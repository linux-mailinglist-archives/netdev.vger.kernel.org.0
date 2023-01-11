Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C0665607
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjAKI1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbjAKI0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:26:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA3DEF
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:25:50 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NsLM05dJZzJrBb;
        Wed, 11 Jan 2023 16:24:28 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 11 Jan
 2023 16:25:46 +0800
Subject: Re: [PATCH v3 00/26] Split netmem from struct page
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>
References: <20230111042214.907030-1-willy@infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
Date:   Wed, 11 Jan 2023 16:25:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/11 12:21, Matthew Wilcox (Oracle) wrote:
> The MM subsystem is trying to reduce struct page to a single pointer.
> The first step towards that is splitting struct page by its individual
> users, as has already been done with folio and slab.  This patchset does
> that for netmem which is used for page pools.

As page pool is only used for rx side in the net stack depending on the
driver, a lot more memory for the net stack is from page_frag_alloc_align(),
kmem cache, etc.
naming it netmem seems a little overkill, perhaps a more specific name for
the page pool? such as pp_cache.

@Jesper & Ilias
Any better idea?
And it seem some API may need changing too, as we are not pooling 'pages'
now.

> 
> There are some relatively significant reductions in kernel text size
> from these changes.  They don't appear to affect performance at all,
> but it's nice to save a bit of memory.
> 
> v3:
>  - Rebase to next-20230110
>  - Add received Acked-by and Reviewed-by tags (thanks!)
>  - Mark compat functions in page_pool.h (Ilias)
>  - Correct a patch title
>  - Convert hns3 driver (and page_pool_dev_alloc_frag())
>  - Make page_pool_recycle_direct() accept a netmem or page pointer
> 
> Matthew Wilcox (Oracle) (26):
>   netmem: Create new type
>   netmem: Add utility functions
>   page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
>   page_pool: Convert page_pool_release_page() to
>     page_pool_release_netmem()
>   page_pool: Start using netmem in allocation path.
                                                    ^
nit: there is a '.' at the end of patch titile.

>   page_pool: Convert page_pool_return_page() to
>     page_pool_return_netmem()
>   page_pool: Convert __page_pool_put_page() to __page_pool_put_netmem()
>   page_pool: Convert pp_alloc_cache to contain netmem
>   page_pool: Convert page_pool_defrag_page() to
>     page_pool_defrag_netmem()
>   page_pool: Convert page_pool_put_defragged_page() to netmem
>   page_pool: Convert page_pool_empty_ring() to use netmem
>   page_pool: Convert page_pool_alloc_pages() to page_pool_alloc_netmem()
>   page_pool: Convert page_pool_dma_sync_for_device() to take a netmem
>   page_pool: Convert page_pool_recycle_in_cache() to netmem
>   page_pool: Remove __page_pool_put_page()
>   page_pool: Use netmem in page_pool_drain_frag()
>   page_pool: Convert page_pool_return_skb_page() to use netmem
>   page_pool: Allow page_pool_recycle_direct() to take a netmem or a page
>   page_pool: Convert frag_page to frag_nmem
>   xdp: Convert to netmem
>   mm: Remove page pool members from struct page
>   page_pool: Pass a netmem to init_callback()
>   net: Add support for netmem in skb_frag
>   mvneta: Convert to netmem
>   mlx5: Convert to netmem
>   hns3: Convert to netmem
> 
>  Documentation/networking/page_pool.rst        |   5 +
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  16 +-
>  drivers/net/ethernet/marvell/mvneta.c         |  48 +--
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  24 +-
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 130 +++++----
>  include/linux/mm_types.h                      |  22 --
>  include/linux/skbuff.h                        |  11 +
>  include/net/page_pool.h                       | 228 ++++++++++++---
>  include/trace/events/page_pool.h              |  28 +-
>  net/bpf/test_run.c                            |   4 +-
>  net/core/page_pool.c                          | 274 +++++++++---------
>  net/core/xdp.c                                |   7 +-
>  16 files changed, 493 insertions(+), 332 deletions(-)
> 
