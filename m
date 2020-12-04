Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA9B2CEE2F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbgLDMga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:36:30 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:51237 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388195AbgLDMg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085388; x=1638621388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uYCBqJLZnpSG4vW8rBFgGJq3+ZAfuyYXev+YIiqcc1g=;
  b=SswkGuKSaj4DmKgg9xZU7u7XO3jy+NfZe31w3ZmMpPXXhVO7QS8pijUW
   MBE9zMkwtSKcP+bHPb7i11w+lSp3F+DxBjmL41Q0g4tc0MOfpVi1cxcxq
   ySQauiF+nh/Wa7TyjiVj2BquUO2OePalus6cM1NR2k779C/ktP9Pi4DRz
   t6YD/T4toTESszmDBxznPo5avu1ejaGb8QBmfVU2/wPcUBPv1QC40xuOC
   PlR813/vPqButFC/O2NadnC+r8Q53grW39lIlSRXrn9Rzk5WlPYKqPTau
   fKEXFP2hx6BPlUI3p7AB4IVqbiq5A7l/z1m28586YY/0X4TmpLE7fqiE+
   g==;
IronPort-SDR: KGYfLM3VecLAB0mBzpDKNZgIccTIBMR3ibZtbRUSxH/oVkyeyhLfsk8FbxS/dT0WFcwuIMerSc
 cQMxaIG+s6qqUVenOz4SeRC8nfvaRjAJaU4SFJrjnP92fH+P2dd7SOz6JgRQByDJx0qMIkeHyR
 qidAtXKlr6rptS30tFLp8CSTV6ypsNfDB0xlzb2rVm50AYSAc/zMJyeCOgVdN9Mv4aQobkRgc0
 QH9ZMcq0+hKlb70fTf5gXi11djDas0X2Ro5T+UDaavIoodUIGfztp1oaFVfue8OKIQ9NSKHFzD
 /a0=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="101477159"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:34:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:34:47 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:42 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 2/7] net: macb: add capability to not set the clock rate
Date:   Fri, 4 Dec 2020 14:34:16 +0200
Message-ID: <1607085261-25255-3-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
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

