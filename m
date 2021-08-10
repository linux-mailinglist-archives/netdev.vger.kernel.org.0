Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92943E51AF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhHJEAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhHJEAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9639B60FDA;
        Tue, 10 Aug 2021 03:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567984;
        bh=qnFLWcCuWCpaki04tXAZPyA5XTOA7xOSzV/I4K32FsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+lK++5vu96s3PdMJ/sCyJr/Y4zMugxU6Y1znZYhn9L1WCqFWyGM+hx3etRpHq4RB
         gZRJUivEm9tlcJwE6Z1E/0iHBmIXV4FDae8BZHh2d2EQ5jn7tEo2fn0+yRON+wZZ6m
         5apa983EALZ8fxjRxUp6DNV0cut8f8FnxZy57scMoDn95Reihx2OR2d8d4DdRD6vDI
         88peETCc4ptkb/Eod9RBwZC4VhM/yKKLSskjoDKr8K7vOwojDvA+6UIn4vYcTDvKh+
         ufFiAZf09pBgmL+QDWCPl0GmWqs0FjqpDagcUmcPby+xDU8GeYC1pot2DkXjg4pevS
         03JRe9jlZ2e2A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/12] net/mlx5: Destroy pool->mutex
Date:   Mon,  9 Aug 2021 20:59:20 -0700
Message-Id: <20210810035923.345745-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Destroy pool->mutex when we destroy the pool.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 7b923f6b5462..3465b363fc2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -440,6 +440,7 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	if (!pool)
 		return ERR_PTR(-ENOMEM);
 	pool->dev = dev;
+	mutex_init(&pool->lock);
 	xa_init_flags(&pool->irqs, XA_FLAGS_ALLOC);
 	pool->xa_num_irqs.min = start;
 	pool->xa_num_irqs.max = start + size - 1;
@@ -448,7 +449,6 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 			 name);
 	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
 	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
-	mutex_init(&pool->lock);
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
 		      name, size, start);
 	return pool;
@@ -462,6 +462,7 @@ static void irq_pool_free(struct mlx5_irq_pool *pool)
 	xa_for_each(&pool->irqs, index, irq)
 		irq_release(&irq->kref);
 	xa_destroy(&pool->irqs);
+	mutex_destroy(&pool->lock);
 	kvfree(pool);
 }
 
-- 
2.31.1

