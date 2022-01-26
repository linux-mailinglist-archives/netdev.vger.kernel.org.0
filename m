Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57F149C76D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiAZK0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiAZK0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:26:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD21DC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U19cqugfjX+AQvYedy4D0v2k2jykRZ160MoEbsh4D0Y=; b=1q95S2seCEuUDaGlGe81Lgi9oK
        KgEXo0A7lq1hDe74r6JEsWmak0L2qvaEQqfuxMPQ5jDaWQN2fY+QpNcNfyjfaPwSuiyAeryhjFzKM
        RFVYwqwxYbufKSWvxN/SZApGAEH02hcVqTcdLtNP/T7xEm+/99TkJkLbLDIBe/7Pric+nhZLx8l3I
        iaCfAP51ExXvNtU0kPkskxqa+llyUdZpYAz7LeR2baPe94yc4MXnJyIQHjvqsNgEq3MLF2pGdhSYg
        ffPOLeOQIqaj8f6ADyuYd6zi3cEq/RlHBuEYrx91EGVPqISyctMyhJW7MlWREgSa9rFlfC90/GRMB
        L8ubxw6A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35156 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCfV7-00038o-Vt; Wed, 26 Jan 2022 10:26:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCfV7-005Rd9-CJ; Wed, 26 Jan 2022 10:26:05 +0000
In-Reply-To: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
References: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: stmmac: fill in supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCfV7-005Rd9-CJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 26 Jan 2022 10:26:05 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fill in phylink's supported_interfaces bitmap with the PHY interface
modes which can be used to talk to the PHY.

We indicate that the PHY interface mode passed in platform data is
always supported, as this is the initial mode passed into phylink.
When there is no PCS specified, we assume that this is the only mode
that is supported - indeed, the driver appears not to support dynamic
switching of interface types at present.

When a xpcs is present, it defines the PHY interface modes that the
stmmac driver can support. Request the supported interfaces from the
xpcs driver, and pass them to phylink.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e85ca75d394d..bd20920daf7b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1194,6 +1194,14 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
+	/* Set the platform/firmware specified interface mode */
+	__set_bit(mode, priv->phylink_config.supported_interfaces);
+
+	/* If we have an xpcs, it defines which PHY interfaces are supported. */
+	if (priv->hw->xpcs)
+		xpcs_get_interfaces(priv->hw->xpcs,
+				    priv->phylink_config.supported_interfaces);
+
 	priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100;
 
-- 
2.30.2

