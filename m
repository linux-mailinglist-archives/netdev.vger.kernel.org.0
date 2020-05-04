Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4930A1C3B93
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgEDNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:46:40 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:37031 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgEDNqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 09:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588599997; x=1620135997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+zzAJaYzelyzPPipowOqC3N1EqhQqggcsRkXu8EpRs=;
  b=U6moy7LX44vzcF0SV4S0ejoHQfZ2lYMg6vSQ2MepP5PQVWctz0l4ZGn2
   6mru3zUtI+2zwHu71dXVswQdka0ipax66L+rUk36JAsKEkUZRRtJafr7l
   msmQLwyFcj1AG5IfmdJYRqs6C26zSSFVeLohPfYeGogzVBiXaluj4DK2/
   MxI4nQc4LCI2HY1gAfWkB60eS7vqfs+cPqc8v425W/tBwH5aEU59Fld43
   Zzoxr96YHoPXpnCbhMULSEBicDqpkoaliVDcQaN+szD5Hyr4052yHO0wL
   ZlXTd1Nin+M5UhL3JwW2q6KP4tf2qcpoNmR+TtMlyKMAoEEr7nlDhyUOt
   g==;
IronPort-SDR: U6f2ndBh/Q51eX2UgthWQWst6qY/Mk/cR/vjfXibcc/+4vMKA3Lj3eHJeqfE51iHIYkBuvboB1
 i/nTOLBXyfNcMEnsJqpU8fWlqigFxqlffWA5eNErVFkh76NqI/uzFLMxpyh0dBQEgrtx120ul2
 w3mfduBGe2Rkb8M4DliDpQsPwuuBK7q44RjfllkpfQ+rP1wkLuPkYFGhMHxyKKmJvrzN0MNV0K
 wZ55eXoIL+TTB+GO8HeNmGCYc1TBhjpZ5EM4bUvBYFfa2etvDAF6KWX7rx2Uk3YYcxY5Pyi9Ge
 Sj0=
X-IronPort-AV: E=Sophos;i="5.73,352,1583218800"; 
   d="scan'208";a="75424641"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2020 06:46:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 May 2020 06:46:40 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 May 2020 06:46:33 -0700
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
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Sergio Prado <sergio.prado@e-labworks.com>
Subject: [PATCH v3 2/7] net: macb: mark device wake capable when "magic-packet" property present
Date:   Mon, 4 May 2020 15:44:17 +0200
Message-ID: <b01c5d9e5e112c8620e28e538109efa70d566509.1588597759.git.nicolas.ferre@microchip.com>
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
2.26.2

