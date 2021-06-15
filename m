Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3873A7586
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFOEDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhFOEDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A63F861416;
        Tue, 15 Jun 2021 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729691;
        bh=co+bBBntoA/WzLJOwEbpvbVwu5qdqmj36w7SQmp7cdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyjxc+AAwb00Lk3i47oKZMo0xJDyydMLZrzVjG2s4KJC9TuXz9gZw5E/rqBzL+t9g
         MOS6sb5kP1e+PZ+zX3YD80qzSRwUq6pUUNCw1G/1Eu0rPq5Yr5duGFmtuu7+CoT+aT
         lZjj+VkN5JY6m28A8pAv2ZMxs5AkosOHn3DHhtvliQRvj4tJefUjmfTcXEEtpICQJi
         1CLls3GStyonM+WYExIBZJP8dfqPZN7PEBVgFH4bzVvC4IbN6PIu7p6JxYAOUP/PI3
         y5RY8baGr9bqu9y5Ny40IGE/owoCudWvV4Q58agVQngiszni2w5+5DuWo7iQO07VmA
         hKyF5hU0+w2Ew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Removing rmap per IRQ
Date:   Mon, 14 Jun 2021 21:01:16 -0700
Message-Id: <20210615040123.287101-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In next patches, IRQs will be requested according to demand, instead of
statically on driver boot.
Also, currently, rmap is managed by the IRQ layer. rmap management will
move out from the IRQ layer in future patches.

Therefore, we want to remove the IRQ from the rmap, when IRQ is destroyed,
instead of removing all the IRQs from the rmap when irq_table is destroyed.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c   | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 81b06b5693cd..6a5a6ec0ddbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -154,8 +154,14 @@ static void irq_release(struct kref *kref)
 {
 	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
 
+	/* free_irq requires that affinity and rmap will be cleared
+	 * before calling it. This is why there is asymmetry with set_rmap
+	 * which should be called after alloc_irq but before request_irq.
+	 */
 	irq_set_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
+	/* this line is releasing this irq from the rmap */
+	irq_set_affinity_notifier(irq->irqn, NULL);
 	free_irq(irq->irqn, &irq->nh);
 }
 
@@ -378,6 +384,11 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	return err;
 }
 
+static void irq_table_clear_rmap(struct mlx5_irq_table *table)
+{
+	cpu_rmap_put(table->rmap);
+}
+
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
@@ -386,11 +397,7 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_sf(dev))
 		return;
 
-	/* free_irq requires that affinity and rmap will be cleared
-	 * before calling it. This is why there is asymmetry with set_rmap
-	 * which should be called after alloc_irq but before request_irq.
-	 */
-	irq_clear_rmap(dev);
+	irq_table_clear_rmap(table);
 	for (i = 0; i < table->nvec; i++)
 		irq_release(&mlx5_irq_get(dev, i)->kref);
 	pci_free_irq_vectors(dev->pdev);
-- 
2.31.1

