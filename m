Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655A391952
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhEZN55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbhEZN5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC67DC061760
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t3so1613124edc.7
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NvKXPfJHudA/7MpUC8eb3xPCFwobuco93gUwHQx0PJI=;
        b=IKKSwCZ6Lj8kBVD0i2rpuXcJWf0lxdn5IeWvduOUjx32P0D/d5JrUZXDPbq9Kxntzx
         QWicQbsa+/QPuA5d/dY1ysRPCFfcbdM20VF8MYJHWAn7XHRKU6DIVAb7LPX8Oc2uT7rJ
         qKtXgOSubkJl2NIOHSv5s25bAyxOgfSZ95atq90twjXrBSVEWjVaE1oAnI0W4Sf6aDgY
         LCAYuVgxBCF5zvNTBu2GSMwruJ4J5oKlXqtLaA3ZkhUU6lSj9P3OJ2loU53ruE9ZqwGe
         BGwSJeUMfMPlUA9gap+TGq2yJYD+MJ4D3OdOC+aWWO+4poDFzX+NRKCPEtS4N1wcIxet
         Z3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NvKXPfJHudA/7MpUC8eb3xPCFwobuco93gUwHQx0PJI=;
        b=epgfVOFSvi8BUSk7aCyJMxYzRSsf3gNd6sy2a8Z4U579Zif7yZnx4hKgOSOHaEqXqX
         o/KNN03X657auL9iIrGAL8QQzZJYx5JsVTm5ikzZ+nm8db9zYIvC64w3T7XZ2l9bGG+/
         0BEEqn1lsE20JJ0HdFvxJwz0/CSICM69q7QmPRDXEynAN8CuirlhitychOGK0OpC8YoQ
         W4JIs+9cnjwqtCsTJK+B84TLpzjYzCPCQBaSgXqhoc2Yjp7WoMsZ/ph7Wrcpl8wBuT5i
         +MWCj2mGMBxN3CEFoNx3auRxfWoovVieDqnXeITOi4zNIMzq2XSjBg9h9IJvhtVFkhWR
         8bJQ==
X-Gm-Message-State: AOAM531eT5nGjPZi40uVzl0O+rRXdjenLZWKV+IDbhZrpA13RfgtzeMk
        FlB61FZrNelRANcHBz+8iqM=
X-Google-Smtp-Source: ABdhPJyzRA57U0ikqNcTnf7NLiP/pQONG6Y0s76lvFeMoF19OiWQ8wTLhqNOyiNVWbXADDS8g8MMfA==
X-Received: by 2002:aa7:dc4a:: with SMTP id g10mr38158185edu.316.1622037363429;
        Wed, 26 May 2021 06:56:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:56:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [RFC PATCH v2 linux-next 12/14] net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX
Date:   Wed, 26 May 2021 16:55:33 +0300
Message-Id: <20210526135535.2515123-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1110 contains two types of integrated PHYs: one 100base-TX PHY
and multiple 100base-T1 PHYs.

The access procedure for the 100base-T1 PHYs is also different than it
is for the 100base-TX one. So we register 2 MDIO buses, one for the
base-TX and the other for the base-T1. Each bus has an OF node which is
a child of the "mdio" subnode of the switch, and they are recognized by
compatible string.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
s/"mdio"/"mdios"/ for the name of the container OF node.

 drivers/net/dsa/sja1105/Makefile       |   1 +
 drivers/net/dsa/sja1105/sja1105.h      |  19 ++
 drivers/net/dsa/sja1105/sja1105_main.c |  21 +-
 drivers/net/dsa/sja1105/sja1105_mdio.c | 288 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  30 +++
 5 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_mdio.c

diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index a860e3a910be..40d69e6c0bae 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_NET_DSA_SJA1105) += sja1105.o
 sja1105-objs := \
     sja1105_spi.o \
     sja1105_main.o \
+    sja1105_mdio.o \
     sja1105_flower.o \
     sja1105_ethtool.o \
     sja1105_devlink.o \
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 8bfda8c7bc1f..80966d7ce318 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -67,6 +67,12 @@ struct sja1105_regs {
 	u64 rmii_ref_clk[SJA1105_MAX_NUM_PORTS];
 	u64 rmii_ext_tx_clk[SJA1105_MAX_NUM_PORTS];
 	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
+	u64 mdio_100base_tx;
+	u64 mdio_100base_t1;
+};
+
+struct sja1105_mdio_private {
+	struct sja1105_private *priv;
 };
 
 enum {
@@ -78,6 +84,12 @@ enum {
 	SJA1105_SPEED_MAX,
 };
 
+enum sja1105_internal_phy_t {
+	SJA1105_NO_PHY		= 0,
+	SJA1105_PHY_BASE_TX,
+	SJA1105_PHY_BASE_T1,
+};
+
 struct sja1105_info {
 	u64 device_id;
 	/* Needed for distinction between P and R, and between Q and S
@@ -123,6 +135,7 @@ struct sja1105_info {
 	bool supports_rgmii[SJA1105_MAX_NUM_PORTS];
 	bool supports_sgmii[SJA1105_MAX_NUM_PORTS];
 	bool supports_2500basex[SJA1105_MAX_NUM_PORTS];
+	enum sja1105_internal_phy_t internal_phy[SJA1105_MAX_NUM_PORTS];
 	const u64 port_speed[SJA1105_SPEED_MAX];
 };
 
@@ -245,6 +258,8 @@ struct sja1105_private {
 	enum sja1105_vlan_state vlan_state;
 	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
+	struct mii_bus *mdio_base_t1;
+	struct mii_bus *mdio_base_tx;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
@@ -274,6 +289,10 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 			   struct netlink_ext_ack *extack);
 void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 
+/* From sja1105_mdio.c */
+int sja1105_mdiobus_register(struct dsa_switch *ds);
+void sja1105_mdiobus_unregister(struct dsa_switch *ds);
+
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
 void sja1105_devlink_teardown(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5e208ca78c4f..20c5dcd8de8d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -175,6 +175,15 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 			continue;
 
 		switch (ports[i].phy_mode) {
+		case PHY_INTERFACE_MODE_INTERNAL:
+			if (priv->info->internal_phy[i] == SJA1105_NO_PHY)
+				goto unsupported;
+
+			mii->xmii_mode[i] = XMII_MODE_MII;
+			if (priv->info->internal_phy[i] == SJA1105_PHY_BASE_TX)
+				mii->special[i] = true;
+
+			break;
 		case PHY_INTERFACE_MODE_MII:
 			if (!priv->info->supports_mii[i])
 				goto unsupported;
@@ -3081,11 +3090,19 @@ static int sja1105_setup(struct dsa_switch *ds)
 		dev_err(ds->dev, "Failed to register PTP clock: %d\n", rc);
 		return rc;
 	}
+
+	rc = sja1105_mdiobus_register(ds);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to register MDIO bus: %pe\n",
+			ERR_PTR(rc));
+		goto out_ptp_clock_unregister;
+	}
+
 	/* Create and send configuration down to device */
 	rc = sja1105_static_config_load(priv, ports);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
-		goto out_ptp_clock_unregister;
+		goto out_mdiobus_unregister;
 	}
 	/* Configure the CGU (PHY link modes and speeds) */
 	rc = priv->info->clocking_setup(priv);
@@ -3128,6 +3145,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 out_devlink_teardown:
 	sja1105_devlink_teardown(ds);
+out_mdiobus_unregister:
+	sja1105_mdiobus_unregister(ds);
 out_ptp_clock_unregister:
 	sja1105_ptp_clock_unregister(ds);
 out_static_config_free:
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
new file mode 100644
index 000000000000..8dfd06318b23
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2021, NXP Semiconductors
+ */
+#include <linux/of_mdio.h>
+#include "sja1105.h"
+
+enum sja1105_mdio_opcode {
+	SJA1105_C45_ADDR = 0,
+	SJA1105_C22 = 1,
+	SJA1105_C45_DATA = 2,
+	SJA1105_C45_DATA_AUTOINC = 3,
+};
+
+static u64 sja1105_base_t1_encode_addr(struct sja1105_private *priv,
+				       int phy, enum sja1105_mdio_opcode op,
+				       int xad)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+
+	return regs->mdio_100base_t1 | (phy << 7) | (op << 5) | (xad << 0);
+}
+
+static int sja1105_base_t1_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	u64 addr;
+	u32 tmp;
+	int rc;
+
+	if (reg & MII_ADDR_C45) {
+		u16 mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+
+		addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C45_ADDR,
+						   mmd);
+
+		tmp = reg & MII_REGADDR_C45_MASK;
+
+		rc = sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+		if (rc < 0)
+			return rc;
+
+		addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C45_DATA,
+						   mmd);
+
+		rc = sja1105_xfer_u32(priv, SPI_READ, addr, &tmp, NULL);
+		if (rc < 0)
+			return rc;
+
+		return tmp & 0xffff;
+	}
+
+	/* Clause 22 read */
+	addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C22, reg & 0x1f);
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, addr, &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+static int sja1105_base_t1_mdio_write(struct mii_bus *bus, int phy, int reg,
+				      u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	u64 addr;
+	u32 tmp;
+	int rc;
+
+	if (reg & MII_ADDR_C45) {
+		u16 mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+
+		addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C45_ADDR,
+						   mmd);
+
+		tmp = reg & MII_REGADDR_C45_MASK;
+
+		rc = sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+		if (rc < 0)
+			return rc;
+
+		addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C45_DATA,
+						   mmd);
+
+		tmp = val & 0xffff;
+
+		rc = sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+		if (rc < 0)
+			return rc;
+
+		return 0;
+	}
+
+	/* Clause 22 write */
+	addr = sja1105_base_t1_encode_addr(priv, phy, SJA1105_C22, reg & 0x1f);
+
+	tmp = val & 0xffff;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
+}
+
+static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 tmp;
+	int rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
+				      u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 tmp = val;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
+				&tmp, NULL);
+}
+
+static int sja1105_mdiobus_base_tx_register(struct sja1105_private *priv,
+					    struct device_node *mdio_node)
+{
+	struct sja1105_mdio_private *mdio_priv;
+	struct device_node *np;
+	struct mii_bus *bus;
+	int rc = 0;
+
+	np = of_find_compatible_node(mdio_node, NULL,
+				     "nxp,sja1110-base-tx-mdio");
+	if (!np)
+		return 0;
+
+	if (!of_device_is_available(np))
+		goto out_put_np;
+
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
+	if (!bus) {
+		rc = -ENOMEM;
+		goto out_put_np;
+	}
+
+	bus->name = "SJA1110 100base-TX MDIO bus";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-base-tx",
+		 dev_name(priv->ds->dev));
+	bus->read = sja1105_base_tx_mdio_read;
+	bus->write = sja1105_base_tx_mdio_write;
+	bus->parent = priv->ds->dev;
+	mdio_priv = bus->priv;
+	mdio_priv->priv = priv;
+
+	rc = of_mdiobus_register(bus, np);
+	if (rc) {
+		mdiobus_free(bus);
+		goto out_put_np;
+	}
+
+	priv->mdio_base_tx = bus;
+
+out_put_np:
+	of_node_put(np);
+
+	return 0;
+}
+
+static void sja1105_mdiobus_base_tx_unregister(struct sja1105_private *priv)
+{
+	if (!priv->mdio_base_tx)
+		return;
+
+	mdiobus_unregister(priv->mdio_base_tx);
+	mdiobus_free(priv->mdio_base_tx);
+	priv->mdio_base_tx = NULL;
+}
+
+static int sja1105_mdiobus_base_t1_register(struct sja1105_private *priv,
+					    struct device_node *mdio_node)
+{
+	struct sja1105_mdio_private *mdio_priv;
+	struct device_node *np;
+	struct mii_bus *bus;
+	int rc = 0;
+
+	np = of_find_compatible_node(mdio_node, NULL,
+				     "nxp,sja1110-base-t1-mdio");
+	if (!np)
+		return 0;
+
+	if (!of_device_is_available(np))
+		goto out_put_np;
+
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
+	if (!bus) {
+		rc = -ENOMEM;
+		goto out_put_np;
+	}
+
+	bus->name = "SJA1110 100base-T1 MDIO bus";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-base-t1",
+		 dev_name(priv->ds->dev));
+	bus->read = sja1105_base_t1_mdio_read;
+	bus->write = sja1105_base_t1_mdio_write;
+	bus->parent = priv->ds->dev;
+	mdio_priv = bus->priv;
+	mdio_priv->priv = priv;
+
+	rc = of_mdiobus_register(bus, np);
+	if (rc) {
+		mdiobus_free(bus);
+		goto out_put_np;
+	}
+
+	priv->mdio_base_t1 = bus;
+
+out_put_np:
+	of_node_put(np);
+
+	return rc;
+}
+
+static void sja1105_mdiobus_base_t1_unregister(struct sja1105_private *priv)
+{
+	if (!priv->mdio_base_t1)
+		return;
+
+	mdiobus_unregister(priv->mdio_base_t1);
+	mdiobus_free(priv->mdio_base_t1);
+	priv->mdio_base_t1 = NULL;
+}
+
+int sja1105_mdiobus_register(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct device_node *switch_node = ds->dev->of_node;
+	struct device_node *mdio_node;
+	int rc;
+
+	mdio_node = of_get_child_by_name(switch_node, "mdios");
+	if (!mdio_node)
+		return 0;
+
+	if (!of_device_is_available(mdio_node))
+		goto out_put_mdio_node;
+
+	if (regs->mdio_100base_tx != SJA1105_RSV_ADDR) {
+		rc = sja1105_mdiobus_base_tx_register(priv, mdio_node);
+		if (rc)
+			goto err_put_mdio_node;
+	}
+
+	if (regs->mdio_100base_t1 != SJA1105_RSV_ADDR) {
+		rc = sja1105_mdiobus_base_t1_register(priv, mdio_node);
+		if (rc)
+			goto err_free_base_tx_mdiobus;
+	}
+
+out_put_mdio_node:
+	of_node_put(mdio_node);
+
+	return 0;
+
+err_free_base_tx_mdiobus:
+	sja1105_mdiobus_base_tx_unregister(priv);
+err_put_mdio_node:
+	of_node_put(mdio_node);
+
+	return rc;
+}
+
+void sja1105_mdiobus_unregister(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	sja1105_mdiobus_base_t1_unregister(priv);
+	sja1105_mdiobus_base_tx_unregister(priv);
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 187c9fbbd397..54ecb5565761 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -436,6 +436,8 @@ static struct sja1105_regs sja1105et_regs = {
 	.ptpclkval = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
 	.ptpclkcorp = 0x1D,
+	.mdio_100base_tx = SJA1105_RSV_ADDR,
+	.mdio_100base_t1 = SJA1105_RSV_ADDR,
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -473,6 +475,8 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.ptpclkrate = 0x1B,
 	.ptpclkcorp = 0x1E,
 	.ptpsyncts = 0x1F,
+	.mdio_100base_tx = SJA1105_RSV_ADDR,
+	.mdio_100base_t1 = SJA1105_RSV_ADDR,
 };
 
 static struct sja1105_regs sja1110_regs = {
@@ -555,6 +559,8 @@ static struct sja1105_regs sja1110_regs = {
 	.ptpclkrate = SJA1110_SPI_ADDR(0x74),
 	.ptpclkcorp = SJA1110_SPI_ADDR(0x80),
 	.ptpsyncts = SJA1110_SPI_ADDR(0x84),
+	.mdio_100base_tx = 0x1c2400,
+	.mdio_100base_t1 = 0x1c1000,
 };
 
 const struct sja1105_info sja1105e_info = {
@@ -785,6 +791,12 @@ const struct sja1105_info sja1110a_info = {
 				   false, false, false, false, false, false},
 	.supports_2500basex	= {false, false, false, true, true,
 				   false, false, false, false, false, false},
+	.internal_phy		= {SJA1105_NO_PHY, SJA1105_PHY_BASE_TX,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1},
 	.name			= "SJA1110A",
 };
 
@@ -824,6 +836,12 @@ const struct sja1105_info sja1110b_info = {
 				   false, false, false, false, false, false},
 	.supports_2500basex	= {false, false, false, true, true,
 				   false, false, false, false, false, false},
+	.internal_phy		= {SJA1105_NO_PHY, SJA1105_PHY_BASE_TX,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_NO_PHY},
 	.name			= "SJA1110B",
 };
 
@@ -863,6 +881,12 @@ const struct sja1105_info sja1110c_info = {
 				   false, false, false, false, false, false},
 	.supports_2500basex	= {false, false, false, false, true,
 				   false, false, false, false, false, false},
+	.internal_phy		= {SJA1105_NO_PHY, SJA1105_PHY_BASE_TX,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY},
 	.name			= "SJA1110C",
 };
 
@@ -900,5 +924,11 @@ const struct sja1105_info sja1110d_info = {
 				   false, false, false, false, false, false},
 	.supports_sgmii		= {false, true, true, true, true,
 				   false, false, false, false, false, false},
+	.internal_phy		= {SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
+				   SJA1105_PHY_BASE_T1, SJA1105_PHY_BASE_T1,
+				   SJA1105_NO_PHY, SJA1105_NO_PHY,
+				   SJA1105_NO_PHY},
 	.name			= "SJA1110D",
 };
-- 
2.25.1

