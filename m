Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E3440482
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhJ2U7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhJ2U7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C6EE61075;
        Fri, 29 Oct 2021 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541008;
        bh=D8lVgCljPZTTEkRLim9yMvLJ84DGrxpUUU92ddyN6W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TouQ6Y2/YzHTwlZqqhIybS4XOXg6G9iRdAtAfMdasK05pIouyvm1OfZouYiqbicD8
         dyqOgsd12W060x+KpVN8HQtRoaliEIIeS9wxu61anydn2ORV7tTV4ZGrdDL6JzjevV
         lGoLsEGi6OtHIUiSqtvthtEUQH43NETn/E4Nty+H+a8zjwdxs05bdxqHRGsvD5IyEI
         pmvpaTDO0PSPh0PC707mr7tpddeJ9zwn+mUTfs09mWLWTJ1JaMJtRN4KiFhlzusfQL
         thrym4a95BKR62OATitGZCwH2iOLKGIGfx/a5TWf0VmHt5+ykstoTPMKO75vWUj7T0
         3unThIleDGi4g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/14] net/mlx5e: Offload internal port as encap route device
Date:   Fri, 29 Oct 2021 13:56:29 -0700
Message-Id: <20211029205632.390403-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

When pefroming encap action, a route lookup is performed
to find the routing device the packet should be forwarded
to after the encapsulation. This is the device that has the
local tunnel ip address.

This change adds support to offload an encap rule where the
route device ends up being an ovs internal port.
In such case, the driver will add a HW rule that will encapsulate
the packet with the tunnel header and will overwrite the vport
metadata in reg_c0 to the internal port metadata value.
Finally, the packet will be forwarded to the root table to be
processed again with the indication that it came from an internal
port.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  3 +-
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 35 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  6 ++--
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index d7e613d0139a..c57180d030c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -83,7 +83,8 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	 */
 	*route_dev = dev;
 	if (!netdev_port_same_parent_id(priv->netdev, real_dev) ||
-	    dst_is_lag_dev || is_vlan_dev(*route_dev))
+	    dst_is_lag_dev || is_vlan_dev(*route_dev) ||
+	    netif_is_ovs_master(*route_dev))
 		*out_dev = uplink_dev;
 	else if (mlx5e_eswitch_rep(dev) &&
 		 mlx5e_is_valid_eswitch_fwd_dev(priv, dev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 1c44c6c345f5..660cca73c36c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -13,6 +13,30 @@ enum {
 	MLX5E_ROUTE_ENTRY_VALID     = BIT(0),
 };
 
+static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
+				     struct mlx5_flow_attr *attr,
+				     struct mlx5e_encap_entry *e,
+				     int out_index)
+{
+	struct net_device *route_dev;
+	int err = 0;
+
+	route_dev = dev_get_by_index(dev_net(e->out_dev), e->route_dev_ifindex);
+
+	if (!route_dev || !netif_is_ovs_master(route_dev))
+		goto out;
+
+	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, e->route_dev_ifindex,
+						MLX5E_TC_INT_PORT_EGRESS,
+						&attr->action, out_index);
+
+out:
+	if (route_dev)
+		dev_put(route_dev);
+
+	return err;
+}
+
 struct mlx5e_route_key {
 	int ip_version;
 	union {
@@ -809,6 +833,17 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	if (err)
 		goto out_err;
 
+	err = mlx5e_set_int_port_tunnel(priv, attr, e, out_index);
+	if (err == -EOPNOTSUPP) {
+		/* If device doesn't support int port offload,
+		 * redirect to uplink vport.
+		 */
+		mlx5_core_dbg(priv->mdev, "attaching int port as encap dev not supported, using uplink\n");
+		err = 0;
+	} else if (err) {
+		goto out_err;
+	}
+
 	flow->encaps[out_index].e = e;
 	list_add(&flow->encaps[out_index].list, &e->flows);
 	flow->encaps[out_index].index = out_index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 21c37a1a4796..3a82ca79de64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1458,7 +1458,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			goto err_out;
 
 		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
+		    !esw_attr->dest_int_port)
 			vf_tun = true;
 		out_priv = netdev_priv(encap_dev);
 		rpriv = out_priv->ppriv;
@@ -1566,7 +1567,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
+		    !esw_attr->dest_int_port)
 			vf_tun = true;
 		if (esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
 			mlx5e_detach_encap(priv, flow, out_index);
-- 
2.31.1

