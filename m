Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330D2405FE0
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348393AbhIIXL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhIIXL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 19:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC4861179;
        Thu,  9 Sep 2021 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229016;
        bh=1/Cg6Bp3ne7Aah10UDF17H+8C9tDJIJN+eWX1zBlGeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2yIPqzBj6HyxQcy7rEPba8g2LcUOrwGO+IovWL0W8QhIGv3k7EPPR6EHRme7MxO9
         vQFaod0BeGHNtA9rzeMBU+Ux8YUKGEnoQsotpj8qz0QM5/G/nEIsSSWFztSHRwDzfh
         88SBt3lnvDMVu6RhLsxDRms6alQVOcO5bvmD1FhRGyu68fuR+MqlXuviBPPpYerz3Y
         eJ5t1VDbI+fEwpqVJH56F2sOAQiSCWfyG8XG8HNbK4wJyIR2MUXIZlnR6zjU0wfpzX
         0w3aG2fMi4S4DNQjmAhJB9uy5N2/HJxvjFQckZX2qKVXRBBX1Hh+cqhTk2U01ycNwn
         RdOYib4nEvnlw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Massey <matthewmassey@fb.com>
Subject: [PATCH net 1/3] net: sched: update default qdisc visibility after Tx queue cnt changes
Date:   Thu,  9 Sep 2021 16:10:02 -0700
Message-Id: <20210909231004.196905-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909231004.196905-1-kuba@kernel.org>
References: <20210909231004.196905-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mq / mqprio make the default child qdiscs visible. They only do
so for the qdiscs which are within real_num_tx_queues when the
device is registered. Depending on order of calls in the driver,
or if user space changes config via ethtool -L the number of
qdiscs visible under tc qdisc show will differ from the number
of queues. This is confusing to users and potentially to system
configuration scripts which try to make sure qdiscs have the
right parameters.

Add a new Qdisc_ops callback and make relevant qdiscs TTRT.

Note that this uncovers the "shortcut" created by
commit 1f27cde313d7 ("net: sched: use pfifo_fast for non real queues")
The default child qdiscs beyond initial real_num_tx are always
pfifo_fast, no matter what the sysfs setting is. Fixing this
gets a little tricky because we'd need to keep a reference
on whatever the default qdisc was at the time of creation.
In practice this is likely an non-issue the qdiscs likely have
to be configured to non-default settings, so whatever user space
is doing such configuration can replace the pfifos... now that
it will see them.

Reported-by: Matthew Massey <matthewmassey@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sch_generic.h |  4 ++++
 net/core/dev.c            |  2 ++
 net/sched/sch_generic.c   |  9 +++++++++
 net/sched/sch_mq.c        | 24 ++++++++++++++++++++++++
 net/sched/sch_mqprio.c    | 23 +++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c0069ac00e62..8c2d611639fc 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -308,6 +308,8 @@ struct Qdisc_ops {
 					  struct netlink_ext_ack *extack);
 	void			(*attach)(struct Qdisc *sch);
 	int			(*change_tx_queue_len)(struct Qdisc *, unsigned int);
+	void			(*change_real_num_tx)(struct Qdisc *sch,
+						      unsigned int new_real_tx);
 
 	int			(*dump)(struct Qdisc *, struct sk_buff *);
 	int			(*dump_stats)(struct Qdisc *, struct gnet_dump *);
@@ -684,6 +686,8 @@ void qdisc_class_hash_grow(struct Qdisc *, struct Qdisc_class_hash *);
 void qdisc_class_hash_destroy(struct Qdisc_class_hash *);
 
 int dev_qdisc_change_tx_queue_len(struct net_device *dev);
+void dev_qdisc_change_real_num_tx(struct net_device *dev,
+				  unsigned int new_real_tx);
 void dev_init_scheduler(struct net_device *dev);
 void dev_shutdown(struct net_device *dev);
 void dev_activate(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 74fd402d26dd..f930329f0dc2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2921,6 +2921,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 		if (dev->num_tc)
 			netif_setup_tc(dev, txq);
 
+		dev_qdisc_change_real_num_tx(dev, txq);
+
 		dev->real_num_tx_queues = txq;
 
 		if (disabling) {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a8dd06c74e31..66d2fbe9ef50 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1330,6 +1330,15 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
 	return 0;
 }
 
+void dev_qdisc_change_real_num_tx(struct net_device *dev,
+				  unsigned int new_real_tx)
+{
+	struct Qdisc *qdisc = dev->qdisc;
+
+	if (qdisc->ops->change_real_num_tx)
+		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
+}
+
 int dev_qdisc_change_tx_queue_len(struct net_device *dev)
 {
 	bool up = dev->flags & IFF_UP;
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index e79f1afe0cfd..db18d8a860f9 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -125,6 +125,29 @@ static void mq_attach(struct Qdisc *sch)
 	priv->qdiscs = NULL;
 }
 
+static void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
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
+
 static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct net_device *dev = qdisc_dev(sch);
@@ -288,6 +311,7 @@ struct Qdisc_ops mq_qdisc_ops __read_mostly = {
 	.init		= mq_init,
 	.destroy	= mq_destroy,
 	.attach		= mq_attach,
+	.change_real_num_tx = mq_change_real_num_tx,
 	.dump		= mq_dump,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 8766ab5b8788..7f23a92849d5 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -306,6 +306,28 @@ static void mqprio_attach(struct Qdisc *sch)
 	priv->qdiscs = NULL;
 }
 
+static void mqprio_change_real_num_tx(struct Qdisc *sch,
+				      unsigned int new_real_tx)
+{
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
+}
+
 static struct netdev_queue *mqprio_queue_get(struct Qdisc *sch,
 					     unsigned long cl)
 {
@@ -623,6 +645,7 @@ static struct Qdisc_ops mqprio_qdisc_ops __read_mostly = {
 	.init		= mqprio_init,
 	.destroy	= mqprio_destroy,
 	.attach		= mqprio_attach,
+	.change_real_num_tx = mqprio_change_real_num_tx,
 	.dump		= mqprio_dump,
 	.owner		= THIS_MODULE,
 };
-- 
2.31.1

