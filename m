Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443A2573FD7
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGMW7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiGMW7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED412A949
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3153361A94
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECD3C341C0;
        Wed, 13 Jul 2022 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753157;
        bh=9JlRPqd5+w5SFFXk+QZSDz5e+A3sUg7YOWExZ5n49uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADyjxvjM9cp/AMLLj+FiL4RJeGKU0VLO8nSNrwq+wO+uAZr1hpOmaINMOgRTU6t+U
         iXBh2BViHnxig84tirOMeIXGa2rOyEeir/3S+aCrvcjqngsbG3EDXZbg9cocsUmx5F
         ZvmpWJlplEqr57Kog0oq4SuNd7aTvvrzWKyiWUmp6ilwoIpWlqACUG87GESkpMclL9
         WdYPki+DuMJoSqzUW7JAPB2z9VqjWgWvPWLIJYjILIcWlv/EUmH0E98zBR9XnCcfp0
         fycZ7YpzDvX9VRdFo5h+uBvRHpSoF3EvWdiSZonK3aqYZOowKsOz8dOU2dfgK3q30b
         5MhuOcEA4zXgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Bridge, refactor groups sizes and indices
Date:   Wed, 13 Jul 2022 15:58:50 -0700
Message-Id: <20220713225859.401241-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in the series introduce additional flow groups for QinQ
support. With increased number of groups it becomes cumbersome to calculate
groups sizes as fractions of the table size. Instead, manually define sizes
of specific group types and ensure that totals are still correct by static
assertions. Having specific table size is important for firmware resource
management.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 41 +++++++++++++------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 05e08cec5a8c..6547b848242a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2021 Mellanox Technologies. */
 
+#include <linux/build_bug.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <net/netevent.h>
@@ -12,26 +13,42 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE 64000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 16000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 32000
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 4 - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM \
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM	\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO \
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 2 - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM \
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE - 1)
-
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE 64000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
+
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 32000
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (32000 - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE / 2 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 2)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO	\
+	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 64000);
 
 #define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
 
-- 
2.36.1

