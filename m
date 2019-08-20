Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94E396C46
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731074AbfHTWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730918AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GhaNEwgY9CnMnSHUSTDErNiB07Wo4XxOmrPuy4e52lA=; b=PYEGuzi8ENINCho5gGabj9jbKU
        8kOv8BoxzPDN7bN2pdSRRkdndHEU9d0nzsWvdFRLnYcseaqj5Pec6RAm5hNFAsq5bnAiPzZX3Ce9B
        JhQAqZLMRCL8xDspn8gXgLLJX/itM9JjC09ARIIz1D0jG8vOvWzvz1cZcxnvQ4nBTXqQ/sMSR+emD
        SGcAsl3HTCDkP40g9VSCCTCUxJyqpjPJZ7FXdisXXyIZhHqaJ2qBs60NcpIGv/+ldnENuedM2CK+/
        tE0ZiAtxvULPnWiobJGhO2hJjyNVkpORJmNcXNCI8BzpfcsG7U3Awm88so8MYOjAv8yOwq/BB4w5H
        OsaEI95g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pw-UX; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 05/38] mlx5: Convert mlx5_qp_table to XArray
Date:   Tue, 20 Aug 2019 15:32:26 -0700
Message-Id: <20190820223259.22348-6-willy@infradead.org>
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

Fix the locking in destroy_resource_common() to be irq-disable rather
than irq-save.  wait_for_completion() can sleep, so this function must
not be callable from interrupt context.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 38 ++++++--------------
 include/linux/mlx5/driver.h                  |  8 ++---
 include/linux/mlx5/qp.h                      |  2 +-
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index b8ba74de9555..e3367290b5ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -49,13 +49,11 @@ mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 	struct mlx5_core_rsc_common *common;
 	unsigned long flags;
 
-	spin_lock_irqsave(&table->lock, flags);
-
-	common = radix_tree_lookup(&table->tree, rsn);
+	xa_lock_irqsave(&table->array, flags);
+	common = xa_load(&table->array, rsn);
 	if (common)
 		atomic_inc(&common->refcount);
-
-	spin_unlock_irqrestore(&table->lock, flags);
+	xa_unlock_irqrestore(&table->array, flags);
 
 	return common;
 }
@@ -197,35 +195,22 @@ static int create_resource_common(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *qp,
 				  int rsc_type)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
-	int err;
-
-	qp->common.res = rsc_type;
-	spin_lock_irq(&table->lock);
-	err = radix_tree_insert(&table->tree,
-				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
-				qp);
-	spin_unlock_irq(&table->lock);
-	if (err)
-		return err;
-
 	atomic_set(&qp->common.refcount, 1);
 	init_completion(&qp->common.free);
 	qp->pid = current->pid;
 
-	return 0;
+	qp->common.res = rsc_type;
+	return xa_err(xa_store_irq(&dev->priv.qp_table.array,
+				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
+				qp, GFP_KERNEL));
 }
 
 static void destroy_resource_common(struct mlx5_core_dev *dev,
 				    struct mlx5_core_qp *qp)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
-	unsigned long flags;
+	struct xarray *xa = &dev->priv.qp_table.array;
 
-	spin_lock_irqsave(&table->lock, flags);
-	radix_tree_delete(&table->tree,
-			  qp->qpn | (qp->common.res << MLX5_USER_INDEX_LEN));
-	spin_unlock_irqrestore(&table->lock, flags);
+	xa_erase_irq(xa, qp->qpn | (qp->common.res << MLX5_USER_INDEX_LEN));
 	mlx5_core_put_rsc((struct mlx5_core_rsc_common *)qp);
 	wait_for_completion(&qp->common.free);
 }
@@ -524,10 +509,7 @@ EXPORT_SYMBOL_GPL(mlx5_core_qp_modify);
 void mlx5_init_qp_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
-
-	memset(table, 0, sizeof(*table));
-	spin_lock_init(&table->lock);
-	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+	xa_init_flags(&table->array, XA_FLAGS_LOCK_IRQ);
 	mlx5_qp_debugfs_init(dev);
 
 	table->nb.notifier_call = rsc_event_notifier;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index df23f17eed64..ba8f59b11920 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -448,12 +448,8 @@ struct mlx5_core_health {
 };
 
 struct mlx5_qp_table {
-	struct notifier_block   nb;
-
-	/* protect radix tree
-	 */
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
+	struct notifier_block	nb;
+	struct xarray		array;
 };
 
 struct mlx5_vf_context {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index ae63b1ae9004..6d1577a1ca41 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -555,7 +555,7 @@ struct mlx5_qp_context {
 
 static inline struct mlx5_core_qp *__mlx5_qp_lookup(struct mlx5_core_dev *dev, u32 qpn)
 {
-	return radix_tree_lookup(&dev->priv.qp_table.tree, qpn);
+	return xa_load(&dev->priv.qp_table.array, qpn);
 }
 
 int mlx5_core_create_dct(struct mlx5_core_dev *dev,
-- 
2.23.0.rc1

