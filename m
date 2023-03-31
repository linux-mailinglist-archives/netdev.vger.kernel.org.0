Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748656D1BC9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCaJQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCaJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06E11D2D6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/JS/osSA5h7igfJZxqOSBjqf6v2ujYGgr3ycuj9xUb4=;
        b=EGPTVyykiyRx8SJHeBHOUCUu88zmX5txc7gIWPyMBwX+8GWhV7xm/v8Sq+djglKvIp3ew0
        kOdzYIqpn0TUC1Cl8cjsIMZ/pgNJRHdNCkLkriGsCwl1cWXnUTJGw8JnkXO8UKsZAZg3pn
        H1FXBMHHUwanP6hld4d/jQiKKYa5YbQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-MOqDvwlkOnO7xunfjJPdCA-1; Fri, 31 Mar 2023 05:14:42 -0400
X-MC-Unique: MOqDvwlkOnO7xunfjJPdCA-1
Received: by mail-pf1-f197.google.com with SMTP id h66-20020a628345000000b00625e0121e40so10133527pfe.1
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680254081; x=1682846081;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JS/osSA5h7igfJZxqOSBjqf6v2ujYGgr3ycuj9xUb4=;
        b=xuFCrmLTycSgR1cz/SQzGj0L8Wn41SApQ33B4bj30p9Hqedo0ps8tpdWBOlVLg4Fov
         HRqrXat8mXgQJwSZ+opKrRkonXlvQGxbmsMYtUvRoMHqoebledQ1OWliQ1wmogtE+C9O
         EybLpH6wmeRez7KGfnv/BWwcSKUONJ8DCvGVU4NdYNT0Zgi0wvshli4N7dIZC8pY4wBv
         XgeSJ88BAUTLw0vSLFl0v3iUr/lR2E5/Tak2E0HZxnom4A9sSys2m5+ShQxAZTQtb4y5
         l61lOBTyZodmTBonmyfxr0i6XYf/Xy/W4D39AMLj2Nm/dl00/81pKn0H4v9K/8TtDJ++
         EWWA==
X-Gm-Message-State: AAQBX9cg3O1xzEzsEYy8fSRmZYFHXzfb9FexGf6yDGSjw4u0JowwK4at
        YckE8W61hyNnm9s6vYf5j3Ow2q5NfLKpAWW5Svt/c9KxTJ0KCQm+DlMqDdefMpRI5aiteDGKjnJ
        i/4NBflnQl+zzCmhL
X-Received: by 2002:a17:90b:1d09:b0:240:5397:bd91 with SMTP id on9-20020a17090b1d0900b002405397bd91mr29295208pjb.4.1680254081366;
        Fri, 31 Mar 2023 02:14:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350azVcu+SuzZYBuZrGYsfh+gJoBAdGdFAR0ZndpXH0PoLcS0dzSktKrdCcUjh9hiMfgdfnHQVw==
X-Received: by 2002:a17:90b:1d09:b0:240:5397:bd91 with SMTP id on9-20020a17090b1d0900b002405397bd91mr29295183pjb.4.1680254081048;
        Fri, 31 Mar 2023 02:14:41 -0700 (PDT)
Received: from [10.72.13.208] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jh5-20020a170903328500b0019f892dc696sm1077019plb.229.2023.03.31.02.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 02:14:40 -0700 (PDT)
Message-ID: <a5b743d1-37d1-1225-c1cb-62cd23d26aef@redhat.com>
Date:   Fri, 31 Mar 2023 17:14:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce
 mergeable_xdp_prepare
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230328120412.110114-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/28 20:04, Xuan Zhuo 写道:
> Separating the logic of preparation for xdp from receive_mergeable.
>
> The purpose of this is to simplify the logic of execution of XDP.
>
> The main logic here is that when headroom is insufficient, we need to
> allocate a new page and calculate offset. It should be noted that if
> there is new page, the variable page will refer to the new page.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 135 ++++++++++++++++++++++-----------------
>   1 file changed, 77 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d2bf1ce0730..bb426958cdd4 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1162,6 +1162,79 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>   	return 0;
>   }
>   
> +static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> +				   struct receive_queue *rq,
> +				   struct bpf_prog *xdp_prog,
> +				   void *ctx,
> +				   unsigned int *frame_sz,
> +				   int *num_buf,
> +				   struct page **page,
> +				   int offset,
> +				   unsigned int *len,
> +				   struct virtio_net_hdr_mrg_rxbuf *hdr)
> +{
> +	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
> +	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> +	struct page *xdp_page;
> +	unsigned int xdp_room;
> +
> +	/* Transient failure which in theory could occur if
> +	 * in-flight packets from before XDP was enabled reach
> +	 * the receive path after XDP is loaded.
> +	 */
> +	if (unlikely(hdr->hdr.gso_type))
> +		return NULL;
> +
> +	/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> +	 * with headroom may add hole in truesize, which
> +	 * make their length exceed PAGE_SIZE. So we disabled the
> +	 * hole mechanism for xdp. See add_recvbuf_mergeable().
> +	 */
> +	*frame_sz = truesize;
> +
> +	/* This happens when headroom is not enough because
> +	 * of the buffer was prefilled before XDP is set.
> +	 * This should only happen for the first several packets.
> +	 * In fact, vq reset can be used here to help us clean up
> +	 * the prefilled buffers, but many existing devices do not
> +	 * support it, and we don't want to bother users who are
> +	 * using xdp normally.
> +	 */
> +	if (!xdp_prog->aux->xdp_has_frags &&
> +	    (*num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> +		/* linearize data for XDP */
> +		xdp_page = xdp_linearize_page(rq, num_buf,
> +					      *page, offset,
> +					      VIRTIO_XDP_HEADROOM,
> +					      len);
> +
> +		if (!xdp_page)
> +			return NULL;
> +	} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> +		xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> +					  sizeof(struct skb_shared_info));
> +		if (*len + xdp_room > PAGE_SIZE)
> +			return NULL;
> +
> +		xdp_page = alloc_page(GFP_ATOMIC);
> +		if (!xdp_page)
> +			return NULL;
> +
> +		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> +		       page_address(*page) + offset, *len);
> +	} else {
> +		return page_address(*page) + offset;


This makes the code a little harder to be read than the original code.

Why not do a verbatim moving without introducing new logic? (Or 
introducing new logic on top?)

Thanks


> +	}
> +
> +	*frame_sz = PAGE_SIZE;
> +
> +	put_page(*page);
> +
> +	*page = xdp_page;
> +
> +	return page_address(xdp_page) + VIRTIO_XDP_HEADROOM;
> +}
> +
>   static struct sk_buff *receive_mergeable(struct net_device *dev,
>   					 struct virtnet_info *vi,
>   					 struct receive_queue *rq,
> @@ -1181,7 +1254,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>   	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
>   	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
> -	unsigned int frame_sz, xdp_room;
> +	unsigned int frame_sz;
>   	int err;
>   
>   	head_skb = NULL;
> @@ -1211,65 +1284,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		u32 act;
>   		int i;
>   
> -		/* Transient failure which in theory could occur if
> -		 * in-flight packets from before XDP was enabled reach
> -		 * the receive path after XDP is loaded.
> -		 */
> -		if (unlikely(hdr->hdr.gso_type))
> +		data = mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_buf, &page,
> +					     offset, &len, hdr);
> +		if (!data)
>   			goto err_xdp;
>   
> -		/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> -		 * with headroom may add hole in truesize, which
> -		 * make their length exceed PAGE_SIZE. So we disabled the
> -		 * hole mechanism for xdp. See add_recvbuf_mergeable().
> -		 */
> -		frame_sz = truesize;
> -
> -		/* This happens when headroom is not enough because
> -		 * of the buffer was prefilled before XDP is set.
> -		 * This should only happen for the first several packets.
> -		 * In fact, vq reset can be used here to help us clean up
> -		 * the prefilled buffers, but many existing devices do not
> -		 * support it, and we don't want to bother users who are
> -		 * using xdp normally.
> -		 */
> -		if (!xdp_prog->aux->xdp_has_frags &&
> -		    (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> -			/* linearize data for XDP */
> -			xdp_page = xdp_linearize_page(rq, &num_buf,
> -						      page, offset,
> -						      VIRTIO_XDP_HEADROOM,
> -						      &len);
> -			frame_sz = PAGE_SIZE;
> -
> -			if (!xdp_page)
> -				goto err_xdp;
> -			offset = VIRTIO_XDP_HEADROOM;
> -
> -			put_page(page);
> -			page = xdp_page;
> -		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> -			xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> -						  sizeof(struct skb_shared_info));
> -			if (len + xdp_room > PAGE_SIZE)
> -				goto err_xdp;
> -
> -			xdp_page = alloc_page(GFP_ATOMIC);
> -			if (!xdp_page)
> -				goto err_xdp;
> -
> -			memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> -			       page_address(page) + offset, len);
> -			frame_sz = PAGE_SIZE;
> -			offset = VIRTIO_XDP_HEADROOM;
> -
> -			put_page(page);
> -			page = xdp_page;
> -		} else {
> -			xdp_page = page;
> -		}
> -
> -		data = page_address(xdp_page) + offset;
>   		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
>   						 &num_buf, &xdp_frags_truesz, stats);
>   		if (unlikely(err))

