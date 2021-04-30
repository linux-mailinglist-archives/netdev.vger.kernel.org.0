Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9357F36F433
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 05:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhD3DCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 23:02:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3348 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3DCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 23:02:41 -0400
Received: from dggeml706-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FWcVl0gH5z19K60;
        Fri, 30 Apr 2021 10:57:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml706-chm.china.huawei.com (10.3.17.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Apr 2021 11:01:49 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 30 Apr
 2021 11:01:49 +0800
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
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
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
Date:   Fri, 30 Apr 2021 11:01:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YIsAIzecktXXBlxn@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/30 2:51, Ilias Apalodimas wrote:
> Hi Yunsheng,
> 
> On Thu, Apr 29, 2021 at 04:27:21PM +0800, Yunsheng Lin wrote:
>> On 2021/4/10 6:37, Matteo Croce wrote:
>>> From: Matteo Croce <mcroce@microsoft.com>

[...]

>>
>> 1. skb frag page recycling do not need "struct xdp_rxq_info" or
>>    "struct xdp_mem_info" to bond the relation between "struct page" and
>>    "struct page_pool", which seems uncessary at this point if bonding
>>    a "struct page_pool" pointer directly in "struct page" does not cause
>>    space increasing.
> 
> We can't do that. The reason we need those structs is that we rely on the
> existing XDP code, which already recycles it's buffers, to enable
> recycling.  Since we allocate a page per packet when using page_pool for a
> driver , the same ideas apply to an SKB and XDP frame. We just recycle the

I am not really familar with XDP here, but a packet from hw is either a
"struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
the same time, right?

What does not really make sense to me is that the page has to be from page
pool when a skb's frag page can be recycled, right? If it is ture, the switch
case in __xdp_return() does not really make sense for skb recycling, why go
all the trouble of checking the mem->type and mem->id to find the page_pool
pointer when recyclable page for skb can only be from page pool?

> payload and we don't really care what's in that.  We could rename the functions
> to something more generic in the future though ?
> 
>>
>> 2. it would be good to do the page reference count updating batching
>>    in page pool instead of specific driver.
>>
>>
>> page_pool_atomic_sub_if_positive() is added to decide who can call
>> page_pool_put_full_page(), because the driver and stack may hold
>> reference to the same page, only if last one which hold complete
>> reference to a page can call page_pool_put_full_page() to decide if
>> recycling is possible, if not, the page is released, so I am wondering
>> if a similar page_pool_atomic_sub_if_positive() can added to specific
>> user space address unmapping path to allow skb recycling for RX zerocopy
>> too?
>>
> 
> I would prefer a different page pool type if we wanted to support the split
> page model.  The changes as is are quite intrusive, since they change the 
> entire skb return path.  So I would prefer introducing the changes one at a 
> time. 

I understand there may be fundamental semantic change when split page model
is supported by page pool, but the split page support change mainly affect the
skb recycling path and the driver that uses page pool(XDP too) if we are careful
enough, not the entire skb return path as my understanding.

Anyway, one changes at a time is always prefered if supporting split page is
proved to be non-trivel and intrusive.

> 
> The fundamental difference between having the recycling in the driver vs
> having it in a generic API is pretty straightforward.  When a driver holds
> the extra page references he is free to decide what to reuse, when he is about
> to refill his Rx descriptors.  So TCP zerocopy might work even if the
> userspace applications hold the buffers for an X amount of time.
> On this proposal though we *need* to decide what to do with the buffer when we
> are about to free the skb.

I am not sure I understand what you meant by "free the skb", does it mean
that kfree_skb() is called to free the skb.

As my understanding, if the skb completely own the page(which means page_count()
== 1) when kfree_skb() is called, __page_pool_put_page() is called, otherwise
page_ref_dec() is called, which is exactly what page_pool_atomic_sub_if_positive()
try to handle it atomically.

> 
> [...]
> 
> 
> Cheers
> /Ilias
> 
> .
> 

