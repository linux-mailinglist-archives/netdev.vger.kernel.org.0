Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4269334779
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhCJTE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233735AbhCJTD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B9764FD0;
        Wed, 10 Mar 2021 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403037;
        bh=6GK5UhIfTAoPjiNIQXf8nmSACDH8fWTBd5FcfAMHG8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqwAKt90WfxWktiWXzZso2vO5+tLGfvC/jArz5K92uUMCXMISRZ06EfQuAEb0XjD5
         DwNx2y17LzJz1Qr064UiO3v4EAxNZY6+0K7wMxVDqVwjivClxQQOPTe0KFlpPQaqfU
         rIspDQkDfYrENHJndNp4hDWc5rD8Om2gBZe/69GLWo5kKOIDCo0p1PaWvd0Dps3KR/
         gRWNVOXbRMpgJz4hj5EczLQZeXTpkn/Z+16T9cW62jw8zmq25vYifj7iX+n69jCJ5q
         Mw5rB820JlLenCWOvk6ans1p2ESfhQuqlYKDSYhSly5+CGIrZHmD88Ax1UMIeSNgmK
         QIKDD2H/7hSYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/18] net/mlx5: Fix turn-off PPS command
Date:   Wed, 10 Mar 2021 11:03:32 -0800
Message-Id: <20210310190342.238957-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Fix a bug of uninitialized pin index when trying to turn off PPS out.

Fixes: de19cd6cc977 ("net/mlx5: Move some PPS logic into helper functions")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index b0e129d0f6d8..1e7f26b240de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -495,15 +495,15 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		return -EINVAL;
 
 	field_select = MLX5_MTPPS_FS_ENABLE;
+	pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT, rq->perout.index);
+	if (pin < 0)
+		return -EBUSY;
+
 	if (on) {
 		bool rt_mode = mlx5_real_time_mode(mdev);
 		u32 nsec;
 		s64 sec;
 
-		pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT, rq->perout.index);
-		if (pin < 0)
-			return -EBUSY;
-
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
 		ts.tv_sec = rq->perout.period.sec;
-- 
2.29.2

