Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9325F1B07C7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgDTLmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC87214AF;
        Mon, 20 Apr 2020 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382965;
        bh=6uTQas+WgihWA12y7puB7Vd8jWDxwGTFjV0K7lRY/B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDRFYyg34boQmnFjKp35bzYI4gb/mAq5RYyDIMeUuGhyZvO1w8rvH0ZRdQlLHQ3Bm
         g/yXtJ7+suhX2Ixm3osaUxohWMeR7P9rkL5gcq1ktECjLBpjjy40yVjgYnB5l6do3T
         /wzT/BoHZB39kHLgO8987AjCtzhpGuGwb/rrN7F0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 18/24] net/mlx5: Update pagealloc.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:30 +0300
Message-Id: <20200420114136.264924-19-leon@kernel.org>
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

Do mass update of pagealloc.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index a3959754b927..3d6f617abb7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -135,8 +135,8 @@ static struct fw_page *find_fw_page(struct mlx5_core_dev *dev, u64 addr)
 static int mlx5_cmd_query_pages(struct mlx5_core_dev *dev, u16 *func_id,
 				s32 *npages, int boot)
 {
-	u32 out[MLX5_ST_SZ_DW(query_pages_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(query_pages_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(query_pages_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_pages_in)] = {};
 	int err;
 
 	MLX5_SET(query_pages_in, in, opcode, MLX5_CMD_OP_QUERY_PAGES);
@@ -145,7 +145,7 @@ static int mlx5_cmd_query_pages(struct mlx5_core_dev *dev, u16 *func_id,
 		 MLX5_QUERY_PAGES_IN_OP_MOD_INIT_PAGES);
 	MLX5_SET(query_pages_in, in, embedded_cpu_function, mlx5_core_is_ecpf(dev));
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, query_pages, in, out);
 	if (err)
 		return err;
 
@@ -256,8 +256,7 @@ static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
 static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id,
 			     bool ec_function)
 {
-	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(manage_pages_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {};
 	int err;
 
 	MLX5_SET(manage_pages_in, in, opcode, MLX5_CMD_OP_MANAGE_PAGES);
@@ -265,7 +264,7 @@ static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id,
 	MLX5_SET(manage_pages_in, in, function_id, func_id);
 	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_in(dev, manage_pages, in);
 	if (err)
 		mlx5_core_warn(dev, "page notify failed func_id(%d) err(%d)\n",
 			       func_id, err);
@@ -373,7 +372,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 			 int *nclaimed, bool ec_function)
 {
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
-	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {};
 	int num_claimed;
 	u32 *out;
 	int err;
-- 
2.25.2

