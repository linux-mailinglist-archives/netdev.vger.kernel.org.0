Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1660A5A53AB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiH2SAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 14:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiH2SAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 14:00:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBE560519;
        Mon, 29 Aug 2022 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661796043; x=1693332043;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=zUXIO+Wk9jcWeQnQbhWvg4aTbpaTh2kM5uYXORo58Ko=;
  b=woTczaQQQHXLZTJoDS8pVvzMqE0ig0bapTPk/87T1gW6Tw1PolUKZ5uW
   ecbTO8QNjgQBxPYd/k67qt6eJLzroHflG5cTP/LhjCnbY1zeVD2fzRecb
   nfNyasPvgT6Jji5FBA3EhbNS0Ze1cAlfgK40oEcBzf6Jv3g9ikEQlB6dd
   2kHRxVm8sjgOX1zAid7eeXtiIhju24kKAVO4Yrvz3YlTXlpR5CdQNEh6w
   NWgZyScA8k6HM5W2N+192h0yjD1jgnSRAqacdhpyBxWjlTnbZf49av92U
   fDCHPTYxpZaLqyHMqcmQLAPVc13tlIwVaRZHIQT0G5v8uXTFSYUBOFMhE
   w==;
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="188516857"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 11:00:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 11:00:43 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 11:00:41 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Date:   Mon, 29 Aug 2022 13:00:37 -0500
Message-ID: <20220829180037.31078-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829180037.31078-1-jerry.ray@microchip.com>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
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
index 17ae02a56bfe..4ea8c95cc23e 100644
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
@@ -867,8 +871,9 @@ static int lan9303_check_device(struct lan9303 *chip)
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
@@ -884,7 +889,7 @@ static int lan9303_check_device(struct lan9303 *chip)
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

