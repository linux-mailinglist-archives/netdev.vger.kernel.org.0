Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A03A6EBF4B
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDWMRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:17:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D1610EA;
        Sun, 23 Apr 2023 05:17:50 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Q46h52x4CzKtRC;
        Sun, 23 Apr 2023 20:16:53 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 23 Apr
 2023 20:17:48 +0800
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <lorenzo.bianconi@redhat.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
Date:   Sun, 23 Apr 2023 20:17:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/23 2:54, Lorenzo Bianconi wrote:
>  struct veth_priv {
> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  			goto drop;
>  
>  		/* Allocate skb head */
> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> +		page = page_pool_dev_alloc_pages(rq->page_pool);
>  		if (!page)
>  			goto drop;
>  
>  		nskb = build_skb(page_address(page), PAGE_SIZE);

If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some additional
improvement for the MTU 1500B case, it seem a 4K page is able to hold two skb.
And we can reduce the memory usage too, which is a significant saving if page
size is 64K.


>  		if (!nskb) {
> -			put_page(page);
> +			page_pool_put_full_page(rq->page_pool, page, true);
>  			goto drop;
>  		}
>  
>  		skb_reserve(nskb, VETH_XDP_HEADROOM);
> +		skb_copy_header(nskb, skb);
> +		skb_mark_for_recycle(nskb);
> +
>  		size = min_t(u32, skb->len, max_head_size);
>  		if (skb_copy_bits(skb, 0, nskb->data, size)) {
>  			consume_skb(nskb);
> @@ -745,7 +750,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  		}
>  		skb_put(nskb, size);
>  
> -		skb_copy_header(nskb, skb);
>  		head_off = skb_headroom(nskb) - skb_headroom(skb);
>  		skb_headers_offset_update(nskb, head_off);
>  
> @@ -754,7 +758,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>  		len = skb->len - off;
>  
>  		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> -			page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> +			page = page_pool_dev_alloc_pages(rq->page_pool);
>  			if (!page) {
>  				consume_skb(nskb);
>  				goto drop;
> @@ -1002,11 +1006,37 @@ static int veth_poll(struct napi_struct *napi, int budget)
>  	return done;
>  }
>  
> +static int veth_create_page_pool(struct veth_rq *rq)
> +{
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.pool_size = VETH_RING_SIZE,

It seems better to allocate different poo_size according to
the mtu, so that the best proformance is achiced using the
least memory?

