Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B615B3C6BAC
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhGMHtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:49:12 -0400
Received: from relay.sw.ru ([185.231.240.75]:54260 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhGMHtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 03:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=S2QgaeifWpJsHlA3PUAtp1Lof9N7j00FCY/hbO/PGaI=; b=EgJEJb+r09iWh1OBB
        feiEeV/D+REGUFN0DOztEvNG72wKfV0UpVf3bKT8pco0QH6ZlX+r9XVL1QDfPZHpW+aNZ9EaGNpXT
        lwN8egs0Y/8kuj6rm53di01iBhF8KuJYTcecatIxD6XNzsFAdpok2p+qqREnEGH7qnmb0fH235aQE
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3D7Q-003my6-2D; Tue, 13 Jul 2021 10:46:16 +0300
Subject: Re: [PATCH IPV6 v3 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   Vasily Averin <vvs@virtuozzo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626069562.git.vvs@virtuozzo.com>
 <1b1efd52-dd34-2023-021c-c6c6df6fec5f@virtuozzo.com>
Message-ID: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
Date:   Tue, 13 Jul 2021 10:46:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1b1efd52-dd34-2023-021c-c6c6df6fec5f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've found 2 problems in this patch,
and I'm going to resend new patch version soon.

On 7/12/21 9:45 AM, Vasily Averin wrote:
> index ff4f9eb..0efcb9b 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -60,10 +60,38 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>  {
>  	struct dst_entry *dst = skb_dst(skb);
>  	struct net_device *dev = dst->dev;
> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
> +	int delta = hh_len - skb_headroom(skb);
>  	const struct in6_addr *nexthop;
>  	struct neighbour *neigh;
>  	int ret;
>  
> +	/* Be paranoid, rather than too clever. */
> +	if (unlikely(delta > 0) && dev->header_ops) {
> +		/* pskb_expand_head() might crash, if skb is shared */
> +		if (skb_shared(skb)) {
> +			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
> +
> +			if (likely(nskb)) {
> +				if (skb->sk)
> +					skb_set_owner_w(skb, skb->sk);

need to assign sk not to skb but to nskb 

> +				consume_skb(skb);
> +			} else {
> +				kfree_skb(skb);

It is quite strange to call consume_skb() on one case and kfree_skb() in another one.
We know that original skb was shared so we should not call kfree_skb here.

Btw I've noticed similar problem in few other cases:
in pptp_xmit, pvc_xmit, ip_vs_prepare_tunneled_skb
they call consume_skb() in case of success and kfree_skb on error path.
It looks like potential bug for me.

> +			}
> +			skb = nskb;
> +		}
> +		if (skb &&
> +		    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +			kfree_skb(skb);
> +			skb = NULL;
> +		}
> +		if (!skb) {
> +			IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
> +			return -ENOMEM;
> +		}
> +	}
> +
>  	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
>  		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
>  
> 

