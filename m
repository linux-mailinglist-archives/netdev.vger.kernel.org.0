Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8876896C68
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbfHTWeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730885AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U3FDKmqwzP0HCl58/EtURkMoF5kFjJky2ZF8eC3+P6s=; b=cetpzH/wN693eaOD1XWiiQuBkz
        /ra23/vc+ni9++NXVrPMc9c0WRJNAU+rNNH76Jun48Z3wYPwwvyLqzbM0+HbO2CLnaGOWug/pbkyN
        MpumekUk19JEFcRQZJK3b+UBPO1sPqwtriBvNqOb3700oS0+UZYJLrNZ1tlWhLPvlswRCgxLNFqhI
        6CY4XCFR3lg++XAFG25Xxi4eYC7niJQ8mSmIrv8y4bvROAOFc+OP5IHDPH1UpIhZCctRsyhEG3A7h
        mmHEtbrSxp2d6iBhS2+qyioxawURWM4absOpzsvoE89rKcqNmqqLaparpq2ncQGZAfVgKgP+kgAZA
        y/f9YxwQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pl-R3; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 03/38] mlx4: Convert qp_table_tree to XArray
Date:   Tue, 20 Aug 2019 15:32:24 -0700
Message-Id: <20190820223259.22348-4-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This XArray appears to be modifiable from interrupt context, so we have
to be a little more careful with the locking.  However, the lookup can
be done without the spinlock held.  I cannot determine whether
mlx4_qp_alloc() is allowed to sleep, so I've retained the GFP_ATOMIC
there, but it could be turned into GFP_KERNEL if the callers can
tolerate it sleeping.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |  3 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c   | 37 ++++++-----------------
 include/linux/mlx4/device.h               |  4 +--
 include/linux/mlx4/qp.h                   |  2 +-
 4 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index b6fe22bee9f4..aaece8480da7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -38,7 +38,7 @@
 #define MLX4_H
 
 #include <linux/mutex.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/rbtree.h>
 #include <linux/timer.h>
 #include <linux/semaphore.h>
@@ -716,7 +716,6 @@ struct mlx4_qp_table {
 	u32			zones_uids[MLX4_QP_TABLE_ZONE_NUM];
 	u32			rdmarc_base;
 	int			rdmarc_shift;
-	spinlock_t		lock;
 	struct mlx4_icm_table	qp_table;
 	struct mlx4_icm_table	auxc_table;
 	struct mlx4_icm_table	altc_table;
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 427e7a31862c..4659ecec12c1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -48,16 +48,13 @@
 
 void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 {
-	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
 	struct mlx4_qp *qp;
 
-	spin_lock(&qp_table->lock);
-
+	xa_lock(&dev->qp_table);
 	qp = __mlx4_qp_lookup(dev, qpn);
 	if (qp)
 		refcount_inc(&qp->refcount);
-
-	spin_unlock(&qp_table->lock);
+	xa_unlock(&dev->qp_table);
 
 	if (!qp) {
 		mlx4_dbg(dev, "Async event for none existent QP %08x\n", qpn);
@@ -390,21 +387,11 @@ static void mlx4_qp_free_icm(struct mlx4_dev *dev, int qpn)
 
 struct mlx4_qp *mlx4_qp_lookup(struct mlx4_dev *dev, u32 qpn)
 {
-	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
-	struct mlx4_qp *qp;
-
-	spin_lock_irq(&qp_table->lock);
-
-	qp = __mlx4_qp_lookup(dev, qpn);
-
-	spin_unlock_irq(&qp_table->lock);
-	return qp;
+	return __mlx4_qp_lookup(dev, qpn);
 }
 
 int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp)
 {
-	struct mlx4_priv *priv = mlx4_priv(dev);
-	struct mlx4_qp_table *qp_table = &priv->qp_table;
 	int err;
 
 	if (!qpn)
@@ -416,10 +403,9 @@ int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp)
 	if (err)
 		return err;
 
-	spin_lock_irq(&qp_table->lock);
-	err = radix_tree_insert(&dev->qp_table_tree, qp->qpn &
-				(dev->caps.num_qps - 1), qp);
-	spin_unlock_irq(&qp_table->lock);
+	err = xa_err(xa_store_irq(&dev->qp_table,
+				qp->qpn & (dev->caps.num_qps - 1),
+				qp, GFP_ATOMIC));
 	if (err)
 		goto err_icm;
 
@@ -512,12 +498,11 @@ EXPORT_SYMBOL_GPL(mlx4_update_qp);
 
 void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp)
 {
-	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
 	unsigned long flags;
 
-	spin_lock_irqsave(&qp_table->lock, flags);
-	radix_tree_delete(&dev->qp_table_tree, qp->qpn & (dev->caps.num_qps - 1));
-	spin_unlock_irqrestore(&qp_table->lock, flags);
+	xa_lock_irqsave(&dev->qp_table, flags);
+	__xa_erase(&dev->qp_table, qp->qpn & (dev->caps.num_qps - 1));
+	xa_unlock_irqrestore(&dev->qp_table, flags);
 }
 EXPORT_SYMBOL_GPL(mlx4_qp_remove);
 
@@ -760,7 +745,6 @@ static void mlx4_cleanup_qp_zones(struct mlx4_dev *dev)
 
 int mlx4_init_qp_table(struct mlx4_dev *dev)
 {
-	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
 	int err;
 	int reserved_from_top = 0;
 	int reserved_from_bot;
@@ -770,8 +754,7 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 	u32 max_table_offset = dev->caps.dmfs_high_rate_qpn_base +
 			dev->caps.dmfs_high_rate_qpn_range;
 
-	spin_lock_init(&qp_table->lock);
-	INIT_RADIX_TREE(&dev->qp_table_tree, GFP_ATOMIC);
+	xa_init_flags(&dev->qp_table, XA_FLAGS_LOCK_IRQ);
 	if (mlx4_is_slave(dev))
 		return 0;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 36e412c3d657..acffca7d9f00 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -36,7 +36,7 @@
 #include <linux/if_ether.h>
 #include <linux/pci.h>
 #include <linux/completion.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/cpu_rmap.h>
 #include <linux/crash_dump.h>
 
@@ -889,7 +889,7 @@ struct mlx4_dev {
 	struct mlx4_caps	caps;
 	struct mlx4_phys_caps	phys_caps;
 	struct mlx4_quotas	quotas;
-	struct radix_tree_root	qp_table_tree;
+	struct xarray		qp_table;
 	u8			rev_id;
 	u8			port_random_macs;
 	char			board_id[MLX4_BOARD_ID_LEN];
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 8e2828d48d7f..6c3ec3197a10 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -488,7 +488,7 @@ int mlx4_qp_to_ready(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 
 static inline struct mlx4_qp *__mlx4_qp_lookup(struct mlx4_dev *dev, u32 qpn)
 {
-	return radix_tree_lookup(&dev->qp_table_tree, qpn & (dev->caps.num_qps - 1));
+	return xa_load(&dev->qp_table, qpn & (dev->caps.num_qps - 1));
 }
 
 void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp);
-- 
2.23.0.rc1

