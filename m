Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721EB3A757F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhFOEDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhFOEDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C22B61410;
        Tue, 15 Jun 2021 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729688;
        bh=zoAV3yITh8X0QgysMHwQ6uaTOsLZ3Pm6s6oz8ZsMoKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9Kuo5paY84+vlNODRPbnviAhJoe0iaReQXemyoENmZZRRsx9j4VAPz+wK+OZ20OA
         YomyRoajOWM5QuuQisoRV2psEIIaS5pSpT9q91SEAaXPfvoXJLkM+ov5afqm1Zwd/g
         mdKe7PXbzSvyaI0qmbm8JRqJQDWdwAuTRiZG+68O1dQ6ZkjAfDLDt7I2QVOeh2OfdV
         +GEkddDtrMfFaAekzh4dRyDeAhb8Yv+utqLcqpXzqAWx3Inr10YmCeW1Z6Os6UHnQI
         3bNnYI8LXBfkqFzoFqhAZl8UCCG/W1i+3REMl/Tr6uy7VzNhDhLf5wbJ6TrVMsKpez
         IwDuPuEmihQbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Lag, refactor disable flow
Date:   Mon, 14 Jun 2021 21:01:09 -0700
Message-Id: <20210615040123.287101-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When a net device is removed (can happen if the PCI function is unbound
from the system) it's not enough to destroy the hardware lag. The system
should recreate the original devices that were present before the lag.
As the same flow is done when a net device is removed from the bond
refactor and reuse the code.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 40 ++++++++++++-------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 1fb70524d067..6642ff0115f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -276,6 +276,29 @@ static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 	}
 }
 
+static void mlx5_disable_lag(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
+	bool roce_lag;
+	int err;
+
+	roce_lag = __mlx5_lag_is_roce(ldev);
+
+	if (roce_lag) {
+		dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+		mlx5_rescan_drivers_locked(dev0);
+		mlx5_nic_vport_disable_roce(dev1);
+	}
+
+	err = mlx5_deactivate_lag(ldev);
+	if (err)
+		return;
+
+	if (roce_lag)
+		mlx5_lag_add_devices(ldev);
+}
+
 static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -322,20 +345,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	} else if (do_bond && __mlx5_lag_is_active(ldev)) {
 		mlx5_modify_lag(ldev, &tracker);
 	} else if (!do_bond && __mlx5_lag_is_active(ldev)) {
-		roce_lag = __mlx5_lag_is_roce(ldev);
-
-		if (roce_lag) {
-			dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
-			mlx5_rescan_drivers_locked(dev0);
-			mlx5_nic_vport_disable_roce(dev1);
-		}
-
-		err = mlx5_deactivate_lag(ldev);
-		if (err)
-			return;
-
-		if (roce_lag)
-			mlx5_lag_add_devices(ldev);
+		mlx5_disable_lag(ldev);
 	}
 }
 
@@ -620,7 +630,7 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
 		return;
 
 	if (__mlx5_lag_is_active(ldev))
-		mlx5_deactivate_lag(ldev);
+		mlx5_disable_lag(ldev);
 
 	mlx5_lag_dev_remove_pf(ldev, dev);
 
-- 
2.31.1

