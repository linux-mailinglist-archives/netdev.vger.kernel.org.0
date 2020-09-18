Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39381270359
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgIRR3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgIRR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A6B23447;
        Fri, 18 Sep 2020 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450135;
        bh=AshaQjj2FPoN7AlF1OA03ob9oqXHSSZlsv3tTJ4o1/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djP7N/I8rbv6TZcEjz+3ICRa8OL6UU8Xn9ChnhcLVAp9nLVxbI1QrWpJ1qDxYAtG7
         hUWt0XNOiPCRtDgwAr0n0DppWtc1IVFZL95EQoBZvTKkmfTGfC1E5dpgn8nzj6Qx7e
         dE4+b8NqSXR/ctXJU7kl5TzKgRt0v/P1TDx7IMIs=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alaa Hleihel <alaa@nvidia.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/15] net/mlx5e: Fix using wrong stats_grps in mlx5e_update_ndo_stats()
Date:   Fri, 18 Sep 2020 10:28:33 -0700
Message-Id: <20200918172839.310037-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

The cited commit started to reuse function mlx5e_update_ndo_stats() for
the representors as well.
However, the function is hard-coded to work on mlx5e_nic_stats_grps only.
Due to this issue, the representors statistics were not updated in the
output of "ip -s".

Fix it to work with the correct group by extracting it from the caller's
profile.

Also, while at it and since this function became generic, move it to
en_stats.c and rename it accordingly.

Fixes: 8a236b15144b ("net/mlx5e: Convert rep stats to mlx5e_stats_grp-based infra")
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  1 -
 .../ethernet/mellanox/mlx5/core/en/monitor_stats.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 12 +-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c   | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h   |  1 +
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5d7b79518449..90d5caabd6af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1005,7 +1005,6 @@ int mlx5e_update_nic_rx(struct mlx5e_priv *priv);
 void mlx5e_update_carrier(struct mlx5e_priv *priv);
 int mlx5e_close(struct net_device *netdev);
 int mlx5e_open(struct net_device *netdev);
-void mlx5e_update_ndo_stats(struct mlx5e_priv *priv);
 
 void mlx5e_queue_update_stats(struct mlx5e_priv *priv);
 int mlx5e_bits_invert(unsigned long a, int size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
index 8fe8b4d6ad1c..254c84739046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
@@ -51,7 +51,7 @@ static void mlx5e_monitor_counters_work(struct work_struct *work)
 					       monitor_counters_work);
 
 	mutex_lock(&priv->state_lock);
-	mlx5e_update_ndo_stats(priv);
+	mlx5e_stats_update_ndo_stats(priv);
 	mutex_unlock(&priv->state_lock);
 	mlx5e_monitor_counter_arm(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d46047235568..b3cda7b6e5e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -158,16 +158,6 @@ static void mlx5e_update_carrier_work(struct work_struct *work)
 	mutex_unlock(&priv->state_lock);
 }
 
-void mlx5e_update_ndo_stats(struct mlx5e_priv *priv)
-{
-	int i;
-
-	for (i = mlx5e_nic_stats_grps_num(priv) - 1; i >= 0; i--)
-		if (mlx5e_nic_stats_grps[i]->update_stats_mask &
-		    MLX5E_NDO_UPDATE_STATS)
-			mlx5e_nic_stats_grps[i]->update_stats(priv);
-}
-
 static void mlx5e_update_stats_work(struct work_struct *work)
 {
 	struct mlx5e_priv *priv = container_of(work, struct mlx5e_priv,
@@ -5187,7 +5177,7 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.enable		   = mlx5e_nic_enable,
 	.disable	   = mlx5e_nic_disable,
 	.update_rx	   = mlx5e_update_nic_rx,
-	.update_stats	   = mlx5e_update_ndo_stats,
+	.update_stats	   = mlx5e_stats_update_ndo_stats,
 	.update_carrier	   = mlx5e_update_carrier,
 	.rx_handlers       = &mlx5e_rx_handlers_nic,
 	.max_tc		   = MLX5E_MAX_NUM_TC,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e13e5d1b3eae..e979bff64c49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1171,7 +1171,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.cleanup_tx		= mlx5e_cleanup_rep_tx,
 	.enable		        = mlx5e_rep_enable,
 	.update_rx		= mlx5e_update_rep_rx,
-	.update_stats           = mlx5e_update_ndo_stats,
+	.update_stats           = mlx5e_stats_update_ndo_stats,
 	.rx_handlers            = &mlx5e_rx_handlers_rep,
 	.max_tc			= 1,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
@@ -1189,7 +1189,7 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.enable		        = mlx5e_uplink_rep_enable,
 	.disable	        = mlx5e_uplink_rep_disable,
 	.update_rx		= mlx5e_update_rep_rx,
-	.update_stats           = mlx5e_update_ndo_stats,
+	.update_stats           = mlx5e_stats_update_ndo_stats,
 	.update_carrier	        = mlx5e_update_carrier,
 	.rx_handlers            = &mlx5e_rx_handlers_rep,
 	.max_tc			= MLX5E_MAX_NUM_TC,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e3b2f59408e6..f6383bc2bc3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -54,6 +54,18 @@ unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv)
 	return total;
 }
 
+void mlx5e_stats_update_ndo_stats(struct mlx5e_priv *priv)
+{
+	mlx5e_stats_grp_t *stats_grps = priv->profile->stats_grps;
+	const unsigned int num_stats_grps = stats_grps_num(priv);
+	int i;
+
+	for (i = num_stats_grps - 1; i >= 0; i--)
+		if (stats_grps[i]->update_stats &&
+		    stats_grps[i]->update_stats_mask & MLX5E_NDO_UPDATE_STATS)
+			stats_grps[i]->update_stats(priv);
+}
+
 void mlx5e_stats_update(struct mlx5e_priv *priv)
 {
 	mlx5e_stats_grp_t *stats_grps = priv->profile->stats_grps;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index be7cda283781..562263d62141 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -103,6 +103,7 @@ unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv);
 void mlx5e_stats_update(struct mlx5e_priv *priv);
 void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx);
 void mlx5e_stats_fill_strings(struct mlx5e_priv *priv, u8 *data);
+void mlx5e_stats_update_ndo_stats(struct mlx5e_priv *priv);
 
 /* Concrete NIC Stats */
 
-- 
2.26.2

