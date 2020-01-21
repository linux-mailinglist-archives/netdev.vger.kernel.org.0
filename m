Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE9A1441E5
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgAUQQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:16:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43527 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729353AbgAUQQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:16:57 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Jan 2020 18:16:54 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00LGGrX7008966;
        Tue, 21 Jan 2020 18:16:54 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next-mlx5 12/13] net/mlx5: E-Switch, Get reg_c1 value on miss
Date:   Tue, 21 Jan 2020 18:16:21 +0200
Message-Id: <1579623382-6934-13-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HW model implicitly decapsulates tunnels on chain 0 and sets reg_c1
with the mapped tunnel id. On miss, the packet does not have the outer
header and the driver restores the tunnel information from the tunnel id.

Getting reg_c1 value in software requires enabling reg_c1 loopback and
copying reg_c1 to reg_b. reg_b comes up on CQE as cqe->imm_inval_pkey.

Use the reg_c0 restoration rules to also copy reg_c1 to reg_B.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 31 +++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index cc446ba..1597cfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -191,6 +191,7 @@ struct mlx5_eswitch_fdb {
 struct mlx5_esw_offload {
 	struct mlx5_flow_table *ft_offloads_restore;
 	struct mlx5_flow_group *restore_group;
+	struct mlx5_modify_hdr *restore_copy_hdr_id;
 
 	struct mlx5_flow_table *ft_offloads;
 	struct mlx5_flow_group *vport_rx_group;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d6c0850..6048d8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -612,9 +612,11 @@ static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 					 esw_vport_context.fdb_to_vport_reg_c_id);
 
 	if (enable)
-		fdb_to_vport_reg_c_id |= MLX5_FDB_TO_VPORT_REG_C_0;
+		fdb_to_vport_reg_c_id |= MLX5_FDB_TO_VPORT_REG_C_0 |
+					 MLX5_FDB_TO_VPORT_REG_C_1;
 	else
-		fdb_to_vport_reg_c_id &= ~MLX5_FDB_TO_VPORT_REG_C_0;
+		fdb_to_vport_reg_c_id &= ~(MLX5_FDB_TO_VPORT_REG_C_0 |
+					   MLX5_FDB_TO_VPORT_REG_C_1);
 
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 esw_vport_context.fdb_to_vport_reg_c_id, fdb_to_vport_reg_c_id);
@@ -872,7 +874,9 @@ struct mlx5_flow_handle *
 			    misc_parameters_2);
 	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0, tag);
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	flow_act.modify_hdr = esw->offloads.restore_copy_hdr_id;
 
 	flow_context = &spec->flow_context;
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
@@ -1226,16 +1230,19 @@ static void esw_destroy_restore_table(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_offload *offloads = &esw->offloads;
 
+	mlx5_modify_header_dealloc(esw->dev, offloads->restore_copy_hdr_id);
 	mlx5_destroy_flow_group(offloads->restore_group);
 	mlx5_destroy_flow_table(offloads->ft_offloads_restore);
 }
 
 static int esw_create_restore_table(struct mlx5_eswitch *esw)
 {
+	u8 modact[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)] = {};
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *ns;
+	struct mlx5_modify_hdr *mod_hdr;
 	void *match_criteria, *misc;
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *g;
@@ -1284,11 +1291,29 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 		goto err_group;
 	}
 
+	MLX5_SET(copy_action_in, modact, action_type, MLX5_ACTION_TYPE_COPY);
+	MLX5_SET(copy_action_in, modact, src_field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_1);
+	MLX5_SET(copy_action_in, modact, dst_field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_B);
+	mod_hdr = mlx5_modify_header_alloc(esw->dev,
+					   MLX5_FLOW_NAMESPACE_KERNEL, 1,
+					   modact);
+	if (IS_ERR(mod_hdr)) {
+		esw_warn(dev, "Failed to create restore mod header, err: %d\n",
+			 err);
+		err = PTR_ERR(mod_hdr);
+		goto err_mod_hdr;
+	}
+
 	esw->offloads.ft_offloads_restore = ft;
 	esw->offloads.restore_group = g;
+	esw->offloads.restore_copy_hdr_id = mod_hdr;
 
 	return 0;
 
+err_mod_hdr:
+	mlx5_destroy_flow_group(g);
 err_group:
 	mlx5_destroy_flow_table(ft);
 out_free:
-- 
1.8.3.1

