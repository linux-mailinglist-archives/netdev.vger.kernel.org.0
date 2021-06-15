Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBBF3A8A2E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFOUeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 16:34:10 -0400
Received: from fgw20-7.mail.saunalahti.fi ([62.142.5.81]:31823 "EHLO
        fgw20-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhFOUeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 16:34:09 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2021 16:34:09 EDT
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTP
        id 7e9e6777-ce16-11eb-ba24-005056bd6ce9;
        Tue, 15 Jun 2021 23:15:59 +0300 (EEST)
Date:   Tue, 15 Jun 2021 23:15:57 +0300
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
Subject: Re: [PATCH net-next v9 08/15] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <YMkKfUhT6BQ1od5B@surfacebook.localdomain>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-9-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611105401.270673-9-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 11, 2021 at 01:53:54PM +0300, Ioana Ciornei kirjoitti:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> mdiobus. From the compatible string, identify whether the PHY is
> c45 and based on this create a PHY device instance which is
> registered on the mdiobus.
> 
> Along with fwnode_mdiobus_register_phy() also introduce
> fwnode_find_mii_timestamper() and fwnode_mdiobus_phy_device_register()
> since they are needed.
> While at it, also use the newly introduced fwnode operation in
> of_mdiobus_phy_device_register().

I understand that this patch series is applied, but I think we have a problem
that has to be fixed before the release. See below for the details.

...

> +int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> +				       struct phy_device *phy,
> +				       struct fwnode_handle *child, u32 addr)
> +{
> +	int rc;
> +
> +	rc = fwnode_irq_get(child, 0);
> +	if (rc == -EPROBE_DEFER)
> +		return rc;
> +
> +	if (rc > 0) {
> +		phy->irq = rc;
> +		mdio->irq[addr] = rc;
> +	} else {
> +		phy->irq = mdio->irq[addr];
> +	}
> +
> +	if (fwnode_property_read_bool(child, "broken-turn-around"))
> +		mdio->phy_ignore_ta_mask |= 1 << addr;
> +
> +	fwnode_property_read_u32(child, "reset-assert-us",
> +				 &phy->mdio.reset_assert_delay);
> +	fwnode_property_read_u32(child, "reset-deassert-us",
> +				 &phy->mdio.reset_deassert_delay);
> +
> +	/* Associate the fwnode with the device structure so it
> +	 * can be looked up later
> +	 */

> +	fwnode_handle_get(child);

We take a reference counting here.
Who and when should drop it?

> +	phy->mdio.dev.fwnode = child;
> +
> +	/* All data is now stored in the phy struct;
> +	 * register it
> +	 */
> +	rc = phy_device_register(phy);
> +	if (rc) {
> +		fwnode_handle_put(child);
> +		return rc;
> +	}
> +
> +	dev_dbg(&mdio->dev, "registered phy %p fwnode at address %i\n",
> +		child, addr);
> +	return 0;
> +}
> +EXPORT_SYMBOL(fwnode_mdiobus_phy_device_register);
> +
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +				struct fwnode_handle *child, u32 addr)
> +{
> +	struct mii_timestamper *mii_ts = NULL;
> +	struct phy_device *phy;
> +	bool is_c45 = false;
> +	u32 phy_id;
> +	int rc;
> +
> +	mii_ts = fwnode_find_mii_timestamper(child);
> +	if (IS_ERR(mii_ts))
> +		return PTR_ERR(mii_ts);
> +
> +	rc = fwnode_property_match_string(child, "compatible",
> +					  "ethernet-phy-ieee802.3-c45");
> +	if (rc >= 0)
> +		is_c45 = true;
> +
> +	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +		phy = get_phy_device(bus, addr, is_c45);
> +	else
> +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +	if (IS_ERR(phy)) {
> +		unregister_mii_timestamper(mii_ts);
> +		return PTR_ERR(phy);
> +	}
> +
> +	if (is_acpi_node(child)) {
> +		phy->irq = bus->irq[addr];
> +
> +		/* Associate the fwnode with the device structure so it
> +		 * can be looked up later.
> +		 */
> +		phy->mdio.dev.fwnode = child;
> +
> +		/* All data is now stored in the phy struct, so register it */
> +		rc = phy_device_register(phy);
> +		if (rc) {
> +			phy_device_free(phy);

> +			fwnode_handle_put(phy->mdio.dev.fwnode);

We dropped reference counting here, but who and when acquired it?

> +			return rc;
> +		}
> +	} else if (is_of_node(child)) {
> +		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
> +		if (rc) {
> +			unregister_mii_timestamper(mii_ts);
> +			phy_device_free(phy);
> +			return rc;
> +		}
> +	}
> +
> +	/* phy->mii_ts may already be defined by the PHY driver. A
> +	 * mii_timestamper probed via the device tree will still have
> +	 * precedence.
> +	 */
> +	if (mii_ts)
> +		phy->mii_ts = mii_ts;
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


