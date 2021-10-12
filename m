Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7842AE57
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhJLVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:00:20 -0400
Received: from ink.ssi.bg ([178.16.128.7]:42105 "EHLO ink.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235436AbhJLVAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 17:00:17 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2021 17:00:17 EDT
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 7FEF73C09C0;
        Tue, 12 Oct 2021 23:48:53 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 19CKmqbB047141;
        Tue, 12 Oct 2021 23:48:52 +0300
Date:   Tue, 12 Oct 2021 23:48:52 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Antoine Tenart <atenart@kernel.org>
cc:     davem@davemloft.net, kuba@kernel.org, horms@verge.net.au,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net] netfilter: ipvs: make global sysctl readonly in
 non-init netns
In-Reply-To: <20211012145437.754391-1-atenart@kernel.org>
Message-ID: <8e76869d-ae27-198a-e750-16cd26e63737@ssi.bg>
References: <20211012145437.754391-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 12 Oct 2021, Antoine Tenart wrote:

> Because the data pointer of net/ipv4/vs/debug_level is not updated per
> netns, it must be marked as read-only in non-init netns.
> 
> Fixes: c6d2d445d8de ("IPVS: netns, final patch enabling network name space.")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index c25097092a06..29ec3ef63edc 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -4090,6 +4090,11 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
>  	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
>  	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
>  	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
> +#ifdef CONFIG_IP_VS_DEBUG
> +	/* Global sysctls must be ro in non-init netns */
> +	if (!net_eq(net, &init_net))
> +		tbl[idx++].mode = 0444;
> +#endif
>  
>  	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
>  	if (ipvs->sysctl_hdr == NULL) {
> -- 
> 2.31.1

Regards

--
Julian Anastasov <ja@ssi.bg>
