Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07653F00AF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhHRJik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:38:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8038 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhHRJg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:36:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqN733dvCzYnLv;
        Wed, 18 Aug 2021 17:35:43 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 17:36:07 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 18 Aug
 2021 17:36:06 +0800
Subject: Re: [PATCH RFC 0/7] add socket to netdev page frag recycling support
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Tang, Feng" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <memxor@gmail.com>,
        <linux@rempel-privat.de>, Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        <aahringo@redhat.com>, <ceggers@arri.de>, <yangbo.lu@nxp.com>,
        "Florian Westphal" <fw@strlen.de>, <xiangxia.m.yue@gmail.com>,
        linmiaohe <linmiaohe@huawei.com>, <hch@lst.de>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com>
Date:   Wed, 18 Aug 2021 17:36:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/18 16:57, Eric Dumazet wrote:
> On Wed, Aug 18, 2021 at 5:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> This patchset adds the socket to netdev page frag recycling
>> support based on the busy polling and page pool infrastructure.
> 
> I really do not see how this can scale to thousands of sockets.
> 
> tcp_mem[] defaults to ~ 9 % of physical memory.
> 
> If you now run tests with thousands of sockets, their skbs will
> consume Gigabytes
> of memory on typical servers, now backed by order-0 pages (instead of
> current order-3 pages)
> So IOMMU costs will actually be much bigger.

As the page allocator support bulk allocating now, see:
https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L252

if the DMA also support batch mapping/unmapping, maybe having a
small-sized page pool for thousands of sockets may not be a problem?
Christoph Hellwig mentioned the batch DMA operation support in below
thread:
https://www.spinics.net/lists/netdev/msg666715.html

if the batched DMA operation is supported, maybe having the
page pool is mainly benefit the case of small number of socket?

> 
> Are we planning to use Gigabyte sized page pools for NIC ?
> 
> Have you tried instead to make TCP frags twice bigger ?

Not yet.

> This would require less IOMMU mappings.
> (Note: This could require some mm help, since PAGE_ALLOC_COSTLY_ORDER
> is currently 3, not 4)

I am not familiar with mm yet, but I will take a look about that:)

> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3eea6e0b30a7d43793f567ffa526092c03e3546..6b66b51b61be9f198f6f1c4a3d81b57fa327986a
> 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2560,7 +2560,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
>         }
>  }
> 
> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
> +#define SKB_FRAG_PAGE_ORDER    get_order(65536)
>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
> 
>  /**
> 
> 
> 
>>
