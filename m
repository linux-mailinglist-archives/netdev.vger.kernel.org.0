Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177AE1C6F7D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEFLmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:42:03 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:49378 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEFLmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588765320; x=1620301320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tv6yJ7LbbY1iSVkwSqx5jSF+okHW//DxXRB/JfgHvV0=;
  b=VhZ8fIKI4inrpF/KGLglfHydjFWixJEL5sqy3TWy6I6fSk+lrMapvtXD
   aCNCZ/VeP+BZgbH0wImnkmTkXcM0UAWqmvmWmVSTFcv6ujskz23ZGlk2q
   kc7/omkGF3D8VtR1BJBuICpMXWoioIF/ILNhRiED2pPUT9Arm3srQB4ju
   eHuiqI5KtTR9hdtGSgFRR7Pe5a5aHM9ednN8pWCiQA7G/GfLc5EWy0lH2
   QEzTDvXeAfVBuNYeunZk81APHEUUHmqiKts7BnObnG4ANbPnk7ezR3YFZ
   BVOVDDZqcckguIJxNC0vR52nnK4RmCcPx225lxw0IZ521J1+H6c0m9221
   g==;
IronPort-SDR: /qz0F12LrMVzDtxM0Yzbwgc1vdt5nba7jH4t4WMGJHJuxo/pGUMRASLobG/IZU3Ap6oh01JaqE
 n837HY/8jb2foWC78+Yg/oUs461tqzCfoJSuobWogRxvOX6VG9ZAdsuKdGwqNM7zqDNp+K5rZz
 5mLCqYeRgBahGpNWa7LyWQzvy0WJXLMT3w6ZwOIyKBDPQfaVvbWD3sP7n81KnLglrCFTYriJZE
 Uv3wu7Cn0Y1lqBGQoVaz/JNKMPG9ULYY5JLLnfwvBjdWFMvawPYOTANZfPReVrbrOPwKn0iNq6
 QZY=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="11483896"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 04:41:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 04:42:01 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 6 May 2020 04:41:55 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sergio Prado <sergio.prado@e-labworks.com>
Subject: [PATCH v4 2/5] net: macb: mark device wake capable when "magic-packet" property present
Date:   Wed, 6 May 2020 13:37:38 +0200
Message-ID: <a9b3da7295473d77459242a9a672cc8913cdb80d.1588763703.git.nicolas.ferre@microchip.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Sergio Prado <sergio.prado@e-labworks.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d11fae37d46b..53e81ab048ae 100644
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
2.26.2

