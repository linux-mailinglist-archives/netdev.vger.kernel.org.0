Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD7DC735
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439527AbfJROU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393962AbfJROU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 10:20:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 778C7C057F2C;
        Fri, 18 Oct 2019 14:20:26 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45C8519D70;
        Fri, 18 Oct 2019 14:20:10 +0000 (UTC)
Date:   Fri, 18 Oct 2019 16:20:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V4 5/6] virtio: introduce a mdev based transport
Message-ID: <20191018162007.31631039.cohuck@redhat.com>
In-Reply-To: <20191017104836.32464-6-jasowang@redhat.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
        <20191017104836.32464-6-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 18 Oct 2019 14:20:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 18:48:35 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch introduces a new mdev transport for virtio. This is used to
> use kernel virtio driver to drive the mediated device that is capable
> of populating virtqueue directly.
> 
> A new virtio-mdev driver will be registered to the mdev bus, when a
> new virtio-mdev device is probed, it will register the device with
> mdev based config ops. This means it is a software transport between
> mdev driver and mdev device. The transport was implemented through
> device specific ops which is a part of mdev_parent_ops now.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/Kconfig       |   7 +
>  drivers/virtio/Makefile      |   1 +
>  drivers/virtio/virtio_mdev.c | 409 +++++++++++++++++++++++++++++++++++
>  3 files changed, 417 insertions(+)

(...)

> +static int virtio_mdev_probe(struct device *dev)
> +{
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +	struct virtio_mdev_device *vm_dev;
> +	int rc;
> +
> +	vm_dev = devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
> +	if (!vm_dev)
> +		return -ENOMEM;
> +
> +	vm_dev->vdev.dev.parent = dev;
> +	vm_dev->vdev.dev.release = virtio_mdev_release_dev;
> +	vm_dev->vdev.config = &virtio_mdev_config_ops;
> +	vm_dev->mdev = mdev;
> +	INIT_LIST_HEAD(&vm_dev->virtqueues);
> +	spin_lock_init(&vm_dev->lock);
> +
> +	vm_dev->version = ops->get_mdev_features(mdev);
> +	if (vm_dev->version != VIRTIO_MDEV_F_VERSION_1) {
> +		dev_err(dev, "VIRTIO_MDEV_F_VERSION_1 is mandatory\n");
> +		return -ENXIO;
> +	}

Hm, so how is that mdev features interface supposed to work? If
VIRTIO_MDEV_F_VERSION_1 is a bit, I would expect this code to test for
its presence, and not for identity.

What will happen if we come up with a version 2? If this is backwards
compatible, will both version 2 and version 1 be set?

> +
> +	vm_dev->vdev.id.device = ops->get_device_id(mdev);
> +	if (vm_dev->vdev.id.device == 0)
> +		return -ENODEV;
> +
> +	vm_dev->vdev.id.vendor = ops->get_vendor_id(mdev);
> +	rc = register_virtio_device(&vm_dev->vdev);
> +	if (rc)
> +		put_device(dev);
> +	else
> +		dev_set_drvdata(dev, vm_dev);
> +
> +	return rc;
> +}

(...)
