Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07BC68229C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjAaDMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjAaDMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618F336FD2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCDC61386
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F81FC433EF;
        Tue, 31 Jan 2023 03:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134733;
        bh=OlnRTlUqF7FbdXVYawtnj2Jz9IsqwNWAnNJB68sFfMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcgXuSfrHCOBPL+8KA9aiwej1n/KUwwBWYVFHzsQ/w4TxqApPJXElSjOhc/DIIjTv
         fdLcxzWzwMFGskBi65CCKkXEyY7hDeBRoqNLKnP8k1iJHlPfakJkGCjzn9Q1T0PpTM
         0MDWvtivY9GpTv2iw5jtm3fSgo7EGW2+8SdOAbg6VeehQ70jPcux+d1WPHIC5ykBE8
         WpGvwF0r1AgshZYx3C4OkZtrE9KKYtTfEbFyl/OtItke7FyMKe2wHR/zMXjckCeeWh
         6w4+7SUv9HgSBWreC1nfE9nEdWJSGNnAbFw5m6lTfjDIZwbS4G7o6osuUJRlKM6IER
         +c8J9/nSS3XVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Refactor the encryption key creation
Date:   Mon, 30 Jan 2023 19:11:53 -0800
Message-Id: <20230131031201.35336-8-saeed@kernel.org>
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

Move the common code to general functions which can be used by fast
update encryption key in later patches.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 77 +++++++++++++------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index bc2a72491e10..81fe5c3763a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -9,50 +9,79 @@ struct mlx5_crypto_dek_priv {
 	int log_dek_obj_range;
 };
 
+static int mlx5_crypto_dek_get_key_sz(struct mlx5_core_dev *mdev,
+				      u32 sz_bytes, u8 *key_sz_p)
+{
+	u32 sz_bits = sz_bytes * BITS_PER_BYTE;
+
+	switch (sz_bits) {
+	case 128:
+		*key_sz_p = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
+		break;
+	case 256:
+		*key_sz_p = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256;
+		break;
+	default:
+		mlx5_core_err(mdev, "Crypto offload error, invalid key size (%u bits)\n",
+			      sz_bits);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mlx5_crypto_dek_fill_key(struct mlx5_core_dev *mdev, u8 *key_obj,
+				    const void *key, u32 sz_bytes)
+{
+	void *dst;
+	u8 key_sz;
+	int err;
+
+	err = mlx5_crypto_dek_get_key_sz(mdev, sz_bytes, &key_sz);
+	if (err)
+		return err;
+
+	MLX5_SET(encryption_key_obj, key_obj, key_size, key_sz);
+
+	if (sz_bytes == 16)
+		/* For key size of 128b the MSBs are reserved. */
+		dst = MLX5_ADDR_OF(encryption_key_obj, key_obj, key[1]);
+	else
+		dst = MLX5_ADDR_OF(encryption_key_obj, key_obj, key);
+
+	memcpy(dst, key, sz_bytes);
+
+	return 0;
+}
+
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       const void *key, u32 sz_bytes,
 			       u32 key_type, u32 *p_key_id)
 {
 	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
-	u32 sz_bits = sz_bytes * BITS_PER_BYTE;
-	u8  general_obj_key_size;
 	u64 general_obj_types;
-	void *obj, *key_p;
+	void *obj;
 	int err;
 
-	obj = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
-	key_p = MLX5_ADDR_OF(encryption_key_obj, obj, key);
-
 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
 	if (!(general_obj_types &
 	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY))
 		return -EINVAL;
 
-	switch (sz_bits) {
-	case 128:
-		general_obj_key_size =
-			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
-		key_p += sz_bytes;
-		break;
-	case 256:
-		general_obj_key_size =
-			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	memcpy(key_p, key, sz_bytes);
-
-	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
-	MLX5_SET(encryption_key_obj, obj, key_purpose, key_type);
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
 		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+
+	obj = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
+	MLX5_SET(encryption_key_obj, obj, key_purpose, key_type);
 	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.hw_objs.pdn);
 
+	err = mlx5_crypto_dek_fill_key(mdev, obj, key, sz_bytes);
+	if (err)
+		return err;
+
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
 		*p_key_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
-- 
2.39.1

