Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B447D895
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbhLVVMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbhLVVMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581DFC061401
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 13:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF26661D11
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECE1C36AEA;
        Wed, 22 Dec 2021 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207529;
        bh=DNTKK2Sits0SHSiG4cPrxPAMesY8ncGvwZWZGMCzI+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1YLaTqP75InX/bgpiKhKni8qQHFAMHEjNk5otdQ8u0gocR31sstod2CusTaJO0lN
         wAHTE5bnjrqSq5Z3VCTwmO75NG4Z3ZelHTDMieWPKlVv7FZ2WzaUREZjwj+LHvjnAI
         qw/S6JqC3dOnX+y4gifnsfd+bmBapI/0XJPOagW9UXFImM20g+VywEOUpKM+pARrCV
         gSZ+JBFMpRfve2DPZdW/XMmkDRuZZBRMAnVSr3sppPa8qifWZ4NQGa9uiSyPNug0Rc
         hoJmjmC7T+p/x8wSZIVeOo1zyFTszWSJAmil9rmaRiZqo/qKlow1REzeltFjeawhwh
         t2IMuzgY+0lDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/11] net/mlx5e: Fix interoperability between XSK and ICOSQ recovery flow
Date:   Wed, 22 Dec 2021 13:11:59 -0800
Message-Id: <20211222211201.77469-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Both regular RQ and XSKRQ use the same ICOSQ for UMRs. When doing
recovery for the ICOSQ, don't forget to deactivate XSKRQ.

XSK can be opened and closed while channels are active, so a new mutex
prevents the ICOSQ recovery from running at the same time. The ICOSQ
recovery deactivates and reactivates XSKRQ, so any parallel change in
XSK state would break consistency. As the regular RQ is running, it's
not enough to just flush the recovery work, because it can be
rescheduled.

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
 .../ethernet/mellanox/mlx5/core/en/health.h   |  2 ++
 .../mellanox/mlx5/core/en/reporter_rx.c       | 35 ++++++++++++++++++-
 .../mellanox/mlx5/core/en/xsk/setup.c         | 16 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 ++--
 5 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f0ac6b0d9653..f42067adc79d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -783,6 +783,8 @@ struct mlx5e_channel {
 	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
 	int                        ix;
 	int                        cpu;
+	/* Sync between icosq recovery and XSK enable/disable. */
+	struct mutex               icosq_recovery_lock;
 };
 
 struct mlx5e_ptp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index d5b7110a4265..0107e4e73bb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -30,6 +30,8 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
 void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq);
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
+void mlx5e_reporter_icosq_suspend_recovery(struct mlx5e_channel *c);
+void mlx5e_reporter_icosq_resume_recovery(struct mlx5e_channel *c);
 
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 74086eb556ae..2684e9da9f41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -62,6 +62,7 @@ static void mlx5e_reset_icosq_cc_pc(struct mlx5e_icosq *icosq)
 
 static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 {
+	struct mlx5e_rq *xskrq = NULL;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_icosq *icosq;
 	struct net_device *dev;
@@ -70,7 +71,13 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	int err;
 
 	icosq = ctx;
+
+	mutex_lock(&icosq->channel->icosq_recovery_lock);
+
+	/* mlx5e_close_rq cancels this work before RQ and ICOSQ are killed. */
 	rq = &icosq->channel->rq;
+	if (test_bit(MLX5E_RQ_STATE_ENABLED, &icosq->channel->xskrq.state))
+		xskrq = &icosq->channel->xskrq;
 	mdev = icosq->channel->mdev;
 	dev = icosq->channel->netdev;
 	err = mlx5_core_query_sq_state(mdev, icosq->sqn, &state);
@@ -84,6 +91,9 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		goto out;
 
 	mlx5e_deactivate_rq(rq);
+	if (xskrq)
+		mlx5e_deactivate_rq(xskrq);
+
 	err = mlx5e_wait_for_icosq_flush(icosq);
 	if (err)
 		goto out;
@@ -97,15 +107,28 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		goto out;
 
 	mlx5e_reset_icosq_cc_pc(icosq);
+
 	mlx5e_free_rx_in_progress_descs(rq);
+	if (xskrq)
+		mlx5e_free_rx_in_progress_descs(xskrq);
+
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
 	mlx5e_activate_icosq(icosq);
-	mlx5e_activate_rq(rq);
 
+	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
+
+	if (xskrq) {
+		mlx5e_activate_rq(xskrq);
+		xskrq->stats->recover++;
+	}
+
+	mutex_unlock(&icosq->channel->icosq_recovery_lock);
+
 	return 0;
 out:
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
+	mutex_unlock(&icosq->channel->icosq_recovery_lock);
 	return err;
 }
 
@@ -706,6 +729,16 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
 
+void mlx5e_reporter_icosq_suspend_recovery(struct mlx5e_channel *c)
+{
+	mutex_lock(&c->icosq_recovery_lock);
+}
+
+void mlx5e_reporter_icosq_resume_recovery(struct mlx5e_channel *c)
+{
+	mutex_unlock(&c->icosq_recovery_lock);
+}
+
 static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 	.name = "rx",
 	.recover = mlx5e_rx_reporter_recover,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 538bc2419bd8..8526a5fbbf0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -4,6 +4,7 @@
 #include "setup.h"
 #include "en/params.h"
 #include "en/txrx.h"
+#include "en/health.h"
 
 /* It matches XDP_UMEM_MIN_CHUNK_SIZE, but as this constant is private and may
  * change unexpectedly, and mlx5e has a minimum valid stride size for striding
@@ -170,7 +171,13 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
+	/* ICOSQ recovery deactivates RQs. Suspend the recovery to avoid
+	 * activating XSKRQ in the middle of recovery.
+	 */
+	mlx5e_reporter_icosq_suspend_recovery(c);
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
+	mlx5e_reporter_icosq_resume_recovery(c);
+
 	/* TX queue is created active. */
 
 	spin_lock_bh(&c->async_icosq_lock);
@@ -180,6 +187,13 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 {
-	mlx5e_deactivate_rq(&c->xskrq);
+	/* ICOSQ recovery may reactivate XSKRQ if clear_bit is called in the
+	 * middle of recovery. Suspend the recovery to avoid it.
+	 */
+	mlx5e_reporter_icosq_suspend_recovery(c);
+	clear_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
+	mlx5e_reporter_icosq_resume_recovery(c);
+	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
+
 	/* TX queue is disabled on close. */
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..a572fc9690ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1087,8 +1087,6 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
-	if (rq->icosq)
-		cancel_work_sync(&rq->icosq->recover_work);
 	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
@@ -2088,6 +2086,8 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_xdpsq_cq;
 
+	mutex_init(&c->icosq_recovery_lock);
+
 	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
 	if (err)
 		goto err_close_async_icosq;
@@ -2156,9 +2156,12 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	mlx5e_close_xdpsq(&c->xdpsq);
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
+	/* The same ICOSQ is used for UMRs for both RQ and XSKRQ. */
+	cancel_work_sync(&c->icosq.recover_work);
 	mlx5e_close_rq(&c->rq);
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
+	mutex_destroy(&c->icosq_recovery_lock);
 	mlx5e_close_icosq(&c->async_icosq);
 	if (c->xdp)
 		mlx5e_close_cq(&c->rq_xdpsq.cq);
-- 
2.33.1

