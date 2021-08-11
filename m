Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0FA3E9771
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhHKSSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhHKSSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E553F6105A;
        Wed, 11 Aug 2021 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705893;
        bh=s9t4logbnq8OQ+/OnZqgWLVeK4uxfCuaoTlWqfHoXqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3uLQngPqtGPbYlFcIrTUJdSy3dH/M/ja8s+qdLu7Ewkhdg6tYLGYzyYVDlv6ywRk
         Ou2gieXr5Mc5Fdxid/Brm6sBw2E7JjSyT3x7y4ma4szamECU3IE93WVaSEMigs4FOx
         klheNnUVu9nydMTaZozDxwjQzqzW8GK9z5NdjU1sOJfQoIEInPLVoAA04GrfcM2w6D
         9wb6rJKuG3bxO1oqfQbROARvirxw4QUAXpvrakZWFnoEhPSEpI2Lup1DNckPU3eHvp
         BWxCw/77JDYuCoQvzgkvlVxeVobHlMypoQCn+vVEfcnNczuh0hgmLwWJA3ITHcWKTf
         EP7G2df6tpBoQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/12] net/mlx5: Delete impossible dev->state checks
Date:   Wed, 11 Aug 2021 11:16:49 -0700
Message-Id: <20210811181658.492548-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

New mlx5_core device structure is allocated through devlink_alloc
with\ kzalloc and that ensures that all fields are equal to zero
and it includes ->state too.

That means that checks of that field in the mlx5_init_one() is
completely redundant, because that function is called only once
in the begging of mlx5_core_dev lifetime.

PCI:
 .probe()
  -> probe_one()
   -> mlx5_init_one()

The recovery flow can't run at that time or before it, because relevant
work initialized later in mlx5_init_once().

Such initialization flow ensures that dev->state can't be
MLX5_DEVICE_STATE_UNINITIALIZED at all, so remove such impossible
checks.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 ----
 drivers/net/ethernet/mellanox/mlx5/core/main.c   | 6 ------
 include/linux/mlx5/driver.h                      | 3 +--
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 4a7de1259004..037e18dd4be0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -213,10 +213,6 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 	mutex_lock(&dev->intf_state_mutex);
 	if (!err_detected && dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto unlock;/* a previous error is still being handled */
-	if (dev->state == MLX5_DEVICE_STATE_UNINITIALIZED) {
-		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
-		goto unlock;
-	}
 
 	enter_error_state(dev, force);
 unlock:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6fe560307c05..1a65e744d2e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1249,11 +1249,6 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	int err = 0;
 
 	mutex_lock(&dev->intf_state_mutex);
-	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-		mlx5_core_warn(dev, "interface is up, NOP\n");
-		goto out;
-	}
-	/* remove any previous indication of internal error */
 	dev->state = MLX5_DEVICE_STATE_UP;
 
 	err = mlx5_function_setup(dev, true);
@@ -1294,7 +1289,6 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	mlx5_function_teardown(dev, true);
 err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
-out:
 	mutex_unlock(&dev->intf_state_mutex);
 	return err;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 524051d1b2e3..2b5c5604b091 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -623,8 +623,7 @@ struct mlx5_priv {
 };
 
 enum mlx5_device_state {
-	MLX5_DEVICE_STATE_UNINITIALIZED,
-	MLX5_DEVICE_STATE_UP,
+	MLX5_DEVICE_STATE_UP = 1,
 	MLX5_DEVICE_STATE_INTERNAL_ERROR,
 };
 
-- 
2.31.1

