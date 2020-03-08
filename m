Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8025417D413
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgCHOLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 10:11:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38837 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726373AbgCHOLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 10:11:08 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Mar 2020 16:11:03 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 028EB3D0032146;
        Sun, 8 Mar 2020 16:11:03 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v2 06/13] net/mlx5: E-Switch, Introduce global tables
Date:   Sun,  8 Mar 2020 16:10:55 +0200
Message-Id: <1583676662-15180-7-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, flow tables are automatically connected according to their
<chain,prio,level> tuple.

Introduce global tables which are flow tables that are detached from the
eswitch chains processing, and will be connected by explicitly referencing
them from multiple chains.

Add this new table type, and allow connecting them by refenece.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 23 ++++++++++++-----
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   | 30 ++++++++++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |  6 +++++
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e7dd2ca..3f644c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -409,6 +409,8 @@ struct mlx5_esw_flow_attr {
 	u16	prio;
 	u32	dest_chain;
 	u32	flags;
+	struct mlx5_flow_table *fdb;
+	struct mlx5_flow_table *dest_ft;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e4bd53e..a867d7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -149,7 +149,12 @@ struct mlx5_flow_handle *
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		struct mlx5_flow_table *ft;
 
-		if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
+		if (attr->dest_ft) {
+			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+			dest[i].ft = attr->dest_ft;
+			i++;
+		} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 			dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 			dest[i].ft = mlx5_esw_chains_get_tc_end_ft(esw);
@@ -202,8 +207,11 @@ struct mlx5_flow_handle *
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
-	fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
-					!!split);
+	if (attr->chain || attr->prio)
+		fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
+						!!split);
+	else
+		fdb = attr->fdb;
 	if (IS_ERR(fdb)) {
 		rule = ERR_CAST(fdb);
 		goto err_esw_get;
@@ -222,7 +230,9 @@ struct mlx5_flow_handle *
 	return rule;
 
 err_add_rule:
-	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, !!split);
+	if (attr->chain || attr->prio)
+		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
+					  !!split);
 err_esw_get:
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
 		mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
@@ -316,8 +326,9 @@ struct mlx5_flow_handle *
 		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 1);
 		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 	} else {
-		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
-					  !!split);
+		if (attr->chain || attr->prio)
+			mlx5_esw_chains_put_table(esw, attr->chain,
+						  attr->prio, !!split);
 		if (attr->dest_chain)
 			mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index b139a97..bba0cec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -716,6 +716,36 @@ struct mlx5_flow_table *
 	return tc_end_fdb(esw);
 }
 
+struct mlx5_flow_table *
+mlx5_esw_chains_create_global_table(struct mlx5_eswitch *esw)
+{
+	int chain, prio, level, err;
+
+	if (!fdb_ignore_flow_level_supported(esw)) {
+		err = -EOPNOTSUPP;
+
+		esw_warn(esw->dev,
+			 "Couldn't create global flow table, ignore_flow_level not supported.");
+		goto err_ignore;
+	}
+
+	chain = mlx5_esw_chains_get_chain_range(esw),
+	prio = mlx5_esw_chains_get_prio_range(esw);
+	level = mlx5_esw_chains_get_level_range(esw);
+
+	return mlx5_esw_chains_create_fdb_table(esw, chain, prio, level);
+
+err_ignore:
+	return ERR_PTR(err);
+}
+
+void
+mlx5_esw_chains_destroy_global_table(struct mlx5_eswitch *esw,
+				     struct mlx5_flow_table *ft)
+{
+	mlx5_esw_chains_destroy_fdb_table(esw, ft);
+}
+
 static int
 mlx5_esw_chains_init(struct mlx5_eswitch *esw)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
index da45e49..01cbdf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -23,6 +23,12 @@ struct mlx5_flow_table *
 struct mlx5_flow_table *
 mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw);
 
+struct mlx5_flow_table *
+mlx5_esw_chains_create_global_table(struct mlx5_eswitch *esw);
+void
+mlx5_esw_chains_destroy_global_table(struct mlx5_eswitch *esw,
+				     struct mlx5_flow_table *ft);
+
 int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
 void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
 
-- 
1.8.3.1

