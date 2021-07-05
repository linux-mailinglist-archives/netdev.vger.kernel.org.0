Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5493BB604
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 05:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhGEEAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 00:00:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6046 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhGEEAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 00:00:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJBbc069ZzXpVb;
        Mon,  5 Jul 2021 11:52:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:58:09 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:58:09 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     <nickhu@andestech.com>, <green.hu@gmail.com>,
        <deanbo422@gmail.com>, <akpm@linux-foundation.org>,
        <yury.norov@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/2] tools: add missing infrastructure for building ptr_ring.h
Date:   Mon, 5 Jul 2021 11:57:34 +0800
Message-ID: <1625457455-4667-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to build ptr_ring.h in userspace, the cacheline
aligning, cpu_relax() and slab related infrastructure is
needed, so add them in this patch.

As L1_CACHE_BYTES may be different for different arch, which
is mostly defined in include/generated/autoconf.h, so user may
need to do "make defconfig" before building a tool using the
API in linux/cache.h.

Also "linux/lockdep.h" is not added in "tools/include" yet,
so remove it in "linux/spinlock.h", and the only place using
"linux/spinlock.h" is tools/testing/radix-tree, removing that
does not break radix-tree testing.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 tools/include/asm/cache.h          | 56 ++++++++++++++++++++++++
 tools/include/asm/processor.h      | 36 ++++++++++++++++
 tools/include/generated/autoconf.h |  1 +
 tools/include/linux/align.h        | 15 +++++++
 tools/include/linux/cache.h        | 87 ++++++++++++++++++++++++++++++++++++++
 tools/include/linux/gfp.h          |  4 ++
 tools/include/linux/slab.h         | 46 ++++++++++++++++++++
 tools/include/linux/spinlock.h     |  2 -
 8 files changed, 245 insertions(+), 2 deletions(-)
 create mode 100644 tools/include/asm/cache.h
 create mode 100644 tools/include/asm/processor.h
 create mode 100644 tools/include/generated/autoconf.h
 create mode 100644 tools/include/linux/align.h
 create mode 100644 tools/include/linux/cache.h
 create mode 100644 tools/include/linux/slab.h

diff --git a/tools/include/asm/cache.h b/tools/include/asm/cache.h
new file mode 100644
index 0000000..071e310
--- /dev/null
+++ b/tools/include/asm/cache.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __TOOLS_LINUX_ASM_CACHE_H
+#define __TOOLS_LINUX_ASM_CACHE_H
+
+#include <generated/autoconf.h>
+
+#if defined(__i386__) || defined(__x86_64__)
+#define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
+#elif defined(__arm__)
+#define L1_CACHE_SHIFT	(CONFIG_ARM_L1_CACHE_SHIFT)
+#elif defined(__aarch64__)
+#define L1_CACHE_SHIFT	(6)
+#elif defined(__powerpc__)
+
+/* bytes per L1 cache line */
+#if defined(CONFIG_PPC_8xx)
+#define L1_CACHE_SHIFT	4
+#elif defined(CONFIG_PPC_E500MC)
+#define L1_CACHE_SHIFT	6
+#elif defined(CONFIG_PPC32)
+#if defined(CONFIG_PPC_47x)
+#define L1_CACHE_SHIFT	7
+#else
+#define L1_CACHE_SHIFT	5
+#endif
+#else /* CONFIG_PPC64 */
+#define L1_CACHE_SHIFT	7
+#endif
+
+#elif defined(__sparc__)
+#define L1_CACHE_SHIFT 5
+#elif defined(__alpha__)
+
+#if defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_EV6)
+#define L1_CACHE_SHIFT	6
+#else
+/* Both EV4 and EV5 are write-through, read-allocate,
+   direct-mapped, physical.
+*/
+#define L1_CACHE_SHIFT	5
+#endif
+
+#elif defined(__mips__)
+#define L1_CACHE_SHIFT	CONFIG_MIPS_L1_CACHE_SHIFT
+#elif defined(__ia64__)
+#define L1_CACHE_SHIFT	CONFIG_IA64_L1_CACHE_SHIFT
+#elif defined(__nds32__)
+#define L1_CACHE_SHIFT	5
+#else
+#define L1_CACHE_SHIFT	5
+#endif
+
+#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
+
+#endif
diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
new file mode 100644
index 0000000..3198ad6
--- /dev/null
+++ b/tools/include/asm/processor.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
+#define __TOOLS_LINUX_ASM_PROCESSOR_H
+
+#include <pthread.h>
+
+#if defined(__i386__) || defined(__x86_64__)
+#include "../../arch/x86/include/asm/vdso/processor.h"
+#elif defined(__arm__)
+#include "../../arch/arm/include/asm/vdso/processor.h"
+#elif defined(__aarch64__)
+#include "../../arch/arm64/include/asm/vdso/processor.h"
+#elif defined(__powerpc__)
+#include "../../arch/powerpc/include/vdso/processor.h"
+#elif defined(__s390__)
+#include "../../arch/s390/include/vdso/processor.h"
+#elif defined(__sh__)
+#include "../../arch/sh/include/asm/processor.h"
+#elif defined(__sparc__)
+#include "../../arch/sparc/include/asm/processor.h"
+#elif defined(__alpha__)
+#include "../../arch/alpha/include/asm/processor.h"
+#elif defined(__mips__)
+#include "../../arch/mips/include/asm/vdso/processor.h"
+#elif defined(__ia64__)
+#include "../../arch/ia64/include/asm/processor.h"
+#elif defined(__xtensa__)
+#include "../../arch/xtensa/include/asm/processor.h"
+#elif defined(__nds32__)
+#include "../../arch/nds32/include/asm/processor.h"
+#else
+#define cpu_relax()	sched_yield()
+#endif
+
+#endif
diff --git a/tools/include/generated/autoconf.h b/tools/include/generated/autoconf.h
new file mode 100644
index 0000000..c588a2f
--- /dev/null
+++ b/tools/include/generated/autoconf.h
@@ -0,0 +1 @@
+#include "../../../include/generated/autoconf.h"
diff --git a/tools/include/linux/align.h b/tools/include/linux/align.h
new file mode 100644
index 0000000..4e82cdf
--- /dev/null
+++ b/tools/include/linux/align.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_ALIGN_H
+#define __TOOLS_LINUX_ALIGN_H
+
+#include <linux/const.h>
+
+/* @a is a power of 2 value */
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
+#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
+#define PTR_ALIGN_DOWN(p, a)	((typeof(p))ALIGN_DOWN((unsigned long)(p), (a)))
+#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#endif	/* _LINUX_ALIGN_H */
diff --git a/tools/include/linux/cache.h b/tools/include/linux/cache.h
new file mode 100644
index 0000000..8f86b1b
--- /dev/null
+++ b/tools/include/linux/cache.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX__CACHE_H
+#define __TOOLS_LINUX__CACHE_H
+
+#include <asm/cache.h>
+
+#ifndef L1_CACHE_ALIGN
+#define L1_CACHE_ALIGN(x) __ALIGN_KERNEL(x, L1_CACHE_BYTES)
+#endif
+
+#ifndef SMP_CACHE_BYTES
+#define SMP_CACHE_BYTES L1_CACHE_BYTES
+#endif
+
+/*
+ * __read_mostly is used to keep rarely changing variables out of frequently
+ * updated cachelines. Its use should be reserved for data that is used
+ * frequently in hot paths. Performance traces can help decide when to use
+ * this. You want __read_mostly data to be tightly packed, so that in the
+ * best case multiple frequently read variables for a hot path will be next
+ * to each other in order to reduce the number of cachelines needed to
+ * execute a critical path. We should be mindful and selective of its use.
+ * ie: if you're going to use it please supply a *good* justification in your
+ * commit log
+ */
+#ifndef __read_mostly
+#define __read_mostly
+#endif
+
+/*
+ * __ro_after_init is used to mark things that are read-only after init (i.e.
+ * after mark_rodata_ro() has been called). These are effectively read-only,
+ * but may get written to during init, so can't live in .rodata (via "const").
+ */
+#ifndef __ro_after_init
+#define __ro_after_init __section(".data..ro_after_init")
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
+#ifndef __cacheline_aligned
+#define __cacheline_aligned					\
+  __attribute__((__aligned__(SMP_CACHE_BYTES),			\
+		 __section__(".data..cacheline_aligned")))
+#endif /* __cacheline_aligned */
+
+#ifndef __cacheline_aligned_in_smp
+#ifdef CONFIG_SMP
+#define __cacheline_aligned_in_smp __cacheline_aligned
+#else
+#define __cacheline_aligned_in_smp
+#endif /* CONFIG_SMP */
+#endif
+
+/*
+ * The maximum alignment needed for some critical structures
+ * These could be inter-node cacheline sizes/L3 cacheline
+ * size etc.  Define this in asm/cache.h for your arch
+ */
+#ifndef INTERNODE_CACHE_SHIFT
+#define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
+#endif
+
+#if !defined(____cacheline_internodealigned_in_smp)
+#if defined(CONFIG_SMP)
+#define ____cacheline_internodealigned_in_smp \
+	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))
+#else
+#define ____cacheline_internodealigned_in_smp
+#endif
+#endif
+
+#ifndef CONFIG_ARCH_HAS_CACHE_LINE_SIZE
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
+#endif /* __LINUX_CACHE_H */
diff --git a/tools/include/linux/gfp.h b/tools/include/linux/gfp.h
index 2203075..d7041c0 100644
--- a/tools/include/linux/gfp.h
+++ b/tools/include/linux/gfp.h
@@ -1,4 +1,8 @@
 #ifndef _TOOLS_INCLUDE_LINUX_GFP_H
 #define _TOOLS_INCLUDE_LINUX_GFP_H
 
+#include <linux/types.h>
+
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
diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spinlock.h
index c934572..622266b 100644
--- a/tools/include/linux/spinlock.h
+++ b/tools/include/linux/spinlock.h
@@ -37,6 +37,4 @@ static inline bool arch_spin_is_locked(arch_spinlock_t *mutex)
 	return true;
 }
 
-#include <linux/lockdep.h>
-
 #endif
-- 
2.7.4

