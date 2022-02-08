Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A04AD1C0
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 07:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347755AbiBHGra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 01:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiBHGra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 01:47:30 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917BC0401EF;
        Mon,  7 Feb 2022 22:47:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V3vFiDe_1644302843;
Received: from fengidri.local(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V3vFiDe_1644302843)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 14:47:24 +0800
Subject: Re: [PATCH v3 13/17] virtio_pci: queue_reset: support
 VIRTIO_F_RING_RESET
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <0908a9f6-562d-fab5-39c3-2f0125acc80e@redhat.com>
 <1644220750.6834595-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEuemxceN-uQ9Pg1bkaW6jba_jzWkoduRM_FqXUKQy26AA@mail.gmail.com>
From:   xuanzhuo <xuanzhuo@linux.alibaba.com>
Message-ID: <79fd067f-d9e8-668d-9d1b-e1d909999d15@linux.alibaba.com>
Date:   Tue, 8 Feb 2022 14:47:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CACGkMEuemxceN-uQ9Pg1bkaW6jba_jzWkoduRM_FqXUKQy26AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/2/8 上午10:55, Jason Wang wrote:
> On Mon, Feb 7, 2022 at 4:19 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>> On Mon, 7 Feb 2022 14:57:13 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>> 在 2022/1/26 下午3:35, Xuan Zhuo 写道:
>>>> This patch implements virtio pci support for QUEUE RESET.
>>>>
>>>> Performing reset on a queue is divided into two steps:
>>>>
>>>> 1. reset_vq: reset one vq
>>>> 2. enable_reset_vq: re-enable the reset queue
>>>>
>>>> In the first step, these tasks will be completed:
>>>>      1. notify the hardware queue to reset
>>>>      2. recycle the buffer from vq
>>>>      3. release the ring of the vq
>>>>
>>>> The process of enable reset vq:
>>>>       vp_modern_enable_reset_vq()
>>>>       vp_enable_reset_vq()
>>>>       __vp_setup_vq()
>>>>       setup_vq()
>>>>       vring_setup_virtqueue()
>>>>
>>>> In this process, we added two parameters, vq and num, and finally passed
>>>> them to vring_setup_virtqueue().  And reuse the original info and vq.
>>>>
>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>> ---
>>>>    drivers/virtio/virtio_pci_common.c |  36 +++++++----
>>>>    drivers/virtio/virtio_pci_common.h |   5 ++
>>>>    drivers/virtio/virtio_pci_modern.c | 100 +++++++++++++++++++++++++++++
>>>>    3 files changed, 128 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>>>> index c02936d29a31..ad21638fbf66 100644
>>>> --- a/drivers/virtio/virtio_pci_common.c
>>>> +++ b/drivers/virtio/virtio_pci_common.c
>>>> @@ -205,23 +205,28 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>>>>      return err;
>>>>    }
>>>>
>>>> -static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>>>> -                                void (*callback)(struct virtqueue *vq),
>>>> -                                const char *name,
>>>> -                                bool ctx,
>>>> -                                u16 msix_vec, u16 num)
>>>> +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>>>> +                         void (*callback)(struct virtqueue *vq),
>>>> +                         const char *name,
>>>> +                         bool ctx,
>>>> +                         u16 msix_vec, u16 num)
>>>>    {
>>>>      struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>> -   struct virtio_pci_vq_info *info = kmalloc(sizeof *info, GFP_KERNEL);
>>>> +   struct virtio_pci_vq_info *info;
>>>>      struct virtqueue *vq;
>>>>      unsigned long flags;
>>>>
>>>> -   /* fill out our structure that represents an active queue */
>>>> -   if (!info)
>>>> -           return ERR_PTR(-ENOMEM);
>>>> +   info = vp_dev->vqs[index];
>>>> +   if (!info) {
>>>> +           info = kzalloc(sizeof *info, GFP_KERNEL);
>>>> +
>>>> +           /* fill out our structure that represents an active queue */
>>>> +           if (!info)
>>>> +                   return ERR_PTR(-ENOMEM);
>>>> +   }
>>>>
>>>>      vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
>>>> -                         msix_vec, NULL, num);
>>>> +                         msix_vec, info->vq, num);
>>>>      if (IS_ERR(vq))
>>>>              goto out_info;
>>>>
>>>> @@ -238,6 +243,9 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>>>>      return vq;
>>>>
>>>>    out_info:
>>>> +   if (info->vq && info->vq->reset)
>>>> +           return vq;
>>>> +
>>>>      kfree(info);
>>>>      return vq;
>>>>    }
>>>> @@ -248,9 +256,11 @@ static void vp_del_vq(struct virtqueue *vq)
>>>>      struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>>>>      unsigned long flags;
>>>>
>>>> -   spin_lock_irqsave(&vp_dev->lock, flags);
>>>> -   list_del(&info->node);
>>>> -   spin_unlock_irqrestore(&vp_dev->lock, flags);
>>>> +   if (!vq->reset) {
>>>> +           spin_lock_irqsave(&vp_dev->lock, flags);
>>>> +           list_del(&info->node);
>>>> +           spin_unlock_irqrestore(&vp_dev->lock, flags);
>>>> +   }
>>>>
>>>>      vp_dev->del_vq(info);
>>>>      kfree(info);
>>>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>>>> index 65db92245e41..c1d15f7c0be4 100644
>>>> --- a/drivers/virtio/virtio_pci_common.h
>>>> +++ b/drivers/virtio/virtio_pci_common.h
>>>> @@ -119,6 +119,11 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>>>>              struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>>>              const char * const names[], const bool *ctx,
>>>>              struct irq_affinity *desc);
>>>> +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>>>> +                         void (*callback)(struct virtqueue *vq),
>>>> +                         const char *name,
>>>> +                         bool ctx,
>>>> +                         u16 msix_vec, u16 num);
>>>>    const char *vp_bus_name(struct virtio_device *vdev);
>>>>
>>>>    /* Setup the affinity for a virtqueue:
>>>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>>> index 2ce58de549de..6789411169e4 100644
>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>>>>      if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>>>>                      pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>>>>              __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
>>>> +
>>>> +   if (features & BIT_ULL(VIRTIO_F_RING_RESET))
>>>> +           __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>>>>    }
>>>>
>>>>    /* virtio config->finalize_features() implementation */
>>>> @@ -176,6 +179,94 @@ static void vp_reset(struct virtio_device *vdev)
>>>>      vp_disable_cbs(vdev);
>>>>    }
>>>>
>>>> +static int vp_modern_reset_vq(struct virtio_reset_vq *param)
>>>> +{
>>>> +   struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
>>>> +   struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>> +   struct virtio_pci_vq_info *info;
>>>> +   u16 msix_vec, queue_index;
>>>> +   unsigned long flags;
>>>> +   void *buf;
>>>> +
>>>> +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
>>>> +           return -ENOENT;
>>>> +
>>>> +   queue_index = param->queue_index;
>>>> +
>>>> +   vp_modern_set_queue_reset(mdev, queue_index);
>>>> +
>>>> +   /* After write 1 to queue reset, the driver MUST wait for a read of
>>>> +    * queue reset to return 1.
>>>> +    */
>>>> +   while (vp_modern_get_queue_reset(mdev, queue_index) != 1)
>>>> +           msleep(1);
>>>
>>> Is this better to move this logic into vp_modern_set_queue_reset()?
>>>
>> OK.
>>
>>>> +
>>>> +   info = vp_dev->vqs[queue_index];
>>>> +   msix_vec = info->msix_vector;
>>>> +
>>>> +   /* Disable VQ callback. */
>>>> +   if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
>>>> +           disable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
>>>
>>> How about the INTX case where irq is shared? I guess we need to disable
>>> and enable the irq as well.
>> For the INTX scenario, I don't think we need to disable/enable the irq. But I do
>> have a mistake, I should put the following list_del(&info->node) here, so that
>> when the irq comes, it will no longer operate this vq.
>>
>> In fact, for no INTX case, the disable_irq here is not necessary, according to
>> the requirements of the spec, after reset, the device should not generate irq
>> anymore.
> I may miss something but I don't think INTX differs from MSI from the
> vq handler perspective.
>
>> Here just to prevent accidents.
> The problem is that if you don't disable/sync IRQ there could be a
> race between the vq irq handler and the virtqueue_detach_unused_buf()?

I understand that under INTX, the irq handler (vp_vring_interrupt) will 
check
the list vp_dev->virtqueues to call the vq callback. Then if we have 
deleted it
from vp_dev->virtqueues, then there is no need to disable irq. And this 
process
is locked by vp_dev->lock.
>>>
>>>> +
>>>> +   while ((buf = virtqueue_detach_unused_buf(info->vq)) != NULL)
>>>> +           param->free_unused_cb(param, buf);
>>>
>>> Any reason that we can't leave this logic to driver? (Or is there any
>>> operations that must be done before the following operations?)
>> As you commented before, we merged free unused buf and reset queue.
>>
>> I think it's a good note, otherwise, we're going to
>>
>>          1. reset vq
>>          2. free unused(by driver)
>>          3. free ring of vq
> Rethink about this, I'd prefer to leave it to the driver for consistency.
>
> E.g the virtqueue_detach_unused_buf() is called by each driver nowdays.
>
OK
>>
>>>
>>>> +
>>>> +   /* delete vq */
>>>> +   spin_lock_irqsave(&vp_dev->lock, flags);
>>>> +   list_del(&info->node);
>>>> +   spin_unlock_irqrestore(&vp_dev->lock, flags);
>>>> +
>>>> +   INIT_LIST_HEAD(&info->node);
>>>> +
>>>> +   if (vp_dev->msix_enabled)
>>>> +           vp_modern_queue_vector(mdev, info->vq->index,
>>>> +                                  VIRTIO_MSI_NO_VECTOR);
>>>
>>> I wonder if this is a must.
>>>
>>>
>>>> +
>>>> +   if (!mdev->notify_base)
>>>> +           pci_iounmap(mdev->pci_dev,
>>>> +                       (void __force __iomem *)info->vq->priv);
>>>
>>> Is this a must? what happens if we simply don't do this?
>>>
>> The purpose of these two operations is mainly to be symmetrical with del_vq().
> This is another question I want to ask. Any reason for calling
> del_vq()? Is it because you need to exclude a vq from the vq handler?
I didn't actually call del_vq(), but I think the process is similar to 
it, so
I'd like to be symmetric with del_vq() in implementation.

The separation from the vq handler is achieved by the following code:

   spin_lock_irqsave(&vp_dev->lock, flags);
   list_del(&info->node);
   spin_unlock_irqrestore(&vp_dev->lock, flags);
> For any case, the MSI and notification stuff seems unnecessary.

I will remove these in next version.

Thanks.
> Thanks
>
>>
>>>> +
>>>> +   vring_reset_virtqueue(info->vq);
>>>> +
>>>> +   return 0;
>>>> +}
>>>> +
>>>> +static struct virtqueue *vp_modern_enable_reset_vq(struct virtio_reset_vq *param)
>>>> +{
>>>> +   struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
>>>> +   struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>> +   struct virtio_pci_vq_info *info;
>>>> +   u16 msix_vec, queue_index;
>>>> +   struct virtqueue *vq;
>>>> +
>>>> +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
>>>> +           return ERR_PTR(-ENOENT);
>>>> +
>>>> +   queue_index = param->queue_index;
>>>> +
>>>> +   info = vp_dev->vqs[queue_index];
>>>> +
>>>> +   if (!info->vq->reset)
>>>> +           return ERR_PTR(-EPERM);
>>>> +
>>>> +   /* check queue reset status */
>>>> +   if (vp_modern_get_queue_reset(mdev, queue_index) != 1)
>>>> +           return ERR_PTR(-EBUSY);
>>>> +
>>>> +   vq = vp_setup_vq(param->vdev, queue_index, param->callback, param->name,
>>>> +                    param->ctx, info->msix_vector, param->ring_num);
>>>> +   if (IS_ERR(vq))
>>>> +           return vq;
>>>> +
>>>> +   vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
>>>> +
>>>> +   msix_vec = vp_dev->vqs[queue_index]->msix_vector;
>>>> +   if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
>>>> +           enable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
>>>
>>> How about the INT-X case?
>> Explained above.
>>
>> Thanks.
>>
>>> Thanks
>>>
>>>
>>>> +
>>>> +   return vq;
>>>> +}
>>>> +
>>>>    static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>>>>    {
>>>>      return vp_modern_config_vector(&vp_dev->mdev, vector);
>>>> @@ -284,6 +375,11 @@ static void del_vq(struct virtio_pci_vq_info *info)
>>>>      struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>>>      struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>
>>>> +   if (vq->reset) {
>>>> +           vring_del_virtqueue(vq);
>>>> +           return;
>>>> +   }
>>>> +
>>>>      if (vp_dev->msix_enabled)
>>>>              vp_modern_queue_vector(mdev, vq->index,
>>>>                                     VIRTIO_MSI_NO_VECTOR);
>>>> @@ -403,6 +499,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>>>      .set_vq_affinity = vp_set_vq_affinity,
>>>>      .get_vq_affinity = vp_get_vq_affinity,
>>>>      .get_shm_region  = vp_get_shm_region,
>>>> +   .reset_vq        = vp_modern_reset_vq,
>>>> +   .enable_reset_vq = vp_modern_enable_reset_vq,
>>>>    };
>>>>
>>>>    static const struct virtio_config_ops virtio_pci_config_ops = {
>>>> @@ -421,6 +519,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>>>>      .set_vq_affinity = vp_set_vq_affinity,
>>>>      .get_vq_affinity = vp_get_vq_affinity,
>>>>      .get_shm_region  = vp_get_shm_region,
>>>> +   .reset_vq        = vp_modern_reset_vq,
>>>> +   .enable_reset_vq = vp_modern_enable_reset_vq,
>>>>    };
>>>>
>>>>    /* the PCI probing function */

