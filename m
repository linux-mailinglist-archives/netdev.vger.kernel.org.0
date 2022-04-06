Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5661E4F5C8D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiDFLlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiDFLi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:38:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491B4578E88;
        Wed,  6 Apr 2022 01:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB9AFB82187;
        Wed,  6 Apr 2022 08:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38080C385A3;
        Wed,  6 Apr 2022 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233619;
        bh=jl68ebA1oZdjEMs41l00Kv1GT53yF/lkevdZqHRnLzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqlNT+yHnQuyjY2mgJjOeilloy/vLGBizI2UMf9VzyDxN5LaV/KkpJrQMKwiF+IE/
         jqG76wUhGeEMt9jazekwZmjNGUJE75FGLLPJmTE25ssajIWzg4bbS2IUYC2GsNiKZU
         MtWJ1HjIQ9wPbAqICXRji/O+GtD6DeUJr11ijpzYTokjwlLEnPfucZtIzAnbeIMBhu
         kxai/5khbSaJM8DFG+sAxv18CZi+C6rv7D8yrNTBdn3Q3T+U+d93BTNrdatrI5o6Dk
         qD3dByAWii7pD7B4IRJ+jvOFYak69hu8f5ZfEluFS8i6h89FDKme/2IauUxoXhWdt2
         4v0Onn1iPQO6g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 16/17] net/mlx5: Remove ipsec_ops function table
Date:   Wed,  6 Apr 2022 11:25:51 +0300
Message-Id: <bc8dd1c8a77b65dbf5e2cf92c813ffaca2505c5f.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

There is only one IPsec implementation and ipsec_ops is not needed
at all in this situation. Together with removal of ipsec_ops, we can
drop the entry checks as these functions are called for IPsec devices
only.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |   5 -
 .../mlx5/core/en_accel/ipsec_offload.c        | 118 ++----------------
 .../mlx5/core/en_accel/ipsec_offload.h        |  35 ------
 .../net/ethernet/mellanox/mlx5/core/main.c    |   4 -
 include/linux/mlx5/driver.h                   |   3 -
 5 files changed, 8 insertions(+), 157 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
index b3e23aa5beeb..b70953979709 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -9,7 +9,6 @@
 #include "ipsec_offload.h"
 #include "en/fs.h"
 
-#ifdef CONFIG_MLX5_EN_IPSEC
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
@@ -19,8 +18,4 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs,
 				   struct mlx5e_ipsec_rule *ipsec_rule);
-#else
-static inline void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv) {}
-static inline int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv) { return 0; }
-#endif
 #endif /* __MLX5_IPSEC_STEERING_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 7ae2d308139e..f0f44bd95cc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -106,8 +106,7 @@ mlx5_ipsec_offload_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
 
 static struct mlx5_accel_esp_xfrm *
 mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
-				   const struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   u32 flags)
+				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
 	int err = 0;
@@ -286,11 +285,6 @@ static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
 	mutex_unlock(&mxfrm->lock);
 }
 
-static int mlx5_ipsec_offload_init(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
 static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 				 struct mlx5_ipsec_obj_attrs *attrs,
 				 u32 ipsec_id)
@@ -378,86 +372,12 @@ static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 	return err;
 }
 
-static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
-	.create_hw_context = mlx5_ipsec_offload_create_sa_ctx,
-	.free_hw_context = mlx5_ipsec_offload_delete_sa_ctx,
-	.init = mlx5_ipsec_offload_init,
-	.esp_create_xfrm = mlx5_ipsec_offload_esp_create_xfrm,
-	.esp_destroy_xfrm = mlx5_ipsec_offload_esp_destroy_xfrm,
-	.esp_modify_xfrm = mlx5_ipsec_offload_esp_modify_xfrm,
-};
-
-static const struct mlx5_accel_ipsec_ops *
-mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
-{
-	if (!mlx5_ipsec_device_caps(mdev))
-		return NULL;
-
-	return &ipsec_offload_ops;
-}
-
-void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops;
-	int err = 0;
-
-	ipsec_ops = mlx5_ipsec_offload_ops(mdev);
-	if (!ipsec_ops || !ipsec_ops->init) {
-		mlx5_core_dbg(mdev, "IPsec ops is not supported\n");
-		return;
-	}
-
-	err = ipsec_ops->init(mdev);
-	if (err) {
-		mlx5_core_warn_once(
-			mdev, "Failed to start IPsec device, err = %d\n", err);
-		return;
-	}
-
-	mdev->ipsec_ops = ipsec_ops;
-}
-
-void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->cleanup)
-		return;
-
-	ipsec_ops->cleanup(mdev);
-}
-
-unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->counters_count)
-		return -EOPNOTSUPP;
-
-	return ipsec_ops->counters_count(mdev);
-}
-
-int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
-				   unsigned int count)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->counters_read)
-		return -EOPNOTSUPP;
-
-	return ipsec_ops->counters_read(mdev, counters, count);
-}
-
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 				       struct mlx5_accel_esp_xfrm *xfrm,
 				       u32 *sa_handle)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
 	__be32 saddr[4] = {}, daddr[4] = {};
 
-	if (!ipsec_ops || !ipsec_ops->create_hw_context)
-		return  ERR_PTR(-EOPNOTSUPP);
-
 	if (!xfrm->attrs.is_ipv6) {
 		saddr[3] = xfrm->attrs.saddr.a4;
 		daddr[3] = xfrm->attrs.daddr.a4;
@@ -466,59 +386,37 @@ void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
 	}
 
-	return ipsec_ops->create_hw_context(mdev, xfrm, saddr, daddr,
-					    xfrm->attrs.spi,
-					    xfrm->attrs.is_ipv6, sa_handle);
+	return mlx5_ipsec_offload_create_sa_ctx(mdev, xfrm, saddr, daddr,
+						xfrm->attrs.spi,
+						xfrm->attrs.is_ipv6, sa_handle);
 }
 
 void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->free_hw_context)
-		return;
-
-	ipsec_ops->free_hw_context(context);
+	mlx5_ipsec_offload_delete_sa_ctx(context);
 }
 
 struct mlx5_accel_esp_xfrm *
 mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
 	struct mlx5_accel_esp_xfrm *xfrm;
 
-	if (!ipsec_ops || !ipsec_ops->esp_create_xfrm)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	xfrm = ipsec_ops->esp_create_xfrm(mdev, attrs, 0);
+	xfrm = mlx5_ipsec_offload_esp_create_xfrm(mdev, attrs);
 	if (IS_ERR(xfrm))
 		return xfrm;
 
 	xfrm->mdev = mdev;
 	return xfrm;
 }
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_create_xfrm);
 
 void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->esp_destroy_xfrm)
-		return;
-
-	ipsec_ops->esp_destroy_xfrm(xfrm);
+	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
 }
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_destroy_xfrm);
 
 int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->esp_modify_xfrm)
-		return -EOPNOTSUPP;
-
-	return ipsec_ops->esp_modify_xfrm(xfrm, attrs);
+	return mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
 }
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
index 36e700b596d8..7dac104e6ef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
@@ -7,43 +7,8 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/accel.h>
 
-#ifdef CONFIG_MLX5_EN_IPSEC
-
-unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev);
-int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
-				   unsigned int count);
-
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 				       struct mlx5_accel_esp_xfrm *xfrm,
 				       u32 *sa_handle);
 void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
-
-void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
-void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
-
-struct mlx5_accel_ipsec_ops {
-	unsigned int (*counters_count)(struct mlx5_core_dev *mdev);
-	int (*counters_read)(struct mlx5_core_dev *mdev, u64 *counters,
-			     unsigned int count);
-	void *(*create_hw_context)(struct mlx5_core_dev *mdev,
-				   struct mlx5_accel_esp_xfrm *xfrm,
-				   const __be32 saddr[4], const __be32 daddr[4],
-				   const __be32 spi, bool is_ipv6,
-				   u32 *sa_handle);
-	void (*free_hw_context)(void *context);
-	int (*init)(struct mlx5_core_dev *mdev);
-	void (*cleanup)(struct mlx5_core_dev *mdev);
-	struct mlx5_accel_esp_xfrm *(*esp_create_xfrm)(
-		struct mlx5_core_dev *mdev,
-		const struct mlx5_accel_esp_xfrm_attrs *attrs, u32 flags);
-	int (*esp_modify_xfrm)(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
-	void (*esp_destroy_xfrm)(struct mlx5_accel_esp_xfrm *xfrm);
-};
-
-#else
-static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
-
-static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
-#endif /* CONFIG_MLX5_EN_IPSEC */
 #endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 032de078723c..d504c8cb8f96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1181,8 +1181,6 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fpga_start;
 	}
 
-	mlx5_accel_ipsec_init(dev);
-
 	err = mlx5_init_fs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to init flow steering\n");
@@ -1230,7 +1228,6 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_set_hca:
 	mlx5_cleanup_fs(dev);
 err_fs:
-	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
 	mlx5_rsc_dump_cleanup(dev);
@@ -1256,7 +1253,6 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_sf_hw_table_destroy(dev);
 	mlx5_vhca_event_stop(dev);
 	mlx5_cleanup_fs(dev);
-	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
 	mlx5_rsc_dump_cleanup(dev);
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5af53c035949..ff47d49d8be4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -777,9 +777,6 @@ struct mlx5_core_dev {
 	} roce;
 #ifdef CONFIG_MLX5_FPGA
 	struct mlx5_fpga_device *fpga;
-#endif
-#ifdef CONFIG_MLX5_EN_IPSEC
-	const struct mlx5_accel_ipsec_ops *ipsec_ops;
 #endif
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
-- 
2.35.1

