Return-Path: <netdev+bounces-11595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E3D733A92
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE69280F23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AB2206A6;
	Fri, 16 Jun 2023 20:11:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294831ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DECC433AD;
	Fri, 16 Jun 2023 20:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946297;
	bh=qY3a4f5hJ+AS8sRwgVZTSv2d+vJwrhHoY0lk/mJwZfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSytNEKyTqtVca5lc4ATzbXeAPGZ6fHvt8VLJ+PWAGsK0IOrtYqIhyVegJxDvzfED
	 W3Gm25i3D/464NwY302+CY7+lEyDIth9Ibf3+BUg5FSwie9sXzqDbtWMab2nRJdK45
	 JchxkKhPGvhEh6CGzul/5JhhQkxhZBd9BKaFdhMpliKsbYqV2AfaJBGTHeeeRfAkF1
	 AMj/UCodvTTOaur7W0EIQBMu/tPRboNE8YRelBG6Nere9oCKwIBm6JGKz4Rgng+BsA
	 4Y9xdoDLbLDb0j+NCTisSTmJ5TUKwP4SjgNHF1DYafv2DZV9+XnO8QXZUiU+4ssLet
	 Vtq57naVIQw3w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Bridge, pass net device when linking vport to bridge
Date: Fri, 16 Jun 2023 13:11:04 -0700
Message-Id: <20230616201113.45510-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

Following patch requires access to additional data in bridge net_device.
Pass the whole structure down the stack instead of adding necessary fields
as function arguments one-by-one.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  9 +++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 35 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  | 10 +++---
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index fd191925ab4b..560800246573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -136,7 +136,6 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
-	int ifindex = upper->ifindex;
 	int err = 0;
 
 	if (!netif_is_bridge_master(upper))
@@ -150,15 +149,15 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 
 	if (mlx5_esw_bridge_is_local(dev, rep, esw))
 		err = info->linking ?
-			mlx5_esw_bridge_vport_link(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_link(upper, vport_num, esw_owner_vhca_id,
 						   br_offloads, extack) :
-			mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_unlink(upper, vport_num, esw_owner_vhca_id,
 						     br_offloads, extack);
 	else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
 		err = info->linking ?
-			mlx5_esw_bridge_vport_peer_link(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_peer_link(upper, vport_num, esw_owner_vhca_id,
 							br_offloads, extack) :
-			mlx5_esw_bridge_vport_peer_unlink(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_peer_unlink(upper, vport_num, esw_owner_vhca_id,
 							  br_offloads, extack);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index bea7cc645461..eaa9b328abd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -834,7 +834,7 @@ mlx5_esw_bridge_egress_miss_flow_create(struct mlx5_flow_table *egress_ft,
 	return handle;
 }
 
-static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
+static struct mlx5_esw_bridge *mlx5_esw_bridge_create(struct net_device *br_netdev,
 						      struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge *bridge;
@@ -858,7 +858,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 		goto err_mdb_ht;
 
 	INIT_LIST_HEAD(&bridge->fdb_list);
-	bridge->ifindex = ifindex;
+	bridge->ifindex = br_netdev->ifindex;
 	bridge->refcnt = 1;
 	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
 	bridge->vlan_proto = ETH_P_8021Q;
@@ -898,14 +898,14 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 }
 
 static struct mlx5_esw_bridge *
-mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads)
+mlx5_esw_bridge_lookup(struct net_device *br_netdev, struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge *bridge;
 
 	ASSERT_RTNL();
 
 	list_for_each_entry(bridge, &br_offloads->bridges, list) {
-		if (bridge->ifindex == ifindex) {
+		if (bridge->ifindex == br_netdev->ifindex) {
 			mlx5_esw_bridge_get(bridge);
 			return bridge;
 		}
@@ -918,7 +918,7 @@ mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads
 			return ERR_PTR(err);
 	}
 
-	bridge = mlx5_esw_bridge_create(ifindex, br_offloads);
+	bridge = mlx5_esw_bridge_create(br_netdev, br_offloads);
 	if (IS_ERR(bridge) && list_empty(&br_offloads->bridges))
 		mlx5_esw_bridge_ingress_table_cleanup(br_offloads);
 	return bridge;
@@ -1601,15 +1601,15 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 	return 0;
 }
 
-static int mlx5_esw_bridge_vport_link_with_flags(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
-						 u16 flags,
+static int mlx5_esw_bridge_vport_link_with_flags(struct net_device *br_netdev, u16 vport_num,
+						 u16 esw_owner_vhca_id, u16 flags,
 						 struct mlx5_esw_bridge_offloads *br_offloads,
 						 struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_bridge *bridge;
 	int err;
 
-	bridge = mlx5_esw_bridge_lookup(ifindex, br_offloads);
+	bridge = mlx5_esw_bridge_lookup(br_netdev, br_offloads);
 	if (IS_ERR(bridge)) {
 		NL_SET_ERR_MSG_MOD(extack, "Error checking for existing bridge with same ifindex");
 		return PTR_ERR(bridge);
@@ -1627,15 +1627,16 @@ static int mlx5_esw_bridge_vport_link_with_flags(int ifindex, u16 vport_num, u16
 	return err;
 }
 
-int mlx5_esw_bridge_vport_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_link(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 			       struct mlx5_esw_bridge_offloads *br_offloads,
 			       struct netlink_ext_ack *extack)
 {
-	return mlx5_esw_bridge_vport_link_with_flags(ifindex, vport_num, esw_owner_vhca_id, 0,
+	return mlx5_esw_bridge_vport_link_with_flags(br_netdev, vport_num, esw_owner_vhca_id, 0,
 						     br_offloads, extack);
 }
 
-int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num,
+				 u16 esw_owner_vhca_id,
 				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack)
 {
@@ -1647,7 +1648,7 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_
 		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
 		return -EINVAL;
 	}
-	if (port->bridge->ifindex != ifindex) {
+	if (port->bridge->ifindex != br_netdev->ifindex) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is attached to another bridge");
 		return -EINVAL;
 	}
@@ -1658,23 +1659,25 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_
 	return err;
 }
 
-int mlx5_esw_bridge_vport_peer_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_link(struct net_device *br_netdev, u16 vport_num,
+				    u16 esw_owner_vhca_id,
 				    struct mlx5_esw_bridge_offloads *br_offloads,
 				    struct netlink_ext_ack *extack)
 {
 	if (!MLX5_CAP_ESW(br_offloads->esw->dev, merged_eswitch))
 		return 0;
 
-	return mlx5_esw_bridge_vport_link_with_flags(ifindex, vport_num, esw_owner_vhca_id,
+	return mlx5_esw_bridge_vport_link_with_flags(br_netdev, vport_num, esw_owner_vhca_id,
 						     MLX5_ESW_BRIDGE_PORT_FLAG_PEER,
 						     br_offloads, extack);
 }
 
-int mlx5_esw_bridge_vport_peer_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_num,
+				      u16 esw_owner_vhca_id,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack)
 {
-	return mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id, br_offloads,
+	return mlx5_esw_bridge_vport_unlink(br_netdev, vport_num, esw_owner_vhca_id, br_offloads,
 					    extack);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index a9dd18c73d6a..2f7ad3bdba5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -43,16 +43,18 @@ struct mlx5_esw_bridge_offloads {
 
 struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw);
 void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw);
-int mlx5_esw_bridge_vport_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_link(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 			       struct mlx5_esw_bridge_offloads *br_offloads,
 			       struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_peer_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_link(struct net_device *br_netdev, u16 vport_num,
+				    u16 esw_owner_vhca_id,
 				    struct mlx5_esw_bridge_offloads *br_offloads,
 				    struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_peer_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_num,
+				      u16 esw_owner_vhca_id,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack);
 void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
-- 
2.40.1


