Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B631A7C9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhBLWfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhBLWba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD65664E9C;
        Fri, 12 Feb 2021 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169049;
        bh=ZmsmFMd+Po8+DYDMNJYenetwqggAYLzQRV+79Sb9HI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6yLXvWAwN75r8RPE7ioiWH4qrY1ByNmdxBs9kXDfkfyLdyRTpxG2yaXTBdhbva4k
         v7t02xdD0VFEQOFRRpmzKOfo1S6tF+hujAMbvbKsDDSrPRqg4GAWnEhpFH+eNHuqS+
         1GkSrkQOX71qiFcs9w5sKE46eMY9beoeILLfiNM2QMcR2AxS4QxbbMWNDl8UV4YX6Q
         Lxja3mVASiQ/6QvhQoatzQ19hDNFNmP7YKFCAur1Kkd+/Y4xCFMrzQvWGfCEzK6WfI
         q3bssh4vZ3aFnWzBiUvddLo3wxinPngIbL4tD2eKgomtGiWcK0DsH6VOND/p0FJubI
         clJRTy/uU1ecw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 3/6] net/mlx5: Refactor init clock function
Date:   Fri, 12 Feb 2021 14:30:39 -0800
Message-Id: <20210212223042.449816-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Function mlx5_init_clock() is responsible for internal PTP related metadata
initializations. Break mlx5_init_clock() to sub functions, each takes care
of its own logic.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 76 +++++++++++++------
 1 file changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index c70c1f0ca0c1..aaf7d837a967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -591,20 +591,12 @@ static int mlx5_pps_event(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-void mlx5_init_clock(struct mlx5_core_dev *mdev)
+static void mlx5_timecounter_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
-	u64 overflow_cycles;
-	u64 ns;
-	u64 frac = 0;
 	u32 dev_freq;
 
 	dev_freq = MLX5_CAP_GEN(mdev, device_frequency_khz);
-	if (!dev_freq) {
-		mlx5_core_warn(mdev, "invalid device_frequency_khz, aborting HW clock init\n");
-		return;
-	}
-	seqlock_init(&clock->lock);
 	clock->cycles.read = read_internal_timer;
 	clock->cycles.shift = MLX5_CYCLES_SHIFT;
 	clock->cycles.mult = clocksource_khz2mult(dev_freq,
@@ -614,6 +606,15 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 
 	timecounter_init(&clock->tc, &clock->cycles,
 			 ktime_to_ns(ktime_get_real()));
+}
+
+static void mlx5_init_overflow_period(struct mlx5_clock *clock)
+{
+	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev, clock);
+	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
+	u64 overflow_cycles;
+	u64 frac = 0;
+	u64 ns;
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least twice every wrap around.
@@ -630,24 +631,53 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	do_div(ns, NSEC_PER_SEC / HZ);
 	clock->overflow_period = ns;
 
-	mdev->clock_info =
-		(struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
-	if (mdev->clock_info) {
-		mdev->clock_info->nsec = clock->tc.nsec;
-		mdev->clock_info->cycles = clock->tc.cycle_last;
-		mdev->clock_info->mask = clock->cycles.mask;
-		mdev->clock_info->mult = clock->nominal_c_mult;
-		mdev->clock_info->shift = clock->cycles.shift;
-		mdev->clock_info->frac = clock->tc.frac;
-		mdev->clock_info->overflow_period = clock->overflow_period;
-	}
-
-	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 	INIT_DELAYED_WORK(&clock->overflow_work, mlx5_timestamp_overflow);
 	if (clock->overflow_period)
 		schedule_delayed_work(&clock->overflow_work, 0);
 	else
-		mlx5_core_warn(mdev, "invalid overflow period, overflow_work is not scheduled\n");
+		mlx5_core_warn(mdev,
+			       "invalid overflow period, overflow_work is not scheduled\n");
+
+	if (clock_info)
+		clock_info->overflow_period = clock->overflow_period;
+}
+
+static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+	struct mlx5_ib_clock_info *info;
+
+	mdev->clock_info = (struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
+	if (!mdev->clock_info) {
+		mlx5_core_warn(mdev, "Failed to allocate IB clock info page\n");
+		return;
+	}
+
+	info = mdev->clock_info;
+
+	info->nsec = clock->tc.nsec;
+	info->cycles = clock->tc.cycle_last;
+	info->mask = clock->cycles.mask;
+	info->mult = clock->nominal_c_mult;
+	info->shift = clock->cycles.shift;
+	info->frac = clock->tc.frac;
+}
+
+void mlx5_init_clock(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+
+	if (!MLX5_CAP_GEN(mdev, device_frequency_khz)) {
+		mlx5_core_warn(mdev, "invalid device_frequency_khz, aborting HW clock init\n");
+		return;
+	}
+
+	seqlock_init(&clock->lock);
+
+	mlx5_timecounter_init(mdev);
+	mlx5_init_clock_info(mdev);
+	mlx5_init_overflow_period(clock);
+	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 
 	/* Configure the PHC */
 	clock->ptp_info = mlx5_ptp_clock_info;
-- 
2.29.2

