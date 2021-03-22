Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F14343C4D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCVJJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:09:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14053 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCVJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 05:08:47 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3pWp2nqgzNnNp;
        Mon, 22 Mar 2021 17:06:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 17:08:39 +0800
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
        <a.fatoum@pengutronix.de>
Subject: [RFC v3] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
Date:   Mon, 22 Mar 2021 17:09:16 +0800
Message-ID: <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
flag set, but queue discipline by-pass does not work for lockless
qdisc because skb is always enqueued to qdisc even when the qdisc
is empty, see __dev_xmit_skb().

This patch calls sch_direct_xmit() to transmit the skb directly
to the driver for empty lockless qdisc too, which aviod enqueuing
and dequeuing operation. qdisc->empty is set to false whenever a
skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
skb dequeuing return NULL, see pfifo_fast_dequeue().

There is a data race between enqueue/dequeue and qdisc->empty
setting, qdisc->empty is only used as a hint, so we need to call
sch_may_need_requeuing() to see if the queue is really empty and if
there is requeued skb, which has higher priority than the current
skb.

The performance for ip_forward test increases about 10% with this
patch.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
Hi, Vladimir and Ahmad
	Please give it a test to see if there is any out of order
packet for this patch, which has removed the priv->lock added in
RFC v2.

There is a data race as below:

      CPU1                                   CPU2
qdisc_run_begin(q)                            .
        .                                q->enqueue()
sch_may_need_requeuing()                      .
    return true                               .
        .                                     .
        .                                     .
    q->enqueue()                              .

When above happen, the skb enqueued by CPU1 is dequeued after the
skb enqueued by CPU2 because sch_may_need_requeuing() return true.
If there is not qdisc bypass, the CPU1 has better chance to queue
the skb quicker than CPU2.

This patch does not take care of the above data race, because I
view this as similar as below:

Even at the same time CPU1 and CPU2 write the skb to two socket
which both heading to the same qdisc, there is no guarantee that
which skb will hit the qdisc first, becuase there is a lot of
factor like interrupt/softirq/cache miss/scheduling afffecting
that.

So I hope the above data race will not cause problem for Vladimir
and Ahmad.
---
 include/net/pkt_sched.h   |  1 +
 include/net/sch_generic.h |  1 -
 net/core/dev.c            | 22 ++++++++++++++++++++++
 net/sched/sch_generic.c   | 11 +++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index f5c1bee..5715ddf 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -122,6 +122,7 @@ void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
 bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		     struct net_device *dev, struct netdev_queue *txq,
 		     spinlock_t *root_lock, bool validate);
+bool sch_may_need_requeuing(struct Qdisc *q);
 
 void __qdisc_run(struct Qdisc *q);
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f7a6e14..e08cc77 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -161,7 +161,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
-		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index be941ed..317180a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3796,9 +3796,31 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
+		if (q->flags & TCQ_F_CAN_BYPASS && READ_ONCE(q->empty) &&
+		    qdisc_run_begin(q)) {
+			if (sch_may_need_requeuing(q)) {
+				rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+				__qdisc_run(q);
+				qdisc_run_end(q);
+
+				goto no_lock_out;
+			}
+
+			qdisc_bstats_cpu_update(q, skb);
+
+			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
+			    !READ_ONCE(q->empty))
+				__qdisc_run(q);
+
+			qdisc_run_end(q);
+			return NET_XMIT_SUCCESS;
+		}
+
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		WRITE_ONCE(q->empty, false);
 		qdisc_run(q);
 
+no_lock_out:
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
 		return rc;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea..2145fdad 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -146,6 +146,8 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 	}
 	if (lock)
 		spin_unlock(lock);
+
+	WRITE_ONCE(q->empty, false);
 	__netif_schedule(q);
 }
 
@@ -273,6 +275,15 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	return skb;
 }
 
+bool sch_may_need_requeuing(struct Qdisc *q)
+{
+	if (likely(skb_queue_empty(&q->gso_skb) &&
+		   !q->ops->peek(q)))
+		return false;
+
+	return true;
+}
+
 /*
  * Transmit possibly several skbs, and handle the return status as
  * required. Owning running seqcount bit guarantees that
-- 
2.7.4

