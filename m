Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253933A8A36
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 22:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFOUhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 16:37:02 -0400
Received: from fgw21-7.mail.saunalahti.fi ([62.142.5.82]:54717 "EHLO
        fgw21-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhFOUhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 16:37:00 -0400
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw21.mail.saunalahti.fi (Halon) with ESMTP
        id e5ba8ddc-ce16-11eb-9eb8-005056bdd08f;
        Tue, 15 Jun 2021 23:18:51 +0300 (EEST)
Date:   Tue, 15 Jun 2021 23:18:50 +0300
From:   andy@surfacebook.localdomain
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v9 13/15] net: phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <YMkLKt42M6Wjut3O@surfacebook.localdomain>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-14-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611105401.270673-14-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 11, 2021 at 01:53:59PM +0300, Ioana Ciornei kirjoitti:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.

...

> +/**
> + * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + * @fwnode: a pointer to a &struct fwnode_handle.
> + * @flags: PHY-specific flags to communicate to the PHY device driver
> + *
> + * Connect the phy specified @fwnode to the phylink instance specified
> + * by @pl.
> + *
> + * Returns 0 on success or a negative errno.
> + */
> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags)
> +{
> +	struct fwnode_handle *phy_fwnode;
> +	struct phy_device *phy_dev;
> +	int ret;
> +
> +	/* Fixed links and 802.3z are handled without needing a PHY */
> +	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> +	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> +	     phy_interface_mode_is_8023z(pl->link_interface)))
> +		return 0;
> +
> +	phy_fwnode = fwnode_get_phy_node(fwnode);
> +	if (IS_ERR(phy_fwnode)) {
> +		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> +			return -ENODEV;
> +		return 0;
> +	}
> +
> +	phy_dev = fwnode_phy_find_device(phy_fwnode);
> +	/* We're done with the phy_node handle */
> +	fwnode_handle_put(phy_fwnode);

As per previous mail, who and when acquire this reference counting? Can it be
possible that caller will never call phylink_fwnode_phy_connect() and hence
reference counting will become disbalances?

We need to fix all this before the release.

> +	if (!phy_dev)
> +		return -ENODEV;
> +
> +	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +				pl->link_interface);
> +	if (ret) {
> +		phy_device_free(phy_dev);
> +		return ret;
> +	}
> +
> +	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
> +	if (ret)
> +		phy_detach(phy_dev);
> +
> +	return ret;
> +}

-- 
With Best Regards,
Andy Shevchenko


