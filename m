Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB03676043
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjATWkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjATWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:40:23 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9993080BA0;
        Fri, 20 Jan 2023 14:40:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 01322168F;
        Fri, 20 Jan 2023 23:40:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674254420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xk0c8KXT0x8OjHkq5e1tXzEKZP0LwHWjl4YMIq+eX4M=;
        b=r1hdBTaIxDJbu5FJo/TGTrKSx6Ixn1HeMHxI6bmZxa1kMUyMpDoL37A9OPInreH/ITaS05
        9sSoGcdYywRCTFne161/qsrmFCZ9AkPIyi8QDnkIUv/3VCc75LfKio8BDyr7DWeQEu8YxP
        xvS3//4U9YuS3pMdurAAaPCJyFGfwDSrsU9zJRDJPpL9rZCEzfUpl0H7u9u87YGIP4QK8L
        L1ewM3ad6IOLrFb2EqPNVKRuXPJwC6uheXJxH/eUOO/wg7+tIvV4ELjhlPshDszRWbQALz
        9X2786k6ggAynG+VGKmXkaHfXYbt0+xcyyThCEnlLeFvRGmqWt6vH2TvuiKWsQ==
From:   Michael Walle <michael@walle.cc>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/5] net: phy: add error checks in mmd_phy_indirect() and export it
Date:   Fri, 20 Jan 2023 23:40:07 +0100
Message-Id: <20230120224011.796097-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230120224011.796097-1-michael@walle.cc>
References: <20230120224011.796097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing error checks in mmd_phy_indirect(). The error checks need to
be disabled to retain the current behavior in phy_read_mmd() and
phy_write_mmd(). Therefore, add a new parameter to enable the error
checks. Add a thin wrapper __phy_mmd_indirect() which is then exported.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy-core.c | 44 +++++++++++++++++++++++++++++++-------
 include/linux/phy.h        |  2 ++
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a64186dc53f8..c9c92b95ace2 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -524,19 +524,47 @@ int phy_speed_down_core(struct phy_device *phydev)
 	return 0;
 }
 
-static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
-			     u16 regnum)
+static int mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
+			    u16 regnum, bool check_rc)
 {
+	int ret;
+
 	/* Write the desired MMD Devad */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
+	ret = __mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
+	if (check_rc && ret)
+		return ret;
 
 	/* Write the desired MMD register address */
-	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
+	ret = __mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
+	if (check_rc && ret)
+		return ret;
 
 	/* Select the Function : DATA with no post increment */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
-			devad | MII_MMD_CTRL_NOINCR);
+	ret = __mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
+			      devad | MII_MMD_CTRL_NOINCR);
+	if (check_rc && ret)
+		return ret;
+
+	return 0;
+}
+
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
+{
+	return mmd_phy_indirect(bus, phy_addr, devad, regnum, true);
 }
+EXPORT_SYMBOL(__phy_mmd_indirect);
 
 /**
  * __phy_read_mmd - Convenience function for reading a register
@@ -563,7 +591,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
+		mmd_phy_indirect(bus, phy_addr, devad, regnum, false);
 
 		/* Read the content of the MMD's selected register */
 		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
@@ -619,7 +647,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
+		mmd_phy_indirect(bus, phy_addr, devad, regnum, false);
 
 		/* Write the data into MMD's selected register */
 		__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fbeba4fee8d4..f7a5e110f95c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1228,6 +1228,8 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 	__ret; \
 })
 
+int __phy_mmd_indirect(struct mii_bus *bus, int phy_addr, int devad,
+		       u16 regnum);
 /*
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.30.2

