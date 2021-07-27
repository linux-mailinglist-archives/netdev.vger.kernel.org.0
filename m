Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816AD3D83D7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhG0XVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233081AbhG0XU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6718660F9C;
        Tue, 27 Jul 2021 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428056;
        bh=ympvfnkWbZjKD33o2kENGYOfKnHXAtXMffzl/RR4qT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjXQqslz9FOQJrcVm8+6rouvxsTce+2UySWTSIoBF0nmYK44x9INpZ4R/8vchvZzG
         dGyG7rJgVtJp0ZyHKmyC2cbJeH3KOyeHSvJ5URgNULlMJAwvU0ahTe7IfvG9X6bWXk
         5O7/+rjOdPL41e6pGc2iswO6sQai9yn4bwWM9+DxJc7WrQmUuZTaxulwJiiCyGwbmA
         GEbaXDX51+rPJgp/b+oprkJ7lZ1/KvaDLYyEDp6toqxawb9lshcrODwPxE/pU7IQnD
         /K0F5yFKGFrgA8PPB7IsPj2wPctOWJdzUklIXMbgUysRi8J73XbBUmBpUH0OY+cq2U
         ugFqbA2KMpe5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/12] net/mlx5e: Fix page allocation failure for trap-RQ over SF
Date:   Tue, 27 Jul 2021 16:20:46 -0700
Message-Id: <20210727232050.606896-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Set the correct device pointer to the trap-RQ, to allow access to
dma_mask and avoid allocation request with the wrong pci-dev.

WARNING: CPU: 1 PID: 12005 at kernel/dma/mapping.c:151 dma_map_page_attrs+0x139/0x1c0
...
all Trace:
<IRQ>
? __page_pool_alloc_pages_slow+0x5a/0x210
mlx5e_post_rx_wqes+0x258/0x400 [mlx5_core]
mlx5e_trap_napi_poll+0x44/0xc0 [mlx5_core]
__napi_poll+0x24/0x150
net_rx_action+0x22b/0x280
__do_softirq+0xc7/0x27e
do_softirq+0x61/0x80
</IRQ>
__local_bh_enable_ip+0x4b/0x50
mlx5e_handle_action_trap+0x2dd/0x4d0 [mlx5_core]
blocking_notifier_call_chain+0x5a/0x80
mlx5_devlink_trap_action_set+0x8b/0x100 [mlx5_core]

Fixes: 5543e989fe5e ("net/mlx5e: Add trap entity to ETH driver")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 86ab4e864fe6..7f94508594fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -37,7 +37,7 @@ static void mlx5e_init_trap_rq(struct mlx5e_trap *t, struct mlx5e_params *params
 	struct mlx5e_priv *priv = t->priv;
 
 	rq->wq_type      = params->rq_wq_type;
-	rq->pdev         = mdev->device;
+	rq->pdev         = t->pdev;
 	rq->netdev       = priv->netdev;
 	rq->priv         = priv;
 	rq->clock        = &mdev->clock;
-- 
2.31.1

