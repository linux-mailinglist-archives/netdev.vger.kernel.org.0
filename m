Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875C4642BC8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiLEPbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiLEPar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:30:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C825BE78;
        Mon,  5 Dec 2022 07:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670254182; x=1701790182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CTju6p3lEQWouZLK24Wd4h6927YMxUYLWgbCTRU7lrk=;
  b=faemkw3LRsYUBpYjJmp86x0LkskVbWJJE2HcxiPKpxcraaJPs8aFWcEq
   mt9H4/V4YGNRzRumHcyqEspcud9SbcrBHJ0wskXDEfEbui8k3Gp1+NFQS
   NVkHyzVJo/kou15eW8LnLGGZ+Haor86JiCg9rHG3AjZ6jCVRO9z36+ZxP
   jAXoIa3amZRoYo3aBNVuWI8IMhmJnvXi8fu6Y7XsSOeuHizx8CXVleSFt
   H1R/LqEK1BFKfpQVm08o9yfH6XoISPcNz2AUDHRzRQzkFxz+Uli+DT22y
   EYNkIFIqSRQe3jXN9elQ+j5+hHvpqjqYOOcycf0Jt9R8fVxIrWIsc2OpJ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="190082671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 08:29:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 08:29:39 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Dec 2022 08:29:37 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 2/2] net: macb: fix connectivity after resume
Date:   Mon, 5 Dec 2022 17:33:28 +0200
Message-ID: <20221205153328.503576-3-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221205153328.503576-1-claudiu.beznea@microchip.com>
References: <20221205153328.503576-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC")
signals to PHY layer that the PHY PM management is done by the MAC driver
itself. In case this is done the mdio_bus_phy_suspend() and
mdio_bus_phy_resume() will return just at its beginning letting the MAC
driver to handle the PHY power management.

AT91 devices (e.g. SAMA7G5, SAMA5D2) has a special power saving mode
called backup and self-refresh where most of the SoCs parts are shutdown
on suspend and RAM is switched to self-refresh. The rail powering the
on-board ethernet PHY could also be closed.

For scenarios where backup and self-refresh is used the MACB driver needs
to re-initialize the PHY device itself when resuming. Otherwise there is
poor or missing connectivity (e.g. SAMA7G5-EK uses KSZ9131 in RGMII mode
which needs its DLL settings to satisfy RGMII timings). For this
phylink_init_phydev() has been called on resume path before
phylink_start(). Up to
commit bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC")
this has been handled by mdio_bus_phy_resume().

This has been tested on SAMA7G5-EK (with KSZ9131 and KSZ8081 PHYs), on
SAMA5D2 (with KSZ8081 PHY), on SAM9X60 (with KSZ8081 PHY).

Fixes: bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

This patch depends on patch 1/2 from this series. For proper backporting
to older kernel (in case this series is integrated as is) please add the
Depends-on tag on this patch after patch 1/2 is integrated in networking
tree.

Thank you,
Claudiu Beznea

 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..8baa53706721 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5238,6 +5238,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!device_may_wakeup(&bp->dev->dev))
 		phy_init(bp->sgmii_phy);
 
+	phylink_init_phydev(bp->phylink);
 	phylink_start(bp->phylink);
 	rtnl_unlock();
 
-- 
2.34.1

