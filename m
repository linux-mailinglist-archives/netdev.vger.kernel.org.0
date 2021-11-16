Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41803452E9D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhKPKFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhKPKFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:05:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93065C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H5XjDJf1LLdUT2/d9oOjk3TTMjFfnNO0QpCXMtAbAkI=; b=gm97coI+QX7aQZZFNH+lEXHSjr
        nY9y2jfr44SOaFxEYoH0gIy+gZCIXIU8wknTcuDr+WnFF4eA+Xf7zcurrgM/xNJehsidjdcgLcWAu
        mR/BK3HkdX+8ENMpkMHYdfbqRgPmTcvOwHFeujGrrdEXqaTdD4n0x5PKwp82wss7H5A+f7OdHBqVt
        AjDsaZYRT68xmu1u3gLwteUC6lj4B1/GIgEo0ommFomJ29rimmIgU9OA/HkGL4qcfF14WcAaYPuqV
        wBZMe3MlJzDLmDiLzgVFFKBaXJNpaWKI2/U5k8y+QIylaHy61LQ6sRearCKCYZAVuU81zXRQdeuyy
        oyNllP/g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39832 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvI4-0000Ka-8Q; Tue, 16 Nov 2021 10:02:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvI3-0078WO-RN; Tue, 16 Nov 2021 10:02:11 +0000
In-Reply-To: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
References: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/3] net: sparx5: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvI3-0078WO-RN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:02:11 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparx5 has no special behaviour in its validation implementation, so can
be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |  3 +
 .../microchip/sparx5/sparx5_phylink.c         | 60 +------------------
 2 files changed, 4 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 3cb6c1fe43ff..16266275dd36 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -292,6 +292,9 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
 	spx5_port->phylink_config.type = PHYLINK_NETDEV;
 	spx5_port->phylink_config.pcs_poll = true;
+	spx5_port->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
+		MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD |
+		MAC_2500FD | MAC_5000FD | MAC_10000FD | MAC_25000FD;
 
 	__set_bit(PHY_INTERFACE_MODE_SGMII,
 		  spx5_port->phylink_config.supported_interfaces);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index e77ddded4811..8ba33bc1a001 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -26,64 +26,6 @@ static bool port_conf_has_changed(struct sparx5_port_config *a, struct sparx5_po
 	return false;
 }
 
-static void sparx5_phylink_validate(struct phylink_config *config,
-				    unsigned long *supported,
-				    struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_5GBASER:
-		phylink_set(mask, 5000baseT_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_10GBASER:
-		phylink_set(mask, 10000baseT_Full);
-		phylink_set(mask, 10000baseCR_Full);
-		phylink_set(mask, 10000baseSR_Full);
-		phylink_set(mask, 10000baseLR_Full);
-		phylink_set(mask, 10000baseLRM_Full);
-		phylink_set(mask, 10000baseER_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_25GBASER:
-		phylink_set(mask, 25000baseCR_Full);
-		phylink_set(mask, 25000baseSR_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		break;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-		break;
-
-	default:
-		linkmode_zero(supported);
-		return;
-	}
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void sparx5_phylink_mac_config(struct phylink_config *config,
 				      unsigned int mode,
 				      const struct phylink_link_state *state)
@@ -187,7 +129,7 @@ const struct phylink_pcs_ops sparx5_phylink_pcs_ops = {
 };
 
 const struct phylink_mac_ops sparx5_phylink_mac_ops = {
-	.validate = sparx5_phylink_validate,
+	.validate = phylink_generic_validate,
 	.mac_config = sparx5_phylink_mac_config,
 	.mac_link_down = sparx5_phylink_mac_link_down,
 	.mac_link_up = sparx5_phylink_mac_link_up,
-- 
2.30.2

