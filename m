Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255001C844E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgEGIGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgEGIGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 04:06:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A26920753;
        Thu,  7 May 2020 08:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588838782;
        bh=yhW1ccbc1lH27NXfN8CwOPauPuCuJYFUhkDaBbjtgyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HbumOnEWEJuzOMW+92j04gHwbRc+CmuOVLOFxYw4xc7NLNc871T9uBuGLRiyulVZ3
         5NesgK0jPdAoyLkhKBk9bEySLA7YZyVAdWdlRMABSZdat6S+dk7Yo0zhEOU0khGZXo
         GW9joYhF/CEVnKUdYitSKtRUEJeP5Npy3v6Ey1J0=
Date:   Thu, 7 May 2020 10:06:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v3 1/9] Implementation of Virtual Bus
Message-ID: <20200507080620.GB1024567@kroah.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506210505.507254-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:04:57PM -0700, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> This is the initial implementation of the Virtual Bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support registering
> virtbus_devices and virtbus_drivers and provide matching
> between them and probing of the registered drivers.
> 
> The bus will support probe/remove shutdown and
> suspend/resume callbacks.

Odd line-wrapping, you can use the full 72 columns.

> Kconfig and Makefile alterations are included

Why wouldn't they be? :)

> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  Documentation/driver-api/virtual_bus.rst |  88 ++++++++
>  drivers/bus/Kconfig                      |  10 +
>  drivers/bus/Makefile                     |   2 +
>  drivers/bus/virtual_bus.c                | 255 +++++++++++++++++++++++
>  include/linux/mod_devicetable.h          |   8 +
>  include/linux/virtual_bus.h              |  62 ++++++
>  scripts/mod/devicetable-offsets.c        |   3 +
>  scripts/mod/file2alias.c                 |   7 +
>  8 files changed, 435 insertions(+)
>  create mode 100644 Documentation/driver-api/virtual_bus.rst
>  create mode 100644 drivers/bus/virtual_bus.c
>  create mode 100644 include/linux/virtual_bus.h
> 
> diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
> new file mode 100644
> index 000000000000..33cef5433dcd
> --- /dev/null
> +++ b/Documentation/driver-api/virtual_bus.rst
> @@ -0,0 +1,88 @@
> +===============================
> +Virtual Bus Devices and Drivers
> +===============================
> +
> +See <linux/virtual_bus.h> for the models for virtbus_device and virtbus_driver.
> +This bus is meant to be a minimalist software based bus to attach generic
> +devices and drivers to so that a chunk of data can be passed between them.
> +
> +Memory Allocation Lifespan and Model
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Originating KO - The kernel object that is defining either the
> +virtbus_device or the virtbus_driver and registering it with the virtual_bus.

What is a "KO"?

> +
> +The originating KO is expected to allocate memory for the virtbus_device or
> +virtbus_driver before registering it with the virtual_bus.
> +
> +For a virtbus_device, this memory is expected to remain viable until the
> +device's mandatory .release() callback is accessed.  The memory cleanup will
> +ideally be performed within this callback.
> +
> +For a virtbus_driver, this memory is expected to remain viable until the
> +driver's .remove() or .shutdown() callbacks are accessed.  The memory cleanup
> +will ideally be performed with these callbacks.

"will ideally" is odd, either it should or not.

But, and this is the same thing I said last time, you are creating these
virtual drivers but NOT USING THEM IN THIS PATCH SERIES!

So, why add them at all?  Why are they needed if you didn't even use
them?  Why define their specific usage but have no way of even testing
if they work properly?

> +Device Enumeration
> +~~~~~~~~~~~~~~~~~~
> +
> +Enumeration is handled automatically by the bus infrastructure.

What does this mean?

> +
> +Device naming and driver binding
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +The virtbus_device.dev.name is the canonical name for the device. It is
> +built from two other parts:
> +
> +        - virtbus_device.match_name (used for matching).
> +        - virtbus_device.id (generated automatically from ida_simple calls)
> +
> +Virtbus device's sub-device names are always in "<name>.<instance>" format.
> +
> +For a virtbus_device to be matched with a virtbus_driver, the device's match
> +name must be populated, as this is what will be evaluated to perform the match.

I don't understand this, why would anyone match a device name?

> +Common Usage and Structure Design
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +The two (or more) Originating KO's (one for the driver and one or more for
> +the devices) will have to have a common header file, so that a struct can
> +be defined that they both use.  This allows for the following design.
> +
> +In the common header file outside of the virtual_bus infrastructure, define
> +struct virtbus_object:
> +
> +                 virtbus_object
> +                        |
> +                -------------------------
> +                |                       |
> +        virtbus_device          private_struct/data

I don't understand this at all, what does it mean?

> +
> +The virtbus_device cannot be a pointer so that a container_of can be
> +performed by the driver.

What driver?  The virtbus driver?  The one that is never implemented in
this patch series?  :(

> +The device originating KO will allocate a virtbus_object and then populate
> +virtbus_device->match_name and register the virtbus_device with virtbus.
> +
> +When the virtbus_driver registers with the virtual_bus and a match is made,
> +the .probe() callback of the driver will be called with the virtbus_device
> +struct as a parameter.  This allows the virtbus_driver to perform a
> +contain_of call to get access to the virtbus_object, and to the pointer to

"contain_of"?

> +the private_struct/data.

Again, you define what a driver should do, but you have no examples of
drivers doing anything :(

> +
> +This is the main goal of virtual_bus, to get a common pointer available
> +to both of the originating KOs involved in a match.

That's the main goal?


> +
> +Mandatory Elements
> +~~~~~~~~~~~~~~~~~
> +
> +virtbus_device:
> +        .relase() callback must not be NULL and is expected to perform
> +                memory cleanup.
> +        .match_name must be populated to be able to match with a driver
> +
> +virtbus_driver:
> +        .probe() callback must not be NULL
> +        .remove() callback must not be NULL
> +        .shutdown() callback must not be NULL
> +        .id_table must not be NULL, used to perform matching

I'm all for writing documentation, but again, I can't really understand
this file at all.

What is the goal of it?  Who is it written for?  I can not tell at all
:(


> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 6d4e4497b59b..00553c78510c 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -203,4 +203,14 @@ config DA8XX_MSTPRI
>  source "drivers/bus/fsl-mc/Kconfig"
>  source "drivers/bus/mhi/Kconfig"
>  
> +config VIRTUAL_BUS
> +       tristate "Software based Virtual Bus"
> +       help
> +         Provides a software bus for virtbus_devices to be added to it
> +         and virtbus_drivers to be registered on it.  It matches driver
> +         and device based on id and calls the driver's probe routine.
> +         One example is the irdma driver needing to connect with various
> +         PCI LAN drivers to request resources (queues) to be able to perform
> +         its function.

module name if built as a module?



> --- /dev/null
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,62 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-2020 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for more information
> + */
> +
> +#ifndef _VIRTUAL_BUS_H_
> +#define _VIRTUAL_BUS_H_
> +
> +#include <linux/device.h>
> +
> +struct virtbus_device {
> +	struct device dev;
> +	const char *match_name;
> +	void (*release)(struct virtbus_device *);
> +	u32 id;
> +};
> +
> +struct virtbus_driver {
> +	int (*probe)(struct virtbus_device *);
> +	int (*remove)(struct virtbus_device *);
> +	void (*shutdown)(struct virtbus_device *);
> +	int (*suspend)(struct virtbus_device *, pm_message_t);
> +	int (*resume)(struct virtbus_device *);
> +	struct device_driver driver;
> +	const struct virtbus_dev_id *id_table;
> +};
> +
> +static inline
> +struct virtbus_device *to_virtbus_dev(struct device *dev)
> +{
> +	return container_of(dev, struct virtbus_device, dev);
> +}
> +
> +static inline
> +struct virtbus_driver *to_virtbus_drv(struct device_driver *drv)
> +{
> +	return container_of(drv, struct virtbus_driver, driver);
> +}
> +
> +int virtbus_register_device(struct virtbus_device *vdev);
> +
> +int
> +__virtbus_register_driver(struct virtbus_driver *vdrv, struct module *owner);
> +
> +#define virtbus_register_driver(vdrv) \
> +	__virtbus_register_driver(vdrv, THIS_MODULE)

Again, I fail to see any use of this call in the patch series.

What am I missing?  Why is it not needed?  If it's not needed, who would
need it and why not this series?

I asked this last time, don't know why it was ignored.  Maybe I should
just stop reviewing patches...

{sigh}

greg k-h
