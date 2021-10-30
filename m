Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7429440C4D
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhJ3XRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhJ3XRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104C160F93;
        Sat, 30 Oct 2021 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635715;
        bh=HyLCMK515YRhtrqBRGOZuyZShlcJGyxe3+W6YN+gKis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXhxl1ePCUtx3SiwrN9JY22kmz0Rdq5lgv6KboSnh5t75+Br1xx8UuPDcuZCTYsfp
         q7eASGJZCSkddIDl1ETAMDde3CtPZV+5+ObC+njAfVVzxzEHZTBt9aronhNBOHWGOT
         pofmBNkYanc7OGFgtKouVZ5WuZS5az8aUyYS2Ys1MCXMz75z12++CMuxUkrqu6+JEI
         EloLA1sSxYGyFvR7rouiwK4zhcIgbBB/+D02pi/FlHBXyCARWboFXo5WB/bYvIycNR
         coZPAw94PmUsm6qtDY72xr794Wjk4F9ExxjC6j0gRWJJGz2mVSBAJSqjBcbtjP1tPV
         yp7yWsEWXCJfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/5] netdevsim: rename 'driver' entry points
Date:   Sat, 30 Oct 2021 16:15:05 -0700
Message-Id: <20211030231505.2478149-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231505.2478149-1-kuba@kernel.org>
References: <20211030231505.2478149-1-kuba@kernel.org>
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
index 040531fe0879..5db40d713d2a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -592,7 +592,7 @@ static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < nsim_dev_get_vfs(nsim_dev); i++) {
-		err = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		err = nsim_drv_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to initialize VFs' netdevsim ports");
 			pr_err("Failed to initialize VF id=%d. %d.\n", i, err);
@@ -604,7 +604,7 @@ static int nsim_esw_switchdev_enable(struct nsim_dev *nsim_dev,
 
 err_port_add_vfs:
 	for (i--; i >= 0; i--)
-		nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
+		nsim_drv_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_VF, i);
 	return err;
 }
 
@@ -1522,7 +1522,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	return err;
 }
 
-int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
+int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -1656,7 +1656,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	mutex_destroy(&nsim_dev->port_list_lock);
 }
 
-void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
+void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
@@ -1687,7 +1687,7 @@ __nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 	return NULL;
 }
 
-int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
+int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -1702,7 +1702,7 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type
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

