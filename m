Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360103092EB
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhA3EVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233647AbhA3DtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:49:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3582364E05;
        Sat, 30 Jan 2021 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973593;
        bh=vwu6crRWTR1BCji27qkqCSzmzItn6rJAd30pJho8c34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/thK5OduWKlKo1t+nJw0fPsjunB35Grfikghk7ZBkc+FnaPqdTQ0v629Lyg8oSlr
         gKz0Tjw145v9dsRuVzN+GBlIZaauglHezgiIEH9UNl7CD+Dcsl3TmZ3MXBQ7JHgGF4
         Q8MAehAyG9WYuR4fwjPkjz8QR94byb+GpJ7bPCyYNl0DRCZ+C/CAR2uvxT9vMuPrJE
         3H4+eZxe3la3gJowOfelut0OqqBkRW3pfR93rXu/pVjFKxLItuKRzOyCokIDLzMPtw
         igesr1y7oKgcMCjggjlIJ+CJyJL9gDrBtmy4ErCjMNp1awqv2jFPH/LHaCGWVabnHa
         Wq1yT1aJ0xUYA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/11] net/mlx5: DR, Use HW specific logic API when writing STE
Date:   Fri, 29 Jan 2021 18:26:16 -0800
Message-Id: <20210130022618.317351-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

STEv0 format and STEv1 HW format are different, each has a
different order:
STEv0: CTRL 32B, TAG 16B, BITMASK 16B
STEv1: CTRL 32B, BITMASK 16B, TAG 16B

To make this transparent to upper layers we introduce a
new ste_ctx function to format the STE prior to writing it.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     |  9 +++---
 .../mellanox/mlx5/core/steering/dr_send.c     | 29 +++++++++++++------
 .../mellanox/mlx5/core/steering/dr_ste.c      |  7 +++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  3 ++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 22 ++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  3 ++
 6 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index fcea2a21abe9..b337d6626bff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -106,10 +106,6 @@ dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_info,
 	int ret;
 
 	list_del(&ste_info->send_list);
-	ret = mlx5dr_send_postsend_ste(dmn, ste_info->ste, ste_info->data,
-				       ste_info->size, ste_info->offset);
-	if (ret)
-		goto out;
 
 	/* Copy data to ste, only reduced size or control, the last 16B (mask)
 	 * is already written to the hw.
@@ -119,6 +115,11 @@ dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_info,
 	else
 		memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_REDUCED);
 
+	ret = mlx5dr_send_postsend_ste(dmn, ste_info->ste, ste_info->data,
+				       ste_info->size, ste_info->offset);
+	if (ret)
+		goto out;
+
 out:
 	kfree(ste_info);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 24dede1b0a20..83c4c877d558 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -431,6 +431,8 @@ int mlx5dr_send_postsend_ste(struct mlx5dr_domain *dmn, struct mlx5dr_ste *ste,
 {
 	struct postsend_info send_info = {};
 
+	mlx5dr_ste_prepare_for_postsend(dmn->ste_ctx, data, size);
+
 	send_info.write.addr = (uintptr_t)data;
 	send_info.write.length = size;
 	send_info.write.lkey = 0;
@@ -457,6 +459,8 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 	if (ret)
 		return ret;
 
+	mlx5dr_ste_prepare_for_postsend(dmn->ste_ctx, formatted_ste, DR_STE_SIZE);
+
 	/* Send the data iteration times */
 	for (i = 0; i < iterations; i++) {
 		u32 ste_index = i * (byte_size / DR_STE_SIZE);
@@ -480,6 +484,10 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 				/* Copy bit_mask */
 				memcpy(data + ste_off + DR_STE_SIZE_REDUCED,
 				       mask, DR_STE_SIZE_MASK);
+				/* Only when we have mask we need to re-arrange the STE */
+				mlx5dr_ste_prepare_for_postsend(dmn->ste_ctx,
+								data + (j * DR_STE_SIZE),
+								DR_STE_SIZE);
 			}
 		}
 
@@ -509,6 +517,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 	u32 byte_size = htbl->chunk->byte_size;
 	int iterations;
 	int num_stes;
+	u8 *copy_dst;
 	u8 *data;
 	int ret;
 	int i;
@@ -518,20 +527,22 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < num_stes; i++) {
-		u8 *copy_dst;
-
-		/* Copy the same ste on the data buffer */
-		copy_dst = data + i * DR_STE_SIZE;
-		memcpy(copy_dst, ste_init_data, DR_STE_SIZE);
-
-		if (update_hw_ste) {
-			/* Copy the reduced ste to hash table ste_arr */
+	if (update_hw_ste) {
+		/* Copy the reduced STE to hash table ste_arr */
+		for (i = 0; i < num_stes; i++) {
 			copy_dst = htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 			memcpy(copy_dst, ste_init_data, DR_STE_SIZE_REDUCED);
 		}
 	}
 
+	mlx5dr_ste_prepare_for_postsend(dmn->ste_ctx, ste_init_data, DR_STE_SIZE);
+
+	/* Copy the same STE on the data buffer */
+	for (i = 0; i < num_stes; i++) {
+		copy_dst = data + i * DR_STE_SIZE;
+		memcpy(copy_dst, ste_init_data, DR_STE_SIZE);
+	}
+
 	/* Send the data iteration times */
 	for (i = 0; i < iterations; i++) {
 		u8 ste_index = i * (byte_size / DR_STE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index e21b61030e35..8ac3ccdda84c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -356,6 +356,13 @@ void mlx5dr_ste_set_hit_addr_by_next_htbl(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
 }
 
+void mlx5dr_ste_prepare_for_postsend(struct mlx5dr_ste_ctx *ste_ctx,
+				     u8 *hw_ste_p, u32 ste_size)
+{
+	if (ste_ctx->prepare_for_postsend)
+		ste_ctx->prepare_for_postsend(hw_ste_p, ste_size);
+}
+
 /* Init one ste as a pattern for ste data array */
 void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
 				  u16 gvmi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 0dc08fe1a9db..06bcb0ee8f96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -160,6 +160,9 @@ struct mlx5dr_ste_ctx {
 					u8 *hw_action,
 					u32 hw_action_sz,
 					u16 *used_hw_action_num);
+
+	/* Send */
+	void (*prepare_for_postsend)(u8 *hw_ste_p, u32 ste_size);
 };
 
 extern struct mlx5dr_ste_ctx ste_ctx_v0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 42b853fa3465..4088d6e51508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -324,6 +324,26 @@ static void dr_ste_v1_init(u8 *hw_ste_p, u16 lu_type,
 	MLX5_SET(ste_match_bwc_v1, hw_ste_p, miss_address_63_48, gvmi);
 }
 
+static void dr_ste_v1_prepare_for_postsend(u8 *hw_ste_p,
+					   u32 ste_size)
+{
+	u8 *tag = hw_ste_p + DR_STE_SIZE_CTRL;
+	u8 *mask = tag + DR_STE_SIZE_TAG;
+	u8 tmp_tag[DR_STE_SIZE_TAG] = {};
+
+	if (ste_size == DR_STE_SIZE_CTRL)
+		return;
+
+	WARN_ON(ste_size != DR_STE_SIZE);
+
+	/* Backup tag */
+	memcpy(tmp_tag, tag, DR_STE_SIZE_TAG);
+
+	/* Swap mask and tag  both are the same size */
+	memcpy(tag, mask, DR_STE_SIZE_MASK);
+	memcpy(mask, tmp_tag, DR_STE_SIZE_TAG);
+}
+
 static void dr_ste_v1_set_rx_flow_tag(u8 *s_action, u32 flow_tag)
 {
 	MLX5_SET(ste_single_action_flow_tag_v1, s_action, action_id,
@@ -1608,4 +1628,6 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.set_action_add			= &dr_ste_v1_set_action_add,
 	.set_action_copy		= &dr_ste_v1_set_action_copy,
 	.set_action_decap_l3_list	= &dr_ste_v1_set_action_decap_l3_list,
+	/* Send */
+	.prepare_for_postsend		= &dr_ste_v1_prepare_for_postsend,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 8d2c3b6e2755..3b76142218d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1072,6 +1072,9 @@ struct mlx5dr_icm_chunk *
 mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 		       enum mlx5dr_icm_chunk_size chunk_size);
 void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk);
+
+void mlx5dr_ste_prepare_for_postsend(struct mlx5dr_ste_ctx *ste_ctx,
+				     u8 *hw_ste_p, u32 ste_size);
 int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 				      struct mlx5dr_domain_rx_tx *nic_dmn,
 				      struct mlx5dr_ste_htbl *htbl,
-- 
2.29.2

