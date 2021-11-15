Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF2450450
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhKOMYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 07:24:11 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27208 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhKOMYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 07:24:06 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ht7Xs5q9Tz8vMY;
        Mon, 15 Nov 2021 20:19:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 15 Nov 2021 20:21:07 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 15 Nov
 2021 20:21:07 +0800
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Guillaume Tucker <guillaume.tucker@collabora.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <akpm@linux-foundation.org>,
        <peterz@infradead.org>, <will@kernel.org>, <jhubbard@nvidia.com>,
        <yuzhao@google.com>, <mcroce@microsoft.com>,
        <fenghua.yu@intel.com>, <feng.tang@intel.com>, <jgg@ziepe.ca>,
        <aarcange@redhat.com>, <guro@fb.com>,
        "kernelci@groups.io" <kernelci@groups.io>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
 <CAC_iWjKFLr932sMt9G2T+MFYUAQZNWPqp6YsnmSd3rMia7OpoA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d0223831-44ff-3e1a-1be9-27d751dc39f2@huawei.com>
Date:   Mon, 15 Nov 2021 20:21:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAC_iWjKFLr932sMt9G2T+MFYUAQZNWPqp6YsnmSd3rMia7OpoA@mail.gmail.com>
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

On 2021/11/15 20:10, Ilias Apalodimas wrote:
> On Mon, 15 Nov 2021 at 13:53, Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
>>
>> On Mon, Nov 15, 2021 at 11:34:59AM +0800, Yunsheng Lin wrote:
>>> On 2021/11/12 17:21, Guillaume Tucker wrote:
>>>> On 09/11/2021 12:02, Yunsheng Lin wrote:
>>>>> On 2021/11/9 17:58, Guillaume Tucker wrote:
>>>>>> Hi Yunsheng,
>>>>>>
>>>>>> Please see the bisection report below about a boot failure on
>>>>>> rk3288-rock2-square which is pointing to this patch.  The issue
>>>>>> appears to only happen with CONFIG_ARM_LPAE=y.
>>>>>>
>>>>>> Reports aren't automatically sent to the public while we're
>>>>>> trialing new bisection features on kernelci.org but this one
>>>>>> looks valid.
>>>>>>
>>>>>> Some more details can be found here:
>>>>>>
>>>>>>   https://linux.kernelci.org/test/case/id/6189968c3ec0a3c06e3358fe/
>>>>>>
>>>>>> Here's the same revision on the same platform booting fine with a
>>>>>> plain multi_v7_defconfig build:
>>>>>>
>>>>>>   https://linux.kernelci.org/test/plan/id/61899d322c0e9fee7e3358ec/
>>>>>>
>>>>>> Please let us know if you need any help debugging this issue or
>>>>>> if you have a fix to try.
>>>>>
>>>>> The patch below is removing the dma mapping support in page pool
>>>>> for 32 bit systems with 64 bit dma address, so it seems there
>>>>> is indeed a a drvier using the the page pool with PP_FLAG_DMA_MAP
>>>>> flags set in a 32 bit systems with 64 bit dma address.
>>>>>
>>>>> It seems we might need to revert the below patch or implement the
>>>>> DMA-mapping tracking support in the driver as mentioned in the below
>>>>> commit log.
>>>>>
>>>>> which ethernet driver do you use in your system?
>>>>
>>>> Thanks for taking a look and sorry for the slow reply.  Here's a
>>>> booting test job with LPAE disabled:
>>>>
>>>>     https://linux.kernelci.org/test/plan/id/618dbb81c60c4d94503358f1/
>>>>     https://storage.kernelci.org/mainline/master/v5.15-12452-g5833291ab6de/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-nfs-rk3288-rock2-square.html#L812
>>>>
>>>> [    8.314523] rk_gmac-dwmac ff290000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>>>
>>>> So the driver is drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
>>>
>>> Thanks for the report, this patch seems to cause problem for 32-bit
>>> system with LPAE enabled.
>>>
>>> As LPAE seems like a common feature for 32 bits system, this patch
>>> might need to be reverted.
>>>
>>> @Jesper, @Ilias, what do you think?
>>
>>
>> So enabling LPAE also enables CONFIG_ARCH_DMA_ADDR_T_64BIT on that board?
>> Doing a quick grep only selects that for XEN.  I am ok reverting that,  but
>> I think we need to understand how the dma address ended up being 64bit.
> 
> So looking a bit closer, indeed enabling LPAE always enables this.  So
> we need to revert the patch.
> Yunsheng will you send that?

Sure.

> 
> Thanks
> /Ilias
>>
>> Regards
>> /Ilias
>>
>>>
>>>>
>>>> Best wishes,
>>>> Guillaume
>>>>
>>>>
>>>>>> GitHub: https://github.com/kernelci/kernelci-project/issues/71
>>>>>>
>>>>>> -------------------------------------------------------------------------------
>>>>>>
>>>>>> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>>>>>> * This automated bisection report was sent to you on the basis  *
>>>>>> * that you may be involved with the breaking commit it has      *
>>>>>> * found.  No manual investigation has been done to verify it,   *
>>>>>> * and the root cause of the problem may be somewhere else.      *
>>>>>> *                                                               *
>>>>>> * If you do send a fix, please include this trailer:            *
>>>>>> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
>>>>>> *                                                               *
>>>>>> * Hope this helps!                                              *
>>>>>> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>>>>>>
>>>>>> mainline/master bisection: baseline.login on rk3288-rock2-square
>>>>>>
>>>>>> Summary:
>>>>>>   Start:      e851dfae4371d Merge tag 'kgdb-5.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/danielt/linux
>>>>>>   Plain log:  https://storage.kernelci.org/mainline/master/v5.15-11387-ge851dfae4371/arm/multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y/gcc-10/lab-collabora/baseline-rk3288-rock2-square.txt
>>>>>>   HTML log:   https://storage.kernelci.org/mainline/master/v5.15-11387-ge851dfae4371/arm/multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y/gcc-10/lab-collabora/baseline-rk3288-rock2-square.html
>>>>>>   Result:     d00e60ee54b12 page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>>>>>>
>>>>>> Checks:
>>>>>>   revert:     PASS
>>>>>>   verify:     PASS
>>>>>>
>>>>>> Parameters:
>>>>>>   Tree:       mainline
>>>>>>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>>>>   Branch:     master
>>>>>>   Target:     rk3288-rock2-square
>>>>>>   CPU arch:   arm
>>>>>>   Lab:        lab-collabora
>>>>>>   Compiler:   gcc-10
>>>>>>   Config:     multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y
>>>>>>   Test case:  baseline.login
>>>>>>
>>>>>> Breaking commit found:
>>>>>>
>>>>>> -------------------------------------------------------------------------------
>>>>>> commit d00e60ee54b12de945b8493cf18c1ada9e422514
>>>>>> Author: Yunsheng Lin <linyunsheng@huawei.com>
>>>>>> Date:   Wed Oct 13 17:19:20 2021 +0800
>>>>>>
>>>>>>     page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>>>>>>
>>>>>>
>>>>>> On 13/10/2021 10:19, Yunsheng Lin wrote:
>>>>>>> As the 32-bit arch with 64-bit DMA seems to rare those days,
>>>>>>> and page pool might carry a lot of code and complexity for
>>>>>>> systems that possibly.
>>>>>>>
>>>>>>> So disable dma mapping support for such systems, if drivers
>>>>>>> really want to work on such systems, they have to implement
>>>>>>> their own DMA-mapping fallback tracking outside page_pool.
>>>>>>>
>>>>>>> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>>>>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>>>>> ---
>>>>>>> V6: Drop pp page tracking support
>>>>>>> ---
>>>>>>>  include/linux/mm_types.h | 13 +------------
>>>>>>>  include/net/page_pool.h  | 12 +-----------
>>>>>>>  net/core/page_pool.c     | 10 ++++++----
>>>>>>>  3 files changed, 8 insertions(+), 27 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>>>>>> index 7f8ee09c711f..436e0946d691 100644
>>>>>>> --- a/include/linux/mm_types.h
>>>>>>> +++ b/include/linux/mm_types.h
>>>>>>> @@ -104,18 +104,7 @@ struct page {
>>>>>>>                          struct page_pool *pp;
>>>>>>>                          unsigned long _pp_mapping_pad;
>>>>>>>                          unsigned long dma_addr;
>>>>>>> -                        union {
>>>>>>> -                                /**
>>>>>>> -                                 * dma_addr_upper: might require a 64-bit
>>>>>>> -                                 * value on 32-bit architectures.
>>>>>>> -                                 */
>>>>>>> -                                unsigned long dma_addr_upper;
>>>>>>> -                                /**
>>>>>>> -                                 * For frag page support, not supported in
>>>>>>> -                                 * 32-bit architectures with 64-bit DMA.
>>>>>>> -                                 */
>>>>>>> -                                atomic_long_t pp_frag_count;
>>>>>>> -                        };
>>>>>>> +                        atomic_long_t pp_frag_count;
>>>>>>>                  };
>>>>>>>                  struct {        /* slab, slob and slub */
>>>>>>>                          union {
>>>>>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>>>>>> index a4082406a003..3855f069627f 100644
>>>>>>> --- a/include/net/page_pool.h
>>>>>>> +++ b/include/net/page_pool.h
>>>>>>> @@ -216,24 +216,14 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>>>>>>          page_pool_put_full_page(pool, page, true);
>>>>>>>  }
>>>>>>>
>>>>>>> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
>>>>>>> -                (sizeof(dma_addr_t) > sizeof(unsigned long))
>>>>>>> -
>>>>>>>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>>>>>>  {
>>>>>>> -        dma_addr_t ret = page->dma_addr;
>>>>>>> -
>>>>>>> -        if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>>>>>>> -                ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
>>>>>>> -
>>>>>>> -        return ret;
>>>>>>> +        return page->dma_addr;
>>>>>>>  }
>>>>>>>
>>>>>>>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>>>>>>  {
>>>>>>>          page->dma_addr = addr;
>>>>>>> -        if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>>>>>>> -                page->dma_addr_upper = upper_32_bits(addr);
>>>>>>>  }
>>>>>>>
>>>>>>>  static inline void page_pool_set_frag_count(struct page *page, long nr)
>>>>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>>>>> index 1a6978427d6c..9b60e4301a44 100644
>>>>>>> --- a/net/core/page_pool.c
>>>>>>> +++ b/net/core/page_pool.c
>>>>>>> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
>>>>>>>           * which is the XDP_TX use-case.
>>>>>>>           */
>>>>>>>          if (pool->p.flags & PP_FLAG_DMA_MAP) {
>>>>>>> +                /* DMA-mapping is not supported on 32-bit systems with
>>>>>>> +                 * 64-bit DMA mapping.
>>>>>>> +                 */
>>>>>>> +                if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>>>>>> +                        return -EOPNOTSUPP;
>>>>>>> +
>>>>>>>                  if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>>>>>>>                      (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>>>>>>>                          return -EINVAL;
>>>>>>> @@ -69,10 +75,6 @@ static int page_pool_init(struct page_pool *pool,
>>>>>>>                   */
>>>>>>>          }
>>>>>>>
>>>>>>> -        if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>>>>>>> -            pool->p.flags & PP_FLAG_PAGE_FRAG)
>>>>>>> -                return -EINVAL;
>>>>>>> -
>>>>>>>          if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>>>>>>>                  return -ENOMEM;
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Git bisection log:
>>>>>>
>>>>>> -------------------------------------------------------------------------------
>>>>>> git bisect start
>>>>>> # good: [bfc484fe6abba4b89ec9330e0e68778e2a9856b2] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
>>>>>> git bisect good bfc484fe6abba4b89ec9330e0e68778e2a9856b2
>>>>>> # bad: [e851dfae4371d3c751f1e18e8eb5eba993de1467] Merge tag 'kgdb-5.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/danielt/linux
>>>>>> git bisect bad e851dfae4371d3c751f1e18e8eb5eba993de1467
>>>>>> # bad: [dcd68326d29b62f3039e4f4d23d3e38f24d37360] Merge tag 'devicetree-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
>>>>>> git bisect bad dcd68326d29b62f3039e4f4d23d3e38f24d37360
>>>>>> # bad: [b7b98f868987cd3e86c9bd9a6db048614933d7a0] Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
>>>>>> git bisect bad b7b98f868987cd3e86c9bd9a6db048614933d7a0
>>>>>> # bad: [9fd3d5dced976640f588e0a866b9611db2d2cb37] net: ethernet: ave: Add compatible string and SoC-dependent data for NX1 SoC
>>>>>> git bisect bad 9fd3d5dced976640f588e0a866b9611db2d2cb37
>>>>>> # good: [a96d317fb1a30b9f323548eb2ff05d4e4600ead9] ethernet: use eth_hw_addr_set()
>>>>>> git bisect good a96d317fb1a30b9f323548eb2ff05d4e4600ead9
>>>>>> # good: [f5396b8a663f7a78ee5b75a47ee524b40795b265] ice: switchdev slow path
>>>>>> git bisect good f5396b8a663f7a78ee5b75a47ee524b40795b265
>>>>>> # good: [20c3d9e45ba630a7156d682a40988c0e96be1b92] hamradio: use dev_addr_set() for setting device address
>>>>>> git bisect good 20c3d9e45ba630a7156d682a40988c0e96be1b92
>>>>>> # bad: [a64b442137669c9e839c6a70965989b01b1253b7] net: dpaa2: add support for manual setup of IRQ coalesing
>>>>>> git bisect bad a64b442137669c9e839c6a70965989b01b1253b7
>>>>>> # good: [30fc7efa38f21afa48b0be6bf2053e4c10ae2c78] net, neigh: Reject creating NUD_PERMANENT with NTF_MANAGED entries
>>>>>> git bisect good 30fc7efa38f21afa48b0be6bf2053e4c10ae2c78
>>>>>> # bad: [13ad5ccc093ff448b99ac7e138e91e78796adb48] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
>>>>>> git bisect bad 13ad5ccc093ff448b99ac7e138e91e78796adb48
>>>>>> # good: [40088915f547b52635f022c1e1e18df65ae3153a] Merge branch 'octeontx2-af-miscellaneous-changes-for-cpt'
>>>>>> git bisect good 40088915f547b52635f022c1e1e18df65ae3153a
>>>>>> # bad: [fdbf35df9c091db9c46e57e9938e3f7a4f603a7c] dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
>>>>>> git bisect bad fdbf35df9c091db9c46e57e9938e3f7a4f603a7c
>>>>>> # bad: [bacc8daf97d4199316328a5d18eeafbe447143c5] xen-netback: Remove redundant initialization of variable err
>>>>>> git bisect bad bacc8daf97d4199316328a5d18eeafbe447143c5
>>>>>> # bad: [d00e60ee54b12de945b8493cf18c1ada9e422514] page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>>>>>> git bisect bad d00e60ee54b12de945b8493cf18c1ada9e422514
>>>>>> # first bad commit: [d00e60ee54b12de945b8493cf18c1ada9e422514] page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
>>>>>> -------------------------------------------------------------------------------
>>>>>> .
>>>>>>
>>>>
>>>> .
>>>>
> .
> 
