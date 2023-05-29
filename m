Return-Path: <netdev+bounces-5979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C744A7141B2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 03:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A463280DAE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 01:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09E0629;
	Mon, 29 May 2023 01:33:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D837C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:33:51 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCDAB1;
	Sun, 28 May 2023 18:33:49 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QTyf12TqkzLq75;
	Mon, 29 May 2023 09:30:49 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 29 May
 2023 09:33:47 +0800
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation
 support
To: Liang Chen <liangchen.linux@gmail.com>, <jasowang@redhat.com>,
	<mst@redhat.com>
CC: <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <xuanzhuo@linux.alibaba.com>,
	<kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
	<pabeni@redhat.com>, <alexander.duyck@gmail.com>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-3-liangchen.linux@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <992eb402-43f9-0289-f95c-b41cb17f2e59@huawei.com>
Date: Mon, 29 May 2023 09:33:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230526054621.18371-3-liangchen.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/26 13:46, Liang Chen wrote:

...

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 99c0ca0c1781..ac40b8c66c59 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -32,7 +32,9 @@ module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
>  
>  static bool page_pool_enabled;
> +static bool page_pool_frag;
>  module_param(page_pool_enabled, bool, 0400);
> +module_param(page_pool_frag, bool, 0400);

The below patchset unifies the frag and non-frag page for
page_pool_alloc_frag() API, perhaps it would simplify the
driver's support of page pool.

https://patchwork.kernel.org/project/netdevbpf/cover/20230526092616.40355-1-linyunsheng@huawei.com/

>  

...

> @@ -1769,13 +1788,29 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>  	 */
>  	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
>  	if (rq->page_pool) {
> -		struct page *page;
> +		if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG) {
> +			if (unlikely(!page_pool_dev_alloc_frag(rq->page_pool,
> +							       &pp_frag_offset, len + room)))
> +				return -ENOMEM;
> +			buf = (char *)page_address(rq->page_pool->frag_page) +
> +				pp_frag_offset;
> +			buf += headroom; /* advance address leaving hole at front of pkt */
> +			hole = (PAGE_SIZE << rq->page_pool->p.order)
> +				- rq->page_pool->frag_offset;
> +			if (hole < len + room) {
> +				if (!headroom)
> +					len += hole;
> +				rq->page_pool->frag_offset += hole;

Is there any reason why the driver need to be aware of page_pool->frag_offset?
Isn't the page_pool_dev_alloc_frag() will drain the last page for you when
page_pool_dev_alloc_frag() is called with size being 'len + room' later?
One case I can think of needing this is to have an accurate truesize report
for skb, but I am not sure it matters that much as 'struct page_frag_cache'
and 'page_frag' implementation both have a similar problem.

> +			}
> +		} else {
> +			struct page *page;
>  
> -		page = page_pool_dev_alloc_pages(rq->page_pool);
> -		if (unlikely(!page))
> -			return -ENOMEM;
> -		buf = (char *)page_address(page);
> -		buf += headroom; /* advance address leaving hole at front of pkt */
> +			page = page_pool_dev_alloc_pages(rq->page_pool);
> +			if (unlikely(!page))
> +				return -ENOMEM;
> +			buf = (char *)page_address(page);
> +			buf += headroom; /* advance address leaving hole at front of pkt */
> +		}
>  	} else {
>  		if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
>  			return -ENOMEM;
> @@ -3800,13 +3835,16 @@ static void virtnet_alloc_page_pool(struct receive_queue *rq)
>  	struct virtio_device *vdev = rq->vq->vdev;
>  
>  	struct page_pool_params pp_params = {
> -		.order = 0,
> +		.order = page_pool_frag ? SKB_FRAG_PAGE_ORDER : 0,
>  		.pool_size = rq->vq->num_max,

If it using order SKB_FRAG_PAGE_ORDER page, perhaps pool_size does
not have to be rq->vq->num_max? Even for order 0 page, perhaps the
pool_size does not need to be as big as rq->vq->num_max?

>  		.nid = dev_to_node(vdev->dev.parent),
>  		.dev = vdev->dev.parent,
>  		.offset = 0,
>  	};
>  
> +	if (page_pool_frag)
> +		pp_params.flags |= PP_FLAG_PAGE_FRAG;
> +
>  	rq->page_pool = page_pool_create(&pp_params);
>  	if (IS_ERR(rq->page_pool)) {
>  		dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> 

