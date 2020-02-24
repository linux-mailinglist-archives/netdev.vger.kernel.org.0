Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF6916A612
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgBXMY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:24:29 -0500
Received: from foss.arm.com ([217.140.110.172]:36420 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgBXMY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 07:24:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABD1730E;
        Mon, 24 Feb 2020 04:24:28 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A0E03F534;
        Mon, 24 Feb 2020 04:24:27 -0800 (PST)
Date:   Mon, 24 Feb 2020 12:24:21 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [CFT 4/8] net: axienet: use resolved link config in
 mac_link_up()
Message-ID: <20200224122421.616c8271@donnerap.cambridge.arm.com>
In-Reply-To: <E1j3k7t-00072J-RS@rmk-PC.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
        <E1j3k7t-00072J-RS@rmk-PC.armlinux.org.uk>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 17:24:09 +0000
Russell King <rmk+kernel@armlinux.org.uk> wrote:

Hi Russell,

> Convert the Xilinx AXI ethernet driver to use the finalised link
> parameters in mac_link_up() rather than the parameters in mac_config().

Many thanks for this series, a quite neat solution for the problems I saw!

I picked 1/8 and 4/8 on top of net-next/master as of today: c3e042f54107376 ("igmp: remove unused macro IGMP_Vx_UNSOLICITED_REPORT_INTERVAL") and it worked great on my FPGA board using SGMII (but no in-band negotiation over that link). I had the 64-bit DMA patches on top, but that doesn't affect this series.

Tested-by: Andre Przywara <andre.przywara@arm.com>

Is this heading for 5.7?

Cheers,
Andre.

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

