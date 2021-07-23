Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C78E3D32A4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhGWDRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhGWDRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B5AC60F38;
        Fri, 23 Jul 2021 03:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012678;
        bh=Z73zC9mi5tV6CVDwT9GE707q/SDbHfKXsCcTwqJI2cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxs+OCVlCU6Mw5YGIB5/OOQJTl1AxqQ0xoG3PsptzdLDkTJEZtu0eS7JbQXoY6l0N
         1Zx7DNDdhCHfGLYGWofsGsOzmn+J2sZWLWVcD7UEG/jZf/SWQkZjHLLxOLYcIvEtD+
         DQ0E6uHRZfGtM/yLJDvVkXHpTRdgQwzlMwSIdYjcRYrU30bkz0zgE5ATAnybsko92m
         FZOFigiOaPfvWdE98aPxtopv8UwZ6du7mKFCdkT3fD45BNIx4DevUry1yBGt8c/sJ0
         kJKxGADkrIkkHWpjth/U7r2Ckm02CPa6sVJl1ei3ZNnWSZSyqJlrRpZE18lwihYqS/
         OLo2AtGFfmNmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/17] ipv6: allocate enough headroom in ip6_finish_output2()
Date:   Thu, 22 Jul 2021 23:57:38 -0400
Message-Id: <20210723035748.531594-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035748.531594-1-sashal@kernel.org>
References: <20210723035748.531594-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 5796015fa968a3349027a27dcd04c71d95c53ba5 ]

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

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 077d43af8226..f16f88ab608c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -60,10 +60,38 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+	int delta = hh_len - skb_headroom(skb);
 	const struct in6_addr *nexthop;
 	struct neighbour *neigh;
 	int ret;
 
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(delta > 0) && dev->header_ops) {
+		/* pskb_expand_head() might crash, if skb is shared */
+		if (skb_shared(skb)) {
+			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+			if (likely(nskb)) {
+				if (skb->sk)
+					skb_set_owner_w(skb, skb->sk);
+				consume_skb(skb);
+			} else {
+				kfree_skb(skb);
+			}
+			skb = nskb;
+		}
+		if (skb &&
+		    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+			kfree_skb(skb);
+			skb = NULL;
+		}
+		if (!skb) {
+			IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
+			return -ENOMEM;
+		}
+	}
+
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
-- 
2.30.2

