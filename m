Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F77373257
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhEDWai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhEDWaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:30 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B07FC06174A;
        Tue,  4 May 2021 15:29:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id n25so12284615edr.5;
        Tue, 04 May 2021 15:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FD5LLho7LrvzPoVcZlIgXjZcqC370ucGqEffbg1GURY=;
        b=dZLK7bnON3F/Ou7MMaw14WDrylW/z1ubJndxyhXiLSPtOWESc6f1WGk9V4Sv+U+Z9u
         hfpexjoEoGA0kIPmgXwom7qooMfdlI2FWspnYyUuqE+8Erh6WNlGRWqIOxGjQEc3ob2w
         ZHVC72Gpnc6WonAUg40DNQRHmN8uO6Ko/bPbmIJw/mbI3ZZYXQxAJMQp4wZOEaVGkzaE
         V2IFPPLRDT3LcITCwNaYRwqlk8/2ebFoeim6ZLlDANU5ggMnviaiPfp8LEtWJw3RAhHZ
         sdeNMYby8O1guFqUFYfHAmPpmwepY+Xyc0aOQiFQAqg4KleFuclr7vM+AW9paX8pw4ef
         /tFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FD5LLho7LrvzPoVcZlIgXjZcqC370ucGqEffbg1GURY=;
        b=aMgufI+lEPyCc1jel25FHPIaA6RRp6j4o2wzhfixnRdm02HBaSWbYk+uz2dDPvlcxP
         qXG0F9FAhPHoYcf26hicT08nn/HNXyGRZmMT9VPm7nhzilcJwMPoORmwGA3kf0VcjYrd
         qtq2GslGcWe06SpgHAw2I0zuxoxa3Ft8TWhURTMGidVOZlXnYiO4dpZSHbGaT/HVL6YH
         sVKujV9yKrkltJDGLefBqmhkZarV8csncd7qu+6vlKvzZ1xATLVyDjalMOWA1oYIrlyj
         924+CElZP5H6PC3+O7idrkCORvF9WdzrYiVan/d70dutQ9k8Rjj5GtfwbcNqOky6SDtl
         Zy9g==
X-Gm-Message-State: AOAM532XIpiItMRD5aO9YWyR4vWdFPcEk4o4EB3Blb7BNFkXPb9bxtPo
        O2YiDy6/SsLJ6mdY2+f7QT0=
X-Google-Smtp-Source: ABdhPJzouxki4469ZTTGeu8rpLhK4p6u3aMJh96dQ/uXa9CJI2pACMF/OaV5O6RR0a4aw57qQUZu9Q==
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr20280211edc.233.1620167371878;
        Tue, 04 May 2021 15:29:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:31 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 06/20] net: dsa: qca8k: handle error with qca8k_write operation
Date:   Wed,  5 May 2021 00:29:00 +0200
Message-Id: <20210504222915.17206-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_write can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 112 +++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cde68ed6856b..899bf93118eb 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -165,15 +165,16 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 	return val;
 }
 
-static void
+static int
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	ret = qca8k_set_page(priv->bus, page);
 	if (ret < 0)
@@ -183,6 +184,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 
 exit:
 	mutex_unlock(&priv->bus->mdio_lock);
+	return ret;
 }
 
 static u32
@@ -242,9 +244,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 
-	qca8k_write(priv, reg, val);
-
-	return 0;
+	return qca8k_write(priv, reg, val);
 }
 
 static const struct regmap_range qca8k_readable_ranges[] = {
@@ -365,6 +365,7 @@ static int
 qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and FDB index */
 	reg = QCA8K_ATU_FUNC_BUSY;
@@ -375,7 +376,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
@@ -448,6 +451,7 @@ static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and VLAN index */
 	reg = QCA8K_VTU_FUNC1_BUSY;
@@ -455,7 +459,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
@@ -503,7 +509,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
 				QCA8K_VTU_FUNC0_EG_MODE_S(port);
 
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		return ret;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 
 out:
@@ -546,7 +554,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			return ret;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 	}
 
@@ -556,15 +566,25 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	return ret;
 }
 
-static void
+static int
 qca8k_mib_init(struct qca8k_priv *priv)
 {
+	int ret;
+
 	mutex_lock(&priv->reg_mutex);
 	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
-	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
 	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
-	qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+exit:
 	mutex_unlock(&priv->reg_mutex);
+	return ret;
 }
 
 static void
@@ -601,6 +621,7 @@ static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -614,7 +635,9 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 		QCA8K_MDIO_MASTER_BUSY);
@@ -624,6 +647,7 @@ static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -636,7 +660,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 			    QCA8K_MDIO_MASTER_BUSY))
@@ -767,12 +793,18 @@ qca8k_setup(struct dsa_switch *ds)
 		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
 
 	/* Enable MIB counters */
-	qca8k_mib_init(priv);
+	ret = qca8k_mib_init(priv);
+	if (ret)
+		pr_warn("mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	if (ret) {
+		pr_err("failed enabling QCA header mode");
+		return ret;
+	}
 
 	/* Disable forwarding by default on all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
@@ -784,11 +816,13 @@ qca8k_setup(struct dsa_switch *ds)
 		qca8k_port_set_status(priv, i, 0);
 
 	/* Forward all unknown frames to CPU port for Linux processing */
-	qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+	if (ret)
+		return ret;
 
 	/* Setup connection between CPU port & user ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
@@ -816,16 +850,20 @@ qca8k_setup(struct dsa_switch *ds)
 			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
 				  0xfff << shift,
 				  QCA8K_PORT_VID_DEF << shift);
-			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
+					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			if (ret)
+				return ret;
 		}
 	}
 
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	if (ret)
+		pr_warn("failed setting MTU settings");
 
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
@@ -1141,8 +1179,8 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
-	int ret = 0;
 	u32 reg;
+	int ret;
 
 	mutex_lock(&priv->reg_mutex);
 	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
@@ -1155,7 +1193,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -1285,9 +1323,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	return 0;
+	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -1382,7 +1418,7 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
 	if (ret) {
@@ -1395,9 +1431,11 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 
 		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
 			  0xfff << shift, vlan->vid << shift);
-		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-			    QCA8K_PORT_VLAN_CVID(vlan->vid) |
-			    QCA8K_PORT_VLAN_SVID(vlan->vid));
+		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -1408,7 +1446,7 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 		    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_del(priv, port, vlan->vid);
 	if (ret)
-- 
2.30.2

