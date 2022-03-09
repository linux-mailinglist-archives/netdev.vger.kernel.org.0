Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1C4D3C3B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbiCIVje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiCIVjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7395854BC7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 098B661B0D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B24AC340EE;
        Wed,  9 Mar 2022 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861894;
        bh=zjrS8b3DpLY96h8Ju/XcrM3NoX317+2slxhILOQlcmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r20OG4rdkNVZAZzWbM3sc+amzC2tYjtt7tKDwAIq/p+CSrLSK2NZCTQUwNtJJfZl2
         Swt5Dy+cZ11GgCX9RJ9JYm0XXCWyZm0D5apJaoOat3aR4yAWFGKyH2QgImFLNK4UES
         uIINGtHl87ATff3o2MVVBMsK25YKIXf1zNZ4jkmlFP/yNRv76DJxU4FQXk/warvMXS
         16BJanixx7GcNjj+FeCyz9vOHnnlMYB1bF6DwMO4ODBs55M1XxcugLD+S7oZ4OyKlh
         qE+WhxUzqjQCgjr0k2U8xg+P88+3PcV4O9eBmFm9XHOAPqFSOdVoyYCoysd2DiD8Nm
         sj6UTKbyHWhXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5: DR, Refactor ste_ctx handling for STE v0/1
Date:   Wed,  9 Mar 2022 13:37:54 -0800
Message-Id: <20220309213755.610202-16-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

As preparation for supporting ConnectX-7, this patches changes handling
of ste_ctx handling for existing STE v0 and V1:
 - each context is now a static struct, and it has a corresponding getter
 - v0 and v1 were extended to contain the fields that are required for
   integrating STEv2.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 21 ++++++++-----------
 .../mellanox/mlx5/core/steering/dr_ste.h      |  6 ++++--
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  9 +++++++-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 20 ++++++++++++++++--
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 5 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index c7094fb10a7f..b25df6ae8ef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -523,8 +523,8 @@ void mlx5dr_ste_set_actions_tx(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes)
 {
-	ste_ctx->set_actions_tx(dmn, action_type_set, hw_ste_arr,
-				attr, added_stes);
+	ste_ctx->set_actions_tx(dmn, action_type_set, ste_ctx->actions_caps,
+				hw_ste_arr, attr, added_stes);
 }
 
 void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
@@ -534,8 +534,8 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes)
 {
-	ste_ctx->set_actions_rx(dmn, action_type_set, hw_ste_arr,
-				attr, added_stes);
+	ste_ctx->set_actions_rx(dmn, action_type_set, ste_ctx->actions_caps,
+				hw_ste_arr, attr, added_stes);
 }
 
 const struct mlx5dr_ste_action_modify_field *
@@ -1361,15 +1361,12 @@ void mlx5dr_ste_build_tnl_header_0_1(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_header_0_1_init(sb, mask);
 }
 
-static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
-	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
-	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = &ste_ctx_v1,
-};
-
 struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version)
 {
-	if (version > MLX5_STEERING_FORMAT_CONNECTX_6DX)
-		return NULL;
+	if (version == MLX5_STEERING_FORMAT_CONNECTX_5)
+		return mlx5dr_ste_get_ctx_v0();
+	else if (version == MLX5_STEERING_FORMAT_CONNECTX_6DX)
+		return mlx5dr_ste_get_ctx_v1();
 
-	return mlx5dr_ste_ctx_arr[version];
+	return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index ca8fa32b8680..9d9b073df75b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -161,11 +161,13 @@ struct mlx5dr_ste_ctx {
 	u32 actions_caps;
 	void (*set_actions_rx)(struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
+			       u32 actions_caps,
 			       u8 *hw_ste_arr,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes);
 	void (*set_actions_tx)(struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
+			       u32 actions_caps,
 			       u8 *hw_ste_arr,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes);
@@ -197,7 +199,7 @@ struct mlx5dr_ste_ctx {
 	void (*prepare_for_postsend)(u8 *hw_ste_p, u32 ste_size);
 };
 
-extern struct mlx5dr_ste_ctx ste_ctx_v0;
-extern struct mlx5dr_ste_ctx ste_ctx_v1;
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx_v0(void);
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx_v1(void);
 
 #endif  /* _DR_STE_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 80424d1e3bb7..5a322335f204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -408,6 +408,7 @@ static void dr_ste_v0_arr_init_next(u8 **last_ste,
 static void
 dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 			 u8 *action_type_set,
+			 u32 actions_caps,
 			 u8 *last_ste,
 			 struct mlx5dr_ste_actions_attr *attr,
 			 u32 *added_stes)
@@ -477,6 +478,7 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 static void
 dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 			 u8 *action_type_set,
+			 u32 actions_caps,
 			 u8 *last_ste,
 			 struct mlx5dr_ste_actions_attr *attr,
 			 u32 *added_stes)
@@ -1898,7 +1900,7 @@ static void dr_ste_v0_build_tnl_header_0_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_header_0_1_tag;
 }
 
-struct mlx5dr_ste_ctx ste_ctx_v0 = {
+static struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
 	.build_eth_l3_ipv6_src_init	= &dr_ste_v0_build_eth_l3_ipv6_src_init,
@@ -1951,3 +1953,8 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.set_action_copy		= &dr_ste_v0_set_action_copy,
 	.set_action_decap_l3_list	= &dr_ste_v0_set_action_decap_l3_list,
 };
+
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx_v0(void)
+{
+	return &ste_ctx_v0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 4a7b038dd15d..2f6d0d62874f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -513,6 +513,7 @@ static void dr_ste_v1_arr_init_next_match(u8 **last_ste,
 
 static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 				     u8 *action_type_set,
+				     u32 actions_caps,
 				     u8 *last_ste,
 				     struct mlx5dr_ste_actions_attr *attr,
 				     u32 *added_stes)
@@ -533,6 +534,10 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_pop_vlan(last_ste, action, attr->vlans.count);
 		action_sz -= DR_STE_ACTION_SINGLE_SZ;
 		action += DR_STE_ACTION_SINGLE_SZ;
+
+		/* Check if vlan_pop and modify_hdr on same STE is supported */
+		if (!(actions_caps & DR_STE_CTX_ACTION_CAP_POP_MDFY))
+			allow_modify_hdr = false;
 	}
 
 	if (action_type_set[DR_ACTION_TYP_CTR])
@@ -632,6 +637,7 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 
 static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 				     u8 *action_type_set,
+				     u32 actions_caps,
 				     u8 *last_ste,
 				     struct mlx5dr_ste_actions_attr *attr,
 				     u32 *added_stes)
@@ -682,6 +688,10 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		action_sz -= DR_STE_ACTION_SINGLE_SZ;
 		action += DR_STE_ACTION_SINGLE_SZ;
 		allow_ctr = false;
+
+		/* Check if vlan_pop and modify_hdr on same STE is supported */
+		if (!(actions_caps & DR_STE_CTX_ACTION_CAP_POP_MDFY))
+			allow_modify_hdr = false;
 	}
 
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
@@ -2045,7 +2055,7 @@ dr_ste_v1_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag;
 }
 
-struct mlx5dr_ste_ctx ste_ctx_v1 = {
+static struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
 	.build_eth_l3_ipv6_src_init	= &dr_ste_v1_build_eth_l3_ipv6_src_init,
@@ -2090,7 +2100,8 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Actions */
 	.actions_caps			= DR_STE_CTX_ACTION_CAP_TX_POP |
 					  DR_STE_CTX_ACTION_CAP_RX_PUSH |
-					  DR_STE_CTX_ACTION_CAP_RX_ENCAP,
+					  DR_STE_CTX_ACTION_CAP_RX_ENCAP |
+					  DR_STE_CTX_ACTION_CAP_POP_MDFY,
 	.set_actions_rx			= &dr_ste_v1_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v1_set_actions_tx,
 	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v1_action_modify_field_arr),
@@ -2102,3 +2113,8 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Send */
 	.prepare_for_postsend		= &dr_ste_v1_prepare_for_postsend,
 };
+
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx_v1(void)
+{
+	return &ste_ctx_v1;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 02590f665174..88092fabf55b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -91,6 +91,7 @@ enum mlx5dr_ste_ctx_action_cap {
 	DR_STE_CTX_ACTION_CAP_TX_POP   = 1 << 0,
 	DR_STE_CTX_ACTION_CAP_RX_PUSH  = 1 << 1,
 	DR_STE_CTX_ACTION_CAP_RX_ENCAP = 1 << 2,
+	DR_STE_CTX_ACTION_CAP_POP_MDFY = 1 << 3,
 };
 
 enum {
-- 
2.35.1

