Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3414296C47
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbfHTWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v9p7uipROWW9QTJPW0kOsPR/8yXx0cxRpnlmUmMvylA=; b=MTTcBhr2nMt17w47ssc6+wiH09
        WqmFsMal35ei4k0ckHvuVXLqPc2PsjfY6+LAiFE263x0B2uN68F+k2mYcFtQXa6zSjT2yB1OV6joL
        0AvbQuI0Y0c0WT7717jkt2vO437glzymhVnlL1hkKOiALSFR7jIK508OgkoSpfHNWY+Y6x7kVBR9s
        iplW2VFQIXNpaZJEXdIififckB/zpvJPqlrKtioyipnlc7+nrQYf/PxzEHnTMtMkKekwTUMQMHpWR
        UDBcbqJjbw8o0k/AjCNuc20N/t2QxlQTm7DwoybqMfK6sYIxy/m12JjP72jB+AC91ZSY9tJ+OrH8d
        lSi+8cNQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pf-PQ; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 02/38] mlx4: Convert srq_table->tree to XArray
Date:   Tue, 20 Aug 2019 15:32:23 -0700
Message-Id: <20190820223259.22348-3-willy@infradead.org>
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

Adjust the locking to not disable interrupts; this isn't needed as all
accesses are either writes from process context or reads protected
by the RCU lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/infiniband/hw/mlx4/cq.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |  3 +--
 drivers/net/ethernet/mellanox/mlx4/srq.c  | 33 +++++++----------------
 3 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index a7d238d312f0..0d7709823b9f 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -728,7 +728,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 		u32 srq_num;
 		g_mlpath_rqpn = be32_to_cpu(cqe->g_mlpath_rqpn);
 		srq_num       = g_mlpath_rqpn & 0xffffff;
-		/* SRQ is also in the radix tree */
+		/* SRQ is also in the xarray */
 		msrq = mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
 				       srq_num);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index a40a9a259adb..b6fe22bee9f4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -698,8 +698,7 @@ struct mlx4_eq_table {
 
 struct mlx4_srq_table {
 	struct mlx4_bitmap	bitmap;
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
+	struct xarray		array;
 	struct mlx4_icm_table	table;
 	struct mlx4_icm_table	cmpt_table;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index cbe4d9746ddf..b7c4007fbc85 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -45,9 +45,7 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	struct mlx4_srq *srq;
 
-	rcu_read_lock();
-	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
-	rcu_read_unlock();
+	srq = xa_load(&srq_table->array, srqn & (dev->caps.num_srqs - 1));
 	if (srq)
 		refcount_inc(&srq->refcount);
 	else {
@@ -172,16 +170,14 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	if (err)
 		return err;
 
-	spin_lock_irq(&srq_table->lock);
-	err = radix_tree_insert(&srq_table->tree, srq->srqn, srq);
-	spin_unlock_irq(&srq_table->lock);
+	err = xa_err(xa_store(&srq_table->array, srq->srqn, srq, GFP_KERNEL));
 	if (err)
 		goto err_icm;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		err = PTR_ERR(mailbox);
-		goto err_radix;
+		goto err_xa;
 	}
 
 	srq_context = mailbox->buf;
@@ -201,17 +197,15 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	err = mlx4_SW2HW_SRQ(dev, mailbox, srq->srqn);
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	if (err)
-		goto err_radix;
+		goto err_xa;
 
 	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
 
 	return 0;
 
-err_radix:
-	spin_lock_irq(&srq_table->lock);
-	radix_tree_delete(&srq_table->tree, srq->srqn);
-	spin_unlock_irq(&srq_table->lock);
+err_xa:
+	xa_erase(&srq_table->array, srq->srqn);
 
 err_icm:
 	mlx4_srq_free_icm(dev, srq->srqn);
@@ -228,9 +222,7 @@ void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
 	if (err)
 		mlx4_warn(dev, "HW2SW_SRQ failed (%d) for SRQN %06x\n", err, srq->srqn);
 
-	spin_lock_irq(&srq_table->lock);
-	radix_tree_delete(&srq_table->tree, srq->srqn);
-	spin_unlock_irq(&srq_table->lock);
+	xa_erase(&srq_table->array, srq->srqn);
 
 	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
@@ -274,8 +266,7 @@ int mlx4_init_srq_table(struct mlx4_dev *dev)
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	int err;
 
-	spin_lock_init(&srq_table->lock);
-	INIT_RADIX_TREE(&srq_table->tree, GFP_ATOMIC);
+	xa_init(&srq_table->array);
 	if (mlx4_is_slave(dev))
 		return 0;
 
@@ -297,13 +288,7 @@ void mlx4_cleanup_srq_table(struct mlx4_dev *dev)
 struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *dev, u32 srqn)
 {
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
-	struct mlx4_srq *srq;
-
-	rcu_read_lock();
-	srq = radix_tree_lookup(&srq_table->tree,
-				srqn & (dev->caps.num_srqs - 1));
-	rcu_read_unlock();
 
-	return srq;
+	return xa_load(&srq_table->array, srqn & (dev->caps.num_srqs - 1));
 }
 EXPORT_SYMBOL_GPL(mlx4_srq_lookup);
-- 
2.23.0.rc1

