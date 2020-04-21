Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA991B2409
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgDUKlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:41:39 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:32622 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgDUKlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587465696; x=1619001696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rK6cWA0PkySI7DE/ZpSxKyujUEY/9QCd7k1z9i+Kkpw=;
  b=pTnCWWqQ0DYvSUMGhoQq0iWj/xMCHgENDxQmEKxMNMNKXGc+Sj09BkGP
   2FbdxoaV+xpFWL1tAF5by9rOYMHWTWE5Nv/i/Ee4j2tl1p4Xm5iUXLdkg
   SPoPUDlJ8MyWOd0iQABN1fAlME6HPq61CdK8oZ8wBXoG08UfzsXnLV9h+
   EZsR2ofwZbqOb993JHelsB3hOf8auV8Bn885DvR7EaFoEcnZm8cUMpJr9
   PKQVcstFsVMXpYGv0TZhO7H7AYIhWYwRknfXVYl9gUt9vtVf/B2N493Eb
   VCMl1NGltVd5828FzKIXFOgemeE1sqYh5v3ZZga36H/o/UqQV2E2uM6x5
   w==;
IronPort-SDR: Qx6hDdrwJI2R/qlc5JFMUD8EJnBzhQlN/WWBqRszDFmUhCVBj09HRHIUFqCUUfQYNOcfwsOnYT
 2+KIECJr0oSyDww824uSAaiYX6lr/CQxdwfOhnSlf66QNxLHQhMdh9NSl7LtO5jCZ7wVygeCU4
 +VikIo4XNrV2MQFTbApx45x+yOZRo4WK/5ZMK4yY2Qf7ACtdZljNYK3mJRMjd+UMcwQvPk2kkq
 oLV3GDvOD0ci7MjvCMyiw4SAtgJVx1CQdpHcqAxkZsMED2rFwKq9+hHycDa94Yke2/CKmxKOnf
 bpE=
X-IronPort-AV: E=Sophos;i="5.72,410,1580799600"; 
   d="scan'208";a="71017508"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2020 03:41:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 03:41:35 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 21 Apr 2020 03:41:33 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <sergio.prado@e-labworks.com>, <antoine.tenart@bootlin.com>,
        <f.fainelli@gmail.com>, <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v2 2/7] net: macb: mark device wake capable when "magic-packet" property present
Date:   Tue, 21 Apr 2020 12:40:59 +0200
Message-ID: <b01c5d9e5e112c8620e28e538109efa70d566509.1587463802.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587463802.git.nicolas.ferre@microchip.com>
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
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
Cc: Sergio Prado <sergio.prado@e-labworks.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

