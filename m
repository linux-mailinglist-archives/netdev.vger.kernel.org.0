Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC6B227E10
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgGULEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGULEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D2FC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MBB7XBSiuzlBGtBsJeXZFEDRZgVQ9B1KzsBZbQZHQoo=; b=p9OtEciY2HKcLxVSINdKLcCVfk
        eYfIpcqla2rQ6nkshAcJG4PGtsaifWcoF5689cgc+reh8e0w6nbJdcaJqYiy5ADhGi80CHaILIAaG
        gzMqubkAZABnZEjSK4yc+jRC7b1pmKFqwoJh2bKrMAYpw/PAJ7hz+Zc7Nd8uVHY9a3N3QtoiK4Rhn
        SNoB9mvn2qsbz/HYCNpYyjANZSvEuav9Fp/2Rgb1v7lNgVMLzzt6aHyfsxorZolTJVNEETzKlzU/+
        UZPdeNWnJs6veqRvbEkCoAjV2FpAjNWGscHOvOxQfKCedQknOrjY9OXgWrWvwtPYqPeUdNuX56ydx
        TtezmQ3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41784 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4q-0004HN-2y; Tue, 21 Jul 2020 12:04:52 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4p-0004Te-Rq; Tue, 21 Jul 2020 12:04:51 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 14/14] net: phylink: add interface to configure
 clause 22 PCS PHY
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4p-0004Te-Rq@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:51 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface to configure the advertisement for a clause 22 PCS
PHY, and set the AN enable flag in the BMCR appropriately.

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b57cd2142786..32b4bd6a5b55 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2442,6 +2442,43 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
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

