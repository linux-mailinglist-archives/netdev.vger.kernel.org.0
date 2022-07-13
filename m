Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E27573FDD
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGMW7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiGMW72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C912A941
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C319861A5A
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D40C341C6;
        Wed, 13 Jul 2022 22:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753160;
        bh=t5mWu7RB5fiNNBRe9M2Bpmf+dNbjfp04MMG4dHbMtqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTUxTCw0h+lw5ggpmUkPCb0gWsysmX/dCmvqjcLh/MIdmHil1EodGqCWoGy6SK2iz
         Bn2A2NNVWh9RqlLqvOxbV7YuFrqaDH+0Fw4MZ6BHm/3729y5l1s53uJ+BvkXCj2oYk
         eJhBd7h1Gzn7P8QNUMgtqIcoLWbg0R2LzXKJSfqMqWiQ8u6k8tSHEK9DCqPWYGnso3
         ThBr6rmimETW4ujTr7+4UQVhklQroelcVL0iGGhZTenQ8q94rRfpFtl5rTRYMohJNr
         y+e3wkyUAXdthekU9mLUVBZ4CI7mjSetvtzdhyGRAPPBXErZMz5XrnDbgjywnP+6K7
         AG2A0ExXSRWLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Bridge, implement QinQ support
Date:   Wed, 13 Jul 2022 15:58:54 -0700
Message-Id: <20220713225859.401241-11-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Implement support for new 802.1ad VLAN protocol type. Create new flow
groups that handle svlan tags. Create FDB flows with svlan tag match when
bridge VLAN is set to QinQ.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 117 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   2 +
 2 files changed, 111 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index e505c4623e65..4fbff7bcc155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -13,8 +13,8 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 16000
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 32000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 12000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 16000
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
@@ -23,8 +23,18 @@
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM			\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM	\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM +	\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
@@ -32,13 +42,18 @@
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
 static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
 
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 32000
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 16000
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (32000 - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM		\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
 	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
@@ -80,6 +95,7 @@ struct mlx5_esw_bridge {
 
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_vlan_fg;
+	struct mlx5_flow_group *egress_qinq_fg;
 	struct mlx5_flow_group *egress_mac_fg;
 	struct mlx5_flow_group *egress_miss_fg;
 	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
@@ -176,6 +192,8 @@ mlx5_esw_bridge_ingress_vlan_proto_fg_create(unsigned int from, unsigned int to,
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
 	if (vlan_proto == ETH_P_8021Q)
 		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	else if (vlan_proto == ETH_P_8021AD)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.svlan_tag);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
 
 	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
@@ -204,6 +222,17 @@ mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw,
 	return mlx5_esw_bridge_ingress_vlan_proto_fg_create(from, to, ETH_P_8021Q, esw, ingress_ft);
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_qinq_fg_create(struct mlx5_eswitch *esw,
+				       struct mlx5_flow_table *ingress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_ingress_vlan_proto_fg_create(from, to, ETH_P_8021AD, esw,
+							    ingress_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_vlan_proto_filter_fg_create(unsigned int from, unsigned int to,
 						    u16 vlan_proto, struct mlx5_eswitch *esw,
@@ -225,6 +254,8 @@ mlx5_esw_bridge_ingress_vlan_proto_filter_fg_create(unsigned int from, unsigned
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
 	if (vlan_proto == ETH_P_8021Q)
 		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	else if (vlan_proto == ETH_P_8021AD)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.svlan_tag);
 	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_mask());
 
@@ -251,6 +282,17 @@ mlx5_esw_bridge_ingress_vlan_filter_fg_create(struct mlx5_eswitch *esw,
 								   ingress_ft);
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_qinq_filter_fg_create(struct mlx5_eswitch *esw,
+					      struct mlx5_flow_table *ingress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_ingress_vlan_proto_filter_fg_create(from, to, ETH_P_8021AD, esw,
+								   ingress_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
 {
@@ -307,6 +349,8 @@ mlx5_esw_bridge_egress_vlan_proto_fg_create(unsigned int from, unsigned int to,
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_15_0);
 	if (vlan_proto == ETH_P_8021Q)
 		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	else if (vlan_proto == ETH_P_8021AD)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.svlan_tag);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
 
 	MLX5_SET(create_flow_group_in, in, start_flow_index, from);
@@ -330,6 +374,16 @@ mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 	return mlx5_esw_bridge_egress_vlan_proto_fg_create(from, to, ETH_P_8021Q, esw, egress_ft);
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_egress_qinq_fg_create(struct mlx5_eswitch *esw,
+				      struct mlx5_flow_table *egress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_egress_vlan_proto_fg_create(from, to, ETH_P_8021AD, esw, egress_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
 {
@@ -394,7 +448,7 @@ mlx5_esw_bridge_egress_miss_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 static int
 mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_flow_group *mac_fg, *vlan_filter_fg, *vlan_fg;
+	struct mlx5_flow_group *mac_fg, *qinq_filter_fg, *qinq_fg, *vlan_filter_fg, *vlan_fg;
 	struct mlx5_flow_table *ingress_ft, *skip_ft;
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	int err;
@@ -428,6 +482,18 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 		goto err_vlan_filter_fg;
 	}
 
+	qinq_fg = mlx5_esw_bridge_ingress_qinq_fg_create(esw, ingress_ft);
+	if (IS_ERR(qinq_fg)) {
+		err = PTR_ERR(qinq_fg);
+		goto err_qinq_fg;
+	}
+
+	qinq_filter_fg = mlx5_esw_bridge_ingress_qinq_filter_fg_create(esw, ingress_ft);
+	if (IS_ERR(qinq_filter_fg)) {
+		err = PTR_ERR(qinq_filter_fg);
+		goto err_qinq_filter_fg;
+	}
+
 	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(esw, ingress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
@@ -438,10 +504,16 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	br_offloads->skip_ft = skip_ft;
 	br_offloads->ingress_vlan_fg = vlan_fg;
 	br_offloads->ingress_vlan_filter_fg = vlan_filter_fg;
+	br_offloads->ingress_qinq_fg = qinq_fg;
+	br_offloads->ingress_qinq_filter_fg = qinq_filter_fg;
 	br_offloads->ingress_mac_fg = mac_fg;
 	return 0;
 
 err_mac_fg:
+	mlx5_destroy_flow_group(qinq_filter_fg);
+err_qinq_filter_fg:
+	mlx5_destroy_flow_group(qinq_fg);
+err_qinq_fg:
 	mlx5_destroy_flow_group(vlan_filter_fg);
 err_vlan_filter_fg:
 	mlx5_destroy_flow_group(vlan_fg);
@@ -457,6 +529,10 @@ mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloa
 {
 	mlx5_destroy_flow_group(br_offloads->ingress_mac_fg);
 	br_offloads->ingress_mac_fg = NULL;
+	mlx5_destroy_flow_group(br_offloads->ingress_qinq_filter_fg);
+	br_offloads->ingress_qinq_filter_fg = NULL;
+	mlx5_destroy_flow_group(br_offloads->ingress_qinq_fg);
+	br_offloads->ingress_qinq_fg = NULL;
 	mlx5_destroy_flow_group(br_offloads->ingress_vlan_filter_fg);
 	br_offloads->ingress_vlan_filter_fg = NULL;
 	mlx5_destroy_flow_group(br_offloads->ingress_vlan_fg);
@@ -476,7 +552,7 @@ static int
 mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct mlx5_esw_bridge *bridge)
 {
-	struct mlx5_flow_group *miss_fg = NULL, *mac_fg, *vlan_fg;
+	struct mlx5_flow_group *miss_fg = NULL, *mac_fg, *vlan_fg, *qinq_fg;
 	struct mlx5_pkt_reformat *miss_pkt_reformat = NULL;
 	struct mlx5_flow_handle *miss_handle = NULL;
 	struct mlx5_eswitch *esw = br_offloads->esw;
@@ -495,6 +571,12 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 		goto err_vlan_fg;
 	}
 
+	qinq_fg = mlx5_esw_bridge_egress_qinq_fg_create(esw, egress_ft);
+	if (IS_ERR(qinq_fg)) {
+		err = PTR_ERR(qinq_fg);
+		goto err_qinq_fg;
+	}
+
 	mac_fg = mlx5_esw_bridge_egress_mac_fg_create(esw, egress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
@@ -539,6 +621,7 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 
 	bridge->egress_ft = egress_ft;
 	bridge->egress_vlan_fg = vlan_fg;
+	bridge->egress_qinq_fg = qinq_fg;
 	bridge->egress_mac_fg = mac_fg;
 	bridge->egress_miss_fg = miss_fg;
 	bridge->egress_miss_pkt_reformat = miss_pkt_reformat;
@@ -546,6 +629,8 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 	return 0;
 
 err_mac_fg:
+	mlx5_destroy_flow_group(qinq_fg);
+err_qinq_fg:
 	mlx5_destroy_flow_group(vlan_fg);
 err_vlan_fg:
 	mlx5_destroy_flow_table(egress_ft);
@@ -563,6 +648,7 @@ mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 	if (bridge->egress_miss_fg)
 		mlx5_destroy_flow_group(bridge->egress_miss_fg);
 	mlx5_destroy_flow_group(bridge->egress_mac_fg);
+	mlx5_destroy_flow_group(bridge->egress_qinq_fg);
 	mlx5_destroy_flow_group(bridge->egress_vlan_fg);
 	mlx5_destroy_flow_table(bridge->egress_ft);
 }
@@ -612,6 +698,11 @@ mlx5_esw_bridge_ingress_flow_with_esw_create(u16 vport_num, const unsigned char
 					 outer_headers.cvlan_tag);
 			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
 					 outer_headers.cvlan_tag);
+		} else if (bridge->vlan_proto == ETH_P_8021AD) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.svlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.svlan_tag);
 		}
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.first_vid);
@@ -700,6 +791,11 @@ mlx5_esw_bridge_ingress_filter_flow_create(u16 vport_num, const unsigned char *a
 				 outer_headers.cvlan_tag);
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
 				 outer_headers.cvlan_tag);
+	} else if (bridge->vlan_proto == ETH_P_8021AD) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.svlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.svlan_tag);
 	}
 
 	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, &dest, 1);
@@ -753,6 +849,11 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, u16 esw_owner_vhca_id, const u
 					 outer_headers.cvlan_tag);
 			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
 					 outer_headers.cvlan_tag);
+		} else if (bridge->vlan_proto == ETH_P_8021AD) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.svlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.svlan_tag);
 		}
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.first_vid);
@@ -1421,7 +1522,7 @@ int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 pro
 	bridge = port->bridge;
 	if (bridge->vlan_proto == proto)
 		return 0;
-	if (proto != ETH_P_8021Q) {
+	if (proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
 		esw_warn(br_offloads->esw->dev, "Can't set unsupported VLAN protocol %x", proto);
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 8c322ef05892..10851a515bca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -27,6 +27,8 @@ struct mlx5_esw_bridge_offloads {
 	struct mlx5_flow_table *ingress_ft;
 	struct mlx5_flow_group *ingress_vlan_fg;
 	struct mlx5_flow_group *ingress_vlan_filter_fg;
+	struct mlx5_flow_group *ingress_qinq_fg;
+	struct mlx5_flow_group *ingress_qinq_filter_fg;
 	struct mlx5_flow_group *ingress_mac_fg;
 
 	struct mlx5_flow_table *skip_ft;
-- 
2.36.1

