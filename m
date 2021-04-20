Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539AB3650D1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhDTDV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234380AbhDTDVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93B72613AB;
        Tue, 20 Apr 2021 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888840;
        bh=etugPg9Tbue29xr1oyCpGqPo4q6VfhRs4BfePpKKuVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZbvCdTKcmBSRP9inDipqVHBWv/haYh3UAjO3kDKQTkFodv6Yx/7FOQNNHOD6nh+N
         iYVy8qL24o7sH7jFDhwGbGN/ruZss0D7CCsS/NT7lmloS4vUpLlLLnPagPGmZBuoL3
         og9OMGRDyovb7UmBFpoewltSgk1LJhgGDP4kiCg12A75tvTT/2ETE7j9r2pkwsbpLm
         n2qDvbXbBR8TdAUETZSiQKq9Ff+lGycyrKJxNrstIb0SLI9IFCe7jDfk0a4Q1X7P1Q
         xjuLLi58dGedOQQxYiWNCadvnxQZ842DGeck7V8y0CgcfmNc8Qk2XJZdFUr95tWo4c
         jvOYSiISOCZ4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: DR, Add support for isolate_vl_tc QP
Date:   Mon, 19 Apr 2021 20:20:18 -0700
Message-Id: <20210420032018.58639-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When using SW steering, rule insertion rate depends on the RDMA RC QP
performance used for writing to the ICM. During stress this QP is competing
on the HW resources with all the other QPs that are used to send data.
To protect SW steering QP's performance in such cases, we set this QP to
use isolated VL. The VL number is reserved by FW and is not exposed to the
driver.
Support for this QP on isolated VL exists only when both force-loopback and
isolate_vl_tc capabilities are set.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 7 +++++++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h    | 2 ++
 include/linux/mlx5/mlx5_ifc.h                              | 4 +++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 68d898e144fb..5970cb8fc0c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -130,6 +130,8 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_enabled);
 	}
 
+	caps->isolate_vl_tc = MLX5_CAP_GEN(mdev, isolate_vl_tc_new);
+
 	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED) {
 		caps->flex_parser_id_icmp_dw0 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw0);
 		caps->flex_parser_id_icmp_dw1 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 69d623bedefe..12cf323a5943 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -46,6 +46,7 @@ struct dr_qp_init_attr {
 	u32 pdn;
 	u32 max_send_wr;
 	struct mlx5_uars_page *uar;
+	u8 isolate_vl_tc:1;
 };
 
 static int dr_parse_cqe(struct mlx5dr_cq *dr_cq, struct mlx5_cqe64 *cqe64)
@@ -158,6 +159,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_RC);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+	MLX5_SET(qpc, qpc, isolate_vl_tc, attr->isolate_vl_tc);
 	MLX5_SET(qpc, qpc, pd, attr->pdn);
 	MLX5_SET(qpc, qpc, uar_page, attr->uar->index);
 	MLX5_SET(qpc, qpc, log_page_size,
@@ -924,6 +926,11 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 	init_attr.pdn = dmn->pdn;
 	init_attr.uar = dmn->uar;
 	init_attr.max_send_wr = QUEUE_SIZE;
+
+	/* Isolated VL is applicable only if force loopback is supported */
+	if (dr_send_allow_fl(&dmn->info.caps))
+		init_attr.isolate_vl_tc = dmn->info.caps.isolate_vl_tc;
+
 	spin_lock_init(&dmn->send_ring->lock);
 
 	dmn->send_ring->qp = dr_create_rc_qp(dmn->mdev, &init_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 8de70566f85b..67460c42a99b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -790,6 +790,7 @@ struct mlx5dr_cmd_caps {
 	struct mlx5dr_cmd_vport_cap *vports_caps;
 	bool prio_tag_required;
 	struct mlx5dr_roce_cap roce_caps;
+	u8 isolate_vl_tc:1;
 };
 
 struct mlx5dr_domain_rx_tx {
@@ -1164,6 +1165,7 @@ struct mlx5dr_cmd_qp_create_attr {
 	u32 sq_wqe_cnt;
 	u32 rq_wqe_cnt;
 	u32 rq_wqe_shift;
+	u8 isolate_vl_tc:1;
 };
 
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4d9569c4b96c..52b7cabcde08 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1319,7 +1319,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_srq_sz[0x8];
 	u8         log_max_qp_sz[0x8];
 	u8         event_cap[0x1];
-	u8         reserved_at_91[0x7];
+	u8         reserved_at_91[0x2];
+	u8         isolate_vl_tc_new[0x1];
+	u8         reserved_at_94[0x4];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
-- 
2.30.2

