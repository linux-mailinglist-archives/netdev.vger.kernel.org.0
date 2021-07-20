Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1883CF211
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbhGTBx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:53:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7394 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344639AbhGTBmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 21:42:00 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GTMpR6p73z7w3x;
        Tue, 20 Jul 2021 10:18:55 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:22:34 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:22:33 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     <nickhu@andestech.com>, <green.hu@gmail.com>,
        <deanbo422@gmail.com>, <akpm@linux-foundation.org>,
        <yury.norov@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH v2 0/4] refactor the ringtest testing for ptr_ring
Date:   Tue, 20 Jul 2021 10:21:45 +0800
Message-ID: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
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

tools/include/* has a lot of abstract layer for building
kernel code from userspace, so reuse or add the abstract
layer in tools/include/ to build the ptr_ring for ringtest
testing.

The same abstract layer can be used to build the ptr_ring
for ptr_ring benchmark app too, see [1].

1. https://lkml.org/lkml/2021/7/1/275

V2:
1. rebased on the Eugenio's patchset and split patch 1 to
   more reviewable ones.
2. only add the interface used by ringtest, so that the
   added code can be built and tested.
3. cpu_relax() only support x86 and arm64 now.
4. use 64 bytes as the default SMP_CACHE_BYTES.

Yunsheng Lin (4):
  tools headers UAPI: add cache aligning related macro
  tools headers UAPI: add kmalloc/vmalloc related interface
  tools headers UAPI: add cpu_relax() implementation for x86 and arm64
  tools/virtio: use common infrastructure to build ptr_ring.h

 tools/include/asm/processor.h    |  26 ++++++++++
 tools/include/linux/cache.h      |  25 ++++++++++
 tools/include/linux/gfp.h        |   2 +
 tools/include/linux/slab.h       |  46 ++++++++++++++++++
 tools/virtio/ringtest/Makefile   |   2 +-
 tools/virtio/ringtest/main.h     |  99 +++-----------------------------------
 tools/virtio/ringtest/ptr_ring.c | 101 ++-------------------------------------
 7 files changed, 109 insertions(+), 192 deletions(-)
 create mode 100644 tools/include/asm/processor.h
 create mode 100644 tools/include/linux/cache.h
 create mode 100644 tools/include/linux/slab.h

-- 
2.7.4

