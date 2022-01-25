Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3F49B911
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585793AbiAYQo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584901AbiAYQkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:40:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA3AC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XACUOeugzdd2Y6kVL7iKjy+g4iyoeEB5Gq8yHVRx5Cw=; b=kxCbMfjYJcmntrnUrVu6OqEOZ7
        XYVQjVb7aJsr82cbAgBPyyzz45h4+NJKKCNpGTUI5fuJSecFQZ+VM/fvrfgJu1pBAKHIFzxuhPUYI
        ApiDmiTiSx2AD3KA+/yqhrBQgeg7GmfBuNBKpT/Z5Gk9zlp7/L7OaU0zTFyGIUkJ+DkTprUfoHptY
        d9JUt8nFWCm83vFbF6xsnzbIXc80zxc5u+10ZSGbqRPvEQZk5JSm0dvQbNwqsu2Yj0t2EyjVaBrvB
        2i+qGA+FW+/xB+AniB9JhXLz/w8MpygSF1fBMeVSRqz+yYD7qgTUFJEgdiVvqm/2dniiH5t451+QN
        VgIxtUpQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57418 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOs5-0002Bl-4R; Tue, 25 Jan 2022 16:40:41 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOs4-005LSp-HF; Tue, 25 Jan 2022 16:40:40 +0000
In-Reply-To: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
References: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] net: stmmac/xpcs: convert to pcs_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOs4-005LSp-HF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:40:40 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac explicitly calls the xpcs driver to validate the ethtool
linkmodes. This is no longer necessary as phylink now supports
validation through a PCS method. Convert both drivers to use this
new mechanism.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ---
 drivers/net/pcs/pcs-xpcs.c                    | 27 ++++++++-----------
 include/linux/pcs/pcs-xpcs.h                  |  2 --
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bd20920daf7b..6c270785cf68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -958,10 +958,6 @@ static void stmmac_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mac_supported);
 	linkmode_and(state->advertising, state->advertising, mac_supported);
-
-	/* If PCS is supported, check which modes it supports. */
-	if (priv->hw->xpcs)
-		xpcs_validate(priv->hw->xpcs, supported, state);
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index f45821524fab..61418d4dc0cd 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -632,35 +632,29 @@ static void xpcs_resolve_pma(struct dw_xpcs *xpcs,
 	}
 }
 
-void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
-		   struct phylink_link_state *state)
+static int xpcs_validate(struct phylink_pcs *pcs, unsigned long *supported,
+			 const struct phylink_link_state *state)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported) = { 0, };
 	const struct xpcs_compat *compat;
+	struct dw_xpcs *xpcs;
 	int i;
 
-	/* phylink expects us to report all supported modes with
-	 * PHY_INTERFACE_MODE_NA, just don't limit the supported and
-	 * advertising masks and exit.
-	 */
-	if (state->interface == PHY_INTERFACE_MODE_NA)
-		return;
-
-	linkmode_zero(xpcs_supported);
-
+	xpcs = phylink_pcs_to_xpcs(pcs);
 	compat = xpcs_find_compat(xpcs->id, state->interface);
 
-	/* Populate the supported link modes for this
-	 * PHY interface type
+	/* Populate the supported link modes for this PHY interface type.
+	 * FIXME: what about the port modes and autoneg bit? This masks
+	 * all those away.
 	 */
 	if (compat)
 		for (i = 0; compat->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
 			set_bit(compat->supported[i], xpcs_supported);
 
 	linkmode_and(supported, supported, xpcs_supported);
-	linkmode_and(state->advertising, state->advertising, xpcs_supported);
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(xpcs_validate);
 
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces)
 {
@@ -1120,6 +1114,7 @@ static const struct xpcs_id xpcs_id_list[] = {
 };
 
 static const struct phylink_pcs_ops xpcs_phylink_ops = {
+	.pcs_validate = xpcs_validate,
 	.pcs_config = xpcs_config,
 	.pcs_get_state = xpcs_get_state,
 	.pcs_link_up = xpcs_link_up,
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 3126a4924d92..266eb26fb029 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -31,8 +31,6 @@ void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		  phy_interface_t interface, int speed, int duplex);
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		   unsigned int mode);
-void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
-		   struct phylink_link_state *state);
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-- 
2.30.2

