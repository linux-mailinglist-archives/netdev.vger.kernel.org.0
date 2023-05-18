Return-Path: <netdev+bounces-3479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB64A707752
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 779F9281761
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 01:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7E0381;
	Thu, 18 May 2023 01:16:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525397E;
	Thu, 18 May 2023 01:16:17 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E7E4224;
	Wed, 17 May 2023 18:16:15 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QMBkg44V3zTktP;
	Thu, 18 May 2023 09:11:23 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 18 May
 2023 09:16:12 +0800
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC: Lorenzo Bianconi <lorenzo@kernel.org>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>, <netdev@vger.kernel.org>,
	<bpf@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
 <ZGIWZHNRvq5DSmeA@lore-desk> <ZGIvbfPd46EIVZf/@boxer>
 <ZGQJKRfuf4+av/MD@lore-desk>
 <d6348bf0-0da8-c0ae-ce78-7f4620837f66@huawei.com>
 <ZGTiF+B46FA3TOj6@lore-desk>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4e5fbf6c-135b-3a14-fa9b-1437eeae41ac@huawei.com>
Date: Thu, 18 May 2023 09:16:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZGTiF+B46FA3TOj6@lore-desk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/17 22:17, Lorenzo Bianconi wrote:
>> Maybe using the new frag interface introduced in [1] bring
>> back the performance for the MTU 8000B case.
>>
>> 1. https://patchwork.kernel.org/project/netdevbpf/cover/20230516124801.2465-1-linyunsheng@huawei.com/
>>
>>
>> I drafted a patch for veth to use the new frag interface, maybe that
>> will show how veth can make use of it. Would you give it a try to see
>> if there is any performance improvment for MTU 8000B case? Thanks.
>>
>> --- a/drivers/net/veth.c
>> +++ b/drivers/net/veth.c
>> @@ -737,8 +737,8 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>             skb_shinfo(skb)->nr_frags ||
>>             skb_headroom(skb) < XDP_PACKET_HEADROOM) {
>>                 u32 size, len, max_head_size, off;
>> +               struct page_pool_frag *pp_frag;
>>                 struct sk_buff *nskb;
>> -               struct page *page;
>>                 int i, head_off;
>>
>>                 /* We need a private copy of the skb and data buffers since
>> @@ -752,14 +752,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>                 if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
>>                         goto drop;
>>
>> +               size = min_t(u32, skb->len, max_head_size);
>> +               size += VETH_XDP_HEADROOM;
>> +               size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>> +
>>                 /* Allocate skb head */
>> -               page = page_pool_dev_alloc_pages(rq->page_pool);
>> -               if (!page)
>> +               pp_frag = page_pool_dev_alloc_frag(rq->page_pool, size);
>> +               if (!pp_frag)
>>                         goto drop;
>>
>> -               nskb = napi_build_skb(page_address(page), PAGE_SIZE);
>> +               nskb = napi_build_skb(page_address(pp_frag->page) + pp_frag->offset,
>> +                                     pp_frag->truesize);
>>                 if (!nskb) {
>> -                       page_pool_put_full_page(rq->page_pool, page, true);
>> +                       page_pool_put_full_page(rq->page_pool, pp_frag->page,
>> +                                               true);
>>                         goto drop;
>>                 }
>>
>> @@ -782,16 +788,18 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>                 len = skb->len - off;
>>
>>                 for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
>> -                       page = page_pool_dev_alloc_pages(rq->page_pool);
>> -                       if (!page) {
>> +                       size = min_t(u32, len, PAGE_SIZE);
>> +
>> +                       pp_frag = page_pool_dev_alloc_frag(rq->page_pool, size);
>> +                       if (!pp_frag) {
>>                                 consume_skb(nskb);
>>                                 goto drop;
>>                         }
>>
>> -                       size = min_t(u32, len, PAGE_SIZE);
>> -                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
>> -                       if (skb_copy_bits(skb, off, page_address(page),
>> -                                         size)) {
>> +                       skb_add_rx_frag(nskb, i, pp_frag->page, pp_frag->offset,
>> +                                       size, pp_frag->truesize);
>> +                       if (skb_copy_bits(skb, off, page_address(pp_frag->page) +
>> +                                         pp_frag->offset, size)) {
>>                                 consume_skb(nskb);
>>                                 goto drop;
>>                         }
>> @@ -1047,6 +1055,8 @@ static int veth_create_page_pool(struct veth_rq *rq)
>>                 return err;
>>         }
> 
> IIUC the code here we are using a variable length for linear part (at most one page)
> while we will always use a full page (exept for the last fragment) for the paged

More correctly, it does not care if the data is in linear part or in paged area.
We copy the data to new skb using least possible fragment and most memory saving
depending on head/tail room size and the page size/order, as skb_copy_bits() hides
the date layout differenence for it's caller.

> area, correct? I have not tested it yet but I do not think we will get a significant
> improvement since if we set MTU to 8000B in my tests we get mostly the same throughput
> (14.5 Gbps vs 14.7 Gbps) if we use page_pool fragment or page_pool full page.
> Am I missing something?

I don't expect significant improvement too, but I do expect a 'nice improvement' for
performance and memory saving depending on how you view 'nice improvement':)

> What we are discussing with Jesper is try to allocate a order 3 page from the pool and
> rely page_pool fragment, similar to page_frag_cache is doing. I will look into it if
> there are no strong 'red flags'.

Thanks.
Yes, if we do not really care about memory usage, using order 3 page should give more
performance improvement.
As my understanding, improvement mentioned above is also applied to order 3 page.

> 
> Regards,
> Lorenzo
> 
>>
>> +       page_pool_set_max_frag_size(rq->page_pool, PAGE_SIZE / 2);
>> +
>>         return 0;
>>  }
>>

