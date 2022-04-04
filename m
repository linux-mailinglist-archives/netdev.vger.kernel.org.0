Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D76A4F146E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiDDMKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbiDDMKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:10:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDA2DFB8;
        Mon,  4 Apr 2022 05:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A94EB81607;
        Mon,  4 Apr 2022 12:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9529CC340F2;
        Mon,  4 Apr 2022 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649074113;
        bh=tYvvDqdrz9CsoU/uR2LHuKDm1HcdeApCtBir84DqAbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7tq0H7Zmgk4eI7fkDFad7Q4YlKZ7h/oGqeBrVEwq0+z2jw0hnI0zuSTff0oesoHj
         PUvXT5vs7NnlcOkLQ+mnZWN7GhIzMRmyQ32M1MimBRG7txqBhRWiBdMB+XeJYVWUyz
         ycy/N3XNCFSTZMXLsNn/SFt+awMdmu2LnVljI4e1vNQZIoQ4/Pw/F332Qg5CZAsXqO
         dJ+FatFV/hUDJfRJoN5H+KfD1VhgKd4bqiLrc7+ie7++tGxLwDl06qPzaCT6OT9LJK
         lwZ6lNfOAGF+/SnVtEPc/xc3XOJX863ooDXJohWaRhyesIO1Vpm7Ou0ETcG7hU7Brt
         Ck4tFfeG20Brg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Remove indirection in TLS build
Date:   Mon,  4 Apr 2022 15:08:17 +0300
Message-Id: <0d1ea8cdc3a15922640b8b764d2bdb8f587b52c2.1649073691.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
References: <cover.1649073691.git.leonro@nvidia.com>
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

The dream described in the commit 1ae173228489 ("net/mlx5: Accel, Add TLS
tx offload interface") never came true, even an opposite happened when FPGA
TLS support was dropped. Such removal revealed the problematic flow in the
build process: build of unrelated files in case of TLS or IPsec are enabled.

In both cases, the MLX5_ACCEL is enabled, which built both TLS and IPsec.
As a solution, simply merge MLX5_TLS and MLX5_EN_TLS options and move TLS
related files to the eth part of the mlx5_core.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/accel/tls.c   |  78 --------------
 .../ethernet/mellanox/mlx5/core/accel/tls.h   | 100 ------------------
 .../mellanox/mlx5/core/en_accel/ktls.c        |  39 +++++++
 .../mellanox/mlx5/core/en_accel/ktls.h        |  47 +++++++-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   1 -
 .../mellanox/mlx5/core/en_accel/tls.c         |   1 -
 .../mellanox/mlx5/core/en_accel/tls.h         |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 10 files changed, 84 insertions(+), 197 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 21df10bb14c3..0c82b376416b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -177,23 +177,14 @@ config MLX5_EN_IPSEC
 	  Note: Support for hardware with this capability needs to be selected
 	  for this option to become available.
 
-config MLX5_TLS
+config MLX5_EN_TLS
 	bool "Mellanox Technologies TLS Connect-X support"
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
 	depends on MLX5_CORE_EN
 	select MLX5_ACCEL
-	select MLX5_EN_TLS
-	help
-	Build TLS support for the Connect-X family of network cards by Mellanox
-	Technologies.
-
-config MLX5_EN_TLS
-	bool
 	help
 	Build support for TLS cryptography-offload acceleration in the NIC.
-	Note: Support for hardware with this capability needs to be selected
-	for this option to become available.
 
 config MLX5_SW_STEERING
 	bool "Mellanox Technologies software-managed steering"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 33525f7d0aa0..b7e3bcb5e6c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -90,7 +90,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_IPSEC) += accel/ipsec_offload.o
 mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) += fpga/ipsec.o
-mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/tls.o accel/ipsec.o
+mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/ipsec.o
 
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
deleted file mode 100644
index fe82c4140d85..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/mlx5/device.h>
-
-#include "accel/tls.h"
-#include "mlx5_core.h"
-#include "lib/mlx5.h"
-
-#ifdef CONFIG_MLX5_TLS
-int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-			 struct tls_crypto_info *crypto_info,
-			 u32 *p_key_id)
-{
-	u32 sz_bytes;
-	void *key;
-
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128: {
-		struct tls12_crypto_info_aes_gcm_128 *info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
-
-		key      = info->key;
-		sz_bytes = sizeof(info->key);
-		break;
-	}
-	case TLS_CIPHER_AES_GCM_256: {
-		struct tls12_crypto_info_aes_gcm_256 *info =
-			(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
-
-		key      = info->key;
-		sz_bytes = sizeof(info->key);
-		break;
-	}
-	default:
-		return -EINVAL;
-	}
-
-	return mlx5_create_encryption_key(mdev, key, sz_bytes,
-					  MLX5_ACCEL_OBJ_TLS_KEY,
-					  p_key_id);
-}
-
-void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
-{
-	mlx5_destroy_encryption_key(mdev, key_id);
-}
-#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
deleted file mode 100644
index 6f92ebe3cc82..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#ifndef __MLX5_ACCEL_TLS_H__
-#define __MLX5_ACCEL_TLS_H__
-
-#include <linux/mlx5/driver.h>
-#include <linux/tls.h>
-
-#ifdef CONFIG_MLX5_TLS
-int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-			 struct tls_crypto_info *crypto_info,
-			 u32 *p_key_id);
-void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
-
-static inline bool mlx5_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
-{
-	return MLX5_CAP_GEN(mdev, tls_tx);
-}
-
-static inline bool mlx5_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
-{
-	return MLX5_CAP_GEN(mdev, tls_rx);
-}
-
-static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
-{
-	if (!mlx5_accel_is_ktls_tx(mdev) &&
-	    !mlx5_accel_is_ktls_rx(mdev))
-		return false;
-
-	if (!MLX5_CAP_GEN(mdev, log_max_dek))
-		return false;
-
-	return MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_128);
-}
-
-static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
-					 struct tls_crypto_info *crypto_info)
-{
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128:
-		if (crypto_info->version == TLS_1_2_VERSION)
-			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_128);
-		break;
-	}
-
-	return false;
-}
-#else
-static inline bool mlx5_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
-{ return false; }
-
-static inline bool mlx5_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
-{ return false; }
-
-static inline int
-mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-		     struct tls_crypto_info *crypto_info,
-		     u32 *p_key_id) { return -ENOTSUPP; }
-static inline void
-mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id) {}
-
-static inline bool
-mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
-static inline bool
-mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
-		      struct tls_crypto_info *crypto_info) { return false; }
-#endif
-#endif	/* __MLX5_ACCEL_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index d93aadbf10da..160aa44bcece 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -2,11 +2,50 @@
 // Copyright (c) 2019 Mellanox Technologies.
 
 #include "en.h"
+#include "lib/mlx5.h"
 #include "en_accel/tls.h"
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
 
+int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+			 struct tls_crypto_info *crypto_info,
+			 u32 *p_key_id)
+{
+	u32 sz_bytes;
+	void *key;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		key      = info->key;
+		sz_bytes = sizeof(info->key);
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *info =
+			(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
+
+		key      = info->key;
+		sz_bytes = sizeof(info->key);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return mlx5_create_encryption_key(mdev, key, sz_bytes,
+					  MLX5_ACCEL_OBJ_TLS_KEY,
+					  p_key_id);
+}
+
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	mlx5_destroy_encryption_key(mdev, key_id);
+}
+
 static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 			  enum tls_offload_ctx_dir direction,
 			  struct tls_crypto_info *crypto_info,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 5833deb2354c..82259d25a516 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -4,9 +4,38 @@
 #ifndef __MLX5E_KTLS_H__
 #define __MLX5E_KTLS_H__
 
+#include <linux/tls.h>
 #include "en.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
+int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+			 struct tls_crypto_info *crypto_info,
+			 u32 *p_key_id);
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
+
+static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
+{
+	if (!MLX5_CAP_GEN(mdev, tls_tx) && !MLX5_CAP_GEN(mdev, tls_rx))
+		return false;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_dek))
+		return false;
+
+	return MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_128);
+}
+
+static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
+					 struct tls_crypto_info *crypto_info)
+{
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		if (crypto_info->version == TLS_1_2_VERSION)
+			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_128);
+		break;
+	}
+
+	return false;
+}
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 int mlx5e_ktls_init_rx(struct mlx5e_priv *priv);
@@ -18,14 +47,12 @@ void mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_
 
 static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
 {
-	return !is_kdump_kernel() &&
-		mlx5_accel_is_ktls_tx(mdev);
+	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_tx);
 }
 
 static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
 {
-	return !is_kdump_kernel() &&
-		mlx5_accel_is_ktls_rx(mdev);
+	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_rx);
 }
 
 static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev)
@@ -35,6 +62,18 @@ static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev)
 }
 
 #else
+static inline int
+mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+		     struct tls_crypto_info *crypto_info,
+		     u32 *p_key_id) { return -EOPNOTSUPP; }
+static inline void
+mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id) {}
+
+static inline bool
+mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
+static inline bool
+mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
+		      struct tls_crypto_info *crypto_info) { return false; }
 
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index e5c180f2403b..0dc715c4c10d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -6,7 +6,6 @@
 
 #include <net/tls.h>
 #include "en.h"
-#include "accel/tls.h"
 
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     = 0,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index 0c6e165c154e..0609828bb973 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -34,7 +34,6 @@
 #include <linux/netdevice.h>
 #include <net/ipv6.h>
 #include "en_accel/tls.h"
-#include "accel/tls.h"
 
 void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index fc13b2ebe6b8..a9776fd04b20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -33,7 +33,6 @@
 #ifndef __MLX5E_TLS_H__
 #define __MLX5E_TLS_H__
 
-#include "accel/tls.h"
 #include "en_accel/ktls.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7423c6830c4f..7ef1ee7e7572 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -49,7 +49,6 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/tls.h"
 #include "accel/ipsec.h"
-#include "accel/tls.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
-- 
2.35.1

