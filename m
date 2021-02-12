Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6570231A7D2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhBLWgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhBLWdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:33:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64C9164EA6;
        Fri, 12 Feb 2021 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169050;
        bh=QFIlPgYKGvUI3weBT5OMCg0y373Zrm+jkdaKaV8zs1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsQkc2xqYXuBffJ3ijjH0G5gs0QPV1s6UuXhKoQY2mwDIRinW2Pa8HInHQviFhqVt
         h4REP3Njkuqrb8ArAJppmgK33kCWA5QmOCtdzqxSRhZJ3kMmyOrhhVxfqxhE08bFx8
         caJbdDyJkNJFF7JjGBNc4ilfKykBSw/Y0vaRNETKf10daroo3UygZIYC/boTf4TdpI
         gXl5EkBY7lOyC/ToKxX/HRzjvGUGlySLjw4U6diKg3eo5YSIFz4zcK76O+bVj2QUDu
         ES5SX8EPenpVIR+gJPPLh9BzCJjFO0fcNVfmIpzrSJ/ANFeqtAp+xzuDDY7dJ7rgh0
         Nixqp2LJReaXA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH mlx5-next 6/6] net/mlx5: Add cyc2time HW translation mode support
Date:   Fri, 12 Feb 2021 14:30:42 -0800
Message-Id: <20210212223042.449816-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Device timestamp can be in real time mode (cycles to time translation is
offloaded into the Hardware). With real time mode, HW provides timestamp
which is already translated into nanoseconds.

With this mode, driver adjusts both the HW and timecounter (to keep
clock_info_page updated) using callbacks: adjfreq, adjtime and settime.
HW clock modifications are done via MTUTC access reg commands. Driver is
allowed to modify HW real time clock only if MCAM ptpcyc2realtime_modify
capability is set.

Add MTUTC set function to be used for configuring the HW real time
clock. Modify existing code to support both internal timer (with
conversion via timecounter_cyc2time() and real time (no conversions).

Align the signatures of the helpers converting from timestamp to
nanoseconds. With that, when allocating a queue assign the corresponding
callback with respect to the capability.

Adjust 1PPS timestamp calculation flows based on the timestamp mode.

Cyc2time offload brings two major advantages:
- Improve MTAE (Max Time Absolute Error) for HW TS by up to 160 ns over a
  100% loaded CPU.
- Faster data-path timestamp to nanoseconds, as translation is
  lock-less and done in HW.

On real time mode, timestamp format is 32 high bits of seconds and 32
low bits of nanoseconds. On some flows, driver shall convert this format
into nanoseconds wall-clock with REAL_TIME_TO_NS macro.

HW supports a single clock, and it is shared by all functions on a
device. In case real time clock is used, it is recommended to use
a single GM to all device's functions.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 197 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |  33 +++
 8 files changed, 241 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 055baf3b6cb1..096e44d2ab4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -56,6 +56,7 @@
 #include "en/dcbnl.h"
 #include "en/fs.h"
 #include "lib/hv_vhca.h"
+#include "lib/clock.h"
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
@@ -389,6 +390,7 @@ struct mlx5e_txqsq {
 	u32                        rate_limit;
 	struct work_struct         recover_work;
 	struct mlx5e_ptpsq        *ptpsq;
+	cqe_ts_to_ns               ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_dma_info {
@@ -650,6 +652,7 @@ struct mlx5e_rq {
 
 	/* XDP read-mostly */
 	struct xdp_rxq_info    xdp_rxq;
+	cqe_ts_to_ns           ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
 enum mlx5e_channel_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 2a2bac30daaa..b1a2b1418803 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -3,7 +3,6 @@
 
 #include "en/ptp.h"
 #include "en/txrx.h"
-#include "lib/clock.h"
 
 struct mlx5e_skb_cb_hwtstamp {
 	ktime_t cqe_hwtstamp;
@@ -70,6 +69,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 				    int budget)
 {
 	struct sk_buff *skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
 	ktime_t hwtstamp;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
@@ -77,7 +77,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	hwtstamp = mlx5_timecounter_cyc2time(ptpsq->txqsq.clock, get_cqe_ts(cqe));
+	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
 	mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_PORT_HWTSTAMP,
 				      hwtstamp, ptpsq->cq_stats);
 	ptpsq->cq_stats->cqe++;
@@ -183,6 +183,9 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_port_ptp *c, int txq_ix,
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	sq->stop_room = param->stop_room;
+	sq->ptp_cyc2time = mlx5_is_real_time_sq(mdev) ?
+			   mlx5_real_time_cyc2time :
+			   mlx5_timecounter_cyc2time;
 
 	node = dev_to_node(mlx5_core_dma_dev(mdev));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 4880f2179273..2371b83dad9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -26,6 +26,13 @@
 
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
 
+static inline
+ktime_t mlx5e_cqe_ts_to_ns(cqe_ts_to_ns func, struct mlx5_clock *clock, u64 cqe_ts)
+{
+	return INDIRECT_CALL_2(func, mlx5_real_time_cyc2time, mlx5_timecounter_cyc2time,
+			       clock, cqe_ts);
+}
+
 enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_NOP,
 	MLX5E_ICOSQ_WQE_UMR_RX,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6a852b4901aa..e40dec25cf6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -422,6 +422,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq   = &c->rq_xdpsq;
 	rq->xsk_pool = xsk_pool;
+	rq->ptp_cyc2time = mlx5_is_real_time_rq(mdev) ?
+			   mlx5_real_time_cyc2time :
+			   mlx5_timecounter_cyc2time;
 
 	if (rq->xsk_pool)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
@@ -654,7 +657,7 @@ static int mlx5e_create_rq(struct mlx5e_rq *rq,
 			   struct mlx5e_rq_param *param)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
-
+	u8 ts_format;
 	void *in;
 	void *rqc;
 	void *wq;
@@ -667,6 +670,9 @@ static int mlx5e_create_rq(struct mlx5e_rq *rq,
 	if (!in)
 		return -ENOMEM;
 
+	ts_format = mlx5_is_real_time_rq(mdev) ?
+		    MLX5_RQC_TIMESTAMP_FORMAT_REAL_TIME :
+		    MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING;
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 	wq  = MLX5_ADDR_OF(rqc, rqc, wq);
 
@@ -674,6 +680,7 @@ static int mlx5e_create_rq(struct mlx5e_rq *rq,
 
 	MLX5_SET(rqc,  rqc, cqn,		rq->cq.mcq.cqn);
 	MLX5_SET(rqc,  rqc, state,		MLX5_RQC_STATE_RST);
+	MLX5_SET(rqc,  rqc, ts_format,		ts_format);
 	MLX5_SET(wq,   wq,  log_wq_pg_sz,	rq->wq_ctrl.buf.page_shift -
 						MLX5_ADAPTER_PAGE_SHIFT);
 	MLX5_SET64(wq, wq,  dbr_addr,		rq->wq_ctrl.db.dma);
@@ -1154,6 +1161,9 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	sq->stop_room = param->stop_room;
+	sq->ptp_cyc2time = mlx5_is_real_time_sq(mdev) ?
+			   mlx5_real_time_cyc2time :
+			   mlx5_timecounter_cyc2time;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1187,6 +1197,7 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 			   struct mlx5e_create_sq_param *csp,
 			   u32 *sqn)
 {
+	u8 ts_format;
 	void *in;
 	void *sqc;
 	void *wq;
@@ -1199,6 +1210,9 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 	if (!in)
 		return -ENOMEM;
 
+	ts_format = mlx5_is_real_time_sq(mdev) ?
+		    MLX5_SQC_TIMESTAMP_FORMAT_REAL_TIME :
+		    MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING;
 	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
@@ -1207,6 +1221,8 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 	MLX5_SET(sqc,  sqc, tis_num_0, csp->tisn);
 	MLX5_SET(sqc,  sqc, cqn, csp->cqn);
 	MLX5_SET(sqc,  sqc, ts_cqe_to_dest_cqn, csp->ts_cqe_to_dest_cqn);
+	MLX5_SET(sqc,  sqc, ts_format, ts_format);
+
 
 	if (MLX5_CAP_ETH(mdev, wqe_inline_mode) == MLX5_CAP_INLINE_MODE_VPORT_CONTEXT)
 		MLX5_SET(sqc,  sqc, min_wqe_inline_mode, csp->min_inline_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7f5851c61218..25e5ce7ec6f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -47,7 +47,6 @@
 #include "fpga/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
-#include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
@@ -1066,9 +1065,8 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	}
 
 	if (unlikely(mlx5e_rx_hw_stamp(rq->tstamp)))
-		skb_hwtstamps(skb)->hwtstamp =
-				mlx5_timecounter_cyc2time(rq->clock, get_cqe_ts(cqe));
-
+		skb_hwtstamps(skb)->hwtstamp = mlx5e_cqe_ts_to_ns(rq->ptp_cyc2time,
+								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
 	if (likely(netdev->features & NETIF_F_RXHASH))
@@ -1667,9 +1665,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	}
 
 	if (unlikely(mlx5e_rx_hw_stamp(tstamp)))
-		skb_hwtstamps(skb)->hwtstamp =
-				mlx5_timecounter_cyc2time(rq->clock, get_cqe_ts(cqe));
-
+		skb_hwtstamps(skb)->hwtstamp = mlx5e_cqe_ts_to_ns(rq->ptp_cyc2time,
+								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
 	if (likely(netdev->features & NETIF_F_RXHASH))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 61ed671fe741..31ecce5c3163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -39,7 +39,6 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
-#include "lib/clock.h"
 #include "en/ptp.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -774,7 +773,7 @@ static void mlx5e_consume_skb(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		struct skb_shared_hwtstamps hwts = {};
 		u64 ts = get_cqe_ts(cqe);
 
-		hwts.hwtstamp = mlx5_timecounter_cyc2time(sq->clock, ts);
+		hwts.hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, ts);
 		if (sq->ptpsq)
 			mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_CQE_HWTSTAMP,
 						      hwts.hwtstamp, sq->ptpsq->cq_stats);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index dbb6138db096..b0e129d0f6d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -67,24 +67,51 @@ enum {
 	MLX5_MTPPS_FS_ENH_OUT_PER_ADJ		= BIT(0x7),
 };
 
-static u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
-				    struct ptp_system_timestamp *sts)
+static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
+{
+	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
+}
+
+static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
+}
+
+static int mlx5_set_mtutc(struct mlx5_core_dev *dev, u32 *mtutc, u32 size)
+{
+	u32 out[MLX5_ST_SZ_DW(mtutc_reg)] = {};
+
+	if (!MLX5_CAP_MCAM_REG(dev, mtutc))
+		return -EOPNOTSUPP;
+
+	return mlx5_core_access_reg(dev, mtutc, size, out, sizeof(out),
+				    MLX5_REG_MTUTC, 0, 1);
+}
+
+static u64 mlx5_read_time(struct mlx5_core_dev *dev,
+			  struct ptp_system_timestamp *sts,
+			  bool real_time)
 {
 	u32 timer_h, timer_h1, timer_l;
 
-	timer_h = ioread32be(&dev->iseg->internal_timer_h);
+	timer_h = ioread32be(real_time ? &dev->iseg->real_time_h :
+			     &dev->iseg->internal_timer_h);
 	ptp_read_system_prets(sts);
-	timer_l = ioread32be(&dev->iseg->internal_timer_l);
+	timer_l = ioread32be(real_time ? &dev->iseg->real_time_l :
+			     &dev->iseg->internal_timer_l);
 	ptp_read_system_postts(sts);
-	timer_h1 = ioread32be(&dev->iseg->internal_timer_h);
+	timer_h1 = ioread32be(real_time ? &dev->iseg->real_time_h :
+			      &dev->iseg->internal_timer_h);
 	if (timer_h != timer_h1) {
 		/* wrap around */
 		ptp_read_system_prets(sts);
-		timer_l = ioread32be(&dev->iseg->internal_timer_l);
+		timer_l = ioread32be(real_time ? &dev->iseg->real_time_l :
+				     &dev->iseg->internal_timer_l);
 		ptp_read_system_postts(sts);
 	}
 
-	return (u64)timer_l | (u64)timer_h1 << 32;
+	return real_time ? REAL_TIME_TO_NS(timer_h1, timer_l) :
+			   (u64)timer_l | (u64)timer_h1 << 32;
 }
 
 static u64 read_internal_timer(const struct cyclecounter *cc)
@@ -94,7 +121,7 @@ static u64 read_internal_timer(const struct cyclecounter *cc)
 	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev,
 						  clock);
 
-	return mlx5_read_internal_timer(mdev, NULL) & cc->mask;
+	return mlx5_read_time(mdev, NULL, false) & cc->mask;
 }
 
 static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
@@ -169,23 +196,58 @@ static void mlx5_timestamp_overflow(struct work_struct *work)
 	schedule_delayed_work(&timer->overflow_work, timer->overflow_period);
 }
 
+static int mlx5_ptp_settime_real_time(struct mlx5_core_dev *mdev,
+				      const struct timespec64 *ts)
+{
+	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
+
+	if (!mlx5_modify_mtutc_allowed(mdev))
+		return 0;
+
+	if (ts->tv_sec < 0 || ts->tv_sec > U32_MAX ||
+	    ts->tv_nsec < 0 || ts->tv_nsec > NSEC_PER_SEC)
+		return -EINVAL;
+
+	MLX5_SET(mtutc_reg, in, operation, MLX5_MTUTC_OPERATION_SET_TIME_IMMEDIATE);
+	MLX5_SET(mtutc_reg, in, utc_sec, ts->tv_sec);
+	MLX5_SET(mtutc_reg, in, utc_nsec, ts->tv_nsec);
+
+	return mlx5_set_mtutc(mdev, in, sizeof(in));
+}
+
 static int mlx5_ptp_settime(struct ptp_clock_info *ptp, const struct timespec64 *ts)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_timer *timer = &clock->timer;
-	u64 ns = timespec64_to_ns(ts);
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
+	int err;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
+	err = mlx5_ptp_settime_real_time(mdev, ts);
+	if (err)
+		return err;
+
 	write_seqlock_irqsave(&clock->lock, flags);
-	timecounter_init(&timer->tc, &timer->cycles, ns);
+	timecounter_init(&timer->tc, &timer->cycles, timespec64_to_ns(ts));
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
 	return 0;
 }
 
+static
+struct timespec64 mlx5_ptp_gettimex_real_time(struct mlx5_core_dev *mdev,
+					      struct ptp_system_timestamp *sts)
+{
+	struct timespec64 ts;
+	u64 time;
+
+	time = mlx5_read_time(mdev, sts, true);
+	ts = ns_to_timespec64(time);
+	return ts;
+}
+
 static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 			     struct ptp_system_timestamp *sts)
 {
@@ -196,24 +258,57 @@ static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 	u64 cycles, ns;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
+	if (mlx5_real_time_mode(mdev)) {
+		*ts = mlx5_ptp_gettimex_real_time(mdev, sts);
+		goto out;
+	}
+
 	write_seqlock_irqsave(&clock->lock, flags);
-	cycles = mlx5_read_internal_timer(mdev, sts);
+	cycles = mlx5_read_time(mdev, sts, false);
 	ns = timecounter_cyc2time(&timer->tc, cycles);
 	write_sequnlock_irqrestore(&clock->lock, flags);
-
 	*ts = ns_to_timespec64(ns);
-
+out:
 	return 0;
 }
 
+static int mlx5_ptp_adjtime_real_time(struct mlx5_core_dev *mdev, s64 delta)
+{
+	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
+
+	if (!mlx5_modify_mtutc_allowed(mdev))
+		return 0;
+
+	/* HW time adjustment range is s16. If out of range, settime instead */
+	if (delta < S16_MIN || delta > S16_MAX) {
+		struct timespec64 ts;
+		s64 ns;
+
+		ts = mlx5_ptp_gettimex_real_time(mdev, NULL);
+		ns = timespec64_to_ns(&ts) + delta;
+		ts = ns_to_timespec64(ns);
+		return mlx5_ptp_settime_real_time(mdev, &ts);
+	}
+
+	MLX5_SET(mtutc_reg, in, operation, MLX5_MTUTC_OPERATION_ADJUST_TIME);
+	MLX5_SET(mtutc_reg, in, time_adjustment, delta);
+
+	return mlx5_set_mtutc(mdev, in, sizeof(in));
+}
+
 static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
+	int err;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
+	err = mlx5_ptp_adjtime_real_time(mdev, delta);
+	if (err)
+		return err;
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_adjtime(&timer->tc, delta);
 	mlx5_update_clock_info_page(mdev);
@@ -222,6 +317,19 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
+static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
+{
+	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
+
+	if (!mlx5_modify_mtutc_allowed(mdev))
+		return 0;
+
+	MLX5_SET(mtutc_reg, in, operation, MLX5_MTUTC_OPERATION_ADJUST_FREQ_UTC);
+	MLX5_SET(mtutc_reg, in, freq_adjustment, freq);
+
+	return mlx5_set_mtutc(mdev, in, sizeof(in));
+}
+
 static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
@@ -231,6 +339,12 @@ static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	int neg_adj = 0;
 	u32 diff;
 	u64 adj;
+	int err;
+
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+	err = mlx5_ptp_adjfreq_real_time(mdev, delta);
+	if (err)
+		return err;
 
 	if (delta < 0) {
 		neg_adj = 1;
@@ -241,7 +355,6 @@ static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	adj *= delta;
 	diff = div_u64(adj, 1000000000ULL);
 
-	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&timer->tc);
 	timer->cycles.mult = neg_adj ? timer->nominal_c_mult - diff :
@@ -324,7 +437,7 @@ static u64 find_target_cycles(struct mlx5_core_dev *mdev, s64 target_ns)
 
 	timer = &clock->timer;
 
-	cycles_now = mlx5_read_internal_timer(mdev, NULL);
+	cycles_now = mlx5_read_time(mdev, NULL, false);
 	write_seqlock_irqsave(&clock->lock, flags);
 	nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
 	nsec_delta = target_ns - nsec_now;
@@ -348,6 +461,11 @@ static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev,
 	return find_target_cycles(mdev, target_ns);
 }
 
+static u64 perout_conf_real_time(s64 sec, u32 nsec)
+{
+	return (u64)nsec | (u64)sec << 32;
+}
+
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 				 struct ptp_clock_request *rq,
 				 int on)
@@ -378,6 +496,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 
 	field_select = MLX5_MTPPS_FS_ENABLE;
 	if (on) {
+		bool rt_mode = mlx5_real_time_mode(mdev);
 		u32 nsec;
 		s64 sec;
 
@@ -397,7 +516,11 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		nsec = rq->perout.start.nsec;
 		sec = rq->perout.start.sec;
 
-		time_stamp = perout_conf_internal_timer(mdev, sec, nsec);
+		if (rt_mode && sec > U32_MAX)
+			return -EINVAL;
+
+		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
+				       perout_conf_internal_timer(mdev, sec, nsec);
 
 		field_select |= MLX5_MTPPS_FS_PIN_MODE |
 				MLX5_MTPPS_FS_PATTERN |
@@ -578,17 +701,23 @@ static void ts_next_sec(struct timespec64 *ts)
 	ts->tv_nsec = 0;
 }
 
-static u64 perout_conf_next_event_inernal_timer(struct mlx5_core_dev *mdev,
-						struct mlx5_clock *clock)
+static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
+					struct mlx5_clock *clock)
 {
+	bool rt_mode = mlx5_real_time_mode(mdev);
 	struct timespec64 ts;
 	s64 target_ns;
 
-	mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
+	if (rt_mode)
+		ts = mlx5_ptp_gettimex_real_time(mdev, NULL);
+	else
+		mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
+
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
-	return find_target_cycles(mdev, target_ns);
+	return rt_mode ? perout_conf_real_time(ts.tv_sec, ts.tv_nsec) :
+			 find_target_cycles(mdev, target_ns);
 }
 
 static int mlx5_pps_event(struct notifier_block *nb,
@@ -607,7 +736,9 @@ static int mlx5_pps_event(struct notifier_block *nb,
 	switch (clock->ptp_info.pin_config[pin].func) {
 	case PTP_PF_EXTTS:
 		ptp_event.index = pin;
-		ptp_event.timestamp =
+		ptp_event.timestamp = mlx5_real_time_mode(mdev) ?
+			mlx5_real_time_cyc2time(clock,
+						be64_to_cpu(eqe->data.pps.time_stamp)) :
 			mlx5_timecounter_cyc2time(clock,
 						  be64_to_cpu(eqe->data.pps.time_stamp));
 		if (clock->pps_info.enabled) {
@@ -621,7 +752,7 @@ static int mlx5_pps_event(struct notifier_block *nb,
 		ptp_clock_event(clock->ptp, &ptp_event);
 		break;
 	case PTP_PF_PEROUT:
-		ns = perout_conf_next_event_inernal_timer(mdev, clock);
+		ns = perout_conf_next_event_timer(mdev, clock);
 		write_seqlock_irqsave(&clock->lock, flags);
 		clock->pps_info.start[pin] = ns;
 		write_sequnlock_irqrestore(&clock->lock, flags);
@@ -711,6 +842,23 @@ static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
 	info->frac = timer->tc.frac;
 }
 
+static void mlx5_init_timer_clock(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+
+	mlx5_timecounter_init(mdev);
+	mlx5_init_clock_info(mdev);
+	mlx5_init_overflow_period(clock);
+	clock->ptp_info = mlx5_ptp_clock_info;
+
+	if (mlx5_real_time_mode(mdev)) {
+		struct timespec64 ts;
+
+		ktime_get_real_ts64(&ts);
+		mlx5_ptp_settime(&clock->ptp_info, &ts);
+	}
+}
+
 void mlx5_init_clock(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
@@ -721,10 +869,7 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	}
 
 	seqlock_init(&clock->lock);
-
-	mlx5_timecounter_init(mdev);
-	mlx5_init_clock_info(mdev);
-	mlx5_init_overflow_period(clock);
+	mlx5_init_timer_clock(mdev);
 	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 
 	/* Configure the PHC */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index 6e8804ebc773..a12c7da618a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -33,6 +33,24 @@
 #ifndef __LIB_CLOCK_H__
 #define __LIB_CLOCK_H__
 
+static inline bool mlx5_is_real_time_rq(struct mlx5_core_dev *mdev)
+{
+	u8 rq_ts_format_cap = MLX5_CAP_GEN(mdev, rq_ts_format);
+
+	return (rq_ts_format_cap == MLX5_RQ_TIMESTAMP_FORMAT_CAP_REAL_TIME  ||
+		rq_ts_format_cap == MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
+}
+
+static inline bool mlx5_is_real_time_sq(struct mlx5_core_dev *mdev)
+{
+	u8 sq_ts_format_cap = MLX5_CAP_GEN(mdev, sq_ts_format);
+
+	return (sq_ts_format_cap == MLX5_SQ_TIMESTAMP_FORMAT_CAP_REAL_TIME  ||
+		sq_ts_format_cap == MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
+}
+
+typedef ktime_t (*cqe_ts_to_ns)(struct mlx5_clock *, u64);
+
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 void mlx5_init_clock(struct mlx5_core_dev *mdev);
 void mlx5_cleanup_clock(struct mlx5_core_dev *mdev);
@@ -57,6 +75,15 @@ static inline ktime_t mlx5_timecounter_cyc2time(struct mlx5_clock *clock,
 	return ns_to_ktime(nsec);
 }
 
+#define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u64)low))
+
+static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *clock,
+					      u64 timestamp)
+{
+	u64 time = REAL_TIME_TO_NS(timestamp >> 32, timestamp & 0xFFFFFFFF);
+
+	return ns_to_ktime(time);
+}
 #else
 static inline void mlx5_init_clock(struct mlx5_core_dev *mdev) {}
 static inline void mlx5_cleanup_clock(struct mlx5_core_dev *mdev) {}
@@ -70,6 +97,12 @@ static inline ktime_t mlx5_timecounter_cyc2time(struct mlx5_clock *clock,
 {
 	return 0;
 }
+
+static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *clock,
+					      u64 timestamp)
+{
+	return 0;
+}
 #endif
 
 #endif
-- 
2.29.2

