Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CD54AC846
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiBGSGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354143AbiBGSF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:05:28 -0500
X-Greylist: delayed 535 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 10:05:27 PST
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07E6CC0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:05:26 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6BFE5601BA;
        Mon,  7 Feb 2022 18:56:26 +0100 (CET)
Date:   Mon, 7 Feb 2022 18:56:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Message-ID: <YgFdS0ak3LIR2waA@salvia>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
> Support GREv0 without NAT.
> 
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> ---
>  net/netfilter/nf_flow_table_core.c    | 10 +++++--
>  net/netfilter/nf_flow_table_ip.c      | 54 ++++++++++++++++++++++++++++-------
>  net/netfilter/nf_flow_table_offload.c | 19 +++++++-----
>  net/netfilter/nft_flow_offload.c      | 13 +++++++++
>  4 files changed, 77 insertions(+), 19 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index b90eca7..e66a375 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -39,8 +39,14 @@
>  
>  	ft->l3proto = ctt->src.l3num;
>  	ft->l4proto = ctt->dst.protonum;
> -	ft->src_port = ctt->src.u.tcp.port;
> -	ft->dst_port = ctt->dst.u.tcp.port;
> +
> +	switch (ctt->dst.protonum) {
> +	case IPPROTO_TCP:
> +	case IPPROTO_UDP:
> +		ft->src_port = ctt->src.u.tcp.port;
> +		ft->dst_port = ctt->dst.u.tcp.port;
> +		break;
> +	}
>  }
>  
>  struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 889cf88..48e2f58 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -172,6 +172,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>  	struct flow_ports *ports;
>  	unsigned int thoff;
>  	struct iphdr *iph;
> +	u8 ipproto;
>
>  	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
>  		return -1;
> @@ -185,13 +186,19 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>  
>  	thoff += offset;
>  
> -	switch (iph->protocol) {
> +	ipproto = iph->protocol;
> +	switch (ipproto) {
>  	case IPPROTO_TCP:
>  		*hdrsize = sizeof(struct tcphdr);
>  		break;
>  	case IPPROTO_UDP:
>  		*hdrsize = sizeof(struct udphdr);
>  		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE:
> +		*hdrsize = sizeof(struct gre_base_hdr);
> +		break;
> +#endif
>  	default:
>  		return -1;
>  	}
> @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>  	if (!pskb_may_pull(skb, thoff + *hdrsize))
>  		return -1;
>  
> +	if (ipproto == IPPROTO_GRE) {

No ifdef here? Maybe remove these ifdef everywhere?

> +		struct gre_base_hdr *greh;
> +
> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
> +			return -1;
> +	}
> +
>  	iph = (struct iphdr *)(skb_network_header(skb) + offset);
> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>  
>  	tuple->src_v4.s_addr	= iph->saddr;
>  	tuple->dst_v4.s_addr	= iph->daddr;
> -	tuple->src_port		= ports->source;
> -	tuple->dst_port		= ports->dest;
> +	if (ipproto == IPPROTO_TCP || ipproto == IPPROTO_UDP) {
> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +		tuple->src_port		= ports->source;
> +		tuple->dst_port		= ports->dest;
> +	}

maybe:

        switch (ipproto) {
        case IPPROTO_TCP:
        case IPPROTO_UDP:
                ...
                break;
        case IPPROTO_GRE:
                break;
        }

?

>  	tuple->l3proto		= AF_INET;
> -	tuple->l4proto		= iph->protocol;
> +	tuple->l4proto		= ipproto;
>  	tuple->iifidx		= dev->ifindex;
>  	nf_flow_tuple_encap(skb, tuple);
>  
> @@ -521,6 +538,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>  	struct flow_ports *ports;
>  	struct ipv6hdr *ip6h;
>  	unsigned int thoff;
> +	u8 nexthdr;
>  
>  	thoff = sizeof(*ip6h) + offset;
>  	if (!pskb_may_pull(skb, thoff))
> @@ -528,13 +546,19 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>  
>  	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
>  
> -	switch (ip6h->nexthdr) {
> +	nexthdr = ip6h->nexthdr;
> +	switch (nexthdr) {
>  	case IPPROTO_TCP:
>  		*hdrsize = sizeof(struct tcphdr);
>  		break;
>  	case IPPROTO_UDP:
>  		*hdrsize = sizeof(struct udphdr);
>  		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE:
> +		*hdrsize = sizeof(struct gre_base_hdr);
> +		break;
> +#endif
>  	default:
>  		return -1;
>  	}
> @@ -545,15 +569,25 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>  	if (!pskb_may_pull(skb, thoff + *hdrsize))
>  		return -1;
>  
> +	if (nexthdr == IPPROTO_GRE) {
> +		struct gre_base_hdr *greh;
> +
> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
> +			return -1;
> +	}
> +
>  	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>  
>  	tuple->src_v6		= ip6h->saddr;
>  	tuple->dst_v6		= ip6h->daddr;
> -	tuple->src_port		= ports->source;
> -	tuple->dst_port		= ports->dest;
> +	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP) {
> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +		tuple->src_port		= ports->source;
> +		tuple->dst_port		= ports->dest;
> +	}
>  	tuple->l3proto		= AF_INET6;
> -	tuple->l4proto		= ip6h->nexthdr;
> +	tuple->l4proto		= nexthdr;
>  	tuple->iifidx		= dev->ifindex;
>  	nf_flow_tuple_encap(skb, tuple);
>  
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index b561e0a..9b81080 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -170,6 +170,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
>  		break;
>  	case IPPROTO_UDP:
> +	case IPPROTO_GRE:
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> @@ -178,15 +179,19 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  	key->basic.ip_proto = tuple->l4proto;
>  	mask->basic.ip_proto = 0xff;
>  
> -	key->tp.src = tuple->src_port;
> -	mask->tp.src = 0xffff;
> -	key->tp.dst = tuple->dst_port;
> -	mask->tp.dst = 0xffff;
> -
>  	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
>  				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
> -				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
> -				      BIT(FLOW_DISSECTOR_KEY_PORTS);
> +				      BIT(FLOW_DISSECTOR_KEY_BASIC);
> +
> +	if (tuple->l4proto == IPPROTO_TCP || tuple->l4proto == IPPROTO_UDP) {
> +		key->tp.src = tuple->src_port;
> +		mask->tp.src = 0xffff;
> +		key->tp.dst = tuple->dst_port;
> +		mask->tp.dst = 0xffff;
> +
> +		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 0af34ad..731b5d8 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  		break;
>  	case IPPROTO_UDP:
>  		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE: {
> +		struct nf_conntrack_tuple *tuple;
> +
> +		if (ct->status & IPS_NAT_MASK)
> +			goto out;

Why this NAT check?

> +		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> +		/* No support for GRE v1 */
> +		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
> +			goto out;
> +		break;
> +	}
> +#endif
>  	default:
>  		goto out;
>  	}
> -- 
> 1.8.3.1
> 
