Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFE2614C4
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfGGLxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58838 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbfGGLx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:27 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLu031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 07/16] net/mlx5e: Generalize tx reporter's functionality
Date:   Sun,  7 Jul 2019 14:52:59 +0300
Message-Id: <1562500388-16847-8-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Prepare for code sharing with rx reporter, which is added in the
following patches in the set. Introduce a generic error_ctx for
agnostic recovery despatch.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  82 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  15 ++-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 126 ++++-----------------
 4 files changed, 124 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 57d2cc666fe3..23d566a45a30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -23,8 +23,9 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 #
 mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
-		en_selftest.o en/port.o en/monitor_stats.o en/reporter_tx.o \
-		en/params.o en/xsk/umem.o en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
+		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
+		en/reporter_tx.o en/params.o en/xsk/umem.o en/xsk/setup.o \
+		en/xsk/rx.o en/xsk/tx.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
new file mode 100644
index 000000000000..60166e5432ae
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "health.h"
+#include "lib/eq.h"
+
+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
+{
+	struct mlx5_core_dev *mdev = channel->mdev;
+	struct net_device *dev = channel->netdev;
+	struct mlx5e_modify_sq_param msp = {0};
+	int err;
+
+	msp.curr_state = MLX5_SQC_STATE_ERR;
+	msp.next_state = MLX5_SQC_STATE_RST;
+
+	err = mlx5e_modify_sq(mdev, sqn, &msp);
+	if (err) {
+		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sqn);
+		return err;
+	}
+
+	memset(&msp, 0, sizeof(msp));
+	msp.curr_state = MLX5_SQC_STATE_RST;
+	msp.next_state = MLX5_SQC_STATE_RDY;
+
+	err = mlx5e_modify_sq(mdev, sqn, &msp);
+	if (err) {
+		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sqn);
+		return err;
+	}
+
+	return 0;
+}
+
+int mlx5e_health_recover_channels(struct mlx5e_priv *priv)
+{
+	int err = 0;
+
+	rtnl_lock();
+	mutex_lock(&priv->state_lock);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto out;
+
+	err = mlx5e_safe_reopen_channels(priv);
+
+out:
+	mutex_unlock(&priv->state_lock);
+	rtnl_unlock();
+
+	return err;
+}
+
+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel)
+{
+	u32 eqe_count;
+
+	netdev_err(channel->netdev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
+		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
+
+	eqe_count = mlx5_eq_poll_irq_disabled(eq);
+	if (!eqe_count)
+		return -EIO;
+
+	netdev_err(channel->netdev, "Recovered %d eqes on EQ 0x%x\n",
+		   eqe_count, eq->core.eqn);
+
+	channel->stats->eq_rearm++;
+	return 0;
+}
+
+int mlx5e_health_report(struct mlx5e_priv *priv,
+			struct devlink_health_reporter *reporter, char *err_str,
+			struct mlx5e_err_ctx *err_ctx)
+{
+	if (!reporter) {
+		netdev_err(priv->netdev, err_str);
+		return err_ctx->recover(&err_ctx->ctx);
+	}
+	return devlink_health_report(reporter, err_str, err_ctx);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index e3a3bcee89e7..960aa18c425d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -4,7 +4,6 @@
 #ifndef __MLX5E_EN_REPORTER_H
 #define __MLX5E_EN_REPORTER_H
 
-#include <linux/mlx5/driver.h>
 #include "en.h"
 
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
@@ -12,4 +11,18 @@
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
+#define MLX5E_REPORTER_PER_Q_MAX_LEN 256
+
+struct mlx5e_err_ctx {
+	int (*recover)(void *ctx);
+	void *ctx;
+};
+
+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel);
+int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
+int mlx5e_health_report(struct mlx5e_priv *priv,
+			struct devlink_health_reporter *reporter, char *err_str,
+			struct mlx5e_err_ctx *err_ctx);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index d5ecfcfe5d52..3e03a1ac8e5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -2,14 +2,6 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include "health.h"
-#include "lib/eq.h"
-
-#define MLX5E_TX_REPORTER_PER_SQ_MAX_LEN 256
-
-struct mlx5e_tx_err_ctx {
-	int (*recover)(struct mlx5e_txqsq *sq);
-	struct mlx5e_txqsq *sq;
-};
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
@@ -39,37 +31,9 @@ static void mlx5e_reset_txqsq_cc_pc(struct mlx5e_txqsq *sq)
 	sq->pc = 0;
 }
 
-static int mlx5e_sq_to_ready(struct mlx5e_txqsq *sq, int curr_state)
-{
-	struct mlx5_core_dev *mdev = sq->channel->mdev;
-	struct net_device *dev = sq->channel->netdev;
-	struct mlx5e_modify_sq_param msp = {0};
-	int err;
-
-	msp.curr_state = curr_state;
-	msp.next_state = MLX5_SQC_STATE_RST;
-
-	err = mlx5e_modify_sq(mdev, sq->sqn, &msp);
-	if (err) {
-		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sq->sqn);
-		return err;
-	}
-
-	memset(&msp, 0, sizeof(msp));
-	msp.curr_state = MLX5_SQC_STATE_RST;
-	msp.next_state = MLX5_SQC_STATE_RDY;
-
-	err = mlx5e_modify_sq(mdev, sq->sqn, &msp);
-	if (err) {
-		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sq->sqn);
-		return err;
-	}
-
-	return 0;
-}
-
-static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
+static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 {
+	struct mlx5e_txqsq *sq = (struct mlx5e_txqsq *)ctx;
 	struct mlx5_core_dev *mdev = sq->channel->mdev;
 	struct net_device *dev = sq->channel->netdev;
 	u8 state;
@@ -101,7 +65,7 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
 	 * pending WQEs. SQ can safely reset the SQ.
 	 */
 
-	err = mlx5e_sq_to_ready(sq, state);
+	err = mlx5e_health_sq_to_ready(sq->channel, sq->sqn);
 	if (err)
 		return err;
 
@@ -112,104 +76,64 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
 	return 0;
 }
 
-static int mlx5_tx_health_report(struct devlink_health_reporter *tx_reporter,
-				 char *err_str,
-				 struct mlx5e_tx_err_ctx *err_ctx)
-{
-	if (!tx_reporter) {
-		netdev_err(err_ctx->sq->channel->netdev, err_str);
-		return err_ctx->recover(err_ctx->sq);
-	}
-
-	return devlink_health_report(tx_reporter, err_str, err_ctx);
-}
-
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
-	struct mlx5e_tx_err_ctx err_ctx = {0};
+	struct mlx5e_priv *priv = sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {0};
 
-	err_ctx.sq       = sq;
-	err_ctx.recover  = mlx5e_tx_reporter_err_cqe_recover;
+	err_ctx.ctx = sq;
+	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
 	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
 
-	mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
-			      &err_ctx);
+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
 
-static int mlx5e_tx_reporter_timeout_recover(struct mlx5e_txqsq *sq)
+static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 {
+	struct mlx5e_txqsq *sq = (struct mlx5e_txqsq *)ctx;
 	struct mlx5_eq_comp *eq = sq->cq.mcq.eq;
-	u32 eqe_count;
-	int ret;
-
-	netdev_err(sq->channel->netdev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
-		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
+	int err;
 
-	eqe_count = mlx5_eq_poll_irq_disabled(eq);
-	ret = eqe_count ? false : true;
-	if (!eqe_count) {
+	err = mlx5e_health_channel_eq_recover(eq, sq->channel);
+	if (err)
 		clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-		return ret;
-	}
 
-	netdev_err(sq->channel->netdev, "Recover %d eqes on EQ 0x%x\n",
-		   eqe_count, eq->core.eqn);
-	sq->channel->stats->eq_rearm++;
-	return ret;
+	return err;
 }
 
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
-	struct mlx5e_tx_err_ctx err_ctx;
+	struct mlx5e_priv *priv = sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx;
 
-	err_ctx.sq       = sq;
-	err_ctx.recover  = mlx5e_tx_reporter_timeout_recover;
+	err_ctx.ctx = sq;
+	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
 	sprintf(err_str,
 		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
 		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
 		jiffies_to_usecs(jiffies - sq->txq->trans_start));
 
-	return mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
-				     &err_ctx);
+	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
 
 /* state lock cannot be grabbed within this function.
  * It can cause a dead lock or a read-after-free.
  */
-static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_tx_err_ctx *err_ctx)
+static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
 {
-	return err_ctx->recover(err_ctx->sq);
-}
-
-static int mlx5e_tx_reporter_recover_all(struct mlx5e_priv *priv)
-{
-	int err = 0;
-
-	rtnl_lock();
-	mutex_lock(&priv->state_lock);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto out;
-
-	err = mlx5e_safe_reopen_channels(priv);
-
-out:
-	mutex_unlock(&priv->state_lock);
-	rtnl_unlock();
-
-	return err;
+	return err_ctx->recover(err_ctx->ctx);
 }
 
 static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
 				     void *context)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
-	struct mlx5e_tx_err_ctx *err_ctx = context;
+	struct mlx5e_err_ctx *err_ctx = context;
 
 	return err_ctx ? mlx5e_tx_reporter_recover_from_ctx(err_ctx) :
-			 mlx5e_tx_reporter_recover_all(priv);
+			 mlx5e_health_recover_channels(priv);
 }
 
 static int
-- 
1.8.3.1

