Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E664822C0
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242799AbhLaIU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242813AbhLaIUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB514C061756
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3666B81D62
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF7FC36AEB;
        Fri, 31 Dec 2021 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938848;
        bh=RmD0xSSatcAPhqCfVzE1NUPl+rgVM4xu7xkEJfBbUyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECDUEjqXeM9ZPFIDpEEXK6uoMmGLzgt/1WrSPt6QYtg3lUKBtwbYP9DhqRTQkQRrE
         8rLS5AeHjIv3AwZHqOzEqBI+9qtNM9gqnEJ+NuzZpKhbnkGWDXw2kmQpCxADAdf+qW
         lKfbuAjVP6kpdEBAat5OtGGw7P80kZ6OkLTV1e99sGMGoi2/Rhj4rGe/NWkOsu93mk
         s64Hl4fbsaXTy4eASIwKbNYI/kim9EC3d8V2+wIbmx3vTKgN6bkx7sX4sf07DJJjgz
         +9RWehSJfINU4WhTurwXaUWogoftm7+w3agzNiQ8NxTrEHp9HceesXV/0a3Iq63P0Z
         oM1nVEfi2fm1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 11/16] net/mlx5: DR, Add misc5 to match_param structs
Date:   Fri, 31 Dec 2021 00:20:33 -0800
Message-Id: <20211231082038.106490-12-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Add misc5 match params to enable matching tunnel headers.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  3 ++
 .../mellanox/mlx5/core/steering/dr_rule.c     | 10 ++++++
 .../mellanox/mlx5/core/steering/dr_ste.c      | 34 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 15 +++++++-
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 12ebb7adea4d..856541a60d8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -424,6 +424,9 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC4)
 		mask.misc4 = matcher->mask.misc4;
 
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC5)
+		mask.misc5 = matcher->mask.misc5;
+
 	ret = mlx5dr_ste_build_pre_check(dmn, matcher->match_criteria,
 					 &matcher->mask, NULL);
 	if (ret)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 3b4cd3160c27..43e7fe85cbc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -974,6 +974,16 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 			return false;
 		}
 	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC5) {
+		s_idx = offsetof(struct mlx5dr_match_param, misc5);
+		e_idx = min(s_idx + sizeof(param->misc5), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_err(matcher->tbl->dmn, "Rule misc5 parameters contains a value not specified by mask\n");
+			return false;
+		}
+	}
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 219a5474a8a4..9bf25231c9c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -880,6 +880,26 @@ static void dr_ste_copy_mask_misc4(char *mask, struct mlx5dr_match_misc4 *spec,
 		IFC_GET_CLR(fte_match_set_misc4, mask, prog_sample_field_value_3, clr);
 }
 
+static void dr_ste_copy_mask_misc5(char *mask, struct mlx5dr_match_misc5 *spec, bool clr)
+{
+	spec->macsec_tag_0 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, macsec_tag_0, clr);
+	spec->macsec_tag_1 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, macsec_tag_1, clr);
+	spec->macsec_tag_2 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, macsec_tag_2, clr);
+	spec->macsec_tag_3 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, macsec_tag_3, clr);
+	spec->tunnel_header_0 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, tunnel_header_0, clr);
+	spec->tunnel_header_1 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, tunnel_header_1, clr);
+	spec->tunnel_header_2 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, tunnel_header_2, clr);
+	spec->tunnel_header_3 =
+		IFC_GET_CLR(fte_match_set_misc5, mask, tunnel_header_3, clr);
+}
+
 void mlx5dr_ste_copy_param(u8 match_criteria,
 			   struct mlx5dr_match_param *set_param,
 			   struct mlx5dr_match_parameters *mask,
@@ -966,6 +986,20 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 		}
 		dr_ste_copy_mask_misc4(buff, &set_param->misc4, clr);
 	}
+
+	param_location += sizeof(struct mlx5dr_match_misc4);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC5) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_misc5)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff = tail_param;
+		} else {
+			buff = data + param_location;
+		}
+		dr_ste_copy_mask_misc5(buff, &set_param->misc5, clr);
+	}
 }
 
 void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 584d2b0eb016..b4987822a81a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -105,7 +105,8 @@ enum mlx5dr_matcher_criteria {
 	DR_MATCHER_CRITERIA_MISC2 = 1 << 3,
 	DR_MATCHER_CRITERIA_MISC3 = 1 << 4,
 	DR_MATCHER_CRITERIA_MISC4 = 1 << 5,
-	DR_MATCHER_CRITERIA_MAX = 1 << 6,
+	DR_MATCHER_CRITERIA_MISC5 = 1 << 6,
+	DR_MATCHER_CRITERIA_MAX = 1 << 7,
 };
 
 enum mlx5dr_action_type {
@@ -762,6 +763,17 @@ struct mlx5dr_match_misc4 {
 	u32 reserved_auto1[8];
 };
 
+struct mlx5dr_match_misc5 {
+	u32 macsec_tag_0;
+	u32 macsec_tag_1;
+	u32 macsec_tag_2;
+	u32 macsec_tag_3;
+	u32 tunnel_header_0;
+	u32 tunnel_header_1;
+	u32 tunnel_header_2;
+	u32 tunnel_header_3;
+};
+
 struct mlx5dr_match_param {
 	struct mlx5dr_match_spec outer;
 	struct mlx5dr_match_misc misc;
@@ -769,6 +781,7 @@ struct mlx5dr_match_param {
 	struct mlx5dr_match_misc2 misc2;
 	struct mlx5dr_match_misc3 misc3;
 	struct mlx5dr_match_misc4 misc4;
+	struct mlx5dr_match_misc5 misc5;
 };
 
 #define DR_MASK_IS_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type || \
-- 
2.33.1

