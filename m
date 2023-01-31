Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1A36822A1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjAaDMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjAaDMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9940F3802F
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 527E460F35
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12B1C433EF;
        Tue, 31 Jan 2023 03:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134735;
        bh=XKkVVy8vXvfU4ckBcayqO+lqsnU4X0OTInYJsMFl/2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7kQt5djwIiP6znOI7ZsIdU+kBw95BMbO+eieYzb2uuboambbNu9sQ1wOjsuNLoGo
         NLVvLUbFxOrN7wo+59m8ClgguORxaDxRGuAT+rYuWcXJDdIZvcVli9DAMmfvJmygLU
         6W/pAssoPM7JkPh2JXux27MVdrOguI43I1SdAZkj+ZwzehA0QYfIEo8vM/jpdF1WPP
         O+jN//MoO3Ldvq/cd21Kg14OMix+bwzfjsZdP/ElBm4ZJwMClJjnVL1Dh/heNYZ8dF
         8Jup2Hk3voClg4qldqbe2kg7Yqlbg3lv4hmqFowusZvd2jNCoNhGpMgg8Pkye0W6Nv
         WufDpr9TRUThw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Add support SYNC_CRYPTO command
Date:   Mon, 30 Jan 2023 19:11:55 -0800
Message-Id: <20230131031201.35336-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Add support for SYNC_CRYPTO command. For now, it is executed only when
initializing DEK, but needed when reusing keys in later patch.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  3 ++
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 36 +++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 382d02f6619c..b00e33ed05e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -104,6 +104,7 @@ static bool mlx5_cmd_is_throttle_opcode(u16 op)
 	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_SYNC_CRYPTO:
 		return true;
 	}
 	return false;
@@ -523,6 +524,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE:
 	case MLX5_CMD_OP_SAVE_VHCA_STATE:
 	case MLX5_CMD_OP_LOAD_VHCA_STATE:
+	case MLX5_CMD_OP_SYNC_CRYPTO:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -ENOLINK;
@@ -725,6 +727,7 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(QUERY_VHCA_MIGRATION_STATE);
 	MLX5_COMMAND_STR_CASE(SAVE_VHCA_STATE);
 	MLX5_COMMAND_STR_CASE(LOAD_VHCA_STATE);
+	MLX5_COMMAND_STR_CASE(SYNC_CRYPTO);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index d1b4cc990756..ce29251484c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -7,6 +7,10 @@
 #define MLX5_CRYPTO_DEK_POOLS_NUM (MLX5_ACCEL_OBJ_TYPE_KEY_NUM - 1)
 #define type2idx(type) ((type) - 1)
 
+enum {
+	MLX5_CRYPTO_DEK_ALL_TYPE = BIT(0),
+};
+
 struct mlx5_crypto_dek_pool {
 	struct mlx5_core_dev *mdev;
 	u32 key_purpose;
@@ -71,6 +75,28 @@ static int mlx5_crypto_dek_fill_key(struct mlx5_core_dev *mdev, u8 *key_obj,
 	return 0;
 }
 
+static int mlx5_crypto_cmd_sync_crypto(struct mlx5_core_dev *mdev,
+				       int crypto_type)
+{
+	u32 in[MLX5_ST_SZ_DW(sync_crypto_in)] = {};
+	int err;
+
+	mlx5_core_dbg(mdev,
+		      "Execute SYNC_CRYPTO command with crypto_type(0x%x)\n",
+		      crypto_type);
+
+	MLX5_SET(sync_crypto_in, in, opcode, MLX5_CMD_OP_SYNC_CRYPTO);
+	MLX5_SET(sync_crypto_in, in, crypto_type, crypto_type);
+
+	err = mlx5_cmd_exec_in(mdev, sync_crypto, in);
+	if (err)
+		mlx5_core_err(mdev,
+			      "Failed to exec sync crypto, type=%d, err=%d\n",
+			      crypto_type, err);
+
+	return err;
+}
+
 static int mlx5_crypto_create_dek_key(struct mlx5_core_dev *mdev,
 				      const void *key, u32 sz_bytes,
 				      u32 key_purpose, u32 *p_key_id)
@@ -197,6 +223,7 @@ void mlx5_crypto_dek_cleanup(struct mlx5_crypto_dek_priv *dek_priv)
 struct mlx5_crypto_dek_priv *mlx5_crypto_dek_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_crypto_dek_priv *dek_priv;
+	int err;
 
 	if (!MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc))
 		return NULL;
@@ -209,10 +236,19 @@ struct mlx5_crypto_dek_priv *mlx5_crypto_dek_init(struct mlx5_core_dev *mdev)
 	dek_priv->log_dek_obj_range = min_t(int, 12,
 					    MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc));
 
+	/* sync all types of objects */
+	err = mlx5_crypto_cmd_sync_crypto(mdev, MLX5_CRYPTO_DEK_ALL_TYPE);
+	if (err)
+		goto err_sync_crypto;
+
 	mlx5_core_dbg(mdev, "Crypto DEK enabled, %d deks per alloc (max %d), total %d\n",
 		      1 << dek_priv->log_dek_obj_range,
 		      1 << MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc),
 		      1 << MLX5_CAP_CRYPTO(mdev, log_max_num_deks));
 
 	return dek_priv;
+
+err_sync_crypto:
+	kfree(dek_priv);
+	return ERR_PTR(err);
 }
-- 
2.39.1

