Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B043B3B1D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhFYDVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:21:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11093 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhFYDVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:21:46 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GB2GG1TrPzZhMj;
        Fri, 25 Jun 2021 11:16:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:24 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v2 1/2] selftests/ptr_ring: add benchmark application for ptr_ring
Date:   Fri, 25 Jun 2021 11:18:55 +0800
Message-ID: <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ptr_ring selftest is embedded within the virtio
selftest, which involves some specific virtio operation,
such as notifying and kicking.

As ptr_ring has been used by various subsystems, it deserves
it's owner's selftest in order to benchmark different usecase
of ptr_ring, such as page pool and pfifo_fast qdisc.

So add a simple application to benchmark ptr_ring performance.
Currently two test mode is supported:
Mode 0: Both enqueuing and dequeuing is done in a single thread,
        it is called simple test mode in the test app.
Mode 1: Enqueuing and dequeuing is done in different thread
        concurrently, also known as SPSC(single-producer/
        single-consumer) test.

The multi-producer/single-consumer test for pfifo_fast case is
not added yet, which can be added if using CAS atomic operation
to enable lockless multi-producer is proved to be better than
using r->producer_lock.

Only supported on x86 and arm64 for now.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 MAINTAINERS                                      |   5 +
 tools/testing/selftests/ptr_ring/Makefile        |   6 +
 tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
 tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
 4 files changed, 410 insertions(+)
 create mode 100644 tools/testing/selftests/ptr_ring/Makefile
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.c
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cc375fd..1227022 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14847,6 +14847,11 @@ F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
 
+PTR RING BENCHMARK
+M:	Yunsheng Lin <linyunsheng@huawei.com>
+L:	netdev@vger.kernel.org
+F:	tools/testing/selftests/ptr_ring/
+
 PTRACE SUPPORT
 M:	Oleg Nesterov <oleg@redhat.com>
 S:	Maintained
diff --git a/tools/testing/selftests/ptr_ring/Makefile b/tools/testing/selftests/ptr_ring/Makefile
new file mode 100644
index 0000000..346dea9
--- /dev/null
+++ b/tools/testing/selftests/ptr_ring/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+LDLIBS = -lpthread
+
+TEST_GEN_PROGS := ptr_ring_test
+
+include ../lib.mk
diff --git a/tools/testing/selftests/ptr_ring/ptr_ring_test.c b/tools/testing/selftests/ptr_ring/ptr_ring_test.c
new file mode 100644
index 0000000..4f32d3d
--- /dev/null
+++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 HiSilicon Limited.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/time.h>
+#include <malloc.h>
+#include <assert.h>
+#include <stdbool.h>
+#include <pthread.h>
+
+#include "ptr_ring_test.h"
+#include "../../../../include/linux/ptr_ring.h"
+
+#define MIN_RING_SIZE	2
+#define MAX_RING_SIZE	10000000
+
+static struct ptr_ring ring ____cacheline_aligned_in_smp;
+
+struct worker_info {
+	pthread_t tid;
+	int test_count;
+	bool error;
+	long duration_us;
+};
+
+static void *produce_worker(void *arg)
+{
+	struct worker_info *info = arg;
+	struct timeval start, end;
+	unsigned long i = 0;
+	long sec, us;
+	int ret;
+
+	gettimeofday(&start, NULL);
+
+	while (++i <= info->test_count) {
+		while (__ptr_ring_full(&ring))
+			cpu_relax();
+
+		ret = __ptr_ring_produce(&ring, (void *)i);
+		if (ret) {
+			fprintf(stderr, "produce failed: %d\n", ret);
+			info->error = true;
+			return NULL;
+		}
+	}
+
+	gettimeofday(&end, NULL);
+
+	sec = (end.tv_sec - start.tv_sec);
+	us = ((sec * 1000000) + end.tv_usec) - (start.tv_usec);
+	info->duration_us = us;
+	info->error = false;
+
+	return NULL;
+}
+
+static void *consume_worker(void *arg)
+{
+	struct worker_info *info = arg;
+	struct timeval start, end;
+	unsigned long i = 0;
+	long sec, us;
+	int *ptr;
+
+	gettimeofday(&start, NULL);
+
+	while (++i <= info->test_count) {
+		while (__ptr_ring_empty(&ring))
+			cpu_relax();
+
+		ptr = __ptr_ring_consume(&ring);
+		if ((unsigned long)ptr != i) {
+			fprintf(stderr, "consumer failed, ptr: %lu, i: %lu\n",
+				(unsigned long)ptr, i);
+			info->error = true;
+			return NULL;
+		}
+	}
+
+	gettimeofday(&end, NULL);
+
+	if (!__ptr_ring_empty(&ring)) {
+		fprintf(stderr, "ring should be empty, test failed\n");
+		info->error = true;
+		return NULL;
+	}
+
+	sec = (end.tv_sec - start.tv_sec);
+	us = ((sec * 1000000) + end.tv_usec) - (start.tv_usec);
+	info->duration_us = us;
+	info->error = false;
+	return NULL;
+}
+
+/* test case for single producer single consumer */
+static void spsc_test(int size, int count)
+{
+	struct worker_info producer, consumer;
+	pthread_attr_t attr;
+	void *res;
+	int ret;
+
+	ret = ptr_ring_init(&ring, size, 0);
+	if (ret) {
+		fprintf(stderr, "init failed: %d\n", ret);
+		return;
+	}
+
+	producer.test_count = count;
+	consumer.test_count = count;
+
+	ret = pthread_attr_init(&attr);
+	if (ret) {
+		fprintf(stderr, "pthread attr init failed: %d\n", ret);
+		goto out;
+	}
+
+	ret = pthread_create(&producer.tid, &attr,
+			     produce_worker, &producer);
+	if (ret) {
+		fprintf(stderr, "create producer thread failed: %d\n", ret);
+		goto out;
+	}
+
+	ret = pthread_create(&consumer.tid, &attr,
+			     consume_worker, &consumer);
+	if (ret) {
+		fprintf(stderr, "create consumer thread failed: %d\n", ret);
+		goto out;
+	}
+
+	ret = pthread_join(producer.tid, &res);
+	if (ret) {
+		fprintf(stderr, "join producer thread failed: %d\n", ret);
+		goto out;
+	}
+
+	ret = pthread_join(consumer.tid, &res);
+	if (ret) {
+		fprintf(stderr, "join consumer thread failed: %d\n", ret);
+		goto out;
+	}
+
+	if (producer.error || consumer.error) {
+		fprintf(stderr, "spsc test failed\n");
+		goto out;
+	}
+
+	printf("ptr_ring(size:%d) perf spsc test for %d times, took %ld us + %ld us\n",
+	       size, count, producer.duration_us, consumer.duration_us);
+out:
+	ptr_ring_cleanup(&ring, NULL);
+}
+
+static void simple_test(int size, int count)
+{
+	struct timeval start, end;
+	long sec, us;
+	int i = 0;
+	int *ptr;
+	int ret;
+
+	ret = ptr_ring_init(&ring, size, 0);
+	if (ret) {
+		fprintf(stderr, "init failed: %d\n", ret);
+		return;
+	}
+
+	gettimeofday(&start, NULL);
+
+	while (++i <= count) {
+		ret = __ptr_ring_produce(&ring, &count);
+		if (ret) {
+			fprintf(stderr, "produce failed: %d\n", ret);
+			goto out;
+		}
+
+		ptr = __ptr_ring_consume(&ring);
+		if (ptr != &count)  {
+			fprintf(stderr, "consume failed: %p\n", ptr);
+			goto out;
+		}
+	}
+
+	gettimeofday(&end, NULL);
+	sec = (end.tv_sec - start.tv_sec);
+	us = ((sec * 1000000) + end.tv_usec) - (start.tv_usec);
+	printf("ptr_ring(size:%d) perf simple test for %d times, took %ld us\n",
+	       size, count, us);
+
+out:
+	ptr_ring_cleanup(&ring, NULL);
+}
+
+int main(int argc, char *argv[])
+{
+	int count = 1000000;
+	int size = 1000;
+	int mode = 0;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "N:s:m:")) != -1) {
+		switch (opt) {
+		case 'N':
+			count = atoi(optarg);
+			break;
+		case 's':
+			size = atoi(optarg);
+			break;
+		case 'm':
+			mode = atoi(optarg);
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	if (count <= 0) {
+		fprintf(stderr, "invalid test count, must be > 0\n");
+		return -1;
+	}
+
+	if (size < MIN_RING_SIZE || size > MAX_RING_SIZE) {
+		fprintf(stderr, "invalid ring size, must be in %d-%d\n",
+			MIN_RING_SIZE, MAX_RING_SIZE);
+		return -1;
+	}
+
+	switch (mode) {
+	case 0:
+		simple_test(size, count);
+		break;
+	case 1:
+		spsc_test(size, count);
+		break;
+	default:
+		fprintf(stderr, "invalid test mode\n");
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/ptr_ring/ptr_ring_test.h b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
new file mode 100644
index 0000000..6bf2494
--- /dev/null
+++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _TEST_PTR_RING_IMPL_H
+#define _TEST_PTR_RING_IMPL_H
+
+#if defined(__x86_64__) || defined(__i386__)
+static inline void cpu_relax(void)
+{
+	asm volatile ("rep; nop" ::: "memory");
+}
+#elif defined(__aarch64__)
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+#else
+#define cpu_relax() assert(0)
+#endif
+
+static inline void barrier(void)
+{
+	asm volatile("" ::: "memory");
+}
+
+/*
+ * This abuses the atomic builtins for thread fences, and
+ * adds a compiler barrier.
+ */
+#define smp_release() do { \
+	barrier(); \
+	__atomic_thread_fence(__ATOMIC_RELEASE); \
+} while (0)
+
+#define smp_acquire() do { \
+	__atomic_thread_fence(__ATOMIC_ACQUIRE); \
+	barrier(); \
+} while (0)
+
+#if defined(__i386__) || defined(__x86_64__)
+#define smp_wmb()		barrier()
+#else
+#define smp_wmb()		smp_release()
+#endif
+
+#define READ_ONCE(x)		(*(volatile typeof(x) *)&(x))
+#define WRITE_ONCE(x, val)	((*(volatile typeof(x) *)&(x)) = (val))
+#define SMP_CACHE_BYTES		64
+#define cache_line_size		SMP_CACHE_BYTES
+#define unlikely(x)		(__builtin_expect(!!(x), 0))
+#define likely(x)		(__builtin_expect(!!(x), 1))
+#define ALIGN(x, a)		(((x) + (a) - 1) / (a) * (a))
+#define SIZE_MAX		(~(size_t)0)
+#define KMALLOC_MAX_SIZE	SIZE_MAX
+#define spinlock_t		pthread_spinlock_t
+#define gfp_t			int
+#define __GFP_ZERO		0x1
+
+#define ____cacheline_aligned_in_smp __attribute__((aligned(SMP_CACHE_BYTES)))
+
+static void *kmalloc(unsigned int size, gfp_t gfp)
+{
+	void *p;
+
+	p = memalign(64, size);
+	if (!p)
+		return p;
+
+	if (gfp & __GFP_ZERO)
+		memset(p, 0, size);
+
+	return p;
+}
+
+static inline void *kzalloc(unsigned int size, gfp_t flags)
+{
+	return kmalloc(size, flags | __GFP_ZERO);
+}
+
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+	return kmalloc(n * size, flags);
+}
+
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
+}
+
+static void kfree(void *p)
+{
+	free(p);
+}
+
+#define kvmalloc_array		kmalloc_array
+#define kvfree			kfree
+
+static void spin_lock_init(spinlock_t *lock)
+{
+	int r = pthread_spin_init(lock, 0);
+
+	assert(!r);
+}
+
+static void spin_lock(spinlock_t *lock)
+{
+	int ret = pthread_spin_lock(lock);
+
+	assert(!ret);
+}
+
+static void spin_unlock(spinlock_t *lock)
+{
+	int ret = pthread_spin_unlock(lock);
+
+	assert(!ret);
+}
+
+static void spin_lock_bh(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static void spin_unlock_bh(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static void spin_lock_irq(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static void spin_unlock_irq(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static void spin_lock_irqsave(spinlock_t *lock, unsigned long f)
+{
+	spin_lock(lock);
+}
+
+static void spin_unlock_irqrestore(spinlock_t *lock, unsigned long f)
+{
+	spin_unlock(lock);
+}
+
+#endif
-- 
2.7.4

