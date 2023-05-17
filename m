Return-Path: <netdev+bounces-3263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC4B706454
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:41:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B52E31C20E87
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C7F154BD;
	Wed, 17 May 2023 09:41:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D265249;
	Wed, 17 May 2023 09:41:38 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3521540C0;
	Wed, 17 May 2023 02:41:34 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QLp0l24SqzqSX3;
	Wed, 17 May 2023 17:37:11 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 17 May
 2023 17:41:31 +0800
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
To: Lorenzo Bianconi <lorenzo@kernel.org>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>
CC: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, <netdev@vger.kernel.org>,
	<bpf@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
 <ZGIWZHNRvq5DSmeA@lore-desk> <ZGIvbfPd46EIVZf/@boxer>
 <ZGQJKRfuf4+av/MD@lore-desk>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d6348bf0-0da8-c0ae-ce78-7f4620837f66@huawei.com>
Date: Wed, 17 May 2023 17:41:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZGQJKRfuf4+av/MD@lore-desk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/17 6:52, Lorenzo Bianconi wrote:
>> On Mon, May 15, 2023 at 01:24:20PM +0200, Lorenzo Bianconi wrote:
>>>> On 2023/5/12 21:08, Lorenzo Bianconi wrote:
>>>>> In order to reduce page_pool memory footprint, rely on
>>>>> page_pool_dev_alloc_frag routine and reduce buffer size
>>>>> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
>>>>
>>>> Is there any performance improvement beside the memory saving? As it
>>>> should reduce TLB miss, I wonder if the TLB miss reducing can even
>>>> out the cost of the extra frag reference count handling for the
>>>> frag support?
>>>
>>> reducing the requested headroom to 192 (from 256) we have a nice improvement in
>>> the 1500B frame case while it is mostly the same in the case of paged skb
>>> (e.g. MTU 8000B).
>>
>> Can you define 'nice improvement' ? ;)
>> Show us numbers or improvement in %.
> 
> I am testing this RFC patch in the scenario reported below:
> 
> iperf tcp tx --> veth0 --> veth1 (xdp_pass) --> iperf tcp rx
> 
> - 6.4.0-rc1 net-next:
>   MTU 1500B: ~ 7.07 Gbps
>   MTU 8000B: ~ 14.7 Gbps
> 
> - 6.4.0-rc1 net-next + page_pool frag support in veth:
>   MTU 1500B: ~ 8.57 Gbps
>   MTU 8000B: ~ 14.5 Gbps
> 

Thanks for sharing the data.
Maybe using the new frag interface introduced in [1] bring
back the performance for the MTU 8000B case.

1. https://patchwork.kernel.org/project/netdevbpf/cover/20230516124801.2465-1-linyunsheng@huawei.com/


I drafted a patch for veth to use the new frag interface, maybe that
will show how veth can make use of it. Would you give it a try to see
if there is any performance improvment for MTU 8000B case? Thanks.

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -737,8 +737,8 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
            skb_shinfo(skb)->nr_frags ||
            skb_headroom(skb) < XDP_PACKET_HEADROOM) {
                u32 size, len, max_head_size, off;
+               struct page_pool_frag *pp_frag;
                struct sk_buff *nskb;
-               struct page *page;
                int i, head_off;

                /* We need a private copy of the skb and data buffers since
@@ -752,14 +752,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
                if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
                        goto drop;

+               size = min_t(u32, skb->len, max_head_size);
+               size += VETH_XDP_HEADROOM;
+               size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
                /* Allocate skb head */
-               page = page_pool_dev_alloc_pages(rq->page_pool);
-               if (!page)
+               pp_frag = page_pool_dev_alloc_frag(rq->page_pool, size);
+               if (!pp_frag)
                        goto drop;

-               nskb = napi_build_skb(page_address(page), PAGE_SIZE);
+               nskb = napi_build_skb(page_address(pp_frag->page) + pp_frag->offset,
+                                     pp_frag->truesize);
                if (!nskb) {
-                       page_pool_put_full_page(rq->page_pool, page, true);
+                       page_pool_put_full_page(rq->page_pool, pp_frag->page,
+                                               true);
                        goto drop;
                }

@@ -782,16 +788,18 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
                len = skb->len - off;

                for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
-                       page = page_pool_dev_alloc_pages(rq->page_pool);
-                       if (!page) {
+                       size = min_t(u32, len, PAGE_SIZE);
+
+                       pp_frag = page_pool_dev_alloc_frag(rq->page_pool, size);
+                       if (!pp_frag) {
                                consume_skb(nskb);
                                goto drop;
                        }

-                       size = min_t(u32, len, PAGE_SIZE);
-                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
-                       if (skb_copy_bits(skb, off, page_address(page),
-                                         size)) {
+                       skb_add_rx_frag(nskb, i, pp_frag->page, pp_frag->offset,
+                                       size, pp_frag->truesize);
+                       if (skb_copy_bits(skb, off, page_address(pp_frag->page) +
+                                         pp_frag->offset, size)) {
                                consume_skb(nskb);
                                goto drop;
                        }
@@ -1047,6 +1055,8 @@ static int veth_create_page_pool(struct veth_rq *rq)
                return err;
        }

+       page_pool_set_max_frag_size(rq->page_pool, PAGE_SIZE / 2);
+
        return 0;
 }


