Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C012B10124E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKSD6m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Nov 2019 22:58:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:14881 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfKSD6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 22:58:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 19:58:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,322,1569308400"; 
   d="scan'208";a="215441102"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga001.fm.intel.com with ESMTP; 18 Nov 2019 19:58:40 -0800
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 18 Nov 2019 19:58:39 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.236]) with mapi id 14.03.0439.000;
 Mon, 18 Nov 2019 19:58:39 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATHptCZx1o750+cmj+dZwSi7aeNZheAgAPN0JA=
Date:   Tue, 19 Nov 2019 03:58:38 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B301493@ORSMSX101.amr.corp.intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Parav Pandit <parav@mellanox.com>
> Sent: Friday, November 15, 2019 3:26 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> gregkh@linuxfoundation.org
> Cc: Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
> 
> Hi Jeff,
> 
> > From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Sent: Friday, November 15, 2019 4:34 PM
> >
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus, virtbus_device
> > and virtbus_driver.  The virtual bus is a software based bus intended
> > to support lightweight devices and drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > The primary purpose of the virual bus is to provide matching services
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> >
> It is fundamental to know that rdma device created by virtbus_driver will be
> anchored to which bus for an non abusive use.
> virtbus or parent pci bus?
> I asked this question in v1 version of this patch.

The model we will be using is a PCI LAN driver that will allocate and
register a virtbus_device.  The virtbus_device will be anchored to the virtual
bus, not the PCI bus.

The virtbus does not have a requirement that elements registering with it
have any association with another outside bus or device.

RDMA is not attached to any bus when it's init is called.  The virtbus_driver
that it will create will be attached to the virtual bus.

The RDMA driver will register a virtbus_driver object.  Its probe will
accept the data pointer from the virtbus_device that the PCI LAN driver
created.

> 
> Also since it says - 'to support lightweight devices', documenting that
> information is critical to avoid ambiguity.
> 
> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1]
> whatever we want to call it, it overlaps with your comment about 'to support
> lightweight devices'.
> Hence let's make things crystal clear weather the purpose is 'only matching
> service' or also 'lightweight devices'.
> If this is only matching service, lets please remove lightweight devices part..
> 

This is only for matching services for kernel objects, I will work on
phrasing this clearer.

> You additionally need modpost support for id table integration to modifo,
> modprobe and other tools.
> A small patch similar to this one [2] is needed.
> Please include in the series.
> 

modpost support added - thanks for that catch!

> [..]
> 
> > +static const
> > +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> > +					struct virtbus_device *vdev)
> > +{
> > +	while (id->name[0]) {
> > +		if (!strcmp(vdev->name, id->name)) {
> > +			vdev->dev_id = id;
> Matching function shouldn't be modifying the id.

This is not the main id of the virtbus_device.  This is copying the
element in the driver id_table that was matched into the virtbus_device
struct, so that when the virtbus_device struct is passed to the
virtbus_driver's probe, it can access the correct driver_data.

I chose a poor name for this field, I will change the name of this part of the
struct to matched_element and include a comment on what is going on here.

> 
> > +			return id;
> > +		}
> > +		id++;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +#define to_virtbus_dev(x)	(container_of((x), struct virtbus_device,
> dev))
> > +#define to_virtbus_drv(x)	(container_of((x), struct virtbus_driver, \
> > +				 driver))
> > +
> > +/**
> > + * virtbus_match - bind virtbus device to virtbus driver
> > + * @dev: device
> > + * @drv: driver
> > + *
> > + * Virtbus device IDs are always in "<name>.<instance>" format.
> We might have to change this scheme depending on the first question I
> asked in the email about device anchoring.
> 
> > +
> > +struct bus_type virtual_bus_type = {
> > +	.name		= "virtbus",
> > +	.match		= virtbus_match,
> > +	.probe		= virtbus_probe,
> > +	.remove		= virtbus_remove,
> > +	.shutdown	= virtbus_shutdown,
> > +	.suspend	= virtbus_suspend,
> > +	.resume		= virtbus_resume,
> > +};
> Drop the tab alignment.
> 

Dropped :)

> > +
> > +/**
> > + * virtbus_dev_register - add a virtual bus device
> > + * @vdev: virtual bus device to add
> > + */
> > +int virtbus_dev_register(struct virtbus_device *vdev) {
> > +	int ret;
> > +
> > +	if (!vdev)
> > +		return -EINVAL;
> No need for this check.
> Driver shouldn't be called null device registration.

check removed.

> 
> > +
> > +	device_initialize(&vdev->dev);
> > +
> > +	vdev->dev.bus = &virtual_bus_type;
> > +	/* All device IDs are automatically allocated */
> > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> This is bug, once device_initialize() is done, it must do put_device() and
> follow the release sequence.
> 

changed to use put_device().

> > +	vdev->id = ret;
> > +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
> > +
> > +	dev_dbg(&vdev->dev, "Registering VirtBus device '%s'\n",
> I think 'virtbus' naming is better instead of 'VirtBus' all over. We don't do "Pci'
> in prints etc.
> 

Changed to virtbus.

> > +		dev_name(&vdev->dev));
> > +
> > +	ret = device_add(&vdev->dev);
> > +	if (!ret)
> > +		return ret;
> > +
> > +	/* Error adding virtual device */
> > +	device_del(&vdev->dev);
> > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > +	vdev->id = VIRTBUS_DEVID_NONE;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_dev_register);
> > +
> > +/**
> > + * virtbus_dev_unregister - remove a virtual bus device
> > + * vdev: virtual bus device we are removing  */ void
> > +virtbus_dev_unregister(struct virtbus_device *vdev) {
> > +	if (!IS_ERR_OR_NULL(vdev)) {
> > +		device_del(&vdev->dev);
> > +
> > +		ida_simple_remove(&virtbus_dev_ida, vdev->id);
> I believe this should be done in the release() because above device_del()
> may not ensure that all references to the devices are dropped.
> 

ida_release moved to .release() function.

> > +		vdev->id = VIRTBUS_DEVID_NONE;
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_dev_unregister);
> > +
> > +struct virtbus_object {
> > +	struct virtbus_device vdev;
> > +	char name[];
> > +};
> > +
> This shouldn't be needed once. More below.
> 
> > +/**
> > + * virtbus_dev_release - Destroy a virtbus device
> > + * @vdev: virtual device to release
> > + *
> > + * Note that the vdev->data which is separately allocated needs to be
> > + * separately freed on it own.
> > + */
> > +static void virtbus_dev_release(struct device *dev) {
> > +	struct virtbus_object *vo = container_of(dev, struct virtbus_object,
> > +						 vdev.dev);
> > +
> > +	kfree(vo);
> > +}
> > +
> > +/**
> > + * virtbus_dev_alloc - allocate a virtbus device
> > + * @name: name to associate with the vdev
> > + * @data: pointer to data to be associated with this device  */
> > +struct virtbus_device *virtbus_dev_alloc(const char *name, void *data) {
> > +	struct virtbus_object *vo;
> > +
> Data should not be used.
> Caller needs to give a size of the object to allocate.
> I discussed the example in detail with Jason in v1 of this patch. Please refer in
> that email.
> It should be something like this.
> 
> /* size = sizeof(struct i40_virtbus_dev), and it is the first member */
> virtbus_dev_alloc(size)
> {
> 	[..]
> }
> 
> struct i40_virtbus_dev {
> 	struct virbus_dev virtdev;
> 	/*... more fields that you want to share with other driver and to use
> in probe() */ };
> 
> irdma_probe(..)
> {
> 	struct i40_virtbus_dev dev = container_of(dev, struct
> i40_virtbus_dev, dev); }
> 
> [..]
> 
> > diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
> > new file mode 100644 index 000000000000..b6f2406180f8
> > --- /dev/null
> > +++ b/include/linux/virtual_bus.h
> > @@ -0,0 +1,55 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * virtual_bus.h - lightweight software bus
> > + *
> > + * Copyright (c) 2019-20 Intel Corporation
> > + *
> > + * Please see Documentation/driver-api/virtual_bus.rst for more
> > +information  */
> > +
> > +#ifndef _VIRTUAL_BUS_H_
> > +#define _VIRTUAL_BUS_H_
> > +
> > +#include <linux/device.h>
> > +
> > +#define VIRTBUS_DEVID_NONE	(-1)
> > +#define VIRTBUS_NAME_SIZE	20
> > +
> > +struct virtbus_dev_id {
> > +	char name[VIRTBUS_NAME_SIZE];
> > +	u64 driver_data;
> > +};
> > +
> > +struct virtbus_device {
> > +	const char			*name;
> > +	int				id;
> > +	const struct virtbus_dev_id	*dev_id;
> > +	struct device			dev;
> Drop the tab based alignment and just please follow format of virtbus_driver
> you did below.
> > +	void				*data;
> Please drop data. we need only wrapper API virtbus_get/set_drvdata().
> > +};
> 

Data dropped in favor of the device creator using a struct to contain the
virtbus_device and data field, and the virtbus_driver using a container_of()
to get to the data after receiving the virtbus_device struct in probe.

Function virtbus_dev_alloc removed from patch (since the device creator will
need to allocate for the container object).

> [1] https://lore.kernel.org/linux-rdma/20191107160448.20962-1-
> parav@mellanox.com/
> [2] https://lore.kernel.org/patchwork/patch/1046991/


Thanks for the feedback!

-Dave E
