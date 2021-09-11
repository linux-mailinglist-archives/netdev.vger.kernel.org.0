Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AC6407933
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhIKPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhIKPvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:51:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65AFC061574;
        Sat, 11 Sep 2021 08:50:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qq21so4866182ejb.10;
        Sat, 11 Sep 2021 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yzw9TEqOzWRxLqpBiubhfJ/8nucPxLebFi7eEuMBVHQ=;
        b=luD7p/Jp7NnTDDVtz7yV3AHu5/OmXt1LdXzz/gR5V41AypJlF40s86zZipuSD1Qjzs
         CgslqDWe9x4Xwgi2dAa8NHZYcZzeNxPTGqall+QtZob48DAbi5FMduuhiBHjpGcEuP3q
         1Ix+wW7Viq1wjFxGb6o7J1PxEbcpeqUVizYs92YUjFd1TR6VgyFSjOm9Hn67j4Kwtkzf
         3JnyrhLkUchZf7km35W9MvrLaiMD2ZM8aRhYxEE051GBk0yrGLW803/MSBkgsrrTy1R7
         bzkAQf3MMiOGJcunp2MPOjOZ6D7QUhGvMRJJ/9AVMISdR1+YwEEQ7wZt01b/1sVqM7wG
         1azA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yzw9TEqOzWRxLqpBiubhfJ/8nucPxLebFi7eEuMBVHQ=;
        b=MUR2WoMjeziIpassjrgFTqnFnI1a+GnGvKEE8doumLSx24dybUzKpm2HjwbeLIYH+e
         D2NVMYp16qgpOuHvLjt9aW9MFW5vRf7e7ZCphgBOyljw44IMGnQ6657kvhtT7xMSSNMw
         Vl/586nq9iDZk4ZNOlMMD5JjZUQ/rnv07/jkwKcf2ZYyIzBvXu1pjy07QL/G0YaRFmb8
         6+eFzUnHZ6xv+7qWeTK8fohRp9Uy4qEk0VaXaoKZ4I6tAvUx+gQl066l53S92hhtogdU
         7MmYDTokheUeOiGPIWAhfoWxLBPC2TE/KZb5rX5zsdBDb7TmSxtgyBtyGMYnbUZoaPR3
         Bohg==
X-Gm-Message-State: AOAM532ESLxZw6XbUTsv+fqy4pGTeAqluTVAna6PQhDt7qxCOwGeVj3V
        ysC2+On/AEaHi7N++xG7eHY=
X-Google-Smtp-Source: ABdhPJwe02IhAP0pRs3mDMAZa8ottCXfnMIw9zi2/9NZCTLTamKP3l8T+YMqH35Xq3vS19nrF1fEmg==
X-Received: by 2002:a17:906:d20a:: with SMTP id w10mr3532495ejz.426.1631375426241;
        Sat, 11 Sep 2021 08:50:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-87-21-249-69.retail.telecomitalia.it. [87.21.249.69])
        by smtp.googlemail.com with ESMTPSA id r26sm921708ejd.85.2021.09.11.08.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:50:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: qca8k: fix kernel panic with legacy mdio mapping
Date:   Sat, 11 Sep 2021 17:50:09 +0200
Message-Id: <20210911155009.22251-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the mdio legacy mapping is used the mii_bus priv registered by DSA
refer to the dsa switch struct instead of the qca8k_priv struct and
causes a kernel panic. Create dedicated function when the internal
dedicated mdio driver is used to properly handle the 2 different
implementation.

Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..bda5a9bf4f52 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -643,10 +643,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
+qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 {
-	struct qca8k_priv *priv = salve_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -682,10 +680,8 @@ qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 }
 
 static int
-qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
+qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
 {
-	struct qca8k_priv *priv = salve_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -726,6 +722,24 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 	return ret;
 }
 
+static int
+qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 data)
+{
+	struct qca8k_priv *priv = slave_bus->priv;
+	struct mii_bus *bus = priv->bus;
+
+	return qca8k_mdio_write(bus, phy, regnum, data);
+}
+
+static int
+qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
+{
+	struct qca8k_priv *priv = slave_bus->priv;
+	struct mii_bus *bus = priv->bus;
+
+	return qca8k_mdio_read(bus, phy, regnum);
+}
+
 static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
@@ -775,8 +789,8 @@ qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
 
 	bus->priv = (void *)priv;
 	bus->name = "qca8k slave mii";
-	bus->read = qca8k_mdio_read;
-	bus->write = qca8k_mdio_write;
+	bus->read = qca8k_internal_mdio_read;
+	bus->write = qca8k_internal_mdio_write;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
 		 ds->index);
 
-- 
2.32.0

