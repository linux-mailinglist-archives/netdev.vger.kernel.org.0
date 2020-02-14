Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002B415F75F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389595AbgBNUCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389578AbgBNUCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 15:02:46 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32545206D7;
        Fri, 14 Feb 2020 20:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710565;
        bh=qiSX8QFKcSeTp4mmGvE+BSPkGtpXSQaCqLDWDWB7McM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NYwDAVoKZ3IC2YQpshcazJxfIRzOcoWPWj3Va9jRpnKaj2hOJDOTRDEPHhCqd7Vga
         n0PQSnc33F7ocY7P5oLV3ZE1+SAnxqpXlJT/YRon34mhklmOptIVr/JE11B0de1u2c
         xSKH1II96Hckq4lMYc0yONdG6j9mdYawzoiCvTpo=
Date:   Fri, 14 Feb 2020 09:02:40 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Message-ID: <20200214170240.GA4034785@kroah.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 11:14:00AM -0800, Jeff Kirsher wrote:
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
> 
> Kconfig and Makefile alterations are included
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

This looks a lot better, and is more of what I was thinking.  Some minor
comments below:

> +/**
> + * virtbus_dev_register - add a virtual bus device
> + * @vdev: virtual bus device to add
> + */
> +int virtbus_dev_register(struct virtbus_device *vdev)
> +{
> +	int ret;
> +
> +	if (!vdev->release) {
> +		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");

"virtbus_device MUST have a .release callback that does something!\n" 

> +		return -EINVAL;
> +	}
> +
> +	device_initialize(&vdev->dev);
> +
> +	vdev->dev.bus = &virtual_bus_type;
> +	vdev->dev.release = virtbus_dev_release;
> +	/* All device IDs are automatically allocated */
> +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> +		put_device(&vdev->dev);

If you allocate the number before device_initialize(), no need to call
put_device().  Just a minor thing, no big deal.

> +		return ret;
> +	}
> +
> +	vdev->id = ret;
> +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
> +
> +	dev_dbg(&vdev->dev, "Registering virtbus device '%s'\n",
> +		dev_name(&vdev->dev));
> +
> +	ret = device_add(&vdev->dev);
> +	if (ret)
> +		goto device_add_err;
> +
> +	return 0;
> +
> +device_add_err:
> +	dev_err(&vdev->dev, "Add device to virtbus failed!\n");

Print the return error here too?

> +	put_device(&vdev->dev);
> +	ida_simple_remove(&virtbus_dev_ida, vdev->id);

You need to do this before put_device().

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_register);
> +


> --- /dev/null
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,57 @@
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
> +struct virtbus_device {
> +	struct device dev;
> +	const char *name;
> +	void (*release)(struct virtbus_device *);
> +	int id;
> +	const struct virtbus_dev_id *matched_element;
> +};

Any reason you need to make "struct virtbus_device" a public structure
at all?  Why not just make it private and have the release function
pointer be passed as part of the register function?  That will keep
people from poking around in here.

> +
> +/* The memory for the table is expected to remain allocated for the duration
> + * of the pairing between driver and device.  The pointer for the matching
> + * element will be copied to the matched_element field of the virtbus_device.

I don't understand this last sentance, what are you trying to say?  We
save off a pointer to the element, so it better not go away, is that
what you mean?  Why would this happen?

> + */
> +struct virtbus_driver {
> +	int (*probe)(struct virtbus_device *);
> +	int (*remove)(struct virtbus_device *);
> +	void (*shutdown)(struct virtbus_device *);
> +	int (*suspend)(struct virtbus_device *, pm_message_t);
> +	int (*resume)(struct virtbus_device *);

Can all of these be const pointers such that we will not change them?

> +	struct device_driver driver;
> +	const struct virtbus_dev_id *id_table;
> +};

thanks,

greg k-h
