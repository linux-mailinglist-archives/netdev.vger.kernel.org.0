Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AA93AA461
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhFPTfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:35:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhFPTfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B6ZGTUD6NsGZsGjjROclmcpOgiH6NhjYtXWhNJYTkbE=; b=QPZQQr2XubOmMa8kdNrJ2g03Fk
        c1tpYiyI3kJqik4ho4L0iWog+kjlzAZCsGQfVRFocACDbUNdsu59uFLXGOBoGlDO5D75974f1bTcK
        E9ETSVvQyRDG1uux/RhrkMXhxC6m13wpBcUsyjdzGWfEg4h+74oAULJ/z+ges+l6V9dA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbHm-009ljo-67; Wed, 16 Jun 2021 21:33:14 +0200
Date:   Wed, 16 Jun 2021 21:33:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v2 2/7] net: mdiobus: Introduce
 fwnode_mdbiobus_register()
Message-ID: <YMpR+lJqcgQU2DMO@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616190759.2832033-3-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:07:54PM +0200, Marcin Wojtas wrote:
> This patch introduces a new helper function that
> wraps acpi_/of_ mdiobus_register() and allows its
> usage via common fwnode_ interface.
> 
> Fall back to raw mdiobus_register() in case CONFIG_FWNODE_MDIO
> is not enabled, in order to satisfy compatibility
> in all future user drivers.

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

I'm not sure this fallback is correct.

Any driver which decides to use fwmode is going to select it. If it is
not selected, you want a link time error, or a compiler time error to
tell you, you are missing FWNODE_MDIO. Calling mdiobus_register() is
unlikely to work, or the driver would of done that directly.

	 Andrew
