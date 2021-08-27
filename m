Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E903F91C6
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbhH0BA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244077AbhH0A7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B45CC610FB;
        Fri, 27 Aug 2021 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025905;
        bh=cMGFUOMlQwReU37Ph8ca8wTiE5Nt1a9wUrn4qsge6Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw6G5zlI3XPTmTemL/NjZKGYLHZ8GR954AnctWGkv4pO37Yd+nOurcWWkAl1d1x+G
         M0+xj1SisF82qcCf5zs4tPl8YJNc65fAsTO+UD7LUv1fzbPw0TjLhN74xweINt66DN
         m/AmvluYkgJ/TV96Xv2ANGbwfkAdMblUiDxtF2V0+YIUwQzxhEJXOTczcsmUXU0Ou8
         vG7YNiEYXgu/CuP6IQ6q0Pk1duslQCF/DjW4HTxa8d7/EiFgtE9TOzXdak2VVanJ/W
         uIuwdG3sgZfPa955KYveT0cf2BPhKDp0PuoKMWV6X379ACUvdNf/IaQu6SFX/kwwQl
         OTMUod0F4bA6Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/17] net/mlx5: DR, Remove rehash ctrl struct from dr_htbl
Date:   Thu, 26 Aug 2021 17:58:00 -0700
Message-Id: <20210827005802.236119-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The calculations to decide for the maximum allowed collision threshold
are simple and there is no reason to save them on the htbl struct.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     |  8 ++++---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 16 --------------
 .../mellanox/mlx5/core/steering/dr_types.h    | 21 +++++++++++++++++--
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 72c75d8e6bbf..f853a48e07b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -628,18 +628,20 @@ static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste_htbl *htbl,
 				      struct mlx5dr_domain_rx_tx *nic_dmn)
 {
 	struct mlx5dr_ste_htbl_ctrl *ctrl = &htbl->ctrl;
+	int threshold;
 
 	if (dmn->info.max_log_sw_icm_sz <= htbl->chunk_size)
 		return false;
 
-	if (!ctrl->may_grow)
+	if (!mlx5dr_ste_htbl_may_grow(htbl))
 		return false;
 
 	if (dr_get_bits_per_mask(htbl->byte_mask) * BITS_PER_BYTE <= htbl->chunk_size)
 		return false;
 
-	if (ctrl->num_of_collisions >= ctrl->increase_threshold &&
-	    (ctrl->num_of_valid_entries - ctrl->num_of_collisions) >= ctrl->increase_threshold)
+	threshold = mlx5dr_ste_htbl_increase_threshold(htbl);
+	if (ctrl->num_of_collisions >= threshold &&
+	    (ctrl->num_of_valid_entries - ctrl->num_of_collisions) >= threshold)
 		return true;
 
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 6ea314ff05ec..15fecb491c55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -467,21 +467,6 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 	return -ENOENT;
 }
 
-static void dr_ste_set_ctrl(struct mlx5dr_ste_htbl *htbl)
-{
-	struct mlx5dr_ste_htbl_ctrl *ctrl = &htbl->ctrl;
-	int num_of_entries;
-
-	htbl->ctrl.may_grow = true;
-
-	if (htbl->chunk_size == DR_CHUNK_SIZE_MAX - 1 || !htbl->byte_mask)
-		htbl->ctrl.may_grow = false;
-
-	/* Threshold is 50%, one is added to table of size 1 */
-	num_of_entries = mlx5dr_icm_pool_chunk_size_to_entries(htbl->chunk_size);
-	ctrl->increase_threshold = (num_of_entries + 1) / 2;
-}
-
 struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 					      enum mlx5dr_icm_chunk_size chunk_size,
 					      u16 lu_type, u16 byte_mask)
@@ -518,7 +503,6 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	}
 
 	htbl->chunk_size = chunk_size;
-	dr_ste_set_ctrl(htbl);
 	return htbl;
 
 out_free_htbl:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index caff9fc4b8ca..9ba4f379afa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -171,8 +171,6 @@ struct mlx5dr_ste_htbl_ctrl {
 
 	/* total number of collisions entries attached to this table */
 	unsigned int num_of_collisions;
-	unsigned int increase_threshold;
-	u8 may_grow:1;
 };
 
 struct mlx5dr_ste_htbl {
@@ -1088,6 +1086,25 @@ mlx5dr_icm_pool_chunk_size_to_byte(enum mlx5dr_icm_chunk_size chunk_size,
 	return entry_size * num_of_entries;
 }
 
+static inline int
+mlx5dr_ste_htbl_increase_threshold(struct mlx5dr_ste_htbl *htbl)
+{
+	int num_of_entries =
+		mlx5dr_icm_pool_chunk_size_to_entries(htbl->chunk_size);
+
+	/* Threshold is 50%, one is added to table of size 1 */
+	return (num_of_entries + 1) / 2;
+}
+
+static inline bool
+mlx5dr_ste_htbl_may_grow(struct mlx5dr_ste_htbl *htbl)
+{
+	if (htbl->chunk_size == DR_CHUNK_SIZE_MAX - 1 || !htbl->byte_mask)
+		return false;
+
+	return true;
+}
+
 static inline struct mlx5dr_cmd_vport_cap *
 mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u32 vport)
 {
-- 
2.31.1

