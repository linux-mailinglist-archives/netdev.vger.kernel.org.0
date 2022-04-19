Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D550688E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbiDSKR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350735AbiDSKRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA3839D
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B0860EBA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E087CC385A9;
        Tue, 19 Apr 2022 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363298;
        bh=WVSO22Yz5f9H1nPByC95l98SjrPcYe1krA1qi9snY3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXl/+6E2qAUXxc+GEMRUj+7q1ENFsETBszPb86OskAG9gd4YnXIT6H3KSqzSKU7Et
         zWzszJaI87WyomxisQ1XqtRNv52ciboiOmbtAiooeN3A6453SpB2FZfa3PKF4DTtev
         byu8vmXOnGD/nEOL8iqZ4JrOrld2M6PX75Ib3ILDj857hHhCi+aiz3M+4oo6WXe8Fx
         gY+9Z+xARlvYZJGC8do1c/I8UqxJDnsyyl3lwgT/qbgEjEEmTwRu0U4sYfBvh4z6Ko
         bhGZAZi2FI/8ukH1cU4xKka7+ey+L+f2Tag0ITJCg4yiPbOloROtgtgIxebw/8hpnG
         7NXAgNAap87lQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 13/17] net/mlx5: Simplify IPsec capabilities logic
Date:   Tue, 19 Apr 2022 13:13:49 +0300
Message-Id: <f47d197be948ce44772baf3276a1a855ad2f210a.1650363043.git.leonro@nvidia.com>
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

Reduce number of hard-coded IPsec capabilities by making sure
that mlx5_ipsec_device_caps() sets only supported bits.

As part of this change, remove _accel_ notations from the names
and prepare the code to IPsec full offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 16 ++------------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  9 +++-----
 .../mlx5/core/en_accel/ipsec_offload.c        | 22 +++++++++----------
 3 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 28729b1cc6e6..be7650d2cfd3 100644
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
@@ -262,11 +262,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
-	if (x->props.family == AF_INET6 &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
-		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
-		return -EINVAL;
-	}
 	return 0;
 }
 
@@ -457,12 +452,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
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
@@ -476,8 +465,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
 
-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
-	    !MLX5_CAP_ETH(mdev, swp_lso)) {
+	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
 		return;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index af1467cbb7c7..97c55620089d 100644
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
index 817747d5229e..b44bce3f4ef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -7,7 +7,7 @@
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
-	u32 caps;
+	u32 caps = 0;
 
 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
 		return 0;
@@ -19,23 +19,23 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
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
+	    !MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
+		return 0;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
-	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
-		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
+	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
+	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
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

