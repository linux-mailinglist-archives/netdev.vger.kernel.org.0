Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8DB5A1F65
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbiHZDS2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 23:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiHZDS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:18:26 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711E1CACA0;
        Thu, 25 Aug 2022 20:18:25 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 0AFF01008B38D;
        Fri, 26 Aug 2022 11:18:22 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id C742D37C893;
        Fri, 26 Aug 2022 11:18:22 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ac8wfnO9bUGB; Fri, 26 Aug 2022 11:18:22 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 9995E37C894;
        Fri, 26 Aug 2022 11:18:22 +0800 (CST)
Date:   Fri, 26 Aug 2022 11:18:21 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1625987692.9093267.1661483901701.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <ebf4b376-6a5c-3cfa-38ab-1559ace13b27@redhat.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn> <ebf4b376-6a5c-3cfa-38ab-1559ace13b27@redhat.com>
Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.166.246.247]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: in order support for virtio_ring
Thread-Index: 1vFj+paB+wRk8wd+9SUq6j4kd2DDhA==
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
> Sent: Thursday, August 25, 2022 3:44:41 PM
> Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring

> ÔÚ 2022/8/17 21:57, Guo Zhi Ð´µÀ:
>> If in order feature negotiated, we can skip the used ring to get
>> buffer's desc id sequentially.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++------
>>   1 file changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 1c1b3fa376a2..143184ebb5a1 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>>   			/* DMA address and size information */
>>   			dma_addr_t queue_dma_addr;
>>   			size_t queue_size_in_bytes;
>> +
>> +			/* In order feature batch begin here */
> 
> 
> We need tweak the comment, it's not easy for me to understand the
> meaning here.
> 
> 
>> +			u16 next_desc_begin;
>>   		} split;
>>   
>>   		/* Available for packed ring */
>> @@ -702,8 +705,13 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>   	}
>>   
>>   	vring_unmap_one_split(vq, i);
>> -	vq->split.desc_extra[i].next = vq->free_head;
>> -	vq->free_head = head;
>> +	/* In order feature use desc in order,
>> +	 * that means, the next desc will always be free
>> +	 */
> 
> 
> Maybe we should add something like "The descriptors are prepared in order".
> 
> 
>> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
>> +		vq->split.desc_extra[i].next = vq->free_head;
>> +		vq->free_head = head;
>> +	}
>>   
>>   	/* Plus final descriptor */
>>   	vq->vq.num_free++;
>> @@ -745,7 +753,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>   {
>>   	struct vring_virtqueue *vq = to_vvq(_vq);
>>   	void *ret;
>> -	unsigned int i;
>> +	unsigned int i, j;
>>   	u16 last_used;
>>   
>>   	START_USE(vq);
>> @@ -764,11 +772,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
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
>> +		i = vq->split.next_desc_begin;
>> +		j = i;
>> +		/* Indirect only takes one descriptor in descriptor table */
>> +		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
>> +			j = (j + 1) % vq->split.vring.num;
> 
> 
> Let's move the expensive mod outside the loop. Or it's split so we can
> use and here actually since the size is guaranteed to be power of the
> two? Another question, is it better to store the next_desc in e.g
> desc_extra?
> 
> And this seems very expensive if the device doesn't do the batching
> (which is not mandatory).
> 
> 
>> +		/* move to next */
>> +		j = (j + 1) % vq->split.vring.num;
>> +		/* Next buffer will use this descriptor in order */
>> +		vq->split.next_desc_begin = j;
>> +		if (!vq->indirect) {
>> +			*len = vq->split.desc_extra[i].len;
>> +		} else {
>> +			struct vring_desc *indir_desc =
>> +				vq->split.desc_state[i].indir_desc;
>> +			u32 indir_num = vq->split.desc_extra[i].len, buffer_len = 0;
>> +
>> +			if (indir_desc) {
>> +				for (j = 0; j < indir_num / sizeof(struct vring_desc); j++)
>> +					buffer_len += indir_desc[j].len;
> 
> 
> So I think we need to finalize this, then we can have much more stress
> on the cache:
> 
> https://lkml.org/lkml/2021/10/26/1300
> 
> It was reverted since it's too aggressive, we should instead:
> 
> 1) do the validation only for morden device
> 
> 2) fail only when we enable the validation via (e.g a module parameter).
> 
> Thanks
> 

Sorry for this obsolete implementation, we will not get buffer'len like this(in a loop).
Actually, for not skipped buffers, we can get length from used ring directly, for skipped buffers
I think we don¡¯t have to get the length, because the driver is not interested in the skipped buffers(tx)¡¯ length.

> 
>> +			}
>> +
>> +			*len = buffer_len;
>> +		}
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
>> @@ -2236,6 +2271,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int
>> index,
>>   	vq->split.avail_flags_shadow = 0;
>>   	vq->split.avail_idx_shadow = 0;
>>   
>> +	vq->split.next_desc_begin = 0;
>> +
>>   	/* No callback?  Tell other side not to bother us. */
>>   	if (!callback) {
>>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
