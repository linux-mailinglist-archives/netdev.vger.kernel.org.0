Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF87B597C2A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbiHRDP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242979AbiHRDPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:15:55 -0400
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC11A7AA0;
        Wed, 17 Aug 2022 20:15:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VMYvRrq_1660792547;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VMYvRrq_1660792547)
          by smtp.aliyun-inc.com;
          Thu, 18 Aug 2022 11:15:47 +0800
Message-ID: <1660792318.4436166-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring
Date:   Thu, 18 Aug 2022 11:11:58 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        jasowang@redhat.com, sgarzare@redhat.com, mst@redhat.com
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 21:57:17 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
> If in order feature negotiated, we can skip the used ring to get
> buffer's desc id sequentially.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 1c1b3fa376a2..143184ebb5a1 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>  			/* DMA address and size information */
>  			dma_addr_t queue_dma_addr;
>  			size_t queue_size_in_bytes;
> +
> +			/* In order feature batch begin here */
> +			u16 next_desc_begin;
>  		} split;
>
>  		/* Available for packed ring */
> @@ -702,8 +705,13 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	}
>
>  	vring_unmap_one_split(vq, i);
> -	vq->split.desc_extra[i].next = vq->free_head;
> -	vq->free_head = head;
> +	/* In order feature use desc in order,
> +	 * that means, the next desc will always be free
> +	 */
> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {

Call virtio_has_feature() here is not good.

Thanks.

> +		vq->split.desc_extra[i].next = vq->free_head;
> +		vq->free_head = head;
> +	}
>
>  	/* Plus final descriptor */
>  	vq->vq.num_free++;
> @@ -745,7 +753,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  	void *ret;
> -	unsigned int i;
> +	unsigned int i, j;
>  	u16 last_used;
>
>  	START_USE(vq);
> @@ -764,11 +772,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>  	/* Only get used array entries after they have been exposed by host. */
>  	virtio_rmb(vq->weak_barriers);
>
> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> -	i = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].id);
> -	*len = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].len);
> +	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
> +		/* Skip used ring and get used desc in order*/
> +		i = vq->split.next_desc_begin;
> +		j = i;
> +		/* Indirect only takes one descriptor in descriptor table */
> +		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
> +			j = (j + 1) % vq->split.vring.num;
> +		/* move to next */
> +		j = (j + 1) % vq->split.vring.num;
> +		/* Next buffer will use this descriptor in order */
> +		vq->split.next_desc_begin = j;
> +		if (!vq->indirect) {
> +			*len = vq->split.desc_extra[i].len;
> +		} else {
> +			struct vring_desc *indir_desc =
> +				vq->split.desc_state[i].indir_desc;
> +			u32 indir_num = vq->split.desc_extra[i].len, buffer_len = 0;
> +
> +			if (indir_desc) {
> +				for (j = 0; j < indir_num / sizeof(struct vring_desc); j++)
> +					buffer_len += indir_desc[j].len;
> +			}
> +
> +			*len = buffer_len;
> +		}
> +	} else {
> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> +		i = virtio32_to_cpu(_vq->vdev,
> +				    vq->split.vring.used->ring[last_used].id);
> +		*len = virtio32_to_cpu(_vq->vdev,
> +				       vq->split.vring.used->ring[last_used].len);
> +	}
>
>  	if (unlikely(i >= vq->split.vring.num)) {
>  		BAD_RING(vq, "id %u out of range\n", i);
> @@ -2236,6 +2271,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->split.avail_flags_shadow = 0;
>  	vq->split.avail_idx_shadow = 0;
>
> +	vq->split.next_desc_begin = 0;
> +
>  	/* No callback?  Tell other side not to bother us. */
>  	if (!callback) {
>  		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> --
> 2.17.1
>
