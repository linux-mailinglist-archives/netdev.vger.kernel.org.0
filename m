Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7B4C115F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbiBWLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbiBWLe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:34:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1D290FE5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Puz/IyorYUj+Up5WRnmdev1B9wl9m70thAShf1Z+xZA=; b=Hhegpnm+4dgN+aYy77h2SK6w+h
        1Gg8JCTH8tV8AcYB+4389noRU9YogTaSC1eL7R65jhiBmKAJSMSqKmBt+v7UrWM7may3aOfq2pX7K
        QIkDDxVLXRvmttnU1JJ/Pg0barpWK80f2kLfidF+aKRt4juR7Ll+jAhObUSYwGXT3JcxvdeVk98wM
        6hxyl51PbCCsFaMybdTR63o7fJv8Cv3rpQqlC8ITg6NCNNItCZAzaOzKNH+lrmQdxpUtxn5Xk1Bd0
        ow0vG1zcgo6yc0XHuYsRFRgDgWNamfbM9lPYozyUzPi7OalkD04Oi4atGHpgmVhUvgEP8kZjVDrNs
        wvZfKL9g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57378 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMpue-0002jM-8u; Wed, 23 Feb 2022 11:34:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMpud-00AJoi-LR; Wed, 23 Feb 2022 11:34:27 +0000
In-Reply-To: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
References: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
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
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next v2 03/10] net: dsa: mt7530: populate
 supported_interfaces and mac_capabilities
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMpud-00AJoi-LR@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 23 Feb 2022 11:34:27 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for mt7530,
mt7531 and mt7621 DSA switches. Filling this in will enable phylink
to pre-check the PHY interface mode against the the supported
interfaces bitmap prior to calling the validate function, and will
eventually allow us to convert to using the generic validation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 74 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h |  2 ++
 2 files changed, 76 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e978a8a37bf5..b07fc7f4c723 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2384,6 +2384,32 @@ mt7531_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	switch (port) {
+	case 0 ... 4: /* Internal phy */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		break;
+
+	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		break;
+
+	case 6: /* 1st cpu port */
+		__set_bit(PHY_INTERFACE_MODE_RGMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_TRGMII,
+			  config->supported_interfaces);
+		break;
+	}
+}
+
 static bool
 mt7530_phy_mode_supported(struct dsa_switch *ds, int port,
 			  const struct phylink_link_state *state)
@@ -2420,6 +2446,37 @@ static bool mt7531_is_rgmii_port(struct mt7530_priv *priv, u32 port)
 	return (port == 5) && (priv->p5_intf_sel != P5_INTF_SEL_GMAC5_SGMII);
 }
 
+static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	switch (port) {
+	case 0 ... 4: /* Internal phy */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		break;
+
+	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
+		if (mt7531_is_rgmii_port(priv, port)) {
+			phy_interface_set_rgmii(config->supported_interfaces);
+			break;
+		}
+		fallthrough;
+
+	case 6: /* 1st cpu port supports sgmii/8023z only */
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  config->supported_interfaces);
+
+		config->mac_capabilities |= MAC_2500FD;
+		break;
+	}
+}
+
 static bool
 mt7531_phy_mode_supported(struct dsa_switch *ds, int port,
 			  const struct phylink_link_state *state)
@@ -2899,6 +2956,18 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	return 0;
 }
 
+static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
+				    struct phylink_config *config)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	/* This switch only supports full-duplex at 1Gbps */
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+				   MAC_10 | MAC_100 | MAC_1000FD;
+
+	priv->info->mac_port_get_caps(ds, port, config);
+}
+
 static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
@@ -3134,6 +3203,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.port_mirror_add	= mt753x_port_mirror_add,
 	.port_mirror_del	= mt753x_port_mirror_del,
+	.phylink_get_caps	= mt753x_phylink_get_caps,
 	.phylink_validate	= mt753x_phylink_validate,
 	.phylink_mac_link_state	= mt753x_phylink_mac_link_state,
 	.phylink_mac_config	= mt753x_phylink_mac_config,
@@ -3151,6 +3221,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3162,6 +3233,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3174,6 +3246,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7531_ind_phy_write,
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
+		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.phy_mode_supported = mt7531_phy_mode_supported,
 		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
@@ -3236,6 +3309,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 	 */
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
 	    !priv->info->phy_read || !priv->info->phy_write ||
+	    !priv->info->mac_port_get_caps ||
 	    !priv->info->phy_mode_supported ||
 	    !priv->info->mac_port_validate ||
 	    !priv->info->mac_port_get_state || !priv->info->mac_port_config)
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 91508e2feef9..e285b68ba354 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -769,6 +769,8 @@ struct mt753x_info {
 	int (*phy_write)(struct mt7530_priv *priv, int port, int regnum, u16 val);
 	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
+	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
+				  struct phylink_config *config);
 	bool (*phy_mode_supported)(struct dsa_switch *ds, int port,
 				   const struct phylink_link_state *state);
 	void (*mac_port_validate)(struct dsa_switch *ds, int port,
-- 
2.30.2

