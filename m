Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F49B370F8D
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEBXIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhEBXIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3254FC06174A;
        Sun,  2 May 2021 16:07:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bf4so4253955edb.11;
        Sun, 02 May 2021 16:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P7Z9vR7PmZB+FbpQMXDhgB1Mrkmc9cjF+wzn558Eoxg=;
        b=dO8MNXghtiBXAlxyb+d9USyiqJRO7/GvRVIVn0H41u8jpDfgxmrqqSZnxEEiG87yIM
         +2TZdGMJaXX3+WOLfIRGwtBA6EPipczcTkYs0nLUcwhOPfs+OA0m3m5rF4WpEXDEr6/G
         a8L60vgl+wgesS74zS3zQIeOAtJ3kHdwdy+Y+HFLjT9xqxEjF9KykUqY7Q8TsY3c5BUp
         4p9xU36OAnnrqNR2B7mhfIpMncXCPhXK70XxnR05z1OiS5cItw0VV+G/PniDFwP65Lh+
         cNM+n3EayInyFMC1bSAR7z7nTUp2SJEDws/gaVArwsK+U9VsUrDSns5/x5UE4/C9777M
         S7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P7Z9vR7PmZB+FbpQMXDhgB1Mrkmc9cjF+wzn558Eoxg=;
        b=R8s0HhiIOWl9aNN6I2vxVkDlYG6gFpvEJAz53XsaEk5T9sS/CNOgNpQrkRafTtqXdO
         LU8+7pbItQHoBhUWaPvJw7OP/5siJgjEuISc+pUmIgPCw+nKrxJifKJ8cm37haxLhjSd
         DsCH8gAFAuaEVDZsVPO1pvpC2FRYYCUed9G0JEjHoZBMjOh3N/KwLUmX8Jc9wTFInnkY
         rp4mjwSgzdojqcxfmPeG6kUwee+c6lsb7cmgEl7EtwyasFBh+EtSdiGB3+lpqjXx90qr
         i2N6+kGomZMCiyDgV1GH+S8Ur3dCzhRBPJXP/d81lRJgrNnZEisVqeban2bd/4k0Lrxu
         qQRg==
X-Gm-Message-State: AOAM530sJz9C6q0oR+YXVjWtwqK6UpIrmC4NbCbK15V3HNxcZe3uawu9
        jC0RzaUcwxAd4OVIG6Bv7Gc=
X-Google-Smtp-Source: ABdhPJzPSMWuTrrLqttVmBSbc2cvi30WucIYSerrSCr0BlMY4KVGRfyCur+mY+zkkWHNVWpFWothHQ==
X-Received: by 2002:aa7:c2d2:: with SMTP id m18mr16729476edp.96.1619996835872;
        Sun, 02 May 2021 16:07:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:15 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 02/17] net: mdio: ipq8064: switch to write/readl function
Date:   Mon,  3 May 2021 01:06:54 +0200
Message-Id: <20210502230710.30676-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use readl/writel function instead of regmap function to make sure no
value is cached and align to other similar mdio driver.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index fb1614242e13..8ae5379eda9d 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -37,7 +37,7 @@
 #define MII_MDIO_RETRY_MSEC			(10)
 
 struct ipq8064_mdio {
-	struct regmap *base; /* NSS_GMAC0_BASE */
+	void __iomem *base; /* NSS_GMAC0_BASE */
 };
 
 static int
@@ -45,9 +45,9 @@ ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
 {
 	u32 busy;
 
-	return regmap_read_poll_timeout(priv->base, MII_ADDR_REG_ADDR, busy,
-					!(busy & MII_BUSY), MII_MDIO_DELAY_USEC,
-					MII_MDIO_RETRY_MSEC * USEC_PER_MSEC);
+	return readl_poll_timeout(priv->base + MII_ADDR_REG_ADDR, busy,
+				  !(busy & MII_BUSY), MII_MDIO_DELAY_USEC,
+				  MII_MDIO_RETRY_MSEC * USEC_PER_MSEC);
 }
 
 static int
@@ -55,7 +55,6 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 {
 	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
 	struct ipq8064_mdio *priv = bus->priv;
-	u32 ret_val;
 	int err;
 
 	/* Reject clause 45 */
@@ -65,15 +64,14 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
-	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
+	writel(miiaddr, priv->base + MII_ADDR_REG_ADDR);
 	usleep_range(8, 10);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
 		return err;
 
-	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
-	return (int)ret_val;
+	return (int)readl(priv->base + MII_DATA_REG_ADDR);
 }
 
 static int
@@ -86,12 +84,12 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 	if (reg_offset & MII_ADDR_C45)
 		return -EOPNOTSUPP;
 
-	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
+	writel(data, priv->base + MII_DATA_REG_ADDR);
 
 	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
-	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
+	writel(miiaddr, priv->base + MII_ADDR_REG_ADDR);
 	usleep_range(8, 10);
 
 	return ipq8064_mdio_wait_busy(priv);
@@ -116,15 +114,9 @@ ipq8064_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	priv = bus->priv;
-	priv->base = device_node_to_regmap(np);
-	if (IS_ERR(priv->base)) {
-		if (priv->base == ERR_PTR(-EPROBE_DEFER))
-			return -EPROBE_DEFER;
-
-		dev_err(&pdev->dev, "error getting device regmap, error=%pe\n",
-			priv->base);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
-	}
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret)
-- 
2.30.2

