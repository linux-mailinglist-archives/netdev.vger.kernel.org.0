Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5EF449E82
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhKHV4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhKHV4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:56:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC61C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 13:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iCjvE+lRVWJDjfBgwsYNTnGsPhH+GU4HIHujqaNY26o=; b=xS8kKXGNbcIhQf3g2+OWd8AUJq
        7MFz0w0l8d2YAvmvRYBW4tsl2Gpe1v4g+eS9PatZ29ES+hlbiACdarB+f/Fi15j7mErdi0Ca6Q08P
        lOR7eTeaDV+nf6kKptRtbmHHzENzF3+jeQgBy0b6Xmdi5Cl3qD3r77Om4fMB7g2qwl+rdpCA1H1i4
        UtBAu48AQkZCY16UIeFPSW0FtU69twVvEWqdgufFV+9CzZoYMPGsK+XY8rAcfpMfnuhqqtYj5RIo+
        BNhDDi81Mxg9+nvzsqgL3rlKHMxycf1mkTjB8TvatU30+ca3BxgoN5FXeCyxJrB/OEHjNbc6h/1um
        EhaeUW1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55546)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mkCaO-0001Au-4Z; Mon, 08 Nov 2021 21:53:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mkCaM-00038o-UM; Mon, 08 Nov 2021 21:53:50 +0000
Date:   Mon, 8 Nov 2021 21:53:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: marvell: mvpp2: Fix wrong SerDes
 reconfiguration order
Message-ID: <YYmcbmuefuEaARxq@shell.armlinux.org.uk>
References: <20211108214918.25222-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211108214918.25222-1-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:49:18PM +0100, Marek Behún wrote:
> Commit bfe301ebbc94 ("net: mvpp2: convert to use
> mac_prepare()/mac_finish()") introduced a bug wherein it leaves the MAC
> RESET register asserted after mac_finish(), due to wrong order of
> function calls.
> 
> Before it was:
>   .mac_config()
>     mvpp22_mode_reconfigure()
>       assert reset
>     mvpp2_xlg_config()
>       deassert reset
> 
> Now it is:
>   .mac_prepare()
>   .mac_config()
>     mvpp2_xlg_config()
>       deassert reset
>   .mac_finish()
>     mvpp2_xlg_config()
>       assert reset
> 
> Obviously this is wrong.
> 
> This bug is triggered when phylink tries to change the PHY interface
> mode from a GMAC mode (sgmii, 1000base-x, 2500base-x) to XLG mode
> (10gbase-r, xaui). The XLG mode does not work since reset is left
> asserted. Only after
>   ifconfig down && ifconfig up
> is called will the XLG mode work.
> 
> Move the call to mvpp22_mode_reconfigure() to .mac_prepare()
> implementation. Since some of the subsequent functions need to know
> whether the interface is being changed, we unfortunately also need to
> pass around the new interface mode before setting port->phy_interface.
> 
> Fixes: bfe301ebbc94 ("net: mvpp2: convert to use mac_prepare()/mac_finish()")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks Marek.

For those who may say something about the sign-offs, we were both
working on the problem, and both eventually came up with the same
patch while talking about it on IRC, so this is kind of co-creation
- and hence the two sign-offs.

> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 38 ++++++++++---------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 587def69a6f7..2b18d89d9756 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1605,7 +1605,7 @@ static void mvpp22_gop_fca_set_periodic_timer(struct mvpp2_port *port)
>  	mvpp22_gop_fca_enable_periodic(port, true);
>  }
>  
> -static int mvpp22_gop_init(struct mvpp2_port *port)
> +static int mvpp22_gop_init(struct mvpp2_port *port, phy_interface_t interface)
>  {
>  	struct mvpp2 *priv = port->priv;
>  	u32 val;
> @@ -1613,7 +1613,7 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
>  	if (!priv->sysctrl_base)
>  		return 0;
>  
> -	switch (port->phy_interface) {
> +	switch (interface) {
>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
> @@ -1743,15 +1743,15 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
>   * lanes by the physical layer. This is why configurations like
>   * "PPv2 (2500BaseX) - COMPHY (2500SGMII)" are valid.
>   */
> -static int mvpp22_comphy_init(struct mvpp2_port *port)
> +static int mvpp22_comphy_init(struct mvpp2_port *port,
> +			      phy_interface_t interface)
>  {
>  	int ret;
>  
>  	if (!port->comphy)
>  		return 0;
>  
> -	ret = phy_set_mode_ext(port->comphy, PHY_MODE_ETHERNET,
> -			       port->phy_interface);
> +	ret = phy_set_mode_ext(port->comphy, PHY_MODE_ETHERNET, interface);
>  	if (ret)
>  		return ret;
>  
> @@ -2172,7 +2172,8 @@ static void mvpp22_pcs_reset_assert(struct mvpp2_port *port)
>  	writel(val & ~MVPP22_XPCS_CFG0_RESET_DIS, xpcs + MVPP22_XPCS_CFG0);
>  }
>  
> -static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port)
> +static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port,
> +				      phy_interface_t interface)
>  {
>  	struct mvpp2 *priv = port->priv;
>  	void __iomem *mpcs, *xpcs;
> @@ -2184,7 +2185,7 @@ static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port)
>  	mpcs = priv->iface_base + MVPP22_MPCS_BASE(port->gop_id);
>  	xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
>  
> -	switch (port->phy_interface) {
> +	switch (interface) {
>  	case PHY_INTERFACE_MODE_10GBASER:
>  		val = readl(mpcs + MVPP22_MPCS_CLK_RESET);
>  		val |= MAC_CLK_RESET_MAC | MAC_CLK_RESET_SD_RX |
> @@ -4529,7 +4530,8 @@ static int mvpp2_poll(struct napi_struct *napi, int budget)
>  	return rx_done;
>  }
>  
> -static void mvpp22_mode_reconfigure(struct mvpp2_port *port)
> +static void mvpp22_mode_reconfigure(struct mvpp2_port *port,
> +				    phy_interface_t interface)
>  {
>  	u32 ctrl3;
>  
> @@ -4540,18 +4542,18 @@ static void mvpp22_mode_reconfigure(struct mvpp2_port *port)
>  	mvpp22_pcs_reset_assert(port);
>  
>  	/* comphy reconfiguration */
> -	mvpp22_comphy_init(port);
> +	mvpp22_comphy_init(port, interface);
>  
>  	/* gop reconfiguration */
> -	mvpp22_gop_init(port);
> +	mvpp22_gop_init(port, interface);
>  
> -	mvpp22_pcs_reset_deassert(port);
> +	mvpp22_pcs_reset_deassert(port, interface);
>  
>  	if (mvpp2_port_supports_xlg(port)) {
>  		ctrl3 = readl(port->base + MVPP22_XLG_CTRL3_REG);
>  		ctrl3 &= ~MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
>  
> -		if (mvpp2_is_xlg(port->phy_interface))
> +		if (mvpp2_is_xlg(interface))
>  			ctrl3 |= MVPP22_XLG_CTRL3_MACMODESELECT_10G;
>  		else
>  			ctrl3 |= MVPP22_XLG_CTRL3_MACMODESELECT_GMAC;
> @@ -4559,7 +4561,7 @@ static void mvpp22_mode_reconfigure(struct mvpp2_port *port)
>  		writel(ctrl3, port->base + MVPP22_XLG_CTRL3_REG);
>  	}
>  
> -	if (mvpp2_port_supports_xlg(port) && mvpp2_is_xlg(port->phy_interface))
> +	if (mvpp2_port_supports_xlg(port) && mvpp2_is_xlg(interface))
>  		mvpp2_xlg_max_rx_size_set(port);
>  	else
>  		mvpp2_gmac_max_rx_size_set(port);
> @@ -4579,7 +4581,7 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
>  	mvpp2_interrupts_enable(port);
>  
>  	if (port->priv->hw_version >= MVPP22)
> -		mvpp22_mode_reconfigure(port);
> +		mvpp22_mode_reconfigure(port, port->phy_interface);
>  
>  	if (port->phylink) {
>  		phylink_start(port->phylink);
> @@ -6444,6 +6446,9 @@ static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
>  			mvpp22_gop_mask_irq(port);
>  
>  			phy_power_off(port->comphy);
> +
> +			/* Reconfigure the serdes lanes */
> +			mvpp22_mode_reconfigure(port, interface);
>  		}
>  	}
>  
> @@ -6498,9 +6503,6 @@ static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
>  	    port->phy_interface != interface) {
>  		port->phy_interface = interface;
>  
> -		/* Reconfigure the serdes lanes */
> -		mvpp22_mode_reconfigure(port);
> -
>  		/* Unmask interrupts */
>  		mvpp22_gop_unmask_irq(port);
>  	}
> @@ -6961,7 +6963,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  	 * driver does this, we can remove this code.
>  	 */
>  	if (port->comphy) {
> -		err = mvpp22_comphy_init(port);
> +		err = mvpp22_comphy_init(port, port->phy_interface);
>  		if (err == 0)
>  			phy_power_off(port->comphy);
>  	}
> -- 
> 2.32.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
