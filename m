Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4308443C5AA
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhJ0I5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:57:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231566AbhJ0I5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635324924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rd+1bM1NgvdCjYjFOKUmVGZTFl4DME6r0n7GbWzwCwA=;
        b=L/1T9AkmyLcha3+Gu7LfrfTUliJcUo7ZhQsX2S4gpKC9AK7LDcRDiUz1QIhM5GYpKnrC0W
        Z8sI+pnCUXqtwV8JlZNzvXQRtNAlDbU7zpj0CofYwRDjNkQ65nJuEpuWgLwXDGSvKaND5n
        R6neq8b5rtwhYupL2S2rjT/CwtlMX2Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-xzUD7dRJPu-2pGu7QdhR2Q-1; Wed, 27 Oct 2021 04:55:22 -0400
X-MC-Unique: xzUD7dRJPu-2pGu7QdhR2Q-1
Received: by mail-wr1-f71.google.com with SMTP id f1-20020a5d64c1000000b001611832aefeso400979wri.17
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rd+1bM1NgvdCjYjFOKUmVGZTFl4DME6r0n7GbWzwCwA=;
        b=GpNPjQXR/HtWLKccyBR7jCXSFLZjDqsT1TG6W8ZFXHtqP4NrERFoTcMENXEHlbaavi
         Nrt/sQbFPSYV4V17W+bBF/vaUqheuO5kA3OSZu582XMpwXX+xvB+u0IsNFMo7+aAxHlm
         x6bJdgidPST8lFRwFyThVjBqyaZm/cUIvWr4xrisuPFzhr9IrkgyRMlzOsQ+/eG0eyCk
         JeEnoGwhJPe2wolrIA79Uu/8FPbmnjLKdlHhTDOEp8/nRv3KACIIuKaUYm4UypGnKZ+g
         HI+MeKDzkCdp7HExxUfTeZ42L4jR5nVOIU65I6GFmmsOAwkkbxnST6bgydIxibxLTtOd
         qEYA==
X-Gm-Message-State: AOAM533ZVh5PH/syv9rzbyobh/6mkFBwzprv6qoSXxbKlCdhEsC00VTO
        mdtlTsyECw7angY2MtEIejcpWKZykHPU6+WU0fwWgPLl8c+L4PxBHlBhwbKmybVfUA41CRciRjn
        3N9BA0WrvU9OaZGEv
X-Received: by 2002:a5d:570c:: with SMTP id a12mr6556404wrv.418.1635324921464;
        Wed, 27 Oct 2021 01:55:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc0w1MFCM+zX4dw5/ef/iVgg5fZjAkE2o0ExvenlNFpYGQ7DD5QS1tyRk29+AUahZaPh7fmw==
X-Received: by 2002:a5d:570c:: with SMTP id a12mr6556379wrv.418.1635324921130;
        Wed, 27 Oct 2021 01:55:21 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id f9sm10848012wrx.31.2021.10.27.01.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:55:20 -0700 (PDT)
Date:   Wed, 27 Oct 2021 04:55:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/3] virtio: cache indirect desc for split
Message-ID: <20211027043851-mutt-send-email-mst@kernel.org>
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
 <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 02:19:11PM +0800, Xuan Zhuo wrote:
> In the case of using indirect, indirect desc must be allocated and
> released each time, which increases a lot of cpu overhead.
> 
> Here, a cache is added for indirect. If the number of indirect desc to be
> applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio.c      |  6 ++++
>  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++------
>  include/linux/virtio.h       | 10 ++++++
>  3 files changed, 70 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..04bcb74e5b9a 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(is_virtio_device);
>  
> +void virtio_use_desc_cache(struct virtio_device *dev, bool val)
> +{
> +	dev->desc_cache = val;
> +}
> +EXPORT_SYMBOL_GPL(virtio_use_desc_cache);
> +
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
>  	int index = dev->index; /* save for after device release */
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd95dfd85e98..0b9a8544b0e8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -117,6 +117,10 @@ struct vring_virtqueue {
>  	/* Hint for event idx: already triggered no need to disable. */
>  	bool event_triggered;
>  
> +	/* Is indirect cache used? */
> +	bool use_desc_cache;
> +	void *desc_cache_chain;
> +
>  	union {
>  		/* Available for split ring */
>  		struct {

Let's use llist_head and friends please (I am guessing we want
single-linked to avoid writing into indirect buffer after use,
invalidating the cache, but please document why in a comment).  Do not
open-code it.

Also hide all casts in inline wrappers.


> @@ -423,12 +427,47 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	return extra[i].next;
>  }
>  
> -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> +#define VIRT_QUEUE_CACHE_DESC_NUM 4

Add an inline wrapper for checking sg versus VIRT_QUEUE_CACHE_DESC_NUM.

> +
> +static void desc_cache_chain_free_split(void *chain)
> +{
> +	struct vring_desc *desc;
> +
> +	while (chain) {
> +		desc = chain;
> +		chain = (void *)desc->addr;
> +		kfree(desc);
> +	}
> +}
> +
> +static void desc_cache_put_split(struct vring_virtqueue *vq,
> +				 struct vring_desc *desc, int n)
> +{
> +	if (vq->use_desc_cache && n <= VIRT_QUEUE_CACHE_DESC_NUM) {
> +		desc->addr = (u64)vq->desc_cache_chain;
> +		vq->desc_cache_chain = desc;
> +	} else {
> +		kfree(desc);
> +	}
> +}


> +
> +static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
>  					       unsigned int total_sg,
>  					       gfp_t gfp)
>  {
>  	struct vring_desc *desc;
> -	unsigned int i;
> +	unsigned int i, n;
> +
> +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> +		if (vq->desc_cache_chain) {
> +			desc = vq->desc_cache_chain;
> +			vq->desc_cache_chain = (void *)desc->addr;
> +			goto got;
> +		}
> +		n = VIRT_QUEUE_CACHE_DESC_NUM;

Hmm. This will allocate more entries than actually used. Why do it?

> +	} else {
> +		n = total_sg;
> +	}
>  
>  	/*
>  	 * We require lowmem mappings for the descriptors because
> @@ -437,12 +476,13 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
>  	 */
>  	gfp &= ~__GFP_HIGHMEM;
>  
> -	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
> +	desc = kmalloc_array(n, sizeof(struct vring_desc), gfp);
>  	if (!desc)
>  		return NULL;
>  
> +got:
>  	for (i = 0; i < total_sg; i++)
> -		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
> +		desc[i].next = cpu_to_virtio16(vq->vq.vdev, i + 1);
>  	return desc;
>  }
>  
> @@ -508,7 +548,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	head = vq->free_head;
>  
>  	if (virtqueue_use_indirect(_vq, total_sg))
> -		desc = alloc_indirect_split(_vq, total_sg, gfp);
> +		desc = alloc_indirect_split(vq, total_sg, gfp);
>  	else {
>  		desc = NULL;
>  		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
> @@ -652,7 +692,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	}
>  
>  	if (indirect)
> -		kfree(desc);
> +		desc_cache_put_split(vq, desc, total_sg);
>  
>  	END_USE(vq);
>  	return -ENOMEM;
> @@ -717,7 +757,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	if (vq->indirect) {
>  		struct vring_desc *indir_desc =
>  				vq->split.desc_state[head].indir_desc;
> -		u32 len;
> +		u32 len, n;
>  
>  		/* Free the indirect table, if any, now that it's unmapped. */
>  		if (!indir_desc)
> @@ -729,10 +769,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  				VRING_DESC_F_INDIRECT));
>  		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
>  
> -		for (j = 0; j < len / sizeof(struct vring_desc); j++)
> +		n = len / sizeof(struct vring_desc);
> +
> +		for (j = 0; j < n; j++)
>  			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
>  
> -		kfree(indir_desc);
> +		desc_cache_put_split(vq, indir_desc, n);
>  		vq->split.desc_state[head].indir_desc = NULL;
>  	} else if (ctx) {
>  		*ctx = vq->split.desc_state[head].indir_desc;
> @@ -2199,6 +2241,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
>  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> +	vq->desc_cache_chain = NULL;
> +	vq->use_desc_cache = vdev->desc_cache;
>  
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
> @@ -2329,6 +2373,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  	if (!vq->packed_ring) {
>  		kfree(vq->split.desc_state);
>  		kfree(vq->split.desc_extra);
> +		desc_cache_chain_free_split(vq->desc_cache_chain);
>  	}
>  	kfree(vq);
>  }
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..d84b7b8f4070 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -109,6 +109,7 @@ struct virtio_device {
>  	bool failed;
>  	bool config_enabled;
>  	bool config_change_pending;
> +	bool desc_cache;
>  	spinlock_t config_lock;
>  	spinlock_t vqs_list_lock; /* Protects VQs list access */
>  	struct device dev;
> @@ -130,6 +131,15 @@ int register_virtio_device(struct virtio_device *dev);
>  void unregister_virtio_device(struct virtio_device *dev);
>  bool is_virtio_device(struct device *dev);
>  
> +/**
> + * virtio_use_desc_cache - virtio ring use desc cache
> + *
> + * virtio will cache the allocated indirect desc.
> + *
> + * This function must be called before find_vqs.
> + */
> +void virtio_use_desc_cache(struct virtio_device *dev, bool val);
> +
>  void virtio_break_device(struct virtio_device *dev);
>  
>  void virtio_config_changed(struct virtio_device *dev);
> -- 
> 2.31.0

