Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1731867271F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjARSgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjARSgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6C95AA40
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87F35B81E9A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6A4C433D2;
        Wed, 18 Jan 2023 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066971;
        bh=G4VngOyuMQ/sC2TvNcP8B0mQJFdjZH1+sNRKG/SAp+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YohR6Tm1Y7V8qB8jdS7o9zb03Q6t0aPHYq5KGLRWvoYyPuM652kwiD315TpAdjmT7
         PjIxyEu2I4euKndTNI3GouwW8BUEKNp5awyy+kZJbqj6Wf1kz7JXuR4VgWl4we0/+x
         VT8JJBKqSmmy7BIat3Lo0c0D1iLIefBNoeGUCSAsvRxeUVcHSwRABgfKShZZwwmWy9
         EQU459B+0UO/VUc1AyTb9/6IRvsG0NwBDJpEywSGp4eRWHXq9y1an8VZ+S69t4NZTP
         tvQoesx6lBGyUFe7Kpxpwm0w2TS3mw+C6uC39eDEHY6DcO1SH6YtLC+vI8sO4tmqpk
         aPNPQEdwSGijg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Add hardware extended range support for PTP adjtime and adjphase
Date:   Wed, 18 Jan 2023 10:35:51 -0800
Message-Id: <20230118183602.124323-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Capable hardware can use an extended range for offsetting the clock. An
extended range of [-200000,200000] is used instead of [-32768,32767] for
the delta/phase parameter of the adjtime/adjphase ptp_clock_info callbacks.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 34 +++++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h                 |  4 ++-
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ecdff26a22b0..75510a12ab02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -69,6 +69,13 @@ enum {
 	MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS     = BIT(0xa),
 };
 
+enum {
+	MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN          = S16_MIN,
+	MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX          = S16_MAX,
+	MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MIN = -200000,
+	MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX = 200000,
+};
+
 static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
 {
 	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
@@ -86,6 +93,22 @@ static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
 	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
 }
 
+static bool mlx5_is_mtutc_time_adj_cap(struct mlx5_core_dev *mdev, s64 delta)
+{
+	s64 min = MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN;
+	s64 max = MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX;
+
+	if (MLX5_CAP_MCAM_FEATURE(mdev, mtutc_time_adjustment_extended_range)) {
+		min = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MIN;
+		max = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX;
+	}
+
+	if (delta < min || delta > max)
+		return false;
+
+	return true;
+}
+
 static int mlx5_set_mtutc(struct mlx5_core_dev *dev, u32 *mtutc, u32 size)
 {
 	u32 out[MLX5_ST_SZ_DW(mtutc_reg)] = {};
@@ -288,8 +311,8 @@ static int mlx5_ptp_adjtime_real_time(struct mlx5_core_dev *mdev, s64 delta)
 	if (!mlx5_modify_mtutc_allowed(mdev))
 		return 0;
 
-	/* HW time adjustment range is s16. If out of range, settime instead */
-	if (delta < S16_MIN || delta > S16_MAX) {
+	/* HW time adjustment range is checked. If out of range, settime instead */
+	if (!mlx5_is_mtutc_time_adj_cap(mdev, delta)) {
 		struct timespec64 ts;
 		s64 ns;
 
@@ -328,7 +351,12 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
 {
-	if (delta < S16_MIN || delta > S16_MAX)
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
+
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
+	if (!mlx5_is_mtutc_time_adj_cap(mdev, delta))
 		return -ERANGE;
 
 	return mlx5_ptp_adjtime(ptp, delta);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a84bdeeed2c6..0b102c651fe2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9941,7 +9941,9 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x5d];
+	u8         reserved_at_0[0x51];
+	u8         mtutc_time_adjustment_extended_range[0x1];
+	u8         reserved_at_52[0xb];
 	u8         mcia_32dwords[0x1];
 	u8         out_pulse_duration_ns[0x1];
 	u8         npps_period[0x1];
-- 
2.39.0

