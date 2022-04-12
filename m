Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD84FE74A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358438AbiDLRjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351686AbiDLRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C76B62133;
        Tue, 12 Apr 2022 10:36:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p15so38745448ejc.7;
        Tue, 12 Apr 2022 10:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BTPgW2n9sf+20ModHaYtKLOVMmWh29ezrmm/S2xE800=;
        b=mvLURYCtwj5+cvgf3AXN4d+Ozqm804p4BiZ8YnrRHm8qN2f89RaShSm+wnfiHpnKaf
         4xQey8Miss5tuRgNbkWPJHwY7cQBi8AoA04vU5gsL+7PsvxJjrsZl0CvAAbapJ1UifZk
         bPQj18l+XzJbPuS52aJreVSUnEeW7mc9sNKAI9267bWfjeZ5IhFk69s7NPuUX1zAk3bh
         tzkfNWcv8Oz3YqdYAJTIRc8LX1NW8/TKbqnqFcMSftR8WnYFlD77+0yHf638MqZ2yCs7
         M6tqIVhqzQV1N41TM7TM4BHh+qY/HqxXFPNKzI1tzpXd5lKtgQzJGkUzq8y0VpMPygpv
         rmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTPgW2n9sf+20ModHaYtKLOVMmWh29ezrmm/S2xE800=;
        b=OEmFjXFy6Ox+6SVBzka/yuI5xV82C85UUDpfBqRTLjY+RGlexWUOMgsDonDAQWe5Ez
         7mZjXXOgLjDpBuIF7XyHDxufv9mbEBwfil0h/W7/K3X8YGiv/K0PXEQowZP6JtVZ37ii
         fFj0+6yDprk9WUhJwHRJRIfg/vKqXRnxjdcdnutDWydK6ka+RzNT3sLiEZeFQ0f7vK6j
         4TiHr8ogH9IAOnJni0L5lPLWzhRlxX52t/Hno19etwj2vrfUPch2XLRE1oWHdIKwCCXN
         jUC7/X9MS7vbCC8PF1FJ/lyb//puy4PC5aYO3YFZ9rsO+kFirPTeoFYPsVO8aQl9yO/8
         HuhQ==
X-Gm-Message-State: AOAM532ZbMUZg2mQMU4FroJcBZDt9jR8Oah3UO/bYWVfEIolYt3kEc9m
        JWp59lHHTGerDrdAcG4lhlc=
X-Google-Smtp-Source: ABdhPJxPWGLES0RgMU8bPM2nfkq8a026Lgl6rBOGDO6Q2BViGc2/VmpvNqkTl7LWfWYGpHNKQk57wA==
X-Received: by 2002:a17:906:b155:b0:6c9:ea2d:3363 with SMTP id bt21-20020a170906b15500b006c9ea2d3363mr35159153ejb.729.1649785013021;
        Tue, 12 Apr 2022 10:36:53 -0700 (PDT)
Received: from localhost.localdomain ([5.171.105.8])
        by smtp.googlemail.com with ESMTPSA id n11-20020a50cc4b000000b0041d8bc4f076sm48959edi.79.2022.04.12.10.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:36:52 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 3/4] drivers: net: dsa: qca8k: rework and simplify mdiobus logic
Date:   Tue, 12 Apr 2022 19:30:18 +0200
Message-Id: <20220412173019.4189-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412173019.4189-1-ansuelsmth@gmail.com>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
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
While at it also improve the bus id to support multiple switch.
Also drop the legacy_phy_port_mapping as we now declare mdiobus with ops
that already address the workaround.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 101 ++++++++++++++--------------------------
 drivers/net/dsa/qca8k.h |   1 -
 2 files changed, 34 insertions(+), 68 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5f447b586cfa..9c4c5af79f9a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1287,87 +1287,71 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 	if (ret >= 0)
 		return ret;
 
-	return qca8k_mdio_read(priv, phy, regnum);
+	ret = qca8k_mdio_read(priv, phy, regnum);
+
+	if (ret < 0)
+		return 0xffff;
+
+	return ret;
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
-
-	/* Use mdio Ethernet when available, fallback to legacy one on error */
-	ret = qca8k_phy_eth_command(priv, false, port, regnum, 0);
-	if (!ret)
-		return ret;
+	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
-	return qca8k_mdio_write(priv, port, regnum, data);
+	return qca8k_internal_mdio_write(slave_bus, port, regnum, data);
 }
 
 static int
-qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
+qca8k_legacy_mdio_read(struct mii_bus *slave_bus, int port, int regnum)
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
+	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 
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
+	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
+		 ds->dst->index, ds->index);
 	bus->parent = ds->dev;
 	bus->phy_mask = ~ds->phys_mii_mask;
-
 	ds->slave_mii_bus = bus;
 
-	return devm_of_mdiobus_register(priv->dev, bus, mdio);
+	/* Check if the devicetree declare the port:phy mapping */
+	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
+	if (of_device_is_available(mdio)) {
+		bus->name = "qca8k slave mii";
+		bus->read = qca8k_internal_mdio_read;
+		bus->write = qca8k_internal_mdio_write;
+		return devm_of_mdiobus_register(priv->dev, bus, mdio);
+	}
+
+	/* If a mapping can't be found the legacy mapping is used,
+	 * using the qca8k_port_to_phy function
+	 */
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
 
@@ -1429,24 +1413,7 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
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

