Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54E223BA36
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgHDMXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 08:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgHDMXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 08:23:18 -0400
X-Greylist: delayed 350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Aug 2020 05:23:17 PDT
Received: from mx2.mailbox.org (mx2a.mailbox.org [IPv6:2001:67c:2050:104:0:2:25:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF215C0617A3
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 05:23:17 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id DBC3CA2BA1;
        Tue,  4 Aug 2020 14:17:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id OV5A9Qzg-o_R; Tue,  4 Aug 2020 14:17:17 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: macb: Properly handle phylink on at91sam9x
Date:   Tue,  4 Aug 2020 14:17:16 +0200
Message-Id: <20200804121716.418535-1-sr@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -3.33 / 15.00 / 15.00
X-Rspamd-Queue-Id: 199E7178C
X-Rspamd-UID: c9f610
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just recently noticed that ethernet does not work anymore since v5.5
on the GARDENA smart Gateway, which is based on the AT91SAM9G25.
Debugging showed that the "GEM bits" in the NCFGR register are now
unconditionally accessed, which is incorrect for the !macb_is_gem()
case.

This patch adds the macb_is_gem() checks back to the code
(in macb_mac_config() & macb_mac_link_up()), so that the GEM register
bits are not accessed in this case any more.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/cadence/macb_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 2213e6ab8151..4b1b5928b104 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -578,7 +578,7 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
 		if (state->interface == PHY_INTERFACE_MODE_RMII)
 			ctrl |= MACB_BIT(RM9200_RMII);
-	} else {
+	} else if (macb_is_gem(bp)) {
 		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
 		if (state->interface == PHY_INTERFACE_MODE_SGMII)
@@ -639,10 +639,13 @@ static void macb_mac_link_up(struct phylink_config *config,
 		ctrl |= MACB_BIT(FD);
 
 	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
-		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(PAE));
+		ctrl &= ~MACB_BIT(PAE);
+		if (macb_is_gem(bp)) {
+			ctrl &= ~GEM_BIT(GBE);
 
-		if (speed == SPEED_1000)
-			ctrl |= GEM_BIT(GBE);
+			if (speed == SPEED_1000)
+				ctrl |= GEM_BIT(GBE);
+		}
 
 		/* We do not support MLO_PAUSE_RX yet */
 		if (tx_pause)
-- 
2.28.0

