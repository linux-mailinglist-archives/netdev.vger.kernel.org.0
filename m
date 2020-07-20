Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038832258CB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgGTHkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:40:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:50777 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgGTHkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:40:18 -0400
IronPort-SDR: NGwLywUaibddsy8487U8mlqcP36+RzXmWsgERYNXQjdyeqo+fmzDCYp6SsnEJVsHPDD/ZWC0ri
 4WLr4tyfe30A==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="214550422"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="214550422"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 00:40:17 -0700
IronPort-SDR: PqGamwaEVAtW6Y3NgK41dykY2Hl5nlGb4vUQKYAZ6ni/PfXbH+yhLNfqkRBzOSDeHn1AcloXKn
 a76HVkRdFiCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="361944927"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.29.73]) ([10.255.29.73])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2020 00:40:14 -0700
Subject: Re: [PATCH V2 1/6] vhost: introduce vhost_call_ctx
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-2-git-send-email-lingshan.zhu@intel.com>
 <871ee1c1-8cf7-3d9d-1892-5991b92e5db3@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <b208cc96-16f1-5b3d-a78a-c5ac5bbf1351@intel.com>
Date:   Mon, 20 Jul 2020 15:40:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <871ee1c1-8cf7-3d9d-1892-5991b92e5db3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/17/2020 11:32 AM, Jason Wang wrote:
>
> On 2020/7/16 下午7:23, Zhu Lingshan wrote:
>> This commit introduces struct vhost_call_ctx which replaced
>> raw struct eventfd_ctx *call_ctx in struct vhost_virtqueue.
>> Besides eventfd_ctx, it contains a spin lock and an
>> irq_bypass_producer in its structure.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vdpa.c  |  4 ++--
>>   drivers/vhost/vhost.c | 22 ++++++++++++++++------
>>   drivers/vhost/vhost.h |  9 ++++++++-
>>   3 files changed, 26 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 7580e34..2fcc422 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -96,7 +96,7 @@ static void handle_vq_kick(struct vhost_work *work)
>>   static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
>>   {
>>       struct vhost_virtqueue *vq = private;
>> -    struct eventfd_ctx *call_ctx = vq->call_ctx;
>> +    struct eventfd_ctx *call_ctx = vq->call_ctx.ctx;
>>         if (call_ctx)
>>           eventfd_signal(call_ctx, 1);
>> @@ -382,7 +382,7 @@ static long vhost_vdpa_vring_ioctl(struct 
>> vhost_vdpa *v, unsigned int cmd,
>>           break;
>>         case VHOST_SET_VRING_CALL:
>> -        if (vq->call_ctx) {
>> +        if (vq->call_ctx.ctx) {
>>               cb.callback = vhost_vdpa_virtqueue_cb;
>>               cb.private = vq;
>>           } else {
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index d7b8df3..4004e94 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -298,6 +298,13 @@ static void vhost_vq_meta_reset(struct vhost_dev 
>> *d)
>>           __vhost_vq_meta_reset(d->vqs[i]);
>>   }
>>   +static void vhost_call_ctx_reset(struct vhost_call_ctx *call_ctx)
>> +{
>> +    call_ctx->ctx = NULL;
>> +    memset(&call_ctx->producer, 0x0, sizeof(struct 
>> irq_bypass_producer));
>> +    spin_lock_init(&call_ctx->ctx_lock);
>> +}
>> +
>>   static void vhost_vq_reset(struct vhost_dev *dev,
>>                  struct vhost_virtqueue *vq)
>>   {
>> @@ -319,13 +326,13 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>       vq->log_base = NULL;
>>       vq->error_ctx = NULL;
>>       vq->kick = NULL;
>> -    vq->call_ctx = NULL;
>>       vq->log_ctx = NULL;
>>       vhost_reset_is_le(vq);
>>       vhost_disable_cross_endian(vq);
>>       vq->busyloop_timeout = 0;
>>       vq->umem = NULL;
>>       vq->iotlb = NULL;
>> +    vhost_call_ctx_reset(&vq->call_ctx);
>>       __vhost_vq_meta_reset(vq);
>>   }
>>   @@ -685,8 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>> eventfd_ctx_put(dev->vqs[i]->error_ctx);
>>           if (dev->vqs[i]->kick)
>>               fput(dev->vqs[i]->kick);
>> -        if (dev->vqs[i]->call_ctx)
>> - eventfd_ctx_put(dev->vqs[i]->call_ctx);
>> +        if (dev->vqs[i]->call_ctx.ctx)
>> + eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>>           vhost_vq_reset(dev, dev->vqs[i]);
>>       }
>>       vhost_dev_free_iovecs(dev);
>> @@ -1629,7 +1636,10 @@ long vhost_vring_ioctl(struct vhost_dev *d, 
>> unsigned int ioctl, void __user *arg
>>               r = PTR_ERR(ctx);
>>               break;
>>           }
>> -        swap(ctx, vq->call_ctx);
>> +
>> +        spin_lock(&vq->call_ctx.ctx_lock);
>> +        swap(ctx, vq->call_ctx.ctx);
>> +        spin_unlock(&vq->call_ctx.ctx_lock);
>>           break;
>>       case VHOST_SET_VRING_ERR:
>>           if (copy_from_user(&f, argp, sizeof f)) {
>> @@ -2440,8 +2450,8 @@ static bool vhost_notify(struct vhost_dev *dev, 
>> struct vhost_virtqueue *vq)
>>   void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>>   {
>>       /* Signal the Guest tell them we used something up. */
>> -    if (vq->call_ctx && vhost_notify(dev, vq))
>> -        eventfd_signal(vq->call_ctx, 1);
>> +    if (vq->call_ctx.ctx && vhost_notify(dev, vq))
>> +        eventfd_signal(vq->call_ctx.ctx, 1);
>>   }
>>   EXPORT_SYMBOL_GPL(vhost_signal);
>>   diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index c8e96a0..402c62e 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -13,6 +13,7 @@
>>   #include <linux/virtio_ring.h>
>>   #include <linux/atomic.h>
>>   #include <linux/vhost_iotlb.h>
>> +#include <linux/irqbypass.h>
>>     struct vhost_work;
>>   typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>> @@ -60,6 +61,12 @@ enum vhost_uaddr_type {
>>       VHOST_NUM_ADDRS = 3,
>>   };
>>   +struct vhost_call_ctx {
>
>
> I think maybe "vhost_vring_call" is a better name since it contains 
> not only the eventfd_ctx now.
>
> Thanks
Sure
>
>
>> +    struct eventfd_ctx *ctx;
>> +    struct irq_bypass_producer producer;
>> +    spinlock_t ctx_lock;
>> +};
>> +
>>   /* The virtqueue structure describes a queue attached to a device. */
>>   struct vhost_virtqueue {
>>       struct vhost_dev *dev;
>> @@ -72,7 +79,7 @@ struct vhost_virtqueue {
>>       vring_used_t __user *used;
>>       const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
>>       struct file *kick;
>> -    struct eventfd_ctx *call_ctx;
>> +    struct vhost_call_ctx call_ctx;
>>       struct eventfd_ctx *error_ctx;
>>       struct eventfd_ctx *log_ctx;
>
