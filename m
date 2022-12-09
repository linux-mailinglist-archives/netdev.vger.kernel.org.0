Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F997648AD9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLIWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLIWrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC50121830;
        Fri,  9 Dec 2022 14:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626038; x=1702162038;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=NxICK9YEAX5kiUZz9Kaz68Sx6I6kNikV7yxiKfqD0gQ=;
  b=HurkNQeA64dxssepArH1PUj4sRDrclHXbCxB0zWxyv4mZxIzDwwRDw9H
   0h8rqMFLm0oDH3A69YRoRLAwVSi7eQ9u6P2ziT+e1x/a+bSAsun959PCw
   hgj+0cRtEfAzdAX8d56tXHqxt6NFwD5ya/SEM+NCVE5gyqVPbsYznkTbq
   LM+tl8jTUJhjpk3SevNVVvRw22r873CjxuLVy7aLkjsAY/i2ZBVjAzQSe
   VqrutDNVP8Fq1vMGgn0TwWdUGZNw3XJBhco0tmrry41wsUEKP9wlb2xSa
   UCAaV4zg0FgMavbk7aQ92FW1VqHtpB7DrZJGYGasPVgxxo0/Gk6nKf1yt
   A==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="203381000"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:17 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:16 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 2/6] dsa: lan9303: move Turbo Mode bit initialization
Date:   Fri, 9 Dec 2022 16:47:09 -0600
Message-ID: <20221209224713.19980-3-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
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
 drivers/net/dsa/lan9303-core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 5a21fc96d479..20fc2af62531 100644
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
 
@@ -1073,14 +1079,6 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
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

