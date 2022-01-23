Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A3496F7C
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiAWBeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiAWBd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:57 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963DCC06173B;
        Sat, 22 Jan 2022 17:33:56 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r10so18678717edt.1;
        Sat, 22 Jan 2022 17:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeNIlOjCpzJJQoQB7ids6lo81FsdNkZ9xGds/d7qknQ=;
        b=SxB6TlpZEosChqccOjgctSYMLWaxFcOSzxgvc2OqtSsLndq/wIZ89WRCfVWfO4wOyn
         UF8Se86jja9rBzZpVDnU5jBiqOCFdpoasObw9B+3YLOnEEmrkuTmg2Ud7QCJ68ZYcvHh
         q2oEuzaVl18/3r2Av7YRdyiyaTQvvPMLpFg0h87hrvbrJpwvXPooPPpS72kSOafZPRZB
         qdi0fOPhtTX4pmtQPRjCp3Ijoth0CEgvs2zRTdzl2lX49ETkVM7qJWcHkDgkMX7n3aGC
         ffFY/s5PxENAeOK4c8s0sHtncVMi4d7R7cjBAT/79zFVkJkctto0rLI3y2cpmpMTYKHm
         2eTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeNIlOjCpzJJQoQB7ids6lo81FsdNkZ9xGds/d7qknQ=;
        b=6je/3I5sUEDvoQa47yUNnwTj0FBkrLMJVK308bGKGDkZtJn5WhGfeF9EUcxP64vioa
         fWnuIY9xcCwqJbiTz4d3IipGMlbq9uX31j3fcMrbjPbwCraMJeueBHfw7m53SWLDMEOf
         kFcuM7M/Ok8pAFFxMtGXW2YLFeOZprxg/Ry63WRtm9dRM0L2345ZVoaNzzUC2/sL720t
         Wcz/nTC9GgZmzQ8KQln57VJsiAQF4QRvvUveL/hpcqobZIIW/1qdnv8R9I6A/ErNDs2B
         q1k4v1UtABSz1+6Gri4yQpREq3j3VbRiNUPIdjpiy0UZuT9jHJzlPnLdrPFXN9QQyOnd
         vVUw==
X-Gm-Message-State: AOAM533F955kiVIr5CcYr5nm4HCEQs/ZnQQrbRgQneVV08O90JRBtxWk
        rRWWdpRh+yxZsorSwdpY5zw=
X-Google-Smtp-Source: ABdhPJzKEkIPiabanr7vps6dciof8xhSKilr2xLXx7aAln0Adx1NpXJ16DLeBl3xvpn5dG/ie/BxMg==
X-Received: by 2002:a05:6402:2805:: with SMTP id h5mr10190712ede.241.1642901635087;
        Sat, 22 Jan 2022 17:33:55 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:54 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 14/16] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Sun, 23 Jan 2022 02:33:35 +0100
Message-Id: <20220123013337.20945-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
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
index c2f5414033d8..2a43fb9aeef2 100644
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
@@ -384,7 +418,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (ret < 0)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, mdio_cache, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -421,7 +455,7 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 
 	val &= ~mask;
 	val |= write_val;
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, mdio_cache, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -1072,14 +1106,14 @@ qca8k_mdio_write(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
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
 
@@ -1109,7 +1143,7 @@ qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
@@ -1120,7 +1154,7 @@ qca8k_mdio_read(struct mii_bus *bus, struct qca8k_mdio_cache *cache,
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, cache, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -3007,6 +3041,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	}
 
 	priv->mdio_cache.page = 0xffff;
+	priv->mdio_cache.lo = 0xffff;
+	priv->mdio_cache.hi = 0xffff;
 
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 77ffdc7b5aaa..9ecd4d221906 100644
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

