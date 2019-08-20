Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1444796C67
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731220AbfHTWeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QJieEXhpBPo0xTgXNNnMN9TmSp4JsMbyVf/4hWMqbcU=; b=lHc6V7uQuJ3OjPK1HW9UnmvAh3
        yeNgxe1pU4quxd4zEYrpo4Kxx2Fv8pemWfFL6CHTpEGjf4wtu4j5kilr57zja56zT3CeVmWU6TpMX
        khqR3b+U+OZJCnCTmLd4QFwDaL+uDtP5V3tlYOfqw+jgY9pmUsjZusbsk6FIM3IfSqc/A0FrvUVU/
        Mon+IVoLA52Mwun8F4zt1d9M3OMHGRWs/GbKJ/GRY6ZVuaY/hHUG5MZaStwhST0YTx3u4cAkNICxz
        nK6JRU8eAXNjlarKQA31wTxiA0vJu5d5ZCWjBV+rBFDYTtoU8enEgKgeojISTV/imk/3Vdon/pAHg
        5RukVszw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pr-Sw; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 04/38] mlx5: Convert cq_table to XArray
Date:   Tue, 20 Aug 2019 15:32:25 -0700
Message-Id: <20190820223259.22348-5-willy@infradead.org>
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

Since mlx5_cq_table would have shrunk down to just the xarray, eliminate
it and embed the xarray directly into mlx5_eq.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 27 ++++---------------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  7 +----
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 09d4c64b6e73..c5953f6e0a69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -113,11 +113,10 @@ static int mlx5_cmd_destroy_eq(struct mlx5_core_dev *dev, u8 eqn)
 /* caller must eventually call mlx5_cq_put on the returned cq */
 static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 {
-	struct mlx5_cq_table *table = &eq->cq_table;
-	struct mlx5_core_cq *cq = NULL;
+	struct mlx5_core_cq *cq;
 
 	rcu_read_lock();
-	cq = radix_tree_lookup(&table->tree, cqn);
+	cq = xa_load(&eq->cq_table, cqn);
 	if (likely(cq))
 		mlx5_cq_hold(cq);
 	rcu_read_unlock();
@@ -243,7 +242,6 @@ static int
 create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	      struct mlx5_eq_param *param)
 {
-	struct mlx5_cq_table *cq_table = &eq->cq_table;
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	struct mlx5_priv *priv = &dev->priv;
 	u8 vecidx = param->irq_index;
@@ -254,11 +252,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	int err;
 	int i;
 
-	/* Init CQ table */
-	memset(cq_table, 0, sizeof(*cq_table));
-	spin_lock_init(&cq_table->lock);
-	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
-
+	xa_init_flags(&eq->cq_table, XA_FLAGS_LOCK_IRQ);
 	eq->nent = roundup_pow_of_two(param->nent + MLX5_NUM_SPARE_EQE);
 	eq->cons_index = 0;
 	err = mlx5_buf_alloc(dev, eq->nent * MLX5_EQE_SIZE, &eq->buf);
@@ -378,25 +372,14 @@ static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 {
-	struct mlx5_cq_table *table = &eq->cq_table;
-	int err;
-
-	spin_lock(&table->lock);
-	err = radix_tree_insert(&table->tree, cq->cqn, cq);
-	spin_unlock(&table->lock);
-
-	return err;
+	return xa_err(xa_store(&eq->cq_table, cq->cqn, cq, GFP_KERNEL));
 }
 
 void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 {
-	struct mlx5_cq_table *table = &eq->cq_table;
 	struct mlx5_core_cq *tmp;
 
-	spin_lock(&table->lock);
-	tmp = radix_tree_delete(&table->tree, cq->cqn);
-	spin_unlock(&table->lock);
-
+	tmp = xa_erase(&eq->cq_table, cq->cqn);
 	if (!tmp) {
 		mlx5_core_dbg(eq->dev, "cq 0x%x not found in eq 0x%x tree\n",
 			      eq->eqn, cq->cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4be4d2d36218..a342cf78120e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -16,14 +16,9 @@ struct mlx5_eq_tasklet {
 	spinlock_t            lock; /* lock completion tasklet list */
 };
 
-struct mlx5_cq_table {
-	spinlock_t              lock;	/* protect radix tree */
-	struct radix_tree_root  tree;
-};
-
 struct mlx5_eq {
 	struct mlx5_core_dev    *dev;
-	struct mlx5_cq_table    cq_table;
+	struct xarray		cq_table;
 	__be32 __iomem	        *doorbell;
 	u32                     cons_index;
 	struct mlx5_frag_buf    buf;
-- 
2.23.0.rc1

