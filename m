Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982FB44A20B
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbhKIBQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242445AbhKIBNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 402D861A89;
        Tue,  9 Nov 2021 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419932;
        bh=ZknjGPUVoBXubIaIGuX9qF5kHI7OFEdYjNjEgB7yb1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S38+kAb6hMBGZkbela7pWHYf5iyoEnacIyhx/UWTGPVARoIvgGq2oLBC+woSHcspx
         CQa9cCxLtw8nWxlxQkdcGomgsSwa7SVrY1zIcppijXxFLrpcnJ2VIAw4Q4h5Oz5LD7
         9bpIwUr6cse82wekqNex/yz5AWaOrGtKJM8DTFmfb95qlOBFTYHvOWzS1T8mz5Z8vD
         ZpgiVzmWp0CQjldor1PKwrr0gXGhedn74bWBfEu3ZQLpmy3Tvm/sIYY+bsFTrs2FXj
         zwLNTeZlx+VcZtV8DxjMHFPI1DUqo3/ahEoH+XrRLb8E/2xjJed9JZsC/0K7E2JhSY
         PzWYb7xBDwG1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, daniel@iogearbox.net,
        atenart@kernel.org, edumazet@google.com, alobakin@pm.me,
        weiwan@google.com, bjorn@kernel.org, arnd@arndb.de,
        memxor@gmail.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/47] net: sched: update default qdisc visibility after Tx queue cnt changes
Date:   Mon,  8 Nov 2021 12:49:52 -0500
Message-Id: <20211108175031.1190422-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index d737a6a2600be..286bc674a6e79 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -216,6 +216,8 @@ struct Qdisc_ops {
 					  struct netlink_ext_ack *extack);
 	void			(*attach)(struct Qdisc *sch);
 	int			(*change_tx_queue_len)(struct Qdisc *, unsigned int);
+	void			(*change_real_num_tx)(struct Qdisc *sch,
+						      unsigned int new_real_tx);
 
 	int			(*dump)(struct Qdisc *, struct sk_buff *);
 	int			(*dump_stats)(struct Qdisc *, struct gnet_dump *);
@@ -547,6 +549,8 @@ void qdisc_class_hash_grow(struct Qdisc *, struct Qdisc_class_hash *);
 void qdisc_class_hash_destroy(struct Qdisc_class_hash *);
 
 int dev_qdisc_change_tx_queue_len(struct net_device *dev);
+void dev_qdisc_change_real_num_tx(struct net_device *dev,
+				  unsigned int new_real_tx);
 void dev_init_scheduler(struct net_device *dev);
 void dev_shutdown(struct net_device *dev);
 void dev_activate(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 397bc2f50de08..2519a90a14827 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2648,6 +2648,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 		if (dev->num_tc)
 			netif_setup_tc(dev, txq);
 
+		dev_qdisc_change_real_num_tx(dev, txq);
+
 		dev->real_num_tx_queues = txq;
 
 		if (disabling) {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 4e15913e7519e..2128b77d5cb33 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1256,6 +1256,15 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
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
index c008a316e9436..699b6bb444cea 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -130,6 +130,29 @@ static void mq_attach(struct Qdisc *sch)
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
@@ -285,6 +308,7 @@ struct Qdisc_ops mq_qdisc_ops __read_mostly = {
 	.init		= mq_init,
 	.destroy	= mq_destroy,
 	.attach		= mq_attach,
+	.change_real_num_tx = mq_change_real_num_tx,
 	.dump		= mq_dump,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index fcfe41a954733..3fd0e5dd7ae3e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -308,6 +308,28 @@ static void mqprio_attach(struct Qdisc *sch)
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
@@ -632,6 +654,7 @@ static struct Qdisc_ops mqprio_qdisc_ops __read_mostly = {
 	.init		= mqprio_init,
 	.destroy	= mqprio_destroy,
 	.attach		= mqprio_attach,
+	.change_real_num_tx = mqprio_change_real_num_tx,
 	.dump		= mqprio_dump,
 	.owner		= THIS_MODULE,
 };
-- 
2.33.0

