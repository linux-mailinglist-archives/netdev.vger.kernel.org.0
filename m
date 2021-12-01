Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F482465693
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245559AbhLATkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:40:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48274 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245441AbhLATkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:40:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F25FCCE20DA;
        Wed,  1 Dec 2021 19:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CFAC53FD0;
        Wed,  1 Dec 2021 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638387413;
        bh=H93UP1EhCP/+BuZSNeDhXJTCc6ecyWHwIU4Bl1NSeEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZh0bRpLzkHUSSr9BM5m4SA//rSHMQd+5aB+2yFKKvTb0XAA2qaWhmAkHr9AbBDTB
         cQfGNLZVw34mYN+jTI9wfYsH0wDmHgNf+Rgj7ftpH05+4yXgdbNgnh0XSfUIzUWihv
         v5SsJv/DzdB5wTUDm3efVcAUZmrQIVmgWv5vCAhrCVll/vq83xjE/a2VdiAU9yrWQO
         40E++DqQDs6XU8RraWvdc/B0Rh3vG10ipHIrAnqWFGBkC45qbgWp+LHNGuxd+xobid
         naSMjjR0xv92EmiTPDdG95iwKNj+jgdv1TV+k/PeFwdbnmzr1wxiWKa+oK+/MCEMLv
         qg8Ol5RDyu2Ug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 4/4] RDMA/mlx5: Add support to multiple priorities for FDB rules
Date:   Wed,  1 Dec 2021 11:36:21 -0800
Message-Id: <20211201193621.9129-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201193621.9129-1-saeed@kernel.org>
References: <20211201193621.9129-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Currently, the driver ignores the user's priority for flow steering
rules in FDB namespace. Change it and create the rule in the right
priority.
It will allow to create FDB steering rules in up to 16 different
priorities.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c      | 4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 510ef85ef6e4..661ed2b44508 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1517,7 +1517,7 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 					       reformat_l3_tunnel_to_l2) &&
 		    esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
-		priority = FDB_BYPASS_PATH;
+		priority = fs_matcher->priority;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX:
 		max_table_size = BIT(
@@ -1547,7 +1547,7 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 		prio = &dev->flow_db->egress_prios[priority];
 		break;
 	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
-		prio = &dev->flow_db->fdb;
+		prio = &dev->flow_db->fdb[priority];
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX:
 		prio = &dev->flow_db->rdma_rx[priority];
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e636e954f6bf..e3c33be9c5a0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -232,6 +232,7 @@ enum {
 #define MLX5_IB_NUM_FLOW_FT		(MLX5_IB_FLOW_LEFTOVERS_PRIO + 1)
 #define MLX5_IB_NUM_SNIFFER_FTS		2
 #define MLX5_IB_NUM_EGRESS_FTS		1
+#define MLX5_IB_NUM_FDB_FTS		MLX5_BY_PASS_NUM_REGULAR_PRIOS
 struct mlx5_ib_flow_prio {
 	struct mlx5_flow_table		*flow_table;
 	unsigned int			refcount;
@@ -276,7 +277,7 @@ struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	egress_prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	sniffer[MLX5_IB_NUM_SNIFFER_FTS];
 	struct mlx5_ib_flow_prio	egress[MLX5_IB_NUM_EGRESS_FTS];
-	struct mlx5_ib_flow_prio	fdb;
+	struct mlx5_ib_flow_prio	fdb[MLX5_IB_NUM_FDB_FTS];
 	struct mlx5_ib_flow_prio	rdma_rx[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	rdma_tx[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	opfcs[MLX5_IB_OPCOUNTER_MAX];
-- 
2.31.1

