Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EED544A187
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbhKIBKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241936AbhKIBIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76B061A4E;
        Tue,  9 Nov 2021 01:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419821;
        bh=zpyCH+BQK8Mv4l53s0cFe41attMdhiZ9sclHH0es2nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brZSiyxQLTu/Ko6/O8Ix/lkZY4RcooUjNGdeFD1D4EVfAMjIshjL7Gxpd0B8OP8WO
         5zMBlsv72GCvyrViZM67rG88y3fEJ2ssAcswD/5EhZlKh5BLmafT7/jCHq3Z4ZSWiw
         nIw1e0yJZP2iZ5yfNvn/zAPcqQCIip3J+waWaLgYVhg2ZrNN0I/iGoFJG/8L1CDjdo
         mFl2F48PyxyAoHl4hgqCDctvu1qPgNR0wFwOc2cam1nb10KH7nNd0wHffBxOelGjG6
         cbUVhT5eR3YLEHH+KrTE/kgrruOU/ysvrOgocPHq4yDV6ejbqL1GLiHxFz7RWuPA62
         sOp1A1x+NlCJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, daniel@iogearbox.net,
        edumazet@google.com, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, bjorn@kernel.org, arnd@arndb.de,
        memxor@gmail.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 013/101] net: sched: update default qdisc visibility after Tx queue cnt changes
Date:   Mon,  8 Nov 2021 12:47:03 -0500
Message-Id: <20211108174832.1189312-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1e080f17750d1083e8a32f7b350584ae1cd7ff20 ]

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
Reviewed-by: Dave Taht <dave.taht@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |  4 ++++
 net/core/dev.c            |  2 ++
 net/sched/sch_generic.c   |  9 +++++++++
 net/sched/sch_mq.c        | 24 ++++++++++++++++++++++++
 net/sched/sch_mqprio.c    | 23 +++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f8631ad3c8686..9226a84dcc14d 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -302,6 +302,8 @@ struct Qdisc_ops {
 					  struct netlink_ext_ack *extack);
 	void			(*attach)(struct Qdisc *sch);
 	int			(*change_tx_queue_len)(struct Qdisc *, unsigned int);
+	void			(*change_real_num_tx)(struct Qdisc *sch,
+						      unsigned int new_real_tx);
 
 	int			(*dump)(struct Qdisc *, struct sk_buff *);
 	int			(*dump_stats)(struct Qdisc *, struct gnet_dump *);
@@ -683,6 +685,8 @@ void qdisc_class_hash_grow(struct Qdisc *, struct Qdisc_class_hash *);
 void qdisc_class_hash_destroy(struct Qdisc_class_hash *);
 
 int dev_qdisc_change_tx_queue_len(struct net_device *dev);
+void dev_qdisc_change_real_num_tx(struct net_device *dev,
+				  unsigned int new_real_tx);
 void dev_init_scheduler(struct net_device *dev);
 void dev_shutdown(struct net_device *dev);
 void dev_activate(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6a4e0e3c59fec..6f03809c45dbf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2973,6 +2973,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 		if (dev->num_tc)
 			netif_setup_tc(dev, txq);
 
+		dev_qdisc_change_real_num_tx(dev, txq);
+
 		dev->real_num_tx_queues = txq;
 
 		if (disabling) {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 05aa2571a4095..6a9c1a39874a0 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1303,6 +1303,15 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
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
index e79f1afe0cfd6..db18d8a860f9c 100644
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
index 5eb3b1b7ae5e7..50e15add6068f 100644
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
@@ -629,6 +651,7 @@ static struct Qdisc_ops mqprio_qdisc_ops __read_mostly = {
 	.init		= mqprio_init,
 	.destroy	= mqprio_destroy,
 	.attach		= mqprio_attach,
+	.change_real_num_tx = mqprio_change_real_num_tx,
 	.dump		= mqprio_dump,
 	.owner		= THIS_MODULE,
 };
-- 
2.33.0

