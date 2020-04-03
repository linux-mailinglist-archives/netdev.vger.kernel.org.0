Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B451A19D762
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgDCNPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:15:14 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:3781 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgDCNPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585919713; x=1617455713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N1kWnTqh2tZak5rgwO3+hEG9eUcZkBQwSStH3ZrWv5g=;
  b=qx5uGIjNyJTh95Rf0XQ+zE/mqfs9tFj+g70pLtfJrP90YGVIjISc3J40
   HJ0PwhJyXdMYY1+moqt3yPSQCEpaZ+74EtaCdPQHzqcvnW1SVTk4p/eR4
   Tx7mt491PNOrrQg3LLYeptwHqSuzBwPe/FxqJd4AHtub1DxB1nCMoBD9N
   b2ds3GomOHFWjsArBYYUwVaOTe/qXBGmuCdfetS5KNNXjG8Qk8PSlmo3a
   it0AymwzthMAqwT6bKunmm5ICLviWjLV/2JQE8mxao2xdUIdvshdJF55M
   HJk0oBzzIgzKvMKgLfoZwGivq4VDcXmBdLimdF3xzom1LC3EFt4tHfb9p
   g==;
IronPort-SDR: FW0u3tt77BdKo48afen52QKZLaE+WNNEIHUsxhg2O3wwQ4zazc0OuIAgRrKa9jYXG2e7lak0uW
 fMvGkJ2fgBLx1SW8Z3cZe9dtOico9p7GD/PdLc20IKZTKt1S3BSskb9yqEnOw8I9gMKC1fXSbD
 uAtCqpFJJ5egtUkYsOQPrnm93HYGKSzo08gcK0PmhQlwsX6WzZSQMG/Zl1xIEsxqQonQAcubzK
 WEB0HWxZFRGGhga7YscCbAgLScUe+623O9ZXexAp1DxHnugYDZcPBU7CHcM7bdElCOFtAzA7TV
 Fl0=
X-IronPort-AV: E=Sophos;i="5.72,339,1580799600"; 
   d="scan'208";a="69328150"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Apr 2020 06:15:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Apr 2020 06:15:11 -0700
Received: from mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 3 Apr 2020 06:15:08 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <rafalo@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC PATCH 2/3] net: macb: mark device wake capable when "magic-packet" property present
Date:   Fri, 3 Apr 2020 15:14:43 +0200
Message-ID: <21cbef3db93cb61c6b8f7093164005d0f452db02.1585917191.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585917191.git.nicolas.ferre@microchip.com>
References: <cover.1585917191.git.nicolas.ferre@microchip.com>
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

