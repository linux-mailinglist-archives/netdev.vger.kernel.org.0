Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21615B4398
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiIJBNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiIJBNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:13:01 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6F4146D11
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:12:29 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1oWp2h-0001OX-2L;
        Sat, 10 Sep 2022 03:12:19 +0200
Date:   Sat, 10 Sep 2022 02:12:12 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Subject: [PATCH] net: dsa: mt7530: add support for in-band link status
Message-ID: <YxvkbO9PoNi86BZa@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read link status from SGMII PCS for in-band managed 2500Base-X and
1000Base-X connection on a MAC port of the MT7531. This is needed to
get the SFP cage working which is connected to SGMII interface of
port 5 of the MT7531 switch IC on the Bananapi BPi-R3 board.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 48 +++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 13 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2703,9 +2703,6 @@ mt7531_mac_config(struct dsa_switch *ds,
 	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
-		if (phylink_autoneg_inband(mode))
-			return -EINVAL;
-
 		return mt7531_sgmii_setup_mode_force(priv, port, interface);
 	default:
 		return -EINVAL;
@@ -2781,13 +2778,6 @@ unsupported:
 		return;
 	}
 
-	if (phylink_autoneg_inband(mode) &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII) {
-		dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
-			__func__);
-		return;
-	}
-
 	mcr_cur = mt7530_read(priv, MT7530_PMCR_P(port));
 	mcr_new = mcr_cur;
 	mcr_new &= ~PMCR_LINK_SETTINGS_MASK;
@@ -2924,6 +2914,9 @@ static void mt753x_phylink_get_caps(stru
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 				   MAC_10 | MAC_100 | MAC_1000FD;
 
+	if ((priv->id == ID_MT7531) && mt753x_is_mac_port(port))
+		config->mac_capabilities |= MAC_2500FD;
+
 	/* This driver does not make use of the speed, duplex, pause or the
 	 * advertisement in its mac_config, so it is safe to mark this driver
 	 * as non-legacy.
@@ -3019,16 +3012,43 @@ mt7531_sgmii_pcs_get_state_an(struct mt7
 	return 0;
 }
 
+static void
+mt7531_sgmii_pcs_get_state_inband(struct mt7530_priv *priv, int port,
+				  struct phylink_link_state *state)
+{
+	unsigned int val;
+
+	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
+	state->link = !!(val & MT7531_SGMII_LINK_STATUS);
+	if (!state->link)
+		return;
+
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+		state->speed = SPEED_2500;
+	else
+		state->speed = SPEED_1000;
+
+	state->duplex = DUPLEX_FULL;
+	state->pause = 0;
+}
+
 static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
 				 struct phylink_link_state *state)
 {
 	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
 	int port = pcs_to_mt753x_pcs(pcs)->port;
+	unsigned int val;
 
-	if (state->interface == PHY_INTERFACE_MODE_SGMII)
+	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		mt7531_sgmii_pcs_get_state_an(priv, port, state);
-	else
-		state->link = false;
+		return;
+	} else if ((state->interface == PHY_INTERFACE_MODE_1000BASEX) ||
+		   (state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
+		mt7531_sgmii_pcs_get_state_inband(priv, port, state);
+		return;
+	}
+
+	state->link = false;
 }
 
 static int mt753x_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
@@ -3069,6 +3089,8 @@ mt753x_setup(struct dsa_switch *ds)
 		priv->pcs[i].pcs.ops = priv->info->pcs_ops;
 		priv->pcs[i].priv = priv;
 		priv->pcs[i].port = i;
+		if (mt753x_is_mac_port(i))
+			priv->pcs[i].pcs.poll = 1;
 	}
 
 	ret = priv->info->sw_setup(ds);
