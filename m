Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F09F3E114D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 11:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhHEJcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 05:32:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7933 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhHEJcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 05:32:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GgNZ56lcJz84FQ;
        Thu,  5 Aug 2021 17:27:57 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 17:31:49 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 5 Aug 2021
 17:31:49 +0800
Subject: Re: [PATCH net] page_pool: mask the page->signature before the
 checking
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Matthew Wilcox <willy@infradead.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <mcroce@microsoft.com>,
        <alexander.duyck@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <chenhao288@hisilicon.com>
References: <1628125617-49538-1-git-send-email-linyunsheng@huawei.com>
 <YQtDynWsDxZ/T41e@casper.infradead.org>
 <19955a79-3a6a-9534-7665-7f868eb7db1f@huawei.com>
 <YQunSivvZZFRETYn@enceladus>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <bfdfd736-68b2-635b-0c59-017574620f8c@huawei.com>
Date:   Thu, 5 Aug 2021 17:31:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YQunSivvZZFRETYn@enceladus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/5 16:54, Ilias Apalodimas wrote:
> On Thu, Aug 05, 2021 at 10:14:39AM +0800, Yunsheng Lin wrote:
>> On 2021/8/5 9:50, Matthew Wilcox wrote:
>>> On Thu, Aug 05, 2021 at 09:06:57AM +0800, Yunsheng Lin wrote:
>>>> As mentioned in commit c07aea3ef4d4 ("mm: add a signature
>>>> in struct page"):
>>>> "The page->signature field is aliased to page->lru.next and
>>>> page->compound_head."
>>>>
>>>> And as the comment in page_is_pfmemalloc():
>>>> "lru.next has bit 1 set if the page is allocated from the
>>>> pfmemalloc reserves. Callers may simply overwrite it if they
>>>> do not need to preserve that information."
>>>>
>>>> The page->signature is or???ed with PP_SIGNATURE when a page is
>>>> allocated in page pool, see __page_pool_alloc_pages_slow(),
>>>> and page->signature is checked directly with PP_SIGNATURE in
>>>> page_pool_return_skb_page(), which might cause resoure leaking
>>>> problem for a page from page pool if bit 1 of lru.next is set for
>>>> a pfmemalloc page.
>>>>
>>>> As bit 0 is page->compound_head, So mask both bit 0 and 1 before
>>>> the checking in page_pool_return_skb_page().
>>>
>>> No, you don't understand.  We *want* the check to fail if we were low
>>> on memory so we return the emergency allocation.
>>
>> If the check failed, but the page pool assume the page is not from page
>> pool and will not do the resource cleaning(like dma unmapping), as the
>> page pool still use the page with pfmemalloc set and dma map the page
>> if pp_flags & PP_FLAG_DMA_MAP is true in __page_pool_alloc_pages_slow().
>>
>> The returning the emergency allocation you mentioned seems to be handled
>> in __page_pool_put_page(), see:
>>
>> https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L411
>>
>> We just use the page with pfmemalloc one time and do the resource cleaning
>> before returning the page back to page allocator. Or did I miss something
>> here?
>>
>>> .
>>>
> 
> I think you are right here.  What happens is that the original
> pp->signature is OR'ed after the allocation in order to preserve any
> existing bits.  When those are present though the if which will trigger the
> recycling will fail and those DMA mapping will be left stale.
> 
> If we mask the bits during the check (as your patch does), we'll end up not
> recycling the page anyway since it has the pfmemalloc bit set. The page
> pool recycle function will end up releasing the page and the DMA mappings right?

Yes.
The problem might be magnified when frag page in page pool is added, because
page pool only hold one ref of the page, and page_pool_return_skb_page() might
dec the page ref twice if the frag page has two users, supposing the above
checking fail with the pfmemalloc page, leaving to the below log:

[   49.584990] BUG: Bad page state in process iperf  pfn:20af242
[   49.584992] page:(____ptrval____) refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20af242

> 
> Regards
> /Ilias
> .
> 
