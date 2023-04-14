Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679916E2C54
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDNWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD444EE9
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E07F064AA2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4711EC433D2;
        Fri, 14 Apr 2023 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510190;
        bh=Ja6MUx1O7IuCmhLD+aDETeREFJP5N+L2L09Dnz/rpeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmgqGBhVpg/Bzhgo/O2V5mO+N1eQ1qDamPJj0DDNmpJL9dObtXLU1hcZKb+RypVGb
         xWJKul0rrq9JCsZr/KeL+quIuLI08RttcWzyFmK1emAjgNPbupTROs8xBVLBNBx5Wr
         Nwnz2SJZo0kjxfRScDvxY6gM51UgYLjdjL4wSyRQDYml5wr5UEvveebOwHxt4o8UK9
         bDGj+ndOW7m3L9GDrA5Y4Q71g0c3lgBdf+AAZVEfgt/QcSGcRgLUw91XWqO8L/gv1T
         MaCOrnJSWSpXSEggpz8Sv/jDG+84wJ3QQIYoNQ2RDkhuJ6H0HYq93y/DQuRKyOjVbm
         910spiNW4N0ww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 11/15] net/mlx5: DR, Apply new accelerated modify action and decapl3
Date:   Fri, 14 Apr 2023 15:09:35 -0700
Message-Id: <20230414220939.136865-12-saeed@kernel.org>
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

If there is support for pattern/args, use the new accelerated modify
header action for modify header and decap L3 actions.
Otherwise fall back to the old modify-header implementation.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 51 +++++++++++++++++--
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   |  2 +-
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 3d04ac08be77..d2d312454564 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -495,21 +495,59 @@ static void dr_ste_v1_set_rx_decap(u8 *hw_ste_p, u8 *s_action)
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
-static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
-					  u8 *s_action,
-					  u16 num_of_actions,
-					  u32 re_write_index)
+static void dr_ste_v1_set_accelerated_rewrite_actions(u8 *hw_ste_p,
+						      u8 *d_action,
+						      u16 num_of_actions,
+						      u32 rewrite_pattern,
+						      u32 rewrite_args)
+{
+	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+		 action_id, DR_STE_V1_ACTION_ID_ACCELERATED_LIST);
+	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+		 modify_actions_pattern_pointer, rewrite_pattern);
+	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+		 number_of_modify_actions, num_of_actions);
+	MLX5_SET(ste_double_action_accelerated_modify_action_list_v1, d_action,
+		 modify_actions_argument_pointer, rewrite_args);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
+static void dr_ste_v1_set_basic_rewrite_actions(u8 *hw_ste_p,
+						u8 *s_action,
+						u16 num_of_actions,
+						u32 rewrite_index)
 {
 	MLX5_SET(ste_single_action_modify_list_v1, s_action, action_id,
 		 DR_STE_V1_ACTION_ID_MODIFY_LIST);
 	MLX5_SET(ste_single_action_modify_list_v1, s_action, num_of_modify_actions,
 		 num_of_actions);
 	MLX5_SET(ste_single_action_modify_list_v1, s_action, modify_actions_ptr,
-		 re_write_index);
+		 rewrite_index);
 
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
+static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
+					  u8 *action,
+					  u16 num_of_actions,
+					  u32 rewrite_pattern,
+					  u32 rewrite_args)
+{
+	if (rewrite_pattern != MLX5DR_INVALID_PATTERN_INDEX)
+		return dr_ste_v1_set_accelerated_rewrite_actions(hw_ste_p,
+								 action,
+								 num_of_actions,
+								 rewrite_pattern,
+								 rewrite_args);
+
+	/* fall back to the code that doesn't support accelerated modify header */
+	return dr_ste_v1_set_basic_rewrite_actions(hw_ste_p,
+						   action,
+						   num_of_actions,
+						   rewrite_args);
+}
+
 static void dr_ste_v1_set_aso_flow_meter(u8 *d_action,
 					 u32 object_id,
 					 u32 offset,
@@ -614,6 +652,7 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		}
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->modify_actions,
+					      attr->modify_pat_idx,
 					      attr->modify_index);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
@@ -744,6 +783,7 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->decap_actions,
+					      attr->decap_pat_idx,
 					      attr->decap_index);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
@@ -799,6 +839,7 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		}
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->modify_actions,
+					      attr->modify_pat_idx,
 					      attr->modify_index);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
index 790a17d6207f..ca3b0f1453a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -100,7 +100,7 @@ struct mlx5_ifc_ste_double_action_insert_with_ptr_v1_bits {
 	u8         pointer[0x20];
 };
 
-struct mlx5_ifc_ste_double_action_modify_action_list_v1_bits {
+struct mlx5_ifc_ste_double_action_accelerated_modify_action_list_v1_bits {
 	u8         action_id[0x8];
 	u8         modify_actions_pattern_pointer[0x18];
 
-- 
2.39.2

