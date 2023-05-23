Return-Path: <netdev+bounces-4549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9B570D352
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AF231C20C70
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE911E501;
	Tue, 23 May 2023 05:43:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED431D2DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F154BC433A8;
	Tue, 23 May 2023 05:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820590;
	bh=Y5c4GKmZwtr8PdRxxrzm2dDR4phkkflM9lO0EB/juuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWZrQCnuS5B/EGAkO51kTmu2rjZwSVDHuK2fx//uvmOMbY6YFBoAfbzGOi72X8cPd
	 p+HCl4o9vry7rLLVwLhJBAMkRpdWc47vvudT07PKTwCwIRdxwSCLK6BSNPK8DpQQQX
	 RUx4bJwc4sBLce8ZKDLOK2Q6MGJ4UZuEiNNmakbyzSq0JqCGDC3lf7v1+4Qt63hn6B
	 JOK09MsuF1u3bdK9GYvcjm4Mw2Vvk0BcZDOdSFNoVpptfEcT65LHnySDCKQoc41VZm
	 to6LSo3QOLFhdqQRTfb2WdBYhQV6DxgqVL5yZld1D3RtWvPAh3fmmPFAJ8ewLgn/je
	 vXxRu1uIXH02g==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Eli Cohen <elic@nvidia.com>
Subject: [net 15/15] net/mlx5: Fix indexing of mlx5_irq
Date: Mon, 22 May 2023 22:42:42 -0700
Message-Id: <20230523054242.21596-16-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

After the cited patch, mlx5_irq xarray index can be different then
mlx5_irq MSIX table index.
Fix it by storing both mlx5_irq xarray index and MSIX table index.

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 86b528aae6d4..db5687d9fec9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -32,6 +32,7 @@ struct mlx5_irq {
 	struct mlx5_irq_pool *pool;
 	int refcount;
 	struct msi_map map;
+	u32 pool_index;
 };
 
 struct mlx5_irq_table {
@@ -132,7 +133,7 @@ static void irq_release(struct mlx5_irq *irq)
 	struct cpu_rmap *rmap;
 #endif
 
-	xa_erase(&pool->irqs, irq->map.index);
+	xa_erase(&pool->irqs, irq->pool_index);
 	/* free_irq requires that affinity_hint and rmap will be cleared before
 	 * calling it. To satisfy this requirement, we call
 	 * irq_cpu_rmap_remove() to remove the notifier
@@ -276,11 +277,11 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	}
 	irq->pool = pool;
 	irq->refcount = 1;
-	irq->map.index = i;
-	err = xa_err(xa_store(&pool->irqs, irq->map.index, irq, GFP_KERNEL));
+	irq->pool_index = i;
+	err = xa_err(xa_store(&pool->irqs, irq->pool_index, irq, GFP_KERNEL));
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc xa entry for irq(%u). err = %d\n",
-			      irq->map.index, err);
+			      irq->pool_index, err);
 		goto err_xa;
 	}
 	return irq;
-- 
2.40.1


