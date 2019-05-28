Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F059B2C788
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfE1NMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:12:34 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38420 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfE1NMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bfJQYi0u+qdY0TmIfJTRVBY7tRlpbouGx/Q+bV59V+c=; b=sBXWcRgY3JXAL23IuTKMDv6Rg
        waQmUbxfZW4sN8/X5X3cVm1ILvJkndgxImKaXm8dGryAZw/S5cORtB7ziAB30qL2iXSnBzUc8a8Ii
        kMKUmFXsagLLEy6I8jDrXKVIxxej02y1E+/pcw93atu0/2NZgOQJrLekaKle0K8IfAZ1jUNIxJ7T+
        T85dY0qC8PPbCa0HXzDoZloOC+KbFXp3ByHLmL8jXpjynxhFvjU3+fszlTg4SzM9+ilb5VsuVsIob
        n5H1S7Y7f+HuIZK/1r39iGhY5unJl6tNVNkqnjlCAd4pqWUUoYka15B8BHXl0eTaTY7+MMJSu8gtm
        RgCaDPk1A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56034)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVbu1-0005wu-Cj; Tue, 28 May 2019 14:12:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVbu0-0003e8-0P; Tue, 28 May 2019 14:12:28 +0100
Date:   Tue, 28 May 2019 14:12:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
Message-ID: <20190528131227.fq4kq255dr53ab4b@shell.armlinux.org.uk>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:28:48PM +0200, Heiner Kallweit wrote:
> The phylib interrupt handler handles link change events only currently.
> However PHY drivers may want to use other interrupt sources too,
> e.g. to report temperature monitoring events. Therefore add a callback
> to struct phy_driver allowing PHY drivers to implement a custom
> interrupt handler.

Looks fine to me.

> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/phy/phy.c | 9 +++++++--
>  include/linux/phy.h   | 3 +++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 20955836c..8030d0a97 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
>  		return IRQ_NONE;
>  
> -	/* reschedule state queue work to run as soon as possible */
> -	phy_trigger_machine(phydev);
> +	if (phydev->drv->handle_interrupt) {
> +		if (phydev->drv->handle_interrupt(phydev))
> +			goto phy_err;
> +	} else {
> +		/* reschedule state queue work to run as soon as possible */
> +		phy_trigger_machine(phydev);
> +	}
>  
>  	if (phy_clear_interrupt(phydev))
>  		goto phy_err;
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index b133d59f3..f90158c67 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -536,6 +536,9 @@ struct phy_driver {
>  	 */
>  	int (*did_interrupt)(struct phy_device *phydev);
>  
> +	/* Override default interrupt handling */
> +	int (*handle_interrupt)(struct phy_device *phydev);
> +
>  	/* Clears up any memory if needed */
>  	void (*remove)(struct phy_device *phydev);
>  
> -- 
> 2.21.0
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
