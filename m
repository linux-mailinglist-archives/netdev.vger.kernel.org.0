Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6384F14A6EE
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgA0PIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:08:00 -0500
Received: from inva021.nxp.com ([92.121.34.21]:40826 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgA0PH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 10:07:58 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 40A922177D8;
        Mon, 27 Jan 2020 16:07:57 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 33B7321779C;
        Mon, 27 Jan 2020 16:07:57 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DA1A6205A3;
        Mon, 27 Jan 2020 16:07:56 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting PHYs
Date:   Mon, 27 Jan 2020 17:07:51 +0200
Message-Id: <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
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
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index a301f0095223..d3eb235450e5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2471,9 +2471,13 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
-	/* Remove any features not supported by the controller */
-	ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
-	linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
+	    !phy_dev->rate_adaptation) {
+		/* Remove any features not supported by the controller */
+		ethtool_convert_legacy_u32_to_link_mode(mask,
+							mac_dev->if_support);
+		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
+	}
 
 	phy_support_asym_pause(phy_dev);
 
-- 
2.1.0

