Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E89452E7F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhKPJ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbhKPJ6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:58:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C9AC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n3KaB9ujBXL3kpoUwh3nmPXVbLrOnLl39mmzvHTherA=; b=rUbFtX8pnlXV5Kc+OAY4P16zz9
        bjErMGazJOfupGBssqPLdqT5wlNZV5t66FjPQuGZ+mrfcvUYl+F02KLqnjxaT4AvrX4QLGSzg3wXw
        svTzIagPW6Sv4n5/XIajrY8irtv/moy/Aq2qvnwAV7f5JhM/PdNkt9pKquHhH2sstEEC8KqI+CfHU
        AXHcYY/ShBWUfPIwZVpFh2YSBaUsUf3xdY5F6yVLCMHoSkngilu1PE2do1CXBU/lXyCUp42xtbPuJ
        0n/ovvvima4yFNAIygdWPJ6/KP2N6j8vzv5AbtE7rGmzTulYJieZCsaohIg5Q/dxoM146CYqpbg8g
        OF038hGg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39816 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBS-0000Hn-Ka; Tue, 16 Nov 2021 09:55:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBS-0078Np-6y; Tue, 16 Nov 2021 09:55:22 +0000
In-Reply-To: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
References: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/3] net: axienet: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvBS-0078Np-6y@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 09:55:22 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy_interface_t bitmap for the Xilinx axienet driver with
interfaces modes supported by the MAC.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9b068b81ae09..8a0a43d71b51 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2105,6 +2105,14 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
 
+	__set_bit(lp->phy_mode, lp->phylink_config.supported_interfaces);
+	if (lp->switch_x_sgmii) {
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  lp->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  lp->phylink_config.supported_interfaces);
+	}
+
 	lp->phylink = phylink_create(&lp->phylink_config, pdev->dev.fwnode,
 				     lp->phy_mode,
 				     &axienet_phylink_ops);
-- 
2.30.2

