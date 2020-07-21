Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B8F227C6C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGUKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:04:22 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:30628 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgGUKEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325861; x=1626861861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eSIX9gvTOXmEs7WsXT0EHbET3IDNtZUzetyMiaF7M2E=;
  b=pFmFNt7A4kTxwN0ug049XZkxNRkoio9U4lcTLjZ8bmraSPbpMES2AEp8
   id1RCW4k1z2Vf70C0dkKo0kkDakYan/1xiZ+zl25UgAi+l3K3596UCtsv
   AAf+ZNEL7b1H6KIUXT06HU/r2V9TOtNysBlniydeAH8z0xgFQZt+ZD6l+
   aaWAYvlnuePBsozWa79eEURAu35++RiRyc0dukYoqyrhz9aSABcD6XkQK
   Eny5pEYrafOqNh8KN2mo2pS6CuAYDjOUsU0sJZmXl6Hb9oX1PM8w903bU
   swS2zdhssEh7KKlSnN0+avD0oXicwU92m4Q0pA9zjU8cmYGwtQbbc97Jz
   g==;
IronPort-SDR: zOL0rLzTbWq08z6asHBEwBpO7+4x8fKeWDVGqFBbISHYCIF5dzCVSQC3v/TBGjXvRIpczDInsE
 SsA+eb169b3oh0iUPbjGpZSG/0dl0jOJ9FzQ0UXdScK2OHGag3a+npeDy/G681MpwZWDgFX7V+
 15m7nsaiGjar/RSWR3Vt8VHzLmBoVOVqpck9JBVo2qkm0+8ZCE+HI5Mmyc4JI/4EhuLLzwzo29
 IpHHw9496cLmIl7TflLImllpWPwM1Y2nM0pP0UYxeyxrQxhdpI6Be2ahFCxZ89iJZCVTDQcn52
 JgA=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="80694800"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:04:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:03:42 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:02:58 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 1/7] net: macb: use device-managed devm_mdiobus_alloc()
Date:   Tue, 21 Jul 2020 13:02:28 +0300
Message-ID: <20200721100234.1302910-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the device-managed variant for the allocating the MDIO bus. This
cleans-up the code a little on the remove and error paths.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a6a35e1b0115..89fe7af5e408 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -769,7 +769,7 @@ static int macb_mii_init(struct macb *bp)
 	/* Enable management port */
 	macb_writel(bp, NCR, MACB_BIT(MPE));
 
-	bp->mii_bus = mdiobus_alloc();
+	bp->mii_bus = devm_mdiobus_alloc(&bp->pdev->dev);
 	if (!bp->mii_bus) {
 		err = -ENOMEM;
 		goto err_out;
@@ -787,7 +787,7 @@ static int macb_mii_init(struct macb *bp)
 
 	err = macb_mdiobus_register(bp);
 	if (err)
-		goto err_out_free_mdiobus;
+		goto err_out;
 
 	err = macb_mii_probe(bp->dev);
 	if (err)
@@ -797,8 +797,6 @@ static int macb_mii_init(struct macb *bp)
 
 err_out_unregister_bus:
 	mdiobus_unregister(bp->mii_bus);
-err_out_free_mdiobus:
-	mdiobus_free(bp->mii_bus);
 err_out:
 	return err;
 }
@@ -4571,7 +4569,6 @@ static int macb_probe(struct platform_device *pdev)
 
 err_out_unregister_mdio:
 	mdiobus_unregister(bp->mii_bus);
-	mdiobus_free(bp->mii_bus);
 
 err_out_free_netdev:
 	free_netdev(dev);
@@ -4599,7 +4596,6 @@ static int macb_remove(struct platform_device *pdev)
 	if (dev) {
 		bp = netdev_priv(dev);
 		mdiobus_unregister(bp->mii_bus);
-		mdiobus_free(bp->mii_bus);
 
 		unregister_netdev(dev);
 		tasklet_kill(&bp->hresp_err_tasklet);
-- 
2.25.1

