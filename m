Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584B41B07A8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDTLmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA6E3214AF;
        Mon, 20 Apr 2020 11:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382924;
        bh=Voi5iiCMf9eOOdSipQ5KnossJauQRDVT1ik8l8J4O3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKqV8jm4ffnxlJZuxOhWMUfq/lcR1kq+sx0t0NEvyHv73Ld7TLTxVM5npUSnPXrZU
         SDGDk+ISF/zywVqOepIUzCoVANibEGA365WQBFD/qNt1XjLJ9n3Gh0s3o56tl2g8m2
         iH5S48yJTU3FJORZSYtV8kGXRIqiBSU1PlNeJ4nA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/24] net/mlx5: Update eswitch to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:19 +0300
Message-Id: <20200420114136.264924-8-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of eswitch to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 38 +++++--------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 18 ++++-----
 3 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7f618a443bfd..c5eb4e7754a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -84,8 +84,7 @@ mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
 					u32 events_mask)
 {
-	int in[MLX5_ST_SZ_DW(modify_nic_vport_context_in)]   = {0};
-	int out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_nic_vport_context_in)] = {};
 	void *nic_vport_ctx;
 
 	MLX5_SET(modify_nic_vport_context_in, in,
@@ -108,40 +107,24 @@ static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
 		MLX5_SET(nic_vport_context, nic_vport_ctx,
 			 event_on_promisc_change, 1);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_nic_vport_context, in);
 }
 
 /* E-Switch vport context HW commands */
 int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
-					  bool other_vport,
-					  void *in, int inlen)
+					  bool other_vport, void *in)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_esw_vport_context_out)] = {0};
-
 	MLX5_SET(modify_esw_vport_context_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_ESW_VPORT_CONTEXT);
 	MLX5_SET(modify_esw_vport_context_in, in, vport_number, vport);
 	MLX5_SET(modify_esw_vport_context_in, in, other_vport, other_vport);
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
-}
-
-int mlx5_eswitch_query_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
-					 bool other_vport,
-					 void *out, int outlen)
-{
-	u32 in[MLX5_ST_SZ_DW(query_esw_vport_context_in)] = {};
-
-	MLX5_SET(query_esw_vport_context_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT);
-	MLX5_SET(modify_esw_vport_context_in, in, vport_number, vport);
-	MLX5_SET(modify_esw_vport_context_in, in, other_vport, other_vport);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec_in(dev, modify_esw_vport_context, in);
 }
 
 static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 				  u16 vlan, u8 qos, u8 set_flags)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {};
 
 	if (!MLX5_CAP_ESW(dev, vport_cvlan_strip) ||
 	    !MLX5_CAP_ESW(dev, vport_cvlan_insert_if_not_exist))
@@ -170,8 +153,7 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 field_select.vport_cvlan_insert, 1);
 
-	return mlx5_eswitch_modify_esw_vport_context(dev, vport, true,
-						     in, sizeof(in));
+	return mlx5_eswitch_modify_esw_vport_context(dev, vport, true, in);
 }
 
 /* E-Switch FDB */
@@ -1901,7 +1883,7 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	MLX5_SET(query_esw_functions_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_FUNCTIONS);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	err = mlx5_cmd_exec_inout(dev, query_esw_functions, in, out);
 	if (!err)
 		return out;
 
@@ -2783,8 +2765,8 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 {
 	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
 	int outlen = MLX5_ST_SZ_BYTES(query_vport_counter_out);
-	u32 in[MLX5_ST_SZ_DW(query_vport_counter_in)] = {0};
-	struct mlx5_vport_drop_stats stats = {0};
+	u32 in[MLX5_ST_SZ_DW(query_vport_counter_in)] = {};
+	struct mlx5_vport_drop_stats stats = {};
 	int err = 0;
 	u32 *out;
 
@@ -2801,7 +2783,7 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 	MLX5_SET(query_vport_counter_in, in, vport_number, vport->vport);
 	MLX5_SET(query_vport_counter_in, in, other_vport, 1);
 
-	err = mlx5_cmd_exec(esw->dev, in, sizeof(in), out, outlen);
+	err = mlx5_cmd_exec_inout(esw->dev, query_vport_counter, in, out);
 	if (err)
 		goto free_out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 39f42f985fbd..fa2ad172f08c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -329,11 +329,7 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule);
 
 int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
-					  bool other_vport,
-					  void *in, int inlen);
-int mlx5_eswitch_query_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
-					 bool other_vport,
-					 void *out, int outlen);
+					  bool other_vport, void *in);
 
 struct mlx5_flow_spec;
 struct mlx5_esw_flow_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f171eb2234b0..dc098bb58973 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -790,7 +790,8 @@ static bool mlx5_eswitch_reg_c1_loopback_supported(struct mlx5_eswitch *esw)
 static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 {
 	u32 out[MLX5_ST_SZ_DW(query_esw_vport_context_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {};
+	u32 min[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_esw_vport_context_in)] = {};
 	u8 curr, wanted;
 	int err;
 
@@ -798,8 +799,9 @@ static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 	    !mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return 0;
 
-	err = mlx5_eswitch_query_esw_vport_context(esw->dev, 0, false,
-						   out, sizeof(out));
+	MLX5_SET(query_esw_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT);
+	err = mlx5_cmd_exec_inout(esw->dev, query_esw_vport_context, in, out);
 	if (err)
 		return err;
 
@@ -814,14 +816,12 @@ static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool enable)
 	else
 		curr &= ~wanted;
 
-	MLX5_SET(modify_esw_vport_context_in, in,
+	MLX5_SET(modify_esw_vport_context_in, min,
 		 esw_vport_context.fdb_to_vport_reg_c_id, curr);
-
-	MLX5_SET(modify_esw_vport_context_in, in,
+	MLX5_SET(modify_esw_vport_context_in, min,
 		 field_select.fdb_to_vport_reg_c_id, 1);
 
-	err = mlx5_eswitch_modify_esw_vport_context(esw->dev, 0, false, in,
-						    sizeof(in));
+	err = mlx5_eswitch_modify_esw_vport_context(esw->dev, 0, false, min);
 	if (!err) {
 		if (enable && (curr & MLX5_FDB_TO_VPORT_REG_C_1))
 			esw->flags |= MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED;
@@ -1474,7 +1474,7 @@ static int mlx5_eswitch_inline_mode_get(const struct mlx5_eswitch *esw, u8 *mode
 out:
 	*mode = mlx5_mode;
 	return 0;
-}       
+}
 
 static void esw_destroy_restore_table(struct mlx5_eswitch *esw)
 {
-- 
2.25.2

