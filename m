Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9EFBC41
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKMXIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:08:48 -0500
Received: from correo.us.es ([193.147.175.20]:38448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfKMXIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 18:08:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3013DE34D5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 00:08:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 215ADD2B1F
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 00:08:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16D35DA4D0; Thu, 14 Nov 2019 00:08:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F10A621FE5;
        Thu, 14 Nov 2019 00:08:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Nov 2019 00:08:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C9AE142EE38E;
        Thu, 14 Nov 2019 00:08:40 +0100 (CET)
Date:   Thu, 14 Nov 2019 00:08:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Garver <eric@garver.life>
Subject: Re: [nf-next PATCH] net: netfilter: Support iif matches in
 POSTROUTING
Message-ID: <20191113230842.blotm5i3ftz24rml@salvia>
References: <20191112161437.19511-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112161437.19511-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 05:14:37PM +0100, Phil Sutter wrote:
> Instead of generally passing NULL to NF_HOOK_COND() for input device,
> pass skb->dev which contains input device for routed skbs.
> 
> Note that iptables (both legacy and nft) reject rules with input
> interface match from being added to POSTROUTING chains, but nftables
> allows this.

Yes, it allows this but it will not ever match, right? So even if the
rule is loaded, it will be useless.

Do you have a usecase in mind that would benefit from this specifically?

> Cc: Eric Garver <eric@garver.life>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/ipv4/ip_output.c    | 4 ++--
>  net/ipv4/xfrm4_output.c | 2 +-
>  net/ipv6/ip6_output.c   | 4 ++--
>  net/ipv6/xfrm6_output.c | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 3d8baaaf7086d..9d83cb320dcb7 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -422,7 +422,7 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  
>  int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> -	struct net_device *dev = skb_dst(skb)->dev;
> +	struct net_device *dev = skb_dst(skb)->dev, *indev = skb->dev;
>  
>  	IP_UPD_PO_STATS(net, IPSTATS_MIB_OUT, skb->len);
>  
> @@ -430,7 +430,7 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  	skb->protocol = htons(ETH_P_IP);
>  
>  	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
> -			    net, sk, skb, NULL, dev,
> +			    net, sk, skb, indev, dev,
>  			    ip_finish_output,
>  			    !(IPCB(skb)->flags & IPSKB_REROUTED));
>  }
> diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
> index ecff3fce98073..89ba7c87de5df 100644
> --- a/net/ipv4/xfrm4_output.c
> +++ b/net/ipv4/xfrm4_output.c
> @@ -92,7 +92,7 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
>  	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
> -			    net, sk, skb, NULL, skb_dst(skb)->dev,
> +			    net, sk, skb, skb->dev, skb_dst(skb)->dev,
>  			    __xfrm4_output,
>  			    !(IPCB(skb)->flags & IPSKB_REROUTED));
>  }
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 71827b56c0063..945508a7cb0f1 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -160,7 +160,7 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
>  
>  int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> -	struct net_device *dev = skb_dst(skb)->dev;
> +	struct net_device *dev = skb_dst(skb)->dev, *indev = skb->dev;
>  	struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
>  
>  	skb->protocol = htons(ETH_P_IPV6);
> @@ -173,7 +173,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  	}
>  
>  	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> -			    net, sk, skb, NULL, dev,
> +			    net, sk, skb, indev, dev,
>  			    ip6_finish_output,
>  			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
>  }
> diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
> index eecac1b7148e5..fbe51d40bd7e9 100644
> --- a/net/ipv6/xfrm6_output.c
> +++ b/net/ipv6/xfrm6_output.c
> @@ -187,7 +187,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
>  	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> -			    net, sk, skb,  NULL, skb_dst(skb)->dev,
> +			    net, sk, skb,  skb->dev, skb_dst(skb)->dev,
>  			    __xfrm6_output,
>  			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
>  }
> -- 
> 2.24.0
> 
