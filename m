Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9452D019B
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLFIYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:01 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41351 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbgLFIYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 51E32C7F;
        Sun,  6 Dec 2020 03:22:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jprFinxZO+a7TpkpT3h7WkxaTKtJPZRzeER6zmwwZGM=; b=C8pShNLT
        PRcz2/PUWTGeO1tFl+MjITRmNLxeA9iujddw45WgFN5UvXXmhZmJ3ViTzIlEDq27
        M9Z/xFsBeZ2mx/Z1dWLb0fryBQsq8nWr9YBnRp30+OamQgerPhQOTUyC0N9+3MMX
        77yZKiLC4pnIyTzuXcO3m1oVetBMAz6H9rwWkpQYLTeDgOLBI6tlZ5M4DA5HWIQN
        DOy3F6vfWSH2gwgGzY7BbdMpuDChP1qUHrBti1BRkX0z/0wooo4A0N0XEnCAvCGw
        rGkEkpon3z69cCjBWrUB/+Yq4IOA9fEhDsJKFdJN/YvKDbeYV37DQStjI0sYrdIw
        V+laAXG/UQ1hPA==
X-ME-Sender: <xms:3JTMX5lSDc_AE0Mm6pC4YzHSc4DvfoPciisqPX6-MqmT9H9ETPawmg>
    <xme:3JTMX0294ztDgbKT72zrLuhxVXgfDph8C6r8eSW7DecvGd4ZCzLL2ZxtODXXT0nmd
    hywP_BKfFWb8lE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3JTMX_ofZ1w1aYYbcbwSb9bibcw0lZqACBq8DHtv4dYhQbuSSRnlTA>
    <xmx:3JTMX5ml_onQbmqt0T9itZ2JeCZ_35RTF15i2j5r4pl0Wza_-MBb9w>
    <xmx:3JTMX328gx2TGua_hEJrAbNw2Qa0_BfgBITMqHzOpcWH1c4tH988ag>
    <xmx:3JTMX4xXorfLetRbMNVh39Q0WMT2g5L6hOCKLhYiGt2WmOI2FXIihg>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 982B81080066;
        Sun,  6 Dec 2020 03:22:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] mlxsw: spectrum: Apply RIF configuration when joining a LAG
Date:   Sun,  6 Dec 2020 10:22:21 +0200
Message-Id: <20201206082227.1857042-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In case a router interface (RIF) is configured for a LAG, make sure its
configuration is applied on the new LAG member.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 17 ++++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +++
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 31 ++++++++++++++++---
 3 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 385eb3c3b362..65e8407f4646 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3595,7 +3595,8 @@ static int mlxsw_sp_port_lag_index_get(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct net_device *lag_dev)
+				  struct net_device *lag_dev,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_upper *lag;
@@ -3631,8 +3632,20 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (mlxsw_sp_port->default_vlan->fid)
 		mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port->default_vlan);
 
+	/* Join a router interface configured on the LAG, if exists */
+	err = mlxsw_sp_port_vlan_router_join(mlxsw_sp_port->default_vlan,
+					     lag_dev, extack);
+	if (err)
+		goto err_router_join;
+
 	return 0;
 
+err_router_join:
+	lag->ref_count--;
+	mlxsw_sp_port->lagged = 0;
+	mlxsw_core_lag_mapping_clear(mlxsw_sp->core, lag_id,
+				     mlxsw_sp_port->local_port);
+	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
@@ -3997,7 +4010,7 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 		} else if (netif_is_lag_master(upper_dev)) {
 			if (info->linking) {
 				err = mlxsw_sp_port_lag_join(mlxsw_sp_port,
-							     upper_dev);
+							     upper_dev, extack);
 			} else {
 				mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 				mlxsw_sp_port_lag_leave(mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ce26cc41831f..6092243a69cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -656,6 +656,10 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 				 struct net_device *l3_dev,
 				 unsigned long event,
 				 struct netdev_notifier_info *info);
+int
+mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+			       struct net_device *l3_dev,
+			       struct netlink_ext_ack *extack);
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan);
 void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 85223647fdb6..20b141f02145 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7697,9 +7697,9 @@ static void mlxsw_sp_rif_subport_put(struct mlxsw_sp_rif *rif)
 }
 
 static int
-mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
-			       struct net_device *l3_dev,
-			       struct netlink_ext_ack *extack)
+__mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+				 struct net_device *l3_dev,
+				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp_port_vlan->mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -7764,6 +7764,27 @@ __mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 	mlxsw_sp_rif_subport_put(rif);
 }
 
+int
+mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+			       struct net_device *l3_dev,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_rif *rif;
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->router->lock);
+	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev);
+	if (!rif)
+		goto out;
+
+	err = __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan, l3_dev,
+					       extack);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
+}
+
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
@@ -7788,8 +7809,8 @@ static int mlxsw_sp_inetaddr_port_vlan_event(struct net_device *l3_dev,
 
 	switch (event) {
 	case NETDEV_UP:
-		return mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan,
-						      l3_dev, extack);
+		return __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan,
+							l3_dev, extack);
 	case NETDEV_DOWN:
 		__mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
 		break;
-- 
2.28.0

