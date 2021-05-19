Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9F238874B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbhESGHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236858AbhESGH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60B37613AE;
        Wed, 19 May 2021 06:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404369;
        bh=icB6kiNO4xW/ejVuNGwjtivwxI7QExeAv4lp/2U8dUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p79kiKVCr7OQxG6WIml3+RQhtYk8kmqUUNO5QtcaR8Iq+YpUfUHkRVp4KuiojN3W1
         GgiwvlbEOaxOkSzBVfIgCo/Wro0RAvyMU4YnBPJKYutRyuCMwyK/d4VqRLOlwBNkS3
         q+G7mXlvC/2L5PNOn32kAueDJspTT+TYjNWq6ejaySox3+rmHMo8enXrZet7ZvS7RL
         Lc5g7bfujeL/0UeLGIrrrlGNHmqciuRoOTFgwoRqcwTYUYewhz1tk3ZFL+pLgto+se
         9Zg0etuAemjZYI/MbBtteFVTBLOAvSFzmKBNXjr06p5Xx14hUMTPabf8E64jkUeB2q
         9sE3Yz9S3y7Yw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 09/16] net/mlx5e: reset XPS on error flow if netdev isn't registered yet
Date:   Tue, 18 May 2021 23:05:16 -0700
Message-Id: <20210519060523.17875-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

mlx5e_attach_netdev can be called prior to registering the netdevice:
Example stack:

ipoib_new_child_link ->
ipoib_intf_init->
rdma_init_netdev->
mlx5_rdma_setup_rn->

mlx5e_attach_netdev->
mlx5e_num_channels_changed ->
mlx5e_set_default_xps_cpumasks ->
netif_set_xps_queue ->
__netif_set_xps_queue -> kmalloc

If any later stage fails at any point after mlx5e_num_channels_changed()
returns, XPS allocated maps will never be freed as they
are only freed during netdev unregistration, which will never happen for
yet to be registered netdevs.

Fixes: 3909a12e7913 ("net/mlx5e: Fix configuration of XPS cpumasks and netdev queues in corner cases")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bca832cdc4cb..89937b055070 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5229,6 +5229,11 @@ static void mlx5e_update_features(struct net_device *netdev)
 	rtnl_unlock();
 }
 
+static void mlx5e_reset_channels(struct net_device *netdev)
+{
+	netdev_reset_tc(netdev);
+}
+
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
 	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
@@ -5283,6 +5288,7 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	profile->cleanup_tx(priv);
 
 out:
+	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
@@ -5300,6 +5306,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	profile->cleanup_rx(priv);
 	profile->cleanup_tx(priv);
+	mlx5e_reset_channels(priv->netdev);
 	cancel_work_sync(&priv->update_stats_work);
 }
 
-- 
2.31.1

