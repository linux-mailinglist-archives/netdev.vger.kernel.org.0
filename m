Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEEB310516
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBEGpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhBEGp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:45:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 494A064FC0;
        Fri,  5 Feb 2021 06:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507448;
        bh=3mdxzFHw6Lad1hMvZhNSMqhVTWRM9Ju9GuYBEoK2zTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJsBoyitaolFPfumi6FPpfGC7buQ3ZQLqSWj1ltV6TPGmoj4v5yTlX+KkoQqNNSS6
         dkS1x5WiaNh2QU4pxSCkiCrKAQs6Yss3ouMGabWiDkIWHEECGpzxuFVh49VMpuiahG
         sTPTx5ZhaA60vi/A67ytpyuCVLMkgSX6uls3/86jNQ5kMlkn91mCPnEBI9HAKJRIgd
         YeG20UNm9IPGj+8ifYOanOFvbmqFtOpr5AhkPiMzYG3uNUtywL99FT1i+SP0OkCXBF
         qGL7gAdj9fI6ud2qDf5/r14Z8UFC+n+FPeqwoDks/rcoW1BXsnMKntzAlSCJc5cci9
         bNMgMLVsvDKow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/17] net/mlx5e: VF tunnel TX traffic offloading
Date:   Thu,  4 Feb 2021 22:40:39 -0800
Message-Id: <20210205064051.89592-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

When tunnel endpoint is on VF, driver still assumes that endpoint is on
uplink and incorrectly configures encap rule offload according to that
assumption. As a result, traffic is sent directly to the uplink and rules
installed on representor of tunnel endpoint VF are ignored.

Implement following changes to allow offloading tx traffic with tunnel
endpoint on VF:

- For tunneling flows perform route lookup on route and out devices pair.
If out device is uplink and route device is VF of same physical port, then
modify packet reg_c_0 metadata register (source port) with the value of VF
vport. Use eswitch vhca_id->vport mapping introduced in one of previous
patches in the series to obtain vport from route netdevice.

- Recirculate encapsulated packets to VF vport in order to apply any flow
rules installed on VF representor that match on encapsulated traffic.

Only enable support for this functionality when all following conditions
are true:

- Hardware advertises capability to preserve reg_c_0 value on packet
recirculation.

- Vport metadata matching is enabled.

- Termination tables are to be used by the flow.

Example TC rules for VF tunnel traffic:

1. Rule that redirects packets from UL to VF rep that has the tunnel
endpoint IP address:

$ tc -s filter show dev enp8s0f0 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac 16:c9:a0:2d:69:2c
  src_mac 0c:42:a1:58:ab:e4
  eth_type ipv4
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device enp8s0f0_0) stolen
        index 3 ref 1 bind 1 installed 377 sec used 0 sec
        Action statistics:
        Sent 114096 bytes 952 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 114096 bytes 952 pkt
        backlog 0b 0p requeues 0
        cookie 878fa48d8c423fc08c3b6ca599b50a97
        no_percpu
        used_hw_stats delayed

2. Rule that decapsulates the tunneled flow and redirects to destination VF
representor:

$ tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac ca:2e:a7:3f:f5:0f
  src_mac 0a:40:bd:30:89:99
  eth_type ipv4
  enc_dst_ip 7.7.7.5
  enc_src_ip 7.7.7.1
  enc_key_id 98
  enc_dst_port 4789
  enc_tos 0
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  unset pipe
         index 2 ref 1 bind 1 installed 434 sec used 434 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device enp8s0f0_1) stolen
        index 4 ref 1 bind 1 installed 434 sec used 0 sec
        Action statistics:
        Sent 129936 bytes 1082 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 129936 bytes 1082 pkt
        backlog 0b 0p requeues 0
        cookie ac17cf398c4c69e4a5b2f7aabd1b88ff
        no_percpu
        used_hw_stats delayed

Co-developed-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  87 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 120 ++++++++++++++++--
 include/linux/mlx5/eswitch.h                  |   2 +
 5 files changed, 201 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 280ea1e1e039..43f1508a05b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -165,6 +165,11 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 		.moffset = 0,
 		.mlen = 2,
 	},
+	[VPORT_TO_REG] = {
+		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
+		.moffset = 2,
+		.mlen = 2,
+	},
 	[TUNNEL_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,
 		.moffset = 1,
@@ -1315,6 +1320,44 @@ static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 	mutex_unlock(&uplink_priv->unready_flows_lock);
 }
 
+static bool same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv);
+
+static bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_dev)
+{
+	struct mlx5_core_dev *out_mdev, *route_mdev;
+	struct mlx5e_priv *out_priv, *route_priv;
+
+	out_priv = netdev_priv(out_dev);
+	out_mdev = out_priv->mdev;
+	route_priv = netdev_priv(route_dev);
+	route_mdev = route_priv->mdev;
+
+	if (out_mdev->coredev_type != MLX5_COREDEV_PF ||
+	    route_mdev->coredev_type != MLX5_COREDEV_VF)
+		return false;
+
+	return same_hw_devs(out_priv, route_priv);
+}
+
+static int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev,
+				      u16 *vport)
+{
+	struct mlx5e_priv *out_priv, *route_priv;
+	struct mlx5_core_dev *route_mdev;
+	struct mlx5_eswitch *esw;
+	u16 vhca_id;
+	int err;
+
+	out_priv = netdev_priv(out_dev);
+	esw = out_priv->mdev->priv.eswitch;
+	route_priv = netdev_priv(route_dev);
+	route_mdev = route_priv->mdev;
+
+	vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
+	err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	return err;
+}
+
 static int
 mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
@@ -3700,6 +3743,45 @@ static bool is_duplicated_encap_entry(struct mlx5e_priv *priv,
 	return false;
 }
 
+static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
+			       struct mlx5_flow_attr *attr,
+			       struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			       struct net_device *out_dev,
+			       int route_dev_ifindex,
+			       int out_index)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct net_device *route_dev;
+	u16 vport_num;
+	int err = 0;
+	u32 data;
+
+	route_dev = dev_get_by_index(dev_net(out_dev), route_dev_ifindex);
+
+	if (!route_dev || route_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    !mlx5e_tc_is_vf_tunnel(out_dev, route_dev))
+		goto out;
+
+	err = mlx5e_tc_query_route_vport(out_dev, route_dev, &vport_num);
+	if (err)
+		goto out;
+
+	attr->dest_chain = 0;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	data = mlx5_eswitch_get_vport_metadata_for_set(esw_attr->in_mdev->priv.eswitch,
+						       vport_num);
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_hdr_acts,
+					MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG, data);
+	if (err)
+		goto out;
+
+out:
+	if (route_dev)
+		dev_put(route_dev);
+	return err;
+}
+
 static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct net_device *mirred_dev,
@@ -3791,6 +3873,11 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	e->compl_result = 1;
 
 attach_flow:
+	err = mlx5e_set_vf_tunnel(esw, attr, &parse_attr->mod_hdr_acts, e->out_dev,
+				  e->route_dev_ifindex, out_index);
+	if (err)
+		goto out_err;
+
 	flow->encaps[out_index].e = e;
 	list_add(&flow->encaps[out_index].list, &e->flows);
 	flow->encaps[out_index].index = out_index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 4a2ce241522e..56d809904ea7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -167,6 +167,7 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
 	CHAIN_TO_REG,
+	VPORT_TO_REG,
 	TUNNEL_TO_REG,
 	CTSTATE_TO_REG,
 	ZONE_TO_REG,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1a045e95bc68..1ab34751329e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -389,12 +389,14 @@ enum mlx5_flow_match_level {
 enum {
 	MLX5_ESW_DEST_ENCAP         = BIT(0),
 	MLX5_ESW_DEST_ENCAP_VALID   = BIT(1),
+	MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE  = BIT(2),
 };
 
 enum {
 	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
 	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
+	MLX5_ESW_ATTR_FLAG_SRC_REWRITE   = BIT(3),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 335dc83d1bb9..1b18f624e04a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -337,6 +337,65 @@ esw_setup_chain_dest(struct mlx5_flow_destination *dest,
 	return  0;
 }
 
+static void esw_put_dest_tables_loop(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr,
+				     int from, int to)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_fs_chains *chains = esw_chains(esw);
+	int i;
+
+	for (i = from; i < to; i++)
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			mlx5_chains_put_table(chains, 0, 1, 0);
+}
+
+static bool
+esw_is_chain_src_port_rewrite(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *esw_attr)
+{
+	int i;
+
+	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			return true;
+	return false;
+}
+
+static int
+esw_setup_chain_src_port_rewrite(struct mlx5_flow_destination *dest,
+				 struct mlx5_flow_act *flow_act,
+				 struct mlx5_eswitch *esw,
+				 struct mlx5_fs_chains *chains,
+				 struct mlx5_flow_attr *attr,
+				 int *i)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	int j, err;
+
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+		return -EOPNOTSUPP;
+
+	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, (*i)++) {
+		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
+		if (err)
+			goto err_setup_chain;
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		flow_act->pkt_reformat = esw_attr->dests[j].pkt_reformat;
+	}
+	return 0;
+
+err_setup_chain:
+	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, j);
+	return err;
+}
+
+static void esw_cleanup_chain_src_port_rewrite(struct mlx5_eswitch *esw,
+					       struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+
+	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, esw_attr->out_count);
+}
+
 static void
 esw_cleanup_chain_dest(struct mlx5_fs_chains *chains, u32 chain, u32 prio, u32 level)
 {
@@ -381,12 +440,18 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		struct mlx5_flow_act *flow_act,
 		struct mlx5_eswitch *esw,
 		struct mlx5_flow_attr *attr,
+		struct mlx5_flow_spec *spec,
 		int *i)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
 	int err = 0;
 
+	if (!mlx5_eswitch_termtbl_required(esw, attr, flow_act, spec) &&
+	    MLX5_CAP_GEN(esw_attr->in_mdev, reg_c_preserve) &&
+	    mlx5_eswitch_vport_match_metadata_enabled(esw))
+		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
+
 	if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, attr, *i);
 		(*i)++;
@@ -397,6 +462,8 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
 					   1, 0, *i);
 		(*i)++;
+	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
+		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
 	} else {
 		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
 	}
@@ -408,10 +475,15 @@ static void
 esw_cleanup_dests(struct mlx5_eswitch *esw,
 		  struct mlx5_flow_attr *attr)
 {
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
-		esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
+		if (attr->dest_chain)
+			esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
+		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
+			esw_cleanup_chain_src_port_rewrite(esw, attr);
+	}
 }
 
 struct mlx5_flow_handle *
@@ -448,10 +520,12 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		}
 	}
 
+	mlx5_eswitch_set_rule_flow_source(esw, spec, esw_attr);
+
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		int err;
 
-		err = esw_setup_dests(dest, &flow_act, esw, attr, &i);
+		err = esw_setup_dests(dest, &flow_act, esw, attr, spec, &i);
 		if (err) {
 			rule = ERR_PTR(err);
 			goto err_create_goto_table;
@@ -498,8 +572,6 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		goto err_esw_get;
 	}
 
-	mlx5_eswitch_set_rule_flow_source(esw, spec, esw_attr);
-
 	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec))
 		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, esw_attr,
 						     &flow_act, dest, i);
@@ -536,7 +608,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	struct mlx5_flow_table *fast_fdb;
 	struct mlx5_flow_table *fwd_fdb;
 	struct mlx5_flow_handle *rule;
-	int i;
+	int i, err = 0;
 
 	fast_fdb = mlx5_chains_get_table(chains, attr->chain, attr->prio, 0);
 	if (IS_ERR(fast_fdb)) {
@@ -554,8 +626,18 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	for (i = 0; i < esw_attr->split_count; i++)
-		esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
+	for (i = 0; i < esw_attr->split_count; i++) {
+		if (esw_is_chain_src_port_rewrite(esw, esw_attr))
+			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
+							       &i);
+		else
+			esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
+
+		if (err) {
+			rule = ERR_PTR(err);
+			goto err_chain_src_rewrite;
+		}
+	}
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = fwd_fdb;
 	i++;
@@ -570,13 +652,16 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	rule = mlx5_add_flow_rules(fast_fdb, spec, &flow_act, dest, i);
 
-	if (IS_ERR(rule))
-		goto add_err;
+	if (IS_ERR(rule)) {
+		i = esw_attr->split_count;
+		goto err_chain_src_rewrite;
+	}
 
 	atomic64_inc(&esw->offloads.num_flows);
 
 	return rule;
-add_err:
+err_chain_src_rewrite:
+	esw_put_dest_tables_loop(esw, attr, 0, i);
 	esw_vport_tbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
@@ -617,6 +702,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	if (fwd_rule)  {
 		esw_vport_tbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
+		esw_put_dest_tables_loop(esw, attr, 0, esw_attr->split_count);
 	} else {
 		if (split)
 			esw_vport_tbl_put(esw, &fwd_attr);
@@ -3020,3 +3106,15 @@ int mlx5_eswitch_vhca_id_to_vport(struct mlx5_eswitch *esw, u16 vhca_id, u16 *vp
 	*vport_num = *res;
 	return 0;
 }
+
+u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
+					    u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (WARN_ON_ONCE(IS_ERR(vport)))
+		return 0;
+
+	return vport->metadata;
+}
+EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_set);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 29fd832950e0..67e341274a22 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -96,6 +96,8 @@ static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)
 
 u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num);
+u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
+					    u16 vport_num);
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 #else  /* CONFIG_MLX5_ESWITCH */
 
-- 
2.29.2

