Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392C158F981
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiHKItM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Aug 2022 04:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiHKItJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:49:09 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E1915C1;
        Thu, 11 Aug 2022 01:49:07 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 3279810087D60;
        Thu, 11 Aug 2022 16:49:03 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id C96CB37C841;
        Thu, 11 Aug 2022 16:49:02 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HGne9ZKrBEwj; Thu, 11 Aug 2022 16:49:02 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 8513337C83E;
        Thu, 11 Aug 2022 16:49:02 +0800 (CST)
Date:   Thu, 11 Aug 2022 16:49:02 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <626955266.7203994.1660207742134.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <9d4c24de-f2cc-16a0-818a-16695946f3a3@redhat.com>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-5-qtxuning1999@sjtu.edu.cn> <9d4c24de-f2cc-16a0-818a-16695946f3a3@redhat.com>
Subject: Re: [RFC 4/5] virtio: get desc id in order
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [43.250.201.29]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: get desc id in order
Thread-Index: cXlU9o42KwIFHsTFxE07x53ZKbWCSQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "jasowang" <jasowang@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael
> Tsirkin" <mst@redhat.com>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Tuesday, July 26, 2022 4:07:46 PM
> Subject: Re: [RFC 4/5] virtio: get desc id in order

> ÔÚ 2022/7/21 16:43, Guo Zhi Ð´µÀ:
>> If in order feature negotiated, we can skip the used ring to get
>> buffer's desc id sequentially.
> 
> 
> Let's rename the patch to something like "in order support for virtio_ring"
> 
> 
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/virtio/virtio_ring.c | 37 ++++++++++++++++++++++++++++--------
>>   1 file changed, 29 insertions(+), 8 deletions(-)
> 
> 
> I don't see packed support in this patch, we need to implement that.
> 
> 
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index a5ec724c0..4d57a4edc 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>>   			/* DMA address and size information */
>>   			dma_addr_t queue_dma_addr;
>>   			size_t queue_size_in_bytes;
>> +
>> +			/* In order feature batch begin here */
>> +			u16 next_batch_desc_begin;
>>   		} split;
>>   
>>   		/* Available for packed ring */
>> @@ -700,8 +703,10 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>   	}
>>   
>>   	vring_unmap_one_split(vq, i);
>> -	vq->split.desc_extra[i].next = vq->free_head;
>> -	vq->free_head = head;
>> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
>> +		vq->split.desc_extra[i].next = vq->free_head;
>> +		vq->free_head = head;
>> +	}
> 
> 
> Let's add a comment to explain why we don't need anything if in order is
> neogitated.
> 
> 
>>   
>>   	/* Plus final descriptor */
>>   	vq->vq.num_free++;
>> @@ -743,7 +748,8 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>   {
>>   	struct vring_virtqueue *vq = to_vvq(_vq);
>>   	void *ret;
>> -	unsigned int i;
>> +	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
>> +	unsigned int i, j;
>>   	u16 last_used;
>>   
>>   	START_USE(vq);
>> @@ -762,11 +768,24 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>   	/* Only get used array entries after they have been exposed by host. */
>>   	virtio_rmb(vq->weak_barriers);
>>   
>> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
>> -	i = virtio32_to_cpu(_vq->vdev,
>> -			vq->split.vring.used->ring[last_used].id);
>> -	*len = virtio32_to_cpu(_vq->vdev,
>> -			vq->split.vring.used->ring[last_used].len);
>> +	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
>> +		/* Skip used ring and get used desc in order*/
>> +		i = vq->split.next_batch_desc_begin;
>> +		j = i;
>> +		while (vq->split.vring.desc[j].flags & nextflag)
> 
> 
> Let's don't depend on the descriptor ring which is under the control of
> the malicious hypervisor.
> 
> Let's use desc_extra that is not visible by the hypervisor. More can be
> seen in this commit:
> 
> 72b5e8958738 ("virtio-ring: store DMA metadata in desc_extra for split
> virtqueue")
> 
> 
>> +			j = (j + 1) % vq->split.vring.num;
>> +		/* move to next */
>> +		j = (j + 1) % vq->split.vring.num;
>> +		vq->split.next_batch_desc_begin = j;
> 
> 
> I'm not sure I get the logic here, basically I think we should check
> buffer instead of descriptor here.

I's sorry I don't understand this comment.
In order means device use descriptors in the same order as they been available.
So we should iterate the descriptor table and calculte the next desc which will be used,
because we don't use used ring now.

> 
> So if vring.used->ring[last_used].id != last_used, we know all
> [last_used, vring.used->ring[last_used].id] have been used in a batch?
> 

We don't use used ring for in order feature.
N descriptors in descriptor table from vq->split.next_batch_desc_begin have been used.
N is vq->split.vring.used->idx - vq->last_used_idx (haven't consider ring problem for short).

> 
>> +
>> +		/* TODO: len of buffer */
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
> 
>> +	} else {
>> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
>> +		i = virtio32_to_cpu(_vq->vdev,
>> +				    vq->split.vring.used->ring[last_used].id);
>> +		*len = virtio32_to_cpu(_vq->vdev,
>> +				       vq->split.vring.used->ring[last_used].len);
>> +	}
>>   
>>   	if (unlikely(i >= vq->split.vring.num)) {
>>   		BAD_RING(vq, "id %u out of range\n", i);
>> @@ -2234,6 +2253,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int
>> index,
>>   	vq->split.avail_flags_shadow = 0;
>>   	vq->split.avail_idx_shadow = 0;
>>   
>> +	vq->split.next_batch_desc_begin = 0;
>> +
>>   	/* No callback?  Tell other side not to bother us. */
>>   	if (!callback) {
>>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
