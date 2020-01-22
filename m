Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD45145750
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgAVN7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:59:49 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54252 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgAVN7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:59:48 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 490951A00AF;
        Wed, 22 Jan 2020 14:59:46 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D0481A074F;
        Wed, 22 Jan 2020 14:59:46 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B4A2C20364;
        Wed, 22 Jan 2020 14:59:45 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next 2/2] dpaa_eth: support all modes with rate adapting PHYs
Date:   Wed, 22 Jan 2020 15:59:33 +0200
Message-Id: <1579701573-6609-3-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
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

As it only worked in other modes besides 10G because the PHY
was not configured by its driver to remove them, this is not
really a bug fix but more of a feature add.

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

