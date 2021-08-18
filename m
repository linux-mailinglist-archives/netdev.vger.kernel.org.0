Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3000D3EF89C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhHRDeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17035 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhHRDeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqD0m1sC9zbfRK;
        Wed, 18 Aug 2021 11:29:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:26 +0800
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
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 0/7] add socket to netdev page frag recycling support
Date:   Wed, 18 Aug 2021 11:32:16 +0800
Message-ID: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the socket to netdev page frag recycling
support based on the busy polling and page pool infrastructure.

The profermance improve from 30Gbit to 41Gbit for one thread iperf
tcp flow, and the CPU usages decreases about 20% for four threads
iperf flow with 100Gb line speed in IOMMU strict mode.

The profermance improve about 2.5% for one thread iperf tcp flow
in IOMMU passthrough mode.

Yunsheng Lin (7):
  page_pool: refactor the page pool to support multi alloc context
  skbuff: add interface to manipulate frag count for tx recycling
  net: add NAPI api to register and retrieve the page pool ptr
  net: pfrag_pool: add pfrag pool support based on page pool
  sock: support refilling pfrag from pfrag_pool
  net: hns3: support tx recycling in the hns3 driver
  sysctl_tcp_use_pfrag_pool

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 32 +++++----
 include/linux/netdevice.h                       |  9 +++
 include/linux/skbuff.h                          | 43 +++++++++++-
 include/net/netns/ipv4.h                        |  1 +
 include/net/page_pool.h                         | 15 ++++
 include/net/pfrag_pool.h                        | 24 +++++++
 include/net/sock.h                              |  1 +
 net/core/Makefile                               |  1 +
 net/core/dev.c                                  | 34 ++++++++-
 net/core/page_pool.c                            | 86 ++++++++++++-----------
 net/core/pfrag_pool.c                           | 92 +++++++++++++++++++++++++
 net/core/sock.c                                 | 12 ++++
 net/ipv4/sysctl_net_ipv4.c                      |  7 ++
 net/ipv4/tcp.c                                  | 34 ++++++---
 14 files changed, 325 insertions(+), 66 deletions(-)
 create mode 100644 include/net/pfrag_pool.h
 create mode 100644 net/core/pfrag_pool.c

-- 
2.7.4

