Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925E620F740
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgF3O3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgF3O3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F9C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oBBZnA4EqspW3zROe8d1roBQQMSI1CyoMEk2p9ddlWs=; b=K56i1HSnOXH8uVlrpH5yeVt25L
        lCmLe8kVy/NundfLB0O5CSbCmNSv6RpZezoeBgsChU78uo+TncnDCs3r9Lu2DQfKsro3yB1mDtgjk
        d8LiNhehqiZezxR4tDDoi4ICyFHzsvqzucyZC0tHNVIY/TOuWrN+ue9zSosavIEQ9ljkNJDepMIkM
        gcuXXd9RxcVo43780iolnC5jIjXLGRR4GFQ52Sp5DzXfIe8SX+p5YjC0hjPt/Kolg2xCWN6ZzpK11
        Djk/Ovw5xJ04WyZdRZMPp0qM5XOWZ8vXOXNL1pdJg91SaB/A6YyA5zmoku16qk8vcYahqkXh2cgJW
        1IuN1XWQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47284 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGT-0000gN-TJ; Tue, 30 Jun 2020 15:29:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGT-0006Qb-Ld; Tue, 30 Jun 2020 15:29:37 +0100
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 13/13] net: phylink: add interface to configure
 clause 22 PCS PHY
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHGT-0006Qb-Ld@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:29:37 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fbc8591b474b..d6c5e900a2f1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2435,6 +2435,43 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
 
+/**
+ * phylink_mii_c22_pcs_config() - configure clause 22 PCS
+ * @pcs: a pointer to a &struct mdio_device.
+ * @mode: link autonegotiation mode
+ * @interface: the PHY interface mode being configured
+ * @advertising: the ethtool advertisement mask
+ *
+ * Configure a Clause 22 PCS PHY with the appropriate negotiation
+ * parameters for the @mode, @interface and @advertising parameters.
+ * Returns negative error number on failure, zero if the advertisement
+ * has not changed, or positive if there is a change.
+ */
+int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising)
+{
+	bool changed;
+	u16 bmcr;
+	int ret;
+
+	ret = phylink_mii_c22_pcs_set_advertisement(pcs, interface,
+						    advertising);
+	if (ret < 0)
+		return ret;
+
+	changed = ret > 0;
+
+	bmcr = mode == MLO_AN_INBAND ? BMCR_ANENABLE : 0;
+	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
+			     BMCR_ANENABLE, bmcr);
+	if (ret < 0)
+		return ret;
+
+	return changed ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
+
 /**
  * phylink_mii_c22_pcs_an_restart() - restart 802.3z autonegotiation
  * @pcs: a pointer to a &struct mdio_device.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 057f78263a46..1aad2aea4610 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -478,6 +478,9 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					  phy_interface_t interface,
 					  const unsigned long *advertising);
+int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
-- 
2.20.1

