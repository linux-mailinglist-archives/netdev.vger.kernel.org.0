Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00D91B07D5
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDTLnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgDTLnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:43:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF8521473;
        Mon, 20 Apr 2020 11:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382983;
        bh=CSrkXBXDw3rmeAAqfYXSoB5CaYWJoYPOhyvaTmaTDNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9KREZCEf6dVeM0Uzmf/UJ6hHap44pveJSgxvtQPEFOt0mH7UtdS0YKFmUinCsuEO
         eo1uGWk/BSJI1vpDOEuzLyvsbHMANySi22aTwFY4nJCTegEfq4umFQ62V/ktxtZkqN
         L+HjzuG7+pxfCoJ9c07gH2Ak37Y1FrXB+AKGnDRo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 23/24] net/mlx5: Update SW steering new cmd interface
Date:   Mon, 20 Apr 2020 14:41:35 +0300
Message-Id: <20200420114136.264924-24-leon@kernel.org>
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

Do mass update of SW steering to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 33 ++++++++-----------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 461b39376daf..6bd34b293007 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -18,7 +18,7 @@ int mlx5dr_cmd_query_esw_vport_context(struct mlx5_core_dev *mdev,
 	MLX5_SET(query_esw_vport_context_in, in, other_vport, other_vport);
 	MLX5_SET(query_esw_vport_context_in, in, vport_number, vport_number);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, query_esw_vport_context, in, out);
 	if (err)
 		return err;
 
@@ -51,7 +51,7 @@ int mlx5dr_cmd_query_gvmi(struct mlx5_core_dev *mdev, bool other_vport,
 		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1 |
 		 HCA_CAP_OPMOD_GET_CUR);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, out_size);
+	err = mlx5_cmd_exec_inout(mdev, query_hca_cap, in, out);
 	if (err) {
 		kfree(out);
 		return err;
@@ -141,7 +141,7 @@ int mlx5dr_cmd_query_flow_table(struct mlx5_core_dev *dev,
 	MLX5_SET(query_flow_table_in, in, table_type, type);
 	MLX5_SET(query_flow_table_in, in, table_id, table_id);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, query_flow_table, in, out);
 	if (err)
 		return err;
 
@@ -158,12 +158,11 @@ int mlx5dr_cmd_query_flow_table(struct mlx5_core_dev *dev,
 
 int mlx5dr_cmd_sync_steering(struct mlx5_core_dev *mdev)
 {
-	u32 out[MLX5_ST_SZ_DW(sync_steering_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(sync_steering_in)] = {};
 
 	MLX5_SET(sync_steering_in, in, opcode, MLX5_CMD_OP_SYNC_STEERING);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, sync_steering, in);
 }
 
 int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
@@ -214,14 +213,13 @@ int mlx5dr_cmd_del_flow_table_entry(struct mlx5_core_dev *mdev,
 				    u32 table_type,
 				    u32 table_id)
 {
-	u32 out[MLX5_ST_SZ_DW(delete_fte_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(delete_fte_in)] = {};
 
 	MLX5_SET(delete_fte_in, in, opcode, MLX5_CMD_OP_DELETE_FLOW_TABLE_ENTRY);
 	MLX5_SET(delete_fte_in, in, table_type, table_type);
 	MLX5_SET(delete_fte_in, in, table_id, table_id);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, delete_fte, in);
 }
 
 int mlx5dr_cmd_alloc_modify_header(struct mlx5_core_dev *mdev,
@@ -263,7 +261,6 @@ int mlx5dr_cmd_alloc_modify_header(struct mlx5_core_dev *mdev,
 int mlx5dr_cmd_dealloc_modify_header(struct mlx5_core_dev *mdev,
 				     u32 modify_header_id)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_modify_header_context_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(dealloc_modify_header_context_in)] = {};
 
 	MLX5_SET(dealloc_modify_header_context_in, in, opcode,
@@ -271,7 +268,7 @@ int mlx5dr_cmd_dealloc_modify_header(struct mlx5_core_dev *mdev,
 	MLX5_SET(dealloc_modify_header_context_in, in, modify_header_id,
 		 modify_header_id);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, dealloc_modify_header_context, in);
 }
 
 int mlx5dr_cmd_create_empty_flow_group(struct mlx5_core_dev *mdev,
@@ -292,7 +289,7 @@ int mlx5dr_cmd_create_empty_flow_group(struct mlx5_core_dev *mdev,
 	MLX5_SET(create_flow_group_in, in, table_type, table_type);
 	MLX5_SET(create_flow_group_in, in, table_id, table_id);
 
-	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, create_flow_group, in, out);
 	if (err)
 		goto out;
 
@@ -309,14 +306,14 @@ int mlx5dr_cmd_destroy_flow_group(struct mlx5_core_dev *mdev,
 				  u32 group_id)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_flow_group_in)] = {};
-	u32 out[MLX5_ST_SZ_DW(destroy_flow_group_out)] = {};
 
-	MLX5_SET(create_flow_group_in, in, opcode, MLX5_CMD_OP_DESTROY_FLOW_GROUP);
+	MLX5_SET(destroy_flow_group_in, in, opcode,
+		 MLX5_CMD_OP_DESTROY_FLOW_GROUP);
 	MLX5_SET(destroy_flow_group_in, in, table_type, table_type);
 	MLX5_SET(destroy_flow_group_in, in, table_id, table_id);
 	MLX5_SET(destroy_flow_group_in, in, group_id, group_id);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, destroy_flow_group, in);
 }
 
 int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
@@ -360,7 +357,7 @@ int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
 	MLX5_SET(create_flow_table_in, in, flow_table_context.reformat_en,
 		 attr->reformat_en);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, create_flow_table, in, out);
 	if (err)
 		return err;
 
@@ -379,7 +376,6 @@ int mlx5dr_cmd_destroy_flow_table(struct mlx5_core_dev *mdev,
 				  u32 table_id,
 				  u32 table_type)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_flow_table_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(destroy_flow_table_in)] = {};
 
 	MLX5_SET(destroy_flow_table_in, in, opcode,
@@ -387,7 +383,7 @@ int mlx5dr_cmd_destroy_flow_table(struct mlx5_core_dev *mdev,
 	MLX5_SET(destroy_flow_table_in, in, table_type, table_type);
 	MLX5_SET(destroy_flow_table_in, in, table_id, table_id);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, destroy_flow_table, in);
 }
 
 int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
@@ -434,7 +430,6 @@ int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 void mlx5dr_cmd_destroy_reformat_ctx(struct mlx5_core_dev *mdev,
 				     u32 reformat_id)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)] = {};
 
 	MLX5_SET(dealloc_packet_reformat_context_in, in, opcode,
@@ -442,7 +437,7 @@ void mlx5dr_cmd_destroy_reformat_ctx(struct mlx5_core_dev *mdev,
 	MLX5_SET(dealloc_packet_reformat_context_in, in, packet_reformat_id,
 		 reformat_id);
 
-	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(mdev, dealloc_packet_reformat_context, in);
 }
 
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
@@ -458,7 +453,7 @@ int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 	MLX5_SET(query_roce_address_in, in, roce_address_index, index);
 	MLX5_SET(query_roce_address_in, in, vhca_port_num, vhca_port_num);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, query_roce_address, in, out);
 	if (err)
 		return err;
 
-- 
2.25.2

