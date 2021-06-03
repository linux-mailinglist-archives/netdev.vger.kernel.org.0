Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A27E39A829
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhFCRN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232655AbhFCRMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29A9561401;
        Thu,  3 Jun 2021 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740220;
        bh=e5fmkblM8CdcxRtrWVQQI5defxu8oUddysWoUM9Z8i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0BiZTEN+ZSxfFZj+3p2DGgkpR2iBwL9+i2lf8OYLCgA4OYvPD9ZyIRnRTRcpyeq0
         dvluU5uqlANc7TyRQkZOLE+icil+Px8mP0OloB0Nhx8vfCt+/3860aSA6vw/Y5YyCR
         wh8B4YcezSSZH2zidmTPEIhYSIijZLMnZd89xezbMHiM2KGIZxcnaRYnid901bgeh6
         05MBnozBnZNlN5CKhoDbp6ou3LDo6Xl+FajBuv5SbQni0UMCPuKasDPbw9jeqLjye0
         TYYdXe/ZaP4O0AR2gEo7JvR6tAi/r875EfvcI6FWwPbrbjFDfoWwebHIhxZ0vBrlb5
         ZKWujLq6VwaFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong Li <zong.li@sifive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/23] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Thu,  3 Jun 2021 13:09:53 -0400
Message-Id: <20210603170959.3169420-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
 drivers/net/ethernet/cadence/macb_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0374a1ba1010..d110aa616a95 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2513,6 +2513,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->dev->stats;
 
+	if (!netif_running(bp->dev))
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.30.2

