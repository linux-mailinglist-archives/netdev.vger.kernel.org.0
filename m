Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42B752B2BA
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiERGuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiERGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AC122B1D
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B924A60BD3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149FEC385A9;
        Wed, 18 May 2022 06:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856593;
        bh=0kWsTb/eNHpxi1Jvvwu0GM/nMX7AXEDSQgegHLKn9ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBl50+kczfMrjfc4SmDWEKWy3reiCuYjM5lY/pwbN1CteQ3OZlLzblDnPF0jvQdJa
         +Qy59gDCWsPM905O2rGlbXZIzhcWOVxT2g4l7oBUxwroDr1ZjvWo8YQIIfFG2817Gf
         UW/WBBnmIPJMkGneixRzozFo1tPWP6XkLp9JKEKucAn6pmCQdI2Wj219F5VhPLxrP1
         kLK7RTVcs9Jztwhqf2KdvJfu0VzoK8yvMRMI3jrWNqtZQkq03NYkcDsYqeDpt03iAF
         gQWEy3wPxWi9+Y//zOSPojlmAFicFG30g9IMUjFyyFEBh2+717XXo9ved6eIcDW6Gy
         9kwo5DbiW4tMQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net-next 11/16] net/mlx5e: CT: Add ct driver counters
Date:   Tue, 17 May 2022 23:49:33 -0700
Message-Id: <20220518064938.128220-12-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Connection offload is translated to multiple rules over several
hardware flow tables. Unhandled end-cases may cause a hardware
resource leak causing multiple system symptoms such as a host
memory leak, decreased performance and other scale related issues.

Export the current number of firmware FTEs related to the CT table
as a debugfs counter. Also add a dropped packets counter to help
debug packets dropped on restore failure.

To show the offloaded count:
cat /sys/kernel/debug/mlx5/<PCI>/ct_nic/offloaded

To show the dropped count:
cat /sys/kernel/debug/mlx5/<PCI>/ct_nic/rx_dropped

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Roi Dayan <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 52 +++++++++++++++++--
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 228fbd2c20d4..bceea7a1589e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -15,6 +15,7 @@
 #include <linux/refcount.h>
 #include <linux/xarray.h>
 #include <linux/if_macvlan.h>
+#include <linux/debugfs.h>
 
 #include "lib/fs_chains.h"
 #include "en/tc_ct.h"
@@ -47,6 +48,15 @@
 #define ct_dbg(fmt, args...)\
 	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
 
+struct mlx5_tc_ct_debugfs {
+	struct {
+		atomic_t offloaded;
+		atomic_t rx_dropped;
+	} stats;
+
+	struct dentry *root;
+};
+
 struct mlx5_tc_ct_priv {
 	struct mlx5_core_dev *dev;
 	const struct net_device *netdev;
@@ -66,6 +76,8 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_ct_fs *fs;
 	struct mlx5_ct_fs_ops *fs_ops;
 	spinlock_t ht_lock; /* protects ft entries */
+
+	struct mlx5_tc_ct_debugfs debugfs;
 };
 
 struct mlx5_ct_flow {
@@ -520,6 +532,8 @@ mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
 {
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+
+	atomic_dec(&ct_priv->debugfs.stats.offloaded);
 }
 
 static struct flow_action_entry *
@@ -1040,6 +1054,7 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_nat;
 
+	atomic_inc(&ct_priv->debugfs.stats.offloaded);
 	return 0;
 
 err_nat:
@@ -2064,6 +2079,29 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 	return err;
 }
 
+static void
+mlx5_ct_tc_create_dbgfs(struct mlx5_tc_ct_priv *ct_priv)
+{
+	bool is_fdb = ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB;
+	struct mlx5_tc_ct_debugfs *ct_dbgfs = &ct_priv->debugfs;
+	char dirname[16] = {};
+
+	if (sscanf(dirname, "ct_%s", is_fdb ? "fdb" : "nic") < 0)
+		return;
+
+	ct_dbgfs->root = debugfs_create_dir(dirname, mlx5_debugfs_get_dev_root(ct_priv->dev));
+	debugfs_create_atomic_t("offloaded", 0400, ct_dbgfs->root,
+				&ct_dbgfs->stats.offloaded);
+	debugfs_create_atomic_t("rx_dropped", 0400, ct_dbgfs->root,
+				&ct_dbgfs->stats.rx_dropped);
+}
+
+static void
+mlx5_ct_tc_remove_dbgfs(struct mlx5_tc_ct_priv *ct_priv)
+{
+	debugfs_remove_recursive(ct_priv->debugfs.root);
+}
+
 #define INIT_ERR_PREFIX "tc ct offload init failed"
 
 struct mlx5_tc_ct_priv *
@@ -2139,6 +2177,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	if (err)
 		goto err_init_fs;
 
+	mlx5_ct_tc_create_dbgfs(ct_priv);
 	return ct_priv;
 
 err_init_fs:
@@ -2171,6 +2210,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	if (!ct_priv)
 		return;
 
+	mlx5_ct_tc_remove_dbgfs(ct_priv);
 	chains = ct_priv->chains;
 
 	ct_priv->fs_ops->destroy(ct_priv->fs);
@@ -2200,22 +2240,22 @@ mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 		return true;
 
 	if (mapping_find(ct_priv->zone_mapping, zone_restore_id, &zone))
-		return false;
+		goto out_inc_drop;
 
 	if (!mlx5_tc_ct_skb_to_tuple(skb, &tuple, zone))
-		return false;
+		goto out_inc_drop;
 
 	spin_lock(&ct_priv->ht_lock);
 
 	entry = mlx5_tc_ct_entry_get(ct_priv, &tuple);
 	if (!entry) {
 		spin_unlock(&ct_priv->ht_lock);
-		return false;
+		goto out_inc_drop;
 	}
 
 	if (IS_ERR(entry)) {
 		spin_unlock(&ct_priv->ht_lock);
-		return false;
+		goto out_inc_drop;
 	}
 	spin_unlock(&ct_priv->ht_lock);
 
@@ -2223,4 +2263,8 @@ mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 	__mlx5_tc_ct_entry_put(entry);
 
 	return true;
+
+out_inc_drop:
+	atomic_inc(&ct_priv->debugfs.stats.rx_dropped);
+	return false;
 }
-- 
2.36.1

