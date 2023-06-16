Return-Path: <netdev+bounces-11571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF18733A4C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A40432810B6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DF01F197;
	Fri, 16 Jun 2023 20:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396991ED5A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5170C433C8;
	Fri, 16 Jun 2023 20:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945685;
	bh=AssDIHTKz9iD16onYlaPx0BbU48o2snYy1YQs7jBKWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXGEZDy93itTqr18unVa8ADgakrNaJxGRwQ4leAs7zK7TlyDGDAwPz02QPDICva4a
	 lrGrLa4KFESCA2WDcgrMtnomcEcxe4T+b+wgdoXHLWaRCSK4+hxR2BaJ1s8GlPOXfZ
	 5MC+aPF6yeUwZTgSOtsBSy98DQOb5walSecvOt0AW7XyLklWYhN/4cXqLpSztXN0Qf
	 /o72k7utL8MtAnJW3tM6HtGjeTn/Z/IOMauBxAzq2V+upz7eu5L2LIxWLPfsoAGSyw
	 9fjP1XXekMfgl4F+5cPtN/cdApLkj/VKFGAEmDwKkxXr1XuPgAy+UOyCdgCSFIsoxd
	 iQ8Mg4f3JK96Q==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Eli Cohen <elic@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net 03/12] net/mlx5: Fix driver load with single msix vector
Date: Fri, 16 Jun 2023 13:01:10 -0700
Message-Id: <20230616200119.44163-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eli Cohen <elic@nvidia.com>

When a PCI device has just one msix vector available, we want to share
this vector between async and completion events. Current code fails to
do that assuming it will always have at least one dedicated vector for
completion events. Fix this by detecting when the pool contains just a
single vector.

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 843da89a9035..33b9359de53d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -565,15 +565,21 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 			      struct mlx5_irq **irqs, struct cpu_rmap **rmap)
 {
+	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
+	struct mlx5_irq_pool *pool = table->pcif_pool;
 	struct irq_affinity_desc af_desc;
 	struct mlx5_irq *irq;
+	int offset = 1;
 	int i;
 
+	if (!pool->xa_num_irqs.max)
+		offset = 0;
+
 	af_desc.is_managed = false;
 	for (i = 0; i < nirqs; i++) {
 		cpumask_clear(&af_desc.mask);
 		cpumask_set_cpu(cpus[i], &af_desc.mask);
-		irq = mlx5_irq_request(dev, i + 1, &af_desc, rmap);
+		irq = mlx5_irq_request(dev, i + offset, &af_desc, rmap);
 		if (IS_ERR(irq))
 			break;
 		irqs[i] = irq;
-- 
2.40.1


