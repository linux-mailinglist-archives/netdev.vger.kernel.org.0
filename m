Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68E23B21BE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFWUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:25:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWUZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LTvMa7TrIXjadvzrpJ2IJPR9/sgB6OoGVq2NGlQ8XYU=; b=JOjeJdgYXJTAJOApMEEob0rYCQ
        Tn9iALGfBlQLjHJaBuo2u1f0LWT4BmRqsBeB3y4ptFF5rmnsqv7bWXAKErTUk1Vf8FK1WVkfu/o8o
        Df9l7kDOB/akb7NwJlBsGsXxZMeT4tnFUdnJDC3MuWi5XUxPt3yUGNQfg3r/k7a3ZkBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw9OW-00At84-FS; Wed, 23 Jun 2021 22:22:44 +0200
Date:   Wed, 23 Jun 2021 22:22:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v3 2/6] net: mdiobus: Introduce
 fwnode_mdbiobus_register()
Message-ID: <YNOYFFgB5UNdSYeI@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621173028.3541424-3-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 07:30:24PM +0200, Marcin Wojtas wrote:
> This patch introduces a new helper function that
> wraps acpi_/of_ mdiobus_register() and allows its
> usage via common fwnode_ interface.
> 
> Fall back to raw mdiobus_register() in case CONFIG_FWNODE_MDIO
> is not enabled, in order to satisfy compatibility
> in all future user drivers.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  include/linux/fwnode_mdio.h    | 12 +++++++++++
>  drivers/net/mdio/fwnode_mdio.c | 22 ++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
> index faf603c48c86..13d4ae8fee0a 100644
> --- a/include/linux/fwnode_mdio.h
> +++ b/include/linux/fwnode_mdio.h
> @@ -16,6 +16,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  				struct fwnode_handle *child, u32 addr);
>  
> +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode);
>  #else /* CONFIG_FWNODE_MDIO */
>  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  				       struct phy_device *phy,
> @@ -30,6 +31,17 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int fwnode_mdiobus_register(struct mii_bus *bus,
> +					  struct fwnode_handle *fwnode)
> +{
> +	/*
> +	 * Fall back to mdiobus_register() function to register a bus.
> +	 * This way, we don't have to keep compat bits around in drivers.
> +	 */
> +
> +	return mdiobus_register(mdio);
> +}
>  #endif

I looked at this some more, and in the end i decided it was O.K.

> +/**
> + * fwnode_mdiobus_register - bring up all the PHYs on a given MDIO bus and
> + *	attach them to it.
> + * @bus: Target MDIO bus.
> + * @fwnode: Pointer to fwnode of the MDIO controller.
> + *
> + * Return values are determined accordingly to acpi_/of_ mdiobus_register()
> + * operation.
> + */
> +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode)
> +{
> +	if (is_acpi_node(fwnode))
> +		return acpi_mdiobus_register(bus, fwnode);
> +	else if (is_of_node(fwnode))
> +		return of_mdiobus_register(bus, to_of_node(fwnode));
> +	else
> +		return -EINVAL;

I wounder if here you should call mdiobus_register(mdio), rather than
-EINVAL?

I don't have a strong opinion.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
