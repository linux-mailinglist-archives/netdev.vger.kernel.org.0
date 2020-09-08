Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AE2262240
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIHWAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgIHWAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 18:00:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AECEC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 15:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cl4elKgzXTyEfk3C7Ik0zALhWFQPGHz38DoyIo6kcYw=; b=sWCd0wFbo+uZBEIBKIaimMjQCd
        vzAC+p5Teq9EBUCyCYkKsZ3sjViVULbLvJu/2fbXu9ZCy+aeNKZa9vL7+HHe2ksA+3LTIo3t5FZ8X
        HKUwreiZHbexU63Fqo2sgqJj2xwlHE64hPcbTpr8Teab9zLCEz18UaEfZEuDbHecyx+T6a8NFxFdS
        pVW8f2u7cLFtR0li3Q3HUEalKWFVy23qz6PJt03J7S7xNTgHc9qfm5GpZLuFRBpDKtpPvy0D6Oyy2
        6/6HBQMaPWy110pl0tHnIE7oB6fH36GPl9IthJEPxHBB5Y1vUi/rRm7by7BLD/hIpOL+nMXhL3jm/
        vQ8FeM0Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39890 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kFlet-0004Bb-AS; Tue, 08 Sep 2020 23:00:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kFles-0006cT-VQ; Tue, 08 Sep 2020 23:00:11 +0100
In-Reply-To: <20200908214727.GZ1551@shell.armlinux.org.uk>
References: <20200908214727.GZ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/7] net: mvpp2: restructure "link status"
 interrupt handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kFles-0006cT-VQ@rmk-PC.armlinux.org.uk>
Date:   Tue, 08 Sep 2020 23:00:10 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "link status" interrupt is used for more than just link status.
Restructure mvpp2_link_status_isr() so we can add additional handling.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 83 ++++++++++++-------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ee8b6a9037ce..bb7284306ee4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2974,44 +2974,17 @@ static irqreturn_t mvpp2_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Per-port interrupt for link status changes */
-static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
+static void mvpp2_isr_handle_link(struct mvpp2_port *port, bool link)
 {
-	struct mvpp2_port *port = (struct mvpp2_port *)dev_id;
 	struct net_device *dev = port->dev;
-	bool event = false, link = false;
-	u32 val;
-
-	mvpp22_gop_mask_irq(port);
-
-	if (mvpp2_port_supports_xlg(port) &&
-	    mvpp2_is_xlg(port->phy_interface)) {
-		val = readl(port->base + MVPP22_XLG_INT_STAT);
-		if (val & MVPP22_XLG_INT_STAT_LINK) {
-			event = true;
-			val = readl(port->base + MVPP22_XLG_STATUS);
-			if (val & MVPP22_XLG_STATUS_LINK_UP)
-				link = true;
-		}
-	} else if (phy_interface_mode_is_rgmii(port->phy_interface) ||
-		   phy_interface_mode_is_8023z(port->phy_interface) ||
-		   port->phy_interface == PHY_INTERFACE_MODE_SGMII) {
-		val = readl(port->base + MVPP22_GMAC_INT_STAT);
-		if (val & MVPP22_GMAC_INT_STAT_LINK) {
-			event = true;
-			val = readl(port->base + MVPP2_GMAC_STATUS0);
-			if (val & MVPP2_GMAC_STATUS0_LINK_UP)
-				link = true;
-		}
-	}
 
 	if (port->phylink) {
 		phylink_mac_change(port->phylink, link);
-		goto handled;
+		return;
 	}
 
-	if (!netif_running(dev) || !event)
-		goto handled;
+	if (!netif_running(dev))
+		return;
 
 	if (link) {
 		mvpp2_interrupts_enable(port);
@@ -3028,8 +3001,54 @@ static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
 
 		mvpp2_interrupts_disable(port);
 	}
+}
+
+static void mvpp2_isr_handle_xlg(struct mvpp2_port *port)
+{
+	bool link;
+	u32 val;
+
+	val = readl(port->base + MVPP22_XLG_INT_STAT);
+	if (val & MVPP22_XLG_INT_STAT_LINK) {
+		val = readl(port->base + MVPP22_XLG_STATUS);
+		if (val & MVPP22_XLG_STATUS_LINK_UP)
+			link = true;
+		mvpp2_isr_handle_link(port, link);
+	}
+}
+
+static void mvpp2_isr_handle_gmac_internal(struct mvpp2_port *port)
+{
+	bool link;
+	u32 val;
+
+	if (phy_interface_mode_is_rgmii(port->phy_interface) ||
+	    phy_interface_mode_is_8023z(port->phy_interface) ||
+	    port->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		val = readl(port->base + MVPP22_GMAC_INT_STAT);
+		if (val & MVPP22_GMAC_INT_STAT_LINK) {
+			val = readl(port->base + MVPP2_GMAC_STATUS0);
+			if (val & MVPP2_GMAC_STATUS0_LINK_UP)
+				link = true;
+			mvpp2_isr_handle_link(port, link);
+		}
+	}
+}
+
+/* Per-port interrupt for link status changes */
+static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
+{
+	struct mvpp2_port *port = (struct mvpp2_port *)dev_id;
+
+	mvpp22_gop_mask_irq(port);
+
+	if (mvpp2_port_supports_xlg(port) &&
+	    mvpp2_is_xlg(port->phy_interface)) {
+		mvpp2_isr_handle_xlg(port);
+	} else {
+		mvpp2_isr_handle_gmac_internal(port);
+	}
 
-handled:
 	mvpp22_gop_unmask_irq(port);
 	return IRQ_HANDLED;
 }
-- 
2.20.1

