Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDABC6C1F00
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjCTSFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCTSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADDA1A663
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6661FB81065
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126C1C433EF;
        Mon, 20 Mar 2023 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334716;
        bh=rZvNFi3OssIl5V6G60orG/s9vdOW38koR8ySvMu/AZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDv3tL09shudozqJRVdKCpQ7Kl0IU8YZAsYn+ri5RXWwkAUXl1RIHcjWDsTdDLHbK
         T53AbkRvq4kMcQNLsrxZOF49O5dWEwAec9ydYRTt7t2uJOqJMGwxC+8RbyLGNIoSY7
         bk0F6JQOsLdiL5E3vxpw6X+sQFeMl/IKPKvC7rvRu7vw+dXPTdX+qsj10Oo4ujFx8Z
         +TpjRM5P8mVC+d4l/ZuBu8tsWPghaVgE0ul3p1JeLD8Fp/VizAMArEAc9651rVUbx/
         IWHGsmEbXlFMaOajgzWj+OI4mbbMT8ulOliXnUWSgNP0K/3HCfHMATZgKx9saGK21n
         zd5bX64PeeQnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 10/14] net/mlx5: Use dynamic msix vectors allocation
Date:   Mon, 20 Mar 2023 10:51:40 -0700
Message-Id: <20230320175144.153187-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Current implementation calculates the number and the partitioaning of
available interrupts vectors and then allocates all the interrupt
vectors.

Here, whenever dynamic msix allocation is supported, we change this to
use msix vectors dynamically so a vectors is actually allocated only
when needed. The current pool logic is kept in place to take care of
partitioning the vectors between the consumers and take care of
reference counting. However, the vectors are allocated only when needed.

Subsequent patches will make use of this to allocate vectors for VDPA.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 114 ++++++++----------
 .../mellanox/mlx5/core/irq_affinity.c         |   5 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  88 +++++++++++---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.h |   4 +-
 6 files changed, 129 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index ed75b527280e..888ccfcbcce6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -18,6 +18,7 @@
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
+#include "pci_irq.h"
 #include "devlink.h"
 #include "en_accel/ipsec.h"
 
@@ -61,9 +62,7 @@ struct mlx5_eq_table {
 	struct mlx5_irq_table	*irq_table;
 	struct mlx5_irq         **comp_irqs;
 	struct mlx5_irq         *ctrl_irq;
-#ifdef CONFIG_RFS_ACCEL
 	struct cpu_rmap		*rmap;
-#endif
 };
 
 #define MLX5_ASYNC_EVENT_MASK ((1ull << MLX5_EVENT_TYPE_PATH_MIG)	    | \
@@ -839,7 +838,7 @@ static int comp_irqs_request_pci(struct mlx5_core_dev *dev)
 	}
 spread_done:
 	rcu_read_unlock();
-	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
+	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs, &table->rmap);
 	kfree(cpus);
 	return ret;
 }
@@ -888,6 +887,40 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 	return ret;
 }
 
+#ifdef CONFIG_RFS_ACCEL
+static int alloc_rmap(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eq_table *eq_table = mdev->priv.eq_table;
+
+	/* rmap is a mapping between irq number and queue number.
+	 * Each irq can be assigned only to a single rmap.
+	 * Since SFs share IRQs, rmap mapping cannot function correctly
+	 * for irqs that are shared between different core/netdev RX rings.
+	 * Hence we don't allow netdev rmap for SFs.
+	 */
+	if (mlx5_core_is_sf(mdev))
+		return 0;
+
+	eq_table->rmap = alloc_irq_cpu_rmap(eq_table->num_comp_eqs);
+	if (!eq_table->rmap)
+		return -ENOMEM;
+	return 0;
+}
+
+static void free_rmap(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eq_table *eq_table = mdev->priv.eq_table;
+
+	if (eq_table->rmap) {
+		free_irq_cpu_rmap(eq_table->rmap);
+		eq_table->rmap = NULL;
+	}
+}
+#else
+static int alloc_rmap(struct mlx5_core_dev *mdev) { return 0; }
+static void free_rmap(struct mlx5_core_dev *mdev) {}
+#endif
+
 static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -903,6 +936,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 		kfree(eq);
 	}
 	comp_irqs_release(dev);
+	free_rmap(dev);
 }
 
 static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
@@ -929,9 +963,16 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	int err;
 	int i;
 
+	err = alloc_rmap(dev);
+	if (err)
+		return err;
+
 	ncomp_eqs = comp_irqs_request(dev);
-	if (ncomp_eqs < 0)
-		return ncomp_eqs;
+	if (ncomp_eqs < 0) {
+		err = ncomp_eqs;
+		goto err_irqs_req;
+	}
+
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	nent = comp_eq_depth_devlink_param_get(dev);
 
@@ -976,6 +1017,8 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	kfree(eq);
 clean:
 	destroy_comp_eqs(dev);
+err_irqs_req:
+	free_rmap(dev);
 	return err;
 }
 
@@ -1054,55 +1097,12 @@ struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn)
 	return ERR_PTR(-ENOENT);
 }
 
-static void clear_rmap(struct mlx5_core_dev *dev)
-{
-#ifdef CONFIG_RFS_ACCEL
-	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-
-	free_irq_cpu_rmap(eq_table->rmap);
-#endif
-}
-
-static int set_rmap(struct mlx5_core_dev *mdev)
-{
-	int err = 0;
-#ifdef CONFIG_RFS_ACCEL
-	struct mlx5_eq_table *eq_table = mdev->priv.eq_table;
-	int vecidx;
-
-	eq_table->rmap = alloc_irq_cpu_rmap(eq_table->num_comp_eqs);
-	if (!eq_table->rmap) {
-		err = -ENOMEM;
-		mlx5_core_err(mdev, "Failed to allocate cpu_rmap. err %d", err);
-		goto err_out;
-	}
-
-	for (vecidx = 0; vecidx < eq_table->num_comp_eqs; vecidx++) {
-		err = irq_cpu_rmap_add(eq_table->rmap,
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
-	clear_rmap(mdev);
-err_out:
-#endif
-	return err;
-}
-
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 
 	mutex_lock(&table->lock); /* sync with create/destroy_async_eq */
-	if (!mlx5_core_is_sf(dev))
-		clear_rmap(dev);
 	mlx5_irq_table_destroy(dev);
 	mutex_unlock(&table->lock);
 }
@@ -1139,18 +1139,6 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 		goto err_async_eqs;
 	}
 
-	if (!mlx5_core_is_sf(dev)) {
-		/* rmap is a mapping between irq number and queue number.
-		 * each irq can be assign only to a single rmap.
-		 * since SFs share IRQs, rmap mapping cannot function correctly
-		 * for irqs that are shared for different core/netdev RX rings.
-		 * Hence we don't allow netdev rmap for SFs
-		 */
-		err = set_rmap(dev);
-		if (err)
-			goto err_rmap;
-	}
-
 	err = create_comp_eqs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to create completion EQs\n");
@@ -1158,10 +1146,8 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 	}
 
 	return 0;
+
 err_comp_eqs:
-	if (!mlx5_core_is_sf(dev))
-		clear_rmap(dev);
-err_rmap:
 	destroy_async_eqs(dev);
 err_async_eqs:
 	return err;
@@ -1169,8 +1155,6 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_core_is_sf(dev))
-		clear_rmap(dev);
 	destroy_comp_eqs(dev);
 	destroy_async_eqs(dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 6535e8813178..fa467335526e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -65,7 +65,8 @@ irq_pool_request_irq(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_de
 			cpu_get(pool, cpumask_first(&af_desc->mask));
 	}
 	return mlx5_irq_alloc(pool, irq_index,
-			      cpumask_empty(&auto_desc.mask) ? af_desc : &auto_desc);
+			      cpumask_empty(&auto_desc.mask) ? af_desc : &auto_desc,
+			      NULL);
 }
 
 /* Looking for the IRQ with the smallest refcount that fits req_mask.
@@ -205,7 +206,7 @@ int mlx5_irq_affinity_irqs_request_auto(struct mlx5_core_dev *dev, int nirqs,
 			 * The PF IRQs are already allocated and binded to CPU
 			 * at this point. Hence, only an index is needed.
 			 */
-			irq = mlx5_irq_request(dev, i, NULL);
+			irq = mlx5_irq_request(dev, i, NULL, NULL);
 		if (IS_ERR(irq))
 			break;
 		irqs[i] = irq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f1de152a6113..bbc9b4188212 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -46,9 +46,6 @@
 #include <linux/kmod.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
-#ifdef CONFIG_RFS_ACCEL
-#include <linux/cpu_rmap.h>
-#endif
 #include <linux/version.h>
 #include <net/devlink.h>
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 7e0dac74721e..efd0c299c5c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -9,6 +9,7 @@
 #define MLX5_COMP_EQS_PER_SF 8
 
 struct mlx5_irq;
+struct cpu_rmap;
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
@@ -25,9 +26,10 @@ int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev);
 void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq);
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct irq_affinity_desc *af_desc);
+				  struct irq_affinity_desc *af_desc,
+				  struct cpu_rmap **rmap);
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
-			      struct mlx5_irq **irqs);
+			      struct mlx5_irq **irqs, struct cpu_rmap **rmap);
 void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c8e2b1ac7fe5..7fa63d31ae5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -9,6 +9,7 @@
 #include "mlx5_irq.h"
 #include "pci_irq.h"
 #include "lib/sf.h"
+#include "lib/eq.h"
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
@@ -126,15 +127,26 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 static void irq_release(struct mlx5_irq *irq)
 {
 	struct mlx5_irq_pool *pool = irq->pool;
+#ifdef CONFIG_RFS_ACCEL
+	struct cpu_rmap *rmap;
+#endif
 
 	xa_erase(&pool->irqs, irq->map.index);
-	/* free_irq requires that affinity_hint and rmap will be cleared
-	 * before calling it. This is why there is asymmetry with set_rmap
-	 * which should be called after alloc_irq but before request_irq.
+	/* free_irq requires that affinity_hint and rmap will be cleared before
+	 * calling it. To satisfy this requirement, we call
+	 * irq_cpu_rmap_remove() to remove the notifier
 	 */
 	irq_update_affinity_hint(irq->map.virq, NULL);
+#ifdef CONFIG_RFS_ACCEL
+	rmap = mlx5_eq_table_get_rmap(pool->dev);
+	if (rmap && irq->map.index)
+		irq_cpu_rmap_remove(rmap, irq->map.virq);
+#endif
+
 	free_cpumask_var(irq->mask);
 	free_irq(irq->map.virq, &irq->nh);
+	if (irq->map.index && pci_msix_can_alloc_dyn(pool->dev->pdev))
+		pci_msix_free_irq(pool->dev->pdev, irq->map);
 	kfree(irq);
 }
 
@@ -197,7 +209,7 @@ static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 		return;
 	}
 
-	if (vecidx == pool->xa_num_irqs.max) {
+	if (!vecidx) {
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async%d", vecidx);
 		return;
 	}
@@ -206,7 +218,8 @@ static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 }
 
 struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
-				struct irq_affinity_desc *af_desc)
+				struct irq_affinity_desc *af_desc,
+				struct cpu_rmap **rmap)
 {
 	struct mlx5_core_dev *dev = pool->dev;
 	char name[MLX5_MAX_IRQ_NAME];
@@ -216,7 +229,28 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	irq = kzalloc(sizeof(*irq), GFP_KERNEL);
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
-	irq->map.virq = pci_irq_vector(dev->pdev, i);
+	if (!i || !pci_msix_can_alloc_dyn(dev->pdev)) {
+		/* The vector at index 0 was already allocated.
+		 * Just get the irq number. If dynamic irq is not supported
+		 * vectors have also been allocated.
+		 */
+		irq->map.virq = pci_irq_vector(dev->pdev, i);
+		irq->map.index = 0;
+	} else {
+		irq->map = pci_msix_alloc_irq_at(dev->pdev, MSI_ANY_INDEX, af_desc);
+		if (!irq->map.virq) {
+			err = irq->map.index;
+			goto err_alloc_irq;
+		}
+	}
+
+	if (i && rmap && *rmap) {
+#ifdef CONFIG_RFS_ACCEL
+		err = irq_cpu_rmap_add(*rmap, irq->map.virq);
+		if (err)
+			goto err_irq_rmap;
+#endif
+	}
 	if (!mlx5_irq_pool_is_sf_pool(pool))
 		irq_set_name(pool, name, i);
 	else
@@ -256,6 +290,16 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 err_cpumask:
 	free_irq(irq->map.virq, &irq->nh);
 err_req_irq:
+#ifdef CONFIG_RFS_ACCEL
+	if (i && rmap && *rmap) {
+		free_irq_cpu_rmap(*rmap);
+		*rmap = NULL;
+	}
+err_irq_rmap:
+#endif
+	if (i && pci_msix_can_alloc_dyn(dev->pdev))
+		pci_msix_free_irq(dev->pdev, irq->map);
+err_alloc_irq:
 	kfree(irq);
 	return ERR_PTR(err);
 }
@@ -300,7 +344,8 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 /* requesting an irq from a given pool according to given index */
 static struct mlx5_irq *
 irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
-			struct irq_affinity_desc *af_desc)
+			struct irq_affinity_desc *af_desc,
+			struct cpu_rmap **rmap)
 {
 	struct mlx5_irq *irq;
 
@@ -310,7 +355,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 		mlx5_irq_get_locked(irq);
 		goto unlock;
 	}
-	irq = mlx5_irq_alloc(pool, vecidx, af_desc);
+	irq = mlx5_irq_alloc(pool, vecidx, af_desc, rmap);
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
@@ -401,8 +446,8 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
 			/* In case we only have a single IRQ for PF/VF */
 			cpumask_set_cpu(cpumask_first(cpu_online_mask), &af_desc.mask);
 		}
-		/* Allocate the IRQ in the last index of the pool */
-		irq = irq_pool_request_vector(pool, pool->xa_num_irqs.max, &af_desc);
+		/* Allocate the IRQ in index 0. The vector was already allocated */
+		irq = irq_pool_request_vector(pool, 0, &af_desc, NULL);
 	} else {
 		irq = mlx5_irq_affinity_request(pool, &af_desc);
 	}
@@ -416,18 +461,20 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
  * @vecidx: vector index of the IRQ. This argument is ignore if affinity is
  * provided.
  * @af_desc: affinity descriptor for this IRQ.
+ * @rmap: pointer to reverse map pointer for completion interrupts
  *
  * This function returns a pointer to IRQ, or ERR_PTR in case of error.
  */
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct irq_affinity_desc *af_desc)
+				  struct irq_affinity_desc *af_desc,
+				  struct cpu_rmap **rmap)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 	struct mlx5_irq_pool *pool;
 	struct mlx5_irq *irq;
 
 	pool = irq_table->pcif_pool;
-	irq = irq_pool_request_vector(pool, vecidx, af_desc);
+	irq = irq_pool_request_vector(pool, vecidx, af_desc, rmap);
 	if (IS_ERR(irq))
 		return irq;
 	mlx5_core_dbg(dev, "irq %u mapped to cpu %*pbl, %u EQs on this irq\n",
@@ -452,6 +499,7 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
  * @cpus: CPUs array for binding the IRQs
  * @nirqs: number of IRQs to request.
  * @irqs: an output array of IRQs pointers.
+ * @rmap: pointer to reverse map pointer for completion interrupts
  *
  * Each IRQ is bound to at most 1 CPU.
  * This function is requests nirqs IRQs, starting from @vecidx.
@@ -460,7 +508,7 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
  * @nirqs), if successful, or a negative error code in case of an error.
  */
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
-			      struct mlx5_irq **irqs)
+			      struct mlx5_irq **irqs, struct cpu_rmap **rmap)
 {
 	struct irq_affinity_desc af_desc;
 	struct mlx5_irq *irq;
@@ -469,7 +517,7 @@ int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 	af_desc.is_managed = 1;
 	for (i = 0; i < nirqs; i++) {
 		cpumask_set_cpu(cpus[i], &af_desc.mask);
-		irq = mlx5_irq_request(dev, i, &af_desc);
+		irq = mlx5_irq_request(dev, i + 1, &af_desc, rmap);
 		if (IS_ERR(irq))
 			break;
 		cpumask_clear(&af_desc.mask);
@@ -630,7 +678,9 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int total_vec;
 	int pcif_vec;
+	int req_vec;
 	int err;
+	int n;
 
 	if (mlx5_core_is_sf(dev))
 		return 0;
@@ -642,11 +692,13 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (mlx5_sf_max_functions(dev))
 		total_vec += MLX5_IRQ_CTRL_SF_MAX +
 			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
+	total_vec = min_t(int, total_vec, pci_msix_vec_count(dev->pdev));
+	pcif_vec = min_t(int, pcif_vec, pci_msix_vec_count(dev->pdev));
 
-	total_vec = pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_MSIX);
-	if (total_vec < 0)
-		return total_vec;
-	pcif_vec = min(pcif_vec, total_vec);
+	req_vec = pci_msix_can_alloc_dyn(dev->pdev) ? 1 : total_vec;
+	n = pci_alloc_irq_vectors(dev->pdev, 1, req_vec, PCI_IRQ_MSIX);
+	if (n < 0)
+		return n;
 
 	err = irq_pools_init(dev, total_vec - pcif_vec, pcif_vec);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
index ea39e4027d8a..d3a77a0ab848 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
@@ -12,6 +12,7 @@
 #define MLX5_EQ_REFS_PER_IRQ (2)
 
 struct mlx5_irq;
+struct cpu_rmap;
 
 struct mlx5_irq_pool {
 	char name[MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS];
@@ -31,7 +32,8 @@ static inline bool mlx5_irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
 }
 
 struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
-				struct irq_affinity_desc *af_desc);
+				struct irq_affinity_desc *af_desc,
+				struct cpu_rmap **rmap);
 int mlx5_irq_get_locked(struct mlx5_irq *irq);
 int mlx5_irq_read_locked(struct mlx5_irq *irq);
 int mlx5_irq_put(struct mlx5_irq *irq);
-- 
2.39.2

