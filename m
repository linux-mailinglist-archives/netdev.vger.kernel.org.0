Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AAE3562C1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348590AbhDGEzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348549AbhDGEys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD50A613D4;
        Wed,  7 Apr 2021 04:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771280;
        bh=uwyIpI7rQTW8ipw4KSBPMycLPvZiSgauhx9/cKqbAXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MixXnWNBfZsVhyMG0jRy04z7pTUoe/2w0ew9i5rUuQuWaUsFjE0yhYSGFZmk41Ep2
         /mk3dy5kWSBigDth2d2xbOHCtvZ1ckhhewjVjV+IMvxLGlJ8e+tjAJdhHgs7f4ZrlW
         BeuqB0y30HOKBhEmcBrDvkd5umKgfNQGfMdaakIocW+JpXEGexWva2EJejNg4tbwVV
         9yHm+RTTRPbfNnsQKMz6OeE3Xm+ulG3TWPxrCO2phjbKbY2lePoGuTytMCGmcyuKSE
         mamESwl/zZlUBIzhTo2xoxDtdEs6N2yazT7Uu8VK4i0PQM70yNiyDSh2j6X/C5Z5cO
         8CEC4RoUzvd7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/13] net/mlx5e: TC, Add sampler restore handle API
Date:   Tue,  6 Apr 2021 21:54:18 -0700
Message-Id: <20210407045421.148987-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Use common object pool to create an object ID to map sample parameters.
Allocate a modify header action to write the object ID to reg_c0 lower
16 bits. Create a restore rule to pass the object ID to software. So
software can identify sampled packets via the object ID and send it to
userspace.

Aggregate the modify header action, restore rule and object ID to a
sample restore handle. Re-use identical sample restore handle for
the same object ID.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/sample.c  | 108 ++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 37e33670bb24..79a0e49b2799 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2021 Mellanox Technologies. */
 
+#include <linux/skbuff.h>
+#include <net/psample.h>
 #include "esw/sample.h"
 #include "eswitch.h"
 #include "en_tc.h"
@@ -12,6 +14,8 @@ struct mlx5_esw_psample {
 	struct mlx5_flow_handle *termtbl_rule;
 	DECLARE_HASHTABLE(hashtbl, 8);
 	struct mutex ht_lock; /* protect hashtbl */
+	DECLARE_HASHTABLE(restore_hashtbl, 8);
+	struct mutex restore_lock; /* protect restore_hashtbl */
 };
 
 struct mlx5_sampler {
@@ -25,6 +29,15 @@ struct mlx5_sampler {
 
 struct mlx5_sample_flow {
 	struct mlx5_sampler *sampler;
+	struct mlx5_sample_restore *restore;
+};
+
+struct mlx5_sample_restore {
+	struct hlist_node hlist;
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_flow_handle *rule;
+	u32 obj_id;
+	int count;
 };
 
 static int
@@ -192,6 +205,99 @@ sampler_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sampler *sampler)
 	mutex_unlock(&esw_psample->ht_lock);
 }
 
+static struct mlx5_modify_hdr *
+sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
+{
+	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	struct mlx5_modify_hdr *modify_hdr;
+	int err;
+
+	err = mlx5e_tc_match_to_reg_set(mdev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
+					CHAIN_TO_REG, obj_id);
+	if (err)
+		goto err_set_regc0;
+
+	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_FDB,
+					      mod_acts.num_actions,
+					      mod_acts.actions);
+	if (IS_ERR(modify_hdr)) {
+		err = PTR_ERR(modify_hdr);
+		goto err_modify_hdr;
+	}
+
+	dealloc_mod_hdr_actions(&mod_acts);
+	return modify_hdr;
+
+err_modify_hdr:
+	dealloc_mod_hdr_actions(&mod_acts);
+err_set_regc0:
+	return ERR_PTR(err);
+}
+
+static struct mlx5_sample_restore *
+sample_restore_get(struct mlx5_esw_psample *esw_psample, u32 obj_id)
+{
+	struct mlx5_core_dev *mdev = esw_psample->priv->mdev;
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	struct mlx5_sample_restore *restore;
+	struct mlx5_modify_hdr *modify_hdr;
+	int err;
+
+	mutex_lock(&esw_psample->restore_lock);
+	hash_for_each_possible(esw_psample->restore_hashtbl, restore, hlist, obj_id)
+		if (restore->obj_id == obj_id)
+			goto add_ref;
+
+	restore = kzalloc(sizeof(*restore), GFP_KERNEL);
+	if (!restore) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+	restore->obj_id = obj_id;
+
+	modify_hdr = sample_metadata_rule_get(mdev, obj_id);
+	if (IS_ERR(modify_hdr)) {
+		err = PTR_ERR(modify_hdr);
+		goto err_modify_hdr;
+	}
+	restore->modify_hdr = modify_hdr;
+
+	restore->rule = esw_add_restore_rule(esw, obj_id);
+	if (IS_ERR(restore->rule)) {
+		err = PTR_ERR(restore->rule);
+		goto err_restore;
+	}
+
+	hash_add(esw_psample->restore_hashtbl, &restore->hlist, obj_id);
+add_ref:
+	restore->count++;
+	mutex_unlock(&esw_psample->restore_lock);
+	return restore;
+
+err_restore:
+	mlx5_modify_header_dealloc(mdev, restore->modify_hdr);
+err_modify_hdr:
+	kfree(restore);
+err_alloc:
+	mutex_unlock(&esw_psample->restore_lock);
+	return ERR_PTR(err);
+}
+
+static void
+sample_restore_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sample_restore *restore)
+{
+	mutex_lock(&esw_psample->restore_lock);
+	if (--restore->count == 0)
+		hash_del(&restore->hlist);
+	mutex_unlock(&esw_psample->restore_lock);
+
+	if (!restore->count) {
+		mlx5_del_flow_rules(restore->rule);
+		mlx5_modify_header_dealloc(esw_psample->priv->mdev, restore->modify_hdr);
+		kfree(restore);
+	}
+}
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv)
 {
@@ -207,6 +313,7 @@ mlx5_esw_sample_init(struct mlx5e_priv *priv)
 		goto err_termtbl;
 
 	mutex_init(&esw_psample->ht_lock);
+	mutex_init(&esw_psample->restore_lock);
 
 	return esw_psample;
 
@@ -221,6 +328,7 @@ mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample)
 	if (IS_ERR_OR_NULL(esw_psample))
 		return;
 
+	mutex_destroy(&esw_psample->restore_lock);
 	mutex_destroy(&esw_psample->ht_lock);
 	sampler_termtbl_destroy(esw_psample);
 	kfree(esw_psample);
-- 
2.30.2

