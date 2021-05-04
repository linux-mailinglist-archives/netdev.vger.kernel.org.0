Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B82373252
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhEDWad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhEDWa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB45C061574;
        Tue,  4 May 2021 15:29:32 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y26so12290136eds.4;
        Tue, 04 May 2021 15:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hU9Fqyvo+WQiZO8Mw7Uir6aN+uf+MCC4pyG3OctBteY=;
        b=Sb6O04Y16nPXOUEuHbWqlpisj4uxrid1QYc9ig//p0q8viNU1W+BnvivMeDVv7ivKA
         jDiK3CZGVnlr6yK+BWUaR8MYV9r4b5ZsDSW18FlwSfjr8hkhdxPaw2wzJI3GODPvGpmY
         hZZ4tjQBWlNU7kXPdM2MXX3DeLh56jqOxp5Kop0SRZ6ab8guqFMVS2+kpmRZUyfNK3vM
         vJ00598NZXhBKbnH1RsTXVaJA4+fIqI/RF1H1gA50sgQ6Y9wlpgQ5U9Pquo6/GysCPJz
         KD7/GwAwTUNzArwM2wceEgeYB7QznxuQ+F2ir+nJRiZlSOR3T+b7CNhKDjSbxyh6yK5t
         v7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hU9Fqyvo+WQiZO8Mw7Uir6aN+uf+MCC4pyG3OctBteY=;
        b=hdTsL6M1ShZPdBabVRjLtRrxELqWuKuvxPDE9sj8DHCSrZziUM8t/1AEOZYD4bMXeh
         aAxKp0Wsq/b+3Myt82UtkxymjXYjmwTOkQZRQwGsbP4eK0PdSIN5Qpl6E1j6Ie7629tV
         BChWBLGbbnvmls9CvdVygINDowO97DyEtz23qrL2n/u4UKOtkT5SSdRpWWrLTLyYj+t2
         FOlE8s6aCc0+wooNb2zJLWNsh7ir+ow70Pv53sG/5O/wxfdpHgJ8PnGgQQRHBuQzWC9K
         FKQ4MphtRJxpO/1iV6Z6CivaERd/QSZwWTupiw52NxRbFJL0a87k6Fe8V/g1EnpDXPlv
         v/RA==
X-Gm-Message-State: AOAM531g/PE6ltJ9MSmbNHbADG95ecVsq4+vtRy0vJ6/rpqpueov7q8G
        sC18g1ZQguANgRPEJ6O7GrGgZSRna3/QoQ==
X-Google-Smtp-Source: ABdhPJyb+jFscBTPXsYn6sOGmEXCpR4nupDqvv4b8r2pb3qY3ky2RfTj6KRg/HcdpbQbbZpIyaxm+A==
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr28462095edb.306.1620167370708;
        Tue, 04 May 2021 15:29:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 05/20] net: dsa: qca8k: handle error with qca8k_read operation
Date:   Wed,  5 May 2021 00:28:59 +0200
Message-Id: <20210504222915.17206-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_read can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 90 +++++++++++++++++++++++++++++++----------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 411b42d38819..cde68ed6856b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -146,12 +146,13 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 static u32
 qca8k_read(struct qca8k_priv *priv, u32 reg)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	val = qca8k_set_page(priv->bus, page);
 	if (val < 0)
@@ -160,8 +161,7 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 
 exit:
-	mutex_unlock(&priv->bus->mdio_lock);
-
+	mutex_unlock(&bus->mdio_lock);
 	return val;
 }
 
@@ -226,8 +226,13 @@ static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	int ret;
 
-	*val = qca8k_read(priv, reg);
+	ret = qca8k_read(priv, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = ret;
 
 	return 0;
 }
@@ -280,15 +285,17 @@ static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
 	unsigned long timeout;
+	u32 val;
 
 	timeout = jiffies + msecs_to_jiffies(20);
 
 	/* loop until the busy flag has cleared */
 	do {
-		u32 val = qca8k_read(priv, reg);
-		int busy = val & mask;
+		val = qca8k_read(priv, reg);
+		if (val < 0)
+			continue;
 
-		if (!busy)
+		if (!(val & mask))
 			break;
 		cond_resched();
 	} while (!time_after_eq(jiffies, timeout));
@@ -296,15 +303,20 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 	return time_after_eq(jiffies, timeout);
 }
 
-static void
+static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
-	u32 reg[4];
+	u32 reg[4], val;
 	int i;
 
 	/* load the ARL table into an array */
-	for (i = 0; i < 4; i++)
-		reg[i] = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
+	for (i = 0; i < 4; i++) {
+		val = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4));
+		if (val < 0)
+			return val;
+
+		reg[i] = val;
+	}
 
 	/* vid - 83:72 */
 	fdb->vid = (reg[2] >> QCA8K_ATU_VID_S) & QCA8K_ATU_VID_M;
@@ -319,6 +331,8 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	fdb->mac[3] = (reg[0] >> QCA8K_ATU_ADDR3_S) & 0xff;
 	fdb->mac[4] = (reg[0] >> QCA8K_ATU_ADDR4_S) & 0xff;
 	fdb->mac[5] = reg[0] & 0xff;
+
+	return 0;
 }
 
 static void
@@ -370,6 +384,8 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
 		reg = qca8k_read(priv, QCA8K_REG_ATU_FUNC);
+		if (reg < 0)
+			return reg;
 		if (reg & QCA8K_ATU_FUNC_FULL)
 			return -1;
 	}
@@ -380,12 +396,15 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 static int
 qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
 {
-	int ret;
+	int ret, ret_read;
 
 	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
 	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
-	if (ret >= 0)
-		qca8k_fdb_read(priv, fdb);
+	if (ret >= 0) {
+		ret_read = qca8k_fdb_read(priv, fdb);
+		if (ret_read < 0)
+			return ret_read;
+	}
 
 	return ret;
 }
@@ -445,6 +464,8 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
 		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
+		if (reg < 0)
+			return reg;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
 			return -ENOMEM;
 	}
@@ -471,6 +492,8 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -502,6 +525,8 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -617,8 +642,11 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 			    QCA8K_MDIO_MASTER_BUSY))
 		return -ETIMEDOUT;
 
-	val = (qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL) &
-		QCA8K_MDIO_MASTER_DATA_MASK);
+	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
+	if (val < 0)
+		return val;
+
+	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
 	return val;
 }
@@ -974,6 +1002,8 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 	u32 reg;
 
 	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+	if (reg < 0)
+		return reg;
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1074,18 +1104,26 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	const struct qca8k_mib_desc *mib;
-	u32 reg, i;
+	u32 reg, i, val;
 	u64 hi;
 
 	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
-		data[i] = qca8k_read(priv, reg);
+		val = qca8k_read(priv, reg);
+		if (val < 0)
+			continue;
+
 		if (mib->size == 2) {
 			hi = qca8k_read(priv, reg + 4);
-			data[i] |= hi << 32;
+			if (hi < 0)
+				continue;
 		}
+
+		data[i] = val;
+		if (mib->size == 2)
+			data[i] |= hi << 32;
 	}
 }
 
@@ -1103,18 +1141,25 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
+	int ret = 0;
 	u32 reg;
 
 	mutex_lock(&priv->reg_mutex);
 	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
+	if (reg < 0) {
+		ret = reg;
+		goto exit;
+	}
+
 	if (eee->eee_enabled)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
 	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
-	mutex_unlock(&priv->reg_mutex);
 
-	return 0;
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
 }
 
 static int
@@ -1439,6 +1484,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	/* read the switches ID register */
 	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
+	if (id < 0)
+		return id;
+
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
 	if (id != QCA8K_ID_QCA8337)
-- 
2.30.2

