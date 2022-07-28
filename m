Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCC58475F
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiG1U6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiG1U5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FDD77574
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 127CB60F1B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAE1C433D7;
        Thu, 28 Jul 2022 20:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041852;
        bh=cHTW6DQbeMBBmAtoYahR9XINzYfwKz4tDQx+D1ryhV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyUwuQ+icxZ3t335CsfhG+GqkIgAwwB/7nRRbUk2yDIPJwkCBXmtlHy2QclVqFiN6
         NYcxmbQbus7RUJPcf2KYx1az/4TPmb3hQUH2PYg+dU2AsBpxbBpMnwpQ1ZMtKINTNN
         2YPtuDLRXKu/AbAS7H2CPFRGPC3bgWcHFCUsWf7TbLPOTeTFZQn7Rt/fi0pSWksyH0
         ufjkOCksbkd247bPW5AZT4CdjWBUQcGCRWjlXYx+yGWFfkN5vp73K/vevp+4bxLANi
         /cE09O4SdMW8oy3e+sVKIDG4RxJyc07ujQDvB6A9BYQh6vde9GovqCegDCLsPZao0E
         IgAepWajpPsfg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Add support for flow metering ASO
Date:   Thu, 28 Jul 2022 13:57:15 -0700
Message-Id: <20220728205728.143074-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for ASO action of type flow metering
on device that supports STEv1.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Hamdan Igbaria <hamdani@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 99 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 56 +++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 17 ++++
 .../mellanox/mlx5/core/steering/fs_dr.c       | 21 ++++
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h | 26 +++++
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  8 ++
 6 files changed, 227 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 1383550f44c1..b1dfad274a39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -22,6 +22,7 @@ enum dr_action_valid_state {
 	DR_ACTION_STATE_PUSH_VLAN,
 	DR_ACTION_STATE_NON_TERM,
 	DR_ACTION_STATE_TERM,
+	DR_ACTION_STATE_ASO,
 	DR_ACTION_STATE_MAX,
 };
 
@@ -42,6 +43,7 @@ static const char * const action_type_to_str[] = {
 	[DR_ACTION_TYP_SAMPLER] = "DR_ACTION_TYP_SAMPLER",
 	[DR_ACTION_TYP_INSERT_HDR] = "DR_ACTION_TYP_INSERT_HDR",
 	[DR_ACTION_TYP_REMOVE_HDR] = "DR_ACTION_TYP_REMOVE_HDR",
+	[DR_ACTION_TYP_ASO_FLOW_METER] = "DR_ACTION_TYP_ASO_FLOW_METER",
 	[DR_ACTION_TYP_MAX] = "DR_ACTION_UNKNOWN",
 };
 
@@ -71,6 +73,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -85,6 +88,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -93,6 +97,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -105,6 +110,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -118,6 +124,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
@@ -128,6 +135,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -145,6 +153,13 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
+		},
+		[DR_ACTION_STATE_ASO] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -163,18 +178,21 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -185,6 +203,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -196,6 +215,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -206,6 +226,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -219,6 +240,16 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
+		},
+		[DR_ACTION_STATE_ASO] = {
+			[DR_ACTION_TYP_L2_TO_TNL_L2]    = DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]    = DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_MODIFY_HDR]      = DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_PUSH_VLAN]       = DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
+			[DR_ACTION_TYP_DROP]            = DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]              = DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -240,6 +271,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -253,6 +285,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -261,6 +294,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -272,6 +306,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -284,6 +319,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -296,6 +332,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -312,6 +349,13 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
+		},
+		[DR_ACTION_STATE_ASO] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_VPORT]           = DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -331,6 +375,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -338,6 +383,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]  = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -345,6 +391,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]  = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -356,6 +403,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -368,6 +416,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]  = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -379,6 +428,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]  = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -393,6 +443,17 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_ASO_FLOW_METER]  = DR_ACTION_STATE_ASO,
+		},
+		[DR_ACTION_STATE_ASO] = {
+			[DR_ACTION_TYP_L2_TO_TNL_L2]    = DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]    = DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_MODIFY_HDR]      = DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_PUSH_VLAN]       = DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_VPORT]           = DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -738,6 +799,12 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.reformat.param_0 = action->reformat->param_0;
 			attr.reformat.param_1 = action->reformat->param_1;
 			break;
+		case DR_ACTION_TYP_ASO_FLOW_METER:
+			attr.aso_flow_meter.obj_id = action->aso->obj_id;
+			attr.aso_flow_meter.offset = action->aso->offset;
+			attr.aso_flow_meter.dest_reg_id = action->aso->dest_reg_id;
+			attr.aso_flow_meter.init_color = action->aso->init_color;
+			break;
 		default:
 			mlx5dr_err(dmn, "Unsupported action type %d\n", action_type);
 			return -EINVAL;
@@ -798,6 +865,7 @@ static unsigned int action_size[DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_TYP_INSERT_HDR]   = sizeof(struct mlx5dr_action_reformat),
 	[DR_ACTION_TYP_REMOVE_HDR]   = sizeof(struct mlx5dr_action_reformat),
 	[DR_ACTION_TYP_SAMPLER]      = sizeof(struct mlx5dr_action_sampler),
+	[DR_ACTION_TYP_ASO_FLOW_METER] = sizeof(struct mlx5dr_action_aso_flow_meter),
 };
 
 static struct mlx5dr_action *
@@ -1830,6 +1898,34 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 	return action;
 }
 
+struct mlx5dr_action *
+mlx5dr_action_create_aso(struct mlx5dr_domain *dmn, u32 obj_id,
+			 u8 dest_reg_id, u8 aso_type,
+			 u8 init_color, u8 meter_id)
+{
+	struct mlx5dr_action *action;
+
+	if (aso_type != MLX5_EXE_ASO_FLOW_METER)
+		return NULL;
+
+	if (init_color > MLX5_FLOW_METER_COLOR_UNDEFINED)
+		return NULL;
+
+	action = dr_action_create_generic(DR_ACTION_TYP_ASO_FLOW_METER);
+	if (!action)
+		return NULL;
+
+	action->aso->obj_id = obj_id;
+	action->aso->offset = meter_id;
+	action->aso->dest_reg_id = dest_reg_id;
+	action->aso->init_color = init_color;
+	action->aso->dmn = dmn;
+
+	refcount_inc(&dmn->refcount);
+
+	return action;
+}
+
 int mlx5dr_action_destroy(struct mlx5dr_action *action)
 {
 	if (WARN_ON_ONCE(refcount_read(&action->refcount) > 1))
@@ -1881,6 +1977,9 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 	case DR_ACTION_TYP_SAMPLER:
 		refcount_dec(&action->sampler->dmn->refcount);
 		break;
+	case DR_ACTION_TYP_ASO_FLOW_METER:
+		refcount_dec(&action->aso->dmn->refcount);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index fcb962c6db2e..ee677a5c76be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -89,6 +89,7 @@ enum dr_ste_v1_action_id {
 	DR_STE_V1_ACTION_ID_QUEUE_ID_SEL		= 0x0d,
 	DR_STE_V1_ACTION_ID_ACCELERATED_LIST		= 0x0e,
 	DR_STE_V1_ACTION_ID_MODIFY_LIST			= 0x0f,
+	DR_STE_V1_ACTION_ID_ASO				= 0x12,
 	DR_STE_V1_ACTION_ID_TRAILER			= 0x13,
 	DR_STE_V1_ACTION_ID_COUNTER_ID			= 0x14,
 	DR_STE_V1_ACTION_ID_MAX				= 0x21,
@@ -129,6 +130,10 @@ enum {
 	DR_STE_V1_ACTION_MDFY_FLD_REGISTER_0_1		= 0x91,
 };
 
+enum dr_ste_v1_aso_ctx_type {
+	DR_STE_V1_ASO_CTX_TYPE_POLICERS = 0x2,
+};
+
 static const struct mlx5dr_ste_action_modify_field dr_ste_v1_action_modify_field_arr[] = {
 	[MLX5_ACTION_IN_FIELD_OUT_SMAC_47_16] = {
 		.hw_field = DR_STE_V1_ACTION_MDFY_FLD_SRC_L2_OUT_0, .start = 0, .end = 31,
@@ -494,6 +499,27 @@ static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
+static void dr_ste_v1_set_aso_flow_meter(u8 *d_action,
+					 u32 object_id,
+					 u32 offset,
+					 u8 dest_reg_id,
+					 u8 init_color)
+{
+	MLX5_SET(ste_double_action_aso_v1, d_action, action_id,
+		 DR_STE_V1_ACTION_ID_ASO);
+	MLX5_SET(ste_double_action_aso_v1, d_action, aso_context_number,
+		 object_id + (offset / MLX5DR_ASO_FLOW_METER_NUM_PER_OBJ));
+	/* Convert reg_c index to HW 64bit index */
+	MLX5_SET(ste_double_action_aso_v1, d_action, dest_reg_id,
+		 (dest_reg_id - 1) / 2);
+	MLX5_SET(ste_double_action_aso_v1, d_action, aso_context_type,
+		 DR_STE_V1_ASO_CTX_TYPE_POLICERS);
+	MLX5_SET(ste_double_action_aso_v1, d_action, flow_meter.line_id,
+		 offset % MLX5DR_ASO_FLOW_METER_NUM_PER_OBJ);
+	MLX5_SET(ste_double_action_aso_v1, d_action, flow_meter.initial_color,
+		 init_color);
+}
+
 static void dr_ste_v1_arr_init_next_match(u8 **last_ste,
 					  u32 *added_stes,
 					  u16 gvmi)
@@ -629,6 +655,21 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		action += DR_STE_ACTION_SINGLE_SZ;
 	}
 
+	if (action_type_set[DR_ACTION_TYP_ASO_FLOW_METER]) {
+		if (action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_aso_flow_meter(action,
+					     attr->aso_flow_meter.obj_id,
+					     attr->aso_flow_meter.offset,
+					     attr->aso_flow_meter.dest_reg_id,
+					     attr->aso_flow_meter.init_color);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+	}
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
@@ -802,6 +843,21 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		action += DR_STE_ACTION_SINGLE_SZ;
 	}
 
+	if (action_type_set[DR_ACTION_TYP_ASO_FLOW_METER]) {
+		if (action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_aso_flow_meter(action,
+					     attr->aso_flow_meter.obj_id,
+					     attr->aso_flow_meter.offset,
+					     attr->aso_flow_meter.dest_reg_id,
+					     attr->aso_flow_meter.init_color);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+	}
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 98320e3945ad..feed227944b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -127,6 +127,7 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_INSERT_HDR,
 	DR_ACTION_TYP_REMOVE_HDR,
 	DR_ACTION_TYP_SAMPLER,
+	DR_ACTION_TYP_ASO_FLOW_METER,
 	DR_ACTION_TYP_MAX,
 };
 
@@ -271,6 +272,13 @@ struct mlx5dr_ste_actions_attr {
 		int	count;
 		u32	headers[MLX5DR_MAX_VLANS];
 	} vlans;
+
+	struct {
+		u32 obj_id;
+		u32 offset;
+		u8 dest_reg_id;
+		u8 init_color;
+	} aso_flow_meter;
 };
 
 void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
@@ -1035,6 +1043,14 @@ struct mlx5dr_rule_action_member {
 	struct list_head list;
 };
 
+struct mlx5dr_action_aso_flow_meter {
+	struct mlx5dr_domain *dmn;
+	u32 obj_id;
+	u32 offset;
+	u8 dest_reg_id;
+	u8 init_color;
+};
+
 struct mlx5dr_action {
 	enum mlx5dr_action_type action_type;
 	refcount_t refcount;
@@ -1049,6 +1065,7 @@ struct mlx5dr_action {
 		struct mlx5dr_action_vport *vport;
 		struct mlx5dr_action_push_vlan *push_vlan;
 		struct mlx5dr_action_flow_tag *flow_tag;
+		struct mlx5dr_action_aso_flow_meter *aso;
 	};
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 6a9abba92df6..75672663359d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -500,6 +500,27 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 		}
 	}
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) {
+		if (fte->action.exe_aso.type != MLX5_EXE_ASO_FLOW_METER) {
+			err = -EOPNOTSUPP;
+			goto free_actions;
+		}
+
+		tmp_action =
+			mlx5dr_action_create_aso(domain,
+						 fte->action.exe_aso.object_id,
+						 fte->action.exe_aso.return_reg_id,
+						 fte->action.exe_aso.type,
+						 fte->action.exe_aso.flow_meter.init_color,
+						 fte->action.exe_aso.flow_meter.meter_idx);
+		if (!tmp_action) {
+			err = -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+		actions[num_actions++] = tmp_action;
+	}
+
 	params.match_sz = match_sz;
 	params.match_buf = (u64 *)fte->val;
 	if (num_term_actions == 1) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 9604b2091358..fb078fa0f0cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -574,4 +574,30 @@ struct mlx5_ifc_dr_action_hw_copy_bits {
 	u8         reserved_at_38[0x8];
 };
 
+enum {
+	MLX5DR_ASO_FLOW_METER_NUM_PER_OBJ = 2,
+};
+
+struct mlx5_ifc_ste_aso_flow_meter_action_bits {
+	u8         reserved_at_0[0xc];
+	u8         action[0x1];
+	u8         initial_color[0x2];
+	u8         line_id[0x1];
+};
+
+struct mlx5_ifc_ste_double_action_aso_v1_bits {
+	u8         action_id[0x8];
+	u8         aso_context_number[0x18];
+
+	u8         dest_reg_id[0x2];
+	u8         change_ordering_tag[0x1];
+	u8         aso_check_ordering[0x1];
+	u8         aso_context_type[0x4];
+	u8         reserved_at_28[0x8];
+	union {
+		u8 aso_fields[0x10];
+		struct mlx5_ifc_ste_aso_flow_meter_action_bits flow_meter;
+	};
+};
+
 #endif /* MLX5_IFC_DR_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7626c85643b1..ecffc2cbe6fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -131,6 +131,14 @@ struct mlx5dr_action *mlx5dr_action_create_pop_vlan(void);
 struct mlx5dr_action *
 mlx5dr_action_create_push_vlan(struct mlx5dr_domain *domain, __be32 vlan_hdr);
 
+struct mlx5dr_action *
+mlx5dr_action_create_aso(struct mlx5dr_domain *dmn,
+			 u32 obj_id,
+			 u8 return_reg_id,
+			 u8 aso_type,
+			 u8 init_color,
+			 u8 meter_id);
+
 int mlx5dr_action_destroy(struct mlx5dr_action *action);
 
 static inline bool
-- 
2.37.1

