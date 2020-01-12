Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2353F138622
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgALMFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:09 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41497 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732796AbgALMFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:08 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so4827659lfp.8
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAnsc8RCCRH0gsrO6JIcw3MEFq+31z6wm/rGDE/KuRQ=;
        b=aTObKf9jOY5DSPZaFHPlwfNPcLJ3/GZ8UnRc5ySOKdbW9sZuWMGox03axDrio9bxjj
         +sOZ6qoazNRcJYbr5/ZgMWGRUOUVMNMHjOx8iLbZZgOkoRDofvsXmnR8At53NL22fK9q
         nx8qzX9pmb+9oIlTOZ3I9SwrUHv5vGNGeboVTZe4/L3TO0dZVdlrGS9RRWSSN4ADBLHP
         krFCz3hKkesmF7Uu/TDABWdR1Zgfz1oCDB4ubk1oWAnHbl5yp9MAJ4CDiQOIONswr7DB
         wO5O2GoPcQUsY1uCtwpuPUANbgSh/7HvdSXUd77LeAOfbDW23QCt3DysFharPM9st8tp
         T3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAnsc8RCCRH0gsrO6JIcw3MEFq+31z6wm/rGDE/KuRQ=;
        b=c3WnbOL3opoILFKFUSup8oqRpPKeMuzJ+GIMvSwLeaJb7504TmkTfR6U+9aR7Dmwmo
         YEWhowdsKDdN6RZs8ozeNuCZCahyZrD26GqQLYmlA5OT93ItN0sahWmu0LE78mzjvm/o
         wduNEqwPkEHCnW/mvQYtA6/HHi20pJG7xXuManAQKehmX9FG1psi8Fsu+2nJeSARjaB1
         ZIwagvkmHt5figpAx6S6IzsxaGZk9DXPEC8hR5zt9l/m2UbncwXy1eyK3+V8nbjvdlNp
         5/TrWLS9TNblMV46NOPKGJiNlYIHpMGk64C3/f2HIakFr82544CBm6dCJH3ALq2N5C8M
         5WdA==
X-Gm-Message-State: APjAAAWBSNJrh5nWWb+P5K+XUzcdQj9UvUsuCPj9tynM/OnY1gLqJECs
        ep2yCogjEkI8Sq+h6/gpz+okZY3JXfb1pA==
X-Google-Smtp-Source: APXvYqw1ZHMG8t1977Az4nvCezE/lvq05WvJq3Bg/69ZCs/IrcuUN560HTFreBkAwO825oVGInpmEg==
X-Received: by 2002:a19:48c5:: with SMTP id v188mr7535743lfa.100.1578830705591;
        Sun, 12 Jan 2020 04:05:05 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:05 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 5/9 v5] net: ethernet: ixp4xx: Standard module init
Date:   Sun, 12 Jan 2020 13:04:46 +0100
Message-Id: <20200112120450.11874-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IXP4xx driver was initializing the MDIO bus before even
probing, in the callbacks supposed to be used for setting up
the module itself, and with the side effect of trying to
register the MDIO bus as soon as this module was loaded or
compiled into the kernel whether the device was discovered
or not.

This does not work with multiplatform environments.

To get rid of this: set up the MDIO bus from the probe()
callback and remove it in the remove() callback. Rename
the probe() and remove() calls to reflect the most common
conventions.

Since there is a bit of checking for the ethernet feature
to be present in the MDIO registering function, making the
whole module not even be registered if we can't find an
MDIO bus, we need something similar: register the MDIO
bus when the corresponding ethernet is probed, and
return -EPROBE_DEFER on the other interfaces until this
happens. If no MDIO bus is present on any of the
registered interfaces we will eventually bail out.

None of the platforms I've seen has e.g. MDIO on EthB
and only uses EthC, there is always a Ethernet hardware
on the NPE (B, C) that has the MDIO bus, we just might
have to wait for it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Change the first alloc_etherdev() to devm_alloc_etherdev()
  and drop one leg of the errorpath so we can just return
  with error code in the first part of the code.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 96 +++++++++++-------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index e811bf0d23cb..799ffebba491 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -519,25 +519,14 @@ static int ixp4xx_mdio_write(struct mii_bus *bus, int phy_id, int location,
 	return ret;
 }
 
-static int ixp4xx_mdio_register(void)
+static int ixp4xx_mdio_register(struct eth_regs __iomem *regs)
 {
 	int err;
 
 	if (!(mdio_bus = mdiobus_alloc()))
 		return -ENOMEM;
 
-	if (cpu_is_ixp43x()) {
-		/* IXP43x lacks NPE-B and uses NPE-C for MII PHY access */
-		if (!(ixp4xx_read_feature_bits() & IXP4XX_FEATURE_NPEC_ETH))
-			return -ENODEV;
-		mdio_regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
-	} else {
-		/* All MII PHY accesses use NPE-B Ethernet registers */
-		if (!(ixp4xx_read_feature_bits() & IXP4XX_FEATURE_NPEB_ETH0))
-			return -ENODEV;
-		mdio_regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
-	}
-
+	mdio_regs = regs;
 	__raw_writel(DEFAULT_CORE_CNTRL, &mdio_regs->core_control);
 	spin_lock_init(&mdio_lock);
 	mdio_bus->name = "IXP4xx MII Bus";
@@ -1376,7 +1365,7 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
-static int eth_init_one(struct platform_device *pdev)
+static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
 	struct port *port;
 	struct net_device *dev;
@@ -1386,7 +1375,7 @@ static int eth_init_one(struct platform_device *pdev)
 	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
-	if (!(dev = alloc_etherdev(sizeof(struct port))))
+	if (!(dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct port))))
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -1396,20 +1385,51 @@ static int eth_init_one(struct platform_device *pdev)
 
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:
+		/* If the MDIO bus is not up yet, defer probe */
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthA_BASE_VIRT;
 		regs_phys  = IXP4XX_EthA_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEB:
+		/*
+		 * On all except IXP43x, NPE-B is used for the MDIO bus.
+		 * If there is no NPE-B in the feature set, bail out, else
+		 * register the MDIO bus.
+		 */
+		if (!cpu_is_ixp43x()) {
+			if (!(ixp4xx_read_feature_bits() &
+			      IXP4XX_FEATURE_NPEB_ETH0))
+				return -ENODEV;
+			/* Else register the MDIO bus on NPE-B */
+			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+				return err;
+		}
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
 		regs_phys  = IXP4XX_EthB_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEC:
+		/*
+		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
+		 * of there is no NPE-C, no bus, nothing works, so bail out.
+		 */
+		if (cpu_is_ixp43x()) {
+			if (!(ixp4xx_read_feature_bits() &
+			      IXP4XX_FEATURE_NPEC_ETH))
+				return -ENODEV;
+			/* Else register the MDIO bus on NPE-C */
+			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+				return err;
+		}
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
 		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
-		err = -ENODEV;
-		goto err_free;
+		return -ENODEV;
 	}
 
 	dev->netdev_ops = &ixp4xx_netdev_ops;
@@ -1418,10 +1438,8 @@ static int eth_init_one(struct platform_device *pdev)
 
 	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
-		err = -EIO;
-		goto err_free;
-	}
+	if (!(port->npe = npe_request(NPE_ID(port->id))))
+		return -EIO;
 
 	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
 	if (!port->mem_res) {
@@ -1467,12 +1485,10 @@ static int eth_init_one(struct platform_device *pdev)
 	release_resource(port->mem_res);
 err_npe_rel:
 	npe_release(port->npe);
-err_free:
-	free_netdev(dev);
 	return err;
 }
 
-static int eth_remove_one(struct platform_device *pdev)
+static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct phy_device *phydev = dev->phydev;
@@ -1480,45 +1496,21 @@ static int eth_remove_one(struct platform_device *pdev)
 
 	unregister_netdev(dev);
 	phy_disconnect(phydev);
+	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(dev);
 	return 0;
 }
 
 static struct platform_driver ixp4xx_eth_driver = {
 	.driver.name	= DRV_NAME,
-	.probe		= eth_init_one,
-	.remove		= eth_remove_one,
+	.probe		= ixp4xx_eth_probe,
+	.remove		= ixp4xx_eth_remove,
 };
-
-static int __init eth_init_module(void)
-{
-	int err;
-
-	/*
-	 * FIXME: we bail out on device tree boot but this really needs
-	 * to be fixed in a nicer way: this registers the MDIO bus before
-	 * even matching the driver infrastructure, we should only probe
-	 * detected hardware.
-	 */
-	if (of_have_populated_dt())
-		return -ENODEV;
-	if ((err = ixp4xx_mdio_register()))
-		return err;
-	return platform_driver_register(&ixp4xx_eth_driver);
-}
-
-static void __exit eth_cleanup_module(void)
-{
-	platform_driver_unregister(&ixp4xx_eth_driver);
-	ixp4xx_mdio_remove();
-}
+module_platform_driver(ixp4xx_eth_driver);
 
 MODULE_AUTHOR("Krzysztof Halasa");
 MODULE_DESCRIPTION("Intel IXP4xx Ethernet driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:ixp4xx_eth");
-module_init(eth_init_module);
-module_exit(eth_cleanup_module);
-- 
2.21.0

