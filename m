Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437C060FD60
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiJ0QsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiJ0QsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:48:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EF118F0D9;
        Thu, 27 Oct 2022 09:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A340623E3;
        Thu, 27 Oct 2022 16:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DAFC433C1;
        Thu, 27 Oct 2022 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889286;
        bh=/9duMPb6opUA8O93tCBr6BdnBW8rIFtYXrBYG6hdJKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aek07/yCA3fhXdaXFgFhCaXDAGxiqfK4GyGnbMj6SFRKMkPhMkB/UX4QHVHZBkMnY
         0xyk6fiCosGcKWzsX3+dGrDdjdQm185fyVc217ZfgVwEfey9Zr+7ToKZtwL0Xrum1m
         NlXPYASJNbt1rLouNxzynMHhM0RIgcxRTovqeoXQ=
Date:   Thu, 27 Oct 2022 18:48:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com
Subject: Re: [RFC 1/5] misc: introduce notify-device driver
Message-ID: <Y1q2RKTaw69C7vZT@kroah.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
 <db30127ab4741d4e71b768881197f4791174f545.1666786471.git.matthias.schiffer@ew.tq-group.com>
 <Y1lGPRvKMbNDs1iK@kroah.com>
 <ed580c15fbf690acde24679956a9439c1c0a1137.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed580c15fbf690acde24679956a9439c1c0a1137.camel@ew.tq-group.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 06:33:33PM +0200, Matthias Schiffer wrote:
> On Wed, 2022-10-26 at 16:37 +0200, Greg Kroah-Hartman wrote:
> > On Wed, Oct 26, 2022 at 03:15:30PM +0200, Matthias Schiffer wrote:
> > > A notify-device is a synchronization facility that allows to query
> > > "readiness" across drivers, without creating a direct dependency between
> > > the driver modules. The notify-device can also be used to trigger deferred
> > > probes.
> > > 
> > > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > > ---
> > >  drivers/misc/Kconfig          |   4 ++
> > >  drivers/misc/Makefile         |   1 +
> > >  drivers/misc/notify-device.c  | 109 ++++++++++++++++++++++++++++++++++
> > >  include/linux/notify-device.h |  33 ++++++++++
> > >  4 files changed, 147 insertions(+)
> > >  create mode 100644 drivers/misc/notify-device.c
> > >  create mode 100644 include/linux/notify-device.h
> > > 
> > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > index 358ad56f6524..63559e9f854c 100644
> > > --- a/drivers/misc/Kconfig
> > > +++ b/drivers/misc/Kconfig
> > > @@ -496,6 +496,10 @@ config VCPU_STALL_DETECTOR
> > >  
> > >  	  If you do not intend to run this kernel as a guest, say N.
> > >  
> > > +config NOTIFY_DEVICE
> > > +	tristate "Notify device"
> > > +	depends on OF
> > > +
> > >  source "drivers/misc/c2port/Kconfig"
> > >  source "drivers/misc/eeprom/Kconfig"
> > >  source "drivers/misc/cb710/Kconfig"
> > > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > > index ac9b3e757ba1..1e8012112b43 100644
> > > --- a/drivers/misc/Makefile
> > > +++ b/drivers/misc/Makefile
> > > @@ -62,3 +62,4 @@ obj-$(CONFIG_HI6421V600_IRQ)	+= hi6421v600-irq.o
> > >  obj-$(CONFIG_OPEN_DICE)		+= open-dice.o
> > >  obj-$(CONFIG_GP_PCI1XXXX)	+= mchp_pci1xxxx/
> > >  obj-$(CONFIG_VCPU_STALL_DETECTOR)	+= vcpu_stall_detector.o
> > > +obj-$(CONFIG_NOTIFY_DEVICE)	+= notify-device.o
> > > diff --git a/drivers/misc/notify-device.c b/drivers/misc/notify-device.c
> > > new file mode 100644
> > > index 000000000000..42e0980394ea
> > > --- /dev/null
> > > +++ b/drivers/misc/notify-device.c
> > > @@ -0,0 +1,109 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +
> > > +#include <linux/device/class.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/notify-device.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/slab.h>
> > > +
> > > +static void notify_device_release(struct device *dev)
> > > +{
> > > +	of_node_put(dev->of_node);
> > > +	kfree(dev);
> > > +}
> > > +
> > > +static struct class notify_device_class = {
> > > +	.name = "notify-device",
> > > +	.owner = THIS_MODULE,
> > > +	.dev_release = notify_device_release,
> > > +};
> > > +
> > > +static struct platform_driver notify_device_driver = {
> 
> [Pruning the CC list a bit, to avoid clogging people's inboxes]
> 
> > 
> > Ick, wait, this is NOT a platform device, nor driver, so it shouldn't be
> > either here.  Worst case, it's a virtual device on the virtual bus.
> 
> This part of the code is inspired by mac80211_hwsim, which uses a
> platform driver in a similar way, for a plain struct device. Should
> this rather use a plain struct device_driver?

It should NOT be using a platform device.

Again, a platform device should NEVER be used as a child of a device in
the tree that is on a discoverable bus.

Use the aux bus code if you don't want to create virtual devices with no
real bus, that is what it is there for.

> Also, what's the virtual bus? Grepping the Linux code and documentation
> didn't turn up anything.

Look at the stuff that ends up in /sys/devices/virtual/  Lots of users
there.

> > But why is this a class at all?  Classes are a representation of a type
> > of device that userspace can see, how is this anything that userspace
> > cares about?
> 
> Makes sense, I will remove the class.
> 
> > 
> > Doesn't the device link stuff handle all of this type of "when this
> > device is done being probed, now I can" problems?  Why is a whole new
> > thing needed?
> 
> The issue here is that (as I understand it) the device link and
> deferred probing infrastructore only cares about whether the supplier
> device has been probed successfully.
> 
> This is insuffient in the case of the dependency between mwifiex and
> hci_uart/hci_mrvl that I want to express: mwifiex loads its firmware
> asynchronously, so finishing the mwifiex probe is too early to retry
> probing the Bluetooth driver.

Welcome to deferred probing hell :)

> While mwifiex does create a few devices (ieee80211, netdevice) when the
> firmware has loaded, none of these bind to a driver, so they don't
> trigger the deferred probes. Using their existence as a condition for
> allowing the Bluetooth driver to probe also seems ugly too me
> (ieee80211 currently can't be looked up by OF node, and netdevices can
> be created and deleted dynamically).
> 
> Because of this, I came to the conclusion that creating and binding a
> device specifically for this purpose is a good solution, as it solves
> two problems at once:
> - The driver bind triggers deferred probes
> - The driver allows to look up the device by OF node
> 
> Integrating this with device links might make sense as well, but I
> haven't looked much into that yet.

Try looking at device links, I think this fits exactly what that solves.
If not, please figure out why.

thanks,

greg k-h
