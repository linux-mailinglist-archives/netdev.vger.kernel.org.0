Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9312637F0D5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 03:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhEMBMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 21:12:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2572 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhEMBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 21:12:23 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgYSc1ybVzsRNF;
        Thu, 13 May 2021 09:08:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 09:10:59 +0800
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
Subject: [PATCH net v7 3/3] net: sched: fix tx action reschedule issue with stopped queue
Date:   Thu, 13 May 2021 09:11:00 +0800
Message-ID: <1620868260-32984-4-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
References: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netdev qeueue might be stopped when byte queue limit has
reached or tx hw ring is full, net_tx_action() may still be
rescheduled endlessly if STATE_MISSED is set, which consumes
a lot of cpu without dequeuing and transmiting any skb because
the netdev queue is stopped, see qdisc_run_end().

This patch fixes it by checking the netdev queue state before
calling qdisc_run() and clearing STATE_MISSED if netdev queue is
stopped during qdisc_run(), the net_tx_action() is recheduled
again when netdev qeueue is restarted, see netif_tx_wake_queue().

As there is time window betewwn netif_xmit_frozen_or_stopped()
checking and STATE_MISSED clearing, between which STATE_MISSED
is set by net_tx_action() scheduled by netif_tx_wake_queue(),
so set the STATE_MISSED again if netdev queue is restarted.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V7: Fix the netif_tx_wake_queue() data race noted by Jakub.
V6: Drop NET_XMIT_DROP checking for it is not really relevant
    to this patch, and it may cause performance performance
    regression with multi pktgen threads on dummy netdev with
    pfifo_fast qdisc case.
---
 net/core/dev.c          |  3 ++-
 net/sched/sch_generic.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d596cd7..ef8cf76 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3853,7 +3853,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 	if (q->flags & TCQ_F_NOLOCK) {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-		qdisc_run(q);
+		if (likely(!netif_xmit_frozen_or_stopped(txq)))
+			qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d86c4cc..b129d9b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -35,6 +35,25 @@
 const struct Qdisc_ops *default_qdisc_ops = &pfifo_fast_ops;
 EXPORT_SYMBOL(default_qdisc_ops);
 
+static void qdisc_maybe_stop_tx(struct Qdisc *q,
+				const struct netdev_queue *txq)
+{
+	clear_bit(__QDISC_STATE_MISSED, &q->state);
+
+	/* Make sure the below netif_xmit_frozen_or_stopped()
+	 * checking happens after clearing STATE_MISSED.
+	 */
+	smp_mb__after_atomic();
+
+	/* Checking netif_xmit_frozen_or_stopped() again to
+	 * make sure STATE_MISSED is set if the STATE_MISSED
+	 * set by netif_tx_wake_queue()'s rescheduling of
+	 * net_tx_action() is cleared by the above clear_bit().
+	 */
+	if (!netif_xmit_frozen_or_stopped(txq))
+		set_bit(__QDISC_STATE_MISSED, &q->state);
+}
+
 /* Main transmission queue. */
 
 /* Modifications to data participating in scheduling must be protected with
@@ -74,6 +93,7 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 			}
 		} else {
 			skb = SKB_XOFF_MAGIC;
+			qdisc_maybe_stop_tx(q, txq);
 		}
 	}
 
@@ -242,6 +262,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 			}
 		} else {
 			skb = NULL;
+			qdisc_maybe_stop_tx(q, txq);
 		}
 		if (lock)
 			spin_unlock(lock);
@@ -251,8 +272,10 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	*validate = true;
 
 	if ((q->flags & TCQ_F_ONETXQUEUE) &&
-	    netif_xmit_frozen_or_stopped(txq))
+	    netif_xmit_frozen_or_stopped(txq)) {
+		qdisc_maybe_stop_tx(q, txq);
 		return skb;
+	}
 
 	skb = qdisc_dequeue_skb_bad_txq(q);
 	if (unlikely(skb)) {
@@ -311,6 +334,8 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (!netif_xmit_frozen_or_stopped(txq))
 			skb = dev_hard_start_xmit(skb, dev, txq, &ret);
+		else
+			qdisc_maybe_stop_tx(q, txq);
 
 		HARD_TX_UNLOCK(dev, txq);
 	} else {
-- 
2.7.4

