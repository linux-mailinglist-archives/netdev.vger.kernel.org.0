Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736843380AB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhCKWhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhCKWhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64BE564F8F;
        Thu, 11 Mar 2021 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502255;
        bh=HMA2+bPGxLH9+FZZ/fmQOvkmbHD43yCKSLn/wM6KBNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laj+AiMNpJnWXTn0fBevEEYMH2lQ92QvyCrkEgqosEpOyckE3cY6zcfST56ATt69M
         o/Uaa/0mNePqndSgKg/Ys/foRBjtaV8sVGfY3beUAgM18er6Iz6pz5DscvHSj+uaw5
         NzA/xr1lcyTJ5Rjjo15Nx0o5CoWZfrMu1tPJoj31UTmSyZ4mdt4w21zmrFCNiEwiBk
         1I9xPZDmpn3rNdMHzN6BWzRo+v7MU+OApEKQzP2ejbBhc7BVZOCaP/CUYRkOoLLq5A
         DL4B8RS7fwZ2Uiv8PeWN2C0GHlSQL0wpHv+ZBjZ5rcaK1befbKihS1g+pVwS2TVXMU
         GraRt0/YUlL9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Remove second FW tracer check
Date:   Thu, 11 Mar 2021 14:37:12 -0800
Message-Id: <20210311223723.361301-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The FW tracer check is called twice, so delete one of them.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c       | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 2eb022ad7fd0..49e106719392 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1100,7 +1100,7 @@ int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
 	int err;
 
 	if (IS_ERR_OR_NULL(tracer))
-		return -EINVAL;
+		return 0;
 
 	dev = tracer->dev;
 	mlx5_fw_tracer_cleanup(tracer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 255bd0059da1..d5d57630015f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -199,16 +199,11 @@ static void mlx5_fw_live_patch_event(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      fw_live_patch_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
-	struct mlx5_fw_tracer *tracer;
 
 	mlx5_core_info(dev, "Live patch updated firmware version: %d.%d.%d\n", fw_rev_maj(dev),
 		       fw_rev_min(dev), fw_rev_sub(dev));
 
-	tracer = dev->tracer;
-	if (IS_ERR_OR_NULL(tracer))
-		return;
-
-	if (mlx5_fw_tracer_reload(tracer))
+	if (mlx5_fw_tracer_reload(dev->tracer))
 		mlx5_core_err(dev, "Failed to reload FW tracer\n");
 }
 
-- 
2.29.2

