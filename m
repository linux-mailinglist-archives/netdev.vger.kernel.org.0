Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF1B452EAB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhKPKJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbhKPKJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:09:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294F8C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FS4ajOcnofb6bnRQXQZpb59B3t3pfaH82+SxdC9NXcU=; b=eZZ0bvcAdeo0g/tAZTPnhqCEqE
        im5eeP2xeZFqx+8RFO8+xrmKNBbOYKX4IhhDcZw4M1wc0CfnHhOjo+FMaV9HfyEl/ekZ056uhXuTH
        erYQEBPHALHxyLk0q6n/QibduyiaOLlP1n1Ax25jst7z1d7b67InAJwrAsp2cI8xBX/sMwziHpxsE
        OqK2Z1Zwy7APbyJcVrC2d7i66vKNpw3SleCkP1WV/MBCjbYGB7cMy0uuemyJZVNf1xMm9e/rolo/+
        EzR2he6DsLRCcalwn25E+gEm9+pkm3Tgu+zExoUi88v3KNVvQMKF24zO5Zh2x8uOzQPLkw2lsHBDh
        4/WG4Qqg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39840 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMX-0000M0-2V; Tue, 16 Nov 2021 10:06:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMW-0078bO-LN; Tue, 16 Nov 2021 10:06:48 +0000
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
Subject: [PATCH net-next 2/4] net: mtk_eth_soc: remove interface checks in
 mtk_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvMW-0078bO-LN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:06:48 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode, nor handle
PHY_INTERFACE_MODE_NA in the validation function. Remove these to
simplify the implementation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 34 ---------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7f62298bc983..31872594c790 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -467,24 +467,8 @@ static void mtk_validate(struct phylink_config *config,
 			 unsigned long *supported,
 			 struct phylink_link_state *state)
 {
-	struct mtk_mac *mac = container_of(config, struct mtk_mac,
-					   phylink_config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII) &&
-	      phy_interface_mode_is_rgmii(state->interface)) &&
-	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) &&
-	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII) &&
-	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII) &&
-	      (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	       phy_interface_mode_is_8023z(state->interface)))) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 
@@ -511,7 +495,6 @@ static void mtk_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RMII:
 	case PHY_INTERFACE_MODE_REVMII:
-	case PHY_INTERFACE_MODE_NA:
 	default:
 		phylink_set(mask, 10baseT_Half);
 		phylink_set(mask, 10baseT_Full);
@@ -520,23 +503,6 @@ static void mtk_validate(struct phylink_config *config,
 		break;
 	}
 
-	if (state->interface == PHY_INTERFACE_MODE_NA) {
-		if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-			phylink_set(mask, 2500baseX_Full);
-		}
-		if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII)) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseT_Half);
-			phylink_set(mask, 1000baseX_Full);
-		}
-		if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GEPHY)) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseT_Half);
-		}
-	}
-
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
 
-- 
2.30.2

