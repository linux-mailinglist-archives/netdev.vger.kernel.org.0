Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3613562C0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348584AbhDGEzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348538AbhDGEys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37322613D3;
        Wed,  7 Apr 2021 04:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771279;
        bh=ZUae4fTld7F1uRUr44/G4y0dB+pjNTdVChERbGv5kzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQE7+DY+0Ca/1rjMy2+n3r6Os2Tfd3f2omic23Yjb3tVpCG8bUejHUWnrCH4AUF7V
         58bXHCXg3xLZX0umssdmtP0qJqJQJ8QBFXo7/XDxSddNRERnLGnRcRYPwVN9Vk+3L0
         3paAP330c9r7bXrhVBktxZViKeN5l2r5ZuYTo5zpk0ugmpabiEBEO82tZ8ZSYgjcSR
         kRkqp4lD5VpSo3YhCS2/jsSRwt7PyBNh0tg4wZS5aU7MaQqTe2oj8B8HoXrThnNtRT
         bKoiAFDkVtvpOSG7/e/wufK3Hkej+zC/IHfVSh3Q9qOTkJexYKnHGoio+anuL1Q3qy
         LTGZWFFyYEXww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/13] net/mlx5e: TC, Add sampler object API
Date:   Tue,  6 Apr 2021 21:54:17 -0700
Message-Id: <20210407045421.148987-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

In order to offload sample action, HW introduces sampler object. The
sampler object samples packets according to the provided sample ratio.
Sampled packets are duplicated. One copy is processed by a termination
table, named the sample table, which sends the packet up to software.
The second copy is processed by the default table.

Instantiate sampler object. Re-use identical sampler object for
the same sample ratio, sample table and default table as a prestep for
offloading tc sample actions.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/sample.c  | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 9bd996e8d28a..37e33670bb24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -3,11 +3,28 @@
 
 #include "esw/sample.h"
 #include "eswitch.h"
+#include "en_tc.h"
+#include "fs_core.h"
 
 struct mlx5_esw_psample {
 	struct mlx5e_priv *priv;
 	struct mlx5_flow_table *termtbl;
 	struct mlx5_flow_handle *termtbl_rule;
+	DECLARE_HASHTABLE(hashtbl, 8);
+	struct mutex ht_lock; /* protect hashtbl */
+};
+
+struct mlx5_sampler {
+	struct hlist_node hlist;
+	u32 sampler_id;
+	u32 sample_ratio;
+	u32 sample_table_id;
+	u32 default_table_id;
+	int count;
+};
+
+struct mlx5_sample_flow {
+	struct mlx5_sampler *sampler;
 };
 
 static int
@@ -64,6 +81,117 @@ sampler_termtbl_destroy(struct mlx5_esw_psample *esw_psample)
 	mlx5_destroy_flow_table(esw_psample->termtbl);
 }
 
+static int
+sampler_obj_create(struct mlx5_core_dev *mdev, struct mlx5_sampler *sampler)
+{
+	u32 in[MLX5_ST_SZ_DW(create_sampler_obj_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u64 general_obj_types;
+	void *obj;
+	int err;
+
+	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types & MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER))
+		return -EOPNOTSUPP;
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, ignore_flow_level))
+		return -EOPNOTSUPP;
+
+	obj = MLX5_ADDR_OF(create_sampler_obj_in, in, sampler_object);
+	MLX5_SET(sampler_obj, obj, table_type, FS_FT_FDB);
+	MLX5_SET(sampler_obj, obj, ignore_flow_level, 1);
+	MLX5_SET(sampler_obj, obj, level, 1);
+	MLX5_SET(sampler_obj, obj, sample_ratio, sampler->sample_ratio);
+	MLX5_SET(sampler_obj, obj, sample_table_id, sampler->sample_table_id);
+	MLX5_SET(sampler_obj, obj, default_table_id, sampler->default_table_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_SAMPLER);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		sampler->sampler_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	return err;
+}
+
+static void
+sampler_obj_destroy(struct mlx5_core_dev *mdev, u32 sampler_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_SAMPLER);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sampler_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static u32
+sampler_hash(u32 sample_ratio, u32 default_table_id)
+{
+	return jhash_2words(sample_ratio, default_table_id, 0);
+}
+
+static int
+sampler_cmp(u32 sample_ratio1, u32 default_table_id1, u32 sample_ratio2, u32 default_table_id2)
+{
+	return sample_ratio1 != sample_ratio2 || default_table_id1 != default_table_id2;
+}
+
+static struct mlx5_sampler *
+sampler_get(struct mlx5_esw_psample *esw_psample, u32 sample_ratio, u32 default_table_id)
+{
+	struct mlx5_sampler *sampler;
+	u32 hash_key;
+	int err;
+
+	mutex_lock(&esw_psample->ht_lock);
+	hash_key = sampler_hash(sample_ratio, default_table_id);
+	hash_for_each_possible(esw_psample->hashtbl, sampler, hlist, hash_key)
+		if (!sampler_cmp(sampler->sample_ratio, sampler->default_table_id,
+				 sample_ratio, default_table_id))
+			goto add_ref;
+
+	sampler = kzalloc(sizeof(*sampler), GFP_KERNEL);
+	if (!sampler) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	sampler->sample_table_id = esw_psample->termtbl->id;
+	sampler->default_table_id = default_table_id;
+	sampler->sample_ratio = sample_ratio;
+
+	err = sampler_obj_create(esw_psample->priv->mdev, sampler);
+	if (err)
+		goto err_create;
+
+	hash_add(esw_psample->hashtbl, &sampler->hlist, hash_key);
+
+add_ref:
+	sampler->count++;
+	mutex_unlock(&esw_psample->ht_lock);
+	return sampler;
+
+err_create:
+	kfree(sampler);
+err_alloc:
+	mutex_unlock(&esw_psample->ht_lock);
+	return ERR_PTR(err);
+}
+
+static void
+sampler_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sampler *sampler)
+{
+	mutex_lock(&esw_psample->ht_lock);
+	if (--sampler->count == 0) {
+		hash_del(&sampler->hlist);
+		sampler_obj_destroy(esw_psample->priv->mdev, sampler->sampler_id);
+		kfree(sampler);
+	}
+	mutex_unlock(&esw_psample->ht_lock);
+}
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv)
 {
@@ -78,6 +206,8 @@ mlx5_esw_sample_init(struct mlx5e_priv *priv)
 	if (err)
 		goto err_termtbl;
 
+	mutex_init(&esw_psample->ht_lock);
+
 	return esw_psample;
 
 err_termtbl:
@@ -91,6 +221,7 @@ mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample)
 	if (IS_ERR_OR_NULL(esw_psample))
 		return;
 
+	mutex_destroy(&esw_psample->ht_lock);
 	sampler_termtbl_destroy(esw_psample);
 	kfree(esw_psample);
 }
-- 
2.30.2

