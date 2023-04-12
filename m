Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4AF6DEA29
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDLEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjDLEIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86EA4EDC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F1162DAD
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EAC433D2;
        Wed, 12 Apr 2023 04:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272486;
        bh=rLauej4VmkThQvY5uBCF9fPgh5uiblN6C+aPyiwStb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJpiqR9DplgbEbG2nEZl2Yr5wKTpKgViZPe3Lw/i1p2gsMaXZ7Rw6XcOthjFHL/l6
         ISjvYATwRvqkCAEBtUz5LFstRm3umz8tv5HTo6q5UEygo+MKMVHOA8cXxye6UBmZrl
         1b/K1jKg8IhGW1Fjour4QrPbIIjApqrAUyW20JiVRM1Gp+tGXKUgJvkAcVuXxrdLhA
         CHnMvqBsbV//8cYjEVkiztv5dq4dSvuQh5gSt/1Ks8XKu7mjwsy7ZHQhjEGBzSLvw4
         0QlVZd2CTFCMLyOR3EhwJFzCmg7/Eze+tzygHFKquEgUW8Bv7CiJdkJBXVhUbD4E2u
         wGJ1KFa0e6abQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Bridge, support multicast VLAN pop
Date:   Tue, 11 Apr 2023 21:07:44 -0700
Message-Id: <20230412040752.14220-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

When VLAN with 'untagged' flag is created on port also provision the
per-port multicast table rule to pop the VLAN during packet replication.
This functionality must be in per-port table because some subset of ports
that are member of multicast group can require just a match on VLAN (trunk
mode) while other subset can be configured to remove the VLAN tag from
packets received on the ports (access mode).

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  33 ++-
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 190 +++++++++++++++++-
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  22 +-
 3 files changed, 236 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 4bc8c6fc394b..52c976135397 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1095,8 +1095,21 @@ mlx5_esw_bridge_vlan_push_mark_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct
 }
 
 static int
-mlx5_esw_bridge_vlan_push_pop_create(u16 vlan_proto, u16 flags, struct mlx5_esw_bridge_vlan *vlan,
-				     struct mlx5_eswitch *esw)
+mlx5_esw_bridge_vlan_push_pop_fhs_create(u16 vlan_proto, struct mlx5_esw_bridge_port *port,
+					 struct mlx5_esw_bridge_vlan *vlan)
+{
+	return mlx5_esw_bridge_vlan_mcast_init(vlan_proto, port, vlan);
+}
+
+static void
+mlx5_esw_bridge_vlan_push_pop_fhs_cleanup(struct mlx5_esw_bridge_vlan *vlan)
+{
+	mlx5_esw_bridge_vlan_mcast_cleanup(vlan);
+}
+
+static int
+mlx5_esw_bridge_vlan_push_pop_create(u16 vlan_proto, u16 flags, struct mlx5_esw_bridge_port *port,
+				     struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
 {
 	int err;
 
@@ -1114,10 +1127,16 @@ mlx5_esw_bridge_vlan_push_pop_create(u16 vlan_proto, u16 flags, struct mlx5_esw_
 		err = mlx5_esw_bridge_vlan_pop_create(vlan, esw);
 		if (err)
 			goto err_vlan_pop;
+
+		err = mlx5_esw_bridge_vlan_push_pop_fhs_create(vlan_proto, port, vlan);
+		if (err)
+			goto err_vlan_pop_fhs;
 	}
 
 	return 0;
 
+err_vlan_pop_fhs:
+	mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
 err_vlan_pop:
 	if (vlan->pkt_mod_hdr_push_mark)
 		mlx5_esw_bridge_vlan_push_mark_cleanup(vlan, esw);
@@ -1142,7 +1161,7 @@ mlx5_esw_bridge_vlan_create(u16 vlan_proto, u16 vid, u16 flags, struct mlx5_esw_
 	vlan->flags = flags;
 	INIT_LIST_HEAD(&vlan->fdb_list);
 
-	err = mlx5_esw_bridge_vlan_push_pop_create(vlan_proto, flags, vlan, esw);
+	err = mlx5_esw_bridge_vlan_push_pop_create(vlan_proto, flags, port, vlan, esw);
 	if (err)
 		goto err_vlan_push_pop;
 
@@ -1154,6 +1173,8 @@ mlx5_esw_bridge_vlan_create(u16 vlan_proto, u16 vid, u16 flags, struct mlx5_esw_
 	return vlan;
 
 err_xa_insert:
+	if (vlan->mcast_handle)
+		mlx5_esw_bridge_vlan_push_pop_fhs_cleanup(vlan);
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
 	if (vlan->pkt_mod_hdr_push_mark)
@@ -1180,6 +1201,8 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list)
 		mlx5_esw_bridge_fdb_entry_notify_and_cleanup(entry, bridge);
 
+	if (vlan->mcast_handle)
+		mlx5_esw_bridge_vlan_push_pop_fhs_cleanup(vlan);
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
 	if (vlan->pkt_mod_hdr_push_mark)
@@ -1218,8 +1241,8 @@ static int mlx5_esw_bridge_port_vlans_recreate(struct mlx5_esw_bridge_port *port
 
 	xa_for_each(&port->vlans, i, vlan) {
 		mlx5_esw_bridge_vlan_flush(vlan, bridge);
-		err = mlx5_esw_bridge_vlan_push_pop_create(bridge->vlan_proto, vlan->flags, vlan,
-							   br_offloads->esw);
+		err = mlx5_esw_bridge_vlan_push_pop_create(bridge->vlan_proto, vlan->flags, port,
+							   vlan, br_offloads->esw);
 		if (err) {
 			esw_warn(br_offloads->esw->dev,
 				 "Failed to create VLAN=%u(proto=%x) push/pop actions (vport=%u,err=%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index 4f54cb41ed19..99e2f9fc11a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -62,6 +62,60 @@ mlx5_esw_bridge_mcast_filter_fg_create(struct mlx5_eswitch *esw,
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_mcast_vlan_proto_fg_create(unsigned int from, unsigned int to, u16 vlan_proto,
+					   struct mlx5_eswitch *esw,
+					   struct mlx5_flow_table *mcast_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	if (vlan_proto == ETH_P_8021Q)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	else if (vlan_proto == ETH_P_8021AD)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.svlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index, from);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, to);
+
+	fg = mlx5_create_flow_group(mcast_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create VLAN(proto=%x) flow group for bridge mcast table (err=%pe)\n",
+			 vlan_proto, fg);
+
+	return fg;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_mcast_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *mcast_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_mcast_vlan_proto_fg_create(from, to, ETH_P_8021Q, esw, mcast_ft);
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_mcast_qinq_fg_create(struct mlx5_eswitch *esw,
+				     struct mlx5_flow_table *mcast_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_mcast_vlan_proto_fg_create(from, to, ETH_P_8021AD, esw, mcast_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_mcast_fwd_fg_create(struct mlx5_eswitch *esw,
 				    struct mlx5_flow_table *mcast_ft)
@@ -91,15 +145,27 @@ mlx5_esw_bridge_mcast_fwd_fg_create(struct mlx5_eswitch *esw,
 
 static int mlx5_esw_bridge_port_mcast_fgs_init(struct mlx5_esw_bridge_port *port)
 {
+	struct mlx5_flow_group *fwd_fg, *qinq_fg, *vlan_fg, *filter_fg;
 	struct mlx5_eswitch *esw = port->bridge->br_offloads->esw;
 	struct mlx5_flow_table *mcast_ft = port->mcast.ft;
-	struct mlx5_flow_group *fwd_fg, *filter_fg;
 	int err;
 
 	filter_fg = mlx5_esw_bridge_mcast_filter_fg_create(esw, mcast_ft);
 	if (IS_ERR(filter_fg))
 		return PTR_ERR(filter_fg);
 
+	vlan_fg = mlx5_esw_bridge_mcast_vlan_fg_create(esw, mcast_ft);
+	if (IS_ERR(vlan_fg)) {
+		err = PTR_ERR(vlan_fg);
+		goto err_vlan_fg;
+	}
+
+	qinq_fg = mlx5_esw_bridge_mcast_qinq_fg_create(esw, mcast_ft);
+	if (IS_ERR(qinq_fg)) {
+		err = PTR_ERR(qinq_fg);
+		goto err_qinq_fg;
+	}
+
 	fwd_fg = mlx5_esw_bridge_mcast_fwd_fg_create(esw, mcast_ft);
 	if (IS_ERR(fwd_fg)) {
 		err = PTR_ERR(fwd_fg);
@@ -107,11 +173,17 @@ static int mlx5_esw_bridge_port_mcast_fgs_init(struct mlx5_esw_bridge_port *port
 	}
 
 	port->mcast.filter_fg = filter_fg;
+	port->mcast.vlan_fg = vlan_fg;
+	port->mcast.qinq_fg = qinq_fg;
 	port->mcast.fwd_fg = fwd_fg;
 
 	return 0;
 
 err_fwd_fg:
+	mlx5_destroy_flow_group(qinq_fg);
+err_qinq_fg:
+	mlx5_destroy_flow_group(vlan_fg);
+err_vlan_fg:
 	mlx5_destroy_flow_group(filter_fg);
 	return err;
 }
@@ -121,6 +193,12 @@ static void mlx5_esw_bridge_port_mcast_fgs_cleanup(struct mlx5_esw_bridge_port *
 	if (port->mcast.fwd_fg)
 		mlx5_destroy_flow_group(port->mcast.fwd_fg);
 	port->mcast.fwd_fg = NULL;
+	if (port->mcast.qinq_fg)
+		mlx5_destroy_flow_group(port->mcast.qinq_fg);
+	port->mcast.qinq_fg = NULL;
+	if (port->mcast.vlan_fg)
+		mlx5_destroy_flow_group(port->mcast.vlan_fg);
+	port->mcast.vlan_fg = NULL;
 	if (port->mcast.filter_fg)
 		mlx5_destroy_flow_group(port->mcast.filter_fg);
 	port->mcast.filter_fg = NULL;
@@ -177,6 +255,82 @@ mlx5_esw_bridge_mcast_filter_flow_peer_create(struct mlx5_esw_bridge_port *port)
 	return handle;
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mcast_vlan_flow_create(u16 vlan_proto, struct mlx5_esw_bridge_port *port,
+				       struct mlx5_esw_bridge_vlan *vlan)
+{
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_VPORT,
+		.vport.num = port->vport_num,
+	};
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	if (MLX5_CAP_ESW_FLOWTABLE(bridge->br_offloads->esw->dev, flow_source) &&
+	    port->vport_num == MLX5_VPORT_UPLINK)
+		rule_spec->flow_context.flow_source =
+			MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	flow_act.pkt_reformat = vlan->pkt_reformat_pop;
+
+	if (vlan_proto == ETH_P_8021Q) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.cvlan_tag);
+	} else if (vlan_proto == ETH_P_8021AD) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.svlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.svlan_tag);
+	}
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria, outer_headers.first_vid);
+	MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid, vlan->vid);
+
+	if (MLX5_CAP_ESW(bridge->br_offloads->esw->dev, merged_eswitch)) {
+		dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
+		dest.vport.vhca_id = port->esw_owner_vhca_id;
+	}
+	handle = mlx5_add_flow_rules(port->mcast.ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
+int mlx5_esw_bridge_vlan_mcast_init(u16 vlan_proto, struct mlx5_esw_bridge_port *port,
+				    struct mlx5_esw_bridge_vlan *vlan)
+{
+	struct mlx5_flow_handle *handle;
+
+	if (!(port->bridge->flags & MLX5_ESW_BRIDGE_MCAST_FLAG))
+		return 0;
+
+	handle = mlx5_esw_bridge_mcast_vlan_flow_create(vlan_proto, port, vlan);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	vlan->mcast_handle = handle;
+	return 0;
+}
+
+void mlx5_esw_bridge_vlan_mcast_cleanup(struct mlx5_esw_bridge_vlan *vlan)
+{
+	if (vlan->mcast_handle)
+		mlx5_del_flow_rules(vlan->mcast_handle);
+	vlan->mcast_handle = NULL;
+}
+
 static struct mlx5_flow_handle *
 mlx5_esw_bridge_mcast_fwd_flow_create(struct mlx5_esw_bridge_port *port)
 {
@@ -214,6 +368,10 @@ mlx5_esw_bridge_mcast_fwd_flow_create(struct mlx5_esw_bridge_port *port)
 static int mlx5_esw_bridge_port_mcast_fhs_init(struct mlx5_esw_bridge_port *port)
 {
 	struct mlx5_flow_handle *filter_handle, *fwd_handle;
+	struct mlx5_esw_bridge_vlan *vlan, *failed;
+	unsigned long index;
+	int err;
+
 
 	filter_handle = (port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER) ?
 		mlx5_esw_bridge_mcast_filter_flow_peer_create(port) :
@@ -223,18 +381,44 @@ static int mlx5_esw_bridge_port_mcast_fhs_init(struct mlx5_esw_bridge_port *port
 
 	fwd_handle = mlx5_esw_bridge_mcast_fwd_flow_create(port);
 	if (IS_ERR(fwd_handle)) {
-		mlx5_del_flow_rules(filter_handle);
-		return PTR_ERR(fwd_handle);
+		err = PTR_ERR(fwd_handle);
+		goto err_fwd;
+	}
+
+	xa_for_each(&port->vlans, index, vlan) {
+		err = mlx5_esw_bridge_vlan_mcast_init(port->bridge->vlan_proto, port, vlan);
+		if (err) {
+			failed = vlan;
+			goto err_vlan;
+		}
 	}
 
 	port->mcast.filter_handle = filter_handle;
 	port->mcast.fwd_handle = fwd_handle;
 
 	return 0;
+
+err_vlan:
+	xa_for_each(&port->vlans, index, vlan) {
+		if (vlan == failed)
+			break;
+
+		mlx5_esw_bridge_vlan_mcast_cleanup(vlan);
+	}
+	mlx5_del_flow_rules(fwd_handle);
+err_fwd:
+	mlx5_del_flow_rules(filter_handle);
+	return err;
 }
 
 static void mlx5_esw_bridge_port_mcast_fhs_cleanup(struct mlx5_esw_bridge_port *port)
 {
+	struct mlx5_esw_bridge_vlan *vlan;
+	unsigned long index;
+
+	xa_for_each(&port->vlans, index, vlan)
+		mlx5_esw_bridge_vlan_mcast_cleanup(vlan);
+
 	if (port->mcast.fwd_handle)
 		mlx5_del_flow_rules(port->mcast.fwd_handle);
 	port->mcast.fwd_handle = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 7fdd719f363c..36ff32001ce8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -83,17 +83,31 @@ static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
 
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_SIZE 1
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_SIZE 1
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_SIZE 4095
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_SIZE MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_SIZE
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM		\
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_FROM		\
 	(MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_FROM		\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM		\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_QINQ_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_TO			\
 	(MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM +			\
 	 MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_SIZE - 1)
 
 #define MLX5_ESW_BRIDGE_MCAST_TABLE_SIZE			\
 	(MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_MCAST_TABLE_SIZE == 8192);
+
 enum {
 	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
 	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
@@ -144,6 +158,7 @@ struct mlx5_esw_bridge_vlan {
 	struct mlx5_pkt_reformat *pkt_reformat_push;
 	struct mlx5_pkt_reformat *pkt_reformat_pop;
 	struct mlx5_modify_hdr *pkt_mod_hdr_push_mark;
+	struct mlx5_flow_handle *mcast_handle;
 };
 
 struct mlx5_esw_bridge_port {
@@ -155,6 +170,8 @@ struct mlx5_esw_bridge_port {
 	struct {
 		struct mlx5_flow_table *ft;
 		struct mlx5_flow_group *filter_fg;
+		struct mlx5_flow_group *vlan_fg;
+		struct mlx5_flow_group *qinq_fg;
 		struct mlx5_flow_group *fwd_fg;
 
 		struct mlx5_flow_handle *filter_handle;
@@ -188,6 +205,9 @@ struct mlx5_flow_table *mlx5_esw_bridge_table_create(int max_fte, u32 level,
 
 int mlx5_esw_bridge_port_mcast_init(struct mlx5_esw_bridge_port *port);
 void mlx5_esw_bridge_port_mcast_cleanup(struct mlx5_esw_bridge_port *port);
+int mlx5_esw_bridge_vlan_mcast_init(u16 vlan_proto, struct mlx5_esw_bridge_port *port,
+				    struct mlx5_esw_bridge_vlan *vlan);
+void mlx5_esw_bridge_vlan_mcast_cleanup(struct mlx5_esw_bridge_vlan *vlan);
 
 int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge);
 void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge);
-- 
2.39.2

