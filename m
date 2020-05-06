Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0AF1C6F7F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgEFLmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:42:07 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2196 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEFLmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588765325; x=1620301325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CnDfNyn7awnGdDhHf08Ujco+xu5QtOjUT5JuHd7ht7E=;
  b=E3W10Kq5Lk/j08oc9ZVzGp7npGXlt+JO+x4XvLZswfl1U8Hq17Yc6Kex
   10aRA18VDW1+TR5s8Oyd5nFfaCNIG91r4U/LvrmYey5Xc4/BH/wE6XlFf
   tivaFM/5it5dci6T8AxAtHKfDKIT4NVSoMdtClyYFUz4+uw7cmvSrjZg3
   srIbA090l6wJo6a1kiK25Aao+pgCsjWu9hY9LzpYTK7vlp0/h2s6eXa4M
   Hj3pjlF5wttN1HCAZ/17niw7/WR/OSz8mFS0iDfcDCRO7oeeCTxC2C3uu
   yShKkACeZR1VHqB6mVaxfjRlCZ50rU1+QE+96oDuUs95hViUllmeQZ5Ux
   Q==;
IronPort-SDR: cJYnnUxg+4j0D7pSV03wjwCRrbdanfXhtfur+zVNRJw5J1IzyXxNIeUaoAYmW0E5aSe2BLPdKv
 FkV9+rvKgCzOwUsntDv+cdVxnyYbYMHFDKu8Qy1o9nhr0SODtlPq5nqP6dtm0FS4r4eR8Kry0t
 bwPw5UnXX0+wHTD+3E/jZg4fRvgax+JsqU3j7IffzKUEnztQ6QQtJXIjwEBjfApjmltD5szECM
 2x/QVfCkrNzBp60esJyK6GCHl3aWW20H8ZntLRlqmwwwg+5mNFpFYpUfxV3zwTrt3FzQwnmQ5j
 hp8=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="74979879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 04:42:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 04:42:03 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 6 May 2020 04:42:00 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v4 3/5] net: macb: fix macb_get/set_wol() when moving to phylink
Date:   Wed, 6 May 2020 13:37:39 +0200
Message-ID: <4aeebe901fde6db70a5ca12b10e793dd2ee6ce60.1588763703.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588763703.git.nicolas.ferre@microchip.com>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
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
if WoL is enabled for the calling Ethernet driver. Call it first
but don't rely on its return value as most of simple PHY drivers
don't implement a set_wol() function.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 53e81ab048ae..24c044dc7fa0 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2817,21 +2817,23 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
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
2.26.2

