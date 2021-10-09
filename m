Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE05A42787B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbhJIJlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:41:08 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24229 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhJIJlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:41:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HRKjl4LYxzQj5H;
        Sat,  9 Oct 2021 17:38:03 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:06 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:05 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <akpm@linux-foundation.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <peterz@infradead.org>, <yuzhao@google.com>, <jhubbard@nvidia.com>,
        <will@kernel.org>, <willy@infradead.org>, <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <vvs@virtuozzo.com>, <linux-mm@kvack.org>,
        <edumazet@google.com>, <alexander.duyck@gmail.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next -v5 0/4] some optimization for page pool
Date:   Sat, 9 Oct 2021 17:37:20 +0800
Message-ID: <20211009093724.10539-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: disable dma mapping support for 32-bit arch with 64-bit
         DMA.
Patch 2 - 4: pp page frag tracking support

The small packet drop test show no notiable performance degradation
when page pool is disabled.

V5: Keep the put_page()/get_page() semantics.

V4:
    1. Change error code to EOPNOTSUPP in patch 1.
    2. Drop patch 2.
    3. Use pp_frag_count to indicate if a pp page can be tracked,
       to avoid breaking the mlx5 driver.

V3:
    1. add patch 1/4/6/7.
    2. use pp_magic to identify pp page uniquely too.
    3. avoid unnecessary compound_head() calling.

V2: add patch 2, adjust the commit log accroding to the discussion
    in V1, and fix a compiler error reported by kernel test robot.

Yunsheng Lin (4):
  page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
  page_pool: change BIAS_MAX to support incrementing
  mm: introduce __get_page() and __put_page()
  skbuff: keep track of pp page when pp_frag_count is used

 include/linux/mm.h       | 21 ++++++++++++++-------
 include/linux/mm_types.h | 13 +------------
 include/linux/skbuff.h   | 30 ++++++++++++++++++++----------
 include/net/page_pool.h  | 36 ++++++++++++++++++++++++------------
 mm/swap.c                |  6 +++---
 net/core/page_pool.c     | 29 +++++++++--------------------
 net/core/skbuff.c        | 10 ++++++++--
 7 files changed, 79 insertions(+), 66 deletions(-)

-- 
2.33.0

