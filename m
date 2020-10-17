Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B2F291464
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438977AbgJQUtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:49:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438738AbgJQUtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 16:49:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTt8N-002Bx8-On; Sat, 17 Oct 2020 22:48:59 +0200
Date:   Sat, 17 Oct 2020 22:48:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] staging: octeon: repair "fixed-link" support
Message-ID: <20201017204859.GT456889@lunn.ch>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/staging/octeon/ethernet.c
> +++ b/drivers/staging/octeon/ethernet.c
> @@ -13,6 +13,7 @@
>  #include <linux/phy.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
> +#include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/if_ether.h>
>  #include <linux/if_vlan.h>
> @@ -892,6 +893,14 @@ static int cvm_oct_probe(struct platform_device *pdev)
>  				break;
>  			}
>  
> +			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
> +				if (of_phy_register_fixed_link(priv->of_node)) {
> +					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
> +						   interface, priv->port);
> +					dev->netdev_ops = NULL;
> +				}
> +			}
> +
>  			if (!dev->netdev_ops) {
>  				free_netdev(dev);
>  			} else if (register_netdev(dev) < 0) {
> -- 
> 2.10.2

I would also expect a call to of_phy_deregister_fixed_link() somewhere
in the driver.

   Andrew
