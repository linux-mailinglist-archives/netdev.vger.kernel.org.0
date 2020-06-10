Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B821F56CC
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgFJO3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 10:29:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729845AbgFJO3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 10:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591799378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idMIiJOT09bgESC1Xwuj+7K7gWUtR0p+u+13akNztH4=;
        b=TE/mwiFn+954n/F343p5PVwQkjChjwlNGkCJ/V/HWcPbRDS2/F6Av5PyF0CS6ewUA6pDfd
        3y7Hy8FL0FJp8UXnw0n3bUu5AhRNKPlsdhwIQn/wHU2BYIXdGa1fb3OGMxmmwfxQfobPMi
        j4K0OgDrHTWC7gSZVNngM04YaRVkAAM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-jrUGcXuUPv6aNeRm9ifd2Q-1; Wed, 10 Jun 2020 10:29:34 -0400
X-MC-Unique: jrUGcXuUPv6aNeRm9ifd2Q-1
Received: by mail-wr1-f71.google.com with SMTP id i6so1148901wrr.23
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 07:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idMIiJOT09bgESC1Xwuj+7K7gWUtR0p+u+13akNztH4=;
        b=UB7pSFKY4xvQ0baX9X4g41IFdXjQAej7POrzRJSw8CVsNMXcAloemIP1iVwwxc8lH9
         5EWDO91n5JSabhOCTrOHEkTWajmg/9tLDxzkpBrX2kqxGTgb3aqtLkmB3jyXhBRJqACi
         vOtRbjA97R7Mvm9lpHQUqYOeBqgqLtP8vz8r0+VUATt1UpOOKl6q4sjoBxR9EVphoatM
         z53qurSUHw/8kAvkYFAzLdL6rcQlRjkV2pEntK1s4fMTfZlz/Xd4NeTypKwaTKa6OqTe
         WxbyvpeZwfAH2xcUEFXVhkyh5X2Yipi3jPI+iq+4QzHp2SjMleUZmW2KrkfQNGTw9hlV
         2GWw==
X-Gm-Message-State: AOAM530p4mw7qJssMF8YJVALXqO7TUzvYmqnejKi160SRiqOthNBWe/V
        fNGwhm8KSu1yKX0bVtuCazhkXGe+Uy2TzKFa3eoa+1CrE1+NBzUBR7glKLDglucP/UAAIwDKQzM
        PqfStH3vncc2Cpj3e
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr4427277wrq.153.1591799372333;
        Wed, 10 Jun 2020 07:29:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRkqAoACOukf2PaRTB33MsiFGBeXf1uA+2oE+b4+96DsfOKM8DLT/GUf7hpdTX2fy2uK5j6g==
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr4427241wrq.153.1591799371814;
        Wed, 10 Jun 2020 07:29:31 -0700 (PDT)
Received: from eperezma.remote.csb (109.141.78.188.dynamic.jazztel.es. [188.78.141.109])
        by smtp.gmail.com with ESMTPSA id w17sm8425820wra.71.2020.06.10.07.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 07:29:31 -0700 (PDT)
Message-ID: <035e82bcf4ade0017641c5b457d0c628c5915732.camel@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Date:   Wed, 10 Jun 2020 16:29:29 +0200
In-Reply-To: <20200610113515.1497099-4-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
         <20200610113515.1497099-4-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-06-10 at 07:36 -0400, Michael S. Tsirkin wrote:
> As testing shows no performance change, switch to that now.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/test.c  |   2 +-
>  drivers/vhost/vhost.c | 318 ++++++++----------------------------------
>  drivers/vhost/vhost.h |   7 +-
>  3 files changed, 65 insertions(+), 262 deletions(-)
> 
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 0466921f4772..7d69778aaa26 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>  	dev = &n->dev;
>  	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>  	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>  		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
>  
>  	f->private_data = n;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 11433d709651..28f324fd77df 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  {
>  	vq->num = 1;
>  	vq->ndescs = 0;
> +	vq->first_desc = 0;
>  	vq->desc = NULL;
>  	vq->avail = NULL;
>  	vq->used = NULL;
> @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
>  	return 0;
>  }
>  
> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> +{
> +	return vq->max_descs - UIO_MAXIOV;
> +}
> +
>  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>  {
>  	kfree(vq->descs);
> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		vq->max_descs = dev->iov_limit;
> +		if (vhost_vq_num_batch_descs(vq) < 0) {
> +			return -EINVAL;
> +		}
>  		vq->descs = kmalloc_array(vq->max_descs,
>  					  sizeof(*vq->descs),
>  					  GFP_KERNEL);
> @@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  		vq->last_avail_idx = s.num;
>  		/* Forget the cached index value. */
>  		vq->avail_idx = vq->last_avail_idx;
> +		vq->ndescs = vq->first_desc = 0;

This is not needed if it is done in vhost_vq_set_backend, as far as I can tell.

Actually, maybe it is even better to move `vq->avail_idx = vq->last_avail_idx;` line to vhost_vq_set_backend, it is part
of the backend "set up" procedure, isn't it?

I tested with virtio_test + batch tests sent in 
https://lkml.kernel.org/lkml/20200418102217.32327-1-eperezma@redhat.com/T/.
I append here what I'm proposing in case it is clearer this way.

Thanks!

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 4d198994e7be..809ad2cd2879 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1617,9 +1617,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			break;
 		}
 		vq->last_avail_idx = s.num;
-		/* Forget the cached index value. */
-		vq->avail_idx = vq->last_avail_idx;
-		vq->ndescs = vq->first_desc = 0;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index fed36af5c444..f4902dc808e4 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -258,6 +258,7 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
 					void *private_data)
 {
 	vq->private_data = private_data;
+	vq->avail_idx = vq->last_avail_idx;
 	vq->ndescs = 0;
 	vq->first_desc = 0;
 }

>  		break;
>  	case VHOST_GET_VRING_BASE:
>  		s.index = idx;
> @@ -2078,253 +2088,6 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
>  	return next;
>  }
>  
> -static int get_indirect(struct vhost_virtqueue *vq,
> -			struct iovec iov[], unsigned int iov_size,
> -			unsigned int *out_num, unsigned int *in_num,
> -			struct vhost_log *log, unsigned int *log_num,
> -			struct vring_desc *indirect)
> -{
> -	struct vring_desc desc;
> -	unsigned int i = 0, count, found = 0;
> -	u32 len = vhost32_to_cpu(vq, indirect->len);
> -	struct iov_iter from;
> -	int ret, access;
> -
> -	/* Sanity check */
> -	if (unlikely(len % sizeof desc)) {
> -		vq_err(vq, "Invalid length in indirect descriptor: "
> -		       "len 0x%llx not multiple of 0x%zx\n",
> -		       (unsigned long long)len,
> -		       sizeof desc);
> -		return -EINVAL;
> -	}
> -
> -	ret = translate_desc(vq, vhost64_to_cpu(vq, indirect->addr), len, vq->indirect,
> -			     UIO_MAXIOV, VHOST_ACCESS_RO);
> -	if (unlikely(ret < 0)) {
> -		if (ret != -EAGAIN)
> -			vq_err(vq, "Translation failure %d in indirect.\n", ret);
> -		return ret;
> -	}
> -	iov_iter_init(&from, READ, vq->indirect, ret, len);
> -
> -	/* We will use the result as an address to read from, so most
> -	 * architectures only need a compiler barrier here. */
> -	read_barrier_depends();
> -
> -	count = len / sizeof desc;
> -	/* Buffers are chained via a 16 bit next field, so
> -	 * we can have at most 2^16 of these. */
> -	if (unlikely(count > USHRT_MAX + 1)) {
> -		vq_err(vq, "Indirect buffer length too big: %d\n",
> -		       indirect->len);
> -		return -E2BIG;
> -	}
> -
> -	do {
> -		unsigned iov_count = *in_num + *out_num;
> -		if (unlikely(++found > count)) {
> -			vq_err(vq, "Loop detected: last one at %u "
> -			       "indirect size %u\n",
> -			       i, count);
> -			return -EINVAL;
> -		}
> -		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
> -			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
> -			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
> -			return -EINVAL;
> -		}
> -		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
> -			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
> -			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
> -			return -EINVAL;
> -		}
> -
> -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> -			access = VHOST_ACCESS_WO;
> -		else
> -			access = VHOST_ACCESS_RO;
> -
> -		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> -				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
> -				     iov_size - iov_count, access);
> -		if (unlikely(ret < 0)) {
> -			if (ret != -EAGAIN)
> -				vq_err(vq, "Translation failure %d indirect idx %d\n",
> -					ret, i);
> -			return ret;
> -		}
> -		/* If this is an input descriptor, increment that count. */
> -		if (access == VHOST_ACCESS_WO) {
> -			*in_num += ret;
> -			if (unlikely(log && ret)) {
> -				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> -				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> -				++*log_num;
> -			}
> -		} else {
> -			/* If it's an output descriptor, they're all supposed
> -			 * to come before any input descriptors. */
> -			if (unlikely(*in_num)) {
> -				vq_err(vq, "Indirect descriptor "
> -				       "has out after in: idx %d\n", i);
> -				return -EINVAL;
> -			}
> -			*out_num += ret;
> -		}
> -	} while ((i = next_desc(vq, &desc)) != -1);
> -	return 0;
> -}
> -
> -/* This looks in the virtqueue and for the first available buffer, and converts
> - * it to an iovec for convenient access.  Since descriptors consist of some
> - * number of output then some number of input descriptors, it's actually two
> - * iovecs, but we pack them into one and note how many of each there were.
> - *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -		      struct iovec iov[], unsigned int iov_size,
> -		      unsigned int *out_num, unsigned int *in_num,
> -		      struct vhost_log *log, unsigned int *log_num)
> -{
> -	struct vring_desc desc;
> -	unsigned int i, head, found = 0;
> -	u16 last_avail_idx;
> -	__virtio16 avail_idx;
> -	__virtio16 ring_head;
> -	int ret, access;
> -
> -	/* Check it isn't doing very strange things with descriptor numbers. */
> -	last_avail_idx = vq->last_avail_idx;
> -
> -	if (vq->avail_idx == vq->last_avail_idx) {
> -		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
> -			vq_err(vq, "Failed to access avail idx at %p\n",
> -				&vq->avail->idx);
> -			return -EFAULT;
> -		}
> -		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
> -
> -		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
> -			vq_err(vq, "Guest moved used index from %u to %u",
> -				last_avail_idx, vq->avail_idx);
> -			return -EFAULT;
> -		}
> -
> -		/* If there's nothing new since last we looked, return
> -		 * invalid.
> -		 */
> -		if (vq->avail_idx == last_avail_idx)
> -			return vq->num;
> -
> -		/* Only get avail ring entries after they have been
> -		 * exposed by guest.
> -		 */
> -		smp_rmb();
> -	}
> -
> -	/* Grab the next descriptor number they're advertising, and increment
> -	 * the index we've seen. */
> -	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
> -		vq_err(vq, "Failed to read head: idx %d address %p\n",
> -		       last_avail_idx,
> -		       &vq->avail->ring[last_avail_idx % vq->num]);
> -		return -EFAULT;
> -	}
> -
> -	head = vhost16_to_cpu(vq, ring_head);
> -
> -	/* If their number is silly, that's an error. */
> -	if (unlikely(head >= vq->num)) {
> -		vq_err(vq, "Guest says index %u > %u is available",
> -		       head, vq->num);
> -		return -EINVAL;
> -	}
> -
> -	/* When we start there are none of either input nor output. */
> -	*out_num = *in_num = 0;
> -	if (unlikely(log))
> -		*log_num = 0;
> -
> -	i = head;
> -	do {
> -		unsigned iov_count = *in_num + *out_num;
> -		if (unlikely(i >= vq->num)) {
> -			vq_err(vq, "Desc index is %u > %u, head = %u",
> -			       i, vq->num, head);
> -			return -EINVAL;
> -		}
> -		if (unlikely(++found > vq->num)) {
> -			vq_err(vq, "Loop detected: last one at %u "
> -			       "vq size %u head %u\n",
> -			       i, vq->num, head);
> -			return -EINVAL;
> -		}
> -		ret = vhost_get_desc(vq, &desc, i);
> -		if (unlikely(ret)) {
> -			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
> -			       i, vq->desc + i);
> -			return -EFAULT;
> -		}
> -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
> -			ret = get_indirect(vq, iov, iov_size,
> -					   out_num, in_num,
> -					   log, log_num, &desc);
> -			if (unlikely(ret < 0)) {
> -				if (ret != -EAGAIN)
> -					vq_err(vq, "Failure detected "
> -						"in indirect descriptor at idx %d\n", i);
> -				return ret;
> -			}
> -			continue;
> -		}
> -
> -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> -			access = VHOST_ACCESS_WO;
> -		else
> -			access = VHOST_ACCESS_RO;
> -		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> -				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
> -				     iov_size - iov_count, access);
> -		if (unlikely(ret < 0)) {
> -			if (ret != -EAGAIN)
> -				vq_err(vq, "Translation failure %d descriptor idx %d\n",
> -					ret, i);
> -			return ret;
> -		}
> -		if (access == VHOST_ACCESS_WO) {
> -			/* If this is an input descriptor,
> -			 * increment that count. */
> -			*in_num += ret;
> -			if (unlikely(log && ret)) {
> -				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> -				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> -				++*log_num;
> -			}
> -		} else {
> -			/* If it's an output descriptor, they're all supposed
> -			 * to come before any input descriptors. */
> -			if (unlikely(*in_num)) {
> -				vq_err(vq, "Descriptor has out after in: "
> -				       "idx %d\n", i);
> -				return -EINVAL;
> -			}
> -			*out_num += ret;
> -		}
> -	} while ((i = next_desc(vq, &desc)) != -1);
> -
> -	/* On success, increment avail index. */
> -	vq->last_avail_idx++;
> -
> -	/* Assume notifications from guest are disabled at this point,
> -	 * if they aren't we would need to update avail_event index. */
> -	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> -	return head;
> -}
> -EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> -
>  static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
>  {
>  	BUG_ON(!vq->ndescs);
> @@ -2428,7 +2191,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
>  
>  /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
>   * A negative code is returned on error. */
> -static int fetch_descs(struct vhost_virtqueue *vq)
> +static int fetch_buf(struct vhost_virtqueue *vq)
>  {
>  	unsigned int i, head, found = 0;
>  	struct vhost_desc *last;
> @@ -2441,7 +2204,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>  	/* Check it isn't doing very strange things with descriptor numbers. */
>  	last_avail_idx = vq->last_avail_idx;
>  
> -	if (vq->avail_idx == vq->last_avail_idx) {
> +	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
> +		/* If we already have work to do, don't bother re-checking. */
> +		if (likely(vq->ndescs))
> +			return 1;
> +
>  		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
>  			vq_err(vq, "Failed to access avail idx at %p\n",
>  				&vq->avail->idx);
> @@ -2532,6 +2299,41 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>  	return 1;
>  }
>  
> +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> + * A negative code is returned on error. */
> +static int fetch_descs(struct vhost_virtqueue *vq)
> +{
> +	int ret;
> +
> +	if (unlikely(vq->first_desc >= vq->ndescs)) {
> +		vq->first_desc = 0;
> +		vq->ndescs = 0;
> +	}
> +
> +	if (vq->ndescs)
> +		return 1;
> +
> +	for (ret = 1;
> +	     ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> +	     ret = fetch_buf(vq))
> +		;
> +
> +	/* On success we expect some descs */
> +	BUG_ON(ret > 0 && !vq->ndescs);
> +	return ret;
> +}
> +
> +/* Reverse the effects of fetch_descs */
> +static void unfetch_descs(struct vhost_virtqueue *vq)
> +{
> +	int i;
> +
> +	for (i = vq->first_desc; i < vq->ndescs; ++i)
> +		if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
> +			vq->last_avail_idx -= 1;
> +	vq->ndescs = 0;
> +}
> +
>  /* This looks in the virtqueue and for the first available buffer, and converts
>   * it to an iovec for convenient access.  Since descriptors consist of some
>   * number of output then some number of input descriptors, it's actually two
> @@ -2540,7 +2342,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>   * This function returns the descriptor number found, or vq->num (which is
>   * never a valid descriptor number) if none was found.  A negative code is
>   * returned on error. */
> -int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>  		      struct iovec iov[], unsigned int iov_size,
>  		      unsigned int *out_num, unsigned int *in_num,
>  		      struct vhost_log *log, unsigned int *log_num)
> @@ -2549,7 +2351,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>  	int i;
>  
>  	if (ret <= 0)
> -		goto err_fetch;
> +		goto err;
>  
>  	/* Now convert to IOV */
>  	/* When we start there are none of either input nor output. */
> @@ -2557,7 +2359,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>  	if (unlikely(log))
>  		*log_num = 0;
>  
> -	for (i = 0; i < vq->ndescs; ++i) {
> +	for (i = vq->first_desc; i < vq->ndescs; ++i) {
>  		unsigned iov_count = *in_num + *out_num;
>  		struct vhost_desc *desc = &vq->descs[i];
>  		int access;
> @@ -2603,24 +2405,26 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>  		}
>  
>  		ret = desc->id;
> +
> +		if (!(desc->flags & VRING_DESC_F_NEXT))
> +			break;
>  	}
>  
> -	vq->ndescs = 0;
> +	vq->first_desc = i + 1;
>  
>  	return ret;
>  
>  err:
> -	vhost_discard_vq_desc(vq, 1);
> -err_fetch:
> -	vq->ndescs = 0;
> +	unfetch_descs(vq);
>  
>  	return ret ? ret : vq->num;
>  }
> -EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
> +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>  
>  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
>  void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
>  {
> +	unfetch_descs(vq);
>  	vq->last_avail_idx -= n;
>  }
>  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 87089d51490d..fed36af5c444 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -81,6 +81,7 @@ struct vhost_virtqueue {
>  
>  	struct vhost_desc *descs;
>  	int ndescs;
> +	int first_desc;
>  	int max_descs;
>  
>  	struct file *kick;
> @@ -189,10 +190,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
>  bool vhost_log_access_ok(struct vhost_dev *);
>  
> -int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
> -		      struct iovec iov[], unsigned int iov_count,
> -		      unsigned int *out_num, unsigned int *in_num,
> -		      struct vhost_log *log, unsigned int *log_num);
>  int vhost_get_vq_desc(struct vhost_virtqueue *,
>  		      struct iovec iov[], unsigned int iov_count,
>  		      unsigned int *out_num, unsigned int *in_num,
> @@ -261,6 +258,8 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
>  					void *private_data)
>  {
>  	vq->private_data = private_data;
> +	vq->ndescs = 0;
> +	vq->first_desc = 0;
>  }
>  
>  /**

