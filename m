Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC7416CDD
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbhIXHf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:35:29 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16291 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbhIXHf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:35:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HG3fV6Yr0z8tQ3;
        Fri, 24 Sep 2021 15:33:06 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 15:33:50 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 24 Sep
 2021 15:33:49 +0800
Subject: Re: [PATCH net-next 3/7] pool_pool: avoid calling compound_head() for
 skb frag page
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Kevin Hao" <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, <memxor@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-4-linyunsheng@huawei.com>
 <YUw78q4IrfR0D2/J@apalos.home>
 <b2779d81-4cb3-5ccc-8e36-02cd633383f3@huawei.com>
 <CAC_iWj+yv8+=MaxtqLFkQh1Qb75vNZw30xcz2VTD-m37-RVp8A@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <39e62727-6d9f-a0db-39b2-296ebd6972b3@huawei.com>
Date:   Fri, 24 Sep 2021 15:33:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAC_iWj+yv8+=MaxtqLFkQh1Qb75vNZw30xcz2VTD-m37-RVp8A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/23 19:47, Ilias Apalodimas wrote:
> On Thu, 23 Sept 2021 at 14:24, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/9/23 16:33, Ilias Apalodimas wrote:
>>> On Wed, Sep 22, 2021 at 05:41:27PM +0800, Yunsheng Lin wrote:
>>>> As the pp page for a skb frag is always a head page, so make
>>>> sure skb_pp_recycle() passes a head page to avoid calling
>>>> compound_head() for skb frag page case.
>>>
>>> Doesn't that rely on the driver mostly (i.e what's passed in skb_frag_set_page() ?
>>> None of the current netstack code assumes bv_page is the head page of a
>>> compound page.  Since our page_pool allocator can will allocate compound
>>> pages for order > 0,  why should we rely on it ?
>>
>> As the page pool alloc function return 'struct page *' to the caller, which
>> is the head page of a compound pages for order > 0, so I assume the caller
>> will pass that to skb_frag_set_page().
> 
> Yea that's exactly the assumption I was afraid of.
> Sure not passing the head page might seem weird atm and the assumption
> stands, but the point is we shouldn't blow up the entire network stack
> if someone does that eventually.
> 
>>
>> For non-pp page, I assume it is ok whether the page is a head page or tail
>> page, as the pp_magic for both of them are not set with PP_SIGNATURE.
> 
> Yea that's true, although we removed the checking for coalescing
> recyclable and non-recyclable SKBs,   the next patch first checks the
> signature before trying to do anything with the skb.
> 
>>
>> Or should we play safe here, and do the trick as skb_free_head() does in
>> patch 6?
> 
> I don't think the &1 will even be measurable,  so I'd suggest just
> dropping this and play safe?

I am not sure what does '&1' mean above.

The one thing I am not sure about the trick done in patch 6 is that
if __page_frag_cache_drain() is right API to use here, I used it because
it is the only API that is expecting a head page.

> 
> Cheers
> /Ilias
>>
>>>
>>> Thanks
>>> /Ilias
>>>>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> ---
>>>>  include/linux/skbuff.h | 2 +-
>>>>  net/core/page_pool.c   | 2 --
>>>>  2 files changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>> index 6bdb0db3e825..35eebc2310a5 100644
>>>> --- a/include/linux/skbuff.h
>>>> +++ b/include/linux/skbuff.h
>>>> @@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>>>>  {
>>>>      if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>>>>              return false;
>>>> -    return page_pool_return_skb_page(virt_to_page(data));
>>>> +    return page_pool_return_skb_page(virt_to_head_page(data));
>>>>  }
>>>>
>>>>  #endif      /* __KERNEL__ */
>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>> index f7e71dcb6a2e..357fb53343a0 100644
>>>> --- a/net/core/page_pool.c
>>>> +++ b/net/core/page_pool.c
>>>> @@ -742,8 +742,6 @@ bool page_pool_return_skb_page(struct page *page)
>>>>  {
>>>>      struct page_pool *pp;
>>>>
>>>> -    page = compound_head(page);
>>>> -
>>>>      /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>>>>       * in order to preserve any existing bits, such as bit 0 for the
>>>>       * head page of compound page and bit 1 for pfmemalloc page, so
>>>> --
>>>> 2.33.0
>>>>
>>> .
>>>
> .
> 
