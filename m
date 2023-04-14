Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0906F6E2C51
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDNWJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC40469E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F8BA64A99
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC7BC4339B;
        Fri, 14 Apr 2023 22:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510189;
        bh=J6T3TzRnGNnHIKdNkBfB3q5qa1WlCeNbmkc7XO8/M7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlOeiTMo971WgqfWJZiCU+7MNvhgYVGba6+8fNoMHXwnjXKgjxis8+zayVwI8WArI
         sDHxzLdakB4Sst94lYz5FeIBK9Mj0/LgJCJ8bzESM8/E3dPPUV/doAzPNYwQDUhqSB
         gZaLRlGAXruN9WpVRCB5XGFdsiRTlqzW9SUBwCja11ogwUfL0PSPzW0ebhby1pheZ+
         U4OEqcmptPfmAk+HDu9CXpR/YB3TIuql9LWkMIQ8Nl4dWi/pbITr6jK/aWCc+vSHyo
         1JYtUn+WWKLSZ0PAngKcgTCRvz0jbppAHfb/Xr+D1XChFGJhu+pEP4QmZyYDeP5QUg
         ZD7AgbCYyVr1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 10/15] net/mlx5: DR, Add modify header argument pointer to actions attributes
Date:   Fri, 14 Apr 2023 15:09:34 -0700
Message-Id: <20230414220939.136865-11-saeed@kernel.org>
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

While building the actions, add the pointer of the arguments for
accelerated modify list action into the action's attributes.
This will be used later on while building the specific STE
for this action.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 26 ++++++++++++++-----
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 19 +++++++++++++-
 .../mellanox/mlx5/core/steering/dr_types.h    |  4 +++
 3 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 732a4002eab5..98e3d4f572eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -819,14 +819,28 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		case DR_ACTION_TYP_TNL_L2_TO_L2:
 			break;
 		case DR_ACTION_TYP_TNL_L3_TO_L2:
-			attr.decap_index = action->rewrite->index;
-			attr.decap_actions = action->rewrite->num_of_actions;
-			attr.decap_with_vlan =
-				attr.decap_actions == WITH_VLAN_NUM_HW_ACTIONS;
+			if (action->rewrite->ptrn && action->rewrite->arg) {
+				attr.decap_index = mlx5dr_arg_get_obj_id(action->rewrite->arg);
+				attr.decap_actions = action->rewrite->ptrn->num_of_actions;
+				attr.decap_pat_idx = action->rewrite->ptrn->index;
+			} else {
+				attr.decap_index = action->rewrite->index;
+				attr.decap_actions = action->rewrite->num_of_actions;
+				attr.decap_with_vlan =
+					attr.decap_actions == WITH_VLAN_NUM_HW_ACTIONS;
+				attr.decap_pat_idx = MLX5DR_INVALID_PATTERN_INDEX;
+			}
 			break;
 		case DR_ACTION_TYP_MODIFY_HDR:
-			attr.modify_index = action->rewrite->index;
-			attr.modify_actions = action->rewrite->num_of_actions;
+			if (action->rewrite->ptrn && action->rewrite->arg) {
+				attr.modify_index = mlx5dr_arg_get_obj_id(action->rewrite->arg);
+				attr.modify_actions = action->rewrite->ptrn->num_of_actions;
+				attr.modify_pat_idx = action->rewrite->ptrn->index;
+			} else {
+				attr.modify_index = action->rewrite->index;
+				attr.modify_actions = action->rewrite->num_of_actions;
+				attr.modify_pat_idx = MLX5DR_INVALID_PATTERN_INDEX;
+			}
 			if (action->rewrite->modify_ttl)
 				dr_action_modify_ttl_adjust(dmn, &attr, rx_rule,
 							    &recalc_cs_required);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index cf8508139f55..3d04ac08be77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -2179,27 +2179,44 @@ dr_ste_v1_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 int dr_ste_v1_alloc_modify_hdr_ptrn_arg(struct mlx5dr_action *action)
 {
 	struct mlx5dr_ptrn_mgr *ptrn_mgr;
+	int ret;
 
 	ptrn_mgr = action->rewrite->dmn->ptrn_mgr;
 	if (!ptrn_mgr)
 		return -EOPNOTSUPP;
 
+	action->rewrite->arg = mlx5dr_arg_get_obj(action->rewrite->dmn->arg_mgr,
+						  action->rewrite->num_of_actions,
+						  action->rewrite->data);
+	if (!action->rewrite->arg) {
+		mlx5dr_err(action->rewrite->dmn, "Failed allocating args for modify header\n");
+		return -EAGAIN;
+	}
+
 	action->rewrite->ptrn =
 		mlx5dr_ptrn_cache_get_pattern(ptrn_mgr,
 					      action->rewrite->num_of_actions,
 					      action->rewrite->data);
 	if (!action->rewrite->ptrn) {
 		mlx5dr_err(action->rewrite->dmn, "Failed to get pattern\n");
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto put_arg;
 	}
 
 	return 0;
+
+put_arg:
+	mlx5dr_arg_put_obj(action->rewrite->dmn->arg_mgr,
+			   action->rewrite->arg);
+	return ret;
 }
 
 void dr_ste_v1_free_modify_hdr_ptrn_arg(struct mlx5dr_action *action)
 {
 	mlx5dr_ptrn_cache_put_pattern(action->rewrite->dmn->ptrn_mgr,
 				      action->rewrite->ptrn);
+	mlx5dr_arg_put_obj(action->rewrite->dmn->arg_mgr,
+			   action->rewrite->arg);
 }
 
 static struct mlx5dr_ste_ctx ste_ctx_v1 = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index e102ceb20e01..3ffda3d302e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -261,11 +261,14 @@ u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste);
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste);
 
 #define MLX5DR_MAX_VLANS 2
+#define MLX5DR_INVALID_PATTERN_INDEX 0xffffffff
 
 struct mlx5dr_ste_actions_attr {
 	u32	modify_index;
+	u32	modify_pat_idx;
 	u16	modify_actions;
 	u32	decap_index;
+	u32	decap_pat_idx;
 	u16	decap_actions;
 	u8	decap_with_vlan:1;
 	u64	final_icm_addr;
@@ -1036,6 +1039,7 @@ struct mlx5dr_action_rewrite {
 	u8 allow_tx:1;
 	u8 modify_ttl:1;
 	struct mlx5dr_ptrn_obj *ptrn;
+	struct mlx5dr_arg_obj *arg;
 };
 
 struct mlx5dr_action_reformat {
-- 
2.39.2

