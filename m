Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D622EE6DA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbhAGU3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAGU3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:29:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB0D2343B;
        Thu,  7 Jan 2021 20:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051337;
        bh=GQh//ftlpxvXu0laJDthJMVmew3EVKQ5Of/x7zyZid4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEW1kcbrPXiEiXp2GkT6gCKDg/MxJ0/W3v9wp3EmQL9hISdTHYU9P4vS6nmocYPrP
         MNu+dQ0Q9Yk0ZRwmBRdw43BODchVcgn7JRpTLnwpmUIHWXFGzZPKag20utwo30p2Sf
         FO5akb5t1EOwh9KIKv10z5o2ZRkDyaWhxGwm4y7d2Lmu76V6FvFsc0QN8DMd+uoEZg
         rI2auR9+uGmDPcRWcmg94L0KxhBpCNPlKOpxfB1t0qUepcP8JR5fBJUia+eaJ1E0Uo
         ze5Pf0qU1AKe9rUSwyf5F63U3rnySPR+/32XPaED9+DLEFPmir7rj/07o77IcfOvVa
         7PTOSC6tmH1iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/11] net/mlx5: Check if lag is supported before creating one
Date:   Thu,  7 Jan 2021 12:28:35 -0800
Message-Id: <20210107202845.470205-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

This patch fixes a memleak issue by preventing to create a lag and
add PFs if lag is not supported.

comm “python3”, pid 349349, jiffies 4296985507 (age 1446.976s)
hex dump (first 32 bytes):
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  …………….
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  …………….
 backtrace:
  [<000000005b216ae7>] mlx5_lag_add+0x1d5/0×3f0 [mlx5_core]
  [<000000000445aa55>] mlx5e_nic_enable+0x66/0×1b0 [mlx5_core]
  [<00000000c56734c3>] mlx5e_attach_netdev+0x16e/0×200 [mlx5_core]
  [<0000000030439d1f>] mlx5e_attach+0x5c/0×90 [mlx5_core]
  [<0000000018fd8615>] mlx5e_add+0x1a4/0×410 [mlx5_core]
  [<0000000068bc504b>] mlx5_add_device+0x72/0×120 [mlx5_core]
  [<000000009fce51f9>] mlx5_register_device+0x77/0xb0 [mlx5_core]
  [<00000000d0d81ff3>] mlx5_load_one+0xc58/0×1eb0 [mlx5_core]
  [<0000000045077adc>] init_one+0x3ea/0×920 [mlx5_core]
  [<0000000043287674>] pci_device_probe+0xcd/0×150
  [<00000000dafd3279>] really_probe+0x1c9/0×4b0
  [<00000000f06bdd84>] driver_probe_device+0x5d/0×140
  [<00000000e3d508b6>] device_driver_attach+0x4f/0×60
  [<0000000084fba0f0>] bind_store+0xbf/0×120
  [<00000000bf6622b3>] kernfs_fop_write+0x114/0×1b0

Fixes: 9b412cc35f00 ("net/mlx5e: Add LAG warning if bond slave is not lag master")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index f3d45ef082cd..83a05371e2aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -564,7 +564,9 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 	struct mlx5_core_dev *tmp_dev;
 	int i, err;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager))
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
 		return;
 
 	tmp_dev = mlx5_get_next_phys_dev(dev);
@@ -582,12 +584,9 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 	if (mlx5_lag_dev_add_pf(ldev, dev, netdev) < 0)
 		return;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
-		tmp_dev = ldev->pf[i].dev;
-		if (!tmp_dev || !MLX5_CAP_GEN(tmp_dev, lag_master) ||
-		    MLX5_CAP_GEN(tmp_dev, num_lag_ports) != MLX5_MAX_PORTS)
+	for (i = 0; i < MLX5_MAX_PORTS; i++)
+		if (!ldev->pf[i].dev)
 			break;
-	}
 
 	if (i >= MLX5_MAX_PORTS)
 		ldev->flags |= MLX5_LAG_FLAG_READY;
-- 
2.26.2

