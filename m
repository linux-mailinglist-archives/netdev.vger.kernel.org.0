Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B339AF49B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 05:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfIKDLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 23:11:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:27145 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfIKDLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 23:11:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 20:11:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,491,1559545200"; 
   d="scan'208";a="268616138"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.71])
  by orsmga001.jf.intel.com with ESMTP; 10 Sep 2019 20:11:19 -0700
Date:   Wed, 11 Sep 2019 11:08:51 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com
Subject: Re: [RFC PATCH 3/4] virtio: introudce a mdev based transport
Message-ID: <20190911030851.GA27733@___>
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com>
 <20190911014726.GA14798@___>
 <8428eec1-b53c-9efc-1260-4e5ce2651461@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8428eec1-b53c-9efc-1260-4e5ce2651461@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:52:03AM +0800, Jason Wang wrote:
> On 2019/9/11 上午9:47, Tiwei Bie wrote:
> > On Tue, Sep 10, 2019 at 04:19:34PM +0800, Jason Wang wrote:
> > > This path introduces a new mdev transport for virtio. This is used to
> > > use kernel virtio driver to drive the mediated device that is capable
> > > of populating virtqueue directly.
> > > 
> > > A new virtio-mdev driver will be registered to the mdev bus, when a
> > > new virtio-mdev device is probed, it will register the device with
> > > mdev based config ops. This means, unlike the exist hardware
> > > transport, this is a software transport between mdev driver and mdev
> > > device. The transport was implemented through:
> > > 
> > > - configuration access was implemented through parent_ops->read()/write()
> > > - vq/config callback was implemented through parent_ops->ioctl()
> > > 
> > > This transport is derived from virtio MMIO protocol and was wrote for
> > > kernel driver. But for the transport itself, but the design goal is to
> > > be generic enough to support userspace driver (this part will be added
> > > in the future).
> > > 
> > > Note:
> > > - current mdev assume all the parameter of parent_ops was from
> > >    userspace. This prevents us from implementing the kernel mdev
> > >    driver. For a quick POC, this patch just abuse those parameter and
> > >    assume the mdev device implementation will treat them as kernel
> > >    pointer. This should be addressed in the formal series by extending
> > >    mdev_parent_ops.
> > > - for a quick POC, I just drive the transport from MMIO, I'm pretty
> > >    there's lot of optimization space for this.
> > > 
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >   drivers/vfio/mdev/Kconfig        |   7 +
> > >   drivers/vfio/mdev/Makefile       |   1 +
> > >   drivers/vfio/mdev/virtio_mdev.c  | 500 +++++++++++++++++++++++++++++++
> > >   include/uapi/linux/virtio_mdev.h | 131 ++++++++
> > >   4 files changed, 639 insertions(+)
> > >   create mode 100644 drivers/vfio/mdev/virtio_mdev.c
> > >   create mode 100644 include/uapi/linux/virtio_mdev.h
> > > 
> > [...]
> > > diff --git a/include/uapi/linux/virtio_mdev.h b/include/uapi/linux/virtio_mdev.h
> > > new file mode 100644
> > > index 000000000000..8040de6b960a
> > > --- /dev/null
> > > +++ b/include/uapi/linux/virtio_mdev.h
> > > @@ -0,0 +1,131 @@
> > > +/*
> > > + * Virtio mediated device driver
> > > + *
> > > + * Copyright 2019, Red Hat Corp.
> > > + *
> > > + * Based on Virtio MMIO driver by ARM Ltd, copyright ARM Ltd. 2011
> > > + *
> > > + * This header is BSD licensed so anyone can use the definitions to implement
> > > + * compatible drivers/servers.
> > > + *
> > > + * Redistribution and use in source and binary forms, with or without
> > > + * modification, are permitted provided that the following conditions
> > > + * are met:
> > > + * 1. Redistributions of source code must retain the above copyright
> > > + *    notice, this list of conditions and the following disclaimer.
> > > + * 2. Redistributions in binary form must reproduce the above copyright
> > > + *    notice, this list of conditions and the following disclaimer in the
> > > + *    documentation and/or other materials provided with the distribution.
> > > + * 3. Neither the name of IBM nor the names of its contributors
> > > + *    may be used to endorse or promote products derived from this software
> > > + *    without specific prior written permission.
> > > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
> > > + * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> > > + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> > > + * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
> > > + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> > > + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> > > + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> > > + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> > > + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> > > + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> > > + * SUCH DAMAGE.
> > > + */
> > > +#ifndef _LINUX_VIRTIO_MDEV_H
> > > +#define _LINUX_VIRTIO_MDEV_H
> > > +
> > > +#include <linux/interrupt.h>
> > > +#include <linux/vringh.h>
> > > +#include <uapi/linux/virtio_net.h>
> > > +
> > > +/*
> > > + * Ioctls
> > > + */
> > > +
> > > +struct virtio_mdev_callback {
> > > +	irqreturn_t (*callback)(void *);
> > > +	void *private;
> > > +};
> > > +
> > > +#define VIRTIO_MDEV 0xAF
> > > +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
> > > +					 struct virtio_mdev_callback)
> > > +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
> > > +					struct virtio_mdev_callback)
> > > +
> > > +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> > > +
> > > +/*
> > > + * Control registers
> > > + */
> > > +
> > > +/* Magic value ("virt" string) - Read Only */
> > > +#define VIRTIO_MDEV_MAGIC_VALUE		0x000
> > > +
> > > +/* Virtio device version - Read Only */
> > > +#define VIRTIO_MDEV_VERSION		0x004
> > > +
> > > +/* Virtio device ID - Read Only */
> > > +#define VIRTIO_MDEV_DEVICE_ID		0x008
> > > +
> > > +/* Virtio vendor ID - Read Only */
> > > +#define VIRTIO_MDEV_VENDOR_ID		0x00c
> > > +
> > > +/* Bitmask of the features supported by the device (host)
> > > + * (32 bits per set) - Read Only */
> > > +#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
> > > +
> > > +/* Device (host) features set selector - Write Only */
> > > +#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
> > > +
> > > +/* Bitmask of features activated by the driver (guest)
> > > + * (32 bits per set) - Write Only */
> > > +#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
> > > +
> > > +/* Activated features set selector - Write Only */
> > > +#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
> > > +
> > > +/* Queue selector - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_SEL		0x030
> > > +
> > > +/* Maximum size of the currently selected queue - Read Only */
> > > +#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
> > > +
> > > +/* Queue size for the currently selected queue - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_NUM		0x038
> > > +
> > > +/* Ready bit for the currently selected queue - Read Write */
> > > +#define VIRTIO_MDEV_QUEUE_READY		0x044
> > > +
> > > +/* Alignment of virtqueue - Read Only */
> > > +#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
> > > +
> > > +/* Queue notifier - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
> > > +
> > > +/* Device status register - Read Write */
> > > +#define VIRTIO_MDEV_STATUS		0x060
> > > +
> > > +/* Selected queue's Descriptor Table address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
> > > +#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
> > > +
> > > +/* Selected queue's Available Ring address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
> > > +#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
> > > +
> > > +/* Selected queue's Used Ring address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
> > > +#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
> > > +
> > > +/* Configuration atomicity value */
> > > +#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
> > > +
> > > +/* The config space is defined by each driver as
> > > + * the per-driver configuration space - Read Write */
> > > +#define VIRTIO_MDEV_CONFIG		0x100
> > IIUC, we can use above registers with virtio-mdev parent's
> > read()/write() to access the mdev device from kernel driver.
> > As you suggested, it's a choice to build vhost-mdev on top
> > of this abstraction as well. But virtio is the frontend
> > device which lacks some vhost backend features, e.g. get
> > vring base, set vring base, negotiate vhost features, etc.
> > So I'm wondering, does it make sense to reserve some space
> > for vhost-mdev in kernel to do vhost backend specific setups?
> > Or do you have any other thoughts?
> 
> 
> Good point. It's just a quick POC, I plan to add vhost features in the next
> release:
> 
> 1) set/get virtqueue state (e.g vring base)
> 2) dirty page tracking
> 3) for vhost features, if you mean _F_LOG_ALL, it could be done by 2), for
> IOTLB, it requires more thought on the API since current IOTLB API is no
> implemented through ioctl ...
> 
> 
> > 
> > Besides, I'm also wondering, what's the purpose of making
> > above registers part of UAPI?
> 
> 
> Sorry if it brings confusion. If we do vhost-mdev on top of this, there's no
> need for this to go for UAPI.
> 
> 
> > And if we make them part
> > of UAPI, do we also need to make them part of virtio spec?
> 
> 
> Yes, but I do not think we should put it into UAPI. Technically, userspace
> can use this transport as well with some modification on the interrupt part,
> e.g using eventfd. But is there any value for doing this instead of vhost?

Yeah, I agree. As we already have vhost, I don't see the value
to make virtio become "virtio + vhost".

Thanks,
Tiwei
