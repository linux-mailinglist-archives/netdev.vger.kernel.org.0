Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9653D410310
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhIRCn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:43:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9892 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhIRCn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:43:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HBFNF0BNjz8yVZ;
        Sat, 18 Sep 2021 10:37:33 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 10:42:01 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 10:42:01 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 3/3] skbuff: keep track of pp
 page when __skb_frag_ref() is called
To:     Eric Dumazet <edumazet@google.com>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "Willem de Bruijn" <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "Paolo Abeni" <pabeni@redhat.com>, Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, <memxor@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <CANn89iLWo_03b=9WYi1401gFCLXnNrjeFJJaZXJkh0E2Bw-yYQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0c59b17a-4bc7-9082-1362-77256bec9abe@huawei.com>
Date:   Sat, 18 Sep 2021 10:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLWo_03b=9WYi1401gFCLXnNrjeFJJaZXJkh0E2Bw-yYQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/18 1:15, Eric Dumazet wrote:
> On Wed, Sep 15, 2021 at 7:05 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> 
>> As memtioned before, Tx recycling is based on page_pool instance per socket.
>> it shares the page_pool instance with rx.
>>
>> Anyway, based on feedback from edumazet and dsahern, I am still trying to
>> see if the page pool is meaningful for tx.
>>
> 
> It is not for generic linux TCP stack, but perhaps for benchmarks.

I am not sure I understand what does above means, did you mean
tx recycling only benefit the benchmark tool, such as iperf/netperf,
but not the real usecase?

> 
> Unless you dedicate one TX/RX pair per TCP socket ?

TX/RX pair for netdev queue or TX/RX pair for recycling pool?

As the TX/RX pair for netdev queue, I am not dedicating one TX/RX
pair netdev queue per TCP socket.

As the TX/RX pair for recycling pool, my initial thinking is each
NAPI/socket context have a 'struct pp_alloc_cache', which provides
last-in-first-out and lockless mini pool specific to each NAPI/socket
context, and a central locked 'struct ptr_ring' pool based on queue
for all the NAPI/socket mini pools, when a NAPI/socket context's
mini pool is empty or full, it can refill some page from the central
pool or flush some page to the central pool.

I am not sure if the locked central pool is needed or not, or the
'struct ptr_ring' of page pool is right one to be the locked central
pool yet.

> 
> Most high performance TCP flows are using zerocopy, I am really not
> sure why we would
> need to 'optimize' the path that is wasting cpu cycles doing
> user->kernel copies anyway,
> at the cost of insane complexity.

As my understanding, zerocopy is mostly about big packet and non-IOMMU
case.

As complexity, I am not convinced yet that it is that complex, as it is
mostly using the existing infrastructure to support tx recycling.

The point is that most of skb is freed in the context of NAPI or socket,
it seems we may utilize that to do batch allocating/freeing of skb/page_frag,
or reusing of skb/page_frag/dma mapping to avoid (IO/CPU)TLB miss, cache miss,
overhead of spinlock and dma mapping.


> .
> 
