Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31329381276
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhENVDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhENVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EE0C061349;
        Fri, 14 May 2021 14:00:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v5so47891edc.8;
        Fri, 14 May 2021 14:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FqkrdS4KspFZ8bszZTkMza7qEh5/dk1petIyFEtqIdw=;
        b=GiVKDY1peLvb2mEBgXYTs0l9Ze00xB2puA42CW+mMDKKOFtlsvGFTgw8ElIXXsxohD
         QNr5j4ZdVGqs4ADckDF7YmsSEhfiSfzvqeDNmiRT8pz1icweGHtw3TcWcUpwrbueqcBS
         xwsHkcaWO32XE0nhgnQD/CDcbJCQZvjLQDBaBUhfYZSmsO7X6C6QBzgspuSXVT1AOvBj
         Axtpnpm2un6nmcBCall9zOgGHYxg9iW3R0KhstaWM+jKr+vlcqsr2qf84ILc5qa/jvD3
         T1/+2PvKjgymIc5MRtKsy6H/v9F4723aW9imw/cR9Hg0pszAb9bq2Ooz77D24pOE5Ubl
         EINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FqkrdS4KspFZ8bszZTkMza7qEh5/dk1petIyFEtqIdw=;
        b=Htmck9ScyuphSY5O3BWo9Grn78veNGRtXq3C9UWtymdsumOuJHQxu8tXGnrENjRR7u
         rP+koaqQrK05KP38MGXxdtSCw6PZgeRrDfAcNFFNuXULxxWK20h1ywcDhfrGE9T3bvZh
         Sv5H+HyGUY1f0mJpMcjQApiAr+55RspLVK9m7qSZlHD1J64fOtfNxC5kEx0TteUoyeON
         gNcipFNeuHCpA9mK7VctY570DnS1+27Mg8SwANc5nuyK/td/2c90/moj2QuqnUjRbez3
         eK/sVQqioSKDAs3P8Le4sb8MBASd3mAh1csDakVxSZ0s62uij8CLPw2o+iQynkKjZPgM
         h0aA==
X-Gm-Message-State: AOAM531XDh6EspKjQL+GYz5ZJX0fyZ7wWY7cki4jiyqptQdxPrXnx259
        L6jrh667sqf7i3v9fWhwsBE=
X-Google-Smtp-Source: ABdhPJwtNaj65T5vwdl7AgEUlnXxSsLa5wvb8DEPdVAySqkmuc6nfJSiOwe73J1b8CPEHe8YXCfI+w==
X-Received: by 2002:a50:fe8e:: with SMTP id d14mr10839303edt.97.1621026038682;
        Fri, 14 May 2021 14:00:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:38 -0700 (PDT)
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
Subject: [PATCH net-next v6 22/25] net: dsa: qca8k: improve internal mdio read/write bus access
Date:   Fri, 14 May 2021 23:00:12 +0200
Message-Id: <20210514210015.18142-23-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the internal mdio read/write bus access by caching the value
without accessing it for every read/write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ba288181fd1a..ccb3d89cf58c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -655,6 +655,7 @@ static int
 qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = salve_bus->priv;
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -669,22 +670,22 @@ qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 
 	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(bus, page);
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -693,6 +694,7 @@ static int
 qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = salve_bus->priv;
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -706,26 +708,26 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 
 	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(bus, page);
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 	if (ret)
 		goto exit;
 
-	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	if (val >= 0)
 		val &= QCA8K_MDIO_MASTER_DATA_MASK;
-- 
2.30.2

