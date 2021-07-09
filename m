Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37253C1F76
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 08:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhGIGnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 02:43:00 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:10339 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhGIGm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 02:42:59 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GLk1x0cXWz77hb;
        Fri,  9 Jul 2021 14:35:49 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 9 Jul 2021 14:40:04 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 9 Jul 2021
 14:40:03 +0800
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page
 pool
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Marcin Wojtas <mw@semihalf.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <20210702153947.7b44acdf@linux.microsoft.com>
 <20210706155131.GS22278@shell.armlinux.org.uk>
 <CAFnufp1hM6WRDigAsSfM94yneRhkmxBoGG7NxRUkbfTR2WQvyA@mail.gmail.com>
 <CAPv3WKdQ5jYtMyZuiKshXhLjcf9b+7Dm2Lt2cjE=ATDe+n9A5g@mail.gmail.com>
 <CAFnufp0NaPSkMQC-3ne49FL3Ak+UV0a7QoXELvVuMzBR4+GZ_g@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <14a92860-67cc-b2ac-efba-dd482f03204b@huawei.com>
Date:   Fri, 9 Jul 2021 14:40:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAFnufp0NaPSkMQC-3ne49FL3Ak+UV0a7QoXELvVuMzBR4+GZ_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/9 12:15, Matteo Croce wrote:
> On Wed, Jul 7, 2021 at 6:50 PM Marcin Wojtas <mw@semihalf.com> wrote:
>>
>> Hi,
>>
>>
>> śr., 7 lip 2021 o 01:20 Matteo Croce <mcroce@linux.microsoft.com> napisał(a):
>>>
>>> On Tue, Jul 6, 2021 at 5:51 PM Russell King (Oracle)
>>> <linux@armlinux.org.uk> wrote:
>>>>
>>>> On Fri, Jul 02, 2021 at 03:39:47PM +0200, Matteo Croce wrote:
>>>>> On Wed, 30 Jun 2021 17:17:54 +0800
>>>>> Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>
>>>>>> This patchset adds elevated refcnt support for page pool
>>>>>> and enable skb's page frag recycling based on page pool
>>>>>> in hns3 drvier.
>>>>>>
>>>>>> Yunsheng Lin (2):
>>>>>>   page_pool: add page recycling support based on elevated refcnt
>>>>>>   net: hns3: support skb's frag page recycling based on page pool
>>>>>>
>>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
>>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
>>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
>>>>>>  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
>>>>>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
>>>>>>  include/linux/mm_types.h                           |   2 +-
>>>>>>  include/linux/skbuff.h                             |   4 +-
>>>>>>  include/net/page_pool.h                            |  30 ++-
>>>>>>  net/core/page_pool.c                               | 215
>>>>>> +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
>>>>>> deletions(-)
>>>>>>
>>>>>
>>>>> Interesting!
>>>>> Unfortunately I'll not have access to my macchiatobin anytime soon, can
>>>>> someone test the impact, if any, on mvpp2?
>>>>
>>>> I'll try to test. Please let me know what kind of testing you're
>>>> looking for (I haven't been following these patches, sorry.)
>>>>
>>>
>>> A drop test or L2 routing will be enough.
>>> BTW I should have the macchiatobin back on friday.
>>
>> I have a 10G packet generator connected to 10G ports of CN913x-DB - I
>> will stress mvpp2 in l2 forwarding early next week (I'm mostly AFK
>> this until Monday).
>>
> 
> I managed to to a drop test on mvpp2. Maybe there is a slowdown but
> it's below the measurement uncertainty.
> 
> Perf top before:
> 
> Overhead  Shared O  Symbol
>    8.48%  [kernel]  [k] page_pool_put_page
>    2.57%  [kernel]  [k] page_pool_refill_alloc_cache
>    1.58%  [kernel]  [k] page_pool_alloc_pages
>    0.75%  [kernel]  [k] page_pool_return_skb_page
> 
> after:
> 
> Overhead  Shared O  Symbol
>    8.34%  [kernel]  [k] page_pool_put_page
>    4.52%  [kernel]  [k] page_pool_return_skb_page
>    4.42%  [kernel]  [k] page_pool_sub_bias
>    3.16%  [kernel]  [k] page_pool_alloc_pages
>    2.43%  [kernel]  [k] page_pool_refill_alloc_cache

Hi, Matteo
Thanks for the testing.
it seems you have adapted the mvpp2 driver to use the new frag
API for page pool, There is one missing optimization for XDP case,
the page is always returned to the pool->ring regardless of the
context of page_pool_put_page() for elevated refcnt case.

Maybe adding back that optimization will close some gap of the above
performance difference if the drop is happening in softirq context.

> 
> Regards,
> 
