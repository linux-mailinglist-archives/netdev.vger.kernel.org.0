Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8775486ECF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbiAGAaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344187AbiAGAaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5CA2B82495
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C2CC36AF5;
        Fri,  7 Jan 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515412;
        bh=TJAcPVnOwPxZPZGZsg3HH5Z1vXJ/MTqCid3xe2M7Dy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2zPzbZyEaCOX9qEGQyk6uqmk/p7N/4fVrepomjZDzEvPjI/lw4VMOiu17zkJHnEY
         2R3gKf1E+UxYqA2G5qyB7k1moplKR/y3hg4TZEygliNc9CpQsqQ0zQxQhe/Dd6gzjK
         scg5iEZWILk+AghAYcivLwgjrA5gCvuzM3G1AVrRwGi3Gp0e3nfPn4BC3fVM4r/M5/
         Fn/JarSynttR253kyYh49E3SDucK003x0mwg1KqZMtrQENiBBagKmZFkbDrn75nxdn
         09xzPJ01LOpAC/2gpzIAJmweeA5ralcAaQ+3D6fJ0hpWg/PkKBBTmphvNYcvirTonv
         LgbwONjcmdtKg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 05/15] net/mlx5: Introduce API for bulk request and release of IRQs
Date:   Thu,  6 Jan 2022 16:29:46 -0800
Message-Id: <20220107002956.74849-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently IRQs are requested one by one. To balance spreading IRQs
among cpus using such scheme requires remembering cpu mask for the
cpus used for a given device. This complicates the IRQ allocation
scheme in subsequent patch.

Hence, prepare the code for bulk IRQs allocation. This enables
spreading IRQs among cpus in subsequent patch.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c              |  6 --
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 98 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 69 ++++++++++++-
 include/linux/mlx5/eq.h                       |  4 +-
 5 files changed, 135 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 91eb615b89ee..86842cd580ba 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1541,16 +1541,10 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 
 	eq->irq_nb.notifier_call = mlx5_ib_eq_pf_int;
 	param = (struct mlx5_eq_param) {
-		.irq_index = MLX5_IRQ_EQ_CTRL,
 		.nent = MLX5_IB_NUM_PF_EQE,
 	};
 	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_FAULT;
-	if (!zalloc_cpumask_var(&param.affinity, GFP_KERNEL)) {
-		err = -ENOMEM;
-		goto err_wq;
-	}
 	eq->core = mlx5_eq_create_generic(dev->mdev, &param);
-	free_cpumask_var(param.affinity);
 	if (IS_ERR(eq->core)) {
 		err = PTR_ERR(eq->core);
 		goto err_wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 1eb0326a489b..14547b6f2894 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -59,6 +59,8 @@ struct mlx5_eq_table {
 	struct mutex            lock; /* sync async eqs creations */
 	int			num_comp_eqs;
 	struct mlx5_irq_table	*irq_table;
+	struct mlx5_irq         **comp_irqs;
+	struct mlx5_irq         *ctrl_irq;
 #ifdef CONFIG_RFS_ACCEL
 	struct cpu_rmap		*rmap;
 #endif
@@ -266,8 +268,8 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	u8 log_eq_stride = ilog2(MLX5_EQE_SIZE);
 	struct mlx5_priv *priv = &dev->priv;
-	u16 vecidx = param->irq_index;
 	__be64 *pas;
+	u16 vecidx;
 	void *eqc;
 	int inlen;
 	u32 *in;
@@ -289,23 +291,16 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	mlx5_init_fbc(eq->frag_buf.frags, log_eq_stride, log_eq_size, &eq->fbc);
 	init_eq_buf(eq);
 
-	if (vecidx == MLX5_IRQ_EQ_CTRL)
-		eq->irq = mlx5_ctrl_irq_request(dev);
-	else
-		eq->irq = mlx5_irq_request(dev, vecidx, param->affinity);
-	if (IS_ERR(eq->irq)) {
-		err = PTR_ERR(eq->irq);
-		goto err_buf;
-	}
-
+	eq->irq = param->irq;
 	vecidx = mlx5_irq_get_index(eq->irq);
+
 	inlen = MLX5_ST_SZ_BYTES(create_eq_in) +
 		MLX5_FLD_SZ_BYTES(create_eq_in, pas[0]) * eq->frag_buf.npages;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
-		goto err_irq;
+		goto err_buf;
 	}
 
 	pas = (__be64 *)MLX5_ADDR_OF(create_eq_in, in, pas);
@@ -349,8 +344,6 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 err_in:
 	kvfree(in);
 
-err_irq:
-	mlx5_irq_release(eq->irq);
 err_buf:
 	mlx5_frag_buf_free(dev, &eq->frag_buf);
 	return err;
@@ -404,7 +397,6 @@ static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 	if (err)
 		mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
 			       eq->eqn);
-	mlx5_irq_release(eq->irq);
 
 	mlx5_frag_buf_free(dev, &eq->frag_buf);
 	return err;
@@ -597,11 +589,8 @@ setup_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq_async *eq,
 
 	eq->irq_nb.notifier_call = mlx5_eq_async_int;
 	spin_lock_init(&eq->lock);
-	if (!zalloc_cpumask_var(&param->affinity, GFP_KERNEL))
-		return -ENOMEM;
 
 	err = create_async_eq(dev, &eq->core, param);
-	free_cpumask_var(param->affinity);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create %s EQ %d\n", name, err);
 		return err;
@@ -646,11 +635,18 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	struct mlx5_eq_param param = {};
 	int err;
 
+	/* All the async_eqs are using single IRQ, request one IRQ and share its
+	 * index among all the async_eqs of this device.
+	 */
+	table->ctrl_irq = mlx5_ctrl_irq_request(dev);
+	if (IS_ERR(table->ctrl_irq))
+		return PTR_ERR(table->ctrl_irq);
+
 	MLX5_NB_INIT(&table->cq_err_nb, cq_err_event_notifier, CQ_ERROR);
 	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = MLX5_IRQ_EQ_CTRL,
+		.irq = table->ctrl_irq,
 		.nent = MLX5_NUM_CMD_EQE,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
@@ -663,7 +659,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = MLX5_IRQ_EQ_CTRL,
+		.irq = table->ctrl_irq,
 		.nent = async_eq_depth_devlink_param_get(dev),
 	};
 
@@ -673,7 +669,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 		goto err2;
 
 	param = (struct mlx5_eq_param) {
-		.irq_index = MLX5_IRQ_EQ_CTRL,
+		.irq = table->ctrl_irq,
 		.nent = /* TODO: sriov max_vf + */ 1,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST,
 	};
@@ -692,6 +688,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 err1:
 	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
+	mlx5_ctrl_irq_release(table->ctrl_irq);
 	return err;
 }
 
@@ -706,6 +703,7 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
+	mlx5_ctrl_irq_release(table->ctrl_irq);
 }
 
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev)
@@ -733,12 +731,10 @@ mlx5_eq_create_generic(struct mlx5_core_dev *dev,
 	struct mlx5_eq *eq = kvzalloc(sizeof(*eq), GFP_KERNEL);
 	int err;
 
-	if (!cpumask_available(param->affinity))
-		return ERR_PTR(-EINVAL);
-
 	if (!eq)
 		return ERR_PTR(-ENOMEM);
 
+	param->irq = dev->priv.eq_table->ctrl_irq;
 	err = create_async_eq(dev, eq, param);
 	if (err) {
 		kvfree(eq);
@@ -798,6 +794,45 @@ void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm)
 }
 EXPORT_SYMBOL(mlx5_eq_update_ci);
 
+static void comp_irqs_release(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+
+	mlx5_irqs_release_vectors(table->comp_irqs, table->num_comp_eqs);
+	kfree(table->comp_irqs);
+}
+
+static int comp_irqs_request(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	int ncomp_eqs = table->num_comp_eqs;
+	u16 *cpus;
+	int ret;
+	int i;
+
+	ncomp_eqs = table->num_comp_eqs;
+	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
+	if (!table->comp_irqs)
+		return -ENOMEM;
+
+	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
+	if (!cpus) {
+		ret = -ENOMEM;
+		goto free_irqs;
+	}
+	for (i = 0; i < ncomp_eqs; i++)
+		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
+	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
+	kfree(cpus);
+	if (ret < 0)
+		goto free_irqs;
+	return ret;
+
+free_irqs:
+	kfree(table->comp_irqs);
+	return ret;
+}
+
 static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -812,6 +847,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 		tasklet_disable(&eq->tasklet_ctx.task);
 		kfree(eq);
 	}
+	comp_irqs_release(dev);
 }
 
 static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
@@ -838,12 +874,13 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	int err;
 	int i;
 
+	ncomp_eqs = comp_irqs_request(dev);
+	if (ncomp_eqs < 0)
+		return ncomp_eqs;
 	INIT_LIST_HEAD(&table->comp_eqs_list);
-	ncomp_eqs = table->num_comp_eqs;
 	nent = comp_eq_depth_devlink_param_get(dev);
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
-		int vecidx = i;
 
 		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
 		if (!eq) {
@@ -858,18 +895,11 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 
 		eq->irq_nb.notifier_call = mlx5_eq_comp_int;
 		param = (struct mlx5_eq_param) {
-			.irq_index = vecidx,
+			.irq = table->comp_irqs[i],
 			.nent = nent,
 		};
 
-		if (!zalloc_cpumask_var(&param.affinity, GFP_KERNEL)) {
-			err = -ENOMEM;
-			goto clean_eq;
-		}
-		cpumask_set_cpu(cpumask_local_spread(i, dev->priv.numa_node),
-				param.affinity);
 		err = create_map_eq(dev, &eq->core, &param);
-		free_cpumask_var(param.affinity);
 		if (err)
 			goto clean_eq;
 		err = mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
@@ -883,7 +913,9 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		list_add_tail(&eq->list, &table->comp_eqs_list);
 	}
 
+	table->num_comp_eqs = ncomp_eqs;
 	return 0;
+
 clean_eq:
 	kfree(eq);
 clean:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index db58f5e3f457..f2ad3c21802f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -23,9 +23,12 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
 int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 
 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev);
+void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq);
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 				  struct cpumask *affinity);
-void mlx5_irq_release(struct mlx5_irq *irq);
+int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
+			      struct mlx5_irq **irqs);
+void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 496826a7a88b..2e19c3c222fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -342,13 +342,27 @@ static struct mlx5_irq_pool *ctrl_irq_pool_get(struct mlx5_core_dev *dev)
 }
 
 /**
- * mlx5_irq_release - release an IRQ back to the system.
- * @irq: irq to be released.
+ * mlx5_irqs_release - release one or more IRQs back to the system.
+ * @irqs: IRQs to be released.
+ * @nirqs: number of IRQs to be released.
  */
-void mlx5_irq_release(struct mlx5_irq *irq)
+static void mlx5_irqs_release(struct mlx5_irq **irqs, int nirqs)
 {
-	synchronize_irq(irq->irqn);
-	irq_put(irq);
+	int i;
+
+	for (i = 0; i < nirqs; i++) {
+		synchronize_irq(irqs[i]->irqn);
+		irq_put(irqs[i]);
+	}
+}
+
+/**
+ * mlx5_ctrl_irq_release - release a ctrl IRQ back to the system.
+ * @ctrl_irq: ctrl IRQ to be released.
+ */
+void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq)
+{
+	mlx5_irqs_release(&ctrl_irq, 1);
 }
 
 /**
@@ -423,6 +437,51 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 	return irq;
 }
 
+/**
+ * mlx5_irqs_release_vectors - release one or more IRQs back to the system.
+ * @irqs: IRQs to be released.
+ * @nirqs: number of IRQs to be released.
+ */
+void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
+{
+	mlx5_irqs_release(irqs, nirqs);
+}
+
+/**
+ * mlx5_irqs_request_vectors - request one or more IRQs for mlx5 device.
+ * @dev: mlx5 device that is requesting the IRQs.
+ * @cpus: CPUs array for binding the IRQs
+ * @nirqs: number of IRQs to request.
+ * @irqs: an output array of IRQs pointers.
+ *
+ * Each IRQ is bound to at most 1 CPU.
+ * This function is requests nirqs IRQs, starting from @vecidx.
+ *
+ * This function returns the number of IRQs requested, (which might be smaller than
+ * @nirqs), if successful, or a negative error code in case of an error.
+ */
+int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
+			      struct mlx5_irq **irqs)
+{
+	cpumask_var_t req_mask;
+	struct mlx5_irq *irq;
+	int i;
+
+	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
+		return -ENOMEM;
+	for (i = 0; i < nirqs; i++) {
+		cpumask_set_cpu(cpus[i], req_mask);
+		irq = mlx5_irq_request(dev, i, req_mask);
+		if (IS_ERR(irq))
+			break;
+		cpumask_clear(req_mask);
+		irqs[i] = irq;
+	}
+
+	free_cpumask_var(req_mask);
+	return i ? i : PTR_ERR(irq);
+}
+
 static struct mlx5_irq_pool *
 irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	       u32 min_threshold, u32 max_threshold)
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index ea3ff5a8ced3..3705a382276b 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -9,13 +9,13 @@
 #define MLX5_NUM_SPARE_EQE (0x80)
 
 struct mlx5_eq;
+struct mlx5_irq;
 struct mlx5_core_dev;
 
 struct mlx5_eq_param {
-	u8             irq_index;
 	int            nent;
 	u64            mask[4];
-	cpumask_var_t  affinity;
+	struct mlx5_irq *irq;
 };
 
 struct mlx5_eq *
-- 
2.33.1

