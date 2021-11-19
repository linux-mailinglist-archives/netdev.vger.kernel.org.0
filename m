Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A154045777C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhKSUBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234823AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF1161B6F;
        Fri, 19 Nov 2021 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351903;
        bh=TKVMAaxQbclSNeprdFgpNXjj+fwfxS446I0YAOVo8nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z28B3y6KSsEJPTp61KumXDGL/Gg+6/demjoTSeVXWOe38cU73+ga5dNp9SQlbisA4
         Plwwo6inholv6HL/fhqbZhKAG1dpcWJ+QLaHBpNBQB4z0L+mVivMjNbQOkvpxfyYHE
         uwqCNAzHi+KavU+Nv++PVynJLCHjXRMsWWjTdZRCX0+/znx/P2/8fl27dFcppxhfg3
         u3o0YjOhJ5aZmq0MAEgu3hM+V88AOLEMRRRuFAnoNg7oxj8TYYD7pJAKIFtNutXXc2
         Qm0FbdZcgn3Q3+s34WVmAoD2PeOy9svSAhX3QicebaqpOaVIQdKUo2cwLSgbZT6A/R
         3gWlxSGZnkhOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/10] net/mlx5e: Do synchronize_net only once when deactivating channels
Date:   Fri, 19 Nov 2021 11:58:13 -0800
Message-Id: <20211119195813.739586-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Synchronize_net takes time, and given that it's called multiple times
per channel on deactivation, it accumulates to a significant amount,
which causes timeouts in some applications (for example, when using
bonding with NetworkManager).

This commit fixes the timing issue by restructuring the code, so that
synchronize_net is only called once per deactivation of all channels.
It's entirely valid, because we only need one synchronization point with
NAPI between deactivation and closing the channels.

Fixes: 9c25a22dfb00 ("net/mlx5e: Use synchronize_rcu to sync with NAPI")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 26 ++++++----
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 52 +++++++++++++------
 3 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index f190c5437294..3314fcadec5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -724,11 +724,14 @@ void mlx5e_ptp_close(struct mlx5e_ptp *c)
 	kvfree(c);
 }
 
-void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
+void mlx5e_ptp_enable_channel(struct mlx5e_ptp *c)
 {
-	int tc;
-
 	napi_enable(&c->napi);
+}
+
+void mlx5e_ptp_start_channel(struct mlx5e_ptp *c)
+{
+	int tc;
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
 		for (tc = 0; tc < c->num_tc; tc++) {
@@ -742,22 +745,25 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	}
 }
 
-void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
+void mlx5e_ptp_disable_channel(struct mlx5e_ptp *c)
 {
 	int tc;
 
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
 		mlx5e_deactivate_rq(&c->rq);
 
-	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
-		for (tc = 0; tc < c->num_tc; tc++) {
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state))
+		for (tc = 0; tc < c->num_tc; tc++)
 			mlx5e_disable_txqsq(&c->ptpsq[tc].txqsq);
+}
+
+void mlx5e_ptp_stop_channel(struct mlx5e_ptp *c)
+{
+	int tc;
 
-			/* Sync with NAPI to prevent netif_tx_wake_queue. */
-			synchronize_net();
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state))
+		for (tc = 0; tc < c->num_tc; tc++)
 			mlx5e_stop_txqsq(&c->ptpsq[tc].txqsq);
-		}
-	}
 	napi_disable(&c->napi);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index a71a32e00ebb..e96d2af682f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -70,8 +70,10 @@ static inline bool mlx5e_use_ptpsq(struct sk_buff *skb)
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
-void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
-void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_enable_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_start_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_disable_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_stop_channel(struct mlx5e_ptp *c);
 int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
 int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv);
 void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1fb0d9b70301..f77d76728b46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2251,11 +2251,14 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	return err;
 }
 
-static void mlx5e_activate_channel(struct mlx5e_channel *c)
+static void mlx5e_enable_channel(struct mlx5e_channel *c)
 {
-	int tc;
-
 	napi_enable(&c->napi);
+}
+
+static void mlx5e_start_channel(struct mlx5e_channel *c)
+{
+	int tc;
 
 	for (tc = 0; tc < c->num_tc; tc++) {
 		mlx5e_enable_txqsq(&c->sq[tc]);
@@ -2272,7 +2275,7 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_xsk(c);
 }
 
-static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
+static void mlx5e_disable_channel(struct mlx5e_channel *c)
 {
 	int tc;
 
@@ -2285,15 +2288,17 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 		mlx5e_deactivate_xdpsq(&c->rq_xdpsq);
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
-	synchronize_net(); /* Sync with NAPI. */
-	for (tc = 0; tc < c->num_tc; tc++) {
+	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_disable_txqsq(&c->sq[tc]);
-		/* Sync with NAPI to prevent netif_tx_wake_queue. */
-		synchronize_net();
-		mlx5e_stop_txqsq(&c->sq[tc]);
-	}
 	mlx5e_qos_deactivate_queues(c, false);
-	synchronize_net();
+}
+
+static void mlx5e_stop_channel(struct mlx5e_channel *c)
+{
+	int tc;
+
+	for (tc = 0; tc < c->num_tc; tc++)
+		mlx5e_stop_txqsq(&c->sq[tc]);
 	mlx5e_qos_deactivate_queues(c, true);
 	napi_disable(&c->napi);
 }
@@ -2371,11 +2376,15 @@ static void mlx5e_activate_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	for (i = 0; i < chs->num; i++)
-		mlx5e_activate_channel(chs->c[i]);
+	for (i = 0; i < chs->num; i++) {
+		mlx5e_enable_channel(chs->c[i]);
+		mlx5e_start_channel(chs->c[i]);
+	}
 
-	if (chs->ptp)
-		mlx5e_ptp_activate_channel(chs->ptp);
+	if (chs->ptp) {
+		mlx5e_ptp_enable_channel(chs->ptp);
+		mlx5e_ptp_start_channel(chs->ptp);
+	}
 }
 
 #define MLX5E_RQ_WQES_TIMEOUT 20000 /* msecs */
@@ -2403,10 +2412,19 @@ static void mlx5e_deactivate_channels(struct mlx5e_channels *chs)
 	int i;
 
 	if (chs->ptp)
-		mlx5e_ptp_deactivate_channel(chs->ptp);
+		mlx5e_ptp_disable_channel(chs->ptp);
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_disable_channel(chs->c[i]);
+
+	/* Sync with all NAPIs to wait until they stop using queues. */
+	synchronize_net();
+
+	if (chs->ptp)
+		mlx5e_ptp_stop_channel(chs->ptp);
 
 	for (i = 0; i < chs->num; i++)
-		mlx5e_deactivate_channel(chs->c[i]);
+		mlx5e_stop_channel(chs->c[i]);
 }
 
 void mlx5e_close_channels(struct mlx5e_channels *chs)
-- 
2.31.1

