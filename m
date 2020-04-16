Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0169D1AD020
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgDPTG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:06:27 -0400
Received: from mailoutvs18.siol.net ([185.57.226.209]:37044 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730621AbgDPTGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:06:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id DD8D0524696;
        Thu, 16 Apr 2020 20:58:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Y-h1UHWlQNt9; Thu, 16 Apr 2020 20:58:13 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 30C905246A3;
        Thu, 16 Apr 2020 20:58:13 +0200 (CEST)
Received: from localhost.localdomain (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id B19535246A4;
        Thu, 16 Apr 2020 20:58:10 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
Date:   Thu, 16 Apr 2020 20:57:56 +0200
Message-Id: <20200416185758.1388148-3-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200416185758.1388148-1-jernej.skrabec@siol.net>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 drivers/net/phy/Kconfig  |   7 ++
 drivers/net/phy/Makefile |   1 +
 drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+)
 create mode 100644 drivers/net/phy/ac200.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eeba..16af69f69eaf 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -288,6 +288,13 @@ config ADIN_PHY
 	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
 	    Ethernet PHY
=20
+config AC200_PHY
+	tristate "AC200 EPHY"
+	depends on NVMEM
+	depends on OF
+	help
+	  Fast ethernet PHY as found in X-Powers AC200 multi-function device.
+
 config AMD_PHY
 	tristate "AMD PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 2f5c7093a65b..b0c5b91900fa 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+=3D sfp.o
 sfp-obj-$(CONFIG_SFP)		+=3D sfp-bus.o
 obj-y				+=3D $(sfp-obj-y) $(sfp-obj-m)
=20
+obj-$(CONFIG_AC200_PHY)		+=3D ac200.o
 obj-$(CONFIG_ADIN_PHY)		+=3D adin.o
 obj-$(CONFIG_AMD_PHY)		+=3D amd.o
 aquantia-objs			+=3D aquantia_main.o
diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
new file mode 100644
index 000000000000..3d7856ff8f91
--- /dev/null
+++ b/drivers/net/phy/ac200.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0+
+/**
+ * Driver for AC200 Ethernet PHY
+ *
+ * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/ac200.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+
+#define AC200_EPHY_ID			0x00441400
+#define AC200_EPHY_ID_MASK		0x0ffffff0
+
+/* macros for system ephy control 0 register */
+#define AC200_EPHY_RESET_INVALID	BIT(0)
+#define AC200_EPHY_SYSCLK_GATING	BIT(1)
+
+/* macros for system ephy control 1 register */
+#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
+#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
+#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
+#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
+
+/* macros for ephy control register */
+#define AC200_EPHY_SHUTDOWN		BIT(0)
+#define AC200_EPHY_LED_POL		BIT(1)
+#define AC200_EPHY_CLK_SEL		BIT(2)
+#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
+#define AC200_EPHY_XMII_SEL		BIT(11)
+#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
+
+struct ac200_ephy_dev {
+	struct phy_driver	*ephy;
+	struct regmap		*regmap;
+};
+
+static char *ac200_phy_name =3D "AC200 EPHY";
+
+static int ac200_ephy_config_init(struct phy_device *phydev)
+{
+	const struct ac200_ephy_dev *priv =3D phydev->drv->driver_data;
+	unsigned int value;
+	int ret;
+
+	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */
+	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
+
+	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
+	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
+
+	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
+	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
+	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
+	phy_write(phydev, 0x15, 0x1530);
+
+	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */
+	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
+
+	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
+	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent IEEE */
+
+	/* next two blocks disable 802.3az IEEE */
+	phy_write(phydev, 0x1f, 0x0200);	/* switch to page 2 */
+	phy_write(phydev, 0x18, 0x0000);
+
+	phy_write(phydev, 0x1f, 0x0000);	/* switch to page 0 */
+	phy_clear_bits_mmd(phydev, 0x7, 0x3c, BIT(1));
+
+	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RMII)
+		value =3D AC200_EPHY_XMII_SEL;
+	else
+		value =3D 0;
+
+	ret =3D regmap_update_bits(priv->regmap, AC200_EPHY_CTL,
+				 AC200_EPHY_XMII_SEL, value);
+	if (ret)
+		return ret;
+
+	/* FIXME: This is H6 specific */
+	phy_set_bits(phydev, 0x13, BIT(12));
+
+	return 0;
+}
+
+static int ac200_ephy_probe(struct platform_device *pdev)
+{
+	struct ac200_dev *ac200 =3D dev_get_drvdata(pdev->dev.parent);
+	struct device *dev =3D &pdev->dev;
+	struct ac200_ephy_dev *priv;
+	struct nvmem_cell *calcell;
+	struct phy_driver *ephy;
+	u16 *caldata, calib;
+	size_t callen;
+	int ret;
+
+	priv =3D devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ephy =3D devm_kzalloc(dev, sizeof(*ephy), GFP_KERNEL);
+	if (!ephy)
+		return -ENOMEM;
+
+	calcell =3D devm_nvmem_cell_get(dev, "calibration");
+	if (IS_ERR(calcell)) {
+		dev_err(dev, "Unable to find calibration data!\n");
+		return PTR_ERR(calcell);
+	}
+
+	caldata =3D nvmem_cell_read(calcell, &callen);
+	if (IS_ERR(caldata)) {
+		dev_err(dev, "Unable to read calibration data!\n");
+		return PTR_ERR(caldata);
+	}
+
+	if (callen !=3D 2) {
+		dev_err(dev, "Calibration data has wrong length: 2 !=3D %zu\n",
+			callen);
+		kfree(caldata);
+		return -EINVAL;
+	}
+
+	calib =3D *caldata + 3;
+	kfree(caldata);
+
+	ephy->phy_id =3D AC200_EPHY_ID;
+	ephy->phy_id_mask =3D AC200_EPHY_ID_MASK;
+	ephy->name =3D ac200_phy_name;
+	ephy->driver_data =3D priv;
+	ephy->soft_reset =3D genphy_soft_reset;
+	ephy->config_init =3D ac200_ephy_config_init;
+	ephy->suspend =3D genphy_suspend;
+	ephy->resume =3D genphy_resume;
+
+	priv->ephy =3D ephy;
+	priv->regmap =3D ac200->regmap;
+	platform_set_drvdata(pdev, priv);
+
+	ret =3D regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL0,
+			   AC200_EPHY_RESET_INVALID |
+			   AC200_EPHY_SYSCLK_GATING);
+	if (ret)
+		return ret;
+
+	ret =3D regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL1,
+			   AC200_EPHY_E_EPHY_MII_IO_EN |
+			   AC200_EPHY_E_LNK_LED_IO_EN |
+			   AC200_EPHY_E_SPD_LED_IO_EN |
+			   AC200_EPHY_E_DPX_LED_IO_EN);
+	if (ret)
+		return ret;
+
+	ret =3D regmap_write(ac200->regmap, AC200_EPHY_CTL,
+			   AC200_EPHY_LED_POL |
+			   AC200_EPHY_CLK_SEL |
+			   AC200_EPHY_ADDR(1) |
+			   AC200_EPHY_CALIB(calib));
+	if (ret)
+		return ret;
+
+	ret =3D phy_driver_register(priv->ephy, THIS_MODULE);
+	if (ret) {
+		dev_err(dev, "Unable to register phy\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ac200_ephy_remove(struct platform_device *pdev)
+{
+	struct ac200_ephy_dev *priv =3D platform_get_drvdata(pdev);
+
+	phy_driver_unregister(priv->ephy);
+
+	regmap_write(priv->regmap, AC200_EPHY_CTL, AC200_EPHY_SHUTDOWN);
+	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL1, 0);
+	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL0, 0);
+
+	return 0;
+}
+
+static const struct of_device_id ac200_ephy_match[] =3D {
+	{ .compatible =3D "x-powers,ac200-ephy" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ac200_ephy_match);
+
+static struct platform_driver ac200_ephy_driver =3D {
+	.probe		=3D ac200_ephy_probe,
+	.remove		=3D ac200_ephy_remove,
+	.driver		=3D {
+		.name		=3D "ac200-ephy",
+		.of_match_table	=3D ac200_ephy_match,
+	},
+};
+module_platform_driver(ac200_ephy_driver);
+
+MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
+MODULE_DESCRIPTION("AC200 Ethernet PHY driver");
+MODULE_LICENSE("GPL");
--=20
2.26.0

