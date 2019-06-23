Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B799F4FB09
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFWKMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 06:12:35 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43616 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbfFWKMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 06:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AhVbW53DiFag2s6qjbCyihqf53aiVzQngIQZlfTYUak=; b=ET9HmijqKungmxoWAjkb3PZDc
        z469Bq1La5cVi9ocJP35bJGP+UUbwxP7d1iktdyAhu1hlSWqXdSUajG0eBGQUd4yu/+jWE3m3171M
        l4UNpPhcns9FSJ7yh06PFSuibt1qTsIbfIhk1XgVnzCDKFhmcrl18mmwuX4CadkvHRQ4/bGCrUWLc
        5jWtO+jaKq2rggx5qUdrxhsBHUTZ7U49tywiKY1Z0CW66iBsl5RljAMQ++HJDiY2u0VbVQ8hTnSOF
        JMdIcp8aFAN2oQDLhJ3wzSp2wZGp6gF367pk99r0Ei/IyK2vxdJ1+Z5a35J9mN7TEnFB+3a++DfYF
        3mIUUGFfw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59906)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hezU2-0000hz-Cy; Sun, 23 Jun 2019 11:12:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hezU0-0004wf-AM; Sun, 23 Jun 2019 11:12:24 +0100
Date:   Sun, 23 Jun 2019 11:12:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561281781-13479-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:23:01AM +0100, Parshuram Thombare wrote:
> This patch add support for SGMII interface) and
> 2.5Gbps MAC in Cadence ethernet controller driver.
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 54 ++++++++++++----
>  drivers/net/ethernet/cadence/macb_main.c | 80 +++++++++++++++++++++---
>  2 files changed, 112 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 8629d345af31..6d268283c318 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -77,6 +77,7 @@
>  #define MACB_RBQPH		0x04D4
>  
>  /* GEM register offsets. */
> +#define GEM_NCR			0x0000 /* Network Control */
>  #define GEM_NCFGR		0x0004 /* Network Config */
>  #define GEM_USRIO		0x000c /* User IO */
>  #define GEM_DMACFG		0x0010 /* DMA Configuration */
> @@ -156,6 +157,7 @@
>  #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
>  #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
>  #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
> +#define GEM_PCS_CTRL		0x0200 /* PCS Control */
>  #define GEM_DCFG1		0x0280 /* Design Config 1 */
>  #define GEM_DCFG2		0x0284 /* Design Config 2 */
>  #define GEM_DCFG3		0x0288 /* Design Config 3 */
> @@ -271,6 +273,10 @@
>  #define MACB_IRXFCS_OFFSET	19
>  #define MACB_IRXFCS_SIZE	1
>  
> +/* GEM specific NCR bitfields. */
> +#define GEM_TWO_PT_FIVE_GIG_OFFSET	29
> +#define GEM_TWO_PT_FIVE_GIG_SIZE	1
> +
>  /* GEM specific NCFGR bitfields. */
>  #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
>  #define GEM_GBE_SIZE		1
> @@ -323,6 +329,9 @@
>  #define MACB_MDIO_SIZE		1
>  #define MACB_IDLE_OFFSET	2 /* The PHY management logic is idle */
>  #define MACB_IDLE_SIZE		1
> +#define MACB_DUPLEX_OFFSET	3
> +#define MACB_DUPLEX_SIZE	1
> +
>  
>  /* Bitfields in TSR */
>  #define MACB_UBR_OFFSET		0 /* Used bit read */
> @@ -456,11 +465,17 @@
>  #define MACB_REV_OFFSET				0
>  #define MACB_REV_SIZE				16
>  
> +/* Bitfields in PCS_CONTROL. */
> +#define GEM_PCS_CTRL_RST_OFFSET			15
> +#define GEM_PCS_CTRL_RST_SIZE			1
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
> @@ -633,19 +648,32 @@
>  #define MACB_MAN_CODE				2
>  
>  /* Capability mask bits */
> -#define MACB_CAPS_ISR_CLEAR_ON_WRITE		0x00000001
> -#define MACB_CAPS_USRIO_HAS_CLKEN		0x00000002
> -#define MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII	0x00000004
> -#define MACB_CAPS_NO_GIGABIT_HALF		0x00000008
> -#define MACB_CAPS_USRIO_DISABLED		0x00000010
> -#define MACB_CAPS_JUMBO				0x00000020
> -#define MACB_CAPS_GEM_HAS_PTP			0x00000040
> -#define MACB_CAPS_BD_RD_PREFETCH		0x00000080
> -#define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
> -#define MACB_CAPS_FIFO_MODE			0x10000000
> -#define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
> -#define MACB_CAPS_SG_DISABLED			0x40000000
> -#define MACB_CAPS_MACB_IS_GEM			0x80000000
> +#define MACB_CAPS_ISR_CLEAR_ON_WRITE		BIT(0)
> +#define MACB_CAPS_USRIO_HAS_CLKEN		BIT(1)
> +#define MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII	BIT(2)
> +#define MACB_CAPS_NO_GIGABIT_HALF		BIT(3)
> +#define MACB_CAPS_USRIO_DISABLED		BIT(4)
> +#define MACB_CAPS_JUMBO				BIT(5)
> +#define MACB_CAPS_GEM_HAS_PTP			BIT(6)
> +#define MACB_CAPS_BD_RD_PREFETCH		BIT(7)
> +#define MACB_CAPS_NEEDS_RSTONUBR		BIT(8)
> +#define MACB_CAPS_FIFO_MODE			BIT(28)
> +#define MACB_CAPS_GIGABIT_MODE_AVAILABLE	BIT(29)
> +#define MACB_CAPS_SG_DISABLED			BIT(30)
> +#define MACB_CAPS_MACB_IS_GEM			BIT(31)
> +#define MACB_CAPS_PCS				BIT(24)
> +#define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
> +
> +#define MACB_GEM7010_IDNUM			0x009
> +#define MACB_GEM7014_IDNU			0x107
> +#define MACB_GEM7014A_IDNUM			0x207
> +#define MACB_GEM7016_IDNUM			0x10a
> +#define MACB_GEM7017_IDNUM			0x00a
> +#define MACB_GEM7017A_IDNUM			0x20a
> +#define MACB_GEM7020_IDNUM			0x003
> +#define MACB_GEM7021_IDNUM			0x00c
> +#define MACB_GEM7021A_IDNUM			0x20c
> +#define MACB_GEM7022_IDNUM			0x00b
>  
>  /* LSO settings */
>  #define MACB_LSO_UFO_ENABLE			0x01
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 1d6527a5313f..10d18b2cef31 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -445,15 +445,15 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
>  	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_GMII:
>  	case PHY_INTERFACE_MODE_RGMII:
>  		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>  			phylink_set(mask, 1000baseT_Full);
>  			phylink_set(mask, 1000baseX_Full);
> -			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
>  				phylink_set(mask, 1000baseT_Half);
> -				phylink_set(mask, 1000baseT_Half);
> -			}
>  		}
>  	/* fallthrough */
>  	case PHY_INTERFACE_MODE_MII:
> @@ -469,7 +469,6 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
>  
>  	linkmode_and(supported, supported, mask);
>  	linkmode_and(state->advertising, state->advertising, mask);
> -
>  }
>  
>  static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
> @@ -483,19 +482,42 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  {
>  	struct net_device *netdev = to_net_dev(pl_config->dev);
>  	struct macb *bp = netdev_priv(netdev);
> +	bool change_interface = bp->phy_interface != state->interface;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  
> +	if (change_interface) {
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> +			gem_writel(bp, NCFGR, ~GEM_BIT(SGMIIEN) &
> +				   ~GEM_BIT(PCSSEL) &
> +				   gem_readl(bp, NCFGR));
> +			gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
> +				   gem_readl(bp, NCR));
> +			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> +				   GEM_BIT(PCS_CTRL_RST));
> +		}

I still don't think this makes much sense, splitting the interface
configuration between here and below.

> +		bp->phy_interface = state->interface;
> +	}
> +
>  	if (!phylink_autoneg_inband(mode) &&
>  	    (bp->speed != state->speed ||
> -	     bp->duplex != state->duplex)) {
> +	     bp->duplex != state->duplex ||
> +	     change_interface)) {
>  		u32 reg;
>  
>  		reg = macb_readl(bp, NCFGR);
>  		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
>  		if (macb_is_gem(bp))
>  			reg &= ~GEM_BIT(GBE);
> +		macb_or_gem_writel(bp, NCFGR, reg);
> +
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> +			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
> +				   GEM_BIT(PCSSEL) |
> +				   gem_readl(bp, NCFGR));

This will only be executed when we are not using inband mode, which
basically means it's not possible to switch to SGMII in-band mode.

> +
> +		reg = macb_readl(bp, NCFGR);
>  		if (state->duplex)
>  			reg |= MACB_BIT(FD);
>  
> @@ -590,8 +612,8 @@ static int macb_mii_probe(struct net_device *dev)
>  	}
>  
>  	bp->link = 0;
> -	bp->speed = 0;
> -	bp->duplex = -1;
> +	bp->speed = SPEED_UNKNOWN;
> +	bp->duplex = DUPLEX_UNKNOWN;
>  
>  	return ret;
>  }
> @@ -3340,6 +3362,22 @@ static void macb_configure_caps(struct macb *bp,
>  		dcfg = gem_readl(bp, DCFG1);
>  		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
>  			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
> +		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
> +			bp->caps |= MACB_CAPS_PCS;
> +		switch (MACB_BFEXT(IDNUM, macb_readl(bp, MID))) {
> +		case MACB_GEM7016_IDNUM:
> +		case MACB_GEM7017_IDNUM:
> +		case MACB_GEM7017A_IDNUM:
> +		case MACB_GEM7020_IDNUM:
> +		case MACB_GEM7021_IDNUM:
> +		case MACB_GEM7021A_IDNUM:
> +		case MACB_GEM7022_IDNUM:
> +			bp->caps |= MACB_CAPS_USRIO_DISABLED;
> +			bp->caps |= MACB_CAPS_MACB_IS_GEM_GXL;
> +			break;
> +		default:
> +			break;
> +		}
>  		dcfg = gem_readl(bp, DCFG2);
>  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
>  			bp->caps |= MACB_CAPS_FIFO_MODE;
> @@ -4322,11 +4360,35 @@ static int macb_probe(struct platform_device *pdev)
>  	}
>  
>  	phy_mode = of_get_phy_mode(np);
> -	if (phy_mode < 0)
> +	if (phy_mode < 0) {
>  		/* not found in DT, MII by default */
>  		bp->phy_interface = PHY_INTERFACE_MODE_MII;
> -	else
> +	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
> +		u32 interface_supported = 1;
> +
> +		if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
> +			if (!(bp->caps & MACB_CAPS_PCS))
> +				interface_supported = 0;
> +		} else if (phy_mode == PHY_INTERFACE_MODE_GMII ||
> +			   phy_mode == PHY_INTERFACE_MODE_RGMII) {
> +			if (!macb_is_gem(bp))
> +				interface_supported = 0;
> +		} else if (phy_mode != PHY_INTERFACE_MODE_RMII &&
> +			   phy_mode != PHY_INTERFACE_MODE_MII) {
> +			/* Add new mode before this */
> +			interface_supported = 0;
> +		}
> +
> +		if (!interface_supported) {
> +			netdev_err(dev, "Phy mode %s not supported",
> +				   phy_modes(phy_mode));
> +			goto err_out_free_netdev;
> +		}
> +
>  		bp->phy_interface = phy_mode;
> +	} else {
> +		bp->phy_interface = phy_mode;
> +	}

If bp->phy_interface is PHY_INTERFACE_MODE_SGMII here, and mac_config()
is called with state->interface = PHY_INTERFACE_MODE_SGMII, then
mac_config() won't configure the MAC for the interface type - is that
intentional?

>  
>  	/* IP specific init */
>  	err = init(pdev);
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
