Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C665959FE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiHPLZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiHPLZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8BDEA168
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CA7160FAD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABBDC433D6;
        Tue, 16 Aug 2022 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646377;
        bh=i+/C9NPsLe5QP8E7i/4CfrCCy4yxga8BJyF676GkJKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEiykNhfSwaoDipgEMj4YBJN+67+mRdPno41CvEOehVmsUHQkBMYaGR3u1FgZE9eU
         sHCFHmEGiepHs564FLCM+uzPRc3O3pV28A5GSBL3jcnFuRWrzGTyIo6DzRcnileGjh
         4r1bKsPgWXkC98cWTlH0vvSG5cg2FAQW3eqHxA2U+ASSgqj9eWl8OhSUzyQhOtmwci
         2owCvDk/k3Yx7dP0ZCKKqEkWtE64o95fC0t6HbZEauNEFM6YmdPBp0Ob1iKEyfySfO
         Zw2hx0tNl+vYteWORzP4eZA4Q0UYTEpslVn0C5q6P0HJosnjgodwNcwE1ISoqwFbxX
         wJtcOgXyKDwxA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 11/26] net/mlx5e: Create Advanced Steering Operation object for IPsec
Date:   Tue, 16 Aug 2022 13:37:59 +0300
Message-Id: <afbcc0c5621ae15a1e05766ca111e66851ff4841.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

Setup the ASO (Advanced Steering Operation) object that is needed
for IPsec to interact with SW stack about various fast changing
events: replay window, lifetime limits,  e.t.c

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 11 +++++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  6 ++++
 .../mlx5/core/en_accel/ipsec_offload.c        | 30 +++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f8ba2d7581e4..f65305281ac4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -378,6 +378,12 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 		goto err_wq;
 	}
 
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_FULL_OFFLOAD) {
+		ret = mlx5e_ipsec_aso_init(ipsec);
+		if (ret)
+			goto err_aso;
+	}
+
 	ret = mlx5e_accel_ipsec_fs_init(ipsec);
 	if (ret)
 		goto err_fs_init;
@@ -388,6 +394,9 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	return 0;
 
 err_fs_init:
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_FULL_OFFLOAD)
+		mlx5e_ipsec_aso_cleanup(ipsec);
+err_aso:
 	destroy_workqueue(ipsec->wq);
 err_wq:
 	kfree(ipsec);
@@ -402,6 +411,8 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	mlx5e_accel_ipsec_fs_cleanup(ipsec);
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_FULL_OFFLOAD)
+		mlx5e_ipsec_aso_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 	kfree(ipsec);
 	priv->ipsec = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 3bba62f54604..2be7fb7db456 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -39,6 +39,7 @@
 #include <linux/mlx5/device.h>
 #include <net/xfrm.h>
 #include <linux/idr.h>
+#include "lib/aso.h"
 
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
@@ -107,6 +108,8 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_rx *rx_ipv4;
 	struct mlx5e_ipsec_rx *rx_ipv6;
 	struct mlx5e_ipsec_tx *tx;
+	struct mlx5_aso *aso;
+	u32 pdn;
 };
 
 struct mlx5e_ipsec_esn_state {
@@ -160,6 +163,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 
+int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
+void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
+
 static inline struct mlx5_core_dev *
 mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 1e586db009be..7ebdfe560398 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -211,3 +211,33 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
+
+int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	int err;
+
+	err = mlx5_core_alloc_pd(mdev, &ipsec->pdn);
+	if (err)
+		return err;
+
+	ipsec->aso = mlx5_aso_create(mdev, ipsec->pdn);
+	if (IS_ERR(ipsec->aso)) {
+		err = PTR_ERR(ipsec->aso);
+		goto err_aso_create;
+	}
+
+	return 0;
+
+err_aso_create:
+	mlx5_core_dealloc_pd(mdev, ipsec->pdn);
+	return err;
+}
+
+void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+
+	mlx5_aso_destroy(ipsec->aso);
+	mlx5_core_dealloc_pd(mdev, ipsec->pdn);
+}
-- 
2.37.2

