Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EC68936A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjBCJSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbjBCJSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:18:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E09DCB5
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675415814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJGQZStfxsVKGxUqV2WM+lmLEOi/QZRXzJ/C23me5nI=;
        b=GxadHCQrmM3sxnCrP/ZEoMpuchHlXVfDKmshYwBIrIimdFsMlx7cGimHxJz/e0DYkny47M
        RWoVNiMVWlUybSLJgIgHUmUu3Cvax7QtvKYvJzwi6e6IRAl3ZWHBFlIucl+oucAjbSKj33
        MrPpvL3AbnOFjlPj+Yt0Rkw3Pc1apXA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-FEa8zNlbM9KPpwtl1aJ5Sw-1; Fri, 03 Feb 2023 04:16:52 -0500
X-MC-Unique: FEa8zNlbM9KPpwtl1aJ5Sw-1
Received: by mail-ed1-f72.google.com with SMTP id w3-20020a056402268300b00487e0d9b53fso3204729edd.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:16:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJGQZStfxsVKGxUqV2WM+lmLEOi/QZRXzJ/C23me5nI=;
        b=ru9D3PObF9c2XmfpHUVD7f05nrB5qN4SSEG659z8ww4JmkVJFxzKnbgAh795bm8p9A
         SiVwQE34PwaHOHk0PFdGEO4sYJWTbdEoF+OqvGNS2tRKZ+kQwOgRc95rJdbeq9bmE7MT
         Q/mC1epj4QfdZCohbc+HyTN2tQIrcD31p/v+38+1yElypQkfet034g0zr3eIoloyLaS8
         8rgxrkzPq/NXIbhlnwKAL9eZMQDehBfWW1lufChEFccDM7V+VjthDjjFkpCNFc57HDAk
         BRXwxMg9dtCH4N6wyFWwsRt5L2PqQeyJDX9doY8GvziIghVA/SPaIqkFBnPYejzHtxtg
         tNow==
X-Gm-Message-State: AO0yUKWpXcd6bjVJYfMJGPLX0LO2d5m8t25X4ZQmJN734EWoNcKJO826
        kDxm1iTXDuddACv81s5YWgyCDGYanGVEp2UysFZUJz6RGoz2gJ7pdvU2U6FYnOtHbTGWc9Mv8Hm
        m9Dm/3RsjcXPNpZfQ
X-Received: by 2002:aa7:cd7b:0:b0:49e:28b6:4cf5 with SMTP id ca27-20020aa7cd7b000000b0049e28b64cf5mr8389095edb.12.1675415811690;
        Fri, 03 Feb 2023 01:16:51 -0800 (PST)
X-Google-Smtp-Source: AK7set/EmHAFK9dC9goDmVVuChPcdLV6U8CHAWYLmcDLw7reR7t0oHvcqvjJrxlemwCIBS6vUDpGlw==
X-Received: by 2002:aa7:cd7b:0:b0:49e:28b6:4cf5 with SMTP id ca27-20020aa7cd7b000000b0049e28b64cf5mr8389078edb.12.1675415811477;
        Fri, 03 Feb 2023 01:16:51 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id z21-20020aa7c655000000b00483dd234ac6sm800134edr.96.2023.02.03.01.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:16:50 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:16:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 03/33] virtio_ring: packed: virtqueue_add_packed()
 support premapped
Message-ID: <20230203041006-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-4-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-4-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:28PM +0800, Xuan Zhuo wrote:
> virtqueue_add_packed() only supports virtual addresses, dma is completed
> in virtqueue_add_packed().
> 
> In some scenarios (such as the AF_XDP scenario), the memory is allocated
> and DMA is completed in advance, so it is necessary for us to support
> passing the DMA address to virtqueue_add_packed().
> 
> Record this information in desc_state, we can skip unmap based on this
> when executing dma unmap.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 71 +++++++++++++++++++++++++-----------
>  1 file changed, 50 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index ec622403cbd5..25027a35fcf8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -78,6 +78,7 @@ struct vring_desc_state_packed {
>  	struct vring_packed_desc *indir_desc; /* Indirect descriptor, if any. */
>  	u16 num;			/* Descriptor list length. */
>  	u16 last;			/* The last desc state in a list. */
> +	bool premapped;
>  };
>  
>  struct vring_desc_extra {


That's an extra cache line. 
> @@ -1200,7 +1201,8 @@ static inline u16 packed_last_used(u16 last_used_idx)
>  }
>  
>  static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
> -				     struct vring_desc_extra *extra)
> +				     struct vring_desc_extra *extra,
> +				     bool premapped)
>  {
>  	u16 flags;
>  
> @@ -1215,6 +1217,9 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
>  				 (flags & VRING_DESC_F_WRITE) ?
>  				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
>  	} else {
> +		if (premapped)
> +			return;
> +
>  		dma_unmap_page(vring_dma_dev(vq),
>  			       extra->addr, extra->len,
>  			       (flags & VRING_DESC_F_WRITE) ?
> @@ -1262,7 +1267,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  					 unsigned int out_sgs,
>  					 unsigned int in_sgs,
>  					 void *data,
> -					 gfp_t gfp)
> +					 gfp_t gfp,
> +					 bool premapped)
>  {
>  	struct vring_packed_desc *desc;
>  	struct scatterlist *sg;
> @@ -1288,10 +1294,15 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  
>  	for (n = 0; n < out_sgs + in_sgs; n++) {
>  		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
> -			addr = vring_map_one_sg(vq, sg, n < out_sgs ?
> -					DMA_TO_DEVICE : DMA_FROM_DEVICE);
> -			if (vring_mapping_error(vq, addr))
> -				goto unmap_release;
> +			if (premapped) {
> +				addr = sg_dma_address(sg);
> +
> +			} else {
> +				addr = vring_map_one_sg(vq, sg, n < out_sgs ?
> +							DMA_TO_DEVICE : DMA_FROM_DEVICE);
> +				if (vring_mapping_error(vq, addr))
> +					goto unmap_release;
> +			}
>  
>  			desc[i].flags = cpu_to_le16(n < out_sgs ?
>  						0 : VRING_DESC_F_WRITE);
> @@ -1350,6 +1361,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  	vq->packed.desc_state[id].data = data;
>  	vq->packed.desc_state[id].indir_desc = desc;
>  	vq->packed.desc_state[id].last = id;
> +	vq->packed.desc_state[id].premapped = premapped;
>  
>  	vq->num_added += 1;
>  
> @@ -1359,10 +1371,11 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  	return 0;
>  
>  unmap_release:
> -	err_idx = i;
> -
> -	for (i = 0; i < err_idx; i++)
> -		vring_unmap_desc_packed(vq, &desc[i]);
> +	if (!premapped) {
> +		err_idx = i;
> +		for (i = 0; i < err_idx; i++)
> +			vring_unmap_desc_packed(vq, &desc[i]);
> +	}
>  
>  	kfree(desc);
>  
> @@ -1377,6 +1390,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>  				       unsigned int in_sgs,
>  				       void *data,
>  				       void *ctx,
> +				       bool premapped,
>  				       gfp_t gfp)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> @@ -1403,7 +1417,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>  
>  	if (virtqueue_use_indirect(vq, total_sg)) {
>  		err = virtqueue_add_indirect_packed(vq, sgs, total_sg, out_sgs,
> -						    in_sgs, data, gfp);
> +						    in_sgs, data, gfp, premapped);
>  		if (err != -ENOMEM) {
>  			END_USE(vq);
>  			return err;
> @@ -1435,10 +1449,17 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>  	c = 0;
>  	for (n = 0; n < out_sgs + in_sgs; n++) {
>  		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
> -			dma_addr_t addr = vring_map_one_sg(vq, sg, n < out_sgs ?
> -					DMA_TO_DEVICE : DMA_FROM_DEVICE);
> -			if (vring_mapping_error(vq, addr))
> -				goto unmap_release;
> +			dma_addr_t addr;
> +
> +			if (premapped) {
> +				addr = sg_dma_address(sg);
> +

drop this empty line pls.

> +			} else {
> +				addr = vring_map_one_sg(vq, sg, n < out_sgs ?
> +							DMA_TO_DEVICE : DMA_FROM_DEVICE);
> +				if (vring_mapping_error(vq, addr))
> +					goto unmap_release;
> +			}
>  
>  			flags = cpu_to_le16(vq->packed.avail_used_flags |
>  				    (++c == total_sg ? 0 : VRING_DESC_F_NEXT) |
> @@ -1485,6 +1506,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>  	vq->packed.desc_state[id].data = data;
>  	vq->packed.desc_state[id].indir_desc = ctx;
>  	vq->packed.desc_state[id].last = prev;
> +	vq->packed.desc_state[id].premapped = premapped;
>  
>  	/*
>  	 * A driver MUST NOT make the first descriptor in the list
> @@ -1501,22 +1523,26 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
>  	return 0;
>  
>  unmap_release:
> +	vq->packed.avail_used_flags = avail_used_flags;
> +
> +	if (premapped)
> +		goto unmap_free;
> +

This goto branching inside error handling is too much like spaghetti code.
See Documentation/process/coding-style.rst for when goto is ok -
basically exit/error handling. This is not error handling.
Pls find a way to avoid.

>  	err_idx = i;
>  	i = head;
>  	curr = vq->free_head;
>  
> -	vq->packed.avail_used_flags = avail_used_flags;
> -
>  	for (n = 0; n < total_sg; n++) {
>  		if (i == err_idx)
>  			break;
> -		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[curr]);
> +		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[curr], false);
>  		curr = vq->packed.desc_extra[curr].next;
>  		i++;
>  		if (i >= vq->packed.vring.num)
>  			i = 0;
>  	}
>  
> +unmap_free:
>  	END_USE(vq);
>  	return -EIO;
>  }
> @@ -1576,8 +1602,10 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
>  	struct vring_desc_state_packed *state = NULL;
>  	struct vring_packed_desc *desc;
>  	unsigned int i, curr;
> +	bool premapped;
>  
>  	state = &vq->packed.desc_state[id];
> +	premapped = state->premapped;
>  
>  	/* Clear data ptr. */
>  	state->data = NULL;
> @@ -1590,7 +1618,8 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
>  		curr = id;
>  		for (i = 0; i < state->num; i++) {
>  			vring_unmap_extra_packed(vq,
> -						 &vq->packed.desc_extra[curr]);
> +						 &vq->packed.desc_extra[curr],
> +						 premapped);
>  			curr = vq->packed.desc_extra[curr].next;
>  		}
>  	}
> @@ -1603,7 +1632,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
>  		if (!desc)
>  			return;
>  
> -		if (vq->use_dma_api) {
> +		if (vq->use_dma_api && !premapped) {
>  			len = vq->packed.desc_extra[id].len;
>  			for (i = 0; i < len / sizeof(struct vring_packed_desc);
>  					i++)
> @@ -2122,7 +2151,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
>  	return vq->packed_ring ? virtqueue_add_packed(_vq, sgs, total_sg,
> -					out_sgs, in_sgs, data, ctx, gfp) :
> +					out_sgs, in_sgs, data, ctx, premapped, gfp) :
>  				 virtqueue_add_split(_vq, sgs, total_sg,
>  					out_sgs, in_sgs, data, ctx, premapped, gfp);
>  }


Too much if !premapped all over the place. Pls refactor so we
get common code and then have premapped and non premapped
versions call that.
> -- 
> 2.32.0.3.g01195cf9f

