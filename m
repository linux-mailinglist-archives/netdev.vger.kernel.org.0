Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C88376DBE
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhEHAav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhEHAac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:32 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A432C061347;
        Fri,  7 May 2021 17:29:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l2so10856152wrm.9;
        Fri, 07 May 2021 17:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JQaoOofnwCbW4CXDxXz2ZwRIKiIkC96GHn5RP7Yxqv4=;
        b=CnGlKDlp73oOvsjoBxPMElYCSXtSH/H1xMhflNvOTg/nVJoBKJa6bIxbc3QSqrZeJ3
         leL6+OOHSElLfxHgwBn4FWlwSqzg+bgFyQNr1PKd20XbTMXwYwGWazqv5Bg2x6SPbcTx
         CFwZY26yLD4lRz/X0aseYpoSolspy4Eth5F5uDcKHCP6LoWlHKxIljqQd/4YkDLBpvh0
         7/iaI8Rgbl3/AxBV5ID/+JGtJOEj2jRpmF9pP6EId2Mghv4R8FfZJbYlcXn/HTQZL50S
         wRzswtvfvITi2bEWXMk7gC1bWa6c+WzSlp0Y5rM2C/vL2E5VRLQihg9VtEmy8cyffkJM
         PHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQaoOofnwCbW4CXDxXz2ZwRIKiIkC96GHn5RP7Yxqv4=;
        b=bwtDIgrH8XvRHZ9oWy9YdSNEG+Qm9nK6Zztc1VqKBCeIFlwdRdhKrHsrwFqQLyJIwe
         q46B//ilrbDtCgN7oWk2gXfqa6EhXMud1rEXAwSC9zDonY+WkLvGYMMdJbS4O+XWfP58
         pxsJ0FWx+4CROhC+ZzTO00mCY4wRd21pWkKviJhK6mss5cU+IMHxuk0LRjCa/xNSZOm/
         uuHoGi+/W+7hj5I05A4TBYgjCER+GzEOsjcqjS+v2dHhdYmISBgwtXaU1VIxpYjZ3KVD
         ftTfGrNZWBVHU4DdBtrZxf4d6NPwHwnJKTnl+rS202KBcnwSzbWrintgtSp2HgPqoTA7
         heAw==
X-Gm-Message-State: AOAM531FbTpy13kHE7bGoKcKwMbSZKLL6wocWu8AZH24yRdWvSqX73sX
        5yJLSrEOD3bcugfMrAgN3WI=
X-Google-Smtp-Source: ABdhPJxt9pJtobn/P7+qqbUat75GalRov6l9U6hk9d59A4u/HT+o2p7OlsOCJiwSbj2LxGwDj1s1Tg==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr15672248wre.183.1620433767545;
        Fri, 07 May 2021 17:29:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 09/28] net: dsa: qca8k: handle error with qca8k_write operation
Date:   Sat,  8 May 2021 02:28:59 +0200
Message-Id: <20210508002920.19945-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_write can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 103 ++++++++++++++++++++++++++--------------
 1 file changed, 68 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5087ee8ecebb..0ec95ef16143 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -168,7 +168,7 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 	return val;
 }
 
-static void
+static int
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
@@ -187,6 +187,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
+	return ret;
 }
 
 static u32
@@ -247,9 +248,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 
-	qca8k_write(priv, reg, val);
-
-	return 0;
+	return qca8k_write(priv, reg, val);
 }
 
 static const struct regmap_range qca8k_readable_ranges[] = {
@@ -367,6 +366,7 @@ static int
 qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and FDB index */
 	reg = QCA8K_ATU_FUNC_BUSY;
@@ -377,7 +377,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
@@ -450,6 +452,7 @@ static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and VLAN index */
 	reg = QCA8K_VTU_FUNC1_BUSY;
@@ -457,7 +460,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
@@ -505,7 +510,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
 				QCA8K_VTU_FUNC0_EG_MODE_S(port);
 
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		return ret;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 
 out:
@@ -548,7 +555,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			return ret;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 	}
 
@@ -558,15 +567,21 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
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
 	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
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
@@ -603,6 +618,7 @@ static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -616,7 +632,9 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 		QCA8K_MDIO_MASTER_BUSY);
@@ -626,6 +644,7 @@ static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -638,7 +657,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 			    QCA8K_MDIO_MASTER_BUSY))
@@ -769,12 +790,18 @@ qca8k_setup(struct dsa_switch *ds)
 		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
 
 	/* Enable MIB counters */
-	qca8k_mib_init(priv);
+	ret = qca8k_mib_init(priv);
+	if (ret)
+		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	if (ret) {
+		dev_err(priv->dev, "failed enabling QCA header mode");
+		return ret;
+	}
 
 	/* Disable forwarding by default on all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
@@ -786,11 +813,13 @@ qca8k_setup(struct dsa_switch *ds)
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
@@ -818,16 +847,20 @@ qca8k_setup(struct dsa_switch *ds)
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
+		dev_warn(priv->dev, "failed setting MTU settings");
 
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
@@ -1143,8 +1176,8 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
-	int ret = 0;
 	u32 reg;
+	int ret;
 
 	mutex_lock(&priv->reg_mutex);
 	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
@@ -1157,7 +1190,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -1287,9 +1320,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	return 0;
+	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -1384,7 +1415,7 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
 	if (ret) {
@@ -1397,9 +1428,11 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 
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
@@ -1410,7 +1443,7 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 		    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_del(priv, port, vlan->vid);
 	if (ret)
-- 
2.30.2

