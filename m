Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D8534E027
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhC3E2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhC3E1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DB4261994;
        Tue, 30 Mar 2021 04:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078469;
        bh=rL/1WhlQLAGt8S/xTEKnddYrNeN/nsPRjg4h4HOO9Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeE/bx3cMMJagSiZdjHXhfDporGGWuvPxN15RMhJ9fLvMZZfp961GiT4vY9/rSghp
         u9JhlUBm3AQOyFumD2KkhVgShX6KLEtPrVtJk5cSqoXW5X5/qswuI9T3jJSAsMTLJS
         9NZ/Vf5jX6UqqHxDQH3bD82vzn9xDahNeO9mRWApiMum3RBgG14bEXi02nXRMvw8uw
         sLehL0w0aIIRg/fBzQdqJrDOnbfSw6fCGtt6fhd2PTYks7W8waS3k3n7SjRcmwYj2j
         Fz7YS4ZZ6YTKH6+qpJBA4B7VLY6HCe2O1ZrWpJfxLvgwgc8Gr2fkuRy8kG23j7hg6P
         LBxOUKB2ey4pA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/12] net/mlx5e: Update ethtool setting of CQE compression
Date:   Mon, 29 Mar 2021 21:27:41 -0700
Message-Id: <20210330042741.198601-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Remove restriction blocking configuration of CQE compression when PTP rx
filter is set. Instead turn on indication for RX PTP, and try to reopen
the channels.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 14 ++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2ad12ee9d100..b425b4a539bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1023,6 +1023,7 @@ int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
+int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
 void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
 				   int num_channels);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index cf319f06521d..964558086ad6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -34,6 +34,7 @@
 #include "en/port.h"
 #include "en/params.h"
 #include "en/xsk/pool.h"
+#include "en/ptp.h"
 #include "lib/clock.h"
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
@@ -1865,13 +1866,19 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 
 	new_channels.params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
+	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
+		new_channels.params.ptp_rx = new_val;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params = new_channels.params;
 		return 0;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	else
+		err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
+						 &new_channels.params.ptp_rx);
 	if (err)
 		return err;
 
@@ -1892,11 +1899,6 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
 
-	if (enable && priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE) {
-		netdev_err(netdev, "Can't enable cqe compression while timestamping is enabled.\n");
-		return -EINVAL;
-	}
-
 	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c6227725733a..db2942b61fd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3970,7 +3970,7 @@ static int mlx5e_change_nic_mtu(struct net_device *netdev, int new_mtu)
 	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu_ctx);
 }
 
-static int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx)
+int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx)
 {
 	bool set  = *(bool *)ctx;
 
-- 
2.30.2

