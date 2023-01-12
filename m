Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDF66668BC
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 03:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbjALCNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 21:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjALCNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 21:13:04 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBB826F
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 18:13:03 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Nsp246WHlz16MhL;
        Thu, 12 Jan 2023 10:11:24 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 12 Jan
 2023 10:13:00 +0800
Subject: Re: [PATCH v3 00/26] Split netmem from struct page
To:     Matthew Wilcox <willy@infradead.org>
CC:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>
References: <20230111042214.907030-1-willy@infradead.org>
 <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
 <Y763vcTFUZvWNgYv@casper.infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <99c58ef0-e06f-9f94-130b-4bc7b6da7710@huawei.com>
Date:   Thu, 12 Jan 2023 10:12:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <Y763vcTFUZvWNgYv@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/11 21:21, Matthew Wilcox wrote:
> On Wed, Jan 11, 2023 at 04:25:46PM +0800, Yunsheng Lin wrote:
>> On 2023/1/11 12:21, Matthew Wilcox (Oracle) wrote:
>>> The MM subsystem is trying to reduce struct page to a single pointer.
>>> The first step towards that is splitting struct page by its individual
>>> users, as has already been done with folio and slab.  This patchset does
>>> that for netmem which is used for page pools.
>>
>> As page pool is only used for rx side in the net stack depending on the
>> driver, a lot more memory for the net stack is from page_frag_alloc_align(),
>> kmem cache, etc.
>> naming it netmem seems a little overkill, perhaps a more specific name for
>> the page pool? such as pp_cache.
>>
>> @Jesper & Ilias
>> Any better idea?
>> And it seem some API may need changing too, as we are not pooling 'pages'
>> now.
> 
> I raised the question of naming in v1, six weeks ago, and nobody had
> any better names.  Seems a little unfair to ignore the question at first
> and then bring it up now.  I'd hate to miss the merge window because of
> a late-breaking major request like this.

I was not keeping very close key on the maillist, so forgive me for missing
it.
As this version contains change to hns3 driver, it caught my eyes and I took
some time to go through it.

> 
> https://lore.kernel.org/netdev/20221130220803.3657490-1-willy@infradead.org/
> 
> I'd like to understand what we think we'll do in networking when we trim
> struct page down to a single pointer,  All these usages that aren't from
> page_pool -- what information does networking need to track per-allocation?

these are memory used by net stack as my limited understanding:
1. page allocated directly from page allocator directly, such as
   dev_alloc_pages().
2. page allocated from page pool API.
3. page allocated form page frag API such as page_frag_alloc_align().
4. buffer allocated from kmem cache API, and may converted to page
   using virt_to_page().
5. page allocated from other subsystem and used by net stack (or allocated
   by net stack and used by other subsystem)using copy avoidance optimization,
   such as sendfile and splite.

For case 1, I do not think the networking need to track per-allocation
information now as its user has taken care of that if information needed.

For case 3, I view it as a pool far more smaller than page pool, we may
merge page frag as part of page pool or find common information needed
by both of them.

For case 4 & 5， they seems to be a similar case. I am not sure how
"triming struct page down to a single pointer" works yet, but at least
it may need a commom field such as page->pp_magic for different subsystem
to use the same page coordinately as page pool does now?

> Would it make sense for the netmem to describe all memory used by the
> networking stack, and have allocators other than page_pool also return
> netmem, or does the normal usage of memory in the net stack not need to
> track that information?

The above question seems hard to answer now, if "reduce struct page to a
single pointer" does not affect case 4 & 5 or other case I missed， it
seems fine to limit the change to page pool as the patchset does for now,
it would be better if we can come out with better name than 'netmem'.
