Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0E381239
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhENVBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhENVBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:35 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F646C061574;
        Fri, 14 May 2021 14:00:22 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h16so55922edr.6;
        Fri, 14 May 2021 14:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0YFnq7TuUbC+khUcVjnA3EasBDRmOOueSwaKGXSBOS8=;
        b=g4QGTJRzwBO1qqLXhqERVC7WbnlGEe5RFsUeCT8etAXFx8XaHwmkpXmnobmhhulXtl
         RPmGGblFmQpOGIqw2C9ez0mfyWT0VluqvQYa+sg1bGG+U1FZhtKr3ELjoA2PYHQZCFKk
         phojdduIgzRDFh1HRRk//frebOZwSDjvoDdZvUc8rkk0H0bvOe+GjKiUu7Jr7odK59x3
         EnX8NH1+pz67g3MHeaDE7OjUApRDXKp6w3y3DL2A7OFy0ibSGL7IFA2nUgssraMxAYPq
         B+AEKNgN83fA9pHfy3Kg9Xp2zu1UaZxGG3MnESfSS0qeMgiZ8Bk84eOtBdg1sIDrGPmV
         CYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0YFnq7TuUbC+khUcVjnA3EasBDRmOOueSwaKGXSBOS8=;
        b=FbU8sRm1oJ3T+Ks/NDGOufvezsMXjxgTGJquMCW7yQnDzofzAbnoU+yx5zEsnzgW51
         3noX+hlgs5bX2S5rKTrlUmgIn3Gw4Ld7jt6Vl2KcC+vzE7W1IsSaFPUCNPRIACn/rXWw
         pFqPjDY4J5nifpmOn4eUEC0/TK5P8gEajjvrDabWzidrV9LRfoL7NPLhQALSU7CsSTZS
         G4lGCi8Ve20fH6ZTO3IEpw/nZnNNSKPZ6NAwGMV71nYx7aFQiUQLBqNsMuu4FqALmozb
         nTYy9QDtcbvQuTUSRcpCQR6Gbpq+QCf7Ay9tSkcGLQVZG0fL2arMEHw/JTq8OCEdafuO
         LJZQ==
X-Gm-Message-State: AOAM532GVN1jxDGFOPvGqMib/rLNULmydDpCSUp3sIwnChp+lagtuwWM
        x3DoclSngUuA87IcfuMqe9Q=
X-Google-Smtp-Source: ABdhPJxn6DvzgrnO1Wmcdas7MRnwXSBk9BRDAdcA9eqhJDJbO9P1RuUbFz3CtglKU7NIcd8q6ZaY3Q==
X-Received: by 2002:a05:6402:da:: with SMTP id i26mr22335400edu.379.1621026020968;
        Fri, 14 May 2021 14:00:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:20 -0700 (PDT)
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
Subject: [PATCH net-next v6 05/25] net: dsa: qca8k: handle error with qca8k_read operation
Date:   Fri, 14 May 2021 22:59:55 +0200
Message-Id: <20210514210015.18142-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_read can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 73 ++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index c9830286fd6d..5eb4d13fe0ba 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -231,8 +231,13 @@ static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	int ret;
+
+	ret = qca8k_read(priv, reg);
+	if (ret < 0)
+		return ret;
 
-	*val = qca8k_read(priv, reg);
+	*val = ret;
 
 	return 0;
 }
@@ -300,15 +305,20 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 	return ret;
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
@@ -323,6 +333,8 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	fdb->mac[3] = (reg[0] >> QCA8K_ATU_ADDR3_S) & 0xff;
 	fdb->mac[4] = (reg[0] >> QCA8K_ATU_ADDR4_S) & 0xff;
 	fdb->mac[5] = reg[0] & 0xff;
+
+	return 0;
 }
 
 static void
@@ -374,6 +386,8 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
 		reg = qca8k_read(priv, QCA8K_REG_ATU_FUNC);
+		if (reg < 0)
+			return reg;
 		if (reg & QCA8K_ATU_FUNC_FULL)
 			return -1;
 	}
@@ -388,10 +402,10 @@ qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
 
 	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
 	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
-	if (ret >= 0)
-		qca8k_fdb_read(priv, fdb);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	return qca8k_fdb_read(priv, fdb);
 }
 
 static int
@@ -449,6 +463,8 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
 		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
+		if (reg < 0)
+			return reg;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
 			return -ENOMEM;
 	}
@@ -475,6 +491,8 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -506,6 +524,8 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -621,8 +641,11 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
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
@@ -978,6 +1001,8 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 	u32 reg;
 
 	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+	if (reg < 0)
+		return reg;
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1078,18 +1103,26 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
 
@@ -1107,18 +1140,25 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
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
@@ -1443,6 +1483,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
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

