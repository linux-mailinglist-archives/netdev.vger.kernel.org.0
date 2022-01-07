Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB665486ECE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344248AbiAGAaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344192AbiAGAaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD901C061201
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED1C61E70
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02F4C36AF3;
        Fri,  7 Jan 2022 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515412;
        bh=e3pl0ubRGG5ROOci2TGqYM+hboIvqrjnnE6XKtqVp1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm0N6L3i0zX2EALqjHtW9tuq+SzEd0pZsMLQQFPILpJ9u11po8dxV0k2MtwDlzp0c
         /aSxfK2m9F55ETwpX75E9xxDvoL2aArHFnZjW5NL8UQAkR2eY0QaCnPm2Cgd+Ey9LJ
         jfW6w2GeUu9o7qxbl87S8hDi+zZTvjTs/etxJC0gBdO6JWAI59p7MZfc8HJVncBucG
         81Rh8rP1oSWWT/khOHnN8xSJUinZtVKBI1qayxXnbtw1bGLPUCvHjGPJVpwweaONJ9
         CxVqP0huYrxh1SX6S/4VQ/cRyhrUW12o01w5/LieSdPAK+G52zvSPtU6z0AbGR9xky
         T3+Pplca/nTEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 04/15] net/mlx5: Split irq_pool_affinity logic to new file
Date:   Thu,  6 Jan 2022 16:29:45 -0800
Message-Id: <20220107002956.74849-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

The downstream patches add more functionality to irq_pool_affinity.
Move the irq_pool_affinity logic to a new file in order to ease the
coding and maintenance of it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/irq_affinity.c         |  99 ++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  11 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 111 +++---------------
 .../net/ethernet/mellanox/mlx5/core/pci_irq.h |  31 +++++
 5 files changed, 157 insertions(+), 97 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 33904bc87efa..fcfd38fa9e6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -109,7 +109,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 #
 # SF device
 #
-mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
+mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o irq_affinity.o
 
 #
 # SF manager
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
new file mode 100644
index 000000000000..4ff0af0fc58a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "mlx5_irq.h"
+#include "pci_irq.h"
+
+/* Creating an IRQ from irq_pool */
+static struct mlx5_irq *
+irq_pool_request_irq(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+{
+	u32 irq_index;
+	int err;
+
+	err = xa_alloc(&pool->irqs, &irq_index, NULL, pool->xa_num_irqs,
+		       GFP_KERNEL);
+	if (err)
+		return ERR_PTR(err);
+	return mlx5_irq_alloc(pool, irq_index, req_mask);
+}
+
+/* Looking for the IRQ with the smallest refcount and the same mask */
+static struct mlx5_irq *
+irq_pool_find_least_loaded(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+{
+	int start = pool->xa_num_irqs.min;
+	int end = pool->xa_num_irqs.max;
+	struct mlx5_irq *irq = NULL;
+	struct mlx5_irq *iter;
+	int irq_refcount = 0;
+	unsigned long index;
+
+	lockdep_assert_held(&pool->lock);
+	xa_for_each_range(&pool->irqs, index, iter, start, end) {
+		struct cpumask *iter_mask = mlx5_irq_get_affinity_mask(iter);
+		int iter_refcount = mlx5_irq_read_locked(iter);
+
+		if (!cpumask_equal(iter_mask, req_mask))
+			/* If a user request a mask, skip IRQs that's aren't a match */
+			continue;
+		if (iter_refcount < pool->min_threshold)
+			/* If we found an IRQ with less than min_thres, return it */
+			return iter;
+		if (!irq || iter_refcount < irq_refcount) {
+			/* In case we won't find an IRQ with less than min_thres,
+			 * keep a pointer to the least used IRQ
+			 */
+			irq_refcount = iter_refcount;
+			irq = iter;
+		}
+	}
+	return irq;
+}
+
+/**
+ * mlx5_irq_affinity_request - request an IRQ according to the given mask.
+ * @pool: IRQ pool to request from.
+ * @req_mask: cpumask requested for this IRQ.
+ *
+ * This function returns a pointer to IRQ, or ERR_PTR in case of error.
+ */
+struct mlx5_irq *
+mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+{
+	struct mlx5_irq *least_loaded_irq, *new_irq;
+
+	mutex_lock(&pool->lock);
+	least_loaded_irq = irq_pool_find_least_loaded(pool, req_mask);
+	if (least_loaded_irq &&
+	    mlx5_irq_read_locked(least_loaded_irq) < pool->min_threshold)
+		goto out;
+	/* We didn't find an IRQ with less than min_thres, try to allocate a new IRQ */
+	new_irq = irq_pool_request_irq(pool, req_mask);
+	if (IS_ERR(new_irq)) {
+		if (!least_loaded_irq) {
+			/* We failed to create an IRQ and we didn't find an IRQ */
+			mlx5_core_err(pool->dev, "Didn't find a matching IRQ. err = %ld\n",
+				      PTR_ERR(new_irq));
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
+	mlx5_irq_get_locked(least_loaded_irq);
+	if (mlx5_irq_read_locked(least_loaded_irq) > pool->max_threshold)
+		mlx5_core_dbg(pool->dev, "IRQ %u overloaded, pool_name: %s, %u EQs on this irq\n",
+			      pci_irq_vector(pool->dev->pdev,
+					     mlx5_irq_get_index(least_loaded_irq)), pool->name,
+			      mlx5_irq_read_locked(least_loaded_irq) / MLX5_EQ_REFS_PER_IRQ);
+unlock:
+	mutex_unlock(&pool->lock);
+	return least_loaded_irq;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 7028e4b43837..db58f5e3f457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -31,4 +31,15 @@ int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
 int mlx5_irq_get_index(struct mlx5_irq *irq);
 
+struct mlx5_irq_pool;
+#ifdef CONFIG_MLX5_SF
+struct mlx5_irq *mlx5_irq_affinity_request(struct mlx5_irq_pool *pool,
+					   const struct cpumask *req_mask);
+#else
+static inline struct mlx5_irq *
+mlx5_irq_affinity_request(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif
 #endif /* __MLX5_IRQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 656a55114600..496826a7a88b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -7,15 +7,12 @@
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
+#include "pci_irq.h"
 #include "lib/sf.h"
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
 
-#define MLX5_MAX_IRQ_NAME (32)
-/* max irq_index is 2047, so four chars */
-#define MLX5_MAX_IRQ_IDX_CHARS (4)
-
 #define MLX5_SFS_PER_CTRL_IRQ 64
 #define MLX5_IRQ_CTRL_SF_MAX 8
 /* min num of vectors for SFs to be enabled */
@@ -25,7 +22,6 @@
 #define MLX5_EQ_SHARE_IRQ_MAX_CTRL (UINT_MAX)
 #define MLX5_EQ_SHARE_IRQ_MIN_COMP (1)
 #define MLX5_EQ_SHARE_IRQ_MIN_CTRL (4)
-#define MLX5_EQ_REFS_PER_IRQ (2)
 
 struct mlx5_irq {
 	struct atomic_notifier_head nh;
@@ -37,16 +33,6 @@ struct mlx5_irq {
 	int irqn;
 };
 
-struct mlx5_irq_pool {
-	char name[MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS];
-	struct xa_limit xa_num_irqs;
-	struct mutex lock; /* sync IRQs creations */
-	struct xarray irqs;
-	u32 max_threshold;
-	u32 min_threshold;
-	struct mlx5_core_dev *dev;
-};
-
 struct mlx5_irq_table {
 	struct mlx5_irq_pool *pf_pool;
 	struct mlx5_irq_pool *sf_ctrl_pool;
@@ -164,7 +150,13 @@ static void irq_put(struct mlx5_irq *irq)
 	mutex_unlock(&pool->lock);
 }
 
-static int irq_get_locked(struct mlx5_irq *irq)
+int mlx5_irq_read_locked(struct mlx5_irq *irq)
+{
+	lockdep_assert_held(&irq->pool->lock);
+	return irq->refcount;
+}
+
+int mlx5_irq_get_locked(struct mlx5_irq *irq)
 {
 	lockdep_assert_held(&irq->pool->lock);
 	if (WARN_ON_ONCE(!irq->refcount))
@@ -178,7 +170,7 @@ static int irq_get(struct mlx5_irq *irq)
 	int err;
 
 	mutex_lock(&irq->pool->lock);
-	err = irq_get_locked(irq);
+	err = mlx5_irq_get_locked(irq);
 	mutex_unlock(&irq->pool->lock);
 	return err;
 }
@@ -215,8 +207,8 @@ static bool irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
 	return !strncmp("mlx5_sf", pool->name, strlen("mlx5_sf"));
 }
 
-static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i,
-				    struct cpumask *affinity)
+struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
+				const struct cpumask *affinity)
 {
 	struct mlx5_core_dev *dev = pool->dev;
 	char name[MLX5_MAX_IRQ_NAME];
@@ -306,79 +298,6 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 
 /* irq_pool API */
 
-/* creating an irq from irq_pool */
-static struct mlx5_irq *irq_pool_create_irq(struct mlx5_irq_pool *pool,
-					    struct cpumask *affinity)
-{
-	u32 irq_index;
-	int err;
-
-	err = xa_alloc(&pool->irqs, &irq_index, NULL, pool->xa_num_irqs,
-		       GFP_KERNEL);
-	if (err)
-		return ERR_PTR(err);
-	return irq_request(pool, irq_index, affinity);
-}
-
-/* looking for the irq with the smallest refcount and the same affinity */
-static struct mlx5_irq *irq_pool_find_least_loaded(struct mlx5_irq_pool *pool,
-						   struct cpumask *affinity)
-{
-	int start = pool->xa_num_irqs.min;
-	int end = pool->xa_num_irqs.max;
-	struct mlx5_irq *irq = NULL;
-	struct mlx5_irq *iter;
-	unsigned long index;
-
-	lockdep_assert_held(&pool->lock);
-	xa_for_each_range(&pool->irqs, index, iter, start, end) {
-		if (!cpumask_equal(iter->mask, affinity))
-			continue;
-		if (iter->refcount < pool->min_threshold)
-			return iter;
-		if (!irq || iter->refcount < irq->refcount)
-			irq = iter;
-	}
-	return irq;
-}
-
-/* requesting an irq from a given pool according to given affinity */
-static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
-						  struct cpumask *affinity)
-{
-	struct mlx5_irq *least_loaded_irq, *new_irq;
-
-	mutex_lock(&pool->lock);
-	least_loaded_irq = irq_pool_find_least_loaded(pool, affinity);
-	if (least_loaded_irq &&
-	    least_loaded_irq->refcount < pool->min_threshold)
-		goto out;
-	new_irq = irq_pool_create_irq(pool, affinity);
-	if (IS_ERR(new_irq)) {
-		if (!least_loaded_irq) {
-			mlx5_core_err(pool->dev, "Didn't find a matching IRQ. err = %ld\n",
-				      PTR_ERR(new_irq));
-			mutex_unlock(&pool->lock);
-			return new_irq;
-		}
-		/* We failed to create a new IRQ for the requested affinity,
-		 * sharing existing IRQ.
-		 */
-		goto out;
-	}
-	least_loaded_irq = new_irq;
-	goto unlock;
-out:
-	irq_get_locked(least_loaded_irq);
-	if (least_loaded_irq->refcount > pool->max_threshold)
-		mlx5_core_dbg(pool->dev, "IRQ %u overloaded, pool_name: %s, %u EQs on this irq\n",
-			      least_loaded_irq->irqn, pool->name,
-			      least_loaded_irq->refcount / MLX5_EQ_REFS_PER_IRQ);
-unlock:
-	mutex_unlock(&pool->lock);
-	return least_loaded_irq;
-}
-
 /* requesting an irq from a given pool according to given index */
 static struct mlx5_irq *
 irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
@@ -389,10 +308,10 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 	mutex_lock(&pool->lock);
 	irq = xa_load(&pool->irqs, vecidx);
 	if (irq) {
-		irq_get_locked(irq);
+		mlx5_irq_get_locked(irq);
 		goto unlock;
 	}
-	irq = irq_request(pool, vecidx, affinity);
+	irq = mlx5_irq_alloc(pool, vecidx, affinity);
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
@@ -457,7 +376,7 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
 		/* Allocate the IRQ in the last index of the pool */
 		irq = irq_pool_request_vector(pool, pool->xa_num_irqs.max, req_mask);
 	} else {
-		irq = irq_pool_request_affinity(pool, req_mask);
+		irq = mlx5_irq_affinity_request(pool, req_mask);
 	}
 
 	free_cpumask_var(req_mask);
@@ -489,7 +408,7 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 			/* In case an SF user request IRQ with vecidx */
 			irq = irq_pool_request_vector(pool, vecidx, NULL);
 		else
-			irq = irq_pool_request_affinity(pool, affinity);
+			irq = mlx5_irq_affinity_request(pool, affinity);
 		goto out;
 	}
 pf_irq:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
new file mode 100644
index 000000000000..5fee4ce57d6c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __PCI_IRQ_H__
+#define __PCI_IRQ_H__
+
+#include <linux/mlx5/driver.h>
+
+#define MLX5_MAX_IRQ_NAME (32)
+/* max irq_index is 2047, so four chars */
+#define MLX5_MAX_IRQ_IDX_CHARS (4)
+#define MLX5_EQ_REFS_PER_IRQ (2)
+
+struct mlx5_irq;
+
+struct mlx5_irq_pool {
+	char name[MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS];
+	struct xa_limit xa_num_irqs;
+	struct mutex lock; /* sync IRQs creations */
+	struct xarray irqs;
+	u32 max_threshold;
+	u32 min_threshold;
+	struct mlx5_core_dev *dev;
+};
+
+struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
+				const struct cpumask *affinity);
+int mlx5_irq_get_locked(struct mlx5_irq *irq);
+int mlx5_irq_read_locked(struct mlx5_irq *irq);
+
+#endif /* __PCI_IRQ_H__ */
-- 
2.33.1

