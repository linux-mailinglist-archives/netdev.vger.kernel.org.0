Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38A4583A14
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiG1INA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiG1IM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:12:58 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1A055086;
        Thu, 28 Jul 2022 01:12:56 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 5B98C1008B393;
        Thu, 28 Jul 2022 16:12:52 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 34CAD2008BD4F;
        Thu, 28 Jul 2022 16:12:52 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7I_j8N54BGeu; Thu, 28 Jul 2022 16:12:50 +0800 (CST)
Received: from [192.168.24.189] (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 4A714200BFDA8;
        Thu, 28 Jul 2022 16:12:40 +0800 (CST)
Message-ID: <f4612182-698b-c687-17c8-610c890adcf9@sjtu.edu.cn>
Date:   Thu, 28 Jul 2022 16:12:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 4/5] virtio: get desc id in order
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-5-qtxuning1999@sjtu.edu.cn>
 <9d4c24de-f2cc-16a0-818a-16695946f3a3@redhat.com>
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
In-Reply-To: <9d4c24de-f2cc-16a0-818a-16695946f3a3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/7/26 16:07, Jason Wang wrote:
>
> 在 2022/7/21 16:43, Guo Zhi 写道:
>> If in order feature negotiated, we can skip the used ring to get
>> buffer's desc id sequentially.
>
>
> Let's rename the patch to something like "in order support for 
> virtio_ring"
>
>
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/virtio/virtio_ring.c | 37 ++++++++++++++++++++++++++++--------
>>   1 file changed, 29 insertions(+), 8 deletions(-)
>
>
> I don't see packed support in this patch, we need to implement that.
>
It will be implemented later.
>
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index a5ec724c0..4d57a4edc 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>>               /* DMA address and size information */
>>               dma_addr_t queue_dma_addr;
>>               size_t queue_size_in_bytes;
>> +
>> +            /* In order feature batch begin here */
>> +            u16 next_batch_desc_begin;
>>           } split;
>>             /* Available for packed ring */
>> @@ -700,8 +703,10 @@ static void detach_buf_split(struct 
>> vring_virtqueue *vq, unsigned int head,
>>       }
>>         vring_unmap_one_split(vq, i);
>> -    vq->split.desc_extra[i].next = vq->free_head;
>> -    vq->free_head = head;
>> +    if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
>> +        vq->split.desc_extra[i].next = vq->free_head;
>> +        vq->free_head = head;
>> +    }
>
>
> Let's add a comment to explain why we don't need anything if in order 
> is neogitated.
>
LGTM.
>
>>         /* Plus final descriptor */
>>       vq->vq.num_free++;
>> @@ -743,7 +748,8 @@ static void *virtqueue_get_buf_ctx_split(struct 
>> virtqueue *_vq,
>>   {
>>       struct vring_virtqueue *vq = to_vvq(_vq);
>>       void *ret;
>> -    unsigned int i;
>> +    __virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, 
>> VRING_DESC_F_NEXT);
>> +    unsigned int i, j;
>>       u16 last_used;
>>         START_USE(vq);
>> @@ -762,11 +768,24 @@ static void *virtqueue_get_buf_ctx_split(struct 
>> virtqueue *_vq,
>>       /* Only get used array entries after they have been exposed by 
>> host. */
>>       virtio_rmb(vq->weak_barriers);
>>   -    last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
>> -    i = virtio32_to_cpu(_vq->vdev,
>> -            vq->split.vring.used->ring[last_used].id);
>> -    *len = virtio32_to_cpu(_vq->vdev,
>> -            vq->split.vring.used->ring[last_used].len);
>> +    if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
>> +        /* Skip used ring and get used desc in order*/
>> +        i = vq->split.next_batch_desc_begin;
>> +        j = i;
>> +        while (vq->split.vring.desc[j].flags & nextflag)
>
>
> Let's don't depend on the descriptor ring which is under the control 
> of the malicious hypervisor.
>
> Let's use desc_extra that is not visible by the hypervisor. More can 
> be seen in this commit:
>
> 72b5e8958738 ("virtio-ring: store DMA metadata in desc_extra for split 
> virtqueue")
>
LGTM, I will use desc_extra in new version patch.
>
>> +            j = (j + 1) % vq->split.vring.num;
>> +        /* move to next */
>> +        j = (j + 1) % vq->split.vring.num;
>> +        vq->split.next_batch_desc_begin = j;
>
>
> I'm not sure I get the logic here, basically I think we should check 
> buffer instead of descriptor here.

Because the vq->last_used_idx != vq->split.vring.used->idx, So the 
virtio driver know these has at least one used descriptor. the 
descriptor's id is vq->split.next_batch_desc_begin because of in order. 
Then we have to traverse the descriptor chain and point 
vq->split.next_batch_desc_begin to next used descriptor.

Thanks.

>
> So if vring.used->ring[last_used].id != last_used, we know all 
> [last_used, vring.used->ring[last_used].id] have been used in a batch?
>
>
>> +
>> +        /* TODO: len of buffer */
>
>
> So spec said:
>
> "
>
> The skipped buffers (for which no used ring entry was written) are 
> assumed to have been used (read or written) by the device completely.
>
>
> "
>
> Thanks
>
The driver will need len in used ring to get buffer size. However in 
order will not write len of each buffer in used ring. So I will tried 
pass len of buffer in device header.
>
>> +    } else {
>> +        last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
>> +        i = virtio32_to_cpu(_vq->vdev,
>> + vq->split.vring.used->ring[last_used].id);
>> +        *len = virtio32_to_cpu(_vq->vdev,
>> + vq->split.vring.used->ring[last_used].len);
>> +    }
>>         if (unlikely(i >= vq->split.vring.num)) {
>>           BAD_RING(vq, "id %u out of range\n", i);
>> @@ -2234,6 +2253,8 @@ struct virtqueue 
>> *__vring_new_virtqueue(unsigned int index,
>>       vq->split.avail_flags_shadow = 0;
>>       vq->split.avail_idx_shadow = 0;
>>   +    vq->split.next_batch_desc_begin = 0;
>> +
>>       /* No callback?  Tell other side not to bother us. */
>>       if (!callback) {
>>           vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
>

