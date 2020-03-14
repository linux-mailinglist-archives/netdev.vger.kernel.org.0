Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC5B18580B
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgCOByK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCOByJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bU757VJA/AVqoYCZxjuzMs2EZuxluXIv7cRa1hDGbgw=; b=OZvvxQdfUqWnI6Kt+XmpDdPiPR
        EWV2Myn9U9oNjAiF5EKjeYFToIXVOqqmnA9S0bqHScC63WNapRmSV9CRg5ZcUmmeTcjQTphf2T3P3
        INgbLTMSI/P6HSAp4RcUk7cKcbZYXcifSbqVpt5qjlaii9QMQPTNWGdISpL6JmkjRDBw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDEme-0002Yq-82; Sat, 14 Mar 2020 22:57:28 +0100
Date:   Sat, 14 Mar 2020 22:57:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: mdiobus: add APIs for modifying a MDIO
 device register
Message-ID: <20200314215728.GG8622@lunn.ch>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <E1jD44i-0006Mj-9J@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD44i-0006Mj-9J@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:31:24AM +0000, Russell King wrote:
> Add APIs for modifying a MDIO device register, similar to the existing
> phy_modify() group of functions, but at mdiobus level instead.  Adapt
> __phy_modify_changed() to use the new mdiobus level helper.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/mdio_bus.c | 55 ++++++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy-core.c | 31 ---------------------
>  include/linux/mdio.h       |  4 +++
>  include/linux/phy.h        | 19 +++++++++++++
>  4 files changed, 78 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 3ab9ca7614d1..b33d1e793686 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -824,6 +824,38 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
>  }
>  EXPORT_SYMBOL(__mdiobus_write);
>  
> +/**
> + * __mdiobus_modify_changed - Unlocked version of the mdiobus_modify function
> + * @bus: the mii_bus struct
> + * @addr: the phy address
> + * @regnum: register number to modify
> + * @mask: bit mask of bits to clear
> + * @set: bit mask of bits to set
> + *
> + * Read, modify, and if any change, write the register value back to the
> + * device. Any error returns a negative number.
> + *
> + * NOTE: MUST NOT be called from interrupt context.
> + */
> +int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
> +			     u16 mask, u16 set)
> +{
> +	int new, ret;
> +
> +	ret = __mdiobus_read(bus, addr, regnum);
> +	if (ret < 0)
> +		return ret;
> +
> +	new = (ret & ~mask) | set;
> +	if (new == ret)
> +		return 0;
> +
> +	ret = __mdiobus_write(bus, addr, regnum, new);
> +
> +	return ret < 0 ? ret : 1;
> +}
> +EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
> +
>  /**
>   * mdiobus_read_nested - Nested version of the mdiobus_read function
>   * @bus: the mii_bus struct
> @@ -928,6 +960,29 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
>  }
>  EXPORT_SYMBOL(mdiobus_write);
>  
> +/**
> + * mdiobus_modify - Convenience function for modifying a given mdio device
> + *	register
> + * @bus: the mii_bus struct
> + * @addr: the phy address
> + * @regnum: register number to write
> + * @mask: bit mask of bits to clear
> + * @set: bit mask of bits to set
> + */
> +int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
> +{
> +	int err;
> +
> +	BUG_ON(in_interrupt());

Hi Russell

There seems to be growing push back on using BUG_ON and its
variants. If should only be used if the system is so badly messed up,
going further would only cause more damage. What really happens here
if it is called in interrupt context? The mutex lock probably won't
work, and we might corrupt the state of the PCS. That is not the end
of the world. So i would suggest a WARN_ON here.

> +
> +	mutex_lock(&bus->mdio_lock);
> +	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	return err < 0 ? err : 0;
> +}
> +EXPORT_SYMBOL_GPL(mdiobus_modify);
> +

  Andrew
