Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2750A16B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbiDUODO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244355AbiDUODO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:03:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F4D6175
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:00:23 -0700 (PDT)
Date:   Thu, 21 Apr 2022 16:00:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650549621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Qgf9REyGtxi7RkAIq+clpuvcLE+rufq3BMywZg45VDc=;
        b=r7gF3J/Pjv3+Wo79ObKsDd2nOey5FU2AdvL0GVXmhgipaN+5Yvo4HFH4/3+6H08wo+/UOE
        +br4LRPjwzWa0dEOLmetkInsh2Fu4sTdta8JkG7ZMJgVukyb9qh3OAeTrYlLwxERRj6VkP
        l3rNfHepD/2LACGrux9ONVSV4b8XGmvdYcT1OqkgpB4GCeDKuHTAy6K+0joCH6IyxhlJ+K
        GMdvrVUptGRWxZSZms8fEhRLIdEU+Ig1RW9LzYquUtJQADdGtaKn0PAMTVerKtWXKuGVi8
        Rzl3/ofBsANHZs0u/WJTN9bIwLqAJmTvxuwIzey/rfP3+mWKYtgYBJd0mlWwzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650549621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Qgf9REyGtxi7RkAIq+clpuvcLE+rufq3BMywZg45VDc=;
        b=KVexsbcMbug/o4aQ2HB45vB/YiXR34Plzwdklbr3p9Q97qkRDxB37npvsb0HvGj6sdBWn4
        hPeY4g3t6JowDkDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <YmFjdOp+R5gVGZ7p@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro dev_core_stats_##FIELD##_inc() disables preemption and invokes
netdev_core_stats_alloc() to return a per-CPU pointer.
netdev_core_stats_alloc() will allocate memory on its first invocation
which breaks on PREEMPT_RT because it requires non-atomic context for
memory allocation.

This can be avoided by enabling preemption in netdev_core_stats_alloc()
assuming the caller always disables preemption.

It might be better to replace local_inc() with this_cpu_inc() now that
dev_core_stats_##FIELD##_inc() gained a preempt-disable section and does
not rely on already disabled preemption. This results in less
instructions on x86-64:
local_inc:
|          incl %gs:__preempt_count(%rip)  # __preempt_count
|          movq    488(%rdi), %rax # _1->core_stats, _22
|          testq   %rax, %rax      # _22
|          je      .L585   #,
|          add %gs:this_cpu_off(%rip), %rax        # this_cpu_off, tcp_ptr__
|  .L586:
|          testq   %rax, %rax      # _27
|          je      .L587   #,
|          incq (%rax)            # _6->a.counter
|  .L587:
|          decl %gs:__preempt_count(%rip)  # __preempt_count

this_cpu_inc(), this patch:
|         movq    488(%rdi), %rax # _1->core_stats, _5
|         testq   %rax, %rax      # _5
|         je      .L591   #,
| .L585:
|         incq %gs:(%rax) # _18->rx_dropped

Use unsigned long as type for the counter. Use this_cpu_inc() to
increment the counter. Use a plain read of the counter.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netdevice.h | 17 +++++++----------
 net/core/dev.c            | 14 +++++---------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf04..0009112b23767 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -199,10 +199,10 @@ struct net_device_stats {
  * Try to fit them in a single cache line, for dev_get_stats() sake.
  */
 struct net_device_core_stats {
-	local_t		rx_dropped;
-	local_t		tx_dropped;
-	local_t		rx_nohandler;
-} __aligned(4 * sizeof(local_t));
+	unsigned long	rx_dropped;
+	unsigned long	tx_dropped;
+	unsigned long	rx_nohandler;
+} __aligned(4 * sizeof(unsigned long));
 
 #include <linux/cache.h>
 #include <linux/skbuff.h>
@@ -3843,7 +3843,7 @@ static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
 	return false;
 }
 
-struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev);
+struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_device *dev);
 
 static inline struct net_device_core_stats *dev_core_stats(struct net_device *dev)
 {
@@ -3851,7 +3851,7 @@ static inline struct net_device_core_stats *dev_core_stats(struct net_device *de
 	struct net_device_core_stats __percpu *p = READ_ONCE(dev->core_stats);
 
 	if (likely(p))
-		return this_cpu_ptr(p);
+		return p;
 
 	return netdev_core_stats_alloc(dev);
 }
@@ -3861,12 +3861,9 @@ static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
 {										\
 	struct net_device_core_stats *p;					\
 										\
-	preempt_disable();							\
 	p = dev_core_stats(dev);						\
-										\
 	if (p)									\
-		local_inc(&p->FIELD);						\
-	preempt_enable();							\
+		this_cpu_inc(p->FIELD);						\
 }
 DEV_CORE_STATS_INC(rx_dropped)
 DEV_CORE_STATS_INC(tx_dropped)
diff --git a/net/core/dev.c b/net/core/dev.c
index 9ec51c1d77cf4..bf6026158874e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10309,7 +10309,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
 
-struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
+struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_device *dev)
 {
 	struct net_device_core_stats __percpu *p;
 
@@ -10320,11 +10320,7 @@ struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
 		free_percpu(p);
 
 	/* This READ_ONCE() pairs with the cmpxchg() above */
-	p = READ_ONCE(dev->core_stats);
-	if (!p)
-		return NULL;
-
-	return this_cpu_ptr(p);
+	return READ_ONCE(dev->core_stats);
 }
 EXPORT_SYMBOL(netdev_core_stats_alloc);
 
@@ -10361,9 +10357,9 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 
 		for_each_possible_cpu(i) {
 			core_stats = per_cpu_ptr(p, i);
-			storage->rx_dropped += local_read(&core_stats->rx_dropped);
-			storage->tx_dropped += local_read(&core_stats->tx_dropped);
-			storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
+			storage->rx_dropped += core_stats->rx_dropped;
+			storage->tx_dropped += core_stats->tx_dropped;
+			storage->rx_nohandler += core_stats->rx_nohandler;
 		}
 	}
 	return storage;
-- 
2.35.2

