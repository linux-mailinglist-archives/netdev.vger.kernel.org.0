Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3821F4C4
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgGNOkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:40:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgGNOkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvM6J-00544K-Kt; Tue, 14 Jul 2020 16:40:07 +0200
Date:   Tue, 14 Jul 2020 16:40:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/2] net: mdiobus: add support to access PHY
 registers via debugfs
Message-ID: <20200714144007.GN1078057@lunn.ch>
References: <20200714142213.21365-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714142213.21365-1-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 04:22:12PM +0200, Marek Behún wrote:
> This adds config option CONFIG_MDIO_BUS_DEBUGFS which, when enabled,
> adds support to communicate with the devices connected to the MDIO
> via debugfs.
> 
> For every MDIO bus this creates directory
>   /sys/kernel/debug/mdio_bus/MDIO_BUS_NAME
> with files "addr", "reg" and "val".
> User can write device address to the "addr" file and register number to
> the "reg" file, and then can read the value of the register from the
> "val" file, or can write new value by writing to the "val" file.
> 
> This is useful when debugging various PHYs or switches.

Hi Marek

Please work with Tobias Waldekranz <tobias@waldekranz.com>.

I'm not particularly keen on allowing write access to such registers,
but it seems like there is demand. But we don't want two ways to do
this.

>  static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
>  {
> @@ -576,6 +577,12 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  		}
>  	}
>  
> +	err = mdiobus_register_debugfs(bus);
> +	if (err) {
> +		dev_err(&bus->dev, "mii_bus %s couldn't create debugfs entries\n", bus->id);
> +		goto error;
> +	}

FYI: You should never error out for debugfs. You should not even check
the return values from debugfs calls.

    Andrew
