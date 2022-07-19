Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665D657A84C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbiGSUfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239576AbiGSUfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D785145074
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75278B81D1C
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299EFC341CA;
        Tue, 19 Jul 2022 20:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262937;
        bh=2rewzlkkqZlTAprRmze4ZIXe1fQcgNdl0cYCoEnsOTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9/5r5uAPR5BaheatW+2psZc1VKRuoxtnWHJtX03Zje64ezrQBH30+UBcTOxC2uzj
         UapUs53RbepMBwSiHHWOAza9IaWyHexWmrvynaNXIu7r8uty9OlPiUNPInGicuoKV9
         IsmH/q+W2BOtKCNrKH5ULIkouzGRydl2/eISwZ3Cor9OSeql37LOWEodljE3XSoOZV
         +v3z2wv5N7YhIZ/FL7FlTcdrr/Acb4oyHwdNYEup4IbuacWmNywLaO+fNzQ0u3nlCc
         LDZoe2eLCYzR7RRWe8ek34ckt6LgtYKY8ak54cyK+c88qNgAtEbVvYvRwsU4QFLm0A
         hCRsixMfNX/iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next V2 03/13] net/mlx5e: HTB, reduce visibility of htb functions
Date:   Tue, 19 Jul 2022 13:35:19 -0700
Message-Id: <20220719203529.51151-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

No need to expose all htb tc functions to the main driver file,
expose only the master htb tc function mlx5e_htb_setup_tc()
which selects the internal "now static" function to call.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 84 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  | 16 +---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 44 +---------
 3 files changed, 70 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 9db677e9ca9c..c37f346b5a3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 #include <net/sch_generic.h>
 
+#include <net/pkt_cls.h>
 #include "en.h"
 #include "params.h"
 #include "../qos.h"
@@ -482,10 +483,11 @@ static void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs)
 		mlx5e_qos_deactivate_queues(chs->c[i]);
 }
 
-/* HTB API */
+/* HTB TC handlers */
 
-int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
-		       struct netlink_ext_ack *extack)
+static int
+mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
+		   struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *root;
 	bool opened;
@@ -542,7 +544,7 @@ int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 	return err;
 }
 
-int mlx5e_htb_root_del(struct mlx5e_priv *priv)
+static int mlx5e_htb_root_del(struct mlx5e_priv *priv)
 {
 	struct mlx5e_qos_node *root;
 	int err;
@@ -607,9 +609,10 @@ static void mlx5e_htb_convert_ceil(struct mlx5e_priv *priv, u64 ceil, u32 *max_a
 		ceil, *max_average_bw);
 }
 
-int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
-			       u32 parent_classid, u64 rate, u64 ceil,
-			       struct netlink_ext_ack *extack)
+static int
+mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
+			   u32 parent_classid, u64 rate, u64 ceil,
+			   struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node, *parent;
 	int qid;
@@ -661,8 +664,9 @@ int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
 	return mlx5e_qid_from_qos(&priv->channels, node->qid);
 }
 
-int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
-			    u64 rate, u64 ceil, struct netlink_ext_ack *extack)
+static int
+mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
+			u64 rate, u64 ceil, struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node, *child;
 	int err, tmp_err;
@@ -781,8 +785,8 @@ static void mlx5e_reset_qdisc(struct net_device *dev, u16 qid)
 	spin_unlock_bh(qdisc_lock(qdisc));
 }
 
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
-		       struct netlink_ext_ack *extack)
+static int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node;
 	struct netdev_queue *txq;
@@ -876,8 +880,9 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
 	return 0;
 }
 
-int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
-			    struct netlink_ext_ack *extack)
+static int
+mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
+			struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node, *parent;
 	u32 old_hw_id, new_hw_id;
@@ -956,8 +961,9 @@ int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
 	return 0;
 }
 
-static int mlx5e_qos_update_children(struct mlx5e_priv *priv, struct mlx5e_qos_node *node,
-				     struct netlink_ext_ack *extack)
+static int
+mlx5e_qos_update_children(struct mlx5e_priv *priv, struct mlx5e_qos_node *node,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *child;
 	int err = 0;
@@ -988,8 +994,9 @@ static int mlx5e_qos_update_children(struct mlx5e_priv *priv, struct mlx5e_qos_n
 	return err;
 }
 
-int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
-			  struct netlink_ext_ack *extack)
+static int
+mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
+		      struct netlink_ext_ack *extack)
 {
 	u32 bw_share, max_average_bw;
 	struct mlx5e_qos_node *node;
@@ -1028,6 +1035,48 @@ int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ce
 	return err;
 }
 
+/* HTB API */
+int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
+{
+	int res;
+
+	switch (htb->command) {
+	case TC_HTB_CREATE:
+		return mlx5e_htb_root_add(priv, htb->parent_classid, htb->classid,
+					  htb->extack);
+	case TC_HTB_DESTROY:
+		return mlx5e_htb_root_del(priv);
+	case TC_HTB_LEAF_ALLOC_QUEUE:
+		res = mlx5e_htb_leaf_alloc_queue(priv, htb->classid, htb->parent_classid,
+						 htb->rate, htb->ceil, htb->extack);
+		if (res < 0)
+			return res;
+		htb->qid = res;
+		return 0;
+	case TC_HTB_LEAF_TO_INNER:
+		return mlx5e_htb_leaf_to_inner(priv, htb->parent_classid, htb->classid,
+					       htb->rate, htb->ceil, htb->extack);
+	case TC_HTB_LEAF_DEL:
+		return mlx5e_htb_leaf_del(priv, &htb->classid, htb->extack);
+	case TC_HTB_LEAF_DEL_LAST:
+	case TC_HTB_LEAF_DEL_LAST_FORCE:
+		return mlx5e_htb_leaf_del_last(priv, htb->classid,
+					       htb->command == TC_HTB_LEAF_DEL_LAST_FORCE,
+					       htb->extack);
+	case TC_HTB_NODE_MODIFY:
+		return mlx5e_htb_node_modify(priv, htb->classid, htb->rate, htb->ceil,
+					     htb->extack);
+	case TC_HTB_LEAF_QUERY_QUEUE:
+		res = mlx5e_get_txq_by_classid(priv, htb->classid);
+		if (res < 0)
+			return res;
+		htb->qid = res;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 struct mlx5e_mqprio_rl {
 	struct mlx5_core_dev *mdev;
 	u32 root_id;
@@ -1111,3 +1160,4 @@ int mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32 *hw_i
 	*hw_id = rl->leaves_id[tc];
 	return 0;
 }
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index 5d9bd91d86c2..6fbddd586736 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -11,6 +11,7 @@
 struct mlx5e_priv;
 struct mlx5e_channels;
 struct mlx5e_channel;
+struct tc_htb_qopt_offload;
 
 int mlx5e_qos_bytes_rate_check(struct mlx5_core_dev *mdev, u64 nbytes);
 int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev);
@@ -26,20 +27,7 @@ void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
 void mlx5e_qos_close_queues(struct mlx5e_channel *c);
 
 /* HTB API */
-int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
-		       struct netlink_ext_ack *extack);
-int mlx5e_htb_root_del(struct mlx5e_priv *priv);
-int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
-			       u32 parent_classid, u64 rate, u64 ceil,
-			       struct netlink_ext_ack *extack);
-int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
-			    u64 rate, u64 ceil, struct netlink_ext_ack *extack);
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
-		       struct netlink_ext_ack *extack);
-int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
-			    struct netlink_ext_ack *extack);
-int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
-			  struct netlink_ext_ack *extack);
+int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb);
 
 /* MQPRIO TX rate limit */
 struct mlx5e_mqprio_rl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fe07180a957a..d4b39351a223 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -31,7 +31,6 @@
  */
 
 #include <net/tc_act/tc_gact.h>
-#include <net/pkt_cls.h>
 #include <linux/mlx5/fs.h>
 #include <net/vxlan.h>
 #include <net/geneve.h>
@@ -3420,47 +3419,6 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	}
 }
 
-static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
-{
-	int res;
-
-	switch (htb->command) {
-	case TC_HTB_CREATE:
-		return mlx5e_htb_root_add(priv, htb->parent_classid, htb->classid,
-					  htb->extack);
-	case TC_HTB_DESTROY:
-		return mlx5e_htb_root_del(priv);
-	case TC_HTB_LEAF_ALLOC_QUEUE:
-		res = mlx5e_htb_leaf_alloc_queue(priv, htb->classid, htb->parent_classid,
-						 htb->rate, htb->ceil, htb->extack);
-		if (res < 0)
-			return res;
-		htb->qid = res;
-		return 0;
-	case TC_HTB_LEAF_TO_INNER:
-		return mlx5e_htb_leaf_to_inner(priv, htb->parent_classid, htb->classid,
-					       htb->rate, htb->ceil, htb->extack);
-	case TC_HTB_LEAF_DEL:
-		return mlx5e_htb_leaf_del(priv, &htb->classid, htb->extack);
-	case TC_HTB_LEAF_DEL_LAST:
-	case TC_HTB_LEAF_DEL_LAST_FORCE:
-		return mlx5e_htb_leaf_del_last(priv, htb->classid,
-					       htb->command == TC_HTB_LEAF_DEL_LAST_FORCE,
-					       htb->extack);
-	case TC_HTB_NODE_MODIFY:
-		return mlx5e_htb_node_modify(priv, htb->classid, htb->rate, htb->ceil,
-					     htb->extack);
-	case TC_HTB_LEAF_QUERY_QUEUE:
-		res = mlx5e_get_txq_by_classid(priv, htb->classid);
-		if (res < 0)
-			return res;
-		htb->qid = res;
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -3494,7 +3452,7 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		return err;
 	case TC_SETUP_QDISC_HTB:
 		mutex_lock(&priv->state_lock);
-		err = mlx5e_setup_tc_htb(priv, type_data);
+		err = mlx5e_htb_setup_tc(priv, type_data);
 		mutex_unlock(&priv->state_lock);
 		return err;
 	default:
-- 
2.36.1

