Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031DB64A311
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiLLOVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiLLOU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:20:58 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C199BEE15;
        Mon, 12 Dec 2022 06:20:56 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 631B542DDD;
        Mon, 12 Dec 2022 16:20:54 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 2B1EC42E56;
        Mon, 12 Dec 2022 16:20:53 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 536733C07CB;
        Mon, 12 Dec 2022 16:20:46 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BCEKf1E041625;
        Mon, 12 Dec 2022 16:20:44 +0200
Date:   Mon, 12 Dec 2022 16:20:41 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Li Qiong <liqiong@nfschina.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH v2] ipvs: add a 'default' case in do_ip_vs_set_ctl()
In-Reply-To: <20221212074351.26440-1-liqiong@nfschina.com>
Message-ID: <c3ca27a-f923-6eb6-bbe4-5e99b65c5940@ssi.bg>
References: <272315c8-5e3b-e8ca-3c7f-68eccd0f2430@nfschina.com> <20221212074351.26440-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 12 Dec 2022, Li Qiong wrote:

> It is better to return the default switch case with
> '-EINVAL', in case new commands are added. otherwise,
> return a uninitialized value of ret.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> Reviewed-by: Simon Horman <horms@verge.net.au>

	Change looks correct to me for -next, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	Still, the comment can explain that this code
is currently unreachable and that some parsers need
the default case to avoid report for uninitialized 'ret'.

> ---
> v2: Add 'default' case instead of initializing 'ret'.
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 988222fff9f0..97f6a1c8933a 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2590,6 +2590,11 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, sockptr_t ptr, unsigned int len)
>  		break;
>  	case IP_VS_SO_SET_DELDEST:
>  		ret = ip_vs_del_dest(svc, &udest);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		ret = -EINVAL;
> +		break;
>  	}
>  
>    out_unlock:
> -- 
> 2.11.0

Regards

--
Julian Anastasov <ja@ssi.bg>

