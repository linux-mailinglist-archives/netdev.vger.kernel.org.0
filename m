Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFD453F92
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhKQEhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhKQEhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B969619F6;
        Wed, 17 Nov 2021 04:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123652;
        bh=MfGRTO5dC0E38da3ARs3dUzXCVX3wHeLNTcyaEMzigE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scPLYVGMwF+T2oLfdSLCOyTQcNRTA58neLhmT5MWWM0Tg4PyzGyPN+6J0IY7pAYzE
         MFdFmU2rBvHVyixWqAHZ8l79lGUOxgzg5QPfC6M12BdE6fbAfDkB4GJGcC9DVXbAHi
         79D2Qyv7QBVuzJICMfA0zCchY0BuGFAdawYJ9QyroYMohJN8Q0igssex2tfrqL30ck
         GvRTvfXbCkNr3OQXxrREh/4ZEG+a0y2Sa99uuUW1P+bOOLNP55CAvf2WoLj59SvQeY
         eNwfFNsmSU3j7F3Tj4J/uLKLtv0/aF5M4HRHMTwZDZW7jcbjfMV4GiRwyTyRPNovmE
         ER0+Db45kBhTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 13/15] net/mlx5: E-switch, move offloads mode callbacks to offloads file
Date:   Tue, 16 Nov 2021 20:33:55 -0800
Message-Id: <20211117043357.345072-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

eswitch.c is mainly for common code between legacy and offloads mode.
MAC address get and set via devlink is applicable only in offloads mode.

Hence, move it to eswitch_offloads.c file.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 59 -------------------
 .../mellanox/mlx5/core/eswitch_offloads.c     | 59 +++++++++++++++++++
 2 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c0526fc27ad6..ec5b1641d40c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1690,65 +1690,6 @@ bool mlx5_esw_is_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	return mlx5_esw_check_port_type(esw, vport_num, MLX5_ESW_VPT_SF);
 }
 
-static bool
-is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
-{
-	return vport_num == MLX5_VPORT_PF ||
-	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
-	       mlx5_esw_is_sf_vport(esw, vport_num);
-}
-
-int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
-					   u8 *hw_addr, int *hw_addr_len,
-					   struct netlink_ext_ack *extack)
-{
-	struct mlx5_eswitch *esw;
-	struct mlx5_vport *vport;
-	u16 vport_num;
-
-	esw = mlx5_devlink_eswitch_get(port->devlink);
-	if (IS_ERR(esw))
-		return PTR_ERR(esw);
-
-	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
-	if (!is_port_function_supported(esw, vport_num))
-		return -EOPNOTSUPP;
-
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
-		return PTR_ERR(vport);
-	}
-
-	mutex_lock(&esw->state_lock);
-	ether_addr_copy(hw_addr, vport->info.mac);
-	*hw_addr_len = ETH_ALEN;
-	mutex_unlock(&esw->state_lock);
-	return 0;
-}
-
-int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
-					   const u8 *hw_addr, int hw_addr_len,
-					   struct netlink_ext_ack *extack)
-{
-	struct mlx5_eswitch *esw;
-	u16 vport_num;
-
-	esw = mlx5_devlink_eswitch_get(port->devlink);
-	if (IS_ERR(esw)) {
-		NL_SET_ERR_MSG_MOD(extack, "Eswitch doesn't support set hw_addr");
-		return PTR_ERR(esw);
-	}
-
-	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
-	if (!is_port_function_supported(esw, vport_num)) {
-		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support set hw_addr");
-		return -EINVAL;
-	}
-
-	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
-}
-
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f4eaa5893886..4bd502ae82b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3862,3 +3862,62 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 	return vport->metadata;
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_set);
+
+static bool
+is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return vport_num == MLX5_VPORT_PF ||
+	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
+	       mlx5_esw_is_sf_vport(esw, vport_num);
+}
+
+int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
+					   u8 *hw_addr, int *hw_addr_len,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	ether_addr_copy(hw_addr, vport->info.mac);
+	*hw_addr_len = ETH_ALEN;
+	mutex_unlock(&esw->state_lock);
+	return 0;
+}
+
+int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
+					   const u8 *hw_addr, int hw_addr_len,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw)) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch doesn't support set hw_addr");
+		return PTR_ERR(esw);
+	}
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support set hw_addr");
+		return -EINVAL;
+	}
+
+	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
+}
-- 
2.31.1

