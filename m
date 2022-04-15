Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC945032CF
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356542AbiDOXdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356515AbiDOXcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ACE326F8;
        Fri, 15 Apr 2022 16:30:25 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i27so17573846ejd.9;
        Fri, 15 Apr 2022 16:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3TdbtJ+5CSDsOQsie0cWjR6PVetHa73QZIrGF+LOlaQ=;
        b=cKQmXjx9x7XM22mAG0RpJzmufh3Ml/XIpZl8XcEOp1RhZJOYmlyqd514QK8ebF7ScV
         OCMOkZ9M7EVc0+979AtcsS/JluGqA7NYGkc3TyH1d/wY15JKLebtkhmE/flwU4S8ojoD
         U/8qNE7dNWuf73tkiAwytXj8QyZwgw2fxRVlHOKAsgV5Xtq96C6Q34dnGBGkKClD8wQ3
         NVNd83m6B47j2wwdYv92kx6/XV0jJLp1/eJRl4gAPwV4AtW1XGvOr+nJuVO5TPRPG4y5
         PV2JUmp8Wbtv8Cu5m1TSjpzXQUBIQZHuptIENCzOeg/pI4vzqrskKZANnoICXMZ0pd6g
         VmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3TdbtJ+5CSDsOQsie0cWjR6PVetHa73QZIrGF+LOlaQ=;
        b=KxqYUI+ZMGaHyoTS9vJUDEMXAo48+y92OJHnKnzm7M5qYozkgTUQfUiaZhyhHiYmND
         Sy2AupZ8Y83MZg1l7lQ1UlDTXhFKBGrxxz7wkD7E9zzbLMRgkVNXRql6Xnma6TqK/cVb
         T1UE21j+4/gkbPIWLW1xWcUQtBvdBqotI6T+fgCm8mj06L3QjGEeOj46vb7L3c9EpZ0P
         f+7xDOAuGtmpTyOv1/5UdX/ZF/irqPF/lPFwAevijRan4TPjqGlzytV8hBoa98earXr9
         PzuK3OBlOMiNWuEL38cj67abw/qo5e0+5XrTSeCkWPhWWkWyzYKtSFGSbF+8Mks2XYJX
         GCEg==
X-Gm-Message-State: AOAM532A0roSTQG8yR7s0prly3oxowJHFrSG3B5VO3wecIU/dP3DqHL/
        LUkKISyb6zsfp5jlwxzF/tE=
X-Google-Smtp-Source: ABdhPJzqsjVQ6znu/N9rI2rKDxVe2CkckyAc6+QRRwom0lJMbL6h/lvoxW1DxoYzl7LpAKssIjcOzA==
X-Received: by 2002:a17:907:97cc:b0:6df:83bc:314c with SMTP id js12-20020a17090797cc00b006df83bc314cmr917960ejc.587.1650065423606;
        Fri, 15 Apr 2022 16:30:23 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 3/6] net: dsa: qca8k: rework and simplify mdiobus logic
Date:   Sat, 16 Apr 2022 01:30:14 +0200
Message-Id: <20220415233017.23275-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an attempt to reduce qca8k_priv space, rework and simplify mdiobus
logic.
We now declare a mdiobus instead of relying on DSA phy_read/write even
if a mdio node is not present. This is all to make the qca8k ops static
and not switch specific. With a legacy implementation where port doesn't
have a phy map declared in the dts with a mdio node, we declare a
'qca8k-legacy' mdiobus. The conversion logic is used as legacy read and
write ops are used instead of the internal one.
Also drop the legacy_phy_port_mapping as we now declare mdiobus with ops
that already address the workaround.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 95 +++++++++++++----------------------------
 drivers/net/dsa/qca8k.h |  1 -
 2 files changed, 29 insertions(+), 67 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 766db0d43092..24d57083ee2c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1291,83 +1291,63 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 }
 
 static int
-qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
+qca8k_legacy_mdio_write(struct mii_bus *slave_bus, int port, int regnum, u16 data)
 {
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	/* Check if the legacy mapping should be used and the
-	 * port is not correctly mapped to the right PHY in the
-	 * devicetree
-	 */
-	if (priv->legacy_phy_port_mapping)
-		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
-	/* Use mdio Ethernet when available, fallback to legacy one on error */
-	ret = qca8k_phy_eth_command(priv, false, port, regnum, 0);
-	if (!ret)
-		return ret;
-
-	return qca8k_mdio_write(priv, port, regnum, data);
+	return qca8k_internal_mdio_write(slave_bus, port, regnum, data);
 }
 
 static int
-qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
+qca8k_legacy_mdio_read(struct mii_bus *slave_bus, int port, int regnum)
 {
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
+	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
-	/* Check if the legacy mapping should be used and the
-	 * port is not correctly mapped to the right PHY in the
-	 * devicetree
-	 */
-	if (priv->legacy_phy_port_mapping)
-		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
-
-	/* Use mdio Ethernet when available, fallback to legacy one on error */
-	ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
-	if (ret >= 0)
-		return ret;
-
-	ret = qca8k_mdio_read(priv, port, regnum);
-
-	if (ret < 0)
-		return 0xffff;
-
-	return ret;
+	return qca8k_internal_mdio_read(slave_bus, port, regnum);
 }
 
 static int
-qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
+qca8k_mdio_register(struct qca8k_priv *priv)
 {
 	struct dsa_switch *ds = priv->ds;
+	struct device_node *mdio;
 	struct mii_bus *bus;
 
 	bus = devm_mdiobus_alloc(ds->dev);
-
 	if (!bus)
 		return -ENOMEM;
 
 	bus->priv = (void *)priv;
-	bus->name = "qca8k slave mii";
-	bus->read = qca8k_internal_mdio_read;
-	bus->write = qca8k_internal_mdio_write;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
-		 ds->index);
-
 	bus->parent = ds->dev;
 	bus->phy_mask = ~ds->phys_mii_mask;
-
 	ds->slave_mii_bus = bus;
 
-	return devm_of_mdiobus_register(priv->dev, bus, mdio);
+	/* Check if the devicetree declare the port:phy mapping */
+	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
+	if (of_device_is_available(mdio)) {
+		snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d", ds->index);
+		bus->name = "qca8k slave mii";
+		bus->read = qca8k_internal_mdio_read;
+		bus->write = qca8k_internal_mdio_write;
+		return devm_of_mdiobus_register(priv->dev, bus, mdio);
+	}
+
+	/* If a mapping can't be found the legacy mapping is used,
+	 * using the qca8k_port_to_phy function
+	 */
+	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
+		 ds->dst->index, ds->index);
+	bus->name = "qca8k-legacy slave mii";
+	bus->read = qca8k_legacy_mdio_read;
+	bus->write = qca8k_legacy_mdio_write;
+	return devm_mdiobus_register(priv->dev, bus);
 }
 
 static int
 qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 {
 	u32 internal_mdio_mask = 0, external_mdio_mask = 0, reg;
-	struct device_node *ports, *port, *mdio;
+	struct device_node *ports, *port;
 	phy_interface_t mode;
 	int err;
 
@@ -1429,24 +1409,7 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 					 QCA8K_MDIO_MASTER_EN);
 	}
 
-	/* Check if the devicetree declare the port:phy mapping */
-	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
-	if (of_device_is_available(mdio)) {
-		err = qca8k_mdio_register(priv, mdio);
-		if (err)
-			of_node_put(mdio);
-
-		return err;
-	}
-
-	/* If a mapping can't be found the legacy mapping is used,
-	 * using the qca8k_port_to_phy function
-	 */
-	priv->legacy_phy_port_mapping = true;
-	priv->ops.phy_read = qca8k_phy_read;
-	priv->ops.phy_write = qca8k_phy_write;
-
-	return 0;
+	return qca8k_mdio_register(priv);
 }
 
 static int
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 12d8d090298b..8bbe36f135b5 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -388,7 +388,6 @@ struct qca8k_priv {
 	 * Bit 1: port enabled. Bit 0: port disabled.
 	 */
 	u8 port_enabled_map;
-	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.34.1

