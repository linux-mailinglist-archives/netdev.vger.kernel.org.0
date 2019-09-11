Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F82DAF489
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfIKCwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfIKCwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:52:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC17610C0933;
        Wed, 11 Sep 2019 02:52:19 +0000 (UTC)
Received: from [10.72.12.57] (ovpn-12-57.pek2.redhat.com [10.72.12.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80C7B4518;
        Wed, 11 Sep 2019 02:52:05 +0000 (UTC)
Subject: Re: [RFC PATCH 3/4] virtio: introudce a mdev based transport
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com> <20190911014726.GA14798@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8428eec1-b53c-9efc-1260-4e5ce2651461@redhat.com>
Date:   Wed, 11 Sep 2019 10:52:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911014726.GA14798@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 11 Sep 2019 02:52:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/11 上午9:47, Tiwei Bie wrote:
> On Tue, Sep 10, 2019 at 04:19:34PM +0800, Jason Wang wrote:
>> This path introduces a new mdev transport for virtio. This is used to
>> use kernel virtio driver to drive the mediated device that is capable
>> of populating virtqueue directly.
>>
>> A new virtio-mdev driver will be registered to the mdev bus, when a
>> new virtio-mdev device is probed, it will register the device with
>> mdev based config ops. This means, unlike the exist hardware
>> transport, this is a software transport between mdev driver and mdev
>> device. The transport was implemented through:
>>
>> - configuration access was implemented through parent_ops->read()/write()
>> - vq/config callback was implemented through parent_ops->ioctl()
>>
>> This transport is derived from virtio MMIO protocol and was wrote for
>> kernel driver. But for the transport itself, but the design goal is to
>> be generic enough to support userspace driver (this part will be added
>> in the future).
>>
>> Note:
>> - current mdev assume all the parameter of parent_ops was from
>>    userspace. This prevents us from implementing the kernel mdev
>>    driver. For a quick POC, this patch just abuse those parameter and
>>    assume the mdev device implementation will treat them as kernel
>>    pointer. This should be addressed in the formal series by extending
>>    mdev_parent_ops.
>> - for a quick POC, I just drive the transport from MMIO, I'm pretty
>>    there's lot of optimization space for this.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vfio/mdev/Kconfig        |   7 +
>>   drivers/vfio/mdev/Makefile       |   1 +
>>   drivers/vfio/mdev/virtio_mdev.c  | 500 +++++++++++++++++++++++++++++++
>>   include/uapi/linux/virtio_mdev.h | 131 ++++++++
>>   4 files changed, 639 insertions(+)
>>   create mode 100644 drivers/vfio/mdev/virtio_mdev.c
>>   create mode 100644 include/uapi/linux/virtio_mdev.h
>>
> [...]
>> diff --git a/include/uapi/linux/virtio_mdev.h b/include/uapi/linux/virtio_mdev.h
>> new file mode 100644
>> index 000000000000..8040de6b960a
>> --- /dev/null
>> +++ b/include/uapi/linux/virtio_mdev.h
>> @@ -0,0 +1,131 @@
>> +/*
>> + * Virtio mediated device driver
>> + *
>> + * Copyright 2019, Red Hat Corp.
>> + *
>> + * Based on Virtio MMIO driver by ARM Ltd, copyright ARM Ltd. 2011
>> + *
>> + * This header is BSD licensed so anyone can use the definitions to implement
>> + * compatible drivers/servers.
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions
>> + * are met:
>> + * 1. Redistributions of source code must retain the above copyright
>> + *    notice, this list of conditions and the following disclaimer.
>> + * 2. Redistributions in binary form must reproduce the above copyright
>> + *    notice, this list of conditions and the following disclaimer in the
>> + *    documentation and/or other materials provided with the distribution.
>> + * 3. Neither the name of IBM nor the names of its contributors
>> + *    may be used to endorse or promote products derived from this software
>> + *    without specific prior written permission.
>> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
>> + * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
>> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
>> + * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
>> + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
>> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
>> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
>> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
>> + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
>> + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
>> + * SUCH DAMAGE.
>> + */
>> +#ifndef _LINUX_VIRTIO_MDEV_H
>> +#define _LINUX_VIRTIO_MDEV_H
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/vringh.h>
>> +#include <uapi/linux/virtio_net.h>
>> +
>> +/*
>> + * Ioctls
>> + */
>> +
>> +struct virtio_mdev_callback {
>> +	irqreturn_t (*callback)(void *);
>> +	void *private;
>> +};
>> +
>> +#define VIRTIO_MDEV 0xAF
>> +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
>> +					 struct virtio_mdev_callback)
>> +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
>> +					struct virtio_mdev_callback)
>> +
>> +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
>> +
>> +/*
>> + * Control registers
>> + */
>> +
>> +/* Magic value ("virt" string) - Read Only */
>> +#define VIRTIO_MDEV_MAGIC_VALUE		0x000
>> +
>> +/* Virtio device version - Read Only */
>> +#define VIRTIO_MDEV_VERSION		0x004
>> +
>> +/* Virtio device ID - Read Only */
>> +#define VIRTIO_MDEV_DEVICE_ID		0x008
>> +
>> +/* Virtio vendor ID - Read Only */
>> +#define VIRTIO_MDEV_VENDOR_ID		0x00c
>> +
>> +/* Bitmask of the features supported by the device (host)
>> + * (32 bits per set) - Read Only */
>> +#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
>> +
>> +/* Device (host) features set selector - Write Only */
>> +#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
>> +
>> +/* Bitmask of features activated by the driver (guest)
>> + * (32 bits per set) - Write Only */
>> +#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
>> +
>> +/* Activated features set selector - Write Only */
>> +#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
>> +
>> +/* Queue selector - Write Only */
>> +#define VIRTIO_MDEV_QUEUE_SEL		0x030
>> +
>> +/* Maximum size of the currently selected queue - Read Only */
>> +#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
>> +
>> +/* Queue size for the currently selected queue - Write Only */
>> +#define VIRTIO_MDEV_QUEUE_NUM		0x038
>> +
>> +/* Ready bit for the currently selected queue - Read Write */
>> +#define VIRTIO_MDEV_QUEUE_READY		0x044
>> +
>> +/* Alignment of virtqueue - Read Only */
>> +#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
>> +
>> +/* Queue notifier - Write Only */
>> +#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
>> +
>> +/* Device status register - Read Write */
>> +#define VIRTIO_MDEV_STATUS		0x060
>> +
>> +/* Selected queue's Descriptor Table address, 64 bits in two halves */
>> +#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
>> +#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
>> +
>> +/* Selected queue's Available Ring address, 64 bits in two halves */
>> +#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
>> +#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
>> +
>> +/* Selected queue's Used Ring address, 64 bits in two halves */
>> +#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
>> +#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
>> +
>> +/* Configuration atomicity value */
>> +#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
>> +
>> +/* The config space is defined by each driver as
>> + * the per-driver configuration space - Read Write */
>> +#define VIRTIO_MDEV_CONFIG		0x100
> IIUC, we can use above registers with virtio-mdev parent's
> read()/write() to access the mdev device from kernel driver.
> As you suggested, it's a choice to build vhost-mdev on top
> of this abstraction as well. But virtio is the frontend
> device which lacks some vhost backend features, e.g. get
> vring base, set vring base, negotiate vhost features, etc.
> So I'm wondering, does it make sense to reserve some space
> for vhost-mdev in kernel to do vhost backend specific setups?
> Or do you have any other thoughts?


Good point. It's just a quick POC, I plan to add vhost features in the 
next release:

1) set/get virtqueue state (e.g vring base)
2) dirty page tracking
3) for vhost features, if you mean _F_LOG_ALL, it could be done by 2), 
for IOTLB, it requires more thought on the API since current IOTLB API 
is no implemented through ioctl ...


>
> Besides, I'm also wondering, what's the purpose of making
> above registers part of UAPI?


Sorry if it brings confusion. If we do vhost-mdev on top of this, 
there's no need for this to go for UAPI.


> And if we make them part
> of UAPI, do we also need to make them part of virtio spec?


Yes, but I do not think we should put it into UAPI. Technically, 
userspace can use this transport as well with some modification on the 
interrupt part, e.g using eventfd. But is there any value for doing this 
instead of vhost?

Thanks


>
> Thanks!
> Tiwei
>
>> +
>> +#endif
>> +
>> +
>> +/* Ready bit for the currently selected queue - Read Write */
>> -- 
>> 2.19.1
>>
