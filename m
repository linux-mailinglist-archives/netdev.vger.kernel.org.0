Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE72CB05B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgLAWnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5337 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLAWnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6cd0000>; Tue, 01 Dec 2020 14:42:21 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:20 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Aya Levin" <ayal@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Allow CQ outside of channel context
Date:   Tue, 1 Dec 2020 14:41:55 -0800
Message-ID: <20201201224208.73295-3-saeedm@nvidia.com>
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
        t=1606862541; bh=gqlTazAz+vJTTsY59aZCb07zgFZkU3u8AbJaJ9zuuVY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=n9t22nj/BWSxCEodPH3lqxkv81raTzCofRZ8N3BkfqVk1BzayDULb+sZYeqEG2BG3
         ZkUPOoBVMSIaFJb4D3YnzqHlD5BlWMTktGPSg81ItcKvo1klWjTkiOKz53abWZbYQJ
         oF0dgaSKqvkj/SxxGkTAb4z2Z3xVyjJinOZ4Sti+EtmYquniRkesY4XIhXDkS6itd7
         4qiiX4yzumFny/0cibCOZZxBzvQJPBp2I+pIOXNc5gRdR5sOW+tpgCh4fmP7b2LSi5
         Ls+NRQBDtrGgsoEqs5C6lFfYLcp+6d7k7hbwEequ902k7jHQS1mRVJqTyLS7sEq8xS
         ajHnlZ/y1SIFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In order to be able to create a CQ outside of a channel context, remove
cq->channel direct pointer. This requires adding a direct pointer to
channel statistics, netdevice, priv and to mlx5_core in order to support
CQs that are a part of mlx5e_channel.
In addition, parameters the were previously derived from the channel
like napi, NUMA node, channel stats and index are now assembled in
struct mlx5e_create_cq_param which is given to mlx5e_open_cq() instead
of channel pointer. Generalizing mlx5e_open_cq() allows opening CQ
outside of channel context which will be used in following patches in
the patch-set.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 16 ++++-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         | 12 +++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 67 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  5 +-
 8 files changed, 73 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 2f05b0f9de01..2d149ab48ce1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -282,10 +282,12 @@ struct mlx5e_cq {
 	u16                        event_ctr;
 	struct napi_struct        *napi;
 	struct mlx5_core_cq        mcq;
-	struct mlx5e_channel      *channel;
+	struct mlx5e_ch_stats     *ch_stats;
=20
 	/* control */
+	struct net_device         *netdev;
 	struct mlx5_core_dev      *mdev;
+	struct mlx5e_priv         *priv;
 	struct mlx5_wq_ctrl        wq_ctrl;
 } ____cacheline_aligned_in_smp;
=20
@@ -923,9 +925,17 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct m=
lx5e_params *params,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
=20
+struct mlx5e_create_cq_param {
+	struct napi_struct *napi;
+	struct mlx5e_ch_stats *ch_stats;
+	int node;
+	int ix;
+};
+
 struct mlx5e_cq_param;
-int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
-		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq);
+int mlx5e_open_cq(struct mlx5e_priv *priv, struct dim_cq_moder moder,
+		  struct mlx5e_cq_param *param, struct mlx5e_create_cq_param *ccp,
+		  struct mlx5e_cq *cq);
 void mlx5e_close_cq(struct mlx5e_cq *cq);
=20
 int mlx5e_open_locked(struct net_device *netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 69a05da0e3e3..c62f5e881377 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -37,13 +37,12 @@ int mlx5e_health_fmsg_named_obj_nest_end(struct devlink=
_fmsg *fmsg)
=20
 int mlx5e_health_cq_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fm=
sg)
 {
-	struct mlx5e_priv *priv =3D cq->channel->priv;
 	u32 out[MLX5_ST_SZ_DW(query_cq_out)] =3D {};
 	u8 hw_status;
 	void *cqc;
 	int err;
=20
-	err =3D mlx5_core_query_cq(priv->mdev, &cq->mcq, out);
+	err =3D mlx5_core_query_cq(cq->mdev, &cq->mcq, out);
 	if (err)
 		return err;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 07ee1d236ab3..ac47efaaebd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -308,7 +308,7 @@ static inline void mlx5e_dump_error_cqe(struct mlx5e_cq=
 *cq, u32 qn,
=20
 	ci =3D mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
=20
-	netdev_err(cq->channel->netdev,
+	netdev_err(cq->netdev,
 		   "Error cqe on cqn 0x%x, ci 0x%x, qn 0x%x, opcode 0x%x, syndrome 0x%x,=
 vendor syndrome 0x%x\n",
 		   cq->mcq.cqn, ci, qn,
 		   get_cqe_opcode((struct mlx5_cqe64 *)err_cqe),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index be3465ba38ca..7703e6553da6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -48,9 +48,15 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e=
_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
 {
+	struct mlx5e_create_cq_param ccp =3D {};
 	struct mlx5e_channel_param *cparam;
 	int err;
=20
+	ccp.napi =3D &c->napi;
+	ccp.ch_stats =3D c->stats;
+	ccp.node =3D cpu_to_node(c->cpu);
+	ccp.ix =3D c->ix;
+
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
 		return -EINVAL;
=20
@@ -60,7 +66,8 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_=
params *params,
=20
 	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
=20
-	err =3D mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rq.cqp, &c->x=
skrq.cq);
+	err =3D mlx5e_open_cq(c->priv, params->rx_cq_moderation, &cparam->rq.cqp,=
 &ccp,
+			    &c->xskrq.cq);
 	if (unlikely(err))
 		goto err_free_cparam;
=20
@@ -68,7 +75,8 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_=
params *params,
 	if (unlikely(err))
 		goto err_close_rx_cq;
=20
-	err =3D mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->xdp_sq.cqp, &=
c->xsksq.cq);
+	err =3D mlx5e_open_cq(c->priv, params->tx_cq_moderation, &cparam->xdp_sq.=
cqp, &ccp,
+			    &c->xsksq.cq);
 	if (unlikely(err))
 		goto err_close_rq;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index aab6b5d7de0a..67995a4ce220 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1515,10 +1515,11 @@ void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 	mlx5e_free_xdpsq(sq);
 }
=20
-static int mlx5e_alloc_cq_common(struct mlx5_core_dev *mdev,
+static int mlx5e_alloc_cq_common(struct mlx5e_priv *priv,
 				 struct mlx5e_cq_param *param,
 				 struct mlx5e_cq *cq)
 {
+	struct mlx5_core_dev *mdev =3D priv->mdev;
 	struct mlx5_core_cq *mcq =3D &cq->mcq;
 	int eqn_not_used;
 	unsigned int irqn;
@@ -1551,25 +1552,27 @@ static int mlx5e_alloc_cq_common(struct mlx5_core_d=
ev *mdev,
 	}
=20
 	cq->mdev =3D mdev;
+	cq->netdev =3D priv->netdev;
+	cq->priv =3D priv;
=20
 	return 0;
 }
=20
-static int mlx5e_alloc_cq(struct mlx5e_channel *c,
+static int mlx5e_alloc_cq(struct mlx5e_priv *priv,
 			  struct mlx5e_cq_param *param,
+			  struct mlx5e_create_cq_param *ccp,
 			  struct mlx5e_cq *cq)
 {
-	struct mlx5_core_dev *mdev =3D c->priv->mdev;
 	int err;
=20
-	param->wq.buf_numa_node =3D cpu_to_node(c->cpu);
-	param->wq.db_numa_node  =3D cpu_to_node(c->cpu);
-	param->eq_ix   =3D c->ix;
+	param->wq.buf_numa_node =3D ccp->node;
+	param->wq.db_numa_node  =3D ccp->node;
+	param->eq_ix            =3D ccp->ix;
=20
-	err =3D mlx5e_alloc_cq_common(mdev, param, cq);
+	err =3D mlx5e_alloc_cq_common(priv, param, cq);
=20
-	cq->napi    =3D &c->napi;
-	cq->channel =3D c;
+	cq->napi     =3D ccp->napi;
+	cq->ch_stats =3D ccp->ch_stats;
=20
 	return err;
 }
@@ -1633,13 +1636,14 @@ static void mlx5e_destroy_cq(struct mlx5e_cq *cq)
 	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
 }
=20
-int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
-		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq)
+int mlx5e_open_cq(struct mlx5e_priv *priv, struct dim_cq_moder moder,
+		  struct mlx5e_cq_param *param, struct mlx5e_create_cq_param *ccp,
+		  struct mlx5e_cq *cq)
 {
-	struct mlx5_core_dev *mdev =3D c->mdev;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int err;
=20
-	err =3D mlx5e_alloc_cq(c, param, cq);
+	err =3D mlx5e_alloc_cq(priv, param, ccp, cq);
 	if (err)
 		return err;
=20
@@ -1665,14 +1669,15 @@ void mlx5e_close_cq(struct mlx5e_cq *cq)
=20
 static int mlx5e_open_tx_cqs(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
+			     struct mlx5e_create_cq_param *ccp,
 			     struct mlx5e_channel_param *cparam)
 {
 	int err;
 	int tc;
=20
 	for (tc =3D 0; tc < c->num_tc; tc++) {
-		err =3D mlx5e_open_cq(c, params->tx_cq_moderation,
-				    &cparam->txq_sq.cqp, &c->sq[tc].cq);
+		err =3D mlx5e_open_cq(c->priv, params->tx_cq_moderation, &cparam->txq_sq=
.cqp,
+				    ccp, &c->sq[tc].cq);
 		if (err)
 			goto err_close_tx_cqs;
 	}
@@ -1812,30 +1817,40 @@ static int mlx5e_open_queues(struct mlx5e_channel *=
c,
 			     struct mlx5e_channel_param *cparam)
 {
 	struct dim_cq_moder icocq_moder =3D {0, 0};
+	struct mlx5e_create_cq_param ccp =3D {};
 	int err;
=20
-	err =3D mlx5e_open_cq(c, icocq_moder, &cparam->icosq.cqp, &c->async_icosq=
.cq);
+	ccp.napi =3D &c->napi;
+	ccp.ch_stats =3D c->stats;
+	ccp.node =3D cpu_to_node(c->cpu);
+	ccp.ix =3D c->ix;
+
+	err =3D mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
+			    &c->async_icosq.cq);
 	if (err)
 		return err;
=20
-	err =3D mlx5e_open_cq(c, icocq_moder, &cparam->async_icosq.cqp, &c->icosq=
.cq);
+	err =3D mlx5e_open_cq(c->priv, icocq_moder, &cparam->async_icosq.cqp, &cc=
p,
+			    &c->icosq.cq);
 	if (err)
 		goto err_close_async_icosq_cq;
=20
-	err =3D mlx5e_open_tx_cqs(c, params, cparam);
+	err =3D mlx5e_open_tx_cqs(c, params, &ccp, cparam);
 	if (err)
 		goto err_close_icosq_cq;
=20
-	err =3D mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->xdp_sq.cqp, &=
c->xdpsq.cq);
+	err =3D mlx5e_open_cq(c->priv, params->tx_cq_moderation, &cparam->xdp_sq.=
cqp, &ccp,
+			    &c->xdpsq.cq);
 	if (err)
 		goto err_close_tx_cqs;
=20
-	err =3D mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rq.cqp, &c->r=
q.cq);
+	err =3D mlx5e_open_cq(c->priv, params->rx_cq_moderation, &cparam->rq.cqp,=
 &ccp,
+			    &c->rq.cq);
 	if (err)
 		goto err_close_xdp_tx_cqs;
=20
-	err =3D c->xdp ? mlx5e_open_cq(c, params->tx_cq_moderation,
-				     &cparam->xdp_sq.cqp, &c->rq_xdpsq.cq) : 0;
+	err =3D c->xdp ? mlx5e_open_cq(c->priv, params->tx_cq_moderation, &cparam=
->xdp_sq.cqp,
+				     &ccp, &c->rq_xdpsq.cq) : 0;
 	if (err)
 		goto err_close_rx_cq;
=20
@@ -3221,14 +3236,16 @@ static int mlx5e_alloc_drop_rq(struct mlx5_core_dev=
 *mdev,
 	return 0;
 }
=20
-static int mlx5e_alloc_drop_cq(struct mlx5_core_dev *mdev,
+static int mlx5e_alloc_drop_cq(struct mlx5e_priv *priv,
 			       struct mlx5e_cq *cq,
 			       struct mlx5e_cq_param *param)
 {
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+
 	param->wq.buf_numa_node =3D dev_to_node(mlx5_core_dma_dev(mdev));
 	param->wq.db_numa_node  =3D dev_to_node(mlx5_core_dma_dev(mdev));
=20
-	return mlx5e_alloc_cq_common(mdev, param, cq);
+	return mlx5e_alloc_cq_common(priv, param, cq);
 }
=20
 int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
@@ -3242,7 +3259,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
=20
 	mlx5e_build_drop_rq_param(priv, &rq_param);
=20
-	err =3D mlx5e_alloc_drop_cq(mdev, cq, &cq_param);
+	err =3D mlx5e_alloc_drop_cq(priv, cq, &cq_param);
 	if (err)
 		return err;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 6628a0197b4e..08163dca15a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -670,13 +670,13 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			sqcc +=3D wi->num_wqebbs;
=20
 			if (last_wqe && unlikely(get_cqe_opcode(cqe) !=3D MLX5_CQE_REQ)) {
-				netdev_WARN_ONCE(cq->channel->netdev,
+				netdev_WARN_ONCE(cq->netdev,
 						 "Bad OP in ICOSQ CQE: 0x%x\n",
 						 get_cqe_opcode(cqe));
 				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
 						     (struct mlx5_err_cqe *)cqe);
 				if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
-					queue_work(cq->channel->priv->wq, &sq->recover_work);
+					queue_work(cq->priv->wq, &sq->recover_work);
 				break;
 			}
=20
@@ -697,7 +697,7 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 				break;
 #endif
 			default:
-				netdev_WARN_ONCE(cq->channel->netdev,
+				netdev_WARN_ONCE(cq->netdev,
 						 "Bad WQE type in ICOSQ WQE info: 0x%x\n",
 						 wi->wqe_type);
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 6dd3ea3cbbed..14af7488cc4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -797,8 +797,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bud=
get)
 				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
 						     (struct mlx5_err_cqe *)cqe);
 				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
-				queue_work(cq->channel->priv->wq,
-					   &sq->recover_work);
+				queue_work(cq->priv->wq, &sq->recover_work);
 			}
 			stats->cqe_err++;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_txrx.c
index d5868670f8a5..1ec3d62f026d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -221,14 +221,13 @@ void mlx5e_completion_event(struct mlx5_core_cq *mcq,=
 struct mlx5_eqe *eqe)
=20
 	napi_schedule(cq->napi);
 	cq->event_ctr++;
-	cq->channel->stats->events++;
+	cq->ch_stats->events++;
 }
=20
 void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event)
 {
 	struct mlx5e_cq *cq =3D container_of(mcq, struct mlx5e_cq, mcq);
-	struct mlx5e_channel *c =3D cq->channel;
-	struct net_device *netdev =3D c->netdev;
+	struct net_device *netdev =3D cq->netdev;
=20
 	netdev_err(netdev, "%s: cqn=3D0x%.6x event=3D0x%.2x\n",
 		   __func__, mcq->cqn, event);
--=20
2.26.2

