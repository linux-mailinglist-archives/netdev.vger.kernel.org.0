Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070446D146A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCaAzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCaAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724521024E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K1Z6RXGT7Cy75Vw4xUJqWStadQH/2oFQYxnNkmPVn5E=; b=14mTYhtJ5v3lGUgn5QOA7xXcRA
        JdORX9vl0fDOkfaaWylqWhVqEnzR0gU9raqaHN2B1JREXKqxFI65I10eAqRuRiSs/UVK45Hs0Z1I0
        8oaKWdczXOk3PzmXLz/ve0S4TGFnB9EGrCfz7JG1K6D6HFhQyBkzsBLKKx0yOUgpvtY8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKH-DQ; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 03/24] net: phy: Add helper to set EEE Clock stop enable bit
Date:   Fri, 31 Mar 2023 02:54:57 +0200
Message-Id: <20230331005518.2134652-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC driver can request that the PHY stops the clock during EEE
LPI. This has normally been does as part of phy_init_eee(), however
that function is overly complex and often wrongly used. Add a
standalone helper, to aid removing phy_init_eee(). The helper
currently calls generic code, but it could in the future call a PHY
specific op if a PHY exports different registers to 802.3.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Add missing EXPORT_SYMBOL_GPL
v3: Move register access into phy-c45.c
---
 drivers/net/phy/phy-c45.c | 24 ++++++++++++++++++++++++
 drivers/net/phy/phy.c     | 19 +++++++++++++++++++
 include/linux/phy.h       |  2 ++
 include/uapi/linux/mdio.h |  1 +
 4 files changed, 46 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index fee514b96ab1..29479e142826 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1386,6 +1386,30 @@ int genphy_c45_eee_is_active(struct phy_device *phydev, unsigned long *adv,
 }
 EXPORT_SYMBOL(genphy_c45_eee_is_active);
 
+/**
+ * genphy_c45_eee_clk_stop_enable - Clock should stop during LPI signalling
+ * @phydev: target phy_device struct
+ *
+ * Description: Program the MMD register 3.0 setting the "Clock stop enable"
+ * bit.
+ */
+int genphy_c45_eee_clk_stop_enable(struct phy_device *phydev)
+{
+	int ret;
+
+	/* IEEE 802.3:2018 - 45.2.3.2.6 Clock stop capable (3.1.6) */
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_STAT1_CLKSTOP_CAPABLE)
+		/* IEEE 802.3-2018 45.2.3.1.4 Clock stop enable (3.0.10) */
+		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
+					MDIO_PCS_CTRL1_CLKSTOP_EN);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_eee_clk_stop_enable);
+
 /**
  * genphy_c45_ethtool_get_eee - get EEE supported and status
  * @phydev: target phy_device struct
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 150df69d9e08..6fc6a59d2f56 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1573,6 +1573,25 @@ int phy_get_eee_err(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_get_eee_err);
 
+/**
+ * phy_eee_clk_stop_enable - Clock should stop during LIP
+ * @phydev: target phy_device struct
+ *
+ * Description: Program the PHY to stop the clock when EEE is
+ * signalling LPI
+ */
+int phy_eee_clk_stop_enable(struct phy_device *phydev)
+{
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = genphy_c45_eee_clk_stop_enable(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_eee_clk_stop_enable);
+
 /**
  * phy_ethtool_get_eee - get EEE supported and status
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2508f1d99777..dea707b3189b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1773,6 +1773,7 @@ int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv);
 int genphy_c45_an_config_eee_aneg(struct phy_device *phydev);
 int genphy_c45_read_eee_adv(struct phy_device *phydev, unsigned long *adv);
+int genphy_c45_eee_clk_stop_enable(struct phy_device *phydev);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
@@ -1847,6 +1848,7 @@ int phy_unregister_fixup_for_uid(u32 phy_uid, u32 phy_uid_mask);
 
 int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable);
 int phy_get_eee_err(struct phy_device *phydev);
+int phy_eee_clk_stop_enable(struct phy_device *phydev);
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data);
 int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data);
 int phy_ethtool_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 256b463e47a6..e810abb1a4d3 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -121,6 +121,7 @@
 /* Status register 1. */
 #define MDIO_STAT1_LPOWERABLE		0x0002	/* Low-power ability */
 #define MDIO_STAT1_LSTATUS		BMSR_LSTATUS
+#define MDIO_STAT1_CLKSTOP_CAPABLE	0x0040	/* Clock stop capable */
 #define MDIO_STAT1_FAULT		0x0080	/* Fault */
 #define MDIO_AN_STAT1_LPABLE		0x0001	/* Link partner AN ability */
 #define MDIO_AN_STAT1_ABLE		BMSR_ANEGCAPABLE
-- 
2.40.0

