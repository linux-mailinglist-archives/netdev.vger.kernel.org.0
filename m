Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B03E9774
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhHKSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhHKSSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FCEF60E78;
        Wed, 11 Aug 2021 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705895;
        bh=CbA8nd6rG8YLWB86ESDqCoMxSfnnH6kbv1N1xdaj6fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI8sr28OvEr9DbeUp6YffOSwQu/d2n/rfrejxJQs7UddjVBttSSrUpl2Opse/1jwB
         RAKjx5h25IsDr2dxsj0trPnzp2Per/oppGDXfz6tINo5Y7oj7U1QxPw1cldgfkHOKD
         1M2gFp+N7Ho7aAlpgzf8/c/YVf96q9vx0BPhpu9Q19VZdC8uvz3RzrKcKOBdR2qs7n
         zIbeJIdGcexvn8xGyyVYJLXkMM0krDOgmZz4r/xWjNoxp3QgGqPAO832k3qtcZ6L9C
         oqnpGnsxO9r07CuVH6CSY/92cmPxWDKROL5Bx4TIe09rhRJYUkBGovViYw/OWDlkQ2
         ITvZ+jnuJ31kA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/12] net/mlx5: Refcount mlx5_irq with integer
Date:   Wed, 11 Aug 2021 11:16:52 -0700
Message-Id: <20210811181658.492548-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, all access to mlx5 IRQs are done undere a lock. Hance, there
isn't a reason to have kref in struct mlx5_irq.
Switch it to integer.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 65 +++++++++++++------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 717b9f1850ac..60bfcad1873c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -32,7 +32,7 @@ struct mlx5_irq {
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
 	struct mlx5_irq_pool *pool;
-	struct kref kref;
+	int refcount;
 	u32 index;
 	int irqn;
 };
@@ -138,9 +138,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	return ret;
 }
 
-static void irq_release(struct kref *kref)
+static void irq_release(struct mlx5_irq *irq)
 {
-	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
 	struct mlx5_irq_pool *pool = irq->pool;
 
 	xa_erase(&pool->irqs, irq->index);
@@ -159,10 +158,31 @@ static void irq_put(struct mlx5_irq *irq)
 	struct mlx5_irq_pool *pool = irq->pool;
 
 	mutex_lock(&pool->lock);
-	kref_put(&irq->kref, irq_release);
+	irq->refcount--;
+	if (!irq->refcount)
+		irq_release(irq);
 	mutex_unlock(&pool->lock);
 }
 
+static int irq_get_locked(struct mlx5_irq *irq)
+{
+	lockdep_assert_held(&irq->pool->lock);
+	if (WARN_ON_ONCE(!irq->refcount))
+		return 0;
+	irq->refcount++;
+	return 1;
+}
+
+static int irq_get(struct mlx5_irq *irq)
+{
+	int err;
+
+	mutex_lock(&irq->pool->lock);
+	err = irq_get_locked(irq);
+	mutex_unlock(&irq->pool->lock);
+	return err;
+}
+
 static irqreturn_t irq_int_handler(int irq, void *nh)
 {
 	atomic_notifier_call_chain(nh, 0, NULL);
@@ -214,7 +234,7 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 		err = -ENOMEM;
 		goto err_cpumask;
 	}
-	kref_init(&irq->kref);
+	irq->refcount = 1;
 	irq->index = i;
 	err = xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
 	if (err) {
@@ -235,18 +255,18 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 {
-	int err;
+	int ret;
 
-	err = kref_get_unless_zero(&irq->kref);
-	if (WARN_ON_ONCE(!err))
+	ret = irq_get(irq);
+	if (!ret)
 		/* Something very bad happens here, we are enabling EQ
 		 * on non-existing IRQ.
 		 */
 		return -ENOENT;
-	err = atomic_notifier_chain_register(&irq->nh, nb);
-	if (err)
+	ret = atomic_notifier_chain_register(&irq->nh, nb);
+	if (ret)
 		irq_put(irq);
-	return err;
+	return ret;
 }
 
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
@@ -301,10 +321,9 @@ static struct mlx5_irq *irq_pool_find_least_loaded(struct mlx5_irq_pool *pool,
 	xa_for_each_range(&pool->irqs, index, iter, start, end) {
 		if (!cpumask_equal(iter->mask, affinity))
 			continue;
-		if (kref_read(&iter->kref) < pool->min_threshold)
+		if (iter->refcount < pool->min_threshold)
 			return iter;
-		if (!irq || kref_read(&iter->kref) <
-		    kref_read(&irq->kref))
+		if (!irq || iter->refcount < irq->refcount)
 			irq = iter;
 	}
 	return irq;
@@ -319,7 +338,7 @@ static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
 	mutex_lock(&pool->lock);
 	least_loaded_irq = irq_pool_find_least_loaded(pool, affinity);
 	if (least_loaded_irq &&
-	    kref_read(&least_loaded_irq->kref) < pool->min_threshold)
+	    least_loaded_irq->refcount < pool->min_threshold)
 		goto out;
 	new_irq = irq_pool_create_irq(pool, affinity);
 	if (IS_ERR(new_irq)) {
@@ -337,11 +356,11 @@ static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
 	least_loaded_irq = new_irq;
 	goto unlock;
 out:
-	kref_get(&least_loaded_irq->kref);
-	if (kref_read(&least_loaded_irq->kref) > pool->max_threshold)
+	irq_get_locked(least_loaded_irq);
+	if (least_loaded_irq->refcount > pool->max_threshold)
 		mlx5_core_dbg(pool->dev, "IRQ %u overloaded, pool_name: %s, %u EQs on this irq\n",
 			      least_loaded_irq->irqn, pool->name,
-			      kref_read(&least_loaded_irq->kref) / MLX5_EQ_REFS_PER_IRQ);
+			      least_loaded_irq->refcount / MLX5_EQ_REFS_PER_IRQ);
 unlock:
 	mutex_unlock(&pool->lock);
 	return least_loaded_irq;
@@ -357,7 +376,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 	mutex_lock(&pool->lock);
 	irq = xa_load(&pool->irqs, vecidx);
 	if (irq) {
-		kref_get(&irq->kref);
+		irq_get_locked(irq);
 		goto unlock;
 	}
 	irq = irq_request(pool, vecidx);
@@ -424,7 +443,7 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 		return irq;
 	mlx5_core_dbg(dev, "irq %u mapped to cpu %*pbl, %u EQs on this irq\n",
 		      irq->irqn, cpumask_pr_args(affinity),
-		      kref_read(&irq->kref) / MLX5_EQ_REFS_PER_IRQ);
+		      irq->refcount / MLX5_EQ_REFS_PER_IRQ);
 	return irq;
 }
 
@@ -456,8 +475,12 @@ static void irq_pool_free(struct mlx5_irq_pool *pool)
 	struct mlx5_irq *irq;
 	unsigned long index;
 
+	/* There are cases in which we are destrying the irq_table before
+	 * freeing all the IRQs, fast teardown for example. Hence, free the irqs
+	 * which might not have been freed.
+	 */
 	xa_for_each(&pool->irqs, index, irq)
-		irq_release(&irq->kref);
+		irq_release(irq);
 	xa_destroy(&pool->irqs);
 	kvfree(pool);
 }
-- 
2.31.1

