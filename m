Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476D33C2341
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhGIMHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:07:47 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:4905 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhGIMHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:07:46 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2021 08:07:46 EDT
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1p8Z-000JcM-2I; Fri, 09 Jul 2021 13:57:43 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1p8X-0002pA-QA; Fri, 09 Jul 2021 13:57:41 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id D9AE6240041;
        Fri,  9 Jul 2021 13:57:40 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 32F0C240040;
        Fri,  9 Jul 2021 13:57:40 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 9027D20196;
        Fri,  9 Jul 2021 13:57:39 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next] net: phy: intel-xway: Add RGMII internal delay configuration
Date:   Fri,  9 Jul 2021 13:57:26 +0200
Message-ID: <20210709115726.11897-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-ID: 151534::1625831862-000003B7-4942A3E1/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the posibility to configure the RGMII RX/TX clock skew via
devicetree.

Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
devicetree.

Furthermore, a warning is now issued if the phy mode is configured to
"rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
as in the dp83867 driver.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 drivers/net/phy/intel-xway.c | 91 ++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index d453ec016168..6fc8f54247c2 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -9,10 +9,16 @@
 #include <linux/phy.h>
 #include <linux/of.h>
=20
+#define XWAY_MDIO_MIICTRL		0x17	/* mii control */
 #define XWAY_MDIO_IMASK			0x19	/* interrupt mask */
 #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
 #define XWAY_MDIO_LED			0x1B	/* led control */
=20
+#define XWAY_MDIO_MIICTRL_RXSKEW_MASK	GENMASK(14, 12)
+#define XWAY_MDIO_MIICTRL_RXSKEW_SHIFT	12
+#define XWAY_MDIO_MIICTRL_TXSKEW_MASK	GENMASK(10, 8)
+#define XWAY_MDIO_MIICTRL_TXSKEW_SHIFT	8
+
 /* bit 15:12 are reserved */
 #define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function=
 of LED3 */
 #define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function=
 of LED2 */
@@ -157,6 +163,87 @@
 #define PHY_ID_PHY11G_VR9_1_2		0xD565A409
 #define PHY_ID_PHY22F_VR9_1_2		0xD565A419
=20
+#if IS_ENABLED(CONFIG_OF_MDIO)
+static const int xway_internal_delay[] =3D {0, 500, 1000, 1500, 2000, 25=
00,
+					 3000, 3500};
+
+static int xway_gphy_of_reg_init(struct phy_device *phydev)
+{
+	struct device *dev =3D &phydev->mdio.dev;
+	int delay_size =3D ARRAY_SIZE(xway_internal_delay);
+	s32 rx_int_delay;
+	s32 tx_int_delay;
+	int err =3D 0;
+	int val;
+
+	if (phy_interface_is_rgmii(phydev)) {
+		val =3D phy_read(phydev, XWAY_MDIO_MIICTRL);
+		if (val < 0)
+			return val;
+	}
+
+	/* Existing behavior was to use default pin strapping delay in rgmii
+	 * mode, but rgmii should have meant no delay.  Warn existing users.
+	 */
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII) {
+		const u16 txskew =3D (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
+				   XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
+		const u16 rxskew =3D (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
+				   XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
+
+		if (txskew > 0 || rxskew > 0)
+			phydev_warn(phydev,
+				    "PHY has delays (e.g. via pin strapping), but phy-mode =3D 'rgmi=
i'\n"
+				    "Should be 'rgmii-id' to use internal delays txskew:%x rxskew:%x=
\n",
+				    txskew, rxskew);
+	}
+
+	/* RX delay *must* be specified if internal delay of RX is used. */
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID) {
+		rx_int_delay =3D phy_get_internal_delay(phydev, dev,
+						      &xway_internal_delay[0],
+						      delay_size, true);
+
+		if (rx_int_delay < 0) {
+			phydev_err(phydev, "rx-internal-delay-ps must be specified\n");
+			return rx_int_delay;
+		}
+
+		val &=3D ~XWAY_MDIO_MIICTRL_RXSKEW_MASK;
+		val |=3D rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
+	}
+
+	/* TX delay *must* be specified if internal delay of TX is used. */
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
+		tx_int_delay =3D phy_get_internal_delay(phydev, dev,
+						      &xway_internal_delay[0],
+						      delay_size, false);
+
+		if (tx_int_delay < 0) {
+			phydev_err(phydev, "tx-internal-delay-ps must be specified\n");
+			return tx_int_delay;
+		}
+
+		val &=3D ~XWAY_MDIO_MIICTRL_TXSKEW_MASK;
+		val |=3D tx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
+	}
+
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)
+		err =3D phy_write(phydev, XWAY_MDIO_MIICTRL, val);
+
+	return err;
+}
+#else
+static int xway_gphy_of_reg_init(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif /* CONFIG_OF_MDIO */
+
 static int xway_gphy_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -204,6 +291,10 @@ static int xway_gphy_config_init(struct phy_device *=
phydev)
 	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
 	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
=20
+	err =3D xway_gphy_of_reg_init(phydev);
+	if (err)
+		return err;
+
 	return 0;
 }
=20
--=20
2.20.1

