Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B058B393EA0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhE1ITt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:19:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2074 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbhE1ITp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:19:45 -0400
Received: from dggeml705-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FryB46DH7zWnTQ;
        Fri, 28 May 2021 16:13:32 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggeml705-chm.china.huawei.com (10.3.17.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 16:18:09 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 16:18:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next 1/2] net: dsa: qca8k: check return value of read functions correctly
Date:   Fri, 28 May 2021 16:22:39 +0800
Message-ID: <20210528082240.3863991-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210528082240.3863991-1-yangyingliang@huawei.com>
References: <20210528082240.3863991-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current return type of qca8k_mii_read32() and qca8k_read() are
unsigned, it can't be negative, so the return value check is
unuseful. For check the return value correctly, change return
type of the read functions and add a output parameter to store
the read value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/dsa/qca8k.c | 131 +++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 70 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f1b7c4dda13..a8c274227348 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -89,26 +89,26 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
-static u32
-qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum)
+static int
+qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
-	u32 val;
 	int ret;
 
 	ret = bus->read(bus, phy_id, regnum);
 	if (ret >= 0) {
-		val = ret;
+		*val = ret;
 		ret = bus->read(bus, phy_id, regnum + 1);
-		val |= ret << 16;
+		*val |= ret << 16;
 	}
 
 	if (ret < 0) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to read qca8k 32bit register\n");
+		*val = 0;
 		return ret;
 	}
 
-	return val;
+	return 0;
 }
 
 static void
@@ -148,26 +148,26 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	return 0;
 }
 
-static u32
-qca8k_read(struct qca8k_priv *priv, u32 reg)
+static int
+qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
 {
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 val;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	val = qca8k_set_page(bus, page);
-	if (val < 0)
+	ret = qca8k_set_page(bus, page);
+	if (ret < 0)
 		goto exit;
 
-	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	ret = qca8k_mii_read32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
-	return val;
+	return ret;
 }
 
 static int
@@ -208,11 +208,9 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	if (ret < 0)
 		goto exit;
 
-	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
-	if (val < 0) {
-		ret = val;
+	ret = qca8k_mii_read32(bus, 0x10 | r2, r1, &val);
+	if (ret < 0)
 		goto exit;
-	}
 
 	val &= ~mask;
 	val |= write_val;
@@ -240,15 +238,8 @@ static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
-	int ret;
-
-	ret = qca8k_read(priv, reg);
-	if (ret < 0)
-		return ret;
 
-	*val = ret;
-
-	return 0;
+	return qca8k_read(priv, reg, val);
 }
 
 static int
@@ -296,18 +287,18 @@ static struct regmap_config qca8k_regmap_config = {
 static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
+	int ret, ret1;
 	u32 val;
-	int ret;
 
-	ret = read_poll_timeout(qca8k_read, val, !(val & mask),
+	ret = read_poll_timeout(qca8k_read, ret1, !(val & mask),
 				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				priv, reg);
+				priv, reg, &val);
 
 	/* Check if qca8k_read has failed for a different reason
 	 * before returning -ETIMEDOUT
 	 */
-	if (ret < 0 && val < 0)
-		return val;
+	if (ret < 0 && ret1 < 0)
+		return ret1;
 
 	return ret;
 }
@@ -316,13 +307,13 @@ static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
 	u32 reg[4], val;
-	int i;
+	int i, ret;
 
 	/* load the ARL table into an array */
 	for (i = 0; i < 4; i++) {
-		val = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
-		if (val < 0)
-			return val;
+		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
+		if (ret < 0)
+			return ret;
 
 		reg[i] = val;
 	}
@@ -396,9 +387,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
-		reg = qca8k_read(priv, QCA8K_REG_ATU_FUNC);
-		if (reg < 0)
-			return reg;
+		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		if (ret < 0)
+			return ret;
 		if (reg & QCA8K_ATU_FUNC_FULL)
 			return -1;
 	}
@@ -477,9 +468,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
-		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
-		if (reg < 0)
-			return reg;
+		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		if (ret < 0)
+			return ret;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
 			return -ENOMEM;
 	}
@@ -505,11 +496,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	if (ret < 0)
 		goto out;
 
-	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
-	if (reg < 0) {
-		ret = reg;
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
 		goto out;
-	}
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -542,11 +531,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (ret < 0)
 		goto out;
 
-	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
-	if (reg < 0) {
-		ret = reg;
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
 		goto out;
-	}
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -638,19 +625,19 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 {
 	u16 r1, r2, page;
 	u32 val;
-	int ret;
+	int ret, ret1;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	ret = read_poll_timeout(qca8k_mii_read32, val, !(val & mask), 0,
+	ret = read_poll_timeout(qca8k_mii_read32, ret1, !(val & mask), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				bus, 0x10 | r2, r1);
+				bus, 0x10 | r2, r1, &val);
 
 	/* Check if qca8k_read has failed for a different reason
 	 * before returnting -ETIMEDOUT
 	 */
-	if (ret < 0 && val < 0)
-		return val;
+	if (ret < 0 && ret1 < 0)
+		return ret1;
 
 	return ret;
 }
@@ -725,7 +712,7 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 	if (ret)
 		goto exit;
 
-	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	ret = qca8k_mii_read32(bus, 0x10 | r2, r1, &val);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
@@ -733,10 +720,10 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 
 	mutex_unlock(&bus->mdio_lock);
 
-	if (val >= 0)
-		val &= QCA8K_MDIO_MASTER_DATA_MASK;
+	if (ret >= 0)
+		ret = val & QCA8K_MDIO_MASTER_DATA_MASK;
 
-	return val;
+	return ret;
 }
 
 static int
@@ -1141,6 +1128,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg, val;
+	int ret;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1211,7 +1199,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
-		val = qca8k_read(priv, QCA8K_REG_PWS);
+		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
 		if (phylink_autoneg_inband(mode))
 			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 		else
@@ -1219,7 +1207,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, QCA8K_REG_PWS, val);
 
 		/* Configure the SGMII parameters */
-		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
+		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
 
 		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
@@ -1314,10 +1302,11 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg;
+	int ret;
 
-	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
-	if (reg < 0)
-		return reg;
+	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	if (ret < 0)
+		return ret;
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1419,19 +1408,20 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	const struct qca8k_mib_desc *mib;
 	u32 reg, i, val;
-	u64 hi;
+	u64 hi = 0;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
-		val = qca8k_read(priv, reg);
-		if (val < 0)
+		ret = qca8k_read(priv, reg, &val);
+		if (ret < 0)
 			continue;
 
 		if (mib->size == 2) {
-			hi = qca8k_read(priv, reg + 4);
-			if (hi < 0)
+			ret = qca8k_read(priv, reg + 4, (u32 *)&hi);
+			if (ret < 0)
 				continue;
 		}
 
@@ -1459,7 +1449,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
+	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
 	if (reg < 0) {
 		ret = reg;
 		goto exit;
@@ -1793,14 +1783,15 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	const struct qca8k_match_data *data;
 	u32 val;
 	u8 id;
+	int ret;
 
 	/* get the switches ID from the compatible */
 	data = of_device_get_match_data(priv->dev);
 	if (!data)
 		return -ENODEV;
 
-	val = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
-	if (val < 0)
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
 		return -ENODEV;
 
 	id = QCA8K_MASK_CTRL_DEVICE_ID(val & QCA8K_MASK_CTRL_DEVICE_ID_MASK);
-- 
2.25.1

