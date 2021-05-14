Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323B2380549
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 10:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhENIdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 04:33:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2982 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhENIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 04:33:04 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhMC70TmVzld9h;
        Fri, 14 May 2021 16:29:39 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 16:31:51 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 14 May
 2021 16:31:51 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
Date:   Fri, 14 May 2021 16:31:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YJ4ocslvURa/H+6f@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/14 15:36, Ilias Apalodimas wrote:
> [...]
>>> +		return false;
>>> +
>>> +	pp = (struct page_pool *)page->pp;
>>> +
>>> +	/* Driver set this to memory recycling info. Reset it on recycle.
>>> +	 * This will *not* work for NIC using a split-page memory model.
>>> +	 * The page will be returned to the pool here regardless of the
>>> +	 * 'flipped' fragment being in use or not.
>>> +	 */
>>> +	page->pp = NULL;
>>
>> Why not only clear the page->pp when the page can not be recycled
>> by the page pool? so that we do not need to set and clear it every
>> time the page is recycled。
>>
> 
> If the page cannot be recycled, page->pp will not probably be set to begin
> with. Since we don't embed the feature in page_pool and we require the
> driver to explicitly enable it, as part of the 'skb flow', I'd rather keep 
> it as is.  When we set/clear the page->pp, the page is probably already in 
> cache, so I doubt this will have any measurable impact.

The point is that we already have the skb->pp_recycle to let driver to
explicitly enable recycling, as part of the 'skb flow, if the page pool keep
the page->pp while it owns the page, then the driver may only need to call
one skb_mark_for_recycle() for a skb, instead of call skb_mark_for_recycle()
for each page frag of a skb.

Maybe we can add a parameter in "struct page_pool_params" to let driver
to decide if the page pool ptr is stored in page->pp while the page pool
owns the page?

Another thing accured to me is that if the driver use page from the
page pool to form a skb, and it does not call skb_mark_for_recycle(),
then there will be resource leaking, right? if yes, it seems the
skb_mark_for_recycle() call does not seems to add any value?


> 
>>> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
>>> +
>>>  	C(end);
> 
> [...]


