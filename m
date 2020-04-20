Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7DC1B07CF
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDTLm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89FA9218AC;
        Mon, 20 Apr 2020 11:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382976;
        bh=MpxMUhm6/qW9DpKkxahe3dSBXrGI2WAFTkECh0Nl9AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt5A2oL4xGqafsZCzyteeyU/33/lHqZnPkUG2kBsXtCClha2dFhMumdsLrDzzgblS
         Br4I+A/LBMd7V1wBNtfw3MI16DQfhL2KvqXoVbl06xylQqjPpGw6HbgW4tD7Yzszx/
         hGPhfH2HZV2qkfLSRa/FHPws6G93D4sHbhzlgP88=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 21/24] net/mlx5: Update rl.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:33 +0300
Message-Id: <20200420114136.264924-22-leon@kernel.org>
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

Do mass update of rl.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 21 +++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index c9599f7c5696..99039c47ef33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -39,8 +39,8 @@
 int mlx5_create_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 				       void *ctx, u32 *element_id)
 {
-	u32 in[MLX5_ST_SZ_DW(create_scheduling_element_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(create_scheduling_element_in)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_scheduling_element_in)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_scheduling_element_in)] = {};
 	void *schedc;
 	int err;
 
@@ -52,7 +52,7 @@ int mlx5_create_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 		 hierarchy);
 	memcpy(schedc, ctx, MLX5_ST_SZ_BYTES(scheduling_context));
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, create_scheduling_element, in, out);
 	if (err)
 		return err;
 
@@ -65,8 +65,7 @@ int mlx5_modify_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 				       void *ctx, u32 element_id,
 				       u32 modify_bitmask)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_scheduling_element_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(modify_scheduling_element_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_scheduling_element_in)] = {};
 	void *schedc;
 
 	schedc = MLX5_ADDR_OF(modify_scheduling_element_in, in,
@@ -81,14 +80,13 @@ int mlx5_modify_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 		 hierarchy);
 	memcpy(schedc, ctx, MLX5_ST_SZ_BYTES(scheduling_context));
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, modify_scheduling_element, in);
 }
 
 int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 					u32 element_id)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_scheduling_element_in)]  = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_scheduling_element_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_scheduling_element_in)] = {};
 
 	MLX5_SET(destroy_scheduling_element_in, in, opcode,
 		 MLX5_CMD_OP_DESTROY_SCHEDULING_ELEMENT);
@@ -97,7 +95,7 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 	MLX5_SET(destroy_scheduling_element_in, in, scheduling_hierarchy,
 		 hierarchy);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_scheduling_element, in);
 }
 
 static bool mlx5_rl_are_equal_raw(struct mlx5_rl_entry *entry, void *rl_in,
@@ -144,8 +142,7 @@ static struct mlx5_rl_entry *find_rl_entry(struct mlx5_rl_table *table,
 static int mlx5_set_pp_rate_limit_cmd(struct mlx5_core_dev *dev,
 				      struct mlx5_rl_entry *entry, bool set)
 {
-	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)]   = {};
-	u32 out[MLX5_ST_SZ_DW(set_pp_rate_limit_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)] = {};
 	void *pp_context;
 
 	pp_context = MLX5_ADDR_OF(set_pp_rate_limit_in, in, ctx);
@@ -155,7 +152,7 @@ static int mlx5_set_pp_rate_limit_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(set_pp_rate_limit_in, in, rate_limit_index, entry->index);
 	if (set)
 		memcpy(pp_context, entry->rl_raw, sizeof(entry->rl_raw));
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, set_pp_rate_limit, in);
 }
 
 bool mlx5_rl_is_in_range(struct mlx5_core_dev *dev, u32 rate)
-- 
2.25.2

