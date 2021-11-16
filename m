Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A3E452E81
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhKPJ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhKPJ6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:58:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626FC061766
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SutG5ncQy60U1nSVfsZ6tu9LOn8COIr+l7fLIkVZDNk=; b=OvM06HP16odbVtnCZK1L1M8bSK
        OlpnhvpSEacgpSExRVAogtRTfAWktK0QbAZ20QJqdF0C9/N+1Lu7NgYhqR1xYmlev0guOzH5e3Blg
        CdrYps0U6He9TDEL9KD8nsn2zOJAYl+uzN99watXsn2JouYk6oimg6kdT8RIMYdVzTXYPf4/RmvAl
        6LIoS3RWo27ArpEZgkD1238V6B6ixcfopbHKfJeFSqJtYfYkk4UsjOZcMANinlQwzj4V3wTQrpSGJ
        /RvN35V46IIOcU/zSb3xZpxUjmVwPGUHNXBEHTjtOX3DOK/6sA+ctrytdzidMXITeybOeo+Qgd2Tm
        Dtb/PZOA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39820 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBc-0000IO-TC; Tue, 16 Nov 2021 09:55:32 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBc-0078O3-F3; Tue, 16 Nov 2021 09:55:32 +0000
In-Reply-To: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
References: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/3] net: axienet: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvBc-0078O3-F3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 09:55:32 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

axienet has no special behaviour in its validation implementation, so
can be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 41 ++-----------------
 1 file changed, 3 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a058019ad9a1..3dabc1901416 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1503,43 +1503,6 @@ static const struct ethtool_ops axienet_ethtool_ops = {
 	.nway_reset	= axienet_ethtools_nway_reset,
 };
 
-static void axienet_validate(struct phylink_config *config,
-			     unsigned long *supported,
-			     struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, Pause);
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_GMII:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		phylink_set(mask, 1000baseX_Full);
-		phylink_set(mask, 1000baseT_Full);
-		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
-			break;
-		fallthrough;
-	case PHY_INTERFACE_MODE_MII:
-		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 10baseT_Full);
-		fallthrough;
-	default:
-		break;
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void axienet_mac_pcs_get_state(struct phylink_config *config,
 				      struct phylink_link_state *state)
 {
@@ -1665,7 +1628,7 @@ static void axienet_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops axienet_phylink_ops = {
-	.validate = axienet_validate,
+	.validate = phylink_generic_validate,
 	.mac_pcs_get_state = axienet_mac_pcs_get_state,
 	.mac_an_restart = axienet_mac_an_restart,
 	.mac_prepare = axienet_mac_prepare,
@@ -2082,6 +2045,8 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+		MAC_10FD | MAC_100FD | MAC_1000FD;
 
 	__set_bit(lp->phy_mode, lp->phylink_config.supported_interfaces);
 	if (lp->switch_x_sgmii) {
-- 
2.30.2

