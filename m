Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9348F18A0E8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 17:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCRQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 12:53:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36967 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCRQxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 12:53:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id d1so2612356wmb.2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 09:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:organization;
        bh=Qa+65VmFjN9b4vovlnZPhOLSTDRz83rBu6bPOP+tScM=;
        b=dItcRit15+p1VtNeUNi37ALns91odm6gvlCt2kbAvJ5i1Ru+QRRvGt4d/1SZxwJsDu
         gs97UH0ZkaGrHMCGpukOjZ7DMeATpC+a9cIAQfV7lnLMdD4ePydXjFJtV20h6B7A2gSd
         +1uy/khUZ3OyEH+c5/5yjTeEo4oWZOp6v0tApdsU+++zE+6sUC0cVjgLzkoIgov1eK78
         LR8oYU4MbN0s2QT2ADvZT3Fq9Fb5KBziesCrlpx+/9P5x4Xuf0SHteR5EOr57z7x9uJM
         /14Xyau2nujs2kC24KkqHbm4DcCqXkODNNb+uUWNU9SR3CTaXfa+YBBOFCZLom/mXjOa
         65Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:organization;
        bh=Qa+65VmFjN9b4vovlnZPhOLSTDRz83rBu6bPOP+tScM=;
        b=NLgFH4cllatVV7aIWORwELmWx3YuuAJeRkkMzTYrqJdOJwX2JLkbaxxX80INOgXsDy
         LFB5jP5YGtExwne+rJynjRUlLpV8CANuEI2JnETiPfsx2OVxOq6kvNHTpTt8RlZ1jIIl
         bJ84KoIh9zwmCeclmd8errXXhB/Gzoa9nd27nx47tVEYOyhyFQJwvRwIrqi6tvKfhSf3
         qAFSAZRqaxjJ1c1i7YUwM0ubvbklKVBIdqg6KalO5A45/lVXFJuv2AvlRaFlt87V8ulc
         2hICGzyQ7splA562F29cZlp5Q0qGf4hgk99wxoOODgXvbHIkXsNPouOJjAQFGTynEClV
         VYcw==
X-Gm-Message-State: ANhLgQ2uSOpjfOy4tr7xbfEbki8NxPJzwow7K3UHwF5VWQiyYkMtJv9r
        tDyiRVEKN5U4dvPEwCnMtTpcDzo5YLo=
X-Google-Smtp-Source: ADFU+vvwRVvzJbtCPq1R3cUwP1x6IfwhKl4+wrCag8+pL0sGq/7Gh753fkf1nkzuBAIYYEtqtd+s1A==
X-Received: by 2002:a1c:b657:: with SMTP id g84mr6119912wmf.107.1584550383883;
        Wed, 18 Mar 2020 09:53:03 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x15sm6613731wrs.5.2020.03.18.09.53.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:53:03 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/2] net: phy: marvell smi2usb mdio controller
Date:   Wed, 18 Mar 2020 17:52:32 +0100
Message-Id: <20200318165232.29680-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318165232.29680-1-tobias@waldekranz.com>
References: <20200318165232.29680-1-tobias@waldekranz.com>
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
index 000000000000..6f022dca618c
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
+	struct smi2usb *smi;
+	struct mii_bus *mdio;
+	struct device *dev = &interface->dev;
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

