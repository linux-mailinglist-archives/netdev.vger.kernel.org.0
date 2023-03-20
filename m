Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAFC6C1EBD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCTR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCTR6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:58:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73EA3B0E0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3656B81060
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366A2C4339C;
        Mon, 20 Mar 2023 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334712;
        bh=PXI8pTYoWdHl/qTHTj0t65ljhjWHaJf7mXvrHtXlSvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2B4abtfURsTxz9k/ZUtrZL6T97Ppl3JFOIleFoxyhDudDZtJy0Amr6BotthQCkJ8
         sTW+hJf6XyL6oLAMixg21xWE73zVBkKlm90/eBorI98g71pWIUEL80KFXUCBw84FZX
         JUSCf5JaqTyq+7T2ufx4vLAoy4yXrd1LAiWQLt1wyMnlIx/Bxs+4qOJcMUjj5fjQdf
         9PkxBBWqz3AKg7njSUC3zWdf8nJlDTmsuwTspWbZDVeqkalj5CuL6h5e5CxqMe9NG/
         Pgsv+Rl3cVrOCZzxXFnEKUww5dpHcuBqppnL9asUum03BhesnUZlV+WpCa5IUmVP5c
         joQ1zalndzI6w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 06/14] net/mlx5: Modify struct mlx5_irq to use struct msi_map
Date:   Mon, 20 Mar 2023 10:51:36 -0700
Message-Id: <20230320175144.153187-7-saeed@kernel.org>
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

Use the standard struct msi_map to store the vector number and irq
number pair in struct mlx5_irq.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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

