Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E3033AED0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCOJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:29:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:13928 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCOJ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:29:37 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DzWLC2gCBzlVmw;
        Mon, 15 Mar 2021 17:28:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 17:29:29 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH net-next] net: sched: remove unnecessay lock protection for skb_bad_txq/gso_skb
Date:   Mon, 15 Mar 2021 17:30:10 +0800
Message-ID: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qdisc_lock(q) is taken before enqueuing and dequeuing
for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
also taken, which can provide the same protection as qdisc_lock(q).

This patch removes the unnecessay qdisc_lock(q) protection for
lockless qdisc' skb_bad_txq/gso_skb queue.

And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
besides taking the qdisc_lock(q) when doing the qdisc reset,
some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
when checking qdisc status. It is unnecessary to take both lock
while the fast path only take one lock, so this patch also changes
it to only take qdisc_lock(q) for locked qdisc, and only take
qdisc->seqlock for lockless qdisc.

Since qdisc->seqlock is taken for lockless qdisc when calling
qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
to decide if the lockless qdisc is running.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sch_generic.h |  2 --
 net/sched/sch_generic.c   | 72 +++++++++++++----------------------------------
 2 files changed, 19 insertions(+), 55 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 2d6eb60..0e497ed 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -139,8 +139,6 @@ static inline struct Qdisc *qdisc_refcount_inc_nz(struct Qdisc *qdisc)
 
 static inline bool qdisc_is_running(struct Qdisc *qdisc)
 {
-	if (qdisc->flags & TCQ_F_NOLOCK)
-		return spin_is_locked(&qdisc->seqlock);
 	return (raw_read_seqcount(&qdisc->running) & 1) ? true : false;
 }
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 49eae93..a5f1e3c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -38,7 +38,7 @@ EXPORT_SYMBOL(default_qdisc_ops);
 /* Main transmission queue. */
 
 /* Modifications to data participating in scheduling must be protected with
- * qdisc_lock(qdisc) spinlock.
+ * qdisc_lock(qdisc) or qdisc->seqlock spinlock.
  *
  * The idea is the following:
  * - enqueue, dequeue are serialized via qdisc root lock
@@ -51,14 +51,8 @@ EXPORT_SYMBOL(default_qdisc_ops);
 static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 {
 	const struct netdev_queue *txq = q->dev_queue;
-	spinlock_t *lock = NULL;
 	struct sk_buff *skb;
 
-	if (q->flags & TCQ_F_NOLOCK) {
-		lock = qdisc_lock(q);
-		spin_lock(lock);
-	}
-
 	skb = skb_peek(&q->skb_bad_txq);
 	if (skb) {
 		/* check the reason of requeuing without tx lock first */
@@ -77,9 +71,6 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 		}
 	}
 
-	if (lock)
-		spin_unlock(lock);
-
 	return skb;
 }
 
@@ -96,13 +87,6 @@ static inline struct sk_buff *qdisc_dequeue_skb_bad_txq(struct Qdisc *q)
 static inline void qdisc_enqueue_skb_bad_txq(struct Qdisc *q,
 					     struct sk_buff *skb)
 {
-	spinlock_t *lock = NULL;
-
-	if (q->flags & TCQ_F_NOLOCK) {
-		lock = qdisc_lock(q);
-		spin_lock(lock);
-	}
-
 	__skb_queue_tail(&q->skb_bad_txq, skb);
 
 	if (qdisc_is_percpu_stats(q)) {
@@ -112,20 +96,10 @@ static inline void qdisc_enqueue_skb_bad_txq(struct Qdisc *q,
 		qdisc_qstats_backlog_inc(q, skb);
 		q->q.qlen++;
 	}
-
-	if (lock)
-		spin_unlock(lock);
 }
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
-	spinlock_t *lock = NULL;
-
-	if (q->flags & TCQ_F_NOLOCK) {
-		lock = qdisc_lock(q);
-		spin_lock(lock);
-	}
-
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
@@ -144,8 +118,7 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 
 		skb = next;
 	}
-	if (lock)
-		spin_unlock(lock);
+
 	__netif_schedule(q);
 }
 
@@ -207,24 +180,9 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 
 	*packets = 1;
 	if (unlikely(!skb_queue_empty(&q->gso_skb))) {
-		spinlock_t *lock = NULL;
-
-		if (q->flags & TCQ_F_NOLOCK) {
-			lock = qdisc_lock(q);
-			spin_lock(lock);
-		}
 
 		skb = skb_peek(&q->gso_skb);
 
-		/* skb may be null if another cpu pulls gso_skb off in between
-		 * empty check and lock.
-		 */
-		if (!skb) {
-			if (lock)
-				spin_unlock(lock);
-			goto validate;
-		}
-
 		/* skb in gso_skb were already validated */
 		*validate = false;
 		if (xfrm_offload(skb))
@@ -243,11 +201,10 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 		} else {
 			skb = NULL;
 		}
-		if (lock)
-			spin_unlock(lock);
+
 		goto trace;
 	}
-validate:
+
 	*validate = true;
 
 	if ((q->flags & TCQ_F_ONETXQUEUE) &&
@@ -1153,13 +1110,15 @@ static void dev_reset_queue(struct net_device *dev,
 
 	if (nolock)
 		spin_lock_bh(&qdisc->seqlock);
-	spin_lock_bh(qdisc_lock(qdisc));
+	else
+		spin_lock_bh(qdisc_lock(qdisc));
 
 	qdisc_reset(qdisc);
 
-	spin_unlock_bh(qdisc_lock(qdisc));
 	if (nolock)
 		spin_unlock_bh(&qdisc->seqlock);
+	else
+		spin_unlock_bh(qdisc_lock(qdisc));
 }
 
 static bool some_qdisc_is_busy(struct net_device *dev)
@@ -1168,20 +1127,27 @@ static bool some_qdisc_is_busy(struct net_device *dev)
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *dev_queue;
-		spinlock_t *root_lock;
 		struct Qdisc *q;
+		bool nolock;
 		int val;
 
 		dev_queue = netdev_get_tx_queue(dev, i);
 		q = dev_queue->qdisc_sleeping;
 
-		root_lock = qdisc_lock(q);
-		spin_lock_bh(root_lock);
+		nolock = q->flags & TCQ_F_NOLOCK;
+
+		if (nolock)
+			spin_lock_bh(&q->seqlock);
+		else
+			spin_lock_bh(qdisc_lock(q));
 
 		val = (qdisc_is_running(q) ||
 		       test_bit(__QDISC_STATE_SCHED, &q->state));
 
-		spin_unlock_bh(root_lock);
+		if (nolock)
+			spin_unlock_bh(&q->seqlock);
+		else
+			spin_unlock_bh(qdisc_lock(q));
 
 		if (val)
 			return true;
-- 
2.7.4

