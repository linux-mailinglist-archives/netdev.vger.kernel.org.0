Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017FE415C92
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbhIWLON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:14:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9911 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbhIWLON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:14:13 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HFXT254Tnz8ykM;
        Thu, 23 Sep 2021 19:08:06 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 23 Sep 2021 19:12:28 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 23 Sep
 2021 19:12:28 +0800
Subject: Re: [PATCH net-next 0/7] some optimization for page pool
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <YUwnogBl/qbNbQ7X@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <953f1319-ff1d-a5a0-9aa5-5ff5cf24e37a@huawei.com>
Date:   Thu, 23 Sep 2021 19:12:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YUwnogBl/qbNbQ7X@apalos.home>
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

On 2021/9/23 15:07, Ilias Apalodimas wrote:
> Hi Yunsheng, 
> 
> On Wed, Sep 22, 2021 at 05:41:24PM +0800, Yunsheng Lin wrote:
>> Patch 1: disable dma mapping support for 32-bit arch with 64-bit
>>          DMA.
>> Patch 2: support non-split page when PP_FLAG_PAGE_FRAG is set.
>> patch 3: avoid calling compound_head() for skb frag page
>> Patch 4-7: use pp_magic to identify pp page uniquely.
> 
> There's some subtle changes in this patchset that might affect XDP.
> 
> What I forgot when I proposed removing the recycling bit,  is that it also
> serves as an 'opt-in' mechanism for drivers that want to use page_pool but 
> do the recycling internally.  With that removed we need to make sure
> nothing bad happens to them.  In theory the page refcnt for mlx5

It seems odd that mlx5 is adding its own page cache on top of page pool,
is it about support both "struct sk_buff" and "struct xdp_buff" for the
same queue?

> specifically will be elevated, so we'll just end up unmapping the buffer.
> Arguably we could add a similar mechanism internally into page pool,  
> which would allow us to enable and disable recycling,  but that's
> an extra if per packet allocation and I don't know if we want that on the XDP 
> case.

Or we could change mlx5e_rx_cache_get() to check for "page->pp_frag_count
== 1" too, and adjust mlx5e_page_release() accordingly?

> A few numbers pre/post patch for XDP would help, but iirc hns3 doesn't have
> XDP support yet?

You are right, hns3 doesn't have XDP support yet.

> 
> It's plumbers week so I'll do some testing starting Monday.
> 
> Thanks
> /Ilias
> 
>>
>> V3:
>>     1. add patch 1/4/6/7.
>>     2. use pp_magic to identify pp page uniquely too.
>>     3. avoid unnecessary compound_head() calling.
>>
>> V2: add patch 2, adjust the commit log accroding to the discussion
>>     in V1, and fix a compiler error reported by kernel test robot.
>>
>> Yunsheng Lin (7):
>>   page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>>   page_pool: support non-split page with PP_FLAG_PAGE_FRAG
>>   pool_pool: avoid calling compound_head() for skb frag page
>>   page_pool: change BIAS_MAX to support incrementing
>>   skbuff: keep track of pp page when __skb_frag_ref() is called
>>   skbuff: only use pp_magic identifier for a skb' head page
>>   skbuff: remove unused skb->pp_recycle
>>
>>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  6 ---
>>  drivers/net/ethernet/marvell/mvneta.c         |  2 -
>>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 +-
>>  drivers/net/ethernet/marvell/sky2.c           |  2 +-
>>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
>>  drivers/net/ethernet/ti/cpsw.c                |  2 -
>>  drivers/net/ethernet/ti/cpsw_new.c            |  2 -
>>  include/linux/mm_types.h                      | 13 +-----
>>  include/linux/skbuff.h                        | 39 ++++++++----------
>>  include/net/page_pool.h                       | 31 ++++++++------
>>  net/core/page_pool.c                          | 40 +++++++------------
>>  net/core/skbuff.c                             | 36 ++++++-----------
>>  net/tls/tls_device.c                          |  2 +-
>>  13 files changed, 67 insertions(+), 114 deletions(-)
>>
>> -- 
>> 2.33.0
>>
> .
> 
