Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAC13B91A0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhGAM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:29:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhGAM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:29:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GFy7W34K8zZjZl;
        Thu,  1 Jul 2021 20:24:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark application for ptr_ring
Date:   Thu, 1 Jul 2021 20:26:40 +0800
Message-ID: <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ptr_ring selftest is embedded within the virtio
selftest, which involves some specific virtio operation,
such as notifying and kicking.

As ptr_ring has been used by various subsystems, it deserves
it's owner selftest in order to benchmark different usecase
of ptr_ring, such as page pool and pfifo_fast qdisc.

So add a simple application to benchmark ptr_ring performance.
Currently two test mode is supported:
Mode 0: Both producing and consuming is done in a single thread,
        it is called simple test mode in the test app.
Mode 1: Producing and consuming is done in different thread
        concurrently, also known as SPSC(single-producer/
        single-consumer) test.

The multi-producer/single-consumer test for pfifo_fast case is
not added yet, which can be added if using CAS atomic operation
to enable lockless multi-producer is proved to be better than
using r->producer_lock.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V3: Remove timestamp sampling, use standard C library as much
    as possible.
---
 MAINTAINERS                                      |   5 +
 tools/testing/selftests/ptr_ring/Makefile        |   6 +
 tools/testing/selftests/ptr_ring/ptr_ring_test.c | 224 +++++++++++++++++++++++
 tools/testing/selftests/ptr_ring/ptr_ring_test.h | 130 +++++++++++++
 4 files changed, 365 insertions(+)
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
index 0000000..4a5312f
--- /dev/null
+++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021 HiSilicon Limited.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <malloc.h>
+#include <stdbool.h>
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
+};
+
+static void *produce_worker(void *arg)
+{
+	struct worker_info *info = arg;
+	unsigned long i = 0;
+	int ret;
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
+	info->error = false;
+
+	return NULL;
+}
+
+static void *consume_worker(void *arg)
+{
+	struct worker_info *info = arg;
+	unsigned long i = 0;
+	int *ptr;
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
+	if (!__ptr_ring_empty(&ring)) {
+		fprintf(stderr, "ring should be empty, test failed\n");
+		info->error = true;
+		return NULL;
+	}
+
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
+	printf("ptr_ring(size:%d) perf spsc test produced/comsumed %d items, finished\n",
+	       size, count);
+out:
+	ptr_ring_cleanup(&ring, NULL);
+}
+
+static void simple_test(int size, int count)
+{
+	struct timeval start, end;
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
+	printf("ptr_ring(size:%d) perf simple test produced/consumed %d items, finished\n",
+	       size, count);
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
+	while ((opt = getopt(argc, argv, "N:s:m:h")) != -1) {
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
+		case 'h':
+			printf("usage: ptr_ring_test [-N COUNT] [-s RING_SIZE] [-m TEST_MODE]\n");
+			return 0;
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
index 0000000..32bfefb
--- /dev/null
+++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _TEST_PTR_RING_TEST_H
+#define _TEST_PTR_RING_TEST_H
+
+#include <assert.h>
+#include <stdatomic.h>
+#include <pthread.h>
+
+/* Assuming the cache line size is 64 for most cpu,
+ * change it accordingly if the running cpu has different
+ * cache line size in order to get more accurate result.
+ */
+#define SMP_CACHE_BYTES	64
+
+#define cpu_relax()	sched_yield()
+#define smp_release()	atomic_thread_fence(memory_order_release)
+#define smp_acquire()	atomic_thread_fence(memory_order_acquire)
+#define smp_wmb()	smp_release()
+#define smp_store_release(p, v)	\
+		atomic_store_explicit(p, v, memory_order_release)
+
+#define READ_ONCE(x)		(*(volatile typeof(x) *)&(x))
+#define WRITE_ONCE(x, val)	((*(volatile typeof(x) *)&(x)) = (val))
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
+#define ____cacheline_aligned_in_smp \
+		__attribute__((aligned(SMP_CACHE_BYTES)))
+
+static inline void *kmalloc(unsigned int size, gfp_t gfp)
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
+static inline void kfree(void *p)
+{
+	free(p);
+}
+
+#define kvmalloc_array		kmalloc_array
+#define kvfree			kfree
+
+static inline void spin_lock_init(spinlock_t *lock)
+{
+	int r = pthread_spin_init(lock, 0);
+
+	assert(!r);
+}
+
+static inline void spin_lock(spinlock_t *lock)
+{
+	int ret = pthread_spin_lock(lock);
+
+	assert(!ret);
+}
+
+static inline void spin_unlock(spinlock_t *lock)
+{
+	int ret = pthread_spin_unlock(lock);
+
+	assert(!ret);
+}
+
+static inline void spin_lock_bh(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_bh(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irq(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irq(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irqsave(spinlock_t *lock,
+				     unsigned long f)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irqrestore(spinlock_t *lock,
+					  unsigned long f)
+{
+	spin_unlock(lock);
+}
+
+#endif
-- 
2.7.4

