Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4984369241
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhDWMjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:39:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDWMjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:39:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZv4j-000eNb-E5; Fri, 23 Apr 2021 14:38:25 +0200
Date:   Fri, 23 Apr 2021 14:38:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] drivers: net: mdio: mdio-ip8064: improve busy wait
 delay
Message-ID: <YIK/wUOplWbf4hK0@lunn.ch>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423014741.11858-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 03:47:29AM +0200, Ansuel Smith wrote:
> With the use of the qca8k dsa driver, some problem arised related to
> port status detection. With a load on a specific port (for example a
> simple speed test), the driver starts to bheave in a strange way and
> garbage data is produced. To address this, enlarge the sleep delay and
> address a bug for the reg offset 31 that require additional delay for
> this specific reg.

>  struct ipq8064_mdio {
>  	struct regmap *base; /* NSS_GMAC0_BASE */
> @@ -65,7 +66,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
>  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
>  
>  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> -	usleep_range(8, 10);
> +	usleep_range(10, 13);
>  
>  	err = ipq8064_mdio_wait_busy(priv);
>  	if (err)
> @@ -91,7 +92,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
>  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
>  
>  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> -	usleep_range(8, 10);
> +
> +	/* For the specific reg 31 extra time is needed or the next
> +	 * read will produce grabage data.
> +	 */
> +	if (reg_offset == 31)
> +		usleep_range(30, 43);
> +	else
> +		usleep_range(10, 13);
>  
>  	return ipq8064_mdio_wait_busy(priv);

Is there any documentation as to what register 31 does?

Maybe the real problem is in ipq8064_mdio_wait_busy()? Have you looked
at how long you typically end up waiting? If you know the MDIO bus
speed, you can work out how long a transaction should take. If it is
taking less, something is broken.

Are you sure regmap caching is disabled, so that
ipq8064_mdio_wait_busy() really is reading the register, not some
old cached value?

      Andrew





>  }
> -- 
> 2.30.2
> 
