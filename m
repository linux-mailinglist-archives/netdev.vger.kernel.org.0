Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F52D2791EF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgIYUTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA68238E2;
        Fri, 25 Sep 2020 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062702;
        bh=dg2gId7YkTx7DVH6d8cFaTfqmH2xpdhgfoAhhrfIT8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lxjlY5r7zmN2HUgPGX7MnY1iKNvyrn2hTHnu6Lw3wbc6JiMHeX+AxjqukNTgnxrv
         zMEbyRd8wkrJiOTVeN6G32CvDd6HJ5FJCAsihs8IFjDVRDNXIx2phToMqaAU3p2QFP
         lLtDL825l8b0SWZ2hV+XNwKC4oHp5C5uAsKzh/n8=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Remove unneeded check from source port builder
Date:   Fri, 25 Sep 2020 12:38:02 -0700
Message-Id: <20200925193809.463047-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Mask validity for ste builders is checked by mlx5dr_ste_build_pre_check
during matcher creation.
It already checks the mask value of source_vport, so removing
this duplicated check.
Also, moving there the check of source_eswitch_owner_vhca_id mask.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  6 +--
 .../mellanox/mlx5/core/steering/dr_ste.c      | 40 +++++++------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  8 ++--
 3 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index c63f727273d8..2b794daca436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -252,10 +252,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		if (dr_mask_is_gvmi_or_qpn_set(&mask.misc) &&
 		    (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 		     dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX)) {
-			ret = mlx5dr_ste_build_src_gvmi_qpn(&sb[idx++], &mask,
-							    dmn, inner, rx);
-			if (ret)
-				return ret;
+			mlx5dr_ste_build_src_gvmi_qpn(&sb[idx++], &mask,
+						      dmn, inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.outer) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 053e63844bd2..6e86704181cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -709,7 +709,14 @@ int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 {
 	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
 		if (mask->misc.source_port && mask->misc.source_port != 0xffff) {
-			mlx5dr_err(dmn, "Partial mask source_port is not supported\n");
+			mlx5dr_err(dmn,
+				   "Partial mask source_port is not supported\n");
+			return -EINVAL;
+		}
+		if (mask->misc.source_eswitch_owner_vhca_id &&
+		    mask->misc.source_eswitch_owner_vhca_id != 0xffff) {
+			mlx5dr_err(dmn,
+				   "Partial mask source_eswitch_owner_vhca_id is not supported\n");
 			return -EINVAL;
 		}
 	}
@@ -2257,25 +2264,14 @@ void mlx5dr_ste_build_register_1(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_build_register_1_tag;
 }
 
-static int dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
-					      u8 *bit_mask)
+static void dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
+					       u8 *bit_mask)
 {
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
-	/* Partial misc source_port is not supported */
-	if (misc_mask->source_port && misc_mask->source_port != 0xffff)
-		return -EINVAL;
-
-	/* Partial misc source_eswitch_owner_vhca_id is not supported */
-	if (misc_mask->source_eswitch_owner_vhca_id &&
-	    misc_mask->source_eswitch_owner_vhca_id != 0xffff)
-		return -EINVAL;
-
 	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_port);
 	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
 	misc_mask->source_eswitch_owner_vhca_id = 0;
-
-	return 0;
 }
 
 static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
@@ -2320,19 +2316,15 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
-				  struct mlx5dr_match_param *mask,
-				  struct mlx5dr_domain *dmn,
-				  bool inner, bool rx)
+void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
+				   struct mlx5dr_match_param *mask,
+				   struct mlx5dr_domain *dmn,
+				   bool inner, bool rx)
 {
-	int ret;
-
 	/* Set vhca_id_valid before we reset source_eswitch_owner_vhca_id */
 	sb->vhca_id_valid = mask->misc.source_eswitch_owner_vhca_id;
 
-	ret = dr_ste_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
-	if (ret)
-		return ret;
+	dr_ste_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
 
 	sb->rx = rx;
 	sb->dmn = dmn;
@@ -2340,6 +2332,4 @@ int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
 	sb->lu_type = MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
 	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_build_src_gvmi_qpn_tag;
-
-	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 07cf24a38d47..026fb4606606 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -346,10 +346,10 @@ void mlx5dr_ste_build_register_0(struct mlx5dr_ste_build *sb,
 void mlx5dr_ste_build_register_1(struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
-				  struct mlx5dr_match_param *mask,
-				  struct mlx5dr_domain *dmn,
-				  bool inner, bool rx);
+void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
+				   struct mlx5dr_match_param *mask,
+				   struct mlx5dr_domain *dmn,
+				   bool inner, bool rx);
 void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool rx);
 
 /* Actions utils */
-- 
2.26.2

