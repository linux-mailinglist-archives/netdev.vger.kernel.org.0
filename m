Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E09381234
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhENVBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhENVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44814C061574;
        Fri, 14 May 2021 14:00:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v5so46918edc.8;
        Fri, 14 May 2021 14:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h4SZ7QJmv/HrbOtolTPG3AL+9UHJYBuUDPau4+rnOa8=;
        b=hzTJDCPxu4xna0qcjdrWqVJ6ILlmvMOvRS06K+m9PSVf8+ubuiHo6ep6iti6szXZ1A
         ucycOBCaC2VrGIizTFUg/ROJ4GQtjIWg1AbC5gSZuaqrQzwlieDKmbfT2WVVL5HI7M85
         wCgXnwWRCbUS6FUmdeHjN22U0LDLaiY/Ae2089cXGHRS90PIyYaCsnJCnUFqIoHAcX9i
         diaw7rDgn8SB+0wOtpJ+C0EwCF5YnAZ2hITkYbRXl6JwE0RYNY75wlmT1oNmmHzvPCTC
         OjaiC0LIYjcyOIR+kyajEek0Mm4kpmgdOtnjNtfWsJFwFMAN9Fct9KaPewWsz2lJquD6
         Bumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h4SZ7QJmv/HrbOtolTPG3AL+9UHJYBuUDPau4+rnOa8=;
        b=q1ll1j7jQkc0IJIQy66/oTQI8iScMDPKTRQfpCWZ2/JkQqFjidinIIE/+fvGIGkWdY
         rYb1WgeUqMyuU3rODlM7AvG623e5Op+lsfff2AS8lghNoACCTssx3xmEQZF3rHpjT8tk
         y9tXqeb3Sv9Q5NUTGG9ESvqyo4kEM+NCykt98M5YAsQ8PtlSZz1DEeDyVKTTLvqgIk+y
         vioj2AmHEBMflO523/pdeXBxNX60/iX5I8xSGqlSfywtLHbK+Y9V3BM6Re5WWXSeUMRo
         Nx+zMUA/wPNKQni3370rTEG/ROCpb4gfZYdId10K9XNeemFkfLpBhjbc4FXCQrTgYESQ
         p7mw==
X-Gm-Message-State: AOAM530v4EOiKCbB5WiA68W9gy0PTbG/uRMVemUGI+Iz5AFuk1zEN+Wc
        uVi1dkgukN51ma1Wt1UM2ePdOZRhmfPIZQ==
X-Google-Smtp-Source: ABdhPJw8bxt5SIeqM3WMvoJVjWX/ln+zY19Pi7kIPJUdn6/GhjN17bmSZ008vqwVgG5t6CHhvrxAEQ==
X-Received: by 2002:a05:6402:1a58:: with SMTP id bf24mr18713162edb.146.1621026018990;
        Fri, 14 May 2021 14:00:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:18 -0700 (PDT)
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
Subject: [PATCH net-next v6 03/25] net: dsa: qca8k: improve qca8k read/write/rmw bus access
Date:   Fri, 14 May 2021 22:59:53 +0200
Message-Id: <20210514210015.18142-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put bus in local variable to improve faster access to the mdio bus.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 25fa7084e820..3c882d325fdf 100644
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

