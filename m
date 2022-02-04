Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FF94AA0FA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiBDUNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiBDUNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:13:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174ADC061714;
        Fri,  4 Feb 2022 12:13:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644005592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jqaag4UtemmF1EvQJCtbw7Beuij0/b6toQ+OkCaOsjo=;
        b=NCD6vHnvVcL4P+8+jCpUHsz+pPcaSCrQ82u3tZlhW3ZlqFzy9Ed/nNDXra30U02wJDRhj4
        4zbfZzTe3snu14vx2jEH/XjQoCrU1VGcau8eThj3AjYJaTULEmjFyC9n0VqNFec5IyQwzE
        p5j+vUG6uozUw8IBG29JBvM6HtKLd1imKmJa+VTL1+QpD3H//nX5IqUWoJJpTRcxb+Cdy1
        zKgIaBTZROfJ//1dk3sOoIAdlZceqAixujGhgyrrbH1g/TzgkO6NSk2fOXfGBkitll7cmU
        g5EOgyvGyrT4c94dJjA2IIuVw5nS77iQFgOc/w1lRgvCyMS/LB5UeUGTV+PVzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644005592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jqaag4UtemmF1EvQJCtbw7Beuij0/b6toQ+OkCaOsjo=;
        b=CwhiA92nMXxFsTDFgShb+9B+838X44103S/3WPmIS9FFv/JGPyYus3PphyX1pjomZcx3Ag
        N1JR+KUXPFqM8uDQ==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next v2 3/3] net: dev: Make rps_lock() disable interrupts.
Date:   Fri,  4 Feb 2022 21:12:59 +0100
Message-Id: <20220204201259.1095226-4-bigeasy@linutronix.de>
In-Reply-To: <20220204201259.1095226-1-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
____napi_schedule() is only invoked if sd is from the local CPU. Replace
it with __napi_schedule_irqoff() which already disables interrupts on
PREEMPT_RT as needed. Move this call to rps_ipi_queued() and rename the
function to napi_schedule_rps as suggested by Jakub.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 76 ++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 34 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f34a8f3a448a7..b7578f47e151c 100644
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
@@ -4456,11 +4476,11 @@ static void rps_trigger_softirq(void *data)
  * If yes, queue it to our IPI list and return 1
  * If no, return 0
  */
-static int rps_ipi_queued(struct softnet_data *sd)
+static int napi_schedule_rps(struct softnet_data *sd)
 {
-#ifdef CONFIG_RPS
 	struct softnet_data *mysd =3D this_cpu_ptr(&softnet_data);
=20
+#ifdef CONFIG_RPS
 	if (sd !=3D mysd) {
 		sd->rps_ipi_next =3D mysd->rps_ipi_list;
 		mysd->rps_ipi_list =3D sd;
@@ -4469,6 +4489,7 @@ static int rps_ipi_queued(struct softnet_data *sd)
 		return 1;
 	}
 #endif /* CONFIG_RPS */
+	__napi_schedule_irqoff(&mysd->backlog);
 	return 0;
 }
=20
@@ -4525,9 +4546,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, in=
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
@@ -4536,26 +4555,21 @@ static int enqueue_to_backlog(struct sk_buff *skb, =
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
 		 */
-		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state)) {
-			if (!rps_ipi_queued(sd))
-				____napi_schedule(sd, &sd->backlog);
-		}
+		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state))
+			napi_schedule_rps(sd);
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
@@ -5624,8 +5638,7 @@ static void flush_backlog(struct work_struct *work)
 	local_bh_disable();
 	sd =3D this_cpu_ptr(&softnet_data);
=20
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
@@ -5633,8 +5646,7 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
=20
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
@@ -5652,16 +5664,14 @@ static bool flush_required(int cpu)
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
@@ -5776,8 +5786,7 @@ static int process_backlog(struct napi_struct *napi, =
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
@@ -5793,8 +5802,7 @@ static int process_backlog(struct napi_struct *napi, =
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

