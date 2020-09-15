Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA6126B03D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgIOWFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936F32080C;
        Tue, 15 Sep 2020 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201556;
        bh=RcX7srgKazxOFPGlCxfgFFi6K/03jNvn2kbyUwkVsRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaBd8SZRoZCh5XYtQ/cI/14tDp1JHFZavbZ5Cx3icGypwBOh9uLpUOXCliBRuePTe
         woapDHbEt2R87ktSBD5Y+78rmI60GPoHGTH2x24iMVXhMKIp/AitprC0oBjCr+wFWR
         UZwzmfDp/QDfUFVXDV6Ik5Rl345QzYyJIi+xGY44=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow
Date:   Tue, 15 Sep 2020 13:25:23 -0700
Message-Id: <20200915202533.64389-7-saeed@kernel.org>
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

Before calling timecounter_cyc2time(), clock->lock must be taken.
Use mlx5_timecounter_cyc2time instead which guarantees a safe access.

Fixes: afc98a0b46d8 ("net/mlx5: Update ptp_clock_event foreach PPS event")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index f8465e42b238..7fc59e01a353 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -557,8 +557,9 @@ static int mlx5_pps_event(struct notifier_block *nb,
 	switch (clock->ptp_info.pin_config[pin].func) {
 	case PTP_PF_EXTTS:
 		ptp_event.index = pin;
-		ptp_event.timestamp = timecounter_cyc2time(&clock->tc,
-					be64_to_cpu(eqe->data.pps.time_stamp));
+		ptp_event.timestamp =
+			mlx5_timecounter_cyc2time(clock,
+						  be64_to_cpu(eqe->data.pps.time_stamp));
 		if (clock->pps_info.enabled) {
 			ptp_event.type = PTP_CLOCK_PPSUSR;
 			ptp_event.pps_times.ts_real =
-- 
2.26.2

