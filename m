Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05801B07B1
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgDTLmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgDTLmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C411821744;
        Mon, 20 Apr 2020 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382935;
        bh=yW21zHyC4FxBAVT11hLjRdiV99O05VRYoUjCrp5Lyto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkBOV6CtNstpAeV389M7Sw8vQ5wxNm9AsayQmtGFVir51m8jiWW9mJZHQ+PPNlGjb
         U7vwlw2KSS+lkEq0Jmj5+DLI1Zkn30+5mhk1FRSbB5ChJYyjnU+1YlJf0uPUZzF8Xb
         I2VNJvi2V7jO5V8nc0ZHYmBM6bN98Hz2OQvRMwYQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/24] net/mlx5: Update fw.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:22 +0300
Message-Id: <20200420114136.264924-11-leon@kernel.org>
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

Do mass update of fw.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 33 ++++++++------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 3040e0466681..a5fbe7343508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -67,26 +67,19 @@ enum {
 	MCQI_FW_STORED_VERSION  = 1,
 };
 
-static int mlx5_cmd_query_adapter(struct mlx5_core_dev *dev, u32 *out,
-				  int outlen)
-{
-	u32 in[MLX5_ST_SZ_DW(query_adapter_in)] = {0};
-
-	MLX5_SET(query_adapter_in, in, opcode, MLX5_CMD_OP_QUERY_ADAPTER);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
-}
-
 int mlx5_query_board_id(struct mlx5_core_dev *dev)
 {
 	u32 *out;
 	int outlen = MLX5_ST_SZ_BYTES(query_adapter_out);
+	u32 in[MLX5_ST_SZ_DW(query_adapter_in)] = {};
 	int err;
 
 	out = kzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_cmd_query_adapter(dev, out, outlen);
+	MLX5_SET(query_adapter_in, in, opcode, MLX5_CMD_OP_QUERY_ADAPTER);
+	err = mlx5_cmd_exec_inout(dev, query_adapter, in, out);
 	if (err)
 		goto out;
 
@@ -105,13 +98,15 @@ int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id)
 {
 	u32 *out;
 	int outlen = MLX5_ST_SZ_BYTES(query_adapter_out);
+	u32 in[MLX5_ST_SZ_DW(query_adapter_in)] = {};
 	int err;
 
 	out = kzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_cmd_query_adapter(mdev, out, outlen);
+	MLX5_SET(query_adapter_in, in, opcode, MLX5_CMD_OP_QUERY_ADAPTER);
+	err = mlx5_cmd_exec_inout(mdev, query_adapter, in, out);
 	if (err)
 		goto out;
 
@@ -259,8 +254,7 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id)
 {
-	u32 out[MLX5_ST_SZ_DW(init_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(init_hca_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(init_hca_in)] = {};
 	int i;
 
 	MLX5_SET(init_hca_in, in, opcode, MLX5_CMD_OP_INIT_HCA);
@@ -271,16 +265,15 @@ int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id)
 				       sw_owner_id[i]);
 	}
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, init_hca, in);
 }
 
 int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev)
 {
-	u32 out[MLX5_ST_SZ_DW(teardown_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(teardown_hca_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(teardown_hca_in)] = {};
 
 	MLX5_SET(teardown_hca_in, in, opcode, MLX5_CMD_OP_TEARDOWN_HCA);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, teardown_hca, in);
 }
 
 int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev)
@@ -315,8 +308,8 @@ int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev)
 int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev)
 {
 	unsigned long end, delay_ms = MLX5_FAST_TEARDOWN_WAIT_MS;
-	u32 out[MLX5_ST_SZ_DW(teardown_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(teardown_hca_in)] = {0};
+	u32 out[MLX5_ST_SZ_DW(teardown_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(teardown_hca_in)] = {};
 	int state;
 	int ret;
 
@@ -329,7 +322,7 @@ int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev)
 	MLX5_SET(teardown_hca_in, in, profile,
 		 MLX5_TEARDOWN_HCA_IN_PROFILE_PREPARE_FAST_TEARDOWN);
 
-	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	ret = mlx5_cmd_exec_inout(dev, teardown_hca, in, out);
 	if (ret)
 		return ret;
 
-- 
2.25.2

