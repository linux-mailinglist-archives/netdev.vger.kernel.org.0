Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4033CF2C9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347422AbhGTC6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 22:58:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7399 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347110AbhGTC4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 22:56:00 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GTPRs6n7lz7x0b;
        Tue, 20 Jul 2021 11:32:57 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 11:36:30 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 11:36:30 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH rfc v6 0/4] add frag page support in page pool
Date:   Tue, 20 Jul 2021 11:35:41 +0800
Message-ID: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds frag page support in page pool and
enable skb's page frag recycling based on page pool in
hns3 drvier.

RFC v6:
1. Disable frag page support in system 32-bit arch and
   64-bit DMA.

RFC v5:
1. Rename dma_addr[0] to pp_frag_count and adjust codes
   according to the rename.

RFC v4:
1. Use the dma_addr[1] to store bias.
2. Default to a pagecnt_bias of PAGE_SIZE - 1.
3. other minor comment suggested by Alexander.

RFC v3:
1. Implement the semantic of "page recycling only wait for the
   page pool user instead of all user of a page"
2. Support the frag allocation of different sizes
3. Merge patch 4 & 5 to one patch as it does not make sense to
   use page_pool_dev_alloc_pages() API directly with elevated
   refcnt.
4. other minor comment suggested by Alexander.

RFC v2:
1. Split patch 1 to more reviewable one.
2. Repurpose the lower 12 bits of the dma address to store the
   pagecnt_bias as suggested by Alexander.
3. support recycling to pool->alloc for elevated refcnt case
   too.

Yunsheng Lin (4):
  page_pool: keep pp info as long as page pool owns the page
  page_pool: add interface to manipulate frag count in page pool
  page_pool: add frag page recycling support in page pool
  net: hns3: support skb's frag page recycling based on page pool

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  82 +++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |   3 +
 drivers/net/ethernet/marvell/mvneta.c           |   6 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
 drivers/net/ethernet/ti/cpsw.c                  |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c              |   2 +-
 include/linux/mm_types.h                        |  18 ++--
 include/linux/skbuff.h                          |   4 +-
 include/net/page_pool.h                         |  65 +++++++++++---
 net/core/page_pool.c                            | 112 +++++++++++++++++++++++-
 10 files changed, 257 insertions(+), 39 deletions(-)

-- 
2.7.4

