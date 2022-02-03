Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174574A8A21
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352864AbiBCRbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352869AbiBCRbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:31:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC588C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PAIBtkJWxx41Bed28ZKjzGiXv8E/+MRt7rygE5BGnds=; b=ceiZE/0dBQ3RXKjfq7JsAlVYfz
        GstggX5AHZtw3z9WONYQZMhHq28Q6aP91X7BurfurFm3EaPcJ9dN8hv+AKrGNDur/+5961MZ2CrNz
        hfshbBmJJiuldfSTNDPT7fEqGFL524niOWWXs0cdCGbwXX7Hl8lofMrc/DgJ1d1HToGqhAPynBcWt
        qiVV8vp4uA7AtPkonjrucT2FAeBpDUmLo/6x6Q4jvSxCwbwo2F7Xnuk7hJsAk6xPKqJC52ipsxY5n
        GFPV525aVrBaReogFaAPZmRb5XIgYuHVr/zrw1flCR6XSJ2YRF9cHROgdz162w9dMLbt4i80yHJRo
        Bc06LLkQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54878 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFfx0-0002zA-JM; Thu, 03 Feb 2022 17:31:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFfx0-006X6e-0I; Thu, 03 Feb 2022 17:31:18 +0000
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
Subject: [PATCH RFC net-next 1/7] net: dsa: mt7530: populate
 supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFfx0-006X6e-0I@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 17:31:18 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces for mt7530, mt7531 and mt7621 DSA
switches. Filling this in will enable phylink to pre-check the PHY
interface mode against the the supported interfaces bitmap prior to
calling the validate function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 68 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h |  2 ++
 2 files changed, 70 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index bc77a26c825a..1d01738cacea 100644
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
@@ -2420,6 +2446,35 @@ static bool mt7531_is_rgmii_port(struct mt7530_priv *priv, u32 port)
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
+		break;
+	}
+}
+
 static bool
 mt7531_phy_mode_supported(struct dsa_switch *ds, int port,
 			  const struct phylink_link_state *state)
@@ -2904,6 +2959,14 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	return 0;
 }
 
+static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
+				    struct phylink_config *config)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	priv->info->mac_port_get_caps(ds, port, config);
+}
+
 static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
@@ -3139,6 +3202,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.port_mirror_add	= mt753x_port_mirror_add,
 	.port_mirror_del	= mt753x_port_mirror_del,
+	.phylink_get_caps	= mt753x_phylink_get_caps,
 	.phylink_validate	= mt753x_phylink_validate,
 	.phylink_mac_link_state	= mt753x_phylink_mac_link_state,
 	.phylink_mac_config	= mt753x_phylink_mac_config,
@@ -3156,6 +3220,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3167,6 +3232,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3179,6 +3245,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7531_ind_phy_write,
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
+		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.phy_mode_supported = mt7531_phy_mode_supported,
 		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
@@ -3241,6 +3308,7 @@ mt7530_probe(struct mdio_device *mdiodev)
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

