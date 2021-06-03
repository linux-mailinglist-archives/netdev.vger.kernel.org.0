Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC6139A8B2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhFCRR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233529AbhFCRPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E6461421;
        Thu,  3 Jun 2021 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740267;
        bh=yl8hScry4M9QShKK1y5D0Ff/KUuEs0Mjc2f0Omi24F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+V3GhUX93VKUV4FDST/G3iLqqBILpStvxW5bLPJdElC9H5RtYITqmQp09d47PHWC
         vICwsZeW85A8Jn+hM4oX7M8q/VTYOu4actRBczVCBuvSTtb5uVWcp1v7wWx4n8Tf5c
         ILeh9zwXKVrou1jsjGJmRWhm/rLhRCsfVOEkjtRJ8DXDB1MunO6vMLdibxdo32s4Vu
         XfjDrGkPm7L4mqxHcKaQ2RrOinGQomm+5f3KfoEH0CtuN+LblyO5hfZxcwBbCxA86E
         3LBU9zpcutHUpsNlFinpLymsMi4T1Lh993WOwHOImDr0ClNi7o8Y8lbOOQzVyBLJus
         YZ5c18B9zpkGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong Li <zong.li@sifive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/17] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Thu,  3 Jun 2021 13:10:47 -0400
Message-Id: <20210603171052.3169893-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
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
index f20718b730e5..69fa47351a32 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2031,6 +2031,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->stats;
 
+	if (!netif_running(bp->dev))
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.30.2

