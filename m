Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010DE1E90F7
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgE3Lwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgE3Lwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:34 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09B6C08C5CB
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:32 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id be9so3754390edb.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6nqT+hA1AnwFbQHRL+39L/o3eHPz/KX3eZY/EWSBAyM=;
        b=aMVzEhAmOfEPilckVTH8ebvMyp4xbBjgt4emhRALBFMYkmUGwQMHpHEbXMt0KnkEVm
         tj6hDlr+GMeXy/IMkvhrcq1+2WbjEEep83KtzlC8Q96pzx0gAYrKDyFMFk1zMr7OPSQn
         U8x+szApNWPwQZvHNBGASif1bV7EMiAH2l+h0f5FovuwH3Je5bfq+KVs/ZPMsl9/rDLL
         i7JgS+jlduFrhF4u4U6GZThEzO+65R0xETYB5OUuLzofiJUb7FdA8Vll38LT1lGnYsHB
         kCczk5KnTtVZcN98W2U1fsJKQf9QlnIAJzJmTG6VyMiPQeu0cO8O9tV3FCbZca03jpvi
         sbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6nqT+hA1AnwFbQHRL+39L/o3eHPz/KX3eZY/EWSBAyM=;
        b=Lg3+JtZCI2ZjM3Lb5iunXQ3u2VXwdDB5L+8mNSu9S0YRyVAPESQbj/FJvrVbZTfmhw
         stljKhisq9m+Yp816oVZGdenw8pRaGEuYXuv4dQ2+j4Q/pCEi2dxlw2bgQqIAGMpJzrv
         agj9k/pdjVI1ycppLQyl1NTuguBltev17BRpTDrZYMUnkF4zU6/YvxJmLqRvvxnbDqVn
         D7L3D0/3ConSe0ooOgKkMTn7N5yxRDG087fF7aPquNgav1HMI/UmQftbTpAUNBgbSo2l
         vAfyuvB0WHBQQX6SBuP4kGuSETuxZ924HixUe+AIdy7+iY4wJH90hx77p7HPj12180Q+
         NZUg==
X-Gm-Message-State: AOAM531gwPcSM7J4DtMV+QI4KnHxx62t6PvF2XE92hFC7tfOYMbznP/g
        4pTMozoC1nKQHh5M6Q2OXhg=
X-Google-Smtp-Source: ABdhPJz5vHj9+h2+0+OraehGKz9LDNs3XT/g1bEB/s2Jn/0LcVkMDQpGUHvFXXjougZwoaFvKVLEcw==
X-Received: by 2002:aa7:c558:: with SMTP id s24mr6523301edr.237.1590839551450;
        Sat, 30 May 2020 04:52:31 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 12/13] net: dsa: felix: move probing to felix_vsc9959.c
Date:   Sat, 30 May 2020 14:51:41 +0300
Message-Id: <20200530115142.707415-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
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
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c         | 194 +------------------------
 drivers/net/dsa/ocelot/felix.h         |  14 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 192 +++++++++++++++++++++++-
 3 files changed, 200 insertions(+), 200 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 88b64faa8b25..0e54b0e295ce 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -158,37 +158,10 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
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
@@ -438,7 +411,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
-	resource_size_t switch_base;
 	struct resource res;
 	int port, i, err;
 
@@ -469,9 +441,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		return err;
 	}
 
-	switch_base = pci_resource_start(felix->pdev,
-					 felix->info->switch_pci_bar);
-
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
 
@@ -480,8 +449,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
 		res.flags = IORESOURCE_MEM;
-		res.start += switch_base;
-		res.end += switch_base;
+		res.start += felix->switch_base;
+		res.end += felix->switch_base;
 
 		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
@@ -518,8 +487,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
 		res.flags = IORESOURCE_MEM;
-		res.start += switch_base;
-		res.end += switch_base;
+		res.start += felix->switch_base;
+		res.end += felix->switch_base;
 
 		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
@@ -786,7 +755,7 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 }
 
-static const struct dsa_switch_ops felix_switch_ops = {
+const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
 	.teardown		= felix_teardown,
@@ -826,150 +795,3 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc          = felix_port_setup_tc,
 };
-
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
-{
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
-}
-
-static void felix_pci_remove(struct pci_dev *pdev)
-{
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
-}
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
-
-MODULE_DESCRIPTION("Felix Switch driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 2f28c28fdef0..a93d27878c6f 100644
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
@@ -43,20 +46,17 @@ struct felix_info {
 	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
 };
 
-extern struct felix_info		felix_info_vsc9959;
-
-enum felix_instance {
-	FELIX_INSTANCE_VSC9959		= 0,
-};
+extern const struct dsa_switch_ops felix_switch_ops;
 
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
index 61c91248a802..9ab940a1b53a 100644
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
@@ -1507,8 +1540,153 @@ struct felix_info felix_info_vsc9959 = {
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
+static struct pci_driver felix_pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= felix_ids,
+	.probe		= felix_pci_probe,
+	.remove		= felix_pci_remove,
+};
+
+module_pci_driver(felix_pci_driver);
+
+MODULE_DESCRIPTION("Felix Switch driver");
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

