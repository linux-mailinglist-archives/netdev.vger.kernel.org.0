Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ABA3CF212
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345005AbhGTByK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:54:10 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12229 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344641AbhGTBmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 21:42:01 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GTMm14W4yz1CLM4;
        Tue, 20 Jul 2021 10:16:49 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [PATCH v2 3/4] tools headers UAPI: add cpu_relax() implementation for x86 and arm64
Date:   Tue, 20 Jul 2021 10:21:48 +0800
Message-ID: <1626747709-34013-4-git-send-email-linyunsheng@huawei.com>
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

As x86 and arm64 is the two available systems that I can build
and test the cpu_relax() implementation, so only add cpu_relax()
implementation for x86 and arm64, other arches can be added easily
when needed.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 tools/include/asm/processor.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 tools/include/asm/processor.h

diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
new file mode 100644
index 0000000..f9b3902
--- /dev/null
+++ b/tools/include/asm/processor.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
+#define __TOOLS_LINUX_ASM_PROCESSOR_H
+
+#if defined(__i386__) || defined(__x86_64__)
+/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
+static __always_inline void rep_nop(void)
+{
+	asm volatile("rep; nop" ::: "memory");
+}
+
+static __always_inline void cpu_relax(void)
+{
+	rep_nop();
+}
+#elif defined(__aarch64__)
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+#else
+#error "Architecture not supported"
+#endif
+
+#endif
-- 
2.7.4

