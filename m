Return-Path: <netdev+bounces-3979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B840F709EA8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6C51C2124A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFC913ADD;
	Fri, 19 May 2023 17:56:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5A513ACF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FDBC433D2;
	Fri, 19 May 2023 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518975;
	bh=V7DoArGqRlb9CWO48XEQmUXeoPhXb/dAsh0DMjKdyNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj9y/jkdVPyDHKuyX+p9YTuLWdF5QlkPQBbXpGSbWQ+ycsD7N4hoWIGk5CKFuePXa
	 HlPCUhJWXKxFNdGq2fII+o+GGo/hNwtoZh+2k1t6d3LOuhZ0+c31M5wy9uyNuqu0Au
	 JuRnzUk6rK8t50eNXGex9cXs88aghEDO+2hXnugohnUCJinbPJy+b+dPxAwZw4RGUH
	 DC0tkSMBlu0suMXpv4WF62LBKTXrdEPhNfZKeQgZW6yAlM2d2sovWLibRf0vHyuOGo
	 YI8xWyag80iGsS2wuvGQI3dC4yT03MZDQBH9fKD7qfc0qv+FZOiCwxkvEUgDWS7kKo
	 kwdXHQ4+bFYnQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: E-Switch, Use metadata for vport matching in send-to-vport rules
Date: Fri, 19 May 2023 10:55:49 -0700
Message-Id: <20230519175557.15683-8-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Like other rules use metadata matching if supported instead of
source_port.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 62 +++++++++++++------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ecd12a0c6f07..66a522d08be1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -838,6 +838,7 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_spec *spec;
 	void *misc;
+	u16 vport;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -847,20 +848,43 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 	MLX5_SET(fte_match_set_misc, misc, source_sqn, sqn);
-	/* source vport is the esw manager */
-	MLX5_SET(fte_match_set_misc, misc, source_port, from_esw->manager_vport);
-	if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
-		MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
-			 MLX5_CAP_GEN(from_esw->dev, vhca_id));
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_sqn);
-	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
-	if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
-		MLX5_SET_TO_ONES(fte_match_set_misc, misc,
-				 source_eswitch_owner_vhca_id);
 
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
+
+	/* source vport is the esw manager */
+	vport = from_esw->manager_vport;
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(on_esw)) {
+		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
+		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_for_match(from_esw, vport));
+
+		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
+		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
+
+		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+	} else {
+		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
+		MLX5_SET(fte_match_set_misc, misc, source_port, vport);
+
+		if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
+			MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
+				 MLX5_CAP_GEN(from_esw->dev, vhca_id));
+
+		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
+
+		if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
+			MLX5_SET_TO_ONES(fte_match_set_misc, misc,
+					 source_eswitch_owner_vhca_id);
+
+		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+	}
+
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = rep->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(rep->esw->dev, vhca_id);
@@ -1270,7 +1294,8 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 #define MAX_SQ_NVPORTS 32
 
 static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
-					   u32 *flow_group_in)
+					   u32 *flow_group_in,
+					   int match_params)
 {
 	void *match_criteria = MLX5_ADDR_OF(create_flow_group_in,
 					    flow_group_in,
@@ -1279,7 +1304,7 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		MLX5_SET(create_flow_group_in, flow_group_in,
 			 match_criteria_enable,
-			 MLX5_MATCH_MISC_PARAMETERS_2);
+			 MLX5_MATCH_MISC_PARAMETERS_2 | match_params);
 
 		MLX5_SET(fte_match_param, match_criteria,
 			 misc_parameters_2.metadata_reg_c_0,
@@ -1287,7 +1312,7 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 	} else {
 		MLX5_SET(create_flow_group_in, flow_group_in,
 			 match_criteria_enable,
-			 MLX5_MATCH_MISC_PARAMETERS);
+			 MLX5_MATCH_MISC_PARAMETERS | match_params);
 
 		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
 				 misc_parameters.source_port);
@@ -1463,14 +1488,13 @@ esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
 
 	memset(flow_group_in, 0, inlen);
 
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_MISC_PARAMETERS);
+	esw_set_flow_group_source_port(esw, flow_group_in, MLX5_MATCH_MISC_PARAMETERS);
 
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
-
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_port);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+	    MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
 		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
 				 misc_parameters.source_eswitch_owner_vhca_id);
 		MLX5_SET(create_flow_group_in, flow_group_in,
@@ -1558,7 +1582,7 @@ esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
 
 	memset(flow_group_in, 0, inlen);
 
-	esw_set_flow_group_source_port(esw, flow_group_in);
+	esw_set_flow_group_source_port(esw, flow_group_in, 0);
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
@@ -1845,7 +1869,7 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 		return -ENOMEM;
 
 	/* create vport rx group */
-	esw_set_flow_group_source_port(esw, flow_group_in);
+	esw_set_flow_group_source_port(esw, flow_group_in, 0);
 
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, nvports - 1);
-- 
2.40.1


