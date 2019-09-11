Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E9EAF45C
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfIKCjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:39:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfIKCjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:39:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A76076543;
        Wed, 11 Sep 2019 02:38:59 +0000 (UTC)
Received: from [10.72.12.57] (ovpn-12-57.pek2.redhat.com [10.72.12.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6119C60BE1;
        Wed, 11 Sep 2019 02:38:41 +0000 (UTC)
Subject: Re: [RFC PATCH 3/4] virtio: introudce a mdev based transport
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com>
 <20190910055744-mutt-send-email-mst@kernel.org>
 <572ffc34-3081-8503-d3cc-192edc9b5311@redhat.com>
 <20190910094807-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <390647ae-0a53-5f2b-ccb0-28ed657636e6@redhat.com>
Date:   Wed, 11 Sep 2019 10:38:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910094807-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 11 Sep 2019 02:38:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/10 下午9:52, Michael S. Tsirkin wrote:
> On Tue, Sep 10, 2019 at 09:13:02PM +0800, Jason Wang wrote:
>> On 2019/9/10 下午6:01, Michael S. Tsirkin wrote:
>>>> +#ifndef _LINUX_VIRTIO_MDEV_H
>>>> +#define _LINUX_VIRTIO_MDEV_H
>>>> +
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/vringh.h>
>>>> +#include <uapi/linux/virtio_net.h>
>>>> +
>>>> +/*
>>>> + * Ioctls
>>>> + */
>>> Pls add a bit more content here. It's redundant to state these
>>> are ioctls. Much better to document what does each one do.
>>
>> Ok.
>>
>>
>>>> +
>>>> +struct virtio_mdev_callback {
>>>> +	irqreturn_t (*callback)(void *);
>>>> +	void *private;
>>>> +};
>>>> +
>>>> +#define VIRTIO_MDEV 0xAF
>>>> +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
>>>> +					 struct virtio_mdev_callback)
>>>> +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
>>>> +					struct virtio_mdev_callback)
>>> Function pointer in an ioctl parameter? How does this ever make sense?
>>
>> I admit this is hacky (casting).
>>
>>
>>> And can't we use a couple of registers for this, and avoid ioctls?
>>
>> Yes, how about something like interrupt numbers for each virtqueue and
>> config?
> Should we just reuse VIRTIO_PCI_COMMON_Q_XXX then?


You mean something like VIRTIO_PCI_COMMON_Q_MSIX? Then it becomes a PCI 
transport in fact. And using either MSIX or irq number is actually 
another layer of indirection. So I think we can just write callback 
function and parameter through registers.


>
>
>>>> +
>>>> +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
>>>> +
>>>> +/*
>>>> + * Control registers
>>>> + */
>>>> +
>>>> +/* Magic value ("virt" string) - Read Only */
>>>> +#define VIRTIO_MDEV_MAGIC_VALUE		0x000
>>>> +
>>>> +/* Virtio device version - Read Only */
>>>> +#define VIRTIO_MDEV_VERSION		0x004
>>>> +
>>>> +/* Virtio device ID - Read Only */
>>>> +#define VIRTIO_MDEV_DEVICE_ID		0x008
>>>> +
>>>> +/* Virtio vendor ID - Read Only */
>>>> +#define VIRTIO_MDEV_VENDOR_ID		0x00c
>>>> +
>>>> +/* Bitmask of the features supported by the device (host)
>>>> + * (32 bits per set) - Read Only */
>>>> +#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
>>>> +
>>>> +/* Device (host) features set selector - Write Only */
>>>> +#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
>>>> +
>>>> +/* Bitmask of features activated by the driver (guest)
>>>> + * (32 bits per set) - Write Only */
>>>> +#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
>>>> +
>>>> +/* Activated features set selector - Write Only */
>>>> +#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
>>>> +
>>>> +/* Queue selector - Write Only */
>>>> +#define VIRTIO_MDEV_QUEUE_SEL		0x030
>>>> +
>>>> +/* Maximum size of the currently selected queue - Read Only */
>>>> +#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
>>>> +
>>>> +/* Queue size for the currently selected queue - Write Only */
>>>> +#define VIRTIO_MDEV_QUEUE_NUM		0x038
>>>> +
>>>> +/* Ready bit for the currently selected queue - Read Write */
>>>> +#define VIRTIO_MDEV_QUEUE_READY		0x044
>>> Is this same as started?
>>
>> Do you mean "status"?
> I really meant "enabled", didn't remember the correct name.
> As in:  VIRTIO_PCI_COMMON_Q_ENABLE


Yes, it's the same.

Thanks


>
>>>> +
>>>> +/* Alignment of virtqueue - Read Only */
>>>> +#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
>>>> +
>>>> +/* Queue notifier - Write Only */
>>>> +#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
>>>> +
>>>> +/* Device status register - Read Write */
>>>> +#define VIRTIO_MDEV_STATUS		0x060
>>>> +
>>>> +/* Selected queue's Descriptor Table address, 64 bits in two halves */
>>>> +#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
>>>> +#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
>>>> +
>>>> +/* Selected queue's Available Ring address, 64 bits in two halves */
>>>> +#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
>>>> +#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
>>>> +
>>>> +/* Selected queue's Used Ring address, 64 bits in two halves */
>>>> +#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
>>>> +#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
>>>> +
>>>> +/* Configuration atomicity value */
>>>> +#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
>>>> +
>>>> +/* The config space is defined by each driver as
>>>> + * the per-driver configuration space - Read Write */
>>>> +#define VIRTIO_MDEV_CONFIG		0x100
>>> Mixing device and generic config space is what virtio pci did,
>>> caused lots of problems with extensions.
>>> It would be better to reserve much more space.
>>
>> I see, will do this.
>>
>> Thanks
>>
>>
>>>
>>>> +
>>>> +#endif
>>>> +
>>>> +
>>>> +/* Ready bit for the currently selected queue - Read Write */
>>>> -- 
>>>> 2.19.1
