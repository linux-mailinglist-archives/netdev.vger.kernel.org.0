Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF049B910
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585779AbiAYQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584880AbiAYQkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:40:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAAEC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U19cqugfjX+AQvYedy4D0v2k2jykRZ160MoEbsh4D0Y=; b=WGjf0+FjgJ7AklnZmK4NZhfdTJ
        tHfD5O05WMCChz/LOEobRiUkW4sjLtZCChvYP/OU6ITeLyUFRMRuuJ3+3UmZA5e/9a9vgv1j8NDfa
        8l//wGAy9GgRReQDbyqR/qbNyob/a1Elc+LQRaZyklziNAr1AojQ3wbz2ht/b5fl0cQ1Stl4zK8wE
        Rhqr6kNRq5mfvXR4Fp8oO8QwCNWNYN5fmVkewYtlJbB3k1hAaAInsRtcIuzgSocfEgO/tJOU6xFgF
        4rQFa9zswy6ZLo5p8MiBLvpsWAM2SDNMob05iL1B1r8YknXHEY21nqL+Qe9gtOHaQ70ed+EkweVic
        szmw15Yw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57416 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOs0-0002BS-0L; Tue, 25 Jan 2022 16:40:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOrz-005LSj-Dc; Tue, 25 Jan 2022 16:40:35 +0000
In-Reply-To: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
References: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
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
Subject: [PATCH net-next 3/7] net: stmmac: fill in supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOrz-005LSj-Dc@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:40:35 +0000
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

