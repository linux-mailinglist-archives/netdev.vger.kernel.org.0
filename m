Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE93A758D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFOEEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFOEDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1EE61416;
        Tue, 15 Jun 2021 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729695;
        bh=KWr/Ivt5kiCZy1zCL6lMwm7cAvpLgdsreK9UpLtZFWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6Zny4vZe9mhMt98qLzw6o6bRH9XFu4kTAQ9RMCINOgYbn3s55D2c3RHLLCfCINKh
         0Y3XqygGy5FxdZDkNqn/+B4XkGcw02ubrvWtSU7e6FucGyjHM17hXmZN5eTy9wUD9/
         88tznxTmFXzafA6XbwhbQMXiuPvAjZ+7TbUSPVjoiD2d8liCuWOKPPaYImzrC4DszH
         dvwzML0fxz8YKMP7NaJl6qKqbepLYQzwACYYbj7oaWwk9NEzSCzgwCXI/uLcUTo8Y0
         IjMRvsxKthaOaKbobYbFLN6uas6qWwrTEehq6xbsJipBM5ixlQ3psNL3dmfc1EeWxO
         2Srzrddugfh1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Round-Robin EQs over IRQs
Date:   Mon, 14 Jun 2021 21:01:23 -0700
Message-Id: <20210615040123.287101-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Whenever users provided affinity for an EQ creation request, map the
EQ to a matching IRQ.
Matching IRQ=IRQ with the same affinity and type (completion/control) of
the EQ created.

This mapping is being done in agressive dedicated IRQ allocation scheme,
which described bellow.

First, we check whether there is a matching IRQ that his min threshold
is not exhausted.
   - min_eqs_threshold = 3 for control EQ.
   - min_eqs_threshold = 1 for completion EQ.
In case no matching IRQ was found, try to request a new IRQ.
In case we can't request a new IRQ, reuse least-used matching IRQ.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c              |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  14 +-
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 197 ++++++++++++++++--
 4 files changed, 189 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 8f88b044ccbc..1338c11fd121 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1559,8 +1559,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	}
 
 	eq->irq_nb.notifier_call = mlx5_ib_eq_pf_int;
-	param = (struct mlx5_eq_param){
-		.irq_index = 0,
+	param = (struct mlx5_eq_param) {
 		.nent = MLX5_IB_NUM_PF_EQE,
 	};
 	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_FAULT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index b8ac9f58d2b5..7e5b3826eae5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -263,7 +263,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	u8 log_eq_stride = ilog2(MLX5_EQE_SIZE);
 	struct mlx5_priv *priv = &dev->priv;
-	u8 vecidx = param->irq_index;
+	u16 vecidx = param->irq_index;
 	__be64 *pas;
 	void *eqc;
 	int inlen;
@@ -292,6 +292,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		goto err_buf;
 	}
 
+	vecidx = mlx5_irq_get_index(eq->irq);
 	inlen = MLX5_ST_SZ_BYTES(create_eq_in) +
 		MLX5_FLD_SZ_BYTES(create_eq_in, pas[0]) * eq->frag_buf.npages;
 
@@ -629,7 +630,6 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = 0,
 		.nent = MLX5_NUM_CMD_EQE,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
@@ -642,7 +642,6 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = 0,
 		.nent = MLX5_NUM_ASYNC_EQE,
 	};
 
@@ -652,7 +651,6 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 		goto err2;
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = 0,
 		.nent = /* TODO: sriov max_vf + */ 1,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST,
 	};
@@ -985,15 +983,19 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
+	int max_eqs_sf;
 	int err;
 
 	eq_table->num_comp_eqs =
 		min_t(int,
 		      mlx5_irq_table_get_num_comp(eq_table->irq_table),
 		      num_eqs - MLX5_MAX_ASYNC_EQS);
-	if (mlx5_core_is_sf(dev))
+	if (mlx5_core_is_sf(dev)) {
+		max_eqs_sf = min_t(int, MLX5_COMP_EQS_PER_SF,
+				   mlx5_irq_table_get_sfs_vec(eq_table->irq_table));
 		eq_table->num_comp_eqs = min_t(int, eq_table->num_comp_eqs,
-					       MLX5_COMP_EQS_PER_SF);
+					       max_eqs_sf);
+	}
 
 	err = create_async_eqs(dev);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 48656e8624a9..abd024173c42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -17,17 +17,19 @@ void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_irq_table_create(struct mlx5_core_dev *dev);
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
 int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table);
+int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table);
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
 
 int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
 			    int msix_vec_count);
 int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 
-struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 				  struct cpumask *affinity);
 void mlx5_irq_release(struct mlx5_irq *irq);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
+int mlx5_irq_get_index(struct mlx5_irq *irq);
 
 #endif /* __MLX5_IRQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 4f18fbcf7ccd..27de8da8edf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -7,7 +7,7 @@
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
-#include "sf/sf.h"
+#include "lib/sf.h"
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
@@ -21,6 +21,12 @@
 /* min num of vectores for SFs to be enabled */
 #define MLX5_IRQ_VEC_COMP_BASE_SF 2
 
+#define MLX5_EQ_SHARE_IRQ_MAX_COMP (8)
+#define MLX5_EQ_SHARE_IRQ_MAX_CTRL (UINT_MAX)
+#define MLX5_EQ_SHARE_IRQ_MIN_COMP (1)
+#define MLX5_EQ_SHARE_IRQ_MIN_CTRL (4)
+#define MLX5_EQ_REFS_PER_IRQ (2)
+
 struct mlx5_irq {
 	u32 index;
 	struct atomic_notifier_head nh;
@@ -34,7 +40,10 @@ struct mlx5_irq {
 struct mlx5_irq_pool {
 	char name[MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS];
 	struct xa_limit xa_num_irqs;
+	struct mutex lock; /* sync IRQs creations */
 	struct xarray irqs;
+	u32 max_threshold;
+	u32 min_threshold;
 	struct mlx5_core_dev *dev;
 };
 
@@ -147,7 +156,11 @@ static void irq_release(struct kref *kref)
 
 static void irq_put(struct mlx5_irq *irq)
 {
+	struct mlx5_irq_pool *pool = irq->pool;
+
+	mutex_lock(&pool->lock);
 	kref_put(&irq->kref, irq_release);
+	mutex_unlock(&pool->lock);
 }
 
 static irqreturn_t irq_int_handler(int irq, void *nh)
@@ -201,15 +214,15 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
-	err = xa_alloc(&pool->irqs, &irq->index, irq, pool->xa_num_irqs,
-		       GFP_KERNEL);
+	kref_init(&irq->kref);
+	irq->index = i;
+	err = xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc xa entry for irq(%u). err = %d\n",
 			      irq->index, err);
 		goto err_xa;
 	}
 	irq->pool = pool;
-	kref_init(&irq->kref);
 	return irq;
 err_xa:
 	free_cpumask_var(irq->mask);
@@ -247,6 +260,124 @@ struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
 	return irq->mask;
 }
 
+int mlx5_irq_get_index(struct mlx5_irq *irq)
+{
+	return irq->index;
+}
+
+/* irq_pool API */
+
+/* creating an irq from irq_pool */
+static struct mlx5_irq *irq_pool_create_irq(struct mlx5_irq_pool *pool,
+					    struct cpumask *affinity)
+{
+	struct mlx5_irq *irq;
+	u32 irq_index;
+	int err;
+
+	err = xa_alloc(&pool->irqs, &irq_index, NULL, pool->xa_num_irqs,
+		       GFP_KERNEL);
+	if (err)
+		return ERR_PTR(err);
+	irq = irq_request(pool, irq_index);
+	if (IS_ERR(irq))
+		return irq;
+	cpumask_copy(irq->mask, affinity);
+	irq_set_affinity_hint(irq->irqn, irq->mask);
+	return irq;
+}
+
+/* looking for the irq with the smallest refcount and the same affinity */
+static struct mlx5_irq *irq_pool_find_least_loaded(struct mlx5_irq_pool *pool,
+						   struct cpumask *affinity)
+{
+	int start = pool->xa_num_irqs.min;
+	int end = pool->xa_num_irqs.max;
+	struct mlx5_irq *irq = NULL;
+	struct mlx5_irq *iter;
+	unsigned long index;
+
+	lockdep_assert_held(&pool->lock);
+	xa_for_each_range(&pool->irqs, index, iter, start, end) {
+		if (!cpumask_equal(iter->mask, affinity))
+			continue;
+		if (kref_read(&iter->kref) < pool->min_threshold)
+			return iter;
+		if (!irq || kref_read(&iter->kref) <
+		    kref_read(&irq->kref))
+			irq = iter;
+	}
+	return irq;
+}
+
+/* requesting an irq from a given pool according to given affinity */
+static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
+						  struct cpumask *affinity)
+{
+	struct mlx5_irq *least_loaded_irq, *new_irq;
+
+	mutex_lock(&pool->lock);
+	least_loaded_irq = irq_pool_find_least_loaded(pool, affinity);
+	if (least_loaded_irq &&
+	    kref_read(&least_loaded_irq->kref) < pool->min_threshold)
+		goto out;
+	new_irq = irq_pool_create_irq(pool, affinity);
+	if (IS_ERR(new_irq)) {
+		if (!least_loaded_irq) {
+			mlx5_core_err(pool->dev, "Didn't find IRQ for cpu = %u\n",
+				      cpumask_first(affinity));
+			mutex_unlock(&pool->lock);
+			return new_irq;
+		}
+		/* We failed to create a new IRQ for the requested affinity,
+		 * sharing existing IRQ.
+		 */
+		goto out;
+	}
+	least_loaded_irq = new_irq;
+	goto unlock;
+out:
+	kref_get(&least_loaded_irq->kref);
+	if (kref_read(&least_loaded_irq->kref) > pool->max_threshold)
+		mlx5_core_dbg(pool->dev, "IRQ %u overloaded, pool_name: %s, %u EQs on this irq\n",
+			      least_loaded_irq->irqn, pool->name,
+			      kref_read(&least_loaded_irq->kref) / MLX5_EQ_REFS_PER_IRQ);
+unlock:
+	mutex_unlock(&pool->lock);
+	return least_loaded_irq;
+}
+
+/* requesting an irq from a given pool according to given index */
+static struct mlx5_irq *
+irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
+			struct cpumask *affinity)
+{
+	struct mlx5_irq *irq;
+
+	mutex_lock(&pool->lock);
+	irq = xa_load(&pool->irqs, vecidx);
+	if (irq) {
+		kref_get(&irq->kref);
+		goto unlock;
+	}
+	irq = irq_request(pool, vecidx);
+	if (IS_ERR(irq) || !affinity)
+		goto unlock;
+	cpumask_copy(irq->mask, affinity);
+	irq_set_affinity_hint(irq->irqn, irq->mask);
+unlock:
+	mutex_unlock(&pool->lock);
+	return irq;
+}
+
+static struct mlx5_irq_pool *find_sf_irq_pool(struct mlx5_irq_table *irq_table,
+					      int i, struct cpumask *affinity)
+{
+	if (cpumask_empty(affinity) && i == MLX5_IRQ_EQ_CTRL)
+		return irq_table->sf_ctrl_pool;
+	return irq_table->sf_comp_pool;
+}
+
 /**
  * mlx5_irq_release - release an IRQ back to the system.
  * @irq: irq to be released.
@@ -266,32 +397,40 @@ void mlx5_irq_release(struct mlx5_irq *irq)
  *
  * This function returns a pointer to IRQ, or ERR_PTR in case of error.
  */
-struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 				  struct cpumask *affinity)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 	struct mlx5_irq_pool *pool;
 	struct mlx5_irq *irq;
 
-	pool = irq_table->pf_pool;
-
-	irq = xa_load(&pool->irqs, vecidx);
-	if (irq) {
-		kref_get(&irq->kref);
-		return irq;
+	if (mlx5_core_is_sf(dev)) {
+		pool = find_sf_irq_pool(irq_table, vecidx, affinity);
+		if (!pool)
+			/* we don't have IRQs for SFs, using the PF IRQs */
+			goto pf_irq;
+		if (cpumask_empty(affinity) && !strcmp(pool->name, "mlx5_sf_comp"))
+			/* In case an SF user request IRQ with vecidx */
+			irq = irq_pool_request_vector(pool, vecidx, NULL);
+		else
+			irq = irq_pool_request_affinity(pool, affinity);
+		goto out;
 	}
-	irq = irq_request(pool, vecidx);
+pf_irq:
+	pool = irq_table->pf_pool;
+	irq = irq_pool_request_vector(pool, vecidx, affinity);
+out:
 	if (IS_ERR(irq))
 		return irq;
-	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
+	mlx5_core_dbg(dev, "irq %u mapped to cpu %*pbl, %u EQs on this irq\n",
+		      irq->irqn, cpumask_pr_args(affinity),
+		      kref_read(&irq->kref) / MLX5_EQ_REFS_PER_IRQ);
 	return irq;
 }
 
-/* irq_pool API */
-
 static struct mlx5_irq_pool *
-irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name)
+irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
+	       u32 min_threshold, u32 max_threshold)
 {
 	struct mlx5_irq_pool *pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
 
@@ -304,6 +443,9 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name)
 	if (name)
 		snprintf(pool->name, MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS,
 			 name);
+	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
+	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
+	mutex_init(&pool->lock);
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
 		      name, size, start);
 	return pool;
@@ -329,7 +471,9 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 	int err;
 
 	/* init pf_pool */
-	table->pf_pool = irq_pool_alloc(dev, 0, pf_vec, NULL);
+	table->pf_pool = irq_pool_alloc(dev, 0, pf_vec, NULL,
+					MLX5_EQ_SHARE_IRQ_MIN_COMP,
+					MLX5_EQ_SHARE_IRQ_MAX_COMP);
 	if (IS_ERR(table->pf_pool))
 		return PTR_ERR(table->pf_pool);
 	if (!mlx5_sf_max_functions(dev))
@@ -346,14 +490,18 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 	num_sf_ctrl = min_t(int, num_sf_ctrl_by_msix, num_sf_ctrl_by_sfs);
 	num_sf_ctrl = min_t(int, MLX5_IRQ_CTRL_SF_MAX, num_sf_ctrl);
 	table->sf_ctrl_pool = irq_pool_alloc(dev, pf_vec, num_sf_ctrl,
-					     "mlx5_sf_ctrl");
+					     "mlx5_sf_ctrl",
+					     MLX5_EQ_SHARE_IRQ_MIN_CTRL,
+					     MLX5_EQ_SHARE_IRQ_MAX_CTRL);
 	if (IS_ERR(table->sf_ctrl_pool)) {
 		err = PTR_ERR(table->sf_ctrl_pool);
 		goto err_pf;
 	}
 	/* init sf_comp_pool */
 	table->sf_comp_pool = irq_pool_alloc(dev, pf_vec + num_sf_ctrl,
-					     sf_vec - num_sf_ctrl, "mlx5_sf_comp");
+					     sf_vec - num_sf_ctrl, "mlx5_sf_comp",
+					     MLX5_EQ_SHARE_IRQ_MIN_COMP,
+					     MLX5_EQ_SHARE_IRQ_MAX_COMP);
 	if (IS_ERR(table->sf_comp_pool)) {
 		err = PTR_ERR(table->sf_comp_pool);
 		goto err_sf_ctrl;
@@ -455,6 +603,15 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	pci_free_irq_vectors(dev->pdev);
 }
 
+int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table)
+{
+	if (table->sf_comp_pool)
+		return table->sf_comp_pool->xa_num_irqs.max -
+			table->sf_comp_pool->xa_num_irqs.min + 1;
+	else
+		return mlx5_irq_table_get_num_comp(table);
+}
+
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev)
 {
 #ifdef CONFIG_MLX5_SF
-- 
2.31.1

