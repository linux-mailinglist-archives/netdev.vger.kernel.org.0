Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C1440BA0
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 22:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhJ3UXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 16:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhJ3UXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 16:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DDB960FC3;
        Sat, 30 Oct 2021 20:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635625266;
        bh=0zIYoPau31cI4bRDlr6UaKB9U2FQdMa/hc6VteH73fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmZkW4f+S0SawA7BWmIa/Q2WVdtW4q5u9PfJ/qmRZwQSYBNgK205fUHmCndXwpx8h
         NCgq6nTC7GbNKw/XM7hbp9sXXUFJDv+e8vqvvRWGEBcN5bYa7BdAzY/BODRrmOrVT5
         bD6JZavGFHuwEUW2NiG56WalX7P6lEhn1GxC1DsE+HogwaDqnvbz/HQV+rwhMi45/w
         c7bRPEW/crHxXtptgS9YHRy3g7F9QGgrTAD8VT6PfxiG8Z9l+yFHj7p3dPFlQ16nb5
         U7/WR8WXn6dqGNf/plQe/boxDQH2XwYiF+63SUj4s73ZfwVwyc+YlXk1k8Kj1igL6q
         LsDhYfhGNmNBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] netdevsim: rename 'driver' entry points
Date:   Sat, 30 Oct 2021 13:21:02 -0700
Message-Id: <20211030202102.2157622-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030202102.2157622-1-kuba@kernel.org>
References: <20211030202102.2157622-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename functions serving as driver entry points
from nsim_dev_... to nsim_drv_... this makes the
API boundary between bus and dev clearer.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       |  8 ++++----
 drivers/net/netdevsim/dev.c       | 12 ++++++------
 drivers/net/netdevsim/netdevsim.h |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 0b41f1625db9..25cb2e600d53 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -80,7 +80,7 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 		return -EBUSY;
 	}
 
-	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
+	ret = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
@@ -110,7 +110,7 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 		return -EBUSY;
 	}
 
-	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
+	ret = nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
@@ -250,14 +250,14 @@ static int nsim_bus_probe(struct device *dev)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
 
-	return nsim_dev_probe(nsim_bus_dev);
+	return nsim_drv_probe(nsim_bus_dev);
 }
 
 static void nsim_bus_remove(struct device *dev)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
 
-	nsim_dev_remove(nsim_bus_dev);
+	nsim_drv_remove(nsim_bus_dev);
 }
 
 static int nsim_num_vf(struct device *dev)
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f6a2a01b384e..6d29531e74fa 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -589,7 +589,7 @@ int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack
 	int i, err;
 
 	for (i = 0; i < nsim_dev_get_vfs(nsim_dev); i++) {
-		err = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		err = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
 			pr_err("Failed to initialize VF id=%d. %d.\n", i, err);
@@ -601,7 +601,7 @@ int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack
 
 err_port_add_vfs:
 	for (i--; i >= 0; i--)
-		nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
 	return err;
 }
 
@@ -1519,7 +1519,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	return err;
 }
 
-int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
+int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -1653,7 +1653,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	mutex_destroy(&nsim_dev->port_list_lock);
 }
 
-void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
+void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
@@ -1684,7 +1684,7 @@ __nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 	return NULL;
 }
 
-int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
+int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -1699,7 +1699,7 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type
 	return err;
 }
 
-int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
+int nsim_drv_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index fd7133407f05..c49771f27f17 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -298,12 +298,12 @@ static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
 
 int nsim_dev_init(void);
 void nsim_dev_exit(void);
-int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
-void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev);
-int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev);
+void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev);
+int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev,
 		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
-int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_drv_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
-- 
2.31.1

