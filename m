Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839E6F9C46
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLV2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbfKLV2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 16:28:37 -0500
Received: from localhost (unknown [8.46.76.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38B52084E;
        Tue, 12 Nov 2019 21:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573594116;
        bh=y3hLIuTALfyf6w0cXcOXstELcimtJSdNdmh7Cyqw0FE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+1PknJzQQLgyqJW7756qIh+kS7W3PbDsBra6GNNIZYh1ltFD4SE6oRGbmg5jeWNw
         1NPgCEWQ1CzYAIB8zOpWXAZ/Tvd1RpMe+L3RBevuTL1N87M8ZiCLygAajTyZzuqntn
         Mn+1812DMlEJMIt6gGVoRcW4znHmDOykZIivHlsY=
Date:   Tue, 12 Nov 2019 22:28:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com,
        jgg@ziepe.ca, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191112212826.GA1837470@kroah.com>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 11:22:19AM -0800, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> This is the initial implementation of the Virtual Bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support lightweight
> devices and drivers and provide matching between them
> and probing of the registered drivers.
> 
> Files added:
> 	drivers/bus/virtual_bus.c
> 	include/linux/virtual_bus.h
> 	Documentation/driver-api/virtual_bus.rst
> 
> The primary purpose of the virual bus is to provide
> matching services and to pass the data pointer
> contained in the virtbus_device to the virtbus_driver
> during its probe call.  This will allow two separate
> kernel objects to match up and start communication.
> 
> The bus will support probe/remove shutdown and
> suspend/resume callbacks.
> 
> Kconfig and Makefile alterations are included
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Interesting, and kind of what I was thinking of, but the implementation
is odd and I don't really see how you can use it.

Can you provide a second patch that actually uses this api?

Code comments below for when you resend:

> +Virtual Bus Structs
> +~~~~~~~~~~~~~~~~~~~
> +struct device virtual_bus = {
> +        .init_name      = "virtbus",
> +        .release        = virtual_bus_release,
> +};
> +
> +struct bus_type virtual_bus_type = {
> +        .name           = "virtbus",
> +        .match          = virtbus_match,
> +        .probe          = virtbus_probe,
> +        .remove         = virtbus_remove,
> +        .shutdown       = virtbus_shutdown,
> +        .suspend        = virtbus_suspend,
> +        .resume         = virtbus_resume,
> +};
> +
> +struct virtbus_device {
> +        const char                      *name;
> +        int                             id;
> +        const struct virtbus_dev_id     *dev_id;
> +        struct device                   dev;
> +        void                            *data;
> +};
> +
> +struct virtbus_driver {
> +        int (*probe)(struct virtbus_device *);
> +        int (*remove)(struct virtbus_device *);
> +        void (*shutdown)(struct virtbus_device *);
> +        int (*suspend)(struct virtbus_device *, pm_message_t state);
> +        int (*resume)(struct virtbus_device *);
> +        struct device_driver driver;
> +};


All of the above should come straight from the .c/.h files, no need to
duplicate it in a text file that will be guaranteed to get out of sync.

> diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
> new file mode 100644
> index 000000000000..af3f6d9b60f4
> --- /dev/null
> +++ b/drivers/bus/virtual_bus.c
> @@ -0,0 +1,339 @@
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
> +static DEFINE_IDA(virtbus_dev_id);
> +
> +static void virtual_bus_release(struct device *dev)
> +{
> +	pr_info("Removing virtual bus device.\n");
> +}

This is just one step away from doing horrible things.

A release function should free the memory.  Not just print a message :(

Also, this is the driver code, use dev_info() and friends, never use
pr_*()   Same goes for all places in this code.

So this is a debugging line, why?
How can this be called?  You only use it:

> +
> +struct device virtual_bus = {
> +	.init_name	= "virtbus",
> +	.release	= virtual_bus_release,
> +};
> +EXPORT_SYMBOL_GPL(virtual_bus);

Here.

Ick.

A static struct device?  Called 'bus'?  That's _REALLY_ confusing.  What
is this for?  And why export it?  That's guaranteed to cause problems
(hint, code lifecycle vs. data lifecycles...)

> +/**
> + * virtbus_add_dev - add a virtual bus device
> + * @vdev: virtual bus device to add
> + */
> +int virtbus_dev_add(struct virtbus_device *vdev)
> +{
> +	int ret;
> +
> +	if (!vdev)
> +		return -EINVAL;
> +
> +	device_initialize(&vdev->dev);
> +	if (!vdev->dev.parent)
> +		vdev->dev.parent = &virtual_bus;

So it's a parent?  Ok, then why export it?

Again I want to see a user please...

> +
> +	vdev->dev.bus = &virtual_bus_type;
> +	/* All device IDs are automatically allocated */
> +	ret = ida_simple_get(&virtbus_dev_id, 0, 0, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
> +
> +	vdev->id = ret;
> +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
> +
> +	pr_debug("Registering VirtBus device '%s'. Parent at %s\n",
> +		 dev_name(&vdev->dev), dev_name(vdev->dev.parent));

dev_dbg().

> +
> +	ret = device_add(&vdev->dev);
> +	if (!ret)
> +		return ret;
> +
> +	/* Error adding virtual device */
> +	ida_simple_remove(&virtbus_dev_id, vdev->id);
> +	vdev->id = VIRTBUS_DEVID_NONE;

That's all you need to clean up?  Did you read the device_add()
documentation?  Please do so.

And what's up with this DEVID_NONE stuff?

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_add);
> +
> +/**
> + * virtbus_dev_del - remove a virtual bus device
> + * vdev: virtual bus device we are removing
> + */
> +void virtbus_dev_del(struct virtbus_device *vdev)
> +{
> +	if (!IS_ERR_OR_NULL(vdev)) {
> +		device_del(&vdev->dev);
> +
> +		ida_simple_remove(&virtbus_dev_id, vdev->id);
> +		vdev->id = VIRTBUS_DEVID_NONE;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_del);
> +
> +struct virtbus_object {
> +	struct virtbus_device vdev;
> +	char name[];
> +};

A device has a name, why have another one?

> +
> +/**
> + * virtbus_dev_release - Destroy a virtbus device
> + * @vdev: virtual device to release
> + *
> + * Note that the vdev->data which is separately allocated needs to be
> + * separately freed on it own.
> + */
> +static void virtbus_dev_release(struct device *dev)
> +{
> +	struct virtbus_object *vo = container_of(dev, struct virtbus_object,
> +						 vdev.dev);
> +
> +	kfree(vo);
> +}
> +
> +/**
> + * virtbus_dev_alloc - allocate a virtbus device
> + * @name: name to associate with the vdev
> + * @data: pointer to data to be associated with this device
> + */
> +struct virtbus_device *virtbus_dev_alloc(const char *name, void *data)
> +{
> +	struct virtbus_object *vo;
> +
> +	/* Create a virtbus object to contain the vdev and name.  This
> +	 * avoids a problem with the const attribute of name in the vdev.
> +	 * The virtbus_object will be allocated here and freed in the
> +	 * release function.
> +	 */
> +	vo = kzalloc(sizeof(*vo) + strlen(name) + 1, GFP_KERNEL);
> +	if (!vo)
> +		return NULL;

What problem are you trying to work around with the name?

> +
> +	strcpy(vo->name, name);
> +	vo->vdev.name = vo->name;
> +	vo->vdev.data = data;
> +	vo->vdev.dev.release = virtbus_dev_release;
> +
> +	return &vo->vdev;
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_alloc);

Why have an alloc/add pair of functions?  Why not just one?

> +
> +static int virtbus_drv_probe(struct device *_dev)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +	int ret;
> +
> +	ret = dev_pm_domain_attach(_dev, true);
> +	if (ret) {
> +		dev_warn(_dev, "Failed to attatch to PM Domain : %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (vdrv->probe) {
> +		ret = vdrv->probe(vdev);
> +		if (ret)
> +			dev_pm_domain_detach(_dev, true);
> +	}
> +
> +	return ret;
> +}
> +
> +static int virtbus_drv_remove(struct device *_dev)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +	int ret = 0;
> +
> +	if (vdrv->remove)
> +		ret = vdrv->remove(vdev);
> +
> +	dev_pm_domain_detach(_dev, true);
> +
> +	return ret;
> +}
> +
> +static void virtbus_drv_shutdown(struct device *_dev)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +
> +	if (vdrv->shutdown)
> +		vdrv->shutdown(vdev);
> +}
> +
> +static int virtbus_drv_suspend(struct device *_dev, pm_message_t state)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +
> +	return vdrv->suspend ? vdrv->suspend(vdev, state) : 0;
> +}
> +
> +static int virtbus_drv_resume(struct device *_dev)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +
> +	return vdrv->resume ? vdrv->resume(vdev) : 0;
> +}
> +
> +/**
> + * virtbus_drv_register - register a driver for virtual bus devices
> + * @vdrv: virtbus_driver structure
> + * @owner: owning module/driver
> + */
> +int virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner)

Don't force someone to type THIS_MODULE for this call, use the macro
trick instead that most subsystems use.

Again, I want to see a user, that will cause lots of these types of
things to be painfully obvious :)


> +{
> +	vdrv->driver.owner = owner;
> +	vdrv->driver.bus = &virtual_bus_type;
> +	vdrv->driver.probe = virtbus_drv_probe;
> +	vdrv->driver.remove = virtbus_drv_remove;
> +	vdrv->driver.shutdown = virtbus_drv_shutdown;
> +	vdrv->driver.suspend = virtbus_drv_suspend;
> +	vdrv->driver.resume = virtbus_drv_resume;
> +
> +	return driver_register(&vdrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(virtbus_drv_register);
> +
> +/**
> + * virtbus_drv_unregister - unregister a driver for virtual bus devices
> + * @drv: virtbus_driver structure
> + */
> +void virtbus_drv_unregister(struct virtbus_driver *vdrv)
> +{
> +	driver_unregister(&vdrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(virtbus_drv_unregister);
> +
> +static const
> +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> +					struct virtbus_device *vdev)
> +{
> +	while (id->name[0]) {
> +		if (strcmp(vdev->name, id->name) == 0) {
> +			vdev->dev_id = id;
> +			return id;
> +		}
> +		id++;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * virtbus_match - bind virtbus device to virtbus driver
> + * @dev: device
> + * @drv: driver
> + *
> + * Virtbus device IDs are always in "<name>.<instance>" format.
> + * Instances are automatically selected through an ida_simple_get so
> + * are positive integers. Names are taken from the device name field.
> + * Driver IDs are simple <name>.  Need to extract the name from the
> + * Virtual Device compare to name of the driver.
> + */
> +static int virtbus_match(struct device *dev, struct device_driver *drv)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(drv);
> +	struct virtbus_device *vdev = to_virtbus_dev(dev);
> +
> +	if (vdrv->id_table)
> +		return virtbus_match_id(vdrv->id_table, vdev) != NULL;
> +
> +	return (strcmp(vdev->name, drv->name) == 0);
> +}
> +
> +/**
> + * virtbus_probe - call probe of the virtbus_drv
> + * @dev: device struct
> + */
> +static int virtbus_probe(struct device *dev)
> +{
> +	return dev->driver->probe ? dev->driver->probe(dev) : 0;
> +}
> +
> +static int virtbus_remove(struct device *dev)
> +{
> +	return dev->driver->remove ? dev->driver->remove(dev) : 0;
> +}
> +
> +static void virtbus_shutdown(struct device *dev)
> +{
> +	if (dev->driver->shutdown)
> +		dev->driver->shutdown(dev);
> +}
> +
> +static int virtbus_suspend(struct device *dev, pm_message_t state)
> +{
> +	if (dev->driver->suspend)
> +		return dev->driver->suspend(dev, state);

You have two different styles here with these calls, use this one
instead of the crazy ? : style above in probe/remove please.

> +
> +	return 0;
> +}
> +
> +static int virtbus_resume(struct device *dev)
> +{
> +	if (dev->driver->resume)
> +		return dev->driver->resume(dev);
> +
> +	return 0;
> +}
> +
> +struct bus_type virtual_bus_type = {
> +	.name		= "virtbus",
> +	.match		= virtbus_match,
> +	.probe		= virtbus_probe,
> +	.remove		= virtbus_remove,
> +	.shutdown	= virtbus_shutdown,
> +	.suspend	= virtbus_suspend,
> +	.resume		= virtbus_resume,
> +};
> +EXPORT_SYMBOL_GPL(virtual_bus_type);

Why is this exported?

> +
> +static int __init virtual_bus_init(void)
> +{
> +	int err;
> +
> +	err = device_register(&virtual_bus);
> +	if (err) {
> +		put_device(&virtual_bus);
> +		return err;
> +	}
> +
> +	err = bus_register(&virtual_bus_type);
> +	if (err) {
> +		device_unregister(&virtual_bus);
> +		return err;
> +	}
> +
> +	pr_debug("Virtual Bus (virtbus) registered with kernel\n");

Don't be noisy.  And remove your debugging code :)


> +	return err;
> +}
> +
> +static void __exit virtual_bus_exit(void)
> +{
> +	bus_unregister(&virtual_bus_type);
> +	device_unregister(&virtual_bus);
> +}
> +
> +module_init(virtual_bus_init);
> +module_exit(virtual_bus_exit);
> diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
> new file mode 100644
> index 000000000000..722f020ac53b
> --- /dev/null
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,64 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-20 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for more information
> + */
> +
> +#ifndef _VIRTUAL_BUS_H_
> +#define _VIRTUAL_BUS_H_
> +
> +#include <linux/device.h>
> +
> +#define VIRTBUS_DEVID_NONE	(-1)

What is this for?

> +#define VIRTBUS_NAME_SIZE	20

Why?  Why is 20 "ok"?

> +
> +struct virtbus_dev_id {
> +	char name[VIRTBUS_NAME_SIZE];
> +	u64 driver_data;

u64 or a pointer?  You use both, pick one please.

> +};
> +
> +/* memory allocation for dev_id is expected to be done by the virtbus_driver
> + * that will match with the virtbus_device, and the matching process will
> + * copy the pointer from the matched element from the driver to the device.

What pointer?  I don't understand.

> + */
> +struct virtbus_device {
> +	const char			*name;
> +	int				id;
> +	const struct virtbus_dev_id	*dev_id;
> +	struct device			dev;
> +	void				*data;
> +};
> +
> +struct virtbus_driver {
> +	int (*probe)(struct virtbus_device *);
> +	int (*remove)(struct virtbus_device *);
> +	void (*shutdown)(struct virtbus_device *);
> +	int (*suspend)(struct virtbus_device *, pm_message_t state);
> +	int (*resume)(struct virtbus_device *);
> +	struct device_driver driver;
> +	const struct virtbus_dev_id *id_table;
> +};
> +
> +#define virtbus_get_dev_id(vdev)	((vdev)->id_entry)
> +#define virtbus_get_devdata(dev)	((dev)->devdata)

What are these for?

> +#define dev_is_virtbus(dev)	((dev)->bus == &virtbus_type)

Who needs this?

> +#define to_virtbus_dev(x)	container_of((x), struct virtbus_device, dev)
> +#define to_virtbus_drv(drv)	(container_of((drv), struct virtbus_driver, \
> +				 driver))

Why are these in a public .h file?

> +
> +extern struct bus_type virtual_bus_type;
> +extern struct device virtual_bus;

Again, why exported?

> +
> +int virtbus_dev_add(struct virtbus_device *vdev);
> +void virtbus_dev_del(struct virtbus_device *vdev);
> +struct virtbus_device *virtbus_dev_alloc(const char *name, void *devdata);
> +int virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner);
> +void virtbus_drv_unregister(struct virtbus_driver *vdrv);
> +
> +int virtbus_for_each_dev(void *data, int (*fn)(struct device *, void *));
> +int virtbus_for_each_drv(void *data, int(*fn)(struct device_driver *, void *));

pick a coding style and stick with it please...

thanks,

greg k-h
