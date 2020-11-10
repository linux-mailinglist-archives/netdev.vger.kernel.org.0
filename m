Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271262AD79E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgKJNfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:35:13 -0500
Received: from correo.us.es ([193.147.175.20]:35748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbgKJNfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 08:35:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0547396266
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0CAEDA7B9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:35:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 95DBDDA78C; Tue, 10 Nov 2020 14:35:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D63ADA730;
        Tue, 10 Nov 2020 14:35:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Nov 2020 14:35:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E4FFF42EF9E0;
        Tue, 10 Nov 2020 14:35:06 +0100 (CET)
Date:   Tue, 10 Nov 2020 14:35:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with async
 Netfilter rules
Message-ID: <20201110133506.GA1777@salvia>
References: <20201106073030.3974927-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106073030.3974927-1-martin@strongswan.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Just a few nitpicks, see below.

On Fri, Nov 06, 2020 at 08:30:30AM +0100, Martin Willi wrote:
> VRF devices use an optimized direct path on output if a default qdisc
> is involved, calling Netfilter hooks directly. This path, however, does
> not consider Netfilter rules completing asynchronously, such as with
> NFQUEUE. The Netfilter okfn() is called for asynchronously accepted
> packets, but the VRF never passes that packet down the stack to send
> it out over the slave device. Using the slower redirect path for this
> seems not feasible, as we do not know beforehand if a Netfilter hook
> has asynchronously completing rules.
> 
> Fix the use of asynchronously completing Netfilter rules in OUTPUT and
> POSTROUTING by using a special completion function that additionally
> calls dst_output() to pass the packet down the stack. Also, slightly
> adjust the use of nf_reset_ct() so that is called in the asynchronous
> case, too.
> 
> Fixes: dcdd43c41e60 ("net: vrf: performance improvements for IPv4")
> Fixes: a9ec54d1b0cd ("net: vrf: performance improvements for IPv6")
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  drivers/net/vrf.c | 92 +++++++++++++++++++++++++++++++++++------------
>  1 file changed, 69 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 60c1aadece89..f2793ffde191 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -608,8 +608,7 @@ static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return ret;
>  }
>  
> -static int vrf_finish_direct(struct net *net, struct sock *sk,
> -			     struct sk_buff *skb)
> +static void vrf_finish_direct(struct sk_buff *skb)
>  {
>  	struct net_device *vrf_dev = skb->dev;
>  
> @@ -628,7 +627,8 @@ static int vrf_finish_direct(struct net *net, struct sock *sk,
>  		skb_pull(skb, ETH_HLEN);
>  	}
>  
> -	return 1;
> +	/* reset skb device */
> +	nf_reset_ct(skb);
>  }
>  
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -707,15 +707,41 @@ static struct sk_buff *vrf_ip6_out_redirect(struct net_device *vrf_dev,
>  	return skb;
>  }
>  
> +static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
> +				     struct sk_buff *skb)
> +{
> +	vrf_finish_direct(skb);
> +
> +	return vrf_ip6_local_out(net, sk, skb);
> +}
> +
>  static int vrf_output6_direct(struct net *net, struct sock *sk,
>  			      struct sk_buff *skb)
>  {
> +	int err = 1;
> +
>  	skb->protocol = htons(ETH_P_IPV6);
>  
> -	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> -			    net, sk, skb, NULL, skb->dev,
> -			    vrf_finish_direct,
> -			    !(IPCB(skb)->flags & IPSKB_REROUTED));
> +	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
> +		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
> +			      NULL, skb->dev, vrf_output6_direct_finish);

I might missing something... this looks very similar to NF_HOOK_COND
but it's open-coded.

My question, could you still use NF_HOOK_COND?

        ret = NF_HOOK_COND(NFPROTO_IPV6, ..., vrf_output6_direct_finish);

just update the okfn.

> +
> +	if (likely(err == 1))

I'd suggest you remove likely() here and elsewhere in this patch.
Just let the branch predictor make its work instead of assuming that
the ruleset accepts traffic.

> +		vrf_finish_direct(skb);
> +
> +	return err;
> +}
> +
> +static int vrf_ip6_out_direct_finish(struct net *net, struct sock *sk,
> +				     struct sk_buff *skb)
> +{
> +	int err;
> +
> +	err = vrf_output6_direct(net, sk, skb);
> +	if (likely(err == 1))
> +		err = vrf_ip6_local_out(net, sk, skb);
> +
> +	return err;
>  }
>  
>  static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
> @@ -728,18 +754,15 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
>  	skb->dev = vrf_dev;
>  
>  	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
> -		      skb, NULL, vrf_dev, vrf_output6_direct);
> +		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
>  
>  	if (likely(err == 1))
>  		err = vrf_output6_direct(net, sk, skb);
>  
> -	/* reset skb device */
>  	if (likely(err == 1))
> -		nf_reset_ct(skb);
> -	else
> -		skb = NULL;
> +		return skb;
>  
> -	return skb;
> +	return NULL;
>  }
>  
>  static struct sk_buff *vrf_ip6_out(struct net_device *vrf_dev,
> @@ -919,15 +942,41 @@ static struct sk_buff *vrf_ip_out_redirect(struct net_device *vrf_dev,
>  	return skb;
>  }
>  
> +static int vrf_output_direct_finish(struct net *net, struct sock *sk,
> +				    struct sk_buff *skb)
> +{
> +	vrf_finish_direct(skb);
> +
> +	return vrf_ip_local_out(net, sk, skb);
> +}
> +
>  static int vrf_output_direct(struct net *net, struct sock *sk,
>  			     struct sk_buff *skb)
>  {
> +	int err = 1;
> +
>  	skb->protocol = htons(ETH_P_IP);
>  
> -	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
> -			    net, sk, skb, NULL, skb->dev,
> -			    vrf_finish_direct,
> -			    !(IPCB(skb)->flags & IPSKB_REROUTED));
> +	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
> +		err = nf_hook(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, sk, skb,
> +			      NULL, skb->dev, vrf_output_direct_finish);
> +
> +	if (likely(err == 1))
> +		vrf_finish_direct(skb);
> +
> +	return err;
> +}
> +
> +static int vrf_ip_out_direct_finish(struct net *net, struct sock *sk,
> +				    struct sk_buff *skb)
> +{
> +	int err;
> +
> +	err = vrf_output_direct(net, sk, skb);
> +	if (likely(err == 1))
> +		err = vrf_ip_local_out(net, sk, skb);
> +
> +	return err;
>  }
>  
>  static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
> @@ -940,18 +989,15 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
>  	skb->dev = vrf_dev;
>  
>  	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
> -		      skb, NULL, vrf_dev, vrf_output_direct);
> +		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
>  
>  	if (likely(err == 1))
>  		err = vrf_output_direct(net, sk, skb);

Could you use NF_HOOK() here instead?

Thanks.
