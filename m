Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300895649D1
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiGCUya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiGCUy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0DA5597;
        Sun,  3 Jul 2022 13:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FDEFB80CD1;
        Sun,  3 Jul 2022 20:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910E7C341C6;
        Sun,  3 Jul 2022 20:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881664;
        bh=KPNcxYuQm4DwJyLX2izxMH/T+Ps3FYgNHEaxDlj1t04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGFz0ca5UPlgJWakZ7CvNum6W5wMDKYYE0wLlCCLZTxkKNzigruAxl7UbaFY3S+HA
         xmaZvvK8CdX/n+neZLVDWJ70faVRf7Q30nja7GpwfL+uU0ceWZ5B1cwdKP9TLjvXSc
         yGT/9QOYDlEK0VRDJfgD8VAwtACcGCHHQ8HSs/7pDgfW4upZdMaZHMw6Qm0jmy7VjE
         +83sMMzmu6pwqgo+QplUG5aGshpxePU26hh2INhJvqsVuaq/yThjxzxdR8mcnF7Npx
         sd34+SINxxCccBab9AgMWql51jRsU3ePc/J6yFhXHzBb7kN2UcuiOcj8nGzaJWGgzI
         7IaZdIzfsHIBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: fs, allow flow table creation with a UID
Date:   Sun,  3 Jul 2022 13:54:05 -0700
Message-Id: <20220703205407.110890-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Add UID field to flow table attributes to allow creating flow tables
with a non default (zero) uid.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 16 ++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c    |  2 +-
 .../mellanox/mlx5/core/steering/dr_cmd.c         |  1 +
 .../mellanox/mlx5/core/steering/dr_table.c       |  8 +++++---
 .../mellanox/mlx5/core/steering/dr_types.h       |  1 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c |  7 ++++---
 .../mellanox/mlx5/core/steering/mlx5dr.h         |  3 ++-
 include/linux/mlx5/fs.h                          |  1 +
 9 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 735dc805dad7..e735e19461ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -50,10 +50,12 @@ static int mlx5_cmd_stub_update_root_ft(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_stub_create_flow_table(struct mlx5_flow_root_namespace *ns,
 					   struct mlx5_flow_table *ft,
-					   unsigned int size,
+					   struct mlx5_flow_table_attr *ft_attr,
 					   struct mlx5_flow_table *next_ft)
 {
-	ft->max_fte = size ? roundup_pow_of_two(size) : 1;
+	int max_fte = ft_attr->max_fte;
+
+	ft->max_fte = max_fte ? roundup_pow_of_two(max_fte) : 1;
 
 	return 0;
 }
@@ -258,7 +260,7 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 				      struct mlx5_flow_table *ft,
-				      unsigned int size,
+				      struct mlx5_flow_table_attr *ft_attr,
 				      struct mlx5_flow_table *next_ft)
 {
 	int en_encap = !!(ft->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
@@ -267,17 +269,19 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
+	unsigned int size;
 	int err;
 
-	if (size != POOL_NEXT_SIZE)
-		size = roundup_pow_of_two(size);
-	size = mlx5_ft_pool_get_avail_sz(dev, ft->type, size);
+	if (ft_attr->max_fte != POOL_NEXT_SIZE)
+		size = roundup_pow_of_two(ft_attr->max_fte);
+	size = mlx5_ft_pool_get_avail_sz(dev, ft->type, ft_attr->max_fte);
 	if (!size)
 		return -ENOSPC;
 
 	MLX5_SET(create_flow_table_in, in, opcode,
 		 MLX5_CMD_OP_CREATE_FLOW_TABLE);
 
+	MLX5_SET(create_flow_table_in, in, uid, ft_attr->uid);
 	MLX5_SET(create_flow_table_in, in, table_type, ft->type);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.level, ft->level);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.log_size, size ? ilog2(size) : 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index 274004e80f03..8ef4254b9ea1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -38,7 +38,7 @@
 struct mlx5_flow_cmds {
 	int (*create_flow_table)(struct mlx5_flow_root_namespace *ns,
 				 struct mlx5_flow_table *ft,
-				 unsigned int size,
+				 struct mlx5_flow_table_attr *ft_attr,
 				 struct mlx5_flow_table *next_ft);
 	int (*destroy_flow_table)(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 1da3dc7c95fa..35d89edb1bcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1155,7 +1155,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 			      find_next_chained_ft(fs_prio);
 	ft->def_miss_action = ns->def_miss_action;
 	ft->ns = ns;
-	err = root->cmds->create_flow_table(root, ft, ft_attr->max_fte, next_ft);
+	err = root->cmds->create_flow_table(root, ft, ft_attr, next_ft);
 	if (err)
 		goto free_ft;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 223c8741b7ae..16d65fe4f654 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -439,6 +439,7 @@ int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(create_flow_table_in, in, opcode, MLX5_CMD_OP_CREATE_FLOW_TABLE);
 	MLX5_SET(create_flow_table_in, in, table_type, attr->table_type);
+	MLX5_SET(create_flow_table_in, in, uid, attr->uid);
 
 	ft_mdev = MLX5_ADDR_OF(create_flow_table_in, in, flow_table_context);
 	MLX5_SET(flow_table_context, ft_mdev, termination_table, attr->term_tbl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index e5f6412baea9..31d443dd8386 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -214,7 +214,7 @@ static int dr_table_destroy_sw_owned_tbl(struct mlx5dr_table *tbl)
 					     tbl->table_type);
 }
 
-static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
+static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl, u16 uid)
 {
 	bool en_encap = !!(tbl->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
 	bool en_decap = !!(tbl->flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
@@ -236,6 +236,7 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
 	ft_attr.sw_owner = true;
 	ft_attr.decap_en = en_decap;
 	ft_attr.reformat_en = en_encap;
+	ft_attr.uid = uid;
 
 	ret = mlx5dr_cmd_create_flow_table(tbl->dmn->mdev, &ft_attr,
 					   NULL, &tbl->table_id);
@@ -243,7 +244,8 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
 	return ret;
 }
 
-struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 level, u32 flags)
+struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 level,
+					 u32 flags, u16 uid)
 {
 	struct mlx5dr_table *tbl;
 	int ret;
@@ -263,7 +265,7 @@ struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 level, u
 	if (ret)
 		goto free_tbl;
 
-	ret = dr_table_create_sw_owned_tbl(tbl);
+	ret = dr_table_create_sw_owned_tbl(tbl, uid);
 	if (ret)
 		goto uninit_tbl;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 98320e3945ad..50b0dd4fb4a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1200,6 +1200,7 @@ struct mlx5dr_cmd_query_flow_table_details {
 
 struct mlx5dr_cmd_create_flow_table_attr {
 	u32 table_type;
+	u16 uid;
 	u64 icm_addr_rx;
 	u64 icm_addr_tx;
 	u8 level;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 6a9abba92df6..c30ed8e18458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -62,7 +62,7 @@ static int set_miss_action(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 					 struct mlx5_flow_table *ft,
-					 unsigned int size,
+					 struct mlx5_flow_table_attr *ft_attr,
 					 struct mlx5_flow_table *next_ft)
 {
 	struct mlx5dr_table *tbl;
@@ -71,7 +71,7 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 
 	if (mlx5_dr_is_fw_table(ft->flags))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
-								    size,
+								    ft_attr,
 								    next_ft);
 	flags = ft->flags;
 	/* turn off encap/decap if not supported for sw-str by fw */
@@ -79,7 +79,8 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 		flags = ft->flags & ~(MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 				      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	tbl = mlx5dr_table_create(ns->fs_dr_domain.dr_domain, ft->level, flags);
+	tbl = mlx5dr_table_create(ns->fs_dr_domain.dr_domain, ft->level, flags,
+				  ft_attr->uid);
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7626c85643b1..3bb14860b36d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -51,7 +51,8 @@ void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 			    struct mlx5dr_domain *peer_dmn);
 
 struct mlx5dr_table *
-mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags);
+mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags,
+		    u16 uid);
 
 struct mlx5dr_table *
 mlx5dr_table_get_from_fs_ft(struct mlx5_flow_table *ft);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index eee07d416b56..8e73c377da2c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -178,6 +178,7 @@ struct mlx5_flow_table_attr {
 	int max_fte;
 	u32 level;
 	u32 flags;
+	u16 uid;
 	struct mlx5_flow_table *next_ft;
 
 	struct {
-- 
2.36.1

