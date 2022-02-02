Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD75C4A68FE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243187AbiBBAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbiBBAEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47526C061741;
        Tue,  1 Feb 2022 16:04:33 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id o12so59324135eju.13;
        Tue, 01 Feb 2022 16:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vHbSxIzj8pGvQe+9cyVzG20+ePbfLgWllhuRABj5OOI=;
        b=oEi5I0+XVLVOyzaDp6qiF1mr4twGlRmgr1tJ/9tT0Vbref/jGQejIHwZ8ah0L9l/Fx
         m59TClVQu75tTSdOuFv2akay1bino+lKaSdNSIG5SJh8+4EjWPW22XH5d7thuSo+4XT9
         a3yQBP68uxfLytdwqcxXahy132GiXwkzj9DeEZlUjJMTa6+UVjFtqf2BPubFFY0twe2h
         g2H0tz8m2tLgNl3PR2BWjvHgMKL6btnVGj0afDb+7z/533Zr4TB5J1JH7XhnV3NfUkje
         s8NcA9/vDCLUM2k5A4jBuPtHhSh+KUf37G8I1se6rxWk39eWXS53CCfcfFlvLa4c/mJr
         2Aug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vHbSxIzj8pGvQe+9cyVzG20+ePbfLgWllhuRABj5OOI=;
        b=BDiHqKHh+k7PhReits7OyT6hh+HLEGKf6RMWvjFgiyTxbxyxT5v1xzcCd8O5yOFhnr
         S35eS7drms0KsdHx7hhCqQNC/nQf1AqJq/D6zJBDrL1ATxAuEdZhRurpDrW74xFVRhCi
         ue+vT9xd+6U1AZXgbBhCK4HzpqfpdunC1hYAX3NbI0puLO15IzIVxxee3jk3FJeEvQn4
         T6p1NVixT8G38Hl9Hn/fI0ETzWqpd6Si0h0PflTGl6ZgmrDI1oe3UNB/olDZFiEvCrwV
         Rsxqyw1/J//ZDEyrZwaQBNyTtUjEG9pNqn8kfa4Cyq8LxmIDWmqKI8PDHgtefEjNYuU7
         IVIg==
X-Gm-Message-State: AOAM530mXa+RM4rw1i2s0x7jAed2w0y2IoNI2CcX4+amIcSyunrfegQF
        Xw+JAP8jHvh079E8Ohk13GFvi4DmQnQ=
X-Google-Smtp-Source: ABdhPJzZ3mUuId+lwstRn1aQexSLiu/QNe8qUQWuGeURzmCNEWmLX4F27085traQ/l9+wZwUbswBBA==
X-Received: by 2002:a17:907:6298:: with SMTP id nd24mr22526866ejc.76.1643760271679;
        Tue, 01 Feb 2022 16:04:31 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:31 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 13/16] net: dsa: qca8k: move page cache to driver priv
Date:   Wed,  2 Feb 2022 01:03:32 +0100
Message-Id: <20220202000335.19296-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There can be multiple qca8k switch on the same system. Move the static
qca8k_current_page to qca8k_priv and make it specific for each switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 42 ++++++++++++++++++++---------------------
 drivers/net/dsa/qca8k.h |  9 +++++++++
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0ce5b7ca0b7f..86d3742b1038 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -75,12 +75,6 @@ static const struct qca8k_mib_desc ar8327_mib[] = {
 	MIB_DESC(1, 0xac, "TXUnicast"),
 };
 
-/* The 32bit switch registers are accessed indirectly. To achieve this we need
- * to set the page of the register. Track the last page that was set to reduce
- * mdio writes
- */
-static u16 qca8k_current_page = 0xffff;
-
 static void
 qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 {
@@ -134,11 +128,13 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 }
 
 static int
-qca8k_set_page(struct mii_bus *bus, u16 page)
+qca8k_set_page(struct qca8k_priv *priv, u16 page)
 {
+	u16 *cached_page = &priv->mdio_cache.page;
+	struct mii_bus *bus = priv->bus;
 	int ret;
 
-	if (page == qca8k_current_page)
+	if (page == *cached_page)
 		return 0;
 
 	ret = bus->write(bus, 0x18, 0, page);
@@ -148,7 +144,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 		return ret;
 	}
 
-	qca8k_current_page = page;
+	*cached_page = page;
 	usleep_range(1000, 2000);
 	return 0;
 }
@@ -374,7 +370,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(priv, page);
 	if (ret < 0)
 		goto exit;
 
@@ -400,7 +396,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(priv, page);
 	if (ret < 0)
 		goto exit;
 
@@ -427,7 +423,7 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(priv, page);
 	if (ret < 0)
 		goto exit;
 
@@ -1098,8 +1094,9 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
+qca8k_mdio_write(struct qca8k_priv *priv, int phy, int regnum, u16 data)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -1116,7 +1113,7 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(priv, page);
 	if (ret)
 		goto exit;
 
@@ -1135,8 +1132,9 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 }
 
 static int
-qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
+qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -1152,7 +1150,7 @@ qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(priv, page);
 	if (ret)
 		goto exit;
 
@@ -1181,7 +1179,6 @@ static int
 qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	int ret;
 
 	/* Use mdio Ethernet when available, fallback to legacy one on error */
@@ -1189,14 +1186,13 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 	if (!ret)
 		return 0;
 
-	return qca8k_mdio_write(bus, phy, regnum, data);
+	return qca8k_mdio_write(priv, phy, regnum, data);
 }
 
 static int
 qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = slave_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	int ret;
 
 	/* Use mdio Ethernet when available, fallback to legacy one on error */
@@ -1204,7 +1200,7 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 	if (ret >= 0)
 		return ret;
 
-	return qca8k_mdio_read(bus, phy, regnum);
+	return qca8k_mdio_read(priv, phy, regnum);
 }
 
 static int
@@ -1225,7 +1221,7 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 	if (!ret)
 		return ret;
 
-	return qca8k_mdio_write(priv->bus, port, regnum, data);
+	return qca8k_mdio_write(priv, port, regnum, data);
 }
 
 static int
@@ -1246,7 +1242,7 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	if (ret >= 0)
 		return ret;
 
-	ret = qca8k_mdio_read(priv->bus, port, regnum);
+	ret = qca8k_mdio_read(priv, port, regnum);
 
 	if (ret < 0)
 		return 0xffff;
@@ -3042,6 +3038,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return PTR_ERR(priv->regmap);
 	}
 
+	priv->mdio_cache.page = 0xffff;
+
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
 	if (ret)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c6f6abd2108e..57368acae41b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -363,6 +363,14 @@ struct qca8k_ports_config {
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 };
 
+struct qca8k_mdio_cache {
+/* The 32bit switch registers are accessed indirectly. To achieve this we need
+ * to set the page of the register. Track the last page that was set to reduce
+ * mdio writes
+ */
+	u16 page;
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
@@ -383,6 +391,7 @@ struct qca8k_priv {
 	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_eth_data mgmt_eth_data;
 	struct qca8k_mib_eth_data mib_eth_data;
+	struct qca8k_mdio_cache mdio_cache;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

