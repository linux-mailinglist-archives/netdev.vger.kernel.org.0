Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB4B4F5C76
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiDFLkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiDFLht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:37:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E3577B4E;
        Wed,  6 Apr 2022 01:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9BF660B1B;
        Wed,  6 Apr 2022 08:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D998AC385DA;
        Wed,  6 Apr 2022 08:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233608;
        bh=1B8RgP8qS4bzHLQ/cJiU8J5bJALa6Z9owM33AUHoTBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0rV1OchZrlYIbNkYnVCinXbcCn1icUY3UlQsOQhpFlGhi8gJ7treL3+apFghM0KB
         L0R9DqUjtgL6ru60od6KJZsof6qIFakCsMvCW7GToRqfQVCDYvwLgIopj9kdifcdMU
         Z2xVhXjmWsTFmVvLLQsp8bqr3uwfM211pOl0cjoGY1fwrWSRI8bqeUC6iz5MJjpo1M
         mvlsY+Vzp7TBlIuafgXQkPtg+vBYRkzB2/HE9KOiFmcO8LmNJuBOR/t4exd10uixhU
         TB//lYFh5awGobsORxn4+FD+vlQ3BUjwVCLQ++UouMzdn/S1hPtUeQZZSLSLSf4AoK
         +QLvXMGxAnuaQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 11/17] net/mlx5: Unify device IPsec capabilities check
Date:   Wed,  6 Apr 2022 11:25:46 +0300
Message-Id: <8f10ea06ad19c6f651e9fb33921009658f01e1d5.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

Merge two different function to one in order to provide coherent
picture if the device is IPsec capable or not.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/accel/ipsec_offload.c  | 38 +++++++++----------
 .../mellanox/mlx5/core/accel/ipsec_offload.h  | 26 -------------
 .../ethernet/mellanox/mlx5/core/en/params.c   |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 12 +++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 include/linux/mlx5/accel.h                    |  7 +++-
 6 files changed, 32 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
index 3a85157f9f07..9dbebef19ff0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -6,9 +6,6 @@
 #include "lib/mlx5.h"
 #include "en_accel/ipsec_fs.h"
 
-#define MLX5_IPSEC_DEV_BASIC_CAPS (MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 | \
-				   MLX5_ACCEL_IPSEC_CAP_LSO)
-
 struct mlx5_ipsec_sa_ctx {
 	struct rhash_head hash;
 	u32 enc_key_id;
@@ -25,17 +22,31 @@ struct mlx5_ipsec_esp_xfrm {
 	struct mlx5_accel_esp_xfrm accel_xfrm;
 };
 
-static u32 mlx5_ipsec_offload_device_caps(struct mlx5_core_dev *mdev)
+u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
-	u32 caps = MLX5_IPSEC_DEV_BASIC_CAPS;
+	u32 caps;
+
+	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
+		return 0;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_dek))
+		return 0;
+
+	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
+	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
+		return 0;
 
-	if (!mlx5_is_ipsec_device(mdev))
+	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) ||
+	    !MLX5_CAP_ETH(mdev, insert_trailer))
 		return 0;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
 	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
 		return 0;
 
+	caps = MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 |
+	       MLX5_ACCEL_IPSEC_CAP_LSO;
+
 	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
 	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
 		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
@@ -52,6 +63,7 @@ static u32 mlx5_ipsec_offload_device_caps(struct mlx5_core_dev *mdev)
 	WARN_ON_ONCE(MLX5_CAP_IPSEC(mdev, log_max_ipsec_offload) > 24);
 	return caps;
 }
+EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
 static int
 mlx5_ipsec_offload_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
@@ -367,7 +379,6 @@ static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 }
 
 static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
-	.device_caps = mlx5_ipsec_offload_device_caps,
 	.create_hw_context = mlx5_ipsec_offload_create_sa_ctx,
 	.free_hw_context = mlx5_ipsec_offload_delete_sa_ctx,
 	.init = mlx5_ipsec_offload_init,
@@ -379,7 +390,7 @@ static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
 static const struct mlx5_accel_ipsec_ops *
 mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
 {
-	if (!mlx5_ipsec_offload_device_caps(mdev))
+	if (!mlx5_ipsec_device_caps(mdev))
 		return NULL;
 
 	return &ipsec_offload_ops;
@@ -416,17 +427,6 @@ void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
 	ipsec_ops->cleanup(mdev);
 }
 
-u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->device_caps)
-		return 0;
-
-	return ipsec_ops->device_caps(mdev);
-}
-EXPORT_SYMBOL_GPL(mlx5_accel_ipsec_device_caps);
-
 unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev)
 {
 	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
index 4a7d49ed5604..3d13e2c136b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
@@ -9,9 +9,6 @@
 
 #ifdef CONFIG_MLX5_IPSEC
 
-#define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
-			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
-
 unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev);
 int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 				   unsigned int count);
@@ -25,7 +22,6 @@ void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
 
 struct mlx5_accel_ipsec_ops {
-	u32 (*device_caps)(struct mlx5_core_dev *mdev);
 	unsigned int (*counters_count)(struct mlx5_core_dev *mdev);
 	int (*counters_read)(struct mlx5_core_dev *mdev, u64 *counters,
 			     unsigned int count);
@@ -45,25 +41,8 @@ struct mlx5_accel_ipsec_ops {
 	void (*esp_destroy_xfrm)(struct mlx5_accel_esp_xfrm *xfrm);
 };
 
-static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
-{
-	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
-		return false;
-
-	if (!MLX5_CAP_GEN(mdev, log_max_dek))
-		return false;
-
-	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
-	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
-		return false;
-
-	return MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
-		MLX5_CAP_ETH(mdev, insert_trailer);
-}
 #else
 
-#define MLX5_IPSEC_DEV(mdev) false
-
 static inline void *
 mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 				 struct mlx5_accel_esp_xfrm *xfrm,
@@ -80,10 +59,5 @@ static inline void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev,
 static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
 
 static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
-static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
-{
-	return false;
-}
-
 #endif /* CONFIG_MLX5_IPSEC */
 #endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index d2ec0961fe9e..9f4ae8bc09b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -689,8 +689,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	bool allow_swp;
 
-	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
-		    !!MLX5_IPSEC_DEV(mdev);
+	allow_swp =
+		mlx5_geneve_tx_allowed(mdev) || !!mlx5_ipsec_device_caps(mdev);
 	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 1391a0c84f16..c280a18ff002 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -226,8 +226,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		return -EINVAL;
 	}
 	if (x->props.flags & XFRM_STATE_ESN &&
-	    !(mlx5_accel_ipsec_device_caps(priv->mdev) &
-	    MLX5_ACCEL_IPSEC_CAP_ESN)) {
+	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_ESN)) {
 		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
 		return -EINVAL;
 	}
@@ -275,8 +274,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		return -EINVAL;
 	}
 	if (x->props.family == AF_INET6 &&
-	    !(mlx5_accel_ipsec_device_caps(priv->mdev) &
-	     MLX5_ACCEL_IPSEC_CAP_IPV6)) {
+	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
 		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
 		return -EINVAL;
 	}
@@ -406,7 +404,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ipsec *ipsec = NULL;
 
-	if (!MLX5_IPSEC_DEV(priv->mdev)) {
+	if (!mlx5_ipsec_device_caps(priv->mdev)) {
 		netdev_dbg(priv->netdev, "Not an IPSec offload device\n");
 		return 0;
 	}
@@ -519,7 +517,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
-	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
+	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
 		return;
@@ -538,7 +536,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
 
-	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
+	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
 	    !MLX5_CAP_ETH(mdev, swp_lso)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 346f7034fec8..6a3a08fd8910 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1329,7 +1329,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
-	if (MLX5_IPSEC_DEV(c->priv->mdev))
+	if (mlx5_ipsec_device_caps(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index af67d51308cf..9145e2d37c0e 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -124,7 +124,7 @@ enum mlx5_accel_ipsec_cap {
 
 #ifdef CONFIG_MLX5_ACCEL
 
-u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev);
+u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
 struct mlx5_accel_esp_xfrm *
 mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
@@ -135,7 +135,10 @@ int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 
 #else
 
-static inline u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev) { return 0; }
+static inline u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
 
 static inline struct mlx5_accel_esp_xfrm *
 mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-- 
2.35.1

