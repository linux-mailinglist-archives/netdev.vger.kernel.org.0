Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9F6DEA2B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDLEIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDLEIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E481BE4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2580262DA3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF26C433D2;
        Wed, 12 Apr 2023 04:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272487;
        bh=QqHuyNmvVMmBBY2OtpT6NOKG9cON+wAQmLEOW5Gck3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0HeAmbr5dXGV8Cig3A4aBl6eQwqGpYJa6gV3RCgg5HVCJZLEi9PjKtrSiz2eBY+o
         LUnGD/keYkpXgIGypPGD83q7SAf/8gs9B286mvQQxv9/uN8G6ofM3k0LZ/qv+EEG2O
         mtrD6A8VasHRDIr1Kf8t61k6RHCOgQ2kBHcveY9Nmt0r1+mIh1PAEO4jadg4idS3aV
         dHFIz4ln98LCXhNfOjD24ZvjjYXRKjZOJoE+w4fWP2vpcU+qQYEL8NUtDQ9TWVBInw
         J5bwTlaokrY6DHr4E2CM6w0jC2A8kr3shVTNK6fdS2YQa0qMcfM0UMFXM2LSjoyzhR
         GtQKhdMkEitcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Bridge, implement mdb offload
Date:   Tue, 11 Apr 2023 21:07:45 -0700
Message-Id: <20230412040752.14220-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Implement support for add/del SWITCHDEV_OBJ_ID_PORT_MDB events. For mdb
destination addresses configure egress table rules to replicate to per-port
multicast tables of all ports that are member of the multicast group as
illustrated by 'MDB1' rule in the following diagram:

                                                                                                                            +--------+--+
                                                                                    +---------------------------------------> Port 1 |  |
                                                                                    |                                       +-^------+--+
                                                                                    |                                         |
                                                                                    |                                         |
                                       +-----------------------------------------+  |     +---------------------------+       |
                                       | EGRESS table                            |  |  +--> PORT 1 multicast table    |       |
+----------------------------------+   +-----------------------------------------+  |  |  +---------------------------+       |
| INGRESS table                    |   |                                         |  |  |  |                           |       |
+----------------------------------+   | dst_mac=P1,vlan=X -> pop vlan, goto P1  +--+  |  | FG0:                      |       |
|                                  |   | dst_mac=P1,vlan=Y -> pop vlan, goto P1  |     |  | src_port=dst_port -> drop |       |
| src_mac=M1,vlan=X -> goto egress +---> dst_mac=P2,vlan=X -> pop vlan, goto P2  +--+  |  | FG1:                      |       |
| ...                              |   | dst_mac=P2,vlan=Y -> goto P2            |  |  |  | VLAN X -> pop, goto port  |       |
|                                  |   | dst_mac=MDB1,vlan=Y -> goto mcast P1,P2 +-----+  | ...                       |       |
+----------------------------------+   |                                         |  |  |  | VLAN Y -> pop, goto port  +-------+
                                       +-----------------------------------------+  |  |  | FG3:                      |
                                                                                    |  |  | matchall -> goto port     |
                                                                                    |  |  |                           |
                                                                                    |  |  +---------------------------+
                                                                                    |  |
                                                                                    |  |
                                                                                    |  |                                    +--------+--+
                                                                                    +---------------------------------------> Port 2 |  |
                                                                                       |                                    +-^------+--+
                                                                                       |                                      |
                                                                                       |                                      |
                                                                                       |  +---------------------------+       |
                                                                                       +--> PORT 2 multicast table    |       |
                                                                                          +---------------------------+       |
                                                                                          |                           |       |
                                                                                          | FG0:                      |       |
                                                                                          | src_port=dst_port -> drop |       |
                                                                                          | FG1:                      |       |
                                                                                          | VLAN X -> pop, goto port  |       |
                                                                                          | ...                       |       |
                                                                                          |                           |       |
                                                                                          | FG3:                      |       |
                                                                                          | matchall -> goto port     +-------+
                                                                                          |                           |
                                                                                          +---------------------------+

MDB is managed by extending mlx5 bridge to store an entry in
mlx5_esw_bridge->mdb_list linked list (used to iterate over all offloaded
MDBs) and mlx5_esw_bridge->mdb_ht hash table (used to lookup existing MDB
by MAC+VLAN). Every MDB entry can be attached to arbitrary amount of bridge
ports that are stored in mlx5_esw_bridge_mdb_entry->ports xarray in order
to allow both efficient lookup of the port and also iteration over all
ports that the entry is attached to. Every time MDB is attached/detached
to/from a port, the hardware rule is recreated with list of destinations
corresponding to all attached ports. When the entry is detached from the
last port it is removed from mdb and destroyed which means that the ports
xarray also acts as implicit reference counting mechanism.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  12 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  75 ++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   6 +
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 295 ++++++++++++++++++
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  29 ++
 5 files changed, 413 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 9701eb3c5f1b..dd0dd3f028a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -220,6 +220,7 @@ mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 	struct netlink_ext_ack *extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 	const struct switchdev_obj *obj = port_obj_info->obj;
 	const struct switchdev_obj_port_vlan *vlan;
+	const struct switchdev_obj_port_mdb *mdb;
 	u16 vport_num, esw_owner_vhca_id;
 	int err;
 
@@ -235,6 +236,11 @@ mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 		err = mlx5_esw_bridge_port_vlan_add(vport_num, esw_owner_vhca_id, vlan->vid,
 						    vlan->flags, br_offloads, extack);
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = mlx5_esw_bridge_port_mdb_add(vport_num, esw_owner_vhca_id, mdb->addr,
+						   mdb->vid, br_offloads, extack);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -248,6 +254,7 @@ mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 {
 	const struct switchdev_obj *obj = port_obj_info->obj;
 	const struct switchdev_obj_port_vlan *vlan;
+	const struct switchdev_obj_port_mdb *mdb;
 	u16 vport_num, esw_owner_vhca_id;
 
 	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
@@ -261,6 +268,11 @@ mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 		mlx5_esw_bridge_port_vlan_del(vport_num, esw_owner_vhca_id, vlan->vid, br_offloads);
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		mlx5_esw_bridge_port_mdb_del(vport_num, esw_owner_vhca_id, mdb->addr, mdb->vid,
+					     br_offloads);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 52c976135397..be4787539c6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -840,6 +840,10 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 	if (err)
 		goto err_fdb_ht;
 
+	err = mlx5_esw_bridge_mdb_init(bridge);
+	if (err)
+		goto err_mdb_ht;
+
 	INIT_LIST_HEAD(&bridge->fdb_list);
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
@@ -849,6 +853,8 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 
 	return bridge;
 
+err_mdb_ht:
+	rhashtable_destroy(&bridge->fdb_ht);
 err_fdb_ht:
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
 err_egress_tbl:
@@ -870,6 +876,7 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
 	mlx5_esw_bridge_mcast_disable(bridge);
 	list_del(&bridge->list);
+	mlx5_esw_bridge_mdb_cleanup(bridge);
 	rhashtable_destroy(&bridge->fdb_ht);
 	kvfree(bridge);
 
@@ -909,7 +916,7 @@ static unsigned long mlx5_esw_bridge_port_key_from_data(u16 vport_num, u16 esw_o
 	return vport_num | (unsigned long)esw_owner_vhca_id << sizeof(vport_num) * BITS_PER_BYTE;
 }
 
-static unsigned long mlx5_esw_bridge_port_key(struct mlx5_esw_bridge_port *port)
+unsigned long mlx5_esw_bridge_port_key(struct mlx5_esw_bridge_port *port)
 {
 	return mlx5_esw_bridge_port_key_from_data(port->vport_num, port->esw_owner_vhca_id);
 }
@@ -1192,7 +1199,8 @@ static void mlx5_esw_bridge_vlan_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&port->vlans, vlan->vid);
 }
 
-static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
+static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_port *port,
+				       struct mlx5_esw_bridge_vlan *vlan,
 				       struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_eswitch *esw = bridge->br_offloads->esw;
@@ -1200,6 +1208,7 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 
 	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list)
 		mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
+	mlx5_esw_bridge_port_mdb_vlan_flush(port, vlan);
 
 	if (vlan->mcast_handle)
 		mlx5_esw_bridge_vlan_push_pop_fhs_cleanup(vlan);
@@ -1216,7 +1225,7 @@ static void mlx5_esw_bridge_vlan_cleanup(struct mlx5_esw_bridge_port *port,
 					 struct mlx5_esw_bridge *bridge)
 {
 	trace_mlx5_esw_bridge_vlan_cleanup(vlan);
-	mlx5_esw_bridge_vlan_flush(vlan, bridge);
+	mlx5_esw_bridge_vlan_flush(port, vlan, bridge);
 	mlx5_esw_bridge_vlan_erase(port, vlan);
 	kvfree(vlan);
 }
@@ -1240,7 +1249,7 @@ static int mlx5_esw_bridge_port_vlans_recreate(struct mlx5_esw_bridge_port *port
 	int err;
 
 	xa_for_each(&port->vlans, i, vlan) {
-		mlx5_esw_bridge_vlan_flush(vlan, bridge);
+		mlx5_esw_bridge_vlan_flush(port, vlan, bridge);
 		err = mlx5_esw_bridge_vlan_push_pop_create(bridge->vlan_proto, vlan->flags, port,
 							   vlan, br_offloads->esw);
 		if (err) {
@@ -1450,6 +1459,7 @@ int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, boo
 		return 0;
 
 	mlx5_esw_bridge_fdb_flush(bridge);
+	mlx5_esw_bridge_mdb_flush(bridge);
 	if (enable)
 		bridge->flags |= MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
 	else
@@ -1476,6 +1486,7 @@ int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 pro
 	}
 
 	mlx5_esw_bridge_fdb_flush(bridge);
+	mlx5_esw_bridge_mdb_flush(bridge);
 	bridge->vlan_proto = proto;
 	mlx5_esw_bridge_vlans_recreate(bridge);
 
@@ -1792,6 +1803,62 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 	}
 }
 
+int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
+				 u16 vid, struct mlx5_esw_bridge_offloads *br_offloads,
+				 struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_bridge_vlan *vlan;
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge *bridge;
+	int err;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!port) {
+		esw_warn(br_offloads->esw->dev,
+			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
+			 addr, vport_num);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
+				       addr, vport_num);
+		return -EINVAL;
+	}
+
+	bridge = port->bridge;
+	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
+		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
+		if (!vlan) {
+			esw_warn(br_offloads->esw->dev,
+				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
+				 addr, vid, vport_num);
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
+					       addr, vid, vport_num);
+			return -EINVAL;
+		}
+	}
+
+	err = mlx5_esw_bridge_port_mdb_attach(port, addr, vid);
+	if (err) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Failed to add MDB (MAC=%pM,vid=%u,vport=%u)\n",
+				       addr, vid, vport_num);
+		return err;
+	}
+
+	return 0;
+}
+
+void mlx5_esw_bridge_port_mdb_del(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
+				  u16 vid, struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge_port *port;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!port)
+		return;
+
+	mlx5_esw_bridge_port_mdb_detach(port, addr, vid);
+}
+
 static void mlx5_esw_bridge_flush(struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge_port *port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index b18f137173d9..9cab66467289 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -79,4 +79,10 @@ int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid,
 void mlx5_esw_bridge_port_vlan_del(u16 vport_num, u16 esw_owner_vhca_id, u16 vid,
 				   struct mlx5_esw_bridge_offloads *br_offloads);
 
+int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
+				 u16 vid, struct mlx5_esw_bridge_offloads *br_offloads,
+				 struct netlink_ext_ack *extack);
+void mlx5_esw_bridge_port_mdb_del(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
+				  u16 vid, struct mlx5_esw_bridge_offloads *br_offloads);
+
 #endif /* __MLX5_ESW_BRIDGE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index 99e2f9fc11a2..d17fe6d374b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -6,6 +6,300 @@
 #include "eswitch.h"
 #include "bridge_priv.h"
 
+static const struct rhashtable_params mdb_ht_params = {
+	.key_offset = offsetof(struct mlx5_esw_bridge_mdb_entry, key),
+	.key_len = sizeof(struct mlx5_esw_bridge_mdb_key),
+	.head_offset = offsetof(struct mlx5_esw_bridge_mdb_entry, ht_node),
+	.automatic_shrinking = true,
+};
+
+int mlx5_esw_bridge_mdb_init(struct mlx5_esw_bridge *bridge)
+{
+	INIT_LIST_HEAD(&bridge->mdb_list);
+	return rhashtable_init(&bridge->mdb_ht, &mdb_ht_params);
+}
+
+void mlx5_esw_bridge_mdb_cleanup(struct mlx5_esw_bridge *bridge)
+{
+	rhashtable_destroy(&bridge->mdb_ht);
+}
+
+static struct mlx5_esw_bridge_port *
+mlx5_esw_bridge_mdb_port_lookup(struct mlx5_esw_bridge_port *port,
+				struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	return xa_load(&entry->ports, mlx5_esw_bridge_port_key(port));
+}
+
+static int mlx5_esw_bridge_mdb_port_insert(struct mlx5_esw_bridge_port *port,
+					   struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	int err = xa_insert(&entry->ports, mlx5_esw_bridge_port_key(port), port, GFP_KERNEL);
+
+	if (!err)
+		entry->num_ports++;
+	return err;
+}
+
+static void mlx5_esw_bridge_mdb_port_remove(struct mlx5_esw_bridge_port *port,
+					    struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	xa_erase(&entry->ports, mlx5_esw_bridge_port_key(port));
+	entry->num_ports--;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mdb_flow_create(u16 esw_owner_vhca_id, struct mlx5_esw_bridge_mdb_entry *entry,
+				struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND | FLOW_ACT_IGNORE_FLOW_LEVEL,
+	};
+	int num_dests = entry->num_ports, i = 0;
+	struct mlx5_flow_destination *dests;
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+	u8 *dmac_v, *dmac_c;
+	unsigned long idx;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	dests = kvcalloc(num_dests, sizeof(*dests), GFP_KERNEL);
+	if (!dests) {
+		kvfree(rule_spec);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	xa_for_each(&entry->ports, idx, port) {
+		dests[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dests[i].ft = port->mcast.ft;
+		i++;
+	}
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	dmac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value, outer_headers.dmac_47_16);
+	ether_addr_copy(dmac_v, entry->key.addr);
+	dmac_c = MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria, outer_headers.dmac_47_16);
+	eth_broadcast_addr(dmac_c);
+
+	if (entry->key.vid) {
+		if (bridge->vlan_proto == ETH_P_8021Q) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.cvlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.cvlan_tag);
+		} else if (bridge->vlan_proto == ETH_P_8021AD) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.svlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.svlan_tag);
+		}
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.first_vid);
+		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid,
+			 entry->key.vid);
+	}
+
+	handle = mlx5_add_flow_rules(bridge->egress_ft, rule_spec, &flow_act, dests, num_dests);
+
+	kvfree(dests);
+	kvfree(rule_spec);
+	return handle;
+}
+
+static int
+mlx5_esw_bridge_port_mdb_offload(struct mlx5_esw_bridge_port *port,
+				 struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	struct mlx5_flow_handle *handle;
+
+	handle = mlx5_esw_bridge_mdb_flow_create(port->esw_owner_vhca_id, entry, port->bridge);
+	if (entry->egress_handle) {
+		mlx5_del_flow_rules(entry->egress_handle);
+		entry->egress_handle = NULL;
+	}
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	entry->egress_handle = handle;
+	return 0;
+}
+
+static struct mlx5_esw_bridge_mdb_entry *
+mlx5_esw_bridge_mdb_lookup(struct mlx5_esw_bridge *bridge,
+			   const unsigned char *addr, u16 vid)
+{
+	struct mlx5_esw_bridge_mdb_key key = {};
+
+	ether_addr_copy(key.addr, addr);
+	key.vid = vid;
+	return rhashtable_lookup_fast(&bridge->mdb_ht, &key, mdb_ht_params);
+}
+
+static struct mlx5_esw_bridge_mdb_entry *
+mlx5_esw_bridge_port_mdb_entry_init(struct mlx5_esw_bridge_port *port,
+				    const unsigned char *addr, u16 vid)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_esw_bridge_mdb_entry *entry;
+	int err;
+
+	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	ether_addr_copy(entry->key.addr, addr);
+	entry->key.vid = vid;
+	xa_init(&entry->ports);
+	err = rhashtable_insert_fast(&bridge->mdb_ht, &entry->ht_node, mdb_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	list_add(&entry->list, &bridge->mdb_list);
+
+	return entry;
+
+err_ht_insert:
+	xa_destroy(&entry->ports);
+	kvfree(entry);
+	return ERR_PTR(err);
+}
+
+static void mlx5_esw_bridge_port_mdb_entry_cleanup(struct mlx5_esw_bridge *bridge,
+						   struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	if (entry->egress_handle)
+		mlx5_del_flow_rules(entry->egress_handle);
+	list_del(&entry->list);
+	rhashtable_remove_fast(&bridge->mdb_ht, &entry->ht_node, mdb_ht_params);
+	xa_destroy(&entry->ports);
+	kvfree(entry);
+}
+
+int mlx5_esw_bridge_port_mdb_attach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
+				    u16 vid)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_esw_bridge_mdb_entry *entry;
+	int err;
+
+	if (!(bridge->flags & MLX5_ESW_BRIDGE_MCAST_FLAG))
+		return -EOPNOTSUPP;
+
+	entry = mlx5_esw_bridge_mdb_lookup(bridge, addr, vid);
+	if (entry) {
+		if (mlx5_esw_bridge_mdb_port_lookup(port, entry)) {
+			esw_warn(bridge->br_offloads->esw->dev, "MDB attach entry is already attached to port (MAC=%pM,vid=%u,vport=%u)\n",
+				 addr, vid, port->vport_num);
+			return 0;
+		}
+	} else {
+		entry = mlx5_esw_bridge_port_mdb_entry_init(port, addr, vid);
+		if (IS_ERR(entry)) {
+			err = PTR_ERR(entry);
+			esw_warn(bridge->br_offloads->esw->dev, "MDB attach failed to init entry (MAC=%pM,vid=%u,vport=%u,err=%d)\n",
+				 addr, vid, port->vport_num, err);
+			return err;
+		}
+	}
+
+	err = mlx5_esw_bridge_mdb_port_insert(port, entry);
+	if (err) {
+		if (!entry->num_ports)
+			mlx5_esw_bridge_port_mdb_entry_cleanup(bridge, entry); /* new mdb entry */
+		esw_warn(bridge->br_offloads->esw->dev,
+			 "MDB attach failed to insert port (MAC=%pM,vid=%u,vport=%u,err=%d)\n",
+			 addr, vid, port->vport_num, err);
+		return err;
+	}
+
+	err = mlx5_esw_bridge_port_mdb_offload(port, entry);
+	if (err)
+		/* Single mdb can be used by multiple ports, so just log the
+		 * error and continue.
+		 */
+		esw_warn(bridge->br_offloads->esw->dev, "MDB attach failed to offload (MAC=%pM,vid=%u,vport=%u,err=%d)\n",
+			 addr, vid, port->vport_num, err);
+	return 0;
+}
+
+static void mlx5_esw_bridge_port_mdb_entry_detach(struct mlx5_esw_bridge_port *port,
+						  struct mlx5_esw_bridge_mdb_entry *entry)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	int err;
+
+	mlx5_esw_bridge_mdb_port_remove(port, entry);
+	if (!entry->num_ports) {
+		mlx5_esw_bridge_port_mdb_entry_cleanup(bridge, entry);
+		return;
+	}
+
+	err = mlx5_esw_bridge_port_mdb_offload(port, entry);
+	if (err)
+		/* Single mdb can be used by multiple ports, so just log the
+		 * error and continue.
+		 */
+		esw_warn(bridge->br_offloads->esw->dev, "MDB detach failed to offload (MAC=%pM,vid=%u,vport=%u)\n",
+			 entry->key.addr, entry->key.vid, port->vport_num);
+}
+
+void mlx5_esw_bridge_port_mdb_detach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
+				     u16 vid)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_esw_bridge_mdb_entry *entry;
+
+	entry = mlx5_esw_bridge_mdb_lookup(bridge, addr, vid);
+	if (!entry) {
+		esw_debug(bridge->br_offloads->esw->dev,
+			  "MDB detach entry not found (MAC=%pM,vid=%u,vport=%u)\n",
+			  addr, vid, port->vport_num);
+		return;
+	}
+
+	if (!mlx5_esw_bridge_mdb_port_lookup(port, entry)) {
+		esw_debug(bridge->br_offloads->esw->dev,
+			  "MDB detach entry not attached to the port (MAC=%pM,vid=%u,vport=%u)\n",
+			  addr, vid, port->vport_num);
+		return;
+	}
+
+	mlx5_esw_bridge_port_mdb_entry_detach(port, entry);
+}
+
+void mlx5_esw_bridge_port_mdb_vlan_flush(struct mlx5_esw_bridge_port *port,
+					 struct mlx5_esw_bridge_vlan *vlan)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_esw_bridge_mdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->mdb_list, list)
+		if (entry->key.vid == vlan->vid && mlx5_esw_bridge_mdb_port_lookup(port, entry))
+			mlx5_esw_bridge_port_mdb_entry_detach(port, entry);
+}
+
+static void mlx5_esw_bridge_port_mdb_flush(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_esw_bridge_mdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->mdb_list, list)
+		if (mlx5_esw_bridge_mdb_port_lookup(port, entry))
+			mlx5_esw_bridge_port_mdb_entry_detach(port, entry);
+}
+
+void mlx5_esw_bridge_mdb_flush(struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_mdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->mdb_list, list)
+		mlx5_esw_bridge_port_mdb_entry_cleanup(bridge, entry);
+}
 static int mlx5_esw_bridge_port_mcast_fts_init(struct mlx5_esw_bridge_port *port,
 					       struct mlx5_esw_bridge *bridge)
 {
@@ -457,6 +751,7 @@ int mlx5_esw_bridge_port_mcast_init(struct mlx5_esw_bridge_port *port)
 
 void mlx5_esw_bridge_port_mcast_cleanup(struct mlx5_esw_bridge_port *port)
 {
+	mlx5_esw_bridge_port_mdb_flush(port);
 	mlx5_esw_bridge_port_mcast_fhs_cleanup(port);
 	mlx5_esw_bridge_port_mcast_fgs_cleanup(port);
 	mlx5_esw_bridge_port_mcast_fts_cleanup(port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 36ff32001ce8..849028f94be2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -125,6 +125,11 @@ struct mlx5_esw_bridge_fdb_key {
 	u16 vid;
 };
 
+struct mlx5_esw_bridge_mdb_key {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
 enum {
 	MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER = BIT(0),
 	MLX5_ESW_BRIDGE_FLAG_PEER = BIT(1),
@@ -151,6 +156,16 @@ struct mlx5_esw_bridge_fdb_entry {
 	struct mlx5_flow_handle *filter_handle;
 };
 
+struct mlx5_esw_bridge_mdb_entry {
+	struct mlx5_esw_bridge_mdb_key key;
+	struct rhash_head ht_node;
+	struct list_head list;
+	struct xarray ports;
+	int num_ports;
+
+	struct mlx5_flow_handle *egress_handle;
+};
+
 struct mlx5_esw_bridge_vlan {
 	u16 vid;
 	u16 flags;
@@ -188,6 +203,9 @@ struct mlx5_esw_bridge {
 	struct list_head fdb_list;
 	struct rhashtable fdb_ht;
 
+	struct list_head mdb_list;
+	struct rhashtable mdb_ht;
+
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_vlan_fg;
 	struct mlx5_flow_group *egress_qinq_fg;
@@ -202,6 +220,7 @@ struct mlx5_esw_bridge {
 
 struct mlx5_flow_table *mlx5_esw_bridge_table_create(int max_fte, u32 level,
 						     struct mlx5_eswitch *esw);
+unsigned long mlx5_esw_bridge_port_key(struct mlx5_esw_bridge_port *port);
 
 int mlx5_esw_bridge_port_mcast_init(struct mlx5_esw_bridge_port *port);
 void mlx5_esw_bridge_port_mcast_cleanup(struct mlx5_esw_bridge_port *port);
@@ -212,4 +231,14 @@ void mlx5_esw_bridge_vlan_mcast_cleanup(struct mlx5_esw_bridge_vlan *vlan);
 int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge);
 void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge);
 
+int mlx5_esw_bridge_mdb_init(struct mlx5_esw_bridge *bridge);
+void mlx5_esw_bridge_mdb_cleanup(struct mlx5_esw_bridge *bridge);
+int mlx5_esw_bridge_port_mdb_attach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
+				    u16 vid);
+void mlx5_esw_bridge_port_mdb_detach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
+				     u16 vid);
+void mlx5_esw_bridge_port_mdb_vlan_flush(struct mlx5_esw_bridge_port *port,
+					 struct mlx5_esw_bridge_vlan *vlan);
+void mlx5_esw_bridge_mdb_flush(struct mlx5_esw_bridge *bridge);
+
 #endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
-- 
2.39.2

