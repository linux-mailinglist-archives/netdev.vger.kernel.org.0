Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E979F4A70C7
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiBBM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:28:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46540 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiBBM24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:28:56 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643804935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gaE2CnG9k+LQIe/sH7m2AqTnxKkca6kKPvnnhRPdxM=;
        b=bYeYj6+w1Ct/bV2eTxYhNSovUyZ+ayN2RRd1RIarP9MFtEftJJnMMlCFyOO9Paagv34K6k
        XR/lhf6oro1Ph0+qRYFwfKZnAL9zj3aXXYdEgAbOMs9rbqv8PQcAmyLn+gj6Z9R4akqNCB
        LV8uweL4En0cl41PsMlbO7+tlQqKC7TBNpWOkfRmngeNNflHoxkeIaQSN3q2MdbRUkZOYm
        efe+bRxRppKxjBYSCIDKt7hmhvUaBN2srq4xMdhEgpCk9ZJISloxMf1XyLWG5vMbkSI5SD
        6JX3nJThkCR2EK181CTcfZ/F78X9n3DNegcgIt6UwR2X84AI1XP8ngzP/DJF5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643804935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gaE2CnG9k+LQIe/sH7m2AqTnxKkca6kKPvnnhRPdxM=;
        b=+tXhZooXTRVTAjLmkAbTv9Ws669/LWZMNyqfUdsHNFh84X9t0IvoXngzfHR9SvSPIiV7Ge
        2U+ApwRXbBRvMLAA==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/4] net: dev: Make rps_lock() disable interrupts.
Date:   Wed,  2 Feb 2022 13:28:48 +0100
Message-Id: <20220202122848.647635-5-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-1-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling interrupts and in the RPS case locking input_pkt_queue is
split into local_irq_disable() and optional spin_lock().

This breaks on PREEMPT_RT because the spinlock_t typed lock can not be
acquired with disabled interrupts.
The sections in which the lock is acquired is usually short in a sense that=
 it
is not causing long und unbounded latiencies. One exception is the
skb_flow_limit() invocation which may invoke a BPF program (and may
require sleeping locks).

By moving local_irq_disable() + spin_lock() into rps_lock(), we can keep
interrupts disabled on !PREEMPT_RT and enabled on PREEMPT_RT kernels.
Without RPS on a PREEMPT_RT kernel, the needed synchronisation happens
as part of local_bh_disable() on the local CPU.
Since interrupts remain enabled, enqueue_to_backlog() needs to disable
interrupts for ____napi_schedule().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 72 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f43d0580fa11d..e9ea56daee2f0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -216,18 +216,38 @@ static inline struct hlist_head *dev_index_hash(struc=
t net *net, int ifindex)
 	return &net->dev_index_head[ifindex & (NETDEV_HASHENTRIES - 1)];
 }
=20
-static inline void rps_lock(struct softnet_data *sd)
+static inline void rps_lock_irqsave(struct softnet_data *sd,
+				    unsigned long *flags)
 {
-#ifdef CONFIG_RPS
-	spin_lock(&sd->input_pkt_queue.lock);
-#endif
+	if (IS_ENABLED(CONFIG_RPS))
+		spin_lock_irqsave(&sd->input_pkt_queue.lock, *flags);
+	else if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_save(*flags);
 }
=20
-static inline void rps_unlock(struct softnet_data *sd)
+static inline void rps_lock_irq_disable(struct softnet_data *sd)
 {
-#ifdef CONFIG_RPS
-	spin_unlock(&sd->input_pkt_queue.lock);
-#endif
+	if (IS_ENABLED(CONFIG_RPS))
+		spin_lock_irq(&sd->input_pkt_queue.lock);
+	else if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_disable();
+}
+
+static inline void rps_unlock_irq_restore(struct softnet_data *sd,
+					  unsigned long *flags)
+{
+	if (IS_ENABLED(CONFIG_RPS))
+		spin_unlock_irqrestore(&sd->input_pkt_queue.lock, *flags);
+	else if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_restore(*flags);
+}
+
+static inline void rps_unlock_irq_enable(struct softnet_data *sd)
+{
+	if (IS_ENABLED(CONFIG_RPS))
+		spin_unlock_irq(&sd->input_pkt_queue.lock);
+	else if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_enable();
 }
=20
 static struct netdev_name_node *netdev_name_node_alloc(struct net_device *=
dev,
@@ -4525,9 +4545,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, in=
t cpu,
=20
 	sd =3D &per_cpu(softnet_data, cpu);
=20
-	local_irq_save(flags);
-
-	rps_lock(sd);
+	rps_lock_irqsave(sd, &flags);
 	if (!netif_running(skb->dev))
 		goto drop;
 	qlen =3D skb_queue_len(&sd->input_pkt_queue);
@@ -4536,26 +4554,30 @@ static int enqueue_to_backlog(struct sk_buff *skb, =
int cpu,
 enqueue:
 			__skb_queue_tail(&sd->input_pkt_queue, skb);
 			input_queue_tail_incr_save(sd, qtail);
-			rps_unlock(sd);
-			local_irq_restore(flags);
+			rps_unlock_irq_restore(sd, &flags);
 			return NET_RX_SUCCESS;
 		}
=20
 		/* Schedule NAPI for backlog device
 		 * We can use non atomic operation since we own the queue lock
+		 * PREEMPT_RT needs to disable interrupts here for
+		 * synchronisation needed in napi_schedule.
 		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_disable();
+
 		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state)) {
 			if (!rps_ipi_queued(sd))
 				____napi_schedule(sd, &sd->backlog);
 		}
+		if (IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_enable();
 		goto enqueue;
 	}
=20
 drop:
 	sd->dropped++;
-	rps_unlock(sd);
-
-	local_irq_restore(flags);
+	rps_unlock_irq_restore(sd, &flags);
=20
 	atomic_long_inc(&skb->dev->rx_dropped);
 	kfree_skb(skb);
@@ -5617,8 +5639,7 @@ static void flush_backlog(struct work_struct *work)
 	local_bh_disable();
 	sd =3D this_cpu_ptr(&softnet_data);
=20
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
@@ -5626,8 +5647,7 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
=20
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
@@ -5645,16 +5665,14 @@ static bool flush_required(int cpu)
 	struct softnet_data *sd =3D &per_cpu(softnet_data, cpu);
 	bool do_flush;
=20
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
=20
 	/* as insertion into process_queue happens with the rps lock held,
 	 * process_queue access may race only with dequeue
 	 */
 	do_flush =3D !skb_queue_empty(&sd->input_pkt_queue) ||
 		   !skb_queue_empty_lockless(&sd->process_queue);
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
=20
 	return do_flush;
 #endif
@@ -5769,8 +5787,7 @@ static int process_backlog(struct napi_struct *napi, =
int quota)
=20
 		}
=20
-		local_irq_disable();
-		rps_lock(sd);
+		rps_lock_irq_disable(sd);
 		if (skb_queue_empty(&sd->input_pkt_queue)) {
 			/*
 			 * Inline a custom version of __napi_complete().
@@ -5786,8 +5803,7 @@ static int process_backlog(struct napi_struct *napi, =
int quota)
 			skb_queue_splice_tail_init(&sd->input_pkt_queue,
 						   &sd->process_queue);
 		}
-		rps_unlock(sd);
-		local_irq_enable();
+		rps_unlock_irq_enable(sd);
 	}
=20
 	return work;
--=20
2.34.1

