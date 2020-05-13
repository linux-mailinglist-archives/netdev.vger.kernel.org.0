Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492BA1D1B28
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgEMQfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:35:36 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:53819 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732242AbgEMQfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:35:34 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D161922FE6;
        Wed, 13 May 2020 18:35:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589387732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUh9s56mz+VY0I68EQVuzjda+7pU6yw+sbb16BW4Umk=;
        b=updwlIuMNLgdOERoPXeVlNO61Ny7SSxFuyLkk+RjxQZHFDBCfbXtdKynZz0ZSzIChQ+TKc
        mvNKDmmbatZwy+DRR4/LOBW9qhzg6jtRytvrRHuipBUgMDvixEuyQsnMPJbCQev7R65bfr
        7v/el8g8qBiyN1edbCYm0yC0MZl78qw=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 1/4] net: phy: broadcom: add exp register access methods without buslock
Date:   Wed, 13 May 2020 18:35:21 +0200
Message-Id: <20200513163524.31256-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513163524.31256-1-michael@walle.cc>
References: <20200513163524.31256-1-michael@walle.cc>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

