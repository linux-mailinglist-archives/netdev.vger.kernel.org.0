Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7143C602
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhJ0JGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhJ0JGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:06:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABB6C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ABeyvAaibmSZCdZ3TMWtb2x84Fdq54DVLG3c2DYJZPM=; b=dgJSi6oA2rXk5ira8kIYcYu6Gg
        hxDEcvwZvAHo2gy2Bl8UY7jfFYRlWblgNnQ77FIsngFIoSnvlzK5D92Bg1cLWE0CIdgmwkMRZLm6T
        9CHgocR+zG/F7pexoGdcT0eEsxzwfdQ58+I9z4FhkYAZ9p18i+QWvUAyeoddTBRkXnQJzMjDZ0Eui
        82ptrMrGjVl84sE74H6vItBYMleduAB9J4/OjIeJeEdDUIsk0PalkBW/ucKSI4VcRdTDFVRnPo1SP
        AiLrWhig8638aJgm3E1FHM6eQdddXb2suST76aAY+LEEsBqCtB5clGFP5RBROUDZqb+QthsLLpz9L
        QJ39KX9Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34110 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqV-0006Ct-Iy; Wed, 27 Oct 2021 10:03:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqV-001Trr-5d; Wed, 27 Oct 2021 10:03:43 +0100
In-Reply-To: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
References: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: mvneta: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfeqV-001Trr-5d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:03:43 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy_interface_t bitmap for the Marvell mvneta driver with
interfaces modes supported by the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b6c636592dfa..7df923648bc4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5179,6 +5179,31 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
+	phy_interface_set_rgmii(pp->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QSGMII,
+		  pp->phylink_config.supported_interfaces);
+	if (comphy) {
+		/* If a COMPHY is present, we can support any of the serdes
+		 * modes and switch between them.
+		 */
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  pp->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  pp->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  pp->phylink_config.supported_interfaces);
+	} else if (phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
+		/* No COMPHY, with only 2500BASE-X mode supported */
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  pp->phylink_config.supported_interfaces);
+	} else if (phy_mode == PHY_INTERFACE_MODE_1000BASEX ||
+		   phy_mode == PHY_INTERFACE_MODE_SGMII) {
+		/* No COMPHY, we can switch between 1000BASE-X and SGMII */
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  pp->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  pp->phylink_config.supported_interfaces);
+	}
 
 	phylink = phylink_create(&pp->phylink_config, pdev->dev.fwnode,
 				 phy_mode, &mvneta_phylink_ops);
-- 
2.30.2

