Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0391CC4F6
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgEIWhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgEIWh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:37:27 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895A9C061A0C;
        Sat,  9 May 2020 15:37:27 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5F18323E2C;
        Sun, 10 May 2020 00:37:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589063844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FpXXvSjfV7CqPtrXWu5x3xX/5W7BGf6WwIAJJKytUlw=;
        b=p/KE5cQ3xwVZhxS2MxTlvLl6NiNMAMDIfQz6H8MaXLHbDyuH7KiVAT5qjkYn51v71Mjdsa
        QYtOy18+xPBk+0iThhkED7+GHxUVsQ7mkCNKOHv7uOSt/4wqRkTW/F7vo3dtDRP3r1DfLF
        UcBzZrv7823g2Jn2uSHCSP89Ol7vnuU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/4] net: phy: broadcom: add exp register access methods without buslock
Date:   Sun, 10 May 2020 00:37:11 +0200
Message-Id: <20200509223714.30855-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200509223714.30855-1-michael@walle.cc>
References: <20200509223714.30855-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper to read and write expansion registers without taking the mdio
lock.

Please note, that this changes the semantics of the read and write.
Before there was no lock between selecting the expansion register and
the actual read/write. This may lead to access failures if there are
parallel accesses. Instead take the bus lock during the whole access
cycle.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm-phy-lib.c | 38 ++++++++++++++++++++++++++++-------
 drivers/net/phy/bcm-phy-lib.h |  2 ++
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index d5f9a2701989..a390812714ed 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -14,33 +14,57 @@
 #define MII_BCM_CHANNEL_WIDTH     0x2000
 #define BCM_CL45VEN_EEE_ADV       0x3c
 
-int bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val)
+int __bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val)
 {
 	int rc;
 
-	rc = phy_write(phydev, MII_BCM54XX_EXP_SEL, reg);
+	rc = __phy_write(phydev, MII_BCM54XX_EXP_SEL, reg);
 	if (rc < 0)
 		return rc;
 
-	return phy_write(phydev, MII_BCM54XX_EXP_DATA, val);
+	return __phy_write(phydev, MII_BCM54XX_EXP_DATA, val);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_write_exp);
+
+int bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val)
+{
+	int rc;
+
+	phy_lock_mdio_bus(phydev);
+	rc = __bcm_phy_write_exp(phydev, reg, val);
+	phy_unlock_mdio_bus(phydev);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(bcm_phy_write_exp);
 
-int bcm_phy_read_exp(struct phy_device *phydev, u16 reg)
+int __bcm_phy_read_exp(struct phy_device *phydev, u16 reg)
 {
 	int val;
 
-	val = phy_write(phydev, MII_BCM54XX_EXP_SEL, reg);
+	val = __phy_write(phydev, MII_BCM54XX_EXP_SEL, reg);
 	if (val < 0)
 		return val;
 
-	val = phy_read(phydev, MII_BCM54XX_EXP_DATA);
+	val = __phy_read(phydev, MII_BCM54XX_EXP_DATA);
 
 	/* Restore default value.  It's O.K. if this write fails. */
-	phy_write(phydev, MII_BCM54XX_EXP_SEL, 0);
+	__phy_write(phydev, MII_BCM54XX_EXP_SEL, 0);
 
 	return val;
 }
+EXPORT_SYMBOL_GPL(__bcm_phy_read_exp);
+
+int bcm_phy_read_exp(struct phy_device *phydev, u16 reg)
+{
+	int rc;
+
+	phy_lock_mdio_bus(phydev);
+	rc = __bcm_phy_read_exp(phydev, reg);
+	phy_unlock_mdio_bus(phydev);
+
+	return rc;
+}
 EXPORT_SYMBOL_GPL(bcm_phy_read_exp);
 
 int bcm54xx_auxctl_read(struct phy_device *phydev, u16 regnum)
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 4d3de91cda6c..0eb5333cda39 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -27,6 +27,8 @@
 #define AFE_HPF_TRIM_OTHERS		MISC_ADDR(0x3a, 0)
 
 
+int __bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val);
+int __bcm_phy_read_exp(struct phy_device *phydev, u16 reg);
 int bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val);
 int bcm_phy_read_exp(struct phy_device *phydev, u16 reg);
 
-- 
2.20.1

