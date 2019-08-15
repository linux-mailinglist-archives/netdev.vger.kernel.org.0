Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D08E511
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfHOG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 02:56:22 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:46145 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726098AbfHOG4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 02:56:22 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 381FB8368EFC;
        Thu, 15 Aug 2019 06:56:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2559:2563:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7514:8603:8660:8957:9025:9149:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12740:12760:12895:13018:13019:13148:13230:13255:13439:14181:14659:14721:21080:21451:21627:21939:30012:30034:30054:30064:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: shirt04_19e6b128f1714
X-Filterd-Recvd-Size: 3207
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Thu, 15 Aug 2019 06:56:17 +0000 (UTC)
Message-ID: <9973b4a89e54296a6a033c790fc0837397a14a5d.camel@perches.com>
Subject: Re: [PATCH] netfilter: nft_bitwise: Adjust parentheses to fix
 memcmp size argument
From:   Joe Perches <joe@perches.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Date:   Wed, 14 Aug 2019 23:56:16 -0700
In-Reply-To: <20190814165809.46421-1-natechancellor@gmail.com>
References: <20190814165809.46421-1-natechancellor@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-08-14 at 09:58 -0700, Nathan Chancellor wrote:
> clang warns:
> 
> net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
> call is a comparison [-Werror,-Wmemsize-comparison]
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ~~~~~~~~~~~~~~~~~~^~
> net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the
> result of 'memcmp' instead?
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>             ^
>                                                        )
> net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument
> to size_t to silence this warning
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ^
>                                       (size_t)(
> 1 error generated.
> 
> Adjust the parentheses so that the result of the sizeof is used for the
> size argument in memcmp, rather than the result of the comparison (which
> would always be true because sizeof is a non-zero number).
> 
> Fixes: bd8699e9e292 ("netfilter: nft_bitwise: add offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/638
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/netfilter/nft_bitwise.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
[]
> @@ -135,8 +135,8 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
>  {
>  	const struct nft_bitwise *priv = nft_expr_priv(expr);
>  
> -	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
> -	    priv->sreg != priv->dreg))
> +	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
> +	    priv->sreg != priv->dreg)

This code should use memchr_inv and not compare against a
static uninitialized struct.

Perhaps linux should introduce and use memcchr like bsd. 
or just add something like #define memcchr memchr_inv




