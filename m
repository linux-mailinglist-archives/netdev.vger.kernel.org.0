Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB168A94D
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjBDKJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDKJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7500196A4
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D94060BE9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E751C433EF;
        Sat,  4 Feb 2023 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505355;
        bh=nOHVtE+Fo2GbRsCYiNeWLBZNSzhlMzrQUPAP4C1cBAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwLF1vBf4tCaEVfxWYQaNw0WpBezHTnWFRyPWkUTbok1BmZTIqrcoG2cjIQ7jODC+
         a/0oafNgcHZ+1lg+zurxZPswbTaCaNgc4cONeXa9fMDo3wm7h/ALh+bDb9Ddb44Qgi
         n7k+hGlMLtaVUuvBcfXUdEURlBnZM/88Q6UYEcGS6mZp4owAxpZ39ulYRzKwwER3oi
         4u+3wGVjmCqSWkfoKZj/Ky46l7jnxnr8qKPxDjpJE6UA8DGMcgu2d4zbs6qnhxx4yl
         5tNWzDta6BEbA+igqdjsqMYkv1r5zreKAX/Ruo0IernerPu/xwxH0IwvZ3fMmPJSSO
         W5QYUQzhlDKvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Lag, Update multiport eswitch check to log an error
Date:   Sat,  4 Feb 2023 02:08:40 -0800
Message-Id: <20230204100854.388126-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Update the function to log an error to the user if failing to offload
the rule and while there add correct prefix for the function name.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c    |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c   | 11 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h   |  4 +++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 78c427b38048..c095a12346de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -232,9 +232,9 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	parse_state->ifindexes[if_count] = out_dev->ifindex;
 	parse_state->if_count++;
 	is_uplink_rep = mlx5e_eswitch_uplink_rep(out_dev);
-	err = mlx5_lag_do_mirred(priv->mdev, out_dev);
-	if (err)
-		return err;
+
+	if (mlx5_lag_mpesw_do_mirred(priv->mdev, out_dev, extack))
+		return -EOPNOTSUPP;
 
 	out_dev = get_fdb_out_dev(uplink_dev, out_dev);
 	if (!out_dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index c17e8f1ec914..d2f840812942 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -96,17 +96,20 @@ int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
 	return mlx5_lag_mpesw_queue_work(dev, MLX5_MPESW_OP_ENABLE);
 }
 
-int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev)
+int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
+			     struct net_device *out_dev,
+			     struct netlink_ext_ack *extack)
 {
 	struct mlx5_lag *ldev = mdev->priv.lag;
 
 	if (!netif_is_bond_master(out_dev) || !ldev)
 		return 0;
 
-	if (ldev->mode == MLX5_LAG_MODE_MPESW)
-		return -EOPNOTSUPP;
+	if (ldev->mode != MLX5_LAG_MODE_MPESW)
+		return 0;
 
-	return 0;
+	NL_SET_ERR_MSG_MOD(extack, "can't forward to bond in mpesw mode");
+	return -EOPNOTSUPP;
 }
 
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 88e8daffcf92..f88dc6ec3de1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -12,7 +12,9 @@ struct lag_mpesw {
 	atomic_t mpesw_rule_count;
 };
 
-int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev);
+int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
+			     struct net_device *out_dev,
+			     struct netlink_ext_ack *extack);
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
 #if IS_ENABLED(CONFIG_MLX5_ESWITCH)
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
-- 
2.39.1

