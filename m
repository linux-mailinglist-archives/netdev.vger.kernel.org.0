Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3473A758A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhFOED5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhFOEDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E84600D4;
        Tue, 15 Jun 2021 04:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729693;
        bh=SlCHA+dsv2AUlstqEZWMCCTRiPi5ZBZnTVoGFCNb+z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUnzGzvgHBqPFzYFXzRHNPomSmG44BnJtXgWJTlj4I/6kxrqP89Kr1ZYHvyvxk6hi
         vC0pDEJ2dVQegfaOYo4YhwKXNXYHLh1aF0rHqQlhFZRYnn/dhQRzcltAH4ynuSt9ZW
         YONXxQ1YTspVWdWinblBaQ7CWY2nd7Xa43CSL+H8UA/lUAaTNerbx2UhwE8pqaqp6j
         vT9IhYtk2u2Sl4I2GECUJerV01uQBSIRX/f0QfIad62pMnqeqHF9WkaZrBOfOkY91r
         LwQIOvHKvyk1QdqLo9qsANEVXw4ej03wOaYtTIKBGTWoNMo2h1FUZpf+rA53SZyaZ/
         CV5norEv2riWA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Change IRQ storage logic from static to dynamic
Date:   Mon, 14 Jun 2021 21:01:19 -0700
Message-Id: <20210615040123.287101-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Store newly created IRQs in the xarray DB instead of a static array,
so we will be able to store only IRQs which are being used.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 12 ++-
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 79 +++++++++++--------
 3 files changed, 58 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 898ae3d47f20..96649dbcef39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -892,10 +892,16 @@ EXPORT_SYMBOL(mlx5_comp_vectors_count);
 struct cpumask *
 mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
 {
-	int vecidx = vector + MLX5_IRQ_VEC_COMP_BASE;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	struct mlx5_eq_comp *eq, *n;
+	int i = 0;
+
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		if (i++ == vector)
+			break;
+	}
 
-	return mlx5_irq_get_affinity_mask(dev->priv.eq_table->irq_table,
-					  vecidx);
+	return mlx5_irq_get_affinity_mask(eq->core.irq);
 }
 EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index d4be79884cb4..63b33cd37f7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -24,7 +24,6 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
 void mlx5_irq_release(struct mlx5_irq *irq);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
-struct cpumask *
-mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
+struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
 
 #endif /* __MLX5_IRQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 149d6db9ee0e..a6acc78bd1a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -14,15 +14,17 @@
 #define MLX5_MAX_IRQ_NAME (32)
 
 struct mlx5_irq {
+	u32 index;
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
 	struct kref kref;
 	int irqn;
+	struct mlx5_irq_table *table;
 };
 
 struct mlx5_irq_table {
-	struct mlx5_irq *irq;
+	struct xarray irqs;
 	int nvec;
 };
 
@@ -54,13 +56,6 @@ int mlx5_irq_get_num_comp(struct mlx5_irq_table *table)
 	return table->nvec - MLX5_IRQ_VEC_COMP_BASE;
 }
 
-static struct mlx5_irq *mlx5_irq_get(struct mlx5_core_dev *dev, int vecidx)
-{
-	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
-
-	return &irq_table->irq[vecidx];
-}
-
 /**
  * mlx5_get_default_msix_vec_count - Get the default number of MSI-X vectors
  *                                   to be ssigned to each VF.
@@ -149,7 +144,9 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 static void irq_release(struct kref *kref)
 {
 	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
+	struct mlx5_irq_table *table =  irq->table;
 
+	xa_erase(&table->irqs, irq->index);
 	/* free_irq requires that affinity and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
@@ -157,6 +154,7 @@ static void irq_release(struct kref *kref)
 	irq_set_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
 	free_irq(irq->irqn, &irq->nh);
+	kfree(irq);
 }
 
 static void irq_put(struct mlx5_irq *irq)
@@ -203,13 +201,17 @@ static void irq_set_name(char *name, int vecidx)
 		 vecidx - MLX5_IRQ_VEC_COMP_BASE);
 }
 
-static int irq_request(struct mlx5_core_dev *dev, int i)
+static struct mlx5_irq *irq_request(struct mlx5_core_dev *dev, int i)
 {
+	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
 	char name[MLX5_MAX_IRQ_NAME];
+	struct xa_limit xa_num_irqs;
 	struct mlx5_irq *irq;
 	int err;
 
-	irq = mlx5_irq_get(dev, i);
+	irq = kzalloc(sizeof(*irq), GFP_KERNEL);
+	if (!irq)
+		return ERR_PTR(-ENOMEM);
 	irq->irqn = pci_irq_vector(dev->pdev, i);
 	irq_set_name(name, i);
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
@@ -226,15 +228,25 @@ static int irq_request(struct mlx5_core_dev *dev, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
+	xa_num_irqs.min = 0;
+	xa_num_irqs.max = table->nvec;
+	err = xa_alloc(&table->irqs, &irq->index, irq, xa_num_irqs,
+		       GFP_KERNEL);
+	if (err) {
+		mlx5_core_err(dev, "Failed to alloc xa entry for irq(%u). err = %d\n",
+			      irq->index, err);
+		goto err_xa;
+	}
+	irq->table = table;
 	kref_init(&irq->kref);
-	return 0;
-
+	return irq;
+err_xa:
+	free_cpumask_var(irq->mask);
 err_cpumask:
 	free_irq(irq->irqn, &irq->nh);
 err_req_irq:
-	if (i != 0)
-		irq_set_affinity_notifier(irq->irqn, NULL);
-	return err;
+	kfree(irq);
+	return ERR_PTR(err);
 }
 
 /**
@@ -259,25 +271,25 @@ void mlx5_irq_release(struct mlx5_irq *irq)
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
 				  struct cpumask *affinity)
 {
-	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
-	struct mlx5_irq *irq = &table->irq[vecidx];
-	int ret;
+	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
+	struct mlx5_irq *irq;
 
-	ret = kref_get_unless_zero(&irq->kref);
-	if (ret)
+	irq = xa_load(&irq_table->irqs, vecidx);
+	if (irq) {
+		kref_get(&irq->kref);
+		return irq;
+	}
+	irq = irq_request(dev, vecidx);
+	if (IS_ERR(irq))
 		return irq;
-	ret = irq_request(dev, vecidx);
-	if (ret)
-		return ERR_PTR(ret);
 	cpumask_copy(irq->mask, affinity);
 	irq_set_affinity_hint(irq->irqn, irq->mask);
 	return irq;
 }
 
-struct cpumask *
-mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx)
+struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
 {
-	return irq_table->irq[vecidx].mask;
+	return irq->mask;
 }
 
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
@@ -299,9 +311,7 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (nvec <= MLX5_IRQ_VEC_COMP_BASE)
 		return -ENOMEM;
 
-	table->irq = kcalloc(nvec, sizeof(*table->irq), GFP_KERNEL);
-	if (!table->irq)
-		return -ENOMEM;
+	xa_init_flags(&table->irqs, XA_FLAGS_ALLOC);
 
 	nvec = pci_alloc_irq_vectors(dev->pdev, MLX5_IRQ_VEC_COMP_BASE + 1,
 				     nvec, PCI_IRQ_MSIX);
@@ -315,19 +325,26 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	return 0;
 
 err_free_irq:
-	kfree(table->irq);
+	xa_destroy(&table->irqs);
 	return err;
 }
 
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
+	struct mlx5_irq *irq;
+	unsigned long index;
 
 	if (mlx5_core_is_sf(dev))
 		return;
 
+	/* There are cases where IRQs still will be in used when we reaching
+	 * to here. Hence, making sure all the irqs are realeased.
+	 */
+	xa_for_each(&table->irqs, index, irq)
+		irq_release(&irq->kref);
 	pci_free_irq_vectors(dev->pdev);
-	kfree(table->irq);
+	xa_destroy(&table->irqs);
 }
 
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev)
-- 
2.31.1

