Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA62A3C212C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhGIJHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:07:31 -0400
Received: from relay.sw.ru ([185.231.240.75]:59402 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhGIJHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 05:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=VYzyPchZWgfbWBDwBp5XfA7XY/tCeN2GdqrZ3vN/fkU=; b=NokqTyOv8BJF7MCxRZM
        WWWG4aKrxxatkBxrhG/BwUML/TZQ5L7ttoancHznEIO7wLfeHKf3cC7WKgDy8uaNknTatNhZsyb8V
        SwVnvjPdABVZwuf8sOTJzYaJdMOsdUMsgsUZXxzW4l6NPGGBgLBKHBXYuZrEdYqnMjzs4FYRjkY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m1mRB-003Pkm-Ku; Fri, 09 Jul 2021 12:04:45 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH IPV6 v2 1/4] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
 <cover.1625818825.git.vvs@virtuozzo.com>
Message-ID: <4f6a2b28-a137-2e19-bf62-5a8767d0d0ac@virtuozzo.com>
Date:   Fri, 9 Jul 2021 12:04:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1625818825.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When TEE target mirrors traffic to another interface, sk_buff may
not have enough headroom to be processed correctly.
ip_finish_output2() detect this situation for ipv4 and allocates
new skb with enogh headroom. However ipv6 lacks this logic in
ip_finish_output2 and it leads to skb_under_panic:

 skbuff: skb_under_panic: text:ffffffffc0866ad4 len:96 put:24
 head:ffff97be85e31800 data:ffff97be85e317f8 tail:0x58 end:0xc0 dev:gre0
 ------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:110!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 2 PID: 393 Comm: kworker/2:2 Tainted: G           OE     5.13.0 #13
 Hardware name: Virtuozzo KVM, BIOS 1.11.0-2.vz7.4 04/01/2014
 Workqueue: ipv6_addrconf addrconf_dad_work
 RIP: 0010:skb_panic+0x48/0x4a
 Call Trace:
  skb_push.cold.111+0x10/0x10
  ipgre_header+0x24/0xf0 [ip_gre]
  neigh_connected_output+0xae/0xf0
  ip6_finish_output2+0x1a8/0x5a0
  ip6_output+0x5c/0x110
  nf_dup_ipv6+0x158/0x1000 [nf_dup_ipv6]
  tee_tg6+0x2e/0x40 [xt_TEE]
  ip6t_do_table+0x294/0x470 [ip6_tables]
  nf_hook_slow+0x44/0xc0
  nf_hook.constprop.34+0x72/0xe0
  ndisc_send_skb+0x20d/0x2e0
  ndisc_send_ns+0xd1/0x210
  addrconf_dad_work+0x3c8/0x540
  process_one_work+0x1d1/0x370
  worker_thread+0x30/0x390
  kthread+0x116/0x130
  ret_from_fork+0x22/0x30

This patch implement new helper that tries to expand headroom on current skb,
if it is not possible (shared_skb) -- creates new one.

v2 open questions:
- currently helper name skb_expand_head is bad
  and should be changed to better one. Any suggestions?  
- proper location for new helper:
   in net/core/skbuff.c right below skb_realloc_headroom() ?
- is it acceptable to free original skb inside helper ?
  Is it probably required to keep it in caller instead?

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9eb..6c5f85f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -56,14 +56,48 @@
 #include <net/lwtunnel.h>
 #include <net/ip_tunnels.h>
 
+static inline struct sk_buff *skb_expand_head(struct sk_buff *skb, int delta)
+{
+	/* pskb_expand_head() might crash, if skb is shared */
+	if (skb_shared(skb)) {
+		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+		if (likely(nskb)) {
+			if (skb->sk)
+				skb_set_owner_w(skb, skb->sk);
+			consume_skb(skb);
+		} else {
+			kfree_skb(skb);
+		}
+		skb = nskb;
+	}
+	if (skb &&
+	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+		kfree_skb(skb);
+		skb = NULL;
+	}
+	return skb;
+}
+
 static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+	int delta = hh_len - skb_headroom(skb);
 	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
 	int ret;
 
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(delta  > 0) && dev->header_ops)
+		skb = skb_expand_head(skb, delta);
+
+	if (!skb) {
+		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
+		return -ENOMEM;
+	}
+
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
-- 
1.8.3.1

