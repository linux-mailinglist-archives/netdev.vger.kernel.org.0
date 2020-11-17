Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E82E2B7088
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKQU6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:58:05 -0500
Received: from mg.ssi.bg ([178.16.128.9]:52828 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgKQU6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:58:05 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id E29BF26F0A;
        Tue, 17 Nov 2020 22:58:02 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 290DC26F05;
        Tue, 17 Nov 2020 22:58:02 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 677863C09C9;
        Tue, 17 Nov 2020 22:57:56 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0AHKvqus026628;
        Tue, 17 Nov 2020 22:57:53 +0200
Date:   Tue, 17 Nov 2020 22:57:52 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Yejune Deng <yejune.deng@gmail.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: replace atomic_add_return()
In-Reply-To: <1605513707-7579-1-git-send-email-yejune.deng@gmail.com>
Message-ID: <9cd77e1e-1c52-d647-9443-485510b4a9b1@ssi.bg>
References: <1605513707-7579-1-git-send-email-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 16 Nov 2020, Yejune Deng wrote:

> atomic_inc_return() looks better
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

	Looks good to me for -next, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 2 +-
>  net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index c0b8215..54e086c 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2137,7 +2137,7 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
>  		pkts = sysctl_sync_threshold(ipvs);
>  	else
> -		pkts = atomic_add_return(1, &cp->in_pkts);
> +		pkts = atomic_inc_return(&cp->in_pkts);
>  
>  	if (ipvs->sync_state & IP_VS_STATE_MASTER)
>  		ip_vs_sync_conn(ipvs, cp, pkts);
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 16b4806..9d43277 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -615,7 +615,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
>  	cp = cp->control;
>  	if (cp) {
>  		if (cp->flags & IP_VS_CONN_F_TEMPLATE)
> -			pkts = atomic_add_return(1, &cp->in_pkts);
> +			pkts = atomic_inc_return(&cp->in_pkts);
>  		else
>  			pkts = sysctl_sync_threshold(ipvs);
>  		ip_vs_sync_conn(ipvs, cp, pkts);
> @@ -776,7 +776,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
>  	if (!cp)
>  		return;
>  	if (cp->flags & IP_VS_CONN_F_TEMPLATE)
> -		pkts = atomic_add_return(1, &cp->in_pkts);
> +		pkts = atomic_inc_return(&cp->in_pkts);
>  	else
>  		pkts = sysctl_sync_threshold(ipvs);
>  	goto sloop;
> -- 
> 1.9.1

Regards

--
Julian Anastasov <ja@ssi.bg>

