Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C345A88F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhKWQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhKWQnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0859060FC1;
        Tue, 23 Nov 2021 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685642;
        bh=893w7YK58a16FrgQv1BBeT0NVXWeeILmCnh28eXL+pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr2PoHJSTxk4Z2B3WetdsTu2xCC1vrnu0gOsSIMOm8L++63YyUrLwBxhf0t1Icl6q
         1DUhO2zfjlwocsP69vIJQIxOkjACB1XVi7afJh3Ay2awCWR/5LXl9bqRSZVjnj5k4G
         3vtiyascAOmFu2IERX1PFdLSLwtosFzxeYJpFsUp6UOUUnGfxT1dhjD4fvx/uCCvGO
         /DUi0jJqhkDRbkUWkQ6ZcSX7tOACt/lp2ZEm2q/dbmK5JH/9LdUgXfGxD/D6Ak6Qx+
         R7sq2KYlBRBRRDMoiIzZOWittZMoJXR7xFULbSDqwK5npWJ/oryN5ofoVOVAi2i8fr
         d6qIbOKHcs34g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 5/8] net: phylink: pass supported PHY interface modes to phylib
Date:   Tue, 23 Nov 2021 17:40:24 +0100
Message-Id: <20211123164027.15618-6-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the supported PHY interface types to phylib so that PHY drivers
can select an appropriate host configuration mode for their interface
according to the host capabilities.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 28 ++++++++++++++++++++++++++++
 include/linux/phy.h       | 10 ++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d2300a3a60ec..0dcf94170d06 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1439,6 +1439,10 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
 	int ret;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -1514,6 +1518,10 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy_dev->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy_dev->interface;
@@ -2704,6 +2712,8 @@ static bool phylink_phy_no_inband(struct phy_device *phy)
 		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
 }
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
@@ -2725,6 +2735,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	/* Do the initial configuration */
 	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
@@ -3102,4 +3116,18 @@ void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c45_pcs_get_state);
 
+static int __init phylink_init(void)
+{
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_5GBASER, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_SGMII, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_100BASEX, phylink_sfp_interfaces);
+
+	return 0;
+}
+module_init(phylink_init);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1e57cdd95da3..11f3b5b7d7b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -169,6 +169,12 @@ static inline bool phy_interface_empty(const unsigned long *intf)
 	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
 }
 
+static inline void phy_interface_copy(unsigned long *dst,
+				      const unsigned long *src)
+{
+	bitmap_copy(dst, src, PHY_INTERFACE_MODE_MAX);
+}
+
 static inline void phy_interface_and(unsigned long *dst, const unsigned long *a,
 				     const unsigned long *b)
 {
@@ -563,6 +569,7 @@ struct macsec_ops;
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
  * @lp_advertising: Current link partner advertised linkmodes
+ * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
  * @link: Current link state
@@ -652,6 +659,9 @@ struct phy_device {
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 
+	/* host supported PHY interface types */
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
+
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
-- 
2.32.0

