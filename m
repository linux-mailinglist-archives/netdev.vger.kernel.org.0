Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498B1B07C3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgDTLmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgDTLmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DE121D94;
        Mon, 20 Apr 2020 11:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382961;
        bh=1Mwj3RjmFnmPxFPL90WRx6qOcMtpon2+USqJqUKzf48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWXQwBDEM/gurjisbjR/+Hsa5VBOplU8W3aZIKpUSIV1/EDcgvoTjGJcQH0WHR+Am
         pLcn4veQ6NAJQlQeVJH34wVrvohr/UXYd//102zHNV+Ctgb7ZEBsua9SVIAxIw2qYy
         u0r/QRvUIAgnSl7zZK0nIlPkfL5CFMFtfC8JJRcA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 17/24] net/mlx5: Update mr.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:29 +0300
Message-Id: <20200420114136.264924-18-leon@kernel.org>
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

Do mass update of mr.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 1feedf335dea..9eb51f06d3ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -39,7 +39,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 			  struct mlx5_core_mkey *mkey,
 			  u32 *in, int inlen)
 {
-	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {0};
+	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {};
 	u32 mkey_index;
 	void *mkc;
 	int err;
@@ -65,19 +65,18 @@ EXPORT_SYMBOL(mlx5_core_create_mkey);
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
 			   struct mlx5_core_mkey *mkey)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_mkey_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_mkey_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_mkey_in)] = {};
 
 	MLX5_SET(destroy_mkey_in, in, opcode, MLX5_CMD_OP_DESTROY_MKEY);
 	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey->key));
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_mkey, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_mkey);
 
 int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
 			 u32 *out, int outlen)
 {
-	u32 in[MLX5_ST_SZ_DW(query_mkey_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_mkey_in)] = {};
 
 	memset(out, 0, outlen);
 	MLX5_SET(query_mkey_in, in, opcode, MLX5_CMD_OP_QUERY_MKEY);
@@ -99,8 +98,8 @@ static inline u32 mlx5_get_psv(u32 *out, int psv_index)
 int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index)
 {
-	u32 out[MLX5_ST_SZ_DW(create_psv_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(create_psv_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(create_psv_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_psv_in)] = {};
 	int i, err;
 
 	if (npsvs > MLX5_MAX_PSVS)
@@ -110,7 +109,7 @@ int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 	MLX5_SET(create_psv_in, in, pd, pdn);
 	MLX5_SET(create_psv_in, in, num_psv, npsvs);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, create_psv, in, out);
 	if (err)
 		return err;
 
@@ -123,11 +122,10 @@ EXPORT_SYMBOL(mlx5_core_create_psv);
 
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_psv_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_psv_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_psv_in)] = {};
 
 	MLX5_SET(destroy_psv_in, in, opcode, MLX5_CMD_OP_DESTROY_PSV);
 	MLX5_SET(destroy_psv_in, in, psvn, psv_num);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_psv, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_psv);
-- 
2.25.2

