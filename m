Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630A54550D2
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhKQWyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241452AbhKQWyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:54:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4E961B7D;
        Wed, 17 Nov 2021 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637189464;
        bh=wtPo9eEOU3l9X4mBTIoDho9DYbbysz2q0qlt7yuHE5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD6YFjiZY5VTzs2pj3jvEWlR5gaGNTPs4mudvzaiR5jGoQKf1WjFI5V4QJYoieSkf
         GRMbD5lt45fdxjeg+RgNymjZjRU7FcOD92ptP4B5d/U5ekzKYJaI8VkM8I6I8Ay+sQ
         xkJ34nQc2txOCzBvQWzcYacGQFsrVzQnl/z5BqhcOckMI4q1KPEYWy1sBr+YabJo1S
         /bHy0R9kEq7jX476JFlFB353dX38PR26BtqjFJPqIWqINpdlXh3AJWbd3SuOG51UCS
         dhXassnXw1s75OimsP5LQo6YxFavir9mqu2RkgfHdHdP835f82YyFauAu7HihocsXe
         gQQgxAOsdaryQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 5/8] net: phylink: pass supported PHY interface modes to phylib
Date:   Wed, 17 Nov 2021 23:50:47 +0100
Message-Id: <20211117225050.18395-6-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117225050.18395-1-kabel@kernel.org>
References: <20211117225050.18395-1-kabel@kernel.org>
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
---
 drivers/net/phy/phylink.c | 28 ++++++++++++++++++++++++++++
 include/linux/phy.h       |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6d7c216a5dea..20403b9676e1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1430,6 +1430,10 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
 	int ret;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -1505,6 +1509,10 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy_dev->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
@@ -2689,6 +2697,8 @@ static bool phylink_phy_no_inband(struct phy_device *phy)
 		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
 }
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
@@ -2710,6 +2720,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	/* Do the initial configuration */
 	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
@@ -3071,4 +3085,18 @@ void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c45_pcs_get_state);
 
+static int __init phylink_init(void)
+{
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_10GKR, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_5GBASER, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_SGMII, phylink_sfp_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, phylink_sfp_interfaces);
+
+	return 0;
+}
+module_init(phylink_init);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 83ae15ab1676..11f3b5b7d7b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -569,6 +569,7 @@ struct macsec_ops;
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
  * @lp_advertising: Current link partner advertised linkmodes
+ * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
  * @link: Current link state
@@ -658,6 +659,9 @@ struct phy_device {
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 
+	/* host supported PHY interface types */
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
+
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
-- 
2.32.0

