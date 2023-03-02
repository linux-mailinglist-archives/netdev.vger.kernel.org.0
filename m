Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496F96A8402
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 15:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCBORM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 09:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBORL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 09:17:11 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C040D34334;
        Thu,  2 Mar 2023 06:17:02 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DCE6C88;
        Thu,  2 Mar 2023 15:16:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677766619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xeWAgjKSMqG6fw3TGLxgmXOddJeFMsepBRpyp4lGwbA=;
        b=oFiaJ/FoNuixUpcMVyUBGjG6lvdEFYYI7vCh45tzXUukD4o2hMbaMeJhjQNzFa4EL/oVSf
        0OzcmtTmEs6dIaErgVsmCXqKQWErf4qFFwIPiTpxhGce7gPle8uo0W/9ol5iZIpJttuPU0
        4MDCeUQFh+wN/55O/7f4fx8h84EWps/aX/uUue7poaMv53DeqyGy6WblCo1SfLXQ7P8YXE
        dzX1yz4jiEIJxiRV4Zwf3GwFerrihwWytymuYeuSTr0xz+Yg+/DL/EX9ozrwDlAKEr44Rp
        y4QeHYApAmLx5P3ziitcdNkCXP5Qg2svYOeuAku8H0N7kCkJ3tj1CGX3/g8vEg==
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next] net: phy: intel-xway: remove LED configuration
Date:   Thu,  2 Mar 2023 15:16:51 +0100
Message-Id: <20230302141651.377261-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For this PHY, the LEDs can either be configured through an attached
EEPROM or if not available, the PHY offers sane default modes. Right now,
the driver will configure to a mode just suitable for one configuration
(although there is a bold claim that "most boards have just one LED").
I'd argue, that as long as there is no configuration through other means
(like device tree), the driver shouldn't configure anything LED related
so that the PHY is using either the modes configured by the EEPROM or
the power-on defaults.

Signed-off-by: Michael Walle <michael@walle.cc>
---
I know there is ongoing work on the device tree, but even then, my
argument holds, if there is no config in the device tree, the driver
shouldn't just use "any" configuration when there are means by the
hardware to configure the LEDs.

Not just as an RFC because netdev is closed, but also to get other
opinions. Not to be applied.
---
 drivers/net/phy/intel-xway.c | 149 -----------------------------------
 1 file changed, 149 deletions(-)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index 3c032868ef04..4428721238a7 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -18,17 +18,6 @@
 #define XWAY_MDIO_MIICTRL_RXSKEW_MASK	GENMASK(14, 12)
 #define XWAY_MDIO_MIICTRL_TXSKEW_MASK	GENMASK(10, 8)
 
-/* bit 15:12 are reserved */
-#define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function of LED3 */
-#define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function of LED2 */
-#define XWAY_MDIO_LED_LED1_EN		BIT(9)	/* Enable the integrated function of LED1 */
-#define XWAY_MDIO_LED_LED0_EN		BIT(8)	/* Enable the integrated function of LED0 */
-/* bit 7:4 are reserved */
-#define XWAY_MDIO_LED_LED3_DA		BIT(3)	/* Direct Access to LED3 */
-#define XWAY_MDIO_LED_LED2_DA		BIT(2)	/* Direct Access to LED2 */
-#define XWAY_MDIO_LED_LED1_DA		BIT(1)	/* Direct Access to LED1 */
-#define XWAY_MDIO_LED_LED0_DA		BIT(0)	/* Direct Access to LED0 */
-
 #define XWAY_MDIO_INIT_WOL		BIT(15)	/* Wake-On-LAN */
 #define XWAY_MDIO_INIT_MSRE		BIT(14)
 #define XWAY_MDIO_INIT_NPRX		BIT(13)
@@ -46,111 +35,6 @@
 
 #define ADVERTISED_MPD			BIT(10)	/* Multi-port device */
 
-/* LED Configuration */
-#define XWAY_MMD_LEDCH			0x01E0
-/* Inverse of SCAN Function */
-#define  XWAY_MMD_LEDCH_NACS_NONE	0x0000
-#define  XWAY_MMD_LEDCH_NACS_LINK	0x0001
-#define  XWAY_MMD_LEDCH_NACS_PDOWN	0x0002
-#define  XWAY_MMD_LEDCH_NACS_EEE	0x0003
-#define  XWAY_MMD_LEDCH_NACS_ANEG	0x0004
-#define  XWAY_MMD_LEDCH_NACS_ABIST	0x0005
-#define  XWAY_MMD_LEDCH_NACS_CDIAG	0x0006
-#define  XWAY_MMD_LEDCH_NACS_TEST	0x0007
-/* Slow Blink Frequency */
-#define  XWAY_MMD_LEDCH_SBF_F02HZ	0x0000
-#define  XWAY_MMD_LEDCH_SBF_F04HZ	0x0010
-#define  XWAY_MMD_LEDCH_SBF_F08HZ	0x0020
-#define  XWAY_MMD_LEDCH_SBF_F16HZ	0x0030
-/* Fast Blink Frequency */
-#define  XWAY_MMD_LEDCH_FBF_F02HZ	0x0000
-#define  XWAY_MMD_LEDCH_FBF_F04HZ	0x0040
-#define  XWAY_MMD_LEDCH_FBF_F08HZ	0x0080
-#define  XWAY_MMD_LEDCH_FBF_F16HZ	0x00C0
-/* LED Configuration */
-#define XWAY_MMD_LEDCL			0x01E1
-/* Complex Blinking Configuration */
-#define  XWAY_MMD_LEDCH_CBLINK_NONE	0x0000
-#define  XWAY_MMD_LEDCH_CBLINK_LINK	0x0001
-#define  XWAY_MMD_LEDCH_CBLINK_PDOWN	0x0002
-#define  XWAY_MMD_LEDCH_CBLINK_EEE	0x0003
-#define  XWAY_MMD_LEDCH_CBLINK_ANEG	0x0004
-#define  XWAY_MMD_LEDCH_CBLINK_ABIST	0x0005
-#define  XWAY_MMD_LEDCH_CBLINK_CDIAG	0x0006
-#define  XWAY_MMD_LEDCH_CBLINK_TEST	0x0007
-/* Complex SCAN Configuration */
-#define  XWAY_MMD_LEDCH_SCAN_NONE	0x0000
-#define  XWAY_MMD_LEDCH_SCAN_LINK	0x0010
-#define  XWAY_MMD_LEDCH_SCAN_PDOWN	0x0020
-#define  XWAY_MMD_LEDCH_SCAN_EEE	0x0030
-#define  XWAY_MMD_LEDCH_SCAN_ANEG	0x0040
-#define  XWAY_MMD_LEDCH_SCAN_ABIST	0x0050
-#define  XWAY_MMD_LEDCH_SCAN_CDIAG	0x0060
-#define  XWAY_MMD_LEDCH_SCAN_TEST	0x0070
-/* Configuration for LED Pin x */
-#define XWAY_MMD_LED0H			0x01E2
-/* Fast Blinking Configuration */
-#define  XWAY_MMD_LEDxH_BLINKF_MASK	0x000F
-#define  XWAY_MMD_LEDxH_BLINKF_NONE	0x0000
-#define  XWAY_MMD_LEDxH_BLINKF_LINK10	0x0001
-#define  XWAY_MMD_LEDxH_BLINKF_LINK100	0x0002
-#define  XWAY_MMD_LEDxH_BLINKF_LINK10X	0x0003
-#define  XWAY_MMD_LEDxH_BLINKF_LINK1000	0x0004
-#define  XWAY_MMD_LEDxH_BLINKF_LINK10_0	0x0005
-#define  XWAY_MMD_LEDxH_BLINKF_LINK100X	0x0006
-#define  XWAY_MMD_LEDxH_BLINKF_LINK10XX	0x0007
-#define  XWAY_MMD_LEDxH_BLINKF_PDOWN	0x0008
-#define  XWAY_MMD_LEDxH_BLINKF_EEE	0x0009
-#define  XWAY_MMD_LEDxH_BLINKF_ANEG	0x000A
-#define  XWAY_MMD_LEDxH_BLINKF_ABIST	0x000B
-#define  XWAY_MMD_LEDxH_BLINKF_CDIAG	0x000C
-/* Constant On Configuration */
-#define  XWAY_MMD_LEDxH_CON_MASK	0x00F0
-#define  XWAY_MMD_LEDxH_CON_NONE	0x0000
-#define  XWAY_MMD_LEDxH_CON_LINK10	0x0010
-#define  XWAY_MMD_LEDxH_CON_LINK100	0x0020
-#define  XWAY_MMD_LEDxH_CON_LINK10X	0x0030
-#define  XWAY_MMD_LEDxH_CON_LINK1000	0x0040
-#define  XWAY_MMD_LEDxH_CON_LINK10_0	0x0050
-#define  XWAY_MMD_LEDxH_CON_LINK100X	0x0060
-#define  XWAY_MMD_LEDxH_CON_LINK10XX	0x0070
-#define  XWAY_MMD_LEDxH_CON_PDOWN	0x0080
-#define  XWAY_MMD_LEDxH_CON_EEE		0x0090
-#define  XWAY_MMD_LEDxH_CON_ANEG	0x00A0
-#define  XWAY_MMD_LEDxH_CON_ABIST	0x00B0
-#define  XWAY_MMD_LEDxH_CON_CDIAG	0x00C0
-#define  XWAY_MMD_LEDxH_CON_COPPER	0x00D0
-#define  XWAY_MMD_LEDxH_CON_FIBER	0x00E0
-/* Configuration for LED Pin x */
-#define XWAY_MMD_LED0L			0x01E3
-/* Pulsing Configuration */
-#define  XWAY_MMD_LEDxL_PULSE_MASK	0x000F
-#define  XWAY_MMD_LEDxL_PULSE_NONE	0x0000
-#define  XWAY_MMD_LEDxL_PULSE_TXACT	0x0001
-#define  XWAY_MMD_LEDxL_PULSE_RXACT	0x0002
-#define  XWAY_MMD_LEDxL_PULSE_COL	0x0004
-/* Slow Blinking Configuration */
-#define  XWAY_MMD_LEDxL_BLINKS_MASK	0x00F0
-#define  XWAY_MMD_LEDxL_BLINKS_NONE	0x0000
-#define  XWAY_MMD_LEDxL_BLINKS_LINK10	0x0010
-#define  XWAY_MMD_LEDxL_BLINKS_LINK100	0x0020
-#define  XWAY_MMD_LEDxL_BLINKS_LINK10X	0x0030
-#define  XWAY_MMD_LEDxL_BLINKS_LINK1000	0x0040
-#define  XWAY_MMD_LEDxL_BLINKS_LINK10_0	0x0050
-#define  XWAY_MMD_LEDxL_BLINKS_LINK100X	0x0060
-#define  XWAY_MMD_LEDxL_BLINKS_LINK10XX	0x0070
-#define  XWAY_MMD_LEDxL_BLINKS_PDOWN	0x0080
-#define  XWAY_MMD_LEDxL_BLINKS_EEE	0x0090
-#define  XWAY_MMD_LEDxL_BLINKS_ANEG	0x00A0
-#define  XWAY_MMD_LEDxL_BLINKS_ABIST	0x00B0
-#define  XWAY_MMD_LEDxL_BLINKS_CDIAG	0x00C0
-#define XWAY_MMD_LED1H			0x01E4
-#define XWAY_MMD_LED1L			0x01E5
-#define XWAY_MMD_LED2H			0x01E6
-#define XWAY_MMD_LED2L			0x01E7
-#define XWAY_MMD_LED3H			0x01E8
-#define XWAY_MMD_LED3L			0x01E9
-
 #define PHY_ID_PHY11G_1_3		0x030260D1
 #define PHY_ID_PHY22F_1_3		0x030260E1
 #define PHY_ID_PHY11G_1_4		0xD565A400
@@ -243,39 +127,6 @@ static int xway_gphy_config_init(struct phy_device *phydev)
 	/* Clear all pending interrupts */
 	phy_read(phydev, XWAY_MDIO_ISTAT);
 
-	/* Ensure that integrated led function is enabled for all leds */
-	err = phy_write(phydev, XWAY_MDIO_LED,
-			XWAY_MDIO_LED_LED0_EN |
-			XWAY_MDIO_LED_LED1_EN |
-			XWAY_MDIO_LED_LED2_EN |
-			XWAY_MDIO_LED_LED3_EN);
-	if (err)
-		return err;
-
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LEDCH,
-		      XWAY_MMD_LEDCH_NACS_NONE |
-		      XWAY_MMD_LEDCH_SBF_F02HZ |
-		      XWAY_MMD_LEDCH_FBF_F16HZ);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LEDCL,
-		      XWAY_MMD_LEDCH_CBLINK_NONE |
-		      XWAY_MMD_LEDCH_SCAN_NONE);
-
-	/**
-	 * In most cases only one LED is connected to this phy, so
-	 * configure them all to constant on and pulse mode. LED3 is
-	 * only available in some packages, leave it in its reset
-	 * configuration.
-	 */
-	ledxh = XWAY_MMD_LEDxH_BLINKF_NONE | XWAY_MMD_LEDxH_CON_LINK10XX;
-	ledxl = XWAY_MMD_LEDxL_PULSE_TXACT | XWAY_MMD_LEDxL_PULSE_RXACT |
-		XWAY_MMD_LEDxL_BLINKS_NONE;
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED0H, ledxh);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED0L, ledxl);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED1H, ledxh);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED1L, ledxl);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
-	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
-
 	err = xway_gphy_rgmii_init(phydev);
 	if (err)
 		return err;
-- 
2.30.2

