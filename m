Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB1A3EE062
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhHPXXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234594AbhHPXXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC02860F35;
        Mon, 16 Aug 2021 23:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156158;
        bh=QDWBoCMgzMVUExdTJdQV9lgbDLoNX7yLPwCmh2Sydw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOGuawURlmMYuJJ1js6GJB8cbxVvfsehWnQhTN8SnQwgJLfaNWgRTLPCBKzDE0vVh
         fNgXGF55LR0su5fkM2hArUeLMMi51HtgWe/th1RtYDbHpnI4EoGj+QaylFHwB/l8Bv
         JNpIAQG0Ubh/JXdQPbixaQ3dJsW/ZVJZ5bCE7E4A/BZQTU6ZYqhPxBDKfqxVgrQrS0
         341iKMwv7Cp4gZUNZa0NvzUB+0wjxwUAmnbif5oQ5diD8Zbx9zXBukrp9u0860+Zuc
         v6Bi8M08zn+PYBU8mpXUnEi1wzlCKZ7T/Zej8gPPtGvyeeJkqFF1pYqMrgO5ni3xaP
         1Wfe0sWpfhJrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 15/17] net/mlx5: Bridge, extract FDB delete notification to function
Date:   Mon, 16 Aug 2021 16:22:17 -0700
Message-Id: <20210816232219.557083-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

SWITCHDEV_FDB_DEL_TO_BRIDGE notification is generated in multiple places in
bridge code. Following patch in series changes the condition for the
notification. Extract the notification into dedicated helper function
mlx5_esw_bridge_fdb_del_notify() to only modify it in single place in the
future changes.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 65173db2a2f4..5f5571190ffe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -76,6 +76,15 @@ mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *
 	call_switchdev_notifiers(val, dev, &send_info.info, NULL);
 }
 
+static void
+mlx5_esw_bridge_fdb_del_notify(struct mlx5_esw_bridge_fdb_entry *entry)
+{
+	if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
+		mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+						   entry->key.vid,
+						   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+}
+
 static struct mlx5_flow_table *
 mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 {
@@ -699,10 +708,7 @@ static void mlx5_esw_bridge_fdb_flush(struct mlx5_esw_bridge *bridge)
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
 
 	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list) {
-		if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
-			mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
-							   entry->key.vid,
-							   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+		mlx5_esw_bridge_fdb_del_notify(entry);
 		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 	}
 }
@@ -850,10 +856,7 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
 
 	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list) {
-		if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
-			mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
-							   entry->key.vid,
-							   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+		mlx5_esw_bridge_fdb_del_notify(entry);
 		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 	}
 
@@ -1241,9 +1244,7 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 		return;
 	}
 
-	if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
-		mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
-						   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+	mlx5_esw_bridge_fdb_del_notify(entry);
 	mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 }
 
@@ -1263,9 +1264,7 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 			if (time_after(lastuse, entry->lastuse)) {
 				mlx5_esw_bridge_fdb_entry_refresh(lastuse, entry);
 			} else if (time_is_before_jiffies(entry->lastuse + bridge->ageing_time)) {
-				mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
-								   entry->key.vid,
-								   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+				mlx5_esw_bridge_fdb_del_notify(entry);
 				mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 			}
 		}
-- 
2.31.1

