Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0913250C4C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfFXNsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:48:08 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34572 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfFXNsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0m1Z+DGmiFVbYLYYydoSL7HbplRewKAhot6TihRQpkI=; b=x1lc1+FApuLoEGqnmJV2LWU0W
        vdg6J6R7ket+/CWRc99euIB6qdQZbC5vVp8PuN7lAL8DkCffytEw4vyJPPMmUYQK1kv027kLh9xE+
        PVKs9lPCjOCxC9+NZUheSBRIdKwKRhvZOmXeAMZoGRhHCEqMKQ/+LrdSVr3u4j3bjqJ4gZtNdqYF5
        fMeEcKV+T8OKXIWzdrLwH6SiXS+eamGs6V/Lx1+TDbuQjGv702FEoSlroANwfCL+OwGxR4qejP3yF
        cLPVhfmQxjqLo29/1zw/CHjoTBgwGcmaIBvqjPJD2qgcSYTG0XXzprNJjz+DyOkXPjfYGQ3cepiYq
        zlWwUvIbQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58944)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPKA-0008Ju-EI; Mon, 24 Jun 2019 14:47:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPK7-0006Kt-Vi; Mon, 24 Jun 2019 14:47:56 +0100
Date:   Mon, 24 Jun 2019 14:47:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v5 4/5] net: macb: add support for high speed interface
Message-ID: <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378355-14048-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561378355-14048-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 01:12:35PM +0100, Parshuram Thombare wrote:
> This patch add support for high speed USXGMII PCS and 10G
> speed in Cadence ethernet controller driver.
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      |  41 +++++
>  drivers/net/ethernet/cadence/macb_main.c | 189 ++++++++++++++++++++---
>  2 files changed, 207 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 330da702b946..809acff19be9 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -82,6 +82,7 @@
>  #define GEM_USRIO		0x000c /* User IO */
>  #define GEM_DMACFG		0x0010 /* DMA Configuration */
>  #define GEM_JML			0x0048 /* Jumbo Max Length */
> +#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
>  #define GEM_HRB			0x0080 /* Hash Bottom */
>  #define GEM_HRT			0x0084 /* Hash Top */
>  #define GEM_SA1B		0x0088 /* Specific1 Bottom */
> @@ -167,6 +168,9 @@
>  #define GEM_DCFG7		0x0298 /* Design Config 7 */
>  #define GEM_DCFG8		0x029C /* Design Config 8 */
>  #define GEM_DCFG10		0x02A4 /* Design Config 10 */
> +#define GEM_DCFG12		0x02AC /* Design Config 12 */
> +#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
> +#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
>  
>  #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
>  #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
> @@ -274,6 +278,8 @@
>  #define MACB_IRXFCS_SIZE	1
>  
>  /* GEM specific NCR bitfields. */
> +#define GEM_ENABLE_HS_MAC_OFFSET	31
> +#define GEM_ENABLE_HS_MAC_SIZE		1
>  #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
>  #define GEM_TWO_PT_FIVE_GIG_SIZE	1
>  
> @@ -465,6 +471,10 @@
>  #define MACB_REV_OFFSET				0
>  #define MACB_REV_SIZE				16
>  
> +/* Bitfield in HS_MAC_CONFIG */
> +#define GEM_HS_MAC_SPEED_OFFSET			0
> +#define GEM_HS_MAC_SPEED_SIZE			3
> +
>  /* Bitfields in PCS_CONTROL. */
>  #define GEM_PCS_CTRL_RST_OFFSET			15
>  #define GEM_PCS_CTRL_RST_SIZE			1
> @@ -510,6 +520,34 @@
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
>  #define GEM_SUBNSINCR_SIZE			16
> @@ -670,6 +708,7 @@
>  #define MACB_CAPS_MACB_IS_GEM			BIT(31)
>  #define MACB_CAPS_PCS				BIT(24)
>  #define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
> +#define MACB_CAPS_HIGH_SPEED			BIT(26)
>  
>  #define MACB_GEM7010_IDNUM			0x009
>  #define MACB_GEM7014_IDNU			0x107
> @@ -749,6 +788,7 @@
>  	})
>  
>  #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
> +#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
>  
>  /* struct macb_dma_desc - Hardware DMA descriptor
>   * @addr: DMA address of data buffer
> @@ -1262,6 +1302,7 @@ struct macb {
>  	struct macb_pm_data pm_data;
>  	struct phylink *pl;
>  	struct phylink_config pl_config;
> +	u32 serdes_rate;
>  };
>  
>  #ifdef CONFIG_MACB_USE_HWSTAMP
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 1323f9b4d3b8..5afc03299bee 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -84,6 +84,20 @@ static struct sifive_fu540_macb_mgmt *mgmt;
>  #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
>  #define MACB_WOL_ENABLED		(0x1 << 1)
>  
> +enum {
> +	HS_MAC_SPEED_100M,
> +	HS_MAC_SPEED_1000M,
> +	HS_MAC_SPEED_2500M,
> +	HS_MAC_SPEED_5000M,
> +	HS_MAC_SPEED_10000M,
> +	HS_MAC_SPEED_25000M,
> +};
> +
> +enum {
> +	MACB_SERDES_RATE_5Gbps = 5,
> +	MACB_SERDES_RATE_10Gbps = 10,
> +};
> +
>  /* Graceful stop timeouts in us. We should allow up to
>   * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
>   */
> @@ -93,6 +107,8 @@ static struct sifive_fu540_macb_mgmt *mgmt;
>  
>  #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
>  
> +#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
> +
>  /* DMA buffer descriptor might be different size
>   * depends on hardware configuration:
>   *
> @@ -439,23 +455,37 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>   */
>  static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>  {
> +	struct macb *bp = netdev_priv(dev);
>  	long ferr, rate, rate_rounded;
>  
>  	if (!clk)
>  		return;
>  
> -	switch (speed) {
> -	case SPEED_10:
> -		rate = 2500000;
> -		break;
> -	case SPEED_100:
> -		rate = 25000000;
> -		break;
> -	case SPEED_1000:
> -		rate = 125000000;
> -		break;
> -	default:
> -		return;
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> +		switch (bp->serdes_rate) {
> +		case MACB_SERDES_RATE_5Gbps:
> +			rate = 78125000;
> +			break;
> +		case MACB_SERDES_RATE_10Gbps:
> +			rate = 156250000;
> +			break;
> +		default:
> +			return;
> +		}
> +	} else {
> +		switch (speed) {
> +		case SPEED_10:
> +			rate = 2500000;
> +			break;
> +		case SPEED_100:
> +			rate = 25000000;
> +			break;
> +		case SPEED_1000:
> +			rate = 125000000;
> +			break;
> +		default:
> +			return;
> +		}
>  	}
>  
>  	rate_rounded = clk_round_rate(clk, rate);
> @@ -485,6 +515,21 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
>  
>  	switch (state->interface) {
>  	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_USXGMII:
> +	case PHY_INTERFACE_MODE_10GKR:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 10000baseCR_Full);
> +			phylink_set(mask, 10000baseER_Full);
> +			phylink_set(mask, 10000baseKR_Full);
> +			phylink_set(mask, 10000baseLR_Full);
> +			phylink_set(mask, 10000baseLRM_Full);
> +			phylink_set(mask, 10000baseSR_Full);
> +			phylink_set(mask, 10000baseT_Full);
> +			phylink_set(mask, 5000baseT_Full);
> +			phylink_set(mask, 2500baseX_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +		}

If MACB_CAPS_GIGABIT_MODE_AVAILABLE is not set, are these interface
modes supported by the hardware?  If the PHY interface mode is not
supported, then the returned support mask must be cleared.

> +	/* fallthrough */
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_GMII:
>  	case PHY_INTERFACE_MODE_RGMII:
> @@ -516,6 +561,91 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int macb_wait_for_usx_block_lock(struct macb *bp)
> +{
> +	u32 val;
> +
> +	return readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
> +				  val & GEM_BIT(USX_BLOCK_LOCK),
> +				  1, MACB_USX_BLOCK_LOCK_TIMEOUT);
> +}
> +
> +static inline int gem_mac_usx_configure(struct macb *bp, int spd)
> +{
> +	u32 speed, config;
> +
> +	gem_writel(bp, NCFGR, GEM_BIT(PCSSEL) |
> +		   (~GEM_BIT(SGMIIEN) & gem_readl(bp, NCFGR)));
> +	gem_writel(bp, NCR, gem_readl(bp, NCR) |
> +		   GEM_BIT(ENABLE_HS_MAC));
> +	gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) |
> +		   MACB_BIT(FD));
> +	config = gem_readl(bp, USX_CONTROL);
> +	config = GEM_BFINS(SERDES_RATE, bp->serdes_rate, config);
> +	config &= ~GEM_BIT(TX_SCR_BYPASS);
> +	config &= ~GEM_BIT(RX_SCR_BYPASS);
> +	gem_writel(bp, USX_CONTROL, config |
> +		   GEM_BIT(TX_EN));
> +	config = gem_readl(bp, USX_CONTROL);
> +	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
> +	if (macb_wait_for_usx_block_lock(bp) < 0) {
> +		netdev_warn(bp->dev, "USXGMII block lock failed");
> +		return -ETIMEDOUT;
> +	}
> +
> +	switch (spd) {
> +	case SPEED_10000:
> +		if (bp->serdes_rate >= MACB_SERDES_RATE_10Gbps) {
> +			speed = HS_MAC_SPEED_10000M;
> +		} else {
> +			netdev_warn(bp->dev, "10G speed isn't supported by HW");
> +			netdev_warn(bp->dev, "Setting speed to 1G");
> +			speed = HS_MAC_SPEED_1000M;
> +		}
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
> +
> +	gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, speed,
> +						gem_readl(bp, HS_MAC_CONFIG)));
> +	gem_writel(bp, USX_CONTROL, GEM_BFINS(USX_CTRL_SPEED, speed,
> +					      gem_readl(bp, USX_CONTROL)));
> +	return 0;
> +}
> +
> +static inline void gem_mac_configure(struct macb *bp, int speed)
> +{
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> +		gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
> +			   GEM_BIT(PCSSEL) |
> +			   gem_readl(bp, NCFGR));

Is this still necessary?

> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +			   gem_readl(bp, NCFGR));
> +		break;
> +	case SPEED_100:
> +		macb_writel(bp, NCFGR, MACB_BIT(SPD) |
> +			    macb_readl(bp, NCFGR));

What happens to the NCFGR register if we call mac_config() first for
a 1G speed, then 100M and finally 10M - what value does the NCFGR
register end up with?

I suspect it ends up with both the GBE and SPD bits set, and that is
probably not what you want.

> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  			   const struct phylink_link_state *state)
>  {
> @@ -558,18 +688,17 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  
>  		if (state->duplex)
>  			reg |= MACB_BIT(FD);
> +		macb_or_gem_writel(bp, NCFGR, reg);
>  
> -		switch (state->speed) {
> -		case SPEED_1000:
> -			reg |= GEM_BIT(GBE);
> -			break;
> -		case SPEED_100:
> -			reg |= MACB_BIT(SPD);
> -			break;
> -		default:
> -			break;
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> +			if (gem_mac_usx_configure(bp, state->speed) < 0) {
> +				spin_unlock_irqrestore(&bp->lock, flags);
> +				phylink_mac_change(bp->pl, false);
> +				return;
> +			}
> +		} else {
> +			gem_mac_configure(bp, state->speed);
>  		}
> -		macb_or_gem_writel(bp, NCFGR, reg);
>  
>  		bp->speed = state->speed;
>  		bp->duplex = state->duplex;
> @@ -3416,6 +3545,9 @@ static void macb_configure_caps(struct macb *bp,
>  		default:
>  			break;
>  		}
> +		dcfg = gem_readl(bp, DCFG12);
> +		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
> +			bp->caps |= MACB_CAPS_HIGH_SPEED;
>  		dcfg = gem_readl(bp, DCFG2);
>  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
>  			bp->caps |= MACB_CAPS_FIFO_MODE;
> @@ -4404,7 +4536,18 @@ static int macb_probe(struct platform_device *pdev)
>  	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
>  		u32 interface_supported = 1;
>  
> -		if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
> +		if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
> +			if (!(bp->caps & MACB_CAPS_HIGH_SPEED &&
> +			      bp->caps & MACB_CAPS_PCS))
> +				interface_supported = 0;
> +
> +			if (of_property_read_u32(np, "serdes-rate-gbps",
> +						 &bp->serdes_rate)) {
> +				netdev_err(dev,
> +					   "GEM serdes_rate not specified");
> +				interface_supported = 0;
> +			}
> +		} else if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
>  			if (!(bp->caps & MACB_CAPS_PCS))
>  				interface_supported = 0;
>  		} else if (phy_mode == PHY_INTERFACE_MODE_GMII ||
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
