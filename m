Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC983A7581
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFOEDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhFOEDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E4961416;
        Tue, 15 Jun 2021 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729689;
        bh=Jeua7A/ekkFHuS2pB3zo3yki3s+Lzeh9/BE7B8Y8IU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC5Nom3RCYsZfneTVECLTwR4bfRXmVd3S54hj1GM2nYhds9Vhn3BCOOEMTG9jj4wY
         iFN/x+i2TwVSAqQwbd/9B1yTL7PqiSeEvSVX1YfICsDB4fwcxZjSZF0RuAHxT0Afuh
         gF8DZRH/lwaV9Y68+7gfYVabTsDIIHCMWvK7upQh2vYOAO9U+fw5lhTJ1UF16jAmpM
         mVQKVUoVHE5WxsG0SSfHOzXQ8gu9F8I+1zsPxnPPIdldG+n8kK4yNakMvXzagVy/nX
         wFPkCeYwwBT7q7rm5vtgxc82Te4vOiCaXS3C1V41ejHt+ERU5lcIx7v9IcVvSqRxQc
         WcyzH95xG1V2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Lag, Don't rescan if the device is going down
Date:   Mon, 14 Jun 2021 21:01:10 -0700
Message-Id: <20210615040123.287101-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

If MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV is set it means the device is going
down and mlx5_rescan_drivers_locked() shouldn't be called.
With this patch and the previous one in the series, unbinding a PCI
function when its netdev is part of a bond works and leaves the system in a
working state.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 6642ff0115f8..4a4e9b228ba0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -258,6 +258,10 @@ static void mlx5_lag_add_devices(struct mlx5_lag *ldev)
 		if (!ldev->pf[i].dev)
 			continue;
 
+		if (ldev->pf[i].dev->priv.flags &
+		    MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
+			continue;
+
 		ldev->pf[i].dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 		mlx5_rescan_drivers_locked(ldev->pf[i].dev);
 	}
@@ -286,8 +290,10 @@ static void mlx5_disable_lag(struct mlx5_lag *ldev)
 	roce_lag = __mlx5_lag_is_roce(ldev);
 
 	if (roce_lag) {
-		dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
-		mlx5_rescan_drivers_locked(dev0);
+		if (!(dev0->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)) {
+			dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+			mlx5_rescan_drivers_locked(dev0);
+		}
 		mlx5_nic_vport_disable_roce(dev1);
 	}
 
-- 
2.31.1

