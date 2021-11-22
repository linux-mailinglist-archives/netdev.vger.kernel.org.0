Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A840A45879F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhKVBHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbhKVBHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA7C061574;
        Sun, 21 Nov 2021 17:04:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x6so57705872edr.5;
        Sun, 21 Nov 2021 17:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZTDB1MttD7rFw8cEyShd6m4+OwJBp+BwQf1CMiAak4=;
        b=oaOf3bvhMYEQnB/KHMRbDOU/FQOntlZlvxQADC5X+3wlKSIYbOCPQ1uWosvz4Sqi1+
         h5DiKDoxA+jnakL10Nx7XanzEKpDFaJtyoABH1LQOf/9cA1Y4WnA+A3e3LHXeUKYLnb+
         Ij+0ILlEFRrdqrxW7gpOhI9TtL64efVHzhyB1evDQftJwaFBQiDnq5tyuMiSnO7sRQd0
         gkpT/uem5dhguNQ5G+kJF501m7hlPIQWfcy70TASuch0cc9bfePcjb/RIm4bRqK8Pf6c
         B9BZeE+CyuTwODBDbSCfZxsTt0/4SXV5LGUJ2zjFtU6nFphvrnWkWxI5OGgStclxGyr7
         cQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZTDB1MttD7rFw8cEyShd6m4+OwJBp+BwQf1CMiAak4=;
        b=IIPDbkarYaV2pYpgPfRl3JMrqvLH/fyw3omKyT4i9ugRYCQobul0BL7rN1MNtjmg1p
         iR4upsJlKtAKPCRjdBplQ+cz+ITeuujwaJHBFOjKCokPmo9MRGqoOD+i2Ko5NZoA1O+2
         VmqUc9e/1c6UdsNPTIw0BgXaSiK+UIu3Jz3fkDI2npW1VTnV6+UIEI2ird05gfUo0L2e
         63a6+HW1pynppd0CzjJ/yuToQ7i/uACDtN1YlW2twvkyWzTti07c5mEoN1QVFUnBD0bw
         RSA3MYFwcX8fOPMGh1Mm2/2+oy6sH37VEgWUPCIlqarL0u+XQjpIxRYRLfEiKkN2b0hn
         8Eow==
X-Gm-Message-State: AOAM531gfULMlTm733lTcgQ00h7R+gITHUqrxDbAxMJ5pODHKrKBa659
        hHoQMKT/UUzUwNMWAlzkEm2SurDkPWk=
X-Google-Smtp-Source: ABdhPJwyZzaRPMlQSW1MHY8vct/08uXkOugb2PmR0BRP7ixvdl5JcnhT2gJqXymV3LR7jv9QhCyD1w==
X-Received: by 2002:a17:907:1c15:: with SMTP id nc21mr35862381ejc.510.1637543043628;
        Sun, 21 Nov 2021 17:04:03 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:03 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 5/9] net: dsa: qca8k: convert qca8k to regmap helper
Date:   Mon, 22 Nov 2021 02:03:09 +0100
Message-Id: <20211122010313.24944-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
missing config to regmap_config struct.
Ipq40xx SoC have the internal switch based on the qca8k regmap but use
mmio for read/write/rmw operation instead of mdio.
In preparation for the support of this internal switch, convert the
driver to regmap API to later split the driver to common and specific
code. The overhead introduced by the use of regamp API is marginal as the
internal mdio will bypass it by using its direct access and regmap will be
used only by configuration functions or fdb access.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 289 ++++++++++++++++++----------------------
 1 file changed, 131 insertions(+), 158 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 52fca800e6f7..159a1065e66b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -10,6 +10,7 @@
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/bitfield.h>
+#include <linux/regmap.h>
 #include <net/dsa.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
@@ -150,8 +151,9 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 }
 
 static int
-qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
+qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -172,8 +174,9 @@ qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
 }
 
 static int
-qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
+qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -194,8 +197,9 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 }
 
 static int
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
 {
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
@@ -223,34 +227,6 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return ret;
 }
 
-static int
-qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return qca8k_rmw(priv, reg, 0, val);
-}
-
-static int
-qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return qca8k_rmw(priv, reg, val, 0);
-}
-
-static int
-qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
-
-	return qca8k_read(priv, reg, val);
-}
-
-static int
-qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
-
-	return qca8k_write(priv, reg, val);
-}
-
 static const struct regmap_range qca8k_readable_ranges[] = {
 	regmap_reg_range(0x0000, 0x00e4), /* Global control */
 	regmap_reg_range(0x0100, 0x0168), /* EEE control */
@@ -282,26 +258,19 @@ static struct regmap_config qca8k_regmap_config = {
 	.max_register = 0x16ac, /* end MIB - Port6 range */
 	.reg_read = qca8k_regmap_read,
 	.reg_write = qca8k_regmap_write,
+	.reg_update_bits = qca8k_regmap_update_bits,
 	.rd_table = &qca8k_readable_table,
+	.disable_locking = true, /* Locking is handled by qca8k read/write */
+	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
 static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
-	int ret, ret1;
 	u32 val;
 
-	ret = read_poll_timeout(qca8k_read, ret1, !(val & mask),
-				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				priv, reg, &val);
-
-	/* Check if qca8k_read has failed for a different reason
-	 * before returning -ETIMEDOUT
-	 */
-	if (ret < 0 && ret1 < 0)
-		return ret1;
-
-	return ret;
+	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
+				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
 }
 
 static int
@@ -312,7 +281,7 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 
 	/* load the ARL table into an array */
 	for (i = 0; i < 4; i++) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
+		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
 		if (ret < 0)
 			return ret;
 
@@ -359,7 +328,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 
 	/* load the array into the ARL table */
 	for (i = 0; i < 3; i++)
-		qca8k_write(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
+		regmap_write(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
 }
 
 static int
@@ -377,7 +346,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_ATU_FUNC, reg);
 	if (ret)
 		return ret;
 
@@ -388,7 +357,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_FUNC, &reg);
 		if (ret < 0)
 			return ret;
 		if (reg & QCA8K_ATU_FUNC_FULL)
@@ -458,7 +427,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
 
 	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC1, reg);
 	if (ret)
 		return ret;
 
@@ -469,7 +438,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC1, &reg);
 		if (ret < 0)
 			return ret;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
@@ -497,7 +466,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	if (ret < 0)
 		goto out;
 
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
 	if (ret < 0)
 		goto out;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
@@ -507,7 +476,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	else
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
 
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
 	if (ret)
 		goto out;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
@@ -530,7 +499,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (ret < 0)
 		goto out;
 
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
 	if (ret < 0)
 		goto out;
 	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
@@ -550,7 +519,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
 		if (ret)
 			goto out;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
@@ -568,7 +537,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -576,11 +545,11 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
 	if (ret)
 		goto exit;
 
-	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+	ret = regmap_write(priv->regmap, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -597,9 +566,9 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
 
 	if (enable)
-		qca8k_reg_set(priv, QCA8K_REG_PORT_STATUS(port), mask);
+		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 	else
-		qca8k_reg_clear(priv, QCA8K_REG_PORT_STATUS(port), mask);
+		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
 }
 
 static u32
@@ -861,8 +830,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				       QCA8K_MDIO_MASTER_EN);
+		return regmap_clear_bits(priv->regmap, QCA8K_MDIO_MASTER_CTRL,
+					 QCA8K_MDIO_MASTER_EN);
 	}
 
 	/* Check if the devicetree declare the port:phy mapping */
@@ -903,10 +872,10 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 		mask |= QCA8K_MAC_PWR_RGMII1_1_8V;
 
 	if (mask) {
-		ret = qca8k_rmw(priv, QCA8K_REG_MAC_PWR_SEL,
-				QCA8K_MAC_PWR_RGMII0_1_8V |
-				QCA8K_MAC_PWR_RGMII1_1_8V,
-				mask);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_MAC_PWR_SEL,
+					 QCA8K_MAC_PWR_RGMII0_1_8V |
+					 QCA8K_MAC_PWR_RGMII1_1_8V,
+					 mask);
 	}
 
 	return ret;
@@ -947,8 +916,9 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 		if (data->reduced_package)
 			val |= QCA8327_PWS_PACKAGE148_EN;
 
-		ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8327_PWS_PACKAGE148_EN,
-				val);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_PWS,
+					 QCA8327_PWS_PACKAGE148_EN,
+					 val);
 		if (ret)
 			return ret;
 	}
@@ -965,9 +935,10 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 		val |= QCA8K_PWS_LED_OPEN_EN_CSR;
 	}
 
-	return qca8k_rmw(priv, QCA8K_REG_PWS,
-			QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL,
-			val);
+	return regmap_update_bits(priv->regmap, QCA8K_REG_PWS,
+				  QCA8K_PWS_LED_OPEN_EN_CSR |
+				  QCA8K_PWS_POWER_ON_SEL,
+				  val);
 }
 
 static int
@@ -1099,16 +1070,16 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Make sure MAC06 is disabled */
-	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
-			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
+	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
+				QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
 	if (ret) {
 		dev_err(priv->dev, "failed disabling MAC06 exchange");
 		return ret;
 	}
 
 	/* Enable CPU Port */
-	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+			      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
 	if (ret) {
 		dev_err(priv->dev, "failed enabling CPU port");
 		return ret;
@@ -1122,16 +1093,18 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Initial setup of all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+					 QCA8K_PORT_LOOKUP_MEMBER, 0);
 		if (ret)
 			return ret;
 
 		/* Enable QCA header mode on all cpu ports */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK, QCA8K_PORT_HDR_CTRL_ALL) |
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK, QCA8K_PORT_HDR_CTRL_ALL));
+			ret = regmap_write(priv->regmap, QCA8K_REG_PORT_HDR_CTRL(i),
+					   FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK,
+						      QCA8K_PORT_HDR_CTRL_ALL) |
+					   FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK,
+						      QCA8K_PORT_HDR_CTRL_ALL));
 			if (ret) {
 				dev_err(priv->dev, "failed enabling QCA header mode");
 				return ret;
@@ -1147,11 +1120,11 @@ qca8k_setup(struct dsa_switch *ds)
 	 * Notice that in multi-cpu config only one port should be set
 	 * for igmp, unknown, multicast and broadcast packet
 	 */
-	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
+	ret = regmap_write(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL1,
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
 	if (ret)
 		return ret;
 
@@ -1161,38 +1134,38 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+						 QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
 		}
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(cpu_port));
+			ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+						 QCA8K_PORT_LOOKUP_MEMBER,
+						 BIT(cpu_port));
 			if (ret)
 				return ret;
 
 			/* Enable ARP Auto-learning by default */
-			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					    QCA8K_PORT_LOOKUP_LEARN);
+			ret = regmap_set_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+					      QCA8K_PORT_LOOKUP_LEARN);
 			if (ret)
 				return ret;
 
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
-			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-					QCA8K_EGREES_VLAN_PORT_MASK(i),
-					QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
+			ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(i),
+						 QCA8K_EGREES_VLAN_PORT_MASK(i),
+						 QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
 			if (ret)
 				return ret;
 
-			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(i),
+					   QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+					   QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
 			if (ret)
 				return ret;
 		}
@@ -1226,18 +1199,18 @@ qca8k_setup(struct dsa_switch *ds)
 					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
 					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
 			}
-			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+			regmap_write(priv->regmap, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
 
 			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
 			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
 			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
 			QCA8K_PORT_HOL_CTRL1_WRED_EN;
-			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
-				  QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
-				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
-				  mask);
+			regmap_update_bits(priv->regmap, QCA8K_REG_PORT_HOL_CTRL1(i),
+					   QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
+					   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+					   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+					   QCA8K_PORT_HOL_CTRL1_WRED_EN,
+					   mask);
 		}
 
 		/* Set initial MTU for every port.
@@ -1255,14 +1228,14 @@ qca8k_setup(struct dsa_switch *ds)
 	if (priv->switch_id == QCA8K_ID_QCA8327) {
 		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
 		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
-		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
-			  QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
-			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
-			  mask);
+		regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FC_THRESH,
+				   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
+				   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
+				   mask);
 	}
 
 	/* Setup our port MTUs to match power on defaults */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	ret = regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
 	if (ret)
 		dev_warn(priv->dev, "failed setting MTU settings");
 
@@ -1305,12 +1278,12 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
 	}
 
 	/* Set RGMII delay based on the selected values */
-	ret = qca8k_rmw(priv, reg,
-			QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
-			QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
-			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
-			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
-			val);
+	ret = regmap_update_bits(priv->regmap, reg,
+				 QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
+				 QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
+				 QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+				 QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
+				 val);
 	if (ret)
 		dev_err(priv->dev, "Failed to set internal delay for CPU port%d",
 			cpu_port_index == QCA8K_CPU_PORT0 ? 0 : 6);
@@ -1371,7 +1344,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
+		regmap_write(priv->regmap, reg, QCA8K_PORT_PAD_RGMII_EN);
 
 		/* Configure rgmii delay */
 		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
@@ -1381,26 +1354,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		 * rather than individual port registers.
 		 */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
-			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+			regmap_write(priv->regmap, QCA8K_REG_PORT5_PAD_CTRL,
+				     QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
 		/* Enable SGMII on the port */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
+		regmap_write(priv->regmap, reg, QCA8K_PORT_PAD_SGMII_EN);
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
-		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+		ret = regmap_read(priv->regmap, QCA8K_REG_PWS, &val);
 		if (ret)
 			return;
 		if (phylink_autoneg_inband(mode))
 			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 		else
 			val |= QCA8K_PWS_SERDES_AEN_DIS;
-		qca8k_write(priv, QCA8K_REG_PWS, val);
+		regmap_write(priv->regmap, QCA8K_REG_PWS, val);
 
 		/* Configure the SGMII parameters */
-		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+		ret = regmap_read(priv->regmap, QCA8K_REG_SGMII_CTRL, &val);
 		if (ret)
 			return;
 
@@ -1422,7 +1395,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
 		}
 
-		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+		regmap_write(priv->regmap, QCA8K_REG_SGMII_CTRL, val);
 
 		/* From original code is reported port instability as SGMII also
 		 * require delay set. Apply advised values here or take them from DT.
@@ -1447,10 +1420,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
 		if (val)
-			ret = qca8k_rmw(priv, reg,
-					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
-					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
-					val);
+			ret = regmap_update_bits(priv->regmap, reg,
+						 QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+						 QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+						 val);
 
 		break;
 	default:
@@ -1531,7 +1504,7 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 	u32 reg;
 	int ret;
 
-	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
 	if (ret < 0)
 		return ret;
 
@@ -1612,7 +1585,7 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 
 	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
 
-	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
+	regmap_write(priv->regmap, QCA8K_REG_PORT_STATUS(port), reg);
 }
 
 static void
@@ -1642,12 +1615,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
-		ret = qca8k_read(priv, reg, &val);
+		ret = regmap_read(priv->regmap, reg, &val);
 		if (ret < 0)
 			continue;
 
 		if (mib->size == 2) {
-			ret = qca8k_read(priv, reg + 4, &hi);
+			ret = regmap_read(priv->regmap, reg + 4, &hi);
 			if (ret < 0)
 				continue;
 		}
@@ -1676,7 +1649,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_EEE_CTRL, &reg);
 	if (ret < 0)
 		goto exit;
 
@@ -1684,7 +1657,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_EEE_CTRL, reg);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -1723,8 +1696,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	}
 
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
 }
 
 static int
@@ -1745,9 +1718,9 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		ret = qca8k_reg_set(priv,
-				    QCA8K_PORT_LOOKUP_CTRL(i),
-				    BIT(port));
+		ret = regmap_set_bits(priv->regmap,
+				      QCA8K_PORT_LOOKUP_CTRL(i),
+				      BIT(port));
 		if (ret)
 			return ret;
 		if (i != port)
@@ -1755,8 +1728,8 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	}
 
 	/* Add all other ports to this ports portvlan mask */
-	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+	ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+				 QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
 	return ret;
 }
@@ -1777,16 +1750,16 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		qca8k_reg_clear(priv,
-				QCA8K_PORT_LOOKUP_CTRL(i),
-				BIT(port));
+		regmap_clear_bits(priv->regmap,
+				  QCA8K_PORT_LOOKUP_CTRL(i),
+				  BIT(port));
 	}
 
 	/* Set the cpu port to be the only one in the portvlan mask of
 	 * this port
 	 */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
 static int
@@ -1826,7 +1799,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+	return regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -1902,13 +1875,13 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 	int ret;
 
 	if (vlan_filtering) {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
 	return ret;
@@ -1931,15 +1904,15 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	if (pvid) {
-		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-				QCA8K_EGREES_VLAN_PORT_MASK(port),
-				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
+		ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(port),
+					 QCA8K_EGREES_VLAN_PORT_MASK(port),
+					 QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
 		if (ret)
 			return ret;
 
-		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
-				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+		ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				   QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				   QCA8K_PORT_VLAN_SVID(vlan->vid));
 	}
 
 	return ret;
@@ -2023,7 +1996,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	if (!data)
 		return -ENODEV;
 
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	ret = regmap_read(priv->regmap, QCA8K_REG_MASK_CTRL, &val);
 	if (ret < 0)
 		return -ENODEV;
 
-- 
2.32.0

