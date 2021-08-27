Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202BF3F91ED
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243894AbhH0BdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhH0BdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F07C060F58;
        Fri, 27 Aug 2021 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630027953;
        bh=nUVuJH9V98Qn3NRiNZgntv8w8SLo+bDvXjHTg1KkhC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P1btc8XdtqQE06oAZKh36kMGfU2C7kghc3V0V61Sv759Y6lBk3L5CmP1cFq8cQVFG
         mepc8VLc7U3GvqomICtYjaBxw1oLPzoyiW8Cd+cFs6pXoJ2Bo7fELPTRyPVLkKc/2R
         mf485l1PYMUwbvV+eVIHyMF9oNX1Lixdh2yoRp7hPFsFmQLjVmy6X9xa4X+/CTHI1a
         CcfNCOH1Th7lzFyBrl9oQpB0RxILPNVQyJTDJp2GwaFIzLzmwevL82oDCJ56PjvhcE
         rtYVhSnKHd3mjARWlPd8qs4ZNjSoJhtmub4Py1VEoZUGRIs3BrUWXKqLOhDpjtn9fb
         eBmpC7jC+81wQ==
Date:   Fri, 27 Aug 2021 03:32:29 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for
 anyone after us in the driver probe list
Message-ID: <20210827033229.1bfcc08b@thinkpad>
In-Reply-To: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
References: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 03:15:13 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Enabling interrupts via device tree for the internal PHYs on the
> mv88e6390 DSA switch does not work. The driver insists to use poll mode.
> 
> Stage one debugging shows that the fwnode_mdiobus_phy_device_register
> function calls fwnode_irq_get properly, and phy->irq is set to a valid
> interrupt line initially.
> 
> But it is then cleared.
> 
> Stage two debugging shows that it is cleared here:
> 
> phy_probe:
> 
> 	/* Disable the interrupt if the PHY doesn't support it
> 	 * but the interrupt is still a valid one
> 	 */
> 	if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
> 		phydev->irq = PHY_POLL;
> 
> Okay, so does the "Marvell 88E6390 Family" PHY driver not have the
> .config_intr and .handle_interrupt function pointers? Yes it does.
> 
> Stage three debugging shows that the PHY device does not attempt a probe
> against the "Marvell 88E6390 Family" driver, but against the "mv88x3310"
> driver.
> 
> Okay, so why does the "mv88x3310" driver match on a mv8836390 internal PHY?
> The PHY IDs (MARVELL_PHY_ID_88E6390_FAMILY vs MARVELL_PHY_ID_88X3310)
> are way different.
> 
> Stage four debugging has us looking through:
> 
> phy_device_register
> -> device_add
>    -> bus_probe_device
>       -> device_initial_probe
>          -> __device_attach
>             -> bus_for_each_drv
>                -> driver_match_device
>                   -> drv->bus->match
>                      -> phy_bus_match  
> 
> Okay, so as we said, the MII_PHYSID1 of mv88e6390 does not match the
> mv88x3310 driver's PHY mask & ID, so why would phy_bus_match return...
> 
> ..Ahh, phy_bus_match calls a shortcircuit method, phydrv->match_phy_device,
> and does not even bother to compare the PHY ID if that is implemented.
> 
> So of course, we go inside the marvell10g.c driver and sure enough, it
> implements .match_phy_device and does not bother to check the PHY ID.
> 
> What's interesting though is that at the end of the device_add() from
> phy_device_register(), the driver for the internal PHYs _is_ the proper
> "Marvell 88E6390 Family". This is because "mv88x3310" ends up failing to
> probe after all, and __device_attach_driver(), to quote:
> 
> 	/*
> 	 * Ignore errors returned by ->probe so that the next driver can try
> 	 * its luck.
> 	 */

:))) /o\ 

> The next (and only other) driver that matches is the 6390 driver. For
> this one, phy_probe doesn't fail, and everything expects to work as
> normal, EXCEPT phydev->irq has already been cleared by the previous
> unsuccessful probe of a driver which did not implement PHY interrupts,
> and therefore cleared that IRQ.
> 
> Okay, so it is not just Marvell 6390 that has PHY interrupts broken.
> Stuff like Atheros, Aquantia, Broadcom, Qualcomm work because they are
> lexicographically before Marvell, and stuff like NXP, Realtek, Vitesse
> are broken.
> 
> This goes to show how fragile it is to reset phydev->irq = PHY_POLL from
> the actual beginning of phy_probe itself. That seems like an actual bug
> of its own too, since phy_probe has side effects which are not restored
> on probe failure, but the line of thought probably was, the same driver
> will attempt probe again, so it doesn't matter. Well, looks like it does.
> 
> Maybe it would make more sense to move the phydev->irq clearing after
> the actual device_add() in phy_device_register() completes, and the
> bound driver is the actual final one.
> 
> (also, a bit frightening that drivers are permitted to bypass the MDIO
> bus matching in such a trivial way and perform PHY reads and writes from
> the .match_phy_device method, on devices that do not even belong to
> them. In the general case it might not be guaranteed that the MDIO
> accesses one driver needs to make to figure out whether to match on a
> device is safe for all other PHY devices)
> 
> Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/marvell10g.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 53a433442803..7bf35b24fd14 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -987,11 +987,17 @@ static int mv3310_get_number_of_ports(struct phy_device *phydev)
>  
>  static int mv3310_match_phy_device(struct phy_device *phydev)
>  {
> +	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
> +		return 0;
> +
>  	return mv3310_get_number_of_ports(phydev) == 1;
>  }
>  
>  static int mv3340_match_phy_device(struct phy_device *phydev)
>  {
> +	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
> +		return 0;
> +
>  	return mv3310_get_number_of_ports(phydev) == 4;
>  }
>  

I fear these checks won't work, since this is a C45 PHY.

You need to check phydev->c45_ids.device_ids[1], instead of
phydev->phy_id.

And even them I am not entirely sure. I will try to test it tomorrow.

Marek
