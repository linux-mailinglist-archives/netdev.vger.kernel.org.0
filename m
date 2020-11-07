Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF402AA46D
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 11:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgKGKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 05:33:14 -0500
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:57330 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727801AbgKGKdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 05:33:13 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 66342100E7B43;
        Sat,  7 Nov 2020 10:33:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2565:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7557:8957:8985:9025:10004:10400:10848:11026:11232:11658:11914:12043:12048:12294:12296:12297:12438:12555:12740:12895:13069:13095:13161:13229:13311:13357:13439:13894:14181:14659:14721:14777:21080:21433:21451:21627:21811:21939:30012:30054:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: tooth45_310a6a7272da
X-Filterd-Recvd-Size: 2830
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Sat,  7 Nov 2020 10:33:10 +0000 (UTC)
Message-ID: <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
In-Reply-To: <20201107075550.2244055-1-ndesaulniers@google.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Sat, 07 Nov 2020 02:32:20 -0800
User-Agent: Evolution 3.38.1-1 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> Clang is more aggressive about -Wformat warnings when the format flag
> specifies a type smaller than the parameter. Fixes 8 instances of:
> 
> warning: format specifies type 'unsigned short' but the argument has
> type 'int' [-Wformat]

Likely clang's -Wformat message is still bogus.
Wasn't that going to be fixed?

Integer promotions are already done on these types to int anyway.
Didn't we have this discussion last year?

https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/

Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
of unnecessary %h[xudi] and %hh[xudi]")

The "h" and "hh" things should never be used. The only reason for them
being used if if you have an "int", but you want to print it out as a
"char" (and honestly, that is a really bad reason, you'd be better off
just using a proper cast to make the code more obvious).

So if what you have a "char" (or unsigned char) you should always just
print it out as an "int", knowing that the compiler already did the
proper type conversion.

> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
[]
> @@ -50,38 +50,38 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
>  
> 
>  	switch (l4proto->l4proto) {
>  	case IPPROTO_ICMP:
> -		seq_printf(s, "type=%u code=%u id=%u ",
> +		seq_printf(s, "type=%u code=%u id=%hu ",

etc...


