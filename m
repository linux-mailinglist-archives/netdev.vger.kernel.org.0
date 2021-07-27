Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B0A3D709E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 09:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhG0HyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 03:54:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16007 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbhG0HyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 03:54:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GYpr03QGFzZst8;
        Tue, 27 Jul 2021 15:50:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 15:54:07 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 27 Jul
 2021 15:54:07 +0800
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Yunsheng Lin <yunshenglin0825@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, "Salil Mehta" <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Will Deacon" <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Vlastimil Babka" <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Alexander Lobakin" <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com>
 <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com>
 <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
 <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com>
 <CAKgT0Ud+PRzz7mgX1dru1=i3TDiaGOoyhg7vp6cz+3NzVFZf+A@mail.gmail.com>
 <20210724130709.GA1461@ip-172-31-30-86.us-east-2.compute.internal>
 <CAKgT0UckhFhvmsjNhBM6tX_EUn12NCn--puJkwVUGitk9yZedw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <75213c28-d586-3dfe-c2a7-738af9dd9864@huawei.com>
Date:   Tue, 27 Jul 2021 15:54:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UckhFhvmsjNhBM6tX_EUn12NCn--puJkwVUGitk9yZedw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/26 0:49, Alexander Duyck wrote:
> On Sat, Jul 24, 2021 at 6:07 AM Yunsheng Lin <yunshenglin0825@gmail.com> wrote:
>>
>> On Fri, Jul 23, 2021 at 09:08:00AM -0700, Alexander Duyck wrote:
>>> On Fri, Jul 23, 2021 at 4:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> On 2021/7/22 23:18, Alexander Duyck wrote:
>>>>>>>
>>>>>>>> You are right that that may cover up the reference count errors. How about
>>>>>>>> something like below:
>>>>>>>>
>>>>>>>> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>>>>>>>                                                           long nr)
>>>>>>>> {
>>>>>>>> #ifdef CONFIG_DEBUG_PAGE_REF
>>>>>>>>         long ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>>>>>
>>>>>>>>         WARN_ON(ret < 0);
>>>>>>>>
>>>>>>>>         return ret;
>>>>>>>> #else
>>>>>>>>         if (atomic_long_read(&page->pp_frag_count) == nr)
>>>>>>>>                 return 0;
>>>>>>>>
>>>>>>>>         return atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>>>>> #end
>>>>>>>> }
>>>>>>>>
>>>>>>>> Or any better suggestion?
>>>>>>>
>>>>>>> So the one thing I might change would be to make it so that you only
>>>>>>> do the atomic_long_read if nr is a constant via __builtin_constant_p.
>>>>>>> That way you would be performing the comparison in
>>>>>>> __page_pool_put_page and in the cases of freeing or draining the
>>>>>>> page_frags you would be using the atomic_long_sub_return which should
>>>>>>> be paths where you would not expect it to match or that are slowpath
>>>>>>> anyway.
>>>>>>>
>>>>>>> Also I would keep the WARN_ON in both paths just to be on the safe side.
>>>>>>
>>>>>> If I understand it correctly, we should change it as below, right?
>>>>>>
>>>>>> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>>>>>                                                           long nr)
>>>>>> {
>>>>>>         long ret;
>>>>>>
>>>>>>         /* As suggested by Alexander, atomic_long_read() may cover up the
>>>>>>          * reference count errors, so avoid calling atomic_long_read() in
>>>>>>          * the cases of freeing or draining the page_frags, where we would
>>>>>>          * not expect it to match or that are slowpath anyway.
>>>>>>          */
>>>>>>         if (__builtin_constant_p(nr) &&
>>>>>>             atomic_long_read(&page->pp_frag_count) == nr)
>>>>>>                 return 0;
>>>>>>
>>>>>>         ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>>>         WARN_ON(ret < 0);
>>>>>>         return ret;
>>>>>> }
>>>>>
>>>>> Yes, that is what I had in mind.
>>>>>
>>>>> One thought I had for a future optimization is that we could look at
>>>>> reducing the count by 1 so that we could essentially combine the
>>>>> non-frag and frag cases.Then instead of testing for 1 we would test
>>>>> for 0 at thee start of the function and test for < 0 to decide if we
>>>>> want to free it or not instead of testing for 0. With that we can
>>>>> essentially reduce the calls to the WARN_ON since we should only have
>>>>> one case where we actually return a value < 0, and we can then check
>>>>> to see if we overshot -1 which would be the WARN_ON case.
>>>>>
>>>>> With that a value of 0 instead of 1 would indicate page frag is not in
>>>>> use for the page *AND/OR* that the page has reached the state where
>>>>> there are no other frags present so the page can be recycled. In
>>>>> effect it would allow us to mix page frags and no frags within the
>>>>> same pool. The added bonus would be we could get rid of the check for
>>>>> PP_FLAG_PAGE_FRAG flag check in the __page_pool_put_page function and
>>>>> replace it with a check for PAGE_POOL_DMA_USE_PP_FRAG_COUNT since we
>>>>> cannot read frag_count in that case.
>>>>
>>>> Let's leave it for a future optimization.
>>>> I am not sure if there is use case to support both frag page and non-frag
>>>> page for the same page pool. If there is, maybe we can use "page->pp_frag_count
>>>>> 0" to indicate that the page is frag page, and "page->pp_frag_count == 0"
>>>> to indicate that the page is non-frag page, so that we can support frag page and
>>>> non-frag page for the same page pool instead of disabling non-frag page support
>>>> when PP_FLAG_PAGE_FRAG flag is set, which might be conflit with the above
>>>> optimization?
>>>
>>> As far as use case I can see a number of potential uses. For example
>>> in the case of drivers that do something like a header/data split I
>>> could see potentially having the header pages be frags while the data
>>> pages being 4K blocks. Basically the big optimization of the count ==
>>> 1/0/nr case is that you aren't increasing/decreasing the count and it
>>> is immediately being recycled/reused. So in such a case being able to
>>> add frag count some pages, and not to others would likely be quite
>>> useful.
>>
>> I am not sure how the header/data split is implemented in hw, but it
>> seems the driver is not able to tell which desc will be filled with
>> header or data in advance, so it might need to allocate 4K block for
>> all desc?
> 
> It all depends on the hardware config. In theory you could have
> anything from a single use for a page to multiple uses for a page in
> the case of headers and/or packets being small. The overhead for
> adding/removing the frag count could end up being more than what is
> needed if the page is only used once. That is why I was thinking it
> might make sense to allow both to coexist in the same pool.

I am agreed that there may be usecase of using both frag page and non-frag
page of the same page pool. Let's leave it for now.

> 
>>>
>>> Basically by shifting the pool values by 1 you can have both in the
>>> same pool with little issue. However the big change is that instead of
>>> testing for count = nr it would end up being pp_frag_count = nr - 1.
>>> So in the case of the standard page pool pages being freed or the last
>>> frag you would be looking at pp_frag_count = 0. In addition we can
>>> mask the WARN_ON overhead as you would be using -1 as the point to
>>> free so you would only have to perform the WARN_ON check for the last
>>> frag instead of every frag.
>>
>> Yes, it seems doable.
>>
>>>
>>>> Also, I am prototyping the tx recycling based on page pool in order to see
>>>> if there is any value supporting the tx recycling.
>>>
>>> Just to clarify here when you say Tx recycling you are talking about
>>> socket to netdev correct? Just want to be certain since the netdev to
>>> netdev case should already have recycling for page pool pages as long
>>> as it follows a 1<->1 path.
>>
>> Yes, the above Tx recycling meant socket to netdev.
>> Also, the above "netdev to netdev" only meant XDP now, but not the IP
>> forwarding path in the network stack, right?
>>
>>>
>>>> As the busypoll has enable the one-to-one relation between NAPI and sock,
>>>> and there is one-to-one relation between NAPI and page pool, perhaps it make
>>>> senses that we use page pool to recycle the tx page too?
>>>>
>>>> There are possibly below problems when doing that as I am aware of now:
>>>> 1. busypoll is for rx, and tx may not be using the same queue as rx even if
>>>>    there are *technically* the same flow， so I am not sure it is ok to use
>>>>    busypoll infrastructure to get the page pool ptr for a specific sock.
>>>>
>>>> 2. There may be multi socks using the same page pool ptr to allocate page for
>>>>    multi flow, so we can not assume the same NAPI polling protection as rx,
>>>>    which might mean we can only use the recyclable page from pool->ring under the
>>>>    r->consumer_lock protection.
>>>>
>>>> 3. Right now tcp_sendmsg_locked() use sk_page_frag_refill() to refill the page
>>>>    frag for tcp xmit, when implementing a similar sk_page_pool_frag_refill()
>>>>    based on page pool, I found that tcp coalesce in tcp_mtu_probe() and
>>>>    tcp fragment in tso_fragment() might mess with the page_ref_count directly.
>>>>
>>>> As the above the problem I am aware of(I believe there are other problems I am not
>>>> aware of yet), I am not sure if the tcp tx page recycling based on page pool is
>>>> doable or not, I would like to hear about your opinion about tcp tx recycling support
>>>> based on page pool first, in case it is a dead end to support that.
>>>
>>> I'm honestly not sure there is much there to gain. Last I knew TCP was
>>> using order 3 pages for transmitting and as a result the overhead for
>>> the pages should already be greatly reduced. In addition one of the
>>> main reasons for page_pool  is the fact that the device has to DMA map
>>> the page and that can have very high overhead on systems with an
>>> IOMMU.
>>
>> Yes, avoiding the IOMMU overhead is the main gain. and "order 3 pages"
>> seems to be disabled on defaut?
>>
>>>
>>> Rather than trying to reuse the devices page pool it might make more
>>> sense to see if you couldn't have TCP just use some sort of circular
>>> buffer of memory that is directly mapped for the device that it is
>>> going to be transmitting to. Essentially what you would be doing is
>>> creating a pre-mapped page and would need to communicate that the
>>> memory is already mapped for the device you want to send it to so that
>>> it could skip that step.
>>
>> IIUC sk_page_frag_refill() is already doing a similar reusing as the
>> rx reusing implemented in most driver except for the not pre-mapping
>> part.
>>
>> And it seems that even if we pre-map the page and communicate that the
>> memory is already mapped to the driver, it is likely that we will not
>> be able to reuse the page when the circular buffer is not big enough
>> or tx completion/tcp ack is not happening quickly enough, which might
>> means unmapping/deallocating old circular buffer and allocating/mapping
>> new circular buffer.
>>
>> Using page pool we might be able to alleviate the above problem as it
>> does for rx?
> 
> I would say that instead of looking at going straight for the page
> pool it might make more sense to look at seeing if we can coalesce the
> DMA mapping of the pages first at the socket layer rather than trying
> to introduce the overhead for the page pool. In the case of sockets we
> already have the destructors that are called when the memory is freed,
> so instead of making sockets use page pool it might make more sense to
> extend the socket buffer allocation/freeing to incorporate bulk
> mapping and unmapping of pages to optimize the socket Tx path in the
> 32K page case.

I was able to enable tx recycling prototyping based on page pool to
run some performance test, the performance improvement is about +20%
（30Gbit -> 38Gbit） for single thread iperf tcp flow when IOMMU is in
strict mode. And CPU usage descreases about 10% for four threads iperf
tcp flow for line speed of 100Gbit when IOMMU is in strict mode.

Looking at the prototyping code, I am agreed that it is a bit controversial
to use the page pool for tx as the page pool is assuming NAPI polling
protection for allocation side.

So I will take a deeper look about your suggestion above to see how to
implement it.

Also, I am assuming the "destructors" means tcp_wfree() for TCP, right?
It seems tcp_wfree() is mainly used to do memory accounting and free
"struct sock" if necessary.
I am not so familiar with socket layer to understand how the "destructors"
will be helpful here, any detailed idea how to use "destructors" here?

> .
> 
