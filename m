Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C1597C25
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiHRDRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242979AbiHRDRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:17:05 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6349AA831D;
        Wed, 17 Aug 2022 20:17:02 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 07BE91008B389;
        Thu, 18 Aug 2022 11:16:59 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id D920F37C894;
        Thu, 18 Aug 2022 11:16:59 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id g2F2qLtILvBE; Thu, 18 Aug 2022 11:16:59 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id A3DBD37C893;
        Thu, 18 Aug 2022 11:16:59 +0800 (CST)
Date:   Thu, 18 Aug 2022 11:16:59 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        eperezma <eperezma@redhat.com>, jasowang <jasowang@redhat.com>,
        sgarzare <sgarzare@redhat.com>, Michael Tsirkin <mst@redhat.com>
Message-ID: <1091620326.8333566.1660792619533.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <1660792318.4436166-3-xuanzhuo@linux.alibaba.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn> <1660792318.4436166-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [36.148.65.198]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: in order support for virtio_ring
Thread-Index: V9KFug4AVD63FIQF+R2n8Bnz0889Jw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>, "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma"
> <eperezma@redhat.com>, "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin"
> <mst@redhat.com>
> Sent: Thursday, August 18, 2022 11:11:58 AM
> Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring

> On Wed, 17 Aug 2022 21:57:17 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>> If in order feature negotiated, we can skip the used ring to get
>> buffer's desc id sequentially.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++------
>>  1 file changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 1c1b3fa376a2..143184ebb5a1 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>>  			/* DMA address and size information */
>>  			dma_addr_t queue_dma_addr;
>>  			size_t queue_size_in_bytes;
>> +
>> +			/* In order feature batch begin here */
>> +			u16 next_desc_begin;
>>  		} split;
>>
>>  		/* Available for packed ring */
>> @@ -702,8 +705,13 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>  	}
>>
>>  	vring_unmap_one_split(vq, i);
>> -	vq->split.desc_extra[i].next = vq->free_head;
>> -	vq->free_head = head;
>> +	/* In order feature use desc in order,
>> +	 * that means, the next desc will always be free
>> +	 */
>> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
> 
> Call virtio_has_feature() here is not good.
> 
> Thanks.
> 

Maybe I can use a variable like vq->indiret?
Thanks.

>> +		vq->split.desc_extra[i].next = vq->free_head;
>> +		vq->free_head = head;
>> +	}
>>
>>  	/* Plus final descriptor */
>>  	vq->vq.num_free++;
>> @@ -745,7 +753,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>  {
>>  	struct vring_virtqueue *vq = to_vvq(_vq);
>>  	void *ret;
>> -	unsigned int i;
>> +	unsigned int i, j;
>>  	u16 last_used;
>>
>>  	START_USE(vq);
>> @@ -764,11 +772,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue
>> *_vq,
>>  	/* Only get used array entries after they have been exposed by host. */
>>  	virtio_rmb(vq->weak_barriers);
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
>>  	if (unlikely(i >= vq->split.vring.num)) {
>>  		BAD_RING(vq, "id %u out of range\n", i);
>> @@ -2236,6 +2271,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int
>> index,
>>  	vq->split.avail_flags_shadow = 0;
>>  	vq->split.avail_idx_shadow = 0;
>>
>> +	vq->split.next_desc_begin = 0;
>> +
>>  	/* No callback?  Tell other side not to bother us. */
>>  	if (!callback) {
>>  		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
>> --
>> 2.17.1
>>
