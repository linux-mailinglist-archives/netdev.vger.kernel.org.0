Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B25614CA
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfGGLx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58930 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727013AbfGGLx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:56 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:20 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJM3031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 14/16] net/mlx5e: Recover from rx timeout
Date:   Sun,  7 Jul 2019 14:53:06 +0300
Message-Id: <1562500388-16847-15-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for recovery from rx timeout. On driver open we post NOP
work request on the rx channels to trigger napi in order to fillup the
rx rings. In case napi wasn't scheduled due to a lost interrupt, perform
EQ recovery.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 30 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 +
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index e8c5d3bd86f1..aa46f7ecae53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -19,6 +19,7 @@
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
 
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index c47e9a53bd53..7e7dba129330 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -109,6 +109,36 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
 
+static int mlx5e_rx_reporter_timeout_recover(void *ctx)
+{
+	struct mlx5e_rq *rq = (struct mlx5e_rq *)ctx;
+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
+	struct mlx5_eq_comp *eq = rq->cq.mcq.eq;
+	int err;
+
+	err = mlx5e_health_channel_eq_recover(eq, rq->channel);
+	if (err)
+		clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+
+	return err;
+}
+
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
+{
+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
+	struct mlx5e_priv *priv = rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = rq;
+	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
+	sprintf(err_str,
+		"RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
+		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
 {
 	return err_ctx->recover(err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2d57611ac579..1ebdeccf395d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -809,6 +809,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 	netdev_warn(c->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x] wq cur_sz(%d) min_rx_wqes(%d)\n",
 		    c->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
 
+	mlx5e_reporter_rx_timeout(rq);
 	return -ETIMEDOUT;
 }
 
-- 
1.8.3.1

