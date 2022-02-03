Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1EF4A8A22
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352873AbiBCRb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352869AbiBCRb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:31:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A68C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C+8A6ZpJPI8MbtjHDSCKNKBSDC6C5XIriSAssOx9qfg=; b=Ix+vQdA5G7/5V/PQlNw1uK87+6
        REGC9ihwv6p1YF4Z0pk0MJSnouC0ksLBMUG9nkf66uBGmSSPhLbwPz57o3tA68XjR8F599pb/Of6s
        Gnp9rfhkSED87+J4AHnhAavXQOiGvrPzXfIOdwpr+0MCUmTWAdJ6c8eexKJ3qiOeGv+xnpeSH6+q9
        Kw9UBGngcyso80324h6S1COrHVVIqs1WGhZCSly5arUn5Ng6hpN3sBzTHBD0aeec/HsUSQaQ6GAso
        zaxr5EcOEnwl2IGjOaVijVCJpcqAfZgWbXYdb1NxK2pbg3uB+h3nYmxxlrUWKqzLlaxtNLS2+KITw
        hs2wwC/A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54880 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFfx5-0002zO-NF; Thu, 03 Feb 2022 17:31:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFfx5-006X6k-3w; Thu, 03 Feb 2022 17:31:23 +0000
In-Reply-To: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 2/7] net: dsa: mt7530: remove interface checks
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFfx5-006X6k-3w@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 17:31:23 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode, nor handle
PHY_INTERFACE_MODE_NA in the validation function. Remove these to
simplify the implementation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 82 ----------------------------------------
 drivers/net/dsa/mt7530.h |  2 -
 2 files changed, 84 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1d01738cacea..ae54c6a49676 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2410,37 +2410,6 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
-static bool
-mt7530_phy_mode_supported(struct dsa_switch *ds, int port,
-			  const struct phylink_link_state *state)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	switch (port) {
-	case 0 ... 4: /* Internal phy */
-		if (state->interface != PHY_INTERFACE_MODE_GMII)
-			return false;
-		break;
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
-		if (!phy_interface_mode_is_rgmii(state->interface) &&
-		    state->interface != PHY_INTERFACE_MODE_MII &&
-		    state->interface != PHY_INTERFACE_MODE_GMII)
-			return false;
-		break;
-	case 6: /* 1st cpu port */
-		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
-		    state->interface != PHY_INTERFACE_MODE_TRGMII)
-			return false;
-		break;
-	default:
-		dev_err(priv->dev, "%s: unsupported port: %i\n", __func__,
-			port);
-		return false;
-	}
-
-	return true;
-}
-
 static bool mt7531_is_rgmii_port(struct mt7530_priv *priv, u32 port)
 {
 	return (port == 5) && (priv->p5_intf_sel != P5_INTF_SEL_GMAC5_SGMII);
@@ -2475,44 +2444,6 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
-static bool
-mt7531_phy_mode_supported(struct dsa_switch *ds, int port,
-			  const struct phylink_link_state *state)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	switch (port) {
-	case 0 ... 4: /* Internal phy */
-		if (state->interface != PHY_INTERFACE_MODE_GMII)
-			return false;
-		break;
-	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
-		if (mt7531_is_rgmii_port(priv, port))
-			return phy_interface_mode_is_rgmii(state->interface);
-		fallthrough;
-	case 6: /* 1st cpu port supports sgmii/8023z only */
-		if (state->interface != PHY_INTERFACE_MODE_SGMII &&
-		    !phy_interface_mode_is_8023z(state->interface))
-			return false;
-		break;
-	default:
-		dev_err(priv->dev, "%s: unsupported port: %i\n", __func__,
-			port);
-		return false;
-	}
-
-	return true;
-}
-
-static bool
-mt753x_phy_mode_supported(struct dsa_switch *ds, int port,
-			  const struct phylink_link_state *state)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	return priv->info->phy_mode_supported(ds, port, state);
-}
-
 static int
 mt753x_pad_setup(struct dsa_switch *ds, const struct phylink_link_state *state)
 {
@@ -2773,9 +2704,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	struct mt7530_priv *priv = ds->priv;
 	u32 mcr_cur, mcr_new;
 
-	if (!mt753x_phy_mode_supported(ds, port, state))
-		goto unsupported;
-
 	switch (port) {
 	case 0 ... 4: /* Internal phy */
 		if (state->interface != PHY_INTERFACE_MODE_GMII)
@@ -2991,12 +2919,6 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct mt7530_priv *priv = ds->priv;
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    !mt753x_phy_mode_supported(ds, port, state)) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 
 	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
@@ -3221,7 +3143,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
@@ -3233,7 +3154,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
@@ -3246,7 +3166,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
-		.phy_mode_supported = mt7531_phy_mode_supported,
 		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
 		.mac_port_config = mt7531_mac_config,
@@ -3309,7 +3228,6 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
 	    !priv->info->phy_read || !priv->info->phy_write ||
 	    !priv->info->mac_port_get_caps ||
-	    !priv->info->phy_mode_supported ||
 	    !priv->info->mac_port_validate ||
 	    !priv->info->mac_port_get_state || !priv->info->mac_port_config)
 		return -EINVAL;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index e285b68ba354..cbebbcc76509 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -771,8 +771,6 @@ struct mt753x_info {
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
 				  struct phylink_config *config);
-	bool (*phy_mode_supported)(struct dsa_switch *ds, int port,
-				   const struct phylink_link_state *state);
 	void (*mac_port_validate)(struct dsa_switch *ds, int port,
 				  unsigned long *supported);
 	int (*mac_port_get_state)(struct dsa_switch *ds, int port,
-- 
2.30.2

