Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1F429EC8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhJLHk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:40:27 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25177 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhJLHkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:40:25 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HT6v021wXz8tWb;
        Tue, 12 Oct 2021 15:37:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 15:38:21 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Tue, 12 Oct
 2021 15:38:15 +0800
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     John Hubbard <jhubbard@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <brouer@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <akpm@linux-foundation.org>, <hawk@kernel.org>,
        <peterz@infradead.org>, <yuzhao@google.com>, <will@kernel.org>,
        <willy@infradead.org>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <vvs@virtuozzo.com>,
        <linux-mm@kvack.org>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
 <89bcc42a-ad95-e729-0748-bf394bf770be@redhat.com>
 <YWQuRpdJOMyJBBrs@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3bba942e-eefd-7ac2-7a8c-b6c349641dd4@huawei.com>
Date:   Tue, 12 Oct 2021 15:38:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YWQuRpdJOMyJBBrs@apalos.home>
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

On 2021/10/11 20:29, Ilias Apalodimas wrote:
> On Mon, Oct 11, 2021 at 02:25:08PM +0200, Jesper Dangaard Brouer wrote:
>>
>>
>> On 09/10/2021 21.49, John Hubbard wrote:
>>> So in case it's not clear, I'd like to request that you drop this one
>>> patch from your series.
>>
>> In my opinion as page_pool maintainer, you should also drop patch 4/4 from
>> this series.
>>
>> I like the first two patches, and they should be resend and can be applied
>> without too much further discussion.
> 
> +1

Ok, it seems there is a lot of contention about how to avoid calling
compound_head() now.

Will send out the uncontroversial one first.

> That's what I hinted on the previous version. The patches right now go way
> beyond the spec of page pool.  We are starting to change core networking
> functions and imho we need a lot more people involved in this discussion,
> than the ones participating already.
> 
> As a general note and the reason I am so hesitant,  is that we are starting
> to violate layers here (at least in my opinion).  When the recycling was
> added,  my main concern was to keep the network stack unaware (apart from
> the skb bit).  Now suddenly we need to teach frag_ref/unref internal page

Maybe the skb recycle bit is a clever way to avoid dealing with the network
stack directly.

But that bit might also introduce or hide some problem, like the data race
as pointed out by Alexander, and the odd using of page pool in mlx5 driver.

> pool counters and that doesn't feel right.  We first need to prove the race
> can actually happen, before starting to change things.

As the network stack is adding a lot of performance improvement, such as
sockmap for BPF, which may cause problem for them, will dig more to prove
that.

> 
> Regards
> /Ilias
>>
>> --Jesper
>>
> .
> 
