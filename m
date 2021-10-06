Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC35423AEC
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbhJFJyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhJFJyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5846109F;
        Wed,  6 Oct 2021 09:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513945;
        bh=C6BeAsiA/whKNVYrKUmXPgAJU+q5ch0jp3kBDCcwOZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5LdAKaQe4Phh+ObKCXeBgi71DfKAFVt6SXQTz2wdgnsWCqPOUKFn5aMOl7bSNIvM
         H5/RE3kRFqoMysT8pS4hmOjVQoq2PLOSz0GZNTaLBFoiWJBGTOkoMDfcyXZM6OuEFJ
         CS/v2moPIokfwOaufREzjcP9vJX5UeFGMgWoOSO5l+7O9harV5KqIQNGSJ/UhXYTkq
         BqWYP7KRIOj14zQkb7vp9UBt+CHAcYEenFiP92QBdBKVbrSbZacS5gHVA9r9Kdf3jL
         RkEpwc8StPxmhYpW31O/C/adSgtcTIYkw1AyElMKFzAL2dxAdhYWorSDzY3jHS5zmK
         14045nZkOo2Bw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH mlx5-next v3 02/13] net/mlx5: Add priorities for counters in RDMA namespaces
Date:   Wed,  6 Oct 2021 12:52:05 +0300
Message-Id: <877eea45f45539e5c63d05fc4697a5a20cf4f482.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633513239.git.leonro@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add additional flow steering priorities in the RDMA namespace.
This allows adding flow counters to count filtered RDMA traffic and then
continue processing in the regular RDMA steering flow.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 54 ++++++++++++++++---
 include/linux/mlx5/device.h                   |  2 +
 include/linux/mlx5/fs.h                       |  2 +
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe501ba88bea..71a08f84d49d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -99,6 +99,9 @@
 #define LEFTOVERS_NUM_LEVELS 1
 #define LEFTOVERS_NUM_PRIOS 1
 
+#define RDMA_RX_COUNTERS_PRIO_NUM_LEVELS 1
+#define RDMA_TX_COUNTERS_PRIO_NUM_LEVELS 1
+
 #define BY_PASS_PRIO_NUM_LEVELS 1
 #define BY_PASS_MIN_LEVEL (ETHTOOL_MIN_LEVEL + MLX5_BY_PASS_NUM_PRIOS +\
 			   LEFTOVERS_NUM_PRIOS)
@@ -206,34 +209,63 @@ static struct init_tree_node egress_root_fs = {
 	}
 };
 
-#define RDMA_RX_BYPASS_PRIO 0
-#define RDMA_RX_KERNEL_PRIO 1
+enum {
+	RDMA_RX_COUNTERS_PRIO,
+	RDMA_RX_BYPASS_PRIO,
+	RDMA_RX_KERNEL_PRIO,
+};
+
+#define RDMA_RX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_REGULAR_PRIOS
+#define RDMA_RX_KERNEL_MIN_LEVEL (RDMA_RX_BYPASS_MIN_LEVEL + 1)
+#define RDMA_RX_COUNTERS_MIN_LEVEL (RDMA_RX_KERNEL_MIN_LEVEL + 2)
+
 static struct init_tree_node rdma_rx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
+		[RDMA_RX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_RX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_RX_NUM_COUNTERS_PRIOS,
+						  RDMA_RX_COUNTERS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_BYPASS_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS, 0,
+		ADD_PRIO(0, RDMA_RX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_REGULAR_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_KERNEL_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS + 1, 0,
+		ADD_PRIO(0, RDMA_RX_KERNEL_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN,
 				ADD_MULTIPLE_PRIO(1, 1))),
 	}
 };
 
+enum {
+	RDMA_TX_COUNTERS_PRIO,
+	RDMA_TX_BYPASS_PRIO,
+};
+
+#define RDMA_TX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_PRIOS
+#define RDMA_TX_COUNTERS_MIN_LEVEL (RDMA_TX_BYPASS_MIN_LEVEL + 1)
+
 static struct init_tree_node rdma_tx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 1,
+	.ar_size = 2,
 	.children = (struct init_tree_node[]) {
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+		[RDMA_TX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_TX_NUM_COUNTERS_PRIOS,
+						  RDMA_TX_COUNTERS_PRIO_NUM_LEVELS))),
+		[RDMA_TX_BYPASS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_RDMA_TX,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
-				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+				ADD_MULTIPLE_PRIO(RDMA_TX_BYPASS_MIN_LEVEL,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 	}
 };
@@ -2215,6 +2247,12 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		prio = RDMA_RX_KERNEL_PRIO;
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
 		root_ns = steering->rdma_tx_root_ns;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_COUNTERS_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_COUNTERS_PRIO;
 	} else { /* Must be NIC RX */
 		root_ns = steering->root_ns;
 		prio = type;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 66eaf0aa7f69..ed0230ff9422 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1456,6 +1456,8 @@ static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
 	return MLX5_MIN_PKEY_TABLE_SIZE << pkey_sz;
 }
 
+#define MLX5_RDMA_RX_NUM_COUNTERS_PRIOS 2
+#define MLX5_RDMA_TX_NUM_COUNTERS_PRIOS 1
 #define MLX5_BY_PASS_NUM_REGULAR_PRIOS 16
 #define MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS 16
 #define MLX5_BY_PASS_NUM_MULTICAST_PRIOS 1
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 0106c67e8ccb..f2c3da2006d9 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -83,6 +83,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
 };
 
 enum {
-- 
2.31.1

