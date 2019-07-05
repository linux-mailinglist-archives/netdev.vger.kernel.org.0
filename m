Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB28D60953
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfGEPat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:49 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52398 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726302AbfGEPat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:49 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOd029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 04/12] net/mlx5: Accel, Add core TLS support for the Connect-X family
Date:   Fri,  5 Jul 2019 18:30:14 +0300
Message-Id: <1562340622-4423-5-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new TLS implementation of the Connect-X family.
Introduce a new compilation flag MLX5_TLS for it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    | 13 +++++-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    | 42 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    | 49 +++++++++++++++++++++-
 3 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 6556490d809c..37fef8cd25e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -134,10 +134,21 @@ config MLX5_FPGA_TLS
 	mlx5_core driver will include the Innova FPGA core and allow building
 	sandbox-specific client drivers.
 
+config MLX5_TLS
+	bool "Mellanox Technologies TLS Connect-X support"
+	depends on MLX5_CORE_EN
+	depends on TLS_DEVICE
+	depends on TLS=y || MLX5_CORE=m
+	select MLX5_ACCEL
+	default n
+	help
+	Build TLS support for the Connect-X family of network cards by Mellanox
+	Technologies.
+
 config MLX5_EN_TLS
 	bool "TLS cryptography-offload accelaration"
 	depends on MLX5_CORE_EN
-	depends on MLX5_FPGA_TLS
+	depends on MLX5_FPGA_TLS || MLX5_TLS
 	default y
 	help
 	Build support for TLS cryptography-offload accelaration in the NIC.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
index a2c9eda1ebf5..cab708af3422 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -35,6 +35,7 @@
 
 #include "accel/tls.h"
 #include "mlx5_core.h"
+#include "lib/mlx5.h"
 
 #ifdef CONFIG_MLX5_FPGA_TLS
 #include "fpga/tls.h"
@@ -63,7 +64,8 @@ int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
 
 bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev)
 {
-	return mlx5_fpga_is_tls_device(mdev);
+	return mlx5_fpga_is_tls_device(mdev) ||
+		mlx5_accel_is_ktls_device(mdev);
 }
 
 u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev)
@@ -81,3 +83,41 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev)
 	mlx5_fpga_tls_cleanup(mdev);
 }
 #endif
+
+#ifdef CONFIG_MLX5_TLS
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
+	return mlx5_create_encryption_key(mdev, key, sz_bytes, p_key_id);
+}
+
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	mlx5_destroy_encryption_key(mdev, key_id);
+}
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index e5d306ad7f91..879321b21616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -37,6 +37,50 @@
 #include <linux/mlx5/driver.h>
 #include <linux/tls.h>
 
+#ifdef CONFIG_MLX5_TLS
+int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+			 struct tls_crypto_info *crypto_info,
+			 u32 *p_key_id);
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
+
+static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
+{
+	if (!MLX5_CAP_GEN(mdev, tls))
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
+#else
+static inline int
+mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+		     struct tls_crypto_info *crypto_info,
+		     u32 *p_key_id) { return -ENOTSUPP; }
+static inline void
+mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id) {}
+
+static inline bool
+mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
+static inline bool
+mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
+		      struct tls_crypto_info *crypto_info) { return false; }
+#endif
+
 #ifdef CONFIG_MLX5_FPGA_TLS
 enum {
 	MLX5_ACCEL_TLS_TX = BIT(0),
@@ -83,7 +127,10 @@ static inline void mlx5_accel_tls_del_flow(struct mlx5_core_dev *mdev, u32 swid,
 					   bool direction_sx) { }
 static inline int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle,
 					   u32 seq, u64 rcd_sn) { return 0; }
-static inline bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev) { return false; }
+static inline bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev)
+{
+	return mlx5_accel_is_ktls_device(mdev);
+}
 static inline u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev) { return 0; }
 static inline int mlx5_accel_tls_init(struct mlx5_core_dev *mdev) { return 0; }
 static inline void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev) { }
-- 
1.8.3.1

