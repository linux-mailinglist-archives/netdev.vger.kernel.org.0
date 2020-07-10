Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926EF21B567
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGJMrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:47:41 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:15336 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgGJMrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594385253; x=1625921253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXqNu8fKVw9rY4hUYMuHMCoxx0VX8MHiv6b9yf2xcA0=;
  b=XZFFh4cMfiQF9188YXVRXr1DaI1oCirdwEbwGcIqWHKMw8OIbHwsSfc/
   1cBi+osxRTLOUgiYHXSCvTTP2Ef5W+vh/tAKGKLRSgWK1CTWHNMz1zPPE
   v7m3jvADFmJxqkAsaNrTd+GQguzAJN6+KIbim0YYevwUo43rR2BFtmxDC
   VHDW3guwbqn1IJ6TnBuOgzLUF0pD0o9wubPSnflxNw6Sm69B2nCoQdIJp
   EWqsvyfE515/RON/1Z3nwNu9HqPwp/2kp9quNn/6OKi1H6srvEQhjS1QD
   O/aEx1+TVYRvaw0CyNSfcCZorGWIsdtPVEVlCjOqIHmMgrV7qvY7XChzL
   A==;
IronPort-SDR: pjId5Jp/Nsf/F0YkmieRr6fv/tTZUtlGX3W78j7dJA7gc0aZ1Xv1wTAfgWggfPSFz0JPmp6VAs
 +18Jz0GdEEX37h/x5H2FKjPqM4nnzCtEtGFs/oo0gboDGypSN2dSwvGwYN/GU3YNXs5Z8VrZny
 5ZxEQRtA9I4ZKZsyC7oHge/hJWPDXFSGsr04BTnHYAfdhORNmHyGVzeoyzeNRSaQUeZ4VBSQsf
 Jx9g8ZrW53mlyJDkS2jwCNP/OXrK4wM6jAB6D2uXTCmMNd6NUbIdHDV+xqwHBqr3RtJ6lLIXWP
 7qY=
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="18675455"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2020 05:47:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 05:47:03 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 05:47:29 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v5 3/5] net: macb: fix macb_get/set_wol() when moving to phylink
Date:   Fri, 10 Jul 2020 14:46:43 +0200
Message-ID: <be2b7d826fae585ce62a1783dc322965a8861162.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1594384335.git.nicolas.ferre@microchip.com>
References: <cover.1594384335.git.nicolas.ferre@microchip.com>
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

phylink_ethtool_set_wol() return value is considered and determines
if the MAC has to handle WoL or not. The case where the PHY doesn't
implement WoL leads to the MAC configuring it to provide this feature.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v5:
- Addressed the error code returned by phylink_ethtool_set_wol() as suggested
  by Russell.
  If PHY handles WoL, MAC doesn't stay in the way.
- Removed Florian's tag

 drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4cafe343c0a2..79c2fe054303 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2821,11 +2821,13 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
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
@@ -2833,9 +2835,13 @@ static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	struct macb *bp = netdev_priv(netdev);
 	int ret;
 
+	/* Pass the order to phylink layer */
 	ret = phylink_ethtool_set_wol(bp->phylink, wol);
-	if (!ret)
-		return 0;
+	/* Don't manage WoL on MAC if handled by the PHY
+	 * or if there's a failure in talking to the PHY
+	 */
+	if (!ret || ret != -EOPNOTSUPP)
+		return ret;
 
 	if (!(bp->wol & MACB_WOL_HAS_MAGIC_PACKET) ||
 	    (wol->wolopts & ~WAKE_MAGIC))
-- 
2.27.0

