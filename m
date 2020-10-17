Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CF6291450
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438737AbgJQUck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:32:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438258AbgJQUck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 16:32:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTssM-002BpP-Cq; Sat, 17 Oct 2020 22:32:26 +0200
Date:   Sat, 17 Oct 2020 22:32:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v1 1/2] net: ftgmac100: move phy connect out from
 ftgmac100_setup_mdio
Message-ID: <20201017203226.GQ456889@lunn.ch>
References: <20201015124917.8168-1-i.mikhaylov@yadro.com>
 <20201015124917.8168-2-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015124917.8168-2-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 03:49:16PM +0300, Ivan Mikhaylov wrote:
> Split MDIO registration and PHY connect into ftgmac100_setup_mdio and
> ftgmac100_mii_probe.
> 
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 92 ++++++++++++------------
>  1 file changed, 47 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 87236206366f..6997e121824b 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1044,11 +1044,47 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>  	schedule_work(&priv->reset_task);
>  }
>  
> -static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
> +static int ftgmac100_mii_probe(struct net_device *netdev)
>  {
> -	struct net_device *netdev = priv->netdev;
> +	struct ftgmac100 *priv = netdev_priv(netdev);
> +	struct platform_device *pdev = to_platform_device(priv->dev);
> +	struct device_node *np = pdev->dev.of_node;
> +	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
>  	struct phy_device *phydev;

Reverse Christmas tree.

>  
> +	/* Get PHY mode from device-tree */
> +	if (np) {
> +		/* Default to RGMII. It's a gigabit part after all */
> +		phy_intf = of_get_phy_mode(np, &phy_intf);
> +		if (phy_intf < 0)
> +			phy_intf = PHY_INTERFACE_MODE_RGMII;

I know you are just moving code around, but it is better to do:

> +		err = of_get_phy_mode(np, &phy_intf);
> +		if (err)
> +			phy_intf = PHY_INTERFACE_MODE_RGMII;

With the code you have, you are probably going to get an email about
assigning an int to an unsigned int type from Colin..

> @@ -1860,6 +1854,14 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  		err = ftgmac100_setup_mdio(netdev);
>  		if (err)
>  			goto err_setup_mdio;
> +
> +		err = ftgmac100_mii_probe(netdev);
> +		if (err) {
> +			dev_err(priv->dev, "MII probe failed!\n");
> +			mdiobus_unregister(priv->mii_bus);
> +			goto err_setup_mdio;
> +		}

It is more uniform to add a new label and add the
mdiobus_unregister(priv->mii_bus) there. All the other error handling
works like that.

      Andrew
