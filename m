Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB733C048
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhCOPpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhCOPpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:45:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C80C06174A;
        Mon, 15 Mar 2021 08:45:33 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g20so8405554wmk.3;
        Mon, 15 Mar 2021 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7zidAh8iuTF0Kc8fsEe5bDCb1/wU5HukfUwj/mszyQY=;
        b=bZPynnspLZDb5z4QGVFC4oEZkSof1OEk5A4lmF/1dM+urAOTA4S50i73af6uhTQeoY
         IRvK8KjZU+YFMAxT0ChpSqKTkDNFsmisLb9CbISrDTtaHk6iFMOfxMGj0MBwseUuCVwq
         Ki3qSJsI/wWfvSqG/Lkaz3+aCHKuIZlBRagqIPb+tY1NAF+yrlG1XXslTCrpIMDuBP8B
         W5lgvFAzwj2S+QkQ2PpC9DVL1kO2GvVCkMc5cRBs48V6pem2Q5ErrOwwzirlvcjzQvMP
         chnh73lqedAlyj7g1t5dWI39GTA7r8StFyC8CXOj4I8owUYAm/YXdNgnn5H39TYW6R+2
         3xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7zidAh8iuTF0Kc8fsEe5bDCb1/wU5HukfUwj/mszyQY=;
        b=dB7wwCSMxtHgsWhVu9sojuIbYlW1m/UObt113t60WwcptMrOmQH4918nMlDKb+JluA
         RZOco4NCsRNkuFHtayUVWFklaF+/fAIic8BtVYvZh6MAuFcL54bp4R1LhqQtAJl9rjwo
         oEfU+uEi+1alx7eqvVNBq9pLdKFTDJLoq9oorZfQ60ysaw7BJqTDp7mZ6gt6DvwRp3NJ
         z0svNabmWhtBRf7fZZP0ZFOfHV5ad2FT077IkQZSOXpH1nqvMKNpY+C5HV1Y9IoOUoD6
         ZLaum6NO8134MFGNuCIe390k5SJ6pbhLu9TN5JhmFsemo2vZaY3ECOcy4booTymymWH2
         FgBw==
X-Gm-Message-State: AOAM530j/VfltiRhj/MEnGuKBzN+zgoAVfWLxNXEkH+zqGAMEBDJ/fqb
        Xg3l4mqIi/oVqBICSUe2+FQ=
X-Google-Smtp-Source: ABdhPJxXACo8qVVdJB+S7MmREzRC9GqjIRZLDrCW6uzjYfrkfsTENRP4MHcoGrnYPQIGZbHIuJSjYQ==
X-Received: by 2002:a05:600c:204f:: with SMTP id p15mr269886wmg.165.1615823132542;
        Mon, 15 Mar 2021 08:45:32 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id i10sm18043507wrs.11.2021.03.15.08.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:45:32 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
Date:   Mon, 15 Mar 2021 16:45:28 +0100
Message-Id: <20210315154528.30212-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315154528.30212-1-noltari@gmail.com>
References: <20210315154528.30212-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM63268
SoCs.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: add missing module author, description and license.

 drivers/net/mdio/Kconfig            |  11 ++
 drivers/net/mdio/Makefile           |   1 +
 drivers/net/mdio/mdio-mux-bcm6368.c | 183 ++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index a10cc460d7cf..d06e06f5e31a 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -200,6 +200,17 @@ config MDIO_BUS_MUX_MESON_G12A
 	  the amlogic g12a SoC. The multiplexers connects either the external
 	  or the internal MDIO bus to the parent bus.
 
+config MDIO_BUS_MUX_BCM6368
+	tristate "Broadcom BCM6368 MDIO bus multiplexers"
+	depends on OF && OF_MDIO && (BMIPS_GENERIC || COMPILE_TEST)
+	select MDIO_BUS_MUX
+	default BMIPS_GENERIC
+	help
+	  This module provides a driver for MDIO bus multiplexers found in
+	  BCM6368 based Broadcom SoCs. This multiplexer connects one of several
+	  child MDIO bus to a parent bus. Buses could be internal as well as
+	  external and selection logic lies inside the same multiplexer.
+
 config MDIO_BUS_MUX_BCM_IPROC
 	tristate "Broadcom iProc based MDIO bus multiplexers"
 	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 5c498dde463f..c3ec0ef989df 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
 
 obj-$(CONFIG_MDIO_BUS_MUX)		+= mdio-mux.o
+obj-$(CONFIG_MDIO_BUS_MUX_BCM6368)	+= mdio-mux-bcm6368.o
 obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
 obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+= mdio-mux-gpio.o
 obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
diff --git a/drivers/net/mdio/mdio-mux-bcm6368.c b/drivers/net/mdio/mdio-mux-bcm6368.c
new file mode 100644
index 000000000000..0abd83a9124f
--- /dev/null
+++ b/drivers/net/mdio/mdio-mux-bcm6368.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Broadcom BCM6368 mdiomux bus controller driver
+ *
+ * Copyright (C) 2021 Álvaro Fernández Rojas <noltari@gmail.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mdio-mux.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+
+#define MDIOC_REG		0x0
+#define MDIOC_EXT_MASK		BIT(16)
+#define MDIOC_REG_SHIFT		20
+#define MDIOC_PHYID_SHIFT	25
+#define MDIOC_RD_MASK		BIT(30)
+#define MDIOC_WR_MASK		BIT(31)
+
+#define MDIOD_REG		0x4
+
+struct bcm6368_mdiomux_desc {
+	void *mux_handle;
+	void __iomem *base;
+	struct device *dev;
+	struct mii_bus *mii_bus;
+	int ext_phy;
+};
+
+static int bcm6368_mdiomux_read(struct mii_bus *bus, int phy_id, int loc)
+{
+	struct bcm6368_mdiomux_desc *md = bus->priv;
+	uint32_t reg;
+	int ret;
+
+	__raw_writel(0, md->base + MDIOC_REG);
+
+	reg = MDIOC_RD_MASK |
+	      (phy_id << MDIOC_PHYID_SHIFT) |
+	      (loc << MDIOC_REG_SHIFT);
+	if (md->ext_phy)
+		reg |= MDIOC_EXT_MASK;
+
+	__raw_writel(reg, md->base + MDIOC_REG);
+	udelay(50);
+	ret = __raw_readw(md->base + MDIOD_REG);
+
+	return ret;
+}
+
+static int bcm6368_mdiomux_write(struct mii_bus *bus, int phy_id, int loc,
+				 uint16_t val)
+{
+	struct bcm6368_mdiomux_desc *md = bus->priv;
+	uint32_t reg;
+
+	__raw_writel(0, md->base + MDIOC_REG);
+
+	reg = MDIOC_WR_MASK |
+	      (phy_id << MDIOC_PHYID_SHIFT) |
+	      (loc << MDIOC_REG_SHIFT);
+	if (md->ext_phy)
+		reg |= MDIOC_EXT_MASK;
+	reg |= val;
+
+	__raw_writel(reg, md->base + MDIOC_REG);
+	udelay(50);
+
+	return 0;
+}
+
+static int bcm6368_mdiomux_switch_fn(int current_child, int desired_child,
+				     void *data)
+{
+	struct bcm6368_mdiomux_desc *md = data;
+
+	md->ext_phy = desired_child;
+
+	return 0;
+}
+
+static int bcm6368_mdiomux_probe(struct platform_device *pdev)
+{
+	struct bcm6368_mdiomux_desc *md;
+	struct mii_bus *bus;
+	struct resource *res;
+	int rc;
+
+	md = devm_kzalloc(&pdev->dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+	md->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	/*
+	 * Just ioremap, as this MDIO block is usually integrated into an
+	 * Ethernet MAC controller register range
+	 */
+	md->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!md->base) {
+		dev_err(&pdev->dev, "failed to ioremap register\n");
+		return -ENOMEM;
+	}
+
+	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!md->mii_bus) {
+		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
+		return ENOMEM;
+	}
+
+	bus = md->mii_bus;
+	bus->priv = md;
+	bus->name = "BCM6368 MDIO mux bus";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, pdev->id);
+	bus->parent = &pdev->dev;
+	bus->read = bcm6368_mdiomux_read;
+	bus->write = bcm6368_mdiomux_write;
+	bus->phy_mask = 0x3f;
+	bus->dev.of_node = pdev->dev.of_node;
+
+	rc = mdiobus_register(bus);
+	if (rc) {
+		dev_err(&pdev->dev, "mdiomux registration failed\n");
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, md);
+
+	rc = mdio_mux_init(md->dev, md->dev->of_node,
+			   bcm6368_mdiomux_switch_fn, &md->mux_handle, md,
+			   md->mii_bus);
+	if (rc) {
+		dev_info(md->dev, "mdiomux initialization failed\n");
+		goto out_register;
+	}
+
+	dev_info(&pdev->dev, "Broadcom BCM6368 MDIO mux bus\n");
+
+	return 0;
+
+out_register:
+	mdiobus_unregister(bus);
+	return rc;
+}
+
+static int bcm6368_mdiomux_remove(struct platform_device *pdev)
+{
+	struct bcm6368_mdiomux_desc *md = platform_get_drvdata(pdev);
+
+	mdio_mux_uninit(md->mux_handle);
+	mdiobus_unregister(md->mii_bus);
+
+	return 0;
+}
+
+static const struct of_device_id bcm6368_mdiomux_ids[] = {
+	{ .compatible = "brcm,bcm6368-mdio-mux", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, bcm6368_mdiomux_ids);
+
+static struct platform_driver bcm6368_mdiomux_driver = {
+	.driver = {
+		.name = "bcm6368-mdio-mux",
+		.of_match_table = bcm6368_mdiomux_ids,
+	},
+	.probe	= bcm6368_mdiomux_probe,
+	.remove	= bcm6368_mdiomux_remove,
+};
+module_platform_driver(bcm6368_mdiomux_driver);
+
+MODULE_AUTHOR("Álvaro Fernández Rojas <noltari@gmail.com>");
+MODULE_DESCRIPTION("BCM6368 mdiomux bus controller driver");
+MODULE_LICENSE("GPL v2");
-- 
2.20.1

