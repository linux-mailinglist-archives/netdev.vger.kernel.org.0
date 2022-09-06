Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23DB5ADEE9
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiIFFV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiIFFVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064E46CF7E
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B46B8161D
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51189C433B5;
        Tue,  6 Sep 2022 05:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441706;
        bh=sRoNavNUvO5sPI3w3jIbMCWjHpQJQ0Xc1tttrys6Yzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpUWojXCQuy+5xaYMnXF5Is/s5gqsc2YWyBTJVxpM2hBtowH/Y2V1O8v4m7rSPzZv
         EiSEBYJm9l/Zbo9Jm5fZZ9VpIKauCd4Gw5CZPotHXAszBS5vV66DO4mtZTMr2/rVau
         KiEAxXfqElOH8TZ/n6Vx6bqGEtBr3e1BHQKkio09Xpuf9bNAu5y2gdu4yBoSa+Y9kK
         DNFP/EqQ9RjLBa/I+NNs/7Oh15cdt52tzoaw9GC4m31OSFU3T357BUzHI+qtyQTSFD
         ZqXw99Zsw8F7Axw9AJWloTCXFLY4EgrZGCphI9XyjoSYgW7sqquE0h0Xv9d6ZDJb8q
         sM754yKG7uxbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 08/17] net/mlx5: Add MACsec Tx tables support to fs_core
Date:   Mon,  5 Sep 2022 22:21:20 -0700
Message-Id: <20220906052129.104507-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Changed EGRESS_KERNEL namespace to EGRESS_IPSEC and add new
namespace for MACsec TX.
This namespace should be the last namespace for transmitted packets.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c  | 18 ++++++++++++++----
 include/linux/mlx5/fs.h                        |  3 ++-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 976f5669b6e5..b859e4a4c744 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -577,7 +577,7 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	int err = -ENOMEM;
 
 	ns = mlx5_get_flow_namespace(ipsec->mdev,
-				     MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
+				     MLX5_FLOW_NAMESPACE_EGRESS_IPSEC);
 	if (!ns)
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index ff5d23f0e4b1..c97aeccc6c2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -928,7 +928,8 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		table_type = FS_FT_NIC_RX;
 		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
-	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
+	case MLX5_FLOW_NAMESPACE_EGRESS_IPSEC:
+	case MLX5_FLOW_NAMESPACE_EGRESS_MACSEC:
 		max_actions = MLX5_CAP_FLOWTABLE_NIC_TX(dev, max_modify_header_actions);
 		table_type = FS_FT_NIC_TX;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index e3960cdf5131..6a6031d9181c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -130,7 +130,11 @@
 
 #define KERNEL_TX_IPSEC_NUM_PRIOS  1
 #define KERNEL_TX_IPSEC_NUM_LEVELS 1
-#define KERNEL_TX_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
+#define KERNEL_TX_IPSEC_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
+
+#define KERNEL_TX_MACSEC_NUM_PRIOS  1
+#define KERNEL_TX_MACSEC_NUM_LEVELS 2
+#define KERNEL_TX_MACSEC_MIN_LEVEL       (KERNEL_TX_IPSEC_MIN_LEVEL + KERNEL_TX_MACSEC_NUM_PRIOS)
 
 struct node_caps {
 	size_t	arr_sz;
@@ -186,18 +190,23 @@ static struct init_tree_node {
 
 static struct init_tree_node egress_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
 		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
 			 FS_CHAINING_CAPS_EGRESS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
-		ADD_PRIO(0, KERNEL_TX_MIN_LEVEL, 0,
+		ADD_PRIO(0, KERNEL_TX_IPSEC_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_EGRESS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(KERNEL_TX_IPSEC_NUM_PRIOS,
 						  KERNEL_TX_IPSEC_NUM_LEVELS))),
+		ADD_PRIO(0, KERNEL_TX_MACSEC_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS_EGRESS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(KERNEL_TX_MACSEC_NUM_PRIOS,
+						  KERNEL_TX_MACSEC_NUM_LEVELS))),
 	}
 };
 
@@ -2315,7 +2324,8 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		prio =  FDB_BYPASS_PATH;
 		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
-	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
+	case MLX5_FLOW_NAMESPACE_EGRESS_IPSEC:
+	case MLX5_FLOW_NAMESPACE_EGRESS_MACSEC:
 		root_ns = steering->egress_root_ns;
 		prio = type - MLX5_FLOW_NAMESPACE_EGRESS;
 		break;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index e62d50acb6bd..53d186774206 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -92,7 +92,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_SNIFFER_RX,
 	MLX5_FLOW_NAMESPACE_SNIFFER_TX,
 	MLX5_FLOW_NAMESPACE_EGRESS,
-	MLX5_FLOW_NAMESPACE_EGRESS_KERNEL,
+	MLX5_FLOW_NAMESPACE_EGRESS_IPSEC,
+	MLX5_FLOW_NAMESPACE_EGRESS_MACSEC,
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
-- 
2.37.2

