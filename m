Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D443E8781
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 03:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhHKBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 21:06:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8005 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhHKBGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 21:06:42 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gks8B6yK6zYmk0;
        Wed, 11 Aug 2021 09:06:02 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 09:06:17 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 09:06:17 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 0/4] add frag page support in
 page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
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
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, Linux-MM <linux-mm@kvack.org>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <20210810070159.367e680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1eb903a5-a954-e405-6088-9b9209703f5e@redhat.com>
 <20210810074306.6cbd1a73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Uc7fRGDjQZf_pPNW2AN5yspkqTc8v9Sj8_zbBP_Tq1-gw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6e34a281-4082-15b7-e355-20b8bc97f427@huawei.com>
Date:   Wed, 11 Aug 2021 09:06:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uc7fRGDjQZf_pPNW2AN5yspkqTc8v9Sj8_zbBP_Tq1-gw@mail.gmail.com>
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

On 2021/8/10 23:09, Alexander Duyck wrote:
> On Tue, Aug 10, 2021 at 7:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 10 Aug 2021 16:23:52 +0200 Jesper Dangaard Brouer wrote:
>>> On 10/08/2021 16.01, Jakub Kicinski wrote:
>>>> On Fri, 6 Aug 2021 10:46:18 +0800 Yunsheng Lin wrote:
>>>>> enable skb's page frag recycling based on page pool in
>>>>> hns3 drvier.
>>>>
>>>> Applied, thanks!
>>>
>>> I had hoped to see more acks / reviewed-by before this got applied.
>>> E.g. from MM-people as this patchset changes struct page and page_pool
>>> (that I'm marked as maintainer of).
>>
>> Sorry, it was on the list for days and there were 7 or so prior
>> versions, I thought it was ripe. If possible, a note that review
>> will come would be useful.
>>
>>> And I would have appreciated an reviewed-by credit to/from Alexander
>>> as he did a lot of work in the RFC patchset for the split-page tricks.

Yeah, the credit goes to Ilias, Matteo, Matthew too, the patchset from them
paves the path for supporting the skb frag page recycling.

>>
>> I asked him off-list, he said something I interpreted as "code is okay,
>> but the review tag is not coming".
> 
> Yeah, I ran out of feedback a revision or two ago and just haven't had
> a chance to go through and add my reviewed by. If you want feel free
> to add my reviewed by for the set.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Yeah, thanks for the time and patient for reviewing this patchset.

By the way, I am still trying to implement the tx recycling mentioned
in the other thread, which seems more controversial than rx recycling
as tx recycling may touch the tcp/ip and socket layer. So it would be
good have your opinion about that idea or implemention too:)

> _______________________________________________
> Linuxarm mailing list -- linuxarm@openeuler.org
> To unsubscribe send an email to linuxarm-leave@openeuler.org
> 
