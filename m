Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CB41456E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhIVJod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:44:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9902 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhIVJoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:44:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HDtX46CQtz8yh9;
        Wed, 22 Sep 2021 17:38:28 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:01 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:01 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 0/7] some optimization for page pool
Date:   Wed, 22 Sep 2021 17:41:24 +0800
Message-ID: <20210922094131.15625-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: disable dma mapping support for 32-bit arch with 64-bit
         DMA.
Patch 2: support non-split page when PP_FLAG_PAGE_FRAG is set.
patch 3: avoid calling compound_head() for skb frag page
Patch 4-7: use pp_magic to identify pp page uniquely.

V3:
    1. add patch 1/4/6/7.
    2. use pp_magic to identify pp page uniquely too.
    3. avoid unnecessary compound_head() calling.

V2: add patch 2, adjust the commit log accroding to the discussion
    in V1, and fix a compiler error reported by kernel test robot.

Yunsheng Lin (7):
  page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
  page_pool: support non-split page with PP_FLAG_PAGE_FRAG
  pool_pool: avoid calling compound_head() for skb frag page
  page_pool: change BIAS_MAX to support incrementing
  skbuff: keep track of pp page when __skb_frag_ref() is called
  skbuff: only use pp_magic identifier for a skb' head page
  skbuff: remove unused skb->pp_recycle

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  6 ---
 drivers/net/ethernet/marvell/mvneta.c         |  2 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 drivers/net/ethernet/ti/cpsw.c                |  2 -
 drivers/net/ethernet/ti/cpsw_new.c            |  2 -
 include/linux/mm_types.h                      | 13 +-----
 include/linux/skbuff.h                        | 39 ++++++++----------
 include/net/page_pool.h                       | 31 ++++++++------
 net/core/page_pool.c                          | 40 +++++++------------
 net/core/skbuff.c                             | 36 ++++++-----------
 net/tls/tls_device.c                          |  2 +-
 13 files changed, 67 insertions(+), 114 deletions(-)

-- 
2.33.0

