Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44223374D2E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhEFB6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:58:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17465 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhEFB6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 21:58:43 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FbGqc5TBczkWpf;
        Thu,  6 May 2021 09:55:08 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 6 May 2021 09:57:38 +0800
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
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>
Subject: [PATCH net v5 3/3] net: sched: fix tx action reschedule issue with stopped queue
Date:   Thu, 6 May 2021 09:57:44 +0800
Message-ID: <1620266264-48109-4-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620266264-48109-1-git-send-email-linyunsheng@huawei.com>
References: <1620266264-48109-1-git-send-email-linyunsheng@huawei.com>
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

As q->enqueue() may return NET_XMIT_DROP when there is no enough
space, running qdisc_run() will likely consume unnecessary cpu, so
avoid calling qdisc_run() when q->enqueue() returns NET_XMIT_DROP
too.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/dev.c          | 4 +++-
 net/sched/sch_generic.c | 8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d596cd7..005bc3e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3853,7 +3853,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 	if (q->flags & TCQ_F_NOLOCK) {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-		qdisc_run(q);
+		if (likely(rc != NET_XMIT_DROP &&
+			   !netif_xmit_frozen_or_stopped(txq)))
+			qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index c32ac5b..2bb829ea 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -74,6 +74,7 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 			}
 		} else {
 			skb = SKB_XOFF_MAGIC;
+			clear_bit(__QDISC_STATE_MISSED, &q->state);
 		}
 	}
 
@@ -242,6 +243,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 			}
 		} else {
 			skb = NULL;
+			clear_bit(__QDISC_STATE_MISSED, &q->state);
 		}
 		if (lock)
 			spin_unlock(lock);
@@ -251,8 +253,10 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	*validate = true;
 
 	if ((q->flags & TCQ_F_ONETXQUEUE) &&
-	    netif_xmit_frozen_or_stopped(txq))
+	    netif_xmit_frozen_or_stopped(txq)) {
+		clear_bit(__QDISC_STATE_MISSED, &q->state);
 		return skb;
+	}
 
 	skb = qdisc_dequeue_skb_bad_txq(q);
 	if (unlikely(skb)) {
@@ -311,6 +315,8 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (!netif_xmit_frozen_or_stopped(txq))
 			skb = dev_hard_start_xmit(skb, dev, txq, &ret);
+		else
+			clear_bit(__QDISC_STATE_MISSED, &q->state);
 
 		HARD_TX_UNLOCK(dev, txq);
 	} else {
-- 
2.7.4

