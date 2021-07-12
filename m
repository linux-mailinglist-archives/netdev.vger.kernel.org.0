Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33713C4125
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 04:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhGLCJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 22:09:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6911 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLCJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 22:09:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GNRqc4rdBz7BQ6;
        Mon, 12 Jul 2021 10:02:52 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 10:06:02 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 10:06:02 +0800
Subject: Re: [PATCH rfc v2 3/5] page_pool: add page recycling support based on
 elevated refcnt
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
 <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Udnb_KgHyWiwxDF+r+DkytgZd4CQJz4QR85JpinhZAJzw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d45619d1-5235-9dd4-77aa-497fa1115c80@huawei.com>
Date:   Mon, 12 Jul 2021 10:06:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udnb_KgHyWiwxDF+r+DkytgZd4CQJz4QR85JpinhZAJzw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/11 1:31, Alexander Duyck wrote:
> On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> <snip>
>> @@ -419,6 +471,20 @@ static __always_inline struct page *
>>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                      unsigned int dma_sync_size, bool allow_direct)
>>  {
>> +       int bias = page_pool_get_pagecnt_bias(page);
>> +
>> +       /* Handle the elevated refcnt case first */
>> +       if (bias) {
>> +               /* It is not the last user yet */
>> +               if (!page_pool_bias_page_recyclable(page, bias))
>> +                       return NULL;
>> +
>> +               if (likely(!page_is_pfmemalloc(page)))
>> +                       goto recyclable;
>> +               else
>> +                       goto unrecyclable;
>> +       }
>> +
> 
> So this part is still broken. Anything that takes a reference to the
> page and holds it while this is called will cause it to break. For
> example with the recent fixes we put in place all it would take is a
> skb_clone followed by pskb_expand_head and this starts leaking memory.

Ok, it seems the fix is confilcting with the expectation this patch is
based, which is "the last user will always call page_pool_put_full_page()
in order to do the recycling or do the resource cleanup(dma unmaping..etc)
and freeing.".

As the user of the new skb after skb_clone() and pskb_expand_head() is
not aware of that their frag page may still be in the page pool after
the fix?

> 
> One of the key bits in order for pagecnt_bias to work is that you have
> to deduct the bias once there are no more parties using it. Otherwise
> you leave the reference count artificially inflated and the page will
> never be freed. It works fine for the single producer single consumer
> case but once you introduce multiple consumers this is going to fall
> apart.

It seems we have diffferent understanding about consumer, I treat the
above user of new skb after skb_clone() and pskb_expand_head() as the
consumer of the page pool too, so that new skb should keep the recycle
bit in order for that to happen.

If the semantic is "the new user of a page should not be handled by page
pool if page pool is not aware of the new user(the new user is added by
calling page allocator API instead of calling the page pool API, like the
skb_clone() and pskb_expand_head() above) ", I suppose I am ok with that
semantic too as long as the above semantic is aligned with the people
involved.

Also, it seems _refcount and dma_addr in "struct page" is in the same cache
line, which means there is already cache line bouncing already between _refcount
and dma_addr updating, so it may makes senses to only use bias to indicate
number of the page pool user for a page, instead of using "bias - page_ref_count",
as the page_ref_count is not reliable if somebody is using the page allocator API
directly.

And the trick part seems to be how to make the bias atomic for allocating and
freeing.

Any better idea?

> .
> 
