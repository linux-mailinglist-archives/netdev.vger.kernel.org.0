Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2973C31A7CC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBLWfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhBLWbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:31:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7FC64EA1;
        Fri, 12 Feb 2021 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169049;
        bh=E1sB7Fj4WA2Q6n0vBuD6YV2HPBpwJhQYCCC3WyScQE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dy0N9Cueeudg+FyTvUtlvnuKJHB9MXIDM/FhAuaxWl8MMXkR2SOz1PrYCE1cKSYHY
         tkRuANpPpwIYDfr3fhm8xZ51GVgoy12/byDBpsf3OLdSgnbEW74Xnq6TKB46rG1xfw
         U7nha1Kyf5fLTMtrUJJ94oqN5EGy1raqHvz4O/7BT3hwEQVJT5IxHck9Js3o1a5j3A
         pg4GqDOcDT1kGu2gw2VD0QUnxhrvSwF4c3K21Jf3pYCQHxd/GC2pIvV9+g1Jh97AQF
         MaHCgW300tD3cTi2NupD5tladmubxnq2DwQxocfkKT84+YEwBrgEY8f+Hy47gNSw3M
         3XqTJ0MnDDm0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@nvidia.com>
Subject: [PATCH mlx5-next 4/6] net/mlx5: Move all internal timer metadata into a dedicated struct
Date:   Fri, 12 Feb 2021 14:30:40 -0800
Message-Id: <20210212223042.449816-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Internal timer mode (SW clock) requires some PTP clock related metadata
structs. Real time mode (HW clock) will not need these metadata structs.
This separation emphasize the different interfaces for HW clock and SW
clock.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 107 ++++++++++--------
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |   3 +-
 include/linux/mlx5/driver.h                   |  12 +-
 3 files changed, 71 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index aaf7d837a967..dcacaa451b53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -89,7 +89,8 @@ static u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
 
 static u64 read_internal_timer(const struct cyclecounter *cc)
 {
-	struct mlx5_clock *clock = container_of(cc, struct mlx5_clock, cycles);
+	struct mlx5_timer *timer = container_of(cc, struct mlx5_timer, cycles);
+	struct mlx5_clock *clock = container_of(timer, struct mlx5_clock, timer);
 	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev,
 						  clock);
 
@@ -100,6 +101,7 @@ static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
 	struct mlx5_clock *clock = &mdev->clock;
+	struct mlx5_timer *timer;
 	u32 sign;
 
 	if (!clock_info)
@@ -109,10 +111,11 @@ static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
 	smp_store_mb(clock_info->sign,
 		     sign | MLX5_IB_CLOCK_INFO_KERNEL_UPDATING);
 
-	clock_info->cycles = clock->tc.cycle_last;
-	clock_info->mult   = clock->cycles.mult;
-	clock_info->nsec   = clock->tc.nsec;
-	clock_info->frac   = clock->tc.frac;
+	timer = &clock->timer;
+	clock_info->cycles = timer->tc.cycle_last;
+	clock_info->mult   = timer->cycles.mult;
+	clock_info->nsec   = timer->tc.nsec;
+	clock_info->frac   = timer->tc.frac;
 
 	smp_store_release(&clock_info->sign,
 			  sign + MLX5_IB_CLOCK_INFO_KERNEL_UPDATING * 2);
@@ -151,28 +154,32 @@ static void mlx5_timestamp_overflow(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct mlx5_core_dev *mdev;
+	struct mlx5_timer *timer;
 	struct mlx5_clock *clock;
 	unsigned long flags;
 
-	clock = container_of(dwork, struct mlx5_clock, overflow_work);
+	timer = container_of(dwork, struct mlx5_timer, overflow_work);
+	clock = container_of(timer, struct mlx5_clock, timer);
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
 	write_seqlock_irqsave(&clock->lock, flags);
-	timecounter_read(&clock->tc);
+	timecounter_read(&timer->tc);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
-	schedule_delayed_work(&clock->overflow_work, clock->overflow_period);
+	schedule_delayed_work(&timer->overflow_work, timer->overflow_period);
 }
 
 static int mlx5_ptp_settime(struct ptp_clock_info *ptp, const struct timespec64 *ts)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_timer *timer = &clock->timer;
 	u64 ns = timespec64_to_ns(ts);
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
-	timecounter_init(&clock->tc, &clock->cycles, ns);
+	timecounter_init(&timer->tc, &timer->cycles, ns);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
@@ -183,6 +190,7 @@ static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 			     struct ptp_system_timestamp *sts)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 	u64 cycles, ns;
@@ -190,7 +198,7 @@ static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	cycles = mlx5_read_internal_timer(mdev, sts);
-	ns = timecounter_cyc2time(&clock->tc, cycles);
+	ns = timecounter_cyc2time(&timer->tc, cycles);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
 	*ts = ns_to_timespec64(ns);
@@ -201,12 +209,13 @@ static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
-	timecounter_adjtime(&clock->tc, delta);
+	timecounter_adjtime(&timer->tc, delta);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
@@ -216,27 +225,27 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 	int neg_adj = 0;
 	u32 diff;
 	u64 adj;
 
-
 	if (delta < 0) {
 		neg_adj = 1;
 		delta = -delta;
 	}
 
-	adj = clock->nominal_c_mult;
+	adj = timer->nominal_c_mult;
 	adj *= delta;
 	diff = div_u64(adj, 1000000000ULL);
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
-	timecounter_read(&clock->tc);
-	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
-				       clock->nominal_c_mult + diff;
+	timecounter_read(&timer->tc);
+	timer->cycles.mult = neg_adj ? timer->nominal_c_mult - diff :
+				       timer->nominal_c_mult + diff;
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
@@ -313,6 +322,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_core_dev *mdev =
 			container_of(clock, struct mlx5_core_dev, clock);
+	struct mlx5_timer *timer = &clock->timer;
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
 	u64 nsec_now, nsec_delta, time_stamp = 0;
 	u64 cycles_now, cycles_delta;
@@ -355,10 +365,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		ns = timespec64_to_ns(&ts);
 		cycles_now = mlx5_read_internal_timer(mdev, NULL);
 		write_seqlock_irqsave(&clock->lock, flags);
-		nsec_now = timecounter_cyc2time(&clock->tc, cycles_now);
+		nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
 		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << clock->cycles.shift,
-					 clock->cycles.mult);
+		cycles_delta = div64_u64(nsec_delta << timer->cycles.shift,
+					 timer->cycles.mult);
 		write_sequnlock_irqrestore(&clock->lock, flags);
 		time_stamp = cycles_now + cycles_delta;
 		field_select = MLX5_MTPPS_FS_PIN_MODE |
@@ -541,6 +551,7 @@ static int mlx5_pps_event(struct notifier_block *nb,
 			  unsigned long type, void *data)
 {
 	struct mlx5_clock *clock = mlx5_nb_cof(nb, struct mlx5_clock, pps_nb);
+	struct mlx5_timer *timer = &clock->timer;
 	struct ptp_clock_event ptp_event;
 	u64 cycles_now, cycles_delta;
 	u64 nsec_now, nsec_delta, ns;
@@ -575,10 +586,10 @@ static int mlx5_pps_event(struct notifier_block *nb,
 		ts.tv_nsec = 0;
 		ns = timespec64_to_ns(&ts);
 		write_seqlock_irqsave(&clock->lock, flags);
-		nsec_now = timecounter_cyc2time(&clock->tc, cycles_now);
+		nsec_now = timecounter_cyc2time(&timer->tc, cycles_now);
 		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << clock->cycles.shift,
-					 clock->cycles.mult);
+		cycles_delta = div64_u64(nsec_delta << timer->cycles.shift,
+					 timer->cycles.mult);
 		clock->pps_info.start[pin] = cycles_now + cycles_delta;
 		write_sequnlock_irqrestore(&clock->lock, flags);
 		schedule_work(&clock->pps_info.out_work);
@@ -594,17 +605,18 @@ static int mlx5_pps_event(struct notifier_block *nb,
 static void mlx5_timecounter_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
+	struct mlx5_timer *timer = &clock->timer;
 	u32 dev_freq;
 
 	dev_freq = MLX5_CAP_GEN(mdev, device_frequency_khz);
-	clock->cycles.read = read_internal_timer;
-	clock->cycles.shift = MLX5_CYCLES_SHIFT;
-	clock->cycles.mult = clocksource_khz2mult(dev_freq,
-						  clock->cycles.shift);
-	clock->nominal_c_mult = clock->cycles.mult;
-	clock->cycles.mask = CLOCKSOURCE_MASK(41);
-
-	timecounter_init(&clock->tc, &clock->cycles,
+	timer->cycles.read = read_internal_timer;
+	timer->cycles.shift = MLX5_CYCLES_SHIFT;
+	timer->cycles.mult = clocksource_khz2mult(dev_freq,
+						  timer->cycles.shift);
+	timer->nominal_c_mult = timer->cycles.mult;
+	timer->cycles.mask = CLOCKSOURCE_MASK(41);
+
+	timecounter_init(&timer->tc, &timer->cycles,
 			 ktime_to_ns(ktime_get_real()));
 }
 
@@ -612,6 +624,7 @@ static void mlx5_init_overflow_period(struct mlx5_clock *clock)
 {
 	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev, clock);
 	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
+	struct mlx5_timer *timer = &clock->timer;
 	u64 overflow_cycles;
 	u64 frac = 0;
 	u64 ns;
@@ -623,29 +636,30 @@ static void mlx5_init_overflow_period(struct mlx5_clock *clock)
 	 * multiplied by clock multiplier where the result doesn't exceed
 	 * 64bits.
 	 */
-	overflow_cycles = div64_u64(~0ULL >> 1, clock->cycles.mult);
-	overflow_cycles = min(overflow_cycles, div_u64(clock->cycles.mask, 3));
+	overflow_cycles = div64_u64(~0ULL >> 1, timer->cycles.mult);
+	overflow_cycles = min(overflow_cycles, div_u64(timer->cycles.mask, 3));
 
-	ns = cyclecounter_cyc2ns(&clock->cycles, overflow_cycles,
+	ns = cyclecounter_cyc2ns(&timer->cycles, overflow_cycles,
 				 frac, &frac);
 	do_div(ns, NSEC_PER_SEC / HZ);
-	clock->overflow_period = ns;
+	timer->overflow_period = ns;
 
-	INIT_DELAYED_WORK(&clock->overflow_work, mlx5_timestamp_overflow);
-	if (clock->overflow_period)
-		schedule_delayed_work(&clock->overflow_work, 0);
+	INIT_DELAYED_WORK(&timer->overflow_work, mlx5_timestamp_overflow);
+	if (timer->overflow_period)
+		schedule_delayed_work(&timer->overflow_work, 0);
 	else
 		mlx5_core_warn(mdev,
 			       "invalid overflow period, overflow_work is not scheduled\n");
 
 	if (clock_info)
-		clock_info->overflow_period = clock->overflow_period;
+		clock_info->overflow_period = timer->overflow_period;
 }
 
 static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
 	struct mlx5_ib_clock_info *info;
+	struct mlx5_timer *timer;
 
 	mdev->clock_info = (struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
 	if (!mdev->clock_info) {
@@ -654,13 +668,14 @@ static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
 	}
 
 	info = mdev->clock_info;
-
-	info->nsec = clock->tc.nsec;
-	info->cycles = clock->tc.cycle_last;
-	info->mask = clock->cycles.mask;
-	info->mult = clock->nominal_c_mult;
-	info->shift = clock->cycles.shift;
-	info->frac = clock->tc.frac;
+	timer = &clock->timer;
+
+	info->nsec = timer->tc.nsec;
+	info->cycles = timer->tc.cycle_last;
+	info->mask = timer->cycles.mask;
+	info->mult = timer->nominal_c_mult;
+	info->shift = timer->cycles.shift;
+	info->frac = timer->tc.frac;
 }
 
 void mlx5_init_clock(struct mlx5_core_dev *mdev)
@@ -714,7 +729,7 @@ void mlx5_cleanup_clock(struct mlx5_core_dev *mdev)
 	}
 
 	cancel_work_sync(&clock->pps_info.out_work);
-	cancel_delayed_work_sync(&clock->overflow_work);
+	cancel_delayed_work_sync(&clock->timer.overflow_work);
 
 	if (mdev->clock_info) {
 		free_page((unsigned long)mdev->clock_info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index 31600924bdc3..6e8804ebc773 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -45,12 +45,13 @@ static inline int mlx5_clock_get_ptp_index(struct mlx5_core_dev *mdev)
 static inline ktime_t mlx5_timecounter_cyc2time(struct mlx5_clock *clock,
 						u64 timestamp)
 {
+	struct mlx5_timer *timer = &clock->timer;
 	unsigned int seq;
 	u64 nsec;
 
 	do {
 		seq = read_seqbegin(&clock->lock);
-		nsec = timecounter_cyc2time(&clock->tc, timestamp);
+		nsec = timecounter_cyc2time(&timer->tc, timestamp);
 	} while (read_seqretry(&clock->lock, seq));
 
 	return ns_to_ktime(nsec);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2eb7755143d7..2f4d6182df1b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -662,18 +662,22 @@ struct mlx5_pps {
 	u8                         enabled;
 };
 
-struct mlx5_clock {
-	struct mlx5_nb             pps_nb;
-	seqlock_t                  lock;
+struct mlx5_timer {
 	struct cyclecounter        cycles;
 	struct timecounter         tc;
-	struct hwtstamp_config     hwtstamp_config;
 	u32                        nominal_c_mult;
 	unsigned long              overflow_period;
 	struct delayed_work        overflow_work;
+};
+
+struct mlx5_clock {
+	struct mlx5_nb             pps_nb;
+	seqlock_t                  lock;
+	struct hwtstamp_config     hwtstamp_config;
 	struct ptp_clock          *ptp;
 	struct ptp_clock_info      ptp_info;
 	struct mlx5_pps            pps_info;
+	struct mlx5_timer          timer;
 };
 
 struct mlx5_dm;
-- 
2.29.2

