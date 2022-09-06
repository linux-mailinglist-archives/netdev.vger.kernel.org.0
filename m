Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929E5ADEF7
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiIFFVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiIFFVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1956CF65
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C970B8161C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423F8C433D6;
        Tue,  6 Sep 2022 05:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441705;
        bh=qyn7UtMhKy6/HFpCIMv4lbzjrp9uOsohYqTeUhA5pFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHAfkq/hdR/FNaOaLZjiQH26MM8RRIal6uSw+b2A6hy76xYudAFmKAJaaJnBlisKa
         /NjyZ7ZSLwmFxQcm+8Q0wGU/xE+0vaGi1vyQnNms/m5ZCnQsjhxu34HU36WWV0Ktqx
         55cO/IXfnLtzsQf9FS9AMPsMOIAinpH0XA6Np1ygfSyG7RE/RdllMBkXjKEhGwIZ5B
         k5x8Kt6LXohV9Y/ioSIVRXzCtBNCkFaHY2ebgjxiOHfvYyFEa1xOlibDeiWL3oVq14
         tDv/3Gh4ql+lm7PT7N/Dg48USdrD76j44OZHh94nypr1XqHYP1yBSROtL90LwoHi4o
         2dqGqZShR7/5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
Date:   Mon,  5 Sep 2022 22:21:19 -0700
Message-Id: <20220906052129.104507-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

This patch adds support for Connect-X MACsec offload Tx SA commands:
add, update and delete.

In Connect-X MACsec, a Security Association (SA) is added or deleted
via allocating a HW context of an encryption/decryption key and
a HW context of a matching SA (MACsec object).

When new SA is added:
- Use a separate crypto key HW context.
- Create a separate MACsec context in HW to include the SA properties.

Introduce a new compilation flag MLX5_EN_MACSEC for it.

Follow-up patches will implement the Tx steering.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +
 .../mellanox/mlx5/core/en_accel/macsec.c      | 385 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/macsec.h      |  26 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   7 +
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 9 files changed, 440 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index bfc0cd5ec423..26685fd0fdaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -139,6 +139,14 @@ config MLX5_CORE_IPOIB
 	help
 	  MLX5 IPoIB offloads & acceleration support.
 
+config MLX5_EN_MACSEC
+	bool "Connect-X support for MACSec offload"
+	depends on MLX5_CORE_EN
+	depends on MACSEC
+	default n
+	help
+	  Build support for MACsec cryptography-offload acceleration in the NIC.
+
 config MLX5_EN_IPSEC
 	bool "Mellanox Technologies IPsec Connect-X support"
 	depends on MLX5_CORE_EN
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a3773a8177ed..dd4b44a54712 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -92,6 +92,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
+mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o
+
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
 				     en_accel/ipsec_offload.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e464024481b4..13aac5131ff7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -954,6 +954,9 @@ struct mlx5e_priv {
 
 	const struct mlx5e_profile *profile;
 	void                      *ppriv;
+#ifdef CONFIG_MLX5_EN_MACSEC
+	struct mlx5e_macsec       *macsec;
+#endif
 #ifdef CONFIG_MLX5_EN_IPSEC
 	struct mlx5e_ipsec        *ipsec;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
new file mode 100644
index 000000000000..f23ff25b2a1b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/mlx5/device.h>
+#include <linux/mlx5/mlx5_ifc.h>
+
+#include "en.h"
+#include "lib/mlx5.h"
+#include "en_accel/macsec.h"
+
+#define MLX5_MACSEC_ASO_INC_SN  0x2
+#define MLX5_MACSEC_ASO_REG_C_4_5 0x2
+
+struct mlx5e_macsec_sa {
+	bool active;
+	u8  assoc_num;
+	u32 macsec_obj_id;
+	u32 enc_key_id;
+	u32 next_pn;
+	sci_t sci;
+};
+
+struct mlx5e_macsec {
+	struct mlx5e_macsec_sa *tx_sa[MACSEC_NUM_AN];
+	struct mutex lock; /* Protects mlx5e_macsec internal contexts */
+
+	/* Global PD for MACsec object ASO context */
+	u32 aso_pdn;
+
+	struct mlx5_core_dev *mdev;
+};
+
+struct mlx5_macsec_obj_attrs {
+	u32 aso_pdn;
+	u32 next_pn;
+	__be64 sci;
+	u32 enc_key_id;
+	bool encrypt;
+};
+
+static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
+				      struct mlx5_macsec_obj_attrs *attrs,
+				      u32 *macsec_obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_macsec_obj_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	void *aso_ctx;
+	void *obj;
+	int err;
+
+	obj = MLX5_ADDR_OF(create_macsec_obj_in, in, macsec_object);
+	aso_ctx = MLX5_ADDR_OF(macsec_offload_obj, obj, macsec_aso);
+
+	MLX5_SET(macsec_offload_obj, obj, confidentiality_en, attrs->encrypt);
+	MLX5_SET(macsec_offload_obj, obj, dekn, attrs->enc_key_id);
+	MLX5_SET64(macsec_offload_obj, obj, sci, (__force u64)(attrs->sci));
+	MLX5_SET(macsec_offload_obj, obj, aso_return_reg, MLX5_MACSEC_ASO_REG_C_4_5);
+	MLX5_SET(macsec_offload_obj, obj, macsec_aso_access_pd, attrs->aso_pdn);
+
+	MLX5_SET(macsec_aso, aso_ctx, valid, 0x1);
+	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_INC_SN);
+	MLX5_SET(macsec_aso, aso_ctx, mode_parameter, attrs->next_pn);
+
+	/* general object fields set */
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_MACSEC);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err) {
+		mlx5_core_err(mdev,
+			      "MACsec offload: Failed to create MACsec object (err = %d)\n",
+			      err);
+		return err;
+	}
+
+	*macsec_obj_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	return err;
+}
+
+static void mlx5e_macsec_destroy_object(struct mlx5_core_dev *mdev, u32 macsec_obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_MACSEC);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, macsec_obj_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static void mlx5e_macsec_cleanup_object(struct mlx5e_macsec *macsec,
+					struct mlx5e_macsec_sa *sa)
+{
+	mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
+}
+
+static int mlx5e_macsec_init_object(struct macsec_context *ctx,
+				    struct mlx5e_macsec_sa *sa,
+				    bool encrypt)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_macsec *macsec = priv->macsec;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_macsec_obj_attrs obj_attrs;
+	int err;
+
+	obj_attrs.next_pn = sa->next_pn;
+	obj_attrs.sci = cpu_to_be64((__force u64)sa->sci);
+	obj_attrs.enc_key_id = sa->enc_key_id;
+	obj_attrs.encrypt = encrypt;
+	obj_attrs.aso_pdn = macsec->aso_pdn;
+
+	err = mlx5e_macsec_create_object(mdev, &obj_attrs, &sa->macsec_obj_id);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
+	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	const struct macsec_secy *secy = ctx->secy;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_sa *tx_sa;
+	struct mlx5e_macsec *macsec;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+
+	if (macsec->tx_sa[assoc_num]) {
+		netdev_err(ctx->netdev, "MACsec offload tx_sa: %d already exist\n", assoc_num);
+		err = -EEXIST;
+		goto out;
+	}
+
+	tx_sa = kzalloc(sizeof(*tx_sa), GFP_KERNEL);
+	if (!tx_sa) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	macsec->tx_sa[assoc_num] = tx_sa;
+
+	tx_sa->active = ctx_tx_sa->active;
+	tx_sa->next_pn = ctx_tx_sa->next_pn_halves.lower;
+	tx_sa->sci = secy->sci;
+	tx_sa->assoc_num = assoc_num;
+
+	err = mlx5_create_encryption_key(mdev, ctx->sa.key, secy->key_len,
+					 MLX5_ACCEL_OBJ_MACSEC_KEY,
+					 &tx_sa->enc_key_id);
+	if (err)
+		goto destroy_sa;
+
+	if (!secy->operational ||
+	    assoc_num != tx_sc->encoding_sa ||
+	    !tx_sa->active)
+		goto out;
+
+	err = mlx5e_macsec_init_object(ctx, tx_sa, tx_sc->encrypt);
+	if (err)
+		goto destroy_encryption_key;
+
+	mutex_unlock(&macsec->lock);
+
+	return 0;
+
+destroy_encryption_key:
+	mlx5_destroy_encryption_key(mdev, tx_sa->enc_key_id);
+destroy_sa:
+	kfree(tx_sa);
+	macsec->tx_sa[assoc_num] = NULL;
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
+	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_sa *tx_sa;
+	struct mlx5e_macsec *macsec;
+	struct net_device *netdev;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	tx_sa = macsec->tx_sa[assoc_num];
+	netdev = ctx->netdev;
+
+	if (!tx_sa) {
+		netdev_err(netdev, "MACsec offload: TX sa 0x%x doesn't exist\n", assoc_num);
+
+		err = -EEXIST;
+		goto out;
+	}
+
+	if (tx_sa->next_pn != ctx_tx_sa->next_pn_halves.lower) {
+		netdev_err(netdev, "MACsec offload: update TX sa %d PN isn't supported\n",
+			   assoc_num);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (tx_sa->active == ctx_tx_sa->active)
+		goto out;
+
+	if (tx_sa->assoc_num != tx_sc->encoding_sa)
+		goto out;
+
+	if (ctx_tx_sa->active) {
+		err = mlx5e_macsec_init_object(ctx, tx_sa, tx_sc->encrypt);
+		if (err)
+			goto out;
+	} else {
+		mlx5e_macsec_cleanup_object(macsec, tx_sa);
+	}
+
+	tx_sa->active = ctx_tx_sa->active;
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u8 assoc_num = ctx->sa.assoc_num;
+	struct mlx5e_macsec_sa *tx_sa;
+	struct mlx5e_macsec *macsec;
+	int err = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	mutex_lock(&priv->macsec->lock);
+
+	macsec = priv->macsec;
+	tx_sa = macsec->tx_sa[ctx->sa.assoc_num];
+
+	if (!tx_sa) {
+		netdev_err(ctx->netdev, "MACsec offload: TX sa 0x%x doesn't exist\n", assoc_num);
+		err = -EEXIST;
+		goto out;
+	}
+
+	mlx5e_macsec_cleanup_object(macsec, tx_sa);
+
+	mlx5_destroy_encryption_key(mdev, tx_sa->enc_key_id);
+
+	kfree(tx_sa);
+	macsec->tx_sa[assoc_num] = NULL;
+
+out:
+	mutex_unlock(&macsec->lock);
+
+	return err;
+}
+
+static bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
+{
+	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
+	    MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD))
+		return false;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_dek))
+		return false;
+
+	if (!MLX5_CAP_MACSEC(mdev, log_max_macsec_offload))
+		return false;
+
+	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mdev, macsec_decrypt) ||
+	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, reformat_remove_macsec))
+		return false;
+
+	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, macsec_encrypt) ||
+	    !MLX5_CAP_FLOWTABLE_NIC_TX(mdev, reformat_add_macsec))
+		return false;
+
+	if (!MLX5_CAP_MACSEC(mdev, macsec_crypto_esp_aes_gcm_128_encrypt) &&
+	    !MLX5_CAP_MACSEC(mdev, macsec_crypto_esp_aes_gcm_256_encrypt))
+		return false;
+
+	if (!MLX5_CAP_MACSEC(mdev, macsec_crypto_esp_aes_gcm_128_decrypt) &&
+	    !MLX5_CAP_MACSEC(mdev, macsec_crypto_esp_aes_gcm_256_decrypt))
+		return false;
+
+	return true;
+}
+
+static const struct macsec_ops macsec_offload_ops = {
+	.mdo_add_txsa = mlx5e_macsec_add_txsa,
+	.mdo_upd_txsa = mlx5e_macsec_upd_txsa,
+	.mdo_del_txsa = mlx5e_macsec_del_txsa,
+};
+
+void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+
+	if (!mlx5e_is_macsec_device(priv->mdev))
+		return;
+
+	/* Enable MACsec */
+	mlx5_core_dbg(priv->mdev, "mlx5e: MACsec acceleration enabled\n");
+	netdev->macsec_ops = &macsec_offload_ops;
+	netdev->features |= NETIF_F_HW_MACSEC;
+	netif_keep_dst(netdev);
+}
+
+int mlx5e_macsec_init(struct mlx5e_priv *priv)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_macsec *macsec = NULL;
+	int err;
+
+	if (!mlx5e_is_macsec_device(priv->mdev)) {
+		mlx5_core_dbg(mdev, "Not a MACsec offload device\n");
+		return 0;
+	}
+
+	macsec = kzalloc(sizeof(*macsec), GFP_KERNEL);
+	if (!macsec)
+		return -ENOMEM;
+
+	mutex_init(&macsec->lock);
+
+	err = mlx5_core_alloc_pd(mdev, &macsec->aso_pdn);
+	if (err) {
+		mlx5_core_err(mdev,
+			      "MACsec offload: Failed to alloc pd for MACsec ASO, err=%d\n",
+			      err);
+		goto err_pd;
+	}
+
+	priv->macsec = macsec;
+
+	macsec->mdev = mdev;
+
+	mlx5_core_dbg(mdev, "MACsec attached to netdevice\n");
+
+	return 0;
+
+err_pd:
+	kfree(macsec);
+	return err;
+}
+
+void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
+{
+	struct mlx5e_macsec *macsec = priv->macsec;
+
+	if (!macsec)
+		return;
+
+	priv->macsec = NULL;
+
+	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
+
+	mutex_destroy(&macsec->lock);
+
+	kfree(macsec);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
new file mode 100644
index 000000000000..1ef1f3e3932f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_ACCEL_MACSEC_H__
+#define __MLX5_EN_ACCEL_MACSEC_H__
+
+#ifdef CONFIG_MLX5_EN_MACSEC
+
+#include <linux/mlx5/driver.h>
+#include <net/macsec.h>
+
+struct mlx5e_priv;
+
+void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_macsec_init(struct mlx5e_priv *priv);
+void mlx5e_macsec_cleanup(struct mlx5e_priv *priv);
+
+#else
+
+static inline void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv) {}
+static inline int mlx5e_macsec_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_macsec_cleanup(struct mlx5e_priv *priv) {}
+
+#endif  /* CONFIG_MLX5_EN_MACSEC */
+
+#endif	/* __MLX5_ACCEL_EN_MACSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7c1a13738a58..905025a10a8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -45,6 +45,7 @@
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
+#include "en_accel/macsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
 #include "lib/vxlan.h"
@@ -4990,6 +4991,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
 	mlx5e_set_netdev_dev_addr(netdev);
+	mlx5e_macsec_build_netdev(priv);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_ktls_build_netdev(priv);
 }
@@ -5053,6 +5055,10 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	}
 	priv->fs = fs;
 
+	err = mlx5e_macsec_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);
+
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
@@ -5070,6 +5076,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
+	mlx5e_macsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 079fa44ada71..c63ce03e79e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -273,6 +273,13 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
+	    MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_MACSEC);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 2f536c5d30b1..032adb21ad4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -83,6 +83,7 @@ int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, voi
 enum {
 	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS,
 	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC,
+	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC,
 };
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c085b031abfc..1986f1c715b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1488,6 +1488,7 @@ static const int types[] = {
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
 	MLX5_CAP_DEV_SHAMPO,
+	MLX5_CAP_MACSEC,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
-- 
2.37.2

