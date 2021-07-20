Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040E13CF210
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343810AbhGTBxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:53:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7037 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbhGTBmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 21:42:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GTMm100YfzYdDc;
        Tue, 20 Jul 2021 10:16:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:22:34 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:22:34 +0800
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
Subject: [PATCH v2 1/4] tools headers UAPI: add cache aligning related macro
Date:   Tue, 20 Jul 2021 10:21:46 +0800
Message-ID: <1626747709-34013-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
References: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

____cacheline_aligned_in_smp macro is needed to avoid
cache bouncing in SMP system, which is used in ptr_ring
lib.

So add the related macro in order to bulid ptr_ring from
user space.

As SMP_CACHE_BYTES is 64 bytes for arm64 and most of x86
system, so use 64 bytes as the default SMP_CACHE_BYTES if
SMP_CACHE_BYTES is not defined.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 tools/include/linux/cache.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/include/linux/cache.h

diff --git a/tools/include/linux/cache.h b/tools/include/linux/cache.h
new file mode 100644
index 0000000..df04307
--- /dev/null
+++ b/tools/include/linux/cache.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX__CACHE_H
+#define __TOOLS_LINUX__CACHE_H
+
+#ifndef CONFIG_SMP
+#define CONFIG_SMP	1
+#endif
+
+#ifndef SMP_CACHE_BYTES
+#define SMP_CACHE_BYTES	64
+#endif
+
+#ifndef ____cacheline_aligned
+#define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
+#endif
+
+#ifndef ____cacheline_aligned_in_smp
+#ifdef CONFIG_SMP
+#define ____cacheline_aligned_in_smp ____cacheline_aligned
+#else
+#define ____cacheline_aligned_in_smp
+#endif /* CONFIG_SMP */
+#endif
+
+#endif /* __LINUX_CACHE_H */
-- 
2.7.4

