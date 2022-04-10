Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCB24FACCD
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiDJIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiDJIbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A205A09B;
        Sun, 10 Apr 2022 01:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB531B80AE8;
        Sun, 10 Apr 2022 08:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BBFC385A8;
        Sun, 10 Apr 2022 08:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579372;
        bh=cAC97hZ8oFmuG9EdCcrhUTbSTFuCpyEgPovLVjsWdM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCxKHCMgzSgvHedAg8HxYqB7fO87IrHM0X0FHAjZ1+NSA9aAaG7HcX2tYWNKke4jJ
         Zbz1xm4tnAXZRhUEnqZo1wLq4aurzWO+h1vqO+BjyrakjxKIDhQuWehO/PzjxcXCWo
         fm3MW3LAS8GECg0MSAwrqLZbxZjMbJa0FeTAoayqFARQ0KMINUxEdnkkN0dR+u2eJP
         lCHcMwsfmW9gOubFKJEd1cdDeZykxMKPf+31PVWDd7Ywp9A8CGx8FxgZA0pL4T2bDR
         qIqt45tnAPKVsgAXpidpp4ZKS07lQhMCHRflRIT9rf5++53bpxHrTtu6+cL16To0AE
         Iot1J35J9Bm5g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 13/17] net/mlx5: Simplify IPsec capabilities logic
Date:   Sun, 10 Apr 2022 11:28:31 +0300
Message-Id: <97011021fc7b7c5d64dcc21b5a103a97d56a13c5.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Reduce number of hard-coded IPsec capabilities by making sure
that mlx5_ipsec_device_caps() sets only supported bits.

As part of this change, remove _accel_ notations from the names
and prepare the code to IPsec full offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 13 +++--------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  9 +++-----
 .../mlx5/core/en_accel/ipsec_offload.c        | 23 ++++++++++---------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 6f93d749b21a..e138a4d1a9c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -215,7 +215,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		return -EINVAL;
 	}
 	if (x->props.flags & XFRM_STATE_ESN &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_ESN)) {
+	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_ESN)) {
 		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
 		return -EINVAL;
 	}
@@ -263,7 +263,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		return -EINVAL;
 	}
 	if (x->props.family == AF_INET6 &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
+	    !mlx5_ipsec_device_caps(priv->mdev)) {
 		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
 		return -EINVAL;
 	}
@@ -456,12 +456,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	if (!mlx5_ipsec_device_caps(mdev))
 		return;
 
-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
-	    !MLX5_CAP_ETH(mdev, swp)) {
-		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-		return;
-	}
-
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
 	netdev->features |= NETIF_F_HW_ESP;
@@ -475,8 +469,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
 
-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
-	    !MLX5_CAP_ETH(mdev, swp_lso)) {
+	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
 		return;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index eb605a0bc5bb..998a812fbd15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -102,12 +102,9 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 is_ipv6;
 };
 
-enum mlx5_accel_ipsec_cap {
-	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
+enum mlx5_ipsec_cap {
+	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
+	MLX5_IPSEC_CAP_ESN		= 1 << 1,
 };
 
 struct mlx5e_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index d3585c8c876b..1dc8588635e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -7,7 +7,7 @@
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
-	u32 caps;
+	u32 caps = 0;
 
 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
 		return 0;
@@ -19,23 +19,24 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
 		return 0;
 
-	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) ||
-	    !MLX5_CAP_ETH(mdev, insert_trailer))
-		return 0;
-
 	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
 	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
 		return 0;
 
-	caps = MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 |
-	       MLX5_ACCEL_IPSEC_CAP_LSO;
+	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) ||
+	    !MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt) ||
+	    !MLX5_CAP_ETH(mdev, swp))
+		return 0;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
-	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
-		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
+	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
+	    MLX5_CAP_ETH(mdev, insert_trailer))
+		caps |= MLX5_IPSEC_CAP_CRYPTO;
+
+	if (!caps)
+		return 0;
 
 	if (MLX5_CAP_IPSEC(mdev, ipsec_esn))
-		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
+		caps |= MLX5_IPSEC_CAP_ESN;
 
 	/* We can accommodate up to 2^24 different IPsec objects
 	 * because we use up to 24 bit in flow table metadata
-- 
2.35.1

