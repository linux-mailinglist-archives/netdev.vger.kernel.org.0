Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34F196C56
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfHTWdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbfHTWdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aZm5q1pMdSmj37MZ2pZUKZAJv5gUxiBukUXOdBf2NF4=; b=ShCTvu8TkmpbbhvUHu7zOJrESs
        ly0c2LXLHNPofJ1j/HoDf9+5M3NvNxxF45Hvoo83e1JHSHg7csfG/AtAixoaIP65Bjb8b9+NQSylo
        +B7cvuyp1vTxYWcAWChiEPBMBCPR9vij7jjQl1StHxqRltmpyXB00f5nhxuN9rtRe+YWC5UrP6fbO
        csyeHk8NMv86aXDc+u2RD4INhFOYmq5AJjBaxa3SgQP7HoEvTRnHt7m2zbvLHXYaTPX/nupAkd72E
        fFMMoerlEWNwVQSRouMKv5Ir7lyrtRKH4kPiMq7x/goBozPNaTPAegqU6ibLoEDtz75QrC4ynXnAc
        YNcJSzqA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pZ-Ld; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 01/38] mlx4: Convert cq_table->tree to XArray
Date:   Tue, 20 Aug 2019 15:32:22 -0700
Message-Id: <20190820223259.22348-2-willy@infradead.org>
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

Remove the custom spinlock as the XArray handles its own locking.
It might also be possible to remove the bitmap and use the XArray
in allocating mode.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c   | 30 +++++++----------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |  3 +--
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 65f8a4b6ed0c..d0be77e70065 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -105,10 +105,8 @@ void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 {
 	struct mlx4_cq *cq;
 
-	rcu_read_lock();
-	cq = radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
+	cq = xa_load(&mlx4_priv(dev)->cq_table.array,
 			       cqn & (dev->caps.num_cqs - 1));
-	rcu_read_unlock();
 
 	if (!cq) {
 		mlx4_dbg(dev, "Completion event for bogus CQ %08x\n", cqn);
@@ -128,9 +126,7 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	struct mlx4_cq *cq;
 
-	rcu_read_lock();
-	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
-	rcu_read_unlock();
+	cq = xa_load(&cq_table->array, cqn & (dev->caps.num_cqs - 1));
 
 	if (!cq) {
 		mlx4_dbg(dev, "Async event for bogus CQ %08x\n", cqn);
@@ -360,16 +356,14 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	if (err)
 		return err;
 
-	spin_lock(&cq_table->lock);
-	err = radix_tree_insert(&cq_table->tree, cq->cqn, cq);
-	spin_unlock(&cq_table->lock);
+	err = xa_err(xa_store(&cq_table->array, cq->cqn, cq, GFP_KERNEL));
 	if (err)
 		goto err_icm;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		err = PTR_ERR(mailbox);
-		goto err_radix;
+		goto err_xa;
 	}
 
 	cq_context = mailbox->buf;
@@ -404,7 +398,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	if (err)
-		goto err_radix;
+		goto err_xa;
 
 	cq->cons_index = 0;
 	cq->arm_sn     = 1;
@@ -420,10 +414,8 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	cq->irq = priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(vector)].irq;
 	return 0;
 
-err_radix:
-	spin_lock(&cq_table->lock);
-	radix_tree_delete(&cq_table->tree, cq->cqn);
-	spin_unlock(&cq_table->lock);
+err_xa:
+	xa_erase(&cq_table->array, cq->cqn);
 
 err_icm:
 	mlx4_cq_free_icm(dev, cq->cqn);
@@ -442,9 +434,7 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 	if (err)
 		mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n", err, cq->cqn);
 
-	spin_lock(&cq_table->lock);
-	radix_tree_delete(&cq_table->tree, cq->cqn);
-	spin_unlock(&cq_table->lock);
+	xa_erase(&cq_table->array, cq->cqn);
 
 	synchronize_irq(priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq);
 	if (priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq !=
@@ -464,8 +454,7 @@ int mlx4_init_cq_table(struct mlx4_dev *dev)
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	int err;
 
-	spin_lock_init(&cq_table->lock);
-	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
+	xa_init(&cq_table->array);
 	if (mlx4_is_slave(dev))
 		return 0;
 
@@ -481,6 +470,5 @@ void mlx4_cleanup_cq_table(struct mlx4_dev *dev)
 {
 	if (mlx4_is_slave(dev))
 		return;
-	/* Nothing to do to clean up radix_tree */
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->cq_table.bitmap);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 23f1b5b512c2..a40a9a259adb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -678,8 +678,7 @@ struct mlx4_mr_table {
 
 struct mlx4_cq_table {
 	struct mlx4_bitmap	bitmap;
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
+	struct xarray		array;
 	struct mlx4_icm_table	table;
 	struct mlx4_icm_table	cmpt_table;
 };
-- 
2.23.0.rc1

