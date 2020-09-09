Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0A62631C8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgIIQ0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgIIQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:25:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40515C061757
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cl4elKgzXTyEfk3C7Ik0zALhWFQPGHz38DoyIo6kcYw=; b=r7Q10U9+umhWyVaP13QHCvTCiV
        AD6QCmiIXeaLpmRY01yq/YIsNqXq5eHKp8dDYKUpB0vPlD5pVP5kwuEbJU/8K6Xdj5Vwg9/r7wgdP
        ZyW48b5hxFKbcfn+FJ/yJH1DLyzsw4DaXtx33VhZ5BWmKgWjmSv22UHcRQSqvjhcDkb/V5CrawdoV
        MdSd732LD77+EGn3R4CQ5MTu+vG/Tea1TGyT+WIz5qetDU+A+fuFtxhg7ZKnMrgNFi9wSJHHl+hq4
        CzneQRFieDxeQomXm3tmXqUYvAMv2vZP3ENygVLc76SkinTrNIy7cMzuHU/lKX6wInB+Sk2z/FY/t
        C7IA2Ryg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46304 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kG2ud-00051d-Lb; Wed, 09 Sep 2020 17:25:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kG2ud-0002yT-EF; Wed, 09 Sep 2020 17:25:35 +0100
In-Reply-To: <20200909162501.GB1551@shell.armlinux.org.uk>
References: <20200909162501.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 1/6] net: mvpp2: restructure "link status"
 interrupt handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kG2ud-0002yT-EF@rmk-PC.armlinux.org.uk>
Date:   Wed, 09 Sep 2020 17:25:35 +0100
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

