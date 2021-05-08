Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF7376DB0
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhEHAad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhEHAa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:26 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EB1C061574;
        Fri,  7 May 2021 17:29:25 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v12so10848590wrq.6;
        Fri, 07 May 2021 17:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z9wCRjYirG2CaGU6+kOVn0TlYvq1oqjexUwBHWJt75s=;
        b=q2PnkNSsoi7TSeENWe+Ou9vfHs3gdi5kY9cvEAWtSKoAfX39LRxfJjEkb4DPhBVVIC
         u7/omJueeZbt/0BTogCfPhzdDfEFaeOHJaFMU853tigyllX/RZUB5+dnjyn54hCDYLvc
         uh6BTgbrKN7CEJDeStIbbsLoSNfLgqaI+8wLA9SL+uMxbvOrX0p9qW37RRDR0zsCbhcl
         LOQpd13HH0bpTIAmqqTg+lJN5iVXLyOeIQMWozZI4C77FpMS60BCAxqapAX6jpv2li7J
         F5emNlXLe1QYqye2W2obXvnpdgA5XtheTiMSNDx2B8FI68M73Qt8Tf/SIZGL5zkm25F3
         JDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9wCRjYirG2CaGU6+kOVn0TlYvq1oqjexUwBHWJt75s=;
        b=e+T7da3VEch8RXlxy+3zmwUNGgHdX8AIy8566SzQpGefUEo8VDttqh9G5OGTN6tBef
         tuY7pNko3tnTbMPr8STPeRPZQ6cc1qlk1jLFIT5VTZtMMx+o3qwmJrTgAGg4KWniJi82
         bXkHxE9cO7opkIjodobOEFgt2qSIzf+baRuocZ4R4lr03IZR/atyY775/07uYsvM7IWy
         wbtqjU/vjw8h8TSA+fA4aNyZtoWLZdZu848imDL8SRDAHM6FKPSicWhr/YNoRDekk7Hu
         oEWdzuE5LIylu0MMq1VhdmqTR2Y62rAfjSxH3UF3sUqtIEsBEWXhlAZYwCCN10P4tEji
         fXoQ==
X-Gm-Message-State: AOAM532J6wqumDOgn474u2+jpOTUpQBUjwjS8tf3CZ/yfA7A6ced7mOn
        fIpaFcQrEQzipnBDX3TlTl8=
X-Google-Smtp-Source: ABdhPJytE2aUU8Xb9aL4qL5aFQQ+lv6kndFg6TvNHyaG6rRtSNhBEeFGKVlxjMJoVO50QK7a8zoS0Q==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr15890359wrr.58.1620433763952;
        Fri, 07 May 2021 17:29:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 06/28] net: dsa: qca8k: improve qca8k read/write/rmw bus access
Date:   Sat,  8 May 2021 02:28:56 +0200
Message-Id: <20210508002920.19945-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put bus in local variable to improve faster access to the mdio bus.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0bfb7ae4c128..f58d4543ef1e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -142,17 +142,18 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 static u32
 qca8k_read(struct qca8k_priv *priv, u32 reg)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	qca8k_set_page(bus, page);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return val;
 }
@@ -160,35 +161,37 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 static void
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_set_page(bus, page);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 }
 
 static u32
 qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 {
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
-	ret = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	qca8k_set_page(bus, page);
+	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
 	ret &= ~mask;
 	ret |= val;
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
-- 
2.30.2

