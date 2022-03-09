Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCC54D3C38
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbiCIVj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbiCIVjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948CA85661
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFA461B16
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD1EC340F4;
        Wed,  9 Mar 2022 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861891;
        bh=6w4MlhsKS4yYYuMn1pyhV8V1K+FfgtSFteediroTS0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXSAI83FkeT8NCKf4ld69CFSTod9Sv+NYbTDa31qQg/+J3hx8dEIQafCxeFxFoRhU
         hIU8Zb0dFb7byq/P/t92pA2MbpDVVe7RkjXBVHHtMZHXRRyDbIFYcpuZuvUM3zSIIL
         4ACxhgSnI+jVVbQD+SXNJEy9q9z4e/lni61m+DEcE4pjms66pYCw+2kZ1ftALMiHqg
         PGQqCGBNYAzrvaXZGiyEuUX38GqXTAltc1ev20egdJKe7lhj3fTx0KKTkH0+Ya806S
         PqwdJ7ufsTjXC+08XvkYxbjx31d1qRbl8SvO1R9xIdszjdUTpbRURsFbjY36RNTVb8
         3XdEEpzvZV6dg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: DR, Add support for matching on Internet Header Length (IHL)
Date:   Wed,  9 Mar 2022 13:37:50 -0800
Message-Id: <20220309213755.610202-12-saeed@kernel.org>
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

Add support for matching on new field - Internet Header Length (IHL).

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 11 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste.c |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c  |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c  |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h   |  4 +++-
 include/linux/mlx5/mlx5_ifc.h                         |  5 ++++-
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 38971fe1dfe1..1668c2b2f60f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -47,6 +47,11 @@ static bool dr_mask_is_ttl_set(struct mlx5dr_match_spec *spec)
 	return spec->ttl_hoplimit;
 }
 
+static bool dr_mask_is_ipv4_ihl_set(struct mlx5dr_match_spec *spec)
+{
+	return spec->ipv4_ihl;
+}
+
 #define DR_MASK_IS_L2_DST(_spec, _misc, _inner_outer) (_spec.first_vid || \
 	(_spec).first_cfi || (_spec).first_prio || (_spec).cvlan_tag || \
 	(_spec).svlan_tag || (_spec).dmac_47_16 || (_spec).dmac_15_0 || \
@@ -507,7 +512,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(ste_ctx, &sb[idx++],
 								     &mask, inner, rx);
 
-			if (dr_mask_is_ttl_set(&mask.outer))
+			if (dr_mask_is_ttl_set(&mask.outer) ||
+			    dr_mask_is_ipv4_ihl_set(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv4_misc(ste_ctx, &sb[idx++],
 								  &mask, inner, rx);
 		}
@@ -614,7 +620,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(ste_ctx, &sb[idx++],
 								     &mask, inner, rx);
 
-			if (dr_mask_is_ttl_set(&mask.inner))
+			if (dr_mask_is_ttl_set(&mask.inner) ||
+			    dr_mask_is_ipv4_ihl_set(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv4_misc(ste_ctx, &sb[idx++],
 								  &mask, inner, rx);
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 187e29b409b6..c7094fb10a7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -793,6 +793,7 @@ static void dr_ste_copy_mask_spec(char *mask, struct mlx5dr_match_spec *spec, bo
 	spec->tcp_sport = IFC_GET_CLR(fte_match_set_lyr_2_4, mask, tcp_sport, clr);
 	spec->tcp_dport = IFC_GET_CLR(fte_match_set_lyr_2_4, mask, tcp_dport, clr);
 
+	spec->ipv4_ihl = IFC_GET_CLR(fte_match_set_lyr_2_4, mask, ipv4_ihl, clr);
 	spec->ttl_hoplimit = IFC_GET_CLR(fte_match_set_lyr_2_4, mask, ttl_hoplimit, clr);
 
 	spec->udp_sport = IFC_GET_CLR(fte_match_set_lyr_2_4, mask, udp_sport, clr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 2d62950f7a29..80424d1e3bb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1152,6 +1152,7 @@ dr_ste_v0_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, time_to_live, spec, ttl_hoplimit);
+	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, ihl, spec, ipv4_ihl);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 6ca06800f1d9..d248a428f872 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1331,6 +1331,7 @@ static int dr_ste_v1_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_TAG(eth_l3_ipv4_misc_v1, tag, time_to_live, spec, ttl_hoplimit);
+	DR_STE_SET_TAG(eth_l3_ipv4_misc_v1, tag, ihl, spec, ipv4_ihl);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 55fcb751e24a..02590f665174 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -555,7 +555,9 @@ struct mlx5dr_match_spec {
 	 */
 	u32 tcp_dport:16;
 
-	u32 reserved_auto1:24;
+	u32 reserved_auto1:16;
+	u32 ipv4_ihl:4;
+	u32 reserved_auto2:4;
 	u32 ttl_hoplimit:8;
 
 	/* UDP source port.;tcp and udp sport/dport are mutually exclusive */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 69985e4d8dfe..1f0c35162b7b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -493,7 +493,10 @@ struct mlx5_ifc_fte_match_set_lyr_2_4_bits {
 	u8         tcp_sport[0x10];
 	u8         tcp_dport[0x10];
 
-	u8         reserved_at_c0[0x18];
+	u8         reserved_at_c0[0x10];
+	u8         ipv4_ihl[0x4];
+	u8         reserved_at_c4[0x4];
+
 	u8         ttl_hoplimit[0x8];
 
 	u8         udp_sport[0x10];
-- 
2.35.1

