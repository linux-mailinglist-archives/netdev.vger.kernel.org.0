Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A15E1FF141
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFRMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:09:10 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48800 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFRMJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:09:08 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DEAED200D4B;
        Thu, 18 Jun 2020 14:09:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D2394200D4A;
        Thu, 18 Jun 2020 14:09:05 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6345A2048B;
        Thu, 18 Jun 2020 14:09:05 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] net: phylink: add interface to configure clause 22 PCS PHY
Date:   Thu, 18 Jun 2020 15:08:33 +0300
Message-Id: <20200618120837.27089-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618120837.27089-1-ioana.ciornei@nxp.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Add helper for clause 22 PCS configuration via the MII bus.
Apart from applying the advertisements, the pcs_config helper also sets
up the BMCR_ANENABLE depending on the in-band AN state.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phylink.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0ab65fb75258..9670e8757fe1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2267,6 +2267,43 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
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
index cc5b452a184e..d979832d0c71 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -410,6 +410,9 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					  phy_interface_t interface,
 					  const unsigned long *advertising);
+int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
-- 
2.25.1

