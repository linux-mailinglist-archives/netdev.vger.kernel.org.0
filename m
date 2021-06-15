Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8330C3A7589
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFOEDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhFOEDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B146008E;
        Tue, 15 Jun 2021 04:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729693;
        bh=MBTTVE7lSuniov8eSFBmtuduY2wOUCKZOkXS06GuJuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFS2qS/jXqghhGbSDedaEfw47r+B8yTemiBxMKCJKoZD4jSWZ56qPiKlbAhOXPVed
         7QYuOD3hp1CwobK1B/6NrMnZVEsXKjX8KebKxdQvQWkkSUk5KTOmcq/l+kRB83Nwr2
         RaS/PZnNJUzY4pwnpcE9Zky4XuDR9GQBE3nEw9/3M7Nau/83zrl0zdghcyNt0FOlld
         /paSRSIHW18GJ+WIQZENNpnJs7xdeOTRdDKeeilDJhmEWJqa1m9x3bLOdSw8fltFO2
         +vVXrg+YrZ/5MWlWOQcH/ktrfDDqSp+RAAXxJqk0jXaUNEYUtPAGGoJOsAee2k9qVv
         KhEOOuegLAHBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Allocating a pool of MSI-X vectors for SFs
Date:   Mon, 14 Jun 2021 21:01:20 -0700
Message-Id: <20210615040123.287101-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

SFs (Sub Functions) currently use IRQs from the global IRQ table their
parent Physical Function have. In order to better scale, we need to
allocate more IRQs and share them between different SFs.

Driver will maintain 3 separated irq pools:
1. A pool that serve the PF consumer (PF's netdev, rdma stacks), similar
to what the driver had before this patch. i.e, this pool will share irqs
between rdma and netev, and will keep the irq indexes and allocation
order. The last is important for PF netdev rmap (aRFS).

2. A pool of control IRQs for SFs. The size of this pool is the number
of SFs that can be created divided by SFS_PER_IRQ. This pool will serve
the control path EQs of the SFs.

3. A pool of completion data path IRQs for SFs transport queues. The
size of this pool is:
num_irqs_allocated - pf_pool_size - sf_ctrl_pool_size.
This pool will served netdev and rdma stacks. Moreover, rmap is not
supported on SFs.

Sharing methodology of the SFs pools is explained in the next patch.

Important note: rmap is not supported on SFs because rmap mapping cannot
function correctly for IRQs that are shared for different core/netdev RX
rings.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  12 +-
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 292 ++++++++++++------
 3 files changed, 209 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 96649dbcef39..b8ac9f58d2b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -471,14 +471,7 @@ static int create_async_eq(struct mlx5_core_dev *dev,
 	int err;
 
 	mutex_lock(&eq_table->lock);
-	/* Async EQs must share irq index 0 */
-	if (param->irq_index != 0) {
-		err = -EINVAL;
-		goto unlock;
-	}
-
 	err = create_map_eq(dev, eq, param);
-unlock:
 	mutex_unlock(&eq_table->lock);
 	return err;
 }
@@ -996,8 +989,11 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 
 	eq_table->num_comp_eqs =
 		min_t(int,
-		      mlx5_irq_get_num_comp(eq_table->irq_table),
+		      mlx5_irq_table_get_num_comp(eq_table->irq_table),
 		      num_eqs - MLX5_MAX_ASYNC_EQS);
+	if (mlx5_core_is_sf(dev))
+		eq_table->num_comp_eqs = min_t(int, eq_table->num_comp_eqs,
+					       MLX5_COMP_EQS_PER_SF);
 
 	err = create_async_eqs(dev);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 63b33cd37f7c..48656e8624a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -6,13 +6,17 @@
 
 #include <linux/mlx5/driver.h>
 
+#define MLX5_COMP_EQS_PER_SF 8
+
+#define MLX5_IRQ_EQ_CTRL (0)
+
 struct mlx5_irq;
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_irq_table_create(struct mlx5_core_dev *dev);
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
-int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
+int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table);
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
 
 int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index a6acc78bd1a3..4f18fbcf7ccd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -7,11 +7,19 @@
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
+#include "sf/sf.h"
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
 
 #define MLX5_MAX_IRQ_NAME (32)
+/* max irq_index is 255. three chars */
+#define MLX5_MAX_IRQ_IDX_CHARS (3)
+
+#define MLX5_SFS_PER_CTRL_IRQ 64
+#define MLX5_IRQ_CTRL_SF_MAX 8
+/* min num of vectores for SFs to be enabled */
+#define MLX5_IRQ_VEC_COMP_BASE_SF 2
 
 struct mlx5_irq {
 	u32 index;
@@ -20,41 +28,21 @@ struct mlx5_irq {
 	char name[MLX5_MAX_IRQ_NAME];
 	struct kref kref;
 	int irqn;
-	struct mlx5_irq_table *table;
+	struct mlx5_irq_pool *pool;
 };
 
-struct mlx5_irq_table {
+struct mlx5_irq_pool {
+	char name[MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS];
+	struct xa_limit xa_num_irqs;
 	struct xarray irqs;
-	int nvec;
+	struct mlx5_core_dev *dev;
 };
 
-int mlx5_irq_table_init(struct mlx5_core_dev *dev)
-{
-	struct mlx5_irq_table *irq_table;
-
-	if (mlx5_core_is_sf(dev))
-		return 0;
-
-	irq_table = kvzalloc(sizeof(*irq_table), GFP_KERNEL);
-	if (!irq_table)
-		return -ENOMEM;
-
-	dev->priv.irq_table = irq_table;
-	return 0;
-}
-
-void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
-{
-	if (mlx5_core_is_sf(dev))
-		return;
-
-	kvfree(dev->priv.irq_table);
-}
-
-int mlx5_irq_get_num_comp(struct mlx5_irq_table *table)
-{
-	return table->nvec - MLX5_IRQ_VEC_COMP_BASE;
-}
+struct mlx5_irq_table {
+	struct mlx5_irq_pool *pf_pool;
+	struct mlx5_irq_pool *sf_ctrl_pool;
+	struct mlx5_irq_pool *sf_comp_pool;
+};
 
 /**
  * mlx5_get_default_msix_vec_count - Get the default number of MSI-X vectors
@@ -144,9 +132,9 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 static void irq_release(struct kref *kref)
 {
 	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
-	struct mlx5_irq_table *table =  irq->table;
+	struct mlx5_irq_pool *pool = irq->pool;
 
-	xa_erase(&table->irqs, irq->index);
+	xa_erase(&pool->irqs, irq->index);
 	/* free_irq requires that affinity and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
@@ -162,38 +150,21 @@ static void irq_put(struct mlx5_irq *irq)
 	kref_put(&irq->kref, irq_release);
 }
 
-int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
-{
-	int err;
-
-	err = kref_get_unless_zero(&irq->kref);
-	if (WARN_ON_ONCE(!err))
-		/* Something very bad happens here, we are enabling EQ
-		 * on non-existing IRQ.
-		 */
-		return -ENOENT;
-	err = atomic_notifier_chain_register(&irq->nh, nb);
-	if (err)
-		irq_put(irq);
-	return err;
-}
-
-int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
-{
-	irq_put(irq);
-	return atomic_notifier_chain_unregister(&irq->nh, nb);
-}
-
 static irqreturn_t irq_int_handler(int irq, void *nh)
 {
 	atomic_notifier_call_chain(nh, 0, NULL);
 	return IRQ_HANDLED;
 }
 
+static void irq_sf_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
+{
+	snprintf(name, MLX5_MAX_IRQ_NAME, "%s%d", pool->name, vecidx);
+}
+
 static void irq_set_name(char *name, int vecidx)
 {
-	if (!vecidx) {
-		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async");
+	if (vecidx == 0) {
+		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async%d", vecidx);
 		return;
 	}
 
@@ -201,11 +172,10 @@ static void irq_set_name(char *name, int vecidx)
 		 vecidx - MLX5_IRQ_VEC_COMP_BASE);
 }
 
-static struct mlx5_irq *irq_request(struct mlx5_core_dev *dev, int i)
+static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 {
-	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
+	struct mlx5_core_dev *dev = pool->dev;
 	char name[MLX5_MAX_IRQ_NAME];
-	struct xa_limit xa_num_irqs;
 	struct mlx5_irq *irq;
 	int err;
 
@@ -213,7 +183,10 @@ static struct mlx5_irq *irq_request(struct mlx5_core_dev *dev, int i)
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 	irq->irqn = pci_irq_vector(dev->pdev, i);
-	irq_set_name(name, i);
+	if (!pool->name[0])
+		irq_set_name(name, i);
+	else
+		irq_sf_set_name(pool, name, i);
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
 	snprintf(irq->name, MLX5_MAX_IRQ_NAME,
 		 "%s@pci:%s", name, pci_name(dev->pdev));
@@ -228,16 +201,14 @@ static struct mlx5_irq *irq_request(struct mlx5_core_dev *dev, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
-	xa_num_irqs.min = 0;
-	xa_num_irqs.max = table->nvec;
-	err = xa_alloc(&table->irqs, &irq->index, irq, xa_num_irqs,
+	err = xa_alloc(&pool->irqs, &irq->index, irq, pool->xa_num_irqs,
 		       GFP_KERNEL);
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc xa entry for irq(%u). err = %d\n",
 			      irq->index, err);
 		goto err_xa;
 	}
-	irq->table = table;
+	irq->pool = pool;
 	kref_init(&irq->kref);
 	return irq;
 err_xa:
@@ -249,6 +220,33 @@ static struct mlx5_irq *irq_request(struct mlx5_core_dev *dev, int i)
 	return ERR_PTR(err);
 }
 
+int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
+{
+	int err;
+
+	err = kref_get_unless_zero(&irq->kref);
+	if (WARN_ON_ONCE(!err))
+		/* Something very bad happens here, we are enabling EQ
+		 * on non-existing IRQ.
+		 */
+		return -ENOENT;
+	err = atomic_notifier_chain_register(&irq->nh, nb);
+	if (err)
+		irq_put(irq);
+	return err;
+}
+
+int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
+{
+	irq_put(irq);
+	return atomic_notifier_chain_unregister(&irq->nh, nb);
+}
+
+struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
+{
+	return irq->mask;
+}
+
 /**
  * mlx5_irq_release - release an IRQ back to the system.
  * @irq: irq to be released.
@@ -272,14 +270,17 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
 				  struct cpumask *affinity)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
+	struct mlx5_irq_pool *pool;
 	struct mlx5_irq *irq;
 
-	irq = xa_load(&irq_table->irqs, vecidx);
+	pool = irq_table->pf_pool;
+
+	irq = xa_load(&pool->irqs, vecidx);
 	if (irq) {
 		kref_get(&irq->kref);
 		return irq;
 	}
-	irq = irq_request(dev, vecidx);
+	irq = irq_request(pool, vecidx);
 	if (IS_ERR(irq))
 		return irq;
 	cpumask_copy(irq->mask, affinity);
@@ -287,53 +288,162 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
 	return irq;
 }
 
-struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
+/* irq_pool API */
+
+static struct mlx5_irq_pool *
+irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name)
 {
-	return irq->mask;
+	struct mlx5_irq_pool *pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
+
+	if (!pool)
+		return ERR_PTR(-ENOMEM);
+	pool->dev = dev;
+	xa_init_flags(&pool->irqs, XA_FLAGS_ALLOC);
+	pool->xa_num_irqs.min = start;
+	pool->xa_num_irqs.max = start + size - 1;
+	if (name)
+		snprintf(pool->name, MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS,
+			 name);
+	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
+		      name, size, start);
+	return pool;
+}
+
+static void irq_pool_free(struct mlx5_irq_pool *pool)
+{
+	struct mlx5_irq *irq;
+	unsigned long index;
+
+	xa_for_each(&pool->irqs, index, irq)
+		irq_release(&irq->kref);
+	xa_destroy(&pool->irqs);
+	kvfree(pool);
+}
+
+static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
+{
+	struct mlx5_irq_table *table = dev->priv.irq_table;
+	int num_sf_ctrl_by_msix;
+	int num_sf_ctrl_by_sfs;
+	int num_sf_ctrl;
+	int err;
+
+	/* init pf_pool */
+	table->pf_pool = irq_pool_alloc(dev, 0, pf_vec, NULL);
+	if (IS_ERR(table->pf_pool))
+		return PTR_ERR(table->pf_pool);
+	if (!mlx5_sf_max_functions(dev))
+		return 0;
+	if (sf_vec < MLX5_IRQ_VEC_COMP_BASE_SF) {
+		mlx5_core_err(dev, "Not enught IRQs for SFs. SF may run at lower performance\n");
+		return 0;
+	}
+
+	/* init sf_ctrl_pool */
+	num_sf_ctrl_by_msix = DIV_ROUND_UP(sf_vec, MLX5_COMP_EQS_PER_SF);
+	num_sf_ctrl_by_sfs = DIV_ROUND_UP(mlx5_sf_max_functions(dev),
+					  MLX5_SFS_PER_CTRL_IRQ);
+	num_sf_ctrl = min_t(int, num_sf_ctrl_by_msix, num_sf_ctrl_by_sfs);
+	num_sf_ctrl = min_t(int, MLX5_IRQ_CTRL_SF_MAX, num_sf_ctrl);
+	table->sf_ctrl_pool = irq_pool_alloc(dev, pf_vec, num_sf_ctrl,
+					     "mlx5_sf_ctrl");
+	if (IS_ERR(table->sf_ctrl_pool)) {
+		err = PTR_ERR(table->sf_ctrl_pool);
+		goto err_pf;
+	}
+	/* init sf_comp_pool */
+	table->sf_comp_pool = irq_pool_alloc(dev, pf_vec + num_sf_ctrl,
+					     sf_vec - num_sf_ctrl, "mlx5_sf_comp");
+	if (IS_ERR(table->sf_comp_pool)) {
+		err = PTR_ERR(table->sf_comp_pool);
+		goto err_sf_ctrl;
+	}
+	return 0;
+err_sf_ctrl:
+	irq_pool_free(table->sf_ctrl_pool);
+err_pf:
+	irq_pool_free(table->pf_pool);
+	return err;
+}
+
+static void irq_pools_destroy(struct mlx5_irq_table *table)
+{
+	if (table->sf_ctrl_pool) {
+		irq_pool_free(table->sf_comp_pool);
+		irq_pool_free(table->sf_ctrl_pool);
+	}
+	irq_pool_free(table->pf_pool);
+}
+
+/* irq_table API */
+
+int mlx5_irq_table_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_irq_table *irq_table;
+
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
+	irq_table = kvzalloc(sizeof(*irq_table), GFP_KERNEL);
+	if (!irq_table)
+		return -ENOMEM;
+
+	dev->priv.irq_table = irq_table;
+	return 0;
+}
+
+void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
+{
+	if (mlx5_core_is_sf(dev))
+		return;
+
+	kvfree(dev->priv.irq_table);
+}
+
+int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
+{
+	return table->pf_pool->xa_num_irqs.max - table->pf_pool->xa_num_irqs.min;
 }
 
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 {
-	struct mlx5_priv *priv = &dev->priv;
-	struct mlx5_irq_table *table = priv->irq_table;
 	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
-	int nvec;
+	int total_vec;
+	int pf_vec;
 	int err;
 
 	if (mlx5_core_is_sf(dev))
 		return 0;
 
-	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
-	       MLX5_IRQ_VEC_COMP_BASE;
-	nvec = min_t(int, nvec, num_eqs);
-	if (nvec <= MLX5_IRQ_VEC_COMP_BASE)
+	pf_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
+		 MLX5_IRQ_VEC_COMP_BASE;
+	pf_vec = min_t(int, pf_vec, num_eqs);
+	if (pf_vec <= MLX5_IRQ_VEC_COMP_BASE)
 		return -ENOMEM;
 
-	xa_init_flags(&table->irqs, XA_FLAGS_ALLOC);
+	total_vec = pf_vec;
+	if (mlx5_sf_max_functions(dev))
+		total_vec += MLX5_IRQ_CTRL_SF_MAX +
+			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
 
-	nvec = pci_alloc_irq_vectors(dev->pdev, MLX5_IRQ_VEC_COMP_BASE + 1,
-				     nvec, PCI_IRQ_MSIX);
-	if (nvec < 0) {
-		err = nvec;
-		goto err_free_irq;
-	}
+	total_vec = pci_alloc_irq_vectors(dev->pdev, MLX5_IRQ_VEC_COMP_BASE + 1,
+					  total_vec, PCI_IRQ_MSIX);
+	if (total_vec < 0)
+		return total_vec;
+	pf_vec = min(pf_vec, total_vec);
 
-	table->nvec = nvec;
-
-	return 0;
+	err = irq_pools_init(dev, total_vec - pf_vec, pf_vec);
+	if (err)
+		pci_free_irq_vectors(dev->pdev);
 
-err_free_irq:
-	xa_destroy(&table->irqs);
 	return err;
 }
 
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
-	struct mlx5_irq *irq;
-	unsigned long index;
 
 	if (mlx5_core_is_sf(dev))
 		return;
@@ -341,10 +451,8 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	/* There are cases where IRQs still will be in used when we reaching
 	 * to here. Hence, making sure all the irqs are realeased.
 	 */
-	xa_for_each(&table->irqs, index, irq)
-		irq_release(&irq->kref);
+	irq_pools_destroy(table);
 	pci_free_irq_vectors(dev->pdev);
-	xa_destroy(&table->irqs);
 }
 
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev)
-- 
2.31.1

