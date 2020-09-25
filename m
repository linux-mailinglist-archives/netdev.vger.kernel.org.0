Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2212791F2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgIYUTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 583F0238E6;
        Fri, 25 Sep 2020 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062702;
        bh=3O1pmVJhpCTBF2PPmkQ8YeB6PYXY+vj5NoGXMOHpYK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgqwsS6bBxZ0Dvsn05eUcqf1gFU984CR/wWMgltMoXDYGARECvawUKJdHKEyvhGP5
         1O6RzSc7XIvf9/vsot78/3IgojBEpCNsnW9c4ZU5Bb8J7IPBw4V7w3z5xHlyvFsGL0
         YZdt1kD+bD1o6HHuCv/9asZ2kwxzZAINlsav54j4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, Remove unneeded vlan check from L2 builder
Date:   Fri, 25 Sep 2020 12:38:03 -0700
Message-Id: <20200925193809.463047-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When we create a matcher we check that all fields are consumed.
There is no need for this specific check. This keeps the STE
builder functions simple and clean.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 12 +++------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 25 +++++--------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  6 ++---
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 2b794daca436..a16d7faa2bb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -258,10 +258,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 
 		if (dr_mask_is_smac_set(&mask.outer) &&
 		    dr_mask_is_dmac_set(&mask.outer)) {
-			ret = mlx5dr_ste_build_eth_l2_src_des(&sb[idx++], &mask,
-							      inner, rx);
-			if (ret)
-				return ret;
+			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++], &mask,
+							inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.outer))
@@ -338,10 +336,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 
 		if (dr_mask_is_smac_set(&mask.inner) &&
 		    dr_mask_is_dmac_set(&mask.inner)) {
-			ret = mlx5dr_ste_build_eth_l2_src_des(&sb[idx++],
-							      &mask, inner, rx);
-			if (ret)
-				return ret;
+			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++],
+							&mask, inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.inner))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 6e86704181cc..970dbabe3ea2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -766,8 +766,8 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 	return 0;
 }
 
-static int dr_ste_build_eth_l2_src_des_bit_mask(struct mlx5dr_match_param *value,
-						bool inner, u8 *bit_mask)
+static void dr_ste_build_eth_l2_src_des_bit_mask(struct mlx5dr_match_param *value,
+						 bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
@@ -795,13 +795,6 @@ static int dr_ste_build_eth_l2_src_des_bit_mask(struct mlx5dr_match_param *value
 		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
 		mask->svlan_tag = 0;
 	}
-
-	if (mask->cvlan_tag || mask->svlan_tag) {
-		pr_info("Invalid c/svlan mask configuration\n");
-		return -EINVAL;
-	}
-
-	return 0;
 }
 
 static void dr_ste_copy_mask_misc(char *mask, struct mlx5dr_match_misc *spec)
@@ -1092,23 +1085,17 @@ static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-int mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *sb,
-				    struct mlx5dr_match_param *mask,
-				    bool inner, bool rx)
+void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx)
 {
-	int ret;
-
-	ret = dr_ste_build_eth_l2_src_des_bit_mask(mask, inner, sb->bit_mask);
-	if (ret)
-		return ret;
+	dr_ste_build_eth_l2_src_des_bit_mask(mask, inner, sb->bit_mask);
 
 	sb->rx = rx;
 	sb->inner = inner;
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC_DST, rx, inner);
 	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_build_eth_l2_src_des_tag;
-
-	return 0;
 }
 
 static void dr_ste_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *value,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 026fb4606606..a4a026243896 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -288,9 +288,9 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 			     struct mlx5dr_matcher_rx_tx *nic_matcher,
 			     struct mlx5dr_match_param *value,
 			     u8 *ste_arr);
-int mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *builder,
-				    struct mlx5dr_match_param *mask,
-				    bool inner, bool rx);
+void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *builder,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx);
 void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
 					  struct mlx5dr_match_param *mask,
 					  bool inner, bool rx);
-- 
2.26.2

