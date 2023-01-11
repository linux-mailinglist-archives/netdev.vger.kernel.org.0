Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8904D6653D1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjAKFjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbjAKFiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A95C5D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2455B819F0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E124C433D2;
        Wed, 11 Jan 2023 05:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415053;
        bh=HSVN6KB6TPZ3ULfrT5oLVlN7ugPGXD4OshGBK9sOoNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOmmsQM31quzTAL3rmC0ABEvTo9k+WlvTAOwueyrWM00DVy46oJ/Nlpf1xPMw5uZE
         9Uq02nS4QoQPSV+DCcuFa6JA4pwlPRc+ftazM36BLac3D03HY4LhelTSu+TiQpIH8y
         0wXT4TubJKYviOybHyiH1nc9d7iIZCbfOECdX/ZakLfhgji9L9xn9HAz6gwn4S5Udn
         zw6d+YGR1bWiROgTVkSPEhN/3UwPcQ+YpWweoI2ra9oFKsH6axjTNS4q7oafMWdBxE
         GiRFq6rE6pxDPfNY3p8WxAMsr5dWGXoU5QZfqIK1v49XLgZEPoe9FC9jxWxTqQHLGs
         Viql4Va1qpyGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: kTLS, Add debugfs
Date:   Tue, 10 Jan 2023 21:30:35 -0800
Message-Id: <20230111053045.413133-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Add TLS debugfs to improve observability by exposing the size of the tls
TX pool.

To observe the size of the TX pool:
$ cat /sys/kernel/debug/mlx5/<pci>/nic/tls/tx/pool_size

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Co-developed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls.c        | 22 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls.h        |  8 +++++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 22 +++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index da2184c94203..eb5b09f81dec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
+#include <linux/debugfs.h>
 #include "en.h"
 #include "lib/mlx5.h"
 #include "en_accel/ktls.h"
@@ -177,6 +178,15 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 	destroy_workqueue(priv->tls->rx_wq);
 }
 
+static void mlx5e_tls_debugfs_init(struct mlx5e_tls *tls,
+				   struct dentry *dfs_root)
+{
+	if (IS_ERR_OR_NULL(dfs_root))
+		return;
+
+	tls->debugfs.dfs = debugfs_create_dir("tls", dfs_root);
+}
+
 int mlx5e_ktls_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tls *tls;
@@ -189,11 +199,23 @@ int mlx5e_ktls_init(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	priv->tls = tls;
+	priv->tls->mdev = priv->mdev;
+
+	mlx5e_tls_debugfs_init(tls, priv->dfs_root);
+
 	return 0;
 }
 
 void mlx5e_ktls_cleanup(struct mlx5e_priv *priv)
 {
+	struct mlx5e_tls *tls = priv->tls;
+
+	if (!mlx5e_is_ktls_device(priv->mdev))
+		return;
+
+	debugfs_remove_recursive(tls->debugfs.dfs);
+	tls->debugfs.dfs = NULL;
+
 	kfree(priv->tls);
 	priv->tls = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 1c35045e41fb..fccf995ee16d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -4,6 +4,7 @@
 #ifndef __MLX5E_KTLS_H__
 #define __MLX5E_KTLS_H__
 
+#include <linux/debugfs.h>
 #include <linux/tls.h>
 #include <net/tls.h>
 #include "en.h"
@@ -72,10 +73,17 @@ struct mlx5e_tls_sw_stats {
 	atomic64_t rx_tls_del;
 };
 
+struct mlx5e_tls_debugfs {
+	struct dentry *dfs;
+	struct dentry *dfs_tx;
+};
+
 struct mlx5e_tls {
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_tls_sw_stats sw_stats;
 	struct workqueue_struct *rx_wq;
 	struct mlx5e_tls_tx_pool *tx_pool;
+	struct mlx5e_tls_debugfs debugfs;
 };
 
 int mlx5e_ktls_init(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 78072bf93f3f..6db27062b765 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
+#include <linux/debugfs.h>
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_txrx.h"
 #include "en_accel/ktls_utils.h"
@@ -886,8 +887,24 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	return false;
 }
 
+static void mlx5e_tls_tx_debugfs_init(struct mlx5e_tls *tls,
+				      struct dentry *dfs_root)
+{
+	if (IS_ERR_OR_NULL(dfs_root))
+		return;
+
+	tls->debugfs.dfs_tx = debugfs_create_dir("tx", dfs_root);
+	if (!tls->debugfs.dfs_tx)
+		return;
+
+	debugfs_create_size_t("pool_size", 0400, tls->debugfs.dfs_tx,
+			      &tls->tx_pool->size);
+}
+
 int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
 {
+	struct mlx5e_tls *tls = priv->tls;
+
 	if (!mlx5e_is_ktls_tx(priv->mdev))
 		return 0;
 
@@ -895,6 +912,8 @@ int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
 	if (!priv->tls->tx_pool)
 		return -ENOMEM;
 
+	mlx5e_tls_tx_debugfs_init(tls, tls->debugfs.dfs);
+
 	return 0;
 }
 
@@ -903,6 +922,9 @@ void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
 	if (!mlx5e_is_ktls_tx(priv->mdev))
 		return;
 
+	debugfs_remove_recursive(priv->tls->debugfs.dfs_tx);
+	priv->tls->debugfs.dfs_tx = NULL;
+
 	mlx5e_tls_tx_pool_cleanup(priv->tls->tx_pool);
 	priv->tls->tx_pool = NULL;
 }
-- 
2.39.0

