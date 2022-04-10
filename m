Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03474FACC3
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiDJIbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiDJIb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77AE59A55;
        Sun, 10 Apr 2022 01:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A117B80AF9;
        Sun, 10 Apr 2022 08:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9EC385A8;
        Sun, 10 Apr 2022 08:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579353;
        bh=aw/G4mT2PW98DjnDIrM2nNnRF1894LWWYE56yz+SSEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5Qqh54PVtIpaNojfr1vmYeb701bi+tIo+gy21hxJuSU8g3sVJIZVZDJQDgGyQ2QV
         wbRB+EVG2mds3kyN0K43nkkiwi8L+xeXjckjvphwRciFlzfXXrQeT8M1okzDaEMbYV
         V3OyjQgbOX5A5sYOXZzK2AF+xyrChGmeX8Kj+dioAD2oqo6cpqNtbfrvMrqXySUlZg
         wWrlhwqqY9LW/JDM8Zr7fTs9Z/j1WIMhNQsCK0Qhvvxgd+hdur7XcBkc+Y4a9PNClq
         /6mZRJ2jVAKj0hvLMCnkok7WX8W6OuYiSOG6hLfIRpjKMDUi6KNqb23lLeNV7L9/+/
         +ihUcss3unmVA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 08/17] net/mlx5: Remove accel notations and indirections from esp functions
Date:   Sun, 10 Apr 2022 11:28:26 +0300
Message-Id: <5dbb20983539eba1040c893fca2f3b9f43882ce6.1649578827.git.leonro@nvidia.com>
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

This change cleanups the mlx5 esp interface.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  8 ++--
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  6 +--
 .../mlx5/core/en_accel/ipsec_offload.c        | 47 +++++--------------
 3 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 512a5ab9291d..792f01264196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -277,7 +277,7 @@ static void _update_xfrm_state(struct work_struct *work)
 	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
 		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
 
-	mlx5_accel_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
+	mlx5_ipsec_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
 }
 
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
@@ -311,7 +311,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 
 	/* create xfrm */
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
-	sa_entry->xfrm = mlx5_accel_esp_create_xfrm(priv->mdev, &attrs);
+	sa_entry->xfrm = mlx5_ipsec_esp_create_xfrm(priv->mdev, &attrs);
 	if (IS_ERR(sa_entry->xfrm)) {
 		err = PTR_ERR(sa_entry->xfrm);
 		goto err_sa_entry;
@@ -353,7 +353,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 err_hw_ctx:
 	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
-	mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
+	mlx5_ipsec_esp_destroy_xfrm(sa_entry->xfrm);
 err_sa_entry:
 	kfree(sa_entry);
 
@@ -379,7 +379,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 		mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
 					&sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
-		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
+		mlx5_ipsec_esp_destroy_xfrm(sa_entry->xfrm);
 	}
 
 	kfree(sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 71c7a7355473..84c8d835a26b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -196,10 +196,10 @@ void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
 struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+mlx5_ipsec_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+void mlx5_ipsec_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
+void mlx5_ipsec_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 #else
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 6c03ce8aba92..34410e929c08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -61,9 +61,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-static struct mlx5_accel_esp_xfrm *
-mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
-				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+struct mlx5_accel_esp_xfrm *
+mlx5_ipsec_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
 
@@ -74,10 +74,11 @@ mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
 	       sizeof(mxfrm->accel_xfrm.attrs));
 
+	mxfrm->accel_xfrm.mdev = mdev;
 	return &mxfrm->accel_xfrm;
 }
 
-static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+void mlx5_ipsec_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
 							 accel_xfrm);
@@ -275,14 +276,13 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void mlx5_ipsec_offload_esp_modify_xfrm(
-	struct mlx5_accel_esp_xfrm *xfrm,
-	const struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5_ipsec_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	int err = 0;
+	int err;
 
 	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
 
@@ -294,8 +294,10 @@ static void mlx5_ipsec_offload_esp_modify_xfrm(
 				    &ipsec_attrs,
 				    mxfrm->sa_ctx->ipsec_obj_id);
 
-	if (!err)
-		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
+	if (err)
+		return;
+
+	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
@@ -321,28 +323,3 @@ void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
 {
 	mlx5_ipsec_offload_delete_sa_ctx(context);
 }
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	struct mlx5_accel_esp_xfrm *xfrm;
-
-	xfrm = mlx5_ipsec_offload_esp_create_xfrm(mdev, attrs);
-	if (IS_ERR(xfrm))
-		return xfrm;
-
-	xfrm->mdev = mdev;
-	return xfrm;
-}
-
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
-{
-	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
-}
-
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-				const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
-}
-- 
2.35.1

