Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37C560959
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGEPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52449 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727914AbfGEPaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:52 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOb029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 02/12] net/mlx5: Kconfig, Better organize compilation flags
Date:   Fri,  5 Jul 2019 18:30:12 +0300
Message-Id: <1562340622-4423-3-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always contain all acceleration functions declarations in
'accel' files, independent to the flags setting.
For this, introduce new flags CONFIG_FPGA_{IPSEC/TLS} and use stubs
where needed.

This obsoletes the need for stubs in 'fpga' files. Remove them.

Also use the new flags in Makefile, to decide whether to compile
TLS-specific or IPSEC-specific objects, or not.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    | 43 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  7 +-
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |  3 +
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   | 75 ----------------------
 include/linux/mlx5/accel.h                         |  2 +-
 8 files changed, 47 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 7845aa5bf6be..6556490d809c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -97,26 +97,49 @@ config MLX5_CORE_IPOIB
 	---help---
 	  MLX5 IPoIB offloads & acceleration support.
 
+config MLX5_FPGA_IPSEC
+	bool "Mellanox Technologies IPsec Innova support"
+	depends on MLX5_CORE
+	depends on MLX5_FPGA
+	default n
+	help
+	Build IPsec support for the Innova family of network cards by Mellanox
+	Technologies. Innova network cards are comprised of a ConnectX chip
+	and an FPGA chip on one board. If you select this option, the
+	mlx5_core driver will include the Innova FPGA core and allow building
+	sandbox-specific client drivers.
+
 config MLX5_EN_IPSEC
 	bool "IPSec XFRM cryptography-offload accelaration"
-	depends on MLX5_ACCEL
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
+	depends on MLX5_FPGA_IPSEC
 	default n
-	---help---
+	help
 	  Build support for IPsec cryptography-offload accelaration in the NIC.
 	  Note: Support for hardware with this capability needs to be selected
 	  for this option to become available.
 
-config MLX5_EN_TLS
-	bool "TLS cryptography-offload accelaration"
-	depends on MLX5_CORE_EN
+config MLX5_FPGA_TLS
+	bool "Mellanox Technologies TLS Innova support"
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
-	depends on MLX5_ACCEL
+	depends on MLX5_FPGA
 	default n
-	---help---
-	  Build support for TLS cryptography-offload accelaration in the NIC.
-	  Note: Support for hardware with this capability needs to be selected
-	  for this option to become available.
+	help
+	Build TLS support for the Innova family of network cards by Mellanox
+	Technologies. Innova network cards are comprised of a ConnectX chip
+	and an FPGA chip on one board. If you select this option, the
+	mlx5_core driver will include the Innova FPGA core and allow building
+	sandbox-specific client drivers.
+
+config MLX5_EN_TLS
+	bool "TLS cryptography-offload accelaration"
+	depends on MLX5_CORE_EN
+	depends on MLX5_FPGA_TLS
+	default y
+	help
+	Build support for TLS cryptography-offload accelaration in the NIC.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8456b19d79cd..d3409870646a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -53,10 +53,11 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 # Accelerations & FPGA
 #
-mlx5_core-$(CONFIG_MLX5_ACCEL) += accel/ipsec.o accel/tls.o
+mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) += fpga/ipsec.o
+mlx5_core-$(CONFIG_MLX5_FPGA_TLS)   += fpga/tls.o
+mlx5_core-$(CONFIG_MLX5_ACCEL)      += accel/tls.o accel/ipsec.o
 
-mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o \
-				 fpga/ipsec.o fpga/tls.o
+mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index d1e76d5a413b..eddc34e4a762 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -31,6 +31,8 @@
  *
  */
 
+#ifdef CONFIG_MLX5_FPGA_IPSEC
+
 #include <linux/mlx5/device.h>
 
 #include "accel/ipsec.h"
@@ -112,3 +114,5 @@ int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 	return mlx5_fpga_esp_modify_xfrm(xfrm, attrs);
 }
 EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index 93b3f5faddb5..530e428d46ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -37,7 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/accel.h>
 
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_FPGA_IPSEC
 
 #define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
 			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
index da7bd26368f9..a2c9eda1ebf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -35,6 +35,8 @@
 
 #include "accel/tls.h"
 #include "mlx5_core.h"
+
+#ifdef CONFIG_MLX5_FPGA_TLS
 #include "fpga/tls.h"
 
 int mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
@@ -78,3 +80,4 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev)
 {
 	mlx5_fpga_tls_cleanup(mdev);
 }
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index def4093ebfae..e5d306ad7f91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -37,8 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/tls.h>
 
-#ifdef CONFIG_MLX5_ACCEL
-
+#ifdef CONFIG_MLX5_FPGA_TLS
 enum {
 	MLX5_ACCEL_TLS_TX = BIT(0),
 	MLX5_ACCEL_TLS_RX = BIT(1),
@@ -88,7 +87,6 @@ static inline int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handl
 static inline u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev) { return 0; }
 static inline int mlx5_accel_tls_init(struct mlx5_core_dev *mdev) { return 0; }
 static inline void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev) { }
-
 #endif
 
 #endif	/* __MLX5_ACCEL_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index 2b5e63b0d4d6..382985e65b48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -37,8 +37,6 @@
 #include "accel/ipsec.h"
 #include "fs_cmd.h"
 
-#ifdef CONFIG_MLX5_FPGA
-
 u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
 unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev);
 int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
@@ -66,77 +64,4 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
 
-#else
-
-static inline u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline unsigned int
-mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev,
-						u64 *counters)
-{
-	return 0;
-}
-
-static inline void *
-mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
-			      struct mlx5_accel_esp_xfrm *accel_xfrm,
-			      const __be32 saddr[4],
-			      const __be32 daddr[4],
-			      const __be32 spi, bool is_ipv6)
-{
-	return NULL;
-}
-
-static inline void mlx5_fpga_ipsec_delete_sa_ctx(void *context)
-{
-}
-
-static inline int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev)
-{
-}
-
-static inline void mlx5_fpga_ipsec_build_fs_cmds(void)
-{
-}
-
-static inline struct mlx5_accel_esp_xfrm *
-mlx5_fpga_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			  const struct mlx5_accel_esp_xfrm_attrs *attrs,
-			  u32 flags)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static inline void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
-{
-}
-
-static inline int
-mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			  const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline const struct mlx5_flow_cmds *
-mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
-{
-	return mlx5_fs_cmd_get_default(type);
-}
-
-#endif /* CONFIG_MLX5_FPGA */
-
 #endif	/* __MLX5_FPGA_SADB_H__ */
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 70e7e5673ce9..5613e677a5f9 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -114,7 +114,7 @@ enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN	= 1 << 7,
 };
 
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_FPGA_IPSEC
 
 u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
-- 
1.8.3.1

