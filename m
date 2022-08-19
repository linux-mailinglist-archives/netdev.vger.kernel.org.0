Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CE599A5D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348504AbiHSLCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348489AbiHSLC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:02:29 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EC2F61A5;
        Fri, 19 Aug 2022 04:02:26 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 6B1F510087D60;
        Fri, 19 Aug 2022 19:02:22 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 2DBE737C83F;
        Fri, 19 Aug 2022 19:02:22 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0dBLnWp56NuV; Fri, 19 Aug 2022 19:02:22 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id E62CD37C83E;
        Fri, 19 Aug 2022 19:02:21 +0800 (CST)
Date:   Fri, 19 Aug 2022 19:02:21 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma <eperezma@redhat.com>
Cc:     jasowang <jasowang@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <984124417.8446289.1660906941482.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <CAJaqyWcq++TmtMsGnn-j=6oAb7+f32P-WC5XRz0L2rEKJ4Sotw@mail.gmail.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn> <CAJaqyWcq++TmtMsGnn-j=6oAb7+f32P-WC5XRz0L2rEKJ4Sotw@mail.gmail.com>
Subject: Re: [RFC v2 1/7] vhost: expose used buffers
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [113.222.45.197]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: expose used buffers
Thread-Index: ZUVniTisaWLV2fp0YDfuwjUwIrJe5A==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "eperezma" <eperezma@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin" <mst@redhat.com>, "netdev"
> <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Thursday, August 18, 2022 2:16:40 PM
> Subject: Re: [RFC v2 1/7] vhost: expose used buffers

> On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>>
>> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
>> of descriptors.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/vhost/vhost.c | 14 ++++++++++++--
>>  drivers/vhost/vhost.h |  1 +
>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826cff0..7b20fa5a46c3 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue
>> *vq,
>>         vring_used_elem_t __user *used;
>>         u16 old, new;
>>         int start;
>> +       int copy_n = count;
>>
>> +       /**
>> +        * If in order feature negotiated, devices can notify the use of a batch
>> of buffers to
>> +        * the driver by only writing out a single used ring entry with the id
>> corresponding
>> +        * to the head entry of the descriptor chain describing the last buffer
>> in the batch.
>> +        */
>> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> +               copy_n = 1;
>> +               heads = &heads[count - 1];
>> +       }
>>         start = vq->last_used_idx & (vq->num - 1);
>>         used = vq->used->ring + start;
>> -       if (vhost_put_used(vq, heads, start, count)) {
>> +       if (vhost_put_used(vq, heads, start, copy_n)) {
>>                 vq_err(vq, "Failed to write used");
>>                 return -EFAULT;
>>         }
>> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> vring_used_elem *heads,
>>
>>         start = vq->last_used_idx & (vq->num - 1);
>>         n = vq->num - start;
>> -       if (n < count) {
>> +       if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>>                 r = __vhost_add_used_n(vq, heads, n);
>>                 if (r < 0)
>>                         return r;
> 
> It would be simpler to use vhost_add_used in vsock/vhost_test to add a
> batch of used descriptors, and leave vhost_add_used_n untouched.
> 
> Since it's the upper layer the one that manages the in_order in this
> version, we could:
> * Always call vhost_add_used(vq, last_head_of_batch, ...) for the tx
> queue, that does not need used length info.
> * Call vhost_add_used_n for the rx queue, since the driver needs the
> used length info.
 
Very insightful view!

At first, vhost_add_used will write used ring for skipped buffer in a batch,
so we can't let vhost unmodified to enable in order feature.

Secondly, Current changes to vhost_add_used_n will affect the rx queue,
as driver have to get each buffer's length from used ring.

So I would propose a flag parameter in vhost_add_used_n to decide
whether the batch for in order buffer is done or nor.
 
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index d9109107af08..0d5c49a30421 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -236,6 +236,7 @@ enum {
>>         VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>>                          (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
>>                          (1ULL << VIRTIO_RING_F_EVENT_IDX) |
>> +                        (1ULL << VIRTIO_F_IN_ORDER) |
>>                          (1ULL << VHOST_F_LOG_ALL) |
>>                          (1ULL << VIRTIO_F_ANY_LAYOUT) |
>>                          (1ULL << VIRTIO_F_VERSION_1)
>> --
>> 2.17.1
>>
