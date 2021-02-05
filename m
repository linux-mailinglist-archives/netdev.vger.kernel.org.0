Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5031095E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 11:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhBEKnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 05:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBEKkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:40:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9A8C0617A9
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K1K7uBJCPyQw/92cN/7GZ39RXp2aITbLzTtfIhjAFrQ=; b=OuIsPzyTIrid8i/dVL/mIsE8LN
        E+6KYfCcd+u0RDpxURnvu2B3osPrbYgs+psuDyjKluKW6ZnUeBEzbs9lUdfMBX9NGQ7jqJ/CfbA5j
        eam7rAuI2WqLlMDznThIeYF3dlEK+gekRcOswF7V1vdbMYWwbE9EpiEzkezIpWq/cGvfQEAs6zXAi
        0diyNNS5ABchK3RcRjVbts6J9bRsLI53qhHG2EhiU/S1bd2USk5bEdqAoULI1jZsiIZwgYi8h/9RS
        X8HsUbkBQeOp6F9D/S/Qkfe0874iutNBXR7SMhr1GJa5D5v0aEDp+pAAkOFMRYeIvsIVHfx/VZl7x
        VJsd3ShQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49112 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l7yWy-0007ea-H9; Fri, 05 Feb 2021 10:40:04 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l7yWy-0006oO-Aa; Fri, 05 Feb 2021 10:40:04 +0000
In-Reply-To: <20210205103859.GH1463@shell.armlinux.org.uk>
References: <20210205103859.GH1463@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: dpaa2-mac: add 1000BASE-X support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l7yWy-0006oO-Aa@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 05 Feb 2021 10:40:04 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that pcs-lynx supports 1000BASE-X, add support for this interface
mode to dpaa2-mac. pcs-lynx can be switched at runtime between SGMII
and 1000BASE-X mode, so allow dpaa2-mac to switch between these as
well.

This commit prepares the ground work for allowing 1G fiber connections
to be used with DPAA2 on the SolidRun CEX7 platforms.

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 69ad869446cf..3ddfb40eb5e4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -79,10 +79,20 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
 					phy_interface_t interface)
 {
 	switch (interface) {
+	/* We can switch between SGMII and 1000BASE-X at runtime with
+	 * pcs-lynx
+	 */
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (mac->pcs &&
+		    (mac->if_mode == PHY_INTERFACE_MODE_SGMII ||
+		     mac->if_mode == PHY_INTERFACE_MODE_1000BASEX))
+			return false;
+		return interface != mac->if_mode;
+
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_USXGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
@@ -122,13 +132,17 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 		fallthrough;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
 		phylink_set(mask, 1000baseT_Full);
+		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+			break;
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
 		break;
 	default:
 		goto empty_set;
-- 
2.20.1

