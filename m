Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E2A3A7580
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhFOEDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhFOEDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 098106141D;
        Tue, 15 Jun 2021 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729690;
        bh=zUrxgzG3wB9wVPjgkQXhvajzUqe5iIOKWiu5i74jTx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6T3vDVs/RW5fQhEH1IXSH46a9G+OPGw0PX5OR5rPQ389PWqkQGqkWzjQns3ph7iP
         6KoDct/4CDWwnmpO2eIR1roPO1nG2fA1M3N6RPo7QTtgYA+vzk6s6AZODEpO+DuJSu
         EK1u7CDpf5awDEXVNBSXgB//TQyRfU+NLaOh8UYWj+z+mRbzL8DTouywVjDItL637g
         ktC1dfYlYK+1HKIUiNH5ZU0V6aHOlAyKnYFbFlEApufQdQZzBWiVd02WmcUWCgskGv
         LwNG5GMpjTEKUQAwfqMak24aEX3NIYGul1yLCj7t6ac4waVh3sD/XW6dYFvsNwD9Xa
         MzuXOeuMmR9iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Delay IRQ destruction till all users are gone
Date:   Mon, 14 Jun 2021 21:01:12 -0700
Message-Id: <20210615040123.287101-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Shared IRQ are consumed by multiple EQ users and in order to properly
initialize and later release such IRQs, we add kref counting of IRQ
structure.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 55 ++++++++++++-------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c3373fb1cd7f..0e65ac3301c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -16,6 +16,8 @@ struct mlx5_irq {
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
+	struct kref kref;
+	int irqn;
 };
 
 struct mlx5_irq_table {
@@ -146,13 +148,35 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	return ret;
 }
 
+static void irq_release(struct kref *kref)
+{
+	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
+
+	free_irq(irq->irqn, &irq->nh);
+}
+
+static void irq_put(struct mlx5_irq *irq)
+{
+	kref_put(&irq->kref, irq_release);
+}
+
 int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 		       struct notifier_block *nb)
 {
 	struct mlx5_irq *irq;
+	int err;
 
 	irq = &irq_table->irq[vecidx];
-	return atomic_notifier_chain_register(&irq->nh, nb);
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
 }
 
 int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
@@ -161,6 +185,7 @@ int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 	struct mlx5_irq *irq;
 
 	irq = &irq_table->irq[vecidx];
+	irq_put(irq);
 	return atomic_notifier_chain_unregister(&irq->nh, nb);
 }
 
@@ -189,28 +214,26 @@ static int request_irqs(struct mlx5_core_dev *dev, int nvec)
 
 	for (i = 0; i < nvec; i++) {
 		struct mlx5_irq *irq = mlx5_irq_get(dev, i);
-		int irqn = pci_irq_vector(dev->pdev, i);
 
+		irq->irqn = pci_irq_vector(dev->pdev, i);
 		irq_set_name(name, i);
 		ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
 		snprintf(irq->name, MLX5_MAX_IRQ_NAME,
 			 "%s@pci:%s", name, pci_name(dev->pdev));
-		err = request_irq(irqn, mlx5_irq_int_handler, 0, irq->name,
+		err = request_irq(irq->irqn, mlx5_irq_int_handler, 0, irq->name,
 				  &irq->nh);
 		if (err) {
 			mlx5_core_err(dev, "Failed to request irq\n");
 			goto err_request_irq;
 		}
+		kref_init(&irq->kref);
 	}
 	return 0;
 
 err_request_irq:
-	while (i--) {
-		struct mlx5_irq *irq = mlx5_irq_get(dev, i);
-		int irqn = pci_irq_vector(dev->pdev, i);
+	while (i--)
+		irq_put(mlx5_irq_get(dev, i));
 
-		free_irq(irqn, &irq->nh);
-	}
 	return  err;
 }
 
@@ -264,10 +287,8 @@ static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	int vecidx = MLX5_IRQ_VEC_COMP_BASE + i;
 	struct mlx5_irq *irq;
-	int irqn;
 
 	irq = mlx5_irq_get(mdev, vecidx);
-	irqn = pci_irq_vector(mdev->pdev, vecidx);
 	if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
 		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
 		return -ENOMEM;
@@ -276,9 +297,9 @@ static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	cpumask_set_cpu(cpumask_local_spread(i, mdev->priv.numa_node),
 			irq->mask);
 	if (IS_ENABLED(CONFIG_SMP) &&
-	    irq_set_affinity_hint(irqn, irq->mask))
+	    irq_set_affinity_hint(irq->irqn, irq->mask))
 		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x",
-			       irqn);
+			       irq->irqn);
 
 	return 0;
 }
@@ -287,11 +308,9 @@ static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	int vecidx = MLX5_IRQ_VEC_COMP_BASE + i;
 	struct mlx5_irq *irq;
-	int irqn;
 
 	irq = mlx5_irq_get(mdev, vecidx);
-	irqn = pci_irq_vector(mdev->pdev, vecidx);
-	irq_set_affinity_hint(irqn, NULL);
+	irq_set_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
 }
 
@@ -344,8 +363,7 @@ static void unrequest_irqs(struct mlx5_core_dev *dev)
 	int i;
 
 	for (i = 0; i < table->nvec; i++)
-		free_irq(pci_irq_vector(dev->pdev, i),
-			 &mlx5_irq_get(dev, i)->nh);
+		irq_put(mlx5_irq_get(dev, i));
 }
 
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
@@ -422,8 +440,7 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	irq_clear_rmap(dev);
 	clear_comp_irqs_affinity_hints(dev);
 	for (i = 0; i < table->nvec; i++)
-		free_irq(pci_irq_vector(dev->pdev, i),
-			 &mlx5_irq_get(dev, i)->nh);
+		irq_release(&mlx5_irq_get(dev, i)->kref);
 	pci_free_irq_vectors(dev->pdev);
 	kfree(table->irq);
 }
-- 
2.31.1

