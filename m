Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8641311B50
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhBFFHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230327AbhBFFDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:03:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5076764E49;
        Sat,  6 Feb 2021 05:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587762;
        bh=d2jh2uYLORwrlC3kS9Wr1UHhbi8o/Uvh+D9DqvUeslg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYlrJsLVpHbpkqymtVg1n6r/brL3JDxfzaNs9NQaVgqMbD5vtd17/iJ4Z9ZVvTy2w
         lCVYU5uhQ5OE43l6OpppfOTL3l3JeXBlJEm44K+Ia+ZBkajRPUd2r8gqkTS4FRbLIi
         sfY7vcVHr+wQjBXe6A8DKaqjMJH0LfF8w+5iH5I11B0uHDXR1yF6/L0ohQE7/kO/Ix
         lUyBa8jH62d3H3IW46K2vU3fK2q4QLe4j7/A7IzQBuYrtkGh+iYYyWeLcok3d1miVu
         CDvr73m1N2KbRXuaZOS31CtHxYYAzGaiGeCufB6G0n7Hggz350FpfluqLrhGlprHd9
         1mj0ElgXQpyPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source port
Date:   Fri,  5 Feb 2021 21:02:24 -0800
Message-Id: <20210206050240.48410-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Setting the source port requires only the E-Switch and vport number.
Refactor the function to get those parameters instead of passing the full
attribute.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7f09f2bbf7c1..416ede2fe5d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -257,7 +257,8 @@ mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 				  struct mlx5_flow_spec *spec,
-				  struct mlx5_esw_flow_attr *attr)
+				  struct mlx5_eswitch *src_esw,
+				  u16 vport)
 {
 	void *misc2;
 	void *misc;
@@ -268,8 +269,8 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
 		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
-			 mlx5_eswitch_get_vport_metadata_for_match(attr->in_mdev->priv.eswitch,
-								   attr->in_rep->vport));
+			 mlx5_eswitch_get_vport_metadata_for_match(src_esw,
+								   vport));
 
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
 		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
@@ -278,12 +279,12 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 	} else {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
-		MLX5_SET(fte_match_set_misc, misc, source_port, attr->in_rep->vport);
+		MLX5_SET(fte_match_set_misc, misc, source_port, vport);
 
 		if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 			MLX5_SET(fte_match_set_misc, misc,
 				 source_eswitch_owner_vhca_id,
-				 MLX5_CAP_GEN(attr->in_mdev, vhca_id));
+				 MLX5_CAP_GEN(src_esw->dev, vhca_id));
 
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 		MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
@@ -407,7 +408,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 			fdb = attr->ft;
 
 		if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
-			mlx5_eswitch_set_rule_source_port(esw, spec, esw_attr);
+			mlx5_eswitch_set_rule_source_port(esw, spec,
+							  esw_attr->in_mdev->priv.eswitch,
+							  esw_attr->in_rep->vport);
 	}
 	if (IS_ERR(fdb)) {
 		rule = ERR_CAST(fdb);
@@ -487,7 +490,9 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	dest[i].ft = fwd_fdb;
 	i++;
 
-	mlx5_eswitch_set_rule_source_port(esw, spec, esw_attr);
+	mlx5_eswitch_set_rule_source_port(esw, spec,
+					  esw_attr->in_mdev->priv.eswitch,
+					  esw_attr->in_rep->vport);
 
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
-- 
2.29.2

