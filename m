Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C438F6E2C56
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjDNWKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6685F5B9F
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482F064A8D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A746FC433D2;
        Fri, 14 Apr 2023 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510191;
        bh=aqSRVA7r3T6Rph04cRmmgGlVwZbjsPNBL9yPjhrFovo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8Ykup1ROzax1Rm2xUFYM/NrV+/zw5VJCA16M1IPOE2wsC0BTpRImQXG3TusgA4ys
         ZFIx3VuXhqTNzgXu7Z1BmctUReLixHqmNT/dxOlWt6IKBeNBm42cZ9WUBqVeFJR8cz
         +InzuK33YT8pY1FSsZ+sadiICj0JiYyNJ55g8os4AP79FoRud/h1k4CwL3k5OU3w+l
         5ENSXxVgIbWiknRypqQzmLmSfHxV/2nv0jDP/YnwLrsyyE+3pI/TV456BmpsBdhw+W
         nDOdZE0L4QF6mtHRZVghvOqrlNl+tAqIgjl88w4Ir8q/omVS3cBdxGQ0cdKAqn1D4o
         j1J7RbYanMttw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 13/15] net/mlx5: DR, Modify header action of size 1 optimization
Date:   Fri, 14 Apr 2023 15:09:37 -0700
Message-Id: <20230414220939.136865-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Set modify header action of size 1 directly on the STE for supporting
devices, thus reducing number of hops and cache misses.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 37 ++++++++++++------
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 38 ++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +
 3 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 8f8f0a0b38fd..0eb9a8d7f282 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -832,14 +832,20 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			}
 			break;
 		case DR_ACTION_TYP_MODIFY_HDR:
-			if (action->rewrite->ptrn && action->rewrite->arg) {
-				attr.modify_index = mlx5dr_arg_get_obj_id(action->rewrite->arg);
-				attr.modify_actions = action->rewrite->ptrn->num_of_actions;
-				attr.modify_pat_idx = action->rewrite->ptrn->index;
-			} else {
-				attr.modify_index = action->rewrite->index;
+			if (action->rewrite->single_action_opt) {
 				attr.modify_actions = action->rewrite->num_of_actions;
-				attr.modify_pat_idx = MLX5DR_INVALID_PATTERN_INDEX;
+				attr.single_modify_action = action->rewrite->data;
+			} else {
+				if (action->rewrite->ptrn && action->rewrite->arg) {
+					attr.modify_index =
+						mlx5dr_arg_get_obj_id(action->rewrite->arg);
+					attr.modify_actions = action->rewrite->ptrn->num_of_actions;
+					attr.modify_pat_idx = action->rewrite->ptrn->index;
+				} else {
+					attr.modify_index = action->rewrite->index;
+					attr.modify_actions = action->rewrite->num_of_actions;
+					attr.modify_pat_idx = MLX5DR_INVALID_PATTERN_INDEX;
+				}
 			}
 			if (action->rewrite->modify_ttl)
 				dr_action_modify_ttl_adjust(dmn, &attr, rx_rule,
@@ -1998,9 +2004,15 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	action->rewrite->data = (u8 *)hw_actions;
 	action->rewrite->num_of_actions = num_hw_actions;
 
-	ret = mlx5dr_ste_alloc_modify_hdr(action);
-	if (ret)
-		goto free_hw_actions;
+	if (num_hw_actions == 1 &&
+	    dmn->info.caps.sw_format_ver >= MLX5_STEERING_FORMAT_CONNECTX_6DX) {
+		action->rewrite->single_action_opt = true;
+	} else {
+		action->rewrite->single_action_opt = false;
+		ret = mlx5dr_ste_alloc_modify_hdr(action);
+		if (ret)
+			goto free_hw_actions;
+	}
 
 	return 0;
 
@@ -2151,6 +2163,7 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		break;
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 		mlx5dr_ste_free_modify_hdr(action);
+		kfree(action->rewrite->data);
 		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
@@ -2161,7 +2174,9 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
-		mlx5dr_ste_free_modify_hdr(action);
+		if (!action->rewrite->single_action_opt)
+			mlx5dr_ste_free_modify_hdr(action);
+		kfree(action->rewrite->data);
 		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_SAMPLER:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index d2d312454564..4c0704ad166b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -499,16 +499,21 @@ static void dr_ste_v1_set_accelerated_rewrite_actions(u8 *hw_ste_p,
 						      u8 *d_action,
 						      u16 num_of_actions,
 						      u32 rewrite_pattern,
-						      u32 rewrite_args)
+						      u32 rewrite_args,
+						      u8 *action_data)
 {
-	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
-		 action_id, DR_STE_V1_ACTION_ID_ACCELERATED_LIST);
-	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
-		 modify_actions_pattern_pointer, rewrite_pattern);
-	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
-		 number_of_modify_actions, num_of_actions);
-	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
-		 modify_actions_argument_pointer, rewrite_args);
+	if (action_data) {
+		memcpy(d_action, action_data, DR_MODIFY_ACTION_SIZE);
+	} else {
+		MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+			 action_id, DR_STE_V1_ACTION_ID_ACCELERATED_LIST);
+		MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+			 modify_actions_pattern_pointer, rewrite_pattern);
+		MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+			 number_of_modify_actions, num_of_actions);
+		MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+			 modify_actions_argument_pointer, rewrite_args);
+	}
 
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
@@ -532,14 +537,16 @@ static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
 					  u8 *action,
 					  u16 num_of_actions,
 					  u32 rewrite_pattern,
-					  u32 rewrite_args)
+					  u32 rewrite_args,
+					  u8 *action_data)
 {
 	if (rewrite_pattern != MLX5DR_INVALID_PATTERN_INDEX)
 		return dr_ste_v1_set_accelerated_rewrite_actions(hw_ste_p,
 								 action,
 								 num_of_actions,
 								 rewrite_pattern,
-								 rewrite_args);
+								 rewrite_args,
+								 action_data);
 
 	/* fall back to the code that doesn't support accelerated modify header */
 	return dr_ste_v1_set_basic_rewrite_actions(hw_ste_p,
@@ -653,7 +660,8 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->modify_actions,
 					      attr->modify_pat_idx,
-					      attr->modify_index);
+					      attr->modify_index,
+					      attr->single_modify_action);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 		allow_encap = false;
@@ -784,7 +792,8 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->decap_actions,
 					      attr->decap_pat_idx,
-					      attr->decap_index);
+					      attr->decap_index,
+					      NULL);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 		allow_modify_hdr = false;
@@ -840,7 +849,8 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->modify_actions,
 					      attr->modify_pat_idx,
-					      attr->modify_index);
+					      attr->modify_index,
+					      attr->single_modify_action);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3ffda3d302e0..37b7b1a79f93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -267,6 +267,7 @@ struct mlx5dr_ste_actions_attr {
 	u32	modify_index;
 	u32	modify_pat_idx;
 	u16	modify_actions;
+	u8	*single_modify_action;
 	u32	decap_index;
 	u32	decap_pat_idx;
 	u16	decap_actions;
@@ -1035,6 +1036,7 @@ struct mlx5dr_action_rewrite {
 	u8 *data;
 	u16 num_of_actions;
 	u32 index;
+	u8 single_action_opt:1;
 	u8 allow_rx:1;
 	u8 allow_tx:1;
 	u8 modify_ttl:1;
-- 
2.39.2

