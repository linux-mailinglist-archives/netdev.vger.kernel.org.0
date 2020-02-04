Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70DB15187B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDKJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:09:03 -0500
Received: from inva021.nxp.com ([92.121.34.21]:35638 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgBDKJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 05:09:02 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BF397228BA5;
        Tue,  4 Feb 2020 11:09:00 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BCFEF228B9C;
        Tue,  4 Feb 2020 11:09:00 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 54A6920564;
        Tue,  4 Feb 2020 11:09:00 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net v3] dpaa_eth: support all modes with rate adapting PHYs
Date:   Tue,  4 Feb 2020 12:08:58 +0200
Message-Id: <1580810938-21047-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop removing modes that are not supported on the system interface
when the connected PHY is capable of rate adaptation. This addresses
an issue with the LS1046ARDB board 10G interface no longer working
with an 1G link partner after autonegotiation support was added
for the Aquantia PHY on board in

commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")

Before this commit the values advertised by the PHY were not
influenced by the dpaa_eth driver removal of system-side unsupported
modes as the aqr_config_aneg() was basically a no-op. After this
commit, the modes removed by the dpaa_eth driver were no longer
advertised thus autonegotiation with 1G link partners failed.

Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---

change in v3: no longer add an API for checking the capability,
  rely on PHY vendor to determine if more modes may be available
  through rate adaptation so stop removing them

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 09dbcd819d84..fd93d542f497 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2453,6 +2453,9 @@ static void dpaa_adjust_link(struct net_device *net_dev)
 	mac_dev->adjust_link(mac_dev);
 }
 
+/* The Aquantia PHYs are capable of performing rate adaptation */
+#define PHY_VEND_AQUANTIA	0x03a1b400
+
 static int dpaa_phy_init(struct net_device *net_dev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
@@ -2471,9 +2474,14 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
-	/* Remove any features not supported by the controller */
-	ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
-	linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	/* Unless the PHY is capable of rate adaptation */
+	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
+	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+		/* remove any features not supported by the controller */
+		ethtool_convert_legacy_u32_to_link_mode(mask,
+							mac_dev->if_support);
+		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	}
 
 	phy_support_asym_pause(phy_dev);
 
-- 
2.1.0

