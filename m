Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C60647A98
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLIAOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLIAOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA32F8D1AD
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5947AB826A7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB81BC433D2;
        Fri,  9 Dec 2022 00:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544877;
        bh=4jI6cq829/giXw42OOsEmZWV/1zz3DXC388TYHkgboI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7jSKGWua5BnuE63CIHMcvRGjdnqgz7+HalrAbiPBM/qxc1bMYeX/MujCRHDFFoT0
         lsqvG9fEBG1kUZg+xpu+IRTft1fCwbvslSQsf5om3+/i7fZ22QlQNgYZpd1Zss21nu
         DHCVh+SZ18+eUd6zeu0vT3G17bCBoeqhWCx6RYYAuzeR1FUd2QkmNF01WZx7GZXGe8
         +NH66f1WSZID6d2H6VhiTZ2HSFkU/J47Y9thtgCoupUpIKnTL2Oy6X2XUEZBAu4K5C
         hU07efcdoDFkQhlYo/CVUT8wKDnzO3C12KuoO/nBIrZTwfbmlI+64gCVyd/cfa5zfn
         6aUUQqjramCyQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 06/15] net/mlx5: DR, Manage definers with refcounts
Date:   Thu,  8 Dec 2022 16:14:11 -0800
Message-Id: <20221209001420.142794-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In many cases different actions will ask for the same definer format.
Instead of allocating new definer general object and running out of
definers, have an xarray of allocated definers and keep track of their
usage with refcounts: allocate a new definer only when there isn't
one with the same format already created, and destroy definer only
when its refcount runs down to zero.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   1 +
 .../mellanox/mlx5/core/steering/dr_definer.c  | 151 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_domain.c   |   7 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |   1 +
 .../mellanox/mlx5/core/steering/mlx5dr.h      |   5 +
 5 files changed, 163 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a22c32aabf11..cd4a1ab0ea78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -111,6 +111,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste_v2.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o \
+					steering/dr_definer.o \
 					steering/dr_dbg.o lib/smfs.o
 #
 # SF device
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c
new file mode 100644
index 000000000000..d5ea97751945
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "dr_types.h"
+#include "dr_ste.h"
+
+struct dr_definer_object {
+	u32 id;
+	u16 format_id;
+	u8 dw_selectors[MLX5_IFC_DEFINER_DW_SELECTORS_NUM];
+	u8 byte_selectors[MLX5_IFC_DEFINER_BYTE_SELECTORS_NUM];
+	u8 match_mask[DR_STE_SIZE_MATCH_TAG];
+	refcount_t refcount;
+};
+
+static bool dr_definer_compare(struct dr_definer_object *definer,
+			       u16 format_id, u8 *dw_selectors,
+			       u8 *byte_selectors, u8 *match_mask)
+{
+	int i;
+
+	if (definer->format_id != format_id)
+		return false;
+
+	for (i = 0; i < MLX5_IFC_DEFINER_DW_SELECTORS_NUM; i++)
+		if (definer->dw_selectors[i] != dw_selectors[i])
+			return false;
+
+	for (i = 0; i < MLX5_IFC_DEFINER_BYTE_SELECTORS_NUM; i++)
+		if (definer->byte_selectors[i] != byte_selectors[i])
+			return false;
+
+	if (memcmp(definer->match_mask, match_mask, DR_STE_SIZE_MATCH_TAG))
+		return false;
+
+	return true;
+}
+
+static struct dr_definer_object *
+dr_definer_find_obj(struct mlx5dr_domain *dmn, u16 format_id,
+		    u8 *dw_selectors, u8 *byte_selectors, u8 *match_mask)
+{
+	struct dr_definer_object *definer_obj;
+	unsigned long id;
+
+	xa_for_each(&dmn->definers_xa, id, definer_obj) {
+		if (dr_definer_compare(definer_obj, format_id,
+				       dw_selectors, byte_selectors,
+				       match_mask))
+			return definer_obj;
+	}
+
+	return NULL;
+}
+
+static struct dr_definer_object *
+dr_definer_create_obj(struct mlx5dr_domain *dmn, u16 format_id,
+		      u8 *dw_selectors, u8 *byte_selectors, u8 *match_mask)
+{
+	struct dr_definer_object *definer_obj;
+	int ret = 0;
+
+	definer_obj = kzalloc(sizeof(*definer_obj), GFP_KERNEL);
+	if (!definer_obj)
+		return NULL;
+
+	ret = mlx5dr_cmd_create_definer(dmn->mdev,
+					format_id,
+					dw_selectors,
+					byte_selectors,
+					match_mask,
+					&definer_obj->id);
+	if (ret)
+		goto err_free_definer_obj;
+
+	/* Definer ID can have 32 bits, but STE format
+	 * supports only definers with 8 bit IDs.
+	 */
+	if (definer_obj->id > 0xff) {
+		mlx5dr_err(dmn, "Unsupported definer ID (%d)\n", definer_obj->id);
+		goto err_destroy_definer;
+	}
+
+	definer_obj->format_id = format_id;
+	memcpy(definer_obj->dw_selectors, dw_selectors, sizeof(definer_obj->dw_selectors));
+	memcpy(definer_obj->byte_selectors, byte_selectors, sizeof(definer_obj->byte_selectors));
+	memcpy(definer_obj->match_mask, match_mask, sizeof(definer_obj->match_mask));
+
+	refcount_set(&definer_obj->refcount, 1);
+
+	ret = xa_insert(&dmn->definers_xa, definer_obj->id, definer_obj, GFP_KERNEL);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Couldn't insert new definer into xarray (%d)\n", ret);
+		goto err_destroy_definer;
+	}
+
+	return definer_obj;
+
+err_destroy_definer:
+	mlx5dr_cmd_destroy_definer(dmn->mdev, definer_obj->id);
+err_free_definer_obj:
+	kfree(definer_obj);
+
+	return NULL;
+}
+
+static void dr_definer_destroy_obj(struct mlx5dr_domain *dmn,
+				   struct dr_definer_object *definer_obj)
+{
+	mlx5dr_cmd_destroy_definer(dmn->mdev, definer_obj->id);
+	xa_erase(&dmn->definers_xa, definer_obj->id);
+	kfree(definer_obj);
+}
+
+int mlx5dr_definer_get(struct mlx5dr_domain *dmn, u16 format_id,
+		       u8 *dw_selectors, u8 *byte_selectors,
+		       u8 *match_mask, u32 *definer_id)
+{
+	struct dr_definer_object *definer_obj;
+	int ret = 0;
+
+	definer_obj = dr_definer_find_obj(dmn, format_id, dw_selectors,
+					  byte_selectors, match_mask);
+	if (!definer_obj) {
+		definer_obj = dr_definer_create_obj(dmn, format_id,
+						    dw_selectors, byte_selectors,
+						    match_mask);
+		if (!definer_obj)
+			return -ENOMEM;
+	} else {
+		refcount_inc(&definer_obj->refcount);
+	}
+
+	*definer_id = definer_obj->id;
+
+	return ret;
+}
+
+void mlx5dr_definer_put(struct mlx5dr_domain *dmn, u32 definer_id)
+{
+	struct dr_definer_object *definer_obj;
+
+	definer_obj = xa_load(&dmn->definers_xa, definer_id);
+	if (!definer_obj) {
+		mlx5dr_err(dmn, "Definer ID %d not found\n", definer_id);
+		return;
+	}
+
+	if (refcount_dec_and_test(&definer_obj->refcount))
+		dr_definer_destroy_obj(dmn, definer_obj);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 9a9836218c8e..5b8bb2ca31e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -425,10 +425,11 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 	refcount_set(&dmn->refcount, 1);
 	mutex_init(&dmn->info.rx.mutex);
 	mutex_init(&dmn->info.tx.mutex);
+	xa_init(&dmn->definers_xa);
 
 	if (dr_domain_caps_init(mdev, dmn)) {
 		mlx5dr_err(dmn, "Failed init domain, no caps\n");
-		goto free_domain;
+		goto def_xa_destroy;
 	}
 
 	dmn->info.max_log_action_icm_sz = DR_CHUNK_SIZE_4K;
@@ -453,7 +454,8 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 
 uninit_caps:
 	dr_domain_caps_uninit(dmn);
-free_domain:
+def_xa_destroy:
+	xa_destroy(&dmn->definers_xa);
 	kfree(dmn);
 	return NULL;
 }
@@ -493,6 +495,7 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 	dr_domain_uninit_csum_recalc_fts(dmn);
 	dr_domain_uninit_resources(dmn);
 	dr_domain_caps_uninit(dmn);
+	xa_destroy(&dmn->definers_xa);
 	mutex_destroy(&dmn->info.tx.mutex);
 	mutex_destroy(&dmn->info.rx.mutex);
 	kfree(dmn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 804268b487d8..94093c3b55a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -925,6 +925,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_ste_ctx *ste_ctx;
 	struct list_head dbg_tbl_list;
 	struct mlx5dr_dbg_dump_info dump_info;
+	struct xarray definers_xa;
 };
 
 struct mlx5dr_table_rx_tx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 84ed77763b21..6ea50436ea61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -142,6 +142,11 @@ mlx5dr_action_create_aso(struct mlx5dr_domain *dmn,
 
 int mlx5dr_action_destroy(struct mlx5dr_action *action);
 
+int mlx5dr_definer_get(struct mlx5dr_domain *dmn, u16 format_id,
+		       u8 *dw_selectors, u8 *byte_selectors,
+		       u8 *match_mask, u32 *definer_id);
+void mlx5dr_definer_put(struct mlx5dr_domain *dmn, u32 definer_id);
+
 static inline bool
 mlx5dr_is_supported(struct mlx5_core_dev *dev)
 {
-- 
2.38.1

