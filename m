Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6B4772CE
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbhLPNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbhLPNMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:12:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB944C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 05:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aXBeW6Sz9rczmOcEpG1MEu+io4SKgWOBsrLW815O16U=; b=vFV+ZikxbcCMkhWo+cRCNrBy+z
        3mwvTYTXLvsumGTt56BFWhhegnaj8t2innFd5ULNTx3zImqBWjZe83zocuV/Vn2yXz6WFGisvGxxr
        Pd6uuiK35dibIpt/iO0QRIsW3X9Zt0jp9wiO0G/d21up8tHnirI2qpUYERApgTGsk4ZqyPsjeduI6
        ppiAy8rTr6fO1YDzdMg6NN0JlEcvDXHKJK0WkR7wVo/ADh3SEp2cSmynYYDp41R1WdTNsYmku3xcV
        IAvuKMiLVJs26xLsG2bb9uo1KI7uwBZ55jWKsX49CkhjY3Mq0Yk3ocNJSClAOBmbGRGITmZ1aUt//
        5cqBPrpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49910 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYt-0007te-Bc; Thu, 16 Dec 2021 13:12:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYs-00GYZ3-To; Thu, 16 Dec 2021 13:12:42 +0000
In-Reply-To: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
References: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT net-next 6/6] net: stmmac: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxqYs-00GYZ3-To@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 13:12:42 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stmmac to use phylink_generic_validate() now that we have the
MAC capabilities and supported interfaces filled in, and we have the
PCS validation handled via the PCS operations.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 +------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 94f7282da006..ce3d9a789cef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -936,30 +936,6 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
 			priv->pause, tx_cnt);
 }
 
-static void stmmac_validate(struct phylink_config *config,
-			    unsigned long *supported,
-			    struct phylink_link_state *state)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mac_supported) = { 0, };
-
-	/* This is very similar to phylink_generic_validate() except that
-	 * we always use PHY_INTERFACE_MODE_INTERNAL to get all capabilities.
-	 * This is because we don't always have config->supported_interfaces
-	 * populated (only when we have the XPCS.)
-	 *
-	 * When we do have an XPCS, we could pass state->interface, as XPCS
-	 * limits to a subset of the ethtool link modes allowed here.
-	 */
-	phylink_set(mac_supported, Autoneg);
-	phylink_set_port_modes(mac_supported);
-	phylink_get_linkmodes(mac_supported, PHY_INTERFACE_MODE_INTERNAL,
-			      config->mac_capabilities);
-
-	linkmode_and(supported, supported, mac_supported);
-	linkmode_and(state->advertising, state->advertising, mac_supported);
-}
-
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 			      const struct phylink_link_state *state)
 {
@@ -1096,7 +1072,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
-	.validate = stmmac_validate,
+	.validate = phylink_generic_validate,
 	.mac_config = stmmac_mac_config,
 	.mac_link_down = stmmac_mac_link_down,
 	.mac_link_up = stmmac_mac_link_up,
-- 
2.30.2

