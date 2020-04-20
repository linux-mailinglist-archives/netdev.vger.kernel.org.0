Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81581B07B9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgDTLmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgDTLmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CED821744;
        Mon, 20 Apr 2020 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382950;
        bh=ACrYpiPRw6EWbL1fsInnUgrI89XDvrHuvSF5peK1E4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPosmaXHxUCuavKwojP/eAVQiDuID+NLr6LwAFQC2Brw3pyhtEIQSH8vrq25sA9c/
         UM0VYsWE6noRcqveQMhMPnsmYxfecKGUwmk5/gBqPZNRFRhy9yuiHdQZ78eoSCohMU
         J25EqsoO597gMP5zRtUsgTacisH9vB8lOZd2peG0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/24] net/mlx5: Update fs_core new cmd interface
Date:   Mon, 20 Apr 2020 14:41:21 +0300
Message-Id: <20200420114136.264924-10-leon@kernel.org>
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

Do mass update of fs_core to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 80 +++++++------------
 1 file changed, 31 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 90048697b2ff..304d1e4f0541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -155,8 +155,7 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 				   struct mlx5_flow_table *ft, u32 underlay_qpn,
 				   bool disconnect)
 {
-	u32 in[MLX5_ST_SZ_DW(set_flow_table_root_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(set_flow_table_root_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_flow_table_root_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
 	if ((MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_IB) &&
@@ -167,13 +166,10 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 		 MLX5_CMD_OP_SET_FLOW_TABLE_ROOT);
 	MLX5_SET(set_flow_table_root_in, in, table_type, ft->type);
 
-	if (disconnect) {
+	if (disconnect)
 		MLX5_SET(set_flow_table_root_in, in, op_mod, 1);
-		MLX5_SET(set_flow_table_root_in, in, table_id, 0);
-	} else {
-		MLX5_SET(set_flow_table_root_in, in, op_mod, 0);
+	else
 		MLX5_SET(set_flow_table_root_in, in, table_id, ft->id);
-	}
 
 	MLX5_SET(set_flow_table_root_in, in, underlay_qpn, underlay_qpn);
 	if (ft->vport) {
@@ -181,7 +177,7 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 		MLX5_SET(set_flow_table_root_in, in, other_vport, 1);
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, set_flow_table_root, in);
 }
 
 static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
@@ -192,8 +188,8 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	int en_encap = !!(ft->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
 	int en_decap = !!(ft->flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 	int term = !!(ft->flags & MLX5_FLOW_TABLE_TERMINATION);
-	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 	int err;
 
@@ -239,7 +235,7 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 		break;
 	}
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, create_flow_table, in, out);
 	if (!err)
 		ft->id = MLX5_GET(create_flow_table_out, out,
 				  table_id);
@@ -249,8 +245,7 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 static int mlx5_cmd_destroy_flow_table(struct mlx5_flow_root_namespace *ns,
 				       struct mlx5_flow_table *ft)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_flow_table_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_flow_table_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
 	MLX5_SET(destroy_flow_table_in, in, opcode,
@@ -262,15 +257,14 @@ static int mlx5_cmd_destroy_flow_table(struct mlx5_flow_root_namespace *ns,
 		MLX5_SET(destroy_flow_table_in, in, other_vport, 1);
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_flow_table, in);
 }
 
 static int mlx5_cmd_modify_flow_table(struct mlx5_flow_root_namespace *ns,
 				      struct mlx5_flow_table *ft,
 				      struct mlx5_flow_table *next_ft)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_flow_table_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(modify_flow_table_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
 	MLX5_SET(modify_flow_table_in, in, opcode,
@@ -310,7 +304,7 @@ static int mlx5_cmd_modify_flow_table(struct mlx5_flow_root_namespace *ns,
 		}
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_flow_table, in);
 }
 
 static int mlx5_cmd_create_flow_group(struct mlx5_flow_root_namespace *ns,
@@ -318,8 +312,7 @@ static int mlx5_cmd_create_flow_group(struct mlx5_flow_root_namespace *ns,
 				      u32 *in,
 				      struct mlx5_flow_group *fg)
 {
-	u32 out[MLX5_ST_SZ_DW(create_flow_group_out)] = {0};
-	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	u32 out[MLX5_ST_SZ_DW(create_flow_group_out)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 	int err;
 
@@ -332,7 +325,7 @@ static int mlx5_cmd_create_flow_group(struct mlx5_flow_root_namespace *ns,
 		MLX5_SET(create_flow_group_in, in, other_vport, 1);
 	}
 
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, create_flow_group, in, out);
 	if (!err)
 		fg->id = MLX5_GET(create_flow_group_out, out,
 				  group_id);
@@ -343,8 +336,7 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_flow_root_namespace *ns,
 				       struct mlx5_flow_table *ft,
 				       struct mlx5_flow_group *fg)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_flow_group_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_flow_group_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_flow_group_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
 	MLX5_SET(destroy_flow_group_in, in, opcode,
@@ -357,7 +349,7 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_flow_root_namespace *ns,
 		MLX5_SET(destroy_flow_group_in, in, other_vport, 1);
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_flow_group, in);
 }
 
 static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
@@ -600,8 +592,7 @@ static int mlx5_cmd_delete_fte(struct mlx5_flow_root_namespace *ns,
 			       struct mlx5_flow_table *ft,
 			       struct fs_fte *fte)
 {
-	u32 out[MLX5_ST_SZ_DW(delete_fte_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(delete_fte_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(delete_fte_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
 	MLX5_SET(delete_fte_in, in, opcode, MLX5_CMD_OP_DELETE_FLOW_TABLE_ENTRY);
@@ -613,22 +604,22 @@ static int mlx5_cmd_delete_fte(struct mlx5_flow_root_namespace *ns,
 		MLX5_SET(delete_fte_in, in, other_vport, 1);
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, delete_fte, in);
 }
 
 int mlx5_cmd_fc_bulk_alloc(struct mlx5_core_dev *dev,
 			   enum mlx5_fc_bulk_alloc_bitmask alloc_bitmask,
 			   u32 *id)
 {
-	u32 in[MLX5_ST_SZ_DW(alloc_flow_counter_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(alloc_flow_counter_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_flow_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_flow_counter_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_flow_counter_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_FLOW_COUNTER);
 	MLX5_SET(alloc_flow_counter_in, in, flow_counter_bulk, alloc_bitmask);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, alloc_flow_counter, in, out);
 	if (!err)
 		*id = MLX5_GET(alloc_flow_counter_out, out, flow_counter_id);
 	return err;
@@ -641,21 +632,20 @@ int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id)
 
 int mlx5_cmd_fc_free(struct mlx5_core_dev *dev, u32 id)
 {
-	u32 in[MLX5_ST_SZ_DW(dealloc_flow_counter_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(dealloc_flow_counter_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_flow_counter_in)] = {};
 
 	MLX5_SET(dealloc_flow_counter_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_FLOW_COUNTER);
 	MLX5_SET(dealloc_flow_counter_in, in, flow_counter_id, id);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, dealloc_flow_counter, in);
 }
 
 int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
 		      u64 *packets, u64 *bytes)
 {
 	u32 out[MLX5_ST_SZ_BYTES(query_flow_counter_out) +
-		MLX5_ST_SZ_BYTES(traffic_counter)]   = {0};
-	u32 in[MLX5_ST_SZ_DW(query_flow_counter_in)] = {0};
+		MLX5_ST_SZ_BYTES(traffic_counter)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_flow_counter_in)] = {};
 	void *stats;
 	int err = 0;
 
@@ -683,11 +673,10 @@ int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, u32 base_id, int bulk_len,
 			   u32 *out)
 {
 	int outlen = mlx5_cmd_fc_get_bulk_query_out_len(bulk_len);
-	u32 in[MLX5_ST_SZ_DW(query_flow_counter_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_flow_counter_in)] = {};
 
 	MLX5_SET(query_flow_counter_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_FLOW_COUNTER);
-	MLX5_SET(query_flow_counter_in, in, op_mod, 0);
 	MLX5_SET(query_flow_counter_in, in, flow_counter_id, base_id);
 	MLX5_SET(query_flow_counter_in, in, num_of_counters, bulk_len);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
@@ -700,7 +689,7 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 					  enum mlx5_flow_namespace_type namespace,
 					  struct mlx5_pkt_reformat *pkt_reformat)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)];
+	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 	void *packet_reformat_context_in;
 	int max_encap_size;
@@ -732,7 +721,6 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 				reformat_data);
 	inlen = reformat - (void *)in  + size;
 
-	memset(in, 0, inlen);
 	MLX5_SET(alloc_packet_reformat_context_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT);
 	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
@@ -741,7 +729,6 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 		 reformat_type, reformat_type);
 	memcpy(reformat, reformat_data, size);
 
-	memset(out, 0, sizeof(out));
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 
 	pkt_reformat->id = MLX5_GET(alloc_packet_reformat_context_out,
@@ -753,17 +740,15 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 static void mlx5_cmd_packet_reformat_dealloc(struct mlx5_flow_root_namespace *ns,
 					     struct mlx5_pkt_reformat *pkt_reformat)
 {
-	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)];
-	u32 out[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_out)];
+	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
-	memset(in, 0, sizeof(in));
 	MLX5_SET(dealloc_packet_reformat_context_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT);
 	MLX5_SET(dealloc_packet_reformat_context_in, in, packet_reformat_id,
 		 pkt_reformat->id);
 
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, dealloc_packet_reformat_context, in);
 }
 
 static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
@@ -771,7 +756,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 					void *modify_actions,
 					struct mlx5_modify_hdr *modify_hdr)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_modify_header_context_out)];
+	u32 out[MLX5_ST_SZ_DW(alloc_modify_header_context_out)] = {};
 	int max_actions, actions_size, inlen, err;
 	struct mlx5_core_dev *dev = ns->dev;
 	void *actions_in;
@@ -821,7 +806,6 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	actions_in = MLX5_ADDR_OF(alloc_modify_header_context_in, in, actions);
 	memcpy(actions_in, modify_actions, actions_size);
 
-	memset(out, 0, sizeof(out));
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 
 	modify_hdr->id = MLX5_GET(alloc_modify_header_context_out, out, modify_header_id);
@@ -832,17 +816,15 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 static void mlx5_cmd_modify_header_dealloc(struct mlx5_flow_root_namespace *ns,
 					   struct mlx5_modify_hdr *modify_hdr)
 {
-	u32 in[MLX5_ST_SZ_DW(dealloc_modify_header_context_in)];
-	u32 out[MLX5_ST_SZ_DW(dealloc_modify_header_context_out)];
+	u32 in[MLX5_ST_SZ_DW(dealloc_modify_header_context_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
 
-	memset(in, 0, sizeof(in));
 	MLX5_SET(dealloc_modify_header_context_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT);
 	MLX5_SET(dealloc_modify_header_context_in, in, modify_header_id,
 		 modify_hdr->id);
 
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev, dealloc_modify_header_context, in);
 }
 
 static const struct mlx5_flow_cmds mlx5_flow_cmds = {
-- 
2.25.2

