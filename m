Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61052CB060
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgLAWnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9876 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgLAWnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d30000>; Tue, 01 Dec 2020 14:42:27 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Add TX port timestamp support
Date:   Tue, 1 Dec 2020 14:42:02 -0800
Message-ID: <20201201224208.73295-10-saeedm@nvidia.com>
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
        t=1606862548; bh=IybIBVp5oEDb5iXYnjV0F4Qk0fX6ltmxYtzZxfM/w68=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fpniEcfy5sJZmeOfT3rjcqf2eVMtSAQCyfPR1kO2Ikpd617gZ/17R5zmMLw2eENP+
         0yoE9NhM6O7FBDDgXuNM16q9ijSzFWwnjhH5MkVjBkn1I8xRjLeq80ysIEEdPFCWiO
         MEbAnvucCHOX4np1JFhzdT2RqbSMei7OBCAzw/zZ67D+tEDFP/sx2YoAH0PwTBmS7/
         CjafszuxsmtGwOm0TMi8gW4Xq1NcYPMYyCmJ2kOZJYp4exGBsZ0AYNFdyV06LBPH3Y
         einom3StFmRHYk6Oj9y8pwbuDq48Q6gLJ9v9JGvA1wDKRnsRqjfLLbpXeD4AjbfzZU
         PHoK6VXD2+Kvg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

Transmitted packet timestamping accuracy can be improved when using
timestamp from the port, instead of packet CQE creation timestamp, as
it better reflects the actual time of a packet's transmit.

TX port timestamping is supported starting from ConnectX6-DX hardware.
Although at the original completion, only CQE timestamp can be attached,
we are able to get TX port timestamping via an additional completion over
a special CQ associated with the SQ (in addition to the regular CQ).

Driver to ignore the original packet completion timestamp, and report
back the timestamp of the special CQ completion. If the absolute timestamp
diff between the two completions is greater than 1 / 128 second, ignore
the TX port timestamp as it has a jitter which is too big.
No skb will be generate out of the extra completion.

Allocate additional CQ per ptpsq, to receive the TX port timestamp.

Driver to hold an skb FIFO in order to map between transmitted skb to
the two expected completions. When using ptpsq, hold double refcount on
the skb, to gaurantee it will not get released before both completions
arrive.

Expose dedicated counters of the ptp additional CQ and connect it to the
TX health reporter.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 173 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  15 ++
 .../mellanox/mlx5/core/en/reporter_tx.c       |  37 +++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  21 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   8 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  12 +-
 9 files changed, 262 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 6864c79d2d9a..a1a81cfeb607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -718,6 +718,7 @@ struct mlx5e_channel_stats {
 struct mlx5e_port_ptp_stats {
 	struct mlx5e_ch_stats ch;
 	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
+	struct mlx5e_ptp_cq_stats cq[MLX5E_MAX_NUM_TC];
 } ____cacheline_aligned_in_smp;
=20
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.h
index 70e463712b7f..3959254d4181 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -44,6 +44,7 @@ struct mlx5e_channel_param {
 struct mlx5e_create_sq_param {
 	struct mlx5_wq_ctrl        *wq_ctrl;
 	u32                         cqn;
+	u32                         ts_cqe_to_dest_cqn;
 	u32                         tisn;
 	u8                          tis_lst_sz;
 	u8                          min_inline_mode;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/ptp.c
index 8639b5104df7..351118985a57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -5,6 +5,115 @@
 #include "en/txrx.h"
 #include "lib/clock.h"
=20
+struct mlx5e_skb_cb_hwtstamp {
+	ktime_t cqe_hwtstamp;
+	ktime_t port_hwtstamp;
+};
+
+void mlx5e_skb_cb_hwtstamp_init(struct sk_buff *skb)
+{
+	memset(skb->cb, 0, sizeof(struct mlx5e_skb_cb_hwtstamp));
+}
+
+static struct mlx5e_skb_cb_hwtstamp *mlx5e_skb_cb_get_hwts(struct sk_buff =
*skb)
+{
+	BUILD_BUG_ON(sizeof(struct mlx5e_skb_cb_hwtstamp) > sizeof(skb->cb));
+	return (struct mlx5e_skb_cb_hwtstamp *)skb->cb;
+}
+
+static void mlx5e_skb_cb_hwtstamp_tx(struct sk_buff *skb,
+				     struct mlx5e_ptp_cq_stats *cq_stats)
+{
+	struct skb_shared_hwtstamps hwts =3D {};
+	ktime_t diff;
+
+	diff =3D abs(mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp -
+		   mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp);
+
+	/* Maximal allowed diff is 1 / 128 second */
+	if (diff > (NSEC_PER_SEC >> 7)) {
+		cq_stats->abort++;
+		cq_stats->abort_abs_diff_ns +=3D diff;
+		return;
+	}
+
+	hwts.hwtstamp =3D mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp;
+	skb_tstamp_tx(skb, &hwts);
+}
+
+void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
+				   ktime_t hwtstamp,
+				   struct mlx5e_ptp_cq_stats *cq_stats)
+{
+	switch (hwtstamp_type) {
+	case (MLX5E_SKB_CB_CQE_HWTSTAMP):
+		mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp =3D hwtstamp;
+		break;
+	case (MLX5E_SKB_CB_PORT_HWTSTAMP):
+		mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp =3D hwtstamp;
+		break;
+	}
+
+	/* If both CQEs arrive, check and report the port tstamp, and clear skb c=
b as
+	 * skb soon to be released.
+	 */
+	if (!mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp ||
+	    !mlx5e_skb_cb_get_hwts(skb)->port_hwtstamp)
+		return;
+
+	mlx5e_skb_cb_hwtstamp_tx(skb, cq_stats);
+	memset(skb->cb, 0, sizeof(struct mlx5e_skb_cb_hwtstamp));
+}
+
+static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
+				    struct mlx5_cqe64 *cqe,
+				    int budget)
+{
+	struct sk_buff *skb =3D mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	ktime_t hwtstamp;
+
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		ptpsq->cq_stats->err_cqe++;
+		goto out;
+	}
+
+	hwtstamp =3D mlx5_timecounter_cyc2time(ptpsq->txqsq.clock, get_cqe_ts(cqe=
));
+	mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_PORT_HWTSTAMP,
+				      hwtstamp, ptpsq->cq_stats);
+	ptpsq->cq_stats->cqe++;
+
+out:
+	napi_consume_skb(skb, budget);
+}
+
+static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
+{
+	struct mlx5e_ptpsq *ptpsq =3D container_of(cq, struct mlx5e_ptpsq, ts_cq)=
;
+	struct mlx5_cqwq *cqwq =3D &cq->wq;
+	struct mlx5_cqe64 *cqe;
+	int work_done =3D 0;
+
+	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &ptpsq->txqsq.state)))
+		return false;
+
+	cqe =3D mlx5_cqwq_get_cqe(cqwq);
+	if (!cqe)
+		return false;
+
+	do {
+		mlx5_cqwq_pop(cqwq);
+
+		mlx5e_ptp_handle_ts_cqe(ptpsq, cqe, budget);
+	} while ((++work_done < budget) && (cqe =3D mlx5_cqwq_get_cqe(cqwq)));
+
+	mlx5_cqwq_update_db_record(cqwq);
+
+	/* ensure cq space is freed before enabling more cqes */
+	wmb();
+
+	return work_done =3D=3D budget;
+}
+
 static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct mlx5e_port_ptp *c =3D container_of(napi, struct mlx5e_port_ptp,
@@ -18,8 +127,10 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi=
, int budget)
=20
 	ch_stats->poll++;
=20
-	for (i =3D 0; i < c->num_tc; i++)
+	for (i =3D 0; i < c->num_tc; i++) {
 		busy |=3D mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
+		busy |=3D mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
+	}
=20
 	if (busy) {
 		work_done =3D budget;
@@ -31,8 +142,10 @@ static int mlx5e_ptp_napi_poll(struct napi_struct *napi=
, int budget)
=20
 	ch_stats->arm++;
=20
-	for (i =3D 0; i < c->num_tc; i++)
+	for (i =3D 0; i < c->num_tc; i++) {
 		mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
+		mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
+	}
=20
 out:
 	rcu_read_unlock();
@@ -96,6 +209,37 @@ static void mlx5e_ptp_destroy_sq(struct mlx5_core_dev *=
mdev, u32 sqn)
 	mlx5_core_destroy_sq(mdev, sqn);
 }
=20
+static int mlx5e_ptp_alloc_traffic_db(struct mlx5e_ptpsq *ptpsq, int numa)
+{
+	int wq_sz =3D mlx5_wq_cyc_get_size(&ptpsq->txqsq.wq);
+
+	ptpsq->skb_fifo.fifo =3D kvzalloc_node(array_size(wq_sz, sizeof(*ptpsq->s=
kb_fifo.fifo)),
+					     GFP_KERNEL, numa);
+	if (!ptpsq->skb_fifo.fifo)
+		return -ENOMEM;
+
+	ptpsq->skb_fifo.pc   =3D &ptpsq->skb_fifo_pc;
+	ptpsq->skb_fifo.cc   =3D &ptpsq->skb_fifo_cc;
+	ptpsq->skb_fifo.mask =3D wq_sz - 1;
+
+	return 0;
+}
+
+static void mlx5e_ptp_drain_skb_fifo(struct mlx5e_skb_fifo *skb_fifo)
+{
+	while (*skb_fifo->pc !=3D *skb_fifo->cc) {
+		struct sk_buff *skb =3D mlx5e_skb_fifo_pop(skb_fifo);
+
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static void mlx5e_ptp_free_traffic_db(struct mlx5e_skb_fifo *skb_fifo)
+{
+	mlx5e_ptp_drain_skb_fifo(skb_fifo);
+	kvfree(skb_fifo->fifo);
+}
+
 static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
 				int txq_ix, struct mlx5e_ptp_params *cparams,
 				int tc, struct mlx5e_ptpsq *ptpsq)
@@ -115,11 +259,17 @@ static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp=
 *c, u32 tisn,
 	csp.cqn             =3D txqsq->cq.mcq.cqn;
 	csp.wq_ctrl         =3D &txqsq->wq_ctrl;
 	csp.min_inline_mode =3D txqsq->min_inline_mode;
+	csp.ts_cqe_to_dest_cqn =3D ptpsq->ts_cq.mcq.cqn;
=20
 	err =3D mlx5e_create_sq_rdy(c->mdev, sqp, &csp, &txqsq->sqn);
 	if (err)
 		goto err_free_txqsq;
=20
+	err =3D mlx5e_ptp_alloc_traffic_db(ptpsq,
+					 dev_to_node(mlx5_core_dma_dev(c->mdev)));
+	if (err)
+		goto err_free_txqsq;
+
 	return 0;
=20
 err_free_txqsq:
@@ -133,6 +283,7 @@ static void mlx5e_ptp_close_txqsq(struct mlx5e_ptpsq *p=
tpsq)
 	struct mlx5e_txqsq *sq =3D &ptpsq->txqsq;
 	struct mlx5_core_dev *mdev =3D sq->mdev;
=20
+	mlx5e_ptp_free_traffic_db(&ptpsq->skb_fifo);
 	cancel_work_sync(&sq->recover_work);
 	mlx5e_ptp_destroy_sq(mdev, sq->sqn);
 	mlx5e_free_txqsq_descs(sq);
@@ -200,8 +351,23 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_port_ptp *c=
,
 			goto out_err_txqsq_cq;
 	}
=20
+	for (tc =3D 0; tc < params->num_tc; tc++) {
+		struct mlx5e_cq *cq =3D &c->ptpsq[tc].ts_cq;
+		struct mlx5e_ptpsq *ptpsq =3D &c->ptpsq[tc];
+
+		err =3D mlx5e_open_cq(c->priv, ptp_moder, cq_param, &ccp, cq);
+		if (err)
+			goto out_err_ts_cq;
+
+		ptpsq->cq_stats =3D &c->priv->port_ptp_stats.cq[tc];
+	}
+
 	return 0;
=20
+out_err_ts_cq:
+	for (--tc; tc >=3D 0; tc--)
+		mlx5e_close_cq(&c->ptpsq[tc].ts_cq);
+	tc =3D params->num_tc;
 out_err_txqsq_cq:
 	for (--tc; tc >=3D 0; tc--)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
@@ -213,6 +379,9 @@ static void mlx5e_ptp_close_cqs(struct mlx5e_port_ptp *=
c)
 {
 	int tc;
=20
+	for (tc =3D 0; tc < c->num_tc; tc++)
+		mlx5e_close_cq(&c->ptpsq[tc].ts_cq);
+
 	for (tc =3D 0; tc < c->num_tc; tc++)
 		mlx5e_close_cq(&c->ptpsq[tc].txqsq.cq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/ptp.h
index daa3b6953e3f..28aa5ae118f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -10,6 +10,11 @@
=20
 struct mlx5e_ptpsq {
 	struct mlx5e_txqsq       txqsq;
+	struct mlx5e_cq          ts_cq;
+	u16                      skb_fifo_cc;
+	u16                      skb_fifo_pc;
+	struct mlx5e_skb_fifo    skb_fifo;
+	struct mlx5e_ptp_cq_stats *cq_stats;
 };
=20
 struct mlx5e_port_ptp {
@@ -45,4 +50,14 @@ void mlx5e_port_ptp_close(struct mlx5e_port_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_port_ptp *c);
 void mlx5e_ptp_deactivate_channel(struct mlx5e_port_ptp *c);
=20
+enum {
+	MLX5E_SKB_CB_CQE_HWTSTAMP  =3D BIT(0),
+	MLX5E_SKB_CB_PORT_HWTSTAMP =3D BIT(1),
+};
+
+void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
+				   ktime_t hwtstamp,
+				   struct mlx5e_ptp_cq_stats *cq_stats);
+
+void mlx5e_skb_cb_hwtstamp_init(struct sk_buff *skb);
 #endif /* __MLX5_EN_PTP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index c55a2ad10599..d7275c84313e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -228,9 +228,19 @@ mlx5e_tx_reporter_build_diagnose_output_ptpsq(struct d=
evlink_fmsg *fmsg,
 	if (err)
 		return err;
=20
-	err =3D mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg,
-								&ptpsq->txqsq,
-								tc);
+	err =3D mlx5e_tx_reporter_build_diagnose_output_sq_common(fmsg, &ptpsq->t=
xqsq, tc);
+	if (err)
+		return err;
+
+	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Port TS");
+	if (err)
+		return err;
+
+	err =3D mlx5e_health_cq_diag_fmsg(&ptpsq->ts_cq, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
=20
@@ -270,6 +280,23 @@ mlx5e_tx_reporter_diagnose_generic_txqsq(struct devlin=
k_fmsg *fmsg,
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
=20
+static int
+mlx5e_tx_reporter_diagnose_generic_tx_port_ts(struct devlink_fmsg *fmsg,
+					      struct mlx5e_ptpsq *ptpsq)
+{
+	int err;
+
+	err =3D mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Port TS");
+	if (err)
+		return err;
+
+	err =3D mlx5e_health_cq_common_diag_fmsg(&ptpsq->ts_cq, fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
 static int
 mlx5e_tx_reporter_diagnose_common_config(struct devlink_health_reporter *r=
eporter,
 					 struct devlink_fmsg *fmsg)
@@ -301,6 +328,10 @@ mlx5e_tx_reporter_diagnose_common_config(struct devlin=
k_health_reporter *reporte
 	if (err)
 		return err;
=20
+	err =3D mlx5e_tx_reporter_diagnose_generic_tx_port_ts(fmsg, generic_ptpsq=
);
+	if (err)
+		return err;
+
 	err =3D mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index e36a13238271..fd12d906d239 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1206,6 +1206,7 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev=
,
 	MLX5_SET(sqc,  sqc, tis_lst_sz, csp->tis_lst_sz);
 	MLX5_SET(sqc,  sqc, tis_num_0, csp->tisn);
 	MLX5_SET(sqc,  sqc, cqn, csp->cqn);
+	MLX5_SET(sqc,  sqc, ts_cqe_to_dest_cqn, csp->ts_cqe_to_dest_cqn);
=20
 	if (MLX5_CAP_ETH(mdev, wqe_inline_mode) =3D=3D MLX5_CAP_INLINE_MODE_VPORT=
_CONTEXT)
 		MLX5_SET(sqc,  sqc, min_wqe_inline_mode, csp->min_inline_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 9d57dc94c767..2cf2042b37c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1733,6 +1733,13 @@ static const struct counter_desc ptp_ch_stats_desc[]=
 =3D {
 	{ MLX5E_DECLARE_PTP_CH_STAT(struct mlx5e_ch_stats, eq_rearm) },
 };
=20
+static const struct counter_desc ptp_cq_stats_desc[] =3D {
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, err_cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns)=
 },
+};
+
 #define NUM_RQ_STATS			ARRAY_SIZE(rq_stats_desc)
 #define NUM_SQ_STATS			ARRAY_SIZE(sq_stats_desc)
 #define NUM_XDPSQ_STATS			ARRAY_SIZE(xdpsq_stats_desc)
@@ -1742,11 +1749,13 @@ static const struct counter_desc ptp_ch_stats_desc[=
] =3D {
 #define NUM_CH_STATS			ARRAY_SIZE(ch_stats_desc)
 #define NUM_PTP_SQ_STATS		ARRAY_SIZE(ptp_sq_stats_desc)
 #define NUM_PTP_CH_STATS		ARRAY_SIZE(ptp_ch_stats_desc)
+#define NUM_PTP_CQ_STATS		ARRAY_SIZE(ptp_cq_stats_desc)
=20
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
 {
 	return priv->port_ptp_opened ?
-	       NUM_PTP_CH_STATS + (NUM_PTP_SQ_STATS * priv->max_opened_tc) :
+	       NUM_PTP_CH_STATS +
+	       ((NUM_PTP_SQ_STATS + NUM_PTP_CQ_STATS) * priv->max_opened_tc) :
 	       0;
 }
=20
@@ -1766,6 +1775,10 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
 				ptp_sq_stats_desc[i].format, tc);
=20
+	for (tc =3D 0; tc < priv->max_opened_tc; tc++)
+		for (i =3D 0; i < NUM_PTP_CQ_STATS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				ptp_cq_stats_desc[i].format, tc);
 	return idx;
 }
=20
@@ -1787,6 +1800,12 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ptp)
 				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.sq[tc],
 						     ptp_sq_stats_desc, i);
=20
+	for (tc =3D 0; tc < priv->max_opened_tc; tc++)
+		for (i =3D 0; i < NUM_PTP_CQ_STATS; i++)
+			data[idx++] =3D
+				MLX5E_READ_CTR64_CPU(&priv->port_ptp_stats.cq[tc],
+						     ptp_cq_stats_desc, i);
+
 	return idx;
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 98ffebcc93b9..e41fc11f2ce7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -53,6 +53,7 @@
=20
 #define MLX5E_DECLARE_PTP_TX_STAT(type, fld) "ptp_tx%d_"#fld, offsetof(typ=
e, fld)
 #define MLX5E_DECLARE_PTP_CH_STAT(type, fld) "ptp_ch_"#fld, offsetof(type,=
 fld)
+#define MLX5E_DECLARE_PTP_CQ_STAT(type, fld) "ptp_cq%d_"#fld, offsetof(typ=
e, fld)
=20
 struct counter_desc {
 	char		format[ETH_GSTRING_LEN];
@@ -401,6 +402,13 @@ struct mlx5e_ch_stats {
 	u64 eq_rearm;
 };
=20
+struct mlx5e_ptp_cq_stats {
+	u64 cqe;
+	u64 err_cqe;
+	u64 abort;
+	u64 abort_abs_diff_ns;
+};
+
 struct mlx5e_stats {
 	struct mlx5e_sw_stats sw;
 	struct mlx5e_qcounter_stats qcnt;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 0ae68cb25035..5736645842f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -449,6 +449,12 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk=
_buff *skb,
=20
 	mlx5e_tx_check_stop(sq);
=20
+	if (unlikely(sq->ptpsq)) {
+		mlx5e_skb_cb_hwtstamp_init(skb);
+		mlx5e_skb_fifo_push(&sq->ptpsq->skb_fifo, skb);
+		skb_get(skb);
+	}
+
 	send_doorbell =3D __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_m=
ore);
 	if (send_doorbell)
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
@@ -753,7 +759,11 @@ static void mlx5e_consume_skb(struct mlx5e_txqsq *sq, =
struct sk_buff *skb,
 		u64 ts =3D get_cqe_ts(cqe);
=20
 		hwts.hwtstamp =3D mlx5_timecounter_cyc2time(sq->clock, ts);
-		skb_tstamp_tx(skb, &hwts);
+		if (sq->ptpsq)
+			mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_CQE_HWTSTAMP,
+						      hwts.hwtstamp, sq->ptpsq->cq_stats);
+		else
+			skb_tstamp_tx(skb, &hwts);
 	}
=20
 	napi_consume_skb(skb, napi_budget);
--=20
2.26.2

