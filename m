Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC93381518
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 04:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhEOCIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 22:08:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2985 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhEOCIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 22:08:23 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fhpcl200qzldZs;
        Sat, 15 May 2021 10:04:55 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 15 May 2021 10:07:08 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Sat, 15 May
 2021 10:07:07 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
Date:   Sat, 15 May 2021 10:07:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YJ5APhzabmAKIKCE@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/14 17:17, Ilias Apalodimas wrote:
> On Fri, May 14, 2021 at 04:31:50PM +0800, Yunsheng Lin wrote:
>> On 2021/5/14 15:36, Ilias Apalodimas wrote:
>>> [...]
>>>>> +		return false;
>>>>> +
>>>>> +	pp = (struct page_pool *)page->pp;
>>>>> +
>>>>> +	/* Driver set this to memory recycling info. Reset it on recycle.
>>>>> +	 * This will *not* work for NIC using a split-page memory model.
>>>>> +	 * The page will be returned to the pool here regardless of the
>>>>> +	 * 'flipped' fragment being in use or not.
>>>>> +	 */
>>>>> +	page->pp = NULL;
>>>>
>>>> Why not only clear the page->pp when the page can not be recycled
>>>> by the page pool? so that we do not need to set and clear it every
>>>> time the page is recycled。
>>>>
>>>
>>> If the page cannot be recycled, page->pp will not probably be set to begin
>>> with. Since we don't embed the feature in page_pool and we require the
>>> driver to explicitly enable it, as part of the 'skb flow', I'd rather keep 
>>> it as is.  When we set/clear the page->pp, the page is probably already in 
>>> cache, so I doubt this will have any measurable impact.
>>
>> The point is that we already have the skb->pp_recycle to let driver to
>> explicitly enable recycling, as part of the 'skb flow, if the page pool keep
>> the page->pp while it owns the page, then the driver may only need to call
>> one skb_mark_for_recycle() for a skb, instead of call skb_mark_for_recycle()
>> for each page frag of a skb.
>>
> 
> The driver is meant to call skb_mark_for_recycle for the skb and
> page_pool_store_mem_info() for the fragments (in order to store page->pp).
> Nothing bad will happen if you call skb_mark_for_recycle on a frag though,
> but in any case you need to store the page_pool pointer of each frag to
> struct page.

Right. Nothing bad will happen when we keep the page_pool pointer in
page->pp while page pool owns the page too, even if the skb->pp_recycle
is not set, right?

> 
>> Maybe we can add a parameter in "struct page_pool_params" to let driver
>> to decide if the page pool ptr is stored in page->pp while the page pool
>> owns the page?
> 
> Then you'd have to check the page pool config before saving the meta-data,

I am not sure what the "saving the meta-data" meant?

> and you would have to make the skb path aware of that as well (I assume you
> mean replace pp_recycle with this?).

I meant we could set the in page->pp when the page is allocated from
alloc_pages() in __page_pool_alloc_pages_slow() unconditionally or
according to a newly add filed in pool->p, and only clear it in
page_pool_release_page(), between which the page is owned by page pool,
right?

> If not and you just want to add an extra flag on page_pool_params and be able 
> to enable recycling depending on that flag, we just add a patch afterwards.
> I am not sure we need an extra if for each packet though.

In that case, the skb_mark_for_recycle() could only set the skb->pp_recycle,
but not the pool->p.

> 
>>
>> Another thing accured to me is that if the driver use page from the
>> page pool to form a skb, and it does not call skb_mark_for_recycle(),
>> then there will be resource leaking, right? if yes, it seems the
>> skb_mark_for_recycle() call does not seems to add any value?
>>
> 
> Not really, the driver has 2 choices:
> - call page_pool_release_page() once it receives the payload. That will
>   clean up dma mappings (if page pool is responsible for them) and free the
>   buffer

The is only needed before SKB recycling is supported or the driver does not
want the SKB recycling support explicitly, right?

> - call skb_mark_for_recycle(). Which will end up recycling the buffer.

If the driver need to add extra flag to enable recycling based on skb
instead of page pool, then adding skb_mark_for_recycle() makes sense to
me too, otherwise it seems adding a field in pool->p to recycling based
on skb makes more sense?

> 
> If you call none of those, you'd leak a page, but that's a driver bug.
> patches [4/5, 5/5] do that for two marvell drivers.
> I really want to make drivers opt-in in the feature instead of always
> enabling it.
> 
> Thanks
> /Ilias
>>
>>>
>>>>> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
>>>>> +
>>>>>  	C(end);
>>>
>>> [...]
>>
>>
> 
> .
> 

