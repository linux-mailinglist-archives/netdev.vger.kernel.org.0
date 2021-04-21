Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A1C3664AF
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhDUFKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:10:31 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:58388 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhDUFKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 01:10:31 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lZ4xf-000CbZ-Oa; Wed, 21 Apr 2021 06:59:39 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lZ4xe-000K08-St; Wed, 21 Apr 2021 06:59:38 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 082F3240041;
        Wed, 21 Apr 2021 06:59:38 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 7B28E240040;
        Wed, 21 Apr 2021 06:59:37 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 19A2F20240;
        Wed, 21 Apr 2021 06:59:37 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] net: phy: intel-xway: enable integrated led functions
Date:   Wed, 21 Apr 2021 06:59:17 +0200
Message-ID: <20210421045917.10171-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-ID: 151534::1618981179-0001DC19-A880F7FB/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel xway phys offer the possibility to deactivate the integrated
led function and to control the leds manually.
If this was set by the bootloader, it must be ensured that the
integrated led function is enabled for all leds when loading the driver.

Before 6e2d85ec0559 ("net: phy: Stop with excessive soft reset") the
LEDs were enabled by a soft-reset of the PHY (using
genphy_soft_reset). Initialize the XWAY_MDIO_LED with it's default
value (which is applied during a soft reset) instead of adding back
the soft reset. This brings back the default LED configuration while
still preventing an excessive amount of soft resets.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 drivers/net/phy/intel-xway.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index 6eac50d4b42f..d453ec016168 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -11,6 +11,18 @@
=20
 #define XWAY_MDIO_IMASK			0x19	/* interrupt mask */
 #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
+#define XWAY_MDIO_LED			0x1B	/* led control */
+
+/* bit 15:12 are reserved */
+#define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function=
 of LED3 */
+#define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function=
 of LED2 */
+#define XWAY_MDIO_LED_LED1_EN		BIT(9)	/* Enable the integrated function =
of LED1 */
+#define XWAY_MDIO_LED_LED0_EN		BIT(8)	/* Enable the integrated function =
of LED0 */
+/* bit 7:4 are reserved */
+#define XWAY_MDIO_LED_LED3_DA		BIT(3)	/* Direct Access to LED3 */
+#define XWAY_MDIO_LED_LED2_DA		BIT(2)	/* Direct Access to LED2 */
+#define XWAY_MDIO_LED_LED1_DA		BIT(1)	/* Direct Access to LED1 */
+#define XWAY_MDIO_LED_LED0_DA		BIT(0)	/* Direct Access to LED0 */
=20
 #define XWAY_MDIO_INIT_WOL		BIT(15)	/* Wake-On-LAN */
 #define XWAY_MDIO_INIT_MSRE		BIT(14)
@@ -159,6 +171,15 @@ static int xway_gphy_config_init(struct phy_device *=
phydev)
 	/* Clear all pending interrupts */
 	phy_read(phydev, XWAY_MDIO_ISTAT);
=20
+	/* Ensure that integrated led function is enabled for all leds */
+	err =3D phy_write(phydev, XWAY_MDIO_LED,
+			XWAY_MDIO_LED_LED0_EN |
+			XWAY_MDIO_LED_LED1_EN |
+			XWAY_MDIO_LED_LED2_EN |
+			XWAY_MDIO_LED_LED3_EN);
+	if (err)
+		return err;
+
 	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LEDCH,
 		      XWAY_MMD_LEDCH_NACS_NONE |
 		      XWAY_MMD_LEDCH_SBF_F02HZ |
--=20
2.20.1

