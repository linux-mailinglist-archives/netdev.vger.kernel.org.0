Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10950E5FD
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiDYQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiDYQmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:42:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF0910A6C7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:39:49 -0700 (PDT)
Date:   Mon, 25 Apr 2022 18:39:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650904787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DJ11l0eZXadVh9iytUFJomjb+I/R3+cDS7S29DBp3mA=;
        b=D1pDlruk5MksQP+pOr9ps9Xbs9GP4G4gjLVqGlfbKyZ2rUviU4JyI6Q+7LZSqxN6k9jDtg
        G8BCdJ4FasA47XA0ltK7I1vGncrmkmdlqrKalveZXeUPsaZf0XTFl+IeHUKqIVr2n5TVcG
        VmOq1Jcb0f/4X9GFcK9A0Y7LB1G3dGagoyQOvSEXoAUl88Id3yMJBHy/dRSq1OSWaA7/9e
        1TFt2pO5W0QGEKFwqN8LQ4fXIInQQS4D8e37ELHDgVnQwiGPXMOZlwCmkQvBkVLnZtqnxF
        zYhRXaUJqEJ69vAOXmQ05f5rMU8VMatalL9NbEBphwRlYbSlnOHQeGZYwU684A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650904787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DJ11l0eZXadVh9iytUFJomjb+I/R3+cDS7S29DBp3mA=;
        b=DEFI13Z75mjdV23yeUFudaKPchiSaPNe/yuG9ByVKNCQqOWHYFsOxAJrWQs0rBZvVHJTkN
        b/t4MhkiPHhURYDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <YmbO0pxgtKpCw4SY@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
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
v1=E2=80=A6v2:
	- Add missing __percpu annotation as noticed by Jakub + robot
	- Use READ_ONCE() in dev_get_stats() to avoid possible split
	  reads, noticed by Eric.

 include/linux/netdevice.h | 21 +++++++++------------
 net/core/dev.c            | 14 +++++---------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf04..b1fbe21650bb5 100644
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
=20
 #include <linux/cache.h>
 #include <linux/skbuff.h>
@@ -3843,15 +3843,15 @@ static __always_inline bool __is_skb_forwardable(co=
nst struct net_device *dev,
 	return false;
 }
=20
-struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *d=
ev);
+struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_=
device *dev);
=20
-static inline struct net_device_core_stats *dev_core_stats(struct net_devi=
ce *dev)
+static inline struct net_device_core_stats __percpu *dev_core_stats(struct=
 net_device *dev)
 {
 	/* This READ_ONCE() pairs with the write in netdev_core_stats_alloc() */
 	struct net_device_core_stats __percpu *p =3D READ_ONCE(dev->core_stats);
=20
 	if (likely(p))
-		return this_cpu_ptr(p);
+		return p;
=20
 	return netdev_core_stats_alloc(dev);
 }
@@ -3859,14 +3859,11 @@ static inline struct net_device_core_stats *dev_cor=
e_stats(struct net_device *de
 #define DEV_CORE_STATS_INC(FIELD)						\
 static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
 {										\
-	struct net_device_core_stats *p;					\
+	struct net_device_core_stats __percpu *p;				\
 										\
-	preempt_disable();							\
 	p =3D dev_core_stats(dev);						\
-										\
 	if (p)									\
-		local_inc(&p->FIELD);						\
-	preempt_enable();							\
+		this_cpu_inc(p->FIELD);						\
 }
 DEV_CORE_STATS_INC(rx_dropped)
 DEV_CORE_STATS_INC(tx_dropped)
diff --git a/net/core/dev.c b/net/core/dev.c
index ae7f42f782e9f..19ef1006f0bf8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10304,7 +10304,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats=
64 *stats64,
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
=20
-struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *d=
ev)
+struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_=
device *dev)
 {
 	struct net_device_core_stats __percpu *p;
=20
@@ -10315,11 +10315,7 @@ struct net_device_core_stats *netdev_core_stats_al=
loc(struct net_device *dev)
 		free_percpu(p);
=20
 	/* This READ_ONCE() pairs with the cmpxchg() above */
-	p =3D READ_ONCE(dev->core_stats);
-	if (!p)
-		return NULL;
-
-	return this_cpu_ptr(p);
+	return READ_ONCE(dev->core_stats);
 }
 EXPORT_SYMBOL(netdev_core_stats_alloc);
=20
@@ -10356,9 +10352,9 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_=
device *dev,
=20
 		for_each_possible_cpu(i) {
 			core_stats =3D per_cpu_ptr(p, i);
-			storage->rx_dropped +=3D local_read(&core_stats->rx_dropped);
-			storage->tx_dropped +=3D local_read(&core_stats->tx_dropped);
-			storage->rx_nohandler +=3D local_read(&core_stats->rx_nohandler);
+			storage->rx_dropped +=3D READ_ONCE(core_stats->rx_dropped);
+			storage->tx_dropped +=3D READ_ONCE(core_stats->tx_dropped);
+			storage->rx_nohandler +=3D READ_ONCE(core_stats->rx_nohandler);
 		}
 	}
 	return storage;
--=20
2.36.0

