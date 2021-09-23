Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F51E415C97
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbhIWLPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:15:02 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16286 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240498AbhIWLPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:15:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HFXZL6JGPz8tJf;
        Thu, 23 Sep 2021 19:12:42 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 23 Sep 2021 19:13:12 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 23 Sep
 2021 19:13:12 +0800
Subject: Re: [PATCH net-next 1/7] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "Willem de Bruijn" <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "Paolo Abeni" <pabeni@redhat.com>, Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, <memxor@gmail.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-2-linyunsheng@huawei.com>
 <0ffa15a1-742d-a05d-3ea6-04ff25be6a29@redhat.com>
 <CAC_iWjJLCQNHxgbQ-mzLC3OC-m2s7qj3YAtw7vPAKGG6WxywpA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <adb2687f-b501-9324-52b2-33ede1169007@huawei.com>
Date:   Thu, 23 Sep 2021 19:13:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAC_iWjJLCQNHxgbQ-mzLC3OC-m2s7qj3YAtw7vPAKGG6WxywpA@mail.gmail.com>
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

On 2021/9/23 18:02, Ilias Apalodimas wrote:
> Hi Jesper,
> 
> On Thu, 23 Sept 2021 at 12:33, Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 22/09/2021 11.41, Yunsheng Lin wrote:
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>> index 1a6978427d6c..a65bd7972e37 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
>>>        * which is the XDP_TX use-case.
>>>        */
>>>       if (pool->p.flags & PP_FLAG_DMA_MAP) {
>>> +             /* DMA-mapping is not supported on 32-bit systems with
>>> +              * 64-bit DMA mapping.
>>> +              */
>>> +             if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>> +                     return -EINVAL;
>>
>> As I said before, can we please use another error than EINVAL.
>> We should give drivers a chance/ability to detect this error, and e.g.
>> fallback to doing DMA mappings inside driver instead.
>>
>> I suggest using EOPNOTSUPP 95 (Operation not supported).

Will change it to EOPNOTSUPP, thanks.

> 
> I am fine with both.  In any case though the aforementioned driver can
> just remove PP_FLAG_DMA_MAP and do it's own mappings.
> 
> Regards
> /Ilias
>>
>> -Jesper
>>
> .
> 
