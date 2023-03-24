Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310096C891B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjCXXO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjCXXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A1A1DBB9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B245B82668
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB12C4339B;
        Fri, 24 Mar 2023 23:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699636;
        bh=tKyfLYb99p7wQrto52OxdNoD0y0fAXEXwjjiU3YImlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rL4XQmIJqqJ0T4LM55dalQENhGdPkhqeUUNys0QUrjtAfhSOewbQWeu8qS6Xmjl6+
         xDRCoFKL6jFu8PS/Wsn2MDGYo82kttv/RwBWW4bdPFO5p5VQqRORo17fKSlo5wLec0
         1YFtbu2i+zibWcH/Atab3SbLyXemSeZOb3GM52ZMTpBdpy6js1PcyCdchiYkbenW48
         hqijlf2GtWKa7hkqFwh/8H7kWQJqvDliuPk6/DS9lTs7dbVJblDlBB8b3oYzgroKE4
         7sG6AZaHAHw2zL9TdtEe10mg3BhZiRim9ysm8uoCN2djfSS5kqDYVJtoVA2V0dOu9J
         CQ8f2jTlUvdUQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 07/15] net/mlx5: Use newer affinity descriptor
Date:   Fri, 24 Mar 2023 16:13:33 -0700
Message-Id: <20230324231341.29808-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Use the more refined struct irq_affinity_desc to describe the required
IRQ affinity. For the async IRQs request unmanaged affinity and for
completion queues use managed affinity.

No functionality changes introduced. It will be used in a subsequent
patch when we use dynamic MSIX allocation.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../mellanox/mlx5/core/irq_affinity.c         | 39 +++++++--------
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  6 +--
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 49 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/pci_irq.h |  2 +-
 4 files changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 380a208ab137..6535e8813178 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -45,30 +45,27 @@ static int cpu_get_least_loaded(struct mlx5_irq_pool *pool,
 
 /* Creating an IRQ from irq_pool */
 static struct mlx5_irq *
-irq_pool_request_irq(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+irq_pool_request_irq(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_desc)
 {
-	cpumask_var_t auto_mask;
-	struct mlx5_irq *irq;
+	struct irq_affinity_desc auto_desc = {};
 	u32 irq_index;
 	int err;
 
-	if (!zalloc_cpumask_var(&auto_mask, GFP_KERNEL))
-		return ERR_PTR(-ENOMEM);
 	err = xa_alloc(&pool->irqs, &irq_index, NULL, pool->xa_num_irqs, GFP_KERNEL);
 	if (err)
 		return ERR_PTR(err);
 	if (pool->irqs_per_cpu) {
-		if (cpumask_weight(req_mask) > 1)
+		if (cpumask_weight(&af_desc->mask) > 1)
 			/* if req_mask contain more then one CPU, set the least loadad CPU
 			 * of req_mask
 			 */
-			cpumask_set_cpu(cpu_get_least_loaded(pool, req_mask), auto_mask);
+			cpumask_set_cpu(cpu_get_least_loaded(pool, &af_desc->mask),
+					&auto_desc.mask);
 		else
-			cpu_get(pool, cpumask_first(req_mask));
+			cpu_get(pool, cpumask_first(&af_desc->mask));
 	}
-	irq = mlx5_irq_alloc(pool, irq_index, cpumask_empty(auto_mask) ? req_mask : auto_mask);
-	free_cpumask_var(auto_mask);
-	return irq;
+	return mlx5_irq_alloc(pool, irq_index,
+			      cpumask_empty(&auto_desc.mask) ? af_desc : &auto_desc);
 }
 
 /* Looking for the IRQ with the smallest refcount that fits req_mask.
@@ -115,22 +112,22 @@ irq_pool_find_least_loaded(struct mlx5_irq_pool *pool, const struct cpumask *req
 /**
  * mlx5_irq_affinity_request - request an IRQ according to the given mask.
  * @pool: IRQ pool to request from.
- * @req_mask: cpumask requested for this IRQ.
+ * @af_desc: affinity descriptor for this IRQ.
  *
  * This function returns a pointer to IRQ, or ERR_PTR in case of error.
  */
 struct mlx5_irq *
-mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_desc)
 {
 	struct mlx5_irq *least_loaded_irq, *new_irq;
 
 	mutex_lock(&pool->lock);
-	least_loaded_irq = irq_pool_find_least_loaded(pool, req_mask);
+	least_loaded_irq = irq_pool_find_least_loaded(pool, &af_desc->mask);
 	if (least_loaded_irq &&
 	    mlx5_irq_read_locked(least_loaded_irq) < pool->min_threshold)
 		goto out;
 	/* We didn't find an IRQ with less than min_thres, try to allocate a new IRQ */
-	new_irq = irq_pool_request_irq(pool, req_mask);
+	new_irq = irq_pool_request_irq(pool, af_desc);
 	if (IS_ERR(new_irq)) {
 		if (!least_loaded_irq) {
 			/* We failed to create an IRQ and we didn't find an IRQ */
@@ -194,16 +191,15 @@ int mlx5_irq_affinity_irqs_request_auto(struct mlx5_core_dev *dev, int nirqs,
 					struct mlx5_irq **irqs)
 {
 	struct mlx5_irq_pool *pool = mlx5_irq_pool_get(dev);
-	cpumask_var_t req_mask;
+	struct irq_affinity_desc af_desc = {};
 	struct mlx5_irq *irq;
 	int i = 0;
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
-		return -ENOMEM;
-	cpumask_copy(req_mask, cpu_online_mask);
+	af_desc.is_managed = 1;
+	cpumask_copy(&af_desc.mask, cpu_online_mask);
 	for (i = 0; i < nirqs; i++) {
 		if (mlx5_irq_pool_is_sf_pool(pool))
-			irq = mlx5_irq_affinity_request(pool, req_mask);
+			irq = mlx5_irq_affinity_request(pool, &af_desc);
 		else
 			/* In case SF pool doesn't exists, fallback to the PF IRQs.
 			 * The PF IRQs are already allocated and binded to CPU
@@ -213,13 +209,12 @@ int mlx5_irq_affinity_irqs_request_auto(struct mlx5_core_dev *dev, int nirqs,
 		if (IS_ERR(irq))
 			break;
 		irqs[i] = irq;
-		cpumask_clear_cpu(cpumask_first(mlx5_irq_get_affinity_mask(irq)), req_mask);
+		cpumask_clear_cpu(cpumask_first(mlx5_irq_get_affinity_mask(irq)), &af_desc.mask);
 		mlx5_core_dbg(pool->dev, "IRQ %u mapped to cpu %*pbl, %u EQs on this irq\n",
 			      pci_irq_vector(dev->pdev, mlx5_irq_get_index(irq)),
 			      cpumask_pr_args(mlx5_irq_get_affinity_mask(irq)),
 			      mlx5_irq_read_locked(irq) / MLX5_EQ_REFS_PER_IRQ);
 	}
-	free_cpumask_var(req_mask);
 	if (!i)
 		return PTR_ERR(irq);
 	return i;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 23cb63fa4588..7e0dac74721e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -25,7 +25,7 @@ int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev);
 void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq);
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct cpumask *affinity);
+				  struct irq_affinity_desc *af_desc);
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 			      struct mlx5_irq **irqs);
 void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs);
@@ -39,7 +39,7 @@ struct mlx5_irq_pool;
 int mlx5_irq_affinity_irqs_request_auto(struct mlx5_core_dev *dev, int nirqs,
 					struct mlx5_irq **irqs);
 struct mlx5_irq *mlx5_irq_affinity_request(struct mlx5_irq_pool *pool,
-					   const struct cpumask *req_mask);
+					   struct irq_affinity_desc *af_desc);
 void mlx5_irq_affinity_irqs_release(struct mlx5_core_dev *dev, struct mlx5_irq **irqs,
 				    int num_irqs);
 #else
@@ -50,7 +50,7 @@ static inline int mlx5_irq_affinity_irqs_request_auto(struct mlx5_core_dev *dev,
 }
 
 static inline struct mlx5_irq *
-mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_desc)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c79775d0ac24..df6c2f8eb5df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -206,7 +206,7 @@ static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 }
 
 struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
-				const struct cpumask *affinity)
+				struct irq_affinity_desc *af_desc)
 {
 	struct mlx5_core_dev *dev = pool->dev;
 	char name[MLX5_MAX_IRQ_NAME];
@@ -235,8 +235,8 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
-	if (affinity) {
-		cpumask_copy(irq->mask, affinity);
+	if (af_desc) {
+		cpumask_copy(irq->mask, &af_desc->mask);
 		irq_set_affinity_and_hint(irq->map.virq, irq->mask);
 	}
 	irq->pool = pool;
@@ -250,7 +250,8 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	}
 	return irq;
 err_xa:
-	irq_update_affinity_hint(irq->map.virq, NULL);
+	if (af_desc)
+		irq_update_affinity_hint(irq->map.virq, NULL);
 	free_cpumask_var(irq->mask);
 err_cpumask:
 	free_irq(irq->map.virq, &irq->nh);
@@ -299,7 +300,7 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 /* requesting an irq from a given pool according to given index */
 static struct mlx5_irq *
 irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
-			struct cpumask *affinity)
+			struct irq_affinity_desc *af_desc)
 {
 	struct mlx5_irq *irq;
 
@@ -309,7 +310,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 		mlx5_irq_get_locked(irq);
 		goto unlock;
 	}
-	irq = mlx5_irq_alloc(pool, vecidx, affinity);
+	irq = mlx5_irq_alloc(pool, vecidx, af_desc);
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
@@ -386,28 +387,26 @@ void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq)
 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_pool *pool = ctrl_irq_pool_get(dev);
-	cpumask_var_t req_mask;
+	struct irq_affinity_desc af_desc;
 	struct mlx5_irq *irq;
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
-		return ERR_PTR(-ENOMEM);
-	cpumask_copy(req_mask, cpu_online_mask);
+	cpumask_copy(&af_desc.mask, cpu_online_mask);
+	af_desc.is_managed = false;
 	if (!mlx5_irq_pool_is_sf_pool(pool)) {
 		/* In case we are allocating a control IRQ from a pci device's pool.
 		 * This can happen also for a SF if the SFs pool is empty.
 		 */
 		if (!pool->xa_num_irqs.max) {
-			cpumask_clear(req_mask);
+			cpumask_clear(&af_desc.mask);
 			/* In case we only have a single IRQ for PF/VF */
-			cpumask_set_cpu(cpumask_first(cpu_online_mask), req_mask);
+			cpumask_set_cpu(cpumask_first(cpu_online_mask), &af_desc.mask);
 		}
 		/* Allocate the IRQ in the last index of the pool */
-		irq = irq_pool_request_vector(pool, pool->xa_num_irqs.max, req_mask);
+		irq = irq_pool_request_vector(pool, pool->xa_num_irqs.max, &af_desc);
 	} else {
-		irq = mlx5_irq_affinity_request(pool, req_mask);
+		irq = mlx5_irq_affinity_request(pool, &af_desc);
 	}
 
-	free_cpumask_var(req_mask);
 	return irq;
 }
 
@@ -416,23 +415,23 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
  * @dev: mlx5 device that requesting the IRQ.
  * @vecidx: vector index of the IRQ. This argument is ignore if affinity is
  * provided.
- * @affinity: cpumask requested for this IRQ.
+ * @af_desc: affinity descriptor for this IRQ.
  *
  * This function returns a pointer to IRQ, or ERR_PTR in case of error.
  */
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct cpumask *affinity)
+				  struct irq_affinity_desc *af_desc)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 	struct mlx5_irq_pool *pool;
 	struct mlx5_irq *irq;
 
 	pool = irq_table->pf_pool;
-	irq = irq_pool_request_vector(pool, vecidx, affinity);
+	irq = irq_pool_request_vector(pool, vecidx, af_desc);
 	if (IS_ERR(irq))
 		return irq;
 	mlx5_core_dbg(dev, "irq %u mapped to cpu %*pbl, %u EQs on this irq\n",
-		      irq->map.virq, cpumask_pr_args(affinity),
+		      irq->map.virq, cpumask_pr_args(&af_desc->mask),
 		      irq->refcount / MLX5_EQ_REFS_PER_IRQ);
 	return irq;
 }
@@ -463,22 +462,20 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 			      struct mlx5_irq **irqs)
 {
-	cpumask_var_t req_mask;
+	struct irq_affinity_desc af_desc;
 	struct mlx5_irq *irq;
 	int i;
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
-		return -ENOMEM;
+	af_desc.is_managed = 1;
 	for (i = 0; i < nirqs; i++) {
-		cpumask_set_cpu(cpus[i], req_mask);
-		irq = mlx5_irq_request(dev, i, req_mask);
+		cpumask_set_cpu(cpus[i], &af_desc.mask);
+		irq = mlx5_irq_request(dev, i, &af_desc);
 		if (IS_ERR(irq))
 			break;
-		cpumask_clear(req_mask);
+		cpumask_clear(&af_desc.mask);
 		irqs[i] = irq;
 	}
 
-	free_cpumask_var(req_mask);
 	return i ? i : PTR_ERR(irq);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
index 5c7e68bee43a..ea39e4027d8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
@@ -31,7 +31,7 @@ static inline bool mlx5_irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
 }
 
 struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
-				const struct cpumask *affinity);
+				struct irq_affinity_desc *af_desc);
 int mlx5_irq_get_locked(struct mlx5_irq *irq);
 int mlx5_irq_read_locked(struct mlx5_irq *irq);
 int mlx5_irq_put(struct mlx5_irq *irq);
-- 
2.39.2

