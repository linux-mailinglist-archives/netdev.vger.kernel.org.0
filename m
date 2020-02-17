Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BDC1618C3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgBQRZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:25:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39674 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbgBQRZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VI0lddDgnD6n90ZaCoN4+miB2XSzIbHyE1DNJ6oPPXo=; b=zZX1qSGSrmRhNV6lmlCHgkFJgW
        2XeL++7t2+N/FV/nLIL3/cDYxxuZujGk/D1acSN7cSwMAUbp5VXtGGaAWbLQ2wS8E7qo5aeaDFmdc
        QZMhnGXdefQ+tXpJDRUnQtbf6kwNO3mUvtx2OCgTq/6R+jzsOw9Q0bMg/RQKggRfah68H7ZhS+UQP
        vgJ6fUIG3haKH+IMsG4nQzQejntxFT06JnzFWXKvFPI16zw6VlKFdTpvLIIdBM9As2ZVR69WUI1+m
        tWY2f3kTG2Gcg/UDIjxpX/pXO85lC+f5EMjxE5mypro1grEBAbrSvRwDBH5EwcJuccu7odrDw1nL3
        Z31febbQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41036 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3k89-00027g-M9; Mon, 17 Feb 2020 17:24:26 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3k85-00072l-RK; Mon, 17 Feb 2020 17:24:21 +0000
In-Reply-To: <20200217172242.GZ25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 17:24:21 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the macb ethernet driver to use the finalised link
parameters in mac_link_up() rather than the parameters in mac_config().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 46 ++++++++++++++----------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index dbf7070fcdba..e99608f27d23 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1199,7 +1199,6 @@ struct macb {
 	unsigned int		dma_burst_length;
 
 	phy_interface_t		phy_interface;
-	int			speed;
 
 	/* AT91RM9200 transmit */
 	struct sk_buff *skb;			/* holds skb until xmit interrupt completes */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 92e0c1035db8..1332523d7dcb 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -572,20 +572,7 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
 
 	/* Clear all the bits we might set later */
-	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
-		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
-
-	if (state->speed == SPEED_1000)
-		ctrl |= GEM_BIT(GBE);
-	else if (state->speed == SPEED_100)
-		ctrl |= MACB_BIT(SPD);
-
-	if (state->duplex)
-		ctrl |= MACB_BIT(FD);
-
-	/* We do not support MLO_PAUSE_RX yet */
-	if (state->pause & MLO_PAUSE_TX)
-		ctrl |= MACB_BIT(PAE);
+	ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
 	if (state->interface == PHY_INTERFACE_MODE_SGMII)
 		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
@@ -594,8 +581,6 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
 
-	bp->speed = state->speed;
-
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
@@ -628,9 +613,34 @@ static void macb_mac_link_up(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
 	struct macb_queue *queue;
+	unsigned long flags;
 	unsigned int q;
+	u32 ctrl;
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	ctrl = macb_or_gem_readl(bp, NCFGR);
 
-	macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
+	/* Clear all the bits we might set later */
+	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
+
+	if (speed == SPEED_1000)
+		ctrl |= GEM_BIT(GBE);
+	else if (speed == SPEED_100)
+		ctrl |= MACB_BIT(SPD);
+
+	if (duplex == DUPLEX_FULL)
+		ctrl |= MACB_BIT(FD);
+
+	/* We do not support rx_pause yet */
+	if (tx_pause)
+		ctrl |= MACB_BIT(PAE);
+
+	macb_or_gem_writel(bp, NCFGR, ctrl);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	macb_set_tx_clk(bp->tx_clk, speed, ndev);
 
 	/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 	 * cleared the pipeline and control registers.
@@ -4424,8 +4434,6 @@ static int macb_probe(struct platform_device *pdev)
 	else
 		bp->phy_interface = interface;
 
-	bp->speed = SPEED_UNKNOWN;
-
 	/* IP specific init */
 	err = init(pdev);
 	if (err)
-- 
2.20.1

