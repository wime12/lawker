BEGIN {
    srand(Seed ? Seed : 1) 
    Grammar = Grammar ? Grammar : "grammar"
    while ((getline < Grammar) > 0)
        if ($2 == "->") {
            i = ++lhs[$1]              # count lhs
            rhsprob[$1, i] = $NF       # 0 <= probability <= 1
            rhscnt[$1, i] = NF-3       # how many in rhs
            for (j = 3; j < NF; j++)   # record them
               rhslist[$1, i, j-2] = $j
        } else
            print "illegal production: " $0
    for (sym in lhs)
         for (i = 2; i <= lhs[sym]; i++)
            rhsprob[sym, i] += rhsprob[sym, i-1]
}
{   if ($1 in lhs) {  # nonterminal to expand
         gen($1)
         printf("\n")
     } else 
         print "unknown nonterminal: " $0   
}
function gen(sym,    i, j) {
    if (sym in lhs) {       # a nonterminal
        j = rand()          # random production
        for (i = 1; i <= lhs[sym] && j > rhsprob[sym, i]; i++) ;       
        for (j = 1; j <= rhscnt[sym, i]; j++) # expand rhs's
            gen(rhslist[sym, i, j])
    } else
        printf("%s ", sym)
}
#./PRE