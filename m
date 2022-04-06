Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA5D4F6049
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiDFNmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiDFNlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:41:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9636A4912
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 03:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0iZDBwJODqFadHCfRWwr5Q22BQy93msRuIdplxb8Y5w=; b=z7G9hKgw97jEnVAjvYZEMkorry
        yNQwo0f4VTGHekHrdB95ReuIsJqbWRkm9Oyiiuh8KnH7yV3tfleirUOheAFphUBJYxYk0wTgfmm0N
        DlLWNh/sGzbli61JnGZuIqnR7Uh8yjFT7d7yzaEPOYn+wicIcJDImztmTlUyDmU+Dc5I+ppM9nKuL
        3r58Htt9MmT3cqkJr3OYmEvyzVm+ckpBDreNp075gukG9WOaAzltYjKcqkd6XTzJ9agGpqS19Xavv
        s12179FV8kCYNdgqN7x8zlKFsnsPrWojjQSEyvd0JETb609bDqP+cA/CtPwcgobPU/8Z8bLOEDv56
        MHIfxEtQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59982 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc3DO-0002ZA-VK; Wed, 06 Apr 2022 11:48:42 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc3DO-004hpp-23; Wed, 06 Apr 2022 11:48:42 +0100
In-Reply-To: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
References: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 2/9] net: dsa: mt7530: populate supported_interfaces
 and mac_capabilities
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc3DO-004hpp-23@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 11:48:42 +0100
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
index 20cadee13361..954d738c75f2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2389,6 +2389,32 @@ mt7531_setup(struct dsa_switch *ds)
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
@@ -2425,6 +2451,37 @@ static bool mt7531_is_rgmii_port(struct mt7530_priv *priv, u32 port)
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
@@ -2904,6 +2961,18 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
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
@@ -3139,6 +3208,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.port_mirror_add	= mt753x_port_mirror_add,
 	.port_mirror_del	= mt753x_port_mirror_del,
+	.phylink_get_caps	= mt753x_phylink_get_caps,
 	.phylink_validate	= mt753x_phylink_validate,
 	.phylink_mac_link_state	= mt753x_phylink_mac_link_state,
 	.phylink_mac_config	= mt753x_phylink_mac_config,
@@ -3156,6 +3226,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3167,6 +3238,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
+		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.phy_mode_supported = mt7530_phy_mode_supported,
 		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
@@ -3179,6 +3251,7 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7531_ind_phy_write,
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
+		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.phy_mode_supported = mt7531_phy_mode_supported,
 		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
@@ -3241,6 +3314,7 @@ mt7530_probe(struct mdio_device *mdiodev)
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

