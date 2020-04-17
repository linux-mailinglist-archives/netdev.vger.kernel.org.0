Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55CB1AE595
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgDQTOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:14:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:40286 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgDQTOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:14:05 -0400
IronPort-SDR: uG3hjsb7ZNEe2bWb12c8nFRkpPAaW2aqT5tZ0F7Lkl56jYI4Wpm/vs5gTmmDIuS/DBvgoFciht
 7R9PddjkLoag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 12:14:02 -0700
IronPort-SDR: 4zaRhb4l6a4+6r5YWFzuK8Fewm9LHjolI12s1JTqyc2WsVke4vgxlvCprvOITm6TgxRnGWHFQZ
 pCrsFmX08C1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="454827844"
Received: from selinabe-mobl.amr.corp.intel.com (HELO [10.254.28.98]) ([10.254.28.98])
  by fmsmga005.fm.intel.com with ESMTP; 17 Apr 2020 12:14:00 -0700
Subject: Re: [net-next 1/9] Implementation of Virtual Bus
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <c5197d2f-3840-d304-6b09-d334cae81294@linux.intel.com>
Date:   Fri, 17 Apr 2020 14:14:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/20 12:10 PM, Jeff Kirsher wrote:
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

FWIW we are planning to use this Virtual Bus to support multiple clients 
for the Sound Open Firmware driver, instead of using platform devices as 
suggested by GregKH.

Minor nit-picks below, please feel free to add my tag for patch 1/9:

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

> +config VIRTUAL_BUS
> +       tristate "Software based Virtual Bus"
> +       help
> +         Provides a software bus for virtbus_devices to be added to it
> +         and virtbus_drivers to be registered on it.  It matches driver
> +         and device based on id and calls the driver's pobe routine.

typo: probe

[...]

> diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
> new file mode 100644
> index 000000000000..fb14cca40eea
> --- /dev/null
> +++ b/drivers/bus/virtual_bus.c
> @@ -0,0 +1,270 @@
> +// SPDX-License-Identifier: GPL-2.0

did you mean GPL-2.0-only, as done for virtual-bus.h?

> +/*
> + * virtual_bus.c - lightweight software based bus for virtual devices
> + *
> + * Copyright (c) 2019-20 Intel Corporation

I think the recommendation is to use 2019-2020 explicitly.

> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for
> + * more information
> + */
> +
> +#include <linux/string.h>
> +#include <linux/virtual_bus.h>
> +#include <linux/of_irq.h>

is of_irq.h required?

> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pm_domain.h>
> +#include <linux/acpi.h>

is there any ACPI dependency?

> +#include <linux/device.h>

alphabetical order for the headers maybe?

[...]

> +int virtbus_register_device(struct virtbus_device *vdev)
> +{
> +	int ret;
> +
> +	/* Do this first so that all error paths perform a put_device */
> +	device_initialize(&vdev->dev);
> +
> +	if (!vdev->release) {
> +		ret = -EINVAL;
> +		dev_err(&vdev->dev, "virtbus_device MUST have a .release callback that does something.\n");
> +		goto device_pre_err;
> +	}
> +
> +	/* All device IDs are automatically allocated */
> +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> +		goto device_pre_err;
> +	}
> +
> +

extra line

> +	vdev->dev.bus = &virtual_bus_type;
> +	vdev->dev.release = virtbus_release_device;
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
> +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> +
> +device_pre_err:
> +	dev_err(&vdev->dev, "Add device to virtbus failed!: %d\n", ret);
> +	put_device(&vdev->dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtbus_register_device);
> +
> +/**
> + * virtbus_unregister_device - remove a virtual bus device
> + * @vdev: virtual bus device we are removing
> + */
> +void virtbus_unregister_device(struct virtbus_device *vdev)
> +{
> +	device_del(&vdev->dev);
> +	put_device(&vdev->dev);

looks like device_unregister(&vdev->dev) ?

> +}
> +EXPORT_SYMBOL_GPL(virtbus_unregister_device);
> +
> +static int virtbus_probe_driver(struct device *_dev)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +	int ret;
> +
> +	ret = dev_pm_domain_attach(_dev, true);
> +	if (ret) {
> +		dev_warn(_dev, "Failed to attatch to PM Domain : %d\n", ret);

typo: attach

[...]

> diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
> new file mode 100644
> index 000000000000..4df06178e72f
> --- /dev/null
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-20 Intel Corporation

2019-2020?
