Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD122D1053
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgLGMRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:08 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39664 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgLGMRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343427; x=1638879427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IKugsm/d3kZD6lpm6POkBOpF9mUABeF8EZuTFUDQaUo=;
  b=QeKE9DEucJFNlKCUT3K8KO8ia9wn1U1zdFxkw95mMjiFst5epOXCzcNE
   /rvQtYotlGA1qzeRgO8+l+0BmKdDJJoAFbN6GoW/dCq+0WPCX6CLKkkfU
   3KPhf6anrUJO+iGeVR89QSjcoHltj4Q7Z0TjcumAgNHDkRka06+jy0SrL
   EPvAtfQAE5vwJEfEvc7LBSNHpWVIEpvpDu8jG8bDIZUDFdQQkjLloAYLb
   4LTODAd5oDozq0w53CdHFMvLhHKJb8jBrstkioOHekiQ04rMmNrhuMjTd
   9svZpC8MUGUBVB/lCKr88LBlZS99a0ZvtRIv5V65lqOQOUnk2nqTQb2nD
   Q==;
IronPort-SDR: D/hLZsD+sS0lWq+irP4F2zrvqsidTlIiAmkDwnu6uxhtBE80EyS5ilzSM3RzxowME678C2/8HJ
 VRHXtfLshW+IUqiJNhfuFlzZj70EcNanfIScbLCgtRyLy3KniEqpgwlL1gnONQ1N/6RAL+UfKF
 DdXTUapMJcrJD2tMZJ8wYzZ7Nv9rw/10hZpVO/lNsCfnimDTd95gSv8NBsDo65eMCPRGii4mh4
 gVztrwYiP9d7R6gKM/8/SWkulfseA0xGT+waIvpstBUBvZzDFzEnPqutPD1l5O6y1Kvg3+/FMh
 X4o=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="106497444"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:00 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:15:53 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 2/8] net: macb: add capability to not set the clock rate
Date:   Mon, 7 Dec 2020 14:15:27 +0200
Message-ID: <1607343333-26552-3-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SAMA7G5's ethernet IPs TX clock could be provided by its generic clock or
by the external clock provided by the PHY. The internal IP logic divides
properly this clock depending on the link speed. The patch adds a new
capability so that macb_set_tx_clock() to not be called for IPs having
this capability (the clock rate, in case of generic clock, is set at the
boot time via device tree and the driver only enables it).

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 7daabffe4318..769694c7f86c 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -699,6 +699,7 @@
 #define MACB_CAPS_GEM_HAS_PTP			0x00000040
 #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
+#define MACB_CAPS_CLK_HW_CHG			0x04000000
 #define MACB_CAPS_MACB_IS_EMAC			0x08000000
 #define MACB_CAPS_FIFO_MODE			0x10000000
 #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6d46153a7c4b..b23e986ac6dc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -460,15 +460,14 @@ static void macb_init_buffers(struct macb *bp)
 
 /**
  * macb_set_tx_clk() - Set a clock to a new frequency
- * @clk:	Pointer to the clock to change
+ * @bp:		pointer to struct macb
  * @speed:	New frequency in Hz
- * @dev:	Pointer to the struct net_device
  */
-static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
+static void macb_set_tx_clk(struct macb *bp, int speed)
 {
 	long ferr, rate, rate_rounded;
 
-	if (!clk)
+	if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
 		return;
 
 	switch (speed) {
@@ -485,7 +484,7 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 		return;
 	}
 
-	rate_rounded = clk_round_rate(clk, rate);
+	rate_rounded = clk_round_rate(bp->tx_clk, rate);
 	if (rate_rounded < 0)
 		return;
 
@@ -495,11 +494,12 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 	ferr = abs(rate_rounded - rate);
 	ferr = DIV_ROUND_UP(ferr, rate / 100000);
 	if (ferr > 5)
-		netdev_warn(dev, "unable to generate target frequency: %ld Hz\n",
+		netdev_warn(bp->dev,
+			    "unable to generate target frequency: %ld Hz\n",
 			    rate);
 
-	if (clk_set_rate(clk, rate_rounded))
-		netdev_err(dev, "adjusting tx_clk failed.\n");
+	if (clk_set_rate(bp->tx_clk, rate_rounded))
+		netdev_err(bp->dev, "adjusting tx_clk failed.\n");
 }
 
 static void macb_validate(struct phylink_config *config,
@@ -751,7 +751,7 @@ static void macb_mac_link_up(struct phylink_config *config,
 		if (rx_pause)
 			ctrl |= MACB_BIT(PAE);
 
-		macb_set_tx_clk(bp->tx_clk, speed, ndev);
+		macb_set_tx_clk(bp, speed);
 
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
-- 
2.7.4

