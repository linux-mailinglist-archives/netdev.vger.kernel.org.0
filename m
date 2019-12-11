Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6144311A2CF
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfLKC7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:59:00 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40272 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727217AbfLKC7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:59:00 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Dec 2019 04:58:58 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xBB2wv6U003700;
        Wed, 11 Dec 2019 04:58:58 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xBB2wuAl018882;
        Wed, 11 Dec 2019 04:58:56 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xBB2wt3s018881;
        Wed, 11 Dec 2019 04:58:55 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
Cc:     jiri@mellanox.com, jakub.kicinski@netronome.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Date:   Wed, 11 Dec 2019 04:58:53 +0200
Message-Id: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is no limit to the number of VFs netdevsim can enable.
In a real systems this value exist and used by driver.
Fore example, Some features might need to consider this value when
allocating memory.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/bus.c       | 39 +++++++++++++++++++++++--------
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 6aeed0c600f8..f1a0171080cb 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -26,9 +26,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 				   unsigned int num_vfs)
 {
-	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
-					  sizeof(struct nsim_vf_config),
-					  GFP_KERNEL);
+	if (nsim_bus_dev->max_vfs < num_vfs)
+		return -ENOMEM;
+
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
 	nsim_bus_dev->num_vfs = num_vfs;
@@ -38,8 +38,6 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 
 static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
-	kfree(nsim_bus_dev->vfconfigs);
-	nsim_bus_dev->vfconfigs = NULL;
 	nsim_bus_dev->num_vfs = 0;
 }
 
@@ -154,22 +152,29 @@ static struct device_type nsim_bus_dev_type = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count);
+nsim_bus_dev_new(unsigned int id, unsigned int port_count,
+		 unsigned int max_vfs);
+
+#define NSIM_BUS_DEV_MAX_VFS 4
 
 static ssize_t
 new_device_store(struct bus_type *bus, const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
 	unsigned int port_count;
+	unsigned int max_vfs;
 	unsigned int id;
 	int err;
 
-	err = sscanf(buf, "%u %u", &id, &port_count);
+	err = sscanf(buf, "%u %u %u", &id, &port_count, &max_vfs);
 	switch (err) {
 	case 1:
 		port_count = 1;
 		/* fall through */
 	case 2:
+		max_vfs = NSIM_BUS_DEV_MAX_VFS;
+		/* fall through */
+	case 3:
 		if (id > INT_MAX) {
 			pr_err("Value of \"id\" is too big.\n");
 			return -EINVAL;
@@ -179,7 +184,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count, max_vfs);
 	if (IS_ERR(nsim_bus_dev))
 		return PTR_ERR(nsim_bus_dev);
 
@@ -267,7 +272,8 @@ static struct bus_type nsim_bus = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count)
+nsim_bus_dev_new(unsigned int id, unsigned int port_count,
+		 unsigned int max_vfs)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
 	int err;
@@ -284,12 +290,24 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
+	nsim_bus_dev->max_vfs = max_vfs;
+
+	nsim_bus_dev->vfconfigs = kcalloc(nsim_bus_dev->max_vfs,
+					  sizeof(struct nsim_vf_config),
+					  GFP_KERNEL);
+	if (!nsim_bus_dev->vfconfigs) {
+		err = -ENOMEM;
+		goto err_nsim_bus_dev_id_free;
+	}
 
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
-		goto err_nsim_bus_dev_id_free;
+		goto err_nsim_vfconfigs_free;
+
 	return nsim_bus_dev;
 
+err_nsim_vfconfigs_free:
+	kfree(nsim_bus_dev->vfconfigs);
 err_nsim_bus_dev_id_free:
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
 err_nsim_bus_dev_free:
@@ -301,6 +319,7 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
 	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
+	kfree(nsim_bus_dev->vfconfigs);
 	kfree(nsim_bus_dev);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 94df795ef4d3..e2049856add8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -238,6 +238,7 @@ struct nsim_bus_dev {
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
+	unsigned int max_vfs;
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
 };
-- 
2.17.1

