Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABC468229D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjAaDMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjAaDMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2090367F2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495A761387
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B78C433EF;
        Tue, 31 Jan 2023 03:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134731;
        bh=kfV6HRulptf0OabgRcveBwWRsvsqlgqnuSOdXPaZRCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx/oiJ8USgEBTyNMeQHW6vRSlmqWREBUHTlPR7jcYaB1bJ/mj7Si0WbKI3wuuR66c
         Vv2T/2SonLyhTzBUcb8kZbDGFtkcfvti4EoZD5wYbUlbN1rtZBxUIQfIuhyRNYnsrg
         QcvH/631Xmnpujk0Km3Tcw+Kwyl7BZNjVJd7nPQZOSMuex1qvSKxnZWZKoT8UnRszy
         zJ6be+PWDBll2pPKUqWqCNCqcLKnINlC4RggjFaRrzTgPGn10k2NUGwX+Fau2VdjxJ
         F0DpsJSt4J04s8whOhbYtX/u6JpAj4w3O7fRD71HoMtozsXScsu1YR2Nkwn2NfasBx
         vQ1y7uM+taShw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Prepare for fast crypto key update if hardware supports it
Date:   Mon, 30 Jan 2023 19:11:51 -0800
Message-Id: <20230131031201.35336-6-saeed@kernel.org>
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

Add CAP for crypto offload, do the simple initialization if hardware
supports it. Currently set log_dek_obj_range to 12, so 4k DEKs will be
created in one bulk allocation.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_common.c   | 10 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  6 ++++
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 36 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/crypto.h  |  2 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/device.h                   |  4 +++
 include/linux/mlx5/driver.h                   |  2 ++
 7 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 68f19324db93..4c9a3210600c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -31,6 +31,7 @@
  */
 
 #include "en.h"
+#include "lib/crypto.h"
 
 /* mlx5e global resources should be placed in this file.
  * Global resources are common to all the netdevices created on the same nic.
@@ -104,6 +105,13 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 	INIT_LIST_HEAD(&res->td.tirs_list);
 	mutex_init(&res->td.list_lock);
 
+	mdev->mlx5e_res.dek_priv = mlx5_crypto_dek_init(mdev);
+	if (IS_ERR(mdev->mlx5e_res.dek_priv)) {
+		mlx5_core_err(mdev, "crypto dek init failed, %ld\n",
+			      PTR_ERR(mdev->mlx5e_res.dek_priv));
+		mdev->mlx5e_res.dek_priv = NULL;
+	}
+
 	return 0;
 
 err_destroy_mkey:
@@ -119,6 +127,8 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 {
 	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 
+	mlx5_crypto_dek_cleanup(mdev->mlx5e_res.dek_priv);
+	mdev->mlx5e_res.dek_priv = NULL;
 	mlx5_free_bfreg(mdev, &res->bfreg);
 	mlx5_core_destroy_mkey(mdev, res->mkey);
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index f34e758a2f1f..7bb7be01225a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -267,6 +267,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, crypto)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_CRYPTO);
+		if (err)
+			return err;
+	}
+
 	if (MLX5_CAP_GEN(dev, shampo)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_SHAMPO);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 7614595c5416..02bc365efade 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -4,6 +4,11 @@
 #include "mlx5_core.h"
 #include "lib/crypto.h"
 
+struct mlx5_crypto_dek_priv {
+	struct mlx5_core_dev *mdev;
+	int log_dek_obj_range;
+};
+
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       void *key, u32 sz_bytes,
 			       u32 key_type, u32 *p_key_id)
@@ -71,3 +76,34 @@ void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
 
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
+
+void mlx5_crypto_dek_cleanup(struct mlx5_crypto_dek_priv *dek_priv)
+{
+	if (!dek_priv)
+		return;
+
+	kfree(dek_priv);
+}
+
+struct mlx5_crypto_dek_priv *mlx5_crypto_dek_init(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_crypto_dek_priv *dek_priv;
+
+	if (!MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc))
+		return NULL;
+
+	dek_priv = kzalloc(sizeof(*dek_priv), GFP_KERNEL);
+	if (!dek_priv)
+		return ERR_PTR(-ENOMEM);
+
+	dek_priv->mdev = mdev;
+	dek_priv->log_dek_obj_range = min_t(int, 12,
+					    MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc));
+
+	mlx5_core_dbg(mdev, "Crypto DEK enabled, %d deks per alloc (max %d), total %d\n",
+		      1 << dek_priv->log_dek_obj_range,
+		      1 << MLX5_CAP_CRYPTO(mdev, log_dek_max_alloc),
+		      1 << MLX5_CAP_CRYPTO(mdev, log_max_num_deks));
+
+	return dek_priv;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
index 0a5a7dc9fa05..5968536047ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
@@ -16,4 +16,6 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
 
+struct mlx5_crypto_dek_priv *mlx5_crypto_dek_init(struct mlx5_core_dev *mdev);
+void mlx5_crypto_dek_cleanup(struct mlx5_crypto_dek_priv *dek_priv);
 #endif /* __MLX5_LIB_CRYPTO_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8823f20d2122..9441588ac524 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1555,6 +1555,7 @@ static const int types[] = {
 	MLX5_CAP_DEV_SHAMPO,
 	MLX5_CAP_MACSEC,
 	MLX5_CAP_ADV_VIRTUALIZATION,
+	MLX5_CAP_CRYPTO,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 29d4b201c7b2..bc531bd9804f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1204,6 +1204,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_CRYPTO = 0x1a,
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_MACSEC = 0x1f,
 	MLX5_CAP_GENERAL_2 = 0x20,
@@ -1460,6 +1461,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_IPSEC(mdev, cap)\
 	MLX5_GET(ipsec_cap, (mdev)->caps.hca[MLX5_CAP_IPSEC]->cur, cap)
 
+#define MLX5_CAP_CRYPTO(mdev, cap)\
+	MLX5_GET(crypto_cap, (mdev)->caps.hca[MLX5_CAP_CRYPTO]->cur, cap)
+
 #define MLX5_CAP_DEV_SHAMPO(mdev, cap)\
 	MLX5_GET(shampo_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_SHAMPO], cap)
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 44167760ff29..cd529e051b4d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -516,6 +516,7 @@ struct mlx5_vhca_state_notifier;
 struct mlx5_sf_dev_table;
 struct mlx5_sf_hw_table;
 struct mlx5_sf_table;
+struct mlx5_crypto_dek_priv;
 
 struct mlx5_rate_limit {
 	u32			rate;
@@ -673,6 +674,7 @@ struct mlx5e_resources {
 	} hw_objs;
 	struct devlink_port dl_port;
 	struct net_device *uplink_netdev;
+	struct mlx5_crypto_dek_priv *dek_priv;
 };
 
 enum mlx5_sw_icm_type {
-- 
2.39.1

