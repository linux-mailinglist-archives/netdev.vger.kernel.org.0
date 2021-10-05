Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4703A421B9E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhJEBRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231214AbhJEBQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF5EF6187D;
        Tue,  5 Oct 2021 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396490;
        bh=vnyLPayMDHKWbSF4TBl8cttuurF4+k8G6p7hIIr8+Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQk8ZTc33FUgS9Xp7x3yLHxOWK+78dRr4AohWeQ61jw6/GcLuqJ/DB2XaeVIrKF3j
         gjJqxeNY+7Zw1+P85b3GU247SvvuOF7PVYNZcqXdxE4Tl+zDSKhvBOFGZB4VljB8mA
         427nm9j+BdIwlq6PFfHxUGhTfNaQe14okoCP+L6/lAtdJtL27wEleGi/Zk4xkaJmio
         QGTnAgiV3BkwHNEhQByJZ09IOrEs2QGPbL6OtqmFggGmUZuLw83aTlnasONYxFruGP
         KnYiMlRho3E7B9oK2TLiaymeE/W0E+xoGd5FbP5vCjnNKSP8rdKk67iLoyCETW4oZ4
         nwP8NvviwNLuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Enable single IRQ for PCI Function
Date:   Mon,  4 Oct 2021 18:13:02 -0700
Message-Id: <20211005011302.41793-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Prior to this patch the driver requires two IRQs to function properly,
one required IRQ for control and at least one required IRQ for IO.

This requirement can be relaxed to one as the driver now allows
sharing of IRQs, so control and IO EQs can share the same irq.

This is needed for high scale amount of VFs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 26 ++++++++++++++-----
 include/linux/mlx5/eq.h                       |  1 -
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index a66144b54fc8..830444f927d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -196,6 +196,12 @@ static void irq_sf_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 
 static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 {
+	if (!pool->xa_num_irqs.max) {
+		/* in case we only have a single irq for the device */
+		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_combined%d", vecidx);
+		return;
+	}
+
 	if (vecidx == pool->xa_num_irqs.max) {
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async%d", vecidx);
 		return;
@@ -204,6 +210,11 @@ static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 	snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", vecidx);
 }
 
+static bool irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
+{
+	return !strncmp("mlx5_sf", pool->name, strlen("mlx5_sf"));
+}
+
 static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 {
 	struct mlx5_core_dev *dev = pool->dev;
@@ -215,7 +226,7 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 	irq->irqn = pci_irq_vector(dev->pdev, i);
-	if (!pool->name[0])
+	if (!irq_pool_is_sf_pool(pool))
 		irq_set_name(pool, name, i);
 	else
 		irq_sf_set_name(pool, name, i);
@@ -385,6 +396,9 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 	if (IS_ERR(irq) || !affinity)
 		goto unlock;
 	cpumask_copy(irq->mask, affinity);
+	if (!irq_pool_is_sf_pool(pool) && !pool->xa_num_irqs.max &&
+	    cpumask_empty(irq->mask))
+		cpumask_set_cpu(0, irq->mask);
 	irq_set_affinity_hint(irq->irqn, irq->mask);
 unlock:
 	mutex_unlock(&pool->lock);
@@ -577,6 +591,8 @@ void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
 
 int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
 {
+	if (!table->pf_pool->xa_num_irqs.max)
+		return 1;
 	return table->pf_pool->xa_num_irqs.max - table->pf_pool->xa_num_irqs.min;
 }
 
@@ -592,19 +608,15 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_sf(dev))
 		return 0;
 
-	pf_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
-		 MLX5_IRQ_VEC_COMP_BASE;
+	pf_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() + 1;
 	pf_vec = min_t(int, pf_vec, num_eqs);
-	if (pf_vec <= MLX5_IRQ_VEC_COMP_BASE)
-		return -ENOMEM;
 
 	total_vec = pf_vec;
 	if (mlx5_sf_max_functions(dev))
 		total_vec += MLX5_IRQ_CTRL_SF_MAX +
 			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
 
-	total_vec = pci_alloc_irq_vectors(dev->pdev, MLX5_IRQ_VEC_COMP_BASE + 1,
-					  total_vec, PCI_IRQ_MSIX);
+	total_vec = pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_MSIX);
 	if (total_vec < 0)
 		return total_vec;
 	pf_vec = min(pf_vec, total_vec);
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index cea6ecb4b73e..ea3ff5a8ced3 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -4,7 +4,6 @@
 #ifndef MLX5_CORE_EQ_H
 #define MLX5_CORE_EQ_H
 
-#define MLX5_IRQ_VEC_COMP_BASE 1
 #define MLX5_NUM_CMD_EQE   (32)
 #define MLX5_NUM_ASYNC_EQE (0x1000)
 #define MLX5_NUM_SPARE_EQE (0x80)
-- 
2.31.1

