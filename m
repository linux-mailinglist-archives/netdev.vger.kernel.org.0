Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA0C5ABA0D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIBVaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiIBVa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:30:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46AFEA315;
        Fri,  2 Sep 2022 14:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662154227; x=1693690227;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=0tijxlJT+sH8I3kLfF1FY/I3t/XXkOUKz1feGpP7oK0=;
  b=KZAnLylfyMFBn4KfN81S5Hhr5hWY6BRPBBY8cU4dUu+9xN+8dBlv3zpl
   HKsyh0njqbenqcxmgsZkVIXXmhTvhOZ60IkX8i0lyp1or5kfzwl0RVXK8
   kUdaULxWflei2NKM9apt67ZaFd7YZC98CLqDj6nfJdy5TK2lx9zAdtTyE
   4Oo5BQSJfXptFi9zyP77lEluJ4gCufm1pej/cZib12Zw0ovsO9wOSw8MQ
   vUfjzg0lB7KdQvGoFYwKApbWBn9T6pScqNtWb3siKZPtGlJF5RHte+iDs
   88vMjUiextQlIn/00PCE0Bfdxrdcptl3m7jisA4d6M5pww380D4RDVNED
   g==;
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="111997226"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 14:30:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 14:30:25 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 14:30:23 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH v2 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Date:   Fri, 2 Sep 2022 16:30:21 -0500
Message-ID: <20220902213021.23151-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220902213021.23151-1-jerry.ray@microchip.com>
References: <20220902213021.23151-1-jerry.ray@microchip.com>
MIME-Version: 1.0
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

Adding support for the LAN9354 device by allowing it to use
the LAN9303 DSA driver.  These devices have the same underlying
access and control methods and from a feature set point of view
the LAN9354 is a superset of the LAN9303.

The MDIO access method has been tested on a SAMA5D3-EDS board
with a LAN9354 RMII daughter card.

While the SPI access method should also be the same, it has not
been tested and as such is not included at this time.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/Kconfig        |  6 +++---
 drivers/net/dsa/lan9303-core.c | 11 ++++++++---
 drivers/net/dsa/lan9303_mdio.c |  1 +
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index d8ae0e8af2a0..07507b4820d7 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -76,7 +76,7 @@ config NET_DSA_SMSC_LAN9303
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
-	  This enables support for the SMSC/Microchip LAN9303 3 port ethernet
+	  This enables support for the Microchip LAN9303/LAN9354 3 port ethernet
 	  switch chips.
 
 config NET_DSA_SMSC_LAN9303_I2C
@@ -90,11 +90,11 @@ config NET_DSA_SMSC_LAN9303_I2C
 	  for I2C managed mode.
 
 config NET_DSA_SMSC_LAN9303_MDIO
-	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in MDIO managed mode"
+	tristate "Microchip LAN9303/LAN9354 3-ports 10/100 ethernet switch in MDIO managed mode"
 	select NET_DSA_SMSC_LAN9303
 	depends on VLAN_8021Q || VLAN_8021Q=n
 	help
-	  Enable access functions if the SMSC/Microchip LAN9303 is configured
+	  Enable access functions if the Microchip LAN9303/LAN9354 is configured
 	  for MDIO managed mode.
 
 config NET_DSA_VITESSE_VSC73XX
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 9d5302001abf..9e04541c3144 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -22,6 +22,10 @@
  */
 #define LAN9303_CHIP_REV 0x14
 # define LAN9303_CHIP_ID 0x9303
+# define LAN9352_CHIP_ID 0x9352
+# define LAN9353_CHIP_ID 0x9353
+# define LAN9354_CHIP_ID 0x9354
+# define LAN9355_CHIP_ID 0x9355
 #define LAN9303_IRQ_CFG 0x15
 # define LAN9303_IRQ_CFG_IRQ_ENABLE BIT(8)
 # define LAN9303_IRQ_CFG_IRQ_POL BIT(4)
@@ -855,8 +859,9 @@ static int lan9303_check_device(struct lan9303 *chip)
 		return ret;
 	}
 
-	if ((reg >> 16) != LAN9303_CHIP_ID) {
-		dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\n",
+	if (((reg >> 16) != LAN9303_CHIP_ID) &&
+	    ((reg >> 16) != LAN9354_CHIP_ID)) {
+		dev_err(chip->dev, "unexpected device found: LAN%4.4X\n",
 			reg >> 16);
 		return -ENODEV;
 	}
@@ -872,7 +877,7 @@ static int lan9303_check_device(struct lan9303 *chip)
 	if (ret)
 		dev_warn(chip->dev, "failed to disable switching %d\n", ret);
 
-	dev_info(chip->dev, "Found LAN9303 rev. %u\n", reg & 0xffff);
+	dev_info(chip->dev, "Found LAN%4.4X rev. %u\n", (reg >> 16), reg & 0xffff);
 
 	ret = lan9303_detect_phy_setup(chip);
 	if (ret) {
diff --git a/drivers/net/dsa/lan9303_mdio.c b/drivers/net/dsa/lan9303_mdio.c
index bbb7032409ba..d12c55fdc811 100644
--- a/drivers/net/dsa/lan9303_mdio.c
+++ b/drivers/net/dsa/lan9303_mdio.c
@@ -158,6 +158,7 @@ static void lan9303_mdio_shutdown(struct mdio_device *mdiodev)
 
 static const struct of_device_id lan9303_mdio_of_match[] = {
 	{ .compatible = "smsc,lan9303-mdio" },
+	{ .compatible = "microchip,lan9354-mdio" },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, lan9303_mdio_of_match);
-- 
2.17.1

