Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B415A6B0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBLKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:43:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52561 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgBLKno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:44 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1pUc-0005aC-2A; Wed, 12 Feb 2020 10:43:42 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next 09/10] net-sysfs: add queue_change_owner()
Date:   Wed, 12 Feb 2020 11:43:20 +0100
Message-Id: <20200212104321.43570-10-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212104321.43570-1-christian.brauner@ubuntu.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to change the owner of the queue entries for a network device
when it is moved between network namespaces.

Currently, when moving network devices between network namespaces the
ownership of the corresponding queue sysfs entries are not changed. This leads
to problems when tools try to operate on the corresponding sysfs files. Fix
this.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 net/core/net-sysfs.c | 101 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4fda021edf6d..53db98be6198 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -944,6 +944,22 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	kobject_put(kobj);
 	return error;
 }
+
+static int rx_queue_change_owner(struct net_device *dev, int index)
+{
+	int error;
+	struct netdev_rx_queue *queue = dev->_rx + index;
+	struct kobject *kobj = &queue->kobj;
+
+	error = sysfs_change_owner(kobj);
+	if (error)
+		return error;
+
+	if (dev->sysfs_rx_queue_group)
+		error = sysfs_group_change_owner(kobj, dev->sysfs_rx_queue_group);
+
+	return error;
+}
 #endif /* CONFIG_SYSFS */
 
 int
@@ -981,6 +997,28 @@ net_rx_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 #endif
 }
 
+int net_rx_queue_change_owner(struct net_device *dev, int num)
+{
+#ifdef CONFIG_SYSFS
+	int i;
+	int error = 0;
+
+#ifndef CONFIG_RPS
+	if (!dev->sysfs_rx_queue_group)
+		return 0;
+#endif
+	for (i = 0; i < num; i++) {
+		error = rx_queue_change_owner(dev, i);
+		if (error)
+			break;
+	}
+
+	return error;
+#else
+	return 0;
+#endif
+}
+
 #ifdef CONFIG_SYSFS
 /*
  * netdev_queue sysfs structures and functions.
@@ -1486,6 +1524,22 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	kobject_put(kobj);
 	return error;
 }
+
+static int tx_queue_change_owner(struct net_device *ndev, int index)
+{
+	int error;
+	struct netdev_queue *queue = ndev->_tx + index;
+	struct kobject *kobj = &queue->kobj;
+
+	error = sysfs_change_owner(kobj);
+	if (error)
+		return error;
+
+#ifdef CONFIG_BQL
+	error = sysfs_group_change_owner(kobj, &dql_group);
+#endif
+	return error;
+}
 #endif /* CONFIG_SYSFS */
 
 int
@@ -1520,6 +1574,24 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 #endif /* CONFIG_SYSFS */
 }
 
+static int net_tx_queue_change_owner(struct net_device *dev, int num)
+{
+#ifdef CONFIG_SYSFS
+	int i;
+	int error = 0;
+
+	for (i = 0; i < num; i++) {
+		error = tx_queue_change_owner(dev, i);
+		if (error)
+			break;
+	}
+
+	return error;
+#else
+	return 0;
+#endif /* CONFIG_SYSFS */
+}
+
 static int register_queue_kobjects(struct net_device *dev)
 {
 	int error = 0, txq = 0, rxq = 0, real_rx = 0, real_tx = 0;
@@ -1554,6 +1626,31 @@ static int register_queue_kobjects(struct net_device *dev)
 	return error;
 }
 
+static int queue_change_owner(struct net_device *ndev)
+{
+	int error = 0, real_rx = 0, real_tx = 0;
+
+#ifdef CONFIG_SYSFS
+	if (ndev->queues_kset) {
+		error = sysfs_change_owner(&ndev->queues_kset->kobj);
+		if (error)
+			return error;
+	}
+	real_rx = ndev->real_num_rx_queues;
+#endif
+	real_tx = ndev->real_num_tx_queues;
+
+	error = net_rx_queue_change_owner(ndev, real_rx);
+	if (error)
+		return error;
+
+	error = net_tx_queue_change_owner(ndev, real_tx);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 static void remove_queue_kobjects(struct net_device *dev)
 {
 	int real_rx = 0, real_tx = 0;
@@ -1791,6 +1888,10 @@ int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
 	if (error)
 		return error;
 
+	error = queue_change_owner(ndev);
+	if (error)
+		return error;
+
 	return 0;
 }
 
-- 
2.25.0

