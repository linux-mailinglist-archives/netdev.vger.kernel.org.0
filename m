Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BFD3D3465
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhGWFXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:23:07 -0400
Received: from relay.sw.ru ([185.231.240.75]:37122 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhGWFXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=fr+RAdrXYeZQV5eYbCDUwvlXBsDn7zY14pZ+tuJZJZM=; b=UNDm2xCO8IwLBIpmP
        2Dkz0Mp+4weJh5Jga6K975SI7vfeV7iSDz23/5wYv4pXHTgmSLt+/Yg94F8zDQbLW0pw5ZYoydkiV
        Ir4ejpwavHd15LR9TYdsGARMx6zLF4Ie0LK42QRPA6W1ymNsc9t3WU57bheoQXPd0ZTJM/3NjAHpw
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m6oHW-004yU3-Gd; Fri, 23 Jul 2021 09:03:34 +0300
Subject: Re: [PATCH AUTOSEL 5.13 07/19] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210723035721.531372-1-sashal@kernel.org>
 <20210723035721.531372-7-sashal@kernel.org>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <2b57c728-3ef2-aeba-2ff3-ff2555fb6ee3@virtuozzo.com>
Date:   Fri, 23 Jul 2021 09:03:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723035721.531372-7-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch is incomplete, and requires following fixup
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d85a1b31dde84038ea07ad825c3d8d3e71f4344

Please backport it too.

Thank you,
	Vasily Averin

On 7/23/21 6:57 AM, Sasha Levin wrote:
> From: Vasily Averin <vvs@virtuozzo.com>
> 
> [ Upstream commit 5796015fa968a3349027a27dcd04c71d95c53ba5 ]
> 
> When TEE target mirrors traffic to another interface, sk_buff may
> not have enough headroom to be processed correctly.
> ip_finish_output2() detect this situation for ipv4 and allocates
> new skb with enogh headroom. However ipv6 lacks this logic in
> ip_finish_output2 and it leads to skb_under_panic:
> 
>  skbuff: skb_under_panic: text:ffffffffc0866ad4 len:96 put:24
>  head:ffff97be85e31800 data:ffff97be85e317f8 tail:0x58 end:0xc0 dev:gre0
>  ------------[ cut here ]------------
>  kernel BUG at net/core/skbuff.c:110!
>  invalid opcode: 0000 [#1] SMP PTI
>  CPU: 2 PID: 393 Comm: kworker/2:2 Tainted: G           OE     5.13.0 #13
>  Hardware name: Virtuozzo KVM, BIOS 1.11.0-2.vz7.4 04/01/2014
>  Workqueue: ipv6_addrconf addrconf_dad_work
>  RIP: 0010:skb_panic+0x48/0x4a
>  Call Trace:
>   skb_push.cold.111+0x10/0x10
>   ipgre_header+0x24/0xf0 [ip_gre]
>   neigh_connected_output+0xae/0xf0
>   ip6_finish_output2+0x1a8/0x5a0
>   ip6_output+0x5c/0x110
>   nf_dup_ipv6+0x158/0x1000 [nf_dup_ipv6]
>   tee_tg6+0x2e/0x40 [xt_TEE]
>   ip6t_do_table+0x294/0x470 [ip6_tables]
>   nf_hook_slow+0x44/0xc0
>   nf_hook.constprop.34+0x72/0xe0
>   ndisc_send_skb+0x20d/0x2e0
>   ndisc_send_ns+0xd1/0x210
>   addrconf_dad_work+0x3c8/0x540
>   process_one_work+0x1d1/0x370
>   worker_thread+0x30/0x390
>   kthread+0x116/0x130
>   ret_from_fork+0x22/0x30
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index ff4f9ebcf7f6..0efcb9b04151 100644
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
> +				consume_skb(skb);
> +			} else {
> +				kfree_skb(skb);
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

