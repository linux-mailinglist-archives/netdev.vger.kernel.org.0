Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4F74286EA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhJKGjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:39:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25117 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhJKGj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:39:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HSTZb0c8fz1DHJ1;
        Mon, 11 Oct 2021 14:35:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 14:37:25 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Mon, 11 Oct
 2021 14:37:25 +0800
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
To:     Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <akpm@linux-foundation.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <peterz@infradead.org>,
        <yuzhao@google.com>, <will@kernel.org>, <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <vvs@virtuozzo.com>, <linux-mm@kvack.org>,
        <edumazet@google.com>, <alexander.duyck@gmail.com>,
        <dsahern@gmail.com>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
 <YWH4YbkC+XtpXTux@casper.infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6a072675-89e9-5635-5a9f-08aaf2e5364f@huawei.com>
Date:   Mon, 11 Oct 2021 14:37:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YWH4YbkC+XtpXTux@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/10 4:15, Matthew Wilcox wrote:
> On Sat, Oct 09, 2021 at 12:49:29PM -0700, John Hubbard wrote:
>> On 10/9/21 02:37, Yunsheng Lin wrote:
>>> Introduce __get_page() and __put_page() to operate on the
>>> base page or head of a compound page for the cases when a
>>> page is known to be a base page or head of a compound page.
>>
>> Hi,
>>
>> I wonder if you are aware of a much larger, 137-patch seriesto do that:
>> folio/pageset [1]?
>>
>> The naming you are proposing here does not really improve clarity. There
>> is nothing about __get_page() that makes it clear that it's meant only
>> for head/base pages, while get_page() tail pages as well. And the
>> well-known and widely used get_page() and put_page() get their meaning
>> shifted.
>>
>> This area is hard to get right, and that's why there have been 15
>> versions, and a lot of contention associated with [1]. If you have an
>> alternate approach, I think it would be better in its own separate
>> series, with a cover letter that, at a minimum, explains how it compares
>> to folios/pagesets.

As I was not familiar enough with mm, so I tried the semantic of
__page_frag_cache_drain(), which expects a base page or the head
page of a compound page too.

I suppose we may need to put a BUG_ON() to catch the case of
user passing a tail page accidentally, which is a run time error
and has run time overhead?
And adding a new type like folio will allow the compiler to
catch the error without any overhead?

> 
> I wasn't initially sure whether network pagepools should be part of
> struct folio or should be their own separate type.  At this point, I

Actually only a few driver are using page pool now, and others are mostly
using page allocator directly, see page_frag_alloc_align() and
skb_page_frag_refill(), only changing the page pool does not seems helpful
here, maybe the whole network stack should be using a new type like folio,
as the netstask does not need to deal with tail page directly? And it seems
virt_to_page() is one of the things need handling when netstack is changed
to use a new type like folio?

> 
