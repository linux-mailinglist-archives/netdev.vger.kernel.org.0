Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7D43C6CC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbhJ0Jvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241270AbhJ0Jvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:51:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CB6C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BLEPx/+eHLdbIIy/fBUmqiAt1B/3VhLEykXVjN74dLY=; b=zfk3efiPPSzaG2Fy2zzlrE4QHj
        1bKOHZsMjjn3KxGUHieKEi/FXaLJlcHFw/JANuXmbhnMfVs75p5n5qfAAiTtkbkRHAE53JrOv8uF5
        6XDll9J2X29tds6V1BH+tkgwCJG2DTe4ZjdeAg4s4Qy/WGyDE2Kk3fvlTD4S7qiTbJMECakABRw6c
        P/3f2A7InYW9wAERFsrmZ912EcLPoCbP28B1EiOnwXYrLT9R8ZmAd8va1XYcbRYrYDiNjbd8cTsD6
        1o9GUbchww2Yi3mbBYwlijDYzEMiLWJdJb6rEWeiey6SzmjBkcHapR6uQHVpEga1seVnHJ/gR117H
        CHd+QopA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34472 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYZ-0006FN-1c; Wed, 27 Oct 2021 10:49:15 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYY-001vqU-K3; Wed, 27 Oct 2021 10:49:14 +0100
In-Reply-To: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
References: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: mvpp2: populate supported_interfaces member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mffYY-001vqU-K3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:49:14 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy interface mode bitmap for the Marvell mvpp2 driver
with interfaces modes supported by the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8ddf58f379ac..43ffff01bd44 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6937,6 +6937,40 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		port->phylink_config.dev = &dev->dev;
 		port->phylink_config.type = PHYLINK_NETDEV;
 
+		if (mvpp2_port_supports_xlg(port)) {
+			__set_bit(PHY_INTERFACE_MODE_10GBASER,
+				  port->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_XAUI,
+				  port->phylink_config.supported_interfaces);
+		}
+
+		if (mvpp2_port_supports_rgmii(port))
+			phy_interface_set_rgmii(port->phylink_config.supported_interfaces);
+
+		if (comphy) {
+			/* If a COMPHY is present, we can support any of the
+			 * serdes modes and switch between them.
+			 */
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  port->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  port->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+				  port->phylink_config.supported_interfaces);
+		} else if (phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
+			/* No COMPHY, with only 2500BASE-X mode supported */
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+				  port->phylink_config.supported_interfaces);
+		} else if (phy_mode == PHY_INTERFACE_MODE_1000BASEX ||
+			   phy_mode == PHY_INTERFACE_MODE_SGMII) {
+			/* No COMPHY, we can switch between 1000BASE-X and SGMII
+			 */
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  port->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  port->phylink_config.supported_interfaces);
+		}
+
 		phylink = phylink_create(&port->phylink_config, port_fwnode,
 					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {
-- 
2.30.2

