Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A4A116C5D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLILgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:36:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60626 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLILgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:36:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wXcoSF5lVsg+P46NhzpR71rHZLr1ZR5DzSYLQta9mWk=; b=cnyCkFbxJ2f/QpCkMJWnZEB5X
        bW+YtqJ4IzqiobxcFFEn0xbjwOoHgoY2xKRDFh7GVsrmJ8/GiNUydwwndNOlepFjNZxdhVuuXa4nZ
        eb1kcVFG7VVshPcI6QbNDkqYpxuwsF2rwOajhw8MYVisd95B0p/oOMDlMMZeXHW7ByfqQMohPLwoZ
        2ur7B1Te51EQCMwQg8pirgBdZMggq3K41zeNAjpMdznrFCOQIRUZa9DBQbsWmGSxe6p2lpB8/bjiN
        flSZ/gHhEmjS8DNidsSq8DIJ1NKtIDvWcP3Kn5UcpBJNZgXfyHpgDT7GGHCw156B17MRarY81VWVI
        EW5urBNxg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38920)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieHKj-0002gZ-K3; Mon, 09 Dec 2019 11:36:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieHKg-0003at-71; Mon, 09 Dec 2019 11:36:06 +0000
Date:   Mon, 9 Dec 2019 11:36:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     nicolas.nerre@microchip.com, andrew@lunn.ch,
        antoine.tenart@bootlin.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        a.fatoum@pengutronix.de, brad.mouring@ni.com, pthombar@cadence.com
Subject: Re: [PATCH 3/3] net: macb: add support for high speed interface
Message-ID: <20191209113606.GF25745@shell.armlinux.org.uk>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575890176-25630-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 11:16:16AM +0000, Milind Parab wrote:
> This patch add support for high speed USXGMII PCS and 10G
> speed in Cadence ethernet controller driver.

How has this been tested?

> Signed-off-by: Milind Parab <mparab@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      |  50 ++++++++
>  drivers/net/ethernet/cadence/macb_main.c | 142 ++++++++++++++++++++---
>  2 files changed, 174 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index dbf7070fcdba..b731807d1c49 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -76,10 +76,12 @@
>  #define MACB_RBQPH		0x04D4
>  
>  /* GEM register offsets. */
> +#define GEM_NCR			0x0000 /* Network Control */
>  #define GEM_NCFGR		0x0004 /* Network Config */
>  #define GEM_USRIO		0x000c /* User IO */
>  #define GEM_DMACFG		0x0010 /* DMA Configuration */
>  #define GEM_JML			0x0048 /* Jumbo Max Length */
> +#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
>  #define GEM_HRB			0x0080 /* Hash Bottom */
>  #define GEM_HRT			0x0084 /* Hash Top */
>  #define GEM_SA1B		0x0088 /* Specific1 Bottom */
> @@ -164,6 +166,9 @@
>  #define GEM_DCFG7		0x0298 /* Design Config 7 */
>  #define GEM_DCFG8		0x029C /* Design Config 8 */
>  #define GEM_DCFG10		0x02A4 /* Design Config 10 */
> +#define GEM_DCFG12		0x02AC /* Design Config 12 */
> +#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
> +#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
>  
>  #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
>  #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
> @@ -270,11 +275,19 @@
>  #define MACB_IRXFCS_OFFSET	19
>  #define MACB_IRXFCS_SIZE	1
>  
> +/* GEM specific NCR bitfields. */
> +#define GEM_ENABLE_HS_MAC_OFFSET	31
> +#define GEM_ENABLE_HS_MAC_SIZE		1
> +
>  /* GEM specific NCFGR bitfields. */
> +#define GEM_FD_OFFSET		1 /* Full duplex */
> +#define GEM_FD_SIZE		1
>  #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
>  #define GEM_GBE_SIZE		1
>  #define GEM_PCSSEL_OFFSET	11
>  #define GEM_PCSSEL_SIZE		1
> +#define GEM_PAE_OFFSET		13 /* Pause enable */
> +#define GEM_PAE_SIZE		1
>  #define GEM_CLK_OFFSET		18 /* MDC clock division */
>  #define GEM_CLK_SIZE		3
>  #define GEM_DBW_OFFSET		21 /* Data bus width */
> @@ -455,11 +468,17 @@
>  #define MACB_REV_OFFSET				0
>  #define MACB_REV_SIZE				16
>  
> +/* Bitfield in HS_MAC_CONFIG */
> +#define GEM_HS_MAC_SPEED_OFFSET			0
> +#define GEM_HS_MAC_SPEED_SIZE			3
> +
>  /* Bitfields in DCFG1. */
>  #define GEM_IRQCOR_OFFSET			23
>  #define GEM_IRQCOR_SIZE				1
>  #define GEM_DBWDEF_OFFSET			25
>  #define GEM_DBWDEF_SIZE				3
> +#define GEM_NO_PCS_OFFSET			0
> +#define GEM_NO_PCS_SIZE				1
>  
>  /* Bitfields in DCFG2. */
>  #define GEM_RX_PKT_BUFF_OFFSET			20
> @@ -494,6 +513,34 @@
>  #define GEM_RXBD_RDBUFF_OFFSET			8
>  #define GEM_RXBD_RDBUFF_SIZE			4
>  
> +/* Bitfields in DCFG12. */
> +#define GEM_HIGH_SPEED_OFFSET			26
> +#define GEM_HIGH_SPEED_SIZE			1
> +
> +/* Bitfields in USX_CONTROL. */
> +#define GEM_USX_CTRL_SPEED_OFFSET		14
> +#define GEM_USX_CTRL_SPEED_SIZE			3
> +#define GEM_SERDES_RATE_OFFSET			12
> +#define GEM_SERDES_RATE_SIZE			2
> +#define GEM_RX_SCR_BYPASS_OFFSET		9
> +#define GEM_RX_SCR_BYPASS_SIZE			1
> +#define GEM_TX_SCR_BYPASS_OFFSET		8
> +#define GEM_TX_SCR_BYPASS_SIZE			1
> +#define GEM_RX_SYNC_RESET_OFFSET		2
> +#define GEM_RX_SYNC_RESET_SIZE			1
> +#define GEM_TX_EN_OFFSET			1
> +#define GEM_TX_EN_SIZE				1
> +#define GEM_SIGNAL_OK_OFFSET			0
> +#define GEM_SIGNAL_OK_SIZE			1
> +
> +/* Bitfields in USX_STATUS. */
> +#define GEM_USX_TX_FAULT_OFFSET			28
> +#define GEM_USX_TX_FAULT_SIZE			1
> +#define GEM_USX_RX_FAULT_OFFSET			27
> +#define GEM_USX_RX_FAULT_SIZE			1
> +#define GEM_USX_BLOCK_LOCK_OFFSET		0
> +#define GEM_USX_BLOCK_LOCK_SIZE			1
> +
>  /* Bitfields in TISUBN */
>  #define GEM_SUBNSINCR_OFFSET			0
>  #define GEM_SUBNSINCRL_OFFSET			24
> @@ -656,6 +703,8 @@
>  #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
>  #define MACB_CAPS_SG_DISABLED			0x40000000
>  #define MACB_CAPS_MACB_IS_GEM			0x80000000
> +#define MACB_CAPS_PCS				0x01000000
> +#define MACB_CAPS_HIGH_SPEED			0x02000000
>  
>  /* LSO settings */
>  #define MACB_LSO_UFO_ENABLE			0x01
> @@ -724,6 +773,7 @@
>  	})
>  
>  #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
> +#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
>  
>  /* struct macb_dma_desc - Hardware DMA descriptor
>   * @addr: DMA address of data buffer
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 17297b01e85e..710ee18a0ef0 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -81,6 +81,18 @@ struct sifive_fu540_macb_mgmt {
>  #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
>  #define MACB_WOL_ENABLED		(0x1 << 1)
>  
> +enum {
> +	HS_MAC_SPEED_100M,
> +	HS_MAC_SPEED_1000M,
> +	HS_MAC_SPEED_2500M,
> +	HS_MAC_SPEED_5000M,
> +	HS_MAC_SPEED_10000M,

Are these chip register definitions?  Shouldn't you be relying on fixed
values for these, rather than their position in an enumerated list?

> +};
> +
> +enum {
> +	MACB_SERDES_RATE_10G = 1,
> +};
> +
>  /* Graceful stop timeouts in us. We should allow up to
>   * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
>   */
> @@ -90,6 +102,8 @@ struct sifive_fu540_macb_mgmt {
>  
>  #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
>  
> +#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
> +
>  /* DMA buffer descriptor might be different size
>   * depends on hardware configuration:
>   *
> @@ -506,6 +520,7 @@ static void macb_validate(struct phylink_config *config,
>  	    state->interface != PHY_INTERFACE_MODE_RMII &&
>  	    state->interface != PHY_INTERFACE_MODE_GMII &&
>  	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> +	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
>  	    !phy_interface_mode_is_rgmii(state->interface)) {
>  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  		return;
> @@ -518,6 +533,13 @@ static void macb_validate(struct phylink_config *config,
>  		return;
>  	}
>  
> +	if (state->interface == PHY_INTERFACE_MODE_USXGMII &&
> +	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
> +	      bp->caps & MACB_CAPS_PCS)) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  	phylink_set(mask, Asym_Pause);
> @@ -527,6 +549,22 @@ static void macb_validate(struct phylink_config *config,
>  	phylink_set(mask, 100baseT_Half);
>  	phylink_set(mask, 100baseT_Full);
>  
> +	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
> +	    (state->interface == PHY_INTERFACE_MODE_NA ||
> +	     state->interface == PHY_INTERFACE_MODE_USXGMII)) {
> +		phylink_set(mask, 10000baseCR_Full);
> +		phylink_set(mask, 10000baseER_Full);
> +		phylink_set(mask, 10000baseKR_Full);
> +		phylink_set(mask, 10000baseLR_Full);
> +		phylink_set(mask, 10000baseLRM_Full);
> +		phylink_set(mask, 10000baseSR_Full);
> +		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 5000baseT_Full);
> +		phylink_set(mask, 2500baseX_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +	}
> +
>  	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
>  	    (state->interface == PHY_INTERFACE_MODE_NA ||
>  	     state->interface == PHY_INTERFACE_MODE_GMII ||
> @@ -544,6 +582,60 @@ static void macb_validate(struct phylink_config *config,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
>  }
>  
> +static int gem_mac_usx_configure(struct macb *bp,
> +				 const struct phylink_link_state *state)
> +{
> +	u32 speed, config, val;
> +	int ret;
> +
> +	val = gem_readl(bp, NCFGR);
> +	val = GEM_BIT(PCSSEL) | (~GEM_BIT(SGMIIEN) & val);
> +	if (state->pause & MLO_PAUSE_TX)
> +		val |= GEM_BIT(PAE);
> +	gem_writel(bp, NCFGR, val);
> +	gem_writel(bp, NCR, gem_readl(bp, NCR) | GEM_BIT(ENABLE_HS_MAC));
> +	gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) | GEM_BIT(FD));
> +	config = gem_readl(bp, USX_CONTROL);
> +	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
> +	config &= ~GEM_BIT(TX_SCR_BYPASS);
> +	config &= ~GEM_BIT(RX_SCR_BYPASS);
> +	gem_writel(bp, USX_CONTROL, config | GEM_BIT(TX_EN));
> +	config = gem_readl(bp, USX_CONTROL);
> +	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
> +	ret = readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
> +				 val & GEM_BIT(USX_BLOCK_LOCK),
> +				 1, MACB_USX_BLOCK_LOCK_TIMEOUT);

What if there's no signal to lock on to?  That's treated as link down
and is not a failure.

> +	if (ret < 0) {
> +		netdev_warn(bp->dev, "USXGMII block lock failed");
> +		return -ETIMEDOUT;
> +	}
> +
> +	switch (state->speed) {
> +	case SPEED_10000:
> +		speed = HS_MAC_SPEED_10000M;
> +		break;
> +	case SPEED_5000:
> +		speed = HS_MAC_SPEED_5000M;
> +		break;
> +	case SPEED_2500:
> +		speed = HS_MAC_SPEED_2500M;
> +		break;
> +	case SPEED_1000:
> +		speed = HS_MAC_SPEED_1000M;
> +		break;
> +	default:
> +	case SPEED_100:
> +		speed = HS_MAC_SPEED_100M;
> +		break;
> +	}

So you only support fixed-mode (phy and fixed links) and not in-band
links here.

> +
> +	gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, speed,
> +						gem_readl(bp, HS_MAC_CONFIG)));
> +	gem_writel(bp, USX_CONTROL, GEM_BFINS(USX_CTRL_SPEED, speed,
> +					      gem_readl(bp, USX_CONTROL)));
> +	return 0;
> +}
> +
>  static void macb_mac_pcs_get_state(struct phylink_config *config,
>  				   struct phylink_link_state *state)
>  {
> @@ -565,30 +657,39 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  
> -	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> +		if (gem_mac_usx_configure(bp, state) < 0) {
> +			spin_unlock_irqrestore(&bp->lock, flags);
> +			phylink_mac_change(bp->phylink, false);
> +			return;
> +		}
> +	} else {
> +		old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
>  
> -	/* Clear all the bits we might set later */
> -	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
> -		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> +		/* Clear all the bits we might set later */
> +		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) |
> +			  MACB_BIT(FD) | MACB_BIT(PAE) |
> +			  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
>  
> -	if (state->speed == SPEED_1000)
> -		ctrl |= GEM_BIT(GBE);
> -	else if (state->speed == SPEED_100)
> -		ctrl |= MACB_BIT(SPD);
> +		if (state->speed == SPEED_1000)
> +			ctrl |= GEM_BIT(GBE);
> +		else if (state->speed == SPEED_100)
> +			ctrl |= MACB_BIT(SPD);
>  
> -	if (state->duplex)
> -		ctrl |= MACB_BIT(FD);
> +		if (state->duplex)
> +			ctrl |= MACB_BIT(FD);
>  
> -	/* We do not support MLO_PAUSE_RX yet */
> -	if (state->pause & MLO_PAUSE_TX)
> -		ctrl |= MACB_BIT(PAE);
> +		/* We do not support MLO_PAUSE_RX yet */
> +		if (state->pause & MLO_PAUSE_TX)
> +			ctrl |= MACB_BIT(PAE);
>  
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> -		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
>  
> -	/* Apply the new configuration, if any */
> -	if (old_ctrl ^ ctrl)
> -		macb_or_gem_writel(bp, NCFGR, ctrl);
> +		/* Apply the new configuration, if any */
> +		if (old_ctrl ^ ctrl)
> +			macb_or_gem_writel(bp, NCFGR, ctrl);
> +	}
>  
>  	bp->speed = state->speed;
>  
> @@ -3399,6 +3500,11 @@ static void macb_configure_caps(struct macb *bp,
>  		dcfg = gem_readl(bp, DCFG1);
>  		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
>  			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
> +		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
> +			bp->caps |= MACB_CAPS_PCS;
> +		dcfg = gem_readl(bp, DCFG12);
> +		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
> +			bp->caps |= MACB_CAPS_HIGH_SPEED;
>  		dcfg = gem_readl(bp, DCFG2);
>  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
>  			bp->caps |= MACB_CAPS_FIFO_MODE;
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
