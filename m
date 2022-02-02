Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF64A68FC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243285AbiBBAEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243127AbiBBAEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0193BC061749;
        Tue,  1 Feb 2022 16:04:35 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j2so37663267edj.8;
        Tue, 01 Feb 2022 16:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/sPTO7HXKid+NzRJvJfh3Z+nIffmW3x5BFbdKbsjz+U=;
        b=Hj9twqOusSBMkgvopcHO49tUa/u2ZqBSJ5gLr9hq+P9C1LKt2tT46h5ozQAQv45GH7
         HsRqJOkvliSW+WXvkusgDJLYuczRlpTvD41VzsFy8wqIV6H+ZjvRbGGTVVNYBnoQmVcy
         rNNJT/ITTfI0QblugYn/maQyXUPceNvD3fkhc5oHN4u5m418oJUJWbfWCdqlE4m/Wn/a
         Ot1MGdzPENgMb96yHpnROtOMkOqgbyVRzFFDIuFD4cDSmqjJUr5nHeMzPb7vL4CxvWRW
         qfyMo+NfEbiDWscJE9SsMvtAbZnzagETq6DZ5RBCNGTQ01Yclssc8A01Be63CCwFPDaO
         qv0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/sPTO7HXKid+NzRJvJfh3Z+nIffmW3x5BFbdKbsjz+U=;
        b=azVccaRSmEkbgtJ0FUVhPb9q34I9RhQ8DykkZ2bDoT90yAs1XQVjgiyer+9U8BxjdN
         EENg5ZYX5l0mZ4d8VyGsvNRe7Y4yCCy2OLyIucdOw4SB6JDPfIGT5A9c60DgpV6Xg1ah
         cisV2ULdz3xQrBUtBokS/h0HRNN/qQWmBk/moKtjKExNfnKIWt1wcM8j5TThB9293eOJ
         Y6DUbfNXiUiKNOzzz3hOpMg+xhmTgNZFKC3oh5ptbUEnmc96iLCS1zji35LIOyTwjmRH
         3oJ8PLeqiX7tIbd8xyBfyI+npvFNWfcRDPZIDGzI3SsyExPEY4rAXiOIQ87wKzwTnkW5
         PEYA==
X-Gm-Message-State: AOAM531OhNdGM2z/5/BoQKUB8JcIwafdopwZ6KpKq15vfwCSAAZiUdvH
        iRlqtTYsFBDjABoKxCBNIms=
X-Google-Smtp-Source: ABdhPJwOE5swVc17Sfw0Mdin4+ZhrSkEyUzplM8S+QeabTxk08OpxuqYylmnf7qs0JcoCjo3I+PHvw==
X-Received: by 2002:a05:6402:50c:: with SMTP id m12mr27533779edv.141.1643760273416;
        Tue, 01 Feb 2022 16:04:33 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:33 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 14/16] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Wed,  2 Feb 2022 01:03:33 +0100
Message-Id: <20220202000335.19296-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation, we can cache lo and hi the same way we do with the
page. This massively reduce the mdio write as 3/4 of the time as we only
require to write the lo or hi part for a mdio write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 61 +++++++++++++++++++++++++++++++++--------
 drivers/net/dsa/qca8k.h |  5 ++++
 2 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 86d3742b1038..0cce3a6030af 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -88,6 +88,44 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
+static int
+qca8k_set_lo(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 lo)
+{
+	u16 *cached_lo = &priv->mdio_cache.lo;
+	struct mii_bus *bus = priv->bus;
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
+qca8k_set_hi(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 hi)
+{
+	u16 *cached_hi = &priv->mdio_cache.hi;
+	struct mii_bus *bus = priv->bus;
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
@@ -111,7 +149,7 @@ qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 }
 
 static void
-qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
+qca8k_mii_write32(struct qca8k_priv *priv, int phy_id, u32 regnum, u32 val)
 {
 	u16 lo, hi;
 	int ret;
@@ -119,12 +157,9 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = bus->write(bus, phy_id, regnum, lo);
+	ret = qca8k_set_lo(priv, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		ret = qca8k_set_hi(priv, phy_id, regnum + 1, hi);
 }
 
 static int
@@ -400,7 +435,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	if (ret < 0)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -433,7 +468,7 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 
 	val &= ~mask;
 	val |= write_val;
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -1117,14 +1152,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int phy, int regnum, u16 data)
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -1154,7 +1189,7 @@ qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
@@ -1165,7 +1200,7 @@ qca8k_mdio_read(struct qca8k_priv *priv, int phy, int regnum)
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -3039,6 +3074,8 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	}
 
 	priv->mdio_cache.page = 0xffff;
+	priv->mdio_cache.lo = 0xffff;
+	priv->mdio_cache.hi = 0xffff;
 
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 57368acae41b..c3d3c2269b1d 100644
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

