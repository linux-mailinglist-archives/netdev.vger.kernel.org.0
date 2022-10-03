Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13505F2FAE
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJCLch convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Oct 2022 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJCLce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:32:34 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E89D3ECFC;
        Mon,  3 Oct 2022 04:32:32 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 4EE181008B388;
        Mon,  3 Oct 2022 19:32:20 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 4475337C894;
        Mon,  3 Oct 2022 19:32:20 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J7WWTuoaNlsJ; Mon,  3 Oct 2022 19:32:20 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 1524437C893;
        Mon,  3 Oct 2022 19:32:20 +0800 (CST)
Date:   Mon, 3 Oct 2022 19:32:19 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1184679327.3310578.1664796739583.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <b1a7c454-860d-6a40-9da1-2a06f30ff1be@redhat.com>
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-7-qtxuning1999@sjtu.edu.cn> <b1a7c454-860d-6a40-9da1-2a06f30ff1be@redhat.com>
Subject: Re: [RFC v3 6/7] virtio: in order support for virtio_ring
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [202.120.40.82]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: in order support for virtio_ring
Thread-Index: WmAeKxuTlnmo+iVwtRyYMcu3mA5FRQ==
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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
> Sent: Wednesday, September 7, 2022 1:38:03 PM
> Subject: Re: [RFC v3 6/7] virtio: in order support for virtio_ring

> ÔÚ 2022/9/1 13:54, Guo Zhi Ð´µÀ:
>> If in order feature negotiated, we can skip the used ring to get
>> buffer's desc id sequentially.  For skipped buffers in the batch, the
>> used ring doesn't contain the buffer length, actually there is not need
>> to get skipped buffers' length as they are tx buffer.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/virtio/virtio_ring.c | 74 +++++++++++++++++++++++++++++++-----
>>   1 file changed, 64 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 00aa4b7a49c2..d52624179b43 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -103,6 +103,9 @@ struct vring_virtqueue {
>>   	/* Host supports indirect buffers */
>>   	bool indirect;
>>   
>> +	/* Host supports in order feature */
>> +	bool in_order;
>> +
>>   	/* Host publishes avail event idx */
>>   	bool event;
>>   
>> @@ -144,6 +147,19 @@ struct vring_virtqueue {
>>   			/* DMA address and size information */
>>   			dma_addr_t queue_dma_addr;
>>   			size_t queue_size_in_bytes;
>> +
>> +			/* If in_order feature is negotiated, here is the next head to consume */
>> +			u16 next_desc_begin;
>> +			/*
>> +			 * If in_order feature is negotiated,
>> +			 * here is the last descriptor's id in the batch
>> +			 */
>> +			u16 last_desc_in_batch;
>> +			/*
>> +			 * If in_order feature is negotiated,
>> +			 * buffers except last buffer in the batch are skipped buffer
>> +			 */
>> +			bool is_skipped_buffer;
>>   		} split;
>>   
>>   		/* Available for packed ring */
>> @@ -584,8 +600,6 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>   					 total_sg * sizeof(struct vring_desc),
>>   					 VRING_DESC_F_INDIRECT,
>>   					 false);
>> -		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
>> -			~VRING_DESC_F_NEXT;
> 
> 
> This seems irrelevant.
> 
> 
>>   	}
>>   
>>   	/* We're using some buffers from the free list. */
>> @@ -701,8 +715,16 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>   	}
>>   
>>   	vring_unmap_one_split(vq, i);
>> -	vq->split.desc_extra[i].next = vq->free_head;
>> -	vq->free_head = head;
>> +	/*
>> +	 * If in_order feature is negotiated,
>> +	 * the descriptors are made available in order.
>> +	 * Since the free_head is already a circular list,
>> +	 * it must consume it sequentially.
>> +	 */
>> +	if (!vq->in_order) {
>> +		vq->split.desc_extra[i].next = vq->free_head;
>> +		vq->free_head = head;
>> +	}
>>   
>>   	/* Plus final descriptor */
>>   	vq->vq.num_free++;
>> @@ -744,7 +766,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>   {
>>   	struct vring_virtqueue *vq = to_vvq(_vq);
>>   	void *ret;
>> -	unsigned int i;
>> +	unsigned int i, j;
>>   	u16 last_used;
>>   
>>   	START_USE(vq);
>> @@ -763,11 +785,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>   	/* Only get used array entries after they have been exposed by host. */
>>   	virtio_rmb(vq->weak_barriers);
>>   
>> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
>> -	i = virtio32_to_cpu(_vq->vdev,
>> -			vq->split.vring.used->ring[last_used].id);
>> -	*len = virtio32_to_cpu(_vq->vdev,
>> -			vq->split.vring.used->ring[last_used].len);
>> +	if (vq->in_order) {
>> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> 
> 
> Let's move this beyond the in_order check.
> 
> 
>> +		if (!vq->split.is_skipped_buffer) {
>> +			vq->split.last_desc_in_batch =
>> +				virtio32_to_cpu(_vq->vdev,
>> +						vq->split.vring.used->ring[last_used].id);
>> +			vq->split.is_skipped_buffer = true;
>> +		}
>> +		/* For skipped buffers in batch, we can ignore the len info, simply set len
>> as 0 */
> 
> 
> This seems to break the caller that depends on a correct len.
> 
> 
>> +		if (vq->split.next_desc_begin != vq->split.last_desc_in_batch) {
>> +			*len = 0;
>> +		} else {
>> +			*len = virtio32_to_cpu(_vq->vdev,
>> +					       vq->split.vring.used->ring[last_used].len);
>> +			vq->split.is_skipped_buffer = false;
>> +		}
>> +		i = vq->split.next_desc_begin;
>> +		j = i;
>> +		/* Indirect only takes one descriptor in descriptor table */
>> +		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
>> +			j = (j + 1) & (vq->split.vring.num - 1);
> 
> 
> Any reason indirect descriptors can't be chained?
> 

If the descriptor is indirect, we only take one slot in the descriptor ring. We are just calculating the number of entries here.
If indirect is chained, it still fill only one slot in the vring.

Thanks

> 
>> +		/* move to next */
>> +		j = (j + 1) % vq->split.vring.num;
>> +		/* Next buffer will use this descriptor in order */
>> +		vq->split.next_desc_begin = j;
> 
> 
> Is it more efficient to poke the available ring?
> 
> Thanks
> 
The available ring is under the guest's control and it may modify it.
Access to avail vring would be another indirection too.

Thanks
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
>> @@ -2223,6 +2272,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int
>> index,
>>   
>>   	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>>   		!context;
>> +	vq->in_order = virtio_has_feature(vdev, VIRTIO_F_IN_ORDER);
>>   	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
>>   
>>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>> @@ -2235,6 +2285,10 @@ struct virtqueue *__vring_new_virtqueue(unsigned int
>> index,
>>   	vq->split.avail_flags_shadow = 0;
>>   	vq->split.avail_idx_shadow = 0;
>>   
>> +	vq->split.next_desc_begin = 0;
>> +	vq->split.last_desc_in_batch = 0;
>> +	vq->split.is_skipped_buffer = false;
>> +
>>   	/* No callback?  Tell other side not to bother us. */
>>   	if (!callback) {
>>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
