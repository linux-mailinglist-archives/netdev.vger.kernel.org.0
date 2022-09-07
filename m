Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3701D5B1077
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiIGXhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGXhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8901E7E33B;
        Wed,  7 Sep 2022 16:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2544761AF2;
        Wed,  7 Sep 2022 23:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8C3C433B5;
        Wed,  7 Sep 2022 23:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593831;
        bh=8nGayDZSVgT6kbm9HUq0yaxUFAjeujV068sMVMghQpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahJwwK87Vga7PCr3lgoH5wPtVrYYttaI07bsTHVeNefG2gTGSQGfluhjA+TwOsD+j
         FAIkyteWbenRZ/ZU4grnvSePqfgaf2Dor8qJ+BCbuGD/sdPyf/oq0tttFjiDLfXbKD
         n9oWb/nrcetyWlduFd9AbnGkcRURKroWe8bfuXleBNXdcOCa5GVDPX63VqQiv2tdNX
         FpniKEpKnUrf779fn9Sj4HuJuYiVYCa4PMOoy+xttl2Ajr7jC6i0pQZAXqUFysYCjk
         RA4C1okQdSmvCdZYOIZpki/PCBeR4lbgoYp38WxCkKOKp9JDDBG9S9HaxEdO6HkL6a
         RFn0LFQwRkfiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH mlx5-next 02/14] net/mlx5: Add support for NPPS with real time mode
Date:   Wed,  7 Sep 2022 16:36:24 -0700
Message-Id: <20220907233636.388475-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add support for setting NPPS. NPPS is currently available in
REAL_TIME_CLOCK mode only. In addition allow the user to set the pulse
duration.

When NPPS pulse duration is not set explicitly by the user, driver set
it to 50% of the NPPS period.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 139 +++++++++++++++---
 include/linux/mlx5/driver.h                   |   2 +
 2 files changed, 121 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 91e806c1aa21..d3a9ae80fd30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -65,6 +65,8 @@ enum {
 	MLX5_MTPPS_FS_TIME_STAMP		= BIT(0x4),
 	MLX5_MTPPS_FS_OUT_PULSE_DURATION	= BIT(0x5),
 	MLX5_MTPPS_FS_ENH_OUT_PER_ADJ		= BIT(0x7),
+	MLX5_MTPPS_FS_NPPS_PERIOD               = BIT(0x9),
+	MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS     = BIT(0xa),
 };
 
 static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
@@ -72,6 +74,13 @@ static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
 	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
 }
 
+static bool mlx5_npps_real_time_supported(struct mlx5_core_dev *mdev)
+{
+	return (mlx5_real_time_mode(mdev) &&
+		MLX5_CAP_MCAM_FEATURE(mdev, npps_period) &&
+		MLX5_CAP_MCAM_FEATURE(mdev, out_pulse_duration_ns));
+}
+
 static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
 {
 	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
@@ -459,9 +468,95 @@ static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev, s64 sec)
 	return find_target_cycles(mdev, target_ns);
 }
 
-static u64 perout_conf_real_time(s64 sec)
+static u64 perout_conf_real_time(s64 sec, u32 nsec)
+{
+	return (u64)nsec | (u64)sec << 32;
+}
+
+static int perout_conf_1pps(struct mlx5_core_dev *mdev, struct ptp_clock_request *rq,
+			    u64 *time_stamp, bool real_time)
+{
+	struct timespec64 ts;
+	s64 ns;
+
+	ts.tv_nsec = rq->perout.period.nsec;
+	ts.tv_sec = rq->perout.period.sec;
+	ns = timespec64_to_ns(&ts);
+
+	if ((ns >> 1) != 500000000LL)
+		return -EINVAL;
+
+	*time_stamp = real_time ? perout_conf_real_time(rq->perout.start.sec, 0) :
+		      perout_conf_internal_timer(mdev, rq->perout.start.sec);
+
+	return 0;
+}
+
+#define MLX5_MAX_PULSE_DURATION (BIT(__mlx5_bit_sz(mtpps_reg, out_pulse_duration_ns)) - 1)
+static int mlx5_perout_conf_out_pulse_duration(struct mlx5_core_dev *mdev,
+					       struct ptp_clock_request *rq,
+					       u32 *out_pulse_duration_ns)
 {
-	return (u64)sec << 32;
+	struct mlx5_pps *pps_info = &mdev->clock.pps_info;
+	u32 out_pulse_duration;
+	struct timespec64 ts;
+
+	if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
+		ts.tv_sec = rq->perout.on.sec;
+		ts.tv_nsec = rq->perout.on.nsec;
+		out_pulse_duration = (u32)timespec64_to_ns(&ts);
+	} else {
+		/* out_pulse_duration_ns should be up to 50% of the
+		 * pulse period as default
+		 */
+		ts.tv_sec = rq->perout.period.sec;
+		ts.tv_nsec = rq->perout.period.nsec;
+		out_pulse_duration = (u32)timespec64_to_ns(&ts) >> 1;
+	}
+
+	if (out_pulse_duration < pps_info->min_out_pulse_duration_ns ||
+	    out_pulse_duration > MLX5_MAX_PULSE_DURATION) {
+		mlx5_core_err(mdev, "NPPS pulse duration %u is not in [%llu, %lu]\n",
+			      out_pulse_duration, pps_info->min_out_pulse_duration_ns,
+			      MLX5_MAX_PULSE_DURATION);
+		return -EINVAL;
+	}
+	*out_pulse_duration_ns = out_pulse_duration;
+
+	return 0;
+}
+
+static int perout_conf_npps_real_time(struct mlx5_core_dev *mdev, struct ptp_clock_request *rq,
+				      u32 *field_select, u32 *out_pulse_duration_ns,
+				      u64 *period, u64 *time_stamp)
+{
+	struct mlx5_pps *pps_info = &mdev->clock.pps_info;
+	struct ptp_clock_time *time = &rq->perout.start;
+	struct timespec64 ts;
+
+	ts.tv_sec = rq->perout.period.sec;
+	ts.tv_nsec = rq->perout.period.nsec;
+	if (timespec64_to_ns(&ts) < pps_info->min_npps_period) {
+		mlx5_core_err(mdev, "NPPS period is lower than minimal npps period %llu\n",
+			      pps_info->min_npps_period);
+		return -EINVAL;
+	}
+	*period = perout_conf_real_time(rq->perout.period.sec, rq->perout.period.nsec);
+
+	if (mlx5_perout_conf_out_pulse_duration(mdev, rq, out_pulse_duration_ns))
+		return -EINVAL;
+
+	*time_stamp = perout_conf_real_time(time->sec, time->nsec);
+	*field_select |= MLX5_MTPPS_FS_NPPS_PERIOD |
+			 MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS;
+
+	return 0;
+}
+
+static bool mlx5_perout_verify_flags(struct mlx5_core_dev *mdev, unsigned int flags)
+{
+	return ((!mlx5_npps_real_time_supported(mdev) && flags) ||
+		(mlx5_npps_real_time_supported(mdev) && flags & ~PTP_PEROUT_DUTY_CYCLE));
 }
 
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
@@ -474,20 +569,20 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(clock, struct mlx5_core_dev, clock);
 	bool rt_mode = mlx5_real_time_mode(mdev);
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
-	struct timespec64 ts;
+	u32 out_pulse_duration_ns = 0;
 	u32 field_select = 0;
+	u64 npps_period = 0;
 	u64 time_stamp = 0;
 	u8 pin_mode = 0;
 	u8 pattern = 0;
 	int pin = -1;
 	int err = 0;
-	s64 ns;
 
 	if (!MLX5_PPS_CAP(mdev))
 		return -EOPNOTSUPP;
 
 	/* Reject requests with unsupported flags */
-	if (rq->perout.flags)
+	if (mlx5_perout_verify_flags(mdev, rq->perout.flags))
 		return -EOPNOTSUPP;
 
 	if (rq->perout.index >= clock->ptp_info.n_pins)
@@ -500,29 +595,25 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 
 	if (on) {
 		bool rt_mode = mlx5_real_time_mode(mdev);
-		s64 sec = rq->perout.start.sec;
-
-		if (rq->perout.start.nsec)
-			return -EINVAL;
 
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
-		ts.tv_sec = rq->perout.period.sec;
-		ts.tv_nsec = rq->perout.period.nsec;
-		ns = timespec64_to_ns(&ts);
 
-		if ((ns >> 1) != 500000000LL)
+		if (rt_mode &&  rq->perout.start.sec > U32_MAX)
 			return -EINVAL;
 
-		if (rt_mode && sec > U32_MAX)
-			return -EINVAL;
-
-		time_stamp = rt_mode ? perout_conf_real_time(sec) :
-				       perout_conf_internal_timer(mdev, sec);
-
 		field_select |= MLX5_MTPPS_FS_PIN_MODE |
 				MLX5_MTPPS_FS_PATTERN |
 				MLX5_MTPPS_FS_TIME_STAMP;
+
+		if (mlx5_npps_real_time_supported(mdev))
+			err = perout_conf_npps_real_time(mdev, rq, &field_select,
+							 &out_pulse_duration_ns, &npps_period,
+							 &time_stamp);
+		else
+			err = perout_conf_1pps(mdev, rq, &time_stamp, rt_mode);
+		if (err)
+			return err;
 	}
 
 	MLX5_SET(mtpps_reg, in, pin, pin);
@@ -531,7 +622,8 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	MLX5_SET(mtpps_reg, in, enable, on);
 	MLX5_SET64(mtpps_reg, in, time_stamp, time_stamp);
 	MLX5_SET(mtpps_reg, in, field_select, field_select);
-
+	MLX5_SET64(mtpps_reg, in, npps_period, npps_period);
+	MLX5_SET(mtpps_reg, in, out_pulse_duration_ns, out_pulse_duration_ns);
 	err = mlx5_set_mtpps(mdev, in, sizeof(in));
 	if (err)
 		return err;
@@ -687,6 +779,13 @@ static void mlx5_get_pps_caps(struct mlx5_core_dev *mdev)
 	clock->ptp_info.n_per_out = MLX5_GET(mtpps_reg, out,
 					     cap_max_num_of_pps_out_pins);
 
+	if (MLX5_CAP_MCAM_FEATURE(mdev, npps_period))
+		clock->pps_info.min_npps_period = 1 << MLX5_GET(mtpps_reg, out,
+								cap_log_min_npps_period);
+	if (MLX5_CAP_MCAM_FEATURE(mdev, out_pulse_duration_ns))
+		clock->pps_info.min_out_pulse_duration_ns = 1 << MLX5_GET(mtpps_reg, out,
+								cap_log_min_out_pulse_duration_ns);
+
 	clock->pps_info.pin_caps[0] = MLX5_GET(mtpps_reg, out, cap_pin_0_mode);
 	clock->pps_info.pin_caps[1] = MLX5_GET(mtpps_reg, out, cap_pin_1_mode);
 	clock->pps_info.pin_caps[2] = MLX5_GET(mtpps_reg, out, cap_pin_2_mode);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 96b16fbe1aa4..a3f39f6e189e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -698,6 +698,8 @@ struct mlx5_pps {
 	struct work_struct         out_work;
 	u64                        start[MAX_PIN_NUM];
 	u8                         enabled;
+	u64                        min_npps_period;
+	u64                        min_out_pulse_duration_ns;
 };
 
 struct mlx5_timer {
-- 
2.37.2

