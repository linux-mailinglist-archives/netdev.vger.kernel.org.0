Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ECE3A7587
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhFOEDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhFOEDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FB96008E;
        Tue, 15 Jun 2021 04:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729692;
        bh=gouvN91wLUhsdtfRcA9qAzhJQw/RWzSXPxiKWY+/HTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp5OPC2cWRPRofYiVlXdnvAkTSm/IeWSb4r1L/LXaTkwzjY/3sCvznmEPJu9N9R9H
         /KQTvx0GK7RDxUlaqppH5hhnNY9uxA+IRQatk0Eur48/UQijkGHsT3VBDn0vJmjbLh
         c4cgU58GD0po39hxcMzm49DsjlbFPWFZOtb8J7cjZrTImwPlTEkF812amhRkmNtvlt
         C+TC+0VuDLqM3CQmeF7MANAGPCg/mzzUAu5iwM3JbQjM8UTwHXSdwi2HuX2KS7Q+qv
         S+qV+fVt6JxVqeQIG5JTp3tofgmaM7cEY3Oqx3FuFhr4wmPA6CBayGkvDGU24nvmP9
         s+OqOaBhD8MAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Extend mlx5_irq_request to request IRQ from the kernel
Date:   Mon, 14 Jun 2021 21:01:17 -0700
Message-Id: <20210615040123.287101-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Extend mlx5_irq_request so that IRQs will be requested upon EQ creation,
and not on driver boot.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 128 ++++++++----------
 1 file changed, 57 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 6a5a6ec0ddbf..7d6ca2581532 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -17,7 +17,6 @@ struct mlx5_irq {
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
-	spinlock_t lock; /* protects affinity assignment */
 	struct kref kref;
 	int irqn;
 };
@@ -60,7 +59,7 @@ int mlx5_irq_get_num_comp(struct mlx5_irq_table *table)
 
 static struct mlx5_irq *mlx5_irq_get(struct mlx5_core_dev *dev, int vecidx)
 {
-	struct mlx5_irq_table *irq_table = dev->priv.irq_table;
+	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 
 	return &irq_table->irq[vecidx];
 }
@@ -192,37 +191,7 @@ int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 	return atomic_notifier_chain_unregister(&irq->nh, nb);
 }
 
-void mlx5_irq_release(struct mlx5_irq *irq)
-{
-	synchronize_irq(irq->irqn);
-	irq_put(irq);
-}
-
-struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
-				  struct cpumask *affinity)
-{
-	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
-	struct mlx5_irq *irq = &table->irq[vecidx];
-	int err;
-
-	err = kref_get_unless_zero(&irq->kref);
-	if (!err)
-		return ERR_PTR(-ENOENT);
-
-	spin_lock(&irq->lock);
-	if (!cpumask_empty(irq->mask)) {
-		/* already configured */
-		spin_unlock(&irq->lock);
-		return irq;
-	}
-
-	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
-	spin_unlock(&irq->lock);
-	return irq;
-}
-
-static irqreturn_t mlx5_irq_int_handler(int irq, void *nh)
+static irqreturn_t irq_int_handler(int irq, void *nh)
 {
 	atomic_notifier_call_chain(nh, 0, NULL);
 	return IRQ_HANDLED;
@@ -230,7 +199,7 @@ static irqreturn_t mlx5_irq_int_handler(int irq, void *nh)
 
 static void irq_set_name(char *name, int vecidx)
 {
-	if (vecidx == 0) {
+	if (!vecidx) {
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async");
 		return;
 	}
@@ -239,41 +208,67 @@ static void irq_set_name(char *name, int vecidx)
 		 vecidx - MLX5_IRQ_VEC_COMP_BASE);
 }
 
-static int request_irqs(struct mlx5_core_dev *dev, int nvec)
+static int irq_request(struct mlx5_core_dev *dev, int i)
 {
+	struct mlx5_irq *irq = mlx5_irq_get(dev, i);
 	char name[MLX5_MAX_IRQ_NAME];
 	int err;
-	int i;
-
-	for (i = 0; i < nvec; i++) {
-		struct mlx5_irq *irq = mlx5_irq_get(dev, i);
-
-		irq->irqn = pci_irq_vector(dev->pdev, i);
-		irq_set_name(name, i);
-		ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
-		snprintf(irq->name, MLX5_MAX_IRQ_NAME,
-			 "%s@pci:%s", name, pci_name(dev->pdev));
-		err = request_irq(irq->irqn, mlx5_irq_int_handler, 0, irq->name,
-				  &irq->nh);
-		if (err) {
-			mlx5_core_err(dev, "Failed to request irq\n");
-			goto err_request_irq;
-		}
-		if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
-			mlx5_core_warn(dev, "zalloc_cpumask_var failed\n");
-			err = -ENOMEM;
-			goto err_request_irq;
-		}
-		spin_lock_init(&irq->lock);
-		kref_init(&irq->kref);
+
+	irq->irqn = pci_irq_vector(dev->pdev, i);
+	irq_set_name(name, i);
+	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
+	snprintf(irq->name, MLX5_MAX_IRQ_NAME,
+		 "%s@pci:%s", name, pci_name(dev->pdev));
+	err = request_irq(irq->irqn, irq_int_handler, 0, irq->name,
+			  &irq->nh);
+	if (err) {
+		mlx5_core_err(dev, "Failed to request irq. err = %d\n", err);
+		return err;
 	}
+	if (!zalloc_cpumask_var(&irq->mask, GFP_KERNEL)) {
+		mlx5_core_warn(dev, "zalloc_cpumask_var failed\n");
+		free_irq(irq->irqn, &irq->nh);
+		return -ENOMEM;
+	}
+	kref_init(&irq->kref);
 	return 0;
+}
 
-err_request_irq:
-	while (i--)
-		irq_put(mlx5_irq_get(dev, i));
+/**
+ * mlx5_irq_release - release an IRQ back to the system.
+ * @irq: irq to be released.
+ */
+void mlx5_irq_release(struct mlx5_irq *irq)
+{
+	synchronize_irq(irq->irqn);
+	irq_put(irq);
+}
 
-	return  err;
+/**
+ * mlx5_irq_request - request an IRQ for mlx5 device.
+ * @dev: mlx5 device that requesting the IRQ.
+ * @vecidx: vector index of the IRQ. This argument is ignore if affinity is
+ * provided.
+ * @affinity: cpumask requested for this IRQ.
+ *
+ * This function returns a pointer to IRQ, or ERR_PTR in case of error.
+ */
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx,
+				  struct cpumask *affinity)
+{
+	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
+	struct mlx5_irq *irq = &table->irq[vecidx];
+	int ret;
+
+	ret = kref_get_unless_zero(&irq->kref);
+	if (ret)
+		return irq;
+	ret = irq_request(dev, vecidx);
+	if (ret)
+		return ERR_PTR(ret);
+	cpumask_copy(irq->mask, affinity);
+	irq_set_affinity_hint(irq->irqn, irq->mask);
+	return irq;
 }
 
 static void irq_clear_rmap(struct mlx5_core_dev *dev)
@@ -369,14 +364,8 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_set_rmap;
 
-	err = request_irqs(dev, nvec);
-	if (err)
-		goto err_request_irqs;
-
 	return 0;
 
-err_request_irqs:
-	irq_clear_rmap(dev);
 err_set_rmap:
 	pci_free_irq_vectors(dev->pdev);
 err_free_irq:
@@ -392,14 +381,11 @@ static void irq_table_clear_rmap(struct mlx5_irq_table *table)
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
-	int i;
 
 	if (mlx5_core_is_sf(dev))
 		return;
 
 	irq_table_clear_rmap(table);
-	for (i = 0; i < table->nvec; i++)
-		irq_release(&mlx5_irq_get(dev, i)->kref);
 	pci_free_irq_vectors(dev->pdev);
 	kfree(table->irq);
 }
-- 
2.31.1

