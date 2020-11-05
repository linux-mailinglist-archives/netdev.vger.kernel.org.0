Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737712A87C9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbgKEUNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:13:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6021 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731954AbgKEUM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:12:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45cc90000>; Thu, 05 Nov 2020 12:12:57 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:12:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next v2 02/12] net/mlx5: DR, Rename builders HW specific names
Date:   Thu, 5 Nov 2020 12:12:32 -0800
Message-ID: <20201105201242.21716-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607177; bh=rq6PWq11BfejZhig3WUJMpUTotqp4JdDPFWggDOS57U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bhWMXnz1ISw6hP1AO2OIp9gshWT1pZqFGMA1HWbLFqWbRn6JZMw+F/cegQKPJRbc9
         K1nYJ97/q5PY3KFNT+OUsMPZkfENez5r6iVJ95xX1uQJ7l91jmVDbY0KDxXAo+rcez
         ae0fXXynM9at4AncbULKSmN4nCi+ErAtNlKooq8gkANPFBBbBL5cB2Qcrw0KNef6Dk
         Mf4yvZrf8df9z8ZcYYtTrw8cD9NA6vrGmc/cUWN51IHhPblV9Iah6/VTUIxwbKEf2n
         TJ0yv8GqbfGzSoqmLhxjqhE/6Pg0M88LYe7k/uhDefbtQrOSO7FjAavxlZFek98m5A
         CEEkayOa9zTsw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

We will support multiple STE versions.
The existing naming is not suitable for newer versions.
Removed the HW specific details and renamed with a more
general names.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 63 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 42 ++++++-------
 .../mellanox/mlx5/core/steering/dr_types.h    | 42 ++++++-------
 3 files changed, 76 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 7df883686d46..752afdb20e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -85,7 +85,7 @@ static bool dr_mask_is_ttl_set(struct mlx5dr_match_spec *=
spec)
 	(_misc2)._inner_outer##_first_mpls_s_bos || \
 	(_misc2)._inner_outer##_first_mpls_ttl)
=20
-static bool dr_mask_is_gre_set(struct mlx5dr_match_misc *misc)
+static bool dr_mask_is_tnl_gre_set(struct mlx5dr_match_misc *misc)
 {
 	return (misc->gre_key_h || misc->gre_key_l ||
 		misc->gre_protocol || misc->gre_c_present ||
@@ -98,7 +98,7 @@ static bool dr_mask_is_gre_set(struct mlx5dr_match_misc *=
misc)
 	(_misc2).outer_first_mpls_over_##gre_udp##_s_bos || \
 	(_misc2).outer_first_mpls_over_##gre_udp##_ttl)
=20
-#define DR_MASK_IS_FLEX_PARSER_0_SET(_misc2) ( \
+#define DR_MASK_IS_TNL_MPLS_SET(_misc2) ( \
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), gre) || \
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
=20
@@ -148,12 +148,23 @@ dr_mask_is_flex_parser_tnl_geneve_set(struct mlx5dr_m=
atch_param *mask,
 	       dr_matcher_supp_flex_parser_geneve(&dmn->info.caps);
 }
=20
-static bool dr_mask_is_flex_parser_icmpv6_set(struct mlx5dr_match_misc3 *m=
isc3)
+static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
 {
 	return (misc3->icmpv6_type || misc3->icmpv6_code ||
 		misc3->icmpv6_header_data);
 }
=20
+static bool dr_mask_is_flex_parser_icmp_set(struct mlx5dr_match_param *mas=
k,
+					    struct mlx5dr_domain *dmn)
+{
+	if (DR_MASK_IS_ICMPV4_SET(&mask->misc3))
+		return mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps);
+	else if (dr_mask_is_icmpv6_set(&mask->misc3))
+		return mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps);
+
+	return false;
+}
+
 static bool dr_mask_is_wqe_metadata_set(struct mlx5dr_match_misc2 *misc2)
 {
 	return misc2->metadata_reg_a;
@@ -257,7 +268,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
=20
 		if (dr_mask_is_smac_set(&mask.outer) &&
 		    dr_mask_is_dmac_set(&mask.outer)) {
-			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++], &mask,
+			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++], &mask,
 							inner, rx);
 		}
=20
@@ -277,8 +288,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 								 inner, rx);
=20
 			if (DR_MASK_IS_ETH_L4_SET(mask.outer, mask.misc, outer))
-				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
-							    inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
+								inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
@@ -290,13 +301,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_=
matcher *matcher,
 		}
=20
 		if (dr_mask_is_flex_parser_tnl_vxlan_gpe_set(&mask, dmn))
-			mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(&sb[idx++],
-								   &mask,
-								   inner, rx);
+			mlx5dr_ste_build_tnl_vxlan_gpe(&sb[idx++], &mask,
+						       inner, rx);
 		else if (dr_mask_is_flex_parser_tnl_geneve_set(&mask, dmn))
-			mlx5dr_ste_build_flex_parser_tnl_geneve(&sb[idx++],
-								&mask,
-								inner, rx);
+			mlx5dr_ste_build_tnl_geneve(&sb[idx++], &mask,
+						    inner, rx);
=20
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
@@ -304,22 +313,18 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_=
matcher *matcher,
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, outer))
 			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
=20
-		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
-			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask,
-						       inner, rx);
+		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
+			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
=20
-		if ((DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(&mask.misc3) &&
-		     mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps)) ||
-		    (dr_mask_is_flex_parser_icmpv6_set(&mask.misc3) &&
-		     mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps))) {
-			ret =3D mlx5dr_ste_build_flex_parser_1(&sb[idx++],
-							     &mask, &dmn->info.caps,
-							     inner, rx);
+		if (dr_mask_is_flex_parser_icmp_set(&mask, dmn)) {
+			ret =3D mlx5dr_ste_build_icmp(&sb[idx++],
+						    &mask, &dmn->info.caps,
+						    inner, rx);
 			if (ret)
 				return ret;
 		}
-		if (dr_mask_is_gre_set(&mask.misc))
-			mlx5dr_ste_build_gre(&sb[idx++], &mask, inner, rx);
+		if (dr_mask_is_tnl_gre_set(&mask.misc))
+			mlx5dr_ste_build_tnl_gre(&sb[idx++], &mask, inner, rx);
 	}
=20
 	/* Inner */
@@ -334,7 +339,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
=20
 		if (dr_mask_is_smac_set(&mask.inner) &&
 		    dr_mask_is_dmac_set(&mask.inner)) {
-			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++],
+			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++],
 							&mask, inner, rx);
 		}
=20
@@ -354,8 +359,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 								 inner, rx);
=20
 			if (DR_MASK_IS_ETH_L4_SET(mask.inner, mask.misc, inner))
-				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
-							    inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
+								inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
@@ -372,8 +377,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, inner))
 			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
=20
-		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
-			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask, inner, rx);
+		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
+			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
 	}
 	/* Empty matcher, takes all */
 	if (matcher->match_criteria =3D=3D DR_MATCHER_CRITERIA_EMPTY)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index b01aaec75622..d275823bff2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1090,7 +1090,7 @@ static int dr_ste_build_eth_l2_src_des_tag(struct mlx=
5dr_match_param *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx)
 {
@@ -1594,9 +1594,9 @@ static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_=
match_param *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask,
-				 bool inner, bool rx)
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx)
 {
 	dr_ste_build_ipv6_l3_l4_bit_mask(mask, inner, sb->bit_mask);
=20
@@ -1693,8 +1693,8 @@ static int dr_ste_build_gre_tag(struct mlx5dr_match_p=
aram *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_gre(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask, bool inner, bool rx)
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask, bool inner, bool rx)
 {
 	dr_ste_build_gre_bit_mask(mask, inner, sb->bit_mask);
=20
@@ -1771,9 +1771,9 @@ static int dr_ste_build_flex_parser_0_tag(struct mlx5=
dr_match_param *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_build *sb,
-				    struct mlx5dr_match_param *mask,
-				    bool inner, bool rx)
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_0_bit_mask(mask, inner, sb->bit_mask);
=20
@@ -1792,8 +1792,8 @@ static int dr_ste_build_flex_parser_1_bit_mask(struct=
 mlx5dr_match_param *mask,
 					       struct mlx5dr_cmd_caps *caps,
 					       u8 *bit_mask)
 {
+	bool is_ipv4_mask =3D DR_MASK_IS_ICMPV4_SET(&mask->misc3);
 	struct mlx5dr_match_misc3 *misc_3_mask =3D &mask->misc3;
-	bool is_ipv4_mask =3D DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3_mask);
 	u32 icmp_header_data_mask;
 	u32 icmp_type_mask;
 	u32 icmp_code_mask;
@@ -1869,7 +1869,7 @@ static int dr_ste_build_flex_parser_1_tag(struct mlx5=
dr_match_param *value,
 	u32 icmp_code;
 	bool is_ipv4;
=20
-	is_ipv4 =3D DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3);
+	is_ipv4 =3D DR_MASK_IS_ICMPV4_SET(misc_3);
 	if (is_ipv4) {
 		icmp_header_data	=3D misc_3->icmpv4_header_data;
 		icmp_type		=3D misc_3->icmpv4_type;
@@ -1928,10 +1928,10 @@ static int dr_ste_build_flex_parser_1_tag(struct ml=
x5dr_match_param *value,
 	return 0;
 }
=20
-int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_build *sb,
-				   struct mlx5dr_match_param *mask,
-				   struct mlx5dr_cmd_caps *caps,
-				   bool inner, bool rx)
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask,
+			  struct mlx5dr_cmd_caps *caps,
+			  bool inner, bool rx)
 {
 	int ret;
=20
@@ -2069,9 +2069,9 @@ dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx=
5dr_match_param *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *s=
b,
-						struct mlx5dr_match_param *mask,
-						bool inner, bool rx)
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, inner,
 							sb->bit_mask);
@@ -2122,9 +2122,9 @@ dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr=
_match_param *value,
 	return 0;
 }
=20
-void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
-					     struct mlx5dr_match_param *mask,
-					     bool inner, bool rx)
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
 	sb->rx =3D rx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5caf082b7000..562c72aad733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -288,7 +288,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *mat=
cher,
 			     struct mlx5dr_matcher_rx_tx *nic_matcher,
 			     struct mlx5dr_match_param *value,
 			     u8 *ste_arr);
-void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *builder,
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *builder,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx);
 void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
@@ -312,31 +312,31 @@ void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_bu=
ild *sb,
 void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask,
-				 bool inner, bool rx);
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx);
 void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
 				  bool inner, bool rx);
-void mlx5dr_ste_build_gre(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask,
-			  bool inner, bool rx);
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask,
+			      bool inner, bool rx);
 void mlx5dr_ste_build_mpls(struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
 			   bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx);
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask,
+			  struct mlx5dr_cmd_caps *caps,
+			  bool inner, bool rx);
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
 				    bool inner, bool rx);
-int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_build *sb,
-				   struct mlx5dr_match_param *mask,
-				   struct mlx5dr_cmd_caps *caps,
-				   bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *s=
b,
-						struct mlx5dr_match_param *mask,
-						bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
-					     struct mlx5dr_match_param *mask,
-					     bool inner, bool rx);
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
@@ -588,9 +588,9 @@ struct mlx5dr_match_param {
 	struct mlx5dr_match_misc3 misc3;
 };
=20
-#define DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type |=
| \
-						   (_misc3)->icmpv4_code || \
-						   (_misc3)->icmpv4_header_data)
+#define DR_MASK_IS_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type || \
+				       (_misc3)->icmpv4_code || \
+				       (_misc3)->icmpv4_header_data)
=20
 struct mlx5dr_esw_caps {
 	u64 drop_icm_address_rx;
--=20
2.26.2

