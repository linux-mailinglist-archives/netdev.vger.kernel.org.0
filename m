Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C85BE9D6
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiITPOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiITPOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:14:22 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096095A835;
        Tue, 20 Sep 2022 08:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1663686861;
  x=1695222861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PDXxWh6D8rkZ8qf1SR+LZVvNYgKTUnfKP/hI0dpGV9c=;
  b=jUUPSUeLOl9bCrQ0GvQf63vr2Lo63CInGZfSU2UcJgAmAbqZ21CJEEqr
   Q5SK6cc4gOg5sDC69dyG4R0FIdg76gd5iH7YzH10lANWtYFMr8iYn+y9K
   U2Ucr086d40AnaR6LkvR7BTNtA15EkUf4R8Cg7PuFRfS1LKBP56PaSyJq
   2nnM+96TUw1tYUXXt8PSzqMycOE7CrCr2W5BpeyCV0Ic1QO3aBwVy2cqa
   0+LZx1FodJkkRH2nzvTIfSP/ya9hE2BtPQcN+5pcSqr700lVZhLdZxcPQ
   YqGONF2Sz37f1fsh583ceXaOp2K3POcJFTYzO3yG0R20khIR8TIeCd2RS
   g==;
From:   Marcus Carlberg <marcus.carlberg@axis.com>
To:     <lxu@maxlinear.com>, <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <kernel@axis.com>,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <devicetree@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] net: phy: mxl-gpy: Add mode for 2 leds
Date:   Tue, 20 Sep 2022 17:14:11 +0200
Message-ID: <20220920151411.12523-3-marcus.carlberg@axis.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220920151411.12523-1-marcus.carlberg@axis.com>
References: <20220920151411.12523-1-marcus.carlberg@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPY211 phy default to using all four led pins.
Hardwares using only two leds where led0 is used as the high
network speed led and led1 the low network speed led will not
get the correct behaviour since 1Gbit and 2.5Gbit will not be
represented at all in the existing leds.

This patch adds a property for switching to a two led mode as specified
above.

Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
---
 drivers/net/phy/mxl-gpy.c | 45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 24bae27eedef..0886fa21c4ff 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -12,6 +12,7 @@
 #include <linux/phy.h>
 #include <linux/polynomial.h>
 #include <linux/netdevice.h>
+#include <linux/of_platform.h>

 /* PHY ID */
 #define PHY_ID_GPYx15B_MASK	0xFFFFFFFC
@@ -32,6 +33,7 @@
 #define PHY_MIISTAT		0x18	/* MII state */
 #define PHY_IMASK		0x19	/* interrupt mask */
 #define PHY_ISTAT		0x1A	/* interrupt status */
+#define PHY_LED			0x1B	/* LED control */
 #define PHY_FWV			0x1E	/* firmware version */

 #define PHY_MIISTAT_SPD_MASK	GENMASK(2, 0)
@@ -59,6 +61,16 @@
 #define PHY_FWV_MAJOR_MASK	GENMASK(11, 8)
 #define PHY_FWV_MINOR_MASK	GENMASK(7, 0)

+/* LED */
+#define VSPEC1_LED0_CTRL	0x01
+#define VSPEC1_LED1_CTRL	0x02
+#define VSPEC1_LED2_CTRL	0x03
+#define VSPEC1_LED3_CTRL	0x04
+#define TWO_LED_CONFIG				0x0300
+#define LED_BLINK_2500MBIT			0x0380
+#define LED_BLINK_1000MBIT_100MBIT_10_MBIT	0x0370
+#define LED_DUAL_MODE	2
+
 /* SGMII */
 #define VSPEC1_SGMII_CTRL	0x08
 #define VSPEC1_SGMII_CTRL_ANEN	BIT(12)		/* Aneg enable */
@@ -201,9 +213,34 @@ static int gpy_config_init(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }

+static int gpy_override_led_mode(struct phy_device
+				*phydev, u32 led_mode)
+{
+	int ret;
+
+	if (led_mode == LED_DUAL_MODE) {
+		ret = phy_write(phydev, PHY_LED, TWO_LED_CONFIG);
+		if (ret < 0)
+			return ret;
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND1,
+				    VSPEC1_LED0_CTRL,
+				    LED_BLINK_2500MBIT);
+		if (ret < 0)
+			return ret;
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND1,
+				    VSPEC1_LED1_CTRL,
+				    LED_BLINK_1000MBIT_100MBIT_10_MBIT);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int gpy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
+	struct device_node *np = dev->of_node;
 	struct gpy_priv *priv;
 	int fw_version;
 	int ret;
@@ -234,6 +271,14 @@ static int gpy_probe(struct phy_device *phydev)
 		    priv->fw_major, priv->fw_minor, fw_version,
 		    fw_version & PHY_FWV_REL_MASK ? "" : " test version");

+	/* Override led mode */
+	ret  = of_property_read_bool(np, "mxl,dual-led-mode");
+	if (ret) {
+		ret = gpy_override_led_mode(phydev, LED_DUAL_MODE);
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }

--
2.20.1

