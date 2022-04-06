Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AB14F6082
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiDFNlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiDFNlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:41:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF786A4329
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 03:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nkQnlSkGVlHWJHHvGkGYpD1QVqaP/kEBKctr3Hx+sNI=; b=arVupQ/OYBbfMrwp78KsDwMDSR
        T3c966/emWqyqr5qNHfoYCGzdZZVkRr22ybJ7i3gkwKRzCS3KqrkEnakJtpsz8F3+oyeRNs2dh9Bi
        tCLijgRKtNEw8G3yu7EU1qXf3CNVbsn8ttHndnU2iECJTViDEVLexA7GfzSYX+fgS03oTgwOIimv2
        YhTtNvEuMMWg1M0TYCp1sgHOhOrjr/y0F4VN8BTjceom+QaXxP0TnJz3a8mgjebNfSKcr87QLOysp
        UF8p6rY1GmtKgzwfkP+fAJrpZdMoiKQPjPw+DmENDrNROj1dcNHACtITEDNpra4x5OOhLcE1na86h
        vw/WsT+A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59980 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc3DJ-0002Yz-RR; Wed, 06 Apr 2022 11:48:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc3DI-004hpj-UU; Wed, 06 Apr 2022 11:48:36 +0100
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
Subject: [PATCH net-next 1/9] net: dsa: mt7530: 1G can also support 1000BASE-X
 link mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc3DI-004hpj-UU@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 11:48:36 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using an external PHY connected using RGMII to mt7531 port 5, the
PHY can be used to used support 1000BASE-X connections. Moreover, if
1000BASE-T is supported, then we should allow 1000BASE-X as well, since
which are supported is a property of the PHY.

Therefore, it makes no sense to exclude this from the linkmodes when
1000BASE-T is supported.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 19f0035d4410..20cadee13361 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2539,13 +2539,8 @@ static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
 	/* Port5 supports ethier RGMII or SGMII.
 	 * Port6 supports SGMII only.
 	 */
-	switch (port) {
-	case 5:
-		if (mt7531_is_rgmii_port(priv, port))
-			break;
-		fallthrough;
-	case 6:
-		phylink_set(supported, 1000baseX_Full);
+	if (port == 6 ||
+	    (port == 5 && !mt7531_is_rgmii_port(priv, port))) {
 		phylink_set(supported, 2500baseX_Full);
 		phylink_set(supported, 2500baseT_Full);
 	}
@@ -2913,8 +2908,6 @@ static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
 {
-	if (port == 5)
-		phylink_set(supported, 1000baseX_Full);
 }
 
 static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
@@ -2951,8 +2944,10 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	}
 
 	/* This switch only supports 1G full-duplex. */
-	if (state->interface != PHY_INTERFACE_MODE_MII)
+	if (state->interface != PHY_INTERFACE_MODE_MII) {
 		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+	}
 
 	priv->info->mac_port_validate(ds, port, mask);
 
-- 
2.30.2

