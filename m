Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C6C5DB2A2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIUSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIUSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0326715C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E846280F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4F5C433C1;
        Wed, 21 Sep 2022 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663783865;
        bh=nw+OwyGe+h55XqKzvQu93K7bYlaNJbKPLF9Ldg5D2Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+GIHU+O3kQ82UHCquQLFxx5LJaGssrIdmHOzA5SUnz7V9bB+iwgVU/9oTbIhuscl
         XItreFn8XOGLJrD3poQuppJO5JJzZ2Brq3mpA3FAET3Ii5M7GZC8jJc66cB8bvYShQ
         QINw+/ku/UKPJfikROGUVpdcDOYmi58qG2cxNy3O02TU4zIVGNTwurKOqQXLCsPl/T
         JoHsJhAgMJF+giUqomP4yoa+uw6U0PQ7rtOR1zm+JaN5Iy7AJSnL2KVCMJp5qAjsTl
         DtjDPh9coIC5W9odfV0PZp9SQlpOOjp5Wp+n0kzJHluK9d/ocnuZl0XyBKHO8acfoE
         f6ULPp7ltCUjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V3 07/10] net/mlx5e: Create advanced steering operation (ASO) object for MACsec
Date:   Wed, 21 Sep 2022 11:10:51 -0700
Message-Id: <20220921181054.40249-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
References: <20220921181054.40249-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Add support for ASO work queue entry (WQE) data to allow reading
data upon querying the ASO work queue (WQ).
Register user mode memory registration (UMR) upon ASO WQ init,
de-register UMR upon ASO WQ cleanup.
MACsec uses UMR to determine the cause of the event triggered
by the HW since different scenarios could trigger the same event.
Setup MACsec ASO object to sync HW with SW about various macsec
flow stateful features like: replay window, lifetime limits e.t.c

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 149 +++++++++++++++---
 1 file changed, 130 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 5162863fa630..5c051562d9f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -6,13 +6,11 @@
 #include <linux/xarray.h>
 
 #include "en.h"
+#include "lib/aso.h"
 #include "lib/mlx5.h"
 #include "en_accel/macsec.h"
 #include "en_accel/macsec_fs.h"
 
-#define MLX5_MACSEC_ASO_INC_SN  0x2
-#define MLX5_MACSEC_ASO_REG_C_4_5 0x2
-
 struct mlx5e_macsec_sa {
 	bool active;
 	u8  assoc_num;
@@ -43,6 +41,23 @@ struct mlx5e_macsec_rx_sc {
 	struct rcu_head rcu_head;
 };
 
+struct mlx5e_macsec_umr {
+	dma_addr_t dma_addr;
+	u8 ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
+	u32 mkey;
+};
+
+struct mlx5e_macsec_aso {
+	/* ASO */
+	struct mlx5_aso *maso;
+	/* Protects macsec ASO */
+	struct mutex aso_lock;
+	/* UMR */
+	struct mlx5e_macsec_umr *umr;
+
+	u32 pdn;
+};
+
 static const struct rhashtable_params rhash_sci = {
 	.key_len = sizeof_field(struct mlx5e_macsec_sa, sci),
 	.key_offset = offsetof(struct mlx5e_macsec_sa, sci),
@@ -65,9 +80,6 @@ struct mlx5e_macsec {
 	struct mlx5e_macsec_fs *macsec_fs;
 	struct mutex lock; /* Protects mlx5e_macsec internal contexts */
 
-	/* Global PD for MACsec object ASO context */
-	u32 aso_pdn;
-
 	/* Tx sci -> fs id mapping handling */
 	struct rhashtable sci_hash;      /* sci -> mlx5e_macsec_sa */
 
@@ -78,6 +90,9 @@ struct mlx5e_macsec {
 
 	/* Stats manage */
 	struct mlx5e_macsec_stats stats;
+
+	/* ASO */
+	struct mlx5e_macsec_aso aso;
 };
 
 struct mlx5_macsec_obj_attrs {
@@ -88,6 +103,55 @@ struct mlx5_macsec_obj_attrs {
 	bool encrypt;
 };
 
+static int mlx5e_macsec_aso_reg_mr(struct mlx5_core_dev *mdev, struct mlx5e_macsec_aso *aso)
+{
+	struct mlx5e_macsec_umr *umr;
+	struct device *dma_device;
+	dma_addr_t dma_addr;
+	int err;
+
+	umr = kzalloc(sizeof(*umr), GFP_KERNEL);
+	if (!umr) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	dma_device = &mdev->pdev->dev;
+	dma_addr = dma_map_single(dma_device, umr->ctx, sizeof(umr->ctx), DMA_BIDIRECTIONAL);
+	err = dma_mapping_error(dma_device, dma_addr);
+	if (err) {
+		mlx5_core_err(mdev, "Can't map dma device, err=%d\n", err);
+		goto out_dma;
+	}
+
+	err = mlx5e_create_mkey(mdev, aso->pdn, &umr->mkey);
+	if (err) {
+		mlx5_core_err(mdev, "Can't create mkey, err=%d\n", err);
+		goto out_mkey;
+	}
+
+	umr->dma_addr = dma_addr;
+
+	aso->umr = umr;
+
+	return 0;
+
+out_mkey:
+	dma_unmap_single(dma_device, dma_addr, sizeof(umr->ctx), DMA_BIDIRECTIONAL);
+out_dma:
+	kfree(umr);
+	return err;
+}
+
+static void mlx5e_macsec_aso_dereg_mr(struct mlx5_core_dev *mdev, struct mlx5e_macsec_aso *aso)
+{
+	struct mlx5e_macsec_umr *umr = aso->umr;
+
+	mlx5_core_destroy_mkey(mdev, umr->mkey);
+	dma_unmap_single(&mdev->pdev->dev, umr->dma_addr, sizeof(umr->ctx), DMA_BIDIRECTIONAL);
+	kfree(umr);
+}
+
 static int mlx5e_macsec_create_object(struct mlx5_core_dev *mdev,
 				      struct mlx5_macsec_obj_attrs *attrs,
 				      bool is_tx,
@@ -180,7 +244,7 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	obj_attrs.sci = cpu_to_be64((__force u64)sa->sci);
 	obj_attrs.enc_key_id = sa->enc_key_id;
 	obj_attrs.encrypt = encrypt;
-	obj_attrs.aso_pdn = macsec->aso_pdn;
+	obj_attrs.aso_pdn = macsec->aso.pdn;
 
 	err = mlx5e_macsec_create_object(mdev, &obj_attrs, is_tx, &sa->macsec_obj_id);
 	if (err)
@@ -1122,6 +1186,54 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	return err;
 }
 
+static int mlx5e_macsec_aso_init(struct mlx5e_macsec_aso *aso, struct mlx5_core_dev *mdev)
+{
+	struct mlx5_aso *maso;
+	int err;
+
+	err = mlx5_core_alloc_pd(mdev, &aso->pdn);
+	if (err) {
+		mlx5_core_err(mdev,
+			      "MACsec offload: Failed to alloc pd for MACsec ASO, err=%d\n",
+			      err);
+		return err;
+	}
+
+	maso = mlx5_aso_create(mdev, aso->pdn);
+	if (IS_ERR(maso)) {
+		err = PTR_ERR(maso);
+		goto err_aso;
+	}
+
+	err = mlx5e_macsec_aso_reg_mr(mdev, aso);
+	if (err)
+		goto err_aso_reg;
+
+	mutex_init(&aso->aso_lock);
+
+	aso->maso = maso;
+
+	return 0;
+
+err_aso_reg:
+	mlx5_aso_destroy(maso);
+err_aso:
+	mlx5_core_dealloc_pd(mdev, aso->pdn);
+	return err;
+}
+
+static void mlx5e_macsec_aso_cleanup(struct mlx5e_macsec_aso *aso, struct mlx5_core_dev *mdev)
+{
+	if (!aso)
+		return;
+
+	mlx5e_macsec_aso_dereg_mr(mdev, aso);
+
+	mlx5_aso_destroy(aso->maso);
+
+	mlx5_core_dealloc_pd(mdev, aso->pdn);
+}
+
 bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
 {
 	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
@@ -1272,14 +1384,6 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	INIT_LIST_HEAD(&macsec->macsec_device_list_head);
 	mutex_init(&macsec->lock);
 
-	err = mlx5_core_alloc_pd(mdev, &macsec->aso_pdn);
-	if (err) {
-		mlx5_core_err(mdev,
-			      "MACsec offload: Failed to alloc pd for MACsec ASO, err=%d\n",
-			      err);
-		goto err_pd;
-	}
-
 	err = rhashtable_init(&macsec->sci_hash, &rhash_sci);
 	if (err) {
 		mlx5_core_err(mdev, "MACsec offload: Failed to init SCI hash table, err=%d\n",
@@ -1287,6 +1391,12 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 		goto err_hash;
 	}
 
+	err = mlx5e_macsec_aso_init(&macsec->aso, priv->mdev);
+	if (err) {
+		mlx5_core_err(mdev, "MACsec offload: Failed to init aso, err=%d\n", err);
+		goto err_aso;
+	}
+
 	xa_init_flags(&macsec->sc_xarray, XA_FLAGS_ALLOC1);
 
 	priv->macsec = macsec;
@@ -1306,10 +1416,10 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	return 0;
 
 err_out:
+	mlx5e_macsec_aso_cleanup(&macsec->aso, priv->mdev);
+err_aso:
 	rhashtable_destroy(&macsec->sci_hash);
 err_hash:
-	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
-err_pd:
 	kfree(macsec);
 	priv->macsec = NULL;
 	return err;
@@ -1318,15 +1428,16 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_macsec *macsec = priv->macsec;
+	struct mlx5_core_dev *mdev = macsec->mdev;
 
 	if (!macsec)
 		return;
 
 	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
 
-	priv->macsec = NULL;
+	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
 
-	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
+	priv->macsec = NULL;
 
 	rhashtable_destroy(&macsec->sci_hash);
 
-- 
2.37.3

