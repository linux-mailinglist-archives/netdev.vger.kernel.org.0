Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918C4370F92
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhEBXIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhEBXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:12 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAFEC06174A;
        Sun,  2 May 2021 16:07:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u13so1573405edd.3;
        Sun, 02 May 2021 16:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKiBURo81wsJ4/lLUH5a5jR3jUHw4EI7m6JCuTtTWYU=;
        b=OSbLIqidQlgKjpBOsLEzyRcrcOAFEhO1mEnNFns68s3bOoRreDsH/bW9KWmWPcfCNj
         h9w5t8eX9iCo0pDyP0/IlXOXVA+zTYEwINxK29Qp+O6U979CKNu7XSo+598Gzf+MoSBq
         RDZ195yMUKqpFXgyPIh+QLT9UDXGN0/BtF+8wFEdOvXAZBYLvpGJWYqKEAAFttqEoVKM
         De2Ps5zLeEVLL1dha5WcHUQtNwsnQIRIkJ/+JNmcFXgiToHsmF7m2irRlVdRbD1/mouV
         QIsoJRhYlWDGqgKXfANkCOYxjNGFy+V4w9wqRXrNyD2d0nT4g4XpkouAUeZGc+YhoyxI
         aMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKiBURo81wsJ4/lLUH5a5jR3jUHw4EI7m6JCuTtTWYU=;
        b=gjgsbh/P+Fqi+r9Q2iTUyQ1N2yEYrplBamELUUva02/+S50VdvGXEP8pvdzC7+K+9Z
         YWTLty1jdUctIkbw9Z20mP+Y+tQpN/RY0/6y582zrvysddRO7NBGrJKpOL8H4miebeK0
         Lp3c/kPcfTp7PaU8pEzfqlJaJl/V6XzsVks0yMKED1ixoZBwDTfN7Kme//ytqhPnHgLA
         boyKyT+s4M3lT+5pTU+HLRH5k6uBpSyAHgzRvd+BJa2xQislLO63vK2BvqzwgECy//Tl
         XGSoO2W2jZbnKFPscq9a3qlWLxFAXWFpy8snAAVNlR5rDS37MQ97XatoSgaGbgHKiZ/h
         0AsA==
X-Gm-Message-State: AOAM533CZbhrFOeYadVGUpSU0vGY7EsI3n2AoSe4UT4S7pSS2rkhaqKl
        dIyy+tf2Er6AM2LScrxsxqI=
X-Google-Smtp-Source: ABdhPJxtZDkHhPmNEUo0ks36gDCt6lqgG83sGbXC/Rlc73PEIO7SZ2UeFwHOigHfyccEFPnX17JaCw==
X-Received: by 2002:a05:6402:120c:: with SMTP id c12mr17003302edw.98.1619996838103;
        Sun, 02 May 2021 16:07:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 04/17] net: dsa: qca8k: rework read/write/set_page to provide error
Date:   Mon,  3 May 2021 01:06:56 +0200
Message-Id: <20210502230710.30676-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Better handle function qca8k_set_page. Rework read/write function to
return an error and rework the driver to handle error from these
function.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 405 ++++++++++++++++++++++++++--------------
 1 file changed, 269 insertions(+), 136 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cdaf9f85a2cb..0678c213065f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -127,82 +127,105 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 				    "failed to write qca8k 32bit register\n");
 }
 
-static void
+static int
 qca8k_set_page(struct mii_bus *bus, u16 page)
 {
 	if (page == qca8k_current_page)
-		return;
+		return 0;
 
-	if (bus->write(bus, 0x18, 0, page) < 0)
+	if (bus->write(bus, 0x18, 0, page)) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to set qca8k page\n");
+		return -EBUSY;
+	}
+
 	qca8k_current_page = page;
+	return 0;
 }
 
-static u32
-qca8k_read(struct qca8k_priv *priv, u32 reg)
+static int
+qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *ret_val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 val;
+	int ret = 0;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	ret = qca8k_set_page(bus, page);
+	if (ret)
+		goto exit;
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	*ret_val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
-	return val;
+exit:
+	mutex_unlock(&bus->mdio_lock);
+	return ret;
 }
 
-static void
+static int
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
+	int ret = 0;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	ret = qca8k_set_page(bus, page);
+	if (ret)
+		goto exit;
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+
+exit:
+	mutex_unlock(&bus->mdio_lock);
+	return ret;
 }
 
-static u32
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
+static int
+qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val, u32 *ret_val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 ret;
+	int ret = 0;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	ret = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
-	ret &= ~mask;
-	ret |= val;
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);
+	qca8k_set_page(bus, page);
+	if (ret)
+		goto exit;
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	*ret_val = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	*ret_val &= ~mask;
+	*ret_val |= val;
+	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
 
+exit:
+	mutex_unlock(&bus->mdio_lock);
 	return ret;
 }
 
-static void
+static int
 qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, 0, val);
+	u32 ret_val;
+
+	return qca8k_rmw(priv, reg, 0, val, &ret_val);
 }
 
-static void
+static int
 qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, val, 0);
+	u32 ret_val;
+
+	return qca8k_rmw(priv, reg, val, 0, &ret_val);
 }
 
 static int
@@ -210,9 +233,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 
-	*val = qca8k_read(priv, reg);
-
-	return 0;
+	return qca8k_read(priv, reg, val);
 }
 
 static int
@@ -220,9 +241,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 
-	qca8k_write(priv, reg, val);
-
-	return 0;
+	return qca8k_write(priv, reg, val);
 }
 
 static const struct regmap_range qca8k_readable_ranges[] = {
@@ -263,15 +282,18 @@ static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
 	unsigned long timeout;
+	int ret;
+	u32 val;
 
 	timeout = jiffies + msecs_to_jiffies(20);
 
 	/* loop until the busy flag has cleared */
 	do {
-		u32 val = qca8k_read(priv, reg);
-		int busy = val & mask;
+		ret = qca8k_read(priv, reg, &val);
+		if (ret)
+			continue;
 
-		if (!busy)
+		if (!(val & mask))
 			break;
 		cond_resched();
 	} while (!time_after_eq(jiffies, timeout));
@@ -279,15 +301,18 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 	return time_after_eq(jiffies, timeout);
 }
 
-static void
+static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
 	u32 reg[4];
-	int i;
+	int ret, i;
 
 	/* load the ARL table into an array */
-	for (i = 0; i < 4; i++)
-		reg[i] = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
+	for (i = 0; i < 4; i++) {
+		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg + i);
+		if (ret)
+			return ret;
+	}
 
 	/* vid - 83:72 */
 	fdb->vid = (reg[2] >> QCA8K_ATU_VID_S) & QCA8K_ATU_VID_M;
@@ -302,6 +327,8 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	fdb->mac[3] = (reg[0] >> QCA8K_ATU_ADDR3_S) & 0xff;
 	fdb->mac[4] = (reg[0] >> QCA8K_ATU_ADDR4_S) & 0xff;
 	fdb->mac[5] = reg[0] & 0xff;
+
+	return 0;
 }
 
 static void
@@ -334,6 +361,7 @@ static int
 qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and FDB index */
 	reg = QCA8K_ATU_FUNC_BUSY;
@@ -344,7 +372,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
@@ -352,7 +382,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
-		reg = qca8k_read(priv, QCA8K_REG_ATU_FUNC);
+		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		if (ret)
+			return ret;
 		if (reg & QCA8K_ATU_FUNC_FULL)
 			return -1;
 	}
@@ -363,14 +395,17 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 static int
 qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
 {
-	int ret;
+	int ret, ret_val;
 
 	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
-	if (ret >= 0)
-		qca8k_fdb_read(priv, fdb);
+	ret_val = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
+	if (ret_val >= 0) {
+		ret = qca8k_fdb_read(priv, fdb);
+		if (ret)
+			return ret;
+	}
 
-	return ret;
+	return ret_val;
 }
 
 static int
@@ -412,6 +447,7 @@ static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and VLAN index */
 	reg = QCA8K_VTU_FUNC1_BUSY;
@@ -419,7 +455,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
@@ -427,7 +465,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
-		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
+		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		if (ret)
+			return ret;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
 			return -ENOMEM;
 	}
@@ -453,7 +493,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	if (ret < 0)
 		goto out;
 
-	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret)
+		return ret;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -463,7 +505,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
 				QCA8K_VTU_FUNC0_EG_MODE_S(port);
 
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		return ret;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 
 out:
@@ -484,7 +528,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (ret < 0)
 		goto out;
 
-	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret)
+		return ret;
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -504,7 +550,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			return ret;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 	}
 
@@ -514,15 +562,29 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	return ret;
 }
 
-static void
+static int
 qca8k_mib_init(struct qca8k_priv *priv)
 {
+	int ret;
+
 	mutex_lock(&priv->reg_mutex);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
-	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
-	qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+exit:
 	mutex_unlock(&priv->reg_mutex);
+	return ret;
 }
 
 static void
@@ -559,6 +621,7 @@ static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -572,7 +635,9 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 		QCA8K_MDIO_MASTER_BUSY);
@@ -582,6 +647,7 @@ static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -594,14 +660,19 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 			    QCA8K_MDIO_MASTER_BUSY))
 		return -ETIMEDOUT;
 
-	val = (qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL) &
-		QCA8K_MDIO_MASTER_DATA_MASK);
+	ret = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL, &val);
+	if (ret)
+		return ret;
+
+	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
 	return val;
 }
@@ -683,9 +754,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				QCA8K_MDIO_MASTER_EN);
-		return 0;
+		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+				       QCA8K_MDIO_MASTER_EN);
 	}
 
 	priv->ops.phy_read = qca8k_phy_read;
@@ -698,6 +768,7 @@ qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int ret, i;
+	u32 ret_val;
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -718,69 +789,98 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Enable CPU Port */
-	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
+			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	if (ret) {
+		pr_err("failed enabling CPU port");
+		return ret;
+	}
 
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
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-			  QCA8K_PORT_LOOKUP_MEMBER, 0);
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0, &ret_val);
+		if (ret)
+			return ret;
+	}
 
 	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
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
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
-				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds),
+					&ret_val);
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
+					BIT(QCA8K_CPU_PORT), &ret_val);
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
-			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
+					0xfff << shift,
+					QCA8K_PORT_VID_DEF << shift,
+					&ret_val);
+			if (ret)
+				return ret;
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
@@ -857,7 +957,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
-		val = qca8k_read(priv, QCA8K_REG_PWS);
+		qca8k_read(priv, QCA8K_REG_PWS, &val);
 		if (phylink_autoneg_inband(mode))
 			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 		else
@@ -865,7 +965,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, QCA8K_REG_PWS, val);
 
 		/* Configure the SGMII parameters */
-		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
+		qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
 
 		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
@@ -955,8 +1055,11 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg;
+	int ret;
 
-	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	if (ret)
+		return ret;
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1057,18 +1160,27 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	const struct qca8k_mib_desc *mib;
-	u32 reg, i;
+	u32 reg, i, val;
+	int ret;
 	u64 hi;
 
 	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
-		data[i] = qca8k_read(priv, reg);
+		ret = qca8k_read(priv, reg, &val);
+		if (ret)
+			continue;
+
 		if (mib->size == 2) {
-			hi = qca8k_read(priv, reg + 4);
-			data[i] |= hi << 32;
+			ret = qca8k_read(priv, reg + 4, (u32 *)&hi);
+			if (ret)
+				continue;
 		}
+
+		data[i] = val;
+		if (mib->size == 2)
+			data[i] |= hi << 32;
 	}
 }
 
@@ -1087,17 +1199,22 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
 	u32 reg;
+	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
+	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
+	if (ret)
+		goto exit;
+
 	if (eee->eee_enabled)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
-	mutex_unlock(&priv->reg_mutex);
+	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
 
-	return 0;
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
 }
 
 static int
@@ -1111,7 +1228,7 @@ static void
 qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u32 stp_state;
+	u32 stp_state, ret_val;
 
 	switch (state) {
 	case BR_STATE_DISABLED:
@@ -1133,7 +1250,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 	}
 
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
+		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state,
+		  &ret_val);
 }
 
 static int
@@ -1141,7 +1259,8 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i;
+	u32 ret_val;
+	int i, ret;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1149,23 +1268,26 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
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
-	/* Add all other ports to this ports portvlan mask */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
-	return 0;
+	/* Add all other ports to this ports portvlan mask */
+	return qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			 QCA8K_PORT_LOOKUP_MEMBER, port_mask,
+			 &ret_val);
 }
 
 static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u32 ret_val;
 	int i;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
@@ -1183,7 +1305,8 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	 * this port
 	 */
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(QCA8K_CPU_PORT));
+		  QCA8K_PORT_LOOKUP_MEMBER, BIT(QCA8K_CPU_PORT),
+		  &ret_val);
 }
 
 static int
@@ -1223,9 +1346,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	return 0;
+	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -1298,18 +1419,22 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
+	u32 ret_val;
+	int ret;
 
 	if (vlan_filtering) {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE,
+				&ret_val);
 	} else {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE,
+				&ret_val);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
@@ -1320,7 +1445,8 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	u32 ret_val;
+	int ret;
 
 	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
 	if (ret) {
@@ -1331,14 +1457,17 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		int shift = 16 * (port % 2);
 
-		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift, vlan->vid << shift);
-		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-			    QCA8K_PORT_VLAN_CVID(vlan->vid) |
-			    QCA8K_PORT_VLAN_SVID(vlan->vid));
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				0xfff << shift, vlan->vid << shift,
+				&ret_val);
+		if (ret)
+			return ret;
+		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				  QCA8K_PORT_VLAN_SVID(vlan->vid));
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
@@ -1394,6 +1523,7 @@ static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
 	struct qca8k_priv *priv;
+	int ret;
 	u32 id;
 
 	/* allocate the private data struct so that we can probe the switches
@@ -1421,7 +1551,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	}
 
 	/* read the switches ID register */
-	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &id);
+	if (ret)
+		return ret;
+
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
 	if (id != QCA8K_ID_QCA8337)
-- 
2.30.2

