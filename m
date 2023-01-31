Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020FF6822A2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjAaDMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjAaDMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F5538012
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529E761388
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4A2C433D2;
        Tue, 31 Jan 2023 03:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134736;
        bh=bZOZuibJ0QyvuUoZbnrn9y0qYowgrr6YDh8WhwgQNp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8Q1CgSY5U8nrWUAiIK1UtJD/46FVlXzb9wVB1DhEpCFSt9XMMuapEFqiW2EuFSoy
         kgWyKYCo2QpDtkJbv7aSWXZNT3MvDUzXxwHM+WMe3WON1J6hgorSOaZ3QCMuwncPld
         WDs70Zip/EVnnGLjmYlJ/G75tYXoYFR+OoY/O7Ap60ZWpt2wGQdOXRP9ZXqEZjprrR
         VPMkSdZT/uhwB7/GlKvzjUyNUi33mJ5mC2GHgpLnX0tXvMBA8aC7JgKaY62PSeb+vo
         OCWTo52ud0v43ww2VWHuMP8xNMhkFtu+zg9BDD/BurWJfG8List7XDvju4togIYVFQ
         voYHqbI3aDhbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Add bulk allocation and modify_dek operation
Date:   Mon, 30 Jan 2023 19:11:56 -0800
Message-Id: <20230131031201.35336-11-saeed@kernel.org>
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

To support fast update of keys into hardware, we optimize firmware to
achieve the maximum rate. The approach is to create DEK objects in
bulk, and update each of them with modify command.
This patch supports bulk allocation and modify_dek commands for new
firmware. However, as log_obj_range is 0 for now, only one DEK obj is
allocated each time, and then updated with user key by modify_dek.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 85 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index ce29251484c0..a7b863859d50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -97,6 +97,72 @@ static int mlx5_crypto_cmd_sync_crypto(struct mlx5_core_dev *mdev,
 	return err;
 }
 
+static int mlx5_crypto_create_dek_bulk(struct mlx5_core_dev *mdev,
+				       u32 key_purpose, int log_obj_range,
+				       u32 *obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	void *obj, *param;
+	int err;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	param = MLX5_ADDR_OF(general_obj_in_cmd_hdr, in, op_param);
+	MLX5_SET(general_obj_create_param, param, log_obj_range, log_obj_range);
+
+	obj = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
+	MLX5_SET(encryption_key_obj, obj, key_purpose, key_purpose);
+	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.hw_objs.pdn);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	*obj_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+	mlx5_core_dbg(mdev, "DEK objects created, bulk=%d, obj_id=%d\n",
+		      1 << log_obj_range, *obj_id);
+
+	return 0;
+}
+
+static int mlx5_crypto_modify_dek_key(struct mlx5_core_dev *mdev,
+				      const void *key, u32 sz_bytes, u32 key_purpose,
+				      u32 obj_id, u32 obj_offset)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_encryption_key_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	void *obj, *param;
+	int err;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, obj_id);
+
+	param = MLX5_ADDR_OF(general_obj_in_cmd_hdr, in, op_param);
+	MLX5_SET(general_obj_query_param, param, obj_offset, obj_offset);
+
+	obj = MLX5_ADDR_OF(modify_encryption_key_in, in, encryption_key_object);
+	MLX5_SET64(encryption_key_obj, obj, modify_field_select, 1);
+	MLX5_SET(encryption_key_obj, obj, key_purpose, key_purpose);
+	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.hw_objs.pdn);
+
+	err = mlx5_crypto_dek_fill_key(mdev, obj, key, sz_bytes);
+	if (err)
+		return err;
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+
+	/* avoid leaking key on the stack */
+	memzero_explicit(in, sizeof(in));
+
+	return err;
+}
+
 static int mlx5_crypto_create_dek_key(struct mlx5_core_dev *mdev,
 				      const void *key, u32 sz_bytes,
 				      u32 key_purpose, u32 *p_key_id)
@@ -164,6 +230,7 @@ void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
 struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_pool,
 					       const void *key, u32 sz_bytes)
 {
+	struct mlx5_crypto_dek_priv *dek_priv = dek_pool->mdev->mlx5e_res.dek_priv;
 	struct mlx5_core_dev *mdev = dek_pool->mdev;
 	u32 key_purpose = dek_pool->key_purpose;
 	struct mlx5_crypto_dek *dek;
@@ -173,8 +240,22 @@ struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_
 	if (!dek)
 		return ERR_PTR(-ENOMEM);
 
-	err = mlx5_crypto_create_dek_key(mdev, key, sz_bytes,
-					 key_purpose, &dek->obj_id);
+	if (!dek_priv) {
+		err = mlx5_crypto_create_dek_key(mdev, key, sz_bytes,
+						 key_purpose, &dek->obj_id);
+		goto out;
+	}
+
+	err = mlx5_crypto_create_dek_bulk(mdev, key_purpose, 0, &dek->obj_id);
+	if (err)
+		goto out;
+
+	err = mlx5_crypto_modify_dek_key(mdev, key, sz_bytes, key_purpose,
+					 dek->obj_id, 0);
+	if (err)
+		mlx5_crypto_destroy_dek_key(mdev, dek->obj_id);
+
+out:
 	if (err) {
 		kfree(dek);
 		return ERR_PTR(err);
-- 
2.39.1

