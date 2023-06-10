Return-Path: <netdev+bounces-9764-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B305072A7A4
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4A241C20A2D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDA74C8A;
	Sat, 10 Jun 2023 01:43:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D091C2E
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79B2C433A4;
	Sat, 10 Jun 2023 01:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361388;
	bh=LOPwnsnhwGCmxTgVxkdZQz9m7HIMUYA9USLzYXKLBtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNys8hvolcw8z7bhZC/MTYR27kRFlKfERWpb+8Dlu7Pakwsb1BYckKeyrBbVW/RlG
	 CODXTIQ1JHc1qPD0HrKxrWWqGqbeJgnQzlfL4vxaH8Yr+Kksb77PkCZNXj5vm0gidA
	 zySt5I6GCTbCQ2oAC+uM3ZGNBhhNF9dtgnKpDRmYI/0WuQRyd2OLQvcgr2/ePjhfnh
	 FcwRSdc2yfRm5QEoKMS7FV8jV7E21jI+rcWcSGBXy6IxIwRp4i+JCSVYgmqYlFR3jz
	 E4ZH/91UNk9w4VDa/+2/h75BJMJPi6Rm9PIYEE2P3vkzcHpNap4i/rJM2moT56gvRJ
	 9uYQZ8UoSyqkw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Enable devlink port for embedded cpu VF vports
Date: Fri,  9 Jun 2023 18:42:42 -0700
Message-Id: <20230610014254.343576-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Enable creation of a devlink port for EC VF vports.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     |  8 +++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 20 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  6 ++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index f370f67d9e33..af779c700278 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -18,7 +18,8 @@ static bool mlx5_esw_devlink_port_supported(struct mlx5_eswitch *esw, u16 vport_
 {
 	return vport_num == MLX5_VPORT_UPLINK ||
 	       (mlx5_core_is_ecpf(esw->dev) && vport_num == MLX5_VPORT_PF) ||
-	       mlx5_eswitch_is_vf_vport(esw, vport_num);
+	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
+	       mlx5_core_is_ec_vf_vport(esw->dev, vport_num);
 }
 
 static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16 vport_num)
@@ -56,6 +57,11 @@ static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16
 		dl_port->attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
 					      vport_num - 1, external);
+	}  else if (mlx5_core_is_ec_vf_vport(esw->dev, vport_num)) {
+		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
+		dl_port->attrs.switch_id.id_len = ppid.id_len;
+		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
+					      vport_num - 1, false);
 	}
 	return dl_port;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 1d879374acaa..0e7b5c6e4020 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -343,4 +343,24 @@ bool mlx5_rdma_supported(struct mlx5_core_dev *dev);
 bool mlx5_vnet_supported(struct mlx5_core_dev *dev);
 bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev);
 
+static inline u16 mlx5_core_ec_vf_vport_base(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN_2(dev, ec_vf_vport_base);
+}
+
+static inline u16 mlx5_core_ec_sriov_enabled(const struct mlx5_core_dev *dev)
+{
+	return mlx5_core_is_ecpf(dev) && mlx5_core_ec_vf_vport_base(dev);
+}
+
+static inline bool mlx5_core_is_ec_vf_vport(const struct mlx5_core_dev *dev, u16 vport_num)
+{
+	int base_vport = mlx5_core_ec_vf_vport_base(dev);
+	int max_vport = base_vport + mlx5_core_max_ec_vfs(dev);
+
+	if (!mlx5_core_ec_sriov_enabled(dev))
+		return false;
+
+	return (vport_num >= base_vport && vport_num < max_vport);
+}
 #endif /* __MLX5_CORE_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9a744c48eec2..252b6a6965b8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -474,6 +474,7 @@ struct mlx5_core_sriov {
 	struct mlx5_vf_context	*vfs_ctx;
 	int			num_vfs;
 	u16			max_vfs;
+	u16			max_ec_vfs;
 };
 
 struct mlx5_fc_pool {
@@ -1244,6 +1245,11 @@ static inline u16 mlx5_core_max_vfs(const struct mlx5_core_dev *dev)
 	return dev->priv.sriov.max_vfs;
 }
 
+static inline u16 mlx5_core_max_ec_vfs(const struct mlx5_core_dev *dev)
+{
+	return dev->priv.sriov.max_ec_vfs;
+}
+
 static inline int mlx5_get_gid_table_len(u16 param)
 {
 	if (param > 4) {
-- 
2.40.1


