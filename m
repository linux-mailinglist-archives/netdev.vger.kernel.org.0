Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B5452EB3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhKPKMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhKPKMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:12:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEB6C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NJcZYYnqTzcqlHwpjMXRDVFZRuc8vJGAo3a1bPK1qNM=; b=M/Nk7CCKNGHeC8hMh3+TlvIM7V
        zW7IhtH8fs00Vbene7b4bmr1BOpber/L+/bMk3VYanGbCs/H6reWeyVk6GdeBirjKDZQLYMW0wPRg
        9n/z4gGlviGc3aAPo8zioFqRHHIcXfCmNTKjL8lCjFoJcb0/8zRTlGVX5T670/E5gqFBVwgPWDESJ
        l1s7lTNv8e1swXNYRiMMI+JyVwZniPJDcO1quxW2g1OfTrgB8MyvOGpJCP+4yRANeXaqQix5FjXRY
        Cub946lYBC1RuqiwWY1HvW7ok2fTjczlLL2OEIANWYfvxcA8V4w0wb+HvC+MEuA9FC95dORUuoWCV
        KWVRPRtw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39852 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvP9-0000Np-Ls; Tue, 16 Nov 2021 10:09:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvP9-0078fX-7x; Tue, 16 Nov 2021 10:09:31 +0000
In-Reply-To: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
References: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ocelot_net: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvP9-0078fX-7x@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:09:31 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy interface mode bitmap for the MSCC Ocelot driver with
the interface modes supported by the MAC.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index eaeba60b1bba..37c158df60ce 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1655,6 +1655,9 @@ static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 
+	__set_bit(ocelot_port->phy_mode,
+		  priv->phylink_config.supported_interfaces);
+
 	phylink = phylink_create(&priv->phylink_config,
 				 of_fwnode_handle(portnp),
 				 phy_mode, &ocelot_phylink_ops);
-- 
2.30.2

