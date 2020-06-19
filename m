Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8682009D8
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732284AbgFSNVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:21:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgFSNVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 09:21:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmGx3-001HC3-RB; Fri, 19 Jun 2020 15:21:01 +0200
Date:   Fri, 19 Jun 2020 15:21:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net 1/2] of: of_mdio: Correct loop scanning logic
Message-ID: <20200619132101.GA304147@lunn.ch>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
 <20200619044759.11387-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619044759.11387-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:47:58PM -0700, Florian Fainelli wrote:
> Commit 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
> introduced a break of the loop on the premise that a successful
> registration should exit the loop. The premise is correct but not to
> code, because rc && rc != -ENODEV is just a special error condition,
> that means we would exit the loop even with rc == -ENODEV which is
> absolutely not correct since this is the error code to indicate to the
> MDIO bus layer that scanning should continue.
> 
> Fix this by explicitly checking for rc = 0 as the only valid condition
> to break out of the loop.
> 
> Fixes: 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/of/of_mdio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index a04afe79529c..7496dc64d6b5 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -315,9 +315,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  
>  			if (of_mdiobus_child_is_phy(child)) {
>  				rc = of_mdiobus_register_phy(mdio, child, addr);
> -				if (rc && rc != -ENODEV)
> +				if (!rc)
> +					break;

Maybe add in a comment here about what ENODEV means in this context?
That might avoid it getting broken again in the future.

> +				if (rc != -ENODEV)
>  					goto unregister;
> -				break;
>  			}
>  		}
>  	}
> -- 

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
