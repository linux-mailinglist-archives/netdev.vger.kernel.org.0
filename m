Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A544D32E004
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCEDU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:20:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhCEDU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614914456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1olrY3e+TANCDEt24lStk/pDiqqxoSAT3HKHn2/2D+k=;
        b=ifDsxm7V3lGZgj4JyVzHTNVBjTzgIIIoc4Xop6glQPF+GxZ9BzSU9BgCTWHZ1VwnI35K/C
        5uNUIpj5tgxJ86vd03Y8miadCdWAVlu5Jvr9bwBFGmZPL8+6CAV2jnMqO2t6Ow6s4EpTBU
        6FYMMG4MFDKNxcs0fSfDoPbqjl22cCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-3nIW0GTAMMe6Jd3E5jg8Pg-1; Thu, 04 Mar 2021 22:20:51 -0500
X-MC-Unique: 3nIW0GTAMMe6Jd3E5jg8Pg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8505A1005D4D;
        Fri,  5 Mar 2021 03:20:49 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86D15D9C0;
        Fri,  5 Mar 2021 03:20:36 +0000 (UTC)
Subject: Re: [RFC v4 07/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-8-xieyongji@bytedance.com>
 <da57a29a-9860-f72f-36d6-252b45fe03f7@redhat.com>
 <CACycT3t=SuKL3y3PvxWjn5nhrqAMmfVmS4YWaWEcZgDe7hXmcA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <09695699-fd6a-1980-0fb4-a84caf96133d@redhat.com>
Date:   Fri, 5 Mar 2021 11:20:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3t=SuKL3y3PvxWjn5nhrqAMmfVmS4YWaWEcZgDe7hXmcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/4 4:05 下午, Yongji Xie wrote:
> On Thu, Mar 4, 2021 at 2:27 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>> This VDUSE driver enables implementing vDPA devices in userspace.
>>> Both control path and data path of vDPA devices will be able to
>>> be handled in userspace.
>>>
>>> In the control path, the VDUSE driver will make use of message
>>> mechnism to forward the config operation from vdpa bus driver
>>> to userspace. Userspace can use read()/write() to receive/reply
>>> those control messages.
>>>
>>> In the data path, VDUSE_IOTLB_GET_FD ioctl will be used to get
>>> the file descriptors referring to vDPA device's iova regions. Then
>>> userspace can use mmap() to access those iova regions. Besides,
>>> userspace can use ioctl() to inject interrupt and use the eventfd
>>> mechanism to receive virtqueue kicks.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>>>    drivers/vdpa/Kconfig                               |   10 +
>>>    drivers/vdpa/Makefile                              |    1 +
>>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
>>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1348 ++++++++++++++++++++
>>>    include/uapi/linux/vduse.h                         |  136 ++
>>>    6 files changed, 1501 insertions(+)
>>>    create mode 100644 drivers/vdpa/vdpa_user/Makefile
>>>    create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>>>    create mode 100644 include/uapi/linux/vduse.h
>>>
>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> index a4c75a28c839..71722e6f8f23 100644
>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> @@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
>>>    'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
>>>    '|'   00-7F  linux/media.h
>>>    0x80  00-1F  linux/fb.h
>>> +0x81  00-1F  linux/vduse.h
>>>    0x89  00-06  arch/x86/include/asm/sockios.h
>>>    0x89  0B-DF  linux/sockios.h
>>>    0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
>>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
>>> index ffd1e098bfd2..92f07715e3b6 100644
>>> --- a/drivers/vdpa/Kconfig
>>> +++ b/drivers/vdpa/Kconfig
>>> @@ -25,6 +25,16 @@ config VDPA_SIM_NET
>>>        help
>>>          vDPA networking device simulator which loops TX traffic back to RX.
>>>
>>> +config VDPA_USER
>>> +     tristate "VDUSE (vDPA Device in Userspace) support"
>>> +     depends on EVENTFD && MMU && HAS_DMA
>>> +     select DMA_OPS
>>> +     select VHOST_IOTLB
>>> +     select IOMMU_IOVA
>>> +     help
>>> +       With VDUSE it is possible to emulate a vDPA Device
>>> +       in a userspace program.
>>> +
>>>    config IFCVF
>>>        tristate "Intel IFC VF vDPA driver"
>>>        depends on PCI_MSI
>>> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
>>> index d160e9b63a66..66e97778ad03 100644
>>> --- a/drivers/vdpa/Makefile
>>> +++ b/drivers/vdpa/Makefile
>>> @@ -1,5 +1,6 @@
>>>    # SPDX-License-Identifier: GPL-2.0
>>>    obj-$(CONFIG_VDPA) += vdpa.o
>>>    obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
>>> +obj-$(CONFIG_VDPA_USER) += vdpa_user/
>>>    obj-$(CONFIG_IFCVF)    += ifcvf/
>>>    obj-$(CONFIG_MLX5_VDPA) += mlx5/
>>> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/Makefile
>>> new file mode 100644
>>> index 000000000000..260e0b26af99
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/Makefile
>>> @@ -0,0 +1,5 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +
>>> +vduse-y := vduse_dev.o iova_domain.o
>>> +
>>> +obj-$(CONFIG_VDPA_USER) += vduse.o
>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
>>> new file mode 100644
>>> index 000000000000..393bf99c48be
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
>>> @@ -0,0 +1,1348 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * VDUSE: vDPA Device in Userspace
>>> + *
>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
>>> + *
>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
>>> + *
>>> + */
>>> +
>>> +#include <linux/init.h>
>>> +#include <linux/module.h>
>>> +#include <linux/miscdevice.h>
>>> +#include <linux/cdev.h>
>>> +#include <linux/device.h>
>>> +#include <linux/eventfd.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/wait.h>
>>> +#include <linux/dma-map-ops.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/file.h>
>>> +#include <linux/uio.h>
>>> +#include <linux/vdpa.h>
>>> +#include <uapi/linux/vduse.h>
>>> +#include <uapi/linux/vdpa.h>
>>> +#include <uapi/linux/virtio_config.h>
>>> +#include <linux/mod_devicetable.h>
>>> +
>>> +#include "iova_domain.h"
>>> +
>>> +#define DRV_VERSION  "1.0"
>>> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
>>> +#define DRV_DESC     "vDPA Device in Userspace"
>>> +#define DRV_LICENSE  "GPL v2"
>>> +
>>> +#define VDUSE_DEV_MAX (1U << MINORBITS)
>>> +
>>> +struct vduse_virtqueue {
>>> +     u16 index;
>>> +     bool ready;
>>> +     spinlock_t kick_lock;
>>> +     spinlock_t irq_lock;
>>> +     struct eventfd_ctx *kickfd;
>>> +     struct vdpa_callback cb;
>>> +};
>>> +
>>> +struct vduse_dev;
>>> +
>>> +struct vduse_vdpa {
>>> +     struct vdpa_device vdpa;
>>> +     struct vduse_dev *dev;
>>> +};
>>> +
>>> +struct vduse_dev {
>>> +     struct vduse_vdpa *vdev;
>>> +     struct device dev;
>>> +     struct cdev cdev;
>>> +     struct vduse_virtqueue *vqs;
>>> +     struct vduse_iova_domain *domain;
>>> +     struct vhost_iotlb *iommu;
>>> +     spinlock_t iommu_lock;
>>> +     atomic_t bounce_map;
>>> +     struct mutex msg_lock;
>>> +     atomic64_t msg_unique;
>>
>> "next_request_id" should be better.
>>
> OK.
>
>>> +     wait_queue_head_t waitq;
>>> +     struct list_head send_list;
>>> +     struct list_head recv_list;
>>> +     struct list_head list;
>>> +     bool connected;
>>> +     int minor;
>>> +     u16 vq_size_max;
>>> +     u16 vq_num;
>>> +     u32 vq_align;
>>> +     u32 device_id;
>>> +     u32 vendor_id;
>>> +};
>>> +
>>> +struct vduse_dev_msg {
>>> +     struct vduse_dev_request req;
>>> +     struct vduse_dev_response resp;
>>> +     struct list_head list;
>>> +     wait_queue_head_t waitq;
>>> +     bool completed;
>>> +};
>>> +
>>> +static unsigned long max_bounce_size = (64 * 1024 * 1024);
>>> +module_param(max_bounce_size, ulong, 0444);
>>> +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
>>> +
>>> +static unsigned long max_iova_size = (128 * 1024 * 1024);
>>> +module_param(max_iova_size, ulong, 0444);
>>> +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
>>> +
>>> +static DEFINE_MUTEX(vduse_lock);
>>> +static LIST_HEAD(vduse_devs);
>>> +static DEFINE_IDA(vduse_ida);
>>> +
>>> +static dev_t vduse_major;
>>> +static struct class *vduse_class;
>>> +
>>> +static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_vdpa *vdev = container_of(vdpa, struct vduse_vdpa, vdpa);
>>> +
>>> +     return vdev->dev;
>>> +}
>>> +
>>> +static inline struct vduse_dev *dev_to_vduse(struct device *dev)
>>> +{
>>> +     struct vdpa_device *vdpa = dev_to_vdpa(dev);
>>> +
>>> +     return vdpa_to_vduse(vdpa);
>>> +}
>>> +
>>> +static struct vduse_dev_msg *vduse_find_msg(struct list_head *head,
>>> +                                         uint32_t unique)
>>> +{
>>> +     struct vduse_dev_msg *tmp, *msg = NULL;
>>> +
>>> +     list_for_each_entry(tmp, head, list) {
>>
>> Shoudl we use list_for_each_entry_safe()?
>>
> Looks like list_for_each_entry() is ok here. We will break the loop
> after deleting one node.


Right.


>
>>> +             if (tmp->req.unique == unique) {
>>> +                     msg = tmp;
>>> +                     list_del(&tmp->list);
>>> +                     break;
>>> +             }
>>> +     }
>>> +
>>> +     return msg;
>>> +}
>>> +
>>> +static struct vduse_dev_msg *vduse_dequeue_msg(struct list_head *head)
>>> +{
>>> +     struct vduse_dev_msg *msg = NULL;
>>> +
>>> +     if (!list_empty(head)) {
>>> +             msg = list_first_entry(head, struct vduse_dev_msg, list);
>>> +             list_del(&msg->list);
>>> +     }
>>> +
>>> +     return msg;
>>> +}
>>> +
>>> +static void vduse_enqueue_msg(struct list_head *head,
>>> +                           struct vduse_dev_msg *msg)
>>> +{
>>> +     list_add_tail(&msg->list, head);
>>> +}
>>> +
>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev, struct vduse_dev_msg *msg)
>>> +{
>>> +     int ret;
>>> +
>>> +     init_waitqueue_head(&msg->waitq);
>>> +     mutex_lock(&dev->msg_lock);
>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>> +     wake_up(&dev->waitq);
>>> +     mutex_unlock(&dev->msg_lock);
>>> +     ret = wait_event_interruptible(msg->waitq, msg->completed);
>>> +     mutex_lock(&dev->msg_lock);
>>> +     if (!msg->completed)
>>> +             list_del(&msg->list);
>>> +     else
>>> +             ret = msg->resp.result;
>>> +     mutex_unlock(&dev->msg_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static u64 vduse_dev_get_features(struct vduse_dev *dev)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_GET_FEATURES;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.features;
>>> +}
>>> +
>>> +static int vduse_dev_set_features(struct vduse_dev *dev, u64 features)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_FEATURES;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.features = features;
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static u8 vduse_dev_get_status(struct vduse_dev *dev)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_GET_STATUS;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.status;
>>> +}
>>> +
>>> +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_STATUS;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.status = status;
>>> +
>>> +     vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int offset,
>>> +                                     void *buf, unsigned int len)
>>
>> Btw, the ident looks odd here and other may places wherhe functions has
>> more than one line of arguments.
>>
> OK, will fix it.
>
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +     unsigned int sz;
>>> +
>>> +     while (len) {
>>> +             sz = min_t(unsigned int, len, sizeof(msg.req.config.data));
>>> +             msg.req.type = VDUSE_GET_CONFIG;
>>> +             msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +             msg.req.config.offset = offset;
>>> +             msg.req.config.len = sz;
>>> +             vduse_dev_msg_sync(dev, &msg);
>>> +             memcpy(buf, msg.resp.config.data, sz);
>>> +             buf += sz;
>>> +             offset += sz;
>>> +             len -= sz;
>>> +     }
>>> +}
>>> +
>>> +static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int offset,
>>> +                                     const void *buf, unsigned int len)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +     unsigned int sz;
>>> +
>>> +     while (len) {
>>> +             sz = min_t(unsigned int, len, sizeof(msg.req.config.data));
>>> +             msg.req.type = VDUSE_SET_CONFIG;
>>> +             msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +             msg.req.config.offset = offset;
>>> +             msg.req.config.len = sz;
>>> +             memcpy(msg.req.config.data, buf, sz);
>>> +             vduse_dev_msg_sync(dev, &msg);
>>> +             buf += sz;
>>> +             offset += sz;
>>> +             len -= sz;
>>> +     }
>>> +}
>>> +
>>> +static void vduse_dev_set_vq_num(struct vduse_dev *dev,
>>> +                             struct vduse_virtqueue *vq, u32 num)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_VQ_NUM;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_num.index = vq->index;
>>> +     msg.req.vq_num.num = num;
>>> +
>>> +     vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
>>> +                             struct vduse_virtqueue *vq, u64 desc_addr,
>>> +                             u64 driver_addr, u64 device_addr)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_VQ_ADDR;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_addr.index = vq->index;
>>> +     msg.req.vq_addr.desc_addr = desc_addr;
>>> +     msg.req.vq_addr.driver_addr = driver_addr;
>>> +     msg.req.vq_addr.device_addr = device_addr;
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
>>> +                             struct vduse_virtqueue *vq, bool ready)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_VQ_READY;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_ready.index = vq->index;
>>> +     msg.req.vq_ready.ready = ready;
>>> +
>>> +     vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
>>> +                                struct vduse_virtqueue *vq)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_GET_VQ_READY;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_ready.index = vq->index;
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg) ? false : msg.resp.vq_ready.ready;
>>> +}
>>> +
>>> +static int vduse_dev_get_vq_state(struct vduse_dev *dev,
>>> +                             struct vduse_virtqueue *vq,
>>> +                             struct vdpa_vq_state *state)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +     int ret;
>>> +
>>> +     msg.req.type = VDUSE_GET_VQ_STATE;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_state.index = vq->index;
>>> +
>>> +     ret = vduse_dev_msg_sync(dev, &msg);
>>> +     if (!ret)
>>> +             state->avail_index = msg.resp.vq_state.avail_idx;
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int vduse_dev_set_vq_state(struct vduse_dev *dev,
>>> +                             struct vduse_virtqueue *vq,
>>> +                             const struct vdpa_vq_state *state)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     msg.req.type = VDUSE_SET_VQ_STATE;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.vq_state.index = vq->index;
>>> +     msg.req.vq_state.avail_idx = state->avail_index;
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
>>> +                             u64 start, u64 last)
>>> +{
>>> +     struct vduse_dev_msg msg = { 0 };
>>> +
>>> +     if (last < start)
>>> +             return -EINVAL;
>>> +
>>> +     msg.req.type = VDUSE_UPDATE_IOTLB;
>>> +     msg.req.unique = atomic64_fetch_inc(&dev->msg_unique);
>>> +     msg.req.iova.start = start;
>>> +     msg.req.iova.last = last;
>>> +
>>> +     return vduse_dev_msg_sync(dev, &msg);
>>> +}
>>> +
>>> +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>> +{
>>> +     struct file *file = iocb->ki_filp;
>>> +     struct vduse_dev *dev = file->private_data;
>>> +     struct vduse_dev_msg *msg;
>>> +     int size = sizeof(struct vduse_dev_request);
>>> +     ssize_t ret = 0;
>>> +
>>> +     if (iov_iter_count(to) < size)
>>> +             return 0;
>>> +
>>> +     mutex_lock(&dev->msg_lock);
>>> +     while (1) {
>>> +             msg = vduse_dequeue_msg(&dev->send_list);
>>> +             if (msg)
>>> +                     break;
>>> +
>>> +             ret = -EAGAIN;
>>> +             if (file->f_flags & O_NONBLOCK)
>>> +                     goto unlock;
>>> +
>>> +             mutex_unlock(&dev->msg_lock);
>>> +             ret = wait_event_interruptible_exclusive(dev->waitq,
>>> +                                     !list_empty(&dev->send_list));
>>> +             if (ret)
>>> +                     return ret;
>>> +
>>> +             mutex_lock(&dev->msg_lock);
>>> +     }
>>> +     ret = copy_to_iter(&msg->req, size, to);
>>> +     if (ret != size) {
>>> +             ret = -EFAULT;
>>> +             vduse_enqueue_msg(&dev->send_list, msg);
>>> +             goto unlock;
>>> +     }
>>> +     vduse_enqueue_msg(&dev->recv_list, msg);
>>> +unlock:
>>> +     mutex_unlock(&dev->msg_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static ssize_t vduse_dev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>> +{
>>> +     struct file *file = iocb->ki_filp;
>>> +     struct vduse_dev *dev = file->private_data;
>>> +     struct vduse_dev_response resp;
>>> +     struct vduse_dev_msg *msg;
>>> +     size_t ret;
>>> +
>>> +     ret = copy_from_iter(&resp, sizeof(resp), from);
>>> +     if (ret != sizeof(resp))
>>> +             return -EINVAL;
>>> +
>>> +     mutex_lock(&dev->msg_lock);
>>> +     msg = vduse_find_msg(&dev->recv_list, resp.request_id);
>>> +     if (!msg) {
>>> +             ret = -EINVAL;
>>> +             goto unlock;
>>> +     }
>>> +
>>> +     memcpy(&msg->resp, &resp, sizeof(resp));
>>> +     msg->completed = 1;
>>> +     wake_up(&msg->waitq);
>>> +unlock:
>>> +     mutex_unlock(&dev->msg_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static __poll_t vduse_dev_poll(struct file *file, poll_table *wait)
>>> +{
>>> +     struct vduse_dev *dev = file->private_data;
>>> +     __poll_t mask = 0;
>>> +
>>> +     poll_wait(file, &dev->waitq, wait);
>>> +
>>> +     if (!list_empty(&dev->send_list))
>>> +             mask |= EPOLLIN | EPOLLRDNORM;
>>> +
>>> +     return mask;
>>> +}
>>> +
>>> +static int vduse_iotlb_add_range(struct vduse_dev *dev,
>>> +                              u64 start, u64 last,
>>> +                              u64 addr, unsigned int perm,
>>> +                              struct file *file, u64 offset)
>>> +{
>>> +     struct vdpa_map_file *map_file;
>>> +     int ret;
>>> +
>>> +     map_file = kmalloc(sizeof(*map_file), GFP_ATOMIC);
>>> +     if (!map_file)
>>> +             return -ENOMEM;
>>> +
>>> +     map_file->file = get_file(file);
>>> +     map_file->offset = offset;
>>> +
>>> +     spin_lock(&dev->iommu_lock);
>>> +     ret = vhost_iotlb_add_range_ctx(dev->iommu, start, last,
>>> +                                     addr, perm, map_file);
>>> +     spin_unlock(&dev->iommu_lock);
>>> +     if (ret) {
>>> +             fput(map_file->file);
>>> +             kfree(map_file);
>>> +             return ret;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>> +static void vduse_iotlb_del_range(struct vduse_dev *dev, u64 start, u64 last)
>>> +{
>>> +     struct vdpa_map_file *map_file;
>>> +     struct vhost_iotlb_map *map;
>>> +
>>> +     spin_lock(&dev->iommu_lock);
>>> +     while ((map = vhost_iotlb_itree_first(dev->iommu, start, last))) {
>>> +             map_file = (struct vdpa_map_file *)map->opaque;
>>> +             fput(map_file->file);
>>> +             kfree(map_file);
>>> +             vhost_iotlb_map_free(dev->iommu, map);
>>> +     }
>>> +     spin_unlock(&dev->iommu_lock);
>>> +}
>>> +
>>> +static void vduse_dev_reset(struct vduse_dev *dev)
>>> +{
>>> +     int i;
>>> +
>>> +     atomic_set(&dev->bounce_map, 0);
>>> +     vduse_iotlb_del_range(dev, 0ULL, ULLONG_MAX);
>>> +     vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
>>> +
>>> +     for (i = 0; i < dev->vq_num; i++) {
>>> +             struct vduse_virtqueue *vq = &dev->vqs[i];
>>> +
>>> +             spin_lock(&vq->irq_lock);
>>> +             vq->ready = false;
>>> +             vq->cb.callback = NULL;
>>> +             vq->cb.private = NULL;
>>> +             spin_unlock(&vq->irq_lock);
>>> +     }
>>> +}
>>> +
>>> +static int vduse_vdpa_set_vq_address(struct vdpa_device *vdpa, u16 idx,
>>> +                             u64 desc_area, u64 driver_area,
>>> +                             u64 device_area)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     return vduse_dev_set_vq_addr(dev, vq, desc_area,
>>> +                                     driver_area, device_area);
>>> +}
>>> +
>>> +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     spin_lock(&vq->kick_lock);
>>> +     if (vq->ready && vq->kickfd)
>>> +             eventfd_signal(vq->kickfd, 1);
>>> +     spin_unlock(&vq->kick_lock);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
>>> +                           struct vdpa_callback *cb)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     spin_lock(&vq->irq_lock);
>>> +     vq->cb.callback = cb->callback;
>>> +     vq->cb.private = cb->private;
>>> +     spin_unlock(&vq->irq_lock);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx, u32 num)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     vduse_dev_set_vq_num(dev, vq, num);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
>>> +                                     u16 idx, bool ready)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     vduse_dev_set_vq_ready(dev, vq, ready);
>>> +     vq->ready = ready;
>>> +}
>>> +
>>> +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     vq->ready = vduse_dev_get_vq_ready(dev, vq);
>>> +
>>> +     return vq->ready;
>>> +}
>>> +
>>> +static int vduse_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 idx,
>>> +                             const struct vdpa_vq_state *state)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     return vduse_dev_set_vq_state(dev, vq, state);
>>> +}
>>> +
>>> +static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx,
>>> +                             struct vdpa_vq_state *state)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vduse_virtqueue *vq = &dev->vqs[idx];
>>> +
>>> +     return vduse_dev_get_vq_state(dev, vq, state);
>>> +}
>>> +
>>> +static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return dev->vq_align;
>>> +}
>>> +
>>> +static u64 vduse_vdpa_get_features(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     u64 fixed = (1ULL << VIRTIO_F_ACCESS_PLATFORM);
>>> +
>>> +     return (vduse_dev_get_features(dev) | fixed);
>>
>> What happens if we don't do such fixup. I think we should fail if
>> usersapce doesnt offer ACCESS_PLATFORM instead.
>>
> Make sense.
>
>>> +}
>>> +
>>> +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 features)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return vduse_dev_set_features(dev, features);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
>>> +                               struct vdpa_callback *cb)
>>> +{
>>> +     /* We don't support config interrupt */
>>> +}
>>> +
>>> +static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return dev->vq_size_max;
>>> +}
>>> +
>>> +static u32 vduse_vdpa_get_device_id(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return dev->device_id;
>>> +}
>>> +
>>> +static u32 vduse_vdpa_get_vendor_id(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return dev->vendor_id;
>>> +}
>>> +
>>> +static u8 vduse_vdpa_get_status(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     return vduse_dev_get_status(dev);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     if (status == 0)
>>> +             vduse_dev_reset(dev);
>>> +
>>> +     vduse_dev_set_status(dev, status);
>>> +}
>>> +
>>> +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
>>> +                          void *buf, unsigned int len)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     vduse_dev_get_config(dev, offset, buf, len);
>>> +}
>>> +
>>> +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
>>> +                     const void *buf, unsigned int len)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     vduse_dev_set_config(dev, offset, buf, len);
>>> +}
>>> +
>>> +static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
>>> +                             struct vhost_iotlb *iotlb)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +     struct vhost_iotlb_map *map;
>>> +     struct vdpa_map_file *map_file;
>>> +     u64 start = 0ULL, last = ULLONG_MAX;
>>> +     int ret = 0;
>>> +
>>> +     vduse_iotlb_del_range(dev, start, last);
>>> +
>>> +     for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
>>> +             map = vhost_iotlb_itree_next(map, start, last)) {
>>> +             map_file = (struct vdpa_map_file *)map->opaque;
>>> +             if (!map_file->file)
>>> +                     continue;
>>> +
>>> +             ret = vduse_iotlb_add_range(dev, map->start, map->last,
>>> +                                         map->addr, map->perm,
>>> +                                         map_file->file,
>>> +                                         map_file->offset);
>>> +             if (ret)
>>> +                     break;
>>> +     }
>>> +     vduse_dev_update_iotlb(dev, start, last);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static void vduse_vdpa_free(struct vdpa_device *vdpa)
>>> +{
>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>> +
>>> +     WARN_ON(!list_empty(&dev->send_list));
>>> +     WARN_ON(!list_empty(&dev->recv_list));
>>> +     dev->vdev = NULL;
>>> +}
>>> +
>>> +static const struct vdpa_config_ops vduse_vdpa_config_ops = {
>>> +     .set_vq_address         = vduse_vdpa_set_vq_address,
>>> +     .kick_vq                = vduse_vdpa_kick_vq,
>>> +     .set_vq_cb              = vduse_vdpa_set_vq_cb,
>>> +     .set_vq_num             = vduse_vdpa_set_vq_num,
>>> +     .set_vq_ready           = vduse_vdpa_set_vq_ready,
>>> +     .get_vq_ready           = vduse_vdpa_get_vq_ready,
>>> +     .set_vq_state           = vduse_vdpa_set_vq_state,
>>> +     .get_vq_state           = vduse_vdpa_get_vq_state,
>>> +     .get_vq_align           = vduse_vdpa_get_vq_align,
>>> +     .get_features           = vduse_vdpa_get_features,
>>> +     .set_features           = vduse_vdpa_set_features,
>>> +     .set_config_cb          = vduse_vdpa_set_config_cb,
>>> +     .get_vq_num_max         = vduse_vdpa_get_vq_num_max,
>>> +     .get_device_id          = vduse_vdpa_get_device_id,
>>> +     .get_vendor_id          = vduse_vdpa_get_vendor_id,
>>> +     .get_status             = vduse_vdpa_get_status,
>>> +     .set_status             = vduse_vdpa_set_status,
>>> +     .get_config             = vduse_vdpa_get_config,
>>> +     .set_config             = vduse_vdpa_set_config,
>>> +     .set_map                = vduse_vdpa_set_map,
>>> +     .free                   = vduse_vdpa_free,
>>> +};
>>> +
>>> +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *page,
>>> +                                     unsigned long offset, size_t size,
>>> +                                     enum dma_data_direction dir,
>>> +                                     unsigned long attrs)
>>> +{
>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>> +
>>> +     if (atomic_xchg(&vdev->bounce_map, 1) == 0 &&
>>> +             vduse_iotlb_add_range(vdev, 0, domain->bounce_size - 1,
>>> +                                   0, VDUSE_ACCESS_RW,
>>> +                                   vduse_domain_file(domain), 0)) {
>>> +             atomic_set(&vdev->bounce_map, 0);
>>> +             return DMA_MAPPING_ERROR;
>>
>> Can we add the bounce mapping page by page here?
>>
> Do you mean mapping the bounce buffer to user space page by page? If
> so, userspace needs to call lots of mmap() for that.


I get this.


>
>>> +     }
>>> +
>>> +     return vduse_domain_map_page(domain, page, offset, size, dir, attrs);
>>> +}
>>> +
>>> +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_addr,
>>> +                             size_t size, enum dma_data_direction dir,
>>> +                             unsigned long attrs)
>>> +{
>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>> +
>>> +     return vduse_domain_unmap_page(domain, dma_addr, size, dir, attrs);
>>> +}
>>> +
>>> +static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
>>> +                                     dma_addr_t *dma_addr, gfp_t flag,
>>> +                                     unsigned long attrs)
>>> +{
>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>> +     unsigned long iova;
>>> +     void *addr;
>>> +
>>> +     *dma_addr = DMA_MAPPING_ERROR;
>>> +     addr = vduse_domain_alloc_coherent(domain, size,
>>> +                             (dma_addr_t *)&iova, flag, attrs);
>>> +     if (!addr)
>>> +             return NULL;
>>> +
>>> +     if (vduse_iotlb_add_range(vdev, iova, iova + size - 1,
>>> +                               iova, VDUSE_ACCESS_RW,
>>> +                               vduse_domain_file(domain), iova)) {
>>> +             vduse_domain_free_coherent(domain, size, addr, iova, attrs);
>>> +             return NULL;
>>> +     }
>>> +     *dma_addr = (dma_addr_t)iova;
>>> +
>>> +     return addr;
>>> +}
>>> +
>>> +static void vduse_dev_free_coherent(struct device *dev, size_t size,
>>> +                                     void *vaddr, dma_addr_t dma_addr,
>>> +                                     unsigned long attrs)
>>> +{
>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>> +     unsigned long start = (unsigned long)dma_addr;
>>> +     unsigned long last = start + size - 1;
>>> +
>>> +     vduse_iotlb_del_range(vdev, start, last);
>>> +     vduse_dev_update_iotlb(vdev, start, last);
>>> +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
>>> +}
>>> +
>>> +static const struct dma_map_ops vduse_dev_dma_ops = {
>>> +     .map_page = vduse_dev_map_page,
>>> +     .unmap_page = vduse_dev_unmap_page,
>>> +     .alloc = vduse_dev_alloc_coherent,
>>> +     .free = vduse_dev_free_coherent,
>>> +};
>>> +
>>> +static unsigned int perm_to_file_flags(u8 perm)
>>> +{
>>> +     unsigned int flags = 0;
>>> +
>>> +     switch (perm) {
>>> +     case VDUSE_ACCESS_WO:
>>> +             flags |= O_WRONLY;
>>> +             break;
>>> +     case VDUSE_ACCESS_RO:
>>> +             flags |= O_RDONLY;
>>> +             break;
>>> +     case VDUSE_ACCESS_RW:
>>> +             flags |= O_RDWR;
>>> +             break;
>>> +     default:
>>> +             WARN(1, "invalidate vhost IOTLB permission\n");
>>> +             break;
>>> +     }
>>> +
>>> +     return flags;
>>> +}
>>> +
>>> +static int vduse_kickfd_setup(struct vduse_dev *dev,
>>> +                     struct vduse_vq_eventfd *eventfd)
>>> +{
>>> +     struct eventfd_ctx *ctx = NULL;
>>> +     struct vduse_virtqueue *vq;
>>> +
>>> +     if (eventfd->index >= dev->vq_num)
>>> +             return -EINVAL;
>>> +
>>> +     vq = &dev->vqs[eventfd->index];
>>> +     if (eventfd->fd > 0) {
>>> +             ctx = eventfd_ctx_fdget(eventfd->fd);
>>> +             if (IS_ERR(ctx))
>>> +                     return PTR_ERR(ctx);
>>> +     }
>>> +     spin_lock(&vq->kick_lock);
>>> +     if (vq->kickfd)
>>> +             eventfd_ctx_put(vq->kickfd);
>>> +     vq->kickfd = ctx;
>>> +     spin_unlock(&vq->kick_lock);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>>> +                     unsigned long arg)
>>> +{
>>> +     struct vduse_dev *dev = file->private_data;
>>> +     void __user *argp = (void __user *)arg;
>>> +     int ret;
>>> +
>>> +     switch (cmd) {
>>> +     case VDUSE_IOTLB_GET_FD: {
>>> +             struct vduse_iotlb_entry entry;
>>> +             struct vhost_iotlb_map *map;
>>> +             struct vdpa_map_file *map_file;
>>> +             struct file *f = NULL;
>>> +
>>> +             ret = -EFAULT;
>>> +             if (copy_from_user(&entry, argp, sizeof(entry)))
>>> +                     break;
>>> +
>>> +             spin_lock(&dev->iommu_lock);
>>> +             map = vhost_iotlb_itree_first(dev->iommu, entry.start,
>>> +                                           entry.last);
>>> +             if (map) {
>>> +                     map_file = (struct vdpa_map_file *)map->opaque;
>>> +                     f = get_file(map_file->file);
>>> +                     entry.offset = map_file->offset;
>>> +                     entry.start = map->start;
>>> +                     entry.last = map->last;
>>> +                     entry.perm = map->perm;
>>> +             }
>>> +             spin_unlock(&dev->iommu_lock);
>>> +             if (!f) {
>>> +                     ret = -EINVAL;
>>> +                     break;
>>> +             }
>>> +             if (copy_to_user(argp, &entry, sizeof(entry))) {
>>> +                     fput(f);
>>> +                     ret = -EFAULT;
>>> +                     break;
>>> +             }
>>> +             ret = get_unused_fd_flags(perm_to_file_flags(entry.perm));
>>> +             if (ret < 0) {
>>> +                     fput(f);
>>> +                     break;
>>> +             }
>>> +             fd_install(ret, f);
>>> +             break;
>>> +     }
>>> +     case VDUSE_VQ_SETUP_KICKFD: {
>>> +             struct vduse_vq_eventfd eventfd;
>>> +
>>> +             ret = -EFAULT;
>>> +             if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
>>> +                     break;
>>> +
>>> +             ret = vduse_kickfd_setup(dev, &eventfd);
>>> +             break;
>>> +     }
>>> +     case VDUSE_INJECT_VQ_IRQ: {
>>> +             struct vduse_virtqueue *vq;
>>> +
>>> +             ret = -EINVAL;
>>> +             if (arg >= dev->vq_num)
>>> +                     break;
>>> +
>>> +             vq = &dev->vqs[arg];
>>> +             spin_lock_irq(&vq->irq_lock);
>>> +             if (vq->ready && vq->cb.callback) {
>>> +                     vq->cb.callback(vq->cb.private);
>>> +                     ret = 0;
>>> +             }
>>> +             spin_unlock_irq(&vq->irq_lock);
>>> +             break;
>>> +     }
>>> +     default:
>>> +             ret = -ENOIOCTLCMD;
>>> +             break;
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int vduse_dev_release(struct inode *inode, struct file *file)
>>> +{
>>> +     struct vduse_dev *dev = file->private_data;
>>> +     struct vduse_dev_msg *msg;
>>> +     int i;
>>> +
>>> +     for (i = 0; i < dev->vq_num; i++) {
>>> +             struct vduse_virtqueue *vq = &dev->vqs[i];
>>> +
>>> +             spin_lock(&vq->kick_lock);
>>> +             if (vq->kickfd)
>>> +                     eventfd_ctx_put(vq->kickfd);
>>> +             vq->kickfd = NULL;
>>> +             spin_unlock(&vq->kick_lock);
>>> +     }
>>> +
>>> +     mutex_lock(&dev->msg_lock);
>>> +     while ((msg = vduse_dequeue_msg(&dev->recv_list)))
>>> +             vduse_enqueue_msg(&dev->send_list, msg);
>>> +     mutex_unlock(&dev->msg_lock);
>>> +
>>> +     dev->connected = false;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int vduse_dev_open(struct inode *inode, struct file *file)
>>> +{
>>> +     struct vduse_dev *dev = container_of(inode->i_cdev,
>>> +                                     struct vduse_dev, cdev);
>>> +     int ret = -EBUSY;
>>> +
>>> +     mutex_lock(&vduse_lock);
>>> +     if (dev->connected)
>>> +             goto unlock;
>>> +
>>> +     ret = 0;
>>> +     dev->connected = true;
>>> +     file->private_data = dev;
>>> +unlock:
>>> +     mutex_unlock(&vduse_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static const struct file_operations vduse_dev_fops = {
>>> +     .owner          = THIS_MODULE,
>>> +     .open           = vduse_dev_open,
>>> +     .release        = vduse_dev_release,
>>> +     .read_iter      = vduse_dev_read_iter,
>>> +     .write_iter     = vduse_dev_write_iter,
>>> +     .poll           = vduse_dev_poll,
>>> +     .unlocked_ioctl = vduse_dev_ioctl,
>>> +     .compat_ioctl   = compat_ptr_ioctl,
>>> +     .llseek         = noop_llseek,
>>> +};
>>> +
>>> +static struct vduse_dev *vduse_dev_create(void)
>>> +{
>>> +     struct vduse_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>> +
>>> +     if (!dev)
>>> +             return NULL;
>>> +
>>> +     dev->iommu = vhost_iotlb_alloc(0, 0);
>>> +     if (!dev->iommu) {
>>> +             kfree(dev);
>>> +             return NULL;
>>> +     }
>>> +
>>> +     mutex_init(&dev->msg_lock);
>>> +     INIT_LIST_HEAD(&dev->send_list);
>>> +     INIT_LIST_HEAD(&dev->recv_list);
>>> +     atomic64_set(&dev->msg_unique, 0);
>>> +     spin_lock_init(&dev->iommu_lock);
>>> +     atomic_set(&dev->bounce_map, 0);
>>> +
>>> +     init_waitqueue_head(&dev->waitq);
>>> +
>>> +     return dev;
>>> +}
>>> +
>>> +static void vduse_dev_destroy(struct vduse_dev *dev)
>>> +{
>>> +     vhost_iotlb_free(dev->iommu);
>>> +     mutex_destroy(&dev->msg_lock);
>>> +     kfree(dev);
>>> +}
>>> +
>>> +static struct vduse_dev *vduse_find_dev(const char *name)
>>> +{
>>> +     struct vduse_dev *tmp, *dev = NULL;
>>> +
>>> +     list_for_each_entry(tmp, &vduse_devs, list) {
>>> +             if (!strcmp(dev_name(&tmp->dev), name)) {
>>> +                     dev = tmp;
>>> +                     break;
>>> +             }
>>> +     }
>>> +     return dev;
>>> +}
>>> +
>>> +static int vduse_destroy_dev(char *name)
>>> +{
>>> +     struct vduse_dev *dev = vduse_find_dev(name);
>>> +
>>> +     if (!dev)
>>> +             return -EINVAL;
>>> +
>>> +     if (dev->vdev || dev->connected)
>>> +             return -EBUSY;
>>> +
>>> +     dev->connected = true;
>>> +     list_del(&dev->list);
>>> +     cdev_device_del(&dev->cdev, &dev->dev);
>>> +     put_device(&dev->dev);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void vduse_release_dev(struct device *device)
>>> +{
>>> +     struct vduse_dev *dev =
>>> +             container_of(device, struct vduse_dev, dev);
>>> +
>>> +     ida_simple_remove(&vduse_ida, dev->minor);
>>> +     kfree(dev->vqs);
>>> +     vduse_domain_destroy(dev->domain);
>>> +     vduse_dev_destroy(dev);
>>> +     module_put(THIS_MODULE);
>>> +}
>>> +
>>> +static int vduse_create_dev(struct vduse_dev_config *config)
>>> +{
>>> +     int i, ret = -ENOMEM;
>>> +     struct vduse_dev *dev;
>>> +
>>> +     if (config->bounce_size > max_bounce_size)
>>> +             return -EINVAL;
>>> +
>>> +     if (config->bounce_size > max_iova_size)
>>> +             return -EINVAL;
>>> +
>>> +     if (vduse_find_dev(config->name))
>>> +             return -EEXIST;
>>> +
>>> +     dev = vduse_dev_create();
>>> +     if (!dev)
>>> +             return -ENOMEM;
>>> +
>>> +     dev->device_id = config->device_id;
>>> +     dev->vendor_id = config->vendor_id;
>>> +     dev->domain = vduse_domain_create(max_iova_size - 1,
>>> +                                     config->bounce_size);
>>> +     if (!dev->domain)
>>> +             goto err_domain;
>>> +
>>> +     dev->vq_align = config->vq_align;
>>> +     dev->vq_size_max = config->vq_size_max;
>>> +     dev->vq_num = config->vq_num;
>>> +     dev->vqs = kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL);
>>> +     if (!dev->vqs)
>>> +             goto err_vqs;
>>> +
>>> +     for (i = 0; i < dev->vq_num; i++) {
>>> +             dev->vqs[i].index = i;
>>> +             spin_lock_init(&dev->vqs[i].kick_lock);
>>> +             spin_lock_init(&dev->vqs[i].irq_lock);
>>> +     }
>>> +
>>> +     ret = ida_simple_get(&vduse_ida, 0, VDUSE_DEV_MAX, GFP_KERNEL);
>>> +     if (ret < 0)
>>> +             goto err_ida;
>>> +
>>> +     dev->minor = ret;
>>> +     device_initialize(&dev->dev);
>>> +     dev->dev.release = vduse_release_dev;
>>> +     dev->dev.class = vduse_class;
>>> +     dev->dev.devt = MKDEV(MAJOR(vduse_major), dev->minor);
>>> +     ret = dev_set_name(&dev->dev, "%s", config->name);
>>
>> Do we need to add a namespce here? E.g "vduse-%s", config->name.
>>
> Actually we already have a parent dir "/dev/vduse/" for it.


Oh, right. Then it should be fine.


>
>>> +     if (ret)
>>> +             goto err_name;
>>> +
>>> +     cdev_init(&dev->cdev, &vduse_dev_fops);
>>> +     dev->cdev.owner = THIS_MODULE;
>>> +
>>> +     ret = cdev_device_add(&dev->cdev, &dev->dev);
>>> +     if (ret) {
>>> +             put_device(&dev->dev);
>>> +             return ret;
>>> +     }
>>> +     list_add(&dev->list, &vduse_devs);
>>> +     __module_get(THIS_MODULE);
>>> +
>>> +     return 0;
>>> +err_name:
>>> +     ida_simple_remove(&vduse_ida, dev->minor);
>>> +err_ida:
>>> +     kfree(dev->vqs);
>>> +err_vqs:
>>> +     vduse_domain_destroy(dev->domain);
>>> +err_domain:
>>> +     vduse_dev_destroy(dev);
>>> +     return ret;
>>> +}
>>> +
>>> +static long vduse_ioctl(struct file *file, unsigned int cmd,
>>> +                     unsigned long arg)
>>> +{
>>> +     int ret;
>>> +     void __user *argp = (void __user *)arg;
>>> +
>>> +     mutex_lock(&vduse_lock);
>>> +     switch (cmd) {
>>> +     case VDUSE_CREATE_DEV: {
>>> +             struct vduse_dev_config config;
>>> +
>>> +             ret = -EFAULT;
>>> +             if (copy_from_user(&config, argp, sizeof(config)))
>>> +                     break;
>>> +
>>> +             ret = vduse_create_dev(&config);
>>> +             break;
>>> +     }
>>> +     case VDUSE_DESTROY_DEV: {
>>> +             char name[VDUSE_NAME_MAX];
>>> +
>>> +             ret = -EFAULT;
>>> +             if (copy_from_user(name, argp, VDUSE_NAME_MAX))
>>> +                     break;
>>> +
>>> +             ret = vduse_destroy_dev(name);
>>> +             break;
>>> +     }
>>> +     default:
>>> +             ret = -EINVAL;
>>> +             break;
>>> +     }
>>> +     mutex_unlock(&vduse_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static const struct file_operations vduse_fops = {
>>> +     .owner          = THIS_MODULE,
>>> +     .unlocked_ioctl = vduse_ioctl,
>>> +     .compat_ioctl   = compat_ptr_ioctl,
>>> +     .llseek         = noop_llseek,
>>> +};
>>> +
>>> +static char *vduse_devnode(struct device *dev, umode_t *mode)
>>> +{
>>> +     return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
>>> +}
>>> +
>>> +static struct miscdevice vduse_misc = {
>>> +     .fops = &vduse_fops,
>>> +     .minor = MISC_DYNAMIC_MINOR,
>>> +     .name = "vduse",
>>> +     .nodename = "vduse/control",
>>> +};
>>> +
>>> +static void vduse_mgmtdev_release(struct device *dev)
>>> +{
>>> +}
>>> +
>>> +static struct device vduse_mgmtdev = {
>>> +     .init_name = "vduse",
>>> +     .release = vduse_mgmtdev_release,
>>> +};
>>> +
>>> +static struct vdpa_mgmt_dev mgmt_dev;
>>> +
>>> +static int vduse_dev_add_vdpa(struct vduse_dev *dev, const char *name)
>>> +{
>>> +     struct vduse_vdpa *vdev = dev->vdev;
>>> +     int ret;
>>> +
>>> +     if (vdev)
>>> +             return -EEXIST;
>>> +
>>> +     vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, NULL,
>>
>> I think the char dev should be used as the parent here.
>>
> Agree.
>
>>> +                              &vduse_vdpa_config_ops,
>>> +                              dev->vq_num, name, true);
>>> +     if (!vdev)
>>> +             return -ENOMEM;
>>> +
>>> +     vdev->dev = dev;
>>> +     vdev->vdpa.dev.dma_mask = &vdev->vdpa.dev.coherent_dma_mask;
>>> +     ret = dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK(64));
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
>>> +     vdev->vdpa.dma_dev = &vdev->vdpa.dev;
>>> +     vdev->vdpa.mdev = &mgmt_dev;
>>> +
>>> +     ret = _vdpa_register_device(&vdev->vdpa);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     dev->vdev = vdev;
>>> +
>>> +     return 0;
>>> +err:
>>> +     put_device(&vdev->vdpa.dev);
>>> +     return ret;
>>> +}
>>> +
>>> +static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>>> +{
>>> +     struct vduse_dev *dev;
>>> +     int ret = -EINVAL;
>>> +
>>> +     mutex_lock(&vduse_lock);
>>> +     dev = vduse_find_dev(name);
>>> +     if (!dev)
>>> +             goto unlock;
>>
>> Any reason for this check? I think vdpa core layer has already did for
>> the name check for us.
>>
> We need to check whether the vduse device with the name is created.


Yes.


>
>>> +
>>> +     ret = vduse_dev_add_vdpa(dev, name);
>>> +unlock:
>>> +     mutex_unlock(&vduse_lock);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
>>> +{
>>> +     _vdpa_unregister_device(dev);
>>> +}
>>> +
>>> +static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops = {
>>> +     .dev_add = vdpa_dev_add,
>>> +     .dev_del = vdpa_dev_del,
>>> +};
>>> +
>>> +static struct virtio_device_id id_table[] = {
>>> +     { VIRTIO_DEV_ANY_ID, VIRTIO_DEV_ANY_ID },
>>> +     { 0 },
>>> +};
>>> +
>>> +static struct vdpa_mgmt_dev mgmt_dev = {
>>> +     .device = &vduse_mgmtdev,
>>> +     .id_table = id_table,
>>> +     .ops = &vdpa_dev_mgmtdev_ops,
>>> +};
>>> +
>>> +static int vduse_mgmtdev_init(void)
>>> +{
>>> +     int ret;
>>> +
>>> +     ret = device_register(&vduse_mgmtdev);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     ret = vdpa_mgmtdev_register(&mgmt_dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     return 0;
>>> +err:
>>> +     device_unregister(&vduse_mgmtdev);
>>> +     return ret;
>>> +}
>>> +
>>> +static void vduse_mgmtdev_exit(void)
>>> +{
>>> +     vdpa_mgmtdev_unregister(&mgmt_dev);
>>> +     device_unregister(&vduse_mgmtdev);
>>> +}
>>> +
>>> +static int vduse_init(void)
>>> +{
>>> +     int ret;
>>> +
>>> +     ret = misc_register(&vduse_misc);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     vduse_class = class_create(THIS_MODULE, "vduse");
>>> +     if (IS_ERR(vduse_class)) {
>>> +             ret = PTR_ERR(vduse_class);
>>> +             goto err_class;
>>> +     }
>>> +     vduse_class->devnode = vduse_devnode;
>>> +
>>> +     ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
>>> +     if (ret)
>>> +             goto err_chardev;
>>> +
>>> +     ret = vduse_domain_init();
>>> +     if (ret)
>>> +             goto err_domain;
>>> +
>>> +     ret = vduse_mgmtdev_init();
>>> +     if (ret)
>>> +             goto err_mgmtdev;
>>
>> Should we validate max_bounce_size < max_iova_size here?
>>
> Sure.
>
>>
>>> +
>>> +     return 0;
>>> +err_mgmtdev:
>>> +     vduse_domain_exit();
>>> +err_domain:
>>> +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
>>> +err_chardev:
>>> +     class_destroy(vduse_class);
>>> +err_class:
>>> +     misc_deregister(&vduse_misc);
>>> +     return ret;
>>> +}
>>> +module_init(vduse_init);
>>> +
>>> +static void vduse_exit(void)
>>> +{
>>> +     misc_deregister(&vduse_misc);
>>> +     class_destroy(vduse_class);
>>> +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
>>> +     vduse_domain_exit();
>>> +     vduse_mgmtdev_exit();
>>> +}
>>> +module_exit(vduse_exit);
>>> +
>>> +MODULE_VERSION(DRV_VERSION);
>>> +MODULE_LICENSE(DRV_LICENSE);
>>> +MODULE_AUTHOR(DRV_AUTHOR);
>>> +MODULE_DESCRIPTION(DRV_DESC);
>>> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
>>> new file mode 100644
>>> index 000000000000..9391c4acfa53
>>> --- /dev/null
>>> +++ b/include/uapi/linux/vduse.h
>>> @@ -0,0 +1,136 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> +#ifndef _UAPI_VDUSE_H_
>>> +#define _UAPI_VDUSE_H_
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +#define VDUSE_CONFIG_DATA_LEN        256
>>> +#define VDUSE_NAME_MAX       256
>>> +
>>> +/* the control messages definition for read/write */
>>> +
>>> +enum vduse_req_type {
>>> +     VDUSE_SET_VQ_NUM,
>>> +     VDUSE_SET_VQ_ADDR,
>>> +     VDUSE_SET_VQ_READY,
>>> +     VDUSE_GET_VQ_READY,
>>> +     VDUSE_SET_VQ_STATE,
>>> +     VDUSE_GET_VQ_STATE,
>>> +     VDUSE_SET_FEATURES,
>>> +     VDUSE_GET_FEATURES,
>>> +     VDUSE_SET_STATUS,
>>> +     VDUSE_GET_STATUS,
>>> +     VDUSE_SET_CONFIG,
>>> +     VDUSE_GET_CONFIG,
>>> +     VDUSE_UPDATE_IOTLB,
>>> +};
>>> +
>>> +struct vduse_vq_num {
>>> +     __u32 index;
>>> +     __u32 num;
>>> +};
>>> +
>>> +struct vduse_vq_addr {
>>> +     __u32 index;
>>> +     __u64 desc_addr;
>>> +     __u64 driver_addr;
>>> +     __u64 device_addr;
>>> +};
>>> +
>>> +struct vduse_vq_ready {
>>> +     __u32 index;
>>> +     __u8 ready;
>>> +};
>>> +
>>> +struct vduse_vq_state {
>>> +     __u32 index;
>>> +     __u16 avail_idx;
>>> +};
>>> +
>>> +struct vduse_dev_config_data {
>>> +     __u32 offset;
>>> +     __u32 len;
>>> +     __u8 data[VDUSE_CONFIG_DATA_LEN];
>>> +};
>>> +
>>> +struct vduse_iova_range {
>>> +     __u64 start;
>>> +     __u64 last;
>>> +};
>>> +
>>> +struct vduse_dev_request {
>>> +     __u32 type; /* request type */
>>> +     __u32 unique; /* request id */
>>
>> Let's simply use "request_id" here.
>>
> OK.
>
>>> +     __u32 reserved[2]; /* for feature use */
>>> +     union {
>>> +             struct vduse_vq_num vq_num; /* virtqueue num */
>>> +             struct vduse_vq_addr vq_addr; /* virtqueue address */
>>> +             struct vduse_vq_ready vq_ready; /* virtqueue ready status */
>>> +             struct vduse_vq_state vq_state; /* virtqueue state */
>>> +             struct vduse_dev_config_data config; /* virtio device config space */
>>> +             struct vduse_iova_range iova; /* iova range for updating */
>>> +             __u64 features; /* virtio features */
>>> +             __u8 status; /* device status */
>>
>> It might be better to use struct for feaures and status as well for
>> consistency.
>>
> OK.
>
>> And to be safe, let's add explicity padding here.
>>
> Do you mean add padding for the union?


I think so.


>
>>> +     };
>>> +};
>>> +
>>> +struct vduse_dev_response {
>>> +     __u32 request_id; /* corresponding request id */
>>> +#define VDUSE_REQUEST_OK     0x00
>>> +#define VDUSE_REQUEST_FAILED 0x01
>>> +     __u8 result; /* the result of request */
>>> +     __u8 reserved[11]; /* for feature use */
>>
>> Looks like this will be a hole which is similar to
>> 429711aec282c4b5fe5bbd7b2f0bbbff4110ffb2. Need to make sure the reserved
>> end at 8 byte boundary.
>>
> Will fix it.
>
>>> +     union {
>>> +             struct vduse_vq_ready vq_ready; /* virtqueue ready status */
>>> +             struct vduse_vq_state vq_state; /* virtqueue state */
>>> +             struct vduse_dev_config_data config; /* virtio device config space */
>>> +             __u64 features; /* virtio features */
>>> +             __u8 status; /* device status */
>>> +     };
>>> +};
>>> +
>>> +/* ioctls */
>>> +
>>> +struct vduse_dev_config {
>>> +     char name[VDUSE_NAME_MAX]; /* vduse device name */
>>> +     __u32 vendor_id; /* virtio vendor id */
>>> +     __u32 device_id; /* virtio device id */
>>> +     __u64 bounce_size; /* bounce buffer size for iommu */
>>> +     __u16 vq_num; /* the number of virtqueues */
>>> +     __u16 vq_size_max; /* the max size of virtqueue */
>>> +     __u32 vq_align; /* the allocation alignment of virtqueue's metadata */
>>> +};
>>> +
>>> +struct vduse_iotlb_entry {
>>> +     __u64 offset; /* the mmap offset on fd */
>>> +     __u64 start; /* start of the IOVA range */
>>> +     __u64 last; /* last of the IOVA range */
>>> +#define VDUSE_ACCESS_RO 0x1
>>> +#define VDUSE_ACCESS_WO 0x2
>>> +#define VDUSE_ACCESS_RW 0x3
>>> +     __u8 perm; /* access permission of this range */
>>> +};
>>> +
>>> +struct vduse_vq_eventfd {
>>> +     __u32 index; /* virtqueue index */
>>> +     int fd; /* eventfd, -1 means de-assigning the eventfd */
>>
>> Let's define a macro for this.
>>
> OK.
>
>>> +};
>>> +
>>> +#define VDUSE_BASE   0x81
>>> +
>>> +/* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
>>> +#define VDUSE_CREATE_DEV     _IOW(VDUSE_BASE, 0x01, struct vduse_dev_config)
>>> +
>>> +/* Destroy a vduse device. Make sure there are no references to the char device */
>>> +#define VDUSE_DESTROY_DEV    _IOW(VDUSE_BASE, 0x02, char[VDUSE_NAME_MAX])
>>> +
>>> +/* Get a file descriptor for the mmap'able iova region */
>>> +#define VDUSE_IOTLB_GET_FD   _IOWR(VDUSE_BASE, 0x03, struct vduse_iotlb_entry)
>>> +
>>> +/* Setup an eventfd to receive kick for virtqueue */
>>> +#define VDUSE_VQ_SETUP_KICKFD        _IOW(VDUSE_BASE, 0x04, struct vduse_vq_eventfd)
>>> +
>>> +/* Inject an interrupt for specific virtqueue */
>>> +#define VDUSE_INJECT_VQ_IRQ  _IO(VDUSE_BASE, 0x05)
>>
>> I wonder do we need a version/feature handshake that is for future
>> extension instead of just reserve bits in uABI? E.g VDUSE_GET_VERSION ...
>>
> Agree. Will do it in v5.


Btw, I think you can remove "RFC" then Michael can consider to merge the 
series.

Thanks


>
> Thanks,
> Yongji
>

