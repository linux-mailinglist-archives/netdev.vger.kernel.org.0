Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48595165B84
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBTK3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:29:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57952 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgBTK3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:29:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D0QfwFe5VuXoN5X68rznn8NM7G9XUwQSimuTofmWdzU=; b=vSR+XvWkpGnlcBg6aNao4QTKw
        xFC+BcQ2mM96psVEya2zQ23e9cMBU4hfolxoeZjgFxZJiBU/0LEWzzY+LLoIvM3MGK5FYTinJ2CuF
        c9hmOHiEX3xdZ7yyhlDqYylpuFaaFePYU+jsLt9M3H2LSmV+1d0SwPa6jzeJAeOxE/DYUtUPz/dl6
        A2GkfelkbNH7rt+/rbgtmhj26ayw/csp8lGsMqIDZIPEudO0UtSAsOoFhMMb8T7cii7mLo/BwDzOh
        kvlMZ+w9xDKZzDsB7h3tHUtJDK1TrbLEGL3EYf6M77VCuTwcQM77sXK0gU3QZ5/hdgXx72iJBoOYt
        9TKxJetSw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50344)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4j5G-0002gg-Iy; Thu, 20 Feb 2020 10:29:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4j5D-0002Li-75; Thu, 20 Feb 2020 10:29:27 +0000
Date:   Thu, 20 Feb 2020 10:29:27 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [CFT 4/8] net: axienet: use resolved link config in mac_link_up()
Message-ID: <20200220102927.GX25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k7t-00072J-RS@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j3k7t-00072J-RS@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

Are you able to give this (along with patch 1) some testing please?
The series can be grabbed from:

  https://patchwork.ozlabs.org/series/159037/mbox/

Strangely, google doesn't find it in the lore.kernel.org archives,
but does in spinics.net archives and patchwork...

On Mon, Feb 17, 2020 at 05:24:09PM +0000, Russell King wrote:
> Convert the Xilinx AXI ethernet driver to use the finalised link
> parameters in mac_link_up() rather than the parameters in mac_config().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 38 +++++++++----------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 197740781157..c2f4c5ca2e80 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1440,6 +1440,22 @@ static void axienet_mac_an_restart(struct phylink_config *config)
>  
>  static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
>  			       const struct phylink_link_state *state)
> +{
> +	/* nothing meaningful to do */
> +}
> +
> +static void axienet_mac_link_down(struct phylink_config *config,
> +				  unsigned int mode,
> +				  phy_interface_t interface)
> +{
> +	/* nothing meaningful to do */
> +}
> +
> +static void axienet_mac_link_up(struct phylink_config *config,
> +				struct phy_device *phy,
> +				unsigned int mode, phy_interface_t interface,
> +				int speed, int duplex,
> +				bool tx_pause, bool rx_pause)
>  {
>  	struct net_device *ndev = to_net_dev(config->dev);
>  	struct axienet_local *lp = netdev_priv(ndev);
> @@ -1448,7 +1464,7 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
>  	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
>  	emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
>  
> -	switch (state->speed) {
> +	switch (speed) {
>  	case SPEED_1000:
>  		emmc_reg |= XAE_EMMC_LINKSPD_1000;
>  		break;
> @@ -1467,33 +1483,17 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
>  	axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
>  
>  	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
> -	if (state->pause & MLO_PAUSE_TX)
> +	if (tx_pause)
>  		fcc_reg |= XAE_FCC_FCTX_MASK;
>  	else
>  		fcc_reg &= ~XAE_FCC_FCTX_MASK;
> -	if (state->pause & MLO_PAUSE_RX)
> +	if (rx_pause)
>  		fcc_reg |= XAE_FCC_FCRX_MASK;
>  	else
>  		fcc_reg &= ~XAE_FCC_FCRX_MASK;
>  	axienet_iow(lp, XAE_FCC_OFFSET, fcc_reg);
>  }
>  
> -static void axienet_mac_link_down(struct phylink_config *config,
> -				  unsigned int mode,
> -				  phy_interface_t interface)
> -{
> -	/* nothing meaningful to do */
> -}
> -
> -static void axienet_mac_link_up(struct phylink_config *config,
> -				struct phy_device *phy,
> -				unsigned int mode, phy_interface_t interface,
> -				int speed, int duplex,
> -				bool tx_pause, bool rx_pause)
> -{
> -	/* nothing meaningful to do */
> -}
> -
>  static const struct phylink_mac_ops axienet_phylink_ops = {
>  	.validate = axienet_validate,
>  	.mac_pcs_get_state = axienet_mac_pcs_get_state,
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
