Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4966F38A17E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhETJbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:31:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3442 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbhETJ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:29:21 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fm48P71jDz80xr;
        Thu, 20 May 2021 17:25:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:56 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: [PATCH RFC v4 2/3] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
Date:   Thu, 20 May 2021 17:27:52 +0800
Message-ID: <1621502873-62720-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
References: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
flag set, but queue discipline by-pass does not work for lockless
qdisc because skb is always enqueued to qdisc even when the qdisc
is empty, see __dev_xmit_skb().

This patch calls sch_direct_xmit() to transmit the skb directly
to the driver for empty lockless qdisc, which aviod enqueuing
and dequeuing operation.

As qdisc->empty is not reliable to indicate a empty qdisc because
there is a time window between enqueuing and setting qdisc->empty.
So we use the MISSED state added in commit a90c57f2cedd ("net:
sched: fix packet stuck problem for lockless qdisc"), which
indicate there is lock contention, suggesting that it is better
not to do the qdisc bypass in order to avoid packet out of order
problem.

In order to make MISSED state reliable to indicate a empty qdisc,
we need to ensure that testing and clearing of MISSED state is
within the protection of qdisc->seqlock, only setting MISSED state
can be done without the protection of qdisc->seqlock.

There are below cases that need special handling:
1. When MISSED state is cleared before another round of dequeuing
in pfifo_fast_dequeue(), and __qdisc_run() might not be able to
dequeue all skb in one round and call __netif_schedule(), which
might result in a non-empty qdisc without MISSED set. In order
to avoid this, the MISSED state is set for lockless qdisc and
__netif_schedule() will be called at the end of qdisc_run_end.

2. The MISSED state also need to be set for lockless qdisc instead
of calling __netif_schedule() directly when requeuing a skb for
a similar reason.

3. For netdev queue stopped case, the MISSED case need clearing
while the netdev queue is stopped, otherwise there may be
unnecessary __netif_schedule() calling. So a new DRAINING state
is added to indicate this case, which also indicate a non-empty
qdisc.

4. As there is already netif_xmit_frozen_or_stopped() checking in
dequeue_skb() and sch_direct_xmit(), which are both within the
protection of qdisc->seqlock, but the same checking in
__dev_xmit_skb() is without the protection, which might cause
empty indication of a lockless qdisc to be not reliable. So
remove the checking in __dev_xmit_skb(), and the checking in
the protection of qdisc->seqlock seems enough to avoid the
cpu consumption problem for netdev queue stopped case.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sch_generic.h | 11 ++++++++---
 net/core/dev.c            | 22 ++++++++++++++++++++--
 net/sched/sch_generic.c   | 20 ++++++++++++++++----
 3 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 3ed6bcc..0940ad56 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -37,8 +37,15 @@ enum qdisc_state_t {
 	__QDISC_STATE_SCHED,
 	__QDISC_STATE_DEACTIVATED,
 	__QDISC_STATE_MISSED,
+	__QDISC_STATE_DRAINING,
 };
 
+#define QDISC_STATE_MISSED	BIT(__QDISC_STATE_MISSED)
+#define QDISC_STATE_DRAINING	BIT(__QDISC_STATE_DRAINING)
+
+#define QDISC_STATE_NON_EMPTY	(QDISC_STATE_MISSED | \
+					QDISC_STATE_DRAINING)
+
 struct qdisc_size_table {
 	struct rcu_head		rcu;
 	struct list_head	list;
@@ -206,10 +213,8 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 		spin_unlock(&qdisc->seqlock);
 
 		if (unlikely(test_bit(__QDISC_STATE_MISSED,
-				      &qdisc->state))) {
-			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+				      &qdisc->state)))
 			__netif_schedule(qdisc);
-		}
 	} else {
 		write_seqcount_end(&qdisc->running);
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index ef8cf76..7ae8d8a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3852,10 +3852,28 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
+		if (q->flags & TCQ_F_CAN_BYPASS && qdisc_run_begin(q)) {
+			if (READ_ONCE(q->state) & QDISC_STATE_NON_EMPTY) {
+				rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+				__qdisc_run(q);
+				qdisc_run_end(q);
+
+				goto no_lock_out;
+			}
+
+			qdisc_bstats_cpu_update(q, skb);
+			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
+			    READ_ONCE(q->state) & QDISC_STATE_NON_EMPTY)
+				__qdisc_run(q);
+
+			qdisc_run_end(q);
+			return NET_XMIT_SUCCESS;
+		}
+
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-		if (likely(!netif_xmit_frozen_or_stopped(txq)))
-			qdisc_run(q);
+		qdisc_run(q);
 
+no_lock_out:
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
 		return rc;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index fc8b56b..83d7f5f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -52,6 +52,8 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
 	 */
 	if (!netif_xmit_frozen_or_stopped(txq))
 		set_bit(__QDISC_STATE_MISSED, &q->state);
+	else
+		set_bit(__QDISC_STATE_DRAINING, &q->state);
 }
 
 /* Main transmission queue. */
@@ -164,9 +166,13 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 
 		skb = next;
 	}
-	if (lock)
+
+	if (lock) {
 		spin_unlock(lock);
-	__netif_schedule(q);
+		set_bit(__QDISC_STATE_MISSED, &q->state);
+	} else {
+		__netif_schedule(q);
+	}
 }
 
 static void try_bulk_dequeue_skb(struct Qdisc *q,
@@ -409,7 +415,11 @@ void __qdisc_run(struct Qdisc *q)
 	while (qdisc_restart(q, &packets)) {
 		quota -= packets;
 		if (quota <= 0) {
-			__netif_schedule(q);
+			if (q->flags & TCQ_F_NOLOCK)
+				set_bit(__QDISC_STATE_MISSED, &q->state);
+			else
+				__netif_schedule(q);
+
 			break;
 		}
 	}
@@ -680,13 +690,14 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
 	if (likely(skb)) {
 		qdisc_update_stats_at_dequeue(qdisc, skb);
 	} else if (need_retry &&
-		   test_bit(__QDISC_STATE_MISSED, &qdisc->state)) {
+		   READ_ONCE(qdisc->state) & QDISC_STATE_NON_EMPTY) {
 		/* Delay clearing the STATE_MISSED here to reduce
 		 * the overhead of the second spin_trylock() in
 		 * qdisc_run_begin() and __netif_schedule() calling
 		 * in qdisc_run_end().
 		 */
 		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+		clear_bit(__QDISC_STATE_DRAINING, &qdisc->state);
 
 		/* Make sure dequeuing happens after clearing
 		 * STATE_MISSED.
@@ -1204,6 +1215,7 @@ static void dev_reset_queue(struct net_device *dev,
 	spin_unlock_bh(qdisc_lock(qdisc));
 	if (nolock) {
 		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+		clear_bit(__QDISC_STATE_DRAINING, &qdisc->state);
 		spin_unlock_bh(&qdisc->seqlock);
 	}
 }
-- 
2.7.4

