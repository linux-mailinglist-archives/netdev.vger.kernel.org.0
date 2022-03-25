Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D582A4E7CB1
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiCYVhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiCYVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:04 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EE4AE3A;
        Fri, 25 Mar 2022 14:35:28 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8DD54223F0;
        Fri, 25 Mar 2022 22:35:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HO3BNNMiGWEE7yu4esdw667t4cALNEKNqcbKGS1w0kw=;
        b=SBUdBNid1b83ipDQWD3bS9UHVF4AToC2TN4ACVgrOfhu9qdnI5Ch+vGjGua3qvYvluuyKW
        YtvPWMDx088UgmjFpkyHE6xwpJM8CeAWvbpmzp5Jq5+jCCtaQ45ujrNn4shxjY8dvS4j9v
        m6yrOzLR4OI3PE2piUGrVvNXZqNHZpM=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 3/8] net: phy: add error checks in __phy_mmd_indirect() and export it
Date:   Fri, 25 Mar 2022 22:35:13 +0100
Message-Id: <20220325213518.2668832-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing error checks and export it so it can be reused. Rename the
function to have the common "phy_" prefix.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy-core.c | 34 ++++++++++++++++++++++++++--------
 include/linux/phy.h        |  2 ++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2001f3329133..dd9b6b64757d 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -437,19 +437,37 @@ int phy_speed_down_core(struct phy_device *phydev)
 	return 0;
 }
 
-static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
-			     u16 regnum)
+/**
+ * __phy_mmd_indirect - prepare an indirect C45 register access
+ *
+ * @bus: the target MII bus
+ * @phy_addr: PHY address on the MII bus
+ * @devad: The target MMD (0..31)
+ * @regnum: The target register on the MMD (0..65535)
+ *
+ * Prepare an indirect C45 read or write transfer using the MII_MMD_CTRL and
+ * MII_MMD_DATA registers in C22 space.
+ */
+int __phy_mmd_indirect(struct mii_bus *bus, int phy_addr, int devad,
+		       u16 regnum)
 {
+	int ret;
+
 	/* Write the desired MMD Devad */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
+	ret = __mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
+	if (ret)
+		return ret;
 
 	/* Write the desired MMD register address */
-	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
+	ret = __mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
+	if (ret)
+		return ret;
 
 	/* Select the Function : DATA with no post increment */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
-			devad | MII_MMD_CTRL_NOINCR);
+	return __mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
+			       devad | MII_MMD_CTRL_NOINCR);
 }
+EXPORT_SYMBOL(__phy_mmd_indirect);
 
 /**
  * __phy_read_mmd - Convenience function for reading a register
@@ -476,7 +494,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
+		__phy_mmd_indirect(bus, phy_addr, devad, regnum);
 
 		/* Read the content of the MMD's selected register */
 		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
@@ -532,7 +550,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
+		__phy_mmd_indirect(bus, phy_addr, devad, regnum);
 
 		/* Write the data into MMD's selected register */
 		__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c2253..c81c209d4abd 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1110,6 +1110,8 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 	__ret; \
 })
 
+int __phy_mmd_indirect(struct mii_bus *bus, int phy_addr, int devad,
+		       u16 regnum);
 /*
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.30.2

