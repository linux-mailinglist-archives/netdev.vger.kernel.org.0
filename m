Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496AE4FB7F8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbiDKJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344695AbiDKJs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:48:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1959D3C710
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iRNfEGZY7a3N9KW4TbecZxEamM0S4cWMub5DzfJg+ZM=; b=1a+/Wg3b9nsLkj0g195ZD/hoAE
        VuK++5JIGQB76itX89ni/bGDzl2KKXq80/d66gkbFo6mw2wGI+ybiVDxiEmGQlyibjneWbntN2PcT
        7ZT3Ryzg7rwUWiWDDCDllVJC5JC8lU4uJE5ZG9i0j0qJLmLEjpUUKON13+Rook7/ZB1OCFMcPAbnl
        6/0diCY99fVgZevvJRn/12Z+pViDtJ5wn6ebxAZwaN3o0rG/UA3dKEOrF/k4jqHwd+/fOemw6egV7
        kSkq5UDBhVmGDoaoiEa9itSPxyyIckk75UXJewf3EY/Es5Gi/3eMi9kx3odOx20E05OaV2Iqohqt4
        xqc5jtvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52854 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndqcZ-0000Gb-Sz; Mon, 11 Apr 2022 10:46:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndqcY-0055Qp-W7; Mon, 11 Apr 2022 10:46:07 +0100
In-Reply-To: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
References: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v2 3/9] net: dsa: mt7530: remove interface checks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndqcY-0055Qp-W7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 10:46:06 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode, nor handle
PHY_INTERFACE_MODE_NA in the validation function. Remove these to
simplify the implementation.

Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 82 ----------------------------------------
 drivers/net/dsa/mt7530.h |  2 -
 2 files changed, 84 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 659aa687fe8c..4fdd75e88b1b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2415,37 +2415,6 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
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
@@ -2482,44 +2451,6 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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
@@ -2774,9 +2705,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	struct mt7530_priv *priv = ds->priv;
 	u32 mcr_cur, mcr_new;
 
-	if (!mt753x_phy_mode_supported(ds, port, state))
-		goto unsupported;
-
 	switch (port) {
 	case 0 ... 4: /* Internal phy */
 		if (state->interface != PHY_INTERFACE_MODE_GMII)
@@ -2994,12 +2922,6 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct mt7530_priv *priv = ds->priv;
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    !mt753x_phy_mode_supported(ds, port, state)) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 
 	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
@@ -3226,7 +3148,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
@@ -3238,7 +3159,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
@@ -3251,7 +3171,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
-		.phy_mode_supported = mt7531_phy_mode_supported,
 		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
 		.mac_port_config = mt7531_mac_config,
@@ -3314,7 +3233,6 @@ mt7530_probe(struct mdio_device *mdiodev)
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

