Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6123739ABA8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFCUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhFCUNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F96061403;
        Thu,  3 Jun 2021 20:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751123;
        bh=DKuAhqGxwceLneeo5716M6QPr2ScTlOb37/eyTIoRXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjcTXgiTQghkHuUXK4cTV/JlxFI+2kNWM5rY6vcKtY3YfB4H7yTZxiiq49knNhLDK
         L3yUARaYlpM/Kke68stUdqyr2mRZnEEZyum/icDGb3IXJhTrsjW16+f2pAmRQLYeR2
         5YHUUeh6fU6Zo0geHUevSLu52St1y08fSTbXg80P1VfHG9bI5XGZd3//jhvsU865p5
         wicx2cJgX1evyQfvrQVZ1PIkdgxU8IxNgGnCbM65VwBz29XCl5mdXR/y+26MpwbU93
         6YyeySem86A7/OA+lvkRG1vXCFNAOVBUI1zEYCdW3dvRz0oTth86zoKGVIcIdcUQrI
         K+23aMQKaKZ5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/10] net/mlx5e: Disable TX MPWQE in kdump mode
Date:   Thu,  3 Jun 2021 13:11:53 -0700
Message-Id: <20210603201155.109184-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

Under kdump environment we want to use the smallest possible amount
of resources, that includes setting SQ size to minimum.
However, when running on a device that supports TX MPWQE, then the SQ stop
room becomes larger than with non-capable device and requires increasing
the SQ size.

Since TX MPWQE offload is not necessary in kdump mode, disable it to
reduce the memory requirements for capable devices.

With this change, the needed SQ stop room size drops by 31.

Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 6 ++----
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d966d5f40e78..b1b51bbba054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1162,6 +1162,13 @@ mlx5e_calc_max_nch(struct mlx5e_priv *priv, const struct mlx5e_profile *profile)
 	return priv->netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
 }
 
+static inline bool
+mlx5e_tx_mpwqe_supported(struct mlx5_core_dev *mdev)
+{
+	return !is_kdump_kernel() &&
+		MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe);
+}
+
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    struct net_device *netdev,
 		    struct mlx5_core_dev *mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8360289813f0..5daf7185b035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1984,7 +1984,7 @@ static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool e
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_params new_params;
 
-	if (enable && !MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe))
+	if (enable && !mlx5e_tx_mpwqe_supported(mdev))
 		return -EOPNOTSUPP;
 
 	new_params = priv->channels.params;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e36d0c6a08db..b1981dc9cc7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4620,12 +4620,10 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	params->log_sq_size = is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE :
 		MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
-	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE,
-			MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe));
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE, mlx5e_tx_mpwqe_supported(mdev));
 
 	/* XDP SQ */
-	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE,
-			MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe));
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE, mlx5e_tx_mpwqe_supported(mdev));
 
 	/* set CQE compression */
 	params->rx_cqe_compress_def = false;
-- 
2.31.1

