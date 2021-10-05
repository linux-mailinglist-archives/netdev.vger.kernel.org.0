Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A968C421B9C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhJEBRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhJEBQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC88615A3;
        Tue,  5 Oct 2021 01:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396489;
        bh=r3P8d6axw7ec4FSLieYQn0HYdWAzgfWlYU65/kglq7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvV/nTTR1U39VYIT2tFVEyFiJyBPShsTrQzXWbs9YT+b+zELoU0kjK5xh3ZqJs5hd
         MEI8x+uGbGPiuMFqjDFtkvLy0hj7BHxDxtmCck97jVpzxFC8fXf3ARlacBqKm8j+NV
         cO7eld/7zMhVi17n13cTCuDrHjjE2vv1prbJu4yA2OzHzNbi8uXWlM10LA3oQB/yq3
         SRMeSn/qqSm/cBX8h5JIcfyIvDM/ctJTcJ3DZv2GxcVl4NmaxpD8PCCm++JbRLohJX
         dRlN4e6pvl5qJYw1xnJgmExWroHxmCGMWFk74sXNEdSmMf5rAdOHr9YLaXm5N0d0XE
         qZ2bCLZnaFnVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Bridge, pop VLAN on egress table miss
Date:   Mon,  4 Oct 2021 18:13:00 -0700
Message-Id: <20211005011302.41793-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Create lowest priority flow group in egress table with single rule that
matches on special reg_c1 value that is set on ingress VLAN push with
single action that pops VLAN. The flow destination is skip table that is
used to skip any further processing of packet in FDB bridge priority.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 128 +++++++++++++++++-
 1 file changed, 126 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 439b67b4380f..ed72246d1d83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -28,7 +28,10 @@
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE / 2 - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 2)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
 
 #define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
 
@@ -61,6 +64,9 @@ struct mlx5_esw_bridge {
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_vlan_fg;
 	struct mlx5_flow_group *egress_mac_fg;
+	struct mlx5_flow_group *egress_miss_fg;
+	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
+	struct mlx5_flow_handle *egress_miss_handle;
 	unsigned long ageing_time;
 	u32 flags;
 };
@@ -307,6 +313,36 @@ mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_egress_miss_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_MISC_PARAMETERS_2);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(egress_ft, in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create bridge egress table miss flow group (err=%ld)\n",
+			 PTR_ERR(fg));
+	kvfree(in);
+	return fg;
+}
+
 static int
 mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
@@ -383,12 +419,19 @@ mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloa
 	br_offloads->ingress_ft = NULL;
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_egress_miss_flow_create(struct mlx5_flow_table *egress_ft,
+					struct mlx5_flow_table *skip_ft,
+					struct mlx5_pkt_reformat *pkt_reformat);
+
 static int
 mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct mlx5_esw_bridge *bridge)
 {
+	struct mlx5_flow_group *miss_fg = NULL, *mac_fg, *vlan_fg;
+	struct mlx5_pkt_reformat *miss_pkt_reformat = NULL;
+	struct mlx5_flow_handle *miss_handle = NULL;
 	struct mlx5_eswitch *esw = br_offloads->esw;
-	struct mlx5_flow_group *mac_fg, *vlan_fg;
 	struct mlx5_flow_table *egress_ft;
 	int err;
 
@@ -410,9 +453,48 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 		goto err_mac_fg;
 	}
 
+	if (mlx5_esw_bridge_pkt_reformat_vlan_pop_supported(esw)) {
+		miss_fg = mlx5_esw_bridge_egress_miss_fg_create(esw, egress_ft);
+		if (IS_ERR(miss_fg)) {
+			esw_warn(esw->dev, "Failed to create miss flow group (err=%ld)\n",
+				 PTR_ERR(miss_fg));
+			miss_fg = NULL;
+			goto skip_miss_flow;
+		}
+
+		miss_pkt_reformat = mlx5_esw_bridge_pkt_reformat_vlan_pop_create(esw);
+		if (IS_ERR(miss_pkt_reformat)) {
+			esw_warn(esw->dev,
+				 "Failed to alloc packet reformat REMOVE_HEADER (err=%ld)\n",
+				 PTR_ERR(miss_pkt_reformat));
+			miss_pkt_reformat = NULL;
+			mlx5_destroy_flow_group(miss_fg);
+			miss_fg = NULL;
+			goto skip_miss_flow;
+		}
+
+		miss_handle = mlx5_esw_bridge_egress_miss_flow_create(egress_ft,
+								      br_offloads->skip_ft,
+								      miss_pkt_reformat);
+		if (IS_ERR(miss_handle)) {
+			esw_warn(esw->dev, "Failed to create miss flow (err=%ld)\n",
+				 PTR_ERR(miss_handle));
+			miss_handle = NULL;
+			mlx5_packet_reformat_dealloc(esw->dev, miss_pkt_reformat);
+			miss_pkt_reformat = NULL;
+			mlx5_destroy_flow_group(miss_fg);
+			miss_fg = NULL;
+			goto skip_miss_flow;
+		}
+	}
+skip_miss_flow:
+
 	bridge->egress_ft = egress_ft;
 	bridge->egress_vlan_fg = vlan_fg;
 	bridge->egress_mac_fg = mac_fg;
+	bridge->egress_miss_fg = miss_fg;
+	bridge->egress_miss_pkt_reformat = miss_pkt_reformat;
+	bridge->egress_miss_handle = miss_handle;
 	return 0;
 
 err_mac_fg:
@@ -425,6 +507,13 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 static void
 mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 {
+	if (bridge->egress_miss_handle)
+		mlx5_del_flow_rules(bridge->egress_miss_handle);
+	if (bridge->egress_miss_pkt_reformat)
+		mlx5_packet_reformat_dealloc(bridge->br_offloads->esw->dev,
+					     bridge->egress_miss_pkt_reformat);
+	if (bridge->egress_miss_fg)
+		mlx5_destroy_flow_group(bridge->egress_miss_fg);
 	mlx5_destroy_flow_group(bridge->egress_mac_fg);
 	mlx5_destroy_flow_group(bridge->egress_vlan_fg);
 	mlx5_destroy_flow_table(bridge->egress_ft);
@@ -623,6 +712,41 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, u16 esw_owner_vhca_id, const u
 	return handle;
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_egress_miss_flow_create(struct mlx5_flow_table *egress_ft,
+					struct mlx5_flow_table *skip_ft,
+					struct mlx5_pkt_reformat *pkt_reformat)
+{
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+		.ft = skip_ft,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+		MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT,
+		.flags = FLOW_ACT_NO_APPEND,
+		.pkt_reformat = pkt_reformat,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
+
+	MLX5_SET(fte_match_param, rule_spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_1,
+		 ESW_TUN_BRIDGE_INGRESS_PUSH_VLAN_MARK);
+
+	handle = mlx5_add_flow_rules(egress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
 static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 						      struct mlx5_esw_bridge_offloads *br_offloads)
 {
-- 
2.31.1

