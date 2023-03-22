Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B46C49B4
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCVLwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCVLwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:52:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB156A6D;
        Wed, 22 Mar 2023 04:52:52 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PhRfg2FP0z9vrP;
        Wed, 22 Mar 2023 19:52:27 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 22 Mar
 2023 19:52:49 +0800
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce
 mergeable_xdp_prepare
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <netdev@vger.kernel.org>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c7749936-c154-da51-ccfb-f16150d19c62@huawei.com>
Date:   Wed, 22 Mar 2023 19:52:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/22 11:03, Xuan Zhuo wrote:
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
>  drivers/net/virtio_net.c | 135 ++++++++++++++++++++++-----------------
>  1 file changed, 77 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d2bf1ce0730..bb426958cdd4 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1162,6 +1162,79 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  	return 0;
>  }
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

The naming convention seems to be xdp_prepare_mergeable().

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

It seems the above 'else if' was not really tested even before this patch,
as there is no "--*num_buf" if xdp_linearize_page() is not called, which
may causes virtnet_build_xdp_buff_mrg() to comsume one more buffer than
expected?

Also, it seems better to split the xdp_linearize_page() to two functions
as pskb_expand_head() and __skb_linearize() do, one to expand the headroom,
the other one to do the linearizing.


> +	} else {
> +		return page_address(*page) + offset;
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
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
>  					 struct virtnet_info *vi,
>  					 struct receive_queue *rq,
> @@ -1181,7 +1254,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>  	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
>  	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
> -	unsigned int frame_sz, xdp_room;
> +	unsigned int frame_sz;
>  	int err;
>  
>  	head_skb = NULL;
> @@ -1211,65 +1284,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		u32 act;
>  		int i;
>  
> -		/* Transient failure which in theory could occur if
> -		 * in-flight packets from before XDP was enabled reach
> -		 * the receive path after XDP is loaded.
> -		 */
> -		if (unlikely(hdr->hdr.gso_type))
> +		data = mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_buf, &page,
> +					     offset, &len, hdr);
> +		if (!data)

unlikely().

>  			goto err_xdp;
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
>  		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
>  						 &num_buf, &xdp_frags_truesz, stats);
>  		if (unlikely(err))
> 
