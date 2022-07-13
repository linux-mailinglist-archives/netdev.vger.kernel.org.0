Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29957323A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbiGMJQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGMJQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:16:16 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB2FE0F4F;
        Wed, 13 Jul 2022 02:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=06OoC9oCRVg+6WOjs+yPs8q4fok70GgfrEc5ex8uQ74=; b=BpPkzSU4s2rxAkt3UlVuboyBuA
        M00NOV5gQdzwfIRpOIOgplPbowQR7aRZAx/ZfJe0nRytzm3py0NN1S4/FP5gcL/YWwGyu/ZtgPsyM
        JzE4NWPQfEMn2nA9Kc+x2Uv32rFkUcplIpeb8ZjYC5GvyR4R6EPVA2cxF5Za0SNIkuCgUYMpYhCeh
        7pgKWzqd+FZoTk0j111rpjeJamZ76pf2N9AX1wAlartUh56nAEeq0s0ffVi7VbwV7fpLTCTIn+g84
        Ob5snDQVloFLio7dZI1LaPd4NwtPthPfUI8r6PUHgWezZJ2nrLLhxWzOmnNU3c4uFeaI5vVPxfwt1
        KhGMVdXLr20w2HpNGPltgbsdKhtXoDiv80DGzC4XPpvdMyKt6XfAUk0EL470vE/V2Xdd7iq6Uj/TX
        RZCJW/kfKa+SZTCtcQGrdUt3dUZc3YVbbY09+ggegZ+TAzLKduX4wEpSDt3xRorQCbIcRcrFPfzue
        6iyEy9K58j4GqHfGNxSDQHgXOPGilyi/N1s7jsJ6CjfXQCmsjzRdywawMvGN+ioQ7DrjBQQ7IYUTv
        0pgCFiJ1NcypvGIhq9oulQORqgRoySktmyDMgxFXdg/8UVBze94AIJqSonOrAkidsqU2WyTsB/THB
        j11N/lF1PfDxRkHWVBu8/qnClqbBuG/NWKL0wLhw0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 03/11] 9p/trans_virtio: introduce struct virtqueue_sg
Date:   Wed, 13 Jul 2022 11:14:42 +0200
Message-ID: <15494041.V0O07oc0Fd@silver>
In-Reply-To: <Ys3antr+zrP5eQ1Z@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <862eef0d6d4b14faaea0d2aab982a3c8dfd8056b.1657636554.git.linux_oss@crudebyte.com>
 <Ys3antr+zrP5eQ1Z@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dienstag, 12. Juli 2022 22:33:34 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:16PM +0200:
> > The amount of elements in a scatter/gather list is limited to
> > approximately 128 elements. To allow going beyond that limit
> > with subsequent patches, pave the way by turning the one-
> > 
> > dimensional sg list array into a two-dimensional array, i.e:
> >   sg[128]
> > 
> > becomes
> > 
> >   sgl[nsgl][SG_MAX_SINGLE_ALLOC]
> > 
> > As the value of 'nsgl' is exactly (still) 1 in this commit
> > and the compile-time (compiler and architecture dependent)
> > value of 'SG_MAX_SINGLE_ALLOC' equals approximately the
> > previous hard coded 128 elements, this commit is therefore
> > more of a preparatory refactoring then actual behaviour
> > change.
> > 
> > A custom struct virtqueue_sg is defined instead of using
> > shared API struct sg_table, because the latter would not
> > allow to resize the table after allocation. sg_append_table
> > API OTOH would not fit either, because it requires a list
> > of pages beforehand upon allocation. And both APIs only
> > support all-or-nothing allocation.
> > 
> > Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> > ---
> > 
> > The question is whether that should really become 9p specifc SG list
> > code, or whether it should rather be squeezed into shared SG list code
> > base. Opinions by maintainers needed.
> 
> hmm from the 9p side I'd say the type is simple enough that we can just
> keep it here; most people don't want to resize these lists...

OK, then I retain it as 9p-specific SG struct then.

> How much do you care about the all-or-nothing case you described in this
> commit message? From the look of it, patch 6 -- at what point did you
> actually see this being useful?

Patch 6 is probably a case of over-engineering, so if you want I can also drop 
patch 6 now or retain it and you'll just eventually ignore it. Because when 
someone comes into the situation having trouble to allocate the SG lists 
already, then allocation of their actual bulk date pages is likely to become 
much more troublesome.

> >  net/9p/trans_virtio.c | 193 ++++++++++++++++++++++++++++++++----------
> >  1 file changed, 147 insertions(+), 46 deletions(-)
> > 
> > diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> > index 18bdfa64b934..f63cd1b08bca 100644
> > --- a/net/9p/trans_virtio.c
> > +++ b/net/9p/trans_virtio.c
> > @@ -36,7 +36,31 @@
> > 
> >  #include <linux/virtio_9p.h>
> >  #include "trans_common.h"
> > 
> > -#define VIRTQUEUE_DEFAULT_NUM	128
> > +/**
> > + * struct virtqueue_sg - (chained) scatter gather lists for virtqueue
> > data
> > + * transmission
> > + * @nsgl: amount of elements (in first dimension) of array field @sgl
> > + * @sgl: two-dimensional array, i.e. sgl[nsgl][SG_MAX_SINGLE_ALLOC]
> > + */
> > +struct virtqueue_sg {
> > +	unsigned int nsgl;
> > +	struct scatterlist *sgl[];
> > +};
> > +
> > +/*
> > + * Default value for field nsgl in struct virtqueue_sg, which defines the
> > + * initial virtio data transmission capacity when this virtio transport
> > is
> > + * probed.
> > + */
> > +#define VIRTQUEUE_SG_NSGL_DEFAULT 1
> > +
> > +/* maximum value for field nsgl in struct virtqueue_sg */
> > +#define VIRTQUEUE_SG_NSGL_MAX					
	\
> > +	((PAGE_SIZE - sizeof(struct virtqueue_sg)) /			
\
> > +	sizeof(struct scatterlist *))					
\
> > +
> > +/* last entry per sg list is used for chaining (pointer to next list) */
> > +#define SG_USER_PAGES_PER_LIST	(SG_MAX_SINGLE_ALLOC - 1)
> > 
> >  /* a single mutex to manage channel initialization and attachment */
> >  static DEFINE_MUTEX(virtio_9p_lock);
> > 
> > @@ -53,8 +77,7 @@ static atomic_t vp_pinned = ATOMIC_INIT(0);
> > 
> >   * @ring_bufs_avail: flag to indicate there is some available in the ring
> >   buf * @vc_wq: wait queue for waiting for thing to be added to ring buf
> >   * @p9_max_pages: maximum number of pinned pages
> > 
> > - * @sg: scatter gather list which is used to pack a request (protected?)
> > - * @sg_n: amount of elements in sg array
> > + * @vq_sg: table of scatter gather lists, which are used to pack a
> > request
> > 
> >   * @chan_list: linked list of channels
> >   *
> >   * We keep all per-channel information in a structure.
> > 
> > @@ -77,9 +100,7 @@ struct virtio_chan {
> > 
> >  	 * will be placing it in each channel.
> >  	 */
> >  	
> >  	unsigned long p9_max_pages;
> > 
> > -	/* Scatterlist: can be too big for stack. */
> > -	struct scatterlist *sg;
> > -	size_t sg_n;
> > +	struct virtqueue_sg *vq_sg;
> > 
> >  	/**
> >  	
> >  	 * @tag: name to identify a mount null terminated
> >  	 */
> > 
> > @@ -96,6 +117,92 @@ static unsigned int rest_of_page(void *data)
> > 
> >  	return PAGE_SIZE - offset_in_page(data);
> >  
> >  }
> > 
> > +/**
> > + * vq_sg_page - returns user page for given page index
> > + * @vq_sg: scatter gather lists used by this transport
> > + * @page: user page index across all scatter gather lists
> > + */
> > +static struct scatterlist *vq_sg_page(struct virtqueue_sg *vq_sg, size_t
> > page) +{
> > +	unsigned int node = page / SG_USER_PAGES_PER_LIST;
> > +	unsigned int leaf = page % SG_USER_PAGES_PER_LIST;
> > +	BUG_ON(node >= VIRTQUEUE_SG_NSGL_MAX);
> 
> probably awnt to check with vq_sg->sg_n instead?
> (we already check sg_n <= MAX on alloc)

Right, that makes sense!

> > +	return &vq_sg->sgl[node][leaf];
> > +}
> > +
> > +/**
> > + * vq_sg_npages - returns total number of individual user pages in passed
> > + * scatter gather lists
> > + * @vq_sg: scatter gather lists to be counted
> > + */
> > +static size_t vq_sg_npages(struct virtqueue_sg *vq_sg)
> > +{
> > +	return vq_sg->nsgl * SG_USER_PAGES_PER_LIST;
> > +}
> > +
> > +/**
> > + * vq_sg_free - free all memory previously allocated for @vq_sg
> > + * @vq_sg: scatter gather lists to be freed
> > + */
> > +static void vq_sg_free(struct virtqueue_sg *vq_sg)
> > +{
> > +	unsigned int i;
> > +
> > +	if (!vq_sg)
> > +		return;
> > +
> > +	for (i = 0; i < vq_sg->nsgl; ++i) {
> > +		kfree(vq_sg->sgl[i]);
> > +	}
> > +	kfree(vq_sg);
> > +}
> > +
> > +/**
> > + * vq_sg_alloc - allocates and returns @nsgl scatter gather lists
> > + * @nsgl: amount of scatter gather lists to be allocated
> > + * If @nsgl is larger than one then chained lists are used if supported
> > by
> > + * architecture.
> > + */
> > +static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
> > +{
> > +	struct virtqueue_sg *vq_sg;
> > +	unsigned int i;
> > +
> > +	BUG_ON(!nsgl || nsgl > VIRTQUEUE_SG_NSGL_MAX);
> > +#ifdef CONFIG_ARCH_NO_SG_CHAIN
> > +	if (WARN_ON_ONCE(nsgl > 1))
> > +		return NULL;
> > +#endif
> > +
> > +	vq_sg = kzalloc(sizeof(struct virtqueue_sg) +
> > +			nsgl * sizeof(struct scatterlist *),
> > +			GFP_KERNEL);
> > +
> > +	if (!vq_sg)
> > +		return NULL;
> > +
> > +	vq_sg->nsgl = nsgl;
> > +
> > +	for (i = 0; i < nsgl; ++i) {
> > +		vq_sg->sgl[i] = kmalloc_array(
> > +			SG_MAX_SINGLE_ALLOC, sizeof(struct scatterlist),
> > +			GFP_KERNEL
> > +		);
> > +		if (!vq_sg->sgl[i]) {
> > +			vq_sg_free(vq_sg);
> > +			return NULL;
> > +		}
> > +		sg_init_table(vq_sg->sgl[i], SG_MAX_SINGLE_ALLOC);
> > +		if (i) {
> > +			/* chain the lists */
> > +			sg_chain(vq_sg->sgl[i - 1], SG_MAX_SINGLE_ALLOC,
> > +				 vq_sg->sgl[i]);
> > +		}
> > +	}
> > +	sg_mark_end(&vq_sg->sgl[nsgl - 1][SG_MAX_SINGLE_ALLOC - 1]);
> > +	return vq_sg;
> > +}
> > +
> > 
> >  /**
> >  
> >   * p9_virtio_close - reclaim resources of a channel
> >   * @client: client instance
> > 
> > @@ -158,9 +265,8 @@ static void req_done(struct virtqueue *vq)
> > 
> >  /**
> >  
> >   * pack_sg_list - pack a scatter gather list from a linear buffer
> > 
> > - * @sg: scatter/gather list to pack into
> > + * @vq_sg: scatter/gather lists to pack into
> > 
> >   * @start: which segment of the sg_list to start at
> > 
> > - * @limit: maximum segment to pack data to
> > 
> >   * @data: data to pack into scatter/gather list
> >   * @count: amount of data to pack into the scatter/gather list
> >   *
> > 
> > @@ -170,11 +276,12 @@ static void req_done(struct virtqueue *vq)
> > 
> >   *
> >   */
> > 
> > -static int pack_sg_list(struct scatterlist *sg, int start,
> > -			int limit, char *data, int count)
> > +static int pack_sg_list(struct virtqueue_sg *vq_sg, int start,
> > +			char *data, int count)
> > 
> >  {
> >  
> >  	int s;
> >  	int index = start;
> > 
> > +	size_t limit = vq_sg_npages(vq_sg);
> > 
> >  	while (count) {
> >  	
> >  		s = rest_of_page(data);
> > 
> > @@ -182,13 +289,13 @@ static int pack_sg_list(struct scatterlist *sg, int
> > start,> 
> >  			s = count;
> >  		
> >  		BUG_ON(index >= limit);
> >  		/* Make sure we don't terminate early. */
> > 
> > -		sg_unmark_end(&sg[index]);
> > -		sg_set_buf(&sg[index++], data, s);
> > +		sg_unmark_end(vq_sg_page(vq_sg, index));
> > +		sg_set_buf(vq_sg_page(vq_sg, index++), data, s);
> > 
> >  		count -= s;
> >  		data += s;
> >  	
> >  	}
> >  	if (index-start)
> > 
> > -		sg_mark_end(&sg[index - 1]);
> > +		sg_mark_end(vq_sg_page(vq_sg, index - 1));
> > 
> >  	return index-start;
> >  
> >  }
> > 
> > @@ -208,21 +315,21 @@ static int p9_virtio_cancelled(struct p9_client
> > *client, struct p9_req_t *req)> 
> >  /**
> >  
> >   * pack_sg_list_p - Just like pack_sg_list. Instead of taking a buffer,
> >   * this takes a list of pages.
> > 
> > - * @sg: scatter/gather list to pack into
> > + * @vq_sg: scatter/gather lists to pack into
> > 
> >   * @start: which segment of the sg_list to start at
> > 
> > - * @limit: maximum number of pages in sg list.
> > 
> >   * @pdata: a list of pages to add into sg.
> >   * @nr_pages: number of pages to pack into the scatter/gather list
> >   * @offs: amount of data in the beginning of first page _not_ to pack
> >   * @count: amount of data to pack into the scatter/gather list
> >   */
> >  
> >  static int
> > 
> > -pack_sg_list_p(struct scatterlist *sg, int start, int limit,
> > +pack_sg_list_p(struct virtqueue_sg *vq_sg, int start,
> > 
> >  	       struct page **pdata, int nr_pages, size_t offs, int count)
> >  
> >  {
> >  
> >  	int i = 0, s;
> >  	int data_off = offs;
> >  	int index = start;
> > 
> > +	size_t limit = vq_sg_npages(vq_sg);
> > 
> >  	BUG_ON(nr_pages > (limit - start));
> >  	/*
> > 
> > @@ -235,15 +342,16 @@ pack_sg_list_p(struct scatterlist *sg, int start,
> > int limit,> 
> >  			s = count;
> >  		
> >  		BUG_ON(index >= limit);
> >  		/* Make sure we don't terminate early. */
> > 
> > -		sg_unmark_end(&sg[index]);
> > -		sg_set_page(&sg[index++], pdata[i++], s, data_off);
> > +		sg_unmark_end(vq_sg_page(vq_sg, index));
> > +		sg_set_page(vq_sg_page(vq_sg, index++), pdata[i++], s,
> > +			    data_off);
> > 
> >  		data_off = 0;
> >  		count -= s;
> >  		nr_pages--;
> >  	
> >  	}
> >  	
> >  	if (index-start)
> > 
> > -		sg_mark_end(&sg[index - 1]);
> > +		sg_mark_end(vq_sg_page(vq_sg, index - 1));
> > 
> >  	return index - start;
> >  
> >  }
> > 
> > @@ -271,15 +379,13 @@ p9_virtio_request(struct p9_client *client, struct
> > p9_req_t *req)> 
> >  	out_sgs = in_sgs = 0;
> >  	/* Handle out VirtIO ring buffers */
> > 
> > -	out = pack_sg_list(chan->sg, 0,
> > -			   chan->sg_n, req->tc.sdata, req->tc.size);
> > +	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
> > 
> >  	if (out)
> > 
> > -		sgs[out_sgs++] = chan->sg;
> > +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
> > 
> > -	in = pack_sg_list(chan->sg, out,
> > -			  chan->sg_n, req->rc.sdata, req->rc.capacity);
> > +	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, req-
>rc.capacity);
> > 
> >  	if (in)
> > 
> > -		sgs[out_sgs + in_sgs++] = chan->sg + out;
> > +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
> > 
> >  	err = virtqueue_add_sgs(chan->vq, sgs, out_sgs, in_sgs, req,
> >  	
> >  				GFP_ATOMIC);
> > 
> > @@ -448,16 +554,15 @@ p9_virtio_zc_request(struct p9_client *client,
> > struct p9_req_t *req,> 
> >  	out_sgs = in_sgs = 0;
> >  	
> >  	/* out data */
> > 
> > -	out = pack_sg_list(chan->sg, 0,
> > -			   chan->sg_n, req->tc.sdata, req->tc.size);
> > +	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
> > 
> >  	if (out)
> > 
> > -		sgs[out_sgs++] = chan->sg;
> > +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
> > 
> >  	if (out_pages) {
> > 
> > -		sgs[out_sgs++] = chan->sg + out;
> > -		out += pack_sg_list_p(chan->sg, out, chan->sg_n,
> > -				      out_pages, out_nr_pages, offs, 
outlen);
> > +		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, out);
> > +		out += pack_sg_list_p(chan->vq_sg, out, out_pages,
> > +				      out_nr_pages, offs, outlen);
> > 
> >  	}
> >  	
> >  	/*
> > 
> > @@ -467,15 +572,14 @@ p9_virtio_zc_request(struct p9_client *client,
> > struct p9_req_t *req,> 
> >  	 * Arrange in such a way that server places header in the
> >  	 * allocated memory and payload onto the user buffer.
> >  	 */
> > 
> > -	in = pack_sg_list(chan->sg, out,
> > -			  chan->sg_n, req->rc.sdata, in_hdr_len);
> > +	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, in_hdr_len);
> > 
> >  	if (in)
> > 
> > -		sgs[out_sgs + in_sgs++] = chan->sg + out;
> > +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
> > 
> >  	if (in_pages) {
> > 
> > -		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
> > -		in += pack_sg_list_p(chan->sg, out + in, chan->sg_n,
> > -				     in_pages, in_nr_pages, offs, 
inlen);
> > +		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out + 
in);
> > +		in += pack_sg_list_p(chan->vq_sg, out + in, in_pages,
> > +				     in_nr_pages, offs, inlen);
> > 
> >  	}
> >  	
> >  	BUG_ON(out_sgs + in_sgs > ARRAY_SIZE(sgs));
> > 
> > @@ -576,14 +680,12 @@ static int p9_virtio_probe(struct virtio_device
> > *vdev)> 
> >  		goto fail;
> >  	
> >  	}
> > 
> > -	chan->sg = kmalloc_array(VIRTQUEUE_DEFAULT_NUM,
> > -				 sizeof(struct scatterlist), 
GFP_KERNEL);
> > -	if (!chan->sg) {
> > +	chan->vq_sg = vq_sg_alloc(VIRTQUEUE_SG_NSGL_DEFAULT);
> > +	if (!chan->vq_sg) {
> > 
> >  		pr_err("Failed to allocate virtio 9P channel\n");
> >  		err = -ENOMEM;
> >  		goto out_free_chan_shallow;
> >  	
> >  	}
> > 
> > -	chan->sg_n = VIRTQUEUE_DEFAULT_NUM;
> > 
> >  	chan->vdev = vdev;
> > 
> > @@ -596,8 +698,6 @@ static int p9_virtio_probe(struct virtio_device *vdev)
> > 
> >  	chan->vq->vdev->priv = chan;
> >  	spin_lock_init(&chan->lock);
> > 
> > -	sg_init_table(chan->sg, chan->sg_n);
> > -
> > 
> >  	chan->inuse = false;
> >  	if (virtio_has_feature(vdev, VIRTIO_9P_MOUNT_TAG)) {
> >  	
> >  		virtio_cread(vdev, struct virtio_9p_config, tag_len, 
&tag_len);
> > 
> > @@ -646,7 +746,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
> > 
> >  out_free_vq:
> >  	vdev->config->del_vqs(vdev);
> >  
> >  out_free_chan:
> > -	kfree(chan->sg);
> > +	vq_sg_free(chan->vq_sg);
> > 
> >  out_free_chan_shallow:
> >  	kfree(chan);
> >  
> >  fail:
> > @@ -741,7 +841,7 @@ static void p9_virtio_remove(struct virtio_device
> > *vdev)> 
> >  	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
> >  	kfree(chan->tag);
> >  	kfree(chan->vc_wq);
> > 
> > -	kfree(chan->sg);
> > +	vq_sg_free(chan->vq_sg);
> > 
> >  	kfree(chan);
> >  
> >  }
> > 
> > @@ -780,7 +880,8 @@ static struct p9_trans_module p9_virtio_trans = {
> > 
> >  	 * that are not at page boundary, that can result in an extra
> >  	 * page in zero copy.
> >  	 */
> > 
> > -	.maxsize = PAGE_SIZE * (VIRTQUEUE_DEFAULT_NUM - 3),
> > +	.maxsize = PAGE_SIZE *
> > +		((VIRTQUEUE_SG_NSGL_DEFAULT * SG_USER_PAGES_PER_LIST) - 
3),
> > 
> >  	.def = 1,
> >  	.owner = THIS_MODULE,
> >  
> >  };




