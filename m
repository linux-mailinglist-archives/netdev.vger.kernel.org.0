Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D03440481
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhJ2U7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhJ2U7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D4F610CF;
        Fri, 29 Oct 2021 20:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541008;
        bh=S3D+4bRB4BS4N00pvorE4KBzt5Jfqg8HRibnktxb4Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNt93lKRXGTcRKbVC7AY8lEJwkRaxVwwZA3PJWf2zziHx1K39SX4LQ6HJsNQApE8X
         VneRpP2DwFVDjamBz1z0Cwd61WlO8MysF6MLW87CP0U8IyQrRepk7t05rzz2CldbVc
         dvEpq7NtGoCgVaGbj8oRuOZCGc8GHwyy2yw2V22/jNxQwgecv2nwfzlbwid/6ZH15I
         fwTjTpzvbzSayZV8ebwDPCW8Ua/IjSfeo/p2guu7fdN8k+svhvNHxB/DshF9pT7Qnt
         F7KnutcKhAQNhl3ULmmx3dTw/MAtr3y2QwPgjMMWBf3NZRVATLsbpqCVcMwdrj/0sj
         u0ywxfOsmpS+g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/14] net/mlx5e: Offload tc rules that redirect to ovs internal port
Date:   Fri, 29 Oct 2021 13:56:28 -0700
Message-Id: <20211029205632.390403-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Allow offloading rules that redirect to ovs internal port
ingress and egress.

To support redirect to ingress device, offloading of REDIRECT_INGRESS
action is added.

When a tc rule redirects to ovs internal port, the hw rule will
overwrite the input vport value in reg_c0 with a new vport metadata
value that is mapped for this internal port using the internal
port mapping api that is introduce in previous patches.
After that the hw rule will redirect the packet to the root table
to continue processing with the new vport metadata value.

The new vport metadata value indicates that this packet is now
arriving through an internal port and therefore should be processed
using rules that apply on the same internal port as the filter device.
Therefore, following rules that apply on this internal port will have
to match on the same vport metadata value as part of their matching
keys to make sure the packet belongs to the internal port.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 123 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   6 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  10 +-
 .../mlx5/core/eswitch_offloads_termtbl.c      |   3 +-
 6 files changed, 141 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index d1599b7b944b..8f64f2c8895a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -173,4 +173,6 @@ void mlx5e_flow_put(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow);
 
 struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow);
 
+struct mlx5e_tc_int_port_priv *
+mlx5e_get_int_port_priv(struct mlx5e_priv *priv);
 #endif /* __MLX5_EN_TC_PRIV_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3242eba67047..21c37a1a4796 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -231,6 +231,23 @@ mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 	return err;
 }
 
+struct mlx5e_tc_int_port_priv *
+mlx5e_get_int_port_priv(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+
+	if (is_mdev_switchdev_mode(priv->mdev)) {
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+
+		return uplink_priv->int_port_priv;
+	}
+
+	return NULL;
+}
+
 static struct mlx5_tc_ct_priv *
 get_ct_priv(struct mlx5e_priv *priv)
 {
@@ -1573,6 +1590,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
 
+	if (esw_attr->dest_int_port)
+		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv), esw_attr->dest_int_port);
+
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
@@ -3814,6 +3834,45 @@ static int verify_uplink_forwarding(struct mlx5e_priv *priv,
 	return 0;
 }
 
+int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
+				      struct mlx5_flow_attr *attr,
+				      int ifindex,
+				      enum mlx5e_tc_int_port_type type,
+				      u32 *action,
+				      int out_index)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5e_tc_int_port_priv *int_port_priv;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5e_tc_int_port *dest_int_port;
+	int err;
+
+	parse_attr = attr->parse_attr;
+	int_port_priv = mlx5e_get_int_port_priv(priv);
+
+	dest_int_port = mlx5e_tc_int_port_get(int_port_priv, ifindex, type);
+	if (IS_ERR(dest_int_port))
+		return PTR_ERR(dest_int_port);
+
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &parse_attr->mod_hdr_acts,
+					MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
+					mlx5e_tc_int_port_get_metadata(dest_int_port));
+	if (err) {
+		mlx5e_tc_int_port_put(int_port_priv, dest_int_port);
+		return err;
+	}
+
+	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+	esw_attr->dest_int_port = dest_int_port;
+	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+
+	/* Forward to root fdb for matching against the new source vport */
+	attr->dest_chain = 0;
+
+	return 0;
+}
+
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
@@ -3833,6 +3892,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
+	bool ptype_host = false;
 	bool mpls_push = false;
 
 	if (!flow_action_has_entries(flow_action)) {
@@ -3862,6 +3922,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						   "skbedit ptype is only supported with type host");
 				return -EOPNOTSUPP;
 			}
+
+			ptype_host = true;
 			break;
 		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
@@ -3926,6 +3988,50 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				break;
 
 			return -EOPNOTSUPP;
+		case FLOW_ACTION_REDIRECT_INGRESS: {
+			struct net_device *out_dev;
+
+			out_dev = act->dev;
+			if (!out_dev)
+				return -EOPNOTSUPP;
+
+			if (!netif_is_ovs_master(out_dev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "redirect to ingress is supported only for OVS internal ports");
+				return -EOPNOTSUPP;
+			}
+
+			if (netif_is_ovs_master(parse_attr->filter_dev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "redirect to ingress is not supported from internal port");
+				return -EOPNOTSUPP;
+			}
+
+			if (!ptype_host) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "redirect to int port ingress requires ptype=host action");
+				return -EOPNOTSUPP;
+			}
+
+			if (esw_attr->out_count) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "redirect to int port ingress is supported only as single destination");
+				return -EOPNOTSUPP;
+			}
+
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
+			err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
+								MLX5E_TC_INT_PORT_INGRESS,
+								&action, esw_attr->out_count);
+			if (err)
+				return err;
+
+			esw_attr->out_count++;
+
+			break;
+		}
 		case FLOW_ACTION_REDIRECT:
 		case FLOW_ACTION_MIRRED: {
 			struct mlx5e_priv *out_priv;
@@ -4035,6 +4141,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				rpriv = out_priv->ppriv;
 				esw_attr->dests[esw_attr->out_count].rep = rpriv->rep;
 				esw_attr->dests[esw_attr->out_count].mdev = out_priv->mdev;
+				esw_attr->out_count++;
+			} else if (netif_is_ovs_master(out_dev)) {
+				err = mlx5e_set_fwd_to_int_port_actions(priv, attr,
+									out_dev->ifindex,
+									MLX5E_TC_INT_PORT_EGRESS,
+									&action,
+									esw_attr->out_count);
+				if (err)
+					return err;
+
 				esw_attr->out_count++;
 			} else if (parse_attr->filter_dev != priv->netdev) {
 				/* All mlx5 devices are called to configure
@@ -4136,6 +4252,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		}
 	}
 
+	/* If we forward to internal port we can only have 1 dest */
+	if (esw_attr->dest_int_port && esw_attr->out_count > 1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Redirect to internal port should be the only destination");
+		return -EOPNOTSUPP;
+	}
+
 	/* always set IP version for indirect table handling */
 	attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 74999dcff70b..fdb222793027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -286,6 +286,12 @@ bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_
 int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev,
 			       u16 *vport);
 
+int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
+				      struct mlx5_flow_attr *attr,
+				      int ifindex,
+				      enum mlx5e_tc_int_port_type type,
+				      u32 *action,
+				      int out_index);
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 194ba8313d4d..e3729bc131c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -467,6 +467,7 @@ struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_core_dev	*in_mdev;
 	struct mlx5_core_dev    *counter_dev;
+	struct mlx5e_tc_int_port *dest_int_port;
 
 	int split_count;
 	int out_count;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94da4aca28c9..8994a2886aa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -290,8 +290,11 @@ esw_setup_chain_src_port_rewrite(struct mlx5_flow_destination *dest,
 		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
 		if (err)
 			goto err_setup_chain;
-		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		flow_act->pkt_reformat = esw_attr->dests[j].pkt_reformat;
+
+		if (esw_attr->dests[j].pkt_reformat) {
+			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			flow_act->pkt_reformat = esw_attr->dests[j].pkt_reformat;
+		}
 	}
 	return 0;
 
@@ -315,7 +318,8 @@ esw_is_indir_table(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
 	int i;
 
 	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
-		if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
+		if (esw_attr->dests[i].rep &&
+		    mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
 						esw_attr->dests[i].mdev))
 			return true;
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 879d78e46e47..d0407b369f6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -229,7 +229,8 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 
 	/* hairpin */
 	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
-		if (esw_attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
+		if (esw_attr->dests[i].rep &&
+		    esw_attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
 			return true;
 
 	return false;
-- 
2.31.1

