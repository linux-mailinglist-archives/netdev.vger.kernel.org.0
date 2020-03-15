Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B08185B2E
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgCOI0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 04:26:14 -0400
Received: from ja.ssi.bg ([178.16.129.10]:44374 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727646AbgCOI0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 04:26:14 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Mar 2020 04:26:13 EDT
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 02F8HNco007937;
        Sun, 15 Mar 2020 10:17:23 +0200
Date:   Sun, 15 Mar 2020 10:17:23 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: optimize tunnel dumps for icmp errors
In-Reply-To: <1584253087-8316-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Message-ID: <alpine.LFD.2.21.2003151003190.3987@ja.home.ssi.bg>
References: <1584253087-8316-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sun, 15 Mar 2020, Haishuang Yan wrote:

> After strip GRE/UDP tunnel header for icmp errors, it's better to show
> "ICMP for GRE/UDP" instead of "ICMP for IPIP" in debug message.
> 
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 512259f..f39ae6b 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c

> @@ -1703,8 +1707,8 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  		return NF_ACCEPT; /* The packet looks wrong, ignore */
>  	raddr = (union nf_inet_addr *)&cih->daddr;
>  
> -	/* Special case for errors for IPIP packets */
> -	ipip = false;
> +	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
> +	tunnel = false;

	At this point it is safe to store cih->protocol in some new
var, eg. outer_proto...

> @@ -1809,17 +1813,18 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  			u32 mtu = ntohs(ic->un.frag.mtu);
>  			__be16 frag_off = cih->frag_off;
>  
> -			/* Strip outer IP and ICMP, go to IPIP header */
> +			/* Strip outer IP and ICMP, go to IPIP/UDP/GRE header */
>  			if (pskb_pull(skb, ihl + sizeof(_icmph)) == NULL)
> -				goto ignore_ipip;
> +				goto ignore_tunnel;
>  			offset2 -= ihl + sizeof(_icmph);
>  			skb_reset_network_header(skb);
> -			IP_VS_DBG(12, "ICMP for IPIP %pI4->%pI4: mtu=%u\n",
> -				&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr, mtu);
> +			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
> +				  ip_vs_proto_name(cih->protocol),

	Because here cih points to the embedded UDP/TCP/SCTP IP header, so
we can not see GRE here. Or it is even better if we do not add more code 
to ip_vs_proto_name(), just use char *outer_proto and assign it with 
"IPIP" (where ipip was set) and "UDP"/"GRE" (where ulen was set) and print
outer_proto here.

> +				  &ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr, mtu);

Regards

--
Julian Anastasov <ja@ssi.bg>
