Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BF359D0D9
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiHWF4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiHWFzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50B5F213
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5FE7B81B79
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72908C433D7;
        Tue, 23 Aug 2022 05:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234150;
        bh=bCLApmqF0ecqn++O3wfE1xxEutEK/Y72IjXWWe4CmwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBRcGW4qBXs+7JctKXt8kMcCfsZowTdTm6vr+jSMYc0O/HqtvUubhdxmDChCRPYNo
         UVLA/7wfWmAvvDVgIszrM/eZs84kqscbwGdLFNOoIIOkPA7zodgwqWLo9zJrZu3Hvi
         qJeP/DnvmAUyllOGxxZH2sS+Tu8QqpFfJsbfYnSOA5Vzt7Gk35N/VwfMdhPsvq+wMW
         3/qBqEFH9oVODBcbIOry6r8aSBHjhS1jxCfgJMWO8Oyfwo22aqi8fDDmiJP01ws8Fj
         zTBpyNVO7ZCzZJY0KD8d/YvKKhHuLNUKP59KKZ07hEnfFvBE413d9UkbO+6IQl7Aoi
         3QmlzqqkZsM3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Separate ethtool_steering from fs.h and make private
Date:   Mon, 22 Aug 2022 22:55:25 -0700
Message-Id: <20220823055533.334471-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
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

From: Lama Kayal <lkayal@nvidia.com>

Create a new fs_ethtool.h header file, where ethtool steering init and
cleanup functions are declared in it.
Make mlx5e_ethtool_steering struct private and declare at en_fs_ethtool.c.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 32 -------------------
 .../mellanox/mlx5/core/en/fs_ethtool.h        | 29 +++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  9 ++----
 .../mellanox/mlx5/core/en_fs_ethtool.c        | 29 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  1 +
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  1 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  1 +
 8 files changed, 65 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 20ca670fc226..6d26a5415afc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -92,38 +92,6 @@ enum {
 struct mlx5e_flow_steering;
 struct mlx5e_priv;
 
-#ifdef CONFIG_MLX5_EN_RXNFC
-
-struct mlx5e_ethtool_table {
-	struct mlx5_flow_table *ft;
-	int                    num_rules;
-};
-
-#define ETHTOOL_NUM_L3_L4_FTS 7
-#define ETHTOOL_NUM_L2_FTS 4
-
-struct mlx5e_ethtool_steering {
-	struct mlx5e_ethtool_table      l3_l4_ft[ETHTOOL_NUM_L3_L4_FTS];
-	struct mlx5e_ethtool_table      l2_ft[ETHTOOL_NUM_L2_FTS];
-	struct list_head                rules;
-	int                             tot_num_rules;
-};
-
-void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs);
-void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs);
-int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd);
-int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
-			    struct ethtool_rxnfc *info, u32 *rule_locs);
-#else
-static inline void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs) { }
-static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs) { }
-static inline int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
-{ return -EOPNOTSUPP; }
-static inline int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
-					  struct ethtool_rxnfc *info, u32 *rule_locs)
-{ return -EOPNOTSUPP; }
-#endif /* CONFIG_MLX5_EN_RXNFC */
-
 #ifdef CONFIG_MLX5_EN_ARFS
 struct mlx5e_arfs_tables;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h
new file mode 100644
index 000000000000..9e276fd3c0cf
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. */
+
+#ifndef __MLX5E_FS_ETHTOOL_H__
+#define __MLX5E_FS_ETHTOOL_H__
+
+struct mlx5e_priv;
+struct mlx5e_ethtool_steering;
+#ifdef CONFIG_MLX5_EN_RXNFC
+int mlx5e_ethtool_alloc(struct mlx5e_ethtool_steering **ethtool);
+void mlx5e_ethtool_free(struct mlx5e_ethtool_steering *ethtool);
+void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs);
+void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs);
+int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd);
+int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
+			    struct ethtool_rxnfc *info, u32 *rule_locs);
+#else
+static inline int mlx5e_ethtool_alloc(struct mlx5e_ethtool_steering **ethtool)
+{ return 0; }
+static inline void mlx5e_ethtool_free(struct mlx5e_ethtool_steering *ethtool) { }
+static inline void mlx5e_ethtool_init_steering(struct mlx5e_flow_steering *fs) { }
+static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs) { }
+static inline int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
+{ return -EOPNOTSUPP; }
+static inline int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
+					  struct ethtool_rxnfc *info, u32 *rule_locs)
+{ return -EOPNOTSUPP; }
+#endif
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index b811207fe5ed..551468dbc93f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -38,6 +38,7 @@
 #include "en/xsk/pool.h"
 #include "en/ptp.h"
 #include "lib/clock.h"
+#include "en/fs_ethtool.h"
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
 			       struct ethtool_drvinfo *drvinfo)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index dc73c0cfca6a..71d9eab49ec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -40,6 +40,7 @@
 #include "en_tc.h"
 #include "lib/mpfs.h"
 #include "en/ptp.h"
+#include "en/fs_ethtool.h"
 
 struct mlx5e_flow_steering {
 	struct work_struct		set_rx_mode_work;
@@ -1410,16 +1411,12 @@ struct mlx5e_tc_table *mlx5e_fs_get_tc(struct mlx5e_flow_steering *fs)
 #ifdef CONFIG_MLX5_EN_RXNFC
 static int mlx5e_fs_ethtool_alloc(struct mlx5e_flow_steering *fs)
 {
-	fs->ethtool = kvzalloc(sizeof(*fs->ethtool), GFP_KERNEL);
-
-	if (!fs->ethtool)
-		return -ENOMEM;
-	return 0;
+	return mlx5e_ethtool_alloc(&fs->ethtool);
 }
 
 static void mlx5e_fs_ethtool_free(struct mlx5e_flow_steering *fs)
 {
-	kvfree(fs->ethtool);
+	mlx5e_ethtool_free(fs->ethtool);
 }
 
 struct mlx5e_ethtool_steering *mlx5e_fs_get_ethtool(struct mlx5e_flow_steering *fs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 3abd3db72e07..2a67798cd446 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -34,6 +34,22 @@
 #include "en.h"
 #include "en/params.h"
 #include "en/xsk/pool.h"
+#include "en/fs_ethtool.h"
+
+struct mlx5e_ethtool_table {
+	struct mlx5_flow_table *ft;
+	int                    num_rules;
+};
+
+#define ETHTOOL_NUM_L3_L4_FTS 7
+#define ETHTOOL_NUM_L2_FTS 4
+
+struct mlx5e_ethtool_steering {
+	struct mlx5e_ethtool_table      l3_l4_ft[ETHTOOL_NUM_L3_L4_FTS];
+	struct mlx5e_ethtool_table      l2_ft[ETHTOOL_NUM_L2_FTS];
+	struct list_head                rules;
+	int                             tot_num_rules;
+};
 
 static int flow_type_to_traffic_type(u32 flow_type);
 
@@ -831,6 +847,19 @@ mlx5e_ethtool_get_all_flows(struct mlx5e_priv *priv,
 	return err;
 }
 
+int mlx5e_ethtool_alloc(struct mlx5e_ethtool_steering **ethtool)
+{
+	*ethtool =  kvzalloc(sizeof(**ethtool), GFP_KERNEL);
+	if (!*ethtool)
+		return -ENOMEM;
+	return 0;
+}
+
+void mlx5e_ethtool_free(struct mlx5e_ethtool_steering *ethtool)
+{
+	kvfree(ethtool);
+}
+
 void mlx5e_ethtool_cleanup_steering(struct mlx5e_flow_steering *fs)
 {
 	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a6b54adb377a..49a67fa5327c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -56,6 +56,7 @@
 #include "en_accel/ipsec.h"
 #include "en/tc/int_port.h"
 #include "en/ptp.h"
+#include "en/fs_ethtool.h"
 
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
 	max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index ac3757beaea2..645214e4302b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -32,6 +32,7 @@
 
 #include "en.h"
 #include "ipoib.h"
+#include "en/fs_ethtool.h"
 
 static void mlx5i_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *drvinfo)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1ce5ab9270f2..6a95566bf149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -35,6 +35,7 @@
 #include "en.h"
 #include "en/params.h"
 #include "ipoib.h"
+#include "en/fs_ethtool.h"
 
 #define IB_DEFAULT_Q_KEY   0xb1b
 #define MLX5I_PARAMS_DEFAULT_LOG_RQ_SIZE 9
-- 
2.37.1

