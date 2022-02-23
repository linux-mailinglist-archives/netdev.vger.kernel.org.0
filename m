Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360334C194C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbiBWRFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243123AbiBWRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B658506D6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC5F60FD3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5F5C340F0;
        Wed, 23 Feb 2022 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635879;
        bh=Du7xiMk5SSzjRwX3j1if1oehAGBWI9kJFCBhnlGMrr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIMhe8VNWsVT+Jhwi1ssh8i5q8uJ8r/6XY7w5N5eWsA3IzJbytAea9zsstxKmz2iS
         s0RnSLUK5EC4sWVB2ED7s0HpxOYBqlyNKM4vXyZLAolTor464N/O5Kb08prm8dOt8S
         EZ9imT0bOk3MzD9rJ5TIj/jKOAsAv9DDzS8SqyHHBJyZxI/ra1IB9pDb4Vw+8Q6E1y
         kYgkYz203aEnAy/CL/vqcXhLMPrx+e7Q/bVVftYgTBs+lAyYe71AfnqpffwelQPCnU
         WZtgiw/vrH+kLHxhe8LyUP4TCaW3BlFdfNBuaTFEAxWHs/Dj/7Fhq/EOAbflzjblsP
         LJrz/djLcx23A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/19] net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version
Date:   Wed, 23 Feb 2022 09:04:15 -0800
Message-Id: <20220223170430.295595-5-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
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

Currently SMFS allows adding rule with matching on src/dst IP w/o matching
on full ethertype or ip_version, which is not supported by HW.
This patch fixes this issue and adds the check as it is done in DMFS.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 20 +++---------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 32 ++++++++++++++++++-
 .../mellanox/mlx5/core/steering/dr_types.h    | 10 ++++++
 3 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index e87cf498c77b..38971fe1dfe1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -13,18 +13,6 @@ static bool dr_mask_is_dmac_set(struct mlx5dr_match_spec *spec)
 	return (spec->dmac_47_16 || spec->dmac_15_0);
 }
 
-static bool dr_mask_is_src_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->src_ip_127_96 || spec->src_ip_95_64 ||
-		spec->src_ip_63_32 || spec->src_ip_31_0);
-}
-
-static bool dr_mask_is_dst_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->dst_ip_127_96 || spec->dst_ip_95_64 ||
-		spec->dst_ip_63_32 || spec->dst_ip_31_0);
-}
-
 static bool dr_mask_is_l3_base_set(struct mlx5dr_match_spec *spec)
 {
 	return (spec->ip_protocol || spec->frag || spec->tcp_flags ||
@@ -503,11 +491,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (outer_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.outer))
+			if (DR_MASK_IS_DST_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.outer))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
@@ -610,11 +598,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (inner_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.inner))
+			if (DR_MASK_IS_DST_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.inner))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 7e61742e58a0..0bf687a71b10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -602,12 +602,34 @@ int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
 						 used_hw_action_num);
 }
 
+int mlx5dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
+				    struct mlx5dr_match_spec *spec)
+{
+	if (spec->ip_version) {
+		if (spec->ip_version != 0xf) {
+			mlx5dr_err(dmn,
+				   "Partial ip_version mask with src/dst IP is not supported\n");
+			return -EINVAL;
+		}
+	} else if (spec->ethertype != 0xffff &&
+		   (DR_MASK_IS_SRC_IP_SET(spec) || DR_MASK_IS_DST_IP_SET(spec))) {
+		mlx5dr_err(dmn,
+			   "Partial/no ethertype mask with src/dst IP is not supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 			       u8 match_criteria,
 			       struct mlx5dr_match_param *mask,
 			       struct mlx5dr_match_param *value)
 {
-	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
+	if (value)
+		return 0;
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC) {
 		if (mask->misc.source_port && mask->misc.source_port != 0xffff) {
 			mlx5dr_err(dmn,
 				   "Partial mask source_port is not supported\n");
@@ -621,6 +643,14 @@ int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 		}
 	}
 
+	if ((match_criteria & DR_MATCHER_CRITERIA_OUTER) &&
+	    mlx5dr_ste_build_pre_check_spec(dmn, &mask->outer))
+		return -EINVAL;
+
+	if ((match_criteria & DR_MATCHER_CRITERIA_INNER) &&
+	    mlx5dr_ste_build_pre_check_spec(dmn, &mask->inner))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 1b3d484b99be..55fcb751e24a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -798,6 +798,16 @@ struct mlx5dr_match_param {
 				       (_misc3)->icmpv4_code || \
 				       (_misc3)->icmpv4_header_data)
 
+#define DR_MASK_IS_SRC_IP_SET(_spec) ((_spec)->src_ip_127_96 || \
+				      (_spec)->src_ip_95_64  || \
+				      (_spec)->src_ip_63_32  || \
+				      (_spec)->src_ip_31_0)
+
+#define DR_MASK_IS_DST_IP_SET(_spec) ((_spec)->dst_ip_127_96 || \
+				      (_spec)->dst_ip_95_64  || \
+				      (_spec)->dst_ip_63_32  || \
+				      (_spec)->dst_ip_31_0)
+
 struct mlx5dr_esw_caps {
 	u64 drop_icm_address_rx;
 	u64 drop_icm_address_tx;
-- 
2.35.1

