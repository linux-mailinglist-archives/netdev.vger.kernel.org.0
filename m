Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D572791EA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgIYUTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbgIYURd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:33 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826342395C;
        Fri, 25 Sep 2020 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062703;
        bh=5fZE0ZMAEDROsnB/b1KGy/Gw6fPJUNFabJMn4eb/HwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMG2S/ggdMjds3HrifNGgavmCojBW/3RKgk6q/XnXFCDu/BGfMUnWhdMZ0tHq4PE9
         AkvDOR3NMmzOA2v4S9R5JZUFXebUigxQu1wsRf2Ewhmdh6Ujs65wxkxOYrfaVILzri
         PhCKp3U/a1tbe1v4q29uuVc6C20XPd5YONNhUFpw=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: DR, Call ste_builder directly with tag pointer
Date:   Fri, 25 Sep 2020 12:38:05 -0700
Message-Id: <20200925193809.463047-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Instead of getting the tag in each function, call the builder
directly with the tag. This will allow to use the same function
for building the tag and the bitmask.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 99 ++++++-------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 2 files changed, 33 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 970dbabe3ea2..b01aaec75622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -155,6 +155,13 @@ static u16 dr_ste_conv_bit_to_byte_mask(u8 *bit_mask)
 	return byte_mask;
 }
 
+static u8 *mlx5dr_ste_get_tag(u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
+
+	return hw_ste->tag;
+}
+
 void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask)
 {
 	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
@@ -748,7 +755,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 		mlx5dr_ste_set_bit_mask(ste_arr, sb->bit_mask);
 
-		ret = sb->ste_build_tag_func(value, sb, ste_arr);
+		ret = sb->ste_build_tag_func(value, sb, mlx5dr_ste_get_tag(ste_arr));
 		if (ret)
 			return ret;
 
@@ -1040,11 +1047,9 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 
 static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   u8 *hw_ste_p)
+					   u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_47_16, spec, dmac_47_16);
 	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_15_0, spec, dmac_15_0);
@@ -1111,11 +1116,9 @@ static void dr_ste_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *val
 
 static int dr_ste_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
 					    struct mlx5dr_ste_build *sb,
-					    u8 *hw_ste_p)
+					    u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_127_96, spec, dst_ip_127_96);
 	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_95_64, spec, dst_ip_95_64);
@@ -1151,11 +1154,9 @@ static void dr_ste_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *val
 
 static int dr_ste_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
 					    struct mlx5dr_ste_build *sb,
-					    u8 *hw_ste_p)
+					    u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_127_96, spec, src_ip_127_96);
 	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_95_64, spec, src_ip_95_64);
@@ -1213,11 +1214,9 @@ static void dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param
 
 static int dr_ste_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
 						struct mlx5dr_ste_build *sb,
-						u8 *hw_ste_p)
+						u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_address, spec, dst_ip_31_0);
 	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_address, spec, src_ip_31_0);
@@ -1303,12 +1302,10 @@ dr_ste_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
 }
 
 static int dr_ste_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
-					      bool inner, u8 *hw_ste_p)
+					      bool inner, u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc_spec = &value->misc;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l2_src, tag, first_vlan_id, spec, first_vid);
 	DR_STE_SET_TAG(eth_l2_src, tag, first_cfi, spec, first_cfi);
@@ -1378,16 +1375,14 @@ static void dr_ste_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l2_src, tag, smac_47_16, spec, smac_47_16);
 	DR_STE_SET_TAG(eth_l2_src, tag, smac_15_0, spec, smac_15_0);
 
-	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, hw_ste_p);
+	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
 }
 
 void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_build *sb,
@@ -1415,16 +1410,14 @@ static void dr_ste_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_47_16, spec, dmac_47_16);
 	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_15_0, spec, dmac_15_0);
 
-	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, hw_ste_p);
+	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
 }
 
 void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_build *sb,
@@ -1470,12 +1463,10 @@ static void dr_ste_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc *misc = &value->misc;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_47_16, spec, dmac_47_16);
 	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_15_0, spec, dmac_15_0);
@@ -1536,11 +1527,9 @@ static void dr_ste_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_param *va
 
 static int dr_ste_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
 					     struct mlx5dr_ste_build *sb,
-					     u8 *hw_ste_p)
+					     u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, time_to_live, spec, ttl_hoplimit);
 
@@ -1583,11 +1572,9 @@ static void dr_ste_build_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, tcp_dport);
 	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, tcp_sport);
@@ -1622,7 +1609,7 @@ void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
 
 static int dr_ste_build_empty_always_hit_tag(struct mlx5dr_match_param *value,
 					     struct mlx5dr_ste_build *sb,
-					     u8 *hw_ste_p)
+					     u8 *tag)
 {
 	return 0;
 }
@@ -1648,11 +1635,9 @@ static void dr_ste_build_mpls_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_mpls_tag(struct mlx5dr_match_param *value,
 				 struct mlx5dr_ste_build *sb,
-				 u8 *hw_ste_p)
+				 u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
-	u8 *tag = hw_ste->tag;
 
 	if (sb->inner)
 		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, inner, tag);
@@ -1691,11 +1676,9 @@ static void dr_ste_build_gre_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_gre_tag(struct mlx5dr_match_param *value,
 				struct mlx5dr_ste_build *sb,
-				u8 *hw_ste_p)
+				u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct  mlx5dr_match_misc *misc = &value->misc;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(gre, tag, gre_protocol, misc, gre_protocol);
 
@@ -1756,11 +1739,9 @@ static void dr_ste_build_flex_parser_0_bit_mask(struct mlx5dr_match_param *value
 
 static int dr_ste_build_flex_parser_0_tag(struct mlx5dr_match_param *value,
 					  struct mlx5dr_ste_build *sb,
-					  u8 *hw_ste_p)
+					  u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-	u8 *tag = hw_ste->tag;
 
 	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
@@ -1878,11 +1859,9 @@ static int dr_ste_build_flex_parser_1_bit_mask(struct mlx5dr_match_param *mask,
 
 static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value,
 					  struct mlx5dr_ste_build *sb,
-					  u8 *hw_ste_p)
+					  u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc3 *misc_3 = &value->misc3;
-	u8 *tag = hw_ste->tag;
 	u32 icmp_header_data;
 	int dw0_location;
 	int dw1_location;
@@ -1982,11 +1961,9 @@ static void dr_ste_build_general_purpose_bit_mask(struct mlx5dr_match_param *val
 
 static int dr_ste_build_general_purpose_tag(struct mlx5dr_match_param *value,
 					    struct mlx5dr_ste_build *sb,
-					    u8 *hw_ste_p)
+					    u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
 		       misc_2_mask, metadata_reg_a);
@@ -2027,11 +2004,9 @@ static void dr_ste_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
 					struct mlx5dr_ste_build *sb,
-					u8 *hw_ste_p)
+					u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
-	u8 *tag = hw_ste->tag;
 
 	if (sb->inner) {
 		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, inner_tcp_seq_num);
@@ -2077,11 +2052,9 @@ dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value
 static int
 dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
-					   u8 *hw_ste_p)
+					   u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
 		       outer_vxlan_gpe_flags, misc3,
@@ -2133,11 +2106,9 @@ dr_ste_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
 static int
 dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
 					struct mlx5dr_ste_build *sb,
-					u8 *hw_ste_p)
+					u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc *misc = &value->misc;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
 		       geneve_protocol_type, misc, geneve_protocol_type);
@@ -2180,11 +2151,9 @@ static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_register_0_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(register_0, tag, register_0_h, misc2, metadata_reg_c_0);
 	DR_STE_SET_TAG(register_0, tag, register_0_l, misc2, metadata_reg_c_1);
@@ -2224,11 +2193,9 @@ static void dr_ste_build_register_1_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_register_1_tag(struct mlx5dr_match_param *value,
 				       struct mlx5dr_ste_build *sb,
-				       u8 *hw_ste_p)
+				       u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
-	u8 *tag = hw_ste->tag;
 
 	DR_STE_SET_TAG(register_1, tag, register_2_h, misc2, metadata_reg_c_4);
 	DR_STE_SET_TAG(register_1, tag, register_2_l, misc2, metadata_reg_c_5);
@@ -2263,15 +2230,13 @@ static void dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
 
 static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 					 struct mlx5dr_ste_build *sb,
-					 u8 *hw_ste_p)
+					 u8 *tag)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc *misc = &value->misc;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
 	struct mlx5dr_cmd_caps *caps;
 	u8 *bit_mask = sb->bit_mask;
-	u8 *tag = hw_ste->tag;
 	bool source_gvmi_set;
 
 	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a4a026243896..ce04a2019f90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -194,7 +194,7 @@ struct mlx5dr_ste_build {
 	u8 bit_mask[DR_STE_SIZE_MASK];
 	int (*ste_build_tag_func)(struct mlx5dr_match_param *spec,
 				  struct mlx5dr_ste_build *sb,
-				  u8 *hw_ste_p);
+				  u8 *tag);
 };
 
 struct mlx5dr_ste_htbl *
-- 
2.26.2

