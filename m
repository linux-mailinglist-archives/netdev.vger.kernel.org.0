Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61C14FACC2
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiDJIbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbiDJIb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1D059392;
        Sun, 10 Apr 2022 01:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9AF60EFD;
        Sun, 10 Apr 2022 08:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F94C385A8;
        Sun, 10 Apr 2022 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579349;
        bh=E4RB0u8p5mkI598j/PspsgdrsgKNDoBKeZzaYfGu2DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmA2JSc6224a3dDtI84e7L3teUFuYNP8SGhUCNPgrY7rz4uIpkH6I4YQB5pyfj2bj
         qb4/0LJReoueO/QBsFfUFDzG+h3lFXeyOwJ1P83uGISWd4o7DghpVXA+ma8whPJ9nr
         IG+BWh7UFoI8IJ0zrUVG9tpXfiJR/E3QDrlj7TZp+g98Jo3urs97y2AjLQfIPDwSIT
         lYMC+z7GV61Ros4ELy0vvAm00BkBnR+Phgxitzl5JTAinoBpEH0pccWQ0FXKnFyVIP
         gFFT9tdv2wY5kwEvqaOedPY9nV6zUjMg4oQ6DHFPK6/l+hYNLCXwWw14M2eLFg5dTh
         xamfmr0qba7zg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 07/17] net/mlx5: Merge various control path IPsec headers into one file
Date:   Sun, 10 Apr 2022 11:28:25 +0300
Message-Id: <85f61994042ee741d0aa8855d2bfca893c072cce.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5 IPsec code has logical separation between code that operates
with XFRM objects (ipsec.c), HW objects (ipsec_offload.c), flow steering
logic (ipsec_fs.c) and data path (ipsec_rxtx.c).

Such separation makes sense for C-files, but isn't needed at all for
H-files as they are included in batch anyway.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 101 +++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  23 +--
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  21 ---
 .../mlx5/core/en_accel/ipsec_offload.c        |   3 +-
 .../mlx5/core/en_accel/ipsec_offload.h        |  14 --
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 include/linux/mlx5/accel.h                    | 145 ------------------
 13 files changed, 120 insertions(+), 208 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 include/linux/mlx5/accel.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1e8700957280..3c1edfa33aa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -5,7 +5,7 @@
 #include "en/txrx.h"
 #include "en/port.h"
 #include "en_accel/en_accel.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 
 static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 142a2e8313f1..512a5ab9291d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -37,9 +37,8 @@
 #include <linux/netdevice.h>
 
 #include "en.h"
-#include "en_accel/ipsec.h"
-#include "en_accel/ipsec_rxtx.h"
-#include "en_accel/ipsec_fs.h"
+#include "ipsec.h"
+#include "ipsec_rxtx.h"
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 35a751faeb33..71c7a7355473 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -40,11 +40,81 @@
 #include <net/xfrm.h>
 #include <linux/idr.h>
 
-#include "ipsec_offload.h"
-
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
 
+enum mlx5_accel_esp_flags {
+	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
+	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
+	MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED     = 1UL << 1,
+	MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP = 1UL << 2,
+};
+
+enum mlx5_accel_esp_action {
+	MLX5_ACCEL_ESP_ACTION_DECRYPT,
+	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
+};
+
+enum mlx5_accel_esp_keymats {
+	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
+	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
+};
+
+struct aes_gcm_keymat {
+	u64   seq_iv;
+
+	u32   salt;
+	u32   icv_len;
+
+	u32   key_len;
+	u32   aes_key[256 / 32];
+};
+
+struct mlx5_accel_esp_xfrm_attrs {
+	enum mlx5_accel_esp_action action;
+	u32   esn;
+	__be32 spi;
+	u32   seq;
+	u32   tfc_pad;
+	u32   flags;
+	u32   sa_handle;
+	union {
+		struct {
+			u32 size;
+
+		} bmp;
+	} replay;
+	enum mlx5_accel_esp_keymats keymat_type;
+	union {
+		struct aes_gcm_keymat aes_gcm;
+	} keymat;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} saddr;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} daddr;
+
+	u8 is_ipv6;
+};
+
+struct mlx5_accel_esp_xfrm {
+	struct mlx5_core_dev  *mdev;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
+};
+
+enum mlx5_accel_ipsec_cap {
+	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
+	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
+	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
+	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
+	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
+};
+
 struct mlx5e_priv;
 
 struct mlx5e_ipsec_sw_stats {
@@ -108,6 +178,29 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 					      unsigned int handle);
 
+void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
+int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
+int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+			    struct mlx5_accel_esp_xfrm_attrs *attrs,
+			    u32 ipsec_obj_id,
+			    struct mlx5e_ipsec_rule *ipsec_rule);
+void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+			     struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5e_ipsec_rule *ipsec_rule);
+
+void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle);
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
+
+u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
+
+struct mlx5_accel_esp_xfrm *
+mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
+void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 #else
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
@@ -122,6 +215,10 @@ static inline void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
 #endif
 
 #endif	/* __MLX5E_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 3b715da86e6d..e278a8fd43ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2,8 +2,9 @@
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 
 #include <linux/netdevice.h>
-#include "ipsec_offload.h"
-#include "ipsec_fs.h"
+#include "en.h"
+#include "en/fs.h"
+#include "ipsec.h"
 #include "fs_core.h"
 
 #define NUM_IPSEC_FTE BIT(15)
@@ -565,7 +566,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
-			   attrs->action, err);
+				attrs->action, err);
 		goto out;
 	}
 
@@ -579,8 +580,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 }
 
 static void rx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5_accel_esp_xfrm_attrs *attrs,
-			struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5_accel_esp_xfrm_attrs *attrs,
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
@@ -592,7 +593,7 @@ static void rx_del_rule(struct mlx5e_priv *priv,
 }
 
 static void tx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
@@ -601,9 +602,9 @@ static void tx_del_rule(struct mlx5e_priv *priv,
 }
 
 int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-			    struct mlx5_accel_esp_xfrm_attrs *attrs,
-			    u32 ipsec_obj_id,
-			    struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5_accel_esp_xfrm_attrs *attrs,
+		u32 ipsec_obj_id,
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
@@ -612,8 +613,8 @@ int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 }
 
 void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-			     struct mlx5_accel_esp_xfrm_attrs *attrs,
-			     struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5_accel_esp_xfrm_attrs *attrs,
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
deleted file mode 100644
index 011af408ee03..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
-
-#ifndef __MLX5_IPSEC_STEERING_H__
-#define __MLX5_IPSEC_STEERING_H__
-
-#include "en.h"
-#include "ipsec.h"
-#include "ipsec_offload.h"
-#include "en/fs.h"
-
-void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
-int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
-int mlx5e_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-			    struct mlx5_accel_esp_xfrm_attrs *attrs,
-			    u32 ipsec_obj_id,
-			    struct mlx5e_ipsec_rule *ipsec_rule);
-void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-			     struct mlx5_accel_esp_xfrm_attrs *attrs,
-			     struct mlx5e_ipsec_rule *ipsec_rule);
-#endif /* __MLX5_IPSEC_STEERING_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 9d2932cf12f1..6c03ce8aba92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -2,9 +2,8 @@
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
-#include "ipsec_offload.h"
+#include "ipsec.h"
 #include "lib/mlx5.h"
-#include "en_accel/ipsec_fs.h"
 
 struct mlx5_ipsec_sa_ctx {
 	struct rhash_head hash;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
deleted file mode 100644
index 7dac104e6ef1..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
-
-#ifndef __MLX5_IPSEC_OFFLOAD_H__
-#define __MLX5_IPSEC_OFFLOAD_H__
-
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/accel.h>
-
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
-#endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 9b65c765cbd9..d30922e1b60f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -34,9 +34,8 @@
 #include <crypto/aead.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-#include "ipsec_offload.h"
-#include "en_accel/ipsec_rxtx.h"
-#include "en_accel/ipsec.h"
+#include "ipsec.h"
+#include "ipsec_rxtx.h"
 #include "en.h"
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 3aace1c2a763..9de84821dafb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -35,9 +35,7 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "ipsec_offload.h"
-#include "fpga/sdk.h"
-#include "en_accel/ipsec.h"
+#include "ipsec.h"
 
 static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sp_alloc) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 12b72a0bcb1a..d27986869b8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -48,7 +48,6 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
-#include "en_accel/ipsec_offload.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a5f6fd16b665..faf195b6deb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,7 +48,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d504c8cb8f96..27f3597a4964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -62,7 +62,7 @@
 #include "lib/mlx5.h"
 #include "lib/tout.h"
 #include "fpga/core.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 #include "lib/clock.h"
 #include "lib/vxlan.h"
 #include "lib/geneve.h"
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
deleted file mode 100644
index 9c511d466e55..000000000000
--- a/include/linux/mlx5/accel.h
+++ /dev/null
@@ -1,145 +0,0 @@
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
-#ifndef __MLX5_ACCEL_H__
-#define __MLX5_ACCEL_H__
-
-#include <linux/mlx5/driver.h>
-
-enum mlx5_accel_esp_flags {
-	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
-	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
-	MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED     = 1UL << 1,
-	MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP = 1UL << 2,
-};
-
-enum mlx5_accel_esp_action {
-	MLX5_ACCEL_ESP_ACTION_DECRYPT,
-	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
-};
-
-enum mlx5_accel_esp_keymats {
-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
-};
-
-
-struct aes_gcm_keymat {
-	u64   seq_iv;
-
-	u32   salt;
-	u32   icv_len;
-
-	u32   key_len;
-	u32   aes_key[256 / 32];
-};
-
-struct mlx5_accel_esp_xfrm_attrs {
-	enum mlx5_accel_esp_action action;
-	u32   esn;
-	__be32 spi;
-	u32   seq;
-	u32   tfc_pad;
-	u32   flags;
-	u32   sa_handle;
-	union {
-		struct {
-			u32 size;
-
-		} bmp;
-	} replay;
-	enum mlx5_accel_esp_keymats keymat_type;
-	union {
-		struct aes_gcm_keymat aes_gcm;
-	} keymat;
-
-	union {
-		__be32 a4;
-		__be32 a6[4];
-	} saddr;
-
-	union {
-		__be32 a4;
-		__be32 a6[4];
-	} daddr;
-
-	u8 is_ipv6;
-};
-
-struct mlx5_accel_esp_xfrm {
-	struct mlx5_core_dev  *mdev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-};
-
-enum mlx5_accel_ipsec_cap {
-	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
-};
-
-#ifdef CONFIG_MLX5_EN_IPSEC
-
-u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-				const struct mlx5_accel_esp_xfrm_attrs *attrs);
-
-#else
-
-static inline u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-static inline void
-mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm) {}
-static inline void
-mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-}
-
-#endif /* CONFIG_MLX5_EN_IPSEC */
-#endif /* __MLX5_ACCEL_H__ */
-- 
2.35.1

