Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE933B9EE9
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGBKRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:17:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9336 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhGBKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:17:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GGW7Q1W0hz74gT;
        Fri,  2 Jul 2021 18:10:58 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 18:15:13 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 18:15:13 +0800
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linuxarm@openeuler.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <thomas.petazzoni@bootlin.com>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ec994486-b385-0597-39f7-128092cba0ce@huawei.com>
Date:   Fri, 2 Jul 2021 18:15:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <6c2d76e2-30ce-5c0f-9d71-f6b71f9ad34f@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/2 17:42, Jesper Dangaard Brouer wrote:
> 
> On 30/06/2021 11.17, Yunsheng Lin wrote:
>> Currently page pool only support page recycling only when
>> refcnt of page is one, which means it can not support the
>> split page recycling implemented in the most ethernet driver.
> 
> Cc. Alex Duyck as I consider him an expert in this area.

Thanks.

> 
> 
>> So add elevated refcnt support in page pool, and support
>> allocating page frag to enable multi-frames-per-page based
>> on the elevated refcnt support.
>>
>> As the elevated refcnt is per page, and there is no space
>> for that in "struct page" now, so add a dynamically allocated
>> "struct page_pool_info" to record page pool ptr and refcnt
>> corrsponding to a page for now. Later, we can recycle the
>> "struct page_pool_info" too, or use part of page memory to
>> record pp_info.
> 
> I'm not happy with allocating a memory (slab) object "struct page_pool_info" per page.
> 
> This also gives us an extra level of indirection.

I'm not happy with that either, if there is better way to
avoid that, I will be happy to change it:)

> 
> 
> You are also adding a page "frag" API inside page pool, which I'm not 100% convinced belongs inside page_pool APIs.
> 
> Please notice the APIs that Alex Duyck added in mm/page_alloc.c:

Actually, that is where the idea of using "page frag" come from.

Aside from the performance improvement, there is memory usage
decrease for 64K page size kernel, which means a 64K page can
be used by 32 description with 2k buffer size, and that is a
lot of memory saving for 64 page size kernel comparing to the
current split page reusing implemented in the driver.


> 
>  __page_frag_cache_refill() + __page_frag_cache_drain() + page_frag_alloc_align()
> 
> 

[...]
