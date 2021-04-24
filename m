Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD9B36A003
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhDXICX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhDXICA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19DE16147F;
        Sat, 24 Apr 2021 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251282;
        bh=n4pxbpVGY4VP9+hJwivgHl7pIpxV7icF5SyiWiTPrsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqy6FK6pVf0WL183eU7AH5d9cFusSqH+J5C/Zf11anxZsr7HQo27GQ7WYxhG/G7Gf
         I5e/I4/TXzZkP3TnYDtZUU5j/rt5TEDgnY+iS7Y9/C4709c7QUNsTDk8+zCbzN/qM1
         TJbNqJDObFkWLFLpkA9BtfdqGHO1K/I3OaXuXN0ryWJvGeDxcawHSpoBpAFRlC4BD5
         1reGhMRwalayHxt9+yikri4padyoStbFJoQUVbVvAJfbcA58oK++tdNFuXMCT3M+nk
         v5MySk8j7Eg0yJjfCMB//VBhLXLXnenFFp+VZExNIJIKGOMQkFiUkSFoId2sbcv0pZ
         NfDU8b2bVVPQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/11] net/mlx5: E-Switch, Prepare to return total vports from eswitch struct
Date:   Sat, 24 Apr 2021 01:01:06 -0700
Message-Id: <20210424080115.97273-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210424080115.97273-1-saeed@kernel.org>
References: <20210424080115.97273-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Total vports are already stored during eswitch initialization. Instead
of calculating everytime, read directly from eswitch.

Additionally, host PF's SF vport information is available using
QUERY_HCA_CAP command. It is not available through HCA_CAP of the
eswitch manager PF.
Hence, this patch prepares the return total eswitch vport count from the
existing eswitch struct.

This further helps to keep eswitch port counting macros and logic within
eswitch.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 9 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 8 ++++++++
 include/linux/mlx5/vport.h                        | 8 --------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c3a58224ae12..f0974aa94574 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1573,8 +1573,8 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (!MLX5_VPORT_MANAGER(dev))
 		return 0;
 
-	total_vports = mlx5_eswitch_get_total_vports(dev);
-
+	total_vports = MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) +
+			mlx5_sf_max_functions(dev);
 	esw_info(dev,
 		 "Total vports %d, per vport: max uc(%d) max mc(%d)\n",
 		 total_vports,
@@ -2215,6 +2215,9 @@ void mlx5_esw_unlock(struct mlx5_eswitch *esw)
  */
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 {
-	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_functions(dev);
+	struct mlx5_eswitch *esw;
+
+	esw = dev->priv.eswitch;
+	return mlx5_esw_allowed(esw) ? esw->total_vports : 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b289d756a7e4..5ab480a5745d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -545,6 +545,14 @@ static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
 
+#define MLX5_VPORT_PF_PLACEHOLDER		(1u)
+#define MLX5_VPORT_UPLINK_PLACEHOLDER		(1u)
+#define MLX5_VPORT_ECPF_PLACEHOLDER(mdev)	(mlx5_ecpf_vport_exists(mdev))
+
+#define MLX5_SPECIAL_VPORTS(mdev) (MLX5_VPORT_PF_PLACEHOLDER +		\
+				   MLX5_VPORT_UPLINK_PLACEHOLDER +	\
+				   MLX5_VPORT_ECPF_PLACEHOLDER(mdev))
+
 static inline int mlx5_esw_sf_start_idx(const struct mlx5_eswitch *esw)
 {
 	/* PF and VF vports indices start from 0 to max_vfs */
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 4db87bcfce7b..aad53cb72f17 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -36,14 +36,6 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
 
-#define MLX5_VPORT_PF_PLACEHOLDER		(1u)
-#define MLX5_VPORT_UPLINK_PLACEHOLDER		(1u)
-#define MLX5_VPORT_ECPF_PLACEHOLDER(mdev)	(mlx5_ecpf_vport_exists(mdev))
-
-#define MLX5_SPECIAL_VPORTS(mdev) (MLX5_VPORT_PF_PLACEHOLDER +		\
-				   MLX5_VPORT_UPLINK_PLACEHOLDER +	\
-				   MLX5_VPORT_ECPF_PLACEHOLDER(mdev))
-
 #define MLX5_VPORT_MANAGER(mdev)					\
 	(MLX5_CAP_GEN(mdev, vport_group_manager) &&			\
 	 (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&	\
-- 
2.30.2

