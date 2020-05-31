Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08831E978D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgEaM1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbgEaM1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:21 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF7FC03E96A
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:21 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y13so6589364eju.2
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahjmFopMf+HWGYftYGhnMhS3kLV273IBmWQaZwQd3Mc=;
        b=Wr4mLGXt+2XpFVYhtzrFJwG+rbpMe7PFBStNHT/0H82ytgc2R6BPF3yUBVWaSIzyy6
         ATS2a7R+rojo3TIHnWrZRSE11y8XknxZrzJWgdPUr84Cq84plOXo09xuGZIkvSpzNwlv
         0e0LhAw6UO8lyAtM401PNy2TgUa0W4ShD/guLUH01eU4ZsB39vK0KhmTYP91EgQUlM4c
         yQjWqrANKC3VcA6EdO/80Qs1ePhTlxCYmCiiHQjTxFdvwjWUTBIJbll/vHSZAiJKv4eM
         wBV2UPhZJZx8xHQhikZuKWBsEyUTWgNQ3p6VLZz9bmDI1fzEG5Co1TKWKB82Jd5LMcGP
         Q47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahjmFopMf+HWGYftYGhnMhS3kLV273IBmWQaZwQd3Mc=;
        b=JQlxoy4kQ0tu/gTvMkea+2knDoxE3ia8ygvrjxYYs79h+dH/Qs3+AVcW+bLh/JvP/o
         9Q38srC9R/J2Wb5Bs4/kSXGijA99WNnI8Y9xYS5x1ySr6ez/FlrAOw91NHdRVsV/NMJD
         nKR3C6MWSGfV1CVE5L0+qasPg2cGueyz6UhsBTTYgJzA/1vIkys3FxC6xoePT3xbi2nv
         7NHk6aC/HzvBbAYnB/D6NAweQ69o5SxFrulxD7JdU6X4POaw8+7eqL6av6iv96YN+SN8
         7eOyn4jda9jCusCScpXNxj8Yo+pMzMFsUNPpUVe/PaiYbJsT1TIbJeSTr9Wzc1aL3+Z6
         dsEA==
X-Gm-Message-State: AOAM531xCyyWag+xakGEMzLVJ9snVrKKrspPYLtpEEGCqu+TAOUbSn+i
        l4hdkJsA0oaUPz+EO9DY/64=
X-Google-Smtp-Source: ABdhPJzPK0pHaMBmj+78m8n+VW3/axd+mU3fOLhSIgQ7wc7zz+gez4EJjP9+pCShMUNvKU+d1DDJ8g==
X-Received: by 2002:a17:906:a2c5:: with SMTP id by5mr11628747ejb.492.1590928039634;
        Sun, 31 May 2020 05:27:19 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 12/13] net: dsa: felix: move probing to felix_vsc9959.c
Date:   Sun, 31 May 2020 15:26:39 +0300
Message-Id: <20200531122640.1375715-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Felix is not actually meant to be a DSA driver only for the switch
inside NXP LS1028A, but an umbrella for all Vitesse / Microsemi /
Microchip switches that are register-compatible with Ocelot and that are
using in DSA mode (with an NPI Ethernet port).

For the dsa_switch_ops exported by the felix driver to be generic enough
to be used by other non-PCI switches, we need to move the PCI-specific
probing to the low-level translation module felix_vsc9959.c. This way,
other switches can have their own probing functions, as platform devices
or otherwise.

This patch also removes the "Felix instance table", which did not stand
the test of time and is unnecessary at this point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Added comment at the beginning of felix.c.
Added a centralized __init felix_init and __exit felix_exit that deals
with registering the drivers for each individual switch. This is done in
order to avoid build errors when compiled as module.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c         | 195 +++----------------------
 drivers/net/dsa/ocelot/felix.h         |  15 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 187 +++++++++++++++++++++++-
 3 files changed, 206 insertions(+), 191 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 88b64faa8b25..e30a6d29a7d5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 NXP Semiconductors
+ *
+ * This is an umbrella module for all network switches that are
+ * register-compatible with Ocelot and that perform I/O to their host CPU
+ * through an NPI (Node Processor Interface) Ethernet port.
  */
 #include <uapi/linux/if_bridge.h>
 #include <soc/mscc/ocelot_vcap.h>
@@ -158,37 +162,10 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 				   struct phylink_link_state *state)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
+	struct felix *felix = ocelot_to_felix(ocelot);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	if (felix->info->phylink_validate)
+		felix->info->phylink_validate(ocelot, port, supported, state);
 }
 
 static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
@@ -438,7 +415,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
-	resource_size_t switch_base;
 	struct resource res;
 	int port, i, err;
 
@@ -469,9 +445,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		return err;
 	}
 
-	switch_base = pci_resource_start(felix->pdev,
-					 felix->info->switch_pci_bar);
-
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
 
@@ -480,8 +453,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
 		res.flags = IORESOURCE_MEM;
-		res.start += switch_base;
-		res.end += switch_base;
+		res.start += felix->switch_base;
+		res.end += felix->switch_base;
 
 		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
@@ -518,8 +491,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
 		res.flags = IORESOURCE_MEM;
-		res.start += switch_base;
-		res.end += switch_base;
+		res.start += felix->switch_base;
+		res.end += felix->switch_base;
 
 		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
@@ -786,7 +759,7 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 }
 
-static const struct dsa_switch_ops felix_switch_ops = {
+const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
 	.teardown		= felix_teardown,
@@ -827,149 +800,17 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_setup_tc          = felix_port_setup_tc,
 };
 
-static struct felix_info *felix_instance_tbl[] = {
-	[FELIX_INSTANCE_VSC9959] = &felix_info_vsc9959,
-};
-
-static irqreturn_t felix_irq_handler(int irq, void *data)
-{
-	struct ocelot *ocelot = (struct ocelot *)data;
-
-	/* The INTB interrupt is used for both PTP TX timestamp interrupt
-	 * and preemption status change interrupt on each port.
-	 *
-	 * - Get txtstamp if have
-	 * - TODO: handle preemption. Without handling it, driver may get
-	 *   interrupt storm.
-	 */
-
-	ocelot_get_txtstamp(ocelot);
-
-	return IRQ_HANDLED;
-}
-
-static int felix_pci_probe(struct pci_dev *pdev,
-			   const struct pci_device_id *id)
+static int __init felix_init(void)
 {
-	enum felix_instance instance = id->driver_data;
-	struct dsa_switch *ds;
-	struct ocelot *ocelot;
-	struct felix *felix;
-	int err;
-
-	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
-		dev_info(&pdev->dev, "device is disabled, skipping\n");
-		return -ENODEV;
-	}
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "device enable failed\n");
-		goto err_pci_enable;
-	}
-
-	/* set up for high or low dma */
-	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
-	}
-
-	felix = kzalloc(sizeof(struct felix), GFP_KERNEL);
-	if (!felix) {
-		err = -ENOMEM;
-		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
-		goto err_alloc_felix;
-	}
-
-	pci_set_drvdata(pdev, felix);
-	ocelot = &felix->ocelot;
-	ocelot->dev = &pdev->dev;
-	felix->pdev = pdev;
-	felix->info = felix_instance_tbl[instance];
-
-	pci_set_master(pdev);
-
-	err = devm_request_threaded_irq(&pdev->dev, pdev->irq, NULL,
-					&felix_irq_handler, IRQF_ONESHOT,
-					"felix-intb", ocelot);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to request irq\n");
-		goto err_alloc_irq;
-	}
-
-	ocelot->ptp = 1;
-
-	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
-	if (!ds) {
-		err = -ENOMEM;
-		dev_err(&pdev->dev, "Failed to allocate DSA switch\n");
-		goto err_alloc_ds;
-	}
-
-	ds->dev = &pdev->dev;
-	ds->num_ports = felix->info->num_ports;
-	ds->num_tx_queues = felix->info->num_tx_queues;
-	ds->ops = &felix_switch_ops;
-	ds->priv = ocelot;
-	felix->ds = ds;
-
-	err = dsa_register_switch(ds);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
-		goto err_register_ds;
-	}
-
-	return 0;
-
-err_register_ds:
-	kfree(ds);
-err_alloc_ds:
-err_alloc_irq:
-err_alloc_felix:
-	kfree(felix);
-err_dma:
-	pci_disable_device(pdev);
-err_pci_enable:
-	return err;
+	return pci_register_driver(&felix_vsc9959_pci_driver);
 }
+module_init(felix_init);
 
-static void felix_pci_remove(struct pci_dev *pdev)
+static void __exit felix_exit(void)
 {
-	struct felix *felix;
-
-	felix = pci_get_drvdata(pdev);
-
-	dsa_unregister_switch(felix->ds);
-
-	kfree(felix->ds);
-	kfree(felix);
-
-	pci_disable_device(pdev);
+	pci_unregister_driver(&felix_vsc9959_pci_driver);
 }
-
-static struct pci_device_id felix_ids[] = {
-	{
-		/* NXP LS1028A */
-		PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, 0xEEF0),
-		.driver_data = FELIX_INSTANCE_VSC9959,
-	},
-	{ 0, }
-};
-MODULE_DEVICE_TABLE(pci, felix_ids);
-
-static struct pci_driver felix_pci_driver = {
-	.name		= KBUILD_MODNAME,
-	.id_table	= felix_ids,
-	.probe		= felix_pci_probe,
-	.remove		= felix_pci_remove,
-};
-
-module_pci_driver(felix_pci_driver);
+module_exit(felix_exit);
 
 MODULE_DESCRIPTION("Felix Switch driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 2f28c28fdef0..f51a29061ae3 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -34,6 +34,9 @@ struct felix_info {
 	void	(*pcs_an_restart)(struct ocelot *ocelot, int port);
 	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
 				  struct phylink_link_state *state);
+	void	(*phylink_validate)(struct ocelot *ocelot, int port,
+				    unsigned long *supported,
+				    struct phylink_link_state *state);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
@@ -43,20 +46,18 @@ struct felix_info {
 	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
 };
 
-extern struct felix_info		felix_info_vsc9959;
-
-enum felix_instance {
-	FELIX_INSTANCE_VSC9959		= 0,
-};
+extern const struct dsa_switch_ops felix_switch_ops;
+extern struct pci_driver felix_vsc9959_pci_driver;
 
 /* DSA glue / front-end for struct ocelot */
 struct felix {
 	struct dsa_switch		*ds;
-	struct pci_dev			*pdev;
-	struct felix_info		*info;
+	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
 	struct phy_device		**pcs;
+	resource_size_t			switch_base;
+	resource_size_t			imdio_base;
 };
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 61c91248a802..214e14893b4a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1145,6 +1145,43 @@ static void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
 	vsc9959_pcs_link_state_resolve(pcs, state);
 }
 
+static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+
+	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
+	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode)
 {
@@ -1188,7 +1225,6 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct enetc_mdio_priv *mdio_priv;
 	struct device *dev = ocelot->dev;
-	resource_size_t imdio_base;
 	void __iomem *imdio_regs;
 	struct resource res;
 	struct enetc_hw *hw;
@@ -1204,13 +1240,10 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	imdio_base = pci_resource_start(felix->pdev,
-					felix->info->imdio_pci_bar);
-
 	memcpy(&res, felix->info->imdio_res, sizeof(res));
 	res.flags = IORESOURCE_MEM;
-	res.start += imdio_base;
-	res.end += imdio_base;
+	res.start += felix->imdio_base;
+	res.end += felix->imdio_base;
 
 	imdio_regs = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(imdio_regs)) {
@@ -1484,7 +1517,7 @@ static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
 	packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
 }
 
-struct felix_info felix_info_vsc9959 = {
+const struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
 	.imdio_res		= &vsc9959_imdio_res,
@@ -1507,8 +1540,148 @@ struct felix_info felix_info_vsc9959 = {
 	.pcs_init		= vsc9959_pcs_init,
 	.pcs_an_restart		= vsc9959_pcs_an_restart,
 	.pcs_link_state		= vsc9959_pcs_link_state,
+	.phylink_validate	= vsc9959_phylink_validate,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
 	.port_sched_speed_set   = vsc9959_sched_speed_set,
 	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
+
+static irqreturn_t felix_irq_handler(int irq, void *data)
+{
+	struct ocelot *ocelot = (struct ocelot *)data;
+
+	/* The INTB interrupt is used for both PTP TX timestamp interrupt
+	 * and preemption status change interrupt on each port.
+	 *
+	 * - Get txtstamp if have
+	 * - TODO: handle preemption. Without handling it, driver may get
+	 *   interrupt storm.
+	 */
+
+	ocelot_get_txtstamp(ocelot);
+
+	return IRQ_HANDLED;
+}
+
+static int felix_pci_probe(struct pci_dev *pdev,
+			   const struct pci_device_id *id)
+{
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	int err;
+
+	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
+		dev_info(&pdev->dev, "device is disabled, skipping\n");
+		return -ENODEV;
+	}
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "device enable failed\n");
+		goto err_pci_enable;
+	}
+
+	/* set up for high or low dma */
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev,
+				"DMA configuration failed: 0x%x\n", err);
+			goto err_dma;
+		}
+	}
+
+	felix = kzalloc(sizeof(struct felix), GFP_KERNEL);
+	if (!felix) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
+		goto err_alloc_felix;
+	}
+
+	pci_set_drvdata(pdev, felix);
+	ocelot = &felix->ocelot;
+	ocelot->dev = &pdev->dev;
+	felix->info = &felix_info_vsc9959;
+	felix->switch_base = pci_resource_start(pdev,
+						felix->info->switch_pci_bar);
+	felix->imdio_base = pci_resource_start(pdev,
+					       felix->info->imdio_pci_bar);
+
+	pci_set_master(pdev);
+
+	err = devm_request_threaded_irq(&pdev->dev, pdev->irq, NULL,
+					&felix_irq_handler, IRQF_ONESHOT,
+					"felix-intb", ocelot);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to request irq\n");
+		goto err_alloc_irq;
+	}
+
+	ocelot->ptp = 1;
+
+	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate DSA switch\n");
+		goto err_alloc_ds;
+	}
+
+	ds->dev = &pdev->dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+
+	err = dsa_register_switch(ds);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		goto err_register_ds;
+	}
+
+	return 0;
+
+err_register_ds:
+	kfree(ds);
+err_alloc_ds:
+err_alloc_irq:
+err_alloc_felix:
+	kfree(felix);
+err_dma:
+	pci_disable_device(pdev);
+err_pci_enable:
+	return err;
+}
+
+static void felix_pci_remove(struct pci_dev *pdev)
+{
+	struct felix *felix;
+
+	felix = pci_get_drvdata(pdev);
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+	kfree(felix);
+
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id felix_ids[] = {
+	{
+		/* NXP LS1028A */
+		PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, 0xEEF0),
+	},
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, felix_ids);
+
+struct pci_driver felix_vsc9959_pci_driver = {
+	.name		= "mscc_felix",
+	.id_table	= felix_ids,
+	.probe		= felix_pci_probe,
+	.remove		= felix_pci_remove,
+};
-- 
2.25.1

