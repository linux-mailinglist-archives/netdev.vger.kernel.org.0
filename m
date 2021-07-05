Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4793BB602
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 05:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhGEEAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 00:00:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6045 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhGEEAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 00:00:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJBbc1S69zXnMc;
        Mon,  5 Jul 2021 11:52:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:58:10 +0800
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
Subject: [PATCH net-next 2/2] tools/virtio: use common infrastructure to build ptr_ring.h
Date:   Mon, 5 Jul 2021 11:57:35 +0800
Message-ID: <1625457455-4667-3-git-send-email-linyunsheng@huawei.com>
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

Use the common infrastructure in tools/include to build
ptr_ring.h in user space.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 tools/virtio/ringtest/Makefile   |   2 +-
 tools/virtio/ringtest/main.h     | 100 +++-----------------------------------
 tools/virtio/ringtest/ptr_ring.c | 102 ++-------------------------------------
 3 files changed, 12 insertions(+), 192 deletions(-)

diff --git a/tools/virtio/ringtest/Makefile b/tools/virtio/ringtest/Makefile
index 85c98c2..89fc024 100644
--- a/tools/virtio/ringtest/Makefile
+++ b/tools/virtio/ringtest/Makefile
@@ -3,7 +3,7 @@ all:
 
 all: ring virtio_ring_0_9 virtio_ring_poll virtio_ring_inorder ptr_ring noring
 
-CFLAGS += -Wall
+CFLAGS += -Wall -I../../include
 CFLAGS += -pthread -O2 -ggdb -flto -fwhole-program
 LDFLAGS += -pthread -O2 -ggdb -flto -fwhole-program
 
diff --git a/tools/virtio/ringtest/main.h b/tools/virtio/ringtest/main.h
index 6d1fccd..95ea050 100644
--- a/tools/virtio/ringtest/main.h
+++ b/tools/virtio/ringtest/main.h
@@ -10,6 +10,13 @@
 
 #include <stdbool.h>
 
+#include <linux/compiler.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
+#define smp_acquire	smp_rmb
+#define smp_release	smp_wmb
+
 extern int param;
 
 extern bool do_exit;
@@ -87,18 +94,6 @@ void wait_for_call(void);
 
 extern unsigned ring_size;
 
-/* Compiler barrier - similar to what Linux uses */
-#define barrier() asm volatile("" ::: "memory")
-
-/* Is there a portable way to do this? */
-#if defined(__x86_64__) || defined(__i386__)
-#define cpu_relax() asm ("rep; nop" ::: "memory")
-#elif defined(__s390x__)
-#define cpu_relax() barrier()
-#else
-#define cpu_relax() assert(0)
-#endif
-
 extern bool do_relax;
 
 static inline void busy_wait(void)
@@ -110,85 +105,4 @@ static inline void busy_wait(void)
 		barrier();
 } 
 
-#if defined(__x86_64__) || defined(__i386__)
-#define smp_mb()     asm volatile("lock; addl $0,-132(%%rsp)" ::: "memory", "cc")
-#else
-/*
- * Not using __ATOMIC_SEQ_CST since gcc docs say they are only synchronized
- * with other __ATOMIC_SEQ_CST calls.
- */
-#define smp_mb() __sync_synchronize()
-#endif
-
-/*
- * This abuses the atomic builtins for thread fences, and
- * adds a compiler barrier.
- */
-#define smp_release() do { \
-    barrier(); \
-    __atomic_thread_fence(__ATOMIC_RELEASE); \
-} while (0)
-
-#define smp_acquire() do { \
-    __atomic_thread_fence(__ATOMIC_ACQUIRE); \
-    barrier(); \
-} while (0)
-
-#if defined(__i386__) || defined(__x86_64__) || defined(__s390x__)
-#define smp_wmb() barrier()
-#else
-#define smp_wmb() smp_release()
-#endif
-
-#ifdef __alpha__
-#define smp_read_barrier_depends() smp_acquire()
-#else
-#define smp_read_barrier_depends() do {} while(0)
-#endif
-
-static __always_inline
-void __read_once_size(const volatile void *p, void *res, int size)
-{
-        switch (size) {                                                 \
-        case 1: *(unsigned char *)res = *(volatile unsigned char *)p; break;              \
-        case 2: *(unsigned short *)res = *(volatile unsigned short *)p; break;            \
-        case 4: *(unsigned int *)res = *(volatile unsigned int *)p; break;            \
-        case 8: *(unsigned long long *)res = *(volatile unsigned long long *)p; break;            \
-        default:                                                        \
-                barrier();                                              \
-                __builtin_memcpy((void *)res, (const void *)p, size);   \
-                barrier();                                              \
-        }                                                               \
-}
-
-static __always_inline void __write_once_size(volatile void *p, void *res, int size)
-{
-	switch (size) {
-	case 1: *(volatile unsigned char *)p = *(unsigned char *)res; break;
-	case 2: *(volatile unsigned short *)p = *(unsigned short *)res; break;
-	case 4: *(volatile unsigned int *)p = *(unsigned int *)res; break;
-	case 8: *(volatile unsigned long long *)p = *(unsigned long long *)res; break;
-	default:
-		barrier();
-		__builtin_memcpy((void *)p, (const void *)res, size);
-		barrier();
-	}
-}
-
-#define READ_ONCE(x) \
-({									\
-	union { typeof(x) __val; char __c[1]; } __u;			\
-	__read_once_size(&(x), __u.__c, sizeof(x));		\
-	smp_read_barrier_depends(); /* Enforce dependency ordering from x */ \
-	__u.__val;							\
-})
-
-#define WRITE_ONCE(x, val) \
-({							\
-	union { typeof(x) __val; char __c[1]; } __u =	\
-		{ .__val = (typeof(x)) (val) }; \
-	__write_once_size(&(x), __u.__c, sizeof(x));	\
-	__u.__val;					\
-})
-
 #endif
diff --git a/tools/virtio/ringtest/ptr_ring.c b/tools/virtio/ringtest/ptr_ring.c
index c9b2633..e058874 100644
--- a/tools/virtio/ringtest/ptr_ring.c
+++ b/tools/virtio/ringtest/ptr_ring.c
@@ -10,104 +10,10 @@
 #include <errno.h>
 #include <limits.h>
 
-#define SMP_CACHE_BYTES 64
-#define cache_line_size() SMP_CACHE_BYTES
-#define ____cacheline_aligned_in_smp __attribute__ ((aligned (SMP_CACHE_BYTES)))
-#define unlikely(x)    (__builtin_expect(!!(x), 0))
-#define likely(x)    (__builtin_expect(!!(x), 1))
-#define ALIGN(x, a) (((x) + (a) - 1) / (a) * (a))
-#define SIZE_MAX        (~(size_t)0)
-#define KMALLOC_MAX_SIZE SIZE_MAX
-
-typedef pthread_spinlock_t  spinlock_t;
-
-typedef int gfp_t;
-#define __GFP_ZERO 0x1
-
-static void *kmalloc(unsigned size, gfp_t gfp)
-{
-	void *p = memalign(64, size);
-	if (!p)
-		return p;
-
-	if (gfp & __GFP_ZERO)
-		memset(p, 0, size);
-	return p;
-}
-
-static inline void *kzalloc(unsigned size, gfp_t flags)
-{
-	return kmalloc(size, flags | __GFP_ZERO);
-}
-
-static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
-{
-	if (size != 0 && n > SIZE_MAX / size)
-		return NULL;
-	return kmalloc(n * size, flags);
-}
-
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
-{
-	return kmalloc_array(n, size, flags | __GFP_ZERO);
-}
-
-static void kfree(void *p)
-{
-	if (p)
-		free(p);
-}
-
-#define kvmalloc_array kmalloc_array
-#define kvfree kfree
-
-static void spin_lock_init(spinlock_t *lock)
-{
-	int r = pthread_spin_init(lock, 0);
-	assert(!r);
-}
-
-static void spin_lock(spinlock_t *lock)
-{
-	int ret = pthread_spin_lock(lock);
-	assert(!ret);
-}
-
-static void spin_unlock(spinlock_t *lock)
-{
-	int ret = pthread_spin_unlock(lock);
-	assert(!ret);
-}
-
-static void spin_lock_bh(spinlock_t *lock)
-{
-	spin_lock(lock);
-}
-
-static void spin_unlock_bh(spinlock_t *lock)
-{
-	spin_unlock(lock);
-}
-
-static void spin_lock_irq(spinlock_t *lock)
-{
-	spin_lock(lock);
-}
-
-static void spin_unlock_irq(spinlock_t *lock)
-{
-	spin_unlock(lock);
-}
-
-static void spin_lock_irqsave(spinlock_t *lock, unsigned long f)
-{
-	spin_lock(lock);
-}
-
-static void spin_unlock_irqrestore(spinlock_t *lock, unsigned long f)
-{
-	spin_unlock(lock);
-}
+#include <linux/align.h>
+#include <linux/cache.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include "../../../include/linux/ptr_ring.h"
 
-- 
2.7.4

