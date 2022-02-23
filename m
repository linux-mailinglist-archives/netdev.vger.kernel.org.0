Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213404C1162
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiBWLfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239950AbiBWLfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:35:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954BF90FFE
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1pO+FM+sU+5kB92vV6m2RtEZamjxXzg3+RlCwPtnMTM=; b=tAeM9PVwvfNYbqfZhLEn7jjwWM
        dJjHD14QUPs2XKM5YBHp9xHZZ51dg4/ES5TWHnJiymVCK9RYXE1jfBdMm+k8VrWZRqRSwQtOVp47J
        9lAGA7J5YIY/wDsvq3nFENeWcqvFE9fBTJ9VPoOVVahejY3cdNV+HORNKWehEa960dBFWq5mmbFnr
        ivyE11PLQgs2o/6KHoCZtFN/qU6fC5oLMAsE1XPcFr/0+MundzDVCkLvViV8m6a4SZ4AMc70maLZZ
        sdy6tR3UFbmWKOipe/vwOgAgSSYJelcRqZZdfoJ0mME1SVwPlR3EW8isNPUnImXz5ASLnwoeFljXn
        weOsXyKQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57384 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMput-0002kF-JG; Wed, 23 Feb 2022 11:34:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMput-00AJp0-08; Wed, 23 Feb 2022 11:34:43 +0000
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
Subject: [PATCH RFC net-next v2 06/10] net: dsa: mt7530: only indicate
 linkmodes that can be supported
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMput-00AJp0-08@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 23 Feb 2022 11:34:43 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mt7530 is not using the basex helper, it becomes unnecessary to
indicate support for both 1000baseX and 2500baseX when one of the 803.3z
PHY interface modes is being selected. Ensure that the driver indicates
only those linkmodes that can actually be supported by the PHY interface
mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 14 +++++++++-----
 drivers/net/dsa/mt7530.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 25c3c54f1380..db1d13718ff1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2517,13 +2517,14 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 }
 
 static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
+				  phy_interface_t interface,
 				  unsigned long *supported)
 {
 	/* Port5 supports ethier RGMII or SGMII.
 	 * Port6 supports SGMII only.
 	 */
-	if (port == 6 ||
-	    (port == 5 && !mt7531_is_rgmii_port(priv, port))) {
+	if ((port == 5 || port == 6) &&
+	    interface == PHY_INTERFACE_MODE_2500BASEX) {
 		phylink_set(supported, 2500baseX_Full);
 		phylink_set(supported, 2500baseT_Full);
 	}
@@ -2898,16 +2899,18 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
 
 static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
+			 phy_interface_t interface,
 			 unsigned long *supported)
 {
 }
 
 static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
+				     phy_interface_t interface,
 				     unsigned long *supported)
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	mt7531_sgmii_validate(priv, port, supported);
+	mt7531_sgmii_validate(priv, port, interface, supported);
 }
 
 static void
@@ -2930,12 +2933,13 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	}
 
 	/* This switch only supports 1G full-duplex. */
-	if (state->interface != PHY_INTERFACE_MODE_MII) {
+	if (state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_2500BASEX)
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	}
 
-	priv->info->mac_port_validate(ds, port, mask);
+	priv->info->mac_port_validate(ds, port, state->interface, mask);
 
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index cbebbcc76509..73cfd29fbb17 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -772,6 +772,7 @@ struct mt753x_info {
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
 				  struct phylink_config *config);
 	void (*mac_port_validate)(struct dsa_switch *ds, int port,
+				  phy_interface_t interface,
 				  unsigned long *supported);
 	int (*mac_port_get_state)(struct dsa_switch *ds, int port,
 				  struct phylink_link_state *state);
-- 
2.30.2

