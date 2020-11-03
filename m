Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B4F2A505A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgKCTsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18814 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgKCTsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b3f20007>; Tue, 03 Nov 2020 11:48:02 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 03/12] net/mlx5: DR, Rename matcher functions to be more HW agnostic
Date:   Tue, 3 Nov 2020 11:47:29 -0800
Message-ID: <20201103194738.64061-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432882; bh=S3zGRchQhlVV191Wbar6zRiiBgA0G892LJEMcsxRw1A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=e+ZHvUFFLq7zQhWcXyf7RcaIFt2yPMeR0+g22OyH1aLy0SfgbTCeEtOjdnZ9zGfYd
         YIIxmIkdkE83AnWdiEvgzWYJyAoVy2y2KoHwOg+LaaSYUJx9qCIVEXaynrir8myjd9
         9NL19zOrHi1jiBvICHGhUdtWd4pqUC0aqvSB0LZLjuUU1vPp1lU0oi/zLjdzpW7/oK
         T/qxrwFucJr8R5n+j7vBPySmtJeh/2Z6Qh6atFkHCpVwfB79MJ6ZuFAkc+b5y0G/T+
         JKdLYSLT4WZryDKaIjhXwY/9hJWsxAC7kifqTNHVr1Q8jCXww+glX42P1XXy8z8tNz
         9ahzk0dSZN6Zw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove flex parser from the matcher function names since
the matcher should not be aware of such HW specific details.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 54 +++++++++++--------
 .../mellanox/mlx5/core/steering/dr_types.h    | 12 -----
 3 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 6bd34b293007..ebc879052e42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -93,12 +93,12 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->gvmi		=3D MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	=3D MLX5_CAP_GEN(mdev, flex_parser_protocols);
=20
-	if (mlx5dr_matcher_supp_flex_parser_icmp_v4(caps)) {
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED) {
 		caps->flex_parser_id_icmp_dw0 =3D MLX5_CAP_GEN(mdev, flex_parser_id_icmp=
_dw0);
 		caps->flex_parser_id_icmp_dw1 =3D MLX5_CAP_GEN(mdev, flex_parser_id_icmp=
_dw1);
 	}
=20
-	if (mlx5dr_matcher_supp_flex_parser_icmp_v6(caps)) {
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED) {
 		caps->flex_parser_id_icmpv6_dw0 =3D
 			MLX5_CAP_GEN(mdev, flex_parser_id_icmpv6_dw0);
 		caps->flex_parser_id_icmpv6_dw1 =3D
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 752afdb20e23..cb5202e17856 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -103,7 +103,7 @@ static bool dr_mask_is_tnl_gre_set(struct mlx5dr_match_=
misc *misc)
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
=20
 static bool
-dr_mask_is_misc3_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
+dr_mask_is_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
 {
 	return (misc3->outer_vxlan_gpe_vni ||
 		misc3->outer_vxlan_gpe_next_protocol ||
@@ -111,21 +111,20 @@ dr_mask_is_misc3_vxlan_gpe_set(struct mlx5dr_match_mi=
sc3 *misc3)
 }
=20
 static bool
-dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
+dr_matcher_supp_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols &
-	       MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
+	return caps->flex_protocols & MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
 }
=20
 static bool
-dr_mask_is_flex_parser_tnl_vxlan_gpe_set(struct mlx5dr_match_param *mask,
-					 struct mlx5dr_domain *dmn)
+dr_mask_is_tnl_vxlan_gpe(struct mlx5dr_match_param *mask,
+			 struct mlx5dr_domain *dmn)
 {
-	return dr_mask_is_misc3_vxlan_gpe_set(&mask->misc3) &&
-	       dr_matcher_supp_flex_parser_vxlan_gpe(&dmn->info.caps);
+	return dr_mask_is_vxlan_gpe_set(&mask->misc3) &&
+	       dr_matcher_supp_vxlan_gpe(&dmn->info.caps);
 }
=20
-static bool dr_mask_is_misc_geneve_set(struct mlx5dr_match_misc *misc)
+static bool dr_mask_is_tnl_geneve_set(struct mlx5dr_match_misc *misc)
 {
 	return misc->geneve_vni ||
 	       misc->geneve_oam ||
@@ -134,18 +133,27 @@ static bool dr_mask_is_misc_geneve_set(struct mlx5dr_=
match_misc *misc)
 }
=20
 static bool
-dr_matcher_supp_flex_parser_geneve(struct mlx5dr_cmd_caps *caps)
+dr_matcher_supp_tnl_geneve(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols &
-	       MLX5_FLEX_PARSER_GENEVE_ENABLED;
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GENEVE_ENABLED;
 }
=20
 static bool
-dr_mask_is_flex_parser_tnl_geneve_set(struct mlx5dr_match_param *mask,
-				      struct mlx5dr_domain *dmn)
+dr_mask_is_tnl_geneve(struct mlx5dr_match_param *mask,
+		      struct mlx5dr_domain *dmn)
 {
-	return dr_mask_is_misc_geneve_set(&mask->misc) &&
-	       dr_matcher_supp_flex_parser_geneve(&dmn->info.caps);
+	return dr_mask_is_tnl_geneve_set(&mask->misc) &&
+	       dr_matcher_supp_tnl_geneve(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_icmp_v4(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED;
+}
+
+static int dr_matcher_supp_icmp_v6(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED;
 }
=20
 static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
@@ -154,13 +162,13 @@ static bool dr_mask_is_icmpv6_set(struct mlx5dr_match=
_misc3 *misc3)
 		misc3->icmpv6_header_data);
 }
=20
-static bool dr_mask_is_flex_parser_icmp_set(struct mlx5dr_match_param *mas=
k,
-					    struct mlx5dr_domain *dmn)
+static bool dr_mask_is_icmp(struct mlx5dr_match_param *mask,
+			    struct mlx5dr_domain *dmn)
 {
 	if (DR_MASK_IS_ICMPV4_SET(&mask->misc3))
-		return mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps);
+		return dr_matcher_supp_icmp_v4(&dmn->info.caps);
 	else if (dr_mask_is_icmpv6_set(&mask->misc3))
-		return mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps);
+		return dr_matcher_supp_icmp_v6(&dmn->info.caps);
=20
 	return false;
 }
@@ -300,10 +308,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_=
matcher *matcher,
 								  inner, rx);
 		}
=20
-		if (dr_mask_is_flex_parser_tnl_vxlan_gpe_set(&mask, dmn))
+		if (dr_mask_is_tnl_vxlan_gpe(&mask, dmn))
 			mlx5dr_ste_build_tnl_vxlan_gpe(&sb[idx++], &mask,
 						       inner, rx);
-		else if (dr_mask_is_flex_parser_tnl_geneve_set(&mask, dmn))
+		else if (dr_mask_is_tnl_geneve(&mask, dmn))
 			mlx5dr_ste_build_tnl_geneve(&sb[idx++], &mask,
 						    inner, rx);
=20
@@ -316,7 +324,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
 			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
=20
-		if (dr_mask_is_flex_parser_icmp_set(&mask, dmn)) {
+		if (dr_mask_is_icmp(&mask, dmn)) {
 			ret =3D mlx5dr_ste_build_icmp(&sb[idx++],
 						    &mask, &dmn->info.caps,
 						    inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 562c72aad733..5642484b3a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -839,18 +839,6 @@ static inline void mlx5dr_domain_unlock(struct mlx5dr_=
domain *dmn)
 	mlx5dr_domain_nic_unlock(&dmn->info.rx);
 }
=20
-static inline int
-mlx5dr_matcher_supp_flex_parser_icmp_v4(struct mlx5dr_cmd_caps *caps)
-{
-	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED;
-}
-
-static inline int
-mlx5dr_matcher_supp_flex_parser_icmp_v6(struct mlx5dr_cmd_caps *caps)
-{
-	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED;
-}
-
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
--=20
2.26.2

