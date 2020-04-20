Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE61B07AC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgDTLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgDTLmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83FEE21473;
        Mon, 20 Apr 2020 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382928;
        bh=KTb3FIZp9j5rkzwh05NHO4sADlw2bnfYKmWaS676ZVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaYoVmY0LxnfNGCPOjVVHN9oEyGFK1M5u1B7U7499AQ8exUEpoAm82cZdttaoIO8I
         hWKm64J/KrWMZ7fQtKmLqvgVVgMyG0oFnzDovNX3URhVIkyCzWWgpS/ScB1XZXqB8V
         Qfgnw6wH+RTvNtzoem8jTHKWjp0qJ0WY4MBgFVbc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/24] net/mlx5: Update FPGA to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:20 +0300
Message-Id: <20200420114136.264924-9-leon@kernel.org>
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

Do mass update of FPGA to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/cmd.c    | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
index 09769401c313..9a37077152aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
@@ -142,15 +142,15 @@ int mlx5_fpga_query(struct mlx5_core_dev *dev, struct mlx5_fpga_query *query)
 int mlx5_fpga_create_qp(struct mlx5_core_dev *dev, void *fpga_qpc,
 			u32 *fpga_qpn)
 {
-	u32 in[MLX5_ST_SZ_DW(fpga_create_qp_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(fpga_create_qp_out)];
+	u32 out[MLX5_ST_SZ_DW(fpga_create_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(fpga_create_qp_in)] = {};
 	int ret;
 
 	MLX5_SET(fpga_create_qp_in, in, opcode, MLX5_CMD_OP_FPGA_CREATE_QP);
 	memcpy(MLX5_ADDR_OF(fpga_create_qp_in, in, fpga_qpc), fpga_qpc,
 	       MLX5_FLD_SZ_BYTES(fpga_create_qp_in, fpga_qpc));
 
-	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	ret = mlx5_cmd_exec_inout(dev, fpga_create_qp, in, out);
 	if (ret)
 		return ret;
 
@@ -164,8 +164,7 @@ int mlx5_fpga_modify_qp(struct mlx5_core_dev *dev, u32 fpga_qpn,
 			enum mlx5_fpga_qpc_field_select fields,
 			void *fpga_qpc)
 {
-	u32 in[MLX5_ST_SZ_DW(fpga_modify_qp_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(fpga_modify_qp_out)];
+	u32 in[MLX5_ST_SZ_DW(fpga_modify_qp_in)] = {};
 
 	MLX5_SET(fpga_modify_qp_in, in, opcode, MLX5_CMD_OP_FPGA_MODIFY_QP);
 	MLX5_SET(fpga_modify_qp_in, in, field_select, fields);
@@ -173,20 +172,20 @@ int mlx5_fpga_modify_qp(struct mlx5_core_dev *dev, u32 fpga_qpn,
 	memcpy(MLX5_ADDR_OF(fpga_modify_qp_in, in, fpga_qpc), fpga_qpc,
 	       MLX5_FLD_SZ_BYTES(fpga_modify_qp_in, fpga_qpc));
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, fpga_modify_qp, in);
 }
 
 int mlx5_fpga_query_qp(struct mlx5_core_dev *dev,
 		       u32 fpga_qpn, void *fpga_qpc)
 {
-	u32 in[MLX5_ST_SZ_DW(fpga_query_qp_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(fpga_query_qp_out)];
+	u32 out[MLX5_ST_SZ_DW(fpga_query_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(fpga_query_qp_in)] = {};
 	int ret;
 
 	MLX5_SET(fpga_query_qp_in, in, opcode, MLX5_CMD_OP_FPGA_QUERY_QP);
 	MLX5_SET(fpga_query_qp_in, in, fpga_qpn, fpga_qpn);
 
-	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	ret = mlx5_cmd_exec_inout(dev, fpga_query_qp, in, out);
 	if (ret)
 		return ret;
 
@@ -197,20 +196,19 @@ int mlx5_fpga_query_qp(struct mlx5_core_dev *dev,
 
 int mlx5_fpga_destroy_qp(struct mlx5_core_dev *dev, u32 fpga_qpn)
 {
-	u32 in[MLX5_ST_SZ_DW(fpga_destroy_qp_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(fpga_destroy_qp_out)];
+	u32 in[MLX5_ST_SZ_DW(fpga_destroy_qp_in)] = {};
 
 	MLX5_SET(fpga_destroy_qp_in, in, opcode, MLX5_CMD_OP_FPGA_DESTROY_QP);
 	MLX5_SET(fpga_destroy_qp_in, in, fpga_qpn, fpga_qpn);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, fpga_destroy_qp, in);
 }
 
 int mlx5_fpga_query_qp_counters(struct mlx5_core_dev *dev, u32 fpga_qpn,
 				bool clear, struct mlx5_fpga_qp_counters *data)
 {
-	u32 in[MLX5_ST_SZ_DW(fpga_query_qp_counters_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(fpga_query_qp_counters_out)];
+	u32 out[MLX5_ST_SZ_DW(fpga_query_qp_counters_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(fpga_query_qp_counters_in)] = {};
 	int ret;
 
 	MLX5_SET(fpga_query_qp_counters_in, in, opcode,
@@ -218,7 +216,7 @@ int mlx5_fpga_query_qp_counters(struct mlx5_core_dev *dev, u32 fpga_qpn,
 	MLX5_SET(fpga_query_qp_counters_in, in, clear, clear);
 	MLX5_SET(fpga_query_qp_counters_in, in, fpga_qpn, fpga_qpn);
 
-	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	ret = mlx5_cmd_exec_inout(dev, fpga_query_qp_counters, in, out);
 	if (ret)
 		return ret;
 
-- 
2.25.2

