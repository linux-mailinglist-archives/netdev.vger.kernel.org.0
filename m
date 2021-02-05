Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E15310513
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhBEGpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhBEGot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC58A64F9C;
        Fri,  5 Feb 2021 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507448;
        bh=hFwYaL4zBe50LhWECDl7AJrKWCucuzYS1FRoJ8M1fMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNNl13cTLEhx5WmXp8YXxdFzcciTEeoX9FtX+rmiEN6tNzuCPIQjcYgPNUA5xksYh
         vht+1XxZqDbzdkr/2Mx3YukCndCJDl9ipVuX/OOvQheIgANIc5IojxFXfmjkeOzFb3
         yZEMbtGEz1Tv7UXCrOQAaHgNeo3L7mYd3uvVRjNf3L+PJGILve0BogS9T4CGTzJibu
         kX7mEIWb4dUmnmYwXbzvrjJWAuMlJ8XiEhlR0mAVOvGVau8i4RFulZf9WICBB+r7Sk
         65S4BrZVP7ImvnUa0u3uVcQhqUdR/TrBVuP/qs75UXut8EB+2Ab3YGcc/AHQ1OEwSo
         ORqrjkw8bofLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/17] net/mlx5: E-Switch, Refactor rule offload forward action processing
Date:   Thu,  4 Feb 2021 22:40:38 -0800
Message-Id: <20210205064051.89592-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in the series extend forwarding functionality with VF
tunnel TX and RX handling. Extract action forwarding processing code into
dedicated functions to simplify further extensions:

- Handle every forwarding case with dedicated function instead of inline
code.

- Extract forwarding dest dispatch conditional into helper function
esw_setup_dests().

- Unify forwaring cleanup code in error path of
mlx5_eswitch_add_offloaded_rule() and in rule deletion code of
__mlx5_eswitch_del_rule() in new helper function esw_cleanup_dests() (dual
to new esw_setup_dests() helper).

This patch does not change functionality.

Co-developed-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 189 ++++++++++++------
 1 file changed, 129 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3085bdd14fbb..335dc83d1bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -296,6 +296,124 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 	}
 }
 
+static void
+esw_setup_ft_dest(struct mlx5_flow_destination *dest,
+		  struct mlx5_flow_act *flow_act,
+		  struct mlx5_flow_attr *attr,
+		  int i)
+{
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[i].ft = attr->dest_ft;
+}
+
+static void
+esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
+			 struct mlx5_flow_act *flow_act,
+			 struct mlx5_fs_chains *chains,
+			 int i)
+{
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
+}
+
+static int
+esw_setup_chain_dest(struct mlx5_flow_destination *dest,
+		     struct mlx5_flow_act *flow_act,
+		     struct mlx5_fs_chains *chains,
+		     u32 chain, u32 prio, u32 level,
+		     int i)
+{
+	struct mlx5_flow_table *ft;
+
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	ft = mlx5_chains_get_table(chains, chain, prio, level);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[i].ft = ft;
+	return  0;
+}
+
+static void
+esw_cleanup_chain_dest(struct mlx5_fs_chains *chains, u32 chain, u32 prio, u32 level)
+{
+	mlx5_chains_put_table(chains, chain, prio, level);
+}
+
+static void
+esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+		     struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *esw_attr,
+		     int attr_idx, int dest_idx, bool pkt_reformat)
+{
+	dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
+	dest[dest_idx].vport.num = esw_attr->dests[attr_idx].rep->vport;
+	dest[dest_idx].vport.vhca_id =
+		MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
+		if (pkt_reformat) {
+			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			flow_act->pkt_reformat = esw_attr->dests[attr_idx].pkt_reformat;
+		}
+		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
+		dest[dest_idx].vport.pkt_reformat = esw_attr->dests[attr_idx].pkt_reformat;
+	}
+}
+
+static int
+esw_setup_vport_dests(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+		      struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *esw_attr,
+		      int i)
+{
+	int j;
+
+	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, i++)
+		esw_setup_vport_dest(dest, flow_act, esw, esw_attr, j, i, true);
+	return i;
+}
+
+static int
+esw_setup_dests(struct mlx5_flow_destination *dest,
+		struct mlx5_flow_act *flow_act,
+		struct mlx5_eswitch *esw,
+		struct mlx5_flow_attr *attr,
+		int *i)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_fs_chains *chains = esw_chains(esw);
+	int err = 0;
+
+	if (attr->dest_ft) {
+		esw_setup_ft_dest(dest, flow_act, attr, *i);
+		(*i)++;
+	} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
+		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
+		(*i)++;
+	} else if (attr->dest_chain) {
+		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
+					   1, 0, *i);
+		(*i)++;
+	} else {
+		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
+	}
+
+	return err;
+}
+
+static void
+esw_cleanup_dests(struct mlx5_eswitch *esw,
+		  struct mlx5_flow_attr *attr)
+{
+	struct mlx5_fs_chains *chains = esw_chains(esw);
+
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
+		esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
+}
+
 struct mlx5_flow_handle *
 mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
@@ -309,7 +427,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	struct mlx5_vport_tbl_attr fwd_attr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
-	int j, i = 0;
+	int i = 0;
 
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -331,49 +449,12 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	}
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-		struct mlx5_flow_table *ft;
-
-		if (attr->dest_ft) {
-			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
-			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[i].ft = attr->dest_ft;
-			i++;
-		} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
-			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
-			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
-			i++;
-		} else if (attr->dest_chain) {
-			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
-			ft = mlx5_chains_get_table(chains, attr->dest_chain,
-						   1, 0);
-			if (IS_ERR(ft)) {
-				rule = ERR_CAST(ft);
-				goto err_create_goto_table;
-			}
-
-			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[i].ft = ft;
-			i++;
-		} else {
-			for (j = esw_attr->split_count; j < esw_attr->out_count; j++) {
-				dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-				dest[i].vport.num = esw_attr->dests[j].rep->vport;
-				dest[i].vport.vhca_id =
-					MLX5_CAP_GEN(esw_attr->dests[j].mdev, vhca_id);
-				if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
-					dest[i].vport.flags |=
-						MLX5_FLOW_DEST_VPORT_VHCA_ID;
-				if (esw_attr->dests[j].flags & MLX5_ESW_DEST_ENCAP) {
-					flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-					flow_act.pkt_reformat =
-							esw_attr->dests[j].pkt_reformat;
-					dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
-					dest[i].vport.pkt_reformat =
-						esw_attr->dests[j].pkt_reformat;
-				}
-				i++;
-			}
+		int err;
+
+		err = esw_setup_dests(dest, &flow_act, esw, attr, &i);
+		if (err) {
+			rule = ERR_PTR(err);
+			goto err_create_goto_table;
 		}
 	}
 
@@ -437,8 +518,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	else if (attr->chain || attr->prio)
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
 err_esw_get:
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
-		mlx5_chains_put_table(chains, attr->dest_chain, 1, 0);
+	esw_cleanup_dests(esw, attr);
 err_create_goto_table:
 	return rule;
 }
@@ -474,18 +554,8 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	for (i = 0; i < esw_attr->split_count; i++) {
-		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-		dest[i].vport.num = esw_attr->dests[i].rep->vport;
-		dest[i].vport.vhca_id =
-			MLX5_CAP_GEN(esw_attr->dests[i].mdev, vhca_id);
-		if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
-			dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
-		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP) {
-			dest[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
-			dest[i].vport.pkt_reformat = esw_attr->dests[i].pkt_reformat;
-		}
-	}
+	for (i = 0; i < esw_attr->split_count; i++)
+		esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = fwd_fdb;
 	i++;
@@ -552,8 +622,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 			esw_vport_tbl_put(esw, &fwd_attr);
 		else if (attr->chain || attr->prio)
 			mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
-		if (attr->dest_chain)
-			mlx5_chains_put_table(chains, attr->dest_chain, 1, 0);
+		esw_cleanup_dests(esw, attr);
 	}
 }
 
-- 
2.29.2

