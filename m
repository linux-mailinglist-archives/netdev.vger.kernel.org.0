Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBD261076
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIHLGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:06:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729372AbgIHLGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 07:06:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8649E9B29CFE06F35EC3;
        Tue,  8 Sep 2020 19:06:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 19:06:06 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <john.fastabend@gmail.com>,
        <eric.dumazet@gmail.com>
Subject: [PATCH v2 net] net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc
Date:   Tue, 8 Sep 2020 19:02:34 +0800
Message-ID: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is concurrent reset and enqueue operation for the
same lockless qdisc when there is no lock to synchronize the
q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
qdisc_deactivate() called by dev_deactivate_queue(), which may cause
out-of-bounds access for priv->ring[] in hns3 driver if user has
requested a smaller queue num when __dev_xmit_skb() still enqueue a
skb with a larger queue_mapping after the corresponding qdisc is
reset, and call hns3_nic_net_xmit() with that skb later.

Reused the existing synchronize_net() in dev_deactivate_many() to
make sure skb with larger queue_mapping enqueued to old qdisc(which
is saved in dev_queue->qdisc_sleeping) will always be reset when
dev_reset_queue() is called.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
ChangeLog V2:
	Reuse existing synchronize_net().
---
 net/sched/sch_generic.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d..54c4172 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
 
 static void qdisc_deactivate(struct Qdisc *qdisc)
 {
-	bool nolock = qdisc->flags & TCQ_F_NOLOCK;
-
 	if (qdisc->flags & TCQ_F_BUILTIN)
 		return;
-	if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
-		return;
-
-	if (nolock)
-		spin_lock_bh(&qdisc->seqlock);
-	spin_lock_bh(qdisc_lock(qdisc));
 
 	set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
-
-	qdisc_reset(qdisc);
-
-	spin_unlock_bh(qdisc_lock(qdisc));
-	if (nolock)
-		spin_unlock_bh(&qdisc->seqlock);
 }
 
 static void dev_deactivate_queue(struct net_device *dev,
@@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct net_device *dev,
 	}
 }
 
+static void dev_reset_queue(struct net_device *dev,
+			    struct netdev_queue *dev_queue,
+			    void *_unused)
+{
+	struct Qdisc *qdisc;
+	bool nolock;
+
+	qdisc = dev_queue->qdisc_sleeping;
+	if (!qdisc)
+		return;
+
+	nolock = qdisc->flags & TCQ_F_NOLOCK;
+
+	if (nolock)
+		spin_lock_bh(&qdisc->seqlock);
+	spin_lock_bh(qdisc_lock(qdisc));
+
+	qdisc_reset(qdisc);
+
+	spin_unlock_bh(qdisc_lock(qdisc));
+	if (nolock)
+		spin_unlock_bh(&qdisc->seqlock);
+}
+
 static bool some_qdisc_is_busy(struct net_device *dev)
 {
 	unsigned int i;
@@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head *head)
 		dev_watchdog_down(dev);
 	}
 
-	/* Wait for outstanding qdisc-less dev_queue_xmit calls.
+	/* Wait for outstanding qdisc-less dev_queue_xmit calls or
+	 * outstanding qdisc enqueuing calls.
 	 * This is avoided if all devices are in dismantle phase :
 	 * Caller will call synchronize_net() for us
 	 */
 	synchronize_net();
 
+	list_for_each_entry(dev, head, close_list) {
+		netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
+
+		if (dev_ingress_queue(dev))
+			dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
+	}
+
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, close_list) {
 		while (some_qdisc_is_busy(dev)) {
-- 
2.8.1

