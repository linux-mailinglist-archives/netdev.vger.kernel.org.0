Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7C91A8998
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504004AbgDNSar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:30:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46038 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503999AbgDNSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hRefF663gYyMM9y5ZQi2t6V9ZOyP1j89f1rq/HtrMLQ=; b=TuP2v5v0q7zCDva4dhjegsxQ6F
        POoNNYL6sk8/X9Hek5J6aNbNGOPmv98Rtk7KP8Kn6BzoW0fltUzfiJ5vSNED1HLZpR53VIfS0YSA6
        wcWaa1HDoA6LtTRa67cmgGk5HlNxbsu6VzZ3QkIagQB9nfnD6VKhQiu9XgYDikx6fxXtkff7V2P6v
        Pb9WkJ5fGIw+cDN2YaydZdJ1tUaxlEsgu9EUfeA3Jax6o2CBR5Pt6A+wCZKY9d4UOWzw7q/1YxfrA
        RxH6GhZpLHmtPK4/kCRMEJrh81AOWCWzlDFxNg8XTVFpcqhVGcty2bs6IeLyniWuc9oRLR34TSyU4
        DMVA+B7g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:52796 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jOQKD-0001Px-Su; Tue, 14 Apr 2020 19:30:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jOQKC-0001WS-OW; Tue, 14 Apr 2020 19:30:20 +0100
In-Reply-To: <20200414182935.GY25745@shell.armlinux.org.uk>
References: <20200414182935.GY25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 2/2] net: marvell10g: soft-reset the PHY when coming out
 of low power
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jOQKC-0001WS-OW@rmk-PC.armlinux.org.uk>
Date:   Tue, 14 Apr 2020 19:30:20 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soft-reset the PHY when coming out of low power mode, which seems to
be necessary with firmware versions 0.3.3.0 and 0.3.10.0.

This depends on ("net: marvell10g: report firmware version")

Fixes: c9cc1c815d36 ("net: phy: marvell10g: place in powersave mode at probe")
Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index ee60417cdc55..5865b563cc94 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -75,7 +75,8 @@ enum {
 
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
-	MV_V2_PORT_CTRL_PWRDOWN = 0x0800,
+	MV_V2_PORT_CTRL_SWRST	= BIT(15),
+	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
 	MV_V2_TEMP_CTRL_SAMPLE	= 0x0000,
@@ -239,8 +240,19 @@ static int mv3310_power_down(struct phy_device *phydev)
 
 static int mv3310_power_up(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				  MV_V2_PORT_CTRL_PWRDOWN);
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int ret;
+
+	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				 MV_V2_PORT_CTRL_PWRDOWN);
+
+	if (priv->firmware_ver < 0x00030000)
+		return ret;
+
+	ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+			       MV_V2_PORT_CTRL_SWRST);
+
+	return ret;
 }
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
-- 
2.20.1

