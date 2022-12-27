Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B86568C2
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiL0JKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiL0JKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:10:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EF51E0
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672132163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSradRKv8X4tppTdp+nyd/8jKoHTyaIYm93jfzfVBMs=;
        b=eh+AA/aIHMOf3t4J8IZFY+kd4svqiFvpdZ9Ie/+PTTWLN10zgjaG+C/rzVvjuC3KF+KxML
        B3cmW+8PSGHpXwoL+XB2pQ04/sZHjOHxEsCoIyq9M7VgJkecujZ2zknnLz9yP5ci5ZLmnJ
        9rbqrISFf1WckdlbZcvP/E6hCZw9OUw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-tkeB8sUvOuWI3W8tKQXlIA-1; Tue, 27 Dec 2022 04:09:22 -0500
X-MC-Unique: tkeB8sUvOuWI3W8tKQXlIA-1
Received: by mail-pg1-f199.google.com with SMTP id e5-20020a63f545000000b0049b36d5a272so742566pgk.12
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSradRKv8X4tppTdp+nyd/8jKoHTyaIYm93jfzfVBMs=;
        b=nR82nQDnGptetDRPaiXzlNtAWTYmlM2bdOq8N9IOVsL3KDGaChvRPqTh5mjK7wuZ2b
         OrBleYFz6HYhXcGlMzuKc8p4tjsifoYwIYxRrmPisCioPFZFFj1KnuobezbH1uYzsZEp
         C9ak5LJ8ou+my+LXXpOhmqEIPPlkakZLwg5VEPXDg7AB7aipa/y3RtO2u85JDMtjl8qH
         RV8C3gQI7Q1iDOlFOSd/9xk33Z5hUhvb9WnbCH97U2tAYXaad2YJ0OOjlSVVzLLocxAw
         3KozJoiDAw+sNfV7110OPztIGwcOAkuMsGce9PTIvG3eKq1zC4qnS/IUFZ4A6nSFR8hp
         GTEg==
X-Gm-Message-State: AFqh2kouj1/QRXN/x60Xp1THNQtvTPB99CLJd+PkhMCRv4oSnunuiUr3
        Wf1L1G8ywJxa59DY8D9unEMg9b7hj0l0wyP4vld6vM2nNt0Re2uKNSfemwxT5demdzhNJKcacN4
        31NcTDX8qzRAPROc7
X-Received: by 2002:a05:6a21:9990:b0:a6:f26b:558 with SMTP id ve16-20020a056a21999000b000a6f26b0558mr34620490pzb.16.1672132160879;
        Tue, 27 Dec 2022 01:09:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXujkKWu8TaIx5QDj+Ms6FxKWfhgvgCot/DHhIN7/4Mzjd1pf+hfvZSKMRrWnDv9cpyYdI8/KA==
X-Received: by 2002:a05:6a21:9990:b0:a6:f26b:558 with SMTP id ve16-20020a056a21999000b000a6f26b0558mr34620466pzb.16.1672132160560;
        Tue, 27 Dec 2022 01:09:20 -0800 (PST)
Received: from [10.72.13.143] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p188-20020a625bc5000000b00580fe3b958esm4044388pfb.131.2022.12.27.01.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 01:09:20 -0800 (PST)
Message-ID: <0abaec22-ec5f-9136-b043-0989d97b209f@redhat.com>
Date:   Tue, 27 Dec 2022 17:09:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183348-mutt-send-email-mst@kernel.org>
 <CACGkMEsJYn=4mC-+QKnkHi+zjZsRL+m+mdyuLemPhsZDi_hcEw@mail.gmail.com>
 <20221227020901-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221227020901-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/27 15:19, Michael S. Tsirkin 写道:
> On Tue, Dec 27, 2022 at 11:47:34AM +0800, Jason Wang wrote:
>> On Tue, Dec 27, 2022 at 7:34 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Mon, Dec 26, 2022 at 03:49:07PM +0800, Jason Wang wrote:
>>>> This patch introduces a per virtqueue waitqueue to allow driver to
>>>> sleep and wait for more used. Two new helpers are introduced to allow
>>>> driver to sleep and wake up.
>>>>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>> ---
>>>> Changes since V1:
>>>> - check virtqueue_is_broken() as well
>>>> - use more_used() instead of virtqueue_get_buf() to allow caller to
>>>>    get buffers afterwards
>>>> ---
>>>>   drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
>>>>   include/linux/virtio.h       |  3 +++
>>>>   2 files changed, 32 insertions(+)
>>>>
>>>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>>>> index 5cfb2fa8abee..9c83eb945493 100644
>>>> --- a/drivers/virtio/virtio_ring.c
>>>> +++ b/drivers/virtio/virtio_ring.c
>>>> @@ -13,6 +13,7 @@
>>>>   #include <linux/dma-mapping.h>
>>>>   #include <linux/kmsan.h>
>>>>   #include <linux/spinlock.h>
>>>> +#include <linux/wait.h>
>>>>   #include <xen/xen.h>
>>>>
>>>>   #ifdef DEBUG
>>>> @@ -60,6 +61,7 @@
>>>>                        "%s:"fmt, (_vq)->vq.name, ##args);      \
>>>>                /* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
>>>>                WRITE_ONCE((_vq)->broken, true);                       \
>>>> +             wake_up_interruptible(&(_vq)->wq);                     \
>>>>        } while (0)
>>>>   #define START_USE(vq)
>>>>   #define END_USE(vq)
>>>> @@ -203,6 +205,9 @@ struct vring_virtqueue {
>>>>        /* DMA, allocation, and size information */
>>>>        bool we_own_ring;
>>>>
>>>> +     /* Wait for buffer to be used */
>>>> +     wait_queue_head_t wq;
>>>> +
>>>>   #ifdef DEBUG
>>>>        /* They're supposed to lock for us. */
>>>>        unsigned int in_use;
>>>> @@ -2024,6 +2029,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
>>>>        if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>>>>                vq->weak_barriers = false;
>>>>
>>>> +     init_waitqueue_head(&vq->wq);
>>>> +
>>>>        err = vring_alloc_state_extra_packed(&vring_packed);
>>>>        if (err)
>>>>                goto err_state_extra;
>>>> @@ -2517,6 +2524,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>>>>        if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>>>>                vq->weak_barriers = false;
>>>>
>>>> +     init_waitqueue_head(&vq->wq);
>>>> +
>>>>        err = vring_alloc_state_extra_split(vring_split);
>>>>        if (err) {
>>>>                kfree(vq);
>>>> @@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
>>>>   {
>>>>        struct vring_virtqueue *vq = to_vvq(_vq);
>>>>
>>>> +     wake_up_interruptible(&vq->wq);
>>>> +
>>>>        if (vq->we_own_ring) {
>>>>                if (vq->packed_ring) {
>>>>                        vring_free_queue(vq->vq.vdev,
>>>> @@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(virtqueue_get_vring);
>>>>
>>>> +int virtqueue_wait_for_used(struct virtqueue *_vq)
>>>> +{
>>>> +     struct vring_virtqueue *vq = to_vvq(_vq);
>>>> +
>>>> +     /* TODO: Tweak the timeout. */
>>>> +     return wait_event_interruptible_timeout(vq->wq,
>>>> +            virtqueue_is_broken(_vq) || more_used(vq), HZ);
>>> There's no good timeout. Let's not even go there, if device goes
>>> bad it should set the need reset bit.
>> The problem is that we can't depend on the device. If it takes too
>> long for the device to respond to cvq, there's a high possibility that
>> the device is buggy or even malicious. We can have a higher timeout
>> here and it should be still better than waiting forever (the cvq
>> commands need to be serialized so it needs to hold a lock anyway
>> (RTNL) ).
>>
>> Thanks
> With a TODO item like this I'd expect this to be an RFC.
> Here's why:
>
> Making driver more robust from device failures is a laudable goal but it's really
> hard to be 100% foolproof here. E.g. device can just block pci reads and
> it would be very hard to recover.


Yes.


>    So I'm going to only merge patches
> like this if they at least theoretically have very little chance
> of breaking existing users.


AFAIK, this is not theoretical, consider:

1) DPU may implement virtio-net CVQ with codes running in CPU
2) VDUSE may want to support CVQ in the future


>
> And note that in most setups, CVQ is only used at startup and then left mostly alone.
>
> Finally, note that lots of guests need virtio to do anything useful at all.
> So just failing commands is not enough to recover - you need to try
> harder maybe by attempting to reset device.


This requires upper layer support which seems not existed in the 
networking subsystem.


> Could be a question of
> policy - might need to make this guest configurable.


Yes.

Thanks


>
>
>
>>>
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
>>>> +
>>>> +void virtqueue_wake_up(struct virtqueue *_vq)
>>>> +{
>>>> +     struct vring_virtqueue *vq = to_vvq(_vq);
>>>> +
>>>> +     wake_up_interruptible(&vq->wq);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(virtqueue_wake_up);
>>>> +
>>>>   MODULE_LICENSE("GPL");
>>>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>>>> index dcab9c7e8784..2eb62c774895 100644
>>>> --- a/include/linux/virtio.h
>>>> +++ b/include/linux/virtio.h
>>>> @@ -72,6 +72,9 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
>>>>   void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
>>>>                            void **ctx);
>>>>
>>>> +int virtqueue_wait_for_used(struct virtqueue *vq);
>>>> +void virtqueue_wake_up(struct virtqueue *vq);
>>>> +
>>>>   void virtqueue_disable_cb(struct virtqueue *vq);
>>>>
>>>>   bool virtqueue_enable_cb(struct virtqueue *vq);
>>>> --
>>>> 2.25.1

