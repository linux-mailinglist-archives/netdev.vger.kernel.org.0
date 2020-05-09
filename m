Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA181CBC02
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgEIA6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:58:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51460 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726842AbgEIA6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:58:05 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E03741A8C5EDE526A5EA;
        Sat,  9 May 2020 08:58:01 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 08:58:00 +0800
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the pool
 buffers
To:     Andrew Lunn <andrew@lunn.ch>,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
CC:     Kevin Hao <haokexin@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        "Geetha sowjanya" <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200508040728.24202-1-haokexin@gmail.com>
 <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
 <20200508053015.GB3222151@pek-khao-d2.corp.ad.wrs.com>
 <CA+sq2CfmFaQ1=8m6vBOD6d_uoez2yU7KrAP1JUMo_nJbe=9_6g@mail.gmail.com>
 <20200508130115.GO208718@lunn.ch>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f14cb268-efd2-1b62-22cb-d501f1f183a7@huawei.com>
Date:   Sat, 9 May 2020 08:58:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200508130115.GO208718@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/8 21:01, Andrew Lunn wrote:
> On Fri, May 08, 2020 at 01:08:13PM +0530, Sunil Kovvuri wrote:
>> On Fri, May 8, 2020 at 11:00 AM Kevin Hao <haokexin@gmail.com> wrote:
>>>
>>> On Fri, May 08, 2020 at 10:18:27AM +0530, Sunil Kovvuri wrote:
>>>> On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
>>>>>
>>>>> In the current codes, the octeontx2 uses its own method to allocate
>>>>> the pool buffers, but there are some issues in this implementation.
>>>>> 1. We have to run the otx2_get_page() for each allocation cycle and
>>>>>    this is pretty error prone. As I can see there is no invocation
>>>>>    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
>>>>>    the allocated pages have the wrong refcount and may be freed wrongly.
>>>>
>>>> Thanks for pointing, will fix.
>>>>
>>>>> 2. It wastes memory. For example, if we only receive one packet in a
>>>>>    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
>>>>>    to refill the pool buffers and leave the remain area of the allocated
>>>>>    page wasted. On a kernel with 64K page, 62K area is wasted.
>>>>>
>>>>> IMHO it is really unnecessary to implement our own method for the
>>>>> buffers allocate, we can reuse the napi_alloc_frag() to simplify
>>>>> our code.
>>>>>
>>>>> Signed-off-by: Kevin Hao <haokexin@gmail.com>
>>>>
>>>> Have you measured performance with and without your patch ?
>>>
>>> I will do performance compare later. But I don't think there will be measurable
>>> difference.
>>>
>>>> I didn't use napi_alloc_frag() as it's too costly, if in one NAPI
>>>> instance driver
>>>> receives 32 pkts, then 32 calls to napi_alloc_frag() and updates to page ref
>>>> count per fragment etc are costly.
>>>
>>> No, the page ref only be updated at the page allocation and all the space are
>>> used. In general, the invocation of napi_alloc_frag() will not cause the update
>>> of the page ref. So in theory, the count of updating page ref should be reduced
>>> by using of napi_alloc_frag() compare to the current otx2 implementation.
>>>
>>
>> Okay, it seems i misunderstood it.
> 
> Hi Sunil
> 
> In general, you should not work around issues in the core, you should
> improve the core. If your implementation really was more efficient
> than the core code, it would of been better if you proposed fixes to
> the core, not hide away better code in your own driver.

Hi, Andrew

When looking the napi_alloc_frag() api, the mapping/unmapping is done by
caller, if the mapping/unmapping is managed in the core, then the
mapping/unmapping can be avoided when the page is reused, because the
mapping/unmapping operation is costly when IOMMU is on, do you think it
makes sense to do the mapping/ummapping in the page_frag_*()?

> 
>       Andrew
> .
> 
