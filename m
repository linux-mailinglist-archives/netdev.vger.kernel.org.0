Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0E496F74
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbiAWBeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbiAWBd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:56 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BD1C06173B;
        Sat, 22 Jan 2022 17:33:55 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j2so49593206edj.8;
        Sat, 22 Jan 2022 17:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3K5O/YpvqFOEiBsb8rfwDwH92nPibKXJLXc8NBPwGo=;
        b=TT2ZMh3W9Oa3C5fsAB8m1OKAP6r02u7tEBrRB5U+X3GQY6IrpruxXLgpPYCEKIMjZx
         ChwdA4qey3DVjCu0ANLCqBRsaaL5iKWk7L2r+NhfGva643Q0KriwcbIKRWhN3SrOWpBs
         qQ08cAjDed4gTLQFLndqG7IXnOakTIa9Prxphux2wR+IMCaVFh+f5RBocs1d0SE/4EpT
         nQlHm40DuC3XCyA8iNEa4AIV3ox9JrA8COxI7ZXdPIFuzJXwjV1uVpeg2tGYdp248bc6
         sqj2s5TE9c4unVI59PkgLxT6i7Vbl6S1KZ8bz+3il/01R/9QvEnppL5aBoA5h+E6RFMO
         QgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3K5O/YpvqFOEiBsb8rfwDwH92nPibKXJLXc8NBPwGo=;
        b=1TR12hO6I4pWN7/LG2u8acn1xVpfhCmPD73LrNoERl/xeEzeyNwmq0RnpapQ1bvE+V
         FUXyfep8XypseBKQlVVyJpptgdVcYWX1+Q6JFMTMgax/wAPrNkIyZAutR2N5ePkQSgwn
         rHy1NzAtfVQmxFNPS3EBD/tqDC/SYRoQF1l9lloT6MM0vDUDmwg87Cd+guFb5yetC5+4
         YdB7D2ZumOV0mLVOnWQo5n2RPzdX4OLboGsF2dEY+6OnsBYXoggNLyn47ZlYzVdmBK3B
         +GJErB3Um35zmc+JBJGrxNY4PKrNSl3hU7q3Yc+GSWy+Hz9RBEZ58dlO3AJAcBGsI+qa
         h5rQ==
X-Gm-Message-State: AOAM532jLVvVxJUwMq2x/iFxGQsD/KsGWVtWZDOP9PZu6luYg6DzmEku
        nhcU4OT3c/7x0cvyKLrWaDATS2rq1qM=
X-Google-Smtp-Source: ABdhPJyznc3txJSrTU4b2J3znljieEdHCDxsi9n4A7LBgqaU6pRGJFKjzJ8xGjNa0/ZYAI8uTuRBAA==
X-Received: by 2002:a05:6402:5216:: with SMTP id s22mr10082431edd.44.1642901634146;
        Sat, 22 Jan 2022 17:33:54 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:53 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 13/16] net: dsa: qca8k: move page cache to driver priv
Date:   Sun, 23 Jan 2022 02:33:34 +0100
Message-Id: <20220123013337.20945-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There can be multiple qca8k switch on the same system. Move the static
qca8k_current_page to qca8k_priv and make it specific for each switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 47 +++++++++++++++++++++++------------------
 drivers/net/dsa/qca8k.h |  9 ++++++++
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index e7bc0770bae9..c2f5414033d8 100644
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
@@ -134,11 +128,11 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 }
 
 static int
-qca8k_set_page(struct mii_bus *bus, u16 page)
+qca8k_set_page(struct mii_bus *bus, u16 page, u16 *cached_page)
 {
 	int ret;
 
-	if (page == qca8k_current_page)
+	if (page == *cached_page)
 		return 0;
 
 	ret = bus->write(bus, 0x18, 0, page);
@@ -148,7 +142,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 		return ret;
 	}
 
-	qca8k_current_page = page;
+	*cached_page = page;
 	usleep_range(1000, 2000);
 	return 0;
 }
@@ -343,6 +337,7 @@ static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -350,11 +345,13 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
 		return 0;
 
+	mdio_cache = &priv->mdio_cache;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &mdio_cache->page);
 	if (ret < 0)
 		goto exit;
 
@@ -369,6 +366,7 @@ static int
 qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -376,11 +374,13 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val))
 		return 0;
 
+	mdio_cache = &priv->mdio_cache;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &mdio_cache->page);
 	if (ret < 0)
 		goto exit;
 
@@ -395,6 +395,7 @@ static int
 qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
@@ -404,11 +405,13 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
 		return 0;
 
+	mdio_cache = &priv->mdio_cache;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &mdio_cache->page);
 	if (ret < 0)
 		goto exit;
 
@@ -1046,7 +1049,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
+qca8k_mdio_write(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
+		 int phy, int regnum, u16 data)
 {
 	u16 r1, r2, page;
 	u32 val;
@@ -1064,7 +1068,7 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &cache->page);
 	if (ret)
 		goto exit;
 
@@ -1083,7 +1087,8 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 }
 
 static int
-qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
+qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
+		int phy, int regnum)
 {
 	u16 r1, r2, page;
 	u32 val;
@@ -1100,7 +1105,7 @@ qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &cache->page);
 	if (ret)
 		goto exit;
 
@@ -1139,7 +1144,7 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 			return 0;
 	}
 
-	return qca8k_mdio_write(bus, phy, regnum, data);
+	return qca8k_mdio_write(bus, &priv->mdio_cache, phy, regnum, data);
 }
 
 static int
@@ -1156,7 +1161,7 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 			return ret;
 	}
 
-	return qca8k_mdio_read(bus, phy, regnum);
+	return qca8k_mdio_read(bus, &priv->mdio_cache, phy, regnum);
 }
 
 static int
@@ -1179,7 +1184,7 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 			return ret;
 	}
 
-	return qca8k_mdio_write(priv->bus, port, regnum, data);
+	return qca8k_mdio_write(priv->bus, &priv->mdio_cache, port, regnum, data);
 }
 
 static int
@@ -1202,7 +1207,7 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 			return ret;
 	}
 
-	ret = qca8k_mdio_read(priv->bus, port, regnum);
+	ret = qca8k_mdio_read(priv->bus, &priv->mdio_cache, port, regnum);
 
 	if (ret < 0)
 		return 0xffff;
@@ -3001,6 +3006,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return PTR_ERR(priv->regmap);
 	}
 
+	priv->mdio_cache.page = 0xffff;
+
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
 	if (ret)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 952217db2047..77ffdc7b5aaa 100644
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
 	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
 	struct qca8k_mib_hdr_data mib_hdr_data;
+	struct qca8k_mdio_cache mdio_cache;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

