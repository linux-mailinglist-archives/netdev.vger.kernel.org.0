Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8B640EED
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiLBULl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiLBULU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B15BF3FB3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0673B8226A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC1C433C1;
        Fri,  2 Dec 2022 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011876;
        bh=rcS7N/tWTblgt66UxBdSTbRpNJEaHe46At2ngywxkIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4PKE+3uUT98TL1RjxiP/RAB1hhgmUov0NiueodO0plWA06zF2tKoDsmBNHnc4Wnu
         5c/PhQxfHvbzmeW3IGcjgBL9FKvh/98whwFtMxEN4heIN94+WTfSj0aO3Lwo3lUv+F
         LkdWlResnt6qvn8w89jj7YOQBBjXd9M5g+/mA8nzEIJK5FMHVUsOAOcKyg0QGqD7P0
         +K1+zcEXLolkkBs9Pt7pMPrD4f/zga14s/nPnNPDG+JYEekNLa804QZlsWNwdNQurF
         vtRwD47A9RrSvOIGUuKnl0dTawCKIcm+1B+dRMsfR6XBnezca7ns00Pn/keFemUmv/
         y/jMIlVQwOPmQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 09/16] net/mlx5e: Create Advanced Steering Operation object for IPsec
Date:   Fri,  2 Dec 2022 22:10:30 +0200
Message-Id: <610c0789dee22247c2601d6245e2162ec5b87050.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Setup the ASO (Advanced Steering Operation) object that is needed
for IPsec to interact with SW stack about various fast changing
events: replay window, lifetime limits,  e.t.c

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 12 +++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 13 +++++
 .../mlx5/core/en_accel/ipsec_offload.c        | 54 +++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 65790ff58a74..2d77fb8a8a01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1245,4 +1245,5 @@ int mlx5e_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate, int max_t
 int mlx5e_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivi);
 int mlx5e_get_vf_stats(struct net_device *dev, int vf, struct ifla_vf_stats *vf_stats);
 #endif
+int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey);
 #endif /* __MLX5_EN_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f518322c1ac1..d2c814e7af97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -373,6 +373,13 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	if (!ipsec->wq)
 		goto err_wq;
 
+	if (mlx5_ipsec_device_caps(priv->mdev) &
+	    MLX5_IPSEC_CAP_PACKET_OFFLOAD) {
+		ret = mlx5e_ipsec_aso_init(ipsec);
+		if (ret)
+			goto err_aso;
+	}
+
 	ret = mlx5e_accel_ipsec_fs_init(ipsec);
 	if (ret)
 		goto err_fs_init;
@@ -383,6 +390,9 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	return;
 
 err_fs_init:
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+		mlx5e_ipsec_aso_cleanup(ipsec);
+err_aso:
 	destroy_workqueue(ipsec->wq);
 err_wq:
 	kfree(ipsec);
@@ -398,6 +408,8 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	mlx5e_accel_ipsec_fs_cleanup(ipsec);
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+		mlx5e_ipsec_aso_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 	kfree(ipsec);
 	priv->ipsec = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index db0ccf2a797a..8e2f88f269ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -39,6 +39,7 @@
 #include <linux/mlx5/device.h>
 #include <net/xfrm.h>
 #include <linux/idr.h>
+#include "lib/aso.h"
 
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
@@ -97,6 +98,14 @@ struct mlx5e_ipsec_sw_stats {
 struct mlx5e_ipsec_rx;
 struct mlx5e_ipsec_tx;
 
+struct mlx5e_ipsec_aso {
+	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
+	dma_addr_t dma_addr;
+	struct mlx5_aso *aso;
+	u32 pdn;
+	u32 mkey;
+};
+
 struct mlx5e_ipsec {
 	struct mlx5_core_dev *mdev;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
@@ -107,6 +116,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_rx *rx_ipv4;
 	struct mlx5e_ipsec_rx *rx_ipv6;
 	struct mlx5e_ipsec_tx *tx;
+	struct mlx5e_ipsec_aso *aso;
 };
 
 struct mlx5e_ipsec_esn_state {
@@ -160,6 +170,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 
+int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
+void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
+
 static inline struct mlx5_core_dev *
 mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 3f2aeb07ea84..7fef5de55229 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
+#include "en.h"
 #include "ipsec.h"
 #include "lib/mlx5.h"
 
@@ -207,3 +208,56 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
+
+int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	struct mlx5e_ipsec_aso *aso;
+	struct mlx5e_hw_objs *res;
+	struct device *pdev;
+	int err;
+
+	aso = kzalloc(sizeof(*ipsec->aso), GFP_KERNEL);
+	if (!aso)
+		return -ENOMEM;
+
+	res = &mdev->mlx5e_res.hw_objs;
+
+	pdev = mlx5_core_dma_dev(mdev);
+	aso->dma_addr = dma_map_single(pdev, aso->ctx, sizeof(aso->ctx),
+				       DMA_BIDIRECTIONAL);
+	err = dma_mapping_error(pdev, aso->dma_addr);
+	if (err)
+		goto err_dma;
+
+	aso->aso = mlx5_aso_create(mdev, res->pdn);
+	if (IS_ERR(aso->aso)) {
+		err = PTR_ERR(aso->aso);
+		goto err_aso_create;
+	}
+
+	ipsec->aso = aso;
+	return 0;
+
+err_aso_create:
+	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
+			 DMA_BIDIRECTIONAL);
+err_dma:
+	kfree(aso);
+	return err;
+}
+
+void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	struct mlx5e_ipsec_aso *aso;
+	struct device *pdev;
+
+	aso = ipsec->aso;
+	pdev = mlx5_core_dma_dev(mdev);
+
+	mlx5_aso_destroy(aso->aso);
+	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
+			 DMA_BIDIRECTIONAL);
+	kfree(aso);
+}
-- 
2.38.1

