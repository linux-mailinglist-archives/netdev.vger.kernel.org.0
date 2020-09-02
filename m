Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A3525B0E0
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgIBQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgIBQLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:11:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A1DC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 09:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VsXuHZ7twgESWUStgblWVFTghAtehwcJapMiLxl8ZcQ=; b=oibF1p6kNyicY3gMbwiWNO5kRU
        wlrOcJPZer98ykqyCoa8vFF2ADjpUpp8M+I+Kn1otTOc2xBwVQyrruDeJUv/aD+svWNrCU8+l5Rqe
        TtuBate9KnVzF3EYBcRr+KE1Rni1gxVNy1BriOMCxA89wWhyrqs9WgQa7KFaQUeyAZ9QVuwsCY9GB
        iI7WOPJScuzFMrSyqTOkalpgQvOccESKX7YvnVQFtGtLN93oSsJ8eBhmaAk316oBzryJN9F9JaF5F
        5LmZzYQ7lMDxs/tDO8n13TdweU/mim7D4BQyhv6IpZCDFI2r6zDDfgOXHt3o2K/m4pg6lbGTzM1Z7
        mjnzM7Zg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45132 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMG-0004wM-7h; Wed, 02 Sep 2020 17:11:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMF-0000j7-3U; Wed, 02 Sep 2020 17:11:35 +0100
In-Reply-To: <20200902161007.GN1551@shell.armlinux.org.uk>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/7] net: mvpp2: restructure "link status" interrupt
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kDVMF-0000j7-3U@rmk-PC.armlinux.org.uk>
Date:   Wed, 02 Sep 2020 17:11:35 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "link status" interrupt is used for more than just link status.
Restructure mvpp2_link_status_isr() so we can add additional handling.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 83 ++++++++++++-------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d0bbe3a64b8d..81473911a822 100644
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

