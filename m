Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4114147C3
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhIVL1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:27:16 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:49713 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhIVL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 07:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=yBdO7WqWKnVSlSiZCuprvXLK0oemHtyvjx/Ahqp0Bbo=; b=AQ8fYOUAxQiy+YpnllDUVP4hRB
        EPe/pXLyb3MPsEqRFwpEaXKLvmzggbiFL3DEvjrErqKP0rKDKuon5HWk11ruuEaB0IyPuO/peCndY
        sPW/W2L9azJW8kwfA+sJoHI23gXoWphLZOhbdR7OFdCpmEO8KGl0cgx6kpdeKfLSSFvYWY9FhDt0a
        CFRHIsBdR9VEmizYRtuDunckBFv2jAViNqeVxyllZABbJUFQgRuMWy4DYevXIUfPXmO0TZ/nWnLX0
        sW0k2WuAe9wO1ogooE/yPUhCMRoex2bVNdyHw2LiSFwkk6K5GRfVpe5zBwhY9JLnmNufoScqgZsmt
        XyNIYUzCDmTMEAKCDXeKnJ7GqG9I9yBxQSP4QasE9LRX9Jszk8zURS8UwAVlVcvoju5qMN/7bqXOI
        xuM8eU067p6BVE6GZ64GWI0OFuI+d/lmaGJ/w6j5pHLEd78SxjzViZl989jrOKAsGER0PiuFJ0KWK
        W7KQNgIgs6INFz4qhDy3n9fkHTQYstXRktcdwLz44Q77VCBf/GJ/A6EOd3To0Bdk8ATutAm1eD0vm
        3PfvqbfBx7Y1shvoXRqGTraW+YTLgFtvpKCiA0QiAZTX8egQmRVnBwj5M7oMN8UCewq/7pxyjLN8m
        OLD+qJ8VMnGEVmpJEyqu5VtQypZS8tTRrew6aU8q8=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 4/7] 9p/trans_virtio: introduce struct virtqueue_sg
Date:   Wed, 22 Sep 2021 13:25:43 +0200
Message-ID: <1839905.9Lnd8ebdCZ@silver>
In-Reply-To: <e90eedf795eb7eb1b5beaaf2f090021c5b559a91.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com> <e90eedf795eb7eb1b5beaaf2f090021c5b559a91.1632156835.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 20. September 2021 18:44:00 CEST Christian Schoenebeck wrote:
> The amount of elements in a scatter/gather list is limited to
> approximately 128 elements. To allow going beyond that limit
> with subsequent patches, pave the way by turning the one-
> dimensional sg list array into a two-dimensional array, i.e:
> 
>   sg[128]
> 
> becomes
> 
>   sgl[nsgl][SG_MAX_SINGLE_ALLOC]
> 
> As the value of 'nsgl' is exactly (still) 1 in this commit
> and the compile-time (compiler and architecture dependent)
> value of 'SG_MAX_SINGLE_ALLOC' equals approximately the
> previous hard coded 128 elements, this commit is therefore
> more of a preparatory refactoring then actual behaviour
> change.
> 
> A custom struct virtqueue_sg is defined instead of using
> shared API struct sg_table, because the latter would not
> allow to resize the table after allocation. sg_append_table
> API OTOH would not fit either, because it requires a list
> of pages beforehand upon allocation. And both APIs only
> support all-or-nothing allocation.
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
>  net/9p/trans_virtio.c | 190 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 144 insertions(+), 46 deletions(-)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 3347d35a5e6e..0db8de84bd51 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -36,7 +36,31 @@
>  #include <linux/virtio_9p.h>
>  #include "trans_common.h"
> 
> -#define VIRTQUEUE_DEFAULT_NUM	128
> +/**
> + * struct virtqueue_sg - (chained) scatter gather lists for virtqueue data
> + * transmission
> + * @nsgl: amount of elements (in first dimension) of array field @sgl
> + * @sgl: two-dimensional array, i.e. sgl[nsgl][SG_MAX_SINGLE_ALLOC]
> + */
> +struct virtqueue_sg {
> +	unsigned int nsgl;
> +	struct scatterlist *sgl[];
> +};
> +
> +/*
> + * Default value for field nsgl in struct virtqueue_sg, which defines the
> + * initial virtio data transmission capacity when this virtio transport is
> + * probed.
> + */
> +#define VIRTQUEUE_SG_NSGL_DEFAULT 1
> +
> +/* maximum value for field nsgl in struct virtqueue_sg */
> +#define VIRTQUEUE_SG_NSGL_MAX						\
> +	((PAGE_SIZE - sizeof(struct virtqueue_sg)) /			\
> +	sizeof(struct scatterlist *))					\
> +
> +/* last entry per sg list is used for chaining (pointer to next list) */
> +#define SG_USER_PAGES_PER_LIST	(SG_MAX_SINGLE_ALLOC - 1)
> 
>  /* a single mutex to manage channel initialization and attachment */
>  static DEFINE_MUTEX(virtio_9p_lock);
> @@ -53,8 +77,7 @@ static atomic_t vp_pinned = ATOMIC_INIT(0);
>   * @ring_bufs_avail: flag to indicate there is some available in the ring
> buf * @vc_wq: wait queue for waiting for thing to be added to ring buf *
> @p9_max_pages: maximum number of pinned pages
> - * @sg: scatter gather list which is used to pack a request (protected?)
> - * @sg_n: amount of elements in sg array
> + * @vq_sg: table of scatter gather lists, which are used to pack a request
>   * @chan_list: linked list of channels
>   *
>   * We keep all per-channel information in a structure.
> @@ -77,9 +100,7 @@ struct virtio_chan {
>  	 * will be placing it in each channel.
>  	 */
>  	unsigned long p9_max_pages;
> -	/* Scatterlist: can be too big for stack. */
> -	struct scatterlist *sg;
> -	size_t sg_n;
> +	struct virtqueue_sg *vq_sg;
>  	/**
>  	 * @tag: name to identify a mount null terminated
>  	 */
> @@ -96,6 +117,89 @@ static unsigned int rest_of_page(void *data)
>  	return PAGE_SIZE - offset_in_page(data);
>  }
> 
> +/**
> + * vq_sg_page - returns user page for given page index
> + * @vq_sg: scatter gather lists used by this transport
> + * @page: user page index across all scatter gather lists
> + */
> +static struct scatterlist *vq_sg_page(struct virtqueue_sg *vq_sg, size_t
> page) +{
> +	unsigned int node = page / SG_USER_PAGES_PER_LIST;
> +	unsigned int leaf = page % SG_USER_PAGES_PER_LIST;
> +	BUG_ON(node >= VIRTQUEUE_SG_NSGL_MAX);
> +	return &vq_sg->sgl[node][leaf];
> +}
> +
> +/**
> + * vq_sg_npages - returns total number of individual user pages in passed
> + * scatter gather lists
> + * @vq_sg: scatter gather lists to be counted
> + */
> +static size_t vq_sg_npages(struct virtqueue_sg *vq_sg)
> +{
> +	return vq_sg->nsgl * SG_USER_PAGES_PER_LIST;
> +}
> +
> +/**
> + * vq_sg_free - free all memory previously allocated for @vq_sg
> + * @vq_sg: scatter gather lists to be freed
> + */
> +static void vq_sg_free(struct virtqueue_sg *vq_sg)
> +{
> +	unsigned int i;
> +

Here should be a

	if (!vq_sg) return;

Not a real issue right now as vq_sg_free() is never called with NULL anywhere, 
but it is common expactation that free calls should safely handle NULL 
arguments.

> +	for (i = 0; i < vq_sg->nsgl; ++i) {
> +		kfree(vq_sg->sgl[i]);
> +	}
> +	kfree(vq_sg);
> +}
> +
> +/**
> + * vq_sg_alloc - allocates and returns @nsgl scatter gather lists
> + * @nsgl: amount of scatter gather lists to be allocated
> + * If @nsgl is larger than one then chained lists are used if supported by
> + * architecture.
> + */
> +static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
> +{
> +	struct virtqueue_sg *vq_sg;
> +	unsigned int i;
> +
> +	BUG_ON(!nsgl || nsgl > VIRTQUEUE_SG_NSGL_MAX);
> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
> +	if (WARN_ON_ONCE(nsgl > 1))
> +		return NULL;
> +#endif
> +
> +	vq_sg = kzalloc(sizeof(struct virtqueue_sg) +
> +			nsgl * sizeof(struct scatterlist *),
> +			GFP_KERNEL);
> +
> +	if (!vq_sg)
> +		return NULL;
> +
> +	vq_sg->nsgl = nsgl;
> +
> +	for (i = 0; i < nsgl; ++i) {
> +		vq_sg->sgl[i] = kmalloc_array(
> +			SG_MAX_SINGLE_ALLOC, sizeof(struct scatterlist),
> +			GFP_KERNEL
> +		);
> +		if (!vq_sg->sgl[i]) {
> +			vq_sg_free(vq_sg);
> +			return NULL;
> +		}
> +		sg_init_table(vq_sg->sgl[i], SG_MAX_SINGLE_ALLOC);
> +		if (i) {
> +			/* chain the lists */
> +			sg_chain(vq_sg->sgl[i - 1], SG_MAX_SINGLE_ALLOC,
> +				 vq_sg->sgl[i]);
> +		}
> +	}
> +	sg_mark_end(&vq_sg->sgl[nsgl - 1][SG_MAX_SINGLE_ALLOC - 1]);
> +	return vq_sg;
> +}
> +
>  /**
>   * p9_virtio_close - reclaim resources of a channel
>   * @client: client instance
> @@ -158,9 +262,8 @@ static void req_done(struct virtqueue *vq)
> 
>  /**
>   * pack_sg_list - pack a scatter gather list from a linear buffer
> - * @sg: scatter/gather list to pack into
> + * @vq_sg: scatter/gather lists to pack into
>   * @start: which segment of the sg_list to start at
> - * @limit: maximum segment to pack data to
>   * @data: data to pack into scatter/gather list
>   * @count: amount of data to pack into the scatter/gather list
>   *
> @@ -170,11 +273,12 @@ static void req_done(struct virtqueue *vq)
>   *
>   */
> 
> -static int pack_sg_list(struct scatterlist *sg, int start,
> -			int limit, char *data, int count)
> +static int pack_sg_list(struct virtqueue_sg *vq_sg, int start,
> +			char *data, int count)
>  {
>  	int s;
>  	int index = start;
> +	size_t limit = vq_sg_npages(vq_sg);
> 
>  	while (count) {
>  		s = rest_of_page(data);
> @@ -182,13 +286,13 @@ static int pack_sg_list(struct scatterlist *sg, int
> start, s = count;
>  		BUG_ON(index >= limit);
>  		/* Make sure we don't terminate early. */
> -		sg_unmark_end(&sg[index]);
> -		sg_set_buf(&sg[index++], data, s);
> +		sg_unmark_end(vq_sg_page(vq_sg, index));
> +		sg_set_buf(vq_sg_page(vq_sg, index++), data, s);
>  		count -= s;
>  		data += s;
>  	}
>  	if (index-start)
> -		sg_mark_end(&sg[index - 1]);
> +		sg_mark_end(vq_sg_page(vq_sg, index - 1));
>  	return index-start;
>  }
> 
> @@ -208,21 +312,21 @@ static int p9_virtio_cancelled(struct p9_client
> *client, struct p9_req_t *req) /**
>   * pack_sg_list_p - Just like pack_sg_list. Instead of taking a buffer,
>   * this takes a list of pages.
> - * @sg: scatter/gather list to pack into
> + * @vq_sg: scatter/gather lists to pack into
>   * @start: which segment of the sg_list to start at
> - * @limit: maximum number of pages in sg list.
>   * @pdata: a list of pages to add into sg.
>   * @nr_pages: number of pages to pack into the scatter/gather list
>   * @offs: amount of data in the beginning of first page _not_ to pack
>   * @count: amount of data to pack into the scatter/gather list
>   */
>  static int
> -pack_sg_list_p(struct scatterlist *sg, int start, int limit,
> +pack_sg_list_p(struct virtqueue_sg *vq_sg, int start,
>  	       struct page **pdata, int nr_pages, size_t offs, int count)
>  {
>  	int i = 0, s;
>  	int data_off = offs;
>  	int index = start;
> +	size_t limit = vq_sg_npages(vq_sg);
> 
>  	BUG_ON(nr_pages > (limit - start));
>  	/*
> @@ -235,15 +339,16 @@ pack_sg_list_p(struct scatterlist *sg, int start, int
> limit, s = count;
>  		BUG_ON(index >= limit);
>  		/* Make sure we don't terminate early. */
> -		sg_unmark_end(&sg[index]);
> -		sg_set_page(&sg[index++], pdata[i++], s, data_off);
> +		sg_unmark_end(vq_sg_page(vq_sg, index));
> +		sg_set_page(vq_sg_page(vq_sg, index++), pdata[i++], s,
> +			    data_off);
>  		data_off = 0;
>  		count -= s;
>  		nr_pages--;
>  	}
> 
>  	if (index-start)
> -		sg_mark_end(&sg[index - 1]);
> +		sg_mark_end(vq_sg_page(vq_sg, index - 1));
>  	return index - start;
>  }
> 
> @@ -271,15 +376,13 @@ p9_virtio_request(struct p9_client *client, struct
> p9_req_t *req)
> 
>  	out_sgs = in_sgs = 0;
>  	/* Handle out VirtIO ring buffers */
> -	out = pack_sg_list(chan->sg, 0,
> -			   chan->sg_n, req->tc.sdata, req->tc.size);
> +	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
>  	if (out)
> -		sgs[out_sgs++] = chan->sg;
> +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
> 
> -	in = pack_sg_list(chan->sg, out,
> -			  chan->sg_n, req->rc.sdata, req->rc.capacity);
> +	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, req->rc.capacity);
>  	if (in)
> -		sgs[out_sgs + in_sgs++] = chan->sg + out;
> +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
> 
>  	err = virtqueue_add_sgs(chan->vq, sgs, out_sgs, in_sgs, req,
>  				GFP_ATOMIC);
> @@ -448,16 +551,15 @@ p9_virtio_zc_request(struct p9_client *client, struct
> p9_req_t *req, out_sgs = in_sgs = 0;
> 
>  	/* out data */
> -	out = pack_sg_list(chan->sg, 0,
> -			   chan->sg_n, req->tc.sdata, req->tc.size);
> +	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
> 
>  	if (out)
> -		sgs[out_sgs++] = chan->sg;
> +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
> 
>  	if (out_pages) {
> -		sgs[out_sgs++] = chan->sg + out;
> -		out += pack_sg_list_p(chan->sg, out, chan->sg_n,
> -				      out_pages, out_nr_pages, offs, outlen);
> +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, out);
> +		out += pack_sg_list_p(chan->vq_sg, out, out_pages,
> +				      out_nr_pages, offs, outlen);
>  	}
> 
>  	/*
> @@ -467,15 +569,14 @@ p9_virtio_zc_request(struct p9_client *client, struct
> p9_req_t *req, * Arrange in such a way that server places header in the
>  	 * allocated memory and payload onto the user buffer.
>  	 */
> -	in = pack_sg_list(chan->sg, out,
> -			  chan->sg_n, req->rc.sdata, in_hdr_len);
> +	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, in_hdr_len);
>  	if (in)
> -		sgs[out_sgs + in_sgs++] = chan->sg + out;
> +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
> 
>  	if (in_pages) {
> -		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
> -		in += pack_sg_list_p(chan->sg, out + in, chan->sg_n,
> -				     in_pages, in_nr_pages, offs, inlen);
> +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out + in);
> +		in += pack_sg_list_p(chan->vq_sg, out + in, in_pages,
> +				     in_nr_pages, offs, inlen);
>  	}
> 
>  	BUG_ON(out_sgs + in_sgs > ARRAY_SIZE(sgs));
> @@ -576,14 +677,12 @@ static int p9_virtio_probe(struct virtio_device *vdev)
> goto fail;
>  	}
> 
> -	chan->sg = kmalloc_array(VIRTQUEUE_DEFAULT_NUM,
> -				 sizeof(struct scatterlist), GFP_KERNEL);
> -	if (!chan->sg) {
> +	chan->vq_sg = vq_sg_alloc(VIRTQUEUE_SG_NSGL_DEFAULT);
> +	if (!chan->vq_sg) {
>  		pr_err("Failed to allocate virtio 9P channel\n");
>  		err = -ENOMEM;
>  		goto out_free_chan_shallow;
>  	}
> -	chan->sg_n = VIRTQUEUE_DEFAULT_NUM;
> 
>  	chan->vdev = vdev;
> 
> @@ -596,8 +695,6 @@ static int p9_virtio_probe(struct virtio_device *vdev)
>  	chan->vq->vdev->priv = chan;
>  	spin_lock_init(&chan->lock);
> 
> -	sg_init_table(chan->sg, chan->sg_n);
> -
>  	chan->inuse = false;
>  	if (virtio_has_feature(vdev, VIRTIO_9P_MOUNT_TAG)) {
>  		virtio_cread(vdev, struct virtio_9p_config, tag_len, &tag_len);
> @@ -646,7 +743,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
>  out_free_vq:
>  	vdev->config->del_vqs(vdev);
>  out_free_chan:
> -	kfree(chan->sg);
> +	vq_sg_free(chan->vq_sg);
>  out_free_chan_shallow:
>  	kfree(chan);
>  fail:
> @@ -741,7 +838,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
> kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
>  	kfree(chan->tag);
>  	kfree(chan->vc_wq);
> -	kfree(chan->sg);
> +	vq_sg_free(chan->vq_sg);
>  	kfree(chan);
> 
>  }
> @@ -780,7 +877,8 @@ static struct p9_trans_module p9_virtio_trans = {
>  	 * that are not at page boundary, that can result in an extra
>  	 * page in zero copy.
>  	 */
> -	.maxsize = PAGE_SIZE * (VIRTQUEUE_DEFAULT_NUM - 3),
> +	.maxsize = PAGE_SIZE *
> +		((VIRTQUEUE_SG_NSGL_DEFAULT * SG_USER_PAGES_PER_LIST) - 3),
>  	.def = 1,
>  	.owner = THIS_MODULE,
>  };




