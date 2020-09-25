Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492A22791EC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgIYUTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3208623977;
        Fri, 25 Sep 2020 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062705;
        bh=BzgF/21M0aOnOyTWvG/YSuMvro/2vJ/a16KWYkFXp+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hdg3/Fdqzjn355Iquq5OsgkA5qKUQDZdhSjG2boedsQ3VNJpVULLUTFkGGpHQ6xEa
         RuqxTQjl8fjwc61apzZy2BARm+dAk3l4ibwUTACQnpLyyXR174oOr68RYDJD8skdoz
         uy8rFAypzDBw48HvdhbAVG+f163MFw7OvQ2Pheww=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: DR, Rename matcher functions to be more HW agnostic
Date:   Fri, 25 Sep 2020 12:38:08 -0700
Message-Id: <20200925193809.463047-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 6bd34b293007..ebc879052e42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -93,12 +93,12 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->gvmi		= MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	= MLX5_CAP_GEN(mdev, flex_parser_protocols);
 
-	if (mlx5dr_matcher_supp_flex_parser_icmp_v4(caps)) {
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED) {
 		caps->flex_parser_id_icmp_dw0 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw0);
 		caps->flex_parser_id_icmp_dw1 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw1);
 	}
 
-	if (mlx5dr_matcher_supp_flex_parser_icmp_v6(caps)) {
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED) {
 		caps->flex_parser_id_icmpv6_dw0 =
 			MLX5_CAP_GEN(mdev, flex_parser_id_icmpv6_dw0);
 		caps->flex_parser_id_icmpv6_dw1 =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 752afdb20e23..cb5202e17856 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -103,7 +103,7 @@ static bool dr_mask_is_tnl_gre_set(struct mlx5dr_match_misc *misc)
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
 
 static bool
-dr_mask_is_misc3_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
+dr_mask_is_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
 {
 	return (misc3->outer_vxlan_gpe_vni ||
 		misc3->outer_vxlan_gpe_next_protocol ||
@@ -111,21 +111,20 @@ dr_mask_is_misc3_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
 }
 
 static bool
-dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
+dr_matcher_supp_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols &
-	       MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
+	return caps->flex_protocols & MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
 }
 
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
 
-static bool dr_mask_is_misc_geneve_set(struct mlx5dr_match_misc *misc)
+static bool dr_mask_is_tnl_geneve_set(struct mlx5dr_match_misc *misc)
 {
 	return misc->geneve_vni ||
 	       misc->geneve_oam ||
@@ -134,18 +133,27 @@ static bool dr_mask_is_misc_geneve_set(struct mlx5dr_match_misc *misc)
 }
 
 static bool
-dr_matcher_supp_flex_parser_geneve(struct mlx5dr_cmd_caps *caps)
+dr_matcher_supp_tnl_geneve(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols &
-	       MLX5_FLEX_PARSER_GENEVE_ENABLED;
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GENEVE_ENABLED;
 }
 
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
 
 static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
@@ -154,13 +162,13 @@ static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
 		misc3->icmpv6_header_data);
 }
 
-static bool dr_mask_is_flex_parser_icmp_set(struct mlx5dr_match_param *mask,
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
 
 	return false;
 }
@@ -300,10 +308,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 								  inner, rx);
 		}
 
-		if (dr_mask_is_flex_parser_tnl_vxlan_gpe_set(&mask, dmn))
+		if (dr_mask_is_tnl_vxlan_gpe(&mask, dmn))
 			mlx5dr_ste_build_tnl_vxlan_gpe(&sb[idx++], &mask,
 						       inner, rx);
-		else if (dr_mask_is_flex_parser_tnl_geneve_set(&mask, dmn))
+		else if (dr_mask_is_tnl_geneve(&mask, dmn))
 			mlx5dr_ste_build_tnl_geneve(&sb[idx++], &mask,
 						    inner, rx);
 
@@ -316,7 +324,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
 			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
 
-		if (dr_mask_is_flex_parser_icmp_set(&mask, dmn)) {
+		if (dr_mask_is_icmp(&mask, dmn)) {
 			ret = mlx5dr_ste_build_icmp(&sb[idx++],
 						    &mask, &dmn->info.caps,
 						    inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5d0ae664aac0..3086a44f7e7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -843,18 +843,6 @@ static inline void mlx5dr_domain_unlock(struct mlx5dr_domain *dmn)
 	mlx5dr_domain_nic_unlock(&dmn->info.rx);
 }
 
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
-- 
2.26.2

