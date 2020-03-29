Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716C2196E43
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgC2QBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:01:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39180 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgC2QBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yZxE0OkjIysyGQ1/UL6ibe6OyNH08kxY0jxzlj5hI4U=; b=FVZmLe1ot+E6MHTrRiB7rCCEzF
        Ic7aoQhbYdDXKJUMWglik1xCgFInOQgu9vEe8hv9d/E5AHB3I2H9ynr8saOuVne+jOj9ZE4aieQaE
        u2yN+6st6ROzwiVLK0rnGpYKBbIu1VJQBvdiQpB8EPrEL2YN4ICXadhc5FXrWzwxINs/sGiflSRHZ
        hL8OGMZAo67DlLrMb8PZl5wJ8YSHqBwR8hA1prsDRfTKkTJW1AMpe+k+xK4LbS5uQDXZ+7rgQeWZF
        RfEKXgMsxBAaXAqS+LXCjjPJNt9XCJIo1etUIcHeScq5ijYs0BYZXYsIYo/8hBiVFvcAXo1J9K4CQ
        Lbim6Wmg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47182 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIaN2-0005oZ-Jk; Sun, 29 Mar 2020 17:01:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIaN1-0007la-Tf; Sun, 29 Mar 2020 17:01:07 +0100
In-Reply-To: <20200329160036.GB25745@shell.armlinux.org.uk>
References: <20200329160036.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/3] net: phylink: change
 phylink_mii_c22_pcs_set_advertisement() prototype
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jIaN1-0007la-Tf@rmk-PC.armlinux.org.uk>
Date:   Sun, 29 Mar 2020 17:01:07 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change phylink_mii_c22_pcs_set_advertisement() to take only the PHY
interface and advertisement mask, rather than the full phylink state.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 12 +++++++-----
 include/linux/phylink.h   |  3 ++-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fed0c5907c6a..f31bfd39df4b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2184,7 +2184,8 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
  * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
  *	advertisement
  * @pcs: a pointer to a &struct mdio_device.
- * @state: a pointer to the state being configured.
+ * @interface: the PHY interface mode being configured
+ * @advertising: the ethtool advertisement mask
  *
  * Helper for MAC PCS supporting the 802.3 clause 22 register set for
  * clause 37 negotiation and/or SGMII control.
@@ -2197,22 +2198,23 @@ EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
  * zero if no change has been made, or one if the advertisement has changed.
  */
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					const struct phylink_link_state *state)
+					  phy_interface_t interface,
+					  const unsigned long *advertising)
 {
 	struct mii_bus *bus = pcs->bus;
 	int addr = pcs->addr;
 	int val, ret;
 	u16 adv;
 
-	switch (state->interface) {
+	switch (interface) {
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
 		adv = ADVERTISE_1000XFULL;
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				      state->advertising))
+				      advertising))
 			adv |= ADVERTISE_1000XPAUSE;
 		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				      state->advertising))
+				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
 
 		val = mdiobus_read(bus, addr, MII_ADVERTISE);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 8fa6df3b881b..6f6ecf3e0be1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -320,7 +320,8 @@ void phylink_helper_basex_speed(struct phylink_link_state *state);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
-					const struct phylink_link_state *state);
+					  phy_interface_t interface,
+					  const unsigned long *advertising);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
-- 
2.20.1

