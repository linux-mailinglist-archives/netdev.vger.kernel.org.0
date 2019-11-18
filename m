Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13001008FF
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKRQQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:16:02 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40134 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfKRQQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 11:16:02 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 270D814007E;
        Mon, 18 Nov 2019 16:15:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 Nov
 2019 16:15:50 +0000
Subject: Re: [PATCH net-next 2/2] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1573893340.git.pabeni@redhat.com>
 <5b7407edd15edaf912214ee62ea3d56d4b4e16b1.1573893340.git.pabeni@redhat.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <2393b7ba-2f58-421d-ef9b-a6ccd3804907@solarflare.com>
Date:   Mon, 18 Nov 2019 16:15:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5b7407edd15edaf912214ee62ea3d56d4b4e16b1.1573893340.git.pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25050.003
X-TM-AS-Result: No-14.817600-8.000000-10
X-TMASE-MatchedRID: TmlY9+XBoTnmLzc6AOD8DfHkpkyUphL9y0Q+dW8+UWTLkl8e9W70i9xw
        X69jh9hhJW1Tjq84Vgr5FoOEUWnZFfiaJZQRpNA+BeUpwRyLLvrM3YWjd+4gDOoYf4aemdWE41e
        hN98IiLcJWjbvKdrGXYbEyZn9ItmZBoKGzYsAhmOlImTUc1ZPYRBJ5KK2zv1kBCzD0Dc8iUu0GC
        +LgyaSccD2+TQ6veAgpT3ohxsBbJIh4UgUH4JX7APZZctd3P4BL1eX+z9B1QxRD5heJnxuK9Ikl
        xunVj5bj37hoGFHM00wf63TOIX9EuNMTcuWvx529u1rQ4BgXPIfVKa359LoE9EsTITobgNEFSxi
        D1T+DkGV8dOKhHa4bccHvwkNmxhvcjlZPhT8y9d32pOm71VVSxfbPFE2GHrVgWrH+UADvgm/PA7
        40bxeADoz2FdR/L9MJSelMBXTs7msf00kb/RIjYS/TV9k6ppAyeUl7aCTy8jzlv7FEwWOy/XBz1
        mm0H5BHxUV8HVnCRR+NZ4lfSsps79ZdlL8eonaVnRXm1iHN1bEQdG7H66TyH4gKq42LRYkggd+E
        KXg69a3h2ihdFir9yd7ND4B+cH/tqGvyPTuNEN+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.817600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25050.003
X-MDID: 1574093761-taUg9zWSbyjF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/11/2019 09:14, Paolo Abeni wrote:
> This is alike the previous change, with some additional ipv4 specific
> quirk. Even when using the route hint we still have to do perform
> additional per packet checks about source address validity: a new
> helper is added to wrap them.
>
> Moreover, the ipv4 route lookup, even in the absence of policy routing,
> may depend on pkts ToS, so we cache that values, too.
>
> Explicitly avoid hints for local broadcast: this simplify the code
> and broadcasts are slower path anyway.
>
> UDP flood performances vs recvmmsg() receiver:
>
> vanilla		patched		delta
> Kpps		Kpps		%
> 1683		1833		+8
>
> In the worst case scenario - each packet has a different
> destination address - the performance delta is within noise
> range.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/route.h | 11 +++++++++++
>  net/ipv4/ip_input.c | 29 ++++++++++++++++++++++++-----
>  net/ipv4/route.c    | 38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/route.h b/include/net/route.h
> index 6c516840380d..f7a8a52318cd 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -185,6 +185,17 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 dst, __be32 src,
>  		       u8 tos, struct net_device *devin,
>  		       struct fib_result *res);
>  
> +struct ip_route_input_hint {
> +	unsigned long	refdst;
> +	__be32		daddr;
> +	char		tos;
Why isn't this a u8?

> +	bool		local;
> +};
> +
> +int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
> +		      u8 tos, struct net_device *devin,
> +		      struct ip_route_input_hint *hint);
> +
>  static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 src,
>  				 u8 tos, struct net_device *devin)
>  {
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 24a95126e698..78fd60bf1c8a 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -305,7 +305,8 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
>  INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
>  INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
>  static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> -			      struct sk_buff *skb, struct net_device *dev)
> +			      struct sk_buff *skb, struct net_device *dev,
> +			      struct ip_route_input_hint *hint)
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
>  	int (*edemux)(struct sk_buff *skb);
> @@ -335,8 +336,12 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  	 *	how the packet travels inside Linux networking.
>  	 */
>  	if (!skb_valid_dst(skb)) {
> -		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
> -					   iph->tos, dev);
> +		if (hint && hint->daddr == iph->daddr && hint->tos == iph->tos)
> +			err = ip_route_use_hint(skb, iph->daddr, iph->saddr,
> +						iph->tos, dev, hint);
> +		else
> +			err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
> +						   iph->tos, dev);
>  		if (unlikely(err))
>  			goto drop_error;
>  	}
> @@ -408,7 +413,7 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
>  	if (!skb)
>  		return NET_RX_SUCCESS;
>  
> -	ret = ip_rcv_finish_core(net, sk, skb, dev);
> +	ret = ip_rcv_finish_core(net, sk, skb, dev, NULL);
>  	if (ret != NET_RX_DROP)
>  		ret = dst_input(skb);
>  	return ret;
> @@ -538,6 +543,7 @@ static void ip_sublist_rcv_finish(struct list_head *head)
>  static void ip_list_rcv_finish(struct net *net, struct sock *sk,
>  			       struct list_head *head)
>  {
> +	struct ip_route_input_hint _hint, *hint = NULL;
>  	struct dst_entry *curr_dst = NULL;
>  	struct sk_buff *skb, *next;
>  	struct list_head sublist;
> @@ -554,11 +560,24 @@ static void ip_list_rcv_finish(struct net *net, struct sock *sk,
>  		skb = l3mdev_ip_rcv(skb);
>  		if (!skb)
>  			continue;
> -		if (ip_rcv_finish_core(net, sk, skb, dev) == NET_RX_DROP)
> +		if (ip_rcv_finish_core(net, sk, skb, dev, hint) == NET_RX_DROP)
>  			continue;
>  
>  		dst = skb_dst(skb);
>  		if (curr_dst != dst) {
> +			struct rtable *rt = (struct rtable *)dst;
> +
> +			if (!net->ipv4.fib_has_custom_rules &&
> +			    rt->rt_type != RTN_BROADCAST) {
> +				_hint.refdst = skb->_skb_refdst;
> +				_hint.daddr = ip_hdr(skb)->daddr;
> +				_hint.tos = ip_hdr(skb)->tos;
> +				_hint.local = rt->rt_type == RTN_LOCAL;
> +				hint = &_hint;
> +			} else {
> +				hint = NULL;
> +			}
Perhaps factor this block out into a function?  Just because it's getting
 deeply indented and giving it a name would make it more obvious what it's
 for.  hint = ipv4_extract_route_hint(skb, &_hint)?

> +
>  			/* dispatch old sublist */
>  			if (!list_empty(&sublist))
>  				ip_sublist_rcv_finish(&sublist);
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index dcc4fa10138d..b0ddff17db80 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2019,6 +2019,44 @@ static int ip_mkroute_input(struct sk_buff *skb,
>  	return __mkroute_input(skb, res, in_dev, daddr, saddr, tos);
>  }
>  
> +/* Implements all the saddr-related checks as ip_route_input_slow(),
> + * assuming daddr is valid and this is not a local broadcast.
> + * Uses the provided hint instead of performing a route lookup.
> + */
> +int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> +		      u8 tos, struct net_device *dev,
> +		      struct ip_route_input_hint *hint)
Mostly I like the idea of these patches, but it bugs me that this seems
 to be reimplementing a little bit, and might get out of sync.  Is it
 possible to factor out the checks from ip_route_input_slow() and just
 call them here?
Otherwise maybe stick something in the comment to ip_route_input_slow()
 reminding to propagate changes to ip_route_use_hint()?

Or perhaps better still would be to come up with a single function that
 always takes a hint, that may be NULL, in which case it performs normal
 routing; and use that in all paths?  (Plumbing the hint through from
 ip_route_input_noref() etc.)

-Ed

> +{
> +	struct in_device *in_dev = __in_dev_get_rcu(dev);
> +	struct net *net = dev_net(dev);
> +	int err = -EINVAL;
> +	u32 itag = 0;
> +
> +	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
> +		goto martian_source;
> +
> +	if (ipv4_is_zeronet(saddr))
> +		goto martian_source;
> +
> +	if (ipv4_is_loopback(saddr) && !IN_DEV_NET_ROUTE_LOCALNET(in_dev, net))
> +		goto martian_source;
> +
> +	if (hint->local) {
> +		err = fib_validate_source(skb, saddr, daddr, tos, 0, dev,
> +					  in_dev, &itag);
> +		if (err < 0)
> +			goto martian_source;
> +	}
> +
> +	err = 0;
> +	__skb_dst_copy(skb, hint->refdst);
> +	return err;
> +
> +martian_source:
> +	ip_handle_martian_source(dev, in_dev, skb, daddr, saddr);
> +	return err;
> +}
> +
>  /*
>   *	NOTE. We drop all the packets that has local source
>   *	addresses, because every properly looped back packet

