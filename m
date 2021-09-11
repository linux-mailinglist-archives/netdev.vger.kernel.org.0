Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E500C4078FB
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhIKPJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhIKPJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:09:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BBAC061574;
        Sat, 11 Sep 2021 08:08:03 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a25so10620965ejv.6;
        Sat, 11 Sep 2021 08:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM7XF1uFs9UTa/foVY6d5+oceSdFNljdu/vD3xDjyZM=;
        b=S9vz87VSobel3WVd8MkbjsZq3rLmApPX3jtgsvbPpYpXc3RyLE5GwcCvKkdH1JZq79
         UyMZEY4MGmuMCeelqLsw7PaZWbH+9pfNG4G9FY6vx4z5dgVEQQkjEFI7D3ro3+DsoI2z
         /74ypdjAVqE7mI/Myc0zTy7JakrFP7ydbs1FqlwqHvAOZmDHsJhi8sCvAanU99eMrdhc
         VPqxwu60nBjCIPky+ogRHsuJcCcIvuq13Z3LguXPM5tt3mkPvl8j9S0YC4Gbu83lJKcC
         UMUgt1aKNAxr4WysLZqZ1pT4kD6bKJkeR/U7iKqBwpTnuHWTP2w03l3XPGLYpJoLkWit
         +PLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM7XF1uFs9UTa/foVY6d5+oceSdFNljdu/vD3xDjyZM=;
        b=15hqpKsO7trtoSuXoHph7twriNo0CESl9hzY0d1pgMv2iuPSgOOqYslIuc7EvPhbbl
         xOE7tD4pFbPKZ1x8tgeeMuqVqGj4zcktJnTKYZ9I7ShJZnHu+rUoAkrRxvP0pp+StdCm
         l+6ELnsrnr6A+uxrLWjy3eGR71yLpxiOtUppFnoPJqNRQYvvQdhBRvgxyRj3Lj7jEpRZ
         65sRBg9XKmrIdtgv1f6XsXEOMVTUIv30rpPYDoH1S2DLgZsGhcVVv+gbtDXSeTpRgtHl
         RWM0L4uR3chwkRz0lobi8ftz7w+4dLolmg8rlwjS+beFmbVJPMcRvAqHcwGjyrQwIkC1
         wi7Q==
X-Gm-Message-State: AOAM532bv1ODn3PzimYNxjDTW+3Gweu1roEdQzl9qepuSq+OVSigfP4S
        1ahvLDO8Me7JLLiXCQSJ1W4=
X-Google-Smtp-Source: ABdhPJzRJ+TGa41Qh5gA0oGgXcQkxdwOt9jVRz/d0dswqBiYK3SNFB3EgmjQ4yzOkzOSuPfLwJbD2w==
X-Received: by 2002:a17:906:3745:: with SMTP id e5mr3320151ejc.400.1631372881612;
        Sat, 11 Sep 2021 08:08:01 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-87-21-249-69.retail.telecomitalia.it. [87.21.249.69])
        by smtp.googlemail.com with ESMTPSA id l16sm882107eje.67.2021.09.11.08.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:08:01 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: qca8k: fix kernel panic with legacy mdio mapping
Date:   Sat, 11 Sep 2021 17:07:31 +0200
Message-Id: <20210911150731.16586-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the mdio legacy mapping is used the mii_bus priv registred by DSA
refer to the dsa switch struct instead of the qca8k_priv struct and
cause a kernel panic. Create dedicated function when the internal
dedicated mdio driver is used to proprely handle the 2 different
implementation.

Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..a701323daf72 100644
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
+qca8k_internal_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
+{
+	struct qca8k_priv *priv = salve_bus->priv;
+	struct mii_bus *bus = priv->bus;
+
+	return qca8k_mdio_write(bus, phy, regnum, data);
+}
+
+static int
+qca8k_internal_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
+{
+	struct qca8k_priv *priv = salve_bus->priv;
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

