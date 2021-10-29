Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6146F440483
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhJ2U7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhJ2U7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A807B610E5;
        Fri, 29 Oct 2021 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541009;
        bh=7hbZfFyfV00FlUNA4bxoirnMO77rg7GmON+RG8pqoBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMIAguQFXv8npWfl/DYDPFCeuolpiZxkwH1CW7RdY5ronM28F0fGAOWB8ADU46kQE
         1Qv90RWa0eI+OzNQE2eC8ZjxtCdwYyjr0zcrTSvS5keJHL/HUkj5CXBaeBHXbN8sTn
         BUGNs4WKv3pbGhc4OXuM3gVOSKC25+JjsIrz8cKj52F4IQsEYnseGBdN0I6NO1fWRp
         U+0IfHI1slvSQxDLae+HbsYj1yeIgCYU3ElxM5j5OBTb+673q+9Pfd4WR+1DhC2VoW
         qlfYMvkGHQTqqob/2pT7NzKFlFqOYW12eR4hNeoT9UHnQ2wpDtr9KsfjOp/AVQ7rtt
         tZ2Ul3Ks5J0pQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5e: Add indirect tc offload of ovs internal port
Date:   Fri, 29 Oct 2021 13:56:30 -0700
Message-Id: <20211029205632.390403-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Register callbacks for tc blocks of ovs internal port devices.

This allows an indirect offloading rules that apply on
such devices as the filter device.

In case a rule is added to a tc block of an internal port,
the mlx5 driver will implicitly add a matching on the internal
port's unique vport metadata value to the rule's matching list.
Therefore, only packets that previously hit a rule that redirects
to an internal port and got the vport metadata overwritten to the
internal port's unique metadata, can match on such indirect rule.

Offloading of both ingress and egress tc blocks of internal ports
is supported as opposed to other devices where only ingress block
offloading is supported.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 32 +++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 36 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 32 ++++++++++++-----
 4 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index c69129940268..fcb0892c08a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -25,6 +25,7 @@
 struct mlx5e_rep_indr_block_priv {
 	struct net_device *netdev;
 	struct mlx5e_rep_priv *rpriv;
+	enum flow_block_binder_type binder_type;
 
 	struct list_head list;
 };
@@ -299,14 +300,16 @@ int mlx5e_rep_tc_event_port_affinity(struct mlx5e_priv *priv)
 
 static struct mlx5e_rep_indr_block_priv *
 mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
-				 struct net_device *netdev)
+				 struct net_device *netdev,
+				 enum flow_block_binder_type binder_type)
 {
 	struct mlx5e_rep_indr_block_priv *cb_priv;
 
 	list_for_each_entry(cb_priv,
 			    &rpriv->uplink_priv.tc_indr_block_priv_list,
 			    list)
-		if (cb_priv->netdev == netdev)
+		if (cb_priv->netdev == netdev &&
+		    cb_priv->binder_type == binder_type)
 			return cb_priv;
 
 	return NULL;
@@ -344,9 +347,13 @@ mlx5e_rep_indr_offload(struct net_device *netdev,
 static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
 				      void *type_data, void *indr_priv)
 {
-	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
+	unsigned long flags = MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
 
+	flags |= (priv->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) ?
+		MLX5_TC_FLAG(EGRESS) :
+		MLX5_TC_FLAG(INGRESS);
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
@@ -428,11 +435,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 			   void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	bool is_ovs_int_port = netif_is_ovs_master(netdev);
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
 
 	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev)) {
+	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev) &&
+	    !is_ovs_int_port) {
 		if (!(netif_is_macvlan(netdev) && macvlan_dev_real_dev(netdev) == rpriv->netdev))
 			return -EOPNOTSUPP;
 		if (!mlx5e_rep_macvlan_mode_supported(netdev)) {
@@ -441,7 +451,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 		}
 	}
 
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		return -EOPNOTSUPP;
+
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS && !is_ovs_int_port)
+		return -EOPNOTSUPP;
+
+	if (is_ovs_int_port && !mlx5e_tc_int_port_supported(esw))
 		return -EOPNOTSUPP;
 
 	f->unlocked_driver_cb = true;
@@ -449,7 +466,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
+		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev, f->binder_type);
 		if (indr_priv)
 			return -EEXIST;
 
@@ -459,6 +476,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 
 		indr_priv->netdev = netdev;
 		indr_priv->rpriv = rpriv;
+		indr_priv->binder_type = f->binder_type;
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
@@ -476,7 +494,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
+		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev, f->binder_type);
 		if (!indr_priv)
 			return -ENOENT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3a82ca79de64..e11a906d70c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1437,6 +1437,32 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	esw_attr = attr->esw_attr;
 
+	if (netif_is_ovs_master(parse_attr->filter_dev)) {
+		struct mlx5e_tc_int_port *int_port;
+
+		if (attr->chain) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Internal port rule is only supported on chain 0");
+			return -EOPNOTSUPP;
+		}
+
+		if (attr->dest_chain) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Internal port rule offload doesn't support goto action");
+			return -EOPNOTSUPP;
+		}
+
+		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
+						 parse_attr->filter_dev->ifindex,
+						 flow_flag_test(flow, EGRESS) ?
+						 MLX5E_TC_INT_PORT_EGRESS :
+						 MLX5E_TC_INT_PORT_INGRESS);
+		if (IS_ERR(int_port))
+			return PTR_ERR(int_port);
+
+		esw_attr->int_port = int_port;
+	}
+
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		struct net_device *out_dev;
 		int mirred_ifindex;
@@ -1592,6 +1618,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
 
+	if (esw_attr->int_port)
+		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv), esw_attr->int_port);
+
 	if (esw_attr->dest_int_port)
 		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv), esw_attr->dest_int_port);
 
@@ -4254,10 +4283,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	/* If we forward to internal port we can only have 1 dest */
-	if (esw_attr->dest_int_port && esw_attr->out_count > 1) {
+	/* Forward to/from internal port can only have 1 dest */
+	if ((netif_is_ovs_master(parse_attr->filter_dev) || esw_attr->dest_int_port) &&
+	    esw_attr->out_count > 1) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Redirect to internal port should be the only destination");
+				   "Rules with internal port can have only one destination");
 		return -EOPNOTSUPP;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e3729bc131c3..42f8ee2e5d9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -468,6 +468,7 @@ struct mlx5_esw_flow_attr {
 	struct mlx5_core_dev	*in_mdev;
 	struct mlx5_core_dev    *counter_dev;
 	struct mlx5e_tc_int_port *dest_int_port;
+	struct mlx5e_tc_int_port *int_port;
 
 	int split_count;
 	int out_count;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8994a2886aa9..f4eaa5893886 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -86,12 +86,18 @@ mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
 				  struct mlx5_flow_spec *spec,
 				  struct mlx5_esw_flow_attr *attr)
 {
-	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
-	    attr && attr->in_rep)
-		spec->flow_context.flow_source =
-			attr->in_rep->vport == MLX5_VPORT_UPLINK ?
-				MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK :
-				MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
+	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) || !attr || !attr->in_rep)
+		return;
+
+	if (attr->int_port) {
+		spec->flow_context.flow_source = mlx5e_tc_int_port_get_flow_source(attr->int_port);
+
+		return;
+	}
+
+	spec->flow_context.flow_source = (attr->in_rep->vport == MLX5_VPORT_UPLINK) ?
+					 MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK :
+					 MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 }
 
 /* Actually only the upper 16 bits of reg c0 need to be cleared, but the lower 16 bits
@@ -121,6 +127,8 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 				  struct mlx5_eswitch *src_esw,
 				  u16 vport)
 {
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	u32 metadata;
 	void *misc2;
 	void *misc;
 
@@ -130,10 +138,16 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		if (mlx5_esw_indir_table_decap_vport(attr))
 			vport = mlx5_esw_indir_table_decap_vport(attr);
+
+		if (esw_attr->int_port)
+			metadata =
+				mlx5e_tc_int_port_get_metadata_for_match(esw_attr->int_port);
+		else
+			metadata =
+				mlx5_eswitch_get_vport_metadata_for_match(src_esw, vport);
+
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
-		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
-			 mlx5_eswitch_get_vport_metadata_for_match(src_esw,
-								   vport));
+		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0, metadata);
 
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
 		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
-- 
2.31.1

