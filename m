Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581F34F5C63
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiDFLh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiDFLhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:37:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC3D576804;
        Wed,  6 Apr 2022 01:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E0D560B70;
        Wed,  6 Apr 2022 08:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11E9C385A1;
        Wed,  6 Apr 2022 08:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233589;
        bh=yQ9jEqNyyooaqG7PApAHcHbpVv5AkSnPuXmTsU8kz+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaGV/R2wyMYDsvTUpEu1Iysqgng3lSnZAGjeVAW9Z1jX5jqYpk808cqFt8QI5Aq2p
         Z6SfQVOU5y8w9Ymvfr+C1yEFx2VK4MV4QMa1D9FRjyksYJnvBw8E+2eF4jUBUzXZNf
         P+c3C2jimAuDdI09HK36EqVZZAE5MGePt9t4yr4TGxrZaY3+/mRRvE3VhWu3X3WUwc
         OZCBtdMEwzp3JF2dDqfGGmPEMjkxA1RiXNrf7XmfMiqaeFf+s7R1CNOo/EALqXLGDJ
         PPQkAUqfJO9C7dymMHnci0R/I7s74+pAPVTQX5RzDB1RhlmHU0Hhml8O53blquVDFw
         7LOURQa6VT12A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 09/17] net/mlx5: Remove ipsec vs. ipsec offload file separation
Date:   Wed,  6 Apr 2022 11:25:44 +0300
Message-Id: <d0ac1fb7b14c10ae20a21ae17a393ee860c72ac3.1649232994.git.leonro@nvidia.com>
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

The IPsec won't be initialized at all if device doesn't support IPsec
offload. It means that we can combine the ipsec.c and ipsec_offload.c
files to one file. Such change will allow us to remove ipsec_ops
indirection.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c | 174 ------------------
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h |  96 ----------
 .../mellanox/mlx5/core/accel/ipsec_offload.c  | 145 ++++++++++++++-
 .../mellanox/mlx5/core/accel/ipsec_offload.h  |  61 +++++-
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 11 files changed, 205 insertions(+), 285 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e50361656305..ad852703a3cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -89,7 +89,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 # Accelerations & FPGA
 #
 mlx5_core-$(CONFIG_MLX5_IPSEC) += accel/ipsec_offload.o
-mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/ipsec.o
+mlx5_core-$(CONFIG_MLX5_ACCEL) += lib/crypto.o
 
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
deleted file mode 100644
index 387be13b2f1f..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
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
-#include <linux/mlx5/device.h>
-
-#include "accel/ipsec.h"
-#include "mlx5_core.h"
-#include "accel/ipsec_offload.h"
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
-		mlx5_core_warn_once(mdev, "Failed to start IPsec device, err = %d\n", err);
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
-u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->device_caps)
-		return 0;
-
-	return ipsec_ops->device_caps(mdev);
-}
-EXPORT_SYMBOL_GPL(mlx5_accel_ipsec_device_caps);
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
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-	__be32 saddr[4] = {}, daddr[4] = {};
-
-	if (!ipsec_ops || !ipsec_ops->create_hw_context)
-		return  ERR_PTR(-EOPNOTSUPP);
-
-	if (!xfrm->attrs.is_ipv6) {
-		saddr[3] = xfrm->attrs.saddr.a4;
-		daddr[3] = xfrm->attrs.daddr.a4;
-	} else {
-		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
-		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
-	}
-
-	return ipsec_ops->create_hw_context(mdev, xfrm, saddr, daddr, xfrm->attrs.spi,
-					    xfrm->attrs.is_ipv6, sa_handle);
-}
-
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->free_hw_context)
-		return;
-
-	ipsec_ops->free_hw_context(context);
-}
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
-	struct mlx5_accel_esp_xfrm *xfrm;
-
-	if (!ipsec_ops || !ipsec_ops->esp_create_xfrm)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	xfrm = ipsec_ops->esp_create_xfrm(mdev, attrs, 0);
-	if (IS_ERR(xfrm))
-		return xfrm;
-
-	xfrm->mdev = mdev;
-	return xfrm;
-}
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_create_xfrm);
-
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->esp_destroy_xfrm)
-		return;
-
-	ipsec_ops->esp_destroy_xfrm(xfrm);
-}
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_destroy_xfrm);
-
-int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
-
-	if (!ipsec_ops || !ipsec_ops->esp_modify_xfrm)
-		return -EOPNOTSUPP;
-
-	return ipsec_ops->esp_modify_xfrm(xfrm, attrs);
-}
-EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
deleted file mode 100644
index fbb9c5415d53..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
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
-#ifndef __MLX5_ACCEL_IPSEC_H__
-#define __MLX5_ACCEL_IPSEC_H__
-
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/accel.h>
-
-#ifdef CONFIG_MLX5_ACCEL
-
-#define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
-			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
-
-unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev);
-int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
-				   unsigned int count);
-
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
-
-void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
-void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
-
-struct mlx5_accel_ipsec_ops {
-	u32 (*device_caps)(struct mlx5_core_dev *mdev);
-	unsigned int (*counters_count)(struct mlx5_core_dev *mdev);
-	int (*counters_read)(struct mlx5_core_dev *mdev, u64 *counters, unsigned int count);
-	void* (*create_hw_context)(struct mlx5_core_dev *mdev,
-				   struct mlx5_accel_esp_xfrm *xfrm,
-				   const __be32 saddr[4], const __be32 daddr[4],
-				   const __be32 spi, bool is_ipv6, u32 *sa_handle);
-	void (*free_hw_context)(void *context);
-	int (*init)(struct mlx5_core_dev *mdev);
-	void (*cleanup)(struct mlx5_core_dev *mdev);
-	struct mlx5_accel_esp_xfrm* (*esp_create_xfrm)(struct mlx5_core_dev *mdev,
-						       const struct mlx5_accel_esp_xfrm_attrs *attrs,
-						       u32 flags);
-	int (*esp_modify_xfrm)(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
-	void (*esp_destroy_xfrm)(struct mlx5_accel_esp_xfrm *xfrm);
-};
-
-#else
-
-#define MLX5_IPSEC_DEV(mdev) false
-
-static inline void *
-mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				 struct mlx5_accel_esp_xfrm *xfrm,
-				 u32 *sa_handle)
-{
-	return NULL;
-}
-
-static inline void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context) {}
-
-static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
-
-static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
-
-#endif /* CONFIG_MLX5_ACCEL */
-
-#endif	/* __MLX5_ACCEL_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
index d6667d38e1de..3a85157f9f07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+/* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
-#include "ipsec_offload.h"
+#include "accel/ipsec_offload.h"
 #include "lib/mlx5.h"
 #include "en_accel/ipsec_fs.h"
 
@@ -376,10 +376,149 @@ static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
 	.esp_modify_xfrm = mlx5_ipsec_offload_esp_modify_xfrm,
 };
 
-const struct mlx5_accel_ipsec_ops *mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
+static const struct mlx5_accel_ipsec_ops *
+mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
 {
 	if (!mlx5_ipsec_offload_device_caps(mdev))
 		return NULL;
 
 	return &ipsec_offload_ops;
 }
+
+void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops;
+	int err = 0;
+
+	ipsec_ops = mlx5_ipsec_offload_ops(mdev);
+	if (!ipsec_ops || !ipsec_ops->init) {
+		mlx5_core_dbg(mdev, "IPsec ops is not supported\n");
+		return;
+	}
+
+	err = ipsec_ops->init(mdev);
+	if (err) {
+		mlx5_core_warn_once(
+			mdev, "Failed to start IPsec device, err = %d\n", err);
+		return;
+	}
+
+	mdev->ipsec_ops = ipsec_ops;
+}
+
+void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->cleanup)
+		return;
+
+	ipsec_ops->cleanup(mdev);
+}
+
+u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->device_caps)
+		return 0;
+
+	return ipsec_ops->device_caps(mdev);
+}
+EXPORT_SYMBOL_GPL(mlx5_accel_ipsec_device_caps);
+
+unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->counters_count)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->counters_count(mdev);
+}
+
+int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
+				   unsigned int count)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->counters_read)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->counters_read(mdev, counters, count);
+}
+
+void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+	__be32 saddr[4] = {}, daddr[4] = {};
+
+	if (!ipsec_ops || !ipsec_ops->create_hw_context)
+		return  ERR_PTR(-EOPNOTSUPP);
+
+	if (!xfrm->attrs.is_ipv6) {
+		saddr[3] = xfrm->attrs.saddr.a4;
+		daddr[3] = xfrm->attrs.daddr.a4;
+	} else {
+		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
+		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
+	}
+
+	return ipsec_ops->create_hw_context(mdev, xfrm, saddr, daddr,
+					    xfrm->attrs.spi,
+					    xfrm->attrs.is_ipv6, sa_handle);
+}
+
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->free_hw_context)
+		return;
+
+	ipsec_ops->free_hw_context(context);
+}
+
+struct mlx5_accel_esp_xfrm *
+mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+	struct mlx5_accel_esp_xfrm *xfrm;
+
+	if (!ipsec_ops || !ipsec_ops->esp_create_xfrm)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	xfrm = ipsec_ops->esp_create_xfrm(mdev, attrs, 0);
+	if (IS_ERR(xfrm))
+		return xfrm;
+
+	xfrm->mdev = mdev;
+	return xfrm;
+}
+EXPORT_SYMBOL_GPL(mlx5_accel_esp_create_xfrm);
+
+void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->esp_destroy_xfrm)
+		return;
+
+	ipsec_ops->esp_destroy_xfrm(xfrm);
+}
+EXPORT_SYMBOL_GPL(mlx5_accel_esp_destroy_xfrm);
+
+int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->esp_modify_xfrm)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->esp_modify_xfrm(xfrm, attrs);
+}
+EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
index 970c66d19c1d..4a7d49ed5604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
@@ -5,11 +5,46 @@
 #define __MLX5_IPSEC_OFFLOAD_H__
 
 #include <linux/mlx5/driver.h>
-#include "accel/ipsec.h"
+#include <linux/mlx5/accel.h>
 
 #ifdef CONFIG_MLX5_IPSEC
 
-const struct mlx5_accel_ipsec_ops *mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev);
+#define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
+			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
+
+unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev);
+int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
+				   unsigned int count);
+
+void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle);
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
+
+void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
+void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
+
+struct mlx5_accel_ipsec_ops {
+	u32 (*device_caps)(struct mlx5_core_dev *mdev);
+	unsigned int (*counters_count)(struct mlx5_core_dev *mdev);
+	int (*counters_read)(struct mlx5_core_dev *mdev, u64 *counters,
+			     unsigned int count);
+	void *(*create_hw_context)(struct mlx5_core_dev *mdev,
+				   struct mlx5_accel_esp_xfrm *xfrm,
+				   const __be32 saddr[4], const __be32 daddr[4],
+				   const __be32 spi, bool is_ipv6,
+				   u32 *sa_handle);
+	void (*free_hw_context)(void *context);
+	int (*init)(struct mlx5_core_dev *mdev);
+	void (*cleanup)(struct mlx5_core_dev *mdev);
+	struct mlx5_accel_esp_xfrm *(*esp_create_xfrm)(
+		struct mlx5_core_dev *mdev,
+		const struct mlx5_accel_esp_xfrm_attrs *attrs, u32 flags);
+	int (*esp_modify_xfrm)(struct mlx5_accel_esp_xfrm *xfrm,
+			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
+	void (*esp_destroy_xfrm)(struct mlx5_accel_esp_xfrm *xfrm);
+};
+
 static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
 {
 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
@@ -25,10 +60,26 @@ static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
 	return MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
 		MLX5_CAP_ETH(mdev, insert_trailer);
 }
-
 #else
-static inline const struct mlx5_accel_ipsec_ops *
-mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev) { return NULL; }
+
+#define MLX5_IPSEC_DEV(mdev) false
+
+static inline void *
+mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
+				 struct mlx5_accel_esp_xfrm *xfrm,
+				 u32 *sa_handle)
+{
+	return NULL;
+}
+
+static inline void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev,
+						  void *context)
+{
+}
+
+static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
+
+static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
 static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
 {
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index ebb12817b795..d2ec0961fe9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -5,7 +5,7 @@
 #include "en/txrx.h"
 #include "en/port.h"
 #include "en_accel/en_accel.h"
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 
 static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index ee50052cbcb8..eccc13b1338f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -40,7 +40,7 @@
 #include <net/xfrm.h>
 #include <linux/idr.h>
 
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 80886290fd22..87c42df3ee20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -35,7 +35,7 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 #include "fpga/sdk.h"
 #include "en_accel/ipsec.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 83365d04050b..346f7034fec8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -48,7 +48,7 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a180c80e9f68..f85eefaad6ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,7 +48,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 387602bbfecc..8fcbb1032b07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -62,7 +62,7 @@
 #include "lib/mlx5.h"
 #include "lib/tout.h"
 #include "fpga/core.h"
-#include "accel/ipsec.h"
+#include "accel/ipsec_offload.h"
 #include "lib/clock.h"
 #include "lib/vxlan.h"
 #include "lib/geneve.h"
-- 
2.35.1

