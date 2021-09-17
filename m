Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92E40F9A3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbhIQN4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235669AbhIQN4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82034611C3;
        Fri, 17 Sep 2021 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631886911;
        bh=c+1/5v3W6h8KgmWxYsyBGxKIVtsLsWwfXcuinAfdwX0=;
        h=From:To:Cc:Subject:Date:From;
        b=pP4ep/EEJhEDCU7kg2oVkSWjf9bpNP69kg/JLEsxEKm3CGbCg9c/XQoEW3WgPYC72
         Odg879w15XREpXHV6Rn8jRIoWHQAUrLVTALi+kaLl+iwv/o5tZfz4MIRO9GXZ2wbfb
         hDkCcry2Qc/UIKYvmgBHhUfASiDjInE8bjBimDYC41qa9W6Zw3ukNt6JuXtVf6lPKJ
         erFGzS8nvnZs52hdxMMqH4ACLJjaaaPsQIvq9h5nkeNa7/ZqIVgfNKT+na0t5rpHdI
         qhyLXZo4ORON8MpbX3jNSgrVMpqSOK21nruqpyLSLU0sWismVkwctHJfcD/x57ndMs
         YHeL45xmtTwCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH net-next] net: sched: move and reuse mq_change_real_num_tx()
Date:   Fri, 17 Sep 2021 06:55:06 -0700
Message-Id: <20210917135506.1408151-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code for handling active queue changes is identical
between mq and mqprio, reuse it.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sch_generic.h |  2 ++
 net/sched/sch_generic.c   | 24 ++++++++++++++++++++++++
 net/sched/sch_mq.c        | 23 -----------------------
 net/sched/sch_mqprio.c    | 24 +-----------------------
 4 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 8c2d611639fc..5a011f8d394e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1345,6 +1345,8 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
+void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx);
+
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
 
 #endif
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 66d2fbe9ef50..8c64a552a64f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1339,6 +1339,30 @@ void dev_qdisc_change_real_num_tx(struct net_device *dev,
 		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
 }
 
+void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
+{
+#ifdef CONFIG_NET_SCHED
+	struct net_device *dev = qdisc_dev(sch);
+	struct Qdisc *qdisc;
+	unsigned int i;
+
+	for (i = new_real_tx; i < dev->real_num_tx_queues; i++) {
+		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
+		/* Only update the default qdiscs we created,
+		 * qdiscs with handles are always hashed.
+		 */
+		if (qdisc != &noop_qdisc && !qdisc->handle)
+			qdisc_hash_del(qdisc);
+	}
+	for (i = dev->real_num_tx_queues; i < new_real_tx; i++) {
+		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
+		if (qdisc != &noop_qdisc && !qdisc->handle)
+			qdisc_hash_add(qdisc, false);
+	}
+#endif
+}
+EXPORT_SYMBOL(mq_change_real_num_tx);
+
 int dev_qdisc_change_tx_queue_len(struct net_device *dev)
 {
 	bool up = dev->flags & IFF_UP;
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index db18d8a860f9..e04f1a87642b 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -125,29 +125,6 @@ static void mq_attach(struct Qdisc *sch)
 	priv->qdiscs = NULL;
 }
 
-static void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
-{
-#ifdef CONFIG_NET_SCHED
-	struct net_device *dev = qdisc_dev(sch);
-	struct Qdisc *qdisc;
-	unsigned int i;
-
-	for (i = new_real_tx; i < dev->real_num_tx_queues; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
-		/* Only update the default qdiscs we created,
-		 * qdiscs with handles are always hashed.
-		 */
-		if (qdisc != &noop_qdisc && !qdisc->handle)
-			qdisc_hash_del(qdisc);
-	}
-	for (i = dev->real_num_tx_queues; i < new_real_tx; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
-		if (qdisc != &noop_qdisc && !qdisc->handle)
-			qdisc_hash_add(qdisc, false);
-	}
-#endif
-}
-
 static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct net_device *dev = qdisc_dev(sch);
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 7f23a92849d5..0bc10234e306 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -306,28 +306,6 @@ static void mqprio_attach(struct Qdisc *sch)
 	priv->qdiscs = NULL;
 }
 
-static void mqprio_change_real_num_tx(struct Qdisc *sch,
-				      unsigned int new_real_tx)
-{
-	struct net_device *dev = qdisc_dev(sch);
-	struct Qdisc *qdisc;
-	unsigned int i;
-
-	for (i = new_real_tx; i < dev->real_num_tx_queues; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
-		/* Only update the default qdiscs we created,
-		 * qdiscs with handles are always hashed.
-		 */
-		if (qdisc != &noop_qdisc && !qdisc->handle)
-			qdisc_hash_del(qdisc);
-	}
-	for (i = dev->real_num_tx_queues; i < new_real_tx; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
-		if (qdisc != &noop_qdisc && !qdisc->handle)
-			qdisc_hash_add(qdisc, false);
-	}
-}
-
 static struct netdev_queue *mqprio_queue_get(struct Qdisc *sch,
 					     unsigned long cl)
 {
@@ -645,7 +623,7 @@ static struct Qdisc_ops mqprio_qdisc_ops __read_mostly = {
 	.init		= mqprio_init,
 	.destroy	= mqprio_destroy,
 	.attach		= mqprio_attach,
-	.change_real_num_tx = mqprio_change_real_num_tx,
+	.change_real_num_tx = mq_change_real_num_tx,
 	.dump		= mqprio_dump,
 	.owner		= THIS_MODULE,
 };
-- 
2.31.1

