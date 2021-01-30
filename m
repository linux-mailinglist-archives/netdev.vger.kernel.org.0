Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD48309387
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA3JiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhA3DKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:10:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B082164E14;
        Sat, 30 Jan 2021 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973595;
        bh=nrejU/eD18V1WMdom+AhGx0A4MoJFPtNst8MSkzg8Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQZsxTKUqT4LK2ezpohSy/uLROEQbKeWdHGqp4hs3L6c/sYm14b0Q4PtzrRaRM638
         VR3zi4apNCCqVTZI1iVVbx/O0Ja4/X4HoJc0c5slzxN/Yt97+72pmCGEcrWxhdQEot
         48PZvzwphnhbU31Bx1uVk2oyY4tyXj8LC9zU0L3ZIVtbFPSrElzcJQH+/oLNiE8f2M
         EeMeeopNx8HWyX8WtiTZliifEZsoTjWpPAp8xoDsVogH/p276A1PcMfNcUZqX2z2ha
         spHU59L/Af4M+mHVFM2St2EnSO7QKmFU0F9FM/1oMy4dUTsCwBukoN3yscF3W7Owfq
         hUA6njdJEjYFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/11] net/mlx5: DR, Allow SW steering for sw_owner_v2 devices
Date:   Fri, 29 Jan 2021 18:26:18 -0800
Message-Id: <20210130022618.317351-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Allow sw_owner_v2 based on sw_format_version.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c        | 17 +++++++++++------
 .../mellanox/mlx5/core/steering/dr_domain.c     | 17 +++++++++--------
 .../mellanox/mlx5/core/steering/dr_types.h      |  6 +++++-
 .../mellanox/mlx5/core/steering/mlx5dr.h        |  5 ++++-
 4 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index ba65ec406cfa..30b0136b5bc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -78,9 +78,9 @@ int mlx5dr_cmd_query_esw_caps(struct mlx5_core_dev *mdev,
 	caps->uplink_icm_address_tx =
 		MLX5_CAP64_ESW_FLOWTABLE(mdev,
 					 sw_steering_uplink_icm_address_tx);
-	caps->sw_owner =
-		MLX5_CAP_ESW_FLOWTABLE_FDB(mdev,
-					   sw_owner);
+	caps->sw_owner_v2 = MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, sw_owner_v2);
+	if (!caps->sw_owner_v2)
+		caps->sw_owner = MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, sw_owner);
 
 	return 0;
 }
@@ -113,10 +113,15 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->nic_tx_allow_address =
 		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_tx_action_allow_icm_address);
 
-	caps->rx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner);
-	caps->max_ft_level = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_ft_level);
+	caps->rx_sw_owner_v2 = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner_v2);
+	caps->tx_sw_owner_v2 = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner_v2);
+
+	if (!caps->rx_sw_owner_v2)
+		caps->rx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner);
+	if (!caps->tx_sw_owner_v2)
+		caps->tx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner);
 
-	caps->tx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner);
+	caps->max_ft_level = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_ft_level);
 
 	caps->log_icm_size = MLX5_CAP_DEV_MEM(mdev, log_steering_sw_icm_size);
 	caps->hdr_modify_icm_addr =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 47ec88964bf3..7091b1be84ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -4,6 +4,11 @@
 #include <linux/mlx5/eswitch.h>
 #include "dr_types.h"
 
+#define DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, dmn_type)	\
+	((dmn)->info.caps.dmn_type##_sw_owner ||	\
+	 ((dmn)->info.caps.dmn_type##_sw_owner_v2 &&	\
+	  (dmn)->info.caps.sw_format_ver <= MLX5_STEERING_FORMAT_CONNECTX_6DX))
+
 static int dr_domain_init_cache(struct mlx5dr_domain *dmn)
 {
 	/* Per vport cached FW FT for checksum recalculation, this
@@ -187,6 +192,7 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 		return ret;
 
 	dmn->info.caps.fdb_sw_owner = dmn->info.caps.esw_caps.sw_owner;
+	dmn->info.caps.fdb_sw_owner_v2 = dmn->info.caps.esw_caps.sw_owner_v2;
 	dmn->info.caps.esw_rx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_rx;
 	dmn->info.caps.esw_tx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_tx;
 
@@ -229,18 +235,13 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 	if (ret)
 		return ret;
 
-	if (dmn->info.caps.sw_format_ver != MLX5_STEERING_FORMAT_CONNECTX_5) {
-		mlx5dr_err(dmn, "SW steering is not supported on this device\n");
-		return -EOPNOTSUPP;
-	}
-
 	ret = dr_domain_query_fdb_caps(mdev, dmn);
 	if (ret)
 		return ret;
 
 	switch (dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
-		if (!dmn->info.caps.rx_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, rx))
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
@@ -249,7 +250,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		dmn->info.rx.drop_icm_addr = dmn->info.caps.nic_rx_drop_address;
 		break;
 	case MLX5DR_DOMAIN_TYPE_NIC_TX:
-		if (!dmn->info.caps.tx_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, tx))
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
@@ -261,7 +262,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		if (!dmn->info.caps.eswitch_manager)
 			return -ENOTSUPP;
 
-		if (!dmn->info.caps.fdb_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, fdb))
 			return -ENOTSUPP;
 
 		dmn->info.rx.ste_type = MLX5DR_STE_TYPE_RX;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3b76142218d1..a8b497cbb844 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -666,7 +666,8 @@ struct mlx5dr_esw_caps {
 	u64 drop_icm_address_tx;
 	u64 uplink_icm_address_rx;
 	u64 uplink_icm_address_tx;
-	bool sw_owner;
+	u8 sw_owner:1;
+	u8 sw_owner_v2:1;
 };
 
 struct mlx5dr_cmd_vport_cap {
@@ -699,6 +700,9 @@ struct mlx5dr_cmd_caps {
 	bool rx_sw_owner;
 	bool tx_sw_owner;
 	bool fdb_sw_owner;
+	u8 rx_sw_owner_v2:1;
+	u8 tx_sw_owner_v2:1;
+	u8 fdb_sw_owner_v2:1;
 	u32 num_vports;
 	struct mlx5dr_esw_caps esw_caps;
 	struct mlx5dr_cmd_vport_cap *vports_caps;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 4177786b8eaf..612b0ac31db2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -124,7 +124,10 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action);
 static inline bool
 mlx5dr_is_supported(struct mlx5_core_dev *dev)
 {
-	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
+	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
+	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
+		(MLX5_CAP_GEN(dev, steering_format_version) <=
+		 MLX5_STEERING_FORMAT_CONNECTX_6DX));
 }
 
 /* buddy functions & structure */
-- 
2.29.2

