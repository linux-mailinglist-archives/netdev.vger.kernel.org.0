Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55104E3687
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiCVCRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiCVCRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D833F2FE7B;
        Mon, 21 Mar 2022 19:14:38 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r7so9569623wmq.2;
        Mon, 21 Mar 2022 19:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3EHoLJoSdzFCxSSo9kxKkBKm6UfZf/in6VghFV4gQE=;
        b=d9clNh88Xr03OWNXSryyPsUu7GQexZqKUYuDy/oH/5eye9sCkvxSTnxCg3Ol5ZrH0V
         pXdUT84HdORYPMiPPK8m7MpX0GoFTDL+tqCxgEEOZEHS24MQiUhEY0rcELziUuzLS7aj
         /+p3Xwjss4+n9IcCEAARwlGHIxf/eqBt/KupOJwmaQseT/9Iiq2ij7eARuysk/yCDIpt
         Bid025XDDvLy/7A+G8Fw3CFy5F/rEn/6IwLTIPEfSpNTsYL7GfoQrudnm4GRVk60L8JL
         n4ZoMc5DvmczW5CmedvcToy/d68qoeiKFbGopQpYmet95AUVfoHQLb/QHvK8VKcJBauQ
         7Hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3EHoLJoSdzFCxSSo9kxKkBKm6UfZf/in6VghFV4gQE=;
        b=2AszPburtKXoccoI0PP6lHYAshio+Jtf/NTMnOUjeIss1xIxkSo/qY+rkyxXK/XTHf
         CfOikAOlF8Uea7AmXOYdkfMMMiTOasDhzHUWMbO7T9VzGTo1084239ntQV7HwypQSXo7
         90oUzbNPnv5X7zxp3yspW/AkhNmaTztGvS9kKcoZaL0UcF7HOCFbudnWNeUgzOjZyksO
         bBduMTsRlDJWV9Y/NknaRyK4oKNenQHXy6QkyVp85r7LdvDJgEF/7NPe3rXce/mpBp25
         ZMjAdRq0jh8jY13OVdBGRmIH3lltif+dSDYo6kV4OLJozp+Rga3GMC4iiNmi7A7qyeFa
         J/4Q==
X-Gm-Message-State: AOAM530uTNIV1GkI97/Z+eGybjQb8aeZTlAlFTNWCUNcACRgjk3/q5R5
        yOjJZKYGQjIPfY5Gbfl8AuQ=
X-Google-Smtp-Source: ABdhPJyd1cR6WcigOKTNAosO0LAEfPzN5vrG4Cw1QMVgbLX5MGTk/apdZEzwzn5uHBe4EMw90yVi2Q==
X-Received: by 2002:a1c:f211:0:b0:381:6c60:742f with SMTP id s17-20020a1cf211000000b003816c60742fmr1654204wmc.130.1647915277340;
        Mon, 21 Mar 2022 19:14:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm177968wrz.2.2022.03.21.19.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:14:37 -0700 (PDT)
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
Subject: [net-next PATCH 3/4] drivers: net: dsa: qca8k: rework and simplify mdiobus logic
Date:   Tue, 22 Mar 2022 02:45:05 +0100
Message-Id: <20220322014506.27872-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220322014506.27872-1-ansuelsmth@gmail.com>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
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
index 33cedae6875c..c837444d37f6 100644
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

