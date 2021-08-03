Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9033DF865
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhHCXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhHCXUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07BB560F94;
        Tue,  3 Aug 2021 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032821;
        bh=AFc/6k5YwUwP9AAOKk7bsRXYfF/doRJC0xMN4+zaCwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8rtetJNIy1A+OrVyI3/SqkUmx/G5HW7LAfoE5s1M8AK064Mkk/pDGL3LOY4C01pl
         Qy+NbvwGYEuiko8zSBAqG2L0CWkpfrkSRKfEKbqevVqAJuLSgSxMtA1JahPaV5I6Xb
         Nq3wtO+bB0/LoohoeEzRu/CrJ8bG6u0gYIwiletYdTkOflDGdrQSzO/MLaZyPeAeGe
         /z17Rg/WGMIqm+lqZIvUlZjR66FdHyMyXBCzKdyRp5PiU6C+5NC8rq3NIZqXV+3mu5
         CmVkjOWpGdYxDzpYajjQQbfe636pceY52F8Aq/rn5UnB5Te+ekneZjedioGPJVnAoT
         /HheTpl/Dc3Zw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH mlx5-next 08/14] net/mlx5e: Use shared mappings for restoring from metadata
Date:   Tue,  3 Aug 2021 16:19:53 -0700
Message-Id: <20210803231959.26513-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

FTEs are added with mapped metadata which is saved per eswitch.
When uplink reps are bonded and we are in a single FDB mode,
we could fail to find metadata which was stored on one eswitch mapping
but not the other or with a different id.
To resolve this issue use shared mapping between eswitch ports.
We do not have any conflict using a single mapping, for a type,
between the ports.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  9 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 11 +++++++---
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 91e7a01e32be..b1707b86aa16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2138,6 +2138,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct mlx5_core_dev *dev;
 	const char *msg;
+	u64 mapping_id;
 	int err;
 
 	dev = priv->mdev;
@@ -2153,13 +2154,17 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	if (!ct_priv)
 		goto err_alloc;
 
-	ct_priv->zone_mapping = mapping_create(sizeof(u16), 0, true);
+	mapping_id = mlx5_query_nic_system_image_guid(dev);
+
+	ct_priv->zone_mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_ZONE,
+						      sizeof(u16), 0, true);
 	if (IS_ERR(ct_priv->zone_mapping)) {
 		err = PTR_ERR(ct_priv->zone_mapping);
 		goto err_mapping_zone;
 	}
 
-	ct_priv->labels_mapping = mapping_create(sizeof(u32) * 4, 0, true);
+	ct_priv->labels_mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_LABELS,
+							sizeof(u32) * 4, 0, true);
 	if (IS_ERR(ct_priv->labels_mapping)) {
 		err = PTR_ERR(ct_priv->labels_mapping);
 		goto err_mapping_labels;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 629a61e8022f..aca677933423 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4848,6 +4848,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mapping_ctx *chains_mapping;
 	struct mlx5_chains_attr attr = {};
+	u64 mapping_id;
 	int err;
 
 	mlx5e_mod_hdr_tbl_init(&tc->mod_hdr);
@@ -4861,8 +4862,12 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	lockdep_set_class(&tc->ht.mutex, &tc_ht_lock_key);
 
-	chains_mapping = mapping_create(sizeof(struct mlx5_mapped_obj),
-					MLX5E_TC_TABLE_CHAIN_TAG_MASK, true);
+	mapping_id = mlx5_query_nic_system_image_guid(dev);
+
+	chains_mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_CHAIN,
+					       sizeof(struct mlx5_mapped_obj),
+					       MLX5E_TC_TABLE_CHAIN_TAG_MASK, true);
+
 	if (IS_ERR(chains_mapping)) {
 		err = PTR_ERR(chains_mapping);
 		goto err_mapping;
@@ -4951,6 +4956,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	struct mapping_ctx *mapping;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
+	u64 mapping_id;
 	int err = 0;
 
 	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
@@ -4967,8 +4973,12 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	uplink_priv->esw_psample = mlx5_esw_sample_init(netdev_priv(priv->netdev));
 #endif
 
-	mapping = mapping_create(sizeof(struct tunnel_match_key),
-				 TUNNEL_INFO_BITS_MASK, true);
+	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
+
+	mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_TUNNEL,
+					sizeof(struct tunnel_match_key),
+					TUNNEL_INFO_BITS_MASK, true);
+
 	if (IS_ERR(mapping)) {
 		err = PTR_ERR(mapping);
 		goto err_tun_mapping;
@@ -4976,7 +4986,8 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	uplink_priv->tunnel_mapping = mapping;
 
 	/* 0xFFF is reserved for stack devices slow path table mark */
-	mapping = mapping_create(sz_enc_opts, ENC_OPTS_BITS_MASK - 1, true);
+	mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_TUNNEL_ENC_OPTS,
+					sz_enc_opts, ENC_OPTS_BITS_MASK - 1, true);
 	if (IS_ERR(mapping)) {
 		err = PTR_ERR(mapping);
 		goto err_enc_opts_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 48cac5bf606d..c3a47349f447 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -86,6 +86,14 @@ struct mlx5_mapped_obj {
 #define esw_chains(esw) \
 	((esw)->fdb_table.offloads.esw_chains_priv)
 
+enum {
+	MAPPING_TYPE_CHAIN,
+	MAPPING_TYPE_TUNNEL,
+	MAPPING_TYPE_TUNNEL_ENC_OPTS,
+	MAPPING_TYPE_LABELS,
+	MAPPING_TYPE_ZONE,
+};
+
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_handle *allow_rule;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1735be77e1fd..dd5eadd6047b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2787,6 +2787,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	struct mapping_ctx *reg_c0_obj_pool;
 	struct mlx5_vport *vport;
 	unsigned long i;
+	u64 mapping_id;
 	int err;
 
 	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
@@ -2810,9 +2811,13 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
 
-	reg_c0_obj_pool = mapping_create(sizeof(struct mlx5_mapped_obj),
-					 ESW_REG_C0_USER_DATA_METADATA_MASK,
-					 true);
+	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
+
+	reg_c0_obj_pool = mapping_create_for_id(mapping_id, MAPPING_TYPE_CHAIN,
+						sizeof(struct mlx5_mapped_obj),
+						ESW_REG_C0_USER_DATA_METADATA_MASK,
+						true);
+
 	if (IS_ERR(reg_c0_obj_pool)) {
 		err = PTR_ERR(reg_c0_obj_pool);
 		goto err_pool;
-- 
2.31.1

