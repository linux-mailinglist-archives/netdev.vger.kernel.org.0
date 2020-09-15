Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36126AF34
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgIOU2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgIOU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:00 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41A59212CC;
        Tue, 15 Sep 2020 20:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201555;
        bh=Mgd0bBvJuBI59QKfqqPfdbn5p4ofeM4J2pdGmv2KLww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybjxr1GmkYY0vsCbblx1N8qQw3pQlYECbyaS0CmS9dI4M3rOjCDyo70O5XgAK8ecg
         QQCsNRjKQwXDj8+JLYg3DGnUz7k37Dm9jZDtFfE1Uh2u1s0TInhVdRy8zToDWxxTUy
         XIhbX5UcI3qKI/etUApeyAmRaY9G/LvnV+OL1Pm0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: Always use container_of to find mdev pointer from clock struct
Date:   Tue, 15 Sep 2020 13:25:20 -0700
Message-Id: <20200915202533.64389-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Clock struct is part of struct mlx5_core_dev. Code was inconsistent, on
some cases used container_of and on another used clock->mdev.

Align code to use container_of amd remove clock->mdev pointer.
While here, fix reverse xmas tree coding style.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 52 +++++++++++--------
 include/linux/mlx5/driver.h                   |  1 -
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 2d55b7c22c03..a07aeb97d027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -150,28 +150,30 @@ static void mlx5_pps_out(struct work_struct *work)
 static void mlx5_timestamp_overflow(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct mlx5_clock *clock = container_of(dwork, struct mlx5_clock,
-						overflow_work);
+	struct mlx5_core_dev *mdev;
+	struct mlx5_clock *clock;
 	unsigned long flags;
 
+	clock = container_of(dwork, struct mlx5_clock, overflow_work);
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&clock->tc);
-	mlx5_update_clock_info_page(clock->mdev);
+	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 	schedule_delayed_work(&clock->overflow_work, clock->overflow_period);
 }
 
-static int mlx5_ptp_settime(struct ptp_clock_info *ptp,
-			    const struct timespec64 *ts)
+static int mlx5_ptp_settime(struct ptp_clock_info *ptp, const struct timespec64 *ts)
 {
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
-						 ptp_info);
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
 	u64 ns = timespec64_to_ns(ts);
+	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_init(&clock->tc, &clock->cycles, ns);
-	mlx5_update_clock_info_page(clock->mdev);
+	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -180,13 +182,12 @@ static int mlx5_ptp_settime(struct ptp_clock_info *ptp,
 static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 			     struct ptp_system_timestamp *sts)
 {
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
-						ptp_info);
-	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev,
-						  clock);
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 	u64 cycles, ns;
 
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	cycles = mlx5_read_internal_timer(mdev, sts);
 	ns = timecounter_cyc2time(&clock->tc, cycles);
@@ -199,13 +200,14 @@ static int mlx5_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
 
 static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
-						ptp_info);
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_adjtime(&clock->tc, delta);
-	mlx5_update_clock_info_page(clock->mdev);
+	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -213,12 +215,13 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 {
-	u64 adj;
-	u32 diff;
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
 	unsigned long flags;
 	int neg_adj = 0;
-	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
-						ptp_info);
+	u32 diff;
+	u64 adj;
+
 
 	if (delta < 0) {
 		neg_adj = 1;
@@ -229,11 +232,12 @@ static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	adj *= delta;
 	diff = div_u64(adj, 1000000000ULL);
 
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&clock->tc);
 	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
 				       clock->nominal_c_mult + diff;
-	mlx5_update_clock_info_page(clock->mdev);
+	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -465,7 +469,8 @@ static int mlx5_query_mtpps_pin_mode(struct mlx5_core_dev *mdev, u8 pin,
 
 static int mlx5_get_pps_pin_mode(struct mlx5_clock *clock, u8 pin)
 {
-	struct mlx5_core_dev *mdev = clock->mdev;
+	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev, clock);
+
 	u32 out[MLX5_ST_SZ_DW(mtpps_reg)] = {};
 	u8 mode;
 	int err;
@@ -538,15 +543,17 @@ static int mlx5_pps_event(struct notifier_block *nb,
 			  unsigned long type, void *data)
 {
 	struct mlx5_clock *clock = mlx5_nb_cof(nb, struct mlx5_clock, pps_nb);
-	struct mlx5_core_dev *mdev = clock->mdev;
 	struct ptp_clock_event ptp_event;
 	u64 cycles_now, cycles_delta;
 	u64 nsec_now, nsec_delta, ns;
 	struct mlx5_eqe *eqe = data;
 	int pin = eqe->data.pps.pin;
+	struct mlx5_core_dev *mdev;
 	struct timespec64 ts;
 	unsigned long flags;
 
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
 	switch (clock->ptp_info.pin_config[pin].func) {
 	case PTP_PF_EXTTS:
 		ptp_event.index = pin;
@@ -605,7 +612,6 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 						  clock->cycles.shift);
 	clock->nominal_c_mult = clock->cycles.mult;
 	clock->cycles.mask = CLOCKSOURCE_MASK(41);
-	clock->mdev = mdev;
 
 	timecounter_init(&clock->tc, &clock->cycles,
 			 ktime_to_ns(ktime_get_real()));
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c145de0473bc..8dc3da6e6480 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -643,7 +643,6 @@ struct mlx5_pps {
 };
 
 struct mlx5_clock {
-	struct mlx5_core_dev      *mdev;
 	struct mlx5_nb             pps_nb;
 	seqlock_t                  lock;
 	struct cyclecounter        cycles;
-- 
2.26.2

