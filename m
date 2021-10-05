Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B053B421B99
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhJEBQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhJEBQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7FA961401;
        Tue,  5 Oct 2021 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396488;
        bh=Gw+Pgg4O/HAuykSxlZVYMwPovurYBpYgz2hwiCBgG7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmeaPzBvRYCWri+gb8QAT3XZKXQo5ye19CWLpB4q5nImzkJQunm9txKRv8kLszUcY
         7nvkMxlou1+irpWtvbc/LlhCJrrn5+NgfvB84RwiEct3UcX8s7BPushV6tE1wpsxUe
         HWoeBdYa6oHBVj4p0G3eOyBsNfyjMWllZwJs3giyjQq3CcfF2M8zpDy5sR99SNcYyV
         /tvGg4JXaD3x/NTaz5vYEMtnVlyrSCVzc5n25YWvj0gQ2qc3TdsE4PeWz3IEbmIhsp
         q7eTcnEUt0hoJ0WuchXILXeI686NVDHiiODOvc0p13Yf7TTq0WZkB+m7iGvul7E5V6
         0NzUTraouUuGA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Bridge, extract VLAN pop code to dedicated functions
Date:   Mon,  4 Oct 2021 18:12:58 -0700
Message-Id: <20211005011302.41793-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series need to pop VLAN when packet misses on egress.
To reuse existing bridge VLAN pop handling code, extract it to dedicated
helpers mlx5_esw_bridge_pkt_reformat_vlan_pop_supported() and
mlx5_esw_bridge_pkt_reformat_vlan_pop_create().

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 34 ++++++++++++-------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 6a36c5aef74c..8361dfc0bf1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -86,6 +86,26 @@ mlx5_esw_bridge_fdb_del_notify(struct mlx5_esw_bridge_fdb_entry *entry)
 						   SWITCHDEV_FDB_DEL_TO_BRIDGE);
 }
 
+static bool mlx5_esw_bridge_pkt_reformat_vlan_pop_supported(struct mlx5_eswitch *esw)
+{
+	return BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_remove)) &&
+		MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_size) >= sizeof(struct vlan_hdr) &&
+		MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_offset) >=
+		offsetof(struct vlan_ethhdr, h_vlan_proto);
+}
+
+static struct mlx5_pkt_reformat *
+mlx5_esw_bridge_pkt_reformat_vlan_pop_create(struct mlx5_eswitch *esw)
+{
+	struct mlx5_pkt_reformat_params reformat_params = {};
+
+	reformat_params.type = MLX5_REFORMAT_TYPE_REMOVE_HDR;
+	reformat_params.param_0 = MLX5_REFORMAT_CONTEXT_ANCHOR_MAC_START;
+	reformat_params.param_1 = offsetof(struct vlan_ethhdr, h_vlan_proto);
+	reformat_params.size = sizeof(struct vlan_hdr);
+	return mlx5_packet_reformat_alloc(esw->dev, &reformat_params, MLX5_FLOW_NAMESPACE_FDB);
+}
+
 static struct mlx5_flow_table *
 mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 {
@@ -800,24 +820,14 @@ mlx5_esw_bridge_vlan_push_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct mlx5
 static int
 mlx5_esw_bridge_vlan_pop_create(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
 {
-	struct mlx5_pkt_reformat_params reformat_params = {};
 	struct mlx5_pkt_reformat *pkt_reformat;
 
-	if (!BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_remove)) ||
-	    MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_size) < sizeof(struct vlan_hdr) ||
-	    MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_offset) <
-	    offsetof(struct vlan_ethhdr, h_vlan_proto)) {
+	if (!mlx5_esw_bridge_pkt_reformat_vlan_pop_supported(esw)) {
 		esw_warn(esw->dev, "Packet reformat REMOVE_HEADER is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
-	reformat_params.type = MLX5_REFORMAT_TYPE_REMOVE_HDR;
-	reformat_params.param_0 = MLX5_REFORMAT_CONTEXT_ANCHOR_MAC_START;
-	reformat_params.param_1 = offsetof(struct vlan_ethhdr, h_vlan_proto);
-	reformat_params.size = sizeof(struct vlan_hdr);
-	pkt_reformat = mlx5_packet_reformat_alloc(esw->dev,
-						  &reformat_params,
-						  MLX5_FLOW_NAMESPACE_FDB);
+	pkt_reformat = mlx5_esw_bridge_pkt_reformat_vlan_pop_create(esw);
 	if (IS_ERR(pkt_reformat)) {
 		esw_warn(esw->dev, "Failed to alloc packet reformat REMOVE_HEADER (err=%ld)\n",
 			 PTR_ERR(pkt_reformat));
-- 
2.31.1

