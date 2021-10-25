Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD743A512
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhJYU5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233258AbhJYU47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08E461039;
        Mon, 25 Oct 2021 20:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195277;
        bh=rPudhx8nVhN+defpaOG5+1kRZwn42E6e35+feCAejdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0YHqcaQGZ+J+0ZTrjsYltrb9h9lNB7r8+XqTK53k2OGhUIHahsh/UHJ/zgSJPO8r
         rqcMhpo2E9eUychSnRh30FRuUvKiRoLjvqYQDnDOr5Myr1WvcW0W6nP3MQPAS5hrVO
         jwQllQp/JWf1NBQPgUWHQ6hztRW5iM9dV2kU9Ut5V9a3A/zYxKxlAyi2HfXKmmQRH1
         u6zlXVjWGAC4LJTci7SEg6LAznBgerrFSblSeC9whlhcIaL6jEFe/udYHEMS4IDpzk
         zfm7pd8CT3dhCe7E7oRwYK72V+Hyjn3I+Ow6KvxpKfHw9xzAqpFsU2Cnb+BZzC/OM9
         GRUlJt/QUe2HA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/14] net/mlx5: Bridge, extract code to lookup and del/notify entry
Date:   Mon, 25 Oct 2021 13:54:25 -0700
Message-Id: <20211025205431.365080-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following two patterns in bridge code are used in multiple places where
similar code is duplicated:

- Lookup FDB entry from hashtable by address+vid pair.

- Notify software bridge and then delete existing FDB entry.

In order to improve code quality and prepare for following patch series
that also uses described patterns, extract the codes to dedicated helper
functions.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 58 ++++++++++---------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 588622ba38c1..33d1d2ed4cd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -888,14 +888,20 @@ mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 	kvfree(entry);
 }
 
+static void
+mlx5_esw_bridge_fdb_entry_notify_and_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
+					     struct mlx5_esw_bridge *bridge)
+{
+	mlx5_esw_bridge_fdb_del_notify(entry);
+	mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+}
+
 static void mlx5_esw_bridge_fdb_flush(struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
 
-	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list) {
-		mlx5_esw_bridge_fdb_del_notify(entry);
-		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
-	}
+	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list)
+		mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
 }
 
 static struct mlx5_esw_bridge_vlan *
@@ -1065,10 +1071,8 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 	struct mlx5_eswitch *esw = bridge->br_offloads->esw;
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
 
-	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list) {
-		mlx5_esw_bridge_fdb_del_notify(entry);
-		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
-	}
+	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list)
+		mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
 
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
@@ -1127,6 +1131,17 @@ mlx5_esw_bridge_port_vlan_lookup(u16 vid, u16 vport_num, u16 esw_owner_vhca_id,
 	return vlan;
 }
 
+static struct mlx5_esw_bridge_fdb_entry *
+mlx5_esw_bridge_fdb_lookup(struct mlx5_esw_bridge *bridge,
+			   const unsigned char *addr, u16 vid)
+{
+	struct mlx5_esw_bridge_fdb_key key = {};
+
+	ether_addr_copy(key.addr, addr);
+	key.vid = vid;
+	return rhashtable_lookup_fast(&bridge->fdb_ht, &key, fdb_ht_params);
+}
+
 static struct mlx5_esw_bridge_fdb_entry *
 mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
 			       const unsigned char *addr, u16 vid, bool added_by_user, bool peer,
@@ -1444,7 +1459,6 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 				     struct switchdev_notifier_fdb_info *fdb_info)
 {
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_fdb_key key;
 	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
@@ -1453,13 +1467,11 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 		return;
 
 	bridge = port->bridge;
-	ether_addr_copy(key.addr, fdb_info->addr);
-	key.vid = fdb_info->vid;
-	entry = rhashtable_lookup_fast(&bridge->fdb_ht, &key, fdb_ht_params);
+	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_debug(br_offloads->esw->dev,
 			  "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
-			  key.addr, key.vid, vport_num);
+			  fdb_info->addr, fdb_info->vid, vport_num);
 		return;
 	}
 
@@ -1501,7 +1513,6 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 {
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_fdb_key key;
 	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
@@ -1510,18 +1521,15 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 		return;
 
 	bridge = port->bridge;
-	ether_addr_copy(key.addr, fdb_info->addr);
-	key.vid = fdb_info->vid;
-	entry = rhashtable_lookup_fast(&bridge->fdb_ht, &key, fdb_ht_params);
+	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_warn(esw->dev,
 			 "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
-			 key.addr, key.vid, vport_num);
+			 fdb_info->addr, fdb_info->vid, vport_num);
 		return;
 	}
 
-	mlx5_esw_bridge_fdb_del_notify(entry);
-	mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+	mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
 }
 
 void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
@@ -1537,13 +1545,11 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 			if (entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER)
 				continue;
 
-			if (time_after(lastuse, entry->lastuse)) {
+			if (time_after(lastuse, entry->lastuse))
 				mlx5_esw_bridge_fdb_entry_refresh(entry);
-			} else if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_PEER) &&
-				   time_is_before_jiffies(entry->lastuse + bridge->ageing_time)) {
-				mlx5_esw_bridge_fdb_del_notify(entry);
-				mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
-			}
+			else if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_PEER) &&
+				 time_is_before_jiffies(entry->lastuse + bridge->ageing_time))
+				mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
 		}
 	}
 }
-- 
2.31.1

