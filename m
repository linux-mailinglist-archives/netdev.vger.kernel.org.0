Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1646941E4A4
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbhI3XQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350119AbhI3XQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A67161A79;
        Thu, 30 Sep 2021 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043706;
        bh=jsEKTQjriFUhTDf4INnf8inzvRYjAIOD2s0Casbcl8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/aTCZ+kkdpLYPXSNmC4C77+fpS0j/Oc5cMfPyQpd6BMxcurPCKkayO+clOn5p9Uy
         vC7QQUQRG4+v7A+tGWZkrNtKIIj5+7cOZ60GomKdYdozwINicnqgIuDWVd9TqT0++r
         BrGjiePRb5MZrcVTmcmr61VDYV0xnpsRwLsafS3sY0kSKLhAcQXn045+pIdT4Wzpl+
         u11/WTPyJpstJLfW5o1Y1aohYm+FEx9/0U1SnS/Z8p5mAMaAwH3kQA0RP2m/Zvbtme
         aXbJa5sJUyfX/UWWGiqFwd/VKT6TRWLnMSmSjJgKmZBpTwRwEa16zvWGyLf5pqSYZf
         UkcuUr27ZysoA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/10] net/mlx5: Avoid generating event after PPS out in Real time mode
Date:   Thu, 30 Sep 2021 16:14:57 -0700
Message-Id: <20210930231501.39062-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When in Real-time mode, HW clock is synced with the PTP daemon. Hence
driver should not re-calibrate the next pulse (via MTPPSE repetitive
events mechanism).

This patch arms repetitive events only in free-running mode.

Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d2ed7b0a18ea..91e806c1aa21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -472,6 +472,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_core_dev *mdev =
 			container_of(clock, struct mlx5_core_dev, clock);
+	bool rt_mode = mlx5_real_time_mode(mdev);
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
 	struct timespec64 ts;
 	u32 field_select = 0;
@@ -535,6 +536,9 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
+	if (rt_mode)
+		return 0;
+
 	return mlx5_set_mtppse(mdev, pin, 0,
 			       MLX5_EVENT_MODE_REPETETIVE & on);
 }
@@ -702,20 +706,14 @@ static void ts_next_sec(struct timespec64 *ts)
 static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
 					struct mlx5_clock *clock)
 {
-	bool rt_mode = mlx5_real_time_mode(mdev);
 	struct timespec64 ts;
 	s64 target_ns;
 
-	if (rt_mode)
-		ts = mlx5_ptp_gettimex_real_time(mdev, NULL);
-	else
-		mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
-
+	mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
-	return rt_mode ? perout_conf_real_time(ts.tv_sec) :
-			 find_target_cycles(mdev, target_ns);
+	return find_target_cycles(mdev, target_ns);
 }
 
 static int mlx5_pps_event(struct notifier_block *nb,
-- 
2.31.1

