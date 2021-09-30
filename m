Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6574941E4A3
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbhI3XQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350091AbhI3XQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C748B61A6E;
        Thu, 30 Sep 2021 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043706;
        bh=TgOg0rnlrtsNdQK9n1/2cLGQH0f4sB2HILwNRzHvG7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khhkeISs6wLo2PYmA2ZbV+6tcD2nDr+wWdA8v6oGDK9b0QLRDV9oM3lFQJNoctgrj
         eXdO39eEcnEOnRzZ1cXkEPwwfqfHyuGu7chivUXZvIkRqOWO1jraWZ+NuaqSYxQEiW
         iy2JjG4Rs7O0pwhn+v97j3u2nFZg4QNli91Y7VK1HH+BlbB3IgvTb6HnUYklSsdBjl
         c4C0tYd2mHBL7jnp2anf3KHpSFYHF+F98gN52DcaPxIp3mY0d8qUXWdjC+1gwhrIaD
         TrP+p5ZuUcfMWbky9uXUqFH4vDSeF1egZYV8Ab+sBohD8dZKne0vLdIFHWGPYuQEix
         V420xOwOjHVcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/10] net/mlx5: Force round second at 1PPS out start time
Date:   Thu, 30 Sep 2021 16:14:56 -0700
Message-Id: <20210930231501.39062-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Allow configuration of 1PPS start time only with time-stamp representing
a round second. Prior to this patch driver allowed setting of a
non-round-second which is not supported by the device. Avoid unexpected
behavior by restricting start-time configuration to a round-second.

Fixes: 4272f9b88db9 ("net/mlx5e: Change 1PPS out scheme")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ffac8a0e7a23..d2ed7b0a18ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -448,22 +448,20 @@ static u64 find_target_cycles(struct mlx5_core_dev *mdev, s64 target_ns)
 	return cycles_now + cycles_delta;
 }
 
-static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev,
-				      s64 sec, u32 nsec)
+static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev, s64 sec)
 {
-	struct timespec64 ts;
+	struct timespec64 ts = {};
 	s64 target_ns;
 
 	ts.tv_sec = sec;
-	ts.tv_nsec = nsec;
 	target_ns = timespec64_to_ns(&ts);
 
 	return find_target_cycles(mdev, target_ns);
 }
 
-static u64 perout_conf_real_time(s64 sec, u32 nsec)
+static u64 perout_conf_real_time(s64 sec)
 {
-	return (u64)nsec | (u64)sec << 32;
+	return (u64)sec << 32;
 }
 
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
@@ -501,8 +499,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 
 	if (on) {
 		bool rt_mode = mlx5_real_time_mode(mdev);
-		u32 nsec;
-		s64 sec;
+		s64 sec = rq->perout.start.sec;
+
+		if (rq->perout.start.nsec)
+			return -EINVAL;
 
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
@@ -513,14 +513,11 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		if ((ns >> 1) != 500000000LL)
 			return -EINVAL;
 
-		nsec = rq->perout.start.nsec;
-		sec = rq->perout.start.sec;
-
 		if (rt_mode && sec > U32_MAX)
 			return -EINVAL;
 
-		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
-				       perout_conf_internal_timer(mdev, sec, nsec);
+		time_stamp = rt_mode ? perout_conf_real_time(sec) :
+				       perout_conf_internal_timer(mdev, sec);
 
 		field_select |= MLX5_MTPPS_FS_PIN_MODE |
 				MLX5_MTPPS_FS_PATTERN |
@@ -717,7 +714,7 @@ static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
-	return rt_mode ? perout_conf_real_time(ts.tv_sec, ts.tv_nsec) :
+	return rt_mode ? perout_conf_real_time(ts.tv_sec) :
 			 find_target_cycles(mdev, target_ns);
 }
 
-- 
2.31.1

