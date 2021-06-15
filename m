Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42C3A7584
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFOEDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhFOEDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2EE061421;
        Tue, 15 Jun 2021 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729691;
        bh=Y1ADodKao4F4CW8Iv6/wX6cYD9CRKhYE1iSkIlFpO1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2C9PzMJHdnheg905SiP4PM/oakie69MFD0QQ4nMLO7kagSt1x7l4FBSr8CrdfpTK
         Xav90bBWGUjBeUgFxVs4m9o+16M7TRhEhL4Oyp58lI/kynwZj99W0+90ttA7yZ9XRc
         kLZLBbaJs6+WTLxPJydKWYRSc7SqvcSl8juWTRnB02rp5Vqe8FceCdrJGJZ9YWeJpu
         sWsHGG9OCqfMY7MJbbbvOF0b6HZ1jkTHQuhaAD7ngAE5E7/4u7lAVSAxOTn8YzpfbA
         AsVSI656mWNC0RDVwb+PE7mwAl+AmIQET53ilpgJwkKHMPT7ysX8bFsblV9A+RDUBn
         0l4mcOTT86XAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Provide cpumask at EQ creation phase
Date:   Mon, 14 Jun 2021 21:01:14 -0700
Message-Id: <20210615040123.287101-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The users of EQ are running their code on different CPUs and with
various affinity patterns. Move the cpumask setting close to their
actual usage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c              |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  27 +++--
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 103 ++++--------------
 include/linux/mlx5/eq.h                       |   1 +
 5 files changed, 49 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 782b2af8f211..8f88b044ccbc 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1564,7 +1564,12 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 		.nent = MLX5_IB_NUM_PF_EQE,
 	};
 	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_FAULT;
+	if (!zalloc_cpumask_var(&param.affinity, GFP_KERNEL)) {
+		err = -ENOMEM;
+		goto err_wq;
+	}
 	eq->core = mlx5_eq_create_generic(dev->mdev, &param);
+	free_cpumask_var(param.affinity);
 	if (IS_ERR(eq->core)) {
 		err = PTR_ERR(eq->core);
 		goto err_wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7e7bbed3763d..5a88887c1a58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -310,7 +310,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	mlx5_init_fbc(eq->frag_buf.frags, log_eq_stride, log_eq_size, &eq->fbc);
 	init_eq_buf(eq);
 
-	eq->irq = mlx5_irq_request(dev, vecidx);
+	eq->irq = mlx5_irq_request(dev, vecidx, param->affinity);
 	if (IS_ERR(eq->irq)) {
 		err = PTR_ERR(eq->irq);
 		goto err_buf;
@@ -621,8 +621,11 @@ setup_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq_async *eq,
 
 	eq->irq_nb.notifier_call = mlx5_eq_async_int;
 	spin_lock_init(&eq->lock);
+	if (!zalloc_cpumask_var(&param->affinity, GFP_KERNEL))
+		return -ENOMEM;
 
 	err = create_async_eq(dev, &eq->core, param);
+	free_cpumask_var(param->affinity);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create %s EQ %d\n", name, err);
 		return err;
@@ -740,6 +743,9 @@ mlx5_eq_create_generic(struct mlx5_core_dev *dev,
 	struct mlx5_eq *eq = kvzalloc(sizeof(*eq), GFP_KERNEL);
 	int err;
 
+	if (!param->affinity)
+		return ERR_PTR(-EINVAL);
+
 	if (!eq)
 		return ERR_PTR(-ENOMEM);
 
@@ -850,16 +856,21 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 			.irq_index = vecidx,
 			.nent = nent,
 		};
-		err = create_map_eq(dev, &eq->core, &param);
-		if (err) {
-			kfree(eq);
-			goto clean;
+
+		if (!zalloc_cpumask_var(&param.affinity, GFP_KERNEL)) {
+			err = -ENOMEM;
+			goto clean_eq;
 		}
+		cpumask_set_cpu(cpumask_local_spread(i, dev->priv.numa_node),
+				param.affinity);
+		err = create_map_eq(dev, &eq->core, &param);
+		free_cpumask_var(param.affinity);
+		if (err)
+			goto clean_eq;
 		err = mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
 		if (err) {
 			destroy_unmap_eq(dev, &eq->core);
-			kfree(eq);
-			goto clean;
+			goto clean_eq;
 		}
 
 		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->core.eqn);
@@ -868,6 +879,8 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	}
 
 	return 0;
+clean_eq:
+	kfree(eq);
 clean:
 	destroy_comp_eqs(dev);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index dd138b38bf36..81bfb5f0d332 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -20,7 +20,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
 			    int msix_vec_count);
 int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 
-struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx);
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
+				  struct cpumask *affinity);
 void mlx5_irq_release(struct mlx5_irq *irq);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index ecace7ca4a01..81b06b5693cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -17,6 +17,7 @@ struct mlx5_irq {
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
+	spinlock_t lock; /* protects affinity assignment */
 	struct kref kref;
 	int irqn;
 };
@@ -153,6 +154,8 @@ static void irq_release(struct kref *kref)
 {
 	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
 
+	irq_set_affinity_hint(irq->irqn, NULL);
+	free_cpumask_var(irq->mask);
 	free_irq(irq->irqn, &irq->nh);
 }
 
@@ -189,7 +192,8 @@ void mlx5_irq_release(struct mlx5_irq *irq)
 	irq_put(irq);
 }
 
-struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx)
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
+				  struct cpumask *affinity)
 {
 	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
 	struct mlx5_irq *irq = &table->irq[vecidx];
@@ -199,6 +203,16 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx)
 	if (!err)
 		return ERR_PTR(-ENOENT);
 
+	spin_lock(&irq->lock);
+	if (!cpumask_empty(irq->mask)) {
+		/* already configured */
+		spin_unlock(&irq->lock);
+		return irq;
+	}
+
+	cpumask_copy(irq->mask, affinity);
+	irq_set_affinity_hint(irq->irqn, irq->mask);
+	spin_unlock(&irq->lock);
 	return irq;
 }
 
@@ -239,6 +253,12 @@ static int request_irqs(struct mlx5_core_dev *dev, int nvec)
 			mlx5_core_err(dev, "Failed to request irq\n");
 			goto err_request_irq;
 		}
+		if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
+			mlx5_core_warn(dev, "zalloc_cpumask_var failed\n");
+			err = -ENOMEM;
+			goto err_request_irq;
+		}
+		spin_lock_init(&irq->lock);
 		kref_init(&irq->kref);
 	}
 	return 0;
@@ -294,69 +314,6 @@ static int irq_set_rmap(struct mlx5_core_dev *mdev)
 	return err;
 }
 
-/* Completion IRQ vectors */
-
-static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
-{
-	int vecidx = MLX5_IRQ_VEC_COMP_BASE + i;
-	struct mlx5_irq *irq;
-
-	irq = mlx5_irq_get(mdev, vecidx);
-	if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
-		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
-		return -ENOMEM;
-	}
-
-	cpumask_set_cpu(cpumask_local_spread(i, mdev->priv.numa_node),
-			irq->mask);
-	if (IS_ENABLED(CONFIG_SMP) &&
-	    irq_set_affinity_hint(irq->irqn, irq->mask))
-		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x",
-			       irq->irqn);
-
-	return 0;
-}
-
-static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
-{
-	int vecidx = MLX5_IRQ_VEC_COMP_BASE + i;
-	struct mlx5_irq *irq;
-
-	irq = mlx5_irq_get(mdev, vecidx);
-	irq_set_affinity_hint(irq->irqn, NULL);
-	free_cpumask_var(irq->mask);
-}
-
-static int set_comp_irq_affinity_hints(struct mlx5_core_dev *mdev)
-{
-	int nvec = mlx5_irq_get_num_comp(mdev->priv.irq_table);
-	int err;
-	int i;
-
-	for (i = 0; i < nvec; i++) {
-		err = set_comp_irq_affinity_hint(mdev, i);
-		if (err)
-			goto err_out;
-	}
-
-	return 0;
-
-err_out:
-	for (i--; i >= 0; i--)
-		clear_comp_irq_affinity_hint(mdev, i);
-
-	return err;
-}
-
-static void clear_comp_irqs_affinity_hints(struct mlx5_core_dev *mdev)
-{
-	int nvec = mlx5_irq_get_num_comp(mdev->priv.irq_table);
-	int i;
-
-	for (i = 0; i < nvec; i++)
-		clear_comp_irq_affinity_hint(mdev, i);
-}
-
 struct cpumask *
 mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx)
 {
@@ -370,15 +327,6 @@ struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *irq_table)
 }
 #endif
 
-static void unrequest_irqs(struct mlx5_core_dev *dev)
-{
-	struct mlx5_irq_table *table = dev->priv.irq_table;
-	int i;
-
-	for (i = 0; i < table->nvec; i++)
-		irq_put(mlx5_irq_get(dev, i));
-}
-
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -419,16 +367,8 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_request_irqs;
 
-	err = set_comp_irq_affinity_hints(dev);
-	if (err) {
-		mlx5_core_err(dev, "Failed to alloc affinity hint cpumask\n");
-		goto err_set_affinity;
-	}
-
 	return 0;
 
-err_set_affinity:
-	unrequest_irqs(dev);
 err_request_irqs:
 	irq_clear_rmap(dev);
 err_set_rmap:
@@ -451,7 +391,6 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	 * which should be called after alloc_irq but before request_irq.
 	 */
 	irq_clear_rmap(dev);
-	clear_comp_irqs_affinity_hints(dev);
 	for (i = 0; i < table->nvec; i++)
 		irq_release(&mlx5_irq_get(dev, i)->kref);
 	pci_free_irq_vectors(dev->pdev);
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index e49d8c0d4f26..cea6ecb4b73e 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -16,6 +16,7 @@ struct mlx5_eq_param {
 	u8             irq_index;
 	int            nent;
 	u64            mask[4];
+	cpumask_var_t  affinity;
 };
 
 struct mlx5_eq *
-- 
2.31.1

