Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF4916185E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgBQQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:56:56 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39154 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgBQQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2/En5IBaP1moV+pglClAUBUFc5ut9gbuR38WbrIBi8E=; b=iHB8AbZ1Vnw4mfaL2XpqFSha0
        Phl21B5adT9qkUS+oIjhwKzNrJ9zF9ogY5LwOPq8/CwAacml5pUsOH/US9s33sSoRB0zaqGsEEH8K
        ipyEWYXdeLXd+7K7lBqES9rPn8pJTBFsEr7XzFAA+rAUb/Sgm8oZLJI4uQKOiGWa3BUUhXJahyaaV
        f4L5JMSjUAoZ5dAgRskiP0wGNqe6kqQ3vuTkoMey0doLT9/E53VLppdWit9LTNj4yTxWKb3NbN6XC
        M+T+TP7Y8FwbUEVECeD0m94bSgLC6cQPj2uNP1xTmFmW3l02B3Cfv4M4psMwtJwbb9fQeP3ISwKc4
        N0cJWPOLg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41594)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3jhO-0001yk-Pd; Mon, 17 Feb 2020 16:56:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3jhM-0006St-61; Mon, 17 Feb 2020 16:56:44 +0000
Date:   Mon, 17 Feb 2020 16:56:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200217165644.GX25745@shell.armlinux.org.uk>
References: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 11:43:48AM +0100, Alexandre Belloni wrote:
> at91ether_init was handling the phy mode and speed but since the switch to
> phylink, the NCFGR register got overwritten by macb_mac_config().

I don't think this actually explains anything - or at least I can't
make sense of it with respect to your patch.

You claim that the NCFGR register gets overwritten in macb_mac_config(),
but I see that the NCFGR register is read-modify-write in there,
whereas your new implementation below doesn't bother reading the
present value.

I think the issue you're referring to is the clearing of the PAE bit,
which is also the RM9200_RMII for at91rm9200?

Next, there's some duplication of code introduced here - it seems
that the tail end of macb_mac_link_down() and at91ether_mac_link_down()
are identical, as are the tail end of macb_mac_link_up() and
at91ether_mac_link_up().

> Add new phylink callbacks to handle emac and at91rm9200 properly.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---

I posted a heads-up message last week about updates to phylink that
I'll be submitting soon (most of the prerequisits have now been sent
for review) which touch every phylink_mac_ops-using piece of code in
the tree.  Unfortunately, this patch introduces a new instance that
likely isn't going to get my attention, so it's going to create a
subtle merge conflict between net-next and net trees unless we work
out some way to deal with it.

I'm just mentioning that so that some thought can be applied now
rather than when it actually happens - especially as I've no way to
test the changes that will be necessary for this driver.

>  drivers/net/ethernet/cadence/macb.h      |  1 +
>  drivers/net/ethernet/cadence/macb_main.c | 81 +++++++++++++++++++++---
>  2 files changed, 73 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index dbf7070fcdba..a3f0f27fc79a 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -652,6 +652,7 @@
>  #define MACB_CAPS_GEM_HAS_PTP			0x00000040
>  #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
>  #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
> +#define MACB_CAPS_MACB_IS_EMAC			0x08000000
>  #define MACB_CAPS_FIFO_MODE			0x10000000
>  #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
>  #define MACB_CAPS_SG_DISABLED			0x40000000
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index def94e91883a..529a1d0d7dab 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -654,6 +654,72 @@ static const struct phylink_mac_ops macb_phylink_ops = {
>  	.mac_link_up = macb_mac_link_up,
>  };
>  
> +static void at91ether_mac_config(struct phylink_config *config,
> +				 unsigned int mode,
> +				 const struct phylink_link_state *state)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct macb *bp = netdev_priv(ndev);
> +	unsigned long flags;
> +	u32 ctrl;
> +
> +	spin_lock_irqsave(&bp->lock, flags);
> +
> +	ctrl = MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG);
> +	if (state->speed == SPEED_100)
> +		ctrl |= MACB_BIT(SPD);
> +
> +	if (state->duplex)
> +		ctrl |= MACB_BIT(FD);
> +
> +	if (state->interface == PHY_INTERFACE_MODE_RMII)
> +		ctrl |= MACB_BIT(RM9200_RMII);
> +
> +	macb_writel(bp, NCFGR, ctrl);
> +
> +	bp->speed = state->speed;
> +
> +	spin_unlock_irqrestore(&bp->lock, flags);
> +}
> +
> +static void at91ether_mac_link_down(struct phylink_config *config,
> +				    unsigned int mode,
> +				    phy_interface_t interface)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct macb *bp = netdev_priv(ndev);
> +	u32 ctrl;
> +
> +	/* Disable Rx and Tx */
> +	ctrl = macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE));
> +	macb_writel(bp, NCR, ctrl);
> +
> +	netif_tx_stop_all_queues(ndev);
> +}
> +
> +static void at91ether_mac_link_up(struct phylink_config *config,
> +				  unsigned int mode,
> +				  phy_interface_t interface,
> +				  struct phy_device *phy)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct macb *bp = netdev_priv(ndev);
> +
> +	/* Enable Rx and Tx */
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
> +
> +	netif_tx_wake_all_queues(ndev);
> +}
> +
> +static const struct phylink_mac_ops at91ether_phylink_ops = {
> +	.validate = macb_validate,
> +	.mac_pcs_get_state = macb_mac_pcs_get_state,
> +	.mac_an_restart = macb_mac_an_restart,
> +	.mac_config = at91ether_mac_config,
> +	.mac_link_down = at91ether_mac_link_down,
> +	.mac_link_up = at91ether_mac_link_up,
> +};
> +
>  static bool macb_phy_handle_exists(struct device_node *dn)
>  {
>  	dn = of_parse_phandle(dn, "phy-handle", 0);
> @@ -695,13 +761,17 @@ static int macb_phylink_connect(struct macb *bp)
>  /* based on au1000_eth. c*/
>  static int macb_mii_probe(struct net_device *dev)
>  {
> +	const struct phylink_mac_ops *phylink_ops = &macb_phylink_ops;
>  	struct macb *bp = netdev_priv(dev);
>  
> +	if (bp->caps & MACB_CAPS_MACB_IS_EMAC)
> +		phylink_ops = &at91ether_phylink_ops;
> +
>  	bp->phylink_config.dev = &dev->dev;
>  	bp->phylink_config.type = PHYLINK_NETDEV;
>  
>  	bp->phylink = phylink_create(&bp->phylink_config, bp->pdev->dev.fwnode,
> -				     bp->phy_interface, &macb_phylink_ops);
> +				     bp->phy_interface, phylink_ops);
>  	if (IS_ERR(bp->phylink)) {
>  		netdev_err(dev, "Could not create a phylink instance (%ld)\n",
>  			   PTR_ERR(bp->phylink));
> @@ -4041,7 +4111,6 @@ static int at91ether_init(struct platform_device *pdev)
>  	struct net_device *dev = platform_get_drvdata(pdev);
>  	struct macb *bp = netdev_priv(dev);
>  	int err;
> -	u32 reg;
>  
>  	bp->queues[0].bp = bp;
>  
> @@ -4055,12 +4124,6 @@ static int at91ether_init(struct platform_device *pdev)
>  
>  	macb_writel(bp, NCR, 0);
>  
> -	reg = MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG);
> -	if (bp->phy_interface == PHY_INTERFACE_MODE_RMII)
> -		reg |= MACB_BIT(RM9200_RMII);
> -
> -	macb_writel(bp, NCFGR, reg);
> -
>  	return 0;
>  }
>  
> @@ -4218,7 +4281,7 @@ static const struct macb_config sama5d4_config = {
>  };
>  
>  static const struct macb_config emac_config = {
> -	.caps = MACB_CAPS_NEEDS_RSTONUBR,
> +	.caps = MACB_CAPS_NEEDS_RSTONUBR | MACB_CAPS_MACB_IS_EMAC,
>  	.clk_init = at91ether_clk_init,
>  	.init = at91ether_init,
>  };
> -- 
> 2.24.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
