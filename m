Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E401743D1C1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhJ0Tjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:39:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240359AbhJ0Tjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635363426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TyWbseVcIvJiB/y7F+AQk9e5SoEkEaCHQO94xB0lAow=;
        b=W/r/zNimbNDrZdmVX8C5Yqdt8a8Tx/4eJ5RAyiGL7Xn9ficYzOSt0ZaKnGnvK+uxKiEdby
        ZHrLD1g5bk5arruSBtqc5lbkb7sW9vDCJZA6N9+jeHVQWM2V3AEv79mjHtvDb5Obe1Sge4
        lEKKM8xAMQgCQMXsMz5NQIjAnCxWhSE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-LcaOZ1s8OLOujiXnoI3uKA-1; Wed, 27 Oct 2021 15:37:05 -0400
X-MC-Unique: LcaOZ1s8OLOujiXnoI3uKA-1
Received: by mail-ed1-f69.google.com with SMTP id z1-20020a05640235c100b003dcf0fbfbd8so3333655edc.6
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 12:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TyWbseVcIvJiB/y7F+AQk9e5SoEkEaCHQO94xB0lAow=;
        b=4PBfFR9+Fvo31eE/we32DAY6zpEBfhwrrT7aN45/5QqJlN7bh72f0kcbP7yxOPcDjF
         SH3DKukI61EVW/X5qJU00OrBkzjZe5y+Wf8Tc2zHb48IJ7k3FBLzPXu0VceAaagZ/ULr
         wVZszLfOJxRZvneCKVfJF0nCR3z56X9frD4BZyhjxaBFPw3YTEkwkcOxc9vq93K/D8Ew
         jSwz9lqeYM0OtBFmUMuop6gwvfYJiYPEJ+kzIPu6exrdrTazOCaCJVmmByMIYx+tk/WP
         9NC7K/SfRTWHfA6EshbwoBMhpigQsp9GjZu6qxL2xFLOizXxm/zreQLicbWPgqbYv4Qx
         6MOA==
X-Gm-Message-State: AOAM533LOUZ9ykib8F9r3Z7c+y347UAV2+C7jp9LBMLK5ZC9+G241zow
        Uxmw82ZUSwyJJhtVNlalgVJU5QauSBHqL+Eo6etctnTF/D87AciUxt2+e3iHeuRRc0FNvGnAnsd
        6O6+1HPhrqyCNvmit
X-Received: by 2002:a05:6402:10cd:: with SMTP id p13mr41189088edu.111.1635363423400;
        Wed, 27 Oct 2021 12:37:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaqOD6uea1lUYf7AdF5P8EDeIgspaeRBq2vHi/VPjOWrW95ZNai33V1+zqnc+0wZyHKtsfxQ==
X-Received: by 2002:a05:6402:10cd:: with SMTP id p13mr41189060edu.111.1635363423177;
        Wed, 27 Oct 2021 12:37:03 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id gt36sm405080ejc.13.2021.10.27.12.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 12:37:02 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:36:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: cache indirect desc for split
Message-ID: <20211027153545-mutt-send-email-mst@kernel.org>
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
 <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
 <d6a38629-cb0a-be7b-5256-30ed8b34ee76@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a38629-cb0a-be7b-5256-30ed8b34ee76@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 09:33:46AM -0700, Dongli Zhang wrote:
> 
> 
> On 10/26/21 11:19 PM, Xuan Zhuo wrote:
> > In the case of using indirect, indirect desc must be allocated and
> > released each time, which increases a lot of cpu overhead.
> > 
> > Here, a cache is added for indirect. If the number of indirect desc to be
> > applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> > the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> > 
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio.c      |  6 ++++
> >  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++------
> >  include/linux/virtio.h       | 10 ++++++
> >  3 files changed, 70 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index 0a5b54034d4b..04bcb74e5b9a 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(is_virtio_device);
> >  
> > +void virtio_use_desc_cache(struct virtio_device *dev, bool val)
> > +{
> > +	dev->desc_cache = val;
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_use_desc_cache);
> > +
> >  void unregister_virtio_device(struct virtio_device *dev)
> >  {
> >  	int index = dev->index; /* save for after device release */
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index dd95dfd85e98..0b9a8544b0e8 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -117,6 +117,10 @@ struct vring_virtqueue {
> >  	/* Hint for event idx: already triggered no need to disable. */
> >  	bool event_triggered;
> >  
> > +	/* Is indirect cache used? */
> > +	bool use_desc_cache;
> > +	void *desc_cache_chain;
> > +
> >  	union {
> >  		/* Available for split ring */
> >  		struct {
> > @@ -423,12 +427,47 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
> >  	return extra[i].next;
> >  }
> >  
> > -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> > +#define VIRT_QUEUE_CACHE_DESC_NUM 4
> > +
> > +static void desc_cache_chain_free_split(void *chain)
> > +{
> > +	struct vring_desc *desc;
> > +
> > +	while (chain) {
> > +		desc = chain;
> > +		chain = (void *)desc->addr;
> > +		kfree(desc);
> > +	}
> > +}
> > +
> > +static void desc_cache_put_split(struct vring_virtqueue *vq,
> > +				 struct vring_desc *desc, int n)
> > +{
> > +	if (vq->use_desc_cache && n <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > +		desc->addr = (u64)vq->desc_cache_chain;
> > +		vq->desc_cache_chain = desc;
> > +	} else {
> > +		kfree(desc);
> > +	}
> > +}
> > +
> > +static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
> >  					       unsigned int total_sg,
> >  					       gfp_t gfp)
> >  {
> >  	struct vring_desc *desc;
> > -	unsigned int i;
> > +	unsigned int i, n;
> > +
> > +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > +		if (vq->desc_cache_chain) {
> > +			desc = vq->desc_cache_chain;
> > +			vq->desc_cache_chain = (void *)desc->addr;
> > +			goto got;
> > +		}
> > +		n = VIRT_QUEUE_CACHE_DESC_NUM;
> 
> How about to make the VIRT_QUEUE_CACHE_DESC_NUM configurable (at least during
> driver probing) unless there is a reason that the default value is 4.
> 
> Thank you very much!
> 
> Dongli Zhang


I would start with some experimentation showing that it actually makes a
difference in performance.

> 
> 
> > +	} else {
> > +		n = total_sg;
> > +	}
> >  
> >  	/*
> >  	 * We require lowmem mappings for the descriptors because
> > @@ -437,12 +476,13 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> >  	 */
> >  	gfp &= ~__GFP_HIGHMEM;
> >  
> > -	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
> > +	desc = kmalloc_array(n, sizeof(struct vring_desc), gfp);
> >  	if (!desc)
> >  		return NULL;
> >  
> > +got:
> >  	for (i = 0; i < total_sg; i++)
> > -		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
> > +		desc[i].next = cpu_to_virtio16(vq->vq.vdev, i + 1);
> >  	return desc;
> >  }
> >  
> > @@ -508,7 +548,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
> >  	head = vq->free_head;
> >  
> >  	if (virtqueue_use_indirect(_vq, total_sg))
> > -		desc = alloc_indirect_split(_vq, total_sg, gfp);
> > +		desc = alloc_indirect_split(vq, total_sg, gfp);
> >  	else {
> >  		desc = NULL;
> >  		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
> > @@ -652,7 +692,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
> >  	}
> >  
> >  	if (indirect)
> > -		kfree(desc);
> > +		desc_cache_put_split(vq, desc, total_sg);
> >  
> >  	END_USE(vq);
> >  	return -ENOMEM;
> > @@ -717,7 +757,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
> >  	if (vq->indirect) {
> >  		struct vring_desc *indir_desc =
> >  				vq->split.desc_state[head].indir_desc;
> > -		u32 len;
> > +		u32 len, n;
> >  
> >  		/* Free the indirect table, if any, now that it's unmapped. */
> >  		if (!indir_desc)
> > @@ -729,10 +769,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
> >  				VRING_DESC_F_INDIRECT));
> >  		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
> >  
> > -		for (j = 0; j < len / sizeof(struct vring_desc); j++)
> > +		n = len / sizeof(struct vring_desc);
> > +
> > +		for (j = 0; j < n; j++)
> >  			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
> >  
> > -		kfree(indir_desc);
> > +		desc_cache_put_split(vq, indir_desc, n);
> >  		vq->split.desc_state[head].indir_desc = NULL;
> >  	} else if (ctx) {
> >  		*ctx = vq->split.desc_state[head].indir_desc;
> > @@ -2199,6 +2241,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> >  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
> >  		!context;
> >  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> > +	vq->desc_cache_chain = NULL;
> > +	vq->use_desc_cache = vdev->desc_cache;
> >  
> >  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> >  		vq->weak_barriers = false;
> > @@ -2329,6 +2373,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
> >  	if (!vq->packed_ring) {
> >  		kfree(vq->split.desc_state);
> >  		kfree(vq->split.desc_extra);
> > +		desc_cache_chain_free_split(vq->desc_cache_chain);
> >  	}
> >  	kfree(vq);
> >  }
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 41edbc01ffa4..d84b7b8f4070 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -109,6 +109,7 @@ struct virtio_device {
> >  	bool failed;
> >  	bool config_enabled;
> >  	bool config_change_pending;
> > +	bool desc_cache;
> >  	spinlock_t config_lock;
> >  	spinlock_t vqs_list_lock; /* Protects VQs list access */
> >  	struct device dev;
> > @@ -130,6 +131,15 @@ int register_virtio_device(struct virtio_device *dev);
> >  void unregister_virtio_device(struct virtio_device *dev);
> >  bool is_virtio_device(struct device *dev);
> >  
> > +/**
> > + * virtio_use_desc_cache - virtio ring use desc cache
> > + *
> > + * virtio will cache the allocated indirect desc.
> > + *
> > + * This function must be called before find_vqs.
> > + */
> > +void virtio_use_desc_cache(struct virtio_device *dev, bool val);
> > +
> >  void virtio_break_device(struct virtio_device *dev);
> >  
> >  void virtio_config_changed(struct virtio_device *dev);
> > 

