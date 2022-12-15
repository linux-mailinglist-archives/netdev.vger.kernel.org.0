Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF664E179
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiLOTCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLOTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:02:11 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2386717044;
        Thu, 15 Dec 2022 11:02:09 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 0F1F821905;
        Thu, 15 Dec 2022 21:02:09 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id B529E21904;
        Thu, 15 Dec 2022 21:02:07 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 795763C043D;
        Thu, 15 Dec 2022 21:02:02 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BFJ1xvf099033;
        Thu, 15 Dec 2022 21:01:59 +0200
Date:   Thu, 15 Dec 2022 21:01:59 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     Simon Horman <horms@verge.net.au>, Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Wiesner <jwiesner@suse.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: use div_s64 for signed division
In-Reply-To: <20221215170324.2579685-1-arnd@kernel.org>
Message-ID: <e1fea67-7425-f13d-e5bd-3d80d9a8afb8@ssi.bg>
References: <20221215170324.2579685-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 15 Dec 2022, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> do_div() is only well-behaved for positive numbers, and now warns
> when the first argument is a an s64:
> 
> net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
> include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>   222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>       |                                   ^~
> net/netfilter/ipvs/ip_vs_est.c:694:17: note: in expansion of macro 'do_div'
>   694 |                 do_div(val, loops);

	net-next already contains fix for this warning
and changes val to u64.

> Convert to using the more appropriate div_s64(), which also
> simplifies the code a bit.
> 
> Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/netfilter/ipvs/ip_vs_est.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
> index ce2a1549b304..dbc32f8cf1f9 100644
> --- a/net/netfilter/ipvs/ip_vs_est.c
> +++ b/net/netfilter/ipvs/ip_vs_est.c
> @@ -691,15 +691,13 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
>  		}
>  		if (diff >= NSEC_PER_SEC)
>  			continue;
> -		val = diff;
> -		do_div(val, loops);
> +		val = div_s64(diff, loops);

	On CONFIG_X86_32 both versions execute single divl
for our case but div_s64 is not inlined. I'm not expert in
this area but if you think div_u64 is more appropriate then
post another patch. Note that now val is u64 and
min_est is still s32 (can be u32).

>  		if (!min_est || val < min_est) {
>  			min_est = val;
>  			/* goal: 95usec per chain */
>  			val = 95 * NSEC_PER_USEC;
>  			if (val >= min_est) {
> -				do_div(val, min_est);
> -				max = (int)val;
> +				max = div_s64(val, min_est);
>  			} else {
>  				max = 1;
>  			}
> -- 
> 2.35.1

Regards

--
Julian Anastasov <ja@ssi.bg>

