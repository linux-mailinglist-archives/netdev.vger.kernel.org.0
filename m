Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF55B3C97
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiIIQCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiIIQCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:02:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E4311C7F0;
        Fri,  9 Sep 2022 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662739326; x=1694275326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FX3EoD/dBRgSe79PLVfWACPg00qOURLb460tBUUxzcQ=;
  b=DENlWMyHCuwa+xoIsHOyZFVGIQrdtgNNwIw5Mk0uBtHtHhKDalcD4unG
   Skw2011/HCcNKSxN4nSEHndGSkuKdbp1OJrUykT2/yOyJgXvKEEJHFCgQ
   JlEwgFn0LE/BwnyueZr5uzNYG7ahPgx3SR4GDWKwnpkwRhdeIJM/xdspK
   aP3EN2Z20BoVx0NfDfNFB/JcsGGQuxNhvFCdqB/47lmt08HUSRdy3rzAG
   gJXjG+kCMDFKmCzb7cMcgcAMnhOQREiSKrVVJ7OmjRoUfieWBL0n5Ds8s
   NkMVv3SK8qynEvSLSSg29FcMllNPnjcXj2hS3K5t0sQuh4iipRm+NfcH+
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="179874779"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 09:02:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 09:02:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 09:01:59 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 2/4] net: dsa: microchip: enable phy interrupts only if interrupt enabled in dts
Date:   Fri, 9 Sep 2022 21:31:18 +0530
Message-ID: <20220909160120.9101-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220909160120.9101-1-arun.ramadoss@microchip.com>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the lan937x_mdio_register function, phy interrupts are enabled
irrespective of irq is enabled in the switch. Now, the check is added to
enable the phy interrupt only if the irq is enabled in the switch.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7136d9c55315..1f4472c90a1f 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -235,15 +235,18 @@ static int lan937x_mdio_register(struct ksz_device *dev)
 
 	ds->slave_mii_bus = bus;
 
-	ret = lan937x_irq_phy_setup(dev);
-	if (ret)
-		return ret;
+	if (dev->irq > 0) {
+		ret = lan937x_irq_phy_setup(dev);
+		if (ret)
+			return ret;
+	}
 
 	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
 	if (ret) {
 		dev_err(ds->dev, "unable to register MDIO bus %s\n",
 			bus->id);
-		lan937x_irq_phy_free(dev);
+		if (dev->irq > 0)
+			lan937x_irq_phy_free(dev);
 	}
 
 	of_node_put(mdio_np);
-- 
2.36.1

