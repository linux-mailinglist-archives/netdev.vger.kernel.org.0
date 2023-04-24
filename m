Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42956DEA28
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDLEIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDLEIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8118246A5
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F0A62DA5
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D9CC433EF;
        Wed, 12 Apr 2023 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272485;
        bh=ieDogycRO2WTRYIVGDUhIotqnr4z0XIfuuLu/C7sOFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aleCNUYpGn0cZ0rTvz6aaBqxi/xPVWJ4ZFlu5C+GrVhXS9TK2mUoRbybV1MrQx4Rw
         Ac0UAw/elMgI5Trps0fg+NOVa+IfncUEv6yR3kmtGrKsbO1kQEaEwWFc08REBiwfFd
         Buhe10wRGYznPBEhCq6ZuphG9L1Pzg8Bkvd2A93xfH7U1HEjy1F6V4gnCjSxhgizY7
         K0YjTkr7BF6VlHlCY3uflw2ZEwYFvOqKGQMuTlJOmfSjkJJMAWYx02vG9vQFw8iAR8
         T08dtEthskLMILiMwaChel6/kE7hKcDB8lYckkFYJ2fsiUsDS0lm+LLZenLPDRie6Q
         bC8qkFuA8o+cA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Bridge, add per-port multicast replication tables
Date:   Tue, 11 Apr 2023 21:07:43 -0700
Message-Id: <20230412040752.14220-7-saeed@kernel.org>
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

Multicast replication requires adding one more level of FDB_BR_OFFLOAD
priority flow tables. The new level is used for per-port multicast-specific
tables that have following flow groups structure (flow highest to lowest
priority):

- Flow group of size one that matches on source port metadata. This will
have a static single rule that prevent packets from being replicated to
their source port.

- Flow group of size one that matches all packets and forwards them to the
port that owns the table.

Initialize the table dynamically on all bridge ports when adding a port to
the bridge that has multicast enabled and on all existing bridge ports when
receiving multicast enable notification.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  14 +-
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 329 +++++++++++++++++-
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  28 ++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 4 files changed, 370 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 35436aa9548d..4bc8c6fc394b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -61,7 +61,7 @@ mlx5_esw_bridge_pkt_reformat_vlan_pop_create(struct mlx5_eswitch *esw)
 	return mlx5_packet_reformat_alloc(esw->dev, &reformat_params, MLX5_FLOW_NAMESPACE_FDB);
 }
 
-static struct mlx5_flow_table *
+struct mlx5_flow_table *
 mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
@@ -1506,6 +1506,15 @@ static int mlx5_esw_bridge_vport_init(u16 vport_num, u16 esw_owner_vhca_id, u16
 	port->bridge = bridge;
 	port->flags |= flags;
 	xa_init(&port->vlans);
+
+	err = mlx5_esw_bridge_port_mcast_init(port);
+	if (err) {
+		esw_warn(esw->dev,
+			 "Failed to initialize port multicast (vport=%u,esw_owner_vhca_id=%u,err=%d)\n",
+			 port->vport_num, port->esw_owner_vhca_id, err);
+		goto err_port_mcast;
+	}
+
 	err = mlx5_esw_bridge_port_insert(port, br_offloads);
 	if (err) {
 		esw_warn(esw->dev,
@@ -1518,6 +1527,8 @@ static int mlx5_esw_bridge_vport_init(u16 vport_num, u16 esw_owner_vhca_id, u16
 	return 0;
 
 err_port_insert:
+	mlx5_esw_bridge_port_mcast_cleanup(port);
+err_port_mcast:
 	kvfree(port);
 	return err;
 }
@@ -1535,6 +1546,7 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 
 	trace_mlx5_esw_bridge_vport_cleanup(port);
 	mlx5_esw_bridge_port_vlans_flush(port, bridge);
+	mlx5_esw_bridge_port_mcast_cleanup(port);
 	mlx5_esw_bridge_port_erase(port, br_offloads);
 	kvfree(port);
 	mlx5_esw_bridge_put(br_offloads, bridge);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index d5a89a86c9e8..4f54cb41ed19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -1,10 +1,283 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
 
+#include "lib/devcom.h"
 #include "bridge.h"
 #include "eswitch.h"
 #include "bridge_priv.h"
 
+static int mlx5_esw_bridge_port_mcast_fts_init(struct mlx5_esw_bridge_port *port,
+					       struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_eswitch *esw = bridge->br_offloads->esw;
+	struct mlx5_flow_table *mcast_ft;
+
+	mcast_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_MCAST_TABLE_SIZE,
+						MLX5_ESW_BRIDGE_LEVEL_MCAST_TABLE,
+						esw);
+	if (IS_ERR(mcast_ft))
+		return PTR_ERR(mcast_ft);
+
+	port->mcast.ft = mcast_ft;
+	return 0;
+}
+
+static void mlx5_esw_bridge_port_mcast_fts_cleanup(struct mlx5_esw_bridge_port *port)
+{
+	if (port->mcast.ft)
+		mlx5_destroy_flow_table(port->mcast.ft);
+	port->mcast.ft = NULL;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_mcast_filter_fg_create(struct mlx5_eswitch *esw,
+				       struct mlx5_flow_table *mcast_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_MISC_PARAMETERS_2);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_mask());
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(mcast_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create filter flow group for bridge mcast table (err=%pe)\n",
+			 fg);
+
+	return fg;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_mcast_fwd_fg_create(struct mlx5_eswitch *esw,
+				    struct mlx5_flow_table *mcast_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(mcast_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create forward flow group for bridge mcast table (err=%pe)\n",
+			 fg);
+
+	return fg;
+}
+
+static int mlx5_esw_bridge_port_mcast_fgs_init(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_eswitch *esw = port->bridge->br_offloads->esw;
+	struct mlx5_flow_table *mcast_ft = port->mcast.ft;
+	struct mlx5_flow_group *fwd_fg, *filter_fg;
+	int err;
+
+	filter_fg = mlx5_esw_bridge_mcast_filter_fg_create(esw, mcast_ft);
+	if (IS_ERR(filter_fg))
+		return PTR_ERR(filter_fg);
+
+	fwd_fg = mlx5_esw_bridge_mcast_fwd_fg_create(esw, mcast_ft);
+	if (IS_ERR(fwd_fg)) {
+		err = PTR_ERR(fwd_fg);
+		goto err_fwd_fg;
+	}
+
+	port->mcast.filter_fg = filter_fg;
+	port->mcast.fwd_fg = fwd_fg;
+
+	return 0;
+
+err_fwd_fg:
+	mlx5_destroy_flow_group(filter_fg);
+	return err;
+}
+
+static void mlx5_esw_bridge_port_mcast_fgs_cleanup(struct mlx5_esw_bridge_port *port)
+{
+	if (port->mcast.fwd_fg)
+		mlx5_destroy_flow_group(port->mcast.fwd_fg);
+	port->mcast.fwd_fg = NULL;
+	if (port->mcast.filter_fg)
+		mlx5_destroy_flow_group(port->mcast.filter_fg);
+	port->mcast.filter_fg = NULL;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mcast_flow_with_esw_create(struct mlx5_esw_bridge_port *port,
+					   struct mlx5_eswitch *esw)
+{
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_DROP,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
+
+	MLX5_SET(fte_match_param, rule_spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_for_match(esw, port->vport_num));
+
+	handle = mlx5_add_flow_rules(port->mcast.ft, rule_spec, &flow_act, NULL, 0);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mcast_filter_flow_create(struct mlx5_esw_bridge_port *port)
+{
+	return mlx5_esw_bridge_mcast_flow_with_esw_create(port, port->bridge->br_offloads->esw);
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mcast_filter_flow_peer_create(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_devcom *devcom = port->bridge->br_offloads->esw->dev->priv.devcom;
+	static struct mlx5_flow_handle *handle;
+	struct mlx5_eswitch *peer_esw;
+
+	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	if (!peer_esw)
+		return ERR_PTR(-ENODEV);
+
+	handle = mlx5_esw_bridge_mcast_flow_with_esw_create(port, peer_esw);
+
+	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	return handle;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_mcast_fwd_flow_create(struct mlx5_esw_bridge_port *port)
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
+static int mlx5_esw_bridge_port_mcast_fhs_init(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_flow_handle *filter_handle, *fwd_handle;
+
+	filter_handle = (port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER) ?
+		mlx5_esw_bridge_mcast_filter_flow_peer_create(port) :
+		mlx5_esw_bridge_mcast_filter_flow_create(port);
+	if (IS_ERR(filter_handle))
+		return PTR_ERR(filter_handle);
+
+	fwd_handle = mlx5_esw_bridge_mcast_fwd_flow_create(port);
+	if (IS_ERR(fwd_handle)) {
+		mlx5_del_flow_rules(filter_handle);
+		return PTR_ERR(fwd_handle);
+	}
+
+	port->mcast.filter_handle = filter_handle;
+	port->mcast.fwd_handle = fwd_handle;
+
+	return 0;
+}
+
+static void mlx5_esw_bridge_port_mcast_fhs_cleanup(struct mlx5_esw_bridge_port *port)
+{
+	if (port->mcast.fwd_handle)
+		mlx5_del_flow_rules(port->mcast.fwd_handle);
+	port->mcast.fwd_handle = NULL;
+	if (port->mcast.filter_handle)
+		mlx5_del_flow_rules(port->mcast.filter_handle);
+	port->mcast.filter_handle = NULL;
+}
+
+int mlx5_esw_bridge_port_mcast_init(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_esw_bridge *bridge = port->bridge;
+	int err;
+
+	if (!(bridge->flags & MLX5_ESW_BRIDGE_MCAST_FLAG))
+		return 0;
+
+	err = mlx5_esw_bridge_port_mcast_fts_init(port, bridge);
+	if (err)
+		return err;
+
+	err = mlx5_esw_bridge_port_mcast_fgs_init(port);
+	if (err)
+		goto err_fgs;
+
+	err = mlx5_esw_bridge_port_mcast_fhs_init(port);
+	if (err)
+		goto err_fhs;
+	return err;
+
+err_fhs:
+	mlx5_esw_bridge_port_mcast_fgs_cleanup(port);
+err_fgs:
+	mlx5_esw_bridge_port_mcast_fts_cleanup(port);
+	return err;
+}
+
+void mlx5_esw_bridge_port_mcast_cleanup(struct mlx5_esw_bridge_port *port)
+{
+	mlx5_esw_bridge_port_mcast_fhs_cleanup(port);
+	mlx5_esw_bridge_port_mcast_fgs_cleanup(port);
+	mlx5_esw_bridge_port_mcast_fts_cleanup(port);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_igmp_fg_create(struct mlx5_eswitch *esw,
 				       struct mlx5_flow_table *ingress_ft)
@@ -251,6 +524,51 @@ mlx5_esw_bridge_ingress_mcast_fhs_cleanup(struct mlx5_esw_bridge_offloads *br_of
 	br_offloads->igmp_handle = NULL;
 }
 
+static int mlx5_esw_brige_mcast_init(struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_esw_bridge_port *port, *failed;
+	unsigned long i;
+	int err;
+
+	xa_for_each(&br_offloads->ports, i, port) {
+		if (port->bridge != bridge)
+			continue;
+
+		err = mlx5_esw_bridge_port_mcast_init(port);
+		if (err) {
+			failed = port;
+			goto err_port;
+		}
+	}
+	return 0;
+
+err_port:
+	xa_for_each(&br_offloads->ports, i, port) {
+		if (port == failed)
+			break;
+		if (port->bridge != bridge)
+			continue;
+
+		mlx5_esw_bridge_port_mcast_cleanup(port);
+	}
+	return err;
+}
+
+static void mlx5_esw_brige_mcast_cleanup(struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_esw_bridge_port *port;
+	unsigned long i;
+
+	xa_for_each(&br_offloads->ports, i, port) {
+		if (port->bridge != bridge)
+			continue;
+
+		mlx5_esw_bridge_port_mcast_cleanup(port);
+	}
+}
+
 static int mlx5_esw_brige_mcast_global_enable(struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	int err;
@@ -306,11 +624,20 @@ int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge)
 		return err;
 
 	bridge->flags |= MLX5_ESW_BRIDGE_MCAST_FLAG;
-	return 0;
+
+	err = mlx5_esw_brige_mcast_init(bridge);
+	if (err) {
+		esw_warn(bridge->br_offloads->esw->dev, "Failed to enable multicast (err=%d)\n",
+			 err);
+		bridge->flags &= ~MLX5_ESW_BRIDGE_MCAST_FLAG;
+		mlx5_esw_brige_mcast_global_disable(bridge->br_offloads);
+	}
+	return err;
 }
 
 void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge)
 {
+	mlx5_esw_brige_mcast_cleanup(bridge);
 	bridge->flags &= ~MLX5_ESW_BRIDGE_MCAST_FLAG;
 	mlx5_esw_brige_mcast_global_disable(bridge->br_offloads);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index dbb935db1b3c..7fdd719f363c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -81,9 +81,23 @@ static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
 
 #define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
 
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_SIZE 1
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_SIZE 1
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM		\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_FROM +			\
+	 MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_SIZE - 1)
+
+#define MLX5_ESW_BRIDGE_MCAST_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_MCAST_TABLE_FWD_GRP_IDX_TO + 1)
 enum {
 	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
 	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_MCAST_TABLE,
 	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
 };
 
@@ -138,6 +152,14 @@ struct mlx5_esw_bridge_port {
 	u16 flags;
 	struct mlx5_esw_bridge *bridge;
 	struct xarray vlans;
+	struct {
+		struct mlx5_flow_table *ft;
+		struct mlx5_flow_group *filter_fg;
+		struct mlx5_flow_group *fwd_fg;
+
+		struct mlx5_flow_handle *filter_handle;
+		struct mlx5_flow_handle *fwd_handle;
+	} mcast;
 };
 
 struct mlx5_esw_bridge {
@@ -161,6 +183,12 @@ struct mlx5_esw_bridge {
 	u16 vlan_proto;
 };
 
+struct mlx5_flow_table *mlx5_esw_bridge_table_create(int max_fte, u32 level,
+						     struct mlx5_eswitch *esw);
+
+int mlx5_esw_bridge_port_mcast_init(struct mlx5_esw_bridge_port *port);
+void mlx5_esw_bridge_port_mcast_cleanup(struct mlx5_esw_bridge_port *port);
+
 int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge);
 void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 8e3da9d4fe1c..19da02c41616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2997,7 +2997,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
-	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BR_OFFLOAD, 3);
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BR_OFFLOAD, 4);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
 		goto out_err;
-- 
2.39.2

