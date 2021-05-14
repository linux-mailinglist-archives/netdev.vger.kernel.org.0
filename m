Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF226381251
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhENVCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhENVBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:41 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C6BC061763;
        Fri, 14 May 2021 14:00:24 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h16so56048edr.6;
        Fri, 14 May 2021 14:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJsRMI57ncIOvJdh/F0FVWIsDUDb9TDdkDmIONjb3sM=;
        b=YjJHnMl3gJp6aTFUyeuUZaL04AgsDbHCKEXMVH9CKarG4y269fVx+EdzaO4PYWhzQ0
         /0bn/Xy3/QKQF6fLZqEGhNggsxZkocdWVJTJLkZ7wxkvpR0yzGoCKAgv5YK0D5VroKXX
         wETLIBx4nUdBRZ/WYvA0jEPwh/3EWAhct7etjqapGD5ZvQJNmqp3lCmmzLirnz0VO8ey
         0XNeiPrtPEnyFxBz6m8YRYOAy7/dAcQLpAc0pNee8viUvQsjeJXPFB/8DUdp13tj6MJA
         UKMS0MI84NkTc0633JbP/ihrSVun9qFaTc9qL4v2GUew2FqTiqCGrxsPjwVE9ACC+JIy
         jaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJsRMI57ncIOvJdh/F0FVWIsDUDb9TDdkDmIONjb3sM=;
        b=AfXmi1DAqVqIXLVuxo0mIYTxgu9b6yk/xmmhPnvN/u3lvmLoRTJXo72RfJGnACA5M3
         rzqkI0Jq+fxrFO3Scfmtyt4v8JxilByReWq34EW9aKvywK1tzlDaRr+PcjQ44nCwHYCs
         xlz+APUJEw7jFIrxNao9RimScMV35OIvbkH7x63QP0y3tFn4iBS9TJ/IgYD2AgoOhJwZ
         PKRecVkdgNLsLMmdUbkk+rge149RYIM3Q4ZPl9VNKhi85qvI2BL2yyyDOW1cDPiae2f4
         3eP4cELzoA8C06B5FYkcGC4tj6+x2fTjVLFj+GUlDI4dIqkoILl2Xplsu9IzQAn6Z4uR
         lE2g==
X-Gm-Message-State: AOAM532aIvyB5EhCcjivM44VblcFrWS5mJzHE0ePZ1LLRRwl2mvSASLD
        iGu4xKqevLy7UE77q2w60fg=
X-Google-Smtp-Source: ABdhPJwSCqosQVbGdkMic1ThNjiDd+NHrNnroTHt7I3eGTridUgs9VMXbWIBuDPgHRZboXEfBdZJDQ==
X-Received: by 2002:a05:6402:40c:: with SMTP id q12mr25438166edv.0.1621026023098;
        Fri, 14 May 2021 14:00:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 07/25] net: dsa: qca8k: handle error with qca8k_rmw operation
Date:   Fri, 14 May 2021 22:59:57 +0200
Message-Id: <20210514210015.18142-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_rmw can fail. Rework any user to handle error values and
correctly return. Change qca8k_rmw to return the error code or 0 instead
of the reg value. The reg returned by qca8k_rmw wasn't used anywhere,
so this doesn't cause any functional change.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 133 +++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2fdd7c2e74d5..409f6592048a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -190,12 +190,13 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 	return ret;
 }
 
-static u32
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
+static int
+qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 {
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 ret;
+	u32 val;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
@@ -205,10 +206,15 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	if (ret < 0)
 		goto exit;
 
-	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
-	ret &= ~mask;
-	ret |= val;
-	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	if (val < 0) {
+		ret = val;
+		goto exit;
+	}
+
+	val &= ~mask;
+	val |= write_val;
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -216,16 +222,16 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	return ret;
 }
 
-static void
+static int
 qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, 0, val);
+	return qca8k_rmw(priv, reg, 0, val);
 }
 
-static void
+static int
 qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, val, 0);
+	return qca8k_rmw(priv, reg, val, 0);
 }
 
 static int
@@ -570,12 +576,19 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
 	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
 
+exit:
 	mutex_unlock(&priv->reg_mutex);
 	return ret;
 }
@@ -747,9 +760,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				QCA8K_MDIO_MASTER_EN);
-		return 0;
+		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+				       QCA8K_MDIO_MASTER_EN);
 	}
 
 	priv->ops.phy_read = qca8k_phy_read;
@@ -782,8 +794,12 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Enable CPU Port */
-	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
+			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	if (ret) {
+		dev_err(priv->dev, "failed enabling CPU port");
+		return ret;
+	}
 
 	/* Enable MIB counters */
 	ret = qca8k_mib_init(priv);
@@ -800,9 +816,12 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Disable forwarding by default on all ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-			  QCA8K_PORT_LOOKUP_MEMBER, 0);
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		if (ret)
+			return ret;
+	}
 
 	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
@@ -821,28 +840,37 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
-				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			if (ret)
+				return ret;
 		}
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
 			int shift = 16 * (i % 2);
 
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				  QCA8K_PORT_LOOKUP_MEMBER,
-				  BIT(QCA8K_CPU_PORT));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					QCA8K_PORT_LOOKUP_MEMBER,
+					BIT(QCA8K_CPU_PORT));
+			if (ret)
+				return ret;
 
 			/* Enable ARP Auto-learning by default */
-			qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				      QCA8K_PORT_LOOKUP_LEARN);
+			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					    QCA8K_PORT_LOOKUP_LEARN);
+			if (ret)
+				return ret;
 
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
-			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-				  0xfff << shift,
-				  QCA8K_PORT_VID_DEF << shift);
+			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
+					0xfff << shift,
+					QCA8K_PORT_VID_DEF << shift);
+			if (ret)
+				return ret;
+
 			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
 					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
 					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
@@ -1234,7 +1262,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i;
+	int i, ret;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1242,17 +1270,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		qca8k_reg_set(priv,
-			      QCA8K_PORT_LOOKUP_CTRL(i),
-			      BIT(port));
+		ret = qca8k_reg_set(priv,
+				    QCA8K_PORT_LOOKUP_CTRL(i),
+				    BIT(port));
+		if (ret)
+			return ret;
 		if (i != port)
 			port_mask |= BIT(i);
 	}
+
 	/* Add all other ports to this ports portvlan mask */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
-	return 0;
+	return ret;
 }
 
 static void
@@ -1389,18 +1420,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	if (vlan_filtering) {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
@@ -1422,16 +1454,17 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		int shift = 16 * (port % 2);
 
-		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift, vlan->vid << shift);
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				0xfff << shift, vlan->vid << shift);
+		if (ret)
+			return ret;
+
 		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
 				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
 				  QCA8K_PORT_VLAN_SVID(vlan->vid));
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.30.2

