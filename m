Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D378D2929F0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgJSPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:01:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:36530 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgJSPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:01:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWev-00089g-2C; Mon, 19 Oct 2020 17:01:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWeu-00051W-Ti; Mon, 19 Oct 2020 17:01:12 +0200
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <013e2c8b-13b5-661c-89c5-508b91cd3f4c@iogearbox.net>
Date:   Mon, 19 Oct 2020 17:01:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160277680864.157904.8719768977907736015.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25962/Mon Oct 19 15:57:02 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 5:46 PM, Toke Høiland-Jørgensen wrote:
[...]
> +struct bpf_redir_neigh {
> +	/* network family for lookup (AF_INET, AF_INET6)
> +	 */
> +	__u8	nh_family;
> +	/* network address of nexthop; skips fib lookup to find gateway */
> +	union {
> +		__be32		ipv4_nh;
> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
> +	};
> +};
> +
>   enum bpf_task_fd_type {
>   	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>   	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c5e2a1c5fd8d..d073031a3a61 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2165,12 +2165,11 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>   }
>   
>   #if IS_ENABLED(CONFIG_IPV6)
> -static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
> +static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
> +			    struct net_device *dev, const struct in6_addr *nexthop)
>   {
> -	struct dst_entry *dst = skb_dst(skb);
> -	struct net_device *dev = dst->dev;
>   	u32 hh_len = LL_RESERVED_SPACE(dev);
> -	const struct in6_addr *nexthop;
> +	struct dst_entry *dst = NULL;
>   	struct neighbour *neigh;
>   
>   	if (dev_xmit_recursion()) {
> @@ -2196,8 +2195,11 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
>   	}
>   
>   	rcu_read_lock_bh();
> -	nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
> -			      &ipv6_hdr(skb)->daddr);
> +	if (!nexthop) {
> +		dst = skb_dst(skb);
> +		nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
> +				      &ipv6_hdr(skb)->daddr);
> +	}
>   	neigh = ip_neigh_gw6(dev, nexthop);
>   	if (likely(!IS_ERR(neigh))) {
>   		int ret;
> @@ -2210,36 +2212,46 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
>   		return ret;
>   	}
>   	rcu_read_unlock_bh();
> -	IP6_INC_STATS(dev_net(dst->dev),
> -		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
> +	if (dst)
> +		IP6_INC_STATS(dev_net(dst->dev),
> +			      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
>   out_drop:
>   	kfree_skb(skb);
>   	return -ENETDOWN;
>   }
>   
> -static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
> +static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
> +				   struct bpf_nh_params *nh)
>   {
>   	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	struct in6_addr *nexthop = NULL;
>   	struct net *net = dev_net(dev);
>   	int err, ret = NET_XMIT_DROP;
> -	struct dst_entry *dst;
> -	struct flowi6 fl6 = {
> -		.flowi6_flags	= FLOWI_FLAG_ANYSRC,
> -		.flowi6_mark	= skb->mark,
> -		.flowlabel	= ip6_flowinfo(ip6h),
> -		.flowi6_oif	= dev->ifindex,
> -		.flowi6_proto	= ip6h->nexthdr,
> -		.daddr		= ip6h->daddr,
> -		.saddr		= ip6h->saddr,
> -	};
>   
> -	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
> -	if (IS_ERR(dst))
> -		goto out_drop;
> +	if (!nh->nh_family) {
> +		struct dst_entry *dst;
> +		struct flowi6 fl6 = {
> +			.flowi6_flags = FLOWI_FLAG_ANYSRC,
> +			.flowi6_mark = skb->mark,
> +			.flowlabel = ip6_flowinfo(ip6h),
> +			.flowi6_oif = dev->ifindex,
> +			.flowi6_proto = ip6h->nexthdr,
> +			.daddr = ip6h->daddr,
> +			.saddr = ip6h->saddr,

nit: Would be good for readability to keep the previous whitespace alignment intact.

> +		};
> +
> +		dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
> +		if (IS_ERR(dst))
> +			goto out_drop;
>   
> -	skb_dst_set(skb, dst);
> +		skb_dst_set(skb, dst);
> +	} else if (nh->nh_family == AF_INET6) {
> +		nexthop = &nh->ipv6_nh;
> +	} else {
> +		goto out_drop;
> +	}
>   
> -	err = bpf_out_neigh_v6(net, skb);
> +	err = bpf_out_neigh_v6(net, skb, dev, nexthop);

I'd probably model the bpf_out_neigh_v{4,6}() as close as possible similar to each other in terms
of args we pass etc. In the v6 case you pass the nexthop in6_addr directly whereas v4 passes
bpf_nh_params, I'd probably also stick to the latter for v6 to keep it symmetric.

>   	if (unlikely(net_xmit_eval(err)))
>   		dev->stats.tx_errors++;
>   	else
> @@ -2260,11 +2272,9 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
>   #endif /* CONFIG_IPV6 */
>   
>   #if IS_ENABLED(CONFIG_INET)
> -static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
> +static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
> +			    struct net_device *dev, struct bpf_nh_params *nh)
>   {
> -	struct dst_entry *dst = skb_dst(skb);
> -	struct rtable *rt = container_of(dst, struct rtable, dst);
> -	struct net_device *dev = dst->dev;
>   	u32 hh_len = LL_RESERVED_SPACE(dev);
>   	struct neighbour *neigh;
>   	bool is_v6gw = false;
> @@ -2292,7 +2302,20 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
>   	}
>   
>   	rcu_read_lock_bh();
> -	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
> +	if (!nh) {
> +		struct dst_entry *dst = skb_dst(skb);
> +		struct rtable *rt = container_of(dst, struct rtable, dst);
> +
> +		neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
> +	} else if (nh->nh_family == AF_INET6) {
> +		neigh = ip_neigh_gw6(dev, &nh->ipv6_nh);
> +		is_v6gw = true;
> +	} else if (nh->nh_family == AF_INET) {
> +		neigh = ip_neigh_gw4(dev, nh->ipv4_nh);
> +	} else {
> +		goto out_drop;
> +	}
> +
>   	if (likely(!IS_ERR(neigh))) {
>   		int ret;
>   
