Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A896C7B9A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjCXJhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjCXJhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:33 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB8625E0A;
        Fri, 24 Mar 2023 02:37:16 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ED121100012;
        Fri, 24 Mar 2023 09:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8SjFQJjZONjT3KnDkDgI1G1ROLQBpJXsDx1sy1hpgQ=;
        b=ieqNy0H0w3qiPW3wNDLZF99vm7rtrpTFfQ1YQ8sxr1B6E1+aq95+INUgTykZ357R4w331b
        Cjwcnia45HaH/vkUkunUTSp7GeIzuOCkQmibEEXf/lBHSPedxNf1cjJVdNx3XhIHZtWmpv
        MnQUtxjsLmP3ztMqYe2Ge5IbP52a6sANbQFCl8sAa3vr3Pp/+DT9NQDJJcWaPDRkiUI38S
        Y3NsIorlkbM87siVGSpkcCl4Mipu+C7VZ+3SRYKO1hwwUSSqjY6BMZnaaSWDcED3Se6raK
        eng5CyJWxQ+SdpFkqDRi60e8/Wty5+pO3GL2CiWJ2zfdCtqbF/hWPzO5A0tWnw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 5/7] net: mdio: Introduce a regmap-based mdio driver
Date:   Fri, 24 Mar 2023 10:36:42 +0100
Message-Id: <20230324093644.464704-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exists several examples today of devices that embed an ethernet
PHY or PCS directly inside an SoC. In this situation, either the device
is controlled through a vendor-specific register set, or sometimes
exposes the standard 802.3 registers that are typically accessed over
MDIO.

As phylib and phylink are designed to use mdiodevices, this driver
allows creating a virtual MDIO bus, that translates mdiodev register
accesses to regmap accesses.

The reason we use regmap is because there are at least 3 such devices
known today, 2 of them are Altera TSE PCS's, memory-mapped, exposed
with a 4-byte stride in stmmac's dwmac-socfpga variant, and a 2-byte
stride in altera-tse. The other one (nxp,sja1110-base-tx-mdio) is
exposed over SPI.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 MAINTAINERS                      |  7 +++
 drivers/net/mdio/Kconfig         | 11 +++++
 drivers/net/mdio/Makefile        |  1 +
 drivers/net/mdio/mdio-regmap.c   | 85 ++++++++++++++++++++++++++++++++
 include/linux/mdio/mdio-regmap.h | 25 ++++++++++
 5 files changed, 129 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-regmap.c
 create mode 100644 include/linux/mdio/mdio-regmap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d5bc223f305..10b3a1800e0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12751,6 +12751,13 @@ F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
 F:	drivers/net/ieee802154/mcr20a.c
 F:	drivers/net/ieee802154/mcr20a.h
 
+MDIO REGMAP DRIVER
+M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/mdio/mdio-regmap.c
+F:	include/linux/mdio/mdio-regmap.h
+
 MEASUREMENT COMPUTING CIO-DAC IIO DRIVER
 M:	William Breathitt Gray <william.gray@linaro.org>
 L:	linux-iio@vger.kernel.org
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 90309980686e..671e4bb82e3e 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -182,6 +182,17 @@ config MDIO_IPQ8064
 	  This driver supports the MDIO interface found in the network
 	  interface units of the IPQ8064 SoC
 
+config MDIO_REGMAP
+	tristate "Regmap-based virtual MDIO bus driver"
+	depends on REGMAP
+	help
+	  This driver allows using MDIO devices that are not sitting on a
+	  regular MDIO bus, but still exposes the standard 802.3 register
+	  layout. It's regmap-based so that it can be used on integrated,
+	  memory-mapped PHYs, SPI PHYs and so on. A new virtual MDIO bus is
+	  created, and its read/write operations are mapped to the underlying
+	  regmap.
+
 config MDIO_THUNDER
 	tristate "ThunderX SOCs MDIO buses"
 	depends on 64BIT
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 7d4cb4c11e4e..1015f0db4531 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
 obj-$(CONFIG_MDIO_MVUSB)		+= mdio-mvusb.o
 obj-$(CONFIG_MDIO_OCTEON)		+= mdio-octeon.o
+obj-$(CONFIG_MDIO_REGMAP)		+= mdio-regmap.o
 obj-$(CONFIG_MDIO_SUN4I)		+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
diff --git a/drivers/net/mdio/mdio-regmap.c b/drivers/net/mdio/mdio-regmap.c
new file mode 100644
index 000000000000..c85d62c2f55c
--- /dev/null
+++ b/drivers/net/mdio/mdio-regmap.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
+ * within the MMIO-mapped area
+ *
+ * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mdio/mdio-regmap.h>
+
+#define DRV_NAME "mdio-regmap"
+
+static int mdio_regmap_read_c22(struct mii_bus *bus, int addr, int regnum)
+{
+	struct mdio_regmap_config *ctx = bus->priv;
+	unsigned int val;
+	int ret;
+
+	if (!(ctx->valid_addr & BIT(addr)))
+		return -ENODEV;
+
+	ret = regmap_read(ctx->regmap, regnum, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int mdio_regmap_write_c22(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	struct mdio_regmap_config *ctx = bus->priv;
+
+	if (!(ctx->valid_addr & BIT(addr)))
+		return -ENODEV;
+
+	return regmap_write(ctx->regmap, regnum, val);
+}
+
+struct mii_bus *devm_mdio_regmap_register(struct device *dev,
+					  const struct mdio_regmap_config *config)
+{
+	struct mdio_regmap_config *mrc;
+	struct mii_bus *mii;
+	int rc;
+
+	if (!config->parent)
+		return ERR_PTR(-EINVAL);
+
+	if (!config->valid_addr)
+		return ERR_PTR(-EINVAL);
+
+	mii = devm_mdiobus_alloc_size(config->parent, sizeof(*mrc));
+	if (!mii)
+		return ERR_PTR(-ENOMEM);
+
+	mrc = mii->priv;
+	memcpy(mrc, config, sizeof(*mrc));
+
+	mrc->regmap = config->regmap;
+	mrc->parent = config->parent;
+	mrc->valid_addr = config->valid_addr;
+
+	mii->name = DRV_NAME;
+	strncpy(mii->id, config->name, MII_BUS_ID_SIZE);
+	mii->parent = config->parent;
+	mii->read = mdio_regmap_read_c22;
+	mii->write = mdio_regmap_write_c22;
+
+	rc = devm_mdiobus_register(dev, mii);
+	if (rc) {
+		dev_err(config->parent, "Cannot register MDIO bus![%s] (%d)\n", mii->id, rc);
+		return ERR_PTR(rc);
+	}
+
+	return mii;
+}
+
diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
new file mode 100644
index 000000000000..ea428e5a2913
--- /dev/null
+++ b/include/linux/mdio/mdio-regmap.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
+ * within the MMIO-mapped area
+ *
+ * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+#ifndef MDIO_REGMAP_H
+#define MDIO_REGMAP_H
+
+#define MDIO_REGMAP_NAME 63
+
+struct device;
+struct regmap;
+
+struct mdio_regmap_config {
+	struct device *parent;
+	struct regmap *regmap;
+	char name[MDIO_REGMAP_NAME];
+	u32 valid_addr;
+};
+
+struct mii_bus *devm_mdio_regmap_register(struct device *dev,
+					  const struct mdio_regmap_config *config);
+
+#endif
-- 
2.39.2

