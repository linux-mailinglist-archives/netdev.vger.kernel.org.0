Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435CB59D0E4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbiHWFzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240363AbiHWFzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3475F121
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AAE2B81B79
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BE6C433D6;
        Tue, 23 Aug 2022 05:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234147;
        bh=hi0GP/0f57rxrMQ7IsEoAgbq1RsA78GeKsMxMAJ82hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfcrVtAIZ6e3g6y1hNvRtDJDR8Q+TXFgxcK9bWS6iZQ/kTE4IDehfN+p/z5EF1bxu
         ZKmKgK23o4j/YV48PAR4R3oHwurD1Mjm+S6DgC/Gwggy2sU5fkFNptnRrJE6aa0Nk8
         Q2wpdTQAiC0TWHVuEy00wNt9Zu5r1Q0vk0KXarHL9uQJREA5xVe1xh1YrpO0h01GaW
         AJsB21sc1YHQn1rDgOcCYzeRhe6AcrdjR8vd+tpFzCc8cON/XQfIqohUF5Fd3h9j8V
         oNhDuGkgyWCiEw6atTUllwHInPug8mfC83n6cH0NWIke9+CsZndAjzH3D7pkkAHnSS
         IRxz6t0BYxf3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Decouple fs_tcp from en.h
Date:   Mon, 22 Aug 2022 22:55:21 -0700
Message-Id: <20220823055533.334471-4-saeed@kernel.org>
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

Make flow steering files fs_tcp.c/h independent of en.h
such that they go through the flow steering API only.

Make error reports be via mlx5_core API instead of netdev_err API, this
to ensure a safe decoupling from en.h, and prevent redundant argument
passing.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 94 +++++++++----------
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      | 14 +--
 .../mellanox/mlx5/core/en_accel/ktls.c        |  8 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
 4 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index a86ae0752760..7f0564ab95eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 
-#include <linux/netdevice.h>
+#include <mlx5_core.h>
 #include "en_accel/fs_tcp.h"
 #include "fs_core.h"
 
@@ -71,11 +71,11 @@ void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
 	mlx5_del_flow_rules(rule);
 }
 
-struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
 					       struct sock *sk, u32 tirn,
 					       uint32_t flow_tag)
 {
-	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(fs);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_flow_table *ft = NULL;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -92,11 +92,11 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 	case AF_INET:
 		accel_fs_tcp_set_ipv4_flow(spec, sk);
 		ft = &fs_tcp->tables[ACCEL_FS_IPV4_TCP];
-		mlx5e_dbg(HW, priv, "%s flow is %pI4:%d -> %pI4:%d\n", __func__,
-			  &inet_sk(sk)->inet_rcv_saddr,
-			  inet_sk(sk)->inet_sport,
-			  &inet_sk(sk)->inet_daddr,
-			  inet_sk(sk)->inet_dport);
+		mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "%s flow is %pI4:%d -> %pI4:%d\n", __func__,
+			      &inet_sk(sk)->inet_rcv_saddr,
+			      inet_sk(sk)->inet_sport,
+			      &inet_sk(sk)->inet_daddr,
+			      inet_sk(sk)->inet_dport);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
@@ -138,19 +138,19 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 	flow = mlx5_add_flow_rules(ft->t, spec, &flow_act, &dest, 1);
 
 	if (IS_ERR(flow))
-		netdev_err(priv->netdev, "mlx5_add_flow_rules() failed, flow is %ld\n",
-			   PTR_ERR(flow));
+		mlx5_core_err(mlx5e_fs_get_mdev(fs), "mlx5_add_flow_rules() failed, flow is %ld\n",
+			      PTR_ERR(flow));
 
 out:
 	kvfree(spec);
 	return flow;
 }
 
-static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
+static int accel_fs_tcp_add_default_rule(struct mlx5e_flow_steering *fs,
 					 enum accel_fs_tcp_type type)
 {
-	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	struct mlx5e_flow_table *accel_fs_t;
 	struct mlx5_flow_destination dest;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -163,9 +163,9 @@ static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev,
-			   "%s: add default rule failed, accel_fs type=%d, err %d\n",
-			   __func__, type, err);
+		mlx5_core_err(mlx5e_fs_get_mdev(fs),
+			      "%s: add default rule failed, accel_fs type=%d, err %d\n",
+			      __func__, type, err);
 		return err;
 	}
 
@@ -263,10 +263,10 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 	return err;
 }
 
-static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_type type)
+static int accel_fs_tcp_create_table(struct mlx5e_flow_steering *fs, enum accel_fs_tcp_type type)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
-	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(fs, false);
 	struct mlx5e_flow_table *ft = &accel_tcp->tables[type];
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -284,14 +284,14 @@ static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_
 		return err;
 	}
 
-	netdev_dbg(priv->netdev, "Created fs accel table id %u level %u\n",
-		   ft->t->id, ft->t->level);
+	mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "Created fs accel table id %u level %u\n",
+		      ft->t->id, ft->t->level);
 
 	err = accel_fs_tcp_create_groups(ft, type);
 	if (err)
 		goto err;
 
-	err = accel_fs_tcp_add_default_rule(priv, type);
+	err = accel_fs_tcp_add_default_rule(fs, type);
 	if (err)
 		goto err;
 
@@ -301,18 +301,18 @@ static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_
 	return err;
 }
 
-static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
+static int accel_fs_tcp_disable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	int err, i;
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
 		err = mlx5_ttc_fwd_default_dest(ttc, fs_accel2tt(i));
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
-				   __func__, fs_accel2tt(i), err);
+			mlx5_core_err(mlx5e_fs_get_mdev(fs),
+				      "%s: modify ttc[%d] default destination failed, err(%d)\n",
+				      __func__, fs_accel2tt(i), err);
 			return err;
 		}
 	}
@@ -320,10 +320,10 @@ static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
 	return 0;
 }
 
-static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
+static int accel_fs_tcp_enable(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs, false);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
@@ -334,18 +334,18 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 		/* Modify ttc rules destination to point on the accel_fs FTs */
 		err = mlx5_ttc_fwd_dest(ttc, fs_accel2tt(i), &dest);
 		if (err) {
-			netdev_err(priv->netdev,
-				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-				   __func__, fs_accel2tt(i), err);
+			mlx5_core_err(mlx5e_fs_get_mdev(fs),
+				      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+				      __func__, fs_accel2tt(i), err);
 			return err;
 		}
 	}
 	return 0;
 }
 
-static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
+static void accel_fs_tcp_destroy_table(struct mlx5e_flow_steering *fs, int i)
 {
-	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(fs);
 
 	if (IS_ERR_OR_NULL(fs_tcp->tables[i].t))
 		return;
@@ -355,43 +355,43 @@ static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
 	fs_tcp->tables[i].t = NULL;
 }
 
-void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
+void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
 	int i;
 
 	if (!accel_tcp)
 		return;
 
-	accel_fs_tcp_disable(priv);
+	accel_fs_tcp_disable(fs);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
-		accel_fs_tcp_destroy_table(priv, i);
+		accel_fs_tcp_destroy_table(fs, i);
 
 	kfree(accel_tcp);
-	mlx5e_fs_set_accel_tcp(priv->fs, NULL);
+	mlx5e_fs_set_accel_tcp(fs, NULL);
 }
 
-int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
+int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 {
 	struct mlx5e_accel_fs_tcp *accel_tcp;
 	int i, err;
 
-	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
+	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
 	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
-	mlx5e_fs_set_accel_tcp(priv->fs, accel_tcp);
+	mlx5e_fs_set_accel_tcp(fs, accel_tcp);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
-		err = accel_fs_tcp_create_table(priv, i);
+		err = accel_fs_tcp_create_table(fs, i);
 		if (err)
 			goto err_destroy_tables;
 	}
 
-	err = accel_fs_tcp_enable(priv);
+	err = accel_fs_tcp_enable(fs);
 	if (err)
 		goto err_destroy_tables;
 
@@ -399,8 +399,8 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 
 err_destroy_tables:
 	while (--i >= 0)
-		accel_fs_tcp_destroy_table(priv, i);
+		accel_fs_tcp_destroy_table(fs, i);
 	kfree(accel_tcp);
-	mlx5e_fs_set_accel_tcp(priv->fs, NULL);
+	mlx5e_fs_set_accel_tcp(fs, NULL);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
index 589235824543..a032bff482a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -4,19 +4,19 @@
 #ifndef __MLX5E_ACCEL_FS_TCP_H__
 #define __MLX5E_ACCEL_FS_TCP_H__
 
-#include "en.h"
+#include "en/fs.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
-int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
-void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
-struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs);
+void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs);
+struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
 					       struct sock *sk, u32 tirn,
 					       uint32_t flow_tag);
 void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule);
 #else
-static inline int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv) { return 0; }
-static inline void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv) {}
-static inline struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+static inline int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs) { return 0; }
+static inline void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs) {}
+static inline struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
 							     struct sock *sk, u32 tirn,
 							     uint32_t flow_tag)
 { return ERR_PTR(-EOPNOTSUPP); }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 30a70d139046..c0b77963cc7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -118,9 +118,9 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 
 	mutex_lock(&priv->state_lock);
 	if (enable)
-		err = mlx5e_accel_fs_tcp_create(priv);
+		err = mlx5e_accel_fs_tcp_create(priv->fs);
 	else
-		mlx5e_accel_fs_tcp_destroy(priv);
+		mlx5e_accel_fs_tcp_destroy(priv->fs);
 	mutex_unlock(&priv->state_lock);
 
 	return err;
@@ -138,7 +138,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	if (priv->netdev->features & NETIF_F_HW_TLS_RX) {
-		err = mlx5e_accel_fs_tcp_create(priv);
+		err = mlx5e_accel_fs_tcp_create(priv->fs);
 		if (err) {
 			destroy_workqueue(priv->tls->rx_wq);
 			return err;
@@ -154,7 +154,7 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 		return;
 
 	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
-		mlx5e_accel_fs_tcp_destroy(priv);
+		mlx5e_accel_fs_tcp_destroy(priv->fs);
 
 	destroy_workqueue(priv->tls->rx_wq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 27483aa7be8a..13145ecaf839 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -111,7 +111,7 @@ static void accel_rule_handle_work(struct work_struct *work)
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
 		goto out;
 
-	rule = mlx5e_accel_fs_add_sk(accel_rule->priv, priv_rx->sk,
+	rule = mlx5e_accel_fs_add_sk(accel_rule->priv->fs, priv_rx->sk,
 				     mlx5e_tir_get_tirn(&priv_rx->tir),
 				     MLX5_FS_DEFAULT_FLOW_TAG);
 	if (!IS_ERR_OR_NULL(rule))
-- 
2.37.1

