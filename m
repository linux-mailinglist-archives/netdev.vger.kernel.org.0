Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321676C8919
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjCXXOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjCXXOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D391E1D3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4735DB82669
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02903C433D2;
        Fri, 24 Mar 2023 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699636;
        bh=MArunab015izxEP66kkmbB3ZIIiajaKbCUsfBKd+F90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9OAB/0LQP/glSufeDF7sikF/quXDCnJ1aWewkC4swNpBLEkGOmPMFlGQnkX/iSJg
         xarGSS/5wyItCpGYs3yrq94G4MJ4aaQFm6yliTiugvO3aiPZ+NWBQR0N6LIQWKWdKP
         AVjGdJOrVFa0tVZae6HBjUaAyFpYA5QTYiHeaUZ87nO9UGIXTcFGQJoIP77ZllPN8o
         CEhT/7ju7CkrF7W1NGDG22Vs/jSwUKkz9iVAy2shmKDxMlYWi76FNUvtiSvaSOCWFs
         IvBFwx6QBjVbG98euwMXbH9Yo/BcBxXsw5vrUJ7/CYdZiV/bTjr8DFZQv7wjW+uN2t
         L/r0XdwbR8enA==
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
Subject: [net-next V2 06/15] net/mlx5: Modify struct mlx5_irq to use struct msi_map
Date:   Fri, 24 Mar 2023 16:13:32 -0700
Message-Id: <20230324231341.29808-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Use the standard struct msi_map to store the vector number and irq
number pair in struct mlx5_irq.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c72736f1571f..c79775d0ac24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -29,8 +29,7 @@ struct mlx5_irq {
 	char name[MLX5_MAX_IRQ_NAME];
 	struct mlx5_irq_pool *pool;
 	int refcount;
-	u32 index;
-	int irqn;
+	struct msi_map map;
 };
 
 struct mlx5_irq_table {
@@ -128,14 +127,14 @@ static void irq_release(struct mlx5_irq *irq)
 {
 	struct mlx5_irq_pool *pool = irq->pool;
 
-	xa_erase(&pool->irqs, irq->index);
+	xa_erase(&pool->irqs, irq->map.index);
 	/* free_irq requires that affinity_hint and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
 	 */
-	irq_update_affinity_hint(irq->irqn, NULL);
+	irq_update_affinity_hint(irq->map.virq, NULL);
 	free_cpumask_var(irq->mask);
-	free_irq(irq->irqn, &irq->nh);
+	free_irq(irq->map.virq, &irq->nh);
 	kfree(irq);
 }
 
@@ -217,7 +216,7 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	irq = kzalloc(sizeof(*irq), GFP_KERNEL);
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
-	irq->irqn = pci_irq_vector(dev->pdev, i);
+	irq->map.virq = pci_irq_vector(dev->pdev, i);
 	if (!mlx5_irq_pool_is_sf_pool(pool))
 		irq_set_name(pool, name, i);
 	else
@@ -225,7 +224,7 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
 	snprintf(irq->name, MLX5_MAX_IRQ_NAME,
 		 "%s@pci:%s", name, pci_name(dev->pdev));
-	err = request_irq(irq->irqn, irq_int_handler, 0, irq->name,
+	err = request_irq(irq->map.virq, irq_int_handler, 0, irq->name,
 			  &irq->nh);
 	if (err) {
 		mlx5_core_err(dev, "Failed to request irq. err = %d\n", err);
@@ -238,23 +237,23 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	}
 	if (affinity) {
 		cpumask_copy(irq->mask, affinity);
-		irq_set_affinity_and_hint(irq->irqn, irq->mask);
+		irq_set_affinity_and_hint(irq->map.virq, irq->mask);
 	}
 	irq->pool = pool;
 	irq->refcount = 1;
-	irq->index = i;
-	err = xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
+	irq->map.index = i;
+	err = xa_err(xa_store(&pool->irqs, irq->map.index, irq, GFP_KERNEL));
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc xa entry for irq(%u). err = %d\n",
-			      irq->index, err);
+			      irq->map.index, err);
 		goto err_xa;
 	}
 	return irq;
 err_xa:
-	irq_update_affinity_hint(irq->irqn, NULL);
+	irq_update_affinity_hint(irq->map.virq, NULL);
 	free_cpumask_var(irq->mask);
 err_cpumask:
-	free_irq(irq->irqn, &irq->nh);
+	free_irq(irq->map.virq, &irq->nh);
 err_req_irq:
 	kfree(irq);
 	return ERR_PTR(err);
@@ -292,7 +291,7 @@ struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
 
 int mlx5_irq_get_index(struct mlx5_irq *irq)
 {
-	return irq->index;
+	return irq->map.index;
 }
 
 /* irq_pool API */
@@ -364,7 +363,7 @@ static void mlx5_irqs_release(struct mlx5_irq **irqs, int nirqs)
 	int i;
 
 	for (i = 0; i < nirqs; i++) {
-		synchronize_irq(irqs[i]->irqn);
+		synchronize_irq(irqs[i]->map.virq);
 		mlx5_irq_put(irqs[i]);
 	}
 }
@@ -433,7 +432,7 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 	if (IS_ERR(irq))
 		return irq;
 	mlx5_core_dbg(dev, "irq %u mapped to cpu %*pbl, %u EQs on this irq\n",
-		      irq->irqn, cpumask_pr_args(affinity),
+		      irq->map.virq, cpumask_pr_args(affinity),
 		      irq->refcount / MLX5_EQ_REFS_PER_IRQ);
 	return irq;
 }
-- 
2.39.2

