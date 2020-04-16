Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B840F1ACF07
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404816AbgDPRpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:45:25 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21464 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404312AbgDPRpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 13:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587059122; x=1618595122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gDJwJ/pAyKWbFBzwhp+PwsI+ak11+Glc+LQ9yysjG/o=;
  b=Ai2s+t0YZhdavTIphPs3ZLEW3HJspEvtiMN7NKx9gw8QVl9nSYHVcDmP
   chMx//pWGil5GeydDbWDCWhlLsOnzeEcjUV+12WyTROqFhCukuvQLK75D
   B6Q123khBnnmmfE5ujF2qhzgZds0rTxUl6qCl65GeS2/S+vUR8MWY+9IZ
   YyS6jUdCkyPKXTDcIpmqGi0UKUdr9xDqso1PMIutgAQg7+KzLpIW+z2UQ
   0gwT1FNK7WNsIau/7pnXmaJPbekSU2JSTAptUdeBqIMPPScyTUfOrwiaz
   DKTBuXRpKYv5UG/VlRIazmSk1CxjaBzf7t1uccYoeW2bkMwIJneXDLPVQ
   Q==;
IronPort-SDR: 4hX2fzr1StBDC67YN3mbu9kRGnPnxwBxC9JneBug//Sd25Vhw2JI1wQRMmKfGufiR9fFcLFeuW
 BweHL2mY9o+tTQUej4U5j9u15MuAEktlnXjPQAB9A1mLhirLXNoty1D4cyxi8AHQwyJOC0JWbL
 X7BQsZUiRDHqgNbfPzhG9yv4GlqDb2/UESrzX/eJEW9kTImW3NsVxg8DNPv8rnWOEy2taqtEQQ
 luYtKnUpRjYVk0/zZ84YGbZRHlzARrmmuwLkbphVeBP7nn/wRvlLNNORygZJ+ot0+4ZrgGZFb3
 3Zc=
X-IronPort-AV: E=Sophos;i="5.72,391,1580799600"; 
   d="scan'208";a="72439798"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2020 10:45:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 Apr 2020 10:45:21 -0700
Received: from ness.corp.atmel.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 16 Apr 2020 10:45:15 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Rafal Ozieblo" <rafalo@cadence.com>
Subject: [PATCH 3/5] net: macb: fix macb_get/set_wol() when moving to phylink
Date:   Thu, 16 Apr 2020 19:44:30 +0200
Message-ID: <897ab8f112d0b82f807e83c6f9e7425d1321fa09.1587058078.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587058078.git.nicolas.ferre@microchip.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Keep previous function goals and integrate phylink actions to them.

phylink_ethtool_get_wol() is not enough to figure out if Ethernet driver
supports Wake-on-Lan.
Initialization of "supported" and "wolopts" members is done in phylink
function, no need to keep them in calling function.

phylink_ethtool_set_wol() return value is not enough to determine
if WoL is enabled for the calling Ethernet driver. Call if first
but don't rely on its return value as most of simple PHY drivers
don't implement a set_wol() function.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Rafal Ozieblo <rafalo@cadence.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 629660d9f17e..b17a33c60cd4 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2813,21 +2813,23 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 {
 	struct macb *bp = netdev_priv(netdev);
 
-	wol->supported = 0;
-	wol->wolopts = 0;
-
-	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET)
+	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
 		phylink_ethtool_get_wol(bp->phylink, wol);
+		wol->supported |= WAKE_MAGIC;
+
+		if (bp->wol & MACB_WOL_ENABLED)
+			wol->wolopts |= WAKE_MAGIC;
+	}
 }
 
 static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 {
 	struct macb *bp = netdev_priv(netdev);
-	int ret;
 
-	ret = phylink_ethtool_set_wol(bp->phylink, wol);
-	if (!ret)
-		return 0;
+	/* Pass the order to phylink layer.
+	 * Don't test return value as set_wol() is often not supported.
+	 */
+	phylink_ethtool_set_wol(bp->phylink, wol);
 
 	if (!(bp->wol & MACB_WOL_HAS_MAGIC_PACKET) ||
 	    (wol->wolopts & ~WAKE_MAGIC))
-- 
2.20.1

