Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208F93CC875
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 12:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhGRKrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 06:47:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:54802 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231836AbhGRKrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 06:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=ImfRd0uL3cPdhN61JfCaXgLBC32zeKuSH0vh7QdatDU=; b=T4EfxypNeQCed1Q8H
        RSIM8CGHCNWsz0u4a9c2GNrxYPygOjW3+edzTMqqG4ug/XWz9tVWsCazk8tiDYh7Nj7/NINw0f0CO
        Y5HSiZi1138hhB3/axFdf00GMtksgRPMu94/ZuX60Ixn/COx5cUbceaAEtPxnFN2fgTH0O3xDkZm0
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m54Hi-004MFx-GN; Sun, 18 Jul 2021 13:44:34 +0300
Subject: Re: [PATCH NET v4 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   Vasily Averin <vvs@virtuozzo.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
 <cover.1626177047.git.vvs@virtuozzo.com>
 <dc51dab2-8434-9f88-d6cd-4e6754383413@virtuozzo.com>
Message-ID: <922a110c-4d20-a1e9-8560-8836d4ddbba1@virtuozzo.com>
Date:   Sun, 18 Jul 2021 13:44:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dc51dab2-8434-9f88-d6cd-4e6754383413@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David,
I've found that you have added v3 version of this patch into netdev-net git.
This version had one mistake: skb_set_owner_w() should set sk not to old skb byt to new nskb.
I've fixed it in v4 version.

Could you please drop bad v3 version and pick up fixed one ?
Should I perhaps submit separate fixup instead?

Thank you,
	Vasily Averin

On 7/13/21 3:01 PM, Vasily Averin wrote:
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
> ---
>  net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index ff4f9eb..25144c7 100644
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
> +					skb_set_owner_w(nskb, skb->sk);
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

