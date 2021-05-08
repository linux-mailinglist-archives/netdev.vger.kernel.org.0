Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5790E376DB8
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEHAam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhEHAab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:31 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B54C061348;
        Fri,  7 May 2021 17:29:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i128so6096355wma.5;
        Fri, 07 May 2021 17:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A0ltW5x1YEbeeKYfwkzjhupdEb1lfOA6ErMl2mGAfo=;
        b=TbNT1XcsS3XC8hMTvPSXMFhAZnMC8u7c8tmDSs+EyeF5am+xh6oUDaeUDf8ebPuCnf
         LP9AFsngg2iKLD6dx4Ld5lyGnJCtkfN0RZKhqnlh/z2VMYtJHBJeqvoyUFReBylcZUm+
         0ZnR8T7JB92b2VZxdjUulNRj+qFpUESbVaaVZ4Q7MdjWEhrLs6p4/b1cWKWn7+mU9MXL
         4cQQI+mAohxPgzWy12Un9mTPYW1WcJWSvDT7W4DNqc6ZjD4yyV9D/7yNaOxOwHCZwumJ
         tH219Fdc9+3vnuPOEBIoFv0ncfKFvN2QT9ktj5KSiVFXGldwUuHiDxs/JHbJDE5+APhH
         uu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A0ltW5x1YEbeeKYfwkzjhupdEb1lfOA6ErMl2mGAfo=;
        b=o3IwY5wtKnR9NxFwpZIxR5mXLt6lN7aa3i7VroL6HA5OwcSdmIYqFAoRh/hXKAQvVw
         QpCv49RwIFMTGgxmw/PXKrOZfVwjCz2yhvEevXRn8uEhYkjZ/tLFWlNvD0OZZieMsMvY
         vnR5aU+mBmmMqLsV9bJQI0/v/AvlYWARFBKf1BZxrCMkuAu2PrevlbUlfCBxCpU4XiCH
         GrSi4kpPxD/TIwboxydbyC75EbIhWp9d0+uVdWw4drAZj2xAMJ7HTomU9qXJxIQhOL7X
         IsN8UJ+Uk33uHVE7Zrf5vRacGZJ8IjN0gIdnUJM+0Lg1fMnQxzVLfb+R5fpWDg6qV0yI
         SenA==
X-Gm-Message-State: AOAM530CKsVylS7qFQjFsaL46UA13OCvSkqy+bauom4xwcMdfn6r+OKH
        v5Bkqa1VPRergm4GyUVfV3nC+57nj8P3UA==
X-Google-Smtp-Source: ABdhPJw5wulzgJQ3mzCKsWjy9ehY3nfx4fy/kJGCzlJzZmTuhsnvOS1K5TUNoNLOaH59PjgWnJyMOA==
X-Received: by 2002:a05:600c:21d3:: with SMTP id x19mr12518411wmj.13.1620433768859;
        Fri, 07 May 2021 17:29:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 10/28] net: dsa: qca8k: handle error with qca8k_rmw operation
Date:   Sat,  8 May 2021 02:29:00 +0200
Message-Id: <20210508002920.19945-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_rmw can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 127 ++++++++++++++++++++++++++--------------
 1 file changed, 84 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0ec95ef16143..16ffff478de0 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -206,6 +206,9 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 		goto exit;
 
 	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	if (ret < 0)
+		goto exit;
+
 	ret &= ~mask;
 	ret |= val;
 	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
@@ -216,16 +219,28 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	return ret;
 }
 
-static void
+static int
 qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, 0, val);
+	int ret;
+
+	ret = qca8k_rmw(priv, reg, 0, val);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
-static void
+static int
 qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, val, 0);
+	int ret;
+
+	ret = qca8k_rmw(priv, reg, val, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int
@@ -573,9 +588,15 @@ qca8k_mib_init(struct qca8k_priv *priv)
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
 
@@ -751,9 +772,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				QCA8K_MDIO_MASTER_EN);
-		return 0;
+		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+				       QCA8K_MDIO_MASTER_EN);
 	}
 
 	priv->ops.phy_read = qca8k_phy_read;
@@ -786,8 +806,12 @@ qca8k_setup(struct dsa_switch *ds)
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
@@ -804,9 +828,12 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Disable forwarding by default on all ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-			  QCA8K_PORT_LOOKUP_MEMBER, 0);
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
@@ -825,28 +852,37 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
-				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			if (ret < 0)
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
+			if (ret < 0)
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
+			if (ret < 0)
+				return ret;
+
 			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
 					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
 					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
@@ -1238,7 +1274,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i;
+	int i, ret;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1246,17 +1282,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
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
+	return ret < 0 ? ret : 0;
 }
 
 static void
@@ -1393,18 +1432,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
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
+	return ret < 0 ? ret : 0;
 }
 
 static int
@@ -1426,16 +1466,17 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		int shift = 16 * (port % 2);
 
-		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift, vlan->vid << shift);
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				0xfff << shift, vlan->vid << shift);
+		if (ret < 0)
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

