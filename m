Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07567454BE4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbhKQR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbhKQR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:27:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EFBC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 09:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lb+hUMX+zQQEQKQ9XTrSwdOhT78PjA7V1LCK8CfryDM=; b=l2EuMAcOHtfAewh4ev17YnN8pP
        QuHhKgEcWMj0BbXgf5AqcPk0EDIkHmU9nNZPIgFGwSwhLz9Sk6Wu4oRfGJJXzH9ox48MNzPEMRJhX
        ud+2ey4r9rcYypFJdSaWgLMOcArTZIcWeXMBHOTLskPyN0AZdv89K8Wa7MH1nGu9/MfHxLdLon4C8
        9o7I77CraMUVYFJhjnHsKFLiE0NEMt5pyaq0L+CSu4idZp7LJX4SeJoujRJovZLyo6avp+F4SvRfI
        3MFVgYysj9h3yfoSBqP3I2Fs04lqMTkb4JZ2z+kk3PkMyDDSIURqwKbf3ZSjMBFUSdo1tjPQEZJqS
        CFcRaQFw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46362 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfI-00029T-A2; Wed, 17 Nov 2021 17:24:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfH-0085K6-RJ; Wed, 17 Nov 2021 17:24:07 +0000
In-Reply-To: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
References: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: dpaa2-mac: remove interface checks in
 dpaa2_mac_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnOfH-0085K6-RJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 17:24:07 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode, nor handle
PHY_INTERFACE_MODE_NA in the validation function. Remove these to
simplify the implementation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 35 -------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 176ce0a03716..bcc7fe127d91 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -90,53 +90,18 @@ static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
 	return err;
 }
 
-static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
-					phy_interface_t interface)
-{
-	switch (interface) {
-	/* We can switch between SGMII and 1000BASE-X at runtime with
-	 * pcs-lynx
-	 */
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-		if (mac->pcs &&
-		    (mac->if_mode == PHY_INTERFACE_MODE_SGMII ||
-		     mac->if_mode == PHY_INTERFACE_MODE_1000BASEX))
-			return false;
-		return interface != mac->if_mode;
-
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		return (interface != mac->if_mode);
-	default:
-		return true;
-	}
-}
-
 static void dpaa2_mac_validate(struct phylink_config *config,
 			       unsigned long *supported,
 			       struct phylink_link_state *state)
 {
-	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    dpaa2_mac_phy_mode_mismatch(mac, state->interface)) {
-		goto empty_set;
-	}
-
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_USXGMII:
 		phylink_set_10g_modes(mask);
-- 
2.30.2

