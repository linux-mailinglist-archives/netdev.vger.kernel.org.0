Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667AA25D259
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgIDH3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgIDH3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:29:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99807C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JMtQFOGUAp+bB8PvyH2Z+74bUr9Mc433bodCglOYdoI=; b=qdeW1xaQ2UuMg7ZrMUtMciKG4t
        fxxnPLCKtlwpm/3933A/joSxh5WBjm8FfEdci0aExjceml+cLR56TPllPefi03fsdcWvjqLImXZbU
        L37RLwzZChYQH1WFjO525YaE1gcr44tlSsOTlJCaRlvQkO5M4ajXS3ouuP7DECKSppJkcLPdw33cu
        1MW4fbAAZU0ld5f5XRTABfDqtKNrCKUBKXyFDXmeUI9cLoeykX7ZQWBkXL4DZDXn+Dv6AgxdDh94K
        yB/PZlx1DUKSx/hJdAuARD6EA9v0agO3IDmHbCqO6JkjGMd7yChYkPqzaGn/0K/eoEedoLQA+UM+J
        a/A97HUw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57904 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE69o-0007OS-3S; Fri, 04 Sep 2020 08:29:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE69n-000576-Sg; Fri, 04 Sep 2020 08:29:11 +0100
In-Reply-To: <20200904072828.GQ1551@shell.armlinux.org.uk>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/6] net: mvpp2: restructure "link status"
 interrupt handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kE69n-000576-Sg@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Sep 2020 08:29:11 +0100
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

