Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734A23DD2C6
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhHBJSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:18:05 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13223 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 05:18:04 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GdXTm6bHbz1CRWx;
        Mon,  2 Aug 2021 17:17:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 17:17:52 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 2 Aug 2021
 17:17:51 +0800
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Yunsheng Lin <yunshenglin0825@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Russell King - ARM Linux" <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Feng Tang" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "Willem de Bruijn" <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com>
 <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com>
 <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
 <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com>
 <CAKgT0Ud+PRzz7mgX1dru1=i3TDiaGOoyhg7vp6cz+3NzVFZf+A@mail.gmail.com>
 <20210724130709.GA1461@ip-172-31-30-86.us-east-2.compute.internal>
 <CAKgT0UckhFhvmsjNhBM6tX_EUn12NCn--puJkwVUGitk9yZedw@mail.gmail.com>
 <75213c28-d586-3dfe-c2a7-738af9dd9864@huawei.com>
 <CAKgT0UcvPaP8AqjiF9eSXSWgnJqGVCNccW-brYeqmkZucpgb8A@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9ffe38f1-f5dd-218f-423e-5947c9ce6b29@huawei.com>
Date:   Mon, 2 Aug 2021 17:17:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcvPaP8AqjiF9eSXSWgnJqGVCNccW-brYeqmkZucpgb8A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/28 2:38, Alexander Duyck wrote:
> On Tue, Jul 27, 2021 at 12:54 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/7/26 0:49, Alexander Duyck wrote:
>>> On Sat, Jul 24, 2021 at 6:07 AM Yunsheng Lin <yunshenglin0825@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 23, 2021 at 09:08:00AM -0700, Alexander Duyck wrote:
>>>>> On Fri, Jul 23, 2021 at 4:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>>
>>>>>> On 2021/7/22 23:18, Alexander Duyck wrote:
>>>>>>>>>
> 
> <snip>
> 
>>>>>
>>>>> Rather than trying to reuse the devices page pool it might make more
>>>>> sense to see if you couldn't have TCP just use some sort of circular
>>>>> buffer of memory that is directly mapped for the device that it is
>>>>> going to be transmitting to. Essentially what you would be doing is
>>>>> creating a pre-mapped page and would need to communicate that the
>>>>> memory is already mapped for the device you want to send it to so that
>>>>> it could skip that step.
>>>>
>>>> IIUC sk_page_frag_refill() is already doing a similar reusing as the
>>>> rx reusing implemented in most driver except for the not pre-mapping
>>>> part.
>>>>
>>>> And it seems that even if we pre-map the page and communicate that the
>>>> memory is already mapped to the driver, it is likely that we will not
>>>> be able to reuse the page when the circular buffer is not big enough
>>>> or tx completion/tcp ack is not happening quickly enough, which might
>>>> means unmapping/deallocating old circular buffer and allocating/mapping
>>>> new circular buffer.
>>>>
>>>> Using page pool we might be able to alleviate the above problem as it
>>>> does for rx?
>>>
>>> I would say that instead of looking at going straight for the page
>>> pool it might make more sense to look at seeing if we can coalesce the
>>> DMA mapping of the pages first at the socket layer rather than trying
>>> to introduce the overhead for the page pool. In the case of sockets we
>>> already have the destructors that are called when the memory is freed,
>>> so instead of making sockets use page pool it might make more sense to
>>> extend the socket buffer allocation/freeing to incorporate bulk
>>> mapping and unmapping of pages to optimize the socket Tx path in the
>>> 32K page case.
>>
>> I was able to enable tx recycling prototyping based on page pool to
>> run some performance test, the performance improvement is about +20%
>> （30Gbit -> 38Gbit） for single thread iperf tcp flow when IOMMU is in
>> strict mode. And CPU usage descreases about 10% for four threads iperf
>> tcp flow for line speed of 100Gbit when IOMMU is in strict mode.
> 
> That isn't surprising given that for most devices the IOMMU will be
> called per frag which can add a fair bit of overhead.
> 
>> Looking at the prototyping code, I am agreed that it is a bit controversial
>> to use the page pool for tx as the page pool is assuming NAPI polling
>> protection for allocation side.
>>
>> So I will take a deeper look about your suggestion above to see how to
>> implement it.
>>
>> Also, I am assuming the "destructors" means tcp_wfree() for TCP, right?
>> It seems tcp_wfree() is mainly used to do memory accounting and free
>> "struct sock" if necessary.
> 
> Yes, that is what I was thinking. If we had some way to add something
> like an argument or way to push the information about where the skbs
> are being freed back to the socket the socket could then be looking at
> pre-mapping the pages for the device if we assume a 1:1 mapping from
> the socket to the device.
> 
>> I am not so familiar with socket layer to understand how the "destructors"
>> will be helpful here, any detailed idea how to use "destructors" here?
> 
> The basic idea is the destructors are called when the skb is orphaned
> or freed. So it might be a good spot to put in any logic to free pages
> from your special pool. The only thing you would need to sort out is
> making certain to bump reference counts appropriately if the skb is
> cloned and the destructor is copied.

It seems the destructor is not copied when a skb is cloned, see:
https://elixir.bootlin.com/linux/latest/source/net/core/skbuff.c#L1050

For IPv4 TCP, tcp_write_xmit() calls __tcp_transmit_skb() to send the
new cloned skb using ip_queue_xmit(), and the original skb is kept in
sk->tcp_rtx_queue to wait for the ack packet. The destructor is assigned
to the new cloned skb in __tcp_transmit_skb(), and when destructor is
called in the tx completion process, it seems the frag page might be
still used by the retransmiting process, which means it is better not to
unmap or recycle that frag page in skb->destructor?

Also I tried to implement a frag pool to replace the page pool, but it
seems the feature needed for frag pool is already implemented by the
page pool, so implementing a new frag pool does not make sense.

For Rx, we have 1 : 1 relation between struct napi_struct instance and
struct page_pool instance, It seems we have the below options if the
recycling pool makes sense for Tx too:
1. 1 : 1 relation between struct net_device instance and struct page_pool
   instance.
2. 1 : 1 relation between struct napi_struct instance and struct page_pool
   instance.
3. 1 : 1 relation between struct sock instance and struct page_pool instance.

For me, the option 2 seems to make more sense to me if we can reuse the same
page pool for both Tx and Rx.

As the where or when to "bump reference counts appropriately", it seems the
__skb_frag_ref() might be a good spot to increment frag count if the frag is
copied, and the bit 0 for "struct page" ptr in frag->bv_page is reversed as
the lower 12 bits for dma address, so we can use bit 0 in frag->bv_page to
indicate the corresponding page is from a page pool or not? If the page is
from a page pool, then __skb_frag_ref() can do a atomic_inc(pp_frag_count)
instead of get_page(). This also might means that skb->pp_recycle is only used
to indicate if the head data page is from page pool or not when the bit 0
of frag->bv_page can be used to indicate if the corresponding frag page is
from page pool or not.

And doing atomic_inc(pp_frag_count) in __skb_frag_ref() seems to match the
semantics of "recycle after all users of page is done with the page", at least
for most users in the netstack?

> .
> 
