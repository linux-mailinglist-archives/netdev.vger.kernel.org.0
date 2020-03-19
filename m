Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534F518B87D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSOBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:01:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44360 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbgCSOBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:01:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so2608507wrh.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 07:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=3iApFu81xqbLUo0y33wRvT3DWHcTjCu0KrnzGMUis7c=;
        b=ajqMGeHSTSnzfgKs0t73dRq/NfcXm/OxWHqjKgv2TgUKjT0zCXsDqlyxKNkKtnCG/9
         ikbIXbi7GulPTY1PGMU8SxnYMYIzf0OPuNr4we0I2cWilHPkxFu9Tgk4+518Z3VUEEHt
         BymsK2eWquM9CUV7MV9iROpoVnJCwCBoR19q/Eaf3a5qB/z6btpIn7HjPcJKnt/89pOi
         E/y6s1XerGLSZ9/yYx8oO0uuu7VjJoGpoAX7TsA0ysN+mIh+RcEzyJe7MNFTTxUq9Dfn
         JO2nk0WY+cPJz2s3koa8Me8YCfecjUdrpCTUvPT/L3nVXoAOREYDWsmjoj8hJ+q9tvyD
         MrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=3iApFu81xqbLUo0y33wRvT3DWHcTjCu0KrnzGMUis7c=;
        b=pMfhBQXY+zb1A5jafa4sBcrOktkdQCwUig/dubLsW/ZRvjeGzf5y3aYVGrEQiCRnoj
         s16yJ1gpnQsSes6pncj506ug/xtfBm4A92Ry9+a89zGIQh7H5BjU+pzFlW0oZSxaE/Ag
         JhbNcidxqltAp90nSUfYxj0N6T3CRGQawGObaTNeWRObWzewexTWNA342ZsqcMY3Pxpf
         o7rfRu8faCby0Oc6QWUZv+jkLHxYh5gYQJWzUszMujlXn8/531rhSImT6AVS6UkBdmXS
         02IXwIJQC42eJ5eXxROEdT4nJFwfaqhxOBoy/cJLqTrbFpGmgJdFapPrmRejgbm3z6ZP
         F3/A==
X-Gm-Message-State: ANhLgQ0QRAE76rOvMDdWiaGg4/dyNkDx1sGGdwOA1H5g8EtpmPRKFxQp
        hg/72KR+Dkfzo+LD90T2Bq4hq5mlNbzDEw==
X-Google-Smtp-Source: ADFU+vtGGbjb9kRtiyGTEjVtspVfLeckjPqa1Webqfl5mehcPNrKZk5RxTZBpN/WgUKr+tXL9v+zyg==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr4577365wrn.106.1584626475669;
        Thu, 19 Mar 2020 07:01:15 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p10sm3747251wrx.81.2020.03.19.07.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:01:15 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
Date:   Thu, 19 Mar 2020 14:59:52 +0100
Message-Id: <20200319135952.16258-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319135952.16258-1-tobias@waldekranz.com>
References: <20200319135952.16258-1-tobias@waldekranz.com>
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO controller present on development boards for Marvell switches
from the Link Street (88E6xxx) family.

Using this module, you can use the following setup as a development
platform for switchdev and DSA related work.

   .-------.      .-----------------.
   |      USB----USB                |
   |  SoC  |      |  88E6390X-DB  ETH1-10
   |      ETH----ETH0               |
   '-------'      '-----------------'

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

v1->v2:
- Reverse christmas tree ordering of local variables.

---
 MAINTAINERS                    |   1 +
 drivers/net/phy/Kconfig        |   7 ++
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-smi2usb.c | 137 +++++++++++++++++++++++++++++++++
 4 files changed, 146 insertions(+)
 create mode 100644 drivers/net/phy/mdio-smi2usb.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 83bb7ce3e23e..a7771e577832 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10100,6 +10100,7 @@ MARVELL SMI2USB MDIO CONTROLLER DRIVER
 M:	Tobias Waldekranz <tobias@waldekranz.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/phy/mdio-smi2usb.c
 F:	Documentation/devicetree/bindings/net/marvell,smi2usb.yaml
 
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index cc7f1df855da..ddde79c6f354 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -189,6 +189,13 @@ config MDIO_OCTEON
 	  buses. It is required by the Octeon and ThunderX ethernet device
 	  drivers on some systems.
 
+config MDIO_SMI2USB
+	tristate "Marvell SMI2USB"
+	depends on OF_MDIO && USB
+	help
+	  A USB to MDIO converter present on development boards for
+	  Marvell's Link Street family of Ethernet switches.
+
 config MDIO_SUN4I
 	tristate "Allwinner sun4i MDIO interface support"
 	depends on ARCH_SUNXI || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 70774ab474e6..fcbe4bd26747 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
 obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
+obj-$(CONFIG_MDIO_SMI2USB)	+= mdio-smi2usb.o
 obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
diff --git a/drivers/net/phy/mdio-smi2usb.c b/drivers/net/phy/mdio-smi2usb.c
new file mode 100644
index 000000000000..c4f7f555a091
--- /dev/null
+++ b/drivers/net/phy/mdio-smi2usb.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/usb.h>
+
+#define USB_MARVELL_VID	0x1286
+
+static const struct usb_device_id smi2usb_table[] = {
+	{ USB_DEVICE(USB_MARVELL_VID, 0x1fa4) },
+
+	{}
+};
+MODULE_DEVICE_TABLE(usb, smi2usb_table);
+
+enum {
+	SMI_CMD_PREAMBLE0,
+	SMI_CMD_PREAMBLE1,
+	SMI_CMD_ADDR,
+	SMI_CMD_VAL,
+};
+
+struct smi2usb {
+	struct usb_device *udev;
+	struct usb_interface *intf;
+
+	struct mii_bus *mdio;
+
+	__le16 buf[4];
+};
+
+static int smi2usb_mdio_read(struct mii_bus *mdio, int dev, int reg)
+{
+	struct smi2usb *smi = mdio->priv;
+	int err, alen;
+
+	if (dev & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	smi->buf[SMI_CMD_ADDR] = cpu_to_le16(0xa400 | (dev << 5) | reg);
+
+	err = usb_bulk_msg(smi->udev, usb_sndbulkpipe(smi->udev, 2),
+			   smi->buf, 6, &alen, 100);
+	if (err)
+		return err;
+
+	err = usb_bulk_msg(smi->udev, usb_rcvbulkpipe(smi->udev, 6),
+			   &smi->buf[SMI_CMD_VAL], 2, &alen, 100);
+	if (err)
+		return err;
+
+	return le16_to_cpu(smi->buf[SMI_CMD_VAL]);
+}
+
+static int smi2usb_mdio_write(struct mii_bus *mdio, int dev, int reg, u16 val)
+{
+	struct smi2usb *smi = mdio->priv;
+	int alen;
+
+	if (dev & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	smi->buf[SMI_CMD_ADDR] = cpu_to_le16(0x8000 | (dev << 5) | reg);
+	smi->buf[SMI_CMD_VAL]  = cpu_to_le16(val);
+
+	return usb_bulk_msg(smi->udev, usb_sndbulkpipe(smi->udev, 2),
+			    smi->buf, 8, &alen, 100);
+}
+
+static int smi2usb_probe(struct usb_interface *interface,
+			 const struct usb_device_id *id)
+{
+	struct device *dev = &interface->dev;
+	struct mii_bus *mdio;
+	struct smi2usb *smi;
+	int err = -ENOMEM;
+
+	mdio = devm_mdiobus_alloc_size(dev, sizeof(*smi));
+	if (!mdio)
+		goto err;
+
+	smi = mdio->priv;
+	smi->mdio = mdio;
+	smi->udev = usb_get_dev(interface_to_usbdev(interface));
+	smi->intf = usb_get_intf(interface);
+
+	/* Reversed from USB PCAPs, no idea what these mean. */
+	smi->buf[SMI_CMD_PREAMBLE0] = cpu_to_le16(0xe800);
+	smi->buf[SMI_CMD_PREAMBLE1] = cpu_to_le16(0x0001);
+
+	usb_set_intfdata(interface, smi);
+
+	snprintf(mdio->id, MII_BUS_ID_SIZE, "smi2usb-%s", dev_name(dev));
+	mdio->name = mdio->id;
+	mdio->parent = dev;
+	mdio->read = smi2usb_mdio_read;
+	mdio->write = smi2usb_mdio_write;
+
+	err = of_mdiobus_register(mdio, dev->of_node);
+	if (err)
+		goto err_put;
+
+	return 0;
+
+err_put:
+	usb_put_intf(interface);
+	usb_put_dev(interface_to_usbdev(interface));
+err:
+	return err;
+}
+
+static void smi2usb_disconnect(struct usb_interface *interface)
+{
+	struct smi2usb *smi;
+
+	smi = usb_get_intfdata(interface);
+	mdiobus_unregister(smi->mdio);
+	usb_set_intfdata(interface, NULL);
+
+	usb_put_intf(interface);
+	usb_put_dev(interface_to_usbdev(interface));
+}
+
+static struct usb_driver smi2usb_driver = {
+	.name       = "smi2usb",
+	.id_table   = smi2usb_table,
+	.probe      = smi2usb_probe,
+	.disconnect = smi2usb_disconnect,
+};
+
+module_usb_driver(smi2usb_driver);
+
+MODULE_AUTHOR("Tobias Waldekranz <tobias@waldekranz.com>");
+MODULE_DESCRIPTION("Marvell SMI2USB Adapter");
+MODULE_LICENSE("GPL");
-- 
2.17.1

