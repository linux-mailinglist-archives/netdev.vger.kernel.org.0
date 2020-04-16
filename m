Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3E11ACF04
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404006AbgDPRpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:45:17 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21464 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgDPRpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 13:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587059116; x=1618595116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N1kWnTqh2tZak5rgwO3+hEG9eUcZkBQwSStH3ZrWv5g=;
  b=azMMqU6OfnThBz6TYYSqN1C0wWPjBPT/CJWyA8/WIv+JbXegPxqcLQ5C
   /94T7KijE5oAALotOvSOe2xUiP9BeeGofAiw8AXVtz61j8bFCNGCQpgOY
   o3tJl/imB9HbQBNsMyFiN7fM4XlgHvjEhrcR2JghhaLPvmrdSlFXQdW66
   JeiHvBA/vqSzIvyjiA9rTG+E0Jm0dJo8oDKTcdv/3DdSbA5yBZsC5VsAo
   X563wtvYj1QFrjX50dzI7N5LzXy+yntvPXZuKrXw1+4X7nDzuG+BcMq5/
   e+GP3IOexO+KOm49+E7N8lROh3MMlu/NkD/xDmAH8GBeUl6RYgBLo/PUI
   w==;
IronPort-SDR: MZH7D49x+kXnbSgRYDTuOdxdyBKj8zPh/CEpUoxnChBPBfN5xaoQmy4rr+cvAt3jy1Bn6A5Jpm
 uVjCmvd558OymHipaPSCa6f+3HR/Vat2pBUPkwwbZjfd8oCjdv7DrL1wPAs2BDmpuaw1SYqbuh
 NE7L+vqOsll1ngujtEtSTruEhvl7jr19h5r0U5DK5z+/k4E07zY+qLENpO6V+aaRRgE0H8gYKq
 KCE5gjEWLtm5Nhg2IvUjssA6aUEEhWhSGn4B4slul+E0ZeXUOwJlnxzMeXbn6+B3+/xGZZ3JXl
 GLI=
X-IronPort-AV: E=Sophos;i="5.72,391,1580799600"; 
   d="scan'208";a="72439768"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2020 10:45:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 Apr 2020 10:45:14 -0700
Received: from ness.corp.atmel.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 16 Apr 2020 10:45:07 -0700
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
Subject: [PATCH 2/5] net: macb: mark device wake capable when "magic-packet" property present
Date:   Thu, 16 Apr 2020 19:44:29 +0200
Message-ID: <3d41fc5ef84dfb2b1fa4bb41c0212417023d4d97.1587058078.git.nicolas.ferre@microchip.com>
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

Change the way the "magic-packet" DT property is handled in the
macb_probe() function, matching DT binding documentation.
Now we mark the device as "wakeup capable" instead of calling the
device_init_wakeup() function that would enable the wakeup source.

For Ethernet WoL, enabling the wakeup_source is done by
using ethtool and associated macb_set_wol() function that
already calls device_set_wakeup_enable() for this purpose.

That would reduce power consumption by cutting more clocks if
"magic-packet" property is set but WoL is not configured by ethtool.

Fixes: 3e2a5e153906 ("net: macb: add wake-on-lan support via magic packet")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Rafal Ozieblo <rafalo@cadence.com>
Cc: Sergio Prado <sergio.prado@e-labworks.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d1b4d6b6d7c8..629660d9f17e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4384,7 +4384,7 @@ static int macb_probe(struct platform_device *pdev)
 	bp->wol = 0;
 	if (of_get_property(np, "magic-packet", NULL))
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
-	device_init_wakeup(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
+	device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
 
 	spin_lock_init(&bp->lock);
 
-- 
2.20.1

