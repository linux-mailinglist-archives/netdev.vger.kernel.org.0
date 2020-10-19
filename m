Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7562929B9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgJSOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:48:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:35000 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbgJSOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:48:51 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWSs-0007Rj-Lp; Mon, 19 Oct 2020 16:48:46 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUWSs-0002vz-GT; Mon, 19 Oct 2020 16:48:46 +0200
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3d90f3aa-fc09-983f-0e5d-81e889d03b54@iogearbox.net>
Date:   Mon, 19 Oct 2020 16:48:46 +0200
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
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Based on the discussion in [0], update the bpf_redirect_neigh() helper to
> accept an optional parameter specifying the nexthop information. This makes
> it possible to combine bpf_fib_lookup() and bpf_redirect_neigh() without
> incurring a duplicate FIB lookup - since the FIB lookup helper will return
> the nexthop information even if no neighbour is present, this can simply be
> passed on to bpf_redirect_neigh() if bpf_fib_lookup() returns
> BPF_FIB_LKUP_RET_NO_NEIGH.
> 
> [0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Overall looks good from what I can tell, just small nits below on top of
David's feedback:

[...]
> -static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
> +static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
> +				   struct bpf_nh_params *nh)
>   {
>   	const struct iphdr *ip4h = ip_hdr(skb);
>   	struct net *net = dev_net(dev);
>   	int err, ret = NET_XMIT_DROP;
> -	struct rtable *rt;
> -	struct flowi4 fl4 = {
> -		.flowi4_flags	= FLOWI_FLAG_ANYSRC,
> -		.flowi4_mark	= skb->mark,
> -		.flowi4_tos	= RT_TOS(ip4h->tos),
> -		.flowi4_oif	= dev->ifindex,
> -		.flowi4_proto	= ip4h->protocol,
> -		.daddr		= ip4h->daddr,
> -		.saddr		= ip4h->saddr,
> -	};
>   
> -	rt = ip_route_output_flow(net, &fl4, NULL);
> -	if (IS_ERR(rt))
> -		goto out_drop;
> -	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
> -		ip_rt_put(rt);
> -		goto out_drop;
> -	}
> +	if (!nh->nh_family) {
> +		struct rtable *rt;
> +		struct flowi4 fl4 = {
> +			.flowi4_flags = FLOWI_FLAG_ANYSRC,
> +			.flowi4_mark = skb->mark,
> +			.flowi4_tos = RT_TOS(ip4h->tos),
> +			.flowi4_oif = dev->ifindex,
> +			.flowi4_proto = ip4h->protocol,
> +			.daddr = ip4h->daddr,
> +			.saddr = ip4h->saddr,
> +		};
> +
> +		rt = ip_route_output_flow(net, &fl4, NULL);
> +		if (IS_ERR(rt))
> +			goto out_drop;
> +		if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
> +			ip_rt_put(rt);
> +			goto out_drop;
> +		}
>   
> -	skb_dst_set(skb, &rt->dst);
> +		skb_dst_set(skb, &rt->dst);
> +		nh = NULL;
> +	}
>   
> -	err = bpf_out_neigh_v4(net, skb);
> +	err = bpf_out_neigh_v4(net, skb, dev, nh);
>   	if (unlikely(net_xmit_eval(err)))
>   		dev->stats.tx_errors++;
>   	else
> @@ -2355,7 +2383,8 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
>   }
>   #endif /* CONFIG_INET */
>   
> -static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
> +static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
> +				struct bpf_nh_params *nh)
>   {
>   	struct ethhdr *ethh = eth_hdr(skb);
>   
> @@ -2370,9 +2399,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
>   	skb_reset_network_header(skb);
>   
>   	if (skb->protocol == htons(ETH_P_IP))
> -		return __bpf_redirect_neigh_v4(skb, dev);
> +		return __bpf_redirect_neigh_v4(skb, dev, nh);
>   	else if (skb->protocol == htons(ETH_P_IPV6))
> -		return __bpf_redirect_neigh_v6(skb, dev);
> +		return __bpf_redirect_neigh_v6(skb, dev, nh);
>   out:
>   	kfree_skb(skb);
>   	return -ENOTSUPP;
> @@ -2455,8 +2484,8 @@ int skb_do_redirect(struct sk_buff *skb)
>   		return -EAGAIN;
>   	}
>   	return flags & BPF_F_NEIGH ?
> -	       __bpf_redirect_neigh(skb, dev) :
> -	       __bpf_redirect(skb, dev, flags);
> +		__bpf_redirect_neigh(skb, dev, &ri->nh) :
> +		__bpf_redirect(skb, dev, flags);
>   out_drop:
>   	kfree_skb(skb);
>   	return -EINVAL;
> @@ -2504,16 +2533,23 @@ static const struct bpf_func_proto bpf_redirect_peer_proto = {
>   	.arg2_type      = ARG_ANYTHING,
>   };
>   
> -BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
> +BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
> +	   int, plen, u64, flags)
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>   
> -	if (unlikely(flags))
> +	if (unlikely((plen && plen < sizeof(*params)) || flags))
>   		return TC_ACT_SHOT;
>   
>   	ri->flags = BPF_F_NEIGH;
>   	ri->tgt_index = ifindex;
>   
> +	BUILD_BUG_ON(sizeof(struct bpf_redir_neigh) != sizeof(struct bpf_nh_params));
> +	if (plen)
> +		memcpy(&ri->nh, params, sizeof(ri->nh));
> +	else
> +		ri->nh.nh_family = 0; /* clear previous value */

I'd probably just add an internal flag and do ...

   ri->flags = BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0);

... instead of above clearing, and skb_do_redirect() then becomes:

   __bpf_redirect_neigh(skb, dev, flags & BPF_F_NEXTHOP ? &ri->nh : NULL)

... which would then also avoid this !nh->nh_family check where you later on
set nh = NULL to pass it onwards.

>   	return TC_ACT_REDIRECT;
>   }
>   
