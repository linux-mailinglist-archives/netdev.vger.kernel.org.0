Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B745399B1A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhFCHBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:11 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46900 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFCHBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:10 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2021 03:01:10 EDT
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 0E2A8219EE; Thu,  3 Jun 2021 14:52:32 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 09/16] mctp: Add neighbour implementation
Date:   Thu,  3 Jun 2021 14:52:11 +0800
Message-Id: <20210603065218.570867-10-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

Add an initial neighbour table implementation, to be used in the route
output path.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 include/net/mctp.h       |  25 +++++++
 include/net/mctpdevice.h |   1 +
 include/net/netns/mctp.h |   4 ++
 net/mctp/Makefile        |   2 +-
 net/mctp/af_mctp.c       |   5 ++
 net/mctp/device.c        |   1 +
 net/mctp/neigh.c         | 141 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 net/mctp/neigh.c

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 131c55850853..a37f77c787a5 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -119,6 +119,31 @@ int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr);
 int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr);
 void mctp_route_remove_dev(struct mctp_dev *mdev);
 
+/* neighbour definitions */
+enum mctp_neigh_source {
+	MCTP_NEIGH_STATIC,
+	MCTP_NEIGH_DISCOVER,
+};
+
+struct mctp_neigh {
+	struct mctp_dev		*dev;
+	mctp_eid_t		eid;
+	enum mctp_neigh_source	source;
+
+	unsigned char		ha[MAX_ADDR_LEN];
+
+	struct list_head	list;
+	struct rcu_head		rcu;
+};
+
+int mctp_neigh_init(void);
+void mctp_neigh_exit(void);
+
+// ret_hwaddr may be NULL, otherwise must have space for MAX_ADDR_LEN
+int mctp_neigh_lookup(struct mctp_dev *dev, mctp_eid_t eid,
+		      void *ret_hwaddr);
+void mctp_neigh_remove_dev(struct mctp_dev *mdev);
+
 int mctp_routes_init(void);
 void mctp_routes_exit(void);
 
diff --git a/include/net/mctpdevice.h b/include/net/mctpdevice.h
index a6ac4aee5d7b..f1ffba088d56 100644
--- a/include/net/mctpdevice.h
+++ b/include/net/mctpdevice.h
@@ -37,5 +37,6 @@ struct mctp_dev {
 
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev);
+struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 
 #endif /* __NET_MCTPDEVICE_H */
diff --git a/include/net/netns/mctp.h b/include/net/netns/mctp.h
index 508459b08a59..2f5ebeeb320e 100644
--- a/include/net/netns/mctp.h
+++ b/include/net/netns/mctp.h
@@ -11,6 +11,10 @@
 struct netns_mctp {
 	/* Only updated under RTNL, entries freed via RCU */
 	struct list_head routes;
+
+	/* neighbour table */
+	struct mutex neigh_lock;
+	struct list_head neighbours;
 };
 
 #endif /* __NETNS_MCTP_H__ */
diff --git a/net/mctp/Makefile b/net/mctp/Makefile
index b1a330e9d82a..0171333384d7 100644
--- a/net/mctp/Makefile
+++ b/net/mctp/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MCTP) += mctp.o
-mctp-objs := af_mctp.o device.o route.o
+mctp-objs := af_mctp.o device.o route.o neigh.o
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 081c7b8005da..227cd49203b0 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -161,6 +161,10 @@ static __init int mctp_init(void)
 	if (rc)
 		goto err_unreg_proto;
 
+	rc = mctp_neigh_init();
+	if (rc)
+		goto err_unreg_proto;
+
 	mctp_device_init();
 
 	return 0;
@@ -176,6 +180,7 @@ static __init int mctp_init(void)
 static __exit void mctp_exit(void)
 {
 	mctp_device_exit();
+	mctp_neigh_exit();
 	mctp_routes_exit();
 	proto_unregister(&mctp_proto);
 	sock_unregister(PF_MCTP);
diff --git a/net/mctp/device.c b/net/mctp/device.c
index 273041ed2d3e..d3ca9f664b30 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -285,6 +285,7 @@ static void mctp_unregister(struct net_device *dev)
 	RCU_INIT_POINTER(mdev->dev->mctp_ptr, NULL);
 
 	mctp_route_remove_dev(mdev);
+	mctp_neigh_remove_dev(mdev);
 	list_for_each_entry_safe(ifa, tmp, &mdev->addrs, dev_list) {
 		list_del_rcu(&ifa->dev_list);
 		kfree_rcu(ifa, rcu);
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
new file mode 100644
index 000000000000..acf4f38c878b
--- /dev/null
+++ b/net/mctp/neigh.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Management Controller Transport Protocol (MCTP) - routing
+ * implementation.
+ *
+ * This is currently based on a simple routing table, with no dst cache. The
+ * number of routes should stay fairly small, so the lookup cost is small.
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#include <linux/idr.h>
+#include <linux/mctp.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+
+#include <net/mctp.h>
+#include <net/mctpdevice.h>
+#include <net/netlink.h>
+#include <net/sock.h>
+
+static int __always_unused mctp_neigh_add(struct mctp_dev *mdev, mctp_eid_t eid,
+					  enum mctp_neigh_source source,
+					  size_t lladdr_len, const void *lladdr)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_neigh *neigh;
+	int rc;
+
+	mutex_lock(&net->mctp.neigh_lock);
+	if (mctp_neigh_lookup(mdev, eid, NULL) == 0) {
+		rc = -EEXIST;
+		goto out;
+	}
+
+	if (lladdr_len > sizeof(neigh->ha)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	neigh = kzalloc(sizeof(*neigh), GFP_KERNEL);
+	if (!neigh) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	INIT_LIST_HEAD(&neigh->list);
+	neigh->dev = mdev;
+	dev_hold(neigh->dev->dev);
+	neigh->eid = eid;
+	neigh->source = source;
+	memcpy(neigh->ha, lladdr, lladdr_len);
+
+	list_add_rcu(&neigh->list, &net->mctp.neighbours);
+	rc = 0;
+out:
+	mutex_unlock(&net->mctp.neigh_lock);
+	return rc;
+}
+
+static void __mctp_neigh_free(struct rcu_head *rcu)
+{
+	struct mctp_neigh *neigh = container_of(rcu, struct mctp_neigh, rcu);
+
+	dev_put(neigh->dev->dev);
+	kfree(neigh);
+}
+
+/* Removes all neighbour entries referring to a device */
+void mctp_neigh_remove_dev(struct mctp_dev *mdev)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_neigh *neigh, *tmp;
+
+	mutex_lock(&net->mctp.neigh_lock);
+	list_for_each_entry_safe(neigh, tmp, &net->mctp.neighbours, list) {
+		if (neigh->dev == mdev) {
+			list_del_rcu(&neigh->list);
+			/* TODO: immediate RTM_DELNEIGH */
+			call_rcu(&neigh->rcu, __mctp_neigh_free);
+		}
+	}
+
+	mutex_unlock(&net->mctp.neigh_lock);
+}
+
+int mctp_neigh_lookup(struct mctp_dev *mdev, mctp_eid_t eid, void *ret_hwaddr)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_neigh *neigh;
+	int rc = -EHOSTUNREACH; // TODO: or ENOENT?
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(neigh, &net->mctp.neighbours, list) {
+		if (mdev == neigh->dev && eid == neigh->eid) {
+			if (ret_hwaddr)
+				memcpy(ret_hwaddr, neigh->ha,
+				       sizeof(neigh->ha));
+			rc = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return rc;
+}
+
+/* namespace registration */
+static int __net_init mctp_neigh_net_init(struct net *net)
+{
+	struct netns_mctp *ns = &net->mctp;
+
+	INIT_LIST_HEAD(&ns->neighbours);
+	return 0;
+}
+
+static void __net_exit mctp_neigh_net_exit(struct net *net)
+{
+	struct netns_mctp *ns = &net->mctp;
+	struct mctp_neigh *neigh;
+
+	list_for_each_entry(neigh, &ns->neighbours, list)
+		call_rcu(&neigh->rcu, __mctp_neigh_free);
+}
+
+/* net namespace implementation */
+
+static struct pernet_operations mctp_net_ops = {
+	.init = mctp_neigh_net_init,
+	.exit = mctp_neigh_net_exit,
+};
+
+int __init mctp_neigh_init(void)
+{
+	return register_pernet_subsys(&mctp_net_ops);
+}
+
+void __exit mctp_neigh_exit(void)
+{
+	unregister_pernet_subsys(&mctp_net_ops);
+}
-- 
2.30.2

