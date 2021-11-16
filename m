Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1480452EAD
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhKPKKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbhKPKKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:10:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71695C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8TJ/OIeRdkM1oox30eLvG8HWV1qjoPaDdEdnXNcCfTY=; b=cWWKPBpeI6a1kenNYlA8SYs0Zc
        uwKjqrkch6Dxbk2fopgWlmYBwlwrPlzwOxYtOHsYWfqdi+9VpdUlof7osWXkh9zExM3obMz1ZQYJd
        R/stSYw9leyWzsalB8Ym0PyxXs2l8EWNabBhi05W3rNUbcwty6ha5x6I0wjkyvAImW1BgJef0+Cfd
        P3FV107a1SL8VdfVmwv0HvYxpUsjrTFAFuSQPdOD1EK9diTgJItnWtnFP0ymprYRjtOq1YfZ/NHrz
        Y2altkWI+3Nvf0xU6nYwGriqkQTdgkPDLvqVtpdydlu0jTOKnzA8BviUa/550Oy44o8gwZbXO9TPe
        Ih1p5+Iw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39844 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMh-0000MT-AN; Tue, 16 Nov 2021 10:06:59 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMg-0078ba-Se; Tue, 16 Nov 2021 10:06:58 +0000
In-Reply-To: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
References: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 4/4] net: mtk_eth_soc: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvMg-0078ba-Se@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:06:58 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_eth_soc has no special behaviour in its validation implementation,
so can be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 53 ++-------------------
 1 file changed, 4 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 98f9a6ed9584..de4152e2e3e4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -463,56 +463,8 @@ static void mtk_mac_link_up(struct phylink_config *config,
 	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
 }
 
-static void mtk_validate(struct phylink_config *config,
-			 unsigned long *supported,
-			 struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_TRGMII:
-		phylink_set(mask, 1000baseT_Full);
-		break;
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_set(mask, 1000baseX_Full);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_set(mask, 2500baseX_Full);
-		break;
-	case PHY_INTERFACE_MODE_GMII:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		phylink_set(mask, 1000baseT_Half);
-		fallthrough;
-	case PHY_INTERFACE_MODE_SGMII:
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		fallthrough;
-	case PHY_INTERFACE_MODE_MII:
-	case PHY_INTERFACE_MODE_RMII:
-	case PHY_INTERFACE_MODE_REVMII:
-	default:
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-		break;
-	}
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static const struct phylink_mac_ops mtk_phylink_ops = {
-	.validate = mtk_validate,
+	.validate = phylink_generic_validate,
 	.mac_pcs_get_state = mtk_mac_pcs_get_state,
 	.mac_an_restart = mtk_mac_an_restart,
 	.mac_config = mtk_mac_config,
@@ -2971,6 +2923,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink_config.dev = &eth->netdev[id]->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
+	mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
+
 	__set_bit(PHY_INTERFACE_MODE_MII,
 		  mac->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_GMII,
-- 
2.30.2

