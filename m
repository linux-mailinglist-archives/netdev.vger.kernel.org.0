Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F186A5ADEE5
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiIFFWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbiIFFVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CB66D566
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74894612D3
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD13C433D7;
        Tue,  6 Sep 2022 05:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441709;
        bh=z+r1InEaExRnOyvmBIqz4YQBQx+DwtkPtPXZ+glj8Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVgL/Hj5wbFXwnCnhM8fDoODcA/UH/1YeTjUhpe9hOdcJ65NSTl5GlVPjzO+/v+DU
         yCfR2g+vBMzvi6ELGzVs/sA1ejE2g/k1RZEL1fBqRwdqHM6WOciruRB2ZMelxuTrhg
         QrsEkqK9r4orykqrK3Jcl6VtWGOSrL3p0wjeC2zwZVsp3y8FGVeuNo2g/eSq0eP10w
         acq/feeLsRSaNT2FPKuE3uBS+OYwgpj0d9ogEb41AU2dBShSjJIVkRxgfdzWfLUpMf
         NcP6V62yqdek2th5HDXhKFwxrr16gKsRZnUfc0NYs/YPSDtIYfmP1xwVmNDHy8/uie
         l+2Dg/klEfHxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 12/17] net/mlx5: Add MACsec Rx tables support to fs_core
Date:   Mon,  5 Sep 2022 22:21:24 -0700
Message-Id: <20220906052129.104507-13-saeed@kernel.org>
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

Add new namespace for MACsec RX flows.
Encrypted MACsec packets should be first decrypted and stripped
from MACsec header and then continues with the kernel's steering
pipeline.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 13 +++++++++++--
 include/linux/mlx5/fs.h                           |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index c97aeccc6c2e..32d4c967469c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -922,6 +922,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		max_actions = MLX5_CAP_ESW_FLOWTABLE_FDB(dev, max_modify_header_actions);
 		table_type = FS_FT_FDB;
 		break;
+	case MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC:
 	case MLX5_FLOW_NAMESPACE_KERNEL:
 	case MLX5_FLOW_NAMESPACE_BYPASS:
 		max_actions = MLX5_CAP_FLOWTABLE_NIC_RX(dev, max_modify_header_actions);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 6a6031d9181c..d53749248fa0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -104,6 +104,10 @@
 #define BY_PASS_MIN_LEVEL (ETHTOOL_MIN_LEVEL + MLX5_BY_PASS_NUM_PRIOS +\
 			   LEFTOVERS_NUM_PRIOS)
 
+#define KERNEL_RX_MACSEC_NUM_PRIOS  1
+#define KERNEL_RX_MACSEC_NUM_LEVELS 2
+#define KERNEL_RX_MACSEC_MIN_LEVEL (BY_PASS_MIN_LEVEL + KERNEL_RX_MACSEC_NUM_PRIOS)
+
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
@@ -126,7 +130,7 @@
 
 #define LAG_PRIO_NUM_LEVELS 1
 #define LAG_NUM_PRIOS 1
-#define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + 1)
+#define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + KERNEL_RX_MACSEC_MIN_LEVEL + 1)
 
 #define KERNEL_TX_IPSEC_NUM_PRIOS  1
 #define KERNEL_TX_IPSEC_NUM_LEVELS 1
@@ -153,12 +157,16 @@ static struct init_tree_node {
 	enum mlx5_flow_table_miss_action def_miss_action;
 } root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 7,
+	.ar_size = 8,
 	  .children = (struct init_tree_node[]){
 		  ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
 						    BY_PASS_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, KERNEL_RX_MACSEC_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(KERNEL_RX_MACSEC_NUM_PRIOS,
+						    KERNEL_RX_MACSEC_NUM_LEVELS))),
 		  ADD_PRIO(0, LAG_MIN_LEVEL, 0, FS_CHAINING_CAPS,
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(LAG_NUM_PRIOS,
@@ -2278,6 +2286,7 @@ static bool is_nic_rx_ns(enum mlx5_flow_namespace_type type)
 {
 	switch (type) {
 	case MLX5_FLOW_NAMESPACE_BYPASS:
+	case MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC:
 	case MLX5_FLOW_NAMESPACE_LAG:
 	case MLX5_FLOW_NAMESPACE_OFFLOADS:
 	case MLX5_FLOW_NAMESPACE_ETHTOOL:
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 53d186774206..c7a91981cd5a 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -79,6 +79,7 @@ static inline void build_leftovers_ft_param(int *priority,
 
 enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_BYPASS,
+	MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC,
 	MLX5_FLOW_NAMESPACE_LAG,
 	MLX5_FLOW_NAMESPACE_OFFLOADS,
 	MLX5_FLOW_NAMESPACE_ETHTOOL,
-- 
2.37.2

