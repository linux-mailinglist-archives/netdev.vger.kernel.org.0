Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BA33CF213
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhGTByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:54:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11347 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344647AbhGTBmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 21:42:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GTMnR10ZBz7vx8;
        Tue, 20 Jul 2021 10:18:03 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH v2 2/4] tools headers UAPI: add kmalloc/vmalloc related interface
Date:   Tue, 20 Jul 2021 10:21:47 +0800
Message-ID: <1626747709-34013-3-git-send-email-linyunsheng@huawei.com>
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

Implement the kmalloc/vmalloc related interface based on
malloc interface in user space.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 tools/include/linux/gfp.h  |  2 ++
 tools/include/linux/slab.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 tools/include/linux/slab.h

diff --git a/tools/include/linux/gfp.h b/tools/include/linux/gfp.h
index 2203075..a660ab9 100644
--- a/tools/include/linux/gfp.h
+++ b/tools/include/linux/gfp.h
@@ -1,4 +1,6 @@
 #ifndef _TOOLS_INCLUDE_LINUX_GFP_H
 #define _TOOLS_INCLUDE_LINUX_GFP_H
 
+#define __GFP_ZERO		0x100u
+
 #endif /* _TOOLS_INCLUDE_LINUX_GFP_H */
diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
new file mode 100644
index 0000000..f0b7da6
--- /dev/null
+++ b/tools/include/linux/slab.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_SLAB_H
+#define __TOOLS_LINUX_SLAB_H
+
+#include <linux/gfp.h>
+#include <linux/cache.h>
+
+static inline void *kmalloc(size_t size, gfp_t gfp)
+{
+	void *p;
+
+	p = memalign(SMP_CACHE_BYTES, size);
+	if (!p)
+		return p;
+
+	if (gfp & __GFP_ZERO)
+		memset(p, 0, size);
+
+	return p;
+}
+
+static inline void *kzalloc(size_t size, gfp_t flags)
+{
+	return kmalloc(size, flags | __GFP_ZERO);
+}
+
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc(n * size, flags);
+}
+
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
+}
+
+static inline void kfree(void *p)
+{
+	free(p);
+}
+
+#define kvmalloc_array		kmalloc_array
+#define kvfree			kfree
+#define KMALLOC_MAX_SIZE	SIZE_MAX
+
+#endif
-- 
2.7.4

