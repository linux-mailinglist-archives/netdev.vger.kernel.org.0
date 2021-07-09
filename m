Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB93C27B6
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhGIQpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:45:22 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:54645 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGIQpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 12:45:22 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1ta4-0004S8-CE; Fri, 09 Jul 2021 18:42:24 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m1ta2-0006Kc-7t; Fri, 09 Jul 2021 18:42:22 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1BB2A240041;
        Fri,  9 Jul 2021 18:42:21 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 62A4A240040;
        Fri,  9 Jul 2021 18:42:20 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 9402520176;
        Fri,  9 Jul 2021 18:42:19 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal delay configuration
Date:   Fri,  9 Jul 2021 18:42:16 +0200
Message-ID: <20210709164216.18561-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1625848943-000072E2-E541AF66/0/0
X-purgate: clean
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

Changes to v2:
o Fix missing whitespace in warning.

Changes to v1:
o code cleanup and use phy_modify().
o use default of 2.0ns if delay property is absent instead of returning
  an error.

---
 drivers/net/phy/intel-xway.c | 90 ++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index d453ec016168..796e6f2eb2d5 100644
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
@@ -157,6 +163,86 @@
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
+	u16 mask =3D 0;
+	int val =3D 0;
+
+	if (!phy_interface_is_rgmii(phydev))
+		return 0;
+
+	/* Existing behavior was to use default pin strapping delay in rgmii
+	 * mode, but rgmii should have meant no delay.  Warn existing users,
+	 * but do not change anything at the moment.
+	 */
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII) {
+		u16 txskew, rxskew;
+
+		val =3D phy_read(phydev, XWAY_MDIO_MIICTRL);
+		if (val < 0)
+			return val;
+
+		txskew =3D (val & XWAY_MDIO_MIICTRL_TXSKEW_MASK) >>
+			 XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
+		rxskew =3D (val & XWAY_MDIO_MIICTRL_RXSKEW_MASK) >>
+			 XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
+
+		if (txskew > 0 || rxskew > 0)
+			phydev_warn(phydev,
+				    "PHY has delays (e.g. via pin strapping), but phy-mode =3D 'rgmi=
i'\n"
+				    "Should be 'rgmii-id' to use internal delays txskew:%d ps rxskew=
:%d ps\n",
+				    xway_internal_delay[txskew],
+				    xway_internal_delay[rxskew]);
+		return 0;
+	}
+
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID) {
+		rx_int_delay =3D phy_get_internal_delay(phydev, dev,
+						      &xway_internal_delay[0],
+						      delay_size, true);
+
+		if (rx_int_delay < 0) {
+			phydev_warn(phydev, "rx-internal-delay-ps is missing, use default of =
2.0 ns\n");
+			rx_int_delay =3D 4; /* 2000 ps */
+		}
+
+		mask |=3D XWAY_MDIO_MIICTRL_RXSKEW_MASK;
+		val |=3D rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
+	}
+
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
+		tx_int_delay =3D phy_get_internal_delay(phydev, dev,
+						      &xway_internal_delay[0],
+						      delay_size, false);
+
+		if (tx_int_delay < 0) {
+			phydev_warn(phydev, "tx-internal-delay-ps is missing, use default of =
2.0 ns\n");
+			tx_int_delay =3D 4; /* 2000 ps */
+		}
+
+		mask |=3D XWAY_MDIO_MIICTRL_TXSKEW_MASK;
+		val |=3D tx_int_delay << XWAY_MDIO_MIICTRL_TXSKEW_SHIFT;
+	}
+
+	return phy_modify(phydev, XWAY_MDIO_MIICTRL, mask, val);
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
@@ -204,6 +290,10 @@ static int xway_gphy_config_init(struct phy_device *=
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

