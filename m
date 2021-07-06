Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59F63BC6DA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhGFGsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:48:51 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10274 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhGFGst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:48:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GJtGx62nCz1CFnD;
        Tue,  6 Jul 2021 14:40:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 14:46:09 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 14:46:08 +0800
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <mw@semihalf.com>,
        <linux@armlinux.org.uk>, <hawk@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <6c2d76e2-30ce-5c0f-9d71-f6b71f9ad34f@redhat.com>
 <ec994486-b385-0597-39f7-128092cba0ce@huawei.com>
 <YOPiHzVkKhdHmxLB@enceladus>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <33aee58e-b1d5-ce7b-1576-556d0da28560@huawei.com>
Date:   Tue, 6 Jul 2021 14:46:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YOPiHzVkKhdHmxLB@enceladus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/6 12:54, Ilias Apalodimas wrote:
> Hi Yunsheng,
> 
> Thanks for having a look!

Hi,

Thanks for reviewing.

> 
> On Fri, Jul 02, 2021 at 06:15:13PM +0800, Yunsheng Lin wrote:
>> On 2021/7/2 17:42, Jesper Dangaard Brouer wrote:
>>>
>>> On 30/06/2021 11.17, Yunsheng Lin wrote:
>>>> Currently page pool only support page recycling only when
>>>> refcnt of page is one, which means it can not support the
>>>> split page recycling implemented in the most ethernet driver.
>>>
>>> Cc. Alex Duyck as I consider him an expert in this area.
>>
>> Thanks.
>>
>>>
>>>
>>>> So add elevated refcnt support in page pool, and support
>>>> allocating page frag to enable multi-frames-per-page based
>>>> on the elevated refcnt support.
>>>>
>>>> As the elevated refcnt is per page, and there is no space
>>>> for that in "struct page" now, so add a dynamically allocated
>>>> "struct page_pool_info" to record page pool ptr and refcnt
>>>> corrsponding to a page for now. Later, we can recycle the
>>>> "struct page_pool_info" too, or use part of page memory to
>>>> record pp_info.
>>>
>>> I'm not happy with allocating a memory (slab) object "struct page_pool_info" per page.
>>>
>>> This also gives us an extra level of indirection.
>>
>> I'm not happy with that either, if there is better way to
>> avoid that, I will be happy to change it:)
> 
> I think what we have to answer here is, do we want and does it make sense
> for page_pool to do the housekeeping of the buffer splitting or are we
> better of having each driver do that.  IIRC your previous patch on top of
> the original recycling patchset was just 'atomic' refcnts on top of page pool.

You are right that driver was doing the the buffer splitting in previous
patch.

The reason why I abandoned that is:
1. Currently the meta-data of page in the driver is per desc, which means
   it might not be able to use first half of a page for a desc, and the
   second half of the same page for another desc, this ping-pong way of
   reusing the whole page for only one desc in the driver seems unnecessary
   and waste a lot of memory when there is already reusing in the page pool.

2. Easy use of API for the driver too, which means the driver uses
   page_pool_dev_alloc_frag() and page_pool_put_full_page() for elevated
   refcnt case, corresponding to page_pool_dev_alloc_pages() and
   page_pool_put_full_page() for non-elevated refcnt case, the driver does
   not need to worry about the meta-data of a page.

> 
> I think I'd prefer each driver having it's own meta-data of how he splits
> the page, mostly due to hardware diversity, but tbh I don't have any
> strong preference atm.

Usually how the driver split the page is fixed for a given rx configuration(
like MTU), so the driver is able to pass that info to page pool.


> 
>>
>>>
>>>
>>> You are also adding a page "frag" API inside page pool, which I'm not 100% convinced belongs inside page_pool APIs.
>>>
>>> Please notice the APIs that Alex Duyck added in mm/page_alloc.c:
>>
>> Actually, that is where the idea of using "page frag" come from.
>>
>> Aside from the performance improvement, there is memory usage
>> decrease for 64K page size kernel, which means a 64K page can
>> be used by 32 description with 2k buffer size, and that is a
>> lot of memory saving for 64 page size kernel comparing to the
>> current split page reusing implemented in the driver.
>>
> 
> Whether the driver or page_pool itself keeps the meta-data, the outcome
> here won't change.  We'll still be able to use page frags.

As above, it is the ping-pong way of reusing when the driver keeps the
meta-data, and it is page-frag way of reusing when the page pool keeps
the meta-data.

I am not sure if the page-frag way of reusing is possible when we still
keep the meta-data in the driver, which seems very complex at the initial
thinking.

> 
> 
> Cheers
> /Ilias
>>
>>>
>>>  __page_frag_cache_refill() + __page_frag_cache_drain() + page_frag_alloc_align()
>>>
>>>
>>
>> [...]
> .
> 
