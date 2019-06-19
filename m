Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE214B4FB
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbfFSJb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:31:59 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60634 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSJb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bGe3aOwnKE0YZc3JsZsCNCcxPKs8/r//l6OwzNxy1FY=; b=CsnXBcQYU3OajEmsY4DKGLn9Y
        LTyl3WF3GDiJDbY+qEoQPfXdPvbNt2ygOYvQHLj5nFCWpiaO1X5Y0k2UReF54sJv/1/354eWUhMYg
        cYuaaWb3tFV48mxXy1XSeGgMvJ9cm3qGNY4nYfhfvPh6ESlZUW1fv8t9JBoDFjSepabhMcQWtY30O
        f5qt/3CGOfWtA/HWP4+Q+b92iYxSp1Ej8IQYJj4UmhpbeBFbSkz+Tfw5s8r9j1gTjmu3WRiDuRgGz
        JE/Lm695u8aY/yjcPsBg75Ai7sU4gmHfqh/gjMrQC5GiviPnrdiJlLs2EbagnIyZ/gncWU4Ubx2+l
        V3YuQMz/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59818)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hdWwW-0007sD-Tx; Wed, 19 Jun 2019 10:31:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hdWwU-0001MP-DY; Wed, 19 Jun 2019 10:31:46 +0100
Date:   Wed, 19 Jun 2019 10:31:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933646-29852-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560933646-29852-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 09:40:46AM +0100, Parshuram Thombare wrote:
> This patch add support for SGMII interface) and
> 2.5Gbps MAC in Cadence ethernet controller driver.
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      |  76 ++++++++++--
>  drivers/net/ethernet/cadence/macb_main.c | 151 ++++++++++++++++++++---
>  2 files changed, 200 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 35ed13236c8b..d7ffbfb2ecc0 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -80,6 +80,7 @@
>  #define MACB_RBQPH		0x04D4
>  
>  /* GEM register offsets. */
> +#define GEM_NCR			0x0000 /* Network Control */
>  #define GEM_NCFGR		0x0004 /* Network Config */
>  #define GEM_USRIO		0x000c /* User IO */
>  #define GEM_DMACFG		0x0010 /* DMA Configuration */
> @@ -159,6 +160,9 @@
>  #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
>  #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
>  #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
> +#define GEM_PCS_CTRL		0x0200 /* PCS Control */
> +#define GEM_PCS_STATUS		0x0204 /* PCS Status */
> +#define GEM_PCS_AN_LP_BASE	0x0214 /* PCS AN LP BASE*/
>  #define GEM_DCFG1		0x0280 /* Design Config 1 */
>  #define GEM_DCFG2		0x0284 /* Design Config 2 */
>  #define GEM_DCFG3		0x0288 /* Design Config 3 */
> @@ -274,6 +278,10 @@
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
> @@ -326,6 +334,9 @@
>  #define MACB_MDIO_SIZE		1
>  #define MACB_IDLE_OFFSET	2 /* The PHY management logic is idle */
>  #define MACB_IDLE_SIZE		1
> +#define MACB_DUPLEX_OFFSET	3
> +#define MACB_DUPLEX_SIZE	1
> +
>  
>  /* Bitfields in TSR */
>  #define MACB_UBR_OFFSET		0 /* Used bit read */
> @@ -459,11 +470,37 @@
>  #define MACB_REV_OFFSET				0
>  #define MACB_REV_SIZE				16
>  
> +/* Bitfields in PCS_CONTROL. */
> +#define GEM_PCS_CTRL_RST_OFFSET			15
> +#define GEM_PCS_CTRL_RST_SIZE			1
> +#define GEM_PCS_CTRL_EN_AN_OFFSET		12
> +#define GEM_PCS_CTRL_EN_AN_SIZE			1
> +#define GEM_PCS_CTRL_RESTART_AN_OFFSET		9
> +#define GEM_PCS_CTRL_RESTART_AN_SIZE		1
> +
> +/* Bitfields in PCS_STATUS. */
> +#define GEM_PCS_STATUS_AN_DONE_OFFSET		5
> +#define GEM_PCS_STATUS_AN_DONE_SIZE		1
> +#define GEM_PCS_STATUS_AN_SUPPORT_OFFSET	3
> +#define GEM_PCS_STATUS_AN_SUPPORT_SIZE		1
> +#define GEM_PCS_STATUS_LINK_OFFSET		2
> +#define GEM_PCS_STATUS_LINK_SIZE		1
> +
> +/* Bitfield in PCS_AN_LP_BASE */
> +#define GEM_PCS_AN_LP_BASE_LINK_OFFSET		15
> +#define GEM_PCS_AN_LP_BASE_LINK_SIZE		1
> +#define GEM_PCS_AN_LP_BASE_DUPLEX_OFFSET	12
> +#define GEM_PCS_AN_LP_BASE_DUPLEX_SIZE		1
> +#define GEM_PCS_AN_LP_BASE_SPEED_OFFSET		10
> +#define GEM_PCS_AN_LP_BASE_SPEED_SIZE		2
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
> @@ -636,19 +673,32 @@
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
> index 830af86d3c65..884d2a4408ad 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -403,6 +403,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>   */
>  static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>  {
> +	struct macb *bp = netdev_priv(dev);
>  	long ferr, rate, rate_rounded;
>  
>  	if (!clk)
> @@ -418,6 +419,12 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>  	case SPEED_1000:
>  		rate = 125000000;
>  		break;
> +	case SPEED_2500:
> +		if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL)
> +			rate = 312500000;
> +		else
> +			rate = 125000000;
> +		break;
>  	default:
>  		return;
>  	}
> @@ -448,15 +455,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
>  	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> +			phylink_set(mask, 2500baseT_Full);

This doesn't look correct to me.  SGMII as defined by Cisco only
supports 1G, 100M and 10M speeds, not 2.5G.

Even so, SGMII is not limited to just base-T - PHYs are free to offer
base-X to SGMII conversion too.

> +	/* fallthrough */
>  	case PHY_INTERFACE_MODE_GMII:
>  	case PHY_INTERFACE_MODE_RGMII:
>  		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>  			phylink_set(mask, 1000baseT_Full);
> -			phylink_set(mask, 1000baseX_Full);
> -			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
> -				phylink_set(mask, 1000baseT_Half);
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
>  				phylink_set(mask, 1000baseT_Half);
> -			}
>  		}
>  	/* fallthrough */
>  	case PHY_INTERFACE_MODE_MII:
> @@ -466,6 +474,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
>  		phylink_set(mask, 100baseT_Half);
>  		phylink_set(mask, 100baseT_Full);
>  		break;
> +
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> +			phylink_set(mask, 2500baseX_Full);
> +	/* fallthrough */
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> +			phylink_set(mask, 1000baseX_Full);
> +		break;

Please see how other drivers which use phylink deal with the validate()
format, and please read the phylink documentation:

 * Note that the PHY may be able to transform from one connection
 * technology to another, so, eg, don't clear 1000BaseX just
 * because the MAC is unable to BaseX mode. This is more about
 * clearing unsupported speeds and duplex settings.

> +
>  	default:
>  		break;
>  	}
> @@ -480,13 +498,52 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
>  {
>  	struct net_device *netdev = to_net_dev(pl_config->dev);
>  	struct macb *bp = netdev_priv(netdev);
> +	u32 status;
>  
> -	state->speed = bp->speed;
> -	state->duplex = bp->duplex;
> -	state->link = bp->link;
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> +		status = gem_readl(bp, PCS_STATUS);
> +		state->an_complete = GEM_BFEXT(PCS_STATUS_AN_DONE, status);
> +		status = gem_readl(bp, PCS_AN_LP_BASE);
> +		switch (GEM_BFEXT(PCS_AN_LP_BASE_SPEED, status)) {
> +		case 0:
> +			state->speed = SPEED_10;
> +			break;
> +		case 1:
> +			state->speed = SPEED_100;
> +			break;
> +		case 2:
> +			state->speed = SPEED_1000;
> +			break;
> +		default:
> +			break;
> +		}
> +		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
> +		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
> +	} else if (bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		state->speed = SPEED_2500;
> +		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
> +		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
> +	} else if (bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX) {
> +		state->speed = SPEED_1000;
> +		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
> +		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
> +	}

So if the phy_interface type is not one listed, we leave state alone?
That doesn't seem good.  It looks like you should at least simply set
state->duplex and state->link according to the NSR register content,
and always derive the speed.

It would also be good to set state->lp_advertising if you have access
to that so ethtool can report the link partner's abilities.  Current
Marvell drivers that use phylink don't do that because that information
is not available from the hardware.

>  	return 1;
>  }
>  
> +static void gem_mac_an_restart(struct phylink_config *pl_config)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> +			   GEM_BIT(PCS_CTRL_RESTART_AN));
> +	}

This will only be called for 802.3z link modes, so you don't need these
checks.

> +}
> +
>  static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  			   const struct phylink_link_state *state)
>  {
> @@ -506,18 +563,26 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  			reg &= ~GEM_BIT(GBE);
>  		if (state->duplex)
>  			reg |= MACB_BIT(FD);
> +		macb_or_gem_writel(bp, NCFGR, reg);
>  
>  		switch (state->speed) {
> +		case SPEED_2500:
> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +				   gem_readl(bp, NCFGR));
> +			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
> +				   gem_readl(bp, NCR));
> +			break;
>  		case SPEED_1000:
> -			reg |= GEM_BIT(GBE);
> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> +				   gem_readl(bp, NCFGR));
>  			break;
>  		case SPEED_100:
> -			reg |= MACB_BIT(SPD);
> +			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
> +				    macb_readl(bp, NCFGR));
>  			break;
>  		default:
>  			break;
>  		}
> -		macb_or_gem_writel(bp, NCFGR, reg);
>  
>  		bp->speed = state->speed;
>  		bp->duplex = state->duplex;

This is not going to work for 802.3z nor SGMII properly when in-band
negotiation is used.  We don't know ahead of time what the speed and
duplex will be.  Please see existing drivers for examples showing
how mac_config() should be implemented (there's good reason why its
laid out as it is in those drivers.)

> @@ -555,6 +620,7 @@ static void gem_mac_link_down(struct phylink_config *pl_config,
>  static const struct phylink_mac_ops gem_phylink_ops = {
>  	.validate = gem_phylink_validate,
>  	.mac_link_state = gem_phylink_mac_link_state,
> +	.mac_an_restart = gem_mac_an_restart,
>  	.mac_config = gem_mac_config,
>  	.mac_link_up = gem_mac_link_up,
>  	.mac_link_down = gem_mac_link_down,
> @@ -2248,7 +2314,9 @@ static void macb_init_hw(struct macb *bp)
>  	macb_set_hwaddr(bp);
>  
>  	config = macb_mdc_clk_div(bp);
> -	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
>  		config |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);

Configuration of the phy interface mode should be done in mac_config()
as previously mentioned, some PHYs can change their link mode at run
time.  Hotplugging SFPs can change the link mode between SGMII and
base-X too.

>  	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
>  	config |= MACB_BIT(PAE);		/* PAuse Enable */
> @@ -2273,6 +2341,17 @@ static void macb_init_hw(struct macb *bp)
>  	if (bp->caps & MACB_CAPS_JUMBO)
>  		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
>  
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		//Enable PCS AN
> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> +			   GEM_BIT(PCS_CTRL_EN_AN));
> +		//Reset PCS block
> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> +			   GEM_BIT(PCS_CTRL_RST));
> +	}
> +

Should be in mac_config.

>  	macb_configure_dma(bp);
>  
>  	/* Initialize TX and RX buffers */
> @@ -3364,6 +3443,22 @@ static void macb_configure_caps(struct macb *bp,
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
> @@ -3652,7 +3747,9 @@ static int macb_init(struct platform_device *pdev)
>  	/* Set MII management clock divider */
>  	val = macb_mdc_clk_div(bp);
>  	val |= macb_dbw(bp);
> -	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
>  		val |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);

Should be in mac_config.

>  	macb_writel(bp, NCFGR, val);
>  
> @@ -4346,11 +4443,37 @@ static int macb_probe(struct platform_device *pdev)
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
> +		if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
> +		    phy_mode == PHY_INTERFACE_MODE_1000BASEX ||
> +		    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
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
