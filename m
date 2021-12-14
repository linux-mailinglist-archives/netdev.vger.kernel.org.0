Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8182C474D0F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhLNVLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbhLNVKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:43 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D1DC06173F;
        Tue, 14 Dec 2021 13:10:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z5so68182562edd.3;
        Tue, 14 Dec 2021 13:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5DhYL9hNpti+cjYN9i+Vi4xVEbKUuQHICREvW9WQ/o=;
        b=RGINkAYfVHsAK2HxlAvJ5ivAIf8jXCSphPqOj3pKjC7n4KzmR9Q0nMh6+JIz9tCcRY
         4eg+MHJPIcKGCwcRKMyY1JZvF2CVjm3ulRWuT0OdBFPoWxNnm/EKLsa2EPCwo9wuxxQ9
         gPB1qO6uGSVZcJi+DjP0KTRsiKOpsM9Q7qpH7YwRUKTx0146wgAESRc907F0OfWM1yKn
         zdOYuLVyCGHxFBV2KTaMOXS5SX07yFjtcu3AR63Spev80X3tl3rsoUTqP5M/pT+9ex1h
         5xfSA3au4jLgllr5toq1Cc4kirMuro2dd8yhswzxcxNzNMhk1XzqFhuINsMndvBuake5
         uhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5DhYL9hNpti+cjYN9i+Vi4xVEbKUuQHICREvW9WQ/o=;
        b=c4dg7IMu8LoRcurEzdoGBXHcbrbRV3fgXopBlsjCnZoU0cTUy/iwYRPLf5fQooFEF0
         U5KZ+pv+3dsluYbuXS2F4TMFAdVhFUcxaSORFncgQUj4AhTvSYAV+b99arNpB7SraeAD
         2BjIptD+PD3e5uVRQk6FrVhPeeRZkIV0opE7BQ9PJAG45I6aE95jwYyKCj49rVsA4seg
         Bq0Ixj6yVLXKXuQFJyp60IjgZTTyYaiqwl7y3QE8JMEvORpt/2fDC73aXyaSyyGbuv7p
         Vtdw5l+19cxwOUwxdXcHdUDIALqFYFE/p3WAjgbyV5YWm3s3hZV/6W6rGbKli5DJ50Dg
         N7IQ==
X-Gm-Message-State: AOAM5330fWiqyORoLB+5aub4JgXvpI5Ckm0P1NDrzhnWPZ0gQlx5d8Nu
        CwcCAifjocJiLSoKHQB7Gyg=
X-Google-Smtp-Source: ABdhPJzMDI/5NxNAoj9hzMKFIqDbHB48hq3HuYgnKsRdMVpnhfv6CwDywzhl2/LBVNDDw+041lY6hA==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr8289289ejr.435.1639516241466;
        Tue, 14 Dec 2021 13:10:41 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:41 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 15/16] net: dsa: qca8k: move page cache to driver priv
Date:   Tue, 14 Dec 2021 22:10:10 +0100
Message-Id: <20211214211011.24850-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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
index a3de23d82809..5c0a7c17da49 100644
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
@@ -327,6 +321,7 @@ static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -334,11 +329,13 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	if (priv->master && !qca8k_read_eth(priv, reg, val))
 		return 0;
 
+	mdio_cache = &priv->mdio_cache;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &mdio_cache->page);
 	if (ret < 0)
 		goto exit;
 
@@ -353,6 +350,7 @@ static int
 qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
@@ -360,11 +358,13 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (priv->master && !qca8k_write_eth(priv, reg, val))
 		return 0;
 
+	mdio_cache = &priv->mdio_cache;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &mdio_cache->page);
 	if (ret < 0)
 		goto exit;
 
@@ -379,6 +379,7 @@ static int
 qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	struct qca8k_mdio_cache *mdio_cache;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
@@ -388,11 +389,13 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
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
 
@@ -1016,7 +1019,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
+qca8k_mdio_write(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
+		 int phy, int regnum, u16 data)
 {
 	u16 r1, r2, page;
 	u32 val;
@@ -1034,7 +1038,7 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &cache->page);
 	if (ret)
 		goto exit;
 
@@ -1053,7 +1057,8 @@ qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 }
 
 static int
-qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
+qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
+		int phy, int regnum)
 {
 	u16 r1, r2, page;
 	u32 val;
@@ -1070,7 +1075,7 @@ qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page, &cache->page);
 	if (ret)
 		goto exit;
 
@@ -1109,7 +1114,7 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
 			return 0;
 	}
 
-	return qca8k_mdio_write(bus, phy, regnum, data);
+	return qca8k_mdio_write(bus, &priv->mdio_cache, phy, regnum, data);
 }
 
 static int
@@ -1126,7 +1131,7 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 			return ret;
 	}
 
-	return qca8k_mdio_read(bus, phy, regnum);
+	return qca8k_mdio_read(bus, &priv->mdio_cache, phy, regnum);
 }
 
 static int
@@ -1149,7 +1154,7 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 			return ret;
 	}
 
-	return qca8k_mdio_write(priv->bus, port, regnum, data);
+	return qca8k_mdio_write(priv->bus, &priv->mdio_cache, port, regnum, data);
 }
 
 static int
@@ -1172,7 +1177,7 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 			return ret;
 	}
 
-	ret = qca8k_mdio_read(priv->bus, port, regnum);
+	ret = qca8k_mdio_read(priv->bus, &priv->mdio_cache, port, regnum);
 
 	if (ret < 0)
 		return 0xffff;
@@ -2976,6 +2981,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return PTR_ERR(priv->regmap);
 	}
 
+	priv->mdio_cache.page = 0xffff;
+
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
 	if (ret)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 203220efa5c0..c4800ee06c34 100644
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
 	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mdio_hdr_data mdio_hdr_data;
 	struct qca8k_mib_hdr_data mib_hdr_data;
+	struct qca8k_mdio_cache mdio_cache;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

