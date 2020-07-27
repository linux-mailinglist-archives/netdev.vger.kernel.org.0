Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736D22FC62
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgG0Wo7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727855AbgG0Wo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:56 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfsYd003709
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:54 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:53 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id D8A0C3FAB6F6D; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 10/21] netgpu: add network/gpu/host dma module
Date:   Mon, 27 Jul 2020 15:44:33 -0700
Message-ID: <20200727224444.2987641-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=4 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Netgpu provides a data path for zero-copy sends and receives
without having the host CPU touch the data.  Protocol processing
is done on the host CPU, while data is DMA'd to and from DMA
mapped memory areas.  The initial code provides transfers between
(mlx5 / host memory) and (mlx5 / nvidia GPU memory).

The use case for this module are GPUs used for machine learning,
which are located near the NICs, and have a high bandwidth PCI
connection between the GPU/NIC.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/misc/Kconfig              |    1 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/netgpu/Kconfig       |   14 +
 drivers/misc/netgpu/Makefile      |    6 +
 drivers/misc/netgpu/netgpu_host.c |  284 +++++++
 drivers/misc/netgpu/netgpu_main.c | 1215 +++++++++++++++++++++++++++++
 drivers/misc/netgpu/netgpu_mem.c  |  351 +++++++++
 drivers/misc/netgpu/netgpu_priv.h |   88 +++
 drivers/misc/netgpu/netgpu_stub.c |  166 ++++
 drivers/misc/netgpu/netgpu_stub.h |   19 +
 10 files changed, 2145 insertions(+)
 create mode 100644 drivers/misc/netgpu/Kconfig
 create mode 100644 drivers/misc/netgpu/Makefile
 create mode 100644 drivers/misc/netgpu/netgpu_host.c
 create mode 100644 drivers/misc/netgpu/netgpu_main.c
 create mode 100644 drivers/misc/netgpu/netgpu_mem.c
 create mode 100644 drivers/misc/netgpu/netgpu_priv.h
 create mode 100644 drivers/misc/netgpu/netgpu_stub.c
 create mode 100644 drivers/misc/netgpu/netgpu_stub.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e1b1ba5e2b92..13ae8e55d2a2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -472,4 +472,5 @@ source "drivers/misc/ocxl/Kconfig"
 source "drivers/misc/cardreader/Kconfig"
 source "drivers/misc/habanalabs/Kconfig"
 source "drivers/misc/uacce/Kconfig"
+source "drivers/misc/netgpu/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c7bd01ac6291..216da8b84c86 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_PVPANIC)   	+= pvpanic.o
 obj-$(CONFIG_HABANA_AI)		+= habanalabs/
 obj-$(CONFIG_UACCE)		+= uacce/
 obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
+obj-y				+= netgpu/
diff --git a/drivers/misc/netgpu/Kconfig b/drivers/misc/netgpu/Kconfig
new file mode 100644
index 000000000000..5d8f27ed3a19
--- /dev/null
+++ b/drivers/misc/netgpu/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# NetGPU framework
+#
+config NETGPU
+	tristate "Network/GPU driver"
+	depends on PCI
+	imply NETGPU_STUB
+	help
+	  Experimental Network / GPU driver
+
+config NETGPU_STUB
+	bool
+	depends on NETGPU = m
diff --git a/drivers/misc/netgpu/Makefile b/drivers/misc/netgpu/Makefile
new file mode 100644
index 000000000000..bec4eb5ea04f
--- /dev/null
+++ b/drivers/misc/netgpu/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_NETGPU) := netgpu.o
+netgpu-y := netgpu_mem.o netgpu_main.o netgpu_host.o
+
+obj-$(CONFIG_NETGPU_STUB) := netgpu_stub.o
diff --git a/drivers/misc/netgpu/netgpu_host.c b/drivers/misc/netgpu/netgpu_host.c
new file mode 100644
index 000000000000..ea84f8cae671
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_host.c
@@ -0,0 +1,284 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/memory.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/indirect_call_wrapper.h>
+
+#include <net/netgpu.h>
+#include <uapi/misc/netgpu.h>
+
+#include "netgpu_priv.h"
+
+struct netgpu_host_region {
+	struct netgpu_region r;				/* must be first */
+	struct page **page;
+};
+
+struct netgpu_host_dmamap {
+	struct netgpu_dmamap map;			/* must be first */
+	dma_addr_t dma[];
+};
+
+static inline struct netgpu_host_region *
+host_region(struct netgpu_region *r)
+{
+	return (struct netgpu_host_region *)r;
+}
+
+static inline struct netgpu_host_dmamap *
+host_map(struct netgpu_dmamap *map)
+{
+	return (struct netgpu_host_dmamap *)map;
+}
+
+/* Used by the lib/iov_iter to obtain a set of pages for TX */
+INDIRECT_CALLABLE_SCOPE int
+netgpu_host_get_pages(struct netgpu_region *r, struct page **pages,
+		      unsigned long addr, int count)
+{
+	unsigned long idx;
+	struct page *p;
+	int i, n;
+
+	idx = (addr - r->start) >> PAGE_SHIFT;
+	n = r->nr_pages - idx + 1;
+	n = min(count, n);
+
+	for (i = 0; i < n; i++) {
+		p = host_region(r)->page[idx + i];
+		get_page(p);
+		pages[i] = p;
+	}
+
+	return n;
+}
+
+INDIRECT_CALLABLE_SCOPE int
+netgpu_host_get_page(struct netgpu_dmamap *map, unsigned long addr,
+		     struct page **page, dma_addr_t *dma)
+{
+	unsigned long idx;
+
+	idx = (addr - map->start) >> PAGE_SHIFT;
+
+	*dma = host_map(map)->dma[idx];
+	*page = host_region(map->r)->page[idx];
+	get_page(*page);
+
+	return 0;
+}
+
+INDIRECT_CALLABLE_SCOPE dma_addr_t
+netgpu_host_get_dma(struct netgpu_dmamap *map, unsigned long addr)
+{
+	unsigned long idx;
+
+	idx = (addr - map->start) >> PAGE_SHIFT;
+	return host_map(map)->dma[idx];
+}
+
+static void
+netgpu_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &user->locked_vm);
+}
+
+static int
+netgpu_account_mem(struct user_struct *user, unsigned long nr_pages)
+{
+	unsigned long page_limit, cur_pages, new_pages;
+
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	do {
+		cur_pages = atomic_long_read(&user->locked_vm);
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
+				     new_pages) != cur_pages);
+
+	return 0;
+}
+
+static void
+netgpu_host_unmap_region(struct netgpu_dmamap *map)
+{
+	int i;
+
+	for (i = 0; i < map->nr_pages; i++)
+		dma_unmap_page(map->device, host_map(map)->dma[i],
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
+}
+
+static struct netgpu_dmamap *
+netgpu_host_map_region(struct netgpu_region *r, struct device *device)
+{
+	struct netgpu_dmamap *map;
+	struct page *page;
+	dma_addr_t dma;
+	size_t sz;
+	int i;
+
+	sz = struct_size(host_map(map), dma, r->nr_pages);
+	map = kvmalloc(sz, GFP_KERNEL);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < r->nr_pages; i++) {
+		page = host_region(r)->page[i];
+		dma = dma_map_page(device, page, 0, PAGE_SIZE,
+				   DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(device, dma)))
+			goto out;
+
+		host_map(map)->dma[i] = dma;
+	}
+
+	return map;
+
+out:
+	while (i--)
+		dma_unmap_page(device, host_map(map)->dma[i], PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+
+	kvfree(map);
+	return ERR_PTR(-ENXIO);
+}
+
+/* NOTE: nr_pages may be negative on error. */
+static void
+netgpu_host_put_pages(struct netgpu_region *r, int nr_pages, bool clear)
+{
+	struct page *page;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = host_region(r)->page[i];
+		if (clear) {
+			ClearPagePrivate(page);
+			set_page_private(page, 0);
+		}
+		put_page(page);
+	}
+}
+
+static void
+netgpu_host_free_region(struct netgpu_mem *mem, struct netgpu_region *r)
+{
+
+	netgpu_host_put_pages(r, r->nr_pages, true);
+	if (mem->account_mem)
+		netgpu_unaccount_mem(mem->user, r->nr_pages);
+	kvfree(host_region(r)->page);
+	kfree(r);
+}
+
+static int
+netgpu_assign_page_addrs(struct netgpu_region *r)
+{
+	struct page *page;
+	int i;
+
+	for (i = 0; i < r->nr_pages; i++) {
+		page = host_region(r)->page[i];
+		if (PagePrivate(page))
+			goto out;
+		SetPagePrivate(page);
+		set_page_private(page, r->start + i * PAGE_SIZE);
+	}
+
+	return 0;
+
+out:
+	while (i--) {
+		page = host_region(r)->page[i];
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+	}
+
+	return -EEXIST;
+}
+
+static struct netgpu_region *
+netgpu_host_add_region(struct netgpu_mem *mem, const struct iovec *iov)
+{
+	struct netgpu_region *r;
+	int err, nr_pages;
+	u64 addr, len;
+	int count = 0;
+
+	err = -ENOMEM;
+	r = kzalloc(sizeof(struct netgpu_host_region), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(err);
+
+	addr = (u64)iov->iov_base;
+	r->start = round_down(addr, PAGE_SIZE);
+	len = round_up(addr - r->start + iov->iov_len, PAGE_SIZE);
+	nr_pages = len >> PAGE_SHIFT;
+
+	r->mem = mem;
+	r->nr_pages = nr_pages;
+	INIT_LIST_HEAD(&r->ctx_list);
+	INIT_LIST_HEAD(&r->dma_list);
+	spin_lock_init(&r->lock);
+
+	host_region(r)->page = kvmalloc_array(nr_pages, sizeof(struct page *),
+					      GFP_KERNEL);
+	if (!host_region(r)->page)
+		goto out;
+
+	if (mem->account_mem) {
+		err = netgpu_account_mem(mem->user, nr_pages);
+		if (err) {
+			nr_pages = 0;
+			goto out;
+		}
+	}
+
+	mmap_read_lock(current->mm);
+	count = pin_user_pages(r->start, nr_pages,
+			       FOLL_WRITE | FOLL_LONGTERM,
+			       host_region(r)->page, NULL);
+	mmap_read_unlock(current->mm);
+
+	if (count != nr_pages) {
+		err = count < 0 ? count : -EFAULT;
+		goto out;
+	}
+
+	err = netgpu_assign_page_addrs(r);
+	if (err)
+		goto out;
+
+	return r;
+
+out:
+	netgpu_host_put_pages(r, count, false);
+	if (mem->account_mem && nr_pages)
+		netgpu_unaccount_mem(mem->user, nr_pages);
+	kvfree(host_region(r)->page);
+	kfree(r);
+
+	return ERR_PTR(err);
+}
+
+struct netgpu_ops host_ops = {
+	.owner		= THIS_MODULE,
+	.memtype	= NETGPU_MEMTYPE_HOST,
+	.add_region	= netgpu_host_add_region,
+	.free_region	= netgpu_host_free_region,
+	.map_region	= netgpu_host_map_region,
+	.unmap_region	= netgpu_host_unmap_region,
+	.get_dma	= netgpu_host_get_dma,
+	.get_page	= netgpu_host_get_page,
+	.get_pages	= netgpu_host_get_pages,
+};
diff --git a/drivers/misc/netgpu/netgpu_main.c b/drivers/misc/netgpu/netgpu_main.c
new file mode 100644
index 000000000000..54264fb46d18
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_main.c
@@ -0,0 +1,1215 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/memory.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/anon_inodes.h>
+#include <linux/indirect_call_wrapper.h>
+
+#include <net/tcp.h>
+
+#include <net/netgpu.h>
+#include <uapi/misc/netgpu.h>
+#include "netgpu_priv.h"
+
+static struct mutex netgpu_lock;
+static const struct file_operations netgpu_fops;
+static void netgpu_free_ctx(struct netgpu_ctx *ctx);
+
+INDIRECT_CALLABLE_DECLARE(dma_addr_t
+	netgpu_host_get_dma(struct netgpu_dmamap *map, unsigned long addr));
+INDIRECT_CALLABLE_DECLARE(int
+	netgpu_host_get_page(struct netgpu_dmamap *map, unsigned long addr,
+			     struct page **page, dma_addr_t *dma));
+INDIRECT_CALLABLE_DECLARE(int
+	netgpu_host_get_pages(struct netgpu_region *r, struct page **pages,
+			      unsigned long addr, int count));
+
+#if IS_MODULE(CONFIG_NETGPU)
+#define MAYBE_EXPORT_SYMBOL(s)
+#else
+#define MAYBE_EXPORT_SYMBOL(s)	EXPORT_SYMBOL(s)
+#endif
+
+#define NETGPU_CACHE_COUNT	63
+
+enum netgpu_match_id {
+	NETGPU_MATCH_TCP6,
+	NETGPU_MATCH_UDP6,
+	NETGPU_MATCH_TCP,
+	NETGPU_MATCH_UDP,
+};
+
+struct netgpu_sock_match {
+	u16 family;
+	u16 type;
+	u16 protocol;
+	u16 initialized;
+	struct proto *base_prot;
+	const struct proto_ops *base_ops;
+	struct proto prot;
+	struct proto_ops ops;
+};
+
+static struct netgpu_sock_match netgpu_match_tbl[] = {
+	[NETGPU_MATCH_TCP6] = {
+		.family		= AF_INET6,
+		.type		= SOCK_STREAM,
+		.protocol	= IPPROTO_TCP,
+	},
+	[NETGPU_MATCH_UDP6] = {
+		.family		= AF_INET6,
+		.type		= SOCK_DGRAM,
+		.protocol	= IPPROTO_UDP,
+	},
+	[NETGPU_MATCH_TCP] = {
+		.family		= AF_INET,
+		.type		= SOCK_STREAM,
+		.protocol	= IPPROTO_TCP,
+	},
+	[NETGPU_MATCH_UDP] = {
+		.family		= AF_INET,
+		.type		= SOCK_DGRAM,
+		.protocol	= IPPROTO_UDP,
+	},
+};
+
+static void
+__netgpu_put_page_any(struct netgpu_ifq *ifq, struct page *page)
+{
+	struct netgpu_pgcache *cache = ifq->any_cache;
+	unsigned count;
+	size_t sz;
+
+	/* unsigned: count == -1 if !cache, so the check will fail. */
+	count = ifq->any_cache_count;
+	if (count < NETGPU_CACHE_COUNT) {
+		cache->page[count] = page;
+		ifq->any_cache_count = count + 1;
+		return;
+	}
+
+	sz = struct_size(cache, page, NETGPU_CACHE_COUNT);
+	cache = kmalloc(sz, GFP_ATOMIC);
+	if (!cache) {
+		/* XXX fixme */
+		pr_err("netgpu: addr 0x%lx lost to overflow\n",
+		       page_private(page));
+		return;
+	}
+	cache->next = ifq->any_cache;
+
+	cache->page[0] = page;
+	ifq->any_cache = cache;
+	ifq->any_cache_count = 1;
+}
+
+static void
+netgpu_put_page_any(struct netgpu_ifq *ifq, struct page *page)
+{
+	spin_lock(&ifq->pgcache_lock);
+
+	__netgpu_put_page_any(ifq, page);
+
+	spin_unlock(&ifq->pgcache_lock);
+}
+
+static void
+netgpu_put_page_napi(struct netgpu_ifq *ifq, struct page *page)
+{
+	struct netgpu_pgcache *spare;
+	unsigned count;
+	size_t sz;
+
+	count = ifq->napi_cache_count;
+	if (count < NETGPU_CACHE_COUNT) {
+		ifq->napi_cache->page[count] = page;
+		ifq->napi_cache_count = count + 1;
+		return;
+	}
+
+	spare = ifq->spare_cache;
+	if (spare) {
+		ifq->spare_cache = NULL;
+		goto out;
+	}
+
+	sz = struct_size(spare, page, NETGPU_CACHE_COUNT);
+	spare = kmalloc(sz, GFP_ATOMIC);
+	if (!spare) {
+		pr_err("netgpu: addr 0x%lx lost to overflow\n",
+		       page_private(page));
+		return;
+	}
+	spare->next = ifq->napi_cache;
+
+out:
+	spare->page[0] = page;
+	ifq->napi_cache = spare;
+	ifq->napi_cache_count = 1;
+}
+
+void
+netgpu_put_page(struct netgpu_ifq *ifq, struct page *page, bool napi)
+{
+	if (napi)
+		netgpu_put_page_napi(ifq, page);
+	else
+		netgpu_put_page_any(ifq, page);
+}
+MAYBE_EXPORT_SYMBOL(netgpu_put_page);
+
+static int
+netgpu_swap_caches(struct netgpu_ifq *ifq, struct netgpu_pgcache **cachep)
+{
+	int count;
+
+	spin_lock(&ifq->pgcache_lock);
+
+	count = ifq->any_cache_count;
+	*cachep = ifq->any_cache;
+	ifq->any_cache = ifq->napi_cache;
+	ifq->any_cache_count = 0;
+
+	spin_unlock(&ifq->pgcache_lock);
+
+	return count;
+}
+
+static struct page *
+netgpu_get_cached_page(struct netgpu_ifq *ifq)
+{
+	struct netgpu_pgcache *cache = ifq->napi_cache;
+	struct page *page;
+	int count;
+
+	count = ifq->napi_cache_count;
+
+	if (!count) {
+		if (cache->next) {
+			kfree(ifq->spare_cache);
+			ifq->spare_cache = cache;
+			cache = cache->next;
+			count = NETGPU_CACHE_COUNT;
+			goto out;
+		}
+
+		/* lockless read of any count - if <= 0, skip */
+		count = READ_ONCE(ifq->any_cache_count);
+		if (count > 0) {
+			count = netgpu_swap_caches(ifq, &cache);
+			goto out;
+		}
+
+		return NULL;
+out:
+		ifq->napi_cache = cache;
+	}
+
+	page = cache->page[--count];
+	ifq->napi_cache_count = count;
+
+	return page;
+}
+
+/*
+ * Free cache structures.  Pages have already been released.
+ */
+static void
+netgpu_free_cache(struct netgpu_ifq *ifq)
+{
+	struct netgpu_pgcache *cache, *next;
+
+	kfree(ifq->spare_cache);
+
+	for (cache = ifq->napi_cache; cache; cache = next) {
+		next = cache->next;
+		kfree(cache);
+	}
+
+	for (cache = ifq->any_cache; cache; cache = next) {
+		next = cache->next;
+		kfree(cache);
+	}
+}
+
+/*
+ * Called from iov_iter when addr is provided for TX.
+ */
+int
+netgpu_get_pages(struct sock *sk, struct page **pages, unsigned long addr,
+		 int count)
+{
+	struct netgpu_dmamap *map;
+	struct netgpu_skq *skq;
+
+	skq = sk->sk_user_data;
+	if (!skq)
+		return -EEXIST;
+
+	map = xa_load(&skq->ctx->xa, addr >> PAGE_SHIFT);
+	if (!map)
+		return -EINVAL;
+
+	return INDIRECT_CALL_1(map->get_pages, netgpu_host_get_pages,
+			       map->r, pages, addr, count);
+}
+
+static int
+netgpu_get_fill_page(struct netgpu_ifq *ifq, dma_addr_t *dma,
+		     struct page **page)
+{
+	struct netgpu_dmamap *map;
+	u64 *addrp, addr;
+	int err;
+
+	addrp = sq_cons_peek(&ifq->fill);
+	if (!addrp)
+		return -ENOMEM;
+
+	addr = READ_ONCE(*addrp);
+
+	map = xa_load(&ifq->ctx->xa, addr >> PAGE_SHIFT);
+	if (!map)
+		return -EINVAL;
+
+	err = INDIRECT_CALL_1(map->get_page, netgpu_host_get_page,
+			      map, addr, page, dma);
+
+	if (!err)
+		sq_cons_advance(&ifq->fill);
+
+	return err;
+}
+
+dma_addr_t
+netgpu_get_dma(struct netgpu_ctx *ctx, struct page *page)
+{
+	struct netgpu_dmamap *map;
+	unsigned long addr;
+
+	addr = page_private(page);
+	map = xa_load(&ctx->xa, addr >> PAGE_SHIFT);
+
+	return INDIRECT_CALL_1(map->get_dma, netgpu_host_get_dma,
+			       map, addr);
+}
+MAYBE_EXPORT_SYMBOL(netgpu_get_dma);
+
+int
+netgpu_get_page(struct netgpu_ifq *ifq, struct page **page, dma_addr_t *dma)
+{
+	*page = netgpu_get_cached_page(ifq);
+	if (*page) {
+		get_page(*page);
+		*dma = netgpu_get_dma(ifq->ctx, *page);
+		return 0;
+	}
+
+	return netgpu_get_fill_page(ifq, dma, page);
+}
+MAYBE_EXPORT_SYMBOL(netgpu_get_page);
+
+static int
+netgpu_shared_queue_validate(struct netgpu_user_queue *u, unsigned elt_size,
+			     unsigned map_off)
+{
+	struct netgpu_queue_map *map;
+	unsigned count;
+	size_t size;
+
+	if (u->elt_sz != elt_size)
+		return -EINVAL;
+
+	count = roundup_pow_of_two(u->entries);
+	if (!count)
+		return -EINVAL;
+	u->entries = count;
+	u->mask = count - 1;
+	u->map_off = map_off;
+
+	size = struct_size(map, data, count * elt_size);
+	if (size == SIZE_MAX || size > U32_MAX)
+		return -EOVERFLOW;
+	u->map_sz = size;
+
+	return 0;
+}
+
+static void
+netgpu_shared_queue_free(struct shared_queue *q)
+{
+	free_pages((uintptr_t)q->map_ptr, get_order(q->map_sz));
+}
+
+static int
+netgpu_shared_queue_create(struct shared_queue *q, struct netgpu_user_queue *u)
+{
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
+			  __GFP_COMP | __GFP_NORETRY;
+	struct netgpu_queue_map *map;
+
+	map = (void *)__get_free_pages(gfp_flags, get_order(u->map_sz));
+	if (!map)
+		return -ENOMEM;
+
+	q->map_ptr = map;
+	q->prod = &map->prod;
+	q->cons = &map->cons;
+	q->data = &map->data[0];
+	q->elt_sz = u->elt_sz;
+	q->mask = u->mask;
+	q->entries = u->entries;
+	q->map_sz = u->map_sz;
+
+	memset(&u->off, 0, sizeof(u->off));
+	u->off.prod = offsetof(struct netgpu_queue_map, prod);
+	u->off.cons = offsetof(struct netgpu_queue_map, cons);
+	u->off.data = offsetof(struct netgpu_queue_map, data);
+
+	return 0;
+}
+
+static int
+__netgpu_queue_mgmt(struct net_device *dev, struct netgpu_ifq *ifq,
+		    u32 *queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+	int err;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	cmd.command = XDP_SETUP_NETGPU;
+	cmd.netgpu.ifq = ifq;
+	cmd.netgpu.queue_id = *queue_id;
+
+	err = ndo_bpf(dev, &cmd);
+	if (!err)
+		*queue_id = cmd.netgpu.queue_id;
+
+	return err;
+}
+
+static int
+netgpu_open_queue(struct netgpu_ifq *ifq, u32 *queue_id)
+{
+	return __netgpu_queue_mgmt(ifq->ctx->dev, ifq, queue_id);
+}
+
+static int
+netgpu_close_queue(struct netgpu_ifq *ifq, u32 queue_id)
+{
+	return __netgpu_queue_mgmt(ifq->ctx->dev, NULL, &queue_id);
+}
+
+static int
+netgpu_mmap(void *priv, struct vm_area_struct *vma,
+	    void *(*validate_request)(void *priv, loff_t, size_t))
+{
+	size_t sz = vma->vm_end - vma->vm_start;
+	unsigned long pfn;
+	void *ptr;
+
+	ptr = validate_request(priv, vma->vm_pgoff, sz);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+static void *
+netgpu_validate_ifq_mmap_request(void *priv, loff_t pgoff, size_t sz)
+{
+	struct netgpu_ifq *ifq = priv;
+	struct page *page;
+	void *ptr;
+
+	/* each returned ptr is a separate allocation. */
+	switch (pgoff << PAGE_SHIFT) {
+	case NETGPU_OFF_FILL_ID:
+		ptr = ifq->fill.map_ptr;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	page = virt_to_head_page(ptr);
+	if (sz > page_size(page))
+		return ERR_PTR(-EINVAL);
+
+	return ptr;
+}
+
+static int
+netgpu_ifq_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return netgpu_mmap(file->private_data, vma,
+			   netgpu_validate_ifq_mmap_request);
+}
+
+static void
+netgpu_free_ifq(struct netgpu_ifq *ifq)
+{
+	/* assume ifq has been released from ifq list */
+	if (ifq->queue_id != -1)
+		netgpu_close_queue(ifq, ifq->queue_id);
+	netgpu_shared_queue_free(&ifq->fill);
+	netgpu_free_cache(ifq);
+	kfree(ifq);
+}
+
+static int
+netgpu_ifq_release(struct inode *inode, struct file *file)
+{
+	struct netgpu_ifq *ifq = file->private_data;
+	struct netgpu_ctx *ctx = ifq->ctx;
+
+	/* CTX LOCKING */
+	list_del(&ifq->ifq_node);
+	netgpu_free_ifq(ifq);
+
+	netgpu_free_ctx(ctx);
+	return 0;
+}
+
+#if 0
+static int
+netgpu_ifq_wakeup(struct netgpu_ifq *ifq)
+{
+	struct net_device *dev = ifq->ctx->dev;
+	int err;
+
+	rcu_read_lock();
+	err = dev->netdev_ops->ndo_xsk_wakeup(dev, ifq->queue_id, flags);
+	rcu_read_unlock();
+
+	return err;
+}
+#endif
+
+static __poll_t
+netgpu_ifq_poll(struct file *file, poll_table *wait)
+{
+	struct netgpu_ifq *ifq = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &ifq->fill_wait, wait);
+
+	if (sq_prod_space(&ifq->fill))
+		mask = EPOLLOUT | EPOLLWRNORM;
+
+#if 0
+	if (driver is asleep because fq is/was empty)
+		netgpu_ifq_wakeup(ifq);
+#endif
+
+	return mask;
+}
+
+static const struct file_operations netgpu_ifq_fops = {
+	.owner =		THIS_MODULE,
+	.mmap =			netgpu_ifq_mmap,
+	.poll =			netgpu_ifq_poll,
+	.release =		netgpu_ifq_release,
+};
+
+static int
+netgpu_create_fd(struct netgpu_ifq *ifq, struct file **filep)
+{
+	struct file *file;
+	unsigned flags;
+	int fd;
+
+	flags = O_RDWR | O_CLOEXEC;
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+
+	file = anon_inode_getfile("[netgpu]", &netgpu_ifq_fops, ifq, flags);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		return PTR_ERR(file);
+	}
+
+	*filep = file;
+	return fd;
+}
+
+static struct netgpu_ifq *
+netgpu_alloc_ifq(void)
+{
+	struct netgpu_ifq *ifq;
+	size_t sz;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	sz = struct_size(ifq->napi_cache, page, NETGPU_CACHE_COUNT);
+	ifq->napi_cache = kmalloc(sz, GFP_KERNEL);
+	if (!ifq->napi_cache)
+		goto out;
+	ifq->napi_cache->next = NULL;
+
+	ifq->queue_id = -1;
+	ifq->any_cache_count = -1;
+	spin_lock_init(&ifq->pgcache_lock);
+
+	return ifq;
+
+out:
+	kfree(ifq->napi_cache);
+	kfree(ifq);
+
+	return NULL;
+}
+
+static int
+netgpu_bind_queue(struct netgpu_ctx *ctx, void __user *arg)
+{
+	struct netgpu_ifq_param p;
+	struct file *file = NULL;
+	struct netgpu_ifq *ifq;
+	int err;
+
+	if (!ctx->dev)
+		return -ENODEV;
+
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	if (p.resv != 0)
+		return -EINVAL;
+
+	if (p.queue_id != -1) {
+	        list_for_each_entry(ifq, &ctx->ifq_list, ifq_node)
+			if (ifq->queue_id == p.queue_id)
+				return -EALREADY;
+	}
+
+	err = netgpu_shared_queue_validate(&p.fill, sizeof(u64),
+					   NETGPU_OFF_FILL_ID);
+	if (err)
+		return err;
+
+	ifq = netgpu_alloc_ifq();
+	if (!ifq)
+		return -ENOMEM;
+	ifq->ctx = ctx;
+
+	err = netgpu_shared_queue_create(&ifq->fill, &p.fill);
+	if (err)
+		goto out;
+
+	err = netgpu_open_queue(ifq, &p.queue_id);
+	if (err)
+		goto out;
+	ifq->queue_id = p.queue_id;
+
+	p.ifq_fd = netgpu_create_fd(ifq, &file);
+	if (p.ifq_fd < 0) {
+		err = p.ifq_fd;
+		goto out;
+	}
+
+	if (copy_to_user(arg, &p, sizeof(p))) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	fd_install(p.ifq_fd, file);
+	list_add(&ifq->ifq_node, &ctx->ifq_list);
+	refcount_inc(&ctx->ref);
+
+	return 0;
+
+out:
+	if (file) {
+		fput(file);
+		put_unused_fd(p.ifq_fd);
+	}
+	netgpu_free_ifq(ifq);
+
+	return err;
+}
+
+static bool
+netgpu_region_overlap(struct netgpu_ctx *ctx, struct netgpu_dmamap *map)
+{
+	unsigned long index, last;
+
+	index = map->start >> PAGE_SHIFT;
+	last = index + map->nr_pages - 1;
+
+	return xa_find(&ctx->xa, &index, last, XA_PRESENT) != NULL;
+}
+
+struct netgpu_dmamap *
+netgpu_ctx_detach_region(struct netgpu_ctx *ctx, struct netgpu_region *r)
+{
+	struct netgpu_dmamap *map;
+	unsigned long start;
+
+	start = r->start >> PAGE_SHIFT;
+	map = xa_load(&ctx->xa, start);
+	xa_store_range(&ctx->xa, start, start + r->nr_pages - 1,
+		       NULL, GFP_KERNEL);
+
+	return map;
+}
+
+static int
+netgpu_attach_region(struct netgpu_ctx *ctx, void __user *arg)
+{
+	struct netgpu_attach_param p;
+	struct netgpu_dmamap *map;
+	struct netgpu_mem *mem;
+	unsigned long start;
+	struct fd f;
+	int err;
+
+	if (!ctx->dev)
+		return -ENODEV;
+
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	f = fdget(p.mem_fd);
+	if (!f.file)
+		return -EBADF;
+
+	if (f.file->f_op != &netgpu_mem_fops) {
+		fdput(f);
+		return -EOPNOTSUPP;
+	}
+
+	mem = f.file->private_data;
+	map = netgpu_mem_attach_ctx(mem, p.mem_idx, ctx);
+	if (IS_ERR(map)) {
+		fdput(f);
+		return PTR_ERR(map);
+	}
+
+	/* XXX "should not happen", validate anyway */
+	if (netgpu_region_overlap(ctx, map)) {
+		netgpu_map_detach_ctx(map, ctx);
+		return -EEXIST;
+	}
+
+	start = map->start >> PAGE_SHIFT;
+	err = xa_err(xa_store_range(&ctx->xa, start, start + map->nr_pages - 1,
+				    map, GFP_KERNEL));
+	if (err)
+		netgpu_map_detach_ctx(map, ctx);
+
+	return err;
+}
+
+static int
+netgpu_attach_dev(struct netgpu_ctx *ctx, void __user *arg)
+{
+	struct net_device *dev;
+	int ifindex;
+	int err;
+
+	if (copy_from_user(&ifindex, arg, sizeof(ifindex)))
+		return -EFAULT;
+
+	dev = dev_get_by_index(&init_net, ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	if (ctx->dev) {
+		err = dev == ctx->dev ? 0 : -EALREADY;
+		dev_put(dev);
+		return err;
+	}
+
+	ctx->dev = dev;
+
+	return 0;
+}
+
+static struct netgpu_ctx *
+netgpu_file_to_ctx(struct file *file)
+{
+	return file->private_data;
+}
+
+static long
+netgpu_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	struct netgpu_ctx *ctx = netgpu_file_to_ctx(file);
+
+	switch (cmd) {
+	case NETGPU_CTX_IOCTL_ATTACH_DEV:
+		return netgpu_attach_dev(ctx, (void __user *)arg);
+
+	case NETGPU_CTX_IOCTL_BIND_QUEUE:
+		return netgpu_bind_queue(ctx, (void __user *)arg);
+
+	case NETGPU_CTX_IOCTL_ATTACH_REGION:
+		return netgpu_attach_region(ctx, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
+
+static void
+__netgpu_free_ctx(struct netgpu_ctx *ctx)
+{
+	struct netgpu_dmamap *map;
+	unsigned long index;
+
+	xa_for_each(&ctx->xa, index, map) {
+		index = (map->start >> PAGE_SHIFT) + map->nr_pages - 1;
+		netgpu_map_detach_ctx(map, ctx);
+	}
+
+	xa_destroy(&ctx->xa);
+
+	if (ctx->dev)
+		dev_put(ctx->dev);
+	kfree(ctx);
+
+	module_put(THIS_MODULE);
+}
+
+static void
+netgpu_free_ctx(struct netgpu_ctx *ctx)
+{
+	if (refcount_dec_and_test(&ctx->ref))
+		__netgpu_free_ctx(ctx);
+}
+
+static int
+netgpu_release(struct inode *inode, struct file *file)
+{
+	struct netgpu_ctx *ctx = netgpu_file_to_ctx(file);
+
+	netgpu_free_ctx(ctx);
+	return 0;
+}
+
+static struct netgpu_ctx *
+netgpu_alloc_ctx(void)
+{
+	struct netgpu_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	xa_init(&ctx->xa);
+	refcount_set(&ctx->ref, 1);
+	INIT_LIST_HEAD(&ctx->ifq_list);
+
+	return ctx;
+}
+
+static int
+netgpu_open(struct inode *inode, struct file *file)
+{
+	struct netgpu_ctx *ctx;
+
+	ctx = netgpu_alloc_ctx();
+	if (!ctx)
+		return -ENOMEM;
+
+	file->private_data = ctx;
+
+	__module_get(THIS_MODULE);
+
+	return 0;
+}
+
+static const struct file_operations netgpu_fops = {
+	.owner =		THIS_MODULE,
+	.open =			netgpu_open,
+	.unlocked_ioctl =	netgpu_ioctl,
+	.release =		netgpu_release,
+};
+
+static struct miscdevice netgpu_dev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "netgpu",
+	.fops		= &netgpu_fops,
+};
+
+/* Our version of __skb_datagram_iter */
+static int
+netgpu_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+		unsigned int offset, size_t len)
+{
+	struct netgpu_skq *skq = desc->arg.data;
+	struct sk_buff *frag_iter;
+	struct iovec *iov;
+	struct page *page;
+	unsigned start;
+	int i, used;
+	u64 addr;
+
+	if (skb_headlen(skb)) {
+		WARN_ONCE(1, "zc socket receiving non-zc data");
+		return -EFAULT;
+	}
+
+	used = 0;
+	start = 0;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag;
+		int end, off, frag_len;
+
+		frag = &skb_shinfo(skb)->frags[i];
+		frag_len = skb_frag_size(frag);
+
+		end = start + frag_len;
+		if (offset < end) {
+			off = offset - start;
+
+			iov = sq_prod_reserve(&skq->rx);
+			if (!iov)
+				break;
+
+			page = skb_frag_page(frag);
+			addr = (u64)page_private(page) + off;
+
+			iov->iov_base = (void *)(addr + skb_frag_off(frag));
+			iov->iov_len = frag_len - off;
+
+			used += (frag_len - off);
+			offset += (frag_len - off);
+
+			put_page(page);
+			__skb_frag_set_page(frag, NULL);
+		}
+		start = end;
+	}
+
+	if (used)
+		sq_prod_submit(&skq->rx);
+
+	skb_walk_frags(skb, frag_iter) {
+		int end, off, ret;
+
+		end = start + frag_iter->len;
+		if (offset < end) {
+			off = offset - start;
+			len = frag_iter->len - off;
+
+			ret = netgpu_recv_skb(desc, frag_iter, off, len);
+			if (ret < 0) {
+				if (!used)
+					used = ret;
+				goto out;
+			}
+			used += ret;
+			if (ret < len)
+				goto out;
+			offset += ret;
+		}
+		start = end;
+	}
+
+out:
+	return used;
+}
+
+static void
+netgpu_read_sock(struct sock *sk, struct netgpu_skq *skq)
+{
+	read_descriptor_t desc;
+	int used;
+
+	desc.arg.data = skq;
+	desc.count = 1;
+	used = tcp_read_sock(sk, &desc, netgpu_recv_skb);
+}
+
+static void
+netgpu_data_ready(struct sock *sk)
+{
+	struct netgpu_skq *skq = sk->sk_user_data;
+
+	if (skq->rx.entries)
+		netgpu_read_sock(sk, skq);
+
+	skq->sk_data_ready(sk);
+}
+
+static bool
+netgpu_stream_memory_read(const struct sock *sk)
+{
+	struct netgpu_skq *skq = sk->sk_user_data;
+
+	return !sq_is_empty(&skq->rx);
+}
+
+static void *
+netgpu_validate_skq_mmap_request(void *priv, loff_t pgoff, size_t sz)
+{
+	struct netgpu_skq *skq = priv;
+	struct page *page;
+	void *ptr;
+
+	/* each returned ptr is a separate allocation. */
+	switch (pgoff << PAGE_SHIFT) {
+	case NETGPU_OFF_RX_ID:
+		ptr = skq->rx.map_ptr;
+		break;
+	case NETGPU_OFF_CQ_ID:
+		ptr = skq->cq.map_ptr;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	page = virt_to_head_page(ptr);
+	if (sz > page_size(page))
+		return ERR_PTR(-EINVAL);
+
+	return ptr;
+}
+
+int
+netgpu_socket_mmap(struct file *file, struct socket *sock,
+		struct vm_area_struct *vma)
+{
+	struct sock *sk;
+
+	sk = sock->sk;
+	if (!sk || !sk->sk_user_data)
+		return -EINVAL;
+
+	return netgpu_mmap(sk->sk_user_data, vma,
+			   netgpu_validate_skq_mmap_request);
+}
+
+static void
+netgpu_release_sk(struct sock *sk, struct netgpu_skq *skq)
+{
+	struct netgpu_sock_match *m;
+
+	m = container_of(sk->sk_prot, struct netgpu_sock_match, prot);
+
+	sk->sk_destruct = skq->sk_destruct;
+	sk->sk_data_ready = skq->sk_data_ready;
+	sk->sk_prot = m->base_prot;
+	sk->sk_user_data = NULL;
+
+	/* XXX reclaim and recycle pending data? */
+	netgpu_shared_queue_free(&skq->rx);
+	netgpu_shared_queue_free(&skq->cq);
+	kfree(skq);
+}
+
+static void
+netgpu_skq_destruct(struct sock *sk)
+{
+	struct netgpu_skq *skq = sk->sk_user_data;
+	struct netgpu_ctx *ctx = skq->ctx;
+
+	netgpu_release_sk(sk, skq);
+
+	if (sk->sk_destruct)
+		sk->sk_destruct(sk);
+
+	netgpu_free_ctx(ctx);
+}
+
+static struct netgpu_skq *
+netgpu_create_skq(struct netgpu_socket_param *p)
+{
+	struct netgpu_skq *skq;
+	int err;
+
+	skq = kzalloc(sizeof(*skq), GFP_KERNEL);
+	if (!skq)
+		return ERR_PTR(-ENOMEM);
+
+	err = netgpu_shared_queue_create(&skq->rx, &p->rx);
+	if (err)
+		goto out;
+
+	err = netgpu_shared_queue_create(&skq->cq, &p->cq);
+	if (err)
+		goto out;
+
+	return skq;
+
+out:
+	netgpu_shared_queue_free(&skq->rx);
+	netgpu_shared_queue_free(&skq->cq);
+	kfree(skq);
+
+	return ERR_PTR(err);
+}
+
+static void
+netgpu_rebuild_match(struct netgpu_sock_match *m, struct sock *sk)
+{
+	mutex_lock(&netgpu_lock);
+
+	if (m->initialized)
+		goto out;
+
+	m->base_ops = sk->sk_socket->ops;
+	m->base_prot = sk->sk_prot;
+
+	m->ops = *m->base_ops;
+	m->prot = *m->base_prot;
+
+	/* XXX need UDP specific vector here */
+	m->prot.stream_memory_read = netgpu_stream_memory_read;
+	m->ops.mmap = netgpu_socket_mmap;
+
+	smp_wmb();
+	m->initialized = 1;
+
+out:
+	mutex_unlock(&netgpu_lock);
+}
+
+static int
+netgpu_match_socket(struct sock *sk)
+{
+	struct netgpu_sock_match *m;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(netgpu_match_tbl); i++) {
+		m = &netgpu_match_tbl[i];
+
+		if (m->family != sk->sk_family ||
+		    m->type != sk->sk_type ||
+		    m->protocol != sk->sk_protocol)
+			continue;
+
+		if (!m->initialized)
+			netgpu_rebuild_match(m, sk);
+
+		if (m->base_prot != sk->sk_prot)
+			return -EPROTO;
+
+		if (m->base_ops != sk->sk_socket->ops)
+			return -EPROTO;
+
+		return i;
+	}
+	return -EOPNOTSUPP;
+}
+
+int
+netgpu_attach_socket(struct sock *sk, void __user *arg)
+{
+	struct netgpu_socket_param p;
+	struct netgpu_ctx *ctx;
+	struct netgpu_skq *skq;
+	struct fd f;
+	int id, err;
+
+	if (sk->sk_user_data)
+		return -EALREADY;
+
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	if (p.resv != 0)
+		return -EINVAL;
+
+	err = netgpu_shared_queue_validate(&p.rx, sizeof(struct iovec),
+					   NETGPU_OFF_RX_ID);
+	if (err)
+		return err;
+
+	err = netgpu_shared_queue_validate(&p.cq, sizeof(u64),
+					   NETGPU_OFF_CQ_ID);
+	if (err)
+		return err;
+
+	id = netgpu_match_socket(sk);
+	if (id < 0)
+		return id;
+
+	f = fdget(p.ctx_fd);
+	if (!f.file)
+		return -EBADF;
+
+	if (f.file->f_op != &netgpu_fops) {
+		fdput(f);
+		return -EOPNOTSUPP;
+	}
+
+	skq = netgpu_create_skq(&p);
+	if (IS_ERR(skq)) {
+		fdput(f);
+		return PTR_ERR(skq);
+	}
+
+	ctx = netgpu_file_to_ctx(f.file);
+	refcount_inc(&ctx->ref);
+	skq->ctx = ctx;
+	fdput(f);
+
+	skq->sk_destruct = sk->sk_destruct;
+	skq->sk_data_ready = sk->sk_data_ready;
+
+	sk->sk_destruct = netgpu_skq_destruct;
+	sk->sk_data_ready = netgpu_data_ready;
+	sk->sk_prot = &netgpu_match_tbl[id].prot;
+	sk->sk_socket->ops = &netgpu_match_tbl[id].ops;
+
+	sk->sk_user_data = skq;
+
+	if (copy_to_user(arg, &p, sizeof(p))) {
+		netgpu_release_sk(sk, skq);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+#if IS_MODULE(CONFIG_NETGPU)
+#include "netgpu_stub.h"
+static struct netgpu_functions netgpu_fcn = {
+        .get_dma        = netgpu_get_dma,
+        .get_page       = netgpu_get_page,
+        .put_page       = netgpu_put_page,
+        .get_pages      = netgpu_get_pages,
+        .socket_mmap    = netgpu_socket_mmap,
+        .attach_socket  = netgpu_attach_socket,
+};
+#else
+#define netgpu_fcn_register(x)
+#define netgpu_fcn_unregister()
+#endif
+
+static int __init
+netgpu_init(void)
+{
+	misc_register(&netgpu_dev);
+	misc_register(&netgpu_mem_dev);
+	netgpu_fcn_register(&netgpu_fcn);
+
+	return 0;
+}
+
+static void __exit
+netgpu_fini(void)
+{
+	misc_deregister(&netgpu_dev);
+	misc_deregister(&netgpu_mem_dev);
+	netgpu_fcn_unregister();
+}
+
+module_init(netgpu_init);
+module_exit(netgpu_fini);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/netgpu/netgpu_mem.c b/drivers/misc/netgpu/netgpu_mem.c
new file mode 100644
index 000000000000..184bf77e838c
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_mem.c
@@ -0,0 +1,351 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/memory.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+
+#include <net/netgpu.h>
+#include <uapi/misc/netgpu.h>
+
+#include "netgpu_priv.h"
+
+static struct netgpu_ops *netgpu_ops[MEMTYPE_MAX] = {
+	[MEMTYPE_HOST]	= &host_ops,
+};
+static const char *netgpu_name[] = {
+	[MEMTYPE_HOST]	= "host",
+	[MEMTYPE_CUDA]	= "cuda",
+};
+static DEFINE_SPINLOCK(netgpu_lock);
+
+int
+netgpu_register(struct netgpu_ops *ops)
+{
+	int err;
+
+	if (ops->memtype >= MEMTYPE_MAX)
+		return -EBADR;
+
+	err = -EEXIST;
+	spin_lock(&netgpu_lock);
+	if (!rcu_dereference_protected(netgpu_ops[ops->memtype],
+				       lockdep_is_held(&netgpu_lock))) {
+		rcu_assign_pointer(netgpu_ops[ops->memtype], ops);
+		err = 0;
+	}
+	spin_unlock(&netgpu_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(netgpu_register);
+
+void
+netgpu_unregister(int memtype)
+{
+	BUG_ON(memtype < 0 || memtype >= MEMTYPE_MAX);
+
+	spin_lock(&netgpu_lock);
+	rcu_assign_pointer(netgpu_ops[memtype], NULL);
+	spin_unlock(&netgpu_lock);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL(netgpu_unregister);
+
+static inline struct device *
+netdev2device(struct net_device *dev)
+{
+	return dev->dev.parent;			/* from SET_NETDEV_DEV() */
+}
+
+static struct netgpu_ctx_entry *
+__netgpu_region_find_ctx(struct netgpu_region *r, struct netgpu_ctx *ctx)
+{
+	struct netgpu_ctx_entry *ce;
+
+	list_for_each_entry(ce, &r->ctx_list, ctx_node)
+		if (ce->ctx == ctx)
+			return ce;
+	return NULL;
+}
+
+void
+netgpu_map_detach_ctx(struct netgpu_dmamap *map, struct netgpu_ctx *ctx)
+{
+	struct netgpu_region *r = map->r;
+	struct netgpu_ctx_entry *ce;
+	bool unmap;
+
+	spin_lock(&r->lock);
+
+	ce = __netgpu_region_find_ctx(r, ctx);
+	list_del(&ce->ctx_node);
+
+	unmap = refcount_dec_and_test(&map->ref);
+	if (unmap)
+		list_del(&map->dma_node);
+
+	spin_unlock(&r->lock);
+
+	if (unmap) {
+		r->ops->unmap_region(map);
+		kvfree(map);
+	}
+
+	kfree(ce);
+	fput(r->mem->file);
+}
+
+static struct netgpu_dmamap *
+__netgpu_region_find_device(struct netgpu_region *r, struct device *device)
+{
+	struct netgpu_dmamap *map;
+
+	list_for_each_entry(map, &r->dma_list, dma_node)
+		if (map->device == device) {
+			refcount_inc(&map->ref);
+			return map;
+		}
+	return NULL;
+}
+
+static struct netgpu_region *
+__netgpu_mem_find_region(struct netgpu_mem *mem, int idx)
+{
+	struct netgpu_region *r;
+
+	list_for_each_entry(r, &mem->region_list, mem_node)
+		if (r->index == idx)
+			return r;
+	return NULL;
+}
+
+struct netgpu_dmamap *
+netgpu_mem_attach_ctx(struct netgpu_mem *mem, int idx, struct netgpu_ctx *ctx)
+{
+	struct netgpu_ctx_entry *ce;
+	struct netgpu_dmamap *map;
+	struct netgpu_region *r;
+	struct device *device;
+
+	rcu_read_lock();
+	r = __netgpu_mem_find_region(mem, idx);
+	rcu_read_unlock();
+
+	if (!r)
+		return ERR_PTR(-ENOENT);
+
+	spin_lock(&r->lock);
+
+	ce = __netgpu_region_find_ctx(r, ctx);
+	if (ce) {
+		map = ERR_PTR(-EEXIST);
+		goto out_unlock;
+	}
+
+	ce = kmalloc(sizeof(*ce), GFP_KERNEL);
+	if (!ce) {
+		map = ERR_PTR(-ENOMEM);
+		goto out_unlock;
+	}
+
+	device = netdev2device(ctx->dev);
+	map = __netgpu_region_find_device(r, device);
+	if (!map) {
+		map = r->ops->map_region(r, device);
+		if (IS_ERR(map)) {
+			kfree(ce);
+			goto out_unlock;
+		}
+
+		map->r = r;
+		map->start = r->start;
+		map->device = device;
+		map->nr_pages = r->nr_pages;
+		map->get_dma = r->ops->get_dma;
+		map->get_page = r->ops->get_page;
+		map->get_pages = r->ops->get_pages;
+
+		refcount_set(&map->ref, 1);
+
+		list_add(&map->dma_node, &r->dma_list);
+	}
+
+	ce->ctx = ctx;
+	list_add(&ce->ctx_node, &r->ctx_list);
+	get_file(mem->file);
+
+out_unlock:
+	spin_unlock(&r->lock);
+	return map;
+}
+
+static void
+netgpu_mem_free_region(struct netgpu_mem *mem, struct netgpu_region *r)
+{
+	struct netgpu_ops *ops = r->ops;
+
+	WARN_ONCE(!list_empty(&r->ctx_list), "context list not empty!");
+	WARN_ONCE(!list_empty(&r->dma_list), "DMA list not empty!");
+
+	/* removes page mappings, frees r */
+	ops->free_region(mem, r);
+	module_put(ops->owner);
+}
+
+/* region overlaps will fail due to PagePrivate bit */
+static int
+netgpu_mem_add_region(struct netgpu_mem *mem, void __user *arg)
+{
+	struct netgpu_region_param p;
+	struct netgpu_region *r;
+	struct netgpu_ops *ops;
+
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	if (p.memtype < 0 || p.memtype >= MEMTYPE_MAX)
+		return -ENXIO;
+
+#ifdef CONFIG_MODULES
+	if (!rcu_access_pointer(netgpu_ops[p.memtype]))
+		request_module("netgpu_%s", netgpu_name[p.memtype]);
+#endif
+
+	rcu_read_lock();
+	ops = rcu_dereference(netgpu_ops[p.memtype]);
+	if (!ops || !try_module_get(ops->owner)) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
+	rcu_read_unlock();
+
+	r = ops->add_region(mem, &p.iov);
+	if (IS_ERR(r)) {
+		module_put(ops->owner);
+		return PTR_ERR(r);
+	}
+
+	r->ops = ops;
+
+	mutex_lock(&mem->lock);
+	r->index = ++mem->index_generator;
+	list_add_rcu(&r->mem_node, &mem->region_list);
+	mutex_unlock(&mem->lock);
+
+	return r->index;
+}
+
+/* This function is called from the nvidia callback, ick. */
+void
+netgpu_detach_region(struct netgpu_region *r)
+{
+	struct netgpu_mem *mem = r->mem;
+	struct netgpu_ctx_entry *ce, *tmp;
+	struct netgpu_dmamap *map;
+
+	mutex_lock(&mem->lock);
+	list_del(&r->mem_node);
+	mutex_unlock(&mem->lock);
+
+	spin_lock(&r->lock);
+
+	list_for_each_entry_safe(ce, tmp, &r->ctx_list, ctx_node) {
+		list_del(&ce->ctx_node);
+		map = netgpu_ctx_detach_region(ce->ctx, r);
+
+		if (refcount_dec_and_test(&map->ref)) {
+			list_del(&map->dma_node);
+			r->ops->unmap_region(map);
+			kvfree(map);
+		}
+
+		kfree(ce);
+		fput(r->mem->file);
+	}
+
+	spin_unlock(&r->lock);
+	netgpu_mem_free_region(mem, r);
+
+	/* XXX nvidia bug - keeps extra file reference?? */
+	fput(mem->file);
+}
+EXPORT_SYMBOL(netgpu_detach_region);
+
+static long
+netgpu_mem_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	struct netgpu_mem *mem = file->private_data;
+
+	switch (cmd) {
+	case NETGPU_MEM_IOCTL_ADD_REGION:
+		return netgpu_mem_add_region(mem, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
+
+static void
+__netgpu_free_mem(struct netgpu_mem *mem)
+{
+	struct netgpu_region *r, *tmp;
+
+	/* no lock needed - no refs at this point */
+	list_for_each_entry_safe(r, tmp, &mem->region_list, mem_node)
+		netgpu_mem_free_region(mem, r);
+
+	free_uid(mem->user);
+	kfree(mem);
+}
+
+static int
+netgpu_mem_release(struct inode *inode, struct file *file)
+{
+	struct netgpu_mem *mem = file->private_data;
+
+	__netgpu_free_mem(mem);
+
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+static int
+netgpu_mem_open(struct inode *inode, struct file *file)
+{
+	struct netgpu_mem *mem;
+
+	mem = kmalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	mem->account_mem = !capable(CAP_IPC_LOCK);
+	mem->user = get_uid(current_user());
+	mem->file = file;
+	mem->index_generator = 0;
+	mutex_init(&mem->lock);
+	INIT_LIST_HEAD(&mem->region_list);
+
+	file->private_data = mem;
+
+	__module_get(THIS_MODULE);
+
+	return 0;
+}
+
+const struct file_operations netgpu_mem_fops = {
+	.owner =		THIS_MODULE,
+	.open =			netgpu_mem_open,
+	.unlocked_ioctl =	netgpu_mem_ioctl,
+	.release =		netgpu_mem_release,
+};
+
+struct miscdevice netgpu_mem_dev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "netgpu_mem",
+	.fops		= &netgpu_mem_fops,
+};
diff --git a/drivers/misc/netgpu/netgpu_priv.h b/drivers/misc/netgpu/netgpu_priv.h
new file mode 100644
index 000000000000..4dc9941767cb
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_priv.h
@@ -0,0 +1,88 @@
+#ifndef _NETGPU_PRIV_H
+#define _NETGPU_PRIV_H
+
+struct netgpu_queue_map {
+	unsigned prod ____cacheline_aligned_in_smp;
+	unsigned cons ____cacheline_aligned_in_smp;
+	unsigned char data[] ____cacheline_aligned_in_smp;
+};
+
+struct netgpu_dmamap {
+	struct list_head dma_node;		/* dma map of region */
+	struct netgpu_region *r;		/* owning region */
+	struct device *device;			/* device map is for */
+	refcount_t ref;				/* ctxs holding this map */
+
+	unsigned long start;			/* copies from region */
+	unsigned long nr_pages;
+	dma_addr_t
+		(*get_dma)(struct netgpu_dmamap *map, unsigned long addr);
+	int	(*get_page)(struct netgpu_dmamap *map, unsigned long addr,
+			    struct page **page, dma_addr_t *dma);
+	int	(*get_pages)(struct netgpu_region *r, struct page **pages,
+			     unsigned long addr, int count);
+};
+
+struct netgpu_ctx;
+
+struct netgpu_ctx_entry {
+	struct list_head ctx_node;
+	struct netgpu_ctx *ctx;
+};
+
+struct netgpu_region {
+	struct list_head dma_list;		/* dma mappings of region */
+	struct list_head ctx_list;		/* contexts using region */
+	struct list_head mem_node;		/* mem area owning region */
+	struct netgpu_mem *mem;
+	struct netgpu_ops *ops;
+	unsigned long start;
+	unsigned long nr_pages;
+	int index;				/* unique per mem */
+	spinlock_t lock;
+};
+
+/* assign the id on creation, just bump counter and match. */
+struct netgpu_mem {
+	struct file *file;
+	struct mutex lock;
+	struct user_struct *user;
+	int index_generator;
+	unsigned account_mem : 1;
+	struct list_head region_list;
+};
+
+struct netgpu_ops {
+	int	memtype;
+	struct module *owner;
+
+	struct netgpu_region *
+		(*add_region)(struct netgpu_mem *, const struct iovec *);
+	void	(*free_region)(struct netgpu_mem *, struct netgpu_region *);
+
+	struct netgpu_dmamap *
+		(*map_region)(struct netgpu_region *, struct device *);
+	void	(*unmap_region)(struct netgpu_dmamap *);
+
+	dma_addr_t
+		(*get_dma)(struct netgpu_dmamap *map, unsigned long addr);
+	int	(*get_page)(struct netgpu_dmamap *map, unsigned long addr,
+			    struct page **page, dma_addr_t *dma);
+	int	(*get_pages)(struct netgpu_region *r, struct page **pages,
+			     unsigned long addr, int count);
+};
+
+extern const struct file_operations netgpu_mem_fops;
+extern struct miscdevice netgpu_mem_dev;
+extern struct netgpu_ops host_ops;
+
+struct netgpu_dmamap *
+	netgpu_mem_attach_ctx(struct netgpu_mem *mem,
+			      int idx, struct netgpu_ctx *ctx);
+void netgpu_map_detach_ctx(struct netgpu_dmamap *map, struct netgpu_ctx *ctx);
+struct netgpu_dmamap *
+	netgpu_ctx_detach_region(struct netgpu_ctx *ctx,
+				 struct netgpu_region *r);
+void netgpu_detach_region(struct netgpu_region *r);
+
+#endif /* _NETGPU_PRIV_H */
diff --git a/drivers/misc/netgpu/netgpu_stub.c b/drivers/misc/netgpu/netgpu_stub.c
new file mode 100644
index 000000000000..112bca3dcd60
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_stub.c
@@ -0,0 +1,166 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+
+#include <net/netgpu.h>
+#include <uapi/misc/netgpu.h>
+
+#include "netgpu_stub.h"
+
+static dma_addr_t
+netgpu_nop_get_dma(struct netgpu_ctx *ctx, struct page *page)
+{
+	return 0;
+}
+
+static int
+netgpu_nop_get_page(struct netgpu_ifq *ifq, struct page **page,
+		    dma_addr_t *dma)
+{
+	return -ENXIO;
+}
+
+static void
+netgpu_nop_put_page(struct netgpu_ifq *ifq, struct page *page, bool napi)
+{
+}
+
+static int
+netgpu_nop_get_pages(struct sock *sk, struct page **pages, unsigned long addr,
+		     int count)
+{
+	return -ENXIO;
+}
+
+static int
+netgpu_nop_socket_mmap(struct file *file, struct socket *sock,
+		       struct vm_area_struct *vma)
+{
+	return -ENOIOCTLCMD;
+}
+
+static int
+netgpu_nop_attach_socket(struct sock *sk, void __user *arg)
+{
+	return -ENOIOCTLCMD;
+}
+
+static struct netgpu_functions netgpu_nop = {
+	.get_dma	= netgpu_nop_get_dma,
+	.get_page	= netgpu_nop_get_page,
+	.put_page	= netgpu_nop_put_page,
+	.get_pages	= netgpu_nop_get_pages,
+	.socket_mmap	= netgpu_nop_socket_mmap,
+	.attach_socket	= netgpu_nop_attach_socket,
+};
+
+static struct netgpu_functions *netgpu_fcn;
+static DEFINE_SPINLOCK(netgpu_fcn_lock);
+
+void
+netgpu_fcn_register(struct netgpu_functions *f)
+{
+	spin_lock(&netgpu_fcn_lock);
+	rcu_assign_pointer(netgpu_fcn, f);
+	spin_unlock(&netgpu_fcn_lock);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL(netgpu_fcn_register);
+
+void
+netgpu_fcn_unregister(void)
+{
+	netgpu_fcn_register(&netgpu_nop);
+}
+EXPORT_SYMBOL(netgpu_fcn_unregister);
+
+dma_addr_t
+netgpu_get_dma(struct netgpu_ctx *ctx, struct page *page)
+{
+	struct netgpu_functions *f;
+	dma_addr_t dma;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	dma = f->get_dma(ctx, page);
+	rcu_read_unlock();
+
+	return dma;
+}
+EXPORT_SYMBOL(netgpu_get_dma);
+
+int
+netgpu_get_page(struct netgpu_ifq *ifq, struct page **page,
+		dma_addr_t *dma)
+{
+	struct netgpu_functions *f;
+	int err;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	err = f->get_page(ifq, page, dma);
+	rcu_read_unlock();
+
+	return err;
+}
+EXPORT_SYMBOL(netgpu_get_page);
+
+void
+netgpu_put_page(struct netgpu_ifq *ifq, struct page *page, bool napi)
+{
+	struct netgpu_functions *f;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	f->put_page(ifq, page, napi);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(netgpu_put_page);
+
+int
+netgpu_get_pages(struct sock *sk, struct page **pages, unsigned long addr,
+		 int count)
+{
+	struct netgpu_functions *f;
+	int err;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	err = f->get_pages(sk, pages, addr, count);
+	rcu_read_unlock();
+
+	return err;
+}
+
+int
+netgpu_socket_mmap(struct file *file, struct socket *sock,
+		   struct vm_area_struct *vma)
+{
+	struct netgpu_functions *f;
+	int err;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	err = f->socket_mmap(file, sock, vma);
+	rcu_read_unlock();
+
+	return err;
+}
+
+int
+netgpu_attach_socket(struct sock *sk, void __user *arg)
+{
+	struct netgpu_functions *f;
+	int err;
+
+	rcu_read_lock();
+	f = rcu_dereference(netgpu_fcn);
+	err = f->attach_socket(sk, arg);
+	rcu_read_unlock();
+
+	return err;
+}
diff --git a/drivers/misc/netgpu/netgpu_stub.h b/drivers/misc/netgpu/netgpu_stub.h
new file mode 100644
index 000000000000..9b682d8ccf0c
--- /dev/null
+++ b/drivers/misc/netgpu/netgpu_stub.h
@@ -0,0 +1,19 @@
+#pragma once
+
+/* development-only support for module loading. */
+
+struct netgpu_functions {
+	dma_addr_t (*get_dma)(struct netgpu_ctx *ctx, struct page *page);
+	int (*get_page)(struct netgpu_ifq *ifq,
+			struct page **page, dma_addr_t *dma);
+	void (*put_page)(struct netgpu_ifq *, struct page *, bool);
+	int (*get_pages)(struct sock *, struct page **,
+			 unsigned long, int);
+
+	int (*socket_mmap)(struct file *file, struct socket *sock,
+			   struct vm_area_struct *vma);
+	int (*attach_socket)(struct sock *sk, void __user *arg);
+};
+
+void netgpu_fcn_register(struct netgpu_functions *f);
+void netgpu_fcn_unregister(void);
-- 
2.24.1

