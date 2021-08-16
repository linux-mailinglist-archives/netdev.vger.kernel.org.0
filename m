Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64043EDF27
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhHPVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:15:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhHPVPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QOz1SztoEYOf+uIyfC3XMLTMwM77KWE1h3rxchFfk90=; b=hlkCINFpYxk8glZKsgK7618O1m
        t95TbcNMaKzmrs5d6WVKvm6ZReufg0kJGcuFYnhq6EDenQsZ0Fq/LaY+XDG2aGse8GKqPCG1EP6Ge
        qgiIeGAk4xILqG2GQnicsQ3/FbE0K8oZTHEezKSFZciz4TYvGwThnra39yIzdxMBr+wM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFjwv-000RNQ-0D; Mon, 16 Aug 2021 23:15:13 +0200
Date:   Mon, 16 Aug 2021 23:15:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, kernel-team@android.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YRrVYNi1E2QO+XSY@lunn.ch>
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com>
 <YRffzVgP2eBw7HRz@lunn.ch>
 <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 01:43:19PM -0700, Saravana Kannan wrote:
> On Sat, Aug 14, 2021 at 8:22 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Hi Saravana
> >
> > > Hi Andrew,
> > >
> >
> > > Also there
> > > are so many phy related properties that my head is spinning. Is there a
> > > "phy" property (which is different from "phys") that treated exactly as
> > > "phy-handle"?
> >
> > Sorry, i don't understand your question.
> 
> Sorry. I was just saying I understand the "phy-handle" DT property
> (seems specific to ethernet PHY) and "phys" DT property (seems to be
> for generic PHYs -- used mostly by display and USB?). But I noticed
> there's yet another "phy" DT property which I'm not sure I understand.
> It seems to be used by display and ethernet and seems to be a
> deprecated property. If you can explain that DT property in the
> context of networking and how to interpret it as a human, that'd be
> nice.

Ah, i think i understand:

Documentation/devicetree/bindings/net/ethernet-controller.yaml

  phy:
    $ref: "#/properties/phy-handle"
    deprecated: true

So it is used the same as phy-handle. I doubt there are many examples
of it, it has been deprecated a long time. Maybe look in the powerpc
dts files?

> > > +     /*
> > > +      * Device tree nodes pointed to by phy-handle never have struct devices
> > > +      * created for them even if they have a "compatible" property. So
> > > +      * return the parent node pointer.
> > > +      */
> >
> > We have a classic bus with devices on it. The bus master is registers
> > with linux using one of the mdiobus_register() calls. That then
> > enumerates the bus, looking at the 32 possible address on the bus,
> > using mdiobus_scan. It then gets a little complex, due to
> > history.
> >
> > Originally, the only thing you could have on an MDIO bus was a
> > PHY. But devices on MDIO busses are more generic, and Linux gained
> > support for Ethernet switches on an MDIO bus, and there are a few
> > other sort device. So to keep the PHY API untouched, but to add these
> > extra devices, we added the generic struct mdio_device which
> > represents any sort of device on an MDIO bus. This has a struct device
> > embedded in it.
> >
> > When we scan the bus and find a PHY, a struct phy_device is created,
> > which has an embedded struct mdio_device. The struct device in that is
> > then registered with the driver core.
> >
> > So a phy-handle does point to a device, but you need to do an object
> > orientated style look at the base class to find it.
> 
> Thanks for the detailed explanation. I didn't notice a phy_device had
> an mdio_device inside it. Makes sense. I think my comment is not
> worded accurately and it really should be:
> 
> Device tree nodes pointed to by phy-handle (even if they have a
> "compatible" property) will never have struct devices probed and bound
> to a driver through the driver framework. It's the parent node/device
> that gets bound to a driver and initializes the PHY. So return the
> parent node pointer instead.
> 
> Does this sound right? As opposed to PHYs the other generic mdio
> devices seem to actually have drivers that'll bind to them through the
> driver framework.

That sounds wrong. The MDIO bus master is a linux device and has a
driver. Same as an I2C bus master, or an SPI bus master, or a USB
host. All these busses have devices on them, same as an MDIO bus. The
devices on the bus are found and registered with the driver
framework. The driver framework, with some help from the mdio bus
class, with then find the correct driver of the device, and probe
it. During probe, it gets initialized by the PHY driver.

So for me, the parent of a PHY would be the MDIO bus master, and the
bus master is not driving the PHY, in the same way an I2C bus master
does not drive the tmp100 temperature sensor on an i2c bus.

But maybe i don't understand your terminology here?

Maybe this will help:

root@370rd:/sys/class/mdio_bus# ls -l
total 0
lrwxrwxrwx 1 root root 0 Jan  2  2021 '!soc!internal-regs!mdio@72004!switch@10!mdio' -> '../../devices/platform/soc/soc:internal-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:10/mdio_bus/!soc!internal-regs!mdio@72004!switch@10!mdio'
lrwxrwxrwx 1 root root 0 Jan  2  2021  f1072004.mdio-mii -> ../../devices/platform/soc/soc:internal-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii
lrwxrwxrwx 1 root root 0 Jan  2  2021  fixed-0 -> '../../devices/platform/Fixed MDIO bus.0/mdio_bus/fixed-0'

So there are three MDIO bus masters.

Going into f1072004.mdio-mii, we see there are two PHYs on this bus:

root@370rd:/sys/class/mdio_bus/f1072004.mdio-mii# ls -l
total 0
lrwxrwxrwx 1 root root    0 Aug 16 21:03 device -> ../../../f1072004.mdio
drwxr-xr-x 5 root root    0 Jan  2  2021 f1072004.mdio-mii:00
drwxr-xr-x 6 root root    0 Jan  2  2021 f1072004.mdio-mii:10
lrwxrwxrwx 1 root root    0 Aug 16 21:03 of_node -> ../../../../../../../firmware/devicetree/base/soc/internal-regs/mdio@72004
drwxr-xr-x 2 root root    0 Aug 16 21:03 power
drwxr-xr-x 2 root root    0 Aug 16 21:03 statistics
lrwxrwxrwx 1 root root    0 Jan  2  2021 subsystem -> ../../../../../../../class/mdio_bus
-rw-r--r-- 1 root root 4096 Jan  2  2021 uevent
-r--r--r-- 1 root root 4096 Aug 16 21:03 waiting_for_supplier

and going into one of the PHYs f1072004.mdio-mii:00

lrwxrwxrwx 1 root root    0 Aug 16 20:54 attached_dev -> ../../../../f1070000.ethernet/net/eth0
lrwxrwxrwx 1 root root    0 Aug 16 20:54 driver -> '../../../../../../../../bus/mdio_bus/drivers/Marvell 88E1510'
drwxr-xr-x 3 root root    0 Jan  2  2021 hwmon
lrwxrwxrwx 1 root root    0 Aug 16 20:54 of_node -> ../../../../../../../../firmware/devicetree/base/soc/internal-regs/mdio@72004/ethernet-phy@0
-r--r--r-- 1 root root 4096 Aug 16 20:54 phy_dev_flags
-r--r--r-- 1 root root 4096 Aug 16 20:54 phy_has_fixups
-r--r--r-- 1 root root 4096 Aug 16 20:54 phy_id
-r--r--r-- 1 root root 4096 Aug 16 20:54 phy_interface
drwxr-xr-x 2 root root    0 Aug 16 20:54 power
drwxr-xr-x 2 root root    0 Aug 16 20:54 statistics
lrwxrwxrwx 1 root root    0 Jan  2  2021 subsystem -> ../../../../../../../../bus/mdio_bus
-rw-r--r-- 1 root root 4096 Jan  2  2021 uevent

The phy-handle in the MAC node points to ethernet-phy@0.

    Andrew
