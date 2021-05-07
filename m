Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E1375F20
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 05:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhEGDYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 23:24:32 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5593 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhEGDYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 23:24:31 -0400
Received: from dggeml711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FbwhK6HgHzYdjR;
        Fri,  7 May 2021 11:21:05 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml711-chm.china.huawei.com (10.3.17.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 7 May 2021 11:23:29 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 7 May 2021
 11:23:29 +0800
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
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
 <YJPn5t2mdZKC//dp@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
Date:   Fri, 7 May 2021 11:23:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YJPn5t2mdZKC//dp@apalos.home>
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

On 2021/5/6 20:58, Ilias Apalodimas wrote:
>>>>
>>>
>>> Not really, the opposite is happening here. If the pp_recycle bit is set we
>>> will always call page_pool_return_skb_page().  If the page signature matches
>>> the 'magic' set by page pool we will always call xdp_return_skb_frame() will
>>> end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
>>> to recycle the page.  If it's not we'll release it from page_pool (releasing
>>> some internal references we keep) unmap the buffer and decrement the refcnt.
>>
>> Yes, I understood the above is what the page pool do now.
>>
>> But the question is who is still holding an extral reference to the page when
>> kfree_skb()? Perhaps a cloned and pskb_expand_head()'ed skb is holding an extral
>> reference to the same page? So why not just do a page_ref_dec() if the orginal skb
>> is freed first, and call __page_pool_put_page() when the cloned skb is freed later?
>> So that we can always reuse the recyclable page from a recyclable skb. This may
>> make the page_pool_destroy() process delays longer than before, I am supposed the
>> page_pool_destroy() delaying for cloned skb case does not really matters here.
>>
>> If the above works, I think the samiliar handling can be added to RX zerocopy if
>> the RX zerocopy also hold extral references to the recyclable page from a recyclable
>> skb too?
>>
> 
> Right, this sounds doable, but I'll have to go back code it and see if it
> really makes sense.  However I'd still prefer the support to go in as-is
> (including the struct xdp_mem_info in struct page, instead of a page_pool
> pointer).
> 
> There's a couple of reasons for that.  If we keep the struct xdp_mem_info we
> can in the future recycle different kind of buffers using __xdp_return().
> And this is a non intrusive change if we choose to store the page pool address
> directly in the future.  It just affects the internal contract between the
> page_pool code and struct page.  So it won't affect any drivers that already
> use the feature.

This patchset has embeded a signature field in "struct page", and xdp_mem_info
is stored in page_private(), which seems not considering the case for associating
the page pool with "struct page" directly yet? Is the page pool also stored in
page_private() and a different signature is used to indicate that?

I am not saying we have to do it in this patchset, but we have to consider it
while we are adding new signature field to "struct page", right?

> Regarding the page_ref_dec(), which as I said sounds doable, I'd prefer
> playing it safe for now and getting rid of the buffers that somehow ended up
> holding an extra reference.  Once this gets approved we can go back and try to
> save the extra space.  I hope I am not wrong but the changes required to
> support a few extra refcounts should not change the current patches much.
> 
> Thanks for taking the time on this!

Thanks all invovled in the effort improving page pool too:)

> /Ilias
> 
>>>
>>> [1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/
>>>
>>> Cheers
>>> /Ilias
>>>
>>> .
>>>
>>
> 
> .
> 

