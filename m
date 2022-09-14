Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3059C5B8D06
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiINQ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiINQ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:28:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23876832EC
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5969B8171B
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 16:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7D3C433D6;
        Wed, 14 Sep 2022 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663172877;
        bh=uFZv+BBj+UU8bgjML1ynUCwruikhsclf+72oquSkI8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EW3TbwZ1MoYYQsYywkdW/hj7uYdzeq8mL5RQGGDvh5XI5lrzmQDBQQ63Lnj05DX+8
         h62ZpnsIQMK5zi20tV3SvGTIU3pkmTgZ6TxbHugDeibTFg+958HL3sDI1ez3u7XGZE
         QSkdu723woz9mkEt/J2bq0dZgKZfy9aY/MfMYi7ecdxSoZOqLPwB+gtANUwr60Cm7w
         qABinSmPCEntizhJAITXDbQSd4XSfjJpAJSfzjaHa/7Sz9xWDFEF69XUidPAC/U2Sh
         HExhObKWYXkLctMhFxhBY1CPdHA+d45dWVn374+zMjx+RxQkKYIIqvX00SnJ+OxWjh
         RIM7GRjes5qtA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 10/10] net/mlx5e: Support MACsec offload replay window
Date:   Wed, 14 Sep 2022 17:27:13 +0100
Message-Id: <20220914162713.203571-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914162713.203571-1-saeed@kernel.org>
References: <20220914162713.203571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Support setting replay window size for MACsec offload.
Currently supported window size of 32, 64, 128 and 256
bit. Other values will be returned as invalid parameter.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 47 +++++++++++++++----
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index ec3dd9966da4..a74354e17e83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -153,6 +153,8 @@ struct mlx5_macsec_obj_attrs {
 	struct mlx5e_macsec_epn_state epn_state;
 	salt_t salt;
 	__be32 ssci;
+	bool replay_protect;
+	u32 replay_window;
 };
 
 struct mlx5_aso_ctrl_param {
@@ -220,6 +222,35 @@ static void mlx5e_macsec_aso_dereg_mr(struct mlx5_core_dev *mdev, struct mlx5e_m
 	kfree(umr);
 }
 
+static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, void *aso_ctx)
+{
+	u8 window_sz;
+
+	if (!attrs->replay_protect)
+		return 0;
+
+	switch (attrs->replay_window) {
+	case 256:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
+		break;
+	case 128:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
+		break;
+	case 64:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
+		break;
+	case 32:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);
+	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_REPLAY_PROTECTION);
+
+	return 0;
+}
+
 static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 				      struct mlx5_macsec_obj_attrs *attrs,
 				      bool is_tx,
@@ -253,15 +284,18 @@ static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 		salt_p = MLX5_ADDR_OF(macsec_offload_obj, obj, salt);
 		for (i = 0; i < 3 ; i++)
 			memcpy((u32 *)salt_p + i, &attrs->salt.bytes[4 * (2 - i)], 4);
-		if (!is_tx)
-			MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_REPLAY_PROTECTION);
 	} else {
 		MLX5_SET64(macsec_offload_obj, obj, sci, (__force u64)(attrs->sci));
 	}
 
 	MLX5_SET(macsec_aso, aso_ctx, valid, 0x1);
-	if (is_tx)
+	if (is_tx) {
 		MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_INC_SN);
+	} else {
+		err = macsec_set_replay_protection(attrs, aso_ctx);
+		if (err)
+			return err;
+	}
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
@@ -343,6 +377,8 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	}
 
 	memcpy(&obj_attrs.salt, &key->salt, sizeof(key->salt));
+	obj_attrs.replay_window = ctx->secy->replay_window;
+	obj_attrs.replay_protect = ctx->secy->replay_protect;
 
 	err = mlx5e_macsec_create_object(mdev, &obj_attrs, is_tx, &sa->macsec_obj_id);
 	if (err)
@@ -438,11 +474,6 @@ static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
 		return false;
 	}
 
-	if (secy->replay_protect) {
-		netdev_err(netdev, "MACsec offload: replay protection is not supported\n");
-		return false;
-	}
-
 	return true;
 }
 
-- 
2.37.3

