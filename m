Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570396632B9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbjAIVTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbjAIVTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:19:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D2C193;
        Mon,  9 Jan 2023 13:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673299143; x=1704835143;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=qk7EXgI2QvbLbQWUvseiawTbqOJcT8gGauJRmP837Hw=;
  b=hGefZ7UvoinO80K09A3YGXyk08JxrlsHvtmXbjd1trt4p5j+kGw2+rIE
   nWZz0HAANcclN4fZbC/XlxM8ZWQ3EOEM6bhMSUY1h72gbjKpPckw2Saj3
   FrWAZXFltRs2nf+Huj6WKKto6/l0gXMRdKTrtYTUyod89lXxwVPQYieYN
   Xd7hI54iiEIXz7I4BwiDqIz4hN22hWzTIbrVIg+phZo9dZGE+wbQ1UgyT
   3jrwQPKWzZG3BALOkE628JbplOy1gSWbVWUYe0G4dsio+Gsc/Fyehtmhc
   7dNTZQLs+z1ARRBotmHkgEfSkt0+QTICN4tNJ26MajINmp9HfNVO6M/fe
   g==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="131543894"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2023 14:19:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:18:58 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:18:56 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Date:   Mon, 9 Jan 2023 15:18:45 -0600
Message-ID: <20230109211849.32530-3-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109211849.32530-1-jerry.ray@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparing to remove the .adjust_link api, I am moving the one-time
initialization of the device's Turbo Mode bit into a different execution
path. This code clears (disables) the Turbo Mode bit which is never used
by this driver. Turbo Mode is a non-standard mode that would allow the
100Mbps RMII interface to run at 200Mbps.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 5a21fc96d479..50470fb09cb4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -886,6 +886,12 @@ static int lan9303_check_device(struct lan9303 *chip)
 		return ret;
 	}
 
+	/* Virtual Phy: Remove Turbo 200Mbit mode */
+	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+
+	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+
 	return 0;
 }
 
@@ -1050,7 +1056,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
 static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 				struct phy_device *phydev)
 {
-	struct lan9303 *chip = ds->priv;
 	int ctl;
 
 	if (!phy_is_pseudo_fixed_link(phydev))
@@ -1073,14 +1078,6 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 		ctl &= ~BMCR_FULLDPLX;
 
 	lan9303_phy_write(ds, port, MII_BMCR, ctl);
-
-	if (port == chip->phy_addr_base) {
-		/* Virtual Phy: Remove Turbo 200Mbit mode */
-		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
-
-		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
-		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
-	}
 }
 
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
-- 
2.17.1

