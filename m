Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8DD4DF3
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfJLHa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:30:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfJLHa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 03:30:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72384307D853;
        Sat, 12 Oct 2019 07:30:58 +0000 (UTC)
Received: from [10.72.12.150] (ovpn-12-150.pek2.redhat.com [10.72.12.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 029D560BF1;
        Sat, 12 Oct 2019 07:30:53 +0000 (UTC)
Subject: Re: [PATCH RFC v1 2/2] vhost: batching fetches
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20191011134358.16912-1-mst@redhat.com>
 <20191011134358.16912-3-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3be186d8-cde6-aa08-0446-1ec7fec0efe0@redhat.com>
Date:   Sat, 12 Oct 2019 15:30:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191011134358.16912-3-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sat, 12 Oct 2019 07:30:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/11 下午9:46, Michael S. Tsirkin wrote:
> With this patch applied, new and old code perform identically.
>
> Lots of extra optimizations are now possible, e.g.
> we can fetch multiple heads with copy_from/to_user now.
> We can get rid of maintaining the log array.  Etc etc.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/test.c  |  2 +-
>   drivers/vhost/vhost.c | 50 ++++++++++++++++++++++++++++++++++++-------
>   drivers/vhost/vhost.h |  4 +++-
>   3 files changed, 46 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 39a018a7af2d..e3a8e9db22cd 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -128,7 +128,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>   	dev = &n->dev;
>   	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>   	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>   		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
>   
>   	f->private_data = n;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 36661d6cb51f..aa383e847865 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -302,6 +302,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>   {
>   	vq->num = 1;
>   	vq->ndescs = 0;
> +	vq->first_desc = 0;
>   	vq->desc = NULL;
>   	vq->avail = NULL;
>   	vq->used = NULL;
> @@ -390,6 +391,7 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>   	for (i = 0; i < dev->nvqs; ++i) {
>   		vq = dev->vqs[i];
>   		vq->max_descs = dev->iov_limit;
> +		vq->batch_descs = dev->iov_limit - UIO_MAXIOV;
>   		vq->descs = kmalloc_array(vq->max_descs,
>   					  sizeof(*vq->descs),
>   					  GFP_KERNEL);
> @@ -2366,6 +2368,8 @@ static void pop_split_desc(struct vhost_virtqueue *vq)
>   	--vq->ndescs;
>   }
>   
> +#define VHOST_DESC_FLAGS (VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE | \
> +			  VRING_DESC_F_NEXT)
>   static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc, u16 id)
>   {
>   	struct vhost_desc *h;
> @@ -2375,7 +2379,7 @@ static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc,
>   	h = &vq->descs[vq->ndescs++];
>   	h->addr = vhost64_to_cpu(vq, desc->addr);
>   	h->len = vhost32_to_cpu(vq, desc->len);
> -	h->flags = vhost16_to_cpu(vq, desc->flags);
> +	h->flags = vhost16_to_cpu(vq, desc->flags) & VHOST_DESC_FLAGS;
>   	h->id = id;
>   
>   	return 0;
> @@ -2450,7 +2454,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
>   	return 0;
>   }
>   
> -static int fetch_descs(struct vhost_virtqueue *vq)
> +static int fetch_buf(struct vhost_virtqueue *vq)
>   {
>   	struct vring_desc desc;
>   	unsigned int i, head, found = 0;
> @@ -2462,7 +2466,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>   	/* Check it isn't doing very strange things with descriptor numbers. */
>   	last_avail_idx = vq->last_avail_idx;
>   
> -	if (vq->avail_idx == vq->last_avail_idx) {
> +	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
> +		/* If we already have work to do, don't bother re-checking. */
> +		if (likely(vq->ndescs))
> +			return vq->num;
> +
>   		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
>   			vq_err(vq, "Failed to access avail idx at %p\n",
>   				&vq->avail->idx);
> @@ -2541,6 +2549,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>   	return 0;
>   }
>   
> +static int fetch_descs(struct vhost_virtqueue *vq)
> +{
> +	int ret = 0;
> +
> +	if (unlikely(vq->first_desc >= vq->ndescs)) {
> +		vq->first_desc = 0;
> +		vq->ndescs = 0;
> +	}
> +
> +	if (vq->ndescs)
> +		return 0;
> +
> +	while (!ret && vq->ndescs <= vq->batch_descs)
> +		ret = fetch_buf(vq);


It looks to me descriptor chaining might be broken here.


> +
> +	return vq->ndescs ? 0 : ret;
> +}
> +
>   /* This looks in the virtqueue and for the first available buffer, and converts
>    * it to an iovec for convenient access.  Since descriptors consist of some
>    * number of output then some number of input descriptors, it's actually two
> @@ -2562,6 +2588,8 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>   	if (ret)
>   		return ret;
>   
> +	/* Note: indirect descriptors are not batched */
> +	/* TODO: batch up to a limit */
>   	last = peek_split_desc(vq);
>   	id = last->id;
>   
> @@ -2584,12 +2612,12 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>   	if (unlikely(log))
>   		*log_num = 0;
>   
> -	for (i = 0; i < vq->ndescs; ++i) {
> +	for (i = vq->first_desc; i < vq->ndescs; ++i) {
>   		unsigned iov_count = *in_num + *out_num;
>   		struct vhost_desc *desc = &vq->descs[i];
>   		int access;
>   
> -		if (desc->flags & ~(VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE)) {
> +		if (desc->flags & ~VHOST_DESC_FLAGS) {
>   			vq_err(vq, "Unexpected flags: 0x%x at descriptor id 0x%x\n",
>   			       desc->flags, desc->id);
>   			ret = -EINVAL;
> @@ -2628,15 +2656,21 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>   			}
>   			*out_num += ret;
>   		}
> +
> +		ret = desc->id;
> +
> +		if (!(desc->flags & VRING_DESC_F_NEXT))
> +			break;
>   	}


What happens if we reach vq->ndescs but VRING_DESC_F_NEXT is still set?

Thanks


>   
> -	ret = id;
> -	vq->ndescs = 0;
> +	vq->first_desc = i + 1;
>   
>   	return ret;
>   
>   err:
> -	vhost_discard_vq_desc(vq, 1);
> +	for (i = vq->first_desc; i < vq->ndescs; ++i)
> +		if (!(desc->flags & VRING_DESC_F_NEXT))
> +			vhost_discard_vq_desc(vq, 1);
>   	vq->ndescs = 0;
>   
>   	return ret;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 1724f61b6c2d..8b88e0c903da 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -100,7 +100,9 @@ struct vhost_virtqueue {
>   
>   	struct vhost_desc *descs;
>   	int ndescs;
> +	int first_desc;
>   	int max_descs;
> +	int batch_descs;
>   
>   	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
>   	struct file *kick;
> @@ -245,7 +247,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>   int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
>   
>   #define vq_err(vq, fmt, ...) do {                                  \
> -		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
> +		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
>   		if ((vq)->error_ctx)                               \
>   				eventfd_signal((vq)->error_ctx, 1);\
>   	} while (0)
