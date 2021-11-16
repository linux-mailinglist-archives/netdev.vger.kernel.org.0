Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2A0452E93
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhKPKCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbhKPKCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:02:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B10C061764
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jXs7glF2y2WdBu8y04Zr6LVYcgntj/0scAsqPJNhHis=; b=d15UGv3oK6XfCo5+6AUv+6Lie/
        RlyBnE5dNBgctV1PNmV5T7kd6vsCcLaunUZEeJqUFNpnZ9IVGpSTyUkmd4tWNW053CA3Mj8C9CRRH
        wGIzyg3lHtySEs+El7fBNYFsTMnBLFBjb3ZxHNUDasIHiRzdAg7qYLgXhyp0MAf34T1O0K6Rt4EgQ
        PS2+q8wgQm7UrmTvM5+9X4ZkuZKEzpdVMh4NvCdcuhXZyoh8zr/1HzgbSi7zTwEKAsR3P4JT4rgBQ
        cGF40YU5XLSO+2XbqcZQaOLdndxk8J5s9z0gwy+Wn+8PH8PsVhm3Ir592i8CQmLFkGUPgjrDl38UR
        TRl3XpnA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39826 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvF7-0000Jc-0g; Tue, 16 Nov 2021 09:59:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvF6-0078SH-Ix; Tue, 16 Nov 2021 09:59:08 +0000
In-Reply-To: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
References: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: enetc: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvF6-0078SH-Ix@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 09:59:08 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc has no special behaviour in its validation implementation, so can
be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 33 ++-----------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 61f05a021779..fe6a544f37f0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -930,35 +930,6 @@ static void enetc_mdiobus_destroy(struct enetc_pf *pf)
 	enetc_imdio_remove(pf);
 }
 
-static void enetc_pl_mac_validate(struct phylink_config *config,
-				  unsigned long *supported,
-				  struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 1000baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void enetc_pl_mac_config(struct phylink_config *config,
 				unsigned int mode,
 				const struct phylink_link_state *state)
@@ -1086,7 +1057,7 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops enetc_mac_phylink_ops = {
-	.validate = enetc_pl_mac_validate,
+	.validate = phylink_generic_validate,
 	.mac_config = enetc_pl_mac_config,
 	.mac_link_up = enetc_pl_mac_link_up,
 	.mac_link_down = enetc_pl_mac_link_down,
@@ -1101,6 +1072,8 @@ static int enetc_phylink_create(struct enetc_ndev_priv *priv,
 
 	pf->phylink_config.dev = &priv->ndev->dev;
 	pf->phylink_config.type = PHYLINK_NETDEV;
+	pf->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
 
 	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 		  pf->phylink_config.supported_interfaces);
-- 
2.30.2

