Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32A268229E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjAaDMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjAaDMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE6737B45
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39BFE61387
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884B4C4339B;
        Tue, 31 Jan 2023 03:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134734;
        bh=BEYh0PLUqA+HwgyPBlDdbYw08ck4OgG8Ko1vzvJUJJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyIS6/J8dL4Wuxz6qiSoGo3twou31YiNMF//UOtN8YiTsL5yKy1IoIvwnboSqfr3B
         N5MQjs6UFvm5Kg0BglHKn3J0HKkD308WuMX8m5LEdDT/0pcRSfCFN3Txvgl1SY9sqh
         rgwM2JGsEjeFO5C3fmxgN5UbLg6GMN9uUYO7+JWFlYaiJ+9wbi9mm5L7i/KvLiW/lq
         Eo4cfkwCdKtfD7CjtM6pfmL2TWBsivVzjKY+GJ+dcP+2Ljq6Mk8XkpNxSOk7Kex/BD
         n1mhiiG+EP7MyTel68jnUteDuF/hJGADvYO6qy4e8QF3r1sdOOVqflmwJRAo3CYR4Y
         dMuy5UkVtOLYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Add new APIs for fast update encryption key
Date:   Mon, 30 Jan 2023 19:11:54 -0800
Message-Id: <20230131031201.35336-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

New APIs are added to support fast update DEKs. As a pool is created
for each key purpose (type), one pair of pool APIs to get/put pool.
Anotehr pair of DEKs APIs is to get DEK object from pool and update it
with user key, or free it back to the pool. As The bulk allocation
and destruction will be supported in later patches, old implementation
is used here.

To support these APIs, pool and dek structs are defined first. Only
small number of fields are stored in them. For example, key_purpose
and refcnt in pool struct, DEK object id in dek struct. More fields
will be added to these structs in later patches, for example, the
different bulk lists for pool struct, the bulk pointer dek struct
belongs to, and a list_entry for the list in a pool, which is used to
save keys waiting for being freed while other thread is doing sync.

Besides the creation and destruction interfaces, new one is also added
to get obj id.

Currently these APIs are planned to used by TLS only.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 90 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/lib/crypto.h  | 13 +++
 2 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 81fe5c3763a5..d1b4cc990756 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -4,11 +4,28 @@
 #include "mlx5_core.h"
 #include "lib/crypto.h"
 
+#define MLX5_CRYPTO_DEK_POOLS_NUM (MLX5_ACCEL_OBJ_TYPE_KEY_NUM - 1)
+#define type2idx(type) ((type) - 1)
+
+struct mlx5_crypto_dek_pool {
+	struct mlx5_core_dev *mdev;
+	u32 key_purpose;
+};
+
 struct mlx5_crypto_dek_priv {
 	struct mlx5_core_dev *mdev;
 	int log_dek_obj_range;
 };
 
+struct mlx5_crypto_dek {
+	u32 obj_id;
+};
+
+u32 mlx5_crypto_dek_get_id(struct mlx5_crypto_dek *dek)
+{
+	return dek->obj_id;
+}
+
 static int mlx5_crypto_dek_get_key_sz(struct mlx5_core_dev *mdev,
 				      u32 sz_bytes, u8 *key_sz_p)
 {
@@ -54,9 +71,9 @@ static int mlx5_crypto_dek_fill_key(struct mlx5_core_dev *mdev, u8 *key_obj,
 	return 0;
 }
 
-int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
-			       const void *key, u32 sz_bytes,
-			       u32 key_type, u32 *p_key_id)
+static int mlx5_crypto_create_dek_key(struct mlx5_core_dev *mdev,
+				      const void *key, u32 sz_bytes,
+				      u32 key_purpose, u32 *p_key_id)
 {
 	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
@@ -75,7 +92,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
 
 	obj = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
-	MLX5_SET(encryption_key_obj, obj, key_purpose, key_type);
+	MLX5_SET(encryption_key_obj, obj, key_purpose, key_purpose);
 	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.hw_objs.pdn);
 
 	err = mlx5_crypto_dek_fill_key(mdev, obj, key, sz_bytes);
@@ -92,7 +109,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 	return err;
 }
 
-void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
+static void mlx5_crypto_destroy_dek_key(struct mlx5_core_dev *mdev, u32 key_id)
 {
 	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
@@ -106,6 +123,69 @@ void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       const void *key, u32 sz_bytes,
+			       u32 key_type, u32 *p_key_id)
+{
+	return mlx5_crypto_create_dek_key(mdev, key, sz_bytes, key_type, p_key_id);
+}
+
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	mlx5_crypto_destroy_dek_key(mdev, key_id);
+}
+
+struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_pool,
+					       const void *key, u32 sz_bytes)
+{
+	struct mlx5_core_dev *mdev = dek_pool->mdev;
+	u32 key_purpose = dek_pool->key_purpose;
+	struct mlx5_crypto_dek *dek;
+	int err;
+
+	dek = kzalloc(sizeof(*dek), GFP_KERNEL);
+	if (!dek)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5_crypto_create_dek_key(mdev, key, sz_bytes,
+					 key_purpose, &dek->obj_id);
+	if (err) {
+		kfree(dek);
+		return ERR_PTR(err);
+	}
+
+	return dek;
+}
+
+void mlx5_crypto_dek_destroy(struct mlx5_crypto_dek_pool *dek_pool,
+			     struct mlx5_crypto_dek *dek)
+{
+	struct mlx5_core_dev *mdev = dek_pool->mdev;
+
+	mlx5_crypto_destroy_dek_key(mdev, dek->obj_id);
+	kfree(dek);
+}
+
+struct mlx5_crypto_dek_pool *
+mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev, int key_purpose)
+{
+	struct mlx5_crypto_dek_pool *pool;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return ERR_PTR(-ENOMEM);
+
+	pool->mdev = mdev;
+	pool->key_purpose = key_purpose;
+
+	return pool;
+}
+
+void mlx5_crypto_dek_pool_destroy(struct mlx5_crypto_dek_pool *pool)
+{
+	kfree(pool);
+}
+
 void mlx5_crypto_dek_cleanup(struct mlx5_crypto_dek_priv *dek_priv)
 {
 	if (!dek_priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
index ee3ed8c863d1..c819c047bb9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
@@ -8,6 +8,7 @@ enum {
 	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_TLS,
 	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_IPSEC,
 	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_MACSEC,
+	MLX5_ACCEL_OBJ_TYPE_KEY_NUM,
 };
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
@@ -16,6 +17,18 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
 
+struct mlx5_crypto_dek_pool;
+struct mlx5_crypto_dek;
+
+struct mlx5_crypto_dek_pool *mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev,
+							 int key_purpose);
+void mlx5_crypto_dek_pool_destroy(struct mlx5_crypto_dek_pool *pool);
+struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_pool,
+					       const void *key, u32 sz_bytes);
+void mlx5_crypto_dek_destroy(struct mlx5_crypto_dek_pool *dek_pool,
+			     struct mlx5_crypto_dek *dek);
+u32 mlx5_crypto_dek_get_id(struct mlx5_crypto_dek *dek);
+
 struct mlx5_crypto_dek_priv *mlx5_crypto_dek_init(struct mlx5_core_dev *mdev);
 void mlx5_crypto_dek_cleanup(struct mlx5_crypto_dek_priv *dek_priv);
 #endif /* __MLX5_LIB_CRYPTO_H__ */
-- 
2.39.1

