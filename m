Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1863E44C888
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhKJTKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhKJTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCD8610FF;
        Wed, 10 Nov 2021 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571241;
        bh=B3ssFMyJIWoIBzfLL8U56ejk3pYs9NOqGpv37mnWppU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s50pQNODSNCEdF4rWnvFazefCeTdzm6zLQa0YwQTA0MTItbFM5KZ091V/vEUD7Xnn
         whMWazxscslGo+1393wYyYFDStNv9H9309vOq/WAanyAx8XGq7FFnjo1SLuDl16Via
         iFur/enTD+K0l3n95xoXZK85Wnhqbsl0jimUOKZJJo1DfmIT998AJX/dRCF69x3wHo
         opZHarB+ggeckDpf9UrPeCP29/80bPaX2LwOPKkYQ4qFw7QAVSG13MbWiQnjhvu/Tz
         xbBHYmyBhdj8v6Lau1S6MypLyfXXNi814YoRdb2wR3Ugf1CtHektneQT74s8p5JRpF
         X9xnR5RW0ImaA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 5/8] net: phylink: pass supported PHY interface modes to phylib
Date:   Wed, 10 Nov 2021 20:07:06 +0100
Message-Id: <20211110190709.16505-6-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110190709.16505-1-kabel@kernel.org>
References: <20211110190709.16505-1-kabel@kernel.org>
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
index 4a8a0adf8c6c..0697c88227f7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1178,6 +1178,10 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
 	int ret;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -1253,6 +1257,10 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_copy(phy_dev->host_interfaces,
+			   pl->config->supported_interfaces);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
@@ -2437,6 +2445,8 @@ static bool phylink_phy_no_inband(struct phy_device *phy)
 		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
 }
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
@@ -2458,6 +2468,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	/* Do the initial configuration */
 	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
@@ -2819,4 +2833,18 @@ void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
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
index effa4137f173..e05146b383ab 100644
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

