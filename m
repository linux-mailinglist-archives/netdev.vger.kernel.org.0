Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B71621DE05
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgGMQ64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMQ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:58:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A597CC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so14348621edz.0
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrsLejkd19G6QH2hQI0ynvBSE4+4O+BrNb45ML688TU=;
        b=iJYUNb7S0DJq2i6BtqoUp+E5eiSfn7k6DKqTRosLFarRxrIaLXDfiXYU5RjYp6y3NN
         ZkghAs+GI1r/tLKEvtVnOf8qHg22Gu/VjoFEozT58AfotQEzxvAcyHMMJ/DmGYaqRU7c
         2a5YySJvON6iPGiCTcs9qbh9fFWdnMHa3SymUQ6zeGqB/Wpgbf1HtxkQ3TsRWp7jB91e
         c9gYMoo5Zq1fIfix40ZJ5TIc0ZCdvrOBnFj8M6KB0gHR9xMISDrFzWpY0xiuWUlnDWdt
         LKVKouCtNk0dj/jvYDrODvCIKRtCcb1dgHeQewsnpC40CdbqjLHnrSreOeXt0+RaAKey
         5Aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrsLejkd19G6QH2hQI0ynvBSE4+4O+BrNb45ML688TU=;
        b=ql42rTNQ6ND2O11iD5BHOhdB+erFpRi817+oFpyBYl48bEJcAN+su9+6iqHTy7ydUF
         aZ42oQM+evrTAwhDaR0fgJ+GPUKL1sN2nNmnOzCDZSie8hS9vCLkOOf8zjm0Qa8SQ6x2
         fot+gZYaMXqGhzQkewrE+RGSF35B5G5r3gzqOtQKQ0ToyvaD68eqrYgcv7fn0baGJ06u
         QCQkM/Iez79aIJ9h9YiYRGGtliY027c+rfnPVLceLGMBeyuxxu7AmQPY4v/zsQR5WxYG
         m8Nrp+rL7ha8+ypE/0yi7oQs6ZHFYthQhwd3ccPD6ebx7yY9PePzGVzaGBzOzH1Vci8S
         tO9A==
X-Gm-Message-State: AOAM530YsOTAGvcbuafknSfbTsNrS/ZUIjx45lps1NeJuNtyFi8bGmlH
        S4VYrXm633R0+XdsMhch+OE=
X-Google-Smtp-Source: ABdhPJwuWJOTxLva77iVRlXyHJu4ckxYkOIFDDVfyM/v2xFJuOEFW1iff+EnyA9kqTu1oNnBO8cIvA==
X-Received: by 2002:aa7:d3c8:: with SMTP id o8mr351572edr.294.1594659534304;
        Mon, 13 Jul 2020 09:58:54 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 01/11] net: mscc: ocelot: convert port registers to regmap
Date:   Mon, 13 Jul 2020 19:57:01 +0300
Message-Id: <20200713165711.2518150-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At the moment, there are some minimal register differences between
VSC7514 Ocelot and VSC9959 Felix. To be precise, the PCS1G registers are
missing from Felix because it was integrated with an NXP PCS.

But with VSC9953 Seville (not yet introduced), the register differences
are more pronounced.  The MAC registers are located at different offsets
within the DEV_GMII target. So we need to refactor the driver to keep a
regmap even for per-port registers. The callers of the ocelot_port_readl
and ocelot_port_writel were kept unchanged, only the implementation is
now more generic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
Rebased on top of patch "net: mscc: ocelot: move ocelot_regs.c into
ocelot_vsc7514.c" which was merged since last submission.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c             | 13 ++--
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 47 ++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h         |  3 +-
 drivers/net/ethernet/mscc/ocelot_io.c      | 16 ++++-
 drivers/net/ethernet/mscc/ocelot_net.c     |  5 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 53 +++++++++++++--
 include/soc/mscc/ocelot.h                  | 42 +++++++++++-
 include/soc/mscc/ocelot_dev.h              | 78 ----------------------
 8 files changed, 158 insertions(+), 99 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 75652ed99b24..bf0bd5c7b12c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -524,7 +524,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
-		void __iomem *port_regs;
+		struct regmap *target;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -541,17 +541,18 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += switch_base;
 		res.end += switch_base;
 
-		port_regs = devm_ioremap_resource(ocelot->dev, &res);
-		if (IS_ERR(port_regs)) {
+		target = ocelot_regmap_init(ocelot, &res);
+		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
-				"failed to map registers for port %d\n", port);
+				"Failed to map memory space for port %d\n",
+				port);
 			kfree(port_phy_modes);
-			return PTR_ERR(port_regs);
+			return PTR_ERR(target);
 		}
 
 		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
-		ocelot_port->regs = port_regs;
+		ocelot_port->target = target;
 		ocelot->ports[port] = ocelot_port;
 	}
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 19614537b1ba..0c54d67a4039 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -329,7 +329,49 @@ static const u32 vsc9959_gcb_regmap[] = {
 	REG(GCB_SOFT_RST,			0x000004),
 };
 
-static const u32 *vsc9959_regmap[] = {
+static const u32 vsc9959_dev_gmii_regmap[] = {
+	REG(DEV_CLOCK_CFG,			0x0),
+	REG(DEV_PORT_MISC,			0x4),
+	REG(DEV_EVENTS,				0x8),
+	REG(DEV_EEE_CFG,			0xc),
+	REG(DEV_RX_PATH_DELAY,			0x10),
+	REG(DEV_TX_PATH_DELAY,			0x14),
+	REG(DEV_PTP_PREDICT_CFG,		0x18),
+	REG(DEV_MAC_ENA_CFG,			0x1c),
+	REG(DEV_MAC_MODE_CFG,			0x20),
+	REG(DEV_MAC_MAXLEN_CFG,			0x24),
+	REG(DEV_MAC_TAGS_CFG,			0x28),
+	REG(DEV_MAC_ADV_CHK_CFG,		0x2c),
+	REG(DEV_MAC_IFG_CFG,			0x30),
+	REG(DEV_MAC_HDX_CFG,			0x34),
+	REG(DEV_MAC_DBG_CFG,			0x38),
+	REG(DEV_MAC_FC_MAC_LOW_CFG,		0x3c),
+	REG(DEV_MAC_FC_MAC_HIGH_CFG,		0x40),
+	REG(DEV_MAC_STICKY,			0x44),
+	REG_RESERVED(PCS1G_CFG),
+	REG_RESERVED(PCS1G_MODE_CFG),
+	REG_RESERVED(PCS1G_SD_CFG),
+	REG_RESERVED(PCS1G_ANEG_CFG),
+	REG_RESERVED(PCS1G_ANEG_NP_CFG),
+	REG_RESERVED(PCS1G_LB_CFG),
+	REG_RESERVED(PCS1G_DBG_CFG),
+	REG_RESERVED(PCS1G_CDET_CFG),
+	REG_RESERVED(PCS1G_ANEG_STATUS),
+	REG_RESERVED(PCS1G_ANEG_NP_STATUS),
+	REG_RESERVED(PCS1G_LINK_STATUS),
+	REG_RESERVED(PCS1G_LINK_DOWN_CNT),
+	REG_RESERVED(PCS1G_STICKY),
+	REG_RESERVED(PCS1G_DEBUG_STATUS),
+	REG_RESERVED(PCS1G_LPI_CFG),
+	REG_RESERVED(PCS1G_LPI_WAKE_ERROR_CNT),
+	REG_RESERVED(PCS1G_LPI_STATUS),
+	REG_RESERVED(PCS1G_TSTPAT_MODE_CFG),
+	REG_RESERVED(PCS1G_TSTPAT_STATUS),
+	REG_RESERVED(DEV_PCS_FX100_CFG),
+	REG_RESERVED(DEV_PCS_FX100_STATUS),
+};
+
+static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[ANA]	= vsc9959_ana_regmap,
 	[QS]	= vsc9959_qs_regmap,
 	[QSYS]	= vsc9959_qsys_regmap,
@@ -338,10 +380,11 @@ static const u32 *vsc9959_regmap[] = {
 	[S2]	= vsc9959_s2_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
+	[DEV_GMII] = vsc9959_dev_gmii_regmap,
 };
 
 /* Addresses are relative to the PCI device's base address */
-static const struct resource vsc9959_target_io_res[] = {
+static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
 	[ANA] = {
 		.start	= 0x0280000,
 		.end	= 0x028ffff,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 394362e23c47..814b09dd2c11 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -105,8 +105,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 #define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
 #define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
 
-int ocelot_probe_port(struct ocelot *ocelot, u8 port,
-		      void __iomem *regs,
+int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
 
 void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index b229b1cb68ef..741f653bc85b 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -49,13 +49,25 @@ EXPORT_SYMBOL(__ocelot_rmw_ix);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 {
-	return readl(port->regs + reg);
+	struct ocelot *ocelot = port->ocelot;
+	u16 target = reg >> TARGET_OFFSET;
+	u32 val;
+
+	WARN_ON(!target);
+
+	regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val);
+	return val;
 }
 EXPORT_SYMBOL(ocelot_port_readl);
 
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 {
-	writel(val, port->regs + reg);
+	struct ocelot *ocelot = port->ocelot;
+	u16 target = reg >> TARGET_OFFSET;
+
+	WARN_ON(!target);
+
+	regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val);
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 41a1b5f6df95..0668d23cdbfa 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1005,8 +1005,7 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 	.notifier_call = ocelot_switchdev_blocking_event,
 };
 
-int ocelot_probe_port(struct ocelot *ocelot, u8 port,
-		      void __iomem *regs,
+int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy)
 {
 	struct ocelot_port_private *priv;
@@ -1024,7 +1023,7 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	priv->chip_port = port;
 	ocelot_port = &priv->port;
 	ocelot_port->ocelot = ocelot;
-	ocelot_port->regs = regs;
+	ocelot_port->target = target;
 	ocelot->ports[port] = ocelot_port;
 
 	dev->netdev_ops = &ocelot_port_netdev_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 43716e8dc0ac..63af145e744c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -263,7 +263,49 @@ static const u32 ocelot_ptp_regmap[] = {
 	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
 };
 
-static const u32 *ocelot_regmap[] = {
+static const u32 ocelot_dev_gmii_regmap[] = {
+	REG(DEV_CLOCK_CFG,				0x0),
+	REG(DEV_PORT_MISC,				0x4),
+	REG(DEV_EVENTS,					0x8),
+	REG(DEV_EEE_CFG,				0xc),
+	REG(DEV_RX_PATH_DELAY,				0x10),
+	REG(DEV_TX_PATH_DELAY,				0x14),
+	REG(DEV_PTP_PREDICT_CFG,			0x18),
+	REG(DEV_MAC_ENA_CFG,				0x1c),
+	REG(DEV_MAC_MODE_CFG,				0x20),
+	REG(DEV_MAC_MAXLEN_CFG,				0x24),
+	REG(DEV_MAC_TAGS_CFG,				0x28),
+	REG(DEV_MAC_ADV_CHK_CFG,			0x2c),
+	REG(DEV_MAC_IFG_CFG,				0x30),
+	REG(DEV_MAC_HDX_CFG,				0x34),
+	REG(DEV_MAC_DBG_CFG,				0x38),
+	REG(DEV_MAC_FC_MAC_LOW_CFG,			0x3c),
+	REG(DEV_MAC_FC_MAC_HIGH_CFG,			0x40),
+	REG(DEV_MAC_STICKY,				0x44),
+	REG(PCS1G_CFG,					0x48),
+	REG(PCS1G_MODE_CFG,				0x4c),
+	REG(PCS1G_SD_CFG,				0x50),
+	REG(PCS1G_ANEG_CFG,				0x54),
+	REG(PCS1G_ANEG_NP_CFG,				0x58),
+	REG(PCS1G_LB_CFG,				0x5c),
+	REG(PCS1G_DBG_CFG,				0x60),
+	REG(PCS1G_CDET_CFG,				0x64),
+	REG(PCS1G_ANEG_STATUS,				0x68),
+	REG(PCS1G_ANEG_NP_STATUS,			0x6c),
+	REG(PCS1G_LINK_STATUS,				0x70),
+	REG(PCS1G_LINK_DOWN_CNT,			0x74),
+	REG(PCS1G_STICKY,				0x78),
+	REG(PCS1G_DEBUG_STATUS,				0x7c),
+	REG(PCS1G_LPI_CFG,				0x80),
+	REG(PCS1G_LPI_WAKE_ERROR_CNT,			0x84),
+	REG(PCS1G_LPI_STATUS,				0x88),
+	REG(PCS1G_TSTPAT_MODE_CFG,			0x8c),
+	REG(PCS1G_TSTPAT_STATUS,			0x90),
+	REG(DEV_PCS_FX100_CFG,				0x94),
+	REG(DEV_PCS_FX100_STATUS,			0x98),
+};
+
+static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = ocelot_ana_regmap,
 	[QS] = ocelot_qs_regmap,
 	[QSYS] = ocelot_qsys_regmap,
@@ -271,6 +313,7 @@ static const u32 *ocelot_regmap[] = {
 	[SYS] = ocelot_sys_regmap,
 	[S2] = ocelot_s2_regmap,
 	[PTP] = ocelot_ptp_regmap,
+	[DEV_GMII] = ocelot_dev_gmii_regmap,
 };
 
 static const struct reg_field ocelot_regfields[] = {
@@ -948,9 +991,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		struct device_node *phy_node;
 		phy_interface_t phy_mode;
 		struct phy_device *phy;
+		struct regmap *target;
 		struct resource *res;
 		struct phy *serdes;
-		void __iomem *regs;
 		char res_name[8];
 		u32 port;
 
@@ -961,8 +1004,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   res_name);
-		regs = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(regs))
+		target = ocelot_regmap_init(ocelot, res);
+		if (IS_ERR(target))
 			continue;
 
 		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
@@ -974,7 +1017,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		if (!phy)
 			continue;
 
-		err = ocelot_probe_port(ocelot, port, regs, phy);
+		err = ocelot_probe_port(ocelot, port, target, phy);
 		if (err) {
 			of_node_put(portnp);
 			goto out_put_ports;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e050f8121ba2..c2a2d0165ef1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -126,6 +126,7 @@ enum ocelot_target {
 	HSIO,
 	PTP,
 	GCB,
+	DEV_GMII,
 	TARGET_MAX,
 };
 
@@ -408,6 +409,45 @@ enum ocelot_reg {
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
 	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
+	DEV_PORT_MISC,
+	DEV_EVENTS,
+	DEV_EEE_CFG,
+	DEV_RX_PATH_DELAY,
+	DEV_TX_PATH_DELAY,
+	DEV_PTP_PREDICT_CFG,
+	DEV_MAC_ENA_CFG,
+	DEV_MAC_MODE_CFG,
+	DEV_MAC_MAXLEN_CFG,
+	DEV_MAC_TAGS_CFG,
+	DEV_MAC_ADV_CHK_CFG,
+	DEV_MAC_IFG_CFG,
+	DEV_MAC_HDX_CFG,
+	DEV_MAC_DBG_CFG,
+	DEV_MAC_FC_MAC_LOW_CFG,
+	DEV_MAC_FC_MAC_HIGH_CFG,
+	DEV_MAC_STICKY,
+	PCS1G_CFG,
+	PCS1G_MODE_CFG,
+	PCS1G_SD_CFG,
+	PCS1G_ANEG_CFG,
+	PCS1G_ANEG_NP_CFG,
+	PCS1G_LB_CFG,
+	PCS1G_DBG_CFG,
+	PCS1G_CDET_CFG,
+	PCS1G_ANEG_STATUS,
+	PCS1G_ANEG_NP_STATUS,
+	PCS1G_LINK_STATUS,
+	PCS1G_LINK_DOWN_CNT,
+	PCS1G_STICKY,
+	PCS1G_DEBUG_STATUS,
+	PCS1G_LPI_CFG,
+	PCS1G_LPI_WAKE_ERROR_CNT,
+	PCS1G_LPI_STATUS,
+	PCS1G_TSTPAT_MODE_CFG,
+	PCS1G_TSTPAT_STATUS,
+	DEV_PCS_FX100_CFG,
+	DEV_PCS_FX100_STATUS,
 };
 
 enum ocelot_regfield {
@@ -494,7 +534,7 @@ struct ocelot_vcap_block {
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
-	void __iomem			*regs;
+	struct regmap			*target;
 
 	bool				vlan_aware;
 
diff --git a/include/soc/mscc/ocelot_dev.h b/include/soc/mscc/ocelot_dev.h
index 7c08437061fc..0c6021f02fee 100644
--- a/include/soc/mscc/ocelot_dev.h
+++ b/include/soc/mscc/ocelot_dev.h
@@ -8,8 +8,6 @@
 #ifndef _MSCC_OCELOT_DEV_H_
 #define _MSCC_OCELOT_DEV_H_
 
-#define DEV_CLOCK_CFG                                     0x0
-
 #define DEV_CLOCK_CFG_MAC_TX_RST                          BIT(7)
 #define DEV_CLOCK_CFG_MAC_RX_RST                          BIT(6)
 #define DEV_CLOCK_CFG_PCS_TX_RST                          BIT(5)
@@ -19,18 +17,12 @@
 #define DEV_CLOCK_CFG_LINK_SPEED(x)                       ((x) & GENMASK(1, 0))
 #define DEV_CLOCK_CFG_LINK_SPEED_M                        GENMASK(1, 0)
 
-#define DEV_PORT_MISC                                     0x4
-
 #define DEV_PORT_MISC_FWD_ERROR_ENA                       BIT(4)
 #define DEV_PORT_MISC_FWD_PAUSE_ENA                       BIT(3)
 #define DEV_PORT_MISC_FWD_CTRL_ENA                        BIT(2)
 #define DEV_PORT_MISC_DEV_LOOP_ENA                        BIT(1)
 #define DEV_PORT_MISC_HDX_FAST_DIS                        BIT(0)
 
-#define DEV_EVENTS                                        0x8
-
-#define DEV_EEE_CFG                                       0xc
-
 #define DEV_EEE_CFG_EEE_ENA                               BIT(22)
 #define DEV_EEE_CFG_EEE_TIMER_AGE(x)                      (((x) << 15) & GENMASK(21, 15))
 #define DEV_EEE_CFG_EEE_TIMER_AGE_M                       GENMASK(21, 15)
@@ -43,33 +35,19 @@
 #define DEV_EEE_CFG_EEE_TIMER_HOLDOFF_X(x)                (((x) & GENMASK(7, 1)) >> 1)
 #define DEV_EEE_CFG_PORT_LPI                              BIT(0)
 
-#define DEV_RX_PATH_DELAY                                 0x10
-
-#define DEV_TX_PATH_DELAY                                 0x14
-
-#define DEV_PTP_PREDICT_CFG                               0x18
-
 #define DEV_PTP_PREDICT_CFG_PTP_PHY_PREDICT_CFG(x)        (((x) << 4) & GENMASK(11, 4))
 #define DEV_PTP_PREDICT_CFG_PTP_PHY_PREDICT_CFG_M         GENMASK(11, 4)
 #define DEV_PTP_PREDICT_CFG_PTP_PHY_PREDICT_CFG_X(x)      (((x) & GENMASK(11, 4)) >> 4)
 #define DEV_PTP_PREDICT_CFG_PTP_PHASE_PREDICT_CFG(x)      ((x) & GENMASK(3, 0))
 #define DEV_PTP_PREDICT_CFG_PTP_PHASE_PREDICT_CFG_M       GENMASK(3, 0)
 
-#define DEV_MAC_ENA_CFG                                   0x1c
-
 #define DEV_MAC_ENA_CFG_RX_ENA                            BIT(4)
 #define DEV_MAC_ENA_CFG_TX_ENA                            BIT(0)
 
-#define DEV_MAC_MODE_CFG                                  0x20
-
 #define DEV_MAC_MODE_CFG_FC_WORD_SYNC_ENA                 BIT(8)
 #define DEV_MAC_MODE_CFG_GIGA_MODE_ENA                    BIT(4)
 #define DEV_MAC_MODE_CFG_FDX_ENA                          BIT(0)
 
-#define DEV_MAC_MAXLEN_CFG                                0x24
-
-#define DEV_MAC_TAGS_CFG                                  0x28
-
 #define DEV_MAC_TAGS_CFG_TAG_ID(x)                        (((x) << 16) & GENMASK(31, 16))
 #define DEV_MAC_TAGS_CFG_TAG_ID_M                         GENMASK(31, 16)
 #define DEV_MAC_TAGS_CFG_TAG_ID_X(x)                      (((x) & GENMASK(31, 16)) >> 16)
@@ -77,12 +55,8 @@
 #define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA                 BIT(1)
 #define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA                     BIT(0)
 
-#define DEV_MAC_ADV_CHK_CFG                               0x2c
-
 #define DEV_MAC_ADV_CHK_CFG_LEN_DROP_ENA                  BIT(0)
 
-#define DEV_MAC_IFG_CFG                                   0x30
-
 #define DEV_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK             BIT(17)
 #define DEV_MAC_IFG_CFG_REDUCED_TX_IFG                    BIT(16)
 #define DEV_MAC_IFG_CFG_TX_IFG(x)                         (((x) << 8) & GENMASK(12, 8))
@@ -94,8 +68,6 @@
 #define DEV_MAC_IFG_CFG_RX_IFG1(x)                        ((x) & GENMASK(3, 0))
 #define DEV_MAC_IFG_CFG_RX_IFG1_M                         GENMASK(3, 0)
 
-#define DEV_MAC_HDX_CFG                                   0x34
-
 #define DEV_MAC_HDX_CFG_BYPASS_COL_SYNC                   BIT(26)
 #define DEV_MAC_HDX_CFG_OB_ENA                            BIT(25)
 #define DEV_MAC_HDX_CFG_WEXC_DIS                          BIT(24)
@@ -107,17 +79,9 @@
 #define DEV_MAC_HDX_CFG_LATE_COL_POS(x)                   ((x) & GENMASK(6, 0))
 #define DEV_MAC_HDX_CFG_LATE_COL_POS_M                    GENMASK(6, 0)
 
-#define DEV_MAC_DBG_CFG                                   0x38
-
 #define DEV_MAC_DBG_CFG_TBI_MODE                          BIT(4)
 #define DEV_MAC_DBG_CFG_IFG_CRS_EXT_CHK_ENA               BIT(0)
 
-#define DEV_MAC_FC_MAC_LOW_CFG                            0x3c
-
-#define DEV_MAC_FC_MAC_HIGH_CFG                           0x40
-
-#define DEV_MAC_STICKY                                    0x44
-
 #define DEV_MAC_STICKY_RX_IPG_SHRINK_STICKY               BIT(9)
 #define DEV_MAC_STICKY_RX_PREAM_SHRINK_STICKY             BIT(8)
 #define DEV_MAC_STICKY_RX_CARRIER_EXT_STICKY              BIT(7)
@@ -129,25 +93,17 @@
 #define DEV_MAC_STICKY_TX_FRM_LEN_OVR_STICKY              BIT(1)
 #define DEV_MAC_STICKY_TX_ABORT_STICKY                    BIT(0)
 
-#define PCS1G_CFG                                         0x48
-
 #define PCS1G_CFG_LINK_STATUS_TYPE                        BIT(4)
 #define PCS1G_CFG_AN_LINK_CTRL_ENA                        BIT(1)
 #define PCS1G_CFG_PCS_ENA                                 BIT(0)
 
-#define PCS1G_MODE_CFG                                    0x4c
-
 #define PCS1G_MODE_CFG_UNIDIR_MODE_ENA                    BIT(4)
 #define PCS1G_MODE_CFG_SGMII_MODE_ENA                     BIT(0)
 
-#define PCS1G_SD_CFG                                      0x50
-
 #define PCS1G_SD_CFG_SD_SEL                               BIT(8)
 #define PCS1G_SD_CFG_SD_POL                               BIT(4)
 #define PCS1G_SD_CFG_SD_ENA                               BIT(0)
 
-#define PCS1G_ANEG_CFG                                    0x54
-
 #define PCS1G_ANEG_CFG_ADV_ABILITY(x)                     (((x) << 16) & GENMASK(31, 16))
 #define PCS1G_ANEG_CFG_ADV_ABILITY_M                      GENMASK(31, 16)
 #define PCS1G_ANEG_CFG_ADV_ABILITY_X(x)                   (((x) & GENMASK(31, 16)) >> 16)
@@ -155,29 +111,19 @@
 #define PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT              BIT(1)
 #define PCS1G_ANEG_CFG_ANEG_ENA                           BIT(0)
 
-#define PCS1G_ANEG_NP_CFG                                 0x58
-
 #define PCS1G_ANEG_NP_CFG_NP_TX(x)                        (((x) << 16) & GENMASK(31, 16))
 #define PCS1G_ANEG_NP_CFG_NP_TX_M                         GENMASK(31, 16)
 #define PCS1G_ANEG_NP_CFG_NP_TX_X(x)                      (((x) & GENMASK(31, 16)) >> 16)
 #define PCS1G_ANEG_NP_CFG_NP_LOADED_ONE_SHOT              BIT(0)
 
-#define PCS1G_LB_CFG                                      0x5c
-
 #define PCS1G_LB_CFG_RA_ENA                               BIT(4)
 #define PCS1G_LB_CFG_GMII_PHY_LB_ENA                      BIT(1)
 #define PCS1G_LB_CFG_TBI_HOST_LB_ENA                      BIT(0)
 
-#define PCS1G_DBG_CFG                                     0x60
-
 #define PCS1G_DBG_CFG_UDLT                                BIT(0)
 
-#define PCS1G_CDET_CFG                                    0x64
-
 #define PCS1G_CDET_CFG_CDET_ENA                           BIT(0)
 
-#define PCS1G_ANEG_STATUS                                 0x68
-
 #define PCS1G_ANEG_STATUS_LP_ADV_ABILITY(x)               (((x) << 16) & GENMASK(31, 16))
 #define PCS1G_ANEG_STATUS_LP_ADV_ABILITY_M                GENMASK(31, 16)
 #define PCS1G_ANEG_STATUS_LP_ADV_ABILITY_X(x)             (((x) & GENMASK(31, 16)) >> 16)
@@ -185,10 +131,6 @@
 #define PCS1G_ANEG_STATUS_PAGE_RX_STICKY                  BIT(3)
 #define PCS1G_ANEG_STATUS_ANEG_COMPLETE                   BIT(0)
 
-#define PCS1G_ANEG_NP_STATUS                              0x6c
-
-#define PCS1G_LINK_STATUS                                 0x70
-
 #define PCS1G_LINK_STATUS_DELAY_VAR(x)                    (((x) << 12) & GENMASK(15, 12))
 #define PCS1G_LINK_STATUS_DELAY_VAR_M                     GENMASK(15, 12)
 #define PCS1G_LINK_STATUS_DELAY_VAR_X(x)                  (((x) & GENMASK(15, 12)) >> 12)
@@ -196,17 +138,9 @@
 #define PCS1G_LINK_STATUS_LINK_STATUS                     BIT(4)
 #define PCS1G_LINK_STATUS_SYNC_STATUS                     BIT(0)
 
-#define PCS1G_LINK_DOWN_CNT                               0x74
-
-#define PCS1G_STICKY                                      0x78
-
 #define PCS1G_STICKY_LINK_DOWN_STICKY                     BIT(4)
 #define PCS1G_STICKY_OUT_OF_SYNC_STICKY                   BIT(0)
 
-#define PCS1G_DEBUG_STATUS                                0x7c
-
-#define PCS1G_LPI_CFG                                     0x80
-
 #define PCS1G_LPI_CFG_QSGMII_MS_SEL                       BIT(20)
 #define PCS1G_LPI_CFG_RX_LPI_OUT_DIS                      BIT(17)
 #define PCS1G_LPI_CFG_LPI_TESTMODE                        BIT(16)
@@ -215,10 +149,6 @@
 #define PCS1G_LPI_CFG_LPI_RX_WTIM_X(x)                    (((x) & GENMASK(5, 4)) >> 4)
 #define PCS1G_LPI_CFG_TX_ASSERT_LPIDLE                    BIT(0)
 
-#define PCS1G_LPI_WAKE_ERROR_CNT                          0x84
-
-#define PCS1G_LPI_STATUS                                  0x88
-
 #define PCS1G_LPI_STATUS_RX_LPI_FAIL                      BIT(16)
 #define PCS1G_LPI_STATUS_RX_LPI_EVENT_STICKY              BIT(12)
 #define PCS1G_LPI_STATUS_RX_QUIET                         BIT(9)
@@ -227,18 +157,12 @@
 #define PCS1G_LPI_STATUS_TX_QUIET                         BIT(1)
 #define PCS1G_LPI_STATUS_TX_LPI_MODE                      BIT(0)
 
-#define PCS1G_TSTPAT_MODE_CFG                             0x8c
-
-#define PCS1G_TSTPAT_STATUS                               0x90
-
 #define PCS1G_TSTPAT_STATUS_JTP_ERR_CNT(x)                (((x) << 8) & GENMASK(15, 8))
 #define PCS1G_TSTPAT_STATUS_JTP_ERR_CNT_M                 GENMASK(15, 8)
 #define PCS1G_TSTPAT_STATUS_JTP_ERR_CNT_X(x)              (((x) & GENMASK(15, 8)) >> 8)
 #define PCS1G_TSTPAT_STATUS_JTP_ERR                       BIT(4)
 #define PCS1G_TSTPAT_STATUS_JTP_LOCK                      BIT(0)
 
-#define DEV_PCS_FX100_CFG                                 0x94
-
 #define DEV_PCS_FX100_CFG_SD_SEL                          BIT(26)
 #define DEV_PCS_FX100_CFG_SD_POL                          BIT(25)
 #define DEV_PCS_FX100_CFG_SD_ENA                          BIT(24)
@@ -259,8 +183,6 @@
 #define DEV_PCS_FX100_CFG_FEFGEN_ENA                      BIT(1)
 #define DEV_PCS_FX100_CFG_PCS_ENA                         BIT(0)
 
-#define DEV_PCS_FX100_STATUS                              0x98
-
 #define DEV_PCS_FX100_STATUS_EDGE_POS_PTP(x)              (((x) << 8) & GENMASK(11, 8))
 #define DEV_PCS_FX100_STATUS_EDGE_POS_PTP_M               GENMASK(11, 8)
 #define DEV_PCS_FX100_STATUS_EDGE_POS_PTP_X(x)            (((x) & GENMASK(11, 8)) >> 8)
-- 
2.25.1

