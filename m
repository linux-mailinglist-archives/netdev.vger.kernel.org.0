Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0595C3826F1
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhEQI1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:27:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2995 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbhEQI1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:27:03 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBvF2f8lzQpPG;
        Mon, 17 May 2021 16:22:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 16:25:45 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 17 May
 2021 16:25:44 +0800
Subject: Re: [PATCH net-next v5 3/5] page_pool: Allow drivers to hint on SKB
 recycling
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Matteo Croce <mcroce@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "Vinay Kumar Yadav" <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
 <YJ4ocslvURa/H+6f@apalos.home>
 <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
 <YJ5APhzabmAKIKCE@apalos.home>
 <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
 <YKIPcF9ACNmFtksz@enceladus>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fade4bc7-c1c7-517e-a775-0a5bb2e66be6@huawei.com>
Date:   Mon, 17 May 2021 16:25:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YKIPcF9ACNmFtksz@enceladus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/17 14:38, Ilias Apalodimas wrote:
> [...]
>>
>>>
>>>> Maybe we can add a parameter in "struct page_pool_params" to let driver
>>>> to decide if the page pool ptr is stored in page->pp while the page pool
>>>> owns the page?
>>>
>>> Then you'd have to check the page pool config before saving the meta-data,
>>
>> I am not sure what the "saving the meta-data" meant?
> 
> I was referring to struct page_pool* and the signature we store in struct
> page.
> 
>>
>>> and you would have to make the skb path aware of that as well (I assume you
>>> mean replace pp_recycle with this?).
>>
>> I meant we could set the in page->pp when the page is allocated from
>> alloc_pages() in __page_pool_alloc_pages_slow() unconditionally or
>> according to a newly add filed in pool->p, and only clear it in
>> page_pool_release_page(), between which the page is owned by page pool,
>> right?
>>
>>> If not and you just want to add an extra flag on page_pool_params and be able 
>>> to enable recycling depending on that flag, we just add a patch afterwards.
>>> I am not sure we need an extra if for each packet though.
>>
>> In that case, the skb_mark_for_recycle() could only set the skb->pp_recycle,
>> but not the pool->p.
>>
>>>
>>>>
>>>> Another thing accured to me is that if the driver use page from the
>>>> page pool to form a skb, and it does not call skb_mark_for_recycle(),
>>>> then there will be resource leaking, right? if yes, it seems the
>>>> skb_mark_for_recycle() call does not seems to add any value?
>>>>
>>>
>>> Not really, the driver has 2 choices:
>>> - call page_pool_release_page() once it receives the payload. That will
>>>   clean up dma mappings (if page pool is responsible for them) and free the
>>>   buffer
>>
>> The is only needed before SKB recycling is supported or the driver does not
>> want the SKB recycling support explicitly, right?
>>
> 
> This is needed in general even before recycling.  It's used to unmap the
> buffer, so once you free the SKB you don't leave any stale DMA mappings.  So
> that's what all the drivers that use page_pool call today.

As my understanding:
1. If the driver is using page allocated from page allocator directly to
   form a skb, let's say the page is owned by skb(or not owned by anyone:)),
   when a skb is freed, the put_page() should be called.

2. If the driver is using page allocated from page pool to form a skb, let's
   say the page is owned by page pool, when a skb is freed, page_pool_put_page()
   should be called.

What page_pool_release_page() mainly do is to make page in case 2 return back
to case 1.

And page_pool_release_page() is replaced with skb_mark_for_recycle() in patch
4/5 to avoid the above "case 2" -> "case 1" changing, so that the page is still
owned by page pool, right?

So the point is that skb_mark_for_recycle() does not really do anything about
the owner of the page, it is still owned by page pool, so it makes more sense
to keep the page pool ptr instead of setting it every time when
skb_mark_for_recycle() is called?

> 
>>> - call skb_mark_for_recycle(). Which will end up recycling the buffer.
>>
>> If the driver need to add extra flag to enable recycling based on skb
>> instead of page pool, then adding skb_mark_for_recycle() makes sense to
>> me too, otherwise it seems adding a field in pool->p to recycling based
>> on skb makes more sense?
>>
> 
> The recycling is essentially an SKB feature though isn't it?  You achieve the
> SKB recycling with the help of page_pool API, not the other way around.  So I
> think this should remain on the SKB and maybe in the future find ways to turn
> in on/off?

As above, does it not make more sense to call page_pool_release_page() if the
driver does not need the SKB recycling?

Even if when skb->pp_recycle is 1, pages allocated from page allocator directly
or page pool are both supported, so it seems page->signature need to be reliable
to indicate a page is indeed owned by a page pool, which means the skb->pp_recycle
is used mainly to short cut the code path for skb->pp_recycle is 0 case, so that
the page->signature does not need checking?

> 
> Thanks
> /Ilias

