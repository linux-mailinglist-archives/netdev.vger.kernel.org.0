Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4770C474D06
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhLNVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbhLNVKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:44 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD2FC06173E;
        Tue, 14 Dec 2021 13:10:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r11so66771999edd.9;
        Tue, 14 Dec 2021 13:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jU2qbfx0AVTju8+6qe/EIDgAs10lLA29tkTsiudBudw=;
        b=pKCdOxt2DXoY7THqxPkNUoo22pTg3DR+oKLGoZ4oCQpQRT+bdDCigmdRNHJhVxoQ7Y
         aYrxI6nhpCuCnh/0F3Zjd/LRaLTydHhy7KtumLsn8RS+0ELZPiWHZ1UaxliM9SXgmFa+
         BUvIsh0JUketwVsOMgTd+EfkS+TF45OrA8XPzFbqaFAFNoGlJm0aXFRvv2vVgD8bAtfl
         bD12nuWuLPePmPK2rehohaoMb87HD4PuxVvtekclV7Rl+7ukU3PtL6s0ggaOwIk4sY0g
         k1u3gG0y+3bbMeYBkwzNivrdXuYzpR/ML9rNfXcTF2RYbOllXipKZdzfuQwyu+mJVNmG
         YZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jU2qbfx0AVTju8+6qe/EIDgAs10lLA29tkTsiudBudw=;
        b=Jamc6FPLM7Q7oqH36NICak4D6qHsOWOa5Gom30DpkW5cASguu2An/hFzie1oOBJtJm
         0MejcLzBGeC9xMdvTPg19wmylZPuK0rvej4MNxoB12LmzuRHCBCZehxJSp5uj3PV+Cq8
         qXCMENdhlumbCVo/XMjn9NPRkYyjV+vi5QHAkJ6FIT7nqCKy50VWt07SGVxv0o+cHA+p
         OUPIm03Mh7VGedgXyqK7GM67+aM7FXhICaaCv82yvm6oxrxCfALMEsSJSmghI6YtDkwS
         t8cRS17z+ASdsaPCkkE92pioiC1KOFcJQPnHgmeK3ZVhQoCgbQ0LJ/Q3sZu6HaieJ56W
         2m3A==
X-Gm-Message-State: AOAM531bwhBUD6b2vHPKCN2nhSsyr5LgmLMW+780H08Zvf4Nm+Fmwp1o
        sDowY/x2dWEUNSrl5gEhU7g=
X-Google-Smtp-Source: ABdhPJztbpWjk1qvaxf2dN0Xw7vLhgIa7fpVmBfX1GCFBpyRMWu70hR1JuYZ2JRfyyQH9QV5afXPmQ==
X-Received: by 2002:a17:907:2cc5:: with SMTP id hg5mr8519021ejc.138.1639516242456;
        Tue, 14 Dec 2021 13:10:42 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:42 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 16/16] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Tue, 14 Dec 2021 22:10:11 +0100
Message-Id: <20211214211011.24850-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation, we can cache lo and hi the same way we do with the
page. This massively reduce the mdio write as 3/4 of the time as we only
require to write the lo or hi part for a mdio write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 60 ++++++++++++++++++++++++++++++++---------
 drivers/net/dsa/qca8k.h |  5 ++++
 2 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5c0a7c17da49..b34fa3483ac1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -88,6 +88,42 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
+static int
+qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum,
+	     u16 lo, u16 *cached_lo)
+{
+	int ret;
+
+	if (lo == *cached_lo)
+		return 0;
+
+	ret = bus->write(bus, phy_id, regnum, lo);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit lo register\n");
+
+	*cached_lo = lo;
+	return 0;
+}
+
+static int
+qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum,
+	     u16 hi, u16 *cached_hi)
+{
+	int ret;
+
+	if (hi == *cached_hi)
+		return 0;
+
+	ret = bus->write(bus, phy_id, regnum, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit hi register\n");
+
+	*cached_hi = hi;
+	return 0;
+}
+
 static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
@@ -111,7 +147,8 @@ qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 }
 
 static void
-qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
+qca8k_mii_write32(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
+		  int phy_id, u32 regnum, u32 val)
 {
 	u16 lo, hi;
 	int ret;
@@ -119,12 +156,9 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = bus->write(bus, phy_id, regnum, lo);
+	ret = qca8k_set_lo(bus, phy_id, regnum, lo, &cache->lo);
 	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		ret = qca8k_set_hi(bus, phy_id, regnum + 1, hi, &cache->hi);
 }
 
 static int
@@ -368,7 +402,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (ret < 0)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, mdio_cache, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -405,7 +439,7 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 
 	val &= ~mask;
 	val |= write_val;
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, mdio_cache, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -1042,14 +1076,14 @@ qca8k_mdio_write(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -1079,7 +1113,7 @@ qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
@@ -1090,7 +1124,7 @@ qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -2982,6 +3016,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	}
 
 	priv->mdio_cache.page = 0xffff;
+	priv->mdio_cache.lo = 0xffff;
+	priv->mdio_cache.hi = 0xffff;
 
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c4800ee06c34..79cd35f48730 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -369,6 +369,11 @@ struct qca8k_mdio_cache {
  * mdio writes
  */
 	u16 page;
+/* lo and hi can also be cached and from Documentation we can skip one
+ * extra mdio write if lo or hi is didn't change.
+ */
+	u16 lo;
+	u16 hi;
 };
 
 struct qca8k_priv {
-- 
2.33.1

