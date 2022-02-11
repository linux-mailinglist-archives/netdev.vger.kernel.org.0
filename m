Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67D24B315E
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354212AbiBKXi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:38:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238960AbiBKXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:38:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C21D44;
        Fri, 11 Feb 2022 15:38:52 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644622730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5G7b2ES7VR2rYyK74LlYYgsniUk9sUCKTTU/CA6Ixx4=;
        b=pyvkdBzkWHNaGnHTMgi03RS0M7/0crQj4Z7lTd1A6CaNV5j+Q/bAncByunooybEXicVCFw
        bi59c7jAkZJpnagrj7e/k5zK+Pu0A98YZf/OuSJtqY50rblG82NxwKR3zbRkMKUYMnOGOQ
        nK0QzBUR8k47QQFwv6ujPBUm+0+MFMJjlTQXY3weqdGuvWFI9G7zmDPxA2uv4NT7I/Mb+P
        zNNQJjRq/pWw9LTnkCE15xQ3tL1JBvt9YlmxcmvRDHJEBrOXEmvBfQbqSniHzquywz+ujx
        VqqeUY6QmYp6mfvV9oEM671qNbLADkY14NoPrUwV4PuAF60567kGtO+68GEX/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644622730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5G7b2ES7VR2rYyK74LlYYgsniUk9sUCKTTU/CA6Ixx4=;
        b=qnDowEU6FueVQFwHkf5sRLvgBqoX444qkvM+8UBs4qAjKGUvbCNB7zWybk44F3ilNPyLXo
        2Mno4evfS08st4Cw==
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
Subject: [PATCH net-next v3 3/3] net: dev: Make rps_lock() disable interrupts.
Date:   Sat, 12 Feb 2022 00:38:39 +0100
Message-Id: <20220211233839.2280731-4-bigeasy@linutronix.de>
In-Reply-To: <20220211233839.2280731-1-bigeasy@linutronix.de>
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 76 ++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 34 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7d90f565e540a..67cc3b455e4af 100644
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
@@ -5638,8 +5652,7 @@ static void flush_backlog(struct work_struct *work)
 	local_bh_disable();
 	sd =3D this_cpu_ptr(&softnet_data);
=20
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
@@ -5647,8 +5660,7 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
=20
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
 		if (skb->dev->reg_state =3D=3D NETREG_UNREGISTERING) {
@@ -5666,16 +5678,14 @@ static bool flush_required(int cpu)
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
@@ -5790,8 +5800,7 @@ static int process_backlog(struct napi_struct *napi, =
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
@@ -5807,8 +5816,7 @@ static int process_backlog(struct napi_struct *napi, =
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

