Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B917B3C4DA9
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhGLHNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 03:13:51 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:39163 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243736AbhGLHIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 03:08:52 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m2q0T-0001NZ-VM; Mon, 12 Jul 2021 09:05:34 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m2q0Q-000ByW-Je; Mon, 12 Jul 2021 09:05:30 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 7E6FB240041;
        Mon, 12 Jul 2021 09:05:28 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id CFD03240040;
        Mon, 12 Jul 2021 09:05:27 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 2E7532029C;
        Mon, 12 Jul 2021 09:05:27 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v4] net: phy: intel-xway: Add RGMII internal delay configuration
Date:   Mon, 12 Jul 2021 09:04:53 +0200
Message-ID: <20210712070453.8167-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1626073531-00007B90-193A2682/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the possibility to configure the RGMII RX/TX clock skew via
devicetree.

Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
devicetree.

Furthermore, a warning is now issued if the phy mode is configured to
"rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
as in the dp83867 driver.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---

Changes to v3:
o Fix typo in commit message
o use FIELD_PREP() and FIELD_GET() macros
o further code cleanups
o always mask rxskew AND txskew value in the register value

Changes to v2:
o Fix missing whitespace in warning.

Changes to v1:
o code cleanup and use phy_modify().
o use default of 2.0ns if delay property is absent instead of returning
  an error.

---
 drivers/net/phy/intel-xway.c | 85 ++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index d453ec016168..5a626cd27ed4 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -8,11 +8,16 @@
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/of.h>
+#include <linux/bitfield.h>
=20
+#define XWAY_MDIO_MIICTRL		0x17	/* mii control */
 #define XWAY_MDIO_IMASK			0x19	/* interrupt mask */
 #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
 #define XWAY_MDIO_LED			0x1B	/* led control */
=20
+#define XWAY_MDIO_MIICTRL_RXSKEW_MASK	GENMASK(14, 12)
+#define XWAY_MDIO_MIICTRL_TXSKEW_MASK	GENMASK(10, 8)
+
 /* bit 15:12 are reserved */
 #define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function=
 of LED3 */
 #define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function=
 of LED2 */
@@ -157,6 +162,82 @@
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
+	unsigned int delay_size =3D ARRAY_SIZE(xway_internal_delay);
+	s32 int_delay;
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
+		txskew =3D FIELD_GET(XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
+		rxskew =3D FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, val);
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
+		int_delay =3D phy_get_internal_delay(phydev, dev,
+						      xway_internal_delay,
+						      delay_size, true);
+
+		if (int_delay < 0) {
+			phydev_warn(phydev, "rx-internal-delay-ps is missing, use default of =
2.0 ns\n");
+			int_delay =3D 4; /* 2000 ps */
+		}
+
+		val |=3D FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, int_delay);
+	}
+
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
+		int_delay =3D phy_get_internal_delay(phydev, dev,
+						      xway_internal_delay,
+						      delay_size, false);
+
+		if (int_delay < 0) {
+			phydev_warn(phydev, "tx-internal-delay-ps is missing, use default of =
2.0 ns\n");
+			int_delay =3D 4; /* 2000 ps */
+		}
+
+		val |=3D FIELD_PREP(XWAY_MDIO_MIICTRL_TXSKEW_MASK, int_delay);
+	}
+
+	return phy_modify(phydev, XWAY_MDIO_MIICTRL,
+			  XWAY_MDIO_MIICTRL_RXSKEW_MASK |
+			  XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
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
@@ -204,6 +285,10 @@ static int xway_gphy_config_init(struct phy_device *=
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

