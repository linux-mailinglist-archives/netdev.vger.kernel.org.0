Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7793182D69
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCLKXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56517 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726044AbgCLKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTZ017875;
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
Subject: [PATCH net-next ct-offload v4 01/15] net/mlx5: E-Switch, Enable reg c1 loopback when possible
Date:   Thu, 12 Mar 2020 12:23:03 +0200
Message-Id: <1584008597-15875-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable reg c1 loopback if firmware reports it's supported,
as this is needed for restoring packet metadata (e.g chain).

Also define helper to query if it is enabled.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 44 ++++++++++++++++------
 include/linux/mlx5/eswitch.h                       |  7 ++++
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9b5eaa8..ee36a8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -236,6 +236,7 @@ struct mlx5_esw_functions {
 
 enum {
 	MLX5_ESWITCH_VPORT_MATCH_METADATA = BIT(0),
+	MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED = BIT(1),
 };
 
 struct mlx5_eswitch {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 25ae38d..c79a73b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -763,14 +763,21 @@ void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule)
 	mlx5_del_flow_rules(rule);
 }
 
+static bool mlx5_eswitch_reg_c1_loopback_supported(struct mlx5_eswitch *esw)
+{
+	return MLX5_CAP_ESW_FLOWTABLE(esw->dev, fdb_to_vport_reg_c_id) &
+	       MLX5_FDB_TO_VPORT_REG_C_1;
+}
+
 static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 {
 	u32 out[MLX5_ST_SZ_DW(query_esw_vport_context_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {};
-	u8 fdb_to_vport_reg_c_id;
+	u8 curr, wanted;
 	int err;
 
-	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
+	if (!mlx5_eswitch_reg_c1_loopback_supported(esw) &&
+	    !mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return 0;
 
 	err = mlx5_eswitch_query_esw_vport_context(esw->dev, 0, false,
@@ -778,24 +785,33 @@ static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 	if (err)
 		return err;
 
-	fdb_to_vport_reg_c_id = MLX5_GET(query_esw_vport_context_out, out,
-					 esw_vport_context.fdb_to_vport_reg_c_id);
+	curr = MLX5_GET(query_esw_vport_context_out, out,
+			esw_vport_context.fdb_to_vport_reg_c_id);
+	wanted = MLX5_FDB_TO_VPORT_REG_C_0;
+	if (mlx5_eswitch_reg_c1_loopback_supported(esw))
+		wanted |= MLX5_FDB_TO_VPORT_REG_C_1;
 
 	if (enable)
-		fdb_to_vport_reg_c_id |= MLX5_FDB_TO_VPORT_REG_C_0 |
-					 MLX5_FDB_TO_VPORT_REG_C_1;
+		curr |= wanted;
 	else
-		fdb_to_vport_reg_c_id &= ~(MLX5_FDB_TO_VPORT_REG_C_0 |
-					   MLX5_FDB_TO_VPORT_REG_C_1);
+		curr &= ~wanted;
 
 	MLX5_SET(modify_esw_vport_context_in, in,
-		 esw_vport_context.fdb_to_vport_reg_c_id, fdb_to_vport_reg_c_id);
+		 esw_vport_context.fdb_to_vport_reg_c_id, curr);
 
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 field_select.fdb_to_vport_reg_c_id, 1);
 
-	return mlx5_eswitch_modify_esw_vport_context(esw->dev, 0, false,
-						     in, sizeof(in));
+	err = mlx5_eswitch_modify_esw_vport_context(esw->dev, 0, false, in,
+						    sizeof(in));
+	if (!err) {
+		if (enable && (curr & MLX5_FDB_TO_VPORT_REG_C_1))
+			esw->flags |= MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED;
+		else
+			esw->flags &= ~MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED;
+	}
+
+	return err;
 }
 
 static void peer_miss_rules_setup(struct mlx5_eswitch *esw,
@@ -2830,6 +2846,12 @@ bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
 	       vport_num <= esw->dev->priv.sriov.max_vfs;
 }
 
+bool mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw)
+{
+	return !!(esw->flags & MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED);
+}
+EXPORT_SYMBOL(mlx5_eswitch_reg_c1_loopback_enabled);
+
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw)
 {
 	return !!(esw->flags & MLX5_ESWITCH_VPORT_MATCH_METADATA);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 61705e7..c16827e 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -70,6 +70,7 @@ struct mlx5_flow_handle *
 enum devlink_eswitch_encap_mode
 mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
 
+bool mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw);
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
 
 /* Reg C0 usage:
@@ -109,6 +110,12 @@ static inline u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
 }
 
 static inline bool
+mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw)
+{
+	return false;
+};
+
+static inline bool
 mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw)
 {
 	return false;
-- 
1.8.3.1

