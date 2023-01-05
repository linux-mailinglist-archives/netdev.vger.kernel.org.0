Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6AD65E49E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjAEETB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjAEESf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB163F113;
        Wed,  4 Jan 2023 20:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18330617F7;
        Thu,  5 Jan 2023 04:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68803C433EF;
        Thu,  5 Jan 2023 04:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892299;
        bh=q2zkceXrjXWDwkPWHMLu3YFFKMk/Dbz2bd1QIVGX7pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYkkyfk4h/QNA20It7XCCLoJnfeRtYA9FwoHr3ic3E7lGwrWJq3ThD+uEuYnWap2K
         ULk+z3I3FtKqsXojVP3zyqznzMAP65ZhFLlQeoYJz8epXAPo6Mz5af7+kc+JBSeT8N
         jxiLFUz4Yonk8+5PBuAD2sln6URze0O0rbKeQj6H218ecm/0GFbaSop1p+gvToI753
         y0Yf5rtQ1p563wEvg0oeHR+ulpEL3Pa8uDHfRXchAvyMaBgC3j2Msm5b0de7bBJO+4
         o3hWTnIpXrDBTpfaW2Kxn96NhvSsaFq8PJr72t2qNZvBiFK03BhPxlBBWXpNKkRuil
         FxSXHk/jivY5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH mlx5-next 6/8] net/mlx5: Add IPSec priorities in RDMA namespaces
Date:   Wed,  4 Jan 2023 20:17:54 -0800
Message-Id: <20230105041756.677120-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Add IPSec flow steering priorities in RDMA namespaces. This allows
adding tables/rules to forward RoCEv2 traffic to the IPSec crypto
tables in NIC_TX domain, and accept RoCEv2 traffic from NIC_RX domain.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 35 +++++++++++++++++--
 include/linux/mlx5/fs.h                       |  2 ++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2333f835fb70..eac9fd35129d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -219,19 +219,30 @@ static struct init_tree_node egress_root_fs = {
 };
 
 enum {
+	RDMA_RX_IPSEC_PRIO,
 	RDMA_RX_COUNTERS_PRIO,
 	RDMA_RX_BYPASS_PRIO,
 	RDMA_RX_KERNEL_PRIO,
 };
 
+#define RDMA_RX_IPSEC_NUM_PRIOS 1
+#define RDMA_RX_IPSEC_NUM_LEVELS 2
+#define RDMA_RX_IPSEC_MIN_LEVEL  (RDMA_RX_IPSEC_NUM_LEVELS)
+
 #define RDMA_RX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_REGULAR_PRIOS
 #define RDMA_RX_KERNEL_MIN_LEVEL (RDMA_RX_BYPASS_MIN_LEVEL + 1)
 #define RDMA_RX_COUNTERS_MIN_LEVEL (RDMA_RX_KERNEL_MIN_LEVEL + 2)
 
 static struct init_tree_node rdma_rx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 3,
+	.ar_size = 4,
 	.children = (struct init_tree_node[]) {
+		[RDMA_RX_IPSEC_PRIO] =
+		ADD_PRIO(0, RDMA_RX_IPSEC_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(RDMA_RX_IPSEC_NUM_PRIOS,
+						  RDMA_RX_IPSEC_NUM_LEVELS))),
 		[RDMA_RX_COUNTERS_PRIO] =
 		ADD_PRIO(0, RDMA_RX_COUNTERS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
@@ -254,15 +265,20 @@ static struct init_tree_node rdma_rx_root_fs = {
 
 enum {
 	RDMA_TX_COUNTERS_PRIO,
+	RDMA_TX_IPSEC_PRIO,
 	RDMA_TX_BYPASS_PRIO,
 };
 
 #define RDMA_TX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_PRIOS
 #define RDMA_TX_COUNTERS_MIN_LEVEL (RDMA_TX_BYPASS_MIN_LEVEL + 1)
 
+#define RDMA_TX_IPSEC_NUM_PRIOS 1
+#define RDMA_TX_IPSEC_PRIO_NUM_LEVELS 1
+#define RDMA_TX_IPSEC_MIN_LEVEL  (RDMA_TX_COUNTERS_MIN_LEVEL + RDMA_TX_IPSEC_NUM_PRIOS)
+
 static struct init_tree_node rdma_tx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
 		[RDMA_TX_COUNTERS_PRIO] =
 		ADD_PRIO(0, RDMA_TX_COUNTERS_MIN_LEVEL, 0,
@@ -270,6 +286,13 @@ static struct init_tree_node rdma_tx_root_fs = {
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_RDMA_TX_NUM_COUNTERS_PRIOS,
 						  RDMA_TX_COUNTERS_PRIO_NUM_LEVELS))),
+		[RDMA_TX_IPSEC_PRIO] =
+		ADD_PRIO(0, RDMA_TX_IPSEC_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(RDMA_TX_IPSEC_NUM_PRIOS,
+						  RDMA_TX_IPSEC_PRIO_NUM_LEVELS))),
+
 		[RDMA_TX_BYPASS_PRIO] =
 		ADD_PRIO(0, RDMA_TX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_RDMA_TX,
@@ -2368,6 +2391,14 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		root_ns = steering->rdma_tx_root_ns;
 		prio = RDMA_TX_COUNTERS_PRIO;
 		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC:
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_IPSEC_PRIO;
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC:
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_IPSEC_PRIO;
+		break;
 	default: /* Must be NIC RX */
 		WARN_ON(!is_nic_rx_ns(type));
 		root_ns = steering->root_ns;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 1d2a0638ae74..d72a09a3798c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -103,6 +103,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_PORT_SEL,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
 	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC,
 };
 
 enum {
-- 
2.38.1

