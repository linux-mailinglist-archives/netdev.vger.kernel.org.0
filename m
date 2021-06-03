Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84639A8DE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhFCRSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233694AbhFCRQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 089706142B;
        Thu,  3 Jun 2021 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740287;
        bh=xAu6IeufdyirXUfJdU9QGi4qi+C5ycFaQoyNAW7BKWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJsEwEd1IVWWQHXzyglr1h2kO6pv6PJwDdXWYHIFDsq3boMF6BQuZplmMKcm76dm0
         WdNVECoHE8vst341EeWkRZgnqlvw2DMqDm6waboaPnrY1BwXtwBemJZj/sclttHdMM
         IjO6GdZ3nN51/3XhTyZKoHYsJVc8KkYTMHNeWyn7Z8OBAaHvJv+nJtNjtQ+o0Y8Pdg
         p3YPbisog/k3nETAGVuk2/W7zELH1ub3xYbVfZFlX0cfoeDh7d82bHMjCcJJzHindl
         t5E0EKOp3FVvt5Y2kGN2y7mIYYfrUCXcYcNABh0He3+2/obuV4yrazh9T6xVuxb66D
         0vQ8P04NqU9oA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong Li <zong.li@sifive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/15] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Thu,  3 Jun 2021 13:11:09 -0400
Message-Id: <20210603171114.3170086-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

[ Upstream commit 5eff1461a6dec84f04fafa9128548bad51d96147 ]

If runtime power menagement is enabled, the gigabit ethernet PLL would
be disabled after macb_probe(). During this period of time, the system
would hang up if we try to access GEMGXL control registers.

We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
function called from invalid context"). Add netif_running checking to
ensure the device is available before accessing GEMGXL device.

Changed in v2:
 - Use netif_running instead of its own flag

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 78803e7de360..d1cdb8540e12 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1955,6 +1955,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->stats;
 
+	if (!netif_running(bp->dev))
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.30.2

