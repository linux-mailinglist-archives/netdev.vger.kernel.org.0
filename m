Return-Path: <netdev+bounces-3985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE997709EAF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB73281DDF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9876314A97;
	Fri, 19 May 2023 17:56:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331D14A8A
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D8FC433A7;
	Fri, 19 May 2023 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518980;
	bh=YwCt/mdNuEBvWIa71gCpeSQoYAFjxhwVBbICQN6mcyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmOWTmhm0BLdAdKUVWOyRNc2lRQsqLI29b8eh8MssKCmqmPHvpIIhp5Ffsztl82mN
	 yL7lvNHjj6VzEtDpNn3PNaN6qi00GnWJlaMWBVy0IIpITX1CELFb92qKoMfRiL8mvM
	 9tAQnesBwItTsdpT61tWKTKaDU7mogrELYwbhPHf8rOeZLIaTid6lQJV89qWnsJIaY
	 2BqaAndn12SWy/CuOirbH4tsckcfNbVmjSHLhdW9BiHwRf6b4dvd3xlkZ07DC2ZEup
	 McdcXXU3oLj9pah4kcqQGr+XT7QOQJHZgR91Duvp3AA/tQCpOiEZUATePUzOV4b/HP
	 u+1ShAK5gPQ3Q==
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
Subject: [net-next 13/15] net/mlx5: E-Switch, Use metadata matching for RoCE loopback rule
Date: Fri, 19 May 2023 10:55:55 -0700
Message-Id: <20230519175557.15683-14-saeed@kernel.org>
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

Use metadata matching for RoCE loopback rule if device is configured
to use metadata for source port matching.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 ++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 46 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/rdma.c    | 20 ++------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1a042c981713..6c5c05c414fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -683,6 +683,14 @@ mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
 
+void mlx5_esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
+					 u32 *flow_group_in,
+					 int match_params);
+
+void mlx5_esw_set_spec_source_port(struct mlx5_eswitch *esw,
+				   u16 vport,
+				   struct mlx5_flow_spec *spec);
+
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
 void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 44b5d1359155..76db72f339d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1293,9 +1293,10 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 #define MAX_PF_SQ 256
 #define MAX_SQ_NVPORTS 32
 
-static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
-					   u32 *flow_group_in,
-					   int match_params)
+void
+mlx5_esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
+				    u32 *flow_group_in,
+				    int match_params)
 {
 	void *match_criteria = MLX5_ADDR_OF(create_flow_group_in,
 					    flow_group_in,
@@ -1488,7 +1489,7 @@ esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
 
 	memset(flow_group_in, 0, inlen);
 
-	esw_set_flow_group_source_port(esw, flow_group_in, MLX5_MATCH_MISC_PARAMETERS);
+	mlx5_esw_set_flow_group_source_port(esw, flow_group_in, MLX5_MATCH_MISC_PARAMETERS);
 
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
@@ -1582,7 +1583,7 @@ esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
 
 	memset(flow_group_in, 0, inlen);
 
-	esw_set_flow_group_source_port(esw, flow_group_in, 0);
+	mlx5_esw_set_flow_group_source_port(esw, flow_group_in, 0);
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
@@ -1869,7 +1870,7 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 		return -ENOMEM;
 
 	/* create vport rx group */
-	esw_set_flow_group_source_port(esw, flow_group_in, 0);
+	mlx5_esw_set_flow_group_source_port(esw, flow_group_in, 0);
 
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, nvports - 1);
@@ -1939,21 +1940,13 @@ static void esw_destroy_vport_rx_drop_group(struct mlx5_eswitch *esw)
 		mlx5_destroy_flow_group(esw->offloads.vport_rx_drop_group);
 }
 
-struct mlx5_flow_handle *
-mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
-				  struct mlx5_flow_destination *dest)
+void
+mlx5_esw_set_spec_source_port(struct mlx5_eswitch *esw,
+			      u16 vport,
+			      struct mlx5_flow_spec *spec)
 {
-	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_handle *flow_rule;
-	struct mlx5_flow_spec *spec;
 	void *misc;
 
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		flow_rule = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
 		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
@@ -1973,6 +1966,23 @@ mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 
 		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
 	}
+}
+
+struct mlx5_flow_handle *
+mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
+				  struct mlx5_flow_destination *dest)
+{
+	struct mlx5_flow_act flow_act = {0};
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_flow_spec *spec;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		flow_rule = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	mlx5_esw_set_spec_source_port(esw, vport, spec);
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	flow_rule = mlx5_add_flow_rules(esw->offloads.ft_offloads, spec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 15bb562b3846..a42f6cd99b74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -30,9 +30,8 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *fg;
-	void *match_criteria;
+	struct mlx5_eswitch *esw;
 	u32 *flow_group_in;
-	void *misc;
 	int err;
 
 	if (!(MLX5_CAP_FLOWTABLE_RDMA_RX(dev, ft_support) &&
@@ -63,12 +62,8 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 		goto free;
 	}
 
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_MISC_PARAMETERS);
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
-				      match_criteria);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-			 misc_parameters.source_port);
+	esw = dev->priv.eswitch;
+	mlx5_esw_set_flow_group_source_port(esw, flow_group_in, 0);
 
 	fg = mlx5_create_flow_group(ft, flow_group_in);
 	if (IS_ERR(fg)) {
@@ -77,14 +72,7 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 		goto destroy_flow_table;
 	}
 
-	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
-	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    misc_parameters);
-	MLX5_SET(fte_match_set_misc, misc, source_port,
-		 dev->priv.eswitch->manager_vport);
-	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			    misc_parameters);
-	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
+	mlx5_esw_set_spec_source_port(esw, esw->manager_vport, spec);
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	flow_rule = mlx5_add_flow_rules(ft, spec, &flow_act, NULL, 0);
-- 
2.40.1


