Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A372404306
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 03:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350080AbhIIBmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 21:42:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350046AbhIIBlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 21:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1fHEkR5k+Jdu65pUoUQvmgXn1dPzE2m99xMmkzV4JqU=; b=miXMqy7Z7y0fLKbOETUtmyt8tO
        mQS6WNeIFFgUMs4zYNUsRnjxWQjpfWM9okgcyCYlCeBM3y2hyBe9G50oDEqiJJCRgkOoq6puRLrIj
        IZc22INp6IhKBQilqFLhx8haWz+EC1pkJ8k6txKzak7OCF0G81ewqa5TGsrQFyY8pHFI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mO92I-005pSx-Va; Thu, 09 Sep 2021 03:39:30 +0200
Date:   Thu, 9 Sep 2021 03:39:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YTll0i6Rz3WAAYzs@lunn.ch>
References: <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1286,6 +1286,17 @@ static int dsa_switch_parse_of(struct
> dsa_switch *ds, struct device_node *dn)
>  {
>         int err;
> 
> +       /* A lot of switch devices have their PHYs as child devices and have
> +        * the PHYs depend on the switch as a supplier (Eg: interrupt
> +        * controller). With fw_devlink=on, that means the PHYs will defer
> +        * probe until the probe() of the switch completes. However, the way
> +        * the DSA framework is designed, the PHYs are expected to be probed
> +        * successfully before the probe() of the switch completes.
> +        *
> +        * So, mark the switch devices as a "broken parent" so that fw_devlink
> +        * knows not to create device links between PHYs and the parent switch.
> +        */
> +       np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
>         err = dsa_switch_parse_member_of(ds, dn);
>         if (err)
>                 return err;

This does not work. First off, its dn, not np. But with that fixed, it
still does not work. This is too late, the mdio busses have already
been registered and probed, the PHYs have been found on the busses,
and the PHYs would of been probed, if not for fw_devlink.

What did work was:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..45d67d50e35f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6249,8 +6249,10 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
        if (!np && !pdata)
                return -EINVAL;
 
-       if (np)
+       if (np) {
                compat_info = of_device_get_match_data(dev);
+               np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
+       }
 
        if (pdata) {
                compat_info = pdata_device_get_match_data(dev);

This will fix it for mv88e6xxx. But if the same problem occurs in any
of the other DSA drivers, they will still be broken:

~/linux/drivers/net/dsa$ grep -r mdiobus_register *
bcm_sf2.c:	err = mdiobus_register(priv->slave_mii_bus);
dsa_loop_bdinfo.c:	return mdiobus_register_board_info(&bdinfo, 1);
lantiq_gswip.c:	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
mt7530.c:	ret = mdiobus_register(bus);
mv88e6xxx/chip.c:	err = of_mdiobus_register(bus, np);
grep: mv88e6xxx/chip.o: binary file matches
ocelot/seville_vsc9953.c:	rc = mdiobus_register(bus);
ocelot/felix_vsc9959.c:	rc = mdiobus_register(bus);
qca/ar9331.c:	ret = of_mdiobus_register(mbus, mnp);
qca8k.c:	return devm_of_mdiobus_register(priv->dev, bus, mdio);
realtek-smi-core.c:	ret = of_mdiobus_register(smi->slave_mii_bus, mdio_np);
sja1105/sja1105_mdio.c:	rc = of_mdiobus_register(bus, np);
sja1105/sja1105_mdio.c:	rc = of_mdiobus_register(bus, np);
sja1105/sja1105_mdio.c:	rc = mdiobus_register(bus);
sja1105/sja1105_mdio.c:int sja1105_mdiobus_register(struct dsa_switch *ds)
sja1105/sja1105.h:int sja1105_mdiobus_register(struct dsa_switch *ds);
sja1105/sja1105_main.c:	rc = sja1105_mdiobus_register(ds);

If you are happy to use a big hammer:

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..7ecd910f7fb8 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -525,6 +525,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
            NULL == bus->read || NULL == bus->write)
                return -EINVAL;
 
+       if (bus->parent && bus->parent->of_node)
+               bus->parent->of_node->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
+
        BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
               bus->state != MDIOBUS_UNREGISTERED);
 
So basically saying all MDIO busses potentially have a problem.

I also don't like the name FWNODE_FLAG_BROKEN_PARENT. The parents are
not broken, they work fine, if fw_devlink gets out of the way and
allows them to do their job.

You also asked about why the component framework is not used. DSA has
been around for a while, the first commit dates back to October
2008. Russell Kings first commit for the component framework is
January 2014. The plain driver model has worked for the last 13 years,
so there has not been any need to change.

   Andrew

