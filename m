Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667211AD60B
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgDQGYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:24:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:31426 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgDQGYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 02:24:08 -0400
IronPort-SDR: 0d/PtWEf/IikgNXNLGsv5umIKbwDP44duDWf/MxINKK72yItyirMDKl0MIh+ZFUvSAe+8+oMjl
 glnWQ2FQXKYA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 23:24:08 -0700
IronPort-SDR: s1OVE8Gab0x5ILCWljlWbNIGmN4O1SlykUkrbTuUi6cxOCBGldpq4lB+f1s3kFuJD29nrjdOVs
 1YH7vYflEVjw==
X-IronPort-AV: E=Sophos;i="5.72,394,1580803200"; 
   d="scan'208";a="428127032"
Received: from mcintra-mobl.ger.corp.intel.com (HELO localhost) ([10.249.44.191])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 23:24:02 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Saeed Mahameed <saeedm@mellanox.com>, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, leon@kernel.org,
        kieran.bingham+renesas@ideasonboard.com, jonas@kwiboo.se,
        airlied@linux.ie, jernej.skrabec@siol.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <20200417011146.83973-1-saeedm@mellanox.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200417011146.83973-1-saeedm@mellanox.com>
Date:   Fri, 17 Apr 2020 09:23:59 +0300
Message-ID: <87v9ly3a0w.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020, Saeed Mahameed <saeedm@mellanox.com> wrote:
> Due to the changes to the semantics of imply keyword [1], which now
> doesn't force any config options to the implied configs any more.
>
> A module (FOO) that has a weak dependency on some other modules (BAR)
> is now broken if it was using imply to force dependency restrictions.
> e.g.: FOO needs BAR to be reachable, especially when FOO=y and BAR=m.
> Which might now introduce build/link errors.
>
> There are two options to solve this:
> 1. use IS_REACHABLE(BAR), everywhere BAR is referenced inside FOO.
> 2. in FOO's Kconfig add: depends on (BAR || !BAR)
>
> The first option is not desirable, and will leave the user confused when
> setting FOO=y and BAR=m, FOO will never reach BAR even though both are
> compiled.
>
> The 2nd one is the preferred approach, and will guarantee BAR is always
> reachable by FOO if both are compiled. But, (BAR || !BAR) is really
> confusing for those who don't really get how kconfig tristate arithmetics
> work.
>
> To solve this and hide this weird expression and to avoid repetition
> across the tree, we introduce new keyword "uses" to the Kconfig options
> family.
>
> uses BAR:
> Equivalent to: depends on symbol || !symbol
> Semantically it means, if FOO is enabled (y/m) and has the option:
> uses BAR, make sure it can reach/use BAR when possible.
>
> For example: if FOO=y and BAR=m, FOO will be forced to m.

Thanks for doing this. I think *something* needs to be done to help
people grasp the "depends on FOO || FOO=n" construct; I've seen many
experienced stumble on this, it's not a rookie mistake.

I suggested "uses" as a keyword, but I'm not hung up on it.

Grepping some Kconfigs a problem I realized with *any* new keyword is
that (FOO || FOO=n) or (FOO || !FOO) is a construct that can be part of
a larger depends on.

For example,

drivers/net/ethernet/broadcom/Kconfig:  depends on PCI && (IPV6 || IPV6=n)

Which means that would have to split up to two. Not ideal, but doable. I
did not find any (FOO || FOO=n) || BAR which would not work with a new
keyword.

An alternative approach that I thought of is adding a lower level
expression to tackle this? "FOO=optional" would expand to (FOO || FOO=n)
anywhere. I have no clue how hard this would be to implement.

For example:

	depends on FOO=optional
=>	
	depends on (FOO || FOO=n)

and:

	depends on FOO=optional || BAR
=>
	depends on (FOO || FOO=n) || BAR


The "optional" keyword is of course open for bikeshedding, but the key
part here I think is that the "depends on" remains, and should be
obvious. And also the =optional ties better to the actual symbol being
depended on.

Thoughts?

BR,
Jani.



>
> [1] https://lore.kernel.org/linux-doc/20200302062340.21453-1-masahiroy@kernel.org/
>
> Link: https://lkml.org/lkml/2020/4/8/839
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: linux-kbuild@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/kbuild/kconfig-language.rst | 10 ++++++++++
>  scripts/kconfig/expr.h                    |  1 +
>  scripts/kconfig/lexer.l                   |  1 +
>  scripts/kconfig/menu.c                    |  4 +++-
>  scripts/kconfig/parser.y                  | 15 +++++++++++++++
>  scripts/kconfig/symbol.c                  |  2 ++
>  6 files changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
> index a1601ec3317b..8db8c2d80794 100644
> --- a/Documentation/kbuild/kconfig-language.rst
> +++ b/Documentation/kbuild/kconfig-language.rst
> @@ -130,6 +130,16 @@ applicable everywhere (see syntax).
>  	bool "foo"
>  	default y
>  
> +- uses dependencies: "uses" <symbol>
> +
> +  Equivalent to: depends on symbol || !symbol
> +  Semantically it means, if FOO is enabled (y/m) and has the option:
> +  uses BAR, make sure it can reach/use BAR when possible.
> +  For example: if FOO=y and BAR=m, FOO will be forced to m.
> +
> +  Note:
> +      To understand how (symbol || !symbol) is actually computed, please see `Menu dependencies`_
> +
>  - reverse dependencies: "select" <symbol> ["if" <expr>]
>  
>    While normal dependencies reduce the upper limit of a symbol (see
> diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
> index 5c3443692f34..face672fb4b4 100644
> --- a/scripts/kconfig/expr.h
> +++ b/scripts/kconfig/expr.h
> @@ -185,6 +185,7 @@ enum prop_type {
>  	P_CHOICE,   /* choice value */
>  	P_SELECT,   /* select BAR */
>  	P_IMPLY,    /* imply BAR */
> +	P_USES,     /* uses BAR */
>  	P_RANGE,    /* range 7..100 (for a symbol) */
>  	P_SYMBOL,   /* where a symbol is defined */
>  };
> diff --git a/scripts/kconfig/lexer.l b/scripts/kconfig/lexer.l
> index 6354c905b006..c6a0017b10d4 100644
> --- a/scripts/kconfig/lexer.l
> +++ b/scripts/kconfig/lexer.l
> @@ -102,6 +102,7 @@ n	[A-Za-z0-9_-]
>  "default"		return T_DEFAULT;
>  "defconfig_list"	return T_DEFCONFIG_LIST;
>  "depends"		return T_DEPENDS;
> +"uses"			return T_USES;
>  "endchoice"		return T_ENDCHOICE;
>  "endif"			return T_ENDIF;
>  "endmenu"		return T_ENDMENU;
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index e436ba44c9c5..e26161b31a11 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -274,7 +274,9 @@ static void sym_check_prop(struct symbol *sym)
>  			break;
>  		case P_SELECT:
>  		case P_IMPLY:
> -			use = prop->type == P_SELECT ? "select" : "imply";
> +		case P_USES:
> +			use = prop->type == P_SELECT ? "select" :
> +				prop->type == P_IMPLY ? "imply" : "uses";
>  			sym2 = prop_get_symbol(prop);
>  			if (sym->type != S_BOOLEAN && sym->type != S_TRISTATE)
>  				prop_warn(prop,
> diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
> index 708b6c4b13ca..c5e9abb49d29 100644
> --- a/scripts/kconfig/parser.y
> +++ b/scripts/kconfig/parser.y
> @@ -57,6 +57,7 @@ static struct menu *current_menu, *current_entry;
>  %token T_DEF_BOOL
>  %token T_DEF_TRISTATE
>  %token T_DEPENDS
> +%token T_USES
>  %token T_ENDCHOICE
>  %token T_ENDIF
>  %token T_ENDMENU
> @@ -169,6 +170,7 @@ config_option_list:
>  	  /* empty */
>  	| config_option_list config_option
>  	| config_option_list depends
> +	| config_option_list uses
>  	| config_option_list help
>  ;
>  
> @@ -261,6 +263,7 @@ choice_option_list:
>  	  /* empty */
>  	| choice_option_list choice_option
>  	| choice_option_list depends
> +	| choice_option_list uses
>  	| choice_option_list help
>  ;
>  
> @@ -360,6 +363,7 @@ menu_option_list:
>  	  /* empty */
>  	| menu_option_list visible
>  	| menu_option_list depends
> +	| menu_option_list uses
>  ;
>  
>  source_stmt: T_SOURCE T_WORD_QUOTE T_EOL
> @@ -384,6 +388,7 @@ comment_stmt: comment comment_option_list
>  comment_option_list:
>  	  /* empty */
>  	| comment_option_list depends
> +	| comment_option_list uses
>  ;
>  
>  /* help option */
> @@ -418,6 +423,16 @@ depends: T_DEPENDS T_ON expr T_EOL
>  	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
>  };
>  
> +/* uses symbol: depends on symbol || !symbol */
> +uses: T_USES symbol T_EOL
> +{
> +	struct expr *symexpr = expr_alloc_symbol($2);
> +
> +	menu_add_dep(expr_alloc_two(E_OR, symexpr, expr_alloc_one(E_NOT, symexpr)));
> +	printd(DEBUG_PARSE, "%s:%d: uses: depends on %s || ! %s\n",
> +	       zconf_curname(), zconf_lineno(), $2->name, $2->name);
> +};
> +
>  /* visibility option */
>  visible: T_VISIBLE if_expr T_EOL
>  {
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index 3dc81397d003..422f7ea47722 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -1295,6 +1295,8 @@ const char *prop_get_type_name(enum prop_type type)
>  		return "choice";
>  	case P_SELECT:
>  		return "select";
> +	case P_USES:
> +		return "uses";
>  	case P_IMPLY:
>  		return "imply";
>  	case P_RANGE:

-- 
Jani Nikula, Intel Open Source Graphics Center
