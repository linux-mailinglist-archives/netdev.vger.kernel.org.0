Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F46640EE6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiLBUK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiLBUKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:10:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A3FBE126
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AB6B8228E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BBEC433D6;
        Fri,  2 Dec 2022 20:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011851;
        bh=y9rGafyKvPlvJeO/9XrNoLzi0uHvOe1ytZLFBH/Ok+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhaGEJm6345bL7oSTLJWhW6nKAzis3si+oTVr7FqU7zbKM/QOFjLb8HaRgZjjD9XL
         D5z+vZa2Cq+bIKC6Up0X/VLP4zJmaB97CqBUEnXY99jXz2mf8Ge1i7po6bDXDV5Bjz
         8DWQXTY8p7K57CMwPRGZaq0FXNQ0wr66OEsTGczhM6hVIWNLIaOIu15cx+CPwZpc3l
         dwCJEg+mo5VPiCbLYu/8cjrdDdGHpIVrg7hkTeN+Nm4oFKMsidfRrHazkZvQhZyFZm
         SlcqIH5vq4pQwt0kgsxxf8CBafF7Jiv33Vgrx822sUZCvCDmC1sEzRlczB72KFXvqP
         1bOIHJUuO5DLw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 03/16] net/mlx5e: Advertise IPsec packet offload support
Date:   Fri,  2 Dec 2022 22:10:24 +0200
Message-Id: <71077abb6b10fb5ec6f8caec56fa8181db093a82.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Add needed capabilities check to determine if device supports IPsec
packet offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h    | 1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 4c47347d0ee2..fa052a89c4dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -88,6 +88,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 enum mlx5_ipsec_cap {
 	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
 	MLX5_IPSEC_CAP_ESN		= 1 << 1,
+	MLX5_IPSEC_CAP_PACKET_OFFLOAD	= 1 << 2,
 };
 
 struct mlx5e_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 792724ce7336..3d5a1f875398 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -31,6 +31,12 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
 		caps |= MLX5_IPSEC_CAP_CRYPTO;
 
+	if (MLX5_CAP_IPSEC(mdev, ipsec_full_offload) &&
+	    MLX5_CAP_FLOWTABLE_NIC_TX(mdev, reformat_add_esp_trasport) &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, reformat_del_esp_trasport) &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, decap))
+		caps |= MLX5_IPSEC_CAP_PACKET_OFFLOAD;
+
 	if (!caps)
 		return 0;
 
-- 
2.38.1

