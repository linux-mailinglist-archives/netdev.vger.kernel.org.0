Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF00B1180C3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 07:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfLJGtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 01:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbfLJGte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 01:49:34 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88C18206E0;
        Tue, 10 Dec 2019 06:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575960573;
        bh=CA9kChyryLNNhjVCKVAZvBo5UGCZZE2+iF4ONtRBcH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PV2pQiQr7OiFekpv+APh+hzsEWq+EdaBWOH9MRj/Jz547maXJcIaUaKV3JjISB46n
         oZRx/mVujOIHQ9V8jIAC+Stq+4mJ5oeTJHcLmH/i4JxGNs43lgQ/29tkCUmWf2dNGy
         wdC7uSpGT4ZvdpzCRg5eCzzlOdsBM+lzjuXDg4Sg=
Date:   Tue, 10 Dec 2019 08:49:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        Kiran Patil <kiran.patil@intel.com>
Subject: Re: [PATCH v3 01/20] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191210064929.GJ67461@unreal>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-2-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:16PM -0800, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
>
> This is the initial implementation of the virtual bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support registering
> virtbus_devices and virtbus_drivers and provide matching
> between them and probing of the registered drivers.
>
> The primary purpose of the virtual bus is to provide
> matching services to allow the use of a container_of
> to get access to a piece of desired data.  This will
> allow two separate kernel objects to match up and
> start communication.
>
> The bus will support probe/remove shutdown and
> suspend/resume callbacks.
>
> Kconfig and Makefile alterations are included
>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  Documentation/driver-api/virtual_bus.rst      |  76 +++++
>  drivers/bus/Kconfig                           |  12 +
>  drivers/bus/Makefile                          |   1 +
>  drivers/bus/virtual_bus.c                     | 295 ++++++++++++++++++
>  include/linux/mod_devicetable.h               |   8 +
>  include/linux/virtual_bus.h                   |  45 +++
>  scripts/mod/devicetable-offsets.c             |   3 +
>  scripts/mod/file2alias.c                      |   8 +
>  .../virtual_bus/virtual_bus_dev/Makefile      |   7 +
>  .../virtual_bus_dev/virtual_bus_dev.c         |  60 ++++
>  .../virtual_bus/virtual_bus_drv/Makefile      |   7 +
>  .../virtual_bus_drv/virtual_bus_drv.c         | 115 +++++++
>  12 files changed, 637 insertions(+)
>  create mode 100644 Documentation/driver-api/virtual_bus.rst
>  create mode 100644 drivers/bus/virtual_bus.c
>  create mode 100644 include/linux/virtual_bus.h
>  create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
>  create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
>  create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
>  create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c
>
> diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
> new file mode 100644
> index 000000000000..db8c34fcafe8
> --- /dev/null
> +++ b/Documentation/driver-api/virtual_bus.rst
> @@ -0,0 +1,76 @@
> +===============================
> +Virtual Bus Devices and Drivers
> +===============================
> +
> +See <linux/virtual_bus.h> for the models for virtbus_device and virtbus_driver.
> +This bus is meant to be a lightweight software based bus to attach generic
> +devices and drivers to so that a chunk of data can be passed between them.
> +
> +One use case example is an rdma driver needing to connect with several
> +different types of PCI LAN devices to be able to request resources from
> +them (queue sets).  Each LAN driver that supports rdma will register a
> +virtbus_device on the virtual bus for each physical function.  The rdma
> +driver will register as a virtbus_driver on the virtual bus to be
> +matched up with multiple virtbus_devices and receive a pointer to a
> +struct containing the callbacks that the PCI LAN drivers support for
> +registering with them.
> +
> +Sections in this document:
> +        Virtbus devices
> +        Virtbus drivers
> +        Device Enumeration
> +        Device naming and driver binding
> +        Virtual Bus API entry points
> +
> +Virtbus devices
> +~~~~~~~~~~~~~~~
> +Virtbus_devices are lightweight objects that support the minimal device
> +functionality.  Devices will accept a name, and then an automatically
> +generated index is concatenated onto it for the virtbus_device->name.
> +
> +The virtbus_driver and virtbus_device creators need to both have access
> +to a predefined virtbus_device_object struct that will look like the
> +following:
> +     struct virtbus_object {
> +          struct virtbus_device vdev;
> +          struct foo_type foo;
> +     }
> +
> +Then when the virtbus_driver's probe is called with the virtbus_device
> +as a parameter, it can do a container_of on the virtbus_device to get
> +to the struct foo_type foo that it cares about.
> +
> +Virtbus drivers
> +~~~~~~~~~~~~~~~
> +Virtbus drivers register with the virtual bus to be matched with virtbus
> +devices.  They expect to be registered with a probe and remove callback,
> +and also support shutdown, suspend, and resume callbacks.  They otherwise
> +follow the standard driver behavior of having discovery and enumeration
> +handled in the bus infrastructure.
> +
> +Virtbus drivers register themselves with the API entry point virtbus_drv_reg
> +and unregister with virtbus_drv_unreg.
> +
> +Device Enumeration
> +~~~~~~~~~~~~~~~~~~
> +Enumeration is handled automatically by the bus infrastructure via the
> +ida_simple methods.
> +
> +Device naming and driver binding
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The virtbus_device.dev.name is the canonical name for the device. It is
> +built from two other parts:
> +
> +        - virtbus_device.name (also used for matching).
> +        - virtbus_device.id (generated automatically from ida_simple calls)
> +
> +This allows for multiple virtbus_devices with the same name, which will all
> +be matched to the same virtbus_driver. Driver binding is performed by the
> +driver core, invoking driver probe() after finding a match between device and driver.
> +
> +Virtual Bus API entry points
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +int virtbus_dev_register(struct virtbus_device *vdev)
> +void virtbus_dev_unregister(struct virtbus_device *vdev)
> +int virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner)
> +void virtbus_drv_unregister(struct virtbus_driver *vdrv)
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 50200d1c06ea..770519d16d43 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -203,4 +203,16 @@ config DA8XX_MSTPRI
>
>  source "drivers/bus/fsl-mc/Kconfig"
>
> +config VIRTUAL_BUS
> +       tristate "lightweight Virtual Bus"
> +       depends on PM
> +       help
> +         Provides a software bus for virtbus_devices to be added to it
> +         and virtbus_drivers to be registered on it.  Will create a match
> +         between the driver and device, then call the driver's probe with
> +         the virtbus_device's struct.
> +         One example is the irdma driver needing to connect with various
> +         PCI LAN drivers to request resources (queues) to be able to perform
> +         its function.
> +
>  endmenu
> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> index 1320bcf9fa9d..6721c77dc71b 100644
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -34,3 +34,4 @@ obj-$(CONFIG_UNIPHIER_SYSTEM_BUS)	+= uniphier-system-bus.o
>  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
>
>  obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
> +obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
> diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
> new file mode 100644
> index 000000000000..6bc986659e4b
> --- /dev/null
> +++ b/drivers/bus/virtual_bus.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * virtual_bus.c - lightweight software based bus for virtual devices
> + *
> + * Copyright (c) 2019-20 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for
> + * more information
> + */
> +
> +#include <linux/string.h>
> +#include <linux/virtual_bus.h>
> +#include <linux/of_irq.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pm_domain.h>
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Lightweight Virtual Bus");
> +MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
> +MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
> +
> +static DEFINE_IDA(virtbus_dev_ida);

I was under impression that usage of IDA interface is discouraged in favor
of direct calls to XArray.

Thanks
