Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA20647A9C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiLIAPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLIAOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CF08D1A1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F2DACE2774
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B637BC433EF;
        Fri,  9 Dec 2022 00:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544880;
        bh=tCcGbybwvFvt+zsuonglP3aV004xgHuoycaywZKMrHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Esexxvajn4HNkzbwOKBwmh7i4JFpb7N7Z6e+rpA2Y/SGiSWOQVzCOdZfEsf4UOEJm
         l7IMs67jYucW+edmT/XYDxvljS2xG23U17JFRSZCjEe9cZeq0h9JkuhnqA60l53htQ
         6zFGzo9J3SuGdWNU+P2hWhmEERpIF9aBrG85sqm762aSX5cXO7uIETmJXfllWFfdT4
         e+2eros6w4XqhZTJDiT5QZbY+jciiLbFhFfBFL7E3AEsgwGI3GIRoXJq58zuzrdddq
         XODU/boSQ/35EY4DAq2/6SGYB6Uu7Zw+rjM+4LnuDVd5/hX//wjieYweKL6twFtUZb
         K9KTtyegFSkUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, Add support for range match action
Date:   Thu,  8 Dec 2022 16:14:14 -0800
Message-Id: <20221209001420.142794-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for matching on range.
The supported type of range is L2 frame size.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 173 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_dbg.c      |  29 ++-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   |  65 ++++++-
 .../mellanox/mlx5/core/steering/dr_types.h    |  26 +++
 .../mellanox/mlx5/core/steering/fs_dr.c       |  30 ++-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   |  35 ++++
 .../mellanox/mlx5/core/steering/mlx5dr.h      |   8 +
 7 files changed, 363 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index fc44fee2f9c2..ee104cf04392 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -44,6 +44,7 @@ static const char * const action_type_to_str[] = {
 	[DR_ACTION_TYP_INSERT_HDR] = "DR_ACTION_TYP_INSERT_HDR",
 	[DR_ACTION_TYP_REMOVE_HDR] = "DR_ACTION_TYP_REMOVE_HDR",
 	[DR_ACTION_TYP_ASO_FLOW_METER] = "DR_ACTION_TYP_ASO_FLOW_METER",
+	[DR_ACTION_TYP_RANGE] = "DR_ACTION_TYP_RANGE",
 	[DR_ACTION_TYP_MAX] = "DR_ACTION_UNKNOWN",
 };
 
@@ -61,6 +62,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
@@ -79,6 +81,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
@@ -94,6 +97,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
@@ -103,6 +107,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
@@ -116,6 +121,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
@@ -129,6 +135,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
@@ -141,6 +148,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
@@ -159,6 +167,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
 		[DR_ACTION_STATE_TERM] = {
@@ -169,6 +178,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -183,6 +193,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
@@ -190,6 +201,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_ASO_FLOW_METER]	= DR_ACTION_STATE_ASO,
@@ -197,6 +209,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -207,6 +220,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
@@ -220,6 +234,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
@@ -231,6 +246,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -250,6 +266,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 			[DR_ACTION_TYP_DROP]            = DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]              = DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -259,6 +276,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -276,6 +294,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
@@ -291,6 +310,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
@@ -299,6 +319,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -311,6 +332,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
@@ -324,6 +346,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
@@ -337,6 +360,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -354,6 +378,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_ASO] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]           = DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
@@ -365,6 +390,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
@@ -380,6 +406,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
@@ -388,6 +415,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -396,6 +424,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -407,6 +436,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
@@ -421,6 +451,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
@@ -433,6 +464,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
@@ -452,6 +484,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]       = DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_RANGE]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]           = DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]             = DR_ACTION_STATE_ASO,
 		},
@@ -756,6 +789,23 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			if (ret)
 				return ret;
 			break;
+		case DR_ACTION_TYP_RANGE:
+			ret = dr_action_get_dest_tbl_addr(matcher,
+							  action->range->hit_tbl_action->dest_tbl,
+							  rx_rule, &attr.final_icm_addr);
+			if (ret)
+				return ret;
+
+			ret = dr_action_get_dest_tbl_addr(matcher,
+							  action->range->miss_tbl_action->dest_tbl,
+							  rx_rule, &attr.range.miss_icm_addr);
+			if (ret)
+				return ret;
+
+			attr.range.definer_id = action->range->definer_id;
+			attr.range.min = action->range->min;
+			attr.range.max = action->range->max;
+			break;
 		case DR_ACTION_TYP_QP:
 			mlx5dr_info(dmn, "Domain doesn't support QP\n");
 			return -EOPNOTSUPP;
@@ -901,6 +951,7 @@ static unsigned int action_size[DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_TYP_REMOVE_HDR]   = sizeof(struct mlx5dr_action_reformat),
 	[DR_ACTION_TYP_SAMPLER]      = sizeof(struct mlx5dr_action_sampler),
 	[DR_ACTION_TYP_ASO_FLOW_METER] = sizeof(struct mlx5dr_action_aso_flow_meter),
+	[DR_ACTION_TYP_RANGE]        = sizeof(struct mlx5dr_action_range),
 };
 
 static struct mlx5dr_action *
@@ -968,6 +1019,123 @@ mlx5dr_action_create_dest_table(struct mlx5dr_table *tbl)
 	return NULL;
 }
 
+static void dr_action_range_definer_fill(u16 *format_id,
+					 u8 *dw_selectors,
+					 u8 *byte_selectors,
+					 u8 *match_mask)
+{
+	int i;
+
+	*format_id = MLX5_IFC_DEFINER_FORMAT_ID_SELECT;
+
+	dw_selectors[0] = MLX5_IFC_DEFINER_FORMAT_OFFSET_OUTER_ETH_PKT_LEN / 4;
+
+	for (i = 1; i < MLX5_IFC_DEFINER_DW_SELECTORS_NUM; i++)
+		dw_selectors[i] = MLX5_IFC_DEFINER_FORMAT_OFFSET_UNUSED;
+
+	for (i = 0; i < MLX5_IFC_DEFINER_BYTE_SELECTORS_NUM; i++)
+		byte_selectors[i] = MLX5_IFC_DEFINER_FORMAT_OFFSET_UNUSED;
+
+	MLX5_SET(match_definer_match_mask, match_mask,
+		 match_dw_0, 0xffffUL << 16);
+}
+
+static int dr_action_create_range_definer(struct mlx5dr_action *action)
+{
+	u8 match_mask[MLX5_FLD_SZ_BYTES(match_definer, match_mask)] = {};
+	u8 byte_selectors[MLX5_IFC_DEFINER_BYTE_SELECTORS_NUM] = {};
+	u8 dw_selectors[MLX5_IFC_DEFINER_DW_SELECTORS_NUM] = {};
+	struct mlx5dr_domain *dmn = action->range->dmn;
+	u32 definer_id;
+	u16 format_id;
+	int ret;
+
+	dr_action_range_definer_fill(&format_id,
+				     dw_selectors,
+				     byte_selectors,
+				     match_mask);
+
+	ret = mlx5dr_definer_get(dmn, format_id,
+				 dw_selectors, byte_selectors,
+				 match_mask, &definer_id);
+	if (ret)
+		return ret;
+
+	action->range->definer_id = definer_id;
+	return 0;
+}
+
+static void dr_action_destroy_range_definer(struct mlx5dr_action *action)
+{
+	mlx5dr_definer_put(action->range->dmn, action->range->definer_id);
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_dest_match_range(struct mlx5dr_domain *dmn,
+				      u32 field,
+				      struct mlx5_flow_table *hit_ft,
+				      struct mlx5_flow_table *miss_ft,
+				      u32 min,
+				      u32 max)
+{
+	struct mlx5dr_action *action;
+	int ret;
+
+	if (!mlx5dr_supp_match_ranges(dmn->mdev)) {
+		mlx5dr_dbg(dmn, "SELECT definer support is needed for match range\n");
+		return NULL;
+	}
+
+	if (field != MLX5_FLOW_DEST_RANGE_FIELD_PKT_LEN ||
+	    min > 0xffff || max > 0xffff) {
+		mlx5dr_err(dmn, "Invalid match range parameters\n");
+		return NULL;
+	}
+
+	action = dr_action_create_generic(DR_ACTION_TYP_RANGE);
+	if (!action)
+		return NULL;
+
+	action->range->hit_tbl_action =
+		mlx5dr_is_fw_table(hit_ft) ?
+			mlx5dr_action_create_dest_flow_fw_table(dmn, hit_ft) :
+			mlx5dr_action_create_dest_table(hit_ft->fs_dr_table.dr_table);
+
+	if (!action->range->hit_tbl_action)
+		goto free_action;
+
+	action->range->miss_tbl_action =
+		mlx5dr_is_fw_table(miss_ft) ?
+			mlx5dr_action_create_dest_flow_fw_table(dmn, miss_ft) :
+			mlx5dr_action_create_dest_table(miss_ft->fs_dr_table.dr_table);
+
+	if (!action->range->miss_tbl_action)
+		goto free_hit_tbl_action;
+
+	action->range->min = min;
+	action->range->max = max;
+	action->range->dmn = dmn;
+
+	ret = dr_action_create_range_definer(action);
+	if (ret)
+		goto free_miss_tbl_action;
+
+	/* No need to increase refcount on domain for this action,
+	 * the hit/miss table actions will do it internally.
+	 */
+
+	return action;
+
+free_miss_tbl_action:
+	mlx5dr_action_destroy(action->range->miss_tbl_action);
+free_hit_tbl_action:
+	mlx5dr_action_destroy(action->range->hit_tbl_action);
+free_action:
+	kfree(action);
+
+	return NULL;
+}
+
 struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
@@ -2015,6 +2183,11 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 	case DR_ACTION_TYP_ASO_FLOW_METER:
 		refcount_dec(&action->aso->dmn->refcount);
 		break;
+	case DR_ACTION_TYP_RANGE:
+		dr_action_destroy_range_definer(action);
+		mlx5dr_action_destroy(action->range->miss_tbl_action);
+		mlx5dr_action_destroy(action->range->hit_tbl_action);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 7adcf0eec13b..db81d881d38e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -49,7 +49,8 @@ enum dr_dump_rec_type {
 	DR_DUMP_REC_TYPE_ACTION_POP_VLAN = 3413,
 	DR_DUMP_REC_TYPE_ACTION_SAMPLER = 3415,
 	DR_DUMP_REC_TYPE_ACTION_INSERT_HDR = 3420,
-	DR_DUMP_REC_TYPE_ACTION_REMOVE_HDR = 3421
+	DR_DUMP_REC_TYPE_ACTION_REMOVE_HDR = 3421,
+	DR_DUMP_REC_TYPE_ACTION_MATCH_RANGE = 3425,
 };
 
 void mlx5dr_dbg_tbl_add(struct mlx5dr_table *tbl)
@@ -107,6 +108,8 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 {
 	struct mlx5dr_action *action = action_mem->action;
 	const u64 action_id = DR_DBG_PTR_TO_ID(action);
+	u64 hit_tbl_ptr, miss_tbl_ptr;
+	u32 hit_tbl_id, miss_tbl_id;
 
 	switch (action->action_type) {
 	case DR_ACTION_TYP_DROP:
@@ -198,6 +201,30 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 			   action->sampler->rx_icm_addr,
 			   action->sampler->tx_icm_addr);
 		break;
+	case DR_ACTION_TYP_RANGE:
+		if (action->range->hit_tbl_action->dest_tbl->is_fw_tbl) {
+			hit_tbl_id = action->range->hit_tbl_action->dest_tbl->fw_tbl.id;
+			hit_tbl_ptr = 0;
+		} else {
+			hit_tbl_id = action->range->hit_tbl_action->dest_tbl->tbl->table_id;
+			hit_tbl_ptr =
+				DR_DBG_PTR_TO_ID(action->range->hit_tbl_action->dest_tbl->tbl);
+		}
+
+		if (action->range->miss_tbl_action->dest_tbl->is_fw_tbl) {
+			miss_tbl_id = action->range->miss_tbl_action->dest_tbl->fw_tbl.id;
+			miss_tbl_ptr = 0;
+		} else {
+			miss_tbl_id = action->range->miss_tbl_action->dest_tbl->tbl->table_id;
+			miss_tbl_ptr =
+				DR_DBG_PTR_TO_ID(action->range->miss_tbl_action->dest_tbl->tbl);
+		}
+
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%llx,0x%x,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_MATCH_RANGE, action_id, rule_id,
+			   hit_tbl_id, hit_tbl_ptr, miss_tbl_id, miss_tbl_ptr,
+			   action->range->definer_id);
+		break;
 	default:
 		return 0;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 87c29118c51b..084145f18084 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -13,6 +13,7 @@ enum dr_ste_v1_entry_format {
 	DR_STE_V1_TYPE_BWC_BYTE	= 0x0,
 	DR_STE_V1_TYPE_BWC_DW	= 0x1,
 	DR_STE_V1_TYPE_MATCH	= 0x2,
+	DR_STE_V1_TYPE_MATCH_RANGES = 0x7,
 };
 
 /* Lookup type is built from 2B: [ Definer mode 1B ][ Definer index 1B ] */
@@ -269,7 +270,12 @@ static void dr_ste_v1_set_entry_type(u8 *hw_ste_p, u8 entry_type)
 
 bool dr_ste_v1_is_miss_addr_set(u8 *hw_ste_p)
 {
-	return false;
+	u8 entry_type = MLX5_GET(ste_match_bwc_v1, hw_ste_p, entry_format);
+
+	/* unlike MATCH STE, for MATCH_RANGES STE both hit and miss addresses
+	 * are part of the action, so they both set as part of STE init
+	 */
+	return entry_type == DR_STE_V1_TYPE_MATCH_RANGES;
 }
 
 void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
@@ -525,6 +531,27 @@ static void dr_ste_v1_set_aso_flow_meter(u8 *d_action,
 		 init_color);
 }
 
+static void dr_ste_v1_set_match_range_pkt_len(u8 *hw_ste_p, u32 definer_id,
+					      u32 min, u32 max)
+{
+	MLX5_SET(ste_match_ranges_v1, hw_ste_p, match_definer_ctx_idx, definer_id);
+
+	/* When the STE will be sent, its mask and tags will be swapped in
+	 * dr_ste_v1_prepare_for_postsend(). This, however, is match range STE
+	 * which doesn't have mask, and shouldn't have mask/tag swapped.
+	 * We're using the common utilities functions to send this STE, so need
+	 * to allow for this swapping - place the values in the corresponding
+	 * locations to allow flipping them when writing to ICM.
+	 *
+	 * min/max_value_2 corresponds to match_dw_0 in its definer.
+	 * To allow mask/tag swapping, writing the min/max_2 to min/max_0.
+	 *
+	 * Pkt len is 2 bytes that are stored in the higher section of the DW.
+	 */
+	MLX5_SET(ste_match_ranges_v1, hw_ste_p, min_value_0, min << 16);
+	MLX5_SET(ste_match_ranges_v1, hw_ste_p, max_value_0, max << 16);
+}
+
 static void dr_ste_v1_arr_init_next_match(u8 **last_ste,
 					  u32 *added_stes,
 					  u16 gvmi)
@@ -540,6 +567,14 @@ static void dr_ste_v1_arr_init_next_match(u8 **last_ste,
 	memset(action, 0, MLX5_FLD_SZ_BYTES(ste_mask_and_match_v1, action));
 }
 
+static void dr_ste_v1_arr_init_next_match_range(u8 **last_ste,
+						u32 *added_stes,
+						u16 gvmi)
+{
+	dr_ste_v1_arr_init_next_match(last_ste, added_stes, gvmi);
+	dr_ste_v1_set_entry_type(*last_ste, DR_STE_V1_TYPE_MATCH_RANGES);
+}
+
 void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 			      u8 *action_type_set,
 			      u32 actions_caps,
@@ -675,6 +710,20 @@ void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	}
 
+	if (action_type_set[DR_ACTION_TYP_RANGE]) {
+		/* match ranges requires a new STE of its own type */
+		dr_ste_v1_arr_init_next_match_range(&last_ste, added_stes, attr->gvmi);
+		dr_ste_v1_set_miss_addr(last_ste, attr->range.miss_icm_addr);
+
+		/* we do not support setting any action on the match ranges STE */
+		action_sz = 0;
+
+		dr_ste_v1_set_match_range_pkt_len(last_ste,
+						  attr->range.definer_id,
+						  attr->range.min,
+						  attr->range.max);
+	}
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
@@ -863,6 +912,20 @@ void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	}
 
+	if (action_type_set[DR_ACTION_TYP_RANGE]) {
+		/* match ranges requires a new STE of its own type */
+		dr_ste_v1_arr_init_next_match_range(&last_ste, added_stes, attr->gvmi);
+		dr_ste_v1_set_miss_addr(last_ste, attr->range.miss_icm_addr);
+
+		/* we do not support setting any action on the match ranges STE */
+		action_sz = 0;
+
+		dr_ste_v1_set_match_range_pkt_len(last_ste,
+						  attr->range.definer_id,
+						  attr->range.min,
+						  attr->range.max);
+	}
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a3e8ce415563..2b769dcbd453 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -129,6 +129,7 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_REMOVE_HDR,
 	DR_ACTION_TYP_SAMPLER,
 	DR_ACTION_TYP_ASO_FLOW_METER,
+	DR_ACTION_TYP_RANGE,
 	DR_ACTION_TYP_MAX,
 };
 
@@ -283,6 +284,13 @@ struct mlx5dr_ste_actions_attr {
 		u8 dest_reg_id;
 		u8 init_color;
 	} aso_flow_meter;
+
+	struct {
+		u64	miss_icm_addr;
+		u32	definer_id;
+		u32	min;
+		u32	max;
+	} range;
 };
 
 void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
@@ -1029,6 +1037,15 @@ struct mlx5dr_action_dest_tbl {
 	};
 };
 
+struct mlx5dr_action_range {
+	struct mlx5dr_domain *dmn;
+	struct mlx5dr_action *hit_tbl_action;
+	struct mlx5dr_action *miss_tbl_action;
+	u32 definer_id;
+	u32 min;
+	u32 max;
+};
+
 struct mlx5dr_action_ctr {
 	u32 ctr_id;
 	u32 offset;
@@ -1075,6 +1092,7 @@ struct mlx5dr_action {
 		struct mlx5dr_action_push_vlan *push_vlan;
 		struct mlx5dr_action_flow_tag *flow_tag;
 		struct mlx5dr_action_aso_flow_meter *aso;
+		struct mlx5dr_action_range *range;
 	};
 };
 
@@ -1500,4 +1518,12 @@ static inline bool mlx5dr_is_fw_table(struct mlx5_flow_table *ft)
 	return !ft->fs_dr_table.dr_table;
 }
 
+static inline bool mlx5dr_supp_match_ranges(struct mlx5_core_dev *dev)
+{
+	return (MLX5_CAP_GEN(dev, steering_format_version) >=
+		MLX5_STEERING_FORMAT_CONNECTX_6DX) &&
+	       (MLX5_CAP_GEN_64(dev, match_definer_format_supported) &
+			(1ULL << MLX5_IFC_DEFINER_FORMAT_ID_SELECT));
+}
+
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index c78fb016c245..984653756779 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -215,6 +215,17 @@ static struct mlx5dr_action *create_ft_action(struct mlx5dr_domain *domain,
 	return mlx5dr_action_create_dest_table(dest_ft->fs_dr_table.dr_table);
 }
 
+static struct mlx5dr_action *create_range_action(struct mlx5dr_domain *domain,
+						 struct mlx5_flow_rule *dst)
+{
+	return mlx5dr_action_create_dest_match_range(domain,
+						     dst->dest_attr.range.field,
+						     dst->dest_attr.range.hit_ft,
+						     dst->dest_attr.range.miss_ft,
+						     dst->dest_attr.range.min,
+						     dst->dest_attr.range.max);
+}
+
 static struct mlx5dr_action *create_action_push_vlan(struct mlx5dr_domain *domain,
 						     struct mlx5_fs_vlan *vlan)
 {
@@ -468,6 +479,15 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
 				term_actions[num_term_actions++].dest = tmp_action;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_RANGE:
+				tmp_action = create_range_action(domain, dst);
+				if (!tmp_action) {
+					err = -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+				term_actions[num_term_actions++].dest = tmp_action;
+				break;
 			default:
 				err = -EOPNOTSUPP;
 				goto free_actions;
@@ -781,11 +801,19 @@ static int mlx5_cmd_dr_destroy_ns(struct mlx5_flow_root_namespace *ns)
 static u32 mlx5_cmd_dr_get_capabilities(struct mlx5_flow_root_namespace *ns,
 					enum fs_flow_table_type ft_type)
 {
+	u32 steering_caps = 0;
+
 	if (ft_type != FS_FT_FDB ||
 	    MLX5_CAP_GEN(ns->dev, steering_format_version) == MLX5_STEERING_FORMAT_CONNECTX_5)
 		return 0;
 
-	return MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX | MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX;
+	steering_caps |= MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX;
+	steering_caps |= MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX;
+
+	if (mlx5dr_supp_match_ranges(ns->dev))
+		steering_caps |= MLX5_FLOW_STEERING_CAP_MATCH_RANGES;
+
+	return steering_caps;
 }
 
 bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
index 34c2bd17a8b4..790a17d6207f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -165,6 +165,41 @@ struct mlx5_ifc_ste_mask_and_match_v1_bits {
 	u8         action[0x60];
 };
 
+struct mlx5_ifc_ste_match_ranges_v1_bits {
+	u8         entry_format[0x8];
+	u8         counter_id[0x18];
+
+	u8         miss_address_63_48[0x10];
+	u8         match_definer_ctx_idx[0x8];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         reserved_at_5a[0x1];
+	u8         match_polarity[0x1];
+	u8         reparse[0x1];
+	u8         reserved_at_5d[0x3];
+
+	u8         next_table_base_63_48[0x10];
+	u8         hash_definer_ctx_idx[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         hash_type[0x2];
+	u8         hash_after_actions[0x1];
+	u8         reserved_at_9e[0x2];
+
+	u8         action[0x60];
+
+	u8         max_value_0[0x20];
+	u8         min_value_0[0x20];
+	u8         max_value_1[0x20];
+	u8         min_value_1[0x20];
+	u8         max_value_2[0x20];
+	u8         min_value_2[0x20];
+	u8         max_value_3[0x20];
+	u8         min_value_3[0x20];
+};
+
 struct mlx5_ifc_ste_eth_l2_src_v1_bits {
 	u8         reserved_at_0[0x1];
 	u8         sx_sniffer[0x1];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 6ea50436ea61..9afd268a2573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -140,6 +140,14 @@ mlx5dr_action_create_aso(struct mlx5dr_domain *dmn,
 			 u8 init_color,
 			 u8 meter_id);
 
+struct mlx5dr_action *
+mlx5dr_action_create_dest_match_range(struct mlx5dr_domain *dmn,
+				      u32 field,
+				      struct mlx5_flow_table *hit_ft,
+				      struct mlx5_flow_table *miss_ft,
+				      u32 min,
+				      u32 max);
+
 int mlx5dr_action_destroy(struct mlx5dr_action *action);
 
 int mlx5dr_definer_get(struct mlx5dr_domain *dmn, u16 format_id,
-- 
2.38.1

