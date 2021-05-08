Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA8C376DB5
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhEHAah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhEHAaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C1C061343;
        Fri,  7 May 2021 17:29:27 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s8so10862635wrw.10;
        Fri, 07 May 2021 17:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tMn90SdNiJQ9BYEL5X0pl9n0f0tRwO21zLMYNU9ng7g=;
        b=iFZck3cyfiSeTkxJ7L1f1iF7Ggb/BtDVD+FVCSdV2msiA/dcHf8SJmorOWJ68MPgty
         T50BFsM6/S3W6GQsRuqWjImynr+0pOydz4F8Ax/Rd6v47+p4kg+HHOJjd9MGuqtOm7qE
         /pp3yNIJGcFMQ3l1kXsHOQgVd2OJaV4D0C9AVcyXkatT04CnCr1vBGYvDlXVA80kKZnf
         xnFAZpcnRhT21VUETVb0Fe6n6HpMql3qIPyw7KaZfWZVzA1RQae8hvdl3R0svRXW298x
         awNLu+PQKg6N2dDUZWG6cG+jJwUwolI3MIL1r7CiIlPJZrZlS5SH/agTqgbPgO43fEqv
         n5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tMn90SdNiJQ9BYEL5X0pl9n0f0tRwO21zLMYNU9ng7g=;
        b=t3uJBK1scKAEzFlF7SIAn6SOABTEusn2zWpl94zY/HX+/VXJiI4wq10ZJNRgtropg4
         +aBh6efC44KD8e+ovVPRGJE+St8U/Mc1c6MdCTpwvO4URUhA0l3SGmiu+yBnCFYxfDOg
         nyK0rmkPvBuXuwVWZrFwKpO7krOZsVDUXUeGRjogJFVp2/ArW6lspq/crOup9XseXw1t
         qiHO3KQm5Z3yJ8XbgSNoCqwRyCy8U7IPA7Mi7w5gFq3SFB50XPikhSHucO9GixlsJDYf
         CI60A9Z5xCLD9PAtIdLfplnV1JoqJ1PpXuOpM/2x4gKwMY1gTuvCXalIaXBF9U+zuiP5
         fziQ==
X-Gm-Message-State: AOAM530i9Ui3eVe/ukxGuPJ/e8YByTEARo6CwAa0UU7115cmqbv/wF6I
        x69nNjjDldIicuf+0LjkbVc=
X-Google-Smtp-Source: ABdhPJxuP5ONoiZedddFhQOzQeMfEVYIMYUI9t2iTXGDg7othihNBXEhTnCMKcjavzpwhuHAXe5CTQ==
X-Received: by 2002:a5d:54c9:: with SMTP id x9mr15341665wrv.91.1620433766271;
        Fri, 07 May 2021 17:29:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:26 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 08/28] net: dsa: qca8k: handle error with qca8k_read operation
Date:   Sat,  8 May 2021 02:28:58 +0200
Message-Id: <20210508002920.19945-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_read can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 76 +++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1c52d1b262f1..5087ee8ecebb 100644
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
@@ -384,12 +398,15 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
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
@@ -449,6 +466,8 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
 		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
+		if (reg < 0)
+			return reg;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
 			return -ENOMEM;
 	}
@@ -475,6 +494,8 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -506,6 +527,8 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	if (reg < 0)
+		return reg;
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -621,8 +644,11 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
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
@@ -978,6 +1004,8 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 	u32 reg;
 
 	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+	if (reg < 0)
+		return reg;
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1078,18 +1106,26 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
 
@@ -1107,18 +1143,25 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
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
@@ -1443,6 +1486,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
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

