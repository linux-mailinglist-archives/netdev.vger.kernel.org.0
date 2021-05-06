Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC33753E6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhEFMfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:35:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3856 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFMfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:35:50 -0400
Received: from dggeml752-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FbXxx4R10z5xYn;
        Thu,  6 May 2021 20:31:33 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml752-chm.china.huawei.com (10.1.199.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 6 May 2021 20:34:49 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 6 May 2021
 20:34:49 +0800
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
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
Date:   Thu, 6 May 2021 20:34:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YIwvI5/ygBvZG5sy@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/1 0:24, Ilias Apalodimas wrote:
> [...]
>>>>
>>>> 1. skb frag page recycling do not need "struct xdp_rxq_info" or
>>>>    "struct xdp_mem_info" to bond the relation between "struct page" and
>>>>    "struct page_pool", which seems uncessary at this point if bonding
>>>>    a "struct page_pool" pointer directly in "struct page" does not cause
>>>>    space increasing.
>>>
>>> We can't do that. The reason we need those structs is that we rely on the
>>> existing XDP code, which already recycles it's buffers, to enable
>>> recycling.  Since we allocate a page per packet when using page_pool for a
>>> driver , the same ideas apply to an SKB and XDP frame. We just recycle the
>>
>> I am not really familar with XDP here, but a packet from hw is either a
>> "struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
>> a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
>> the same time, right?
>>
> 
> Yes, but the payload is irrelevant in both cases and that's what we use
> page_pool for.  You can't use this patchset unless your driver usues
> build_skb().  So in both cases you just allocate memory for the payload and

I am not sure I understood why build_skb() matters here. If the head data of
a skb is a page frag and is from page pool, then it's page->signature should be
PP_SIGNATURE, otherwise it's page->signature is zero, so a recyclable skb does
not require it's head data being from a page pool, right?

> decide what the wrap the buffer with (XDP or SKB) later.

[...]

>>
>> I am not sure I understand what you meant by "free the skb", does it mean
>> that kfree_skb() is called to free the skb.
> 
> Yes
> 
>>
>> As my understanding, if the skb completely own the page(which means page_count()
>> == 1) when kfree_skb() is called, __page_pool_put_page() is called, otherwise
>> page_ref_dec() is called, which is exactly what page_pool_atomic_sub_if_positive()
>> try to handle it atomically.
>>
> 
> Not really, the opposite is happening here. If the pp_recycle bit is set we
> will always call page_pool_return_skb_page().  If the page signature matches
> the 'magic' set by page pool we will always call xdp_return_skb_frame() will
> end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
> to recycle the page.  If it's not we'll release it from page_pool (releasing
> some internal references we keep) unmap the buffer and decrement the refcnt.

Yes, I understood the above is what the page pool do now.

But the question is who is still holding an extral reference to the page when
kfree_skb()? Perhaps a cloned and pskb_expand_head()'ed skb is holding an extral
reference to the same page? So why not just do a page_ref_dec() if the orginal skb
is freed first, and call __page_pool_put_page() when the cloned skb is freed later?
So that we can always reuse the recyclable page from a recyclable skb. This may
make the page_pool_destroy() process delays longer than before, I am supposed the
page_pool_destroy() delaying for cloned skb case does not really matters here.

If the above works, I think the samiliar handling can be added to RX zerocopy if
the RX zerocopy also hold extral references to the recyclable page from a recyclable
skb too?

> 
> [1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/
> 
> Cheers
> /Ilias
> 
> .
> 

