Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64F2182D6B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCLKX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56553 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726856AbgCLKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:29 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTg017875;
        Thu, 12 Mar 2020 12:23:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 08/15] net/mlx5: E-Switch, Introduce global tables
Date:   Thu, 12 Mar 2020 12:23:10 +0200
Message-Id: <1584008597-15875-9-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
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
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +++++++++----
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   | 30 ++++++++++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |  6 +++++
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ee36a8a..dae0f3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -421,6 +421,8 @@ struct mlx5_esw_flow_attr {
 	u16	prio;
 	u32	dest_chain;
 	u32	flags;
+	struct mlx5_flow_table *fdb;
+	struct mlx5_flow_table *dest_ft;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c79a73b..8bfab5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -324,7 +324,12 @@ struct mlx5_flow_handle *
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
@@ -378,8 +383,11 @@ struct mlx5_flow_handle *
 	if (split) {
 		fdb = esw_vport_tbl_get(esw, attr);
 	} else {
-		fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
-						0);
+		if (attr->chain || attr->prio)
+			fdb = mlx5_esw_chains_get_table(esw, attr->chain,
+							attr->prio, 0);
+		else
+			fdb = attr->fdb;
 		mlx5_eswitch_set_rule_source_port(esw, spec, attr);
 	}
 	if (IS_ERR(fdb)) {
@@ -402,7 +410,7 @@ struct mlx5_flow_handle *
 err_add_rule:
 	if (split)
 		esw_vport_tbl_put(esw, attr);
-	else
+	else if (attr->chain || attr->prio)
 		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 err_esw_get:
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
@@ -499,7 +507,7 @@ struct mlx5_flow_handle *
 	} else {
 		if (split)
 			esw_vport_tbl_put(esw, attr);
-		else
+		else if (attr->chain || attr->prio)
 			mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
 						  0);
 		if (attr->dest_chain)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index ca3bbf8..84e3313 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -722,6 +722,36 @@ struct mlx5_flow_table *
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
index e806d8d..c7bc609 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -25,6 +25,12 @@ struct mlx5_flow_table *
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

