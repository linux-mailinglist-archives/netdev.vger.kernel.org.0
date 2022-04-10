Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523894FACD4
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbiDJIbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbiDJIbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2C3130;
        Sun, 10 Apr 2022 01:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6093960EF2;
        Sun, 10 Apr 2022 08:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FAFC385A4;
        Sun, 10 Apr 2022 08:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579356;
        bh=iF2234Y/nNRwhOLi6R2r4203gbCkyMNKuczKCh9bSKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIhJDX1/QvdKadmSZCDaLM+Nbygc4fD3AiEdwzI7V9Sruad9ZySiXTbCc5vp/pOlZ
         nA9RWJRq+MLisd+t+jNZspZ+IHHOC0BPJ4rPuPtGI4Gi6cQ+nmUiUAjPO/I1qO4a+o
         D996CHkvqD1kfbYHaWgP9lMsN/S1uTB1HJpiTYUysnSu+PrLxBCdCHArPsmhc49ov/
         9Wm9EULdvluz7+nWbGLnFX6MWwYYmIUlm9MVLIoJgh0OvpJkWY7Mh7zGP+B2eOL2O0
         BTgmYsXM3wG6LWAu/l+hZLoKtXBwq1b8Fw6ge5qzG0kGzPBxUzp/pxQN4uQa04tQ9B
         SkD3YLmfTrR+A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 09/17] net/mlx5: Simplify HW context interfaces by using SA entry
Date:   Sun, 10 Apr 2022 11:28:27 +0300
Message-Id: <f60c7586f160c3b3fd81d480a0ad74dcbdf85b02.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

SA context logic used multiple structures to store same data
over and over. By simplifying the SA context interfaces, we
can remove extra structs.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  50 ++---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  27 ++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 182 ++++--------------
 3 files changed, 61 insertions(+), 198 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 792f01264196..1b65b0c3d02b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -63,9 +63,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
 	return ret;
 }
 
-static int  mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry,
-				    unsigned int handle)
+static int mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	unsigned int handle = sa_entry->ipsec_obj_id;
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5e_ipsec_sa_entry *_sa_entry;
 	unsigned long flags;
@@ -277,16 +277,14 @@ static void _update_xfrm_state(struct work_struct *work)
 	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
 		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
 
-	mlx5_ipsec_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
+	mlx5_ipsec_esp_modify_xfrm(sa_entry, &modify_work->attrs);
 }
 
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	struct net_device *netdev = x->xso.real_dev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
 	struct mlx5e_priv *priv;
-	unsigned int sa_handle;
 	int err;
 
 	priv = netdev_priv(netdev);
@@ -309,33 +307,20 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	/* check esn */
 	mlx5e_ipsec_update_esn_state(sa_entry);
 
-	/* create xfrm */
-	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
-	sa_entry->xfrm = mlx5_ipsec_esp_create_xfrm(priv->mdev, &attrs);
-	if (IS_ERR(sa_entry->xfrm)) {
-		err = PTR_ERR(sa_entry->xfrm);
-		goto err_sa_entry;
-	}
-
+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
 	/* create hw context */
-	sa_entry->hw_context =
-			mlx5_accel_esp_create_hw_context(priv->mdev,
-							 sa_entry->xfrm,
-							 &sa_handle);
-	if (IS_ERR(sa_entry->hw_context)) {
-		err = PTR_ERR(sa_entry->hw_context);
+	err = mlx5_ipsec_create_sa_ctx(sa_entry);
+	if (err)
 		goto err_xfrm;
-	}
 
-	sa_entry->ipsec_obj_id = sa_handle;
-	err = mlx5e_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+	err = mlx5e_ipsec_fs_add_rule(priv, &sa_entry->attrs,
 				      sa_entry->ipsec_obj_id,
 				      &sa_entry->ipsec_rule);
 	if (err)
 		goto err_hw_ctx;
 
 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
-		err = mlx5e_ipsec_sadb_rx_add(sa_entry, sa_handle);
+		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
 		if (err)
 			goto err_add_rule;
 	} else {
@@ -348,15 +333,11 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
-				&sa_entry->ipsec_rule);
+	mlx5e_ipsec_fs_del_rule(priv, &sa_entry->attrs, &sa_entry->ipsec_rule);
 err_hw_ctx:
-	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
+	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
-	mlx5_ipsec_esp_destroy_xfrm(sa_entry->xfrm);
-err_sa_entry:
 	kfree(sa_entry);
-
 out:
 	return err;
 }
@@ -374,14 +355,9 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
-	if (sa_entry->hw_context) {
-		cancel_work_sync(&sa_entry->modify_work.work);
-		mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
-					&sa_entry->ipsec_rule);
-		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
-		mlx5_ipsec_esp_destroy_xfrm(sa_entry->xfrm);
-	}
-
+	cancel_work_sync(&sa_entry->modify_work.work);
+	mlx5e_ipsec_fs_del_rule(priv, &sa_entry->attrs, &sa_entry->ipsec_rule);
+	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 84c8d835a26b..284b907549d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -102,11 +102,6 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 is_ipv6;
 };
 
-struct mlx5_accel_esp_xfrm {
-	struct mlx5_core_dev  *mdev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-};
-
 enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
 	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
@@ -162,11 +157,11 @@ struct mlx5e_ipsec_sa_entry {
 	unsigned int handle; /* Handle in SADB_RX */
 	struct xfrm_state *x;
 	struct mlx5e_ipsec *ipsec;
-	struct mlx5_accel_esp_xfrm *xfrm;
-	void *hw_context;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
 	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
 			  struct xfrm_offload *xo);
 	u32 ipsec_obj_id;
+	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5e_ipsec_modify_state_work modify_work;
 };
@@ -188,19 +183,19 @@ void mlx5e_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 			     struct mlx5_accel_esp_xfrm_attrs *attrs,
 			     struct mlx5e_ipsec_rule *ipsec_rule);
 
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
-struct mlx5_accel_esp_xfrm *
-mlx5_ipsec_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
-void mlx5_ipsec_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-void mlx5_ipsec_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+void mlx5_ipsec_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
+
+static inline struct mlx5_core_dev *
+mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	return sa_entry->ipsec->mdev;
+}
 #else
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 34410e929c08..d3585c8c876b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -5,21 +5,6 @@
 #include "ipsec.h"
 #include "lib/mlx5.h"
 
-struct mlx5_ipsec_sa_ctx {
-	struct rhash_head hash;
-	u32 enc_key_id;
-	u32 ipsec_obj_id;
-	/* hw ctx */
-	struct mlx5_core_dev *dev;
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-};
-
-struct mlx5_ipsec_esp_xfrm {
-	/* reference counter of SA ctx */
-	struct mlx5_ipsec_sa_ctx *sa_ctx;
-	struct mlx5_accel_esp_xfrm accel_xfrm;
-};
-
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
 	u32 caps;
@@ -61,43 +46,11 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-struct mlx5_accel_esp_xfrm *
-mlx5_ipsec_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-
-	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
-	if (!mxfrm)
-		return ERR_PTR(-ENOMEM);
-
-	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
-	       sizeof(mxfrm->accel_xfrm.attrs));
-
-	mxfrm->accel_xfrm.mdev = mdev;
-	return &mxfrm->accel_xfrm;
-}
-
-void mlx5_ipsec_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
-							 accel_xfrm);
-
-	kfree(mxfrm);
-}
-
-struct mlx5_ipsec_obj_attrs {
-	const struct aes_gcm_keymat *aes_gcm;
-	u32 accel_flags;
-	u32 esn_msb;
-	u32 enc_key_id;
-};
-
-static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
-				 struct mlx5_ipsec_obj_attrs *attrs,
-				 u32 *ipsec_id)
-{
-	const struct aes_gcm_keymat *aes_gcm = attrs->aes_gcm;
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
@@ -128,14 +81,14 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
-		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
-		if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
+		if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 			MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
 	}
 
-	MLX5_SET(ipsec_obj, obj, dekn, attrs->enc_key_id);
+	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
@@ -145,13 +98,15 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
 
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
-		*ipsec_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+		sa_entry->ipsec_obj_id =
+			MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
 
 	return err;
 }
 
-static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
+static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 
@@ -159,79 +114,52 @@ static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
 		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
 
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
-					      struct mlx5_accel_esp_xfrm *accel_xfrm,
-					      const __be32 saddr[4], const __be32 daddr[4],
-					      const __be32 spi, bool is_ipv6, u32 *hw_handle)
+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_accel_esp_xfrm_attrs *xfrm_attrs = &accel_xfrm->attrs;
-	struct aes_gcm_keymat *aes_gcm = &xfrm_attrs->keymat.aes_gcm;
-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	struct mlx5_ipsec_sa_ctx *sa_ctx;
+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	int err;
 
-	/* alloc SA context */
-	sa_ctx = kzalloc(sizeof(*sa_ctx), GFP_KERNEL);
-	if (!sa_ctx)
-		return ERR_PTR(-ENOMEM);
-
-	sa_ctx->dev = mdev;
-
-	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-	sa_ctx->mxfrm = mxfrm;
-
 	/* key */
 	err = mlx5_create_encryption_key(mdev, aes_gcm->aes_key,
 					 aes_gcm->key_len / BITS_PER_BYTE,
 					 MLX5_ACCEL_OBJ_IPSEC_KEY,
-					 &sa_ctx->enc_key_id);
+					 &sa_entry->enc_key_id);
 	if (err) {
 		mlx5_core_dbg(mdev, "Failed to create encryption key (err = %d)\n", err);
-		goto err_sa_ctx;
+		return err;
 	}
 
-	ipsec_attrs.aes_gcm = aes_gcm;
-	ipsec_attrs.accel_flags = accel_xfrm->attrs.flags;
-	ipsec_attrs.esn_msb = accel_xfrm->attrs.esn;
-	ipsec_attrs.enc_key_id = sa_ctx->enc_key_id;
-	err = mlx5_create_ipsec_obj(mdev, &ipsec_attrs,
-				    &sa_ctx->ipsec_obj_id);
+	err = mlx5_create_ipsec_obj(sa_entry);
 	if (err) {
 		mlx5_core_dbg(mdev, "Failed to create IPsec object (err = %d)\n", err);
 		goto err_enc_key;
 	}
 
-	*hw_handle = sa_ctx->ipsec_obj_id;
-	mxfrm->sa_ctx = sa_ctx;
-
-	return sa_ctx;
+	return 0;
 
 err_enc_key:
-	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
-err_sa_ctx:
-	kfree(sa_ctx);
-	return ERR_PTR(err);
+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
+	return err;
 }
 
-static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 
-	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
-	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
-	kfree(sa_ctx);
+	mlx5_destroy_ipsec_obj(sa_entry);
+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
 }
 
-static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
-				 struct mlx5_ipsec_obj_attrs *attrs,
-				 u32 ipsec_id)
+static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
+				 const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	u32 in[MLX5_ST_SZ_DW(modify_ipsec_obj_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(query_ipsec_obj_out)];
 	u64 modify_field_select = 0;
@@ -239,7 +167,7 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	void *obj;
 	int err;
 
-	if (!(attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
+	if (!(attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
 		return 0;
 
 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
@@ -249,11 +177,11 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_IPSEC);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (err) {
 		mlx5_core_err(mdev, "Query IPsec object failed (Object id %d), err = %d\n",
-			      ipsec_id, err);
+			      sa_entry->ipsec_obj_id, err);
 		return err;
 	}
 
@@ -266,8 +194,8 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 		return -EOPNOTSUPP;
 
 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
-	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
 
 	/* general object fields set */
@@ -276,50 +204,14 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-void mlx5_ipsec_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+void mlx5_ipsec_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
-	struct mlx5_core_dev *mdev = xfrm->mdev;
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
 	int err;
 
-	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-
-	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
-	/* modify device with new hw_sa */
-	ipsec_attrs.accel_flags = attrs->flags;
-	ipsec_attrs.esn_msb = attrs->esn;
-	err = mlx5_modify_ipsec_obj(mdev,
-				    &ipsec_attrs,
-				    mxfrm->sa_ctx->ipsec_obj_id);
-
+	err = mlx5_modify_ipsec_obj(sa_entry, attrs);
 	if (err)
 		return;
 
-	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
-}
-
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle)
-{
-	__be32 saddr[4] = {}, daddr[4] = {};
-
-	if (!xfrm->attrs.is_ipv6) {
-		saddr[3] = xfrm->attrs.saddr.a4;
-		daddr[3] = xfrm->attrs.daddr.a4;
-	} else {
-		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
-		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
-	}
-
-	return mlx5_ipsec_offload_create_sa_ctx(mdev, xfrm, saddr, daddr,
-						xfrm->attrs.spi,
-						xfrm->attrs.is_ipv6, sa_handle);
-}
-
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
-{
-	mlx5_ipsec_offload_delete_sa_ctx(context);
+	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
-- 
2.35.1

