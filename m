Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A2950688D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350583AbiDSKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350594AbiDSKR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8782AC78
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A113D60EBA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B686C385A5;
        Tue, 19 Apr 2022 10:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363274;
        bh=TObWgbu2mUKMMirEE6zVpGJgIAP0hOiGRZeeQTQYV+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVqi4wP8UkupiJ1EHIGg+aU0QtDnZKonlMwBhd0O8/yAG+RhXgWdt/CK0/94GtKVb
         HVR2Rzhzj2prTVvR71k4SoJWeHWmGaU/a1G1kRNeM54/E1xGBDLcAvDS5ORJ3iV/96
         W9VnzOqoY7sTqtfpNMz59PLLK4xqvWluON95ft8QyXDUu8t+M/dwbiJ/Aa1TUN8F8O
         rBZyuoay57plwL/54T+p2NyrUvcmdkGU45D4uKWf1yCztN70YU0BzTl6v9t+1smXsq
         PtHF1zQ45caJyPzwWTGP18Tuptz5i8RI7DwhuBvb9vcJZIz1rEOjtK6ms9XoBc6ryc
         WcnUBb06gFEQg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 06/17] net/mlx5: Remove useless validity check
Date:   Tue, 19 Apr 2022 13:13:42 +0300
Message-Id: <3837e89fa62c9c23fa05e737d6838d4f81e7d814.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

All callers build xfrm attributes with help of mlx5e_ipsec_build_accel_xfrm_attrs()
function that ensure validity of attributes. There is no need to recheck
them again.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 44 -------------------
 include/linux/mlx5/accel.h                    | 10 -----
 2 files changed, 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index bbfb6643ed80..9d2932cf12f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -62,55 +62,11 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-static int
-mlx5_ipsec_offload_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
-					   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	if (attrs->replay_type != MLX5_ACCEL_ESP_REPLAY_NONE) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with anti replay (replay_type = %d)\n",
-			      attrs->replay_type);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat_type != MLX5_ACCEL_ESP_KEYMAT_AES_GCM) {
-		mlx5_core_err(mdev, "Only aes gcm keymat is supported (keymat_type = %d)\n",
-			      attrs->keymat_type);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat.aes_gcm.iv_algo !=
-	    MLX5_ACCEL_ESP_AES_GCM_IV_ALGO_SEQ) {
-		mlx5_core_err(mdev, "Only iv sequence algo is supported (iv_algo = %d)\n",
-			      attrs->keymat.aes_gcm.iv_algo);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat.aes_gcm.key_len != 128 &&
-	    attrs->keymat.aes_gcm.key_len != 256) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with key length other than 128/256 bit (key length = %d)\n",
-			      attrs->keymat.aes_gcm.key_len);
-		return -EOPNOTSUPP;
-	}
-
-	if ((attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) &&
-	    !MLX5_CAP_IPSEC(mdev, ipsec_esn)) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with ESN triggered\n");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
 static struct mlx5_accel_esp_xfrm *
 mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	int err = 0;
-
-	err = mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs);
-	if (err)
-		return ERR_PTR(err);
 
 	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
 	if (!mxfrm)
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index a2720ebbb9fd..9c511d466e55 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -36,10 +36,6 @@
 
 #include <linux/mlx5/driver.h>
 
-enum mlx5_accel_esp_aes_gcm_keymat_iv_algo {
-	MLX5_ACCEL_ESP_AES_GCM_IV_ALGO_SEQ,
-};
-
 enum mlx5_accel_esp_flags {
 	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
 	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
@@ -57,14 +53,9 @@ enum mlx5_accel_esp_keymats {
 	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
 };
 
-enum mlx5_accel_esp_replay {
-	MLX5_ACCEL_ESP_REPLAY_NONE,
-	MLX5_ACCEL_ESP_REPLAY_BMP,
-};
 
 struct aes_gcm_keymat {
 	u64   seq_iv;
-	enum mlx5_accel_esp_aes_gcm_keymat_iv_algo iv_algo;
 
 	u32   salt;
 	u32   icv_len;
@@ -81,7 +72,6 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u32   tfc_pad;
 	u32   flags;
 	u32   sa_handle;
-	enum mlx5_accel_esp_replay replay_type;
 	union {
 		struct {
 			u32 size;
-- 
2.35.1

