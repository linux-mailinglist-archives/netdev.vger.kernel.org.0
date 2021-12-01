Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7890465692
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbhLATkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbhLATkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:40:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0A7C061748;
        Wed,  1 Dec 2021 11:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 270C3CE20D7;
        Wed,  1 Dec 2021 19:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F01C53FD2;
        Wed,  1 Dec 2021 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638387411;
        bh=IYyg1u8T7so8ka7N+0GTaJz8oYtsZpRFGY/nRldkmwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6ZRIUvwsoAH/8bgHFJli1im9lV7iycAVSVyfEBa+O+BuE7K3f5ygsGSJEHojb0iD
         YnQpb05z+Du918ravsxT7G3ganWyN5yg6Lv2YUrrwDDyy5qscNGOcIeM3rBuaFFyj8
         hs/I2FFv4v/tlTLZL7QYADxmbWkl7QQ2+/vwLBtROIkcASEeUCvo0EsWbL7g32hTlt
         V+2PyxDGvto9aPL4+/3x6LFN4cAPbpKhmd078XeirDdu1rTQatEvI/vulX+/xzEWqZ
         4eRtqeWGYPTdyjpWdhGpL6f+pfziC8P4v+BwoPqvBeDtNnILTTgVsfeQHn1jvdKSPd
         CZr0fgDd5XeyA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Refactor mlx5_get_flow_namespace
Date:   Wed,  1 Dec 2021 11:36:19 -0800
Message-Id: <20211201193621.9129-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201193621.9129-1-saeed@kernel.org>
References: <20211201193621.9129-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Have all the namespace type check in the same switch case.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2d26e16a67cd..9736f0dd6a49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2206,6 +2206,22 @@ struct mlx5_flow_namespace *mlx5_get_fdb_sub_ns(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_get_fdb_sub_ns);
 
+static bool is_nic_rx_ns(enum mlx5_flow_namespace_type type)
+{
+	switch (type) {
+	case MLX5_FLOW_NAMESPACE_BYPASS:
+	case MLX5_FLOW_NAMESPACE_LAG:
+	case MLX5_FLOW_NAMESPACE_OFFLOADS:
+	case MLX5_FLOW_NAMESPACE_ETHTOOL:
+	case MLX5_FLOW_NAMESPACE_KERNEL:
+	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
+	case MLX5_FLOW_NAMESPACE_ANCHOR:
+		return true;
+	default:
+		return false;
+	}
+}
+
 struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 						    enum mlx5_flow_namespace_type type)
 {
@@ -2236,31 +2252,35 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
 		return NULL;
-	default:
-		break;
-	}
-
-	if (type == MLX5_FLOW_NAMESPACE_EGRESS ||
-	    type == MLX5_FLOW_NAMESPACE_EGRESS_KERNEL) {
+	case MLX5_FLOW_NAMESPACE_EGRESS:
+	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
 		root_ns = steering->egress_root_ns;
 		prio = type - MLX5_FLOW_NAMESPACE_EGRESS;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_BYPASS_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_KERNEL_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_COUNTERS_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS:
 		root_ns = steering->rdma_tx_root_ns;
 		prio = RDMA_TX_COUNTERS_PRIO;
-	} else { /* Must be NIC RX */
+		break;
+	default: /* Must be NIC RX */
+		WARN_ON(!is_nic_rx_ns(type));
 		root_ns = steering->root_ns;
 		prio = type;
+		break;
 	}
 
 	if (!root_ns)
-- 
2.31.1

