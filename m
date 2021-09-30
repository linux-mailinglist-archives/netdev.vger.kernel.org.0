Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB98741D53E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbhI3ILI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:11:08 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24201 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348850AbhI3ILH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 04:11:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKm8Z4dSjz8tRc;
        Thu, 30 Sep 2021 16:08:30 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:09:23 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:09:23 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v4 0/3] some optimization for page pool
Date:   Thu, 30 Sep 2021 16:07:44 +0800
Message-ID: <20210930080747.28297-1-linyunsheng@huawei.com>
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
Patch 2 & 3: pp page frag tracking support

The small packet drop test show no notiable performance degradation
when page pool is disabled.

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

Yunsheng Lin (3):
  page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
  page_pool: change BIAS_MAX to support incrementing
  skbuff: keep track of pp page when pp_frag_count is used

 include/linux/mm_types.h | 13 +------------
 include/linux/skbuff.h   | 30 ++++++++++++++++++++----------
 include/net/page_pool.h  | 36 ++++++++++++++++++++++++------------
 net/core/page_pool.c     | 29 +++++++++--------------------
 net/core/skbuff.c        | 10 ++++++++--
 5 files changed, 62 insertions(+), 56 deletions(-)

-- 
2.33.0

