Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB8B4772C6
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhLPNMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbhLPNMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:12:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A6C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 05:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I7p7qWB1CvF3K3PC5KtQwYzw4iKptOC1jBzUIZS8nuQ=; b=Vc/djmSmMUBtB/W7WZKM9cEyNU
        PNehhar7fgg9sW6TtWL/SvHKYywa2ZRjTkbuExSNY713InKWpQFL/NmM7I48wfIFA4+b+WDCzAvfO
        gb00IkzRZrSctP76AWEFeW+LXdyXLeAn7ofUlinY7QPysJd0yeut6vTWMurlZXEjy0AaW+AqKe5KC
        uTnDqLfyBVogM30lMn3YkSOXmgERHJkWXa/MU4Nahp713AfYej3Ww6zqJ1XdWV5dHXtqahN3UDSjk
        z8vD2/nRRj4FGskGZlQJX0eEl7NpD9zZ3shkNnsxXcycKlJpQpg5L8lIT2iHZNv9UC12bHhMvkcVU
        iwf9GM2g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49904 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYd-0007ss-VT; Thu, 16 Dec 2021 13:12:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYd-00GYYi-IA; Thu, 16 Dec 2021 13:12:27 +0000
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
Subject: [PATCH CFT net-next 3/6] net: stmmac: fill in supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxqYd-00GYYi-IA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 13:12:27 +0000
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

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 09bef8310360..b8ec8afb95a6 100644
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

