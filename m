Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24B425A6FD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIBHpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:45:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A2AE20829;
        Wed,  2 Sep 2020 07:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032711;
        bh=kX89PHdoE8Yh3sfXO09ljZ6/XBPfAXN/toWSwST6gHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiHH3TPHLbqqOlT52pDSMn5083sMWCUFjFuByg96dfHlvt+hhGq8lH4YcEYMGv6P8
         qYwS91BGj6R6JxhAOpL1pUgkj2nCWH5N4VzzC3CYRRbr5A128PPVVM/joGgvSSelNb
         KOt+M+FBEtPu2a2Gwd1TbhRN06O19tld+9pD+91g=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 1/3] net/mlx5: Refactor query port speed functions
Date:   Wed,  2 Sep 2020 10:45:01 +0300
Message-Id: <20200902074503.743310-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200902074503.743310-1-leon@kernel.org>
References: <20200902074503.743310-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

The functions mlx5_query_port_link_width_oper and
mlx5_query_port_ib_proto_oper are always called together, so combine them
to a new function called mlx5_query_port_oper to avoid duplication.

And while the mlx5i_get_port_settings is the same as
mlx5_query_port_oper therefore let's remove it.

According to the IB spec link_width_oper and ib_proto_oper should be u16
and not as written u8, so perform casting as a preparation to cross-RDMA
patch which will fix that type for all drivers in the RDMA subsystem.

Fixes: ada68c31ba9c ("net/mlx5: Introduce a new header file for physical port functions")
Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 27 ++++++++++---------
 .../mellanox/mlx5/core/ipoib/ethtool.c        | 23 +++-------------
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 +++-------------
 include/linux/mlx5/port.h                     |  7 +++--
 4 files changed, 25 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bfa8b6b3c681..ca33ff4b1d5e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -326,8 +326,8 @@ void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *ibdev, u8 port_num)
 	spin_unlock(&port->mp.mpi_lock);
 }
 
-static int translate_eth_legacy_proto_oper(u32 eth_proto_oper, u8 *active_speed,
-					   u8 *active_width)
+static int translate_eth_legacy_proto_oper(u32 eth_proto_oper,
+					   u16 *active_speed, u8 *active_width)
 {
 	switch (eth_proto_oper) {
 	case MLX5E_PROT_MASK(MLX5E_1000BASE_CX_SGMII):
@@ -384,7 +384,7 @@ static int translate_eth_legacy_proto_oper(u32 eth_proto_oper, u8 *active_speed,
 	return 0;
 }
 
-static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 					u8 *active_width)
 {
 	switch (eth_proto_oper) {
@@ -436,7 +436,7 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u8 *active_speed,
 	return 0;
 }
 
-static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
+static int translate_eth_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 				    u8 *active_width, bool ext)
 {
 	return ext ?
@@ -457,6 +457,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	bool put_mdev = true;
 	u16 qkey_viol_cntr;
 	u32 eth_prot_oper;
+	u16 active_speed;
 	u8 mdev_port_num;
 	bool ext;
 	int err;
@@ -490,9 +491,12 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	props->active_width     = IB_WIDTH_4X;
 	props->active_speed     = IB_SPEED_QDR;
 
-	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
+	translate_eth_proto_oper(eth_prot_oper, &active_speed,
 				 &props->active_width, ext);
 
+	WARN_ON_ONCE(active_speed & ~0xFF);
+	props->active_speed = (u8)active_speed;
+
 	props->port_cap_flags |= IB_PORT_CM_SUP;
 	props->ip_gids = true;
 
@@ -1183,8 +1187,8 @@ enum mlx5_ib_width {
 	MLX5_IB_WIDTH_12X	= 1 << 4
 };
 
-static void translate_active_width(struct ib_device *ibdev, u8 active_width,
-				  u8 *ib_width)
+static void translate_active_width(struct ib_device *ibdev, u16 active_width,
+				   u8 *ib_width)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 
@@ -1277,7 +1281,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 	u16 max_mtu;
 	u16 oper_mtu;
 	int err;
-	u8 ib_link_width_oper;
+	u16 ib_link_width_oper;
 	u8 vl_hw_cap;
 
 	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
@@ -1310,16 +1314,13 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 	if (props->port_cap_flags & IB_PORT_CAP_MASK2_SUP)
 		props->port_cap_flags2 = rep->cap_mask2;
 
-	err = mlx5_query_port_link_width_oper(mdev, &ib_link_width_oper, port);
+	err = mlx5_query_ib_port_oper(mdev, &ib_link_width_oper,
+				      (u16 *)&props->active_speed, port);
 	if (err)
 		goto out;
 
 	translate_active_width(ibdev, ib_link_width_oper, &props->active_width);
 
-	err = mlx5_query_port_ib_proto_oper(mdev, &props->active_speed, port);
-	if (err)
-		goto out;
-
 	mlx5_query_port_max_mtu(mdev, &max_mtu, port);
 
 	props->max_mtu = mlx5_mtu_to_ib_mtu(max_mtu);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 1eef66ee849e..17f5be801d2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -174,24 +174,6 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	}
 }
 
-static int mlx5i_get_port_settings(struct net_device *netdev,
-				   u16 *ib_link_width_oper, u16 *ib_proto_oper)
-{
-	struct mlx5e_priv *priv    = mlx5i_epriv(netdev);
-	struct mlx5_core_dev *mdev = priv->mdev;
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {0};
-	int ret;
-
-	ret = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_IB, 1);
-	if (ret)
-		return ret;
-
-	*ib_link_width_oper = MLX5_GET(ptys_reg, out, ib_link_width_oper);
-	*ib_proto_oper      = MLX5_GET(ptys_reg, out, ib_proto_oper);
-
-	return 0;
-}
-
 static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 {
 	int rate, width;
@@ -209,11 +191,14 @@ static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 static int mlx5i_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings *link_ksettings)
 {
+	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
 	u16 ib_link_width_oper;
 	u16 ib_proto_oper;
 	int speed, ret;
 
-	ret = mlx5i_get_port_settings(netdev, &ib_link_width_oper, &ib_proto_oper);
+	ret = mlx5_query_ib_port_oper(mdev, &ib_link_width_oper, &ib_proto_oper,
+				      1);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index e4186e84b3ff..4bb219565c58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -154,24 +154,8 @@ int mlx5_set_port_beacon(struct mlx5_core_dev *dev, u16 beacon_duration)
 				    sizeof(out), MLX5_REG_MLCR, 0, 1);
 }
 
-int mlx5_query_port_link_width_oper(struct mlx5_core_dev *dev,
-				    u8 *link_width_oper, u8 local_port)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	int err;
-
-	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_IB, local_port);
-	if (err)
-		return err;
-
-	*link_width_oper = MLX5_GET(ptys_reg, out, ib_link_width_oper);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx5_query_port_link_width_oper);
-
-int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
-				  u8 *proto_oper, u8 local_port)
+int mlx5_query_ib_port_oper(struct mlx5_core_dev *dev, u16 *link_width_oper,
+			    u16 *proto_oper, u8 local_port)
 {
 	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
 	int err;
@@ -181,11 +165,12 @@ int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
+	*link_width_oper = MLX5_GET(ptys_reg, out, ib_link_width_oper);
 	*proto_oper = MLX5_GET(ptys_reg, out, ib_proto_oper);
 
 	return 0;
 }
-EXPORT_SYMBOL(mlx5_query_port_ib_proto_oper);
+EXPORT_SYMBOL(mlx5_query_ib_port_oper);
 
 /* This function should be used after setting a port register only */
 void mlx5_toggle_port_link(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 2d45a6af52a4..4d33ae0c2d97 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -133,10 +133,9 @@ enum mlx5e_connector_type {
 int mlx5_set_port_caps(struct mlx5_core_dev *dev, u8 port_num, u32 caps);
 int mlx5_query_port_ptys(struct mlx5_core_dev *dev, u32 *ptys,
 			 int ptys_size, int proto_mask, u8 local_port);
-int mlx5_query_port_link_width_oper(struct mlx5_core_dev *dev,
-				    u8 *link_width_oper, u8 local_port);
-int mlx5_query_port_ib_proto_oper(struct mlx5_core_dev *dev,
-				  u8 *proto_oper, u8 local_port);
+
+int mlx5_query_ib_port_oper(struct mlx5_core_dev *dev, u16 *link_width_oper,
+			    u16 *proto_oper, u8 local_port);
 void mlx5_toggle_port_link(struct mlx5_core_dev *dev);
 int mlx5_set_port_admin_status(struct mlx5_core_dev *dev,
 			       enum mlx5_port_status status);
-- 
2.26.2

