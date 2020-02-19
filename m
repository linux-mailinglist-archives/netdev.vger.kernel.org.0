Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DA61646F4
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBSOal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:30:41 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38485 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBSOal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:30:41 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D440D20000A;
        Wed, 19 Feb 2020 14:30:36 +0000 (UTC)
Date:   Wed, 19 Feb 2020 15:30:36 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200219143036.GB3390@piout.net>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 17/02/2020 17:24:21+0000, Russell King wrote:
> Convert the macb ethernet driver to use the finalised link
> parameters in mac_link_up() rather than the parameters in mac_config().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/cadence/macb.h      |  1 -
>  drivers/net/ethernet/cadence/macb_main.c | 46 ++++++++++++++----------
>  2 files changed, 27 insertions(+), 20 deletions(-)
> 

I did test the series after rebasing on top of the at91rm9200 fix.

Here is what I tested:

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index a3f0f27fc79a..ab827fb4b6b9 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1200,7 +1200,6 @@ struct macb {
 	unsigned int		dma_burst_length;
 
 	phy_interface_t		phy_interface;
-	int			speed;
 
 	/* AT91RM9200 transmit */
 	struct sk_buff *skb;			/* holds skb until xmit interrupt completes */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7ab0bef5e1bd..3a7c26b08607 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -571,37 +571,20 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 
 	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
 
-	/* Clear all the bits we might set later */
-	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
-
 	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
 		if (state->interface == PHY_INTERFACE_MODE_RMII)
 			ctrl |= MACB_BIT(RM9200_RMII);
 	} else {
-		ctrl &= ~(GEM_BIT(GBE) | GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
-
-		/* We do not support MLO_PAUSE_RX yet */
-		if (state->pause & MLO_PAUSE_TX)
-			ctrl |= MACB_BIT(PAE);
+		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
 		if (state->interface == PHY_INTERFACE_MODE_SGMII)
 			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	}
 
-	if (state->speed == SPEED_1000)
-		ctrl |= GEM_BIT(GBE);
-	else if (state->speed == SPEED_100)
-		ctrl |= MACB_BIT(SPD);
-
-	if (state->duplex)
-		ctrl |= MACB_BIT(FD);
-
 	/* Apply the new configuration, if any */
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
 
-	bp->speed = state->speed;
-
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
@@ -635,10 +618,33 @@ static void macb_mac_link_up(struct phylink_config *config,
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
+
+	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
+
+	if (speed == SPEED_100)
+		ctrl |= MACB_BIT(SPD);
+
+	if (duplex)
+		ctrl |= MACB_BIT(FD);
 
 	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
-		macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
+		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(PAE));
+
+		if (speed == SPEED_1000)
+			ctrl |= GEM_BIT(GBE);
+
+		/* We do not support MLO_PAUSE_RX yet */
+		if (tx_pause)
+			ctrl |= MACB_BIT(PAE);
+
+		macb_set_tx_clk(bp->tx_clk, speed, ndev);
 
 		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
 		 * cleared the pipeline and control registers.
@@ -651,6 +657,10 @@ static void macb_mac_link_up(struct phylink_config *config,
 				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
 	}
 
+	macb_or_gem_writel(bp, NCFGR, ctrl);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	/* Enable Rx and Tx */
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
 
@@ -4432,8 +4442,6 @@ static int macb_probe(struct platform_device *pdev)
 	else
 		bp->phy_interface = interface;
 
-	bp->speed = SPEED_UNKNOWN;
-
 	/* IP specific init */
 	err = init(pdev);
 	if (err)


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
