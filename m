Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496E2CB05D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgLAWnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15919 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLAWnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6cf0001>; Tue, 01 Dec 2020 14:42:23 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:22 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Allow SQ outside of channel context
Date:   Tue, 1 Dec 2020 14:41:57 -0800
Message-ID: <20201201224208.73295-5-saeedm@nvidia.com>
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
        t=1606862543; bh=Hq+bjzfxYE+pMggRNHoxKac5M3y0VQLBIIBQ2VkDi7U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fWajvak4Dnk+HSo7+rN6rNxlK79Z7WzYOGnYe5ufAJgv8aC+PHkAHCy/0H1CZx96K
         PAug2JAiNEjrFOhQPSkxGjAsX55VMQ2hc7mUeAUzkw1Phj876qHZtzB1C66fzY9kEJ
         VXdh0u0ACuqtbE4Xjqel1OWoz8lfSB6Ygsa8UQ3Q+nfBcLfJFOaJixIvdNtAs53VMr
         LV+iyrYf34l+Ny7EsuSGSLrRSpgcFBTpF2igCCoyW1w1hgsDr/jSv2YhW+Po1LSCIx
         9DArEonvSVOrjW9D3/DgLgIQtnjFE4Bumfb5nQ4p9R8x6/QobwecJHnUjQ9fN/ZHVR
         oH3sc4+rgBVXg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

In order to be able to create an SQ outside of a channel context, remove
sq->channel direct pointer. This requires adding a direct pointer to:
netdevice, priv and mlx5_core in order to support SQs that are part of
mlx5e_channel. Use channel_stats from the corresponding CQ.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +++-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  4 +---
 .../ethernet/mellanox/mlx5/core/en/health.h   |  2 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       | 20 +++++++++----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++++----
 7 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 3dec0731f4da..c014e8ff66aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -369,10 +369,12 @@ struct mlx5e_txqsq {
 	unsigned int               hw_mtu;
 	struct hwtstamp_config    *tstamp;
 	struct mlx5_clock         *clock;
+	struct net_device         *netdev;
+	struct mlx5_core_dev      *mdev;
+	struct mlx5e_priv         *priv;
=20
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
-	struct mlx5e_channel      *channel;
 	int                        ch_ix;
 	int                        txq_ix;
 	u32                        rate_limit;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index e8fc535e6f91..718f8c0a4f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -157,10 +157,8 @@ void mlx5e_health_channels_update(struct mlx5e_priv *p=
riv)
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
 }
=20
-int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
+int mlx5e_health_sq_to_ready(struct mlx5_core_dev *mdev, struct net_device=
 *dev, u32 sqn)
 {
-	struct mlx5_core_dev *mdev =3D channel->mdev;
-	struct net_device *dev =3D channel->netdev;
 	struct mlx5e_modify_sq_param msp =3D {};
 	int err;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 48d0232ce654..f88fbbe06995 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -42,7 +42,7 @@ struct mlx5e_err_ctx {
 	void *ctx;
 };
=20
-int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
+int mlx5e_health_sq_to_ready(struct mlx5_core_dev *mdev, struct net_device=
 *dev, u32 sqn);
 int mlx5e_health_channel_eq_recover(struct net_device *dev, struct mlx5_eq=
_comp *eq,
 				    struct mlx5e_ch_stats *stats);
 int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 0206e033a271..d80bbd17e5f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -87,7 +87,7 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *=
ctx)
=20
 	/* At this point, both the rq and the icosq are disabled */
=20
-	err =3D mlx5e_health_sq_to_ready(icosq->channel, icosq->sqn);
+	err =3D mlx5e_health_sq_to_ready(mdev, dev, icosq->sqn);
 	if (err)
 		goto out;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 97bfeae17dec..88b3b21d1068 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -15,7 +15,7 @@ static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq=
)
 		msleep(20);
 	}
=20
-	netdev_err(sq->channel->netdev,
+	netdev_err(sq->netdev,
 		   "Wait for SQ 0x%x flush timeout (sq cc =3D 0x%x, sq pc =3D 0x%x)\n",
 		   sq->sqn, sq->cc, sq->pc);
=20
@@ -41,8 +41,8 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	int err;
=20
 	sq =3D ctx;
-	mdev =3D sq->channel->mdev;
-	dev =3D sq->channel->netdev;
+	mdev =3D sq->mdev;
+	dev =3D sq->netdev;
=20
 	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 		return 0;
@@ -68,7 +68,7 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	 * pending WQEs. SQ can safely reset the SQ.
 	 */
=20
-	err =3D mlx5e_health_sq_to_ready(sq->channel, sq->sqn);
+	err =3D mlx5e_health_sq_to_ready(mdev, dev, sq->sqn);
 	if (err)
 		goto out;
=20
@@ -99,8 +99,8 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	to_ctx =3D ctx;
 	sq =3D to_ctx->sq;
 	eq =3D sq->cq.mcq.eq;
-	priv =3D sq->channel->priv;
-	err =3D mlx5e_health_channel_eq_recover(sq->channel->netdev, eq, sq->chan=
nel->stats);
+	priv =3D sq->priv;
+	err =3D mlx5e_health_channel_eq_recover(sq->netdev, eq, sq->cq.ch_stats);
 	if (!err) {
 		to_ctx->status =3D 0; /* this sq recovered */
 		return err;
@@ -144,8 +144,8 @@ static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
 					struct mlx5e_txqsq *sq, int tc)
 {
-	struct mlx5e_priv *priv =3D sq->channel->priv;
 	bool stopped =3D netif_xmit_stopped(sq->txq);
+	struct mlx5e_priv *priv =3D sq->priv;
 	u8 state;
 	int err;
=20
@@ -396,8 +396,8 @@ static int mlx5e_tx_reporter_dump(struct devlink_health=
_reporter *reporter,
=20
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_priv *priv =3D sq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_priv *priv =3D sq->priv;
 	struct mlx5e_err_ctx err_ctx =3D {};
=20
 	err_ctx.ctx =3D sq;
@@ -410,9 +410,9 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
=20
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_priv *priv =3D sq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
 	struct mlx5e_tx_timeout_ctx to_ctx =3D {};
+	struct mlx5e_priv *priv =3D sq->priv;
 	struct mlx5e_err_ctx err_ctx =3D {};
=20
 	to_ctx.sq =3D sq;
@@ -421,7 +421,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
 	snprintf(err_str, sizeof(err_str),
 		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x=
%x, usecs since last trans: %u",
-		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 sq->ch_ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
 		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
=20
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index f51c04284e4d..2b51d3222ca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -276,7 +276,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev,=
 struct mlx5e_txqsq *sq,
 	if (WARN_ON_ONCE(tls_ctx->netdev !=3D netdev))
 		goto err_out;
=20
-	if (mlx5_accel_is_ktls_tx(sq->channel->mdev))
+	if (mlx5_accel_is_ktls_tx(sq->mdev))
 		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
=20
 	/* FPGA */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 559ef38a6358..38506b8b6f82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1132,7 +1132,9 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->tstamp    =3D c->tstamp;
 	sq->clock     =3D &mdev->clock;
 	sq->mkey_be   =3D c->mkey_be;
-	sq->channel   =3D c;
+	sq->netdev    =3D c->netdev;
+	sq->mdev      =3D c->mdev;
+	sq->priv      =3D c->priv;
 	sq->ch_ix     =3D c->ix;
 	sq->txq_ix    =3D txq_ix;
 	sq->uar_map   =3D mdev->mlx5e_res.bfreg.map;
@@ -1332,7 +1334,7 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
=20
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
-	sq->txq =3D netdev_get_tx_queue(sq->channel->netdev, sq->txq_ix);
+	sq->txq =3D netdev_get_tx_queue(sq->netdev, sq->txq_ix);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
@@ -1370,8 +1372,7 @@ static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq=
 *sq)
=20
 static void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_channel *c =3D sq->channel;
-	struct mlx5_core_dev *mdev =3D c->mdev;
+	struct mlx5_core_dev *mdev =3D sq->mdev;
 	struct mlx5_rate_limit rl =3D {0};
=20
 	cancel_work_sync(&sq->dim.work);
--=20
2.26.2

