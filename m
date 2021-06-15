Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4223A7588
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhFOEDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhFOEDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8494E6141D;
        Tue, 15 Jun 2021 04:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729692;
        bh=2EXBU977pIy0pSoyT78mm6Z8HJvDZt1pCIHR3an2VBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRo2q+/SmkrvAPpJJYpI8ZzNGwoDaN8FzyLUSAl8q2dynXzUIxwhkFSM8+Wd+6LQQ
         wPXdSzc9jDpNlfyZtBBqzInCXYe08Qey+h/K2wZTxH8WI4Qe76zocAlR+ZtiwzHWiT
         JeQhGXTQyoffsxkvlUYZ87tV0kIZ5S19P7pAUekVl8wyVgNdTPVV+Wsbn1otCA4eRq
         CnmIVijy2mzzo+VImA33DEMJlNNONdT/gntEu7evMT47zntXfjk9RJUjIZX+F9LR6n
         yhd1ng/U7Hpaqoby4juVY7En2bc3VlEX7zQqEInRjCx9unU2rzQbAPg7BNBzToH0Tb
         qabKF1xprXpkg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Moving rmap logic to EQs
Date:   Mon, 14 Jun 2021 21:01:18 -0700
Message-Id: <20210615040123.287101-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

IRQs are being simplified in order to ease their sharing and any feature
specific object will be moved to upper layer.
Hence we move rmap object into eq_table.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 67 ++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  1 -
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 84 +++----------------
 3 files changed, 78 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index ef0fe499eaed..898ae3d47f20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -58,6 +58,9 @@ struct mlx5_eq_table {
 	struct mutex            lock; /* sync async eqs creations */
 	int			num_comp_eqs;
 	struct mlx5_irq_table	*irq_table;
+#ifdef CONFIG_RFS_ACCEL
+	struct cpu_rmap		*rmap;
+#endif
 };
 
 #define MLX5_ASYNC_EVENT_MASK ((1ull << MLX5_EVENT_TYPE_PATH_MIG)	    | \
@@ -899,7 +902,7 @@ EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
 #ifdef CONFIG_RFS_ACCEL
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev)
 {
-	return mlx5_irq_get_rmap(dev->priv.eq_table->irq_table);
+	return dev->priv.eq_table->rmap;
 }
 #endif
 
@@ -916,12 +919,57 @@ struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn)
 	return ERR_PTR(-ENOENT);
 }
 
+static void clear_rmap(struct mlx5_core_dev *dev)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+
+	free_irq_cpu_rmap(eq_table->rmap);
+#endif
+}
+
+static int set_rmap(struct mlx5_core_dev *mdev)
+{
+	int err = 0;
+#ifdef CONFIG_RFS_ACCEL
+	struct mlx5_eq_table *eq_table = mdev->priv.eq_table;
+	int vecidx;
+
+	eq_table->rmap = alloc_irq_cpu_rmap(eq_table->num_comp_eqs);
+	if (!eq_table->rmap) {
+		err = -ENOMEM;
+		mlx5_core_err(mdev, "Failed to allocate cpu_rmap. err %d", err);
+		goto err_out;
+	}
+
+	vecidx = MLX5_IRQ_VEC_COMP_BASE;
+	for (; vecidx < eq_table->num_comp_eqs + MLX5_IRQ_VEC_COMP_BASE;
+	     vecidx++) {
+		err = irq_cpu_rmap_add(eq_table->rmap,
+				       pci_irq_vector(mdev->pdev, vecidx));
+		if (err) {
+			mlx5_core_err(mdev, "irq_cpu_rmap_add failed. err %d",
+				      err);
+			goto err_irq_cpu_rmap_add;
+		}
+	}
+	return 0;
+
+err_irq_cpu_rmap_add:
+	clear_rmap(mdev);
+err_out:
+#endif
+	return err;
+}
+
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 
 	mutex_lock(&table->lock); /* sync with create/destroy_async_eq */
+	if (!mlx5_core_is_sf(dev))
+		clear_rmap(dev);
 	mlx5_irq_table_destroy(dev);
 	mutex_unlock(&table->lock);
 }
@@ -951,6 +999,18 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 		goto err_async_eqs;
 	}
 
+	if (!mlx5_core_is_sf(dev)) {
+		/* rmap is a mapping between irq number and queue number.
+		 * each irq can be assign only to a single rmap.
+		 * since SFs share IRQs, rmap mapping cannot function correctly
+		 * for irqs that are shared for different core/netdev RX rings.
+		 * Hence we don't allow netdev rmap for SFs
+		 */
+		err = set_rmap(dev);
+		if (err)
+			goto err_rmap;
+	}
+
 	err = create_comp_eqs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to create completion EQs\n");
@@ -959,6 +1019,9 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 
 	return 0;
 err_comp_eqs:
+	if (!mlx5_core_is_sf(dev))
+		clear_rmap(dev);
+err_rmap:
 	destroy_async_eqs(dev);
 err_async_eqs:
 	return err;
@@ -966,6 +1029,8 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev)
 {
+	if (!mlx5_core_is_sf(dev))
+		clear_rmap(dev);
 	destroy_comp_eqs(dev);
 	destroy_async_eqs(dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 81bfb5f0d332..d4be79884cb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -12,7 +12,6 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_irq_table_create(struct mlx5_core_dev *dev);
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
-struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
 int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 7d6ca2581532..149d6db9ee0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -24,9 +24,6 @@ struct mlx5_irq {
 struct mlx5_irq_table {
 	struct mlx5_irq *irq;
 	int nvec;
-#ifdef CONFIG_RFS_ACCEL
-	struct cpu_rmap *rmap;
-#endif
 };
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev)
@@ -159,8 +156,6 @@ static void irq_release(struct kref *kref)
 	 */
 	irq_set_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
-	/* this line is releasing this irq from the rmap */
-	irq_set_affinity_notifier(irq->irqn, NULL);
 	free_irq(irq->irqn, &irq->nh);
 }
 
@@ -210,10 +205,11 @@ static void irq_set_name(char *name, int vecidx)
 
 static int irq_request(struct mlx5_core_dev *dev, int i)
 {
-	struct mlx5_irq *irq = mlx5_irq_get(dev, i);
 	char name[MLX5_MAX_IRQ_NAME];
+	struct mlx5_irq *irq;
 	int err;
 
+	irq = mlx5_irq_get(dev, i);
 	irq->irqn = pci_irq_vector(dev->pdev, i);
 	irq_set_name(name, i);
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
@@ -223,15 +219,22 @@ static int irq_request(struct mlx5_core_dev *dev, int i)
 			  &irq->nh);
 	if (err) {
 		mlx5_core_err(dev, "Failed to request irq. err = %d\n", err);
-		return err;
+		goto err_req_irq;
 	}
 	if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
 		mlx5_core_warn(dev, "zalloc_cpumask_var failed\n");
-		free_irq(irq->irqn, &irq->nh);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_cpumask;
 	}
 	kref_init(&irq->kref);
 	return 0;
+
+err_cpumask:
+	free_irq(irq->irqn, &irq->nh);
+err_req_irq:
+	if (i != 0)
+		irq_set_affinity_notifier(irq->irqn, NULL);
+	return err;
 }
 
 /**
@@ -271,63 +274,12 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
 	return irq;
 }
 
-static void irq_clear_rmap(struct mlx5_core_dev *dev)
-{
-#ifdef CONFIG_RFS_ACCEL
-	struct mlx5_irq_table *irq_table = dev->priv.irq_table;
-
-	free_irq_cpu_rmap(irq_table->rmap);
-#endif
-}
-
-static int irq_set_rmap(struct mlx5_core_dev *mdev)
-{
-	int err = 0;
-#ifdef CONFIG_RFS_ACCEL
-	struct mlx5_irq_table *irq_table = mdev->priv.irq_table;
-	int num_affinity_vec;
-	int vecidx;
-
-	num_affinity_vec = mlx5_irq_get_num_comp(irq_table);
-	irq_table->rmap = alloc_irq_cpu_rmap(num_affinity_vec);
-	if (!irq_table->rmap) {
-		err = -ENOMEM;
-		mlx5_core_err(mdev, "Failed to allocate cpu_rmap. err %d", err);
-		goto err_out;
-	}
-
-	vecidx = MLX5_IRQ_VEC_COMP_BASE;
-	for (; vecidx < irq_table->nvec; vecidx++) {
-		err = irq_cpu_rmap_add(irq_table->rmap,
-				       pci_irq_vector(mdev->pdev, vecidx));
-		if (err) {
-			mlx5_core_err(mdev, "irq_cpu_rmap_add failed. err %d",
-				      err);
-			goto err_irq_cpu_rmap_add;
-		}
-	}
-	return 0;
-
-err_irq_cpu_rmap_add:
-	irq_clear_rmap(mdev);
-err_out:
-#endif
-	return err;
-}
-
 struct cpumask *
 mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx)
 {
 	return irq_table->irq[vecidx].mask;
 }
 
-#ifdef CONFIG_RFS_ACCEL
-struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *irq_table)
-{
-	return irq_table->rmap;
-}
-#endif
-
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -360,24 +312,13 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 
 	table->nvec = nvec;
 
-	err = irq_set_rmap(dev);
-	if (err)
-		goto err_set_rmap;
-
 	return 0;
 
-err_set_rmap:
-	pci_free_irq_vectors(dev->pdev);
 err_free_irq:
 	kfree(table->irq);
 	return err;
 }
 
-static void irq_table_clear_rmap(struct mlx5_irq_table *table)
-{
-	cpu_rmap_put(table->rmap);
-}
-
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
@@ -385,7 +326,6 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_sf(dev))
 		return;
 
-	irq_table_clear_rmap(table);
 	pci_free_irq_vectors(dev->pdev);
 	kfree(table->irq);
 }
-- 
2.31.1

