Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709684FB7FF
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344714AbiDKJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344706AbiDKJsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:48:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6071A3CA70
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z3rwZCCM0LZHsBKwzS3UKuH2CbTPGJIJtGg/wOkxfVg=; b=PThn6RVRkxXvFDmwfY1Nn9FH60
        TuKNTsJlNoxA/nG6p84qCSsdkORe5RmV1SSNqv5FjqX1wvTpieHBMaqDBxIfMnlNSWny60D4KhxXr
        y3dbI6Thv+8RXGqJMgfc4ME4PAMSjgyuNMKhKcYQ9tQJ7unfhqGVmON6MWCw5PmwXoY9YzxHKknll
        Ac3gveRJKA+ngM7822XH/8SIX0W0zp0jkMIjO1VQYfn2cgr2eBkG/S7gpENYtfexzRxlfwlhZDl0f
        AZcnd+NF+V0P9cfk4uygYAuKrxNQLhjTlVLhwdXa2wPs1wbOdF6bZmLmLz4vEfP9Uh2NYR8ZUAKpj
        mhc2l2nA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52872 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndqcz-0000Hk-Da; Mon, 11 Apr 2022 10:46:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndqcy-0055RU-HE; Mon, 11 Apr 2022 10:46:32 +0100
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
Subject: [PATCH net-next v2 8/9] net: dsa: mt7530: move autoneg handling to
 PCS validation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndqcy-0055RU-HE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 10:46:32 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the autoneg bit handling to the PCS validation, which allows us to
get rid of mt753x_phylink_validate() and rely on the default
phylink_generic_validate() implementation for the MAC side.

Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1c0d931973e5..0ee2cb7e5664 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2900,25 +2900,16 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
 	priv->info->mac_port_get_caps(ds, port, config);
 }
 
-static void
-mt753x_phylink_validate(struct dsa_switch *ds, int port,
-			unsigned long *supported,
-			struct phylink_link_state *state)
+static int mt753x_pcs_validate(struct phylink_pcs *pcs,
+			       unsigned long *supported,
+			       const struct phylink_link_state *state)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	u32 caps;
-
-	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
-
-	phylink_set_port_modes(mask);
-	phylink_get_linkmodes(mask, state->interface, caps);
+	/* Autonegotiation is not supported in TRGMII nor 802.3z modes */
+	if (state->interface == PHY_INTERFACE_MODE_TRGMII ||
+	    phy_interface_mode_is_8023z(state->interface))
+		phylink_clear(supported, Autoneg);
 
-	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
-	    !phy_interface_mode_is_8023z(state->interface))
-		phylink_set(mask, Autoneg);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	return 0;
 }
 
 static void mt7530_pcs_get_state(struct phylink_pcs *pcs,
@@ -3020,12 +3011,14 @@ static void mt7530_pcs_an_restart(struct phylink_pcs *pcs)
 }
 
 static const struct phylink_pcs_ops mt7530_pcs_ops = {
+	.pcs_validate = mt753x_pcs_validate,
 	.pcs_get_state = mt7530_pcs_get_state,
 	.pcs_config = mt753x_pcs_config,
 	.pcs_an_restart = mt7530_pcs_an_restart,
 };
 
 static const struct phylink_pcs_ops mt7531_pcs_ops = {
+	.pcs_validate = mt753x_pcs_validate,
 	.pcs_get_state = mt7531_pcs_get_state,
 	.pcs_config = mt753x_pcs_config,
 	.pcs_an_restart = mt7531_pcs_an_restart,
@@ -3117,7 +3110,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_mirror_add	= mt753x_port_mirror_add,
 	.port_mirror_del	= mt753x_port_mirror_del,
 	.phylink_get_caps	= mt753x_phylink_get_caps,
-	.phylink_validate	= mt753x_phylink_validate,
 	.phylink_mac_select_pcs	= mt753x_phylink_mac_select_pcs,
 	.phylink_mac_config	= mt753x_phylink_mac_config,
 	.phylink_mac_link_down	= mt753x_phylink_mac_link_down,
-- 
2.30.2

