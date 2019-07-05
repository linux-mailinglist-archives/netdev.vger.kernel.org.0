Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85906095B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfGEPbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:31:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52473 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727922AbfGEPay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:54 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOl029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 12/12] net/mlx5e: Add kTLS TX HW offload support
Date:   Fri,  5 Jul 2019 18:30:22 +0300
Message-Id: <1562340622-4423-13-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for transmit side kernel-TLS acceleration.
Offload the crypto encryption to HW.

Per TLS connection:
- Use a separate TIS to maintain the HW context.
- Use a separate encryption key.
- Maintain static and progress HW contexts by posting the proper
  WQEs at creation time, or upon resync.
- Use a special DUMP opcode to replay the previous frags and sync
  the HW context.

To make sure the SQ is able to serve an xmit request, increase
SQ stop room to cover:
- static params WQE,
- progress params WQE, and
- resync DUMP per frag.

Currently supporting TLS 1.2, and key size 128bit.

Tested over SimX simulator.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  93 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  97 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 459 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  11 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  14 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 14 files changed, 748 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 5a1ee9ec8659..57d2cc666fe3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -62,4 +62,5 @@ mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o
 
-mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o
+mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
+				   en_accel/ktls.o en_accel/ktls_tx.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d3d2733917ff..263558875f20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -209,7 +209,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt        inline_mtts[0];
+		u8                     tls_static_params_ctx[0];
+	};
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
@@ -333,6 +336,9 @@ struct mlx5e_tx_wqe_info {
 	u32 num_bytes;
 	u8  num_wqebbs;
 	u8  num_dma;
+#ifdef CONFIG_MLX5_EN_TLS
+	skb_frag_t *resync_dump_frag;
+#endif
 };
 
 enum mlx5e_dma_map_type {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index ef16f9e41cf4..ddfe19adb3d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -15,9 +15,15 @@
 #else
 /* TLS offload requires additional stop_room for:
  *  - a resync SKB.
+ * kTLS offload requires additional stop_room for:
+ * - static params WQE,
+ * - progress params WQE, and
+ * - resync DUMP per frag.
  */
 #define MLX5E_SQ_TLS_ROOM  \
-	(MLX5_SEND_WQE_MAX_WQEBBS)
+	(MLX5_SEND_WQE_MAX_WQEBBS + \
+	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS + \
+	 MAX_SKB_FRAGS * MLX5E_KTLS_MAX_DUMP_WQEBBS)
 #endif
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
new file mode 100644
index 000000000000..d2ff74d52720
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "en.h"
+#include "en_accel/ktls.h"
+
+static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+	void *tisc;
+
+	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	MLX5_SET(tisc, tisc, tls_en, 1);
+
+	return mlx5e_create_tis(mdev, in, tisn);
+}
+
+static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
+			  enum tls_offload_ctx_dir direction,
+			  struct tls_crypto_info *crypto_info,
+			  u32 start_offload_tcp_sn)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_ktls_offload_context_tx *tx_priv;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
+
+	if (WARN_ON(direction != TLS_OFFLOAD_CTX_DIR_TX))
+		return -EINVAL;
+
+	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
+		return -EOPNOTSUPP;
+
+	tx_priv = kvzalloc(sizeof(*tx_priv), GFP_KERNEL);
+	if (!tx_priv)
+		return -ENOMEM;
+
+	tx_priv->expected_seq = start_offload_tcp_sn;
+	tx_priv->crypto_info  = crypto_info;
+	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, tx_priv);
+
+	/* tc and underlay_qpn values are not in use for tls tis */
+	err = mlx5e_ktls_create_tis(mdev, &tx_priv->tisn);
+	if (err)
+		goto create_tis_fail;
+
+	err = mlx5_ktls_create_key(mdev, crypto_info, &tx_priv->key_id);
+	if (err)
+		goto encryption_key_create_fail;
+
+	mlx5e_ktls_tx_offload_set_pending(tx_priv);
+
+	return 0;
+
+encryption_key_create_fail:
+	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+create_tis_fail:
+	kvfree(tx_priv);
+	return err;
+}
+
+static void mlx5e_ktls_del(struct net_device *netdev,
+			   struct tls_context *tls_ctx,
+			   enum tls_offload_ctx_dir direction)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_ktls_offload_context_tx *tx_priv =
+		mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+
+	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
+	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+	kvfree(tx_priv);
+}
+
+static const struct tlsdev_ops mlx5e_ktls_ops = {
+	.tls_dev_add = mlx5e_ktls_add,
+	.tls_dev_del = mlx5e_ktls_del,
+};
+
+void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+
+	if (!mlx5_accel_is_ktls_device(priv->mdev))
+		return;
+
+	netdev->hw_features |= NETIF_F_HW_TLS_TX;
+	netdev->features    |= NETIF_F_HW_TLS_TX;
+
+	netdev->tlsdev_ops = &mlx5e_ktls_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
new file mode 100644
index 000000000000..407da83474ef
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5E_KTLS_H__
+#define __MLX5E_KTLS_H__
+
+#include "en.h"
+
+#ifdef CONFIG_MLX5_EN_TLS
+#include <net/tls.h>
+#include "accel/tls.h"
+
+#define MLX5E_KTLS_STATIC_UMR_WQE_SZ \
+	(sizeof(struct mlx5e_umr_wqe) + MLX5_ST_SZ_BYTES(tls_static_params))
+#define MLX5E_KTLS_STATIC_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_BB))
+
+#define MLX5E_KTLS_PROGRESS_WQE_SZ \
+	(sizeof(struct mlx5e_tx_wqe) + MLX5_ST_SZ_BYTES(tls_progress_params))
+#define MLX5E_KTLS_PROGRESS_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
+#define MLX5E_KTLS_MAX_DUMP_WQEBBS 2
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     = 0,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_OFFLOAD        = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_AUTHENTICATION = 2,
+};
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 2,
+};
+
+struct mlx5e_ktls_offload_context_tx {
+	struct tls_offload_context_tx *tx_ctx;
+	struct tls_crypto_info *crypto_info;
+	u32 expected_seq;
+	u32 tisn;
+	u32 key_id;
+	bool ctx_post_pending;
+};
+
+struct mlx5e_ktls_offload_context_tx_shadow {
+	struct tls_offload_context_tx         tx_ctx;
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+};
+
+static inline void
+mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
+			   struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+
+	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+
+	shadow->priv_tx = priv_tx;
+	priv_tx->tx_ctx = tx_ctx;
+}
+
+static inline struct mlx5e_ktls_offload_context_tx *
+mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
+{
+	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+
+	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+
+	return shadow->priv_tx;
+}
+
+void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
+void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
+
+struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
+					 struct mlx5e_txqsq *sq,
+					 struct sk_buff *skb,
+					 struct mlx5e_tx_wqe **wqe, u16 *pi);
+void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					   struct mlx5e_tx_wqe_info *wi,
+					   struct mlx5e_sq_dma *dma);
+
+#else
+
+static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
+{
+}
+
+#endif
+
+#endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
new file mode 100644
index 000000000000..3f5f4317a22b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -0,0 +1,459 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include <linux/tls.h>
+#include "en.h"
+#include "en/txrx.h"
+#include "en_accel/ktls.h"
+
+enum {
+	MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2 = 0x2,
+};
+
+enum {
+	MLX5E_ENCRYPTION_STANDARD_TLS = 0x1,
+};
+
+#define EXTRACT_INFO_FIELDS do { \
+	salt    = info->salt;    \
+	rec_seq = info->rec_seq; \
+	salt_sz    = sizeof(info->salt);    \
+	rec_seq_sz = sizeof(info->rec_seq); \
+} while (0)
+
+static void
+fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	char *initial_rn, *gcm_iv;
+	u16 salt_sz, rec_seq_sz;
+	char *salt, *rec_seq;
+	u8 tls_version;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		EXTRACT_INFO_FIELDS;
+		break;
+	}
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
+	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
+
+	memcpy(gcm_iv,      salt,    salt_sz);
+	memcpy(initial_rn,  rec_seq, rec_seq_sz);
+
+	tls_version = MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2;
+
+	MLX5_SET(tls_static_params, ctx, tls_version, tls_version);
+	MLX5_SET(tls_static_params, ctx, const_1, 1);
+	MLX5_SET(tls_static_params, ctx, const_2, 2);
+	MLX5_SET(tls_static_params, ctx, encryption_standard,
+		 MLX5E_ENCRYPTION_STANDARD_TLS);
+	MLX5_SET(tls_static_params, ctx, dek_index, priv_tx->key_id);
+}
+
+static void
+build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u32 sqn,
+		    struct mlx5e_ktls_offload_context_tx *priv_tx,
+		    bool fence)
+{
+	struct mlx5_wqe_ctrl_seg     *cseg  = &wqe->ctrl;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+
+#define STATIC_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR |
+					     (MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS << 24));
+	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     STATIC_PARAMS_DS_CNT);
+	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+	cseg->imm              = cpu_to_be32(priv_tx->tisn);
+
+	ucseg->flags = MLX5_UMR_INLINE;
+	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
+
+	fill_static_params_ctx(wqe->tls_static_params_ctx, priv_tx);
+}
+
+static void
+fill_progress_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	MLX5_SET(tls_progress_params, ctx, pd, priv_tx->tisn);
+	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
+	MLX5_SET(tls_progress_params, ctx, auth_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD);
+}
+
+static void
+build_progress_params(struct mlx5e_tx_wqe *wqe, u16 pc, u32 sqn,
+		      struct mlx5e_ktls_offload_context_tx *priv_tx,
+		      bool fence)
+{
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+
+#define PROGRESS_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode =
+		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV |
+			    (MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS << 24));
+	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     PROGRESS_PARAMS_DS_CNT);
+	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	fill_progress_params_ctx(wqe->data, priv_tx);
+}
+
+static void tx_fill_wi(struct mlx5e_txqsq *sq,
+		       u16 pi, u8 num_wqebbs,
+		       skb_frag_t *resync_dump_frag)
+{
+	struct mlx5e_tx_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	wi->skb              = NULL;
+	wi->num_wqebbs       = num_wqebbs;
+	wi->resync_dump_frag = resync_dump_frag;
+}
+
+void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	priv_tx->ctx_post_pending = true;
+}
+
+static bool
+mlx5e_ktls_tx_offload_test_and_clear_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	bool ret = priv_tx->ctx_post_pending;
+
+	priv_tx->ctx_post_pending = false;
+
+	return ret;
+}
+
+static void
+post_static_params(struct mlx5e_txqsq *sq,
+		   struct mlx5e_ktls_offload_context_tx *priv_tx,
+		   bool fence)
+{
+	struct mlx5e_umr_wqe *umr_wqe;
+	u16 pi;
+
+	umr_wqe = mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_STATIC_UMR_WQE_SZ, &pi);
+	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, NULL);
+	sq->pc += MLX5E_KTLS_STATIC_WQEBBS;
+}
+
+static void
+post_progress_params(struct mlx5e_txqsq *sq,
+		     struct mlx5e_ktls_offload_context_tx *priv_tx,
+		     bool fence)
+{
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	wqe = mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_PROGRESS_WQE_SZ, &pi);
+	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, NULL);
+	sq->pc += MLX5E_KTLS_PROGRESS_WQEBBS;
+}
+
+static void
+mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
+			      struct mlx5e_ktls_offload_context_tx *priv_tx,
+			      bool skip_static_post, bool fence_first_post)
+{
+	bool progress_fence = skip_static_post || !fence_first_post;
+
+	if (!skip_static_post)
+		post_static_params(sq, priv_tx, fence_first_post);
+
+	post_progress_params(sq, priv_tx, progress_fence);
+}
+
+struct tx_sync_info {
+	u64 rcd_sn;
+	s32 sync_len;
+	int nr_frags;
+	skb_frag_t *frags[MAX_SKB_FRAGS];
+};
+
+static bool tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
+			     u32 tcp_seq, struct tx_sync_info *info)
+{
+	struct tls_offload_context_tx *tx_ctx = priv_tx->tx_ctx;
+	struct tls_record_info *record;
+	int remaining, i = 0;
+	unsigned long flags;
+	bool ret = true;
+
+	spin_lock_irqsave(&tx_ctx->lock, flags);
+	record = tls_get_record(tx_ctx, tcp_seq, &info->rcd_sn);
+
+	if (unlikely(!record)) {
+		ret = false;
+		goto out;
+	}
+
+	if (unlikely(tcp_seq < tls_record_start_seq(record))) {
+		if (!tls_record_is_start_marker(record))
+			ret = false;
+		goto out;
+	}
+
+	info->sync_len = tcp_seq - tls_record_start_seq(record);
+	remaining = info->sync_len;
+	while (remaining > 0) {
+		skb_frag_t *frag = &record->frags[i];
+
+		__skb_frag_ref(frag);
+		remaining -= skb_frag_size(frag);
+		info->frags[i++] = frag;
+	}
+	/* reduce the part which will be sent with the original SKB */
+	if (remaining < 0)
+		skb_frag_size_add(info->frags[i - 1], remaining);
+	info->nr_frags = i;
+out:
+	spin_unlock_irqrestore(&tx_ctx->lock, flags);
+	return ret;
+}
+
+static void
+tx_post_resync_params(struct mlx5e_txqsq *sq,
+		      struct mlx5e_ktls_offload_context_tx *priv_tx,
+		      u64 rcd_sn)
+{
+	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	__be64 rn_be = cpu_to_be64(rcd_sn);
+	bool skip_static_post;
+	u16 rec_seq_sz;
+	char *rec_seq;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		rec_seq = info->rec_seq;
+		rec_seq_sz = sizeof(info->rec_seq);
+		break;
+	}
+	default:
+		WARN_ON(1);
+	}
+
+	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
+	if (!skip_static_post)
+		memcpy(rec_seq, &rn_be, rec_seq_sz);
+
+	mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, skip_static_post, true);
+}
+
+static int
+tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		    skb_frag_t *frag, u32 tisn, bool first)
+{
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_wqe_eth_seg  *eseg;
+	struct mlx5_wqe_data_seg *dseg;
+	struct mlx5e_tx_wqe *wqe;
+	dma_addr_t dma_addr = 0;
+	u16 ds_cnt, ds_cnt_inl;
+	u8  num_wqebbs;
+	u16 pi, ihs;
+	int fsz;
+
+	ds_cnt = sizeof(*wqe) / MLX5_SEND_WQE_DS;
+	ihs    = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
+	ds_cnt_inl = DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
+	ds_cnt += ds_cnt_inl;
+	ds_cnt += 1; /* one frag */
+
+	wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
+
+	num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
+
+	cseg = &wqe->ctrl;
+	eseg = &wqe->eth;
+	dseg =  wqe->data;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP);
+	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
+	cseg->imm              = cpu_to_be32(tisn);
+	cseg->fm_ce_se         = first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	eseg->inline_hdr.sz = cpu_to_be16(ihs);
+	memcpy(eseg->inline_hdr.start, skb->data, ihs);
+	dseg += ds_cnt_inl;
+
+	fsz = skb_frag_size(frag);
+	dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
+				    DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+		return -ENOMEM;
+
+	dseg->addr       = cpu_to_be64(dma_addr);
+	dseg->lkey       = sq->mkey_be;
+	dseg->byte_count = cpu_to_be32(fsz);
+	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
+
+	tx_fill_wi(sq, pi, num_wqebbs, frag);
+	sq->pc += num_wqebbs;
+
+	WARN(num_wqebbs > MLX5E_KTLS_MAX_DUMP_WQEBBS,
+	     "unexpected DUMP num_wqebbs, %d > %d",
+	     num_wqebbs, MLX5E_KTLS_MAX_DUMP_WQEBBS);
+
+	return 0;
+}
+
+void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					   struct mlx5e_tx_wqe_info *wi,
+					   struct mlx5e_sq_dma *dma)
+{
+	struct mlx5e_sq_stats *stats = sq->stats;
+
+	mlx5e_tx_dma_unmap(sq->pdev, dma);
+	__skb_frag_unref(wi->resync_dump_frag);
+	stats->tls_dump_packets++;
+	stats->tls_dump_bytes += wi->num_bytes;
+}
+
+static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+
+	tx_fill_wi(sq, pi, 1, NULL);
+
+	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
+}
+
+static struct sk_buff *
+mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
+			 struct mlx5e_txqsq *sq,
+			 struct sk_buff *skb,
+			 u32 seq)
+{
+	struct mlx5e_sq_stats *stats = sq->stats;
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	struct tx_sync_info info = {};
+	u16 contig_wqebbs_room, pi;
+	u8 num_wqebbs;
+	int i;
+
+	if (!tx_sync_info_get(priv_tx, seq, &info)) {
+		/* We might get here if a retransmission reaches the driver
+		 * after the relevant record is acked.
+		 * It should be safe to drop the packet in this case
+		 */
+		stats->tls_drop_no_sync_data++;
+		goto err_out;
+	}
+
+	if (unlikely(info.sync_len < 0)) {
+		u32 payload;
+		int headln;
+
+		headln = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		payload = skb->len - headln;
+		if (likely(payload <= -info.sync_len))
+			return skb;
+
+		stats->tls_drop_bypass_req++;
+		goto err_out;
+	}
+
+	stats->tls_ooo++;
+
+	num_wqebbs = MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS +
+		(info.nr_frags ? info.nr_frags * MLX5E_KTLS_MAX_DUMP_WQEBBS : 1);
+	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs_room < num_wqebbs))
+		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
+
+	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
+
+	for (i = 0; i < info.nr_frags; i++)
+		if (tx_post_resync_dump(sq, skb, info.frags[i],
+					priv_tx->tisn, !i))
+			goto err_out;
+
+	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
+	 * actual data xmit.
+	 */
+	if (!info.nr_frags)
+		tx_post_fence_nop(sq);
+
+	return skb;
+
+err_out:
+	dev_kfree_skb_any(skb);
+	return NULL;
+}
+
+struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
+					 struct mlx5e_txqsq *sq,
+					 struct sk_buff *skb,
+					 struct mlx5e_tx_wqe **wqe, u16 *pi)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct mlx5e_sq_stats *stats = sq->stats;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct tls_context *tls_ctx;
+	int datalen;
+	u32 seq;
+
+	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
+		goto out;
+
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	if (!datalen)
+		goto out;
+
+	tls_ctx = tls_get_ctx(skb->sk);
+	if (unlikely(tls_ctx->netdev != netdev))
+		goto err_out;
+
+	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+
+	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
+		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
+		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+		stats->tls_ctx++;
+	}
+
+	seq = ntohl(tcp_hdr(skb)->seq);
+	if (unlikely(priv_tx->expected_seq != seq)) {
+		skb = mlx5e_ktls_tx_handle_ooo(priv_tx, sq, skb, seq);
+		if (unlikely(!skb))
+			goto out;
+		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+	}
+
+	priv_tx->expected_seq = seq + datalen;
+
+	cseg = &(*wqe)->ctrl;
+	cseg->imm = cpu_to_be32(priv_tx->tisn);
+
+	stats->tls_encrypted_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
+	stats->tls_encrypted_bytes   += datalen;
+
+out:
+	return skb;
+
+err_out:
+	dev_kfree_skb_any(skb);
+	return NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index dc15c5c9e557..f8b93b62a7d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -190,6 +190,11 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	u32 caps;
 
+	if (mlx5_accel_is_ktls_device(priv->mdev)) {
+		mlx5e_ktls_build_netdev(priv);
+		return;
+	}
+
 	if (!mlx5_accel_is_tls_device(priv->mdev))
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 3f5d72163b56..9015f3f7792d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -33,8 +33,10 @@
 #ifndef __MLX5E_TLS_H__
 #define __MLX5E_TLS_H__
 
-#ifdef CONFIG_MLX5_EN_TLS
+#include "accel/tls.h"
+#include "en_accel/ktls.h"
 
+#ifdef CONFIG_MLX5_EN_TLS
 #include <net/tls.h>
 #include "en.h"
 
@@ -94,7 +96,12 @@ struct mlx5e_tls_offload_context_rx {
 
 #else
 
-static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv) { }
+static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
+{
+	if (mlx5_accel_is_ktls_device(priv->mdev))
+		mlx5e_ktls_build_netdev(priv);
+}
+
 static inline int mlx5e_tls_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tls_cleanup(struct mlx5e_priv *priv) { }
 static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 7d191d98ac94..71384ad1a443 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -269,6 +269,11 @@ struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
 	int datalen;
 	u32 skb_seq;
 
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls)) {
+		skb = mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
+		goto out;
+	}
+
 	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 075496de00e5..83194d56434d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3156,6 +3156,9 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 
 	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.td.tdn);
 
+	if (MLX5_GET(tisc, tisc, tls_en))
+		MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.pdn);
+
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 5f540db47cc9..539b4d3656da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -48,8 +48,15 @@
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_nop) },
 
 #ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_no_sync_data) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_bypass_req) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_bytes) },
 #endif
 
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
@@ -271,8 +278,15 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 			s->tx_csum_none		+= sq_stats->csum_none;
 			s->tx_csum_partial	+= sq_stats->csum_partial;
 #ifdef CONFIG_MLX5_EN_TLS
-			s->tx_tls_ooo		+= sq_stats->tls_ooo;
-			s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
+			s->tx_tls_encrypted_packets += sq_stats->tls_encrypted_packets;
+			s->tx_tls_encrypted_bytes   += sq_stats->tls_encrypted_bytes;
+			s->tx_tls_ctx               += sq_stats->tls_ctx;
+			s->tx_tls_ooo               += sq_stats->tls_ooo;
+			s->tx_tls_resync_bytes      += sq_stats->tls_resync_bytes;
+			s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
+			s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
+			s->tx_tls_dump_bytes        += sq_stats->tls_dump_bytes;
+			s->tx_tls_dump_packets      += sq_stats->tls_dump_packets;
 #endif
 			s->tx_cqes		+= sq_stats->cqes;
 		}
@@ -1293,6 +1307,16 @@ static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
+#endif
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, dropped) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index fb3ad7231e11..76ac111e14d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -122,8 +122,15 @@ struct mlx5e_sw_stats {
 	u64 ch_eq_rearm;
 
 #ifdef CONFIG_MLX5_EN_TLS
+	u64 tx_tls_encrypted_packets;
+	u64 tx_tls_encrypted_bytes;
+	u64 tx_tls_ctx;
 	u64 tx_tls_ooo;
 	u64 tx_tls_resync_bytes;
+	u64 tx_tls_drop_no_sync_data;
+	u64 tx_tls_drop_bypass_req;
+	u64 tx_tls_dump_packets;
+	u64 tx_tls_dump_bytes;
 #endif
 
 	u64 rx_xsk_packets;
@@ -256,8 +263,15 @@ struct mlx5e_sq_stats {
 	u64 added_vlan_packets;
 	u64 nop;
 #ifdef CONFIG_MLX5_EN_TLS
+	u64 tls_encrypted_packets;
+	u64 tls_encrypted_bytes;
+	u64 tls_ctx;
 	u64 tls_ooo;
 	u64 tls_resync_bytes;
+	u64 tls_drop_no_sync_data;
+	u64 tls_drop_bypass_req;
+	u64 tls_dump_packets;
+	u64 tls_dump_bytes;
 #endif
 	/* less likely accessed in data path */
 	u64 csum_none;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 200301d6bac5..600e92cb629a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,6 +38,7 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/ktls.h"
 #include "lib/clock.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -321,11 +322,17 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 #ifdef CONFIG_MLX5_EN_IPSEC
 		struct mlx5_wqe_eth_seg cur_eth = wqe->eth;
 #endif
+#ifdef CONFIG_MLX5_EN_TLS
+		struct mlx5_wqe_ctrl_seg cur_ctrl = wqe->ctrl;
+#endif
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
 		wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
 #ifdef CONFIG_MLX5_EN_IPSEC
 		wqe->eth = cur_eth;
 #endif
+#ifdef CONFIG_MLX5_EN_TLS
+		wqe->ctrl = cur_ctrl;
+#endif
 	}
 
 	/* fill wqe */
@@ -473,6 +480,14 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			skb = wi->skb;
 
 			if (unlikely(!skb)) {
+#ifdef CONFIG_MLX5_EN_TLS
+				if (wi->resync_dump_frag) {
+					struct mlx5e_sq_dma *dma =
+						mlx5e_dma_get(sq, dma_fifo_cc++);
+
+					mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma);
+				}
+#endif
 				sqcc += wi->num_wqebbs;
 				continue;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index eb9680293b06..a19790dee7b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -239,6 +239,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, tls)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_TLS);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.1

