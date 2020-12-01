Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC572CB05C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgLAWnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5342 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLAWnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6ce0000>; Tue, 01 Dec 2020 14:42:22 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Aya Levin" <ayal@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Allow RQ outside of channel context
Date:   Tue, 1 Dec 2020 14:41:56 -0800
Message-ID: <20201201224208.73295-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606862542; bh=cXlx1UGIJR/PCC7oLAtH61gN0el4Zhg/V8cpA+PoMtM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=B8JyEJ6Aa+ROMSyfhSfBtm1yqWECDXgz4ymXZTuP2ku2XtOB12lr0hZ7x14puK+w6
         ii5yrVx1Kv/cRhsiogGLs3DS5hdGIPKfge/+8M43mdhgD7mMuiqywXhChkuoxTnzVg
         ZXLPPYn08l7pkE9z1iiAZaFBgUQFJVXpMPwWRYBWsdk+1xlaWu8AvZ2T2s+0FOt+HC
         5tG4oHRf6LE1bRMCKLns0a8L3QBYfBSqfGVPi95+BsOccDOIU3izW7n9P6n3My6y9X
         F4CmXwWPCmo/jXj7f6UC1DBXF7sFKSUGeCJueYdPx5S9b3QEJ55bvtnpSL1JBVgN7C
         ztHgWja4PLE1g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In order to be able to create an RQ outside of a channel context, remove
rq->channel direct pointer. This requires adding a direct pointer to:
ICOSQ and priv in order to support RQs that are part of mlx5e_channel.
Use channel_stats from the corresponding CQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  9 ++--
 .../ethernet/mellanox/mlx5/core/en/health.h   |  3 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       | 50 ++++++++++---------
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 22 ++++----
 7 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 2d149ab48ce1..3dec0731f4da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -595,7 +595,6 @@ struct mlx5e_rq {
 		u8             map_dir;   /* dma map direction */
 	} buff;
=20
-	struct mlx5e_channel  *channel;
 	struct device         *pdev;
 	struct net_device     *netdev;
 	struct mlx5e_rq_stats *stats;
@@ -604,6 +603,8 @@ struct mlx5e_rq {
 	struct mlx5e_page_cache page_cache;
 	struct hwtstamp_config *tstamp;
 	struct mlx5_clock      *clock;
+	struct mlx5e_icosq    *icosq;
+	struct mlx5e_priv     *priv;
=20
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 	mlx5e_fp_post_rx_wqes  post_wqes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index c62f5e881377..e8fc535e6f91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -205,21 +205,22 @@ int mlx5e_health_recover_channels(struct mlx5e_priv *=
priv)
 	return err;
 }
=20
-int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_=
channel *channel)
+int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq=
_comp *eq,
+				    struct mlx5e_ch_stats *stats)
 {
 	u32 eqe_count;
=20
-	netdev_err(channel->netdev, "EQ 0x%x: Cons =3D 0x%x, irqn =3D 0x%x\n",
+	netdev_err(dev, "EQ 0x%x: Cons =3D 0x%x, irqn =3D 0x%x\n",
 		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
=20
 	eqe_count =3D mlx5_eq_poll_irq_disabled(eq);
 	if (!eqe_count)
 		return -EIO;
=20
-	netdev_err(channel->netdev, "Recovered %d eqes on EQ 0x%x\n",
+	netdev_err(dev, "Recovered %d eqes on EQ 0x%x\n",
 		   eqe_count, eq->core.eqn);
=20
-	channel->stats->eq_rearm++;
+	stats->eq_rearm++;
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index b9aadddfd000..48d0232ce654 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -43,7 +43,8 @@ struct mlx5e_err_ctx {
 };
=20
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
-int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_=
channel *channel);
+int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq=
_comp *eq,
+				    struct mlx5e_ch_stats *stats);
 int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
 int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 9913647a1faf..0206e033a271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -146,17 +146,16 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void =
*ctx)
=20
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
-	struct mlx5e_icosq *icosq;
 	struct mlx5_eq_comp *eq;
 	struct mlx5e_rq *rq;
 	int err;
=20
 	rq =3D ctx;
-	icosq =3D &rq->channel->icosq;
 	eq =3D rq->cq.mcq.eq;
-	err =3D mlx5e_health_channel_eq_recover(eq, rq->channel);
-	if (err)
-		clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+
+	err =3D mlx5e_health_channel_eq_recover(rq->netdev, eq, rq->cq.ch_stats);
+	if (err && rq->icosq)
+		clear_bit(MLX5E_SQ_STATE_ENABLED, &rq->icosq->state);
=20
 	return err;
 }
@@ -233,21 +232,13 @@ static int mlx5e_reporter_icosq_diagnose(struct mlx5e=
_icosq *icosq, u8 hw_state,
 static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
-	struct mlx5e_priv *priv =3D rq->channel->priv;
-	struct mlx5e_icosq *icosq;
-	u8 icosq_hw_state;
 	u16 wqe_counter;
 	int wqes_sz;
 	u8 hw_state;
 	u16 wq_head;
 	int err;
=20
-	icosq =3D &rq->channel->icosq;
-	err =3D mlx5e_query_rq_state(priv->mdev, rq->rqn, &hw_state);
-	if (err)
-		return err;
-
-	err =3D mlx5_core_query_sq_state(priv->mdev, icosq->sqn, &icosq_hw_state)=
;
+	err =3D mlx5e_query_rq_state(rq->mdev, rq->rqn, &hw_state);
 	if (err)
 		return err;
=20
@@ -259,7 +250,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(stru=
ct mlx5e_rq *rq,
 	if (err)
 		return err;
=20
-	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->channel->ix);
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->ix);
 	if (err)
 		return err;
=20
@@ -295,9 +286,18 @@ static int mlx5e_rx_reporter_build_diagnose_output(str=
uct mlx5e_rq *rq,
 	if (err)
 		return err;
=20
-	err =3D mlx5e_reporter_icosq_diagnose(icosq, icosq_hw_state, fmsg);
-	if (err)
-		return err;
+	if (rq->icosq) {
+		struct mlx5e_icosq *icosq =3D rq->icosq;
+		u8 icosq_hw_state;
+
+		err =3D mlx5_core_query_sq_state(rq->mdev, icosq->sqn, &icosq_hw_state);
+		if (err)
+			return err;
+
+		err =3D mlx5e_reporter_icosq_diagnose(icosq, icosq_hw_state, fmsg);
+		if (err)
+			return err;
+	}
=20
 	err =3D devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
@@ -557,25 +557,29 @@ static int mlx5e_rx_reporter_dump(struct devlink_heal=
th_reporter *reporter,
=20
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 {
-	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
-	struct mlx5e_priv *priv =3D rq->channel->priv;
+	char icosq_str[MLX5E_REPORTER_PER_Q_MAX_LEN] =3D {};
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_icosq *icosq =3D rq->icosq;
+	struct mlx5e_priv *priv =3D rq->priv;
 	struct mlx5e_err_ctx err_ctx =3D {};
=20
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
+
+	if (icosq)
+		snprintf(icosq_str, sizeof(icosq_str), "ICOSQ: 0x%x, ", icosq->sqn);
 	snprintf(err_str, sizeof(err_str),
-		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
-		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+		 "RX timeout on channel: %d, %sRQ: 0x%x, CQ: 0x%x",
+		 rq->ix, icosq_str, rq->rqn, rq->cq.mcq.cqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
=20
 void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 {
-	struct mlx5e_priv *priv =3D rq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_priv *priv =3D rq->priv;
 	struct mlx5e_err_ctx err_ctx =3D {};
=20
 	err_ctx.ctx =3D rq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 8be6eaa3eeb1..97bfeae17dec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -100,7 +100,7 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	sq =3D to_ctx->sq;
 	eq =3D sq->cq.mcq.eq;
 	priv =3D sq->channel->priv;
-	err =3D mlx5e_health_channel_eq_recover(eq, sq->channel);
+	err =3D mlx5e_health_channel_eq_recover(sq->channel->netdev, eq, sq->chan=
nel->stats);
 	if (!err) {
 		to_ctx->status =3D 0; /* this sq recovered */
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 67995a4ce220..559ef38a6358 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -412,9 +412,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->wq_type =3D params->rq_wq_type;
 	rq->pdev    =3D c->pdev;
 	rq->netdev  =3D c->netdev;
+	rq->priv    =3D c->priv;
 	rq->tstamp  =3D c->tstamp;
 	rq->clock   =3D &mdev->clock;
-	rq->channel =3D c;
+	rq->icosq   =3D &c->icosq;
 	rq->ix      =3D c->ix;
 	rq->mdev    =3D mdev;
 	rq->hw_mtu  =3D MLX5E_SW2HW_MTU(params, params->sw_mtu);
@@ -617,7 +618,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	int i;
=20
 	old_prog =3D rcu_dereference_protected(rq->xdp_prog,
-					     lockdep_is_held(&rq->channel->priv->state_lock));
+					     lockdep_is_held(&rq->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
=20
@@ -717,9 +718,7 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr=
_state, int next_state)
=20
 static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 {
-	struct mlx5e_channel *c =3D rq->channel;
-	struct mlx5e_priv *priv =3D c->priv;
-	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct mlx5_core_dev *mdev =3D rq->mdev;
=20
 	void *in;
 	void *rqc;
@@ -748,8 +747,7 @@ static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq =
*rq, bool enable)
=20
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
-	struct mlx5e_channel *c =3D rq->channel;
-	struct mlx5_core_dev *mdev =3D c->mdev;
+	struct mlx5_core_dev *mdev =3D rq->mdev;
 	void *in;
 	void *rqc;
 	int inlen;
@@ -783,7 +781,6 @@ static void mlx5e_destroy_rq(struct mlx5e_rq *rq)
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 {
 	unsigned long exp_time =3D jiffies + msecs_to_jiffies(wait_time);
-	struct mlx5e_channel *c =3D rq->channel;
=20
 	u16 min_wqes =3D mlx5_min_rx_wqes(rq->wq_type, mlx5e_rqwq_get_size(rq));
=20
@@ -794,8 +791,8 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int=
 wait_time)
 		msleep(20);
 	} while (time_before(jiffies, exp_time));
=20
-	netdev_warn(c->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x=
] wq cur_sz(%d) min_rx_wqes(%d)\n",
-		    c->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
+	netdev_warn(rq->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%=
x] wq cur_sz(%d) min_rx_wqes(%d)\n",
+		    rq->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
=20
 	mlx5e_reporter_rx_timeout(rq);
 	return -ETIMEDOUT;
@@ -910,7 +907,7 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e=
_params *params,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	mlx5e_trigger_irq(&rq->channel->icosq);
+	mlx5e_trigger_irq(rq->icosq);
 }
=20
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
@@ -922,7 +919,7 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
-	cancel_work_sync(&rq->channel->icosq.recover_work);
+	cancel_work_sync(&rq->icosq->recover_work);
 	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
@@ -4411,7 +4408,7 @@ static void mlx5e_rq_replace_xdp_prog(struct mlx5e_rq=
 *rq, struct bpf_prog *prog
 	struct bpf_prog *old_prog;
=20
 	old_prog =3D rcu_replace_pointer(rq->xdp_prog, prog,
-				       lockdep_is_held(&rq->channel->priv->state_lock));
+				       lockdep_is_held(&rq->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 08163dca15a0..5c0015024f62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -503,7 +503,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u1=
6 ix)
 {
 	struct mlx5e_mpw_info *wi =3D &rq->mpwqe.info[ix];
 	struct mlx5e_dma_info *dma_info =3D &wi->umr.dma_info[0];
-	struct mlx5e_icosq *sq =3D &rq->channel->icosq;
+	struct mlx5e_icosq *sq =3D rq->icosq;
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
 	u16 xlt_offset =3D ix << (MLX5E_LOG_ALIGNED_MPWQE_PPW - 1);
@@ -713,9 +713,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
=20
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 {
-	struct mlx5e_icosq *sq =3D &rq->channel->icosq;
 	struct mlx5_wq_ll *wq =3D &rq->mpwqe.wq;
 	u8  umr_completed =3D rq->mpwqe.umr_completed;
+	struct mlx5e_icosq *sq =3D rq->icosq;
 	int alloc_err =3D 0;
 	u8  missing, i;
 	u16 head;
@@ -1218,11 +1218,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, s=
truct mlx5_cqe64 *cqe,
 static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_err_cqe *err_cqe =3D (struct mlx5_err_cqe *)cqe;
+	struct mlx5e_priv *priv =3D rq->priv;
=20
 	if (cqe_syndrome_needs_recover(err_cqe->syndrome) &&
 	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state)) {
 		mlx5e_dump_error_cqe(&rq->cq, rq->rqn, err_cqe);
-		queue_work(rq->channel->priv->wq, &rq->recover_work);
+		queue_work(priv->wq, &rq->recover_work);
 	}
 }
=20
@@ -1771,8 +1772,9 @@ static void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq=
 *rq, struct mlx5_cqe64 *cq
=20
 int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params=
, bool xsk)
 {
+	struct net_device *netdev =3D rq->netdev;
 	struct mlx5_core_dev *mdev =3D rq->mdev;
-	struct mlx5e_channel *c =3D rq->channel;
+	struct mlx5e_priv *priv =3D rq->priv;
=20
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
@@ -1784,15 +1786,15 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, stru=
ct mlx5e_params *params, bool
 		rq->post_wqes =3D mlx5e_post_rx_mpwqes;
 		rq->dealloc_wqe =3D mlx5e_dealloc_rx_mpwqe;
=20
-		rq->handle_rx_cqe =3D c->priv->profile->rx_handlers->handle_rx_cqe_mpwqe=
;
+		rq->handle_rx_cqe =3D priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
 #ifdef CONFIG_MLX5_EN_IPSEC
 		if (MLX5_IPSEC_DEV(mdev)) {
-			netdev_err(c->netdev, "MPWQE RQ with IPSec offload not supported\n");
+			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
 			return -EINVAL;
 		}
 #endif
 		if (!rq->handle_rx_cqe) {
-			netdev_err(c->netdev, "RX handler of MPWQE RQ is not set\n");
+			netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
 			return -EINVAL;
 		}
 		break;
@@ -1807,13 +1809,13 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, stru=
ct mlx5e_params *params, bool
=20
 #ifdef CONFIG_MLX5_EN_IPSEC
 		if ((mlx5_fpga_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_DEVICE) &&
-		    c->priv->ipsec)
+		    priv->ipsec)
 			rq->handle_rx_cqe =3D mlx5e_ipsec_handle_rx_cqe;
 		else
 #endif
-			rq->handle_rx_cqe =3D c->priv->profile->rx_handlers->handle_rx_cqe;
+			rq->handle_rx_cqe =3D priv->profile->rx_handlers->handle_rx_cqe;
 		if (!rq->handle_rx_cqe) {
-			netdev_err(c->netdev, "RX handler of RQ is not set\n");
+			netdev_err(netdev, "RX handler of RQ is not set\n");
 			return -EINVAL;
 		}
 	}
--=20
2.26.2

