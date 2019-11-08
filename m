Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E03F52CD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfKHRqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:46:02 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44870 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKHRqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+ssHqRonHsnYjT+bWfLtaaScXceMrjaos1JpVeNXeuE=; b=vMa9TNR21lxUpsfS7KTDT3yuH
        hkgZ4VER6NUWQF8rNqsDI3MZMTcXeo8ULw5kl74mpi+kFZxYyLAfma8VKoqI5ZySRHPFDWN6p0lSk
        VpJVhJbVEJD2oNyAUYC/EkMdZzl0VMeuRdv/FsgWKhbcTO0W5KMMcUxzQh4w2IkuEECH6MdPANoWs
        Bnd+sn5At6FNiNaBYEL25Ewq8igFUqodzieWeVdby6T9S1vtBhP4v+Xuiq4n9SihJC0L/fPq5psoj
        3AbxrXLg1ERxXuL92SAuenGJjcix7bIXktEj3mWKpwbM0m50V9GXNsnu0fCTpDa5yM1fysq+YVr3A
        qBiXm5QnA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:32832)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iT8KY-0003wb-M4; Fri, 08 Nov 2019 17:45:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iT8KV-0006AB-5h; Fri, 08 Nov 2019 17:45:51 +0000
Date:   Fri, 8 Nov 2019 17:45:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: rework upstream interface
Message-ID: <20191108174551.GZ25745@shell.armlinux.org.uk>
References: <E1iT8EL-0008QJ-Fg@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iT8EL-0008QJ-Fg@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, this should've been for net-next.

On Fri, Nov 08, 2019 at 05:39:29PM +0000, Russell King wrote:
> The current upstream interface is an all-or-nothing, which is
> sub-optimal for future changes, as it doesn't allow the upstream driver
> to prepare for the SFP module becoming available, as it is at boot.
> 
> Switch to a find-sfp-bus, add-upstream, del-upstream, put-sfp-bus
> interface structure instead, which allows the upstream driver to
> prepare for a module being available as soon as add-upstream is called.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 10 +++--
>  drivers/net/phy/sfp-bus.c | 92 +++++++++++++++++++++++++++------------
>  include/linux/sfp.h       | 25 +++++++----
>  3 files changed, 88 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 4c5e8b4f8d80..2b70b4d50573 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -551,7 +551,7 @@ static int phylink_register_sfp(struct phylink *pl,
>  	struct sfp_bus *bus;
>  	int ret;
>  
> -	bus = sfp_register_upstream_node(fwnode, pl, &sfp_phylink_ops);
> +	bus = sfp_bus_find_fwnode(fwnode);
>  	if (IS_ERR(bus)) {
>  		ret = PTR_ERR(bus);
>  		phylink_err(pl, "unable to attach SFP bus: %d\n", ret);
> @@ -560,7 +560,10 @@ static int phylink_register_sfp(struct phylink *pl,
>  
>  	pl->sfp_bus = bus;
>  
> -	return 0;
> +	ret = sfp_bus_add_upstream(bus, pl, &sfp_phylink_ops);
> +	sfp_bus_put(bus);
> +
> +	return ret;
>  }
>  
>  /**
> @@ -654,8 +657,7 @@ EXPORT_SYMBOL_GPL(phylink_create);
>   */
>  void phylink_destroy(struct phylink *pl)
>  {
> -	if (pl->sfp_bus)
> -		sfp_unregister_upstream(pl->sfp_bus);
> +	sfp_bus_del_upstream(pl->sfp_bus);
>  	if (pl->link_gpio)
>  		gpiod_put(pl->link_gpio);
>  
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index d037aab6a71d..715d45214e18 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -329,10 +329,19 @@ static void sfp_bus_release(struct kref *kref)
>  	kfree(bus);
>  }
>  
> -static void sfp_bus_put(struct sfp_bus *bus)
> +/**
> + * sfp_bus_put() - put a reference on the &struct sfp_bus
> + * bus: the &struct sfp_bus found via sfp_bus_find_fwnode()
> + *
> + * Put a reference on the &struct sfp_bus and free the underlying structure
> + * if this was the last reference.
> + */
> +void sfp_bus_put(struct sfp_bus *bus)
>  {
> -	kref_put_mutex(&bus->kref, sfp_bus_release, &sfp_mutex);
> +	if (bus)
> +		kref_put_mutex(&bus->kref, sfp_bus_release, &sfp_mutex);
>  }
> +EXPORT_SYMBOL_GPL(sfp_bus_put);
>  
>  static int sfp_register_bus(struct sfp_bus *bus)
>  {
> @@ -348,11 +357,11 @@ static int sfp_register_bus(struct sfp_bus *bus)
>  				return ret;
>  		}
>  	}
> +	bus->registered = true;
>  	bus->socket_ops->attach(bus->sfp);
>  	if (bus->started)
>  		bus->socket_ops->start(bus->sfp);
>  	bus->upstream_ops->attach(bus->upstream, bus);
> -	bus->registered = true;
>  	return 0;
>  }
>  
> @@ -446,13 +455,12 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
>  }
>  
>  /**
> - * sfp_register_upstream_node() - parse and register the neighbouring device
> + * sfp_bus_find_fwnode() - parse and locate the SFP bus from fwnode
>   * @fwnode: firmware node for the parent device (MAC or PHY)
> - * @upstream: the upstream private data
> - * @ops: the upstream's &struct sfp_upstream_ops
>   *
> - * Parse the parent device's firmware node for a SFP bus, and register the
> - * SFP bus using sfp_register_upstream().
> + * Parse the parent device's firmware node for a SFP bus, and locate
> + * the sfp_bus structure, incrementing its reference count.  This must
> + * be put via sfp_bus_put() when done.
>   *
>   * Returns: on success, a pointer to the sfp_bus structure,
>   *	    %NULL if no SFP is specified,
> @@ -462,9 +470,7 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
>   * 	        %-ENOMEM if we failed to allocate the bus.
>   *		an error from the upstream's connect_phy() method.
>   */
> -struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
> -					   void *upstream,
> -					   const struct sfp_upstream_ops *ops)
> +struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
>  {
>  	struct fwnode_reference_args ref;
>  	struct sfp_bus *bus;
> @@ -482,7 +488,39 @@ struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
>  	if (!bus)
>  		return ERR_PTR(-ENOMEM);
>  
> +	return bus;
> +}
> +EXPORT_SYMBOL_GPL(sfp_bus_find_fwnode);
> +
> +/**
> + * sfp_bus_add_upstream() - parse and register the neighbouring device
> + * @bus: the &struct sfp_bus found via sfp_bus_find_fwnode()
> + * @upstream: the upstream private data
> + * @ops: the upstream's &struct sfp_upstream_ops
> + *
> + * Add upstream driver for the SFP bus, and if the bus is complete, register
> + * the SFP bus using sfp_register_upstream().  This takes a reference on the
> + * bus, so it is safe to put the bus after this call.
> + *
> + * Returns: on success, a pointer to the sfp_bus structure,
> + *	    %NULL if no SFP is specified,
> + * 	    on failure, an error pointer value:
> + * 		corresponding to the errors detailed for
> + * 		fwnode_property_get_reference_args().
> + * 	        %-ENOMEM if we failed to allocate the bus.
> + *		an error from the upstream's connect_phy() method.
> + */
> +int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
> +			 const struct sfp_upstream_ops *ops)
> +{
> +	int ret;
> +
> +	/* If no bus, return success */
> +	if (!bus)
> +		return 0;
> +
>  	rtnl_lock();
> +	kref_get(&bus->kref);
>  	bus->upstream_ops = ops;
>  	bus->upstream = upstream;
>  
> @@ -495,33 +533,33 @@ struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
>  	}
>  	rtnl_unlock();
>  
> -	if (ret) {
> +	if (ret)
>  		sfp_bus_put(bus);
> -		bus = ERR_PTR(ret);
> -	}
>  
> -	return bus;
> +	return ret;
>  }
> -EXPORT_SYMBOL_GPL(sfp_register_upstream_node);
> +EXPORT_SYMBOL_GPL(sfp_bus_add_upstream);
>  
>  /**
> - * sfp_unregister_upstream() - Unregister sfp bus
> + * sfp_bus_del_upstream() - Delete a sfp bus
>   * @bus: a pointer to the &struct sfp_bus structure for the sfp module
>   *
> - * Unregister a previously registered upstream connection for the SFP
> - * module. @bus is returned from sfp_register_upstream().
> + * Delete a previously registered upstream connection for the SFP
> + * module. @bus should have been added by sfp_bus_add_upstream().
>   */
> -void sfp_unregister_upstream(struct sfp_bus *bus)
> +void sfp_bus_del_upstream(struct sfp_bus *bus)
>  {
> -	rtnl_lock();
> -	if (bus->sfp)
> -		sfp_unregister_bus(bus);
> -	sfp_upstream_clear(bus);
> -	rtnl_unlock();
> +	if (bus) {
> +		rtnl_lock();
> +		if (bus->sfp)
> +			sfp_unregister_bus(bus);
> +		sfp_upstream_clear(bus);
> +		rtnl_unlock();
>  
> -	sfp_bus_put(bus);
> +		sfp_bus_put(bus);
> +	}
>  }
> -EXPORT_SYMBOL_GPL(sfp_unregister_upstream);
> +EXPORT_SYMBOL_GPL(sfp_bus_del_upstream);
>  
>  /* Socket driver entry points */
>  int sfp_add_phy(struct sfp_bus *bus, struct phy_device *phydev)
> diff --git a/include/linux/sfp.h b/include/linux/sfp.h
> index 355a08a76fd4..c8464de7cff5 100644
> --- a/include/linux/sfp.h
> +++ b/include/linux/sfp.h
> @@ -508,10 +508,11 @@ int sfp_get_module_eeprom(struct sfp_bus *bus, struct ethtool_eeprom *ee,
>  			  u8 *data);
>  void sfp_upstream_start(struct sfp_bus *bus);
>  void sfp_upstream_stop(struct sfp_bus *bus);
> -struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
> -					   void *upstream,
> -					   const struct sfp_upstream_ops *ops);
> -void sfp_unregister_upstream(struct sfp_bus *bus);
> +void sfp_bus_put(struct sfp_bus *bus);
> +struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode);
> +int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
> +			 const struct sfp_upstream_ops *ops);
> +void sfp_bus_del_upstream(struct sfp_bus *bus);
>  #else
>  static inline int sfp_parse_port(struct sfp_bus *bus,
>  				 const struct sfp_eeprom_id *id,
> @@ -553,14 +554,22 @@ static inline void sfp_upstream_stop(struct sfp_bus *bus)
>  {
>  }
>  
> -static inline struct sfp_bus *sfp_register_upstream_node(
> -	struct fwnode_handle *fwnode, void *upstream,
> -	const struct sfp_upstream_ops *ops)
> +static inline void sfp_bus_put(struct sfp_bus *bus)
> +{
> +}
> +
> +static inline struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
>  {
>  	return NULL;
>  }
>  
> -static inline void sfp_unregister_upstream(struct sfp_bus *bus)
> +static int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
> +				const struct sfp_upstream_ops *ops)
> +{
> +	return 0;
> +}
> +
> +static inline void sfp_bus_del_upstream(struct sfp_bus *bus)
>  {
>  }
>  #endif
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
