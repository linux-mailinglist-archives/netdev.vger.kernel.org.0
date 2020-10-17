Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51583291459
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438951AbgJQUjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:39:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438904AbgJQUjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 16:39:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTszK-002BsT-N6; Sat, 17 Oct 2020 22:39:38 +0200
Date:   Sat, 17 Oct 2020 22:39:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v1 2/2] net: ftgmac100: add handling of mdio/phy nodes
 for ast2400/2500
Message-ID: <20201017203938.GR456889@lunn.ch>
References: <20201015124917.8168-1-i.mikhaylov@yadro.com>
 <20201015124917.8168-3-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015124917.8168-3-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	err = mdiobus_register(priv->mii_bus);
> +	mdio_np = of_get_child_by_name(np, "mdio");
> +	if (mdio_np)
> +		err = of_mdiobus_register(priv->mii_bus, mdio_np);
> +	else
> +		err = mdiobus_register(priv->mii_bus);

of_mdiobus_register() will do the right thing if passed a NULL pointer
for mdio_np.

> +
>  	if (err) {
>  		dev_err(priv->dev, "Cannot register MDIO bus!\n");
>  		goto err_register_mdiobus;
>  	}
>  
> +	if (mdio_np)
> +		of_node_put(mdio_np);

of_node_put() is also happy with a NULL pointer.

> +
>  	return 0;
>  
>  err_register_mdiobus:
> @@ -1830,10 +1839,23 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  	} else if (np && of_get_property(np, "phy-handle", NULL)) {
>  		struct phy_device *phy;
>  
> +		/* Support "mdio"/"phy" child nodes for ast2400/2500 with
> +		 * an embedded MDIO controller. Automatically scan the DTS for
> +		 * available PHYs and register them.
> +		 */
> +		if (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
> +		    of_device_is_compatible(np, "aspeed,ast2500-mac")) {
> +			err = ftgmac100_setup_mdio(netdev);
> +			if (err)
> +				goto err_setup_mdio;
> +		}
> +
>  		phy = of_phy_get_and_connect(priv->netdev, np,
>  					     &ftgmac100_adjust_link);
>  		if (!phy) {
>  			dev_err(&pdev->dev, "Failed to connect to phy\n");
> +			if (priv->mii_bus)
> +				mdiobus_unregister(priv->mii_bus);
>  			goto err_setup_mdio;

It would be nice if the tear down was symmetric to the setup. Add an
ftgmac100_remove_mdio(), and call it on the same condition as
ftgmac100_setup_mdio().

	 Andrew
