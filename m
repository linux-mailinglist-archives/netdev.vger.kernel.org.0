Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4914D4A88BF
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352311AbiBCQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:41:34 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352302AbiBCQlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:41:32 -0500
Date:   Thu, 3 Feb 2022 17:41:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643906491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bYIZBPQJfwNvlKqbK2sBYVP5XkkzJtgJ5VRUIUtkS4o=;
        b=X3QpqMzWkPAZyBShkSPdNaQscxe6zgUyNMk7rjY3Rhitd6o/wad5EnyAVW5K/Oe2vnrxp5
        Nz5nioOeJWEllBHGD4nJjDucntB0unVEElsdju4tS/ju1RWGJ9Y6XRl4pu+mjM1JvLbRWM
        SRPeahesX479zwDtbFneQbiS+tGzUnFZyg5oPXc/IVnvAJASZ0lujE8d6IxgtxvjIVnH97
        JYsrCt0pGJy/XrjS9lvLESrcL/gur5upb8YF1GwA6cJysJmES4hUDpHbpUpOcXRba9XOU4
        cZjn8DQnQMRNWBKVIdJmJTfoheHFs4MXE0NkiXo2m1mCIgtuak0QKx5a9Lj/Tw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643906491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bYIZBPQJfwNvlKqbK2sBYVP5XkkzJtgJ5VRUIUtkS4o=;
        b=S6rPSWy7MY2Nkyr066mQrMoUy3jK+qncvSOKP6GpFHvjBi2WJblLzy5g3k4Pp5549IQArB
        L1HWQWZvYIoyR6CA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next v2 4/4] net: dev: Make rps_lock() disable interrupts.
Message-ID: <YfwFunubdlRK/8IZ@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-5-bigeasy@linutronix.de>
 <20220202084735.126397eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220202084735.126397eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling interrupts and in the RPS case locking input_pkt_queue is
split into local_irq_disable() and optional spin_lock().

This breaks on PREEMPT_RT because the spinlock_t typed lock can not be
acquired with disabled interrupts.
The sections in which the lock is acquired is usually short in a sense that it
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
On 2022-02-02 08:47:35 [-0800], Jakub Kicinski wrote:
> 
> I think you can re-jig this a little more - rps_ipi_queued() only return
> 0 if sd is "local" so maybe we can call __napi_schedule_irqoff()
> instead which already has the if () for PREEMPT_RT?
> 
> Maybe moving the ____napi_schedule() into rps_ipi_queued() and
> renaming it to napi_schedule_backlog() or napi_schedule_rps() 
> would make the code easier to follow in that case?

Something like this then?

 net/core/dev.c | 76 ++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 34 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f43d0580fa11d..18f9941287c2e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -216,18 +216,38 @@ static inline struct hlist_head *dev_index_hash(struct net *net, int ifindex)
 	return &net->dev_index_head[ifindex & (NETDEV_HASHENTRIES - 1)];
 }
 
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
 
 static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
@@ -4456,11 +4476,11 @@ static void rps_trigger_softirq(void *data)
  * If yes, queue it to our IPI list and return 1
  * If no, return 0
  */
-static int rps_ipi_queued(struct softnet_data *sd)
+static int napi_schedule_rps(struct softnet_data *sd)
 {
-#ifdef CONFIG_RPS
 	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
+#ifdef CONFIG_RPS
 	if (sd != mysd) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
@@ -4469,6 +4489,7 @@ static int rps_ipi_queued(struct softnet_data *sd)
 		return 1;
 	}
 #endif /* CONFIG_RPS */
+	__napi_schedule_irqoff(&mysd->backlog);
 	return 0;
 }
 
@@ -4525,9 +4546,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 
 	sd = &per_cpu(softnet_data, cpu);
 
-	local_irq_save(flags);
-
-	rps_lock(sd);
+	rps_lock_irqsave(sd, &flags);
 	if (!netif_running(skb->dev))
 		goto drop;
 	qlen = skb_queue_len(&sd->input_pkt_queue);
@@ -4536,26 +4555,21 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 enqueue:
 			__skb_queue_tail(&sd->input_pkt_queue, skb);
 			input_queue_tail_incr_save(sd, qtail);
-			rps_unlock(sd);
-			local_irq_restore(flags);
+			rps_unlock_irq_restore(sd, &flags);
 			return NET_RX_SUCCESS;
 		}
 
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
 
 drop:
 	sd->dropped++;
-	rps_unlock(sd);
-
-	local_irq_restore(flags);
+	rps_unlock_irq_restore(sd, &flags);
 
 	atomic_long_inc(&skb->dev->rx_dropped);
 	kfree_skb(skb);
@@ -5617,8 +5631,7 @@ static void flush_backlog(struct work_struct *work)
 	local_bh_disable();
 	sd = this_cpu_ptr(&softnet_data);
 
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
@@ -5626,8 +5639,7 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
 
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
 		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
@@ -5645,16 +5657,14 @@ static bool flush_required(int cpu)
 	struct softnet_data *sd = &per_cpu(softnet_data, cpu);
 	bool do_flush;
 
-	local_irq_disable();
-	rps_lock(sd);
+	rps_lock_irq_disable(sd);
 
 	/* as insertion into process_queue happens with the rps lock held,
 	 * process_queue access may race only with dequeue
 	 */
 	do_flush = !skb_queue_empty(&sd->input_pkt_queue) ||
 		   !skb_queue_empty_lockless(&sd->process_queue);
-	rps_unlock(sd);
-	local_irq_enable();
+	rps_unlock_irq_enable(sd);
 
 	return do_flush;
 #endif
@@ -5769,8 +5779,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 
 		}
 
-		local_irq_disable();
-		rps_lock(sd);
+		rps_lock_irq_disable(sd);
 		if (skb_queue_empty(&sd->input_pkt_queue)) {
 			/*
 			 * Inline a custom version of __napi_complete().
@@ -5786,8 +5795,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 			skb_queue_splice_tail_init(&sd->input_pkt_queue,
 						   &sd->process_queue);
 		}
-		rps_unlock(sd);
-		local_irq_enable();
+		rps_unlock_irq_enable(sd);
 	}
 
 	return work;
-- 
2.34.1


