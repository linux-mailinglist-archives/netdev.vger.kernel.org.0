Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1EC3D3487
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhGWFjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:39:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7417 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhGWFjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 01:39:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GWJwd6Jh0z7wqY;
        Fri, 23 Jul 2021 14:16:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 14:19:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 14:19:42 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>, <qperret@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [RFC PATCH net-next 2/4] io: add function to flush the write combine buffer to device immediately
Date:   Fri, 23 Jul 2021 14:16:07 +0800
Message-ID: <1627020969-32945-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1627020969-32945-1-git-send-email-huangguangbin2@huawei.com>
References: <1627020969-32945-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

Device registers can be mapped as write-combine type. In this case, data
are not written into the device immediately. They are temporarily stored
in the write combine buffer and written into the device when the buffer
is full. But in some situation, we need to flush the write combine
buffer to device immediately for better performance. So we add a general
function called 'flush_wc_write()'. We use DGH instruction to implement
this function for ARM64.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 arch/arm64/include/asm/io.h | 2 ++
 include/linux/io.h          | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 7fd836bea7eb..5315d023b2dd 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -112,6 +112,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define __iowmb()		dma_wmb()
 #define __iomb()		dma_mb()
 
+#define flush_wc_write()	dgh()
+
 /*
  * Relaxed I/O memory access primitives. These follow the Device memory
  * ordering rules but do not guarantee any ordering relative to Normal memory
diff --git a/include/linux/io.h b/include/linux/io.h
index 9595151d800d..469d53444218 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -166,4 +166,10 @@ static inline void arch_io_free_memtype_wc(resource_size_t base,
 }
 #endif
 
+/* IO barriers */
+
+#ifndef flush_wc_write
+#define flush_wc_write()		do { } while (0)
+#endif
+
 #endif /* _LINUX_IO_H */
-- 
2.8.1

