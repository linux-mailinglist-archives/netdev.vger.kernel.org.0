Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597396E2C49
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjDNWJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDNWJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891DA3C3B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14ED664A8E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C13C433D2;
        Fri, 14 Apr 2023 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510184;
        bh=i9DL9s3BoL/wYqCIUJowI6b2kRc4KAzj5kqKFok0P8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftyw5ryhhJy8hbdmGx8r032KuxKge8xVl2H2OMbbv/a55+lJNcnOBn0O9Hi1ZlIfn
         AKr3nPhRPSa6iZGCVsRmI/9rVRoOg/xJwSXfiFdLfWndZa0Q97DQa77rbAPLRq1z61
         x/ljJ9EiGcpo7U0ONddj07NOSK8xz0DjOxigMKMn4pd48C1lpVx89qoadEIpeoPYCG
         5iwfnYyzr5CHCCgvVYR6i7R+N1QUCvUPv+y/33YjgRkOY4/pTQWVxB+dMdvRuRd5fR
         MvayMfE+u+FsPUj0ZztHTIe4HqA04KBe3QrykBeZD9DreyhJxottotjrTVd5Wq20a/
         PoXyYqvJ4SGoQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 03/15] net/mlx5: DR, Split chunk allocation to HW-dependent ways
Date:   Fri, 14 Apr 2023 15:09:27 -0700
Message-Id: <20230414220939.136865-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

This way we are able to allocate chunk for modify_headers from 2 types:
STEv0 that is allocated from the action area, and STEv1 that is allocating
the chunks from the special area for patterns.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 22 ++-----
 .../mellanox/mlx5/core/steering/dr_ste.c      | 57 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  2 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 29 ++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.h   |  2 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c   |  2 +
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +
 7 files changed, 98 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 724e4d9e70ac..732a4002eab5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1961,7 +1961,6 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 					  __be64 actions[],
 					  struct mlx5dr_action *action)
 {
-	struct mlx5dr_icm_chunk *chunk;
 	u32 max_hw_actions;
 	u32 num_hw_actions;
 	u32 num_sw_actions;
@@ -1978,15 +1977,9 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 		return -EINVAL;
 	}
 
-	chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool, DR_CHUNK_SIZE_16);
-	if (!chunk)
-		return -ENOMEM;
-
 	hw_actions = kcalloc(1, max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);
-	if (!hw_actions) {
-		ret = -ENOMEM;
-		goto free_chunk;
-	}
+	if (!hw_actions)
+		return -ENOMEM;
 
 	ret = dr_actions_convert_modify_header(action,
 					       max_hw_actions,
@@ -1998,15 +1991,11 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	if (ret)
 		goto free_hw_actions;
 
-	action->rewrite->chunk = chunk;
 	action->rewrite->modify_ttl = modify_ttl;
 	action->rewrite->data = (u8 *)hw_actions;
 	action->rewrite->num_of_actions = num_hw_actions;
-	action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr(chunk) -
-				  dmn->info.caps.hdr_modify_icm_addr) /
-				  DR_ACTION_CACHE_LINE_SIZE;
 
-	ret = mlx5dr_send_postsend_action(dmn, action);
+	ret = mlx5dr_ste_alloc_modify_hdr(action);
 	if (ret)
 		goto free_hw_actions;
 
@@ -2014,8 +2003,6 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 
 free_hw_actions:
 	kfree(hw_actions);
-free_chunk:
-	mlx5dr_icm_free_chunk(chunk);
 	return ret;
 }
 
@@ -2171,8 +2158,7 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
-		mlx5dr_icm_free_chunk(action->rewrite->chunk);
-		kfree(action->rewrite->data);
+		mlx5dr_ste_free_modify_hdr(action);
 		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_SAMPLER:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 1e15f605df6e..9413aaf51251 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -633,6 +633,63 @@ int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
 						 used_hw_action_num);
 }
 
+static int
+dr_ste_alloc_modify_hdr_chunk(struct mlx5dr_action *action)
+{
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
+	u32 chunk_size;
+	int ret;
+
+	chunk_size = ilog2(roundup_pow_of_two(action->rewrite->num_of_actions));
+
+	/* HW modify action index granularity is at least 64B */
+	chunk_size = max_t(u32, chunk_size, DR_CHUNK_SIZE_8);
+
+	action->rewrite->chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
+							chunk_size);
+	if (!action->rewrite->chunk)
+		return -ENOMEM;
+
+	action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr(action->rewrite->chunk) -
+				  dmn->info.caps.hdr_modify_icm_addr) /
+				 DR_ACTION_CACHE_LINE_SIZE;
+
+	ret = mlx5dr_send_postsend_action(action->rewrite->dmn, action);
+	if (ret)
+		goto free_chunk;
+
+	return 0;
+
+free_chunk:
+	mlx5dr_icm_free_chunk(action->rewrite->chunk);
+	return -ENOMEM;
+}
+
+static void dr_ste_free_modify_hdr_chunk(struct mlx5dr_action *action)
+{
+	mlx5dr_icm_free_chunk(action->rewrite->chunk);
+}
+
+int mlx5dr_ste_alloc_modify_hdr(struct mlx5dr_action *action)
+{
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
+
+	if (mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return dmn->ste_ctx->alloc_modify_hdr_chunk(action);
+
+	return dr_ste_alloc_modify_hdr_chunk(action);
+}
+
+void mlx5dr_ste_free_modify_hdr(struct mlx5dr_action *action)
+{
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
+
+	if (mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return dmn->ste_ctx->dealloc_modify_hdr_chunk(action);
+
+	return dr_ste_free_modify_hdr_chunk(action);
+}
+
 static int dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
 				       struct mlx5dr_match_spec *spec)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 7075142bcfb6..54a6619c3ecb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -195,6 +195,8 @@ struct mlx5dr_ste_ctx {
 					u8 *hw_action,
 					u32 hw_action_sz,
 					u16 *used_hw_action_num);
+	int (*alloc_modify_hdr_chunk)(struct mlx5dr_action *action);
+	void (*dealloc_modify_hdr_chunk)(struct mlx5dr_action *action);
 
 	/* Send */
 	void (*prepare_for_postsend)(u8 *hw_ste_p, u32 ste_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 27cc6931bbde..cf8508139f55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -2176,6 +2176,32 @@ dr_ste_v1_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag;
 }
 
+int dr_ste_v1_alloc_modify_hdr_ptrn_arg(struct mlx5dr_action *action)
+{
+	struct mlx5dr_ptrn_mgr *ptrn_mgr;
+
+	ptrn_mgr = action->rewrite->dmn->ptrn_mgr;
+	if (!ptrn_mgr)
+		return -EOPNOTSUPP;
+
+	action->rewrite->ptrn =
+		mlx5dr_ptrn_cache_get_pattern(ptrn_mgr,
+					      action->rewrite->num_of_actions,
+					      action->rewrite->data);
+	if (!action->rewrite->ptrn) {
+		mlx5dr_err(action->rewrite->dmn, "Failed to get pattern\n");
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+void dr_ste_v1_free_modify_hdr_ptrn_arg(struct mlx5dr_action *action)
+{
+	mlx5dr_ptrn_cache_put_pattern(action->rewrite->dmn->ptrn_mgr,
+				      action->rewrite->ptrn);
+}
+
 static struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
@@ -2232,6 +2258,9 @@ static struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.set_action_add			= &dr_ste_v1_set_action_add,
 	.set_action_copy		= &dr_ste_v1_set_action_copy,
 	.set_action_decap_l3_list	= &dr_ste_v1_set_action_decap_l3_list,
+	.alloc_modify_hdr_chunk		= &dr_ste_v1_alloc_modify_hdr_ptrn_arg,
+	.dealloc_modify_hdr_chunk	= &dr_ste_v1_free_modify_hdr_ptrn_arg,
+
 	/* Send */
 	.prepare_for_postsend		= &dr_ste_v1_prepare_for_postsend,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
index b5c0f0f8392f..e2fc69867088 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
@@ -31,6 +31,8 @@ void dr_ste_v1_set_action_copy(u8 *d_action, u8 dst_hw_field, u8 dst_shifter,
 			       u8 dst_len, u8 src_hw_field, u8 src_shifter);
 int dr_ste_v1_set_action_decap_l3_list(void *data, u32 data_sz, u8 *hw_action,
 				       u32 hw_action_sz, u16 *used_hw_action_num);
+int dr_ste_v1_alloc_modify_hdr_ptrn_arg(struct mlx5dr_action *action);
+void dr_ste_v1_free_modify_hdr_ptrn_arg(struct mlx5dr_action *action);
 void dr_ste_v1_build_eth_l2_src_dst_init(struct mlx5dr_ste_build *sb,
 					 struct mlx5dr_match_param *mask);
 void dr_ste_v1_build_eth_l3_ipv6_dst_init(struct mlx5dr_ste_build *sb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
index cf1a3c9a1cf4..808b013cf48c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
@@ -221,6 +221,8 @@ static struct mlx5dr_ste_ctx ste_ctx_v2 = {
 	.set_action_add			= &dr_ste_v1_set_action_add,
 	.set_action_copy		= &dr_ste_v1_set_action_copy,
 	.set_action_decap_l3_list	= &dr_ste_v1_set_action_decap_l3_list,
+	.alloc_modify_hdr_chunk		= &dr_ste_v1_alloc_modify_hdr_ptrn_arg,
+	.dealloc_modify_hdr_chunk	= &dr_ste_v1_free_modify_hdr_ptrn_arg,
 
 	/* Send */
 	.prepare_for_postsend		= &dr_ste_v1_prepare_for_postsend,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 097f1f389b76..a1c549fed9ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -335,6 +335,8 @@ int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
 					u8 *hw_action,
 					u32 hw_action_sz,
 					u16 *used_hw_action_num);
+int mlx5dr_ste_alloc_modify_hdr(struct mlx5dr_action *action);
+void mlx5dr_ste_free_modify_hdr(struct mlx5dr_action *action);
 
 const struct mlx5dr_ste_action_modify_field *
 mlx5dr_ste_conv_modify_hdr_sw_field(struct mlx5dr_ste_ctx *ste_ctx, u16 sw_field);
-- 
2.39.2

