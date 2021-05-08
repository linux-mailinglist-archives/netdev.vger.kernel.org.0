Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7F376DDE
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhEHAch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhEHAbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:31:21 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BCFC061360;
        Fri,  7 May 2021 17:29:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so8034900wmy.5;
        Fri, 07 May 2021 17:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fogw8IcjT8TV14jKFrpaG7JVRrfLzwmnVNQap9rROkA=;
        b=QqhwFaqx728ggmXmnNTJJWph1ML8IRuA0gl5YzcTDWRe/wErQ1nBTq07kb+3+HlUIX
         NgCDA9bKw4zNvZLXK5f3Lvec+1bFezD+Zl4XGbIkd/N3UXVP5lH5xWd9Ic+xA0kNIfOy
         ih8A4ya9ag93361MWcPwyDICqwi9fJTd7fvQ4ri/ye4JV7dFgd5+/h2d3xDFhbKYVTwL
         hQWp+yPhq3ih4snD6fIu841E61cgdJiREFd2Te/bCKrpuOcL3DuF23zUxuIARwkAHYmB
         MDNJSVQpXRhMQPcUkrNhHpDAlDNTvdsetlguPI7eZK43H2CkrJSYbMvCAj1AcU/zH1TF
         fSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fogw8IcjT8TV14jKFrpaG7JVRrfLzwmnVNQap9rROkA=;
        b=R4MWLKfh7G5Cx+T+0wBEN8blV9GDJZov3rRH0zskwX561qo+FS9ib8Am1tQZw2z9CX
         Sh3rdZtTCGMEbHIRh+yNZNpZaPDm3CcrxJKz0Zn8LB0g3mlSR6SBza0AV4ONzRqWBFQw
         Wnl7ScxqpZ2jV3oQEshENgf//jM5ef403XvR3yD4Lr8exXvAE7q6QRWzSaF+mijKAFLh
         ltP9tDPiFnYhXrNMplwxgJlLUEQD4soRUI1d5T4wd1XRxXbBG86OCmjvhMLMbBc8QAg4
         Ry0SMhwNS60dnj+8JR5mpWOl9mWGURSHcxCphj0VJR0I85vtvHeXnc016rF3BCsiI57E
         N0cQ==
X-Gm-Message-State: AOAM533Y4NC6YwaNoXmO4N/CUXTUpQU/1I+I7rY05vIO9RmAIhT7IO1f
        3ZIAJrtcRMIIeOVVwog/CjX4Brq7TkVefg==
X-Google-Smtp-Source: ABdhPJwFhr40ax0mb5uX9wu2eHTNXPt7oDUlc4ydQje2FStzzUhWSvgHAmxqZAesYJWlJLfizpSX1A==
X-Received: by 2002:a1c:a54a:: with SMTP id o71mr13067952wme.172.1620433787013;
        Fri, 07 May 2021 17:29:47 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:46 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 25/28] net: dsa: qca8k: add support for internal phy
Date:   Sat,  8 May 2021 02:29:15 +0200
Message-Id: <20210508002920.19945-25-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to setup_mdio_bus for internal phy declaration. Introduce a
flag to use the legacy port phy mapping by default and use the direct
mapping if a mdio node is detected in the switch node.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 46 +++++++++++++++++++++++++++--------------
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f96579c0bd46..3d195fdd7ed5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -663,19 +663,15 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
+qca8k_mdio_write(struct qca8k_priv *priv, int phy, u32 regnum, u16 data)
 {
 	u16 r1, r2, page;
-	u32 phy, val;
+	u32 val;
 	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
 
-	/* callee is responsible for not passing bad ports,
-	 * but we still would like to make spills impossible.
-	 */
-	phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 	val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
 	      QCA8K_MDIO_MASTER_WRITE | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
@@ -705,19 +701,15 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 }
 
 static int
-qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
+qca8k_mdio_read(struct qca8k_priv *priv, int phy, u32 regnum)
 {
 	u16 r1, r2, page;
-	u32 phy, val;
+	u32 val;
 	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
 
-	/* callee is responsible for not passing bad ports,
-	 * but we still would like to make spills impossible.
-	 */
-	phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 	val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
@@ -758,6 +750,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
 
+	/* Check if the legacy mapping should be used and the
+	 * port is not correctly mapped to the right PHY in the
+	 * devicetree
+	 */
+	if (priv->legacy_phy_port_mapping)
+		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+
 	return qca8k_mdio_write(priv, port, regnum, data);
 }
 
@@ -767,6 +766,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	struct qca8k_priv *priv = ds->priv;
 	int ret;
 
+	/* Check if the legacy mapping should be used and the
+	 * port is not correctly mapped to the right PHY in the
+	 * devicetree
+	 */
+	if (priv->legacy_phy_port_mapping)
+		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+
 	ret = qca8k_mdio_read(priv, port, regnum);
 
 	if (ret < 0)
@@ -779,7 +785,7 @@ static int
 qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 {
 	u32 internal_mdio_mask = 0, external_mdio_mask = 0, reg;
-	struct device_node *ports, *port;
+	struct device_node *ports, *port, *mdio;
 	int err;
 
 	ports = of_get_child_by_name(priv->dev->of_node, "ports");
@@ -800,7 +806,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		if (!dsa_is_user_port(priv->ds, reg))
 			continue;
 
-		if (of_property_read_bool(port, "phy-handle"))
+		if (of_property_read_bool(port, "phy-handle") &&
+		    of_property_match_string(port, "phy-mode", "internal") < 0)
 			external_mdio_mask |= BIT(reg);
 		else
 			internal_mdio_mask |= BIT(reg);
@@ -837,6 +844,14 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 				       QCA8K_MDIO_MASTER_EN);
 	}
 
+	/* Check if the devicetree declare the port:phy mapping
+	 * If a mapping can't be found the legacy mapping is used,
+	 * using the qca8k_port_to_phy function
+	 */
+	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
+	if (!mdio)
+		priv->legacy_phy_port_mapping = true;
+
 	priv->ops.phy_read = qca8k_phy_read;
 	priv->ops.phy_write = qca8k_phy_write;
 	return 0;
@@ -1198,7 +1213,8 @@ qca8k_phylink_validate(struct dsa_switch *ds, int port,
 	case 5:
 		/* Internal PHY */
 		if (state->interface != PHY_INTERFACE_MODE_NA &&
-		    state->interface != PHY_INTERFACE_MODE_GMII)
+		    state->interface != PHY_INTERFACE_MODE_GMII &&
+		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
 			goto unsupported;
 		break;
 	case 6: /* 2nd CPU port / external PHY */
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index d365f85ab34f..ed3b05ad6745 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -255,6 +255,7 @@ struct qca8k_priv {
 	u8 switch_revision;
 	u8 rgmii_tx_delay;
 	u8 rgmii_rx_delay;
+	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

