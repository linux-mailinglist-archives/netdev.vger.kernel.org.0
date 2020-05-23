Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922BE1DF7DC
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgEWO6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 10:58:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbgEWO6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 10:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cy8TMfFe9/igSyNs9fuUQdkDSBXJLsJjI81IzQferQU=; b=Y697UmxTZKun2ELviziRRLaMYS
        KITlJt+XU2EmbbJxMt/OYO3RDfJJD1hqSBYiu54zW1l85wLHEVl02KFJm+uB2p5FutyLpxTIKJJnV
        Kax+mkHflINhIyz1vHlbowmy/eARErNYgVKA2Psq1kqi0+C73V34HXGEc639nU6kRE3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcVbc-0034Qb-VV; Sat, 23 May 2020 16:58:32 +0200
Date:   Sat, 23 May 2020 16:58:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/4] net: dp83869: Add RGMII internal delay
 configuration
Message-ID: <20200523145832.GJ610998@lunn.ch>
References: <20200521174834.3234-1-dmurphy@ti.com>
 <20200521174834.3234-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521174834.3234-5-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 12:48:34PM -0500, Dan Murphy wrote:
> Add RGMII internal delay configuration for Rx and Tx.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83869.c | 101 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index cfb22a21a2e6..40c34fefffe4 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -99,6 +99,14 @@
>  #define DP83869_OP_MODE_MII			BIT(5)
>  #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
>  
> +/* RGMIIDCTL bits */
> +#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
> +#define DP83869_RGMII_CLK_DELAY_INV		0
> +
> +static int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500, 1750,
> +				       2000, 2250, 2500, 2750, 3000, 3250,
> +				       3500, 3750, 4000};
> +
>  enum {
>  	DP83869_PORT_MIRRORING_KEEP,
>  	DP83869_PORT_MIRRORING_EN,
> @@ -108,6 +116,8 @@ enum {
>  struct dp83869_private {
>  	int tx_fifo_depth;
>  	int rx_fifo_depth;
> +	u32 rx_id_delay;
> +	u32 tx_id_delay;
>  	int io_impedance;
>  	int port_mirroring;
>  	bool rxctrl_strap_quirk;
> @@ -182,6 +192,7 @@ static int dp83869_of_init(struct phy_device *phydev)
>  	struct dp83869_private *dp83869 = phydev->priv;
>  	struct device *dev = &phydev->mdio.dev;
>  	struct device_node *of_node = dev->of_node;
> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>  	int ret;
>  
>  	if (!of_node)
> @@ -232,6 +243,26 @@ static int dp83869_of_init(struct phy_device *phydev)
>  				 &dp83869->tx_fifo_depth))
>  		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>  
> +	dp83869->rx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
> +	ret = of_property_read_u32(of_node, "rx-internal-delay",
> +				   &dp83869->rx_id_delay);
> +	if (!ret && dp83869->rx_id_delay > dp83869_internal_delay[delay_size]) {
> +		phydev_err(phydev,
> +			   "rx-internal-delay value of %u out of range\n",
> +			   dp83869->rx_id_delay);
> +		return -EINVAL;
> +	}

Hi Dan

Seems like the helper should be doing the range check, and printing
the message. It should be common to all PHY drivers using delays
looked up in a list.

I also wonder about putting the of_property_read_u32 inside a
helper. Something like

of_get_phy_rgmii_delays(struct device_node *np, phy_interface_t interface,
			u32 *rx_delay, u32 *tx_delay)

And maybe a third helper which combines phy_get_delay_index() and
of_get_phy_rgmii_delays().

> +static int dp83869_verify_rgmii_cfg(struct phy_device *phydev)
> +{
> +	struct dp83869_private *dp83869 = phydev->priv;
> +
> +	/* RX delay *must* be specified if internal delay of RX is used. */

No. As i said last time, default to 2ns, if there is no specific delay
value in DT.

    Andrew
