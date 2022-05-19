Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1364852D54E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiESN5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbiESN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:08 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932512BE7;
        Thu, 19 May 2022 06:57:04 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AB19924000A;
        Thu, 19 May 2022 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWGVazQWGDDZgzON711pAZLPzapDACfEJlg6W1kTnfg=;
        b=BhkmYgd0BYKmyoJAXqAKqMjHEUFihdXTXN70fxztHSnrObK3NtNQFzMboMqwt+XpzQQBq8
        Yckb+AaL2hE1pmmtEbLR6rLBxyeepVgkzziIS882Uojd76piQeLymSa7cHjUN3tFnQqX0A
        /HiQNag2wBM6NiYjZFQdF4ixegzRmBH+6+CkP1eh5m73aUKH14Fldg3uY3qgC8C7HSl3Zy
        7wfbsiUhnuFoVNDgwX9BUFpRq6lxwsuk3Xj7UuEefU8Fxxi8GiIk7GXCHkAaaT3zBG67iM
        OmCXXf7ZSi2i5fa5SWdwzpMMobse/smQ6HYAlkS6nDQCtYamQECNfPh5KOY35A==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/6] net: phy: Add support for inband extensions
Date:   Thu, 19 May 2022 15:56:45 +0200
Message-Id: <20220519135647.465653-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The USXGMII Standard by Cisco introduces the notion of extensions used
in the preamble. The standard proposes a "PCH" extension, which allows
passing timestamps in the preamble. However, other alternatives are
possible, like Microchip's "MCH" mode, that allows passing indication to
a PHY telling whether or not the PHY should timestamp an outgoing packet,
therefore removing the need for the PHY to have an internal classifier.

This commit allows reporting the various extensions a PHY supports,
without tying them to the actual PHY mode. This is done 1) because there
are multiple variants of the USXGMII mode, like QUSGMII and OUSGMII, and
2) because other non-cisco standards might one day propose a similar
mechanism.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/phy/phy.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h   | 25 +++++++++++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..bbd3d7620609 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1475,3 +1475,71 @@ int phy_ethtool_nway_reset(struct net_device *ndev)
 	return phy_restart_aneg(phydev);
 }
 EXPORT_SYMBOL(phy_ethtool_nway_reset);
+
+/**
+ * PHY modes in the USXGMII family can have extensions, with data transmitted
+ * in the frame preamble.
+ * For now, only QUSGMII is supported, but other variants like USGMII and
+ * OUSGMII can be added in the future.
+ */
+static inline bool phy_interface_has_inband_ext(phy_interface_t interface)
+{
+	return interface == PHY_INTERFACE_MODE_QUSGMII;
+}
+
+bool phy_inband_ext_available(struct phy_device *phydev, u32 ext)
+{
+	return !!(phydev->inband_ext.available & ext);
+}
+EXPORT_SYMBOL(phy_inband_ext_available);
+
+bool phy_inband_ext_enabled(struct phy_device *phydev, u32 ext)
+{
+	return !!(phydev->inband_ext.enabled & ext);
+}
+EXPORT_SYMBOL(phy_inband_ext_enabled);
+
+static int phy_set_inband_ext(struct phy_device *phydev, u32 mask, u32 ext)
+{
+	int ret;
+
+	if (!phy_interface_has_inband_ext(phydev->interface))
+		return -EOPNOTSUPP;
+
+	if (!phydev->drv->inband_ext_config)
+		return -EOPNOTSUPP;
+
+	ret = phydev->drv->inband_ext_config(phydev, mask, ext);
+	if (ret)
+		return ret;
+
+	phydev->inband_ext.enabled &= ~mask;
+	phydev->inband_ext.enabled |= (mask & ext);
+
+	return 0;
+}
+
+int phy_inband_ext_enable(struct phy_device *phydev, u32 ext)
+{
+	return phy_set_inband_ext(phydev, ext, ext);
+}
+EXPORT_SYMBOL(phy_inband_ext_enable);
+
+int phy_inband_ext_disable(struct phy_device *phydev, u32 ext)
+{
+	return phy_set_inband_ext(phydev, ext, 0);
+}
+EXPORT_SYMBOL(phy_inband_ext_disable);
+
+int phy_inband_ext_set_available(struct phy_device *phydev, u32 mask, u32 ext)
+{
+	if (!(mask & phydev->drv->inband_ext))
+		return -EOPNOTSUPP;
+
+	phydev->inband_ext.available &= ~mask;
+	phydev->inband_ext.available |= (mask & ext);
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_inband_ext_set_available);
+
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4a2731c78590..6b08f49bce5b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -190,6 +190,21 @@ static inline void phy_interface_set_rgmii(unsigned long *intf)
 	__set_bit(PHY_INTERFACE_MODE_RGMII_TXID, intf);
 }
 
+/*
+ * TODO : Doc
+ */
+enum {
+	__PHY_INBAND_EXT_PCH = 0,
+};
+
+#define PHY_INBAND_EXT_PCH	BIT(__PHY_INBAND_EXT_PCH)
+
+int phy_inband_ext_enable(struct phy_device *phydev, u32 ext);
+int phy_inband_ext_disable(struct phy_device *phydev, u32 ext);
+int phy_inband_ext_set_available(struct phy_device *phydev, u32 mask, u32 ext);
+bool phy_inband_ext_available(struct phy_device *phydev, u32 ext);
+bool phy_inband_ext_enabled(struct phy_device *phydev, u32 ext);
+
 /*
  * phy_supported_speeds - return all speeds currently supported by a PHY device
  */
@@ -275,7 +290,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 	}
 }
 
-
 #define PHY_INIT_TIMEOUT	100000
 #define PHY_FORCE_TIMEOUT	10
 
@@ -635,6 +649,11 @@ struct phy_device {
 
 	phy_interface_t interface;
 
+	struct {
+		u32 available;
+		u32 enabled;
+	} inband_ext;
+
 	/*
 	 * forced speed & duplex (no autoneg)
 	 * partner speed & duplex & pause (autoneg)
@@ -766,6 +785,7 @@ struct phy_driver {
 	u32 phy_id_mask;
 	const unsigned long * const features;
 	u32 flags;
+	u32 inband_ext;
 	const void *driver_data;
 
 	/**
@@ -935,6 +955,9 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	int (*inband_ext_config)(struct phy_device *dev, u32 features,
+				 u32 mask);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.36.1

