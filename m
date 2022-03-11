Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B184D5C9E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347260AbiCKHl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242370AbiCKHlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5551B7603
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B0E4B82AE1
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8644EC340F4;
        Fri, 11 Mar 2022 07:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984447;
        bh=FBg5X4iaEIhM8hSTT5JCdm4lstN91ttAlwN8ADvuarA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUGzKA517+bMtS9e0RfPU17PlzEgsBXBeqI/20pQv4Otay9ddlTrBKTBiSYqBe3iJ
         73RMTMEqww4VBN3Z1ud5rgcU5zGaL++wR8CmiYks5ZRzjBeJBsNCIUZLcpf99JQ3Ly
         9R1tRiuysolIoTgEgyMvX8skLHkLGqmnTwbDZZxa8rM/bVKFGJWD6JBA6OAT+kJvbq
         zAGa4cu8c4zEpl7IK7fx95qxQ6WyLLl7XO8YS0fC6JUeExW9KG2U+TACkxJ3flUZiw
         gX3qa6fvHCo8c8SOFN6ZaoLvZM/yiLrGklvutk0gotQIqbkFnuJRZo9YYCWFN0pITb
         lnxqpxFkXznoA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Add smfs lib to export direct steering API to CT
Date:   Thu, 10 Mar 2022 23:40:26 -0800
Message-Id: <20220311074031.645168-11-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Add a thin layer that exports selected direct steering (dr) API
which will be used by a ct fs implementation in a following
patch.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/smfs.c    | 68 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/smfs.h    | 36 ++++++++++
 3 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 24cf559811b0..f68a9db18698 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -106,7 +106,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste_v2.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o \
-					steering/dr_dbg.o
+					steering/dr_dbg.o lib/smfs.o
 #
 # SF device
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c
new file mode 100644
index 000000000000..9b8c051ccf65
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#include <linux/kernel.h>
+#include <linux/mlx5/driver.h>
+
+#include "smfs.h"
+
+struct mlx5dr_matcher *
+mlx5_smfs_matcher_create(struct mlx5dr_table *table, u32 priority, struct mlx5_flow_spec *spec)
+{
+	struct mlx5dr_match_parameters matcher_mask = {};
+
+	matcher_mask.match_buf = (u64 *)&spec->match_criteria;
+	matcher_mask.match_sz = DR_SZ_MATCH_PARAM;
+
+	return mlx5dr_matcher_create(table, priority, spec->match_criteria_enable, &matcher_mask);
+}
+
+void
+mlx5_smfs_matcher_destroy(struct mlx5dr_matcher *matcher)
+{
+	mlx5dr_matcher_destroy(matcher);
+}
+
+struct mlx5dr_table *
+mlx5_smfs_table_get_from_fs_ft(struct mlx5_flow_table *ft)
+{
+	return mlx5dr_table_get_from_fs_ft(ft);
+}
+
+struct mlx5dr_action *
+mlx5_smfs_action_create_dest_table(struct mlx5dr_table *table)
+{
+	return mlx5dr_action_create_dest_table(table);
+}
+
+struct mlx5dr_action *
+mlx5_smfs_action_create_flow_counter(u32 counter_id)
+{
+	return mlx5dr_action_create_flow_counter(counter_id);
+}
+
+void
+mlx5_smfs_action_destroy(struct mlx5dr_action *action)
+{
+	mlx5dr_action_destroy(action);
+}
+
+struct mlx5dr_rule *
+mlx5_smfs_rule_create(struct mlx5dr_matcher *matcher, struct mlx5_flow_spec *spec,
+		      size_t num_actions, struct mlx5dr_action *actions[],
+		      u32 flow_source)
+{
+	struct mlx5dr_match_parameters value = {};
+
+	value.match_buf = (u64 *)spec->match_value;
+	value.match_sz = DR_SZ_MATCH_PARAM;
+
+	return mlx5dr_rule_create(matcher, &value, num_actions, actions, flow_source);
+}
+
+void
+mlx5_smfs_rule_destroy(struct mlx5dr_rule *rule)
+{
+	mlx5dr_rule_destroy(rule);
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h
new file mode 100644
index 000000000000..452d0df339ac
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. */
+
+#ifndef __MLX5_LIB_SMFS_H__
+#define __MLX5_LIB_SMFS_H__
+
+#include "steering/mlx5dr.h"
+#include "steering/dr_types.h"
+
+struct mlx5dr_matcher *
+mlx5_smfs_matcher_create(struct mlx5dr_table *table, u32 priority, struct mlx5_flow_spec *spec);
+
+void
+mlx5_smfs_matcher_destroy(struct mlx5dr_matcher *matcher);
+
+struct mlx5dr_table *
+mlx5_smfs_table_get_from_fs_ft(struct mlx5_flow_table *ft);
+
+struct mlx5dr_action *
+mlx5_smfs_action_create_dest_table(struct mlx5dr_table *table);
+
+struct mlx5dr_action *
+mlx5_smfs_action_create_flow_counter(u32 counter_id);
+
+void
+mlx5_smfs_action_destroy(struct mlx5dr_action *action);
+
+struct mlx5dr_rule *
+mlx5_smfs_rule_create(struct mlx5dr_matcher *matcher, struct mlx5_flow_spec *spec,
+		      size_t num_actions, struct mlx5dr_action *actions[],
+		      u32 flow_source);
+
+void
+mlx5_smfs_rule_destroy(struct mlx5dr_rule *rule);
+
+#endif /* __MLX5_LIB_SMFS_H__ */
-- 
2.35.1

