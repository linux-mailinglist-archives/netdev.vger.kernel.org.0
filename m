Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0771631A7D3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBLWgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231923AbhBLWdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:33:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C93F764EAA;
        Fri, 12 Feb 2021 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169050;
        bh=mluaK0Nvt5a+LF10c0CLxSFUZdDYN69Z4JFLiNdVY6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEwwxHyWhewsUPnfZ1vyof7miNWKVBOMrHDhtWzF9KFgJTVcB5CIOps4TD0YTkLR+
         c2DibyskSEi1vYRIEfBsW+ksKqzr5Qe3+/C+U5KVP2Yd0C13fYf35L14lV76uc79O1
         0uPedDMXFBvPcBvV7zRcvXHpXxVtsjPE/yofwrpt92HgRu++HHw+UCru0WuVt98O0+
         Tpg2AfmClB5bbUrd2aeuZPxrAYXtVrV32Gue34blKbFlR2uQbK2w7ag5V1I8Hi4YXR
         qOoCVE55X46ARkI9iyTj3Cl6Qs3JPANkbA9LbZWBetSeaCocyMQoMpcFKuSsnXr6PS
         8G5sso1FkMmWA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 5/6] net/mlx5: Move some PPS logic into helper functions
Date:   Fri, 12 Feb 2021 14:30:41 -0800
Message-Id: <20210212223042.449816-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Some of PPS logic (timestamp calculations) fits only internal timer
timestamp mode. Move these logics into helper functions. Later in the
patchset cyc2time HW translation mode will expose its own PPS timestamp
calculations.

With this change, main flow will only hold calling PPS logic based on run
time mode.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 113 +++++++++++-------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index dcacaa451b53..dbb6138db096 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -314,6 +314,40 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 			       MLX5_EVENT_MODE_REPETETIVE & on);
 }
 
+static u64 find_target_cycles(struct mlx5_core_dev *mdev, s64 target_ns)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+	u64 cycles_now, cycles_delta;
+	u64 nsec_now, nsec_delta;
+	struct mlx5_timer *timer;
+	unsigned long flags;
+
+	timer = &clock->timer;
+
+	cycles_now = mlx5_read_internal_timer(mdev, NULL);
+	write_seqlock_irqsave(&clock->lock, flags);
+	nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
+	nsec_delta = target_ns - nsec_now;
+	cycles_delta = div64_u64(nsec_delta << timer->cycles.shift,
+				 timer->cycles.mult);
+	write_sequnlock_irqrestore(&clock->lock, flags);
+
+	return cycles_now + cycles_delta;
+}
+
+static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev,
+				      s64 sec, u32 nsec)
+{
+	struct timespec64 ts;
+	s64 target_ns;
+
+	ts.tv_sec = sec;
+	ts.tv_nsec = nsec;
+	target_ns = timespec64_to_ns(&ts);
+
+	return find_target_cycles(mdev, target_ns);
+}
+
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 				 struct ptp_clock_request *rq,
 				 int on)
@@ -322,13 +356,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_core_dev *mdev =
 			container_of(clock, struct mlx5_core_dev, clock);
-	struct mlx5_timer *timer = &clock->timer;
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
-	u64 nsec_now, nsec_delta, time_stamp = 0;
-	u64 cycles_now, cycles_delta;
 	struct timespec64 ts;
-	unsigned long flags;
 	u32 field_select = 0;
+	u64 time_stamp = 0;
 	u8 pin_mode = 0;
 	u8 pattern = 0;
 	int pin = -1;
@@ -345,12 +376,15 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (rq->perout.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
-	pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT,
-			   rq->perout.index);
-	if (pin < 0)
-		return -EBUSY;
-
+	field_select = MLX5_MTPPS_FS_ENABLE;
 	if (on) {
+		u32 nsec;
+		s64 sec;
+
+		pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT, rq->perout.index);
+		if (pin < 0)
+			return -EBUSY;
+
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
 		ts.tv_sec = rq->perout.period.sec;
@@ -360,23 +394,14 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		if ((ns >> 1) != 500000000LL)
 			return -EINVAL;
 
-		ts.tv_sec = rq->perout.start.sec;
-		ts.tv_nsec = rq->perout.start.nsec;
-		ns = timespec64_to_ns(&ts);
-		cycles_now = mlx5_read_internal_timer(mdev, NULL);
-		write_seqlock_irqsave(&clock->lock, flags);
-		nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
-		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << timer->cycles.shift,
-					 timer->cycles.mult);
-		write_sequnlock_irqrestore(&clock->lock, flags);
-		time_stamp = cycles_now + cycles_delta;
-		field_select = MLX5_MTPPS_FS_PIN_MODE |
-			       MLX5_MTPPS_FS_PATTERN |
-			       MLX5_MTPPS_FS_ENABLE |
-			       MLX5_MTPPS_FS_TIME_STAMP;
-	} else {
-		field_select = MLX5_MTPPS_FS_ENABLE;
+		nsec = rq->perout.start.nsec;
+		sec = rq->perout.start.sec;
+
+		time_stamp = perout_conf_internal_timer(mdev, sec, nsec);
+
+		field_select |= MLX5_MTPPS_FS_PIN_MODE |
+				MLX5_MTPPS_FS_PATTERN |
+				MLX5_MTPPS_FS_TIME_STAMP;
 	}
 
 	MLX5_SET(mtpps_reg, in, pin, pin);
@@ -547,19 +572,35 @@ static void mlx5_get_pps_caps(struct mlx5_core_dev *mdev)
 	clock->pps_info.pin_caps[7] = MLX5_GET(mtpps_reg, out, cap_pin_7_mode);
 }
 
+static void ts_next_sec(struct timespec64 *ts)
+{
+	ts->tv_sec += 1;
+	ts->tv_nsec = 0;
+}
+
+static u64 perout_conf_next_event_inernal_timer(struct mlx5_core_dev *mdev,
+						struct mlx5_clock *clock)
+{
+	struct timespec64 ts;
+	s64 target_ns;
+
+	mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
+	ts_next_sec(&ts);
+	target_ns = timespec64_to_ns(&ts);
+
+	return find_target_cycles(mdev, target_ns);
+}
+
 static int mlx5_pps_event(struct notifier_block *nb,
 			  unsigned long type, void *data)
 {
 	struct mlx5_clock *clock = mlx5_nb_cof(nb, struct mlx5_clock, pps_nb);
-	struct mlx5_timer *timer = &clock->timer;
 	struct ptp_clock_event ptp_event;
-	u64 cycles_now, cycles_delta;
-	u64 nsec_now, nsec_delta, ns;
 	struct mlx5_eqe *eqe = data;
 	int pin = eqe->data.pps.pin;
 	struct mlx5_core_dev *mdev;
-	struct timespec64 ts;
 	unsigned long flags;
+	u64 ns;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 
@@ -580,17 +621,9 @@ static int mlx5_pps_event(struct notifier_block *nb,
 		ptp_clock_event(clock->ptp, &ptp_event);
 		break;
 	case PTP_PF_PEROUT:
-		mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
-		cycles_now = mlx5_read_internal_timer(mdev, NULL);
-		ts.tv_sec += 1;
-		ts.tv_nsec = 0;
-		ns = timespec64_to_ns(&ts);
+		ns = perout_conf_next_event_inernal_timer(mdev, clock);
 		write_seqlock_irqsave(&clock->lock, flags);
-		nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
-		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << timer->cycles.shift,
-					 timer->cycles.mult);
-		clock->pps_info.start[pin] = cycles_now + cycles_delta;
+		clock->pps_info.start[pin] = ns;
 		write_sequnlock_irqrestore(&clock->lock, flags);
 		schedule_work(&clock->pps_info.out_work);
 		break;
-- 
2.29.2

