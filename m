Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61466453F8A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhKQEhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhKQEhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AA726137E;
        Wed, 17 Nov 2021 04:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123648;
        bh=yTXZrajXKcgdlEBq8KlDX5d8Apy09LABtQqxukRMxVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USzqs4GDEKJu2hwJ3YTvkIvSOIhbLaynECMzarXSo8Jb2eC6HKipU0tGmIP/949Rb
         Cmz/zA2oJ7RdNJYkQge455+ZoDx6nRGkfh6/jOm7AppPGeLFU8l12kBuhGf63XKoIV
         DNdt50HOmINwhCla1yuNj9AmSiyiElQs7X2NmskEA8QmY2FioMh3J3rFbm8n/nATn7
         mgDu7rSb4Eg/NFFw7pmszA7UWsvMw131hfE4DA1roDXOYrK9ukUw3LL9oGxu0gDQc2
         bLvNJGR/8c1pRPSDvrwKw1ZZ1UxP8Hysw7W3EjAp7jXDqa5D2B3sfFsG6uBPIvwgyN
         nw1+iAHS7fmDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next v0 05/15] net/mlx5: CT: Allow static allocation of mod headers
Date:   Tue, 16 Nov 2021 20:33:47 -0800
Message-Id: <20211117043357.345072-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

As each CT rule uses at least 4 modify header actions, each rule
causes at least 3 reallocations by the mod header actions api.

Allow initial static allocation of the mod acts array, and use it for
CT rules. If the static allocation is exceeded go back to dynamic
allocation.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/mod_hdr.c    | 17 ++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/mod_hdr.h    | 13 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c  |  9 ++++++++-
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
index 19d05fb4aab2..17325c5d6516 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
@@ -176,11 +176,20 @@ mlx5e_mod_hdr_alloc(struct mlx5_core_dev *mdev, int namespace,
 	new_sz = MLX5_MH_ACT_SZ * new_num_actions;
 	old_sz = mod_hdr_acts->max_actions * MLX5_MH_ACT_SZ;
 
-	ret = krealloc(mod_hdr_acts->actions, new_sz, GFP_KERNEL);
+	if (mod_hdr_acts->is_static) {
+		ret = kzalloc(new_sz, GFP_KERNEL);
+		if (ret) {
+			memcpy(ret, mod_hdr_acts->actions, old_sz);
+			mod_hdr_acts->is_static = false;
+		}
+	} else {
+		ret = krealloc(mod_hdr_acts->actions, new_sz, GFP_KERNEL);
+		if (ret)
+			memset(ret + old_sz, 0, new_sz - old_sz);
+	}
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
-	memset(ret + old_sz, 0, new_sz - old_sz);
 	mod_hdr_acts->actions = ret;
 	mod_hdr_acts->max_actions = new_num_actions;
 
@@ -191,7 +200,9 @@ mlx5e_mod_hdr_alloc(struct mlx5_core_dev *mdev, int namespace,
 void
 mlx5e_mod_hdr_dealloc(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
-	kfree(mod_hdr_acts->actions);
+	if (!mod_hdr_acts->is_static)
+		kfree(mod_hdr_acts->actions);
+
 	mod_hdr_acts->actions = NULL;
 	mod_hdr_acts->num_actions = 0;
 	mod_hdr_acts->max_actions = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
index b8cd1a7a31be..b8dac418d0a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
@@ -7,14 +7,27 @@
 #include <linux/hashtable.h>
 #include <linux/mlx5/fs.h>
 
+#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
+
 struct mlx5e_mod_hdr_handle;
 
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
 	int max_actions;
+	bool is_static;
 	void *actions;
 };
 
+#define DECLARE_MOD_HDR_ACTS_ACTIONS(name, len) \
+	u8 name[len][MLX5_MH_ACT_SZ] = {}
+
+#define DECLARE_MOD_HDR_ACTS(name, acts_arr) \
+	struct mlx5e_tc_mod_hdr_acts name = { \
+		.max_actions = ARRAY_SIZE(acts_arr), \
+		.is_static = true, \
+		.actions = acts_arr, \
+	}
+
 char *mlx5e_mod_hdr_alloc(struct mlx5_core_dev *mdev, int namespace,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void mlx5e_mod_hdr_dealloc(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 89065fac7590..f89a4c7a4f71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -36,6 +36,12 @@
 #define MLX5_CT_LABELS_BITS (mlx5e_tc_attr_to_reg_mappings[LABELS_TO_REG].mlen)
 #define MLX5_CT_LABELS_MASK GENMASK(MLX5_CT_LABELS_BITS - 1, 0)
 
+/* Statically allocate modify actions for
+ * ipv6 and port nat (5) + tuple fields (4) + nic mode zone restore (1) = 10.
+ * This will be increased dynamically if needed (for the ipv6 snat + dnat).
+ */
+#define MLX5_CT_MIN_MOD_ACTS 10
+
 #define ct_dbg(fmt, args...)\
 	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
 
@@ -645,7 +651,8 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5e_mod_hdr_handle **mh,
 				u8 zone_restore_id, bool nat)
 {
-	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
+	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
 	struct flow_action_entry *meta;
 	u16 ct_state = 0;
 	int err;
-- 
2.31.1

