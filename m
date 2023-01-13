Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB24966897E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjAMCTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjAMCTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:19:22 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4529E574C7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:19:20 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NtQ6f43y4zRrFK;
        Fri, 13 Jan 2023 10:17:30 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 13 Jan
 2023 10:19:14 +0800
Subject: Re: [PATCH v3 00/26] Split netmem from struct page
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
CC:     <brouer@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>
References: <20230111042214.907030-1-willy@infradead.org>
 <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
 <Y763vcTFUZvWNgYv@casper.infradead.org>
 <9cdc89f3-8c00-3673-5fdb-4f5bebd95d7a@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9857b63e-5f7d-e45a-d837-bae8737c3c55@huawei.com>
Date:   Fri, 13 Jan 2023 10:19:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <9cdc89f3-8c00-3673-5fdb-4f5bebd95d7a@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

On 2023/1/12 18:15, Jesper Dangaard Brouer wrote:> On 11/01/2023 14.21, Matthew Wilcox wrote:
>> On Wed, Jan 11, 2023 at 04:25:46PM +0800, Yunsheng Lin wrote:
>>> On 2023/1/11 12:21, Matthew Wilcox (Oracle) wrote:
>>>> The MM subsystem is trying to reduce struct page to a single pointer.
>>>> The first step towards that is splitting struct page by its individual
>>>> users, as has already been done with folio and slab.  This patchset does
>>>> that for netmem which is used for page pools.
>>> As page pool is only used for rx side in the net stack depending on the
>>> driver, a lot more memory for the net stack is from page_frag_alloc_align(),
>>> kmem cache, etc.
>>> naming it netmem seems a little overkill, perhaps a more specific name for
>>> the page pool? such as pp_cache.
>>>
>>> @Jesper & Ilias
>>> Any better idea?
> 
> I like the 'netmem' name.

Fair enough.
I just pointed out why netmem might not be appropriate when we are not
figuring out how netmem will work through the whole networking stack yet.
It is eventually your and david/jakub's call to decide the naming anyway.

> 
>>> And it seem some API may need changing too, as we are not pooling 'pages'
>>> now.
> 
> IMHO it would be overkill to rename the page_pool to e.g. netmem_pool.
> as it would generate too much churn and will be hard to follow in git
> as the code filename page_pool.c would also have to be renamed.
> It guess we keep page_pool for historical reasons ;-)

I think this is a matter of conflict between backward and forward maintainability.
IMHO we should prefer forward maintainability over backward maintainability.

And greg offers a possible way to fix the backport problem:
https://www.spinics.net/lists/kernel/msg4648826.html

For git history, I suppose that is a pain we have to pay for the future
maintainability.

> 
>> I raised the question of naming in v1, six weeks ago, and nobody had
>> any better names.  Seems a little unfair to ignore the question at first
>> and then bring it up now.  I'd hate to miss the merge window because of
>> a late-breaking major request like this.
>>
>> https://lore.kernel.org/netdev/20221130220803.3657490-1-willy@infradead.org/
>>
>> I'd like to understand what we think we'll do in networking when we trim
>> struct page down to a single pointer,  All these usages that aren't from
>> page_pool -- what information does networking need to track per-allocation?
>> Would it make sense for the netmem to describe all memory used by the
>> networking stack, and have allocators other than page_pool also return
>> netmem, 
> 
> This is also how I see the future, that other netstack "allocators" can
> return and work-with 'netmem' objects.   IMHO we are already cramming

I am not sure how "other netstack 'allocators' can return and work-with
'netmem' objects" works, I suppose putting different union for different
allocators in struct netmem like struct page does? Isn't that bringing
the similar problem Matthew is trying to fix in this patchset?


> too many use-cases into page_pool (like the frag support Yunsheng
> added).  IMHO there are room for other netstack "allocators" that can

I do not understand why frag support is viewed as "cramming use-cases to
page pool".
In my defence, the frag support for rx is fix in the page pool, it just
extend the page pool to return smaller buffer than before. If I create other
allocator for that, I might invent a lot of wheel page pool already invented.

> utilize netmem.  The page_pool is optimized for RX-NAPI workloads, using
> it for other purposes is a mistake IMHO.  People should create other
> netstack "allocators" that solves their specific use-cases.  E.g. The TX
> path likely needs another "allocator" optimized for this TX use-case.
> 
