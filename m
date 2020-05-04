Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9281C3B97
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEDNqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:46:45 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36514 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbgEDNqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 09:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588600003; x=1620136003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c3iuhkwHDW+6rW4ZzAEBKYMLJ0sc8jLJEmEwsrWvUFs=;
  b=H9WOsTn0K4dKZ+io3mEqg47NNAxXVd8EnM1bsOc5uPugfFtfeYugzQq2
   UYOciVriPnYKF4b6JeSPOIygGxk6CtwjOat2jA32E3lXcutPWp8B/PGYC
   GhwSG1VDEvZiduoXpkl5R6eqJ3LNl++V0I1FD+mnQORclfCQQU6I8+rwN
   gkufiEO+TgdNr8nvuhDxYiBLgxznvDdn/adozkh0F1AIejqUFc0F6GdSL
   Yg5+1f6r/Dn6qe531jSjX4XSY70ymDswBV+8YC0LqYkebqKQm4jxrXIn/
   ImPFjlnOG5EJ1nniIoA+QkJmCojvbnaws0ZT/Bj4vMg67YPxw6aXAaE7A
   Q==;
IronPort-SDR: qByEXUbz+XJu7zWYLrooIYhzLlJmc87a2ewZUokCHS5HEddGKdDpE2W7gODtBNCTltx0Q0yiVf
 ZScTbvdSukfaShDaFP+cBcost0Jduqg5aOxlJc18rGx1U0uwZBldTWg758tSp/b2Kta86DhQGG
 42GoMey4Fqqt4T1Jf+qwiOv3+JdO0HBngzngBQjVyvaZ+1VPthx8R3oMnSQT6v2af+vVGw+NZB
 F4anYAfmu+MIiX7FSByadjD4UOa/R3C01wCcHQ1OPIQX5pSUrTG/luCnfvAtF9GrTOh0ykXDLl
 03c=
X-IronPort-AV: E=Sophos;i="5.73,352,1583218800"; 
   d="scan'208";a="72332643"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2020 06:46:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 May 2020 06:46:43 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 May 2020 06:46:39 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>
Subject: [PATCH v3 4/7] net: macb: fix macb_suspend() by removing call to netif_carrier_off()
Date:   Mon, 4 May 2020 15:44:19 +0200
Message-ID: <2b377e5705ced4b0171e07642a891f2416b94945.1588597759.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588597759.git.nicolas.ferre@microchip.com>
References: <cover.1588597759.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

As we now use the phylink call to phylink_stop() in the non-WoL path,
there is no need for this call to netif_carrier_off() anymore. It can
disturb the underlying phylink FSM.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b17a33c60cd4..72b8983a763a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4562,7 +4562,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 	}
 
-	netif_carrier_off(netdev);
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
 	pm_runtime_force_suspend(dev);
-- 
2.26.2

