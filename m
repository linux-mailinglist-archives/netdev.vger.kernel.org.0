Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23598382A9D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhEQLLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:11:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3569 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhEQLL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:11:29 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkGYp48QHzmVSc;
        Mon, 17 May 2021 19:07:26 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 19:10:10 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 17 May
 2021 19:10:10 +0800
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
 <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
 <YKIPcF9ACNmFtksz@enceladus>
 <fade4bc7-c1c7-517e-a775-0a5bb2e66be6@huawei.com>
 <YKI5JxG2rw2y6C1P@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <074b0d1d-9531-57f3-8e0e-a447387478d1@huawei.com>
Date:   Mon, 17 May 2021 19:10:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YKI5JxG2rw2y6C1P@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/17 17:36, Ilias Apalodimas wrote:
 >>
>> Even if when skb->pp_recycle is 1, pages allocated from page allocator directly
>> or page pool are both supported, so it seems page->signature need to be reliable
>> to indicate a page is indeed owned by a page pool, which means the skb->pp_recycle
>> is used mainly to short cut the code path for skb->pp_recycle is 0 case, so that
>> the page->signature does not need checking?
> 
> Yes, the idea for the recycling bit, is that you don't have to fetch the page
> in cache do do more processing (since freeing is asynchronous and we
> can't have any guarantees on what the cache will have at that point).  So we
> are trying to affect the existing release path a less as possible. However it's
> that new skb bit that triggers the whole path.
> 
> What you propose could still be doable though.  As you said we can add the
> page pointer to struct page when we allocate a page_pool page and never
> reset it when we recycle the buffer. But I don't think there will be any
> performance impact whatsoever. So I prefer the 'visible' approach, at least for

setting and unsetting the page_pool ptr every time the page is recycled may
cause a cache bouncing problem when rx cleaning and skb releasing is not
happening on the same cpu.

> the first iteration.
> 
> Thanks
> /Ilias
>  
> 
> .
> 

