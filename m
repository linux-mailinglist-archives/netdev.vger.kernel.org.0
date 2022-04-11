Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915064FB7F9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344690AbiDKJsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbiDKJsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:48:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439A93BBE3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+mgZjavIGa1UXRhETom46Yf5c2lj00ZXmfX/KHMAcg4=; b=RsO7HFRDfRtAyr7SeCRyxRTa7u
        VUyZKaR4vBw1XZphqr0Qzj/wRbk99wzCzeKKDLC/UQoj1PgKD6MAFg/hxyG5etqA7H1iVWjbVtehV
        GvAltHbjasmFz5d5zDFLftT2TB4R2TRZmh7jvhHoW/bhD7A7gK8N3ayq3D4so8oU3dy/KUlxWZNND
        6AmYIO4Gpu/uZJr1yJIHwPY6lBvVrdrc8/hiphC6eOFtI1SDkCCZJlQZcpU+aO+8mLfXPFlpwm680
        Y+nKQczjyIV5VWa2psS2h+nMaej41KbMni8XEhmB0yBvO6thehQ1/3EYwjhmmJaNv+4KXP7Aa3cvp
        TQd+8/zQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52850 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndqcP-0000GA-KN; Mon, 11 Apr 2022 10:45:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndqcO-0055Qd-Nq; Mon, 11 Apr 2022 10:45:56 +0100
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
Subject: [PATCH net-next v2 1/9] net: dsa: mt7530: 1G can also support
 1000BASE-X link mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndqcO-0055Qd-Nq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 10:45:56 +0100
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
Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 19f0035d4410..854859e8cb75 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2539,13 +2539,7 @@ static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
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
+	if (port == 6) {
 		phylink_set(supported, 2500baseX_Full);
 		phylink_set(supported, 2500baseT_Full);
 	}
@@ -2913,8 +2907,6 @@ static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
 {
-	if (port == 5)
-		phylink_set(supported, 1000baseX_Full);
 }
 
 static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
@@ -2951,8 +2943,10 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
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

