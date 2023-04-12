Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32D96DEA25
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDLEIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDLEIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085EF1989
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9691D62DA3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B41C433D2;
        Wed, 12 Apr 2023 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272483;
        bh=csUG3zbgP+X2HwnvUh5CIf0AIiaNokFbFiRXG9DA7vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvoXSt5gOlFSEcUFlulNDA1nDxzsw9+d9DkoPDHDII7Dq/YR/qVP8U3eF71v3Zo3B
         9nM+pCTitfUZ7sstSIZL6ST9gJWcCeMmGuaPcMxXtDMY9RA0sFAyVx9x7HLOia/NNQ
         5xYQOiLAbQS8XU7OT4FqlGr/ez4zH8IP/CFmvnEMPG1xnoNHSgKCeK8lEV53ingpAt
         Ygou4GgV1Gc0DqURrJ+sVI1cVKLetg1eA/l++4Rk9yDu5HZyPm7D4Xn5rLtdYN01hE
         mul3qshAWPCvLK8EzOXjEMXhyFxCODIVlHlpN4e+VTHqfaiCFIu6JE6b4gAPjMME73
         iFuHPpE2SsKxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Bridge, move additional data structures to priv header
Date:   Tue, 11 Apr 2023 21:07:40 -0700
Message-Id: <20230412040752.14220-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series will require accessing flow tables and groups
sizes, table levels and struct mlx5_esw_bridge from new the new source file
dedicated to multicast code. Expose these data in bridge_priv.h to reduce
clutter in following patches that will implement the actual functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 85 -------------------
 .../mellanox/mlx5/core/esw/bridge_priv.h      | 85 +++++++++++++++++++
 2 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index e45f9bb80535..ec052fff7712 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -13,66 +13,6 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM	\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM +	\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
-
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM		\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO	\
-	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
-
-#define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
-
-enum {
-	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
-	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
-	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
-};
-
 static const struct rhashtable_params fdb_ht_params = {
 	.key_offset = offsetof(struct mlx5_esw_bridge_fdb_entry, key),
 	.key_len = sizeof(struct mlx5_esw_bridge_fdb_key),
@@ -80,31 +20,6 @@ static const struct rhashtable_params fdb_ht_params = {
 	.automatic_shrinking = true,
 };
 
-enum {
-	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
-};
-
-struct mlx5_esw_bridge {
-	int ifindex;
-	int refcnt;
-	struct list_head list;
-	struct mlx5_esw_bridge_offloads *br_offloads;
-
-	struct list_head fdb_list;
-	struct rhashtable fdb_ht;
-
-	struct mlx5_flow_table *egress_ft;
-	struct mlx5_flow_group *egress_vlan_fg;
-	struct mlx5_flow_group *egress_qinq_fg;
-	struct mlx5_flow_group *egress_mac_fg;
-	struct mlx5_flow_group *egress_miss_fg;
-	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
-	struct mlx5_flow_handle *egress_miss_handle;
-	unsigned long ageing_time;
-	u32 flags;
-	u16 vlan_proto;
-};
-
 static void
 mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *addr, u16 vid,
 				   unsigned long val)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 878311fe950a..b99761e73c1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -12,6 +12,70 @@
 #include <linux/xarray.h>
 #include "fs_core.h"
 
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
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
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
+
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM		\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO	\
+	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
+
+#define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
+
+enum {
+	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
+};
+
+enum {
+	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
+};
+
 struct mlx5_esw_bridge_fdb_key {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
@@ -60,4 +124,25 @@ struct mlx5_esw_bridge_port {
 	struct xarray vlans;
 };
 
+struct mlx5_esw_bridge {
+	int ifindex;
+	int refcnt;
+	struct list_head list;
+	struct mlx5_esw_bridge_offloads *br_offloads;
+
+	struct list_head fdb_list;
+	struct rhashtable fdb_ht;
+
+	struct mlx5_flow_table *egress_ft;
+	struct mlx5_flow_group *egress_vlan_fg;
+	struct mlx5_flow_group *egress_qinq_fg;
+	struct mlx5_flow_group *egress_mac_fg;
+	struct mlx5_flow_group *egress_miss_fg;
+	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
+	struct mlx5_flow_handle *egress_miss_handle;
+	unsigned long ageing_time;
+	u32 flags;
+	u16 vlan_proto;
+};
+
 #endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
-- 
2.39.2

