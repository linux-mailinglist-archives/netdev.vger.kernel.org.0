Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7402CB062
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLAWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:11 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15928 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgLAWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d30000>; Tue, 01 Dec 2020 14:42:27 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Add TX PTP port object support
Date:   Tue, 1 Dec 2020 14:42:01 -0800
Message-ID: <20201201224208.73295-9-saeedm@nvidia.com>
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
        t=1606862547; bh=E3TRMOekSNh56mnxnTOhZgImjdAl2yE8/w0g0fTQBLU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=cis1Wq60e+9o09SUGZcZ5j3WYfe6Dw14FQ+YLCCc3/J5i79ErHHdhMKhQKBhBln/b
         QX4uo5Du/znVC2C3jshvyEkJsQ1A5/h+zmUNLFQSNe8c8jZYOZyglhrdyTm308rk79
         BsJ0cWJjvfBe0QezIJPfBcTQDCfvMTUUeZ0kYmeaeOvGZDOOPRPCKCvef80I1QaAmm
         59NAbT3iTSG48gk01ohDpiMQKZF/+3xDbU7FqcjY1nbNhoX0AmG5cNKQEkqDQzfcv5
         GYB+dzS6c4NAPrBKcv5wjGfR41n65C0DnaZu9Ksih7vL9TxfvBWrqT6yT59yJKDNwZ
         +o6z1AiakIyxg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

Add TX PTP port object support for better TX timestamping accuracy.
Currently, driver supports CQE based TX port timestamp. Device
also offers TX port timestamp, which has less jitter and better
reflects the actual time of a packet's transmit.

Define new driver layout called ptpsq, on which driver will create
SQs that will support TX port timestamp for their transmitted packets.
Driver to identify PTP TX skbs and steer them to these dedicated SQs
as part of the select queue ndo.

Driver to hold ptpsq per TC and report them at
netif_set_real_num_tx_queues().

Add support for all needed functionality in order to xmit and poll
completions received via ptpsq.

Add ptpsq to the TX reporter recover, diagnose and dump methods.

Creation of ptpsqs is disabled by default, and can be enabled via
tx_port_ts private flag.

This patch steer all timestamp related packets to a ptpsq, but it
does not open the port timestamp support for it. The support will
be added in the following patch.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  29 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   8 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 360 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  48 +++
 .../mellanox/mlx5/core/en/reporter_tx.c       | 166 ++++++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  33 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  82 ++--
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  96 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  56 ++-
 11 files changed, 823 insertions(+), 60 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 83a67ca43a41..77961643d5a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -25,7 +25,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) +=3D en_main.o en_common=
.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o
=20
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 7f3bd3d406b3..6864c79d2d9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -227,6 +227,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
 	MLX5E_PFLAG_XDP_TX_MPWQE,
 	MLX5E_PFLAG_SKB_TX_MPWQE,
+	MLX5E_PFLAG_TX_PORT_TS,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
=20
@@ -338,6 +339,8 @@ struct mlx5e_skb_fifo {
 	u16 mask;
 };
=20
+struct mlx5e_ptpsq;
+
 struct mlx5e_txqsq {
 	/* data path */
=20
@@ -385,6 +388,7 @@ struct mlx5e_txqsq {
 	int                        txq_ix;
 	u32                        rate_limit;
 	struct work_struct         recover_work;
+	struct mlx5e_ptpsq        *ptpsq;
 } ____cacheline_aligned_in_smp;
=20
 struct mlx5e_dma_info {
@@ -692,8 +696,11 @@ struct mlx5e_channel {
 	int                        cpu;
 };
=20
+struct mlx5e_port_ptp;
+
 struct mlx5e_channels {
 	struct mlx5e_channel **c;
+	struct mlx5e_port_ptp  *port_ptp;
 	unsigned int           num;
 	struct mlx5e_params    params;
 };
@@ -708,6 +715,11 @@ struct mlx5e_channel_stats {
 	struct mlx5e_xdpsq_stats xsksq;
 } ____cacheline_aligned_in_smp;
=20
+struct mlx5e_port_ptp_stats {
+	struct mlx5e_ch_stats ch;
+	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
+} ____cacheline_aligned_in_smp;
+
 enum {
 	MLX5E_STATE_OPENED,
 	MLX5E_STATE_DESTROYING,
@@ -777,8 +789,10 @@ struct mlx5e_scratchpad {
=20
 struct mlx5e_priv {
 	/* priv data path fields - start */
-	struct mlx5e_txqsq *txq2sq[MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC];
+	/* +1 for port ptp ts */
+	struct mlx5e_txqsq *txq2sq[(MLX5E_MAX_NUM_CHANNELS + 1) * MLX5E_MAX_NUM_T=
C];
 	int channel_tc2realtxq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
+	int port_ptp_tc2realtxq[MLX5E_MAX_NUM_TC];
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx_dp       dcbx_dp;
 #endif
@@ -813,12 +827,15 @@ struct mlx5e_priv {
 	struct net_device         *netdev;
 	struct mlx5e_stats         stats;
 	struct mlx5e_channel_stats channel_stats[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_port_ptp_stats port_ptp_stats;
 	u16                        max_nch;
 	u8                         max_opened_tc;
+	bool                       port_ptp_opened;
 	struct hwtstamp_config     tstamp;
 	u16                        q_counter;
 	u16                        drop_rq_q_counter;
 	struct notifier_block      events_nb;
+	int                        num_tc_x_num_ch;
=20
 	struct udp_tunnel_nic_info nic_info;
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -993,7 +1010,17 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq=
);
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_tx_disable_queue(struct netdev_queue *txq);
+int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa);
+void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq);
+struct mlx5e_create_sq_param;
+int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
+			struct mlx5e_sq_param *param,
+			struct mlx5e_create_sq_param *csp,
+			u32 *sqn);
+void mlx5e_tx_err_cqe_work(struct work_struct *recover_work);
=20
 static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.h
index 187007ad3349..70e463712b7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -41,6 +41,14 @@ struct mlx5e_channel_param {
 	struct mlx5e_sq_param      async_icosq;
 };
=20
+struct mlx5e_create_sq_param {
+	struct mlx5_wq_ctrl        *wq_ctrl;
+	u32                         cqn;
+	u32                         tisn;
+	u8                          tis_lst_sz;
+	u8                          min_inline_mode;
+};
+
 static inline bool mlx5e_qid_get_ch_if_in_group(struct mlx5e_params *param=
s,
 						u16 qid,
 						enum mlx5e_rq_group group,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/ptp.c
new file mode 100644
index 000000000000..8639b5104df7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies
+
+#include "en/ptp.h"
+#include "en/txrx.h"
+#include "lib/clock.h"
+
+static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct mlx5e_port_ptp *c =3D container_of(napi, struct mlx5e_port_ptp,
+						napi);
+	struct mlx5e_ch_stats *ch_stats =3D c->stats;
+	bool busy =3D false;
+	int work_done =3D 0;
+	int i;
+
+	rcu_read_lock();
+
+	ch_stats->poll++;
+
+	for (i =3D 0; i < c->num_tc; i++)
+		busy |=3D mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
+
+	if (busy) {
+		work_done =3D budget;
+		goto out;
+	}
+
+	if (unlikely(!napi_complete_done(napi, work_done)))
+		goto out;
+
+	ch_stats->arm++;
+
+	for (i =3D 0; i < c->num_tc; i++)
+		mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
+
+out:
+	rcu_read_unlock();
+
+	return work_done;
+}
+
+static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
+				 struct mlx5e_params *params,
+				 struct mlx5e_sq_param *param,
+				 struct mlx5e_txqsq *sq, int tc,
+				 struct mlx5e_ptpsq *ptpsq)
+{
+	void *sqc_wq               =3D MLX5_ADDR_OF(sqc, param->sqc, wq);
+	struct mlx5_core_dev *mdev =3D c->mdev;
+	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	int err;
+	int node;
+
+	sq->pdev      =3D c->pdev;
+	sq->tstamp    =3D c->tstamp;
+	sq->clock     =3D &mdev->clock;
+	sq->mkey_be   =3D c->mkey_be;
+	sq->netdev    =3D c->netdev;
+	sq->priv      =3D c->priv;
+	sq->mdev      =3D mdev;
+	sq->ch_ix     =3D c->ix;
+	sq->txq_ix    =3D txq_ix;
+	sq->uar_map   =3D mdev->mlx5e_res.bfreg.map;
+	sq->min_inline_mode =3D params->tx_min_inline_mode;
+	sq->hw_mtu    =3D MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->stats     =3D &c->priv->port_ptp_stats.sq[tc];
+	sq->ptpsq     =3D ptpsq;
+	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
+	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
+		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
+	sq->stop_room =3D param->stop_room;
+
+	node =3D dev_to_node(mlx5_core_dma_dev(mdev));
+
+	param->wq.db_numa_node =3D node;
+	err =3D mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
+	if (err)
+		return err;
+	wq->db    =3D &wq->db[MLX5_SND_DBR];
+
+	err =3D mlx5e_alloc_txqsq_db(sq, node);
+	if (err)
+		goto err_sq_wq_destroy;
+
+	return 0;
+
+err_sq_wq_destroy:
+	mlx5_wq_destroy(&sq->wq_ctrl);
+
+	return err;
+}
+
+static void mlx5e_ptp_destroy_sq(struct mlx5_core_dev *mdev, u32 sqn)
+{
+	mlx5_core_destroy_sq(mdev, sqn);
+}
+
+static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
+				int txq_ix, struct mlx5e_ptp_params *cparams,
+				int tc, struct mlx5e_ptpsq *ptpsq)
+{
+	struct mlx5e_sq_param *sqp =3D &cparams->txq_sq_param;
+	struct mlx5e_txqsq *txqsq =3D &ptpsq->txqsq;
+	struct mlx5e_create_sq_param csp =3D {};
+	int err;
+
+	err =3D mlx5e_ptp_alloc_txqsq(c, txq_ix, &cparams->params, sqp,
+				    txqsq, tc, ptpsq);
+	if (err)
+		return err;
+
+	csp.tisn            =3D tisn;
+	csp.tis_lst_sz      =3D 1;
+	csp.cqn             =3D txqsq->cq.mcq.cqn;
+	csp.wq_ctrl         =3D &txqsq->wq_ctrl;
+	csp.min_inline_mode =3D txqsq->min_inline_mode;
+
+	err =3D mlx5e_create_sq_rdy(c->mdev, sqp, &csp, &txqsq->sqn);
+	if (err)
+		goto err_free_txqsq;
+
+	return 0;
+
+err_free_txqsq:
+	mlx5e_free_txqsq(txqsq);
+
+	return err;
+}
+
+static void mlx5e_ptp_close_txqsq(struct mlx5e_ptpsq *ptpsq)
+{
+	struct mlx5e_txqsq *sq =3D &ptpsq->txqsq;
+	struct mlx5_core_dev *mdev =3D sq->mdev;
+
+	cancel_work_sync(&sq->recover_work);
+	mlx5e_ptp_destroy_sq(mdev, sq->sqn);
+	mlx5e_free_txqsq_descs(sq);
+	mlx5e_free_txqsq(sq);
+}
+
+static int mlx5e_ptp_open_txqsqs(struct mlx5e_port_ptp *c,
+				 struct mlx5e_ptp_params *cparams)
+{
+	struct mlx5e_params *params =3D &cparams->params;
+	int ix_base;
+	int err;
+	int tc;
+
+	ix_base =3D params->num_tc * params->num_channels;
+
+	for (tc =3D 0; tc < params->num_tc; tc++) {
+		int txq_ix =3D ix_base + tc;
+
+		err =3D mlx5e_ptp_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
+					   cparams, tc, &c->ptpsq[tc]);
+		if (err)
+			goto close_txqsq;
+	}
+
+	return 0;
+
+close_txqsq:
+	for (--tc; tc >=3D 0; tc--)
+		mlx5e_ptp_close_txqsq(&c->ptpsq[tc]);
+
+	return err;
+}
+
+static void mlx5e_ptp_close_txqsqs(struct mlx5e_port_ptp *c)
+{
+	int tc;
+
+	for (tc =3D 0; tc < c->num_tc; tc++)
+		mlx5e_ptp_close_txqsq(&c->ptpsq[tc]);
+}
+
+static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c,
+			      struct mlx5e_ptp_params *cparams)
+{
+	struct mlx5e_params *params =3D &cparams->params;
+	struct mlx5e_create_cq_param ccp =3D {};
+	struct dim_cq_moder ptp_moder =3D {};
+	struct mlx5e_cq_param *cq_param;
+	int err;
+	int tc;
+
+	ccp.node     =3D dev_to_node(mlx5_core_dma_dev(c->mdev));
+	ccp.ch_stats =3D c->stats;
+	ccp.napi     =3D &c->napi;
+	ccp.ix       =3D c->ix;
+
+	cq_param =3D &cparams->txq_sq_param.cqp;
+
+	for (tc =3D 0; tc < params->num_tc; tc++) {
+		struct mlx5e_cq *cq =3D &c->ptpsq[tc].txqsq.cq;
+
+		err =3D mlx5e_open_cq(c->priv, ptp_moder, cq_param, &ccp, cq);
+		if (err)
+			goto out_err_txqsq_cq;
+	}
+
+	return 0;
+
+out_err_txqsq_cq:
+	for (--tc; tc >=3D 0; tc--)
+		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
+
+	return err;
+}
+
+static void mlx5e_ptp_close_cqs(struct mlx5e_port_ptp *c)
+{
+	int tc;
+
+	for (tc =3D 0; tc < c->num_tc; tc++)
+		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
+}
+
+static void mlx5e_ptp_build_sq_param(struct mlx5e_priv *priv,
+				     struct mlx5e_params *params,
+				     struct mlx5e_sq_param *param)
+{
+	void *sqc =3D param->sqc;
+	void *wq;
+
+	mlx5e_build_sq_param_common(priv, param);
+
+	wq =3D MLX5_ADDR_OF(sqc, sqc, wq);
+	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
+	param->stop_room =3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+}
+
+static void mlx5e_ptp_build_params(struct mlx5e_port_ptp *c,
+				   struct mlx5e_ptp_params *cparams,
+				   struct mlx5e_params *orig)
+{
+	struct mlx5e_params *params =3D &cparams->params;
+
+	params->tx_min_inline_mode =3D orig->tx_min_inline_mode;
+	params->num_channels =3D orig->num_channels;
+	params->hard_mtu =3D orig->hard_mtu;
+	params->sw_mtu =3D orig->sw_mtu;
+	params->num_tc =3D orig->num_tc;
+
+	/* SQ */
+	params->log_sq_size =3D orig->log_sq_size;
+
+	mlx5e_ptp_build_sq_param(c->priv, params, &cparams->txq_sq_param);
+}
+
+static int mlx5e_ptp_open_queues(struct mlx5e_port_ptp *c,
+				 struct mlx5e_ptp_params *cparams)
+{
+	int err;
+
+	err =3D mlx5e_ptp_open_cqs(c, cparams);
+	if (err)
+		return err;
+
+	napi_enable(&c->napi);
+
+	err =3D mlx5e_ptp_open_txqsqs(c, cparams);
+	if (err)
+		goto disable_napi;
+
+	return 0;
+
+disable_napi:
+	napi_disable(&c->napi);
+	mlx5e_ptp_close_cqs(c);
+
+	return err;
+}
+
+static void mlx5e_ptp_close_queues(struct mlx5e_port_ptp *c)
+{
+	mlx5e_ptp_close_txqsqs(c);
+	napi_disable(&c->napi);
+	mlx5e_ptp_close_cqs(c);
+}
+
+int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *para=
ms,
+			u8 lag_port, struct mlx5e_port_ptp **cp)
+{
+	struct net_device *netdev =3D priv->netdev;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct mlx5e_ptp_params *cparams;
+	struct mlx5e_port_ptp *c;
+	unsigned int irq;
+	int err;
+	int eqn;
+
+	err =3D mlx5_vector2eqn(priv->mdev, 0, &eqn, &irq);
+	if (err)
+		return err;
+
+	c =3D kvzalloc_node(sizeof(*c), GFP_KERNEL, dev_to_node(mlx5_core_dma_dev=
(mdev)));
+	cparams =3D kvzalloc(sizeof(*cparams), GFP_KERNEL);
+	if (!c || !cparams)
+		return -ENOMEM;
+
+	c->priv     =3D priv;
+	c->mdev     =3D priv->mdev;
+	c->tstamp   =3D &priv->tstamp;
+	c->ix       =3D 0;
+	c->pdev     =3D mlx5_core_dma_dev(priv->mdev);
+	c->netdev   =3D priv->netdev;
+	c->mkey_be  =3D cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	c->num_tc   =3D params->num_tc;
+	c->stats    =3D &priv->port_ptp_stats.ch;
+	c->irq_desc =3D irq_to_desc(irq);
+	c->lag_port =3D lag_port;
+
+	netif_napi_add(netdev, &c->napi, mlx5e_ptp_napi_poll, 64);
+
+	mlx5e_ptp_build_params(c, cparams, params);
+
+	err =3D mlx5e_ptp_open_queues(c, cparams);
+	if (unlikely(err))
+		goto err_napi_del;
+
+	*cp =3D c;
+
+	kvfree(cparams);
+
+	return 0;
+
+err_napi_del:
+	netif_napi_del(&c->napi);
+
+	kvfree(cparams);
+	kvfree(c);
+	return err;
+}
+
+void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c)
+{
+	mlx5e_ptp_close_queues(c);
+	netif_napi_del(&c->napi);
+
+	kvfree(c);
+}
+
+void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c)
+{
+	int tc;
+
+	for (tc =3D 0; tc < c->num_tc; tc++)
+		mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
+}
+
+void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c)
+{
+	int tc;
+
+	for (tc =3D 0; tc < c->num_tc; tc++)
+		mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/ptp.h
new file mode 100644
index 000000000000..daa3b6953e3f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_PTP_H__
+#define __MLX5_EN_PTP_H__
+
+#include "en.h"
+#include "en/params.h"
+#include "en_stats.h"
+
+struct mlx5e_ptpsq {
+	struct mlx5e_txqsq       txqsq;
+};
+
+struct mlx5e_port_ptp {
+	/* data path */
+	struct mlx5e_ptpsq         ptpsq[MLX5E_MAX_NUM_TC];
+	struct napi_struct         napi;
+	struct device             *pdev;
+	struct net_device         *netdev;
+	__be32                     mkey_be;
+	u8                         num_tc;
+	u8                         lag_port;
+
+	/* data path - accessed per napi poll */
+	struct irq_desc *irq_desc;
+	struct mlx5e_ch_stats     *stats;
+
+	/* control */
+	struct mlx5e_priv         *priv;
+	struct mlx5_core_dev      *mdev;
+	struct hwtstamp_config    *tstamp;
+	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
+	int                        ix;
+};
+
+struct mlx5e_ptp_params {
+	struct mlx5e_params        params;
+	struct mlx5e_sq_param      txq_sq_param;
+};
+
+int mlx5e_port_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *para=
ms,
+			u8 lag_port, struct mlx5e_port_ptp **cp);
+void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c);
+void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c);
+void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c);
+
+#endif /* __MLX5_EN_PTP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 88b3b21d1068..c55a2ad10599 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
 #include "health.h"
+#include "en/ptp.h"
=20
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
@@ -141,8 +142,8 @@ static int mlx5e_tx_reporter_recover(struct devlink_hea=
lth_reporter *reporter,
 }
=20
 static int
-mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
-					struct mlx5e_txqsq *sq, int tc)
+mlx5e_tx_reporter_build_diagnose_output_sq_common(struct devlink_fmsg *fms=
g,
+						  struct mlx5e_txqsq *sq, int tc)
 {
 	bool stopped =3D netif_xmit_stopped(sq->txq);
 	struct mlx5e_priv *priv =3D sq->priv;
@@ -153,14 +154,6 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
_fmsg *fmsg,
 	if (err)
 		return err;
=20
-	err =3D devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		return err;
-
-	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", sq->ch_ix);
-	if (err)
-		return err;
-
 	err =3D devlink_fmsg_u32_pair_put(fmsg, "tc", tc);
 	if (err)
 		return err;
@@ -193,7 +186,24 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
_fmsg *fmsg,
 	if (err)
 		return err;
=20
-	err =3D mlx5e_health_eq_diag_fmsg(sq->cq.mcq.eq, fmsg);
+	return mlx5e_health_eq_diag_fmsg(sq->cq.mcq.eq, fmsg);
+}
+
+static int
+mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
+					struct mlx5e_txqsq *sq, int tc)
+{
+	int err;
+
+	err =3D devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", sq->ch_ix);
+	if (err)
+		return err;
+
+	err =3D mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg, sq, tc);
 	if (err)
 		return err;
=20
@@ -204,49 +214,116 @@ mlx5e_tx_reporter_build_diagnose_output(struct devli=
nk_fmsg *fmsg,
 	return 0;
 }
=20
-static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *repo=
rter,
-				      struct devlink_fmsg *fmsg,
-				      struct netlink_ext_ack *extack)
+static int
+mlx5e_tx_reporter_build_diagnose_output_ptpsq(struct devlink_fmsg *fmsg,
+					      struct mlx5e_ptpsq *ptpsq, int tc)
 {
-	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
-	struct mlx5e_txqsq *generic_sq =3D priv->txq2sq[0];
-	u32 sq_stride, sq_sz;
-
-	int i, tc, err =3D 0;
+	int err;
=20
-	mutex_lock(&priv->state_lock);
+	err =3D devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
=20
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto unlock;
+	err =3D devlink_fmsg_string_pair_put(fmsg, "channel", "ptp");
+	if (err)
+		return err;
=20
-	sq_sz =3D mlx5_wq_cyc_get_size(&generic_sq->wq);
-	sq_stride =3D MLX5_SEND_WQE_BB;
+	err =3D mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg,
+								&ptpsq->txqsq,
+								tc);
+	if (err)
+		return err;
=20
-	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common Config");
+	err =3D devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
-		goto unlock;
+		return err;
+
+	return 0;
+}
+
+static int
+mlx5e_tx_reporter_diagnose_generic_txqsq(struct devlink_fmsg *fmsg,
+					 struct mlx5e_txqsq *txqsq)
+{
+	u32 sq_stride, sq_sz;
+	int err;
=20
 	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SQ");
 	if (err)
-		goto unlock;
+		return err;
+
+	sq_sz =3D mlx5_wq_cyc_get_size(&txqsq->wq);
+	sq_stride =3D MLX5_SEND_WQE_BB;
=20
 	err =3D devlink_fmsg_u64_pair_put(fmsg, "stride size", sq_stride);
 	if (err)
-		goto unlock;
+		return err;
=20
 	err =3D devlink_fmsg_u32_pair_put(fmsg, "size", sq_sz);
 	if (err)
-		goto unlock;
+		return err;
=20
-	err =3D mlx5e_health_cq_common_diag_fmsg(&generic_sq->cq, fmsg);
+	err =3D mlx5e_health_cq_common_diag_fmsg(&txqsq->cq, fmsg);
 	if (err)
-		goto unlock;
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
+static int
+mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *r=
eporter,
+					 struct devlink_fmsg *fmsg)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_txqsq *generic_sq =3D priv->txq2sq[0];
+	struct mlx5e_ptpsq *generic_ptpsq;
+	int err;
+
+	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common Config");
+	if (err)
+		return err;
+
+	err =3D mlx5e_tx_reporter_diagnose_generic_txqsq(fmsg, generic_sq);
+	if (err)
+		return err;
+
+	generic_ptpsq =3D priv->channels.port_ptp ?
+			&priv->channels.port_ptp->ptpsq[0] :
+			NULL;
+	if (!generic_ptpsq)
+		goto out;
+
+	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "PTP");
+	if (err)
+		return err;
+
+	err =3D mlx5e_tx_reporter_diagnose_generic_txqsq(fmsg, &generic_ptpsq->tx=
qsq);
+	if (err)
+		return err;
=20
 	err =3D mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
+		return err;
+
+out:
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
+static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *repo=
rter,
+				      struct devlink_fmsg *fmsg,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_port_ptp *ptp_ch =3D priv->channels.port_ptp;
+
+	int i, tc, err =3D 0;
+
+	mutex_lock(&priv->state_lock);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
=20
-	err =3D mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+	err =3D mlx5e_tx_reporter_diagnose_common_config(reporter, fmsg);
 	if (err)
 		goto unlock;
=20
@@ -265,6 +342,19 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
 				goto unlock;
 		}
 	}
+
+	if (!ptp_ch)
+		goto close_sqs_nest;
+
+	for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+		err =3D mlx5e_tx_reporter_build_diagnose_output_ptpsq(fmsg,
+								    &ptp_ch->ptpsq[tc],
+								    tc);
+		if (err)
+			goto unlock;
+	}
+
+close_sqs_nest:
 	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
 		goto unlock;
@@ -338,6 +428,7 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv =
*priv, struct devlink_fms
 static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 					  struct devlink_fmsg *fmsg)
 {
+	struct mlx5e_port_ptp *ptp_ch =3D priv->channels.port_ptp;
 	struct mlx5_rsc_key key =3D {};
 	int i, tc, err;
=20
@@ -373,6 +464,17 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e=
_priv *priv,
 				return err;
 		}
 	}
+
+	if (ptp_ch) {
+		for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+			struct mlx5e_txqsq *sq =3D &ptp_ch->ptpsq[tc].txqsq;
+
+			err =3D mlx5e_health_queue_dump(priv, fmsg, sq->sqn, "PTP SQ");
+			if (err)
+				return err;
+		}
+	}
+
 	return devlink_fmsg_arr_pair_nest_end(fmsg);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 42e61dc28ead..30542d98ab27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1946,6 +1946,38 @@ static int set_pflag_skb_tx_mpwqe(struct net_device =
*netdev, bool enable)
 	return set_pflag_tx_mpwqe_common(netdev, MLX5E_PFLAG_SKB_TX_MPWQE, enable=
);
 }
=20
+static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(netdev);
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct mlx5e_channels new_channels =3D {};
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
+		return -EOPNOTSUPP;
+
+	new_channels.params =3D priv->channels.params;
+	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_TX_PORT_TS, enable);
+	/* No need to verify SQ stop room as
+	 * ptpsq.txqsq.stop_room <=3D generic_sq->stop_room, and both
+	 * has the same log_sq_size.
+	 */
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params =3D new_channels.params;
+		err =3D mlx5e_num_channels_changed(priv);
+		goto out;
+	}
+
+	err =3D mlx5e_safe_switch_channels(priv, &new_channels,
+					 mlx5e_num_channels_changed_ctx, NULL);
+out:
+	if (!err)
+		priv->port_ptp_opened =3D true;
+
+	return err;
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] =3D {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -1954,6 +1986,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E=
_NUM_PFLAGS] =3D {
 	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
 	{ "skb_tx_mpwqe",        set_pflag_skb_tx_mpwqe },
+	{ "tx_port_ts",          set_pflag_tx_port_ts },
 };
=20
 static int mlx5e_handle_pflag(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 3ea15d62acd9..e36a13238271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -64,6 +64,7 @@
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
+#include "en/ptp.h"
=20
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -1083,14 +1084,14 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq=
)
 	mlx5_wq_destroy(&sq->wq_ctrl);
 }
=20
-static void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
+void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
 	kvfree(sq->db.wqe_info);
 	kvfree(sq->db.skb_fifo.fifo);
 	kvfree(sq->db.dma_fifo);
 }
=20
-static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
+int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
 {
 	int wq_sz =3D mlx5_wq_cyc_get_size(&sq->wq);
 	int df_sz =3D wq_sz * MLX5_SEND_WQEBB_NUM_DS;
@@ -1118,7 +1119,6 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *s=
q, int numa)
 	return 0;
 }
=20
-static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work);
 static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 			     int txq_ix,
 			     struct mlx5e_params *params,
@@ -1176,20 +1176,12 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *=
c,
 	return err;
 }
=20
-static void mlx5e_free_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_free_txqsq(struct mlx5e_txqsq *sq)
 {
 	mlx5e_free_txqsq_db(sq);
 	mlx5_wq_destroy(&sq->wq_ctrl);
 }
=20
-struct mlx5e_create_sq_param {
-	struct mlx5_wq_ctrl        *wq_ctrl;
-	u32                         cqn;
-	u32                         tisn;
-	u8                          tis_lst_sz;
-	u8                          min_inline_mode;
-};
-
 static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 			   struct mlx5e_sq_param *param,
 			   struct mlx5e_create_sq_param *csp,
@@ -1271,10 +1263,10 @@ static void mlx5e_destroy_sq(struct mlx5_core_dev *=
mdev, u32 sqn)
 	mlx5_core_destroy_sq(mdev, sqn);
 }
=20
-static int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
-			       struct mlx5e_sq_param *param,
-			       struct mlx5e_create_sq_param *csp,
-			       u32 *sqn)
+int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
+			struct mlx5e_sq_param *param,
+			struct mlx5e_create_sq_param *csp,
+			u32 *sqn)
 {
 	struct mlx5e_modify_sq_param msp =3D {0};
 	int err;
@@ -1350,7 +1342,7 @@ void mlx5e_tx_disable_queue(struct netdev_queue *txq)
 	__netif_tx_unlock_bh(txq);
 }
=20
-static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 {
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
=20
@@ -1389,7 +1381,7 @@ static void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 	mlx5e_free_txqsq(sq);
 }
=20
-static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
+void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 {
 	struct mlx5e_txqsq *sq =3D container_of(recover_work, struct mlx5e_txqsq,
 					      recover_work);
@@ -2374,6 +2366,13 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
=20
+	if (MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS)) {
+		err =3D mlx5e_port_ptp_open(priv, &chs->params, chs->c[0]->lag_port,
+					  &chs->port_ptp);
+		if (err)
+			goto err_close_channels;
+	}
+
 	mlx5e_health_channels_update(priv);
 	kvfree(cparam);
 	return 0;
@@ -2395,6 +2394,9 @@ static void mlx5e_activate_channels(struct mlx5e_chan=
nels *chs)
=20
 	for (i =3D 0; i < chs->num; i++)
 		mlx5e_activate_channel(chs->c[i]);
+
+	if (chs->port_ptp)
+		mlx5e_ptp_activate_channel(chs->port_ptp);
 }
=20
 #define MLX5E_RQ_WQES_TIMEOUT 20000 /* msecs */
@@ -2421,6 +2423,9 @@ static void mlx5e_deactivate_channels(struct mlx5e_ch=
annels *chs)
 {
 	int i;
=20
+	if (chs->port_ptp)
+		mlx5e_ptp_deactivate_channel(chs->port_ptp);
+
 	for (i =3D 0; i < chs->num; i++)
 		mlx5e_deactivate_channel(chs->c[i]);
 }
@@ -2429,6 +2434,9 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
=20
+	if (chs->port_ptp)
+		mlx5e_port_ptp_close(chs->port_ptp);
+
 	for (i =3D 0; i < chs->num; i++)
 		mlx5e_close_channel(chs->c[i]);
=20
@@ -2914,6 +2922,8 @@ static int mlx5e_update_netdev_queues(struct mlx5e_pr=
iv *priv)
 	nch =3D priv->channels.params.num_channels;
 	ntc =3D priv->channels.params.num_tc;
 	num_txqs =3D nch * ntc;
+	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS))
+		num_txqs +=3D ntc;
 	num_rxqs =3D nch * priv->profile->rq_groups;
=20
 	mlx5e_netdev_set_tcs(netdev, nch, ntc);
@@ -2987,14 +2997,13 @@ MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(mlx5e_num_chan=
nels_changed);
=20
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
-	int i, ch;
+	int i, ch, tc, num_tc;
=20
 	ch =3D priv->channels.num;
+	num_tc =3D priv->channels.params.num_tc;
=20
 	for (i =3D 0; i < ch; i++) {
-		int tc;
-
-		for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+		for (tc =3D 0; tc < num_tc; tc++) {
 			struct mlx5e_channel *c =3D priv->channels.c[i];
 			struct mlx5e_txqsq *sq =3D &c->sq[tc];
=20
@@ -3002,10 +3011,28 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv =
*priv)
 			priv->channel_tc2realtxq[i][tc] =3D i + tc * ch;
 		}
 	}
+
+	if (!priv->channels.port_ptp)
+		return;
+
+	for (tc =3D 0; tc < num_tc; tc++) {
+		struct mlx5e_port_ptp *c =3D priv->channels.port_ptp;
+		struct mlx5e_txqsq *sq =3D &c->ptpsq[tc].txqsq;
+
+		priv->txq2sq[sq->txq_ix] =3D sq;
+		priv->port_ptp_tc2realtxq[tc] =3D priv->num_tc_x_num_ch + tc;
+	}
+}
+
+static void mlx5e_update_num_tc_x_num_ch(struct mlx5e_priv *priv)
+{
+	priv->num_tc_x_num_ch =3D priv->channels.params.num_tc *
+				priv->channels.num;
 }
=20
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
+	mlx5e_update_num_tc_x_num_ch(priv);
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_xdp_tx_enable(priv);
@@ -4342,6 +4369,7 @@ static void mlx5e_tx_timeout_work(struct work_struct =
*work)
 {
 	struct mlx5e_priv *priv =3D container_of(work, struct mlx5e_priv,
 					       tx_timeout_work);
+	struct net_device *netdev =3D priv->netdev;
 	int i;
=20
 	rtnl_lock();
@@ -4350,9 +4378,9 @@ static void mlx5e_tx_timeout_work(struct work_struct =
*work)
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
=20
-	for (i =3D 0; i < priv->channels.num * priv->channels.params.num_tc; i++)=
 {
+	for (i =3D 0; i < netdev->real_num_tx_queues; i++) {
 		struct netdev_queue *dev_queue =3D
-			netdev_get_tx_queue(priv->netdev, i);
+			netdev_get_tx_queue(netdev, i);
 		struct mlx5e_txqsq *sq =3D priv->txq2sq[i];
=20
 		if (!netif_xmit_stopped(dev_queue))
@@ -5334,10 +5362,14 @@ struct net_device *mlx5e_create_netdev(struct mlx5_=
core_dev *mdev,
 				       void *ppriv)
 {
 	struct net_device *netdev;
+	unsigned int ptp_txqs =3D 0;
 	int err;
=20
+	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
+		ptp_txqs =3D profile->max_tc;
+
 	netdev =3D alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
-				    nch * profile->max_tc,
+				    nch * profile->max_tc + ptp_txqs,
 				    nch * profile->rq_groups);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index ebfb47a09128..9d57dc94c767 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -402,6 +402,24 @@ static void mlx5e_stats_grp_sw_update_stats_sq(struct =
mlx5e_sw_stats *s,
 	s->tx_cqes                  +=3D sq_stats->cqes;
 }
=20
+static void mlx5e_stats_grp_sw_update_stats_ptp(struct mlx5e_priv *priv,
+						struct mlx5e_sw_stats *s)
+{
+	int i;
+
+	if (!priv->port_ptp_opened)
+		return;
+
+	mlx5e_stats_grp_sw_update_stats_ch_stats(s, &priv->port_ptp_stats.ch);
+
+	for (i =3D 0; i < priv->max_opened_tc; i++) {
+		mlx5e_stats_grp_sw_update_stats_sq(s, &priv->port_ptp_stats.sq[i]);
+
+		/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D92657 */
+		barrier();
+	}
+}
+
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s =3D &priv->stats.sw;
@@ -430,6 +448,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 			barrier();
 		}
 	}
+	mlx5e_stats_grp_sw_update_stats_ptp(priv, s);
 }
=20
 static const struct counter_desc q_stats_desc[] =3D {
@@ -1690,6 +1709,30 @@ static const struct counter_desc ch_stats_desc[] =3D=
 {
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, eq_rearm) },
 };
=20
+static const struct counter_desc ptp_sq_stats_desc[] =3D {
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, packets) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, bytes) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, csum_partial) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, nop) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, csum_none) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, stopped) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, dropped) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, xmit_more) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, recover) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, cqes) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, wake) },
+	{ MLX5E_DECLARE_PTP_TX_STAT(struct mlx5e_sq_stats, cqe_err) },
+};
+
+static const struct counter_desc ptp_ch_stats_desc[] =3D {
+	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, events) },
+	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, poll) },
+	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, arm) },
+	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, eq_rearm) },
+};
+
 #define NUM_RQ_STATS			ARRAY_SIZE(rq_stats_desc)
 #define NUM_SQ_STATS			ARRAY_SIZE(sq_stats_desc)
 #define NUM_XDPSQ_STATS			ARRAY_SIZE(xdpsq_stats_desc)
@@ -1697,6 +1740,57 @@ static const struct counter_desc ch_stats_desc[] =3D=
 {
 #define NUM_XSKRQ_STATS			ARRAY_SIZE(xskrq_stats_desc)
 #define NUM_XSKSQ_STATS			ARRAY_SIZE(xsksq_stats_desc)
 #define NUM_CH_STATS			ARRAY_SIZE(ch_stats_desc)
+#define NUM_PTP_SQ_STATS		ARRAY_SIZE(ptp_sq_stats_desc)
+#define NUM_PTP_CH_STATS		ARRAY_SIZE(ptp_ch_stats_desc)
+
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
+{
+	return priv->port_ptp_opened ?
+	       NUM_PTP_CH_STATS + (NUM_PTP_SQ_STATS * priv->max_opened_tc) :
+	       0;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
+{
+	int i, tc;
+
+	if (!priv->port_ptp_opened)
+		return idx;
+
+	for (i =3D 0; i < NUM_PTP_CH_STATS; i++)
+		sprintf(data + (idx++) * ETH_GSTRING_LEN,
+			ptp_ch_stats_desc[i].format);
+
+	for (tc =3D 0; tc < priv->max_opened_tc; tc++)
+		for (i =3D 0; i < NUM_PTP_SQ_STATS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				ptp_sq_stats_desc[i].format, tc);
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
+{
+	int i, tc;
+
+	if (!priv->port_ptp_opened)
+		return idx;
+
+	for (i =3D 0; i < NUM_PTP_CH_STATS; i++)
+		data[idx++] =3D
+			MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.ch,
+					     ptp_ch_stats_desc, i);
+
+	for (tc =3D 0; tc < priv->max_opened_tc; tc++)
+		for (i =3D 0; i < NUM_PTP_SQ_STATS; i++)
+			data[idx++] =3D
+				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.sq[tc],
+						     ptp_sq_stats_desc, i);
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ptp) { return; }
=20
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 {
@@ -1818,6 +1912,7 @@ MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
+static MLX5E_DEFINE_STATS_GRP(ptp, 0);
=20
 /* The stats groups order is opposite to the update_stats() order calls */
 mlx5e_stats_grp_t mlx5e_nic_stats_grps[] =3D {
@@ -1840,6 +1935,7 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] =3D {
 	&MLX5E_STATS_GRP(tls),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
+	&MLX5E_STATS_GRP(ptp),
 };
=20
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 162daaadb0d8..98ffebcc93b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -51,6 +51,9 @@
 #define MLX5E_DECLARE_XSKSQ_STAT(type, fld) "tx%d_xsk_"#fld, offsetof(type=
, fld)
 #define MLX5E_DECLARE_CH_STAT(type, fld) "ch%d_"#fld, offsetof(type, fld)
=20
+#define MLX5E_DECLARE_PTP_TX_STAT(type, fld) "ptp_tx%d_"#fld, offsetof(typ=
e, fld)
+#define MLX5E_DECLARE_PTP_CH_STAT(type, fld) "ptp_ch_"#fld, offsetof(type,=
 fld)
+
 struct counter_desc {
 	char		format[ETH_GSTRING_LEN];
 	size_t		offset; /* Byte offset */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index c6b20b77a0f2..0ae68cb25035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -39,6 +39,7 @@
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
 #include "lib/clock.h"
+#include "en/ptp.h"
=20
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -66,14 +67,67 @@ static inline int mlx5e_get_dscp_up(struct mlx5e_priv *=
priv, struct sk_buff *skb
 }
 #endif
=20
+static bool mlx5e_use_ptpsq(struct sk_buff *skb)
+{
+	struct flow_keys fk;
+
+	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
+		return false;
+
+	if (fk.basic.n_proto =3D=3D htons(ETH_P_1588))
+		return true;
+
+	if (fk.basic.n_proto !=3D htons(ETH_P_IP) &&
+	    fk.basic.n_proto !=3D htons(ETH_P_IPV6))
+		return false;
+
+	return fk.basic.ip_proto =3D=3D IPPROTO_UDP;
+}
+
+static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+	int up =3D 0;
+
+	if (!netdev_get_num_tc(dev))
+		goto return_txq;
+
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+	if (priv->dcbx_dp.trust_state =3D=3D MLX5_QPTS_TRUST_DSCP)
+		up =3D mlx5e_get_dscp_up(priv, skb);
+	else
+#endif
+		if (skb_vlan_tag_present(skb))
+			up =3D skb_vlan_tag_get_prio(skb);
+
+return_txq:
+	return priv->port_ptp_tc2realtxq[up];
+}
+
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev)
 {
-	int txq_ix =3D netdev_pick_tx(dev, skb, NULL);
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
+	int txq_ix;
 	int up =3D 0;
 	int ch_ix;
=20
+	if (unlikely(priv->channels.port_ptp)) {
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+		    mlx5e_use_ptpsq(skb))
+			return mlx5e_select_ptpsq(dev, skb);
+
+		txq_ix =3D netdev_pick_tx(dev, skb, NULL);
+		/* Fix netdev_pick_tx() not to choose ptp_channel txqs.
+		 * If they are selected, switch to regular queues.
+		 * Driver to select these queues only at mlx5e_select_ptpsq().
+		 */
+		if (unlikely(txq_ix >=3D priv->num_tc_x_num_ch))
+			txq_ix =3D txq_ix % priv->num_tc_x_num_ch;
+	} else {
+		txq_ix =3D netdev_pick_tx(dev, skb, NULL);
+	}
+
 	if (!netdev_get_num_tc(dev))
 		return txq_ix;
=20
--=20
2.26.2

