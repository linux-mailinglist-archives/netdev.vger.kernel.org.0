Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E8F440C4B
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhJ3XRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232063AbhJ3XRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A37D60F58;
        Sat, 30 Oct 2021 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635714;
        bh=XfPV90upcm8BbRkDzrAqGvLrKSBt0lEMFu+1d0krC0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8Q9sYPh4i2VkS0rve3TC1xX140PWZ5aCubAyhWY2ISSAibwkoZEx0gkhmx9Oi+8E
         0EAT8Az65DbhVkb0Y9HwBFpx53MSqPz3Pcps9IGfyFJtvyjW5wQKq1cdnIluj+/2Hv
         lA89U6FsARrQHA/maLltQI5zM8FXsIzggo1y8AwP06ErsA2ospZbX0saY7fhTN/ScP
         R4Ut3MRHjCC5xdXTf/kXn3RvvNJEARNHEZ32dBZXWDYRPM+hIqmq/F0WMjvJ2qxaHk
         hmonafC+dbBpwid3BFPqLjQhv1Sm700dYSHThDlxtb5jVnEgWtI3Hx9rato1orcS7l
         qT8pm1W4iaNVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/5] netdevsim: move details of vf config to dev
Date:   Sat, 30 Oct 2021 16:15:03 -0700
Message-Id: <20211030231505.2478149-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231505.2478149-1-kuba@kernel.org>
References: <20211030231505.2478149-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since "eswitch" configuration was added bus.c contains
a lot of device details which really belong to dev.c.

Restructure the code while moving it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       | 69 ++-----------------------------
 drivers/net/netdevsim/dev.c       | 61 +++++++++++++++++++++++++--
 drivers/net/netdevsim/netdevsim.h |  6 +--
 3 files changed, 63 insertions(+), 73 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 1e7df184419d..d037600c0f0c 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 
@@ -24,50 +23,11 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 	return container_of(dev, struct nsim_bus_dev, dev);
 }
 
-static void
-nsim_bus_dev_set_vfs(struct nsim_bus_dev *nsim_bus_dev, unsigned int num_vfs)
-{
-	rtnl_lock();
-	nsim_bus_dev->num_vfs = num_vfs;
-	rtnl_unlock();
-}
-
-static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
-				   unsigned int num_vfs)
-{
-	struct nsim_dev *nsim_dev;
-	int err = 0;
-
-	if (nsim_bus_dev->max_vfs < num_vfs)
-		return -ENOMEM;
-	nsim_bus_dev_set_vfs(nsim_bus_dev, num_vfs);
-
-	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-	if (nsim_esw_mode_is_switchdev(nsim_dev)) {
-		err = nsim_esw_switchdev_enable(nsim_dev, NULL);
-		if (err)
-			nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
-	}
-
-	return err;
-}
-
-void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
-{
-	struct nsim_dev *nsim_dev;
-
-	nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
-	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-	if (nsim_esw_mode_is_switchdev(nsim_dev))
-		nsim_esw_legacy_enable(nsim_dev, NULL);
-}
-
 static ssize_t
 nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
-	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
 	unsigned int num_vfs;
 	int ret;
 
@@ -76,33 +36,12 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
 		return ret;
 
 	device_lock(dev);
-	if (!nsim_dev) {
-		ret = -ENOENT;
-		goto exit_unlock;
-	}
-
-	mutex_lock(&nsim_dev->vfs_lock);
-	if (nsim_bus_dev->num_vfs == num_vfs)
-		goto exit_good;
-	if (nsim_bus_dev->num_vfs && num_vfs) {
-		ret = -EBUSY;
-		goto exit_unlock;
-	}
-
-	if (num_vfs) {
-		ret = nsim_bus_dev_vfs_enable(nsim_bus_dev, num_vfs);
-		if (ret)
-			goto exit_unlock;
-	} else {
-		nsim_bus_dev_vfs_disable(nsim_bus_dev);
-	}
-exit_good:
-	ret = count;
-exit_unlock:
-	mutex_unlock(&nsim_dev->vfs_lock);
+	ret = -ENOENT;
+	if (dev_get_drvdata(dev))
+		ret = nsim_drv_configure_vfs(nsim_bus_dev, num_vfs);
 	device_unlock(dev);
 
-	return ret;
+	return ret ? ret : count;
 }
 
 static ssize_t
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 8157d28b32e4..c19f36c9e0a1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -64,6 +64,14 @@ unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev)
 	return nsim_dev->nsim_bus_dev->num_vfs;
 }
 
+static void
+nsim_bus_dev_set_vfs(struct nsim_bus_dev *nsim_bus_dev, unsigned int num_vfs)
+{
+	rtnl_lock();
+	nsim_bus_dev->num_vfs = num_vfs;
+	rtnl_unlock();
+}
+
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
 static int
@@ -496,7 +504,9 @@ static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 }
 
 static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port);
-int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack)
+
+static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
+				  struct netlink_ext_ack *extack)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	struct nsim_dev_port *nsim_dev_port, *tmp;
@@ -511,7 +521,8 @@ int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *ex
 	return 0;
 }
 
-int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack)
+static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
+				     struct netlink_ext_ack *extack)
 {
 	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	int i, err;
@@ -1565,8 +1576,11 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	debugfs_remove(nsim_dev->take_snapshot);
 
 	mutex_lock(&nsim_dev->vfs_lock);
-	if (nsim_dev_get_vfs(nsim_dev))
-		nsim_bus_dev_vfs_disable(nsim_dev->nsim_bus_dev);
+	if (nsim_dev_get_vfs(nsim_dev)) {
+		nsim_bus_dev_set_vfs(nsim_dev->nsim_bus_dev, 0);
+		if (nsim_esw_mode_is_switchdev(nsim_dev))
+			nsim_esw_legacy_enable(nsim_dev, NULL);
+	}
 	mutex_unlock(&nsim_dev->vfs_lock);
 
 	nsim_dev_port_del_all(nsim_dev);
@@ -1641,6 +1655,45 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type
 	return err;
 }
 
+int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
+			   unsigned int num_vfs)
+{
+	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	int ret;
+
+	mutex_lock(&nsim_dev->vfs_lock);
+	if (nsim_bus_dev->num_vfs == num_vfs) {
+		ret = 0;
+		goto exit_unlock;
+	}
+	if (nsim_bus_dev->num_vfs && num_vfs) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
+	if (nsim_bus_dev->max_vfs < num_vfs) {
+		ret = -ENOMEM;
+		goto exit_unlock;
+	}
+
+	nsim_bus_dev_set_vfs(nsim_bus_dev, num_vfs);
+	if (nsim_esw_mode_is_switchdev(nsim_dev)) {
+		if (num_vfs) {
+			ret = nsim_esw_switchdev_enable(nsim_dev, NULL);
+			if (ret) {
+				nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
+				goto exit_unlock;
+			}
+		} else {
+			nsim_esw_legacy_enable(nsim_dev, NULL);
+		}
+	}
+
+exit_unlock:
+	mutex_unlock(&nsim_dev->vfs_lock);
+
+	return ret;
+}
+
 int nsim_dev_init(void)
 {
 	nsim_dev_ddir = debugfs_create_dir(DRV_NAME, NULL);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index b4b287cdfe77..8da5f82e5cfc 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -281,9 +281,6 @@ struct nsim_dev {
 	u16 esw_mode;
 };
 
-int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack);
-int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack);
-
 static inline bool nsim_esw_mode_is_legacy(struct nsim_dev *nsim_dev)
 {
 	return nsim_dev->esw_mode == DEVLINK_ESWITCH_MODE_LEGACY;
@@ -309,6 +306,8 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
+int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
+			   unsigned int num_vfs);
 
 unsigned int nsim_dev_get_vfs(struct nsim_dev *nsim_dev);
 
@@ -324,7 +323,6 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
 ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   const char __user *data,
 				   size_t count, loff_t *ppos);
-void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev);
 
 static inline bool nsim_dev_port_is_pf(struct nsim_dev_port *nsim_dev_port)
 {
-- 
2.31.1

