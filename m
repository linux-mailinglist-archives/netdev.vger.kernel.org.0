Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77241FF8E1
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbgFRQKj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45384 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732000AbgFRQK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05IG7aTO013390
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:22 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31q644vshh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:21 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 636743D44E14C; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 15/21] netgpu: add network/gpu dma module
Date:   Thu, 18 Jun 2020 09:09:35 -0700
Message-ID: <20200618160941.879717-16-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=4 adultscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netgpu provides a data path for zero-copy TCP sends and receives
directly to GPU memory.  TCP processing is done on the host CPU,
while data is DMA'd to and from device memory.

The use case for this module are GPUs used for machine learning,
which are located near the NICs, and have a high bandwith PCI
connection between the GPU/NIC.

This initial working code is a proof of concept, for discussion.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/misc/Kconfig         |    1 +
 drivers/misc/Makefile        |    1 +
 drivers/misc/netgpu/Kconfig  |   10 +
 drivers/misc/netgpu/Makefile |   11 +
 drivers/misc/netgpu/nvidia.c | 1516 ++++++++++++++++++++++++++++++++++
 include/uapi/misc/netgpu.h   |   43 +
 6 files changed, 1582 insertions(+)
 create mode 100644 drivers/misc/netgpu/Kconfig
 create mode 100644 drivers/misc/netgpu/Makefile
 create mode 100644 drivers/misc/netgpu/nvidia.c
 create mode 100644 include/uapi/misc/netgpu.h

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
index c7bd01ac6291..e026fe95a629 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_PVPANIC)   	+= pvpanic.o
 obj-$(CONFIG_HABANA_AI)		+= habanalabs/
 obj-$(CONFIG_UACCE)		+= uacce/
 obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
+obj-$(CONFIG_NETGPU)		+= netgpu/
diff --git a/drivers/misc/netgpu/Kconfig b/drivers/misc/netgpu/Kconfig
new file mode 100644
index 000000000000..f67adf825c1b
--- /dev/null
+++ b/drivers/misc/netgpu/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# NetGPU framework
+#
+
+config NETGPU
+	tristate "Network/GPU driver"
+	depends on PCI
+	---help---
+	  Experimental Network / GPU driver
diff --git a/drivers/misc/netgpu/Makefile b/drivers/misc/netgpu/Makefile
new file mode 100644
index 000000000000..fe58963efdf7
--- /dev/null
+++ b/drivers/misc/netgpu/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+pkg = /home/bsd/local/pull/nvidia/NVIDIA-Linux-x86_64-440.59/kernel
+
+obj-$(CONFIG_NETGPU) := netgpu.o
+
+netgpu-y := nvidia.o
+
+# netgpu-$(CONFIG_DEBUG_FS) += debugfs.o
+
+ccflags-y += -I$(pkg)
diff --git a/drivers/misc/netgpu/nvidia.c b/drivers/misc/netgpu/nvidia.c
new file mode 100644
index 000000000000..a0ea82effb2f
--- /dev/null
+++ b/drivers/misc/netgpu/nvidia.c
@@ -0,0 +1,1516 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/seq_file.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/memory.h>
+#include <linux/device.h>
+#include <linux/interval_tree.h>
+
+#include <net/tcp.h>
+
+#include <net/netgpu.h>
+#include <uapi/misc/netgpu.h>
+
+/* XXX enable if using nvidia - will be split out to its own file */
+//#define USE_CUDA 1
+
+#ifdef USE_CUDA
+#include "nvidia/nv-p2p.h"
+#endif
+
+/* nvidia GPU uses 64K pages */
+#define GPU_PAGE_SHIFT		16
+#define GPU_PAGE_SIZE		(1UL << GPU_PAGE_SHIFT)
+#define GPU_PAGE_MASK		(GPU_PAGE_SIZE - 1)
+
+/* self is 3 so skb_netgpu_unref does not catch the dummy page */
+#define NETGPU_REFC_MAX		0xff00
+#define NETGPU_REFC_SELF	3
+#define NETGPU_REFC_EXTRA	(NETGPU_REFC_MAX - NETGPU_REFC_SELF)
+
+static struct mutex netgpu_lock;
+static unsigned int netgpu_index;
+static DEFINE_XARRAY(xa_netgpu);
+static const struct file_operations netgpu_fops;
+
+/* XXX hack */
+static void (*sk_data_ready)(struct sock *sk);
+static struct proto netgpu_prot;
+
+#ifdef USE_CUDA
+/* page_range represents one contiguous GPU PA region */
+struct netgpu_page_range {
+	unsigned long pfn;
+	struct resource *res;
+	struct netgpu_region *region;
+	struct interval_tree_node va_node;
+};
+#endif
+
+struct netgpu_pginfo {
+	unsigned long addr;
+	dma_addr_t dma;
+};
+
+#define NETGPU_CACHE_COUNT	63
+
+/* region represents GPU VA region backed by gpu_pgtbl
+ * as the region is VA, the PA ranges may be discontiguous
+ */
+struct netgpu_region {
+	struct nvidia_p2p_page_table *gpu_pgtbl;
+	struct nvidia_p2p_dma_mapping *dmamap;
+	struct netgpu_pginfo *pginfo;
+	struct page **page;
+	struct netgpu_ctx *ctx;
+	unsigned long start;
+	unsigned long len;
+	struct rb_root_cached root;
+	unsigned host_memory : 1;
+};
+
+static inline struct device *
+netdev2device(struct net_device *dev)
+{
+	return dev->dev.parent;			/* from SET_NETDEV_DEV() */
+}
+
+static inline struct pci_dev *
+netdev2pci_dev(struct net_device *dev)
+{
+	return to_pci_dev(netdev2device(dev));
+}
+
+#ifdef USE_CUDA
+static int nvidia_pg_size[] = {
+	[NVIDIA_P2P_PAGE_SIZE_4KB]   =	 4 * 1024,
+	[NVIDIA_P2P_PAGE_SIZE_64KB]  =	64 * 1024,
+	[NVIDIA_P2P_PAGE_SIZE_128KB] = 128 * 1024,
+};
+
+static void netgpu_cuda_free_region(struct netgpu_region *r);
+#endif
+static void netgpu_free_ctx(struct netgpu_ctx *ctx);
+static int netgpu_add_region(struct netgpu_ctx *ctx, void __user *arg);
+
+#ifdef USE_CUDA
+#define node2page_range(itn) \
+	container_of(itn, struct netgpu_page_range, va_node)
+
+#define region_for_each(r, idx, itn, pr)				\
+	for (idx = r->start,						\
+		itn = interval_tree_iter_first(r->root, idx, r->last);	\
+	     pr = container_of(itn, struct netgpu_page_range, va_node),	\
+		itn;							\
+	     idx = itn->last + 1,					\
+		itn = interval_tree_iter_next(itn, idx, r->last))
+
+#define region_remove_each(r, itn) \
+	while ((itn = interval_tree_iter_first(&r->root, r->start, \
+					       r->start + r->len - 1)) && \
+	       (interval_tree_remove(itn, &r->root), 1))
+
+static inline struct netgpu_page_range *
+region_find(struct netgpu_region *r, unsigned long start, int count)
+{
+	struct interval_tree_node *itn;
+	unsigned long last;
+
+	last = start + count * PAGE_SIZE - 1;
+
+	itn = interval_tree_iter_first(&r->root, start, last);
+	return itn ? node2page_range(itn) : 0;
+}
+
+static void
+netgpu_cuda_pgtbl_cb(void *data)
+{
+	struct netgpu_region *r = data;
+
+	netgpu_cuda_free_region(r);
+}
+
+static void
+netgpu_init_pages(u64 va, unsigned long pfn_start, unsigned long pfn_end)
+{
+	unsigned long pfn;
+	struct page *page;
+
+	for (pfn = pfn_start; pfn < pfn_end; pfn++) {
+		page = pfn_to_page(pfn);
+		mm_zero_struct_page(page);
+
+		set_page_count(page, 2);	/* matches host logic */
+		page->page_type = 7;		/* XXX differential flag */
+		__SetPageReserved(page);
+
+		set_page_private(page, va);
+		va += PAGE_SIZE;
+	}
+}
+
+static struct resource *
+netgpu_add_pages(int nid, u64 start, u64 end)
+{
+	struct mhp_restrictions restrict = {
+		.flags = MHP_MEMBLOCK_API,
+	};
+
+	return add_memory_pages(nid, start, end - start, &restrict);
+}
+
+static void
+netgpu_free_pages(struct resource *res)
+{
+	release_memory_pages(res);
+}
+
+static int
+netgpu_remap_pages(struct netgpu_region *r, u64 va, u64 start, u64 end)
+{
+	struct netgpu_page_range *pr;
+	struct resource *res;
+
+	pr = kmalloc(sizeof(*pr), GFP_KERNEL);
+	if (!pr)
+		return -ENOMEM;
+
+	res = netgpu_add_pages(numa_mem_id(), start, end);
+	if (IS_ERR(res)) {
+		kfree(pr);
+		return PTR_ERR(res);
+	}
+
+	pr->pfn = PHYS_PFN(start);
+	pr->region = r;
+	pr->va_node.start = va;
+	pr->va_node.last = va + (end - start) - 1;
+	pr->res = res;
+
+	netgpu_init_pages(va, PHYS_PFN(start), PHYS_PFN(end));
+
+//	spin_lock(&r->lock);
+	interval_tree_insert(&pr->va_node, &r->root);
+//	spin_unlock(&r->lock);
+
+	return 0;
+}
+
+static int
+netgpu_cuda_map_region(struct netgpu_region *r)
+{
+	struct pci_dev *pdev;
+	int ret;
+
+	pdev = netdev2pci_dev(r->ctx->dev);
+
+	/*
+	 * takes PA from pgtbl, performs mapping, saves mapping
+	 * dma_mapping holds dma mapped addresses, and pdev.
+	 * mem_info contains pgtbl and mapping list.  mapping is added to list.
+	 * rm_p2p_dma_map_pages() does the work.
+	 */
+	ret = nvidia_p2p_dma_map_pages(pdev, r->gpu_pgtbl, &r->dmamap);
+	if (ret) {
+		pr_err("dma map failed: %d\n", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+/*
+ * makes GPU pages at va available to other devices.
+ * expensive operation.
+ */
+static int
+netgpu_cuda_add_region(struct netgpu_ctx *ctx, const struct iovec *iov)
+{
+	struct nvidia_p2p_page_table *gpu_pgtbl;
+	struct netgpu_region *r;
+	u64 va, size, start, end, pa;
+	int i, count, gpu_pgsize;
+	int ret;
+
+	start = (u64)iov->iov_base;
+	va = round_down(start, GPU_PAGE_SIZE);
+	size = round_up(start - va + iov->iov_len, GPU_PAGE_SIZE);
+	count = size / PAGE_SIZE;
+
+	ret = -ENOMEM;
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		goto out;
+
+	/*
+	 * allocates page table, sets gpu_uuid to owning gpu.
+	 * allocates page array, set PA for each page.
+	 * sets page_size (64K here)
+	 * rm_p2p_get_pages() does the actual work.
+	 */
+	ret = nvidia_p2p_get_pages(0, 0, va, size, &gpu_pgtbl,
+				   netgpu_cuda_pgtbl_cb, r);
+	if (ret) {
+		kfree(r);
+		goto out;
+	}
+
+	/* gpu pgtbl owns r, will free via netgpu_cuda_pgtbl_cb */
+	r->gpu_pgtbl = gpu_pgtbl;
+
+	r->start = va;
+	r->len = size;
+	r->root = RB_ROOT_CACHED;
+//	spin_lock_init(&r->lock);
+
+	if (!NVIDIA_P2P_PAGE_TABLE_VERSION_COMPATIBLE(gpu_pgtbl)) {
+		pr_err("incompatible page table\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	gpu_pgsize = nvidia_pg_size[gpu_pgtbl->page_size];
+	if (count != gpu_pgtbl->entries * gpu_pgsize / PAGE_SIZE) {
+		pr_err("GPU page count %d != host page count %d\n",
+		       gpu_pgtbl->entries, count);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = xa_err(xa_store_range(&ctx->xa, va >> PAGE_SHIFT,
+				    (va + size) >> PAGE_SHIFT,
+				    r, GFP_KERNEL));
+	if (ret)
+		goto out;
+
+	r->ctx = ctx;
+	refcount_inc(&ctx->ref);
+
+	ret = netgpu_cuda_map_region(r);
+	if (ret)
+		goto out;
+
+	start = U64_MAX;
+	end = 0;
+
+	for (i = 0; i < gpu_pgtbl->entries; i++) {
+		pa = gpu_pgtbl->pages[i]->physical_address;
+		if (pa != end) {
+			if (end) {
+				ret = netgpu_remap_pages(r, va, start, end);
+				if (ret)
+					goto out;
+			}
+			start = pa;
+			va = r->start + i * gpu_pgsize;
+		}
+		end = pa + gpu_pgsize;
+	}
+	ret = netgpu_remap_pages(r, va, start, end);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	return ret;
+}
+#endif
+
+static void
+netgpu_host_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &user->locked_vm);
+}
+
+static int
+netgpu_host_account_mem(struct user_struct *user, unsigned long nr_pages)
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
+static unsigned
+netgpu_init_region(struct netgpu_region *r, const struct iovec *iov,
+		   unsigned align)
+{
+	u64 addr = (u64)iov->iov_base;
+	u32 len = iov->iov_len;
+	unsigned nr_pages;
+
+	r->root = RB_ROOT_CACHED;
+//	spin_lock_init(&r->lock);
+
+	r->start = round_down(addr, align);
+	r->len = round_up(addr - r->start + len, align);
+	nr_pages = r->len / PAGE_SIZE;
+
+	r->page = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	r->pginfo = kvmalloc_array(nr_pages, sizeof(struct netgpu_pginfo),
+				   GFP_KERNEL);
+	if (!r->page || !r->pginfo)
+		return 0;
+
+	return nr_pages;
+}
+
+/* NOTE: nr_pages may be negative on error. */
+static void
+netgpu_host_put_pages(struct netgpu_region *r, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		put_page(r->page[i]);
+}
+
+static void
+netgpu_host_release_pages(struct netgpu_region *r, int nr_pages)
+{
+	struct device *device;
+	int i;
+
+	device = netdev2device(r->ctx->dev);
+
+	for (i = 0; i < nr_pages; i++) {
+		dma_unmap_page(device, r->pginfo[i].dma, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+		put_page(r->page[i]);
+	}
+}
+
+static bool
+netgpu_host_setup_pages(struct netgpu_region *r, unsigned nr_pages)
+{
+	struct device *device;
+	struct page *page;
+	dma_addr_t dma;
+	u64 addr;
+	int i;
+
+	device = netdev2device(r->ctx->dev);
+
+	addr = r->start;
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		page = r->page[i];
+		dma = dma_map_page(device, page, 0, PAGE_SIZE,
+				   DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(device, dma)))
+			goto out;
+
+		r->pginfo[i].dma = dma;
+		r->pginfo[i].addr = addr;
+	}
+	return true;
+
+out:
+	while (i--)
+		dma_unmap_page(device, r->pginfo[i].dma, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+
+	return false;
+}
+
+static int
+netgpu_host_add_region(struct netgpu_ctx *ctx, const struct iovec *iov)
+{
+	struct netgpu_region *r;
+	int err, nr_pages;
+	int count = 0;
+
+	err = -ENOMEM;
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return err;
+
+	r->ctx = ctx;			/* no refcount for host regions */
+	r->host_memory = true;
+
+	nr_pages = netgpu_init_region(r, iov, PAGE_SIZE);
+	if (!nr_pages)
+		goto out;
+
+	if (ctx->account_mem) {
+		err = netgpu_host_account_mem(ctx->user, nr_pages);
+		if (err)
+			goto out;
+	}
+
+	/* XXX should this be pin_user_pages? */
+	mmap_read_lock(current->mm);
+	count = get_user_pages(r->start, nr_pages,
+			       FOLL_WRITE | FOLL_LONGTERM,
+			       r->page, NULL);
+	mmap_read_unlock(current->mm);
+
+	if (count != nr_pages) {
+		err = count < 0 ? count : -EFAULT;
+		goto out;
+	}
+
+	if (!netgpu_host_setup_pages(r, count))
+		goto out;
+
+	err = xa_err(xa_store_range(&ctx->xa, r->start >> PAGE_SHIFT,
+				    (r->start + r->len) >> PAGE_SHIFT,
+				    r, GFP_KERNEL));
+	if (err)
+		goto out;
+
+	return 0;
+
+out:
+	if (ctx->account_mem)
+		netgpu_host_unaccount_mem(ctx->user, nr_pages);
+	netgpu_host_put_pages(r, count);
+	kvfree(r->page);
+	kvfree(r->pginfo);
+	kfree(r);
+
+	return err;
+}
+
+static int
+netgpu_add_region(struct netgpu_ctx *ctx, void __user *arg)
+{
+	struct dma_region d;
+	int err = -EIO;
+
+	if (!ctx->dev)
+		return -ENODEV;
+
+	if (copy_from_user(&d, arg, sizeof(d)))
+		return -EFAULT;
+
+	if (d.host_memory)
+		err = netgpu_host_add_region(ctx, &d.iov);
+#ifdef USE_CUDA
+	else
+		err = netgpu_cuda_add_region(ctx, &d.iov);
+#endif
+
+	return err;
+}
+
+#ifdef USE_CUDA
+static void
+region_get_pages(struct page **pages, unsigned long pfn, int n)
+{
+	struct page *p;
+	int i;
+
+	for (i = 0; i < n; i++) {
+		p = pfn_to_page(pfn + i);
+		get_page(p);
+		pages[i] = p;
+	}
+}
+
+static int
+netgpu_cuda_get_page(struct netgpu_region *r, unsigned long addr,
+		     struct page **page, dma_addr_t *dma)
+{
+	struct netgpu_page_range *pr;
+	unsigned long idx;
+	struct page *p;
+
+	pr = region_find(r, addr, 1);
+	if (!pr)
+		return -EFAULT;
+
+	idx = (addr - pr->va_node.start) >> PAGE_SHIFT;
+
+	p = pfn_to_page(pr->pfn + idx);
+	get_page(p);
+	*page = p;
+	*dma = page_to_phys(p);		/* XXX can get away with this for now */
+
+	return 0;
+}
+
+static int
+netgpu_cuda_get_pages(struct netgpu_region *r, struct page **pages,
+		     unsigned long addr, int count)
+{
+	struct netgpu_page_range *pr;
+	unsigned long idx, end;
+	int n;
+
+	pr = region_find(r, addr, count);
+	if (!pr)
+		return -EFAULT;
+
+	idx = (addr - pr->va_node.start) >> PAGE_SHIFT;
+	end = (pr->va_node.last - pr->va_node.start) >> PAGE_SHIFT;
+	n = end - idx + 1;
+	n = min(count, n);
+
+	region_get_pages(pages, pr->pfn + idx, n);
+
+	return n;
+}
+#endif
+
+/* Used by the lib/iov_iter to obtain a set of pages for TX */
+static int
+netgpu_host_get_pages(struct netgpu_region *r, struct page **pages,
+		      unsigned long addr, int count)
+{
+	unsigned long idx;
+	struct page *p;
+	int i, n;
+
+	idx = (addr - r->start) >> PAGE_SHIFT;
+	n = (r->len >> PAGE_SHIFT) - idx + 1;
+	n = min(count, n);
+
+	for (i = 0; i < n; i++) {
+		p = r->page[idx + i];
+		get_page(p);
+		pages[i] = p;
+	}
+
+	return n;
+}
+
+/* Used by the driver to obtain the backing store page for a fill address */
+static int
+netgpu_host_get_page(struct netgpu_region *r, unsigned long addr,
+		     struct page **page, dma_addr_t *dma)
+{
+	unsigned long idx;
+	struct page *p;
+
+	idx = (addr - r->start) >> PAGE_SHIFT;
+
+	p = r->page[idx];
+	get_page(p);
+	set_page_private(p, addr);
+	*page = p;
+	*dma = r->pginfo[idx].dma;
+
+	return 0;
+}
+
+static void
+__netgpu_put_page_any(struct netgpu_ctx *ctx, struct page *page)
+{
+	struct netgpu_pgcache *cache = ctx->any_cache;
+	unsigned count;
+	size_t sz;
+
+	/* unsigned: count == -1 if !cache, so the check will fail. */
+	count = ctx->any_cache_count;
+	if (count < NETGPU_CACHE_COUNT) {
+		cache->page[count] = page;
+		ctx->any_cache_count = count + 1;
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
+	cache->next = ctx->any_cache;
+
+	cache->page[0] = page;
+	ctx->any_cache = cache;
+	ctx->any_cache_count = 1;
+}
+
+static void
+netgpu_put_page_any(struct netgpu_ctx *ctx, struct page *page)
+{
+	spin_lock(&ctx->pgcache_lock);
+
+	__netgpu_put_page_any(ctx, page);
+
+	spin_unlock(&ctx->pgcache_lock);
+}
+
+static void
+netgpu_put_page_napi(struct netgpu_ctx *ctx, struct page *page)
+{
+	struct netgpu_pgcache *spare;
+	unsigned count;
+	size_t sz;
+
+	count = ctx->napi_cache_count;
+	if (count < NETGPU_CACHE_COUNT) {
+		ctx->napi_cache->page[count] = page;
+		ctx->napi_cache_count = count + 1;
+		return;
+	}
+
+	spare = ctx->spare_cache;
+	if (spare) {
+		ctx->spare_cache = NULL;
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
+	spare->next = ctx->napi_cache;
+
+out:
+	spare->page[0] = page;
+	ctx->napi_cache = spare;
+	ctx->napi_cache_count = 1;
+}
+
+void
+netgpu_put_page(struct netgpu_ctx *ctx, struct page *page, bool napi)
+{
+	if (napi)
+		netgpu_put_page_napi(ctx, page);
+	else
+		netgpu_put_page_any(ctx, page);
+}
+EXPORT_SYMBOL(netgpu_put_page);
+
+static int
+netgpu_swap_caches(struct netgpu_ctx *ctx, struct netgpu_pgcache **cachep)
+{
+	int count;
+
+	spin_lock(&ctx->pgcache_lock);
+
+	count = ctx->any_cache_count;
+	*cachep = ctx->any_cache;
+	ctx->any_cache = ctx->napi_cache;
+	ctx->any_cache_count = 0;
+
+	spin_unlock(&ctx->pgcache_lock);
+
+	return count;
+}
+
+static struct page *
+netgpu_get_cached_page(struct netgpu_ctx *ctx)
+{
+	struct netgpu_pgcache *cache = ctx->napi_cache;
+	struct page *page;
+	int count;
+
+	count = ctx->napi_cache_count;
+
+	if (!count) {
+		if (cache->next) {
+			if (ctx->spare_cache)
+				kfree(ctx->spare_cache);
+			ctx->spare_cache = cache;
+			cache = cache->next;
+			count = NETGPU_CACHE_COUNT;
+			goto out;
+		}
+
+		/* lockless read of any count - if >0, skip */
+		count = READ_ONCE(ctx->any_cache_count);
+		if (count > 0) {
+			count = netgpu_swap_caches(ctx, &cache);
+			goto out;
+		}
+
+		return NULL;
+out:
+		ctx->napi_cache = cache;
+	}
+
+	page = cache->page[--count];
+	ctx->napi_cache_count = count;
+
+	return page;
+}
+
+/*
+ * Free cache structures.  Pages have already been released.
+ */
+static void
+netgpu_free_cache(struct netgpu_ctx *ctx)
+{
+	struct netgpu_pgcache *cache, *next;
+
+	if (ctx->spare_cache)
+		kfree(ctx->spare_cache);
+	for (cache = ctx->napi_cache; cache; cache = next) {
+		next = cache->next;
+		kfree(cache);
+	}
+	for (cache = ctx->any_cache; cache; cache = next) {
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
+	struct netgpu_region *r;
+	struct netgpu_ctx *ctx;
+	int n = 0;
+
+	ctx = xa_load(&xa_netgpu, (uintptr_t)sk->sk_user_data);
+	if (!ctx)
+		return -EEXIST;
+
+	r = xa_load(&ctx->xa, addr >> PAGE_SHIFT);
+	if (!r)
+		return -EINVAL;
+
+	if (r->host_memory)
+		n = netgpu_host_get_pages(r, pages, addr, count);
+#ifdef USE_CUDA
+	else
+		n = netgpu_cuda_get_pages(r, pages, addr, count);
+#endif
+
+	return n;
+}
+EXPORT_SYMBOL(netgpu_get_pages);
+
+static int
+netgpu_get_fill_page(struct netgpu_ctx *ctx, dma_addr_t *dma,
+		     struct page **page)
+{
+	struct netgpu_region *r;
+	u64 *addrp, addr;
+	int ret = 0;
+
+	addrp = sq_cons_peek(&ctx->fill);
+	if (!addrp)
+		return -ENOMEM;
+
+	addr = READ_ONCE(*addrp);
+
+	r = xa_load(&ctx->xa, addr >> PAGE_SHIFT);
+	if (!r)
+		return -EINVAL;
+
+	if (r->host_memory)
+		ret = netgpu_host_get_page(r, addr, page, dma);
+#ifdef USE_CUDA
+	else
+		ret = netgpu_cuda_get_page(r, addr, page, dma);
+#endif
+
+	if (!ret)
+		sq_cons_advance(&ctx->fill);
+
+	return ret;
+}
+
+static dma_addr_t
+netgpu_page_get_dma(struct netgpu_ctx *ctx, struct page *page)
+{
+	return page_to_phys(page);		/* XXX cheat for now... */
+}
+
+int
+netgpu_get_page(struct netgpu_ctx *ctx, struct page **page, dma_addr_t *dma)
+{
+	struct page *p;
+
+	p = netgpu_get_cached_page(ctx);
+	if (p) {
+		page_ref_inc(p);
+		*dma = netgpu_page_get_dma(ctx, p);
+		*page = p;
+		return 0;
+	}
+
+	return netgpu_get_fill_page(ctx, dma, page);
+}
+EXPORT_SYMBOL(netgpu_get_page);
+
+static struct page *
+netgpu_get_dummy_page(struct netgpu_ctx *ctx)
+{
+	ctx->page_extra_refc--;
+	if (unlikely(!ctx->page_extra_refc)) {
+		page_ref_add(ctx->dummy_page, NETGPU_REFC_EXTRA);
+		ctx->page_extra_refc = NETGPU_REFC_EXTRA;
+	}
+	return ctx->dummy_page;
+}
+
+/* Our version of __skb_datagram_iter */
+static int
+netgpu_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+		unsigned int offset, size_t len)
+{
+	struct netgpu_ctx *ctx = desc->arg.data;
+	struct sk_buff *frag_iter;
+	struct iovec *iov;
+	struct page *page;
+	unsigned start;
+	int i, used;
+	u64 addr;
+
+	if (skb_headlen(skb)) {
+		pr_err("zc socket receiving non-zc data");
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
+			iov = sq_prod_reserve(&ctx->rx);
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
+			page = netgpu_get_dummy_page(ctx);
+			__skb_frag_set_page(frag, page);
+		}
+		start = end;
+	}
+
+	if (used)
+		sq_prod_submit(&ctx->rx);
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
+netgpu_read_sock(struct sock *sk, struct netgpu_ctx *ctx)
+{
+	read_descriptor_t desc;
+	int used;
+
+	desc.arg.data = ctx;
+	desc.count = 1;
+	used = tcp_read_sock(sk, &desc, netgpu_recv_skb);
+}
+
+static void
+netgpu_data_ready(struct sock *sk)
+{
+	struct netgpu_ctx *ctx;
+
+	ctx = xa_load(&xa_netgpu, (uintptr_t)sk->sk_user_data);
+	if (ctx && ctx->rx.entries)
+		netgpu_read_sock(sk, ctx);
+
+	sk_data_ready(sk);
+}
+
+static bool netgpu_stream_memory_read(const struct sock *sk)
+{
+	struct netgpu_ctx *ctx;
+	bool empty = false;
+
+	/* sk is not locked.  called from poll, so not sp. */
+	ctx = xa_load(&xa_netgpu, (uintptr_t)sk->sk_user_data);
+	if (ctx)
+		empty = sq_empty(&ctx->rx);
+
+	return !empty;
+}
+
+static struct netgpu_ctx *
+netgpu_file_to_ctx(struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct netgpu_ctx *ctx = seq->private;
+
+	return ctx;
+}
+
+int
+netgpu_register_dma(struct sock *sk, void __user *optval, unsigned int optlen)
+{
+	struct fd f;
+	int netgpu_fd;
+	struct netgpu_ctx *ctx;
+
+	if (sk->sk_user_data)
+		return -EALREADY;
+	if (optlen < sizeof(netgpu_fd))
+		return -EINVAL;
+	if (copy_from_user(&netgpu_fd, optval, sizeof(netgpu_fd)))
+		return -EFAULT;
+
+	f = fdget(netgpu_fd);
+	if (!f.file)
+		return -EBADF;
+
+	if (f.file->f_op != &netgpu_fops) {
+		fdput(f);
+		return -EOPNOTSUPP;
+	}
+
+	/* XXX should really have some way to identify sk_user_data type */
+	ctx = netgpu_file_to_ctx(f.file);
+	sk->sk_user_data = (void *)(uintptr_t)ctx->index;
+
+	fdput(f);
+
+	if (!sk_data_ready)
+		sk_data_ready = sk->sk_data_ready;
+	sk->sk_data_ready = netgpu_data_ready;
+
+	/* XXX does not do any checking here */
+	if (!netgpu_prot.stream_memory_read) {
+		netgpu_prot = *sk->sk_prot;
+		netgpu_prot.stream_memory_read = netgpu_stream_memory_read;
+	}
+	sk->sk_prot = &netgpu_prot;
+
+	return 0;
+}
+EXPORT_SYMBOL(netgpu_register_dma);
+
+static int
+netgpu_validate_queue(struct netgpu_user_queue *q, unsigned elt_size,
+		      unsigned map_off)
+{
+	struct shared_queue_map *map;
+	unsigned count;
+	size_t size;
+
+	if (q->elt_sz != elt_size)
+		return -EINVAL;
+
+	count = roundup_pow_of_two(q->entries);
+	if (!count)
+		return -EINVAL;
+	q->entries = count;
+	q->mask = count - 1;
+
+	size = struct_size(map, data, count * elt_size);
+	if (size == SIZE_MAX || size > U32_MAX)
+		return -EOVERFLOW;
+	q->map_sz = size;
+
+	q->map_off = map_off;
+
+	return 0;
+}
+
+static int
+netgpu_validate_param(struct netgpu_ctx *ctx, struct netgpu_params *p)
+{
+	int rc;
+
+	if (ctx->queue_id != -1)
+		return -EALREADY;
+
+	rc = netgpu_validate_queue(&p->fill, sizeof(u64), NETGPU_OFF_FILL_ID);
+	if (rc)
+		return rc;
+
+	rc = netgpu_validate_queue(&p->rx, sizeof(struct iovec),
+				   NETGPU_OFF_RX_ID);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int
+netgpu_queue_create(struct shared_queue *q, struct netgpu_user_queue *u)
+{
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
+			  __GFP_COMP | __GFP_NORETRY;
+	struct shared_queue_map *map;
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
+
+	memset(&u->off, 0, sizeof(u->off));
+	u->off.prod = offsetof(struct shared_queue_map, prod);
+	u->off.cons = offsetof(struct shared_queue_map, cons);
+	u->off.desc = offsetof(struct shared_queue_map, data);
+
+	return 0;
+}
+
+static int
+netgpu_bind_device(struct netgpu_ctx *ctx, int ifindex)
+{
+	struct net_device *dev;
+	int rc;
+
+	dev = dev_get_by_index(&init_net, ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	if (ctx->dev) {
+		rc = dev == ctx->dev ? 0 : -EALREADY;
+		dev_put(dev);
+		return rc;
+	}
+
+	ctx->dev = dev;
+
+	return 0;
+}
+
+static int
+__netgpu_queue_mgmt(struct net_device *dev, struct netgpu_ctx *ctx,
+		    u32 queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+
+	cmd.command = XDP_SETUP_NETGPU;
+	cmd.netgpu.ctx = ctx;
+	cmd.netgpu.queue_id = queue_id;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	return ndo_bpf(dev, &cmd);
+}
+
+static int
+netgpu_open_queue(struct netgpu_ctx *ctx, u32 queue_id)
+{
+	return __netgpu_queue_mgmt(ctx->dev, ctx, queue_id);
+}
+
+static int
+netgpu_close_queue(struct netgpu_ctx *ctx, u32 queue_id)
+{
+	return __netgpu_queue_mgmt(ctx->dev, NULL, queue_id);
+}
+
+static int
+netgpu_bind_queue(struct netgpu_ctx *ctx, void __user *arg)
+{
+	struct netgpu_params p;
+	int rc;
+
+	if (!ctx->dev)
+		return -ENODEV;
+
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	rc = netgpu_validate_param(ctx, &p);
+	if (rc)
+		return rc;
+
+	rc = netgpu_queue_create(&ctx->fill, &p.fill);
+	if (rc)
+		return rc;
+
+	rc = netgpu_queue_create(&ctx->rx, &p.rx);
+	if (rc)
+		return rc;
+
+	rc = netgpu_open_queue(ctx, p.queue_id);
+	if (rc)
+		return rc;
+	ctx->queue_id = p.queue_id;
+
+	if (copy_to_user(arg, &p, sizeof(p)))
+		return -EFAULT;
+		/* XXX leaks ring here ... */
+
+	return rc;
+}
+
+static int
+netgpu_attach_dev(struct netgpu_ctx *ctx, void __user *arg)
+{
+	int ifindex;
+
+	if (copy_from_user(&ifindex, arg, sizeof(ifindex)))
+		return -EFAULT;
+
+	return netgpu_bind_device(ctx, ifindex);
+}
+
+static long
+netgpu_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	struct netgpu_ctx *ctx = netgpu_file_to_ctx(file);
+
+	switch (cmd) {
+	case NETGPU_IOCTL_ATTACH_DEV:
+		return netgpu_attach_dev(ctx, (void __user *)arg);
+
+	case NETGPU_IOCTL_BIND_QUEUE:
+		return netgpu_bind_queue(ctx, (void __user *)arg);
+
+	case NETGPU_IOCTL_ADD_REGION:
+		return netgpu_add_region(ctx, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
+
+static int
+netgpu_show(struct seq_file *seq_file, void *private)
+{
+	return 0;
+}
+
+static struct netgpu_ctx *
+netgpu_create_ctx(void)
+{
+	struct netgpu_ctx *ctx;
+	size_t sz;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->account_mem = !capable(CAP_IPC_LOCK);
+	ctx->user = get_uid(current_user());
+
+	sz = struct_size(ctx->napi_cache, page, NETGPU_CACHE_COUNT);
+	ctx->napi_cache = kmalloc(sz, GFP_KERNEL);
+	if (!ctx->napi_cache)
+		goto out;
+	ctx->napi_cache->next = NULL;
+
+	ctx->dummy_page = alloc_page(GFP_KERNEL);
+	if (!ctx->dummy_page)
+		goto out;
+
+	spin_lock_init(&ctx->pgcache_lock);
+	xa_init(&ctx->xa);
+	refcount_set(&ctx->ref, 1);
+	ctx->queue_id = -1;
+	ctx->any_cache_count = -1;
+
+	/* Set dummy page refs to MAX, with extra to hand out */
+	page_ref_add(ctx->dummy_page, NETGPU_REFC_MAX - 1);
+	ctx->page_extra_refc = NETGPU_REFC_EXTRA;
+
+	return (ctx);
+
+out:
+	free_uid(ctx->user);
+	kfree(ctx->napi_cache);
+	if (ctx->dummy_page)
+		put_page(ctx->dummy_page);
+	kfree(ctx);
+
+	return NULL;
+}
+
+static int
+netgpu_open(struct inode *inode, struct file *file)
+{
+	struct netgpu_ctx *ctx;
+	int err;
+
+	ctx = netgpu_create_ctx();
+	if (!ctx)
+		return -ENOMEM;
+
+	__module_get(THIS_MODULE);
+
+	/* miscdevice inits (but doesn't use) private_data.
+	 * single_open wants to use it, so set to NULL first.
+	 */
+	file->private_data = NULL;
+	err = single_open(file, netgpu_show, ctx);
+	if (err)
+		goto out;
+
+	mutex_lock(&netgpu_lock);
+	ctx->index = ++netgpu_index;
+	mutex_unlock(&netgpu_lock);
+
+	/* XXX retval... */
+	xa_store(&xa_netgpu, ctx->index, ctx, GFP_KERNEL);
+
+	return 0;
+
+out:
+	netgpu_free_ctx(ctx);
+
+	return err;
+}
+
+#ifdef USE_CUDA
+static void
+netgpu_cuda_free_page_range(struct netgpu_page_range *pr)
+{
+	unsigned long pfn, pfn_end;
+	struct page *page;
+
+	pfn_end = pr->pfn +
+		  ((pr->va_node.last + 1 - pr->va_node.start) >> PAGE_SHIFT);
+
+	for (pfn = pr->pfn; pfn < pfn_end; pfn++) {
+		page = pfn_to_page(pfn);
+		set_page_count(page, 0);
+	}
+	netgpu_free_pages(pr->res);
+	kfree(pr);
+}
+
+static void
+netgpu_cuda_release_resources(struct netgpu_region *r)
+{
+	struct pci_dev *pdev;
+	int ret;
+
+	if (r->dmamap) {
+		pdev = netdev2pci_dev(r->ctx->dev);
+		ret = nvidia_p2p_dma_unmap_pages(pdev, r->gpu_pgtbl, r->dmamap);
+		if (ret)
+			pr_err("nvidia_p2p_dma_unmap failed: %d\n", ret);
+	}
+}
+
+static void
+netgpu_cuda_free_region(struct netgpu_region *r)
+{
+	struct interval_tree_node *va_node;
+	int ret;
+
+	netgpu_cuda_release_resources(r);
+
+	region_remove_each(r, va_node)
+		netgpu_cuda_free_page_range(node2page_range(va_node));
+
+	/* NB: this call is a NOP in the current code */
+	ret = nvidia_p2p_free_page_table(r->gpu_pgtbl);
+	if (ret)
+		pr_err("nvidia_p2p_free_page_table error %d\n", ret);
+
+	/* erase if inital store was successful */
+	if (r->ctx) {
+		xa_store_range(&r->ctx->xa, r->start >> PAGE_SHIFT,
+			       (r->start + r->len) >> PAGE_SHIFT,
+			       NULL, GFP_KERNEL);
+		netgpu_free_ctx(r->ctx);
+	}
+
+	kfree(r);
+}
+#endif
+
+static void
+netgpu_host_free_region(struct netgpu_ctx *ctx, struct netgpu_region *r)
+{
+	unsigned nr_pages;
+
+	if (!r->host_memory)
+		return;
+
+	nr_pages = r->len / PAGE_SIZE;
+
+	xa_store_range(&ctx->xa, r->start >> PAGE_SHIFT,
+		      (r->start + r->len) >> PAGE_SHIFT,
+		      NULL, GFP_KERNEL);
+
+	if (ctx->account_mem)
+		netgpu_host_unaccount_mem(ctx->user, nr_pages);
+	netgpu_host_release_pages(r, nr_pages);
+	kvfree(r->page);
+	kvfree(r->pginfo);
+	kfree(r);
+}
+
+static void
+__netgpu_free_ctx(struct netgpu_ctx *ctx)
+{
+	struct netgpu_region *r;
+	unsigned long index;
+
+	xa_for_each(&ctx->xa, index, r)
+		netgpu_host_free_region(ctx, r);
+
+	xa_destroy(&ctx->xa);
+
+	netgpu_free_cache(ctx);
+	free_uid(ctx->user);
+	ctx->page_extra_refc += (NETGPU_REFC_SELF - 1);
+	page_ref_sub(ctx->dummy_page, ctx->page_extra_refc);
+	put_page(ctx->dummy_page);
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
+	int ret;
+
+	if (ctx->queue_id != -1)
+		netgpu_close_queue(ctx, ctx->queue_id);
+
+	xa_erase(&xa_netgpu, ctx->index);
+
+	netgpu_free_ctx(ctx);
+
+	ret = single_release(inode, file);
+
+	return ret;
+}
+
+static void *
+netgpu_validate_mmap_request(struct file *file, loff_t pgoff, size_t sz)
+{
+	struct netgpu_ctx *ctx = netgpu_file_to_ctx(file);
+	loff_t offset = pgoff << PAGE_SHIFT;
+	struct page *page;
+	void *ptr;
+
+	/* each returned ptr is a separate allocation. */
+	switch (offset) {
+	case NETGPU_OFF_FILL_ID:
+		ptr = ctx->fill.map_ptr;
+		break;
+	case NETGPU_OFF_RX_ID:
+		ptr = ctx->rx.map_ptr;
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
+netgpu_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	size_t sz = vma->vm_end - vma->vm_start;
+	unsigned long pfn;
+	void *ptr;
+
+	ptr = netgpu_validate_mmap_request(file, vma->vm_pgoff, sz);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+static const struct file_operations netgpu_fops = {
+	.owner =		THIS_MODULE,
+	.open =			netgpu_open,
+	.mmap =			netgpu_mmap,
+	.unlocked_ioctl =	netgpu_ioctl,
+	.release =		netgpu_release,
+};
+
+static struct miscdevice netgpu_miscdev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "netgpu",
+	.fops		= &netgpu_fops,
+};
+
+static int __init
+netgpu_init(void)
+{
+	mutex_init(&netgpu_lock);
+	misc_register(&netgpu_miscdev);
+
+	return 0;
+}
+
+static void __exit
+netgpu_fini(void)
+{
+	misc_deregister(&netgpu_miscdev);
+}
+
+module_init(netgpu_init);
+module_exit(netgpu_fini);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("jlemon@flugsvamp.com");
diff --git a/include/uapi/misc/netgpu.h b/include/uapi/misc/netgpu.h
new file mode 100644
index 000000000000..ca3338464218
--- /dev/null
+++ b/include/uapi/misc/netgpu.h
@@ -0,0 +1,43 @@
+#pragma once
+
+#include <linux/ioctl.h>
+
+/* VA memory provided by a specific PCI device. */
+struct dma_region {
+	struct iovec iov;
+	unsigned host_memory : 1;
+};
+
+#define NETGPU_OFF_FILL_ID	(0ULL << 12)
+#define NETGPU_OFF_RX_ID	(1ULL << 12)
+
+struct netgpu_queue_offsets {
+	unsigned prod;
+	unsigned cons;
+	unsigned desc;
+	unsigned resv;
+};
+
+struct netgpu_user_queue {
+	unsigned elt_sz;
+	unsigned entries;
+	unsigned mask;
+	unsigned map_sz;
+	unsigned map_off;
+	struct netgpu_queue_offsets off;
+};
+
+struct netgpu_params {
+	unsigned flags;
+	unsigned ifindex;
+	unsigned queue_id;
+	unsigned resv;
+	struct netgpu_user_queue fill;
+	struct netgpu_user_queue rx;
+};
+
+#define NETGPU_IOCTL_ATTACH_DEV		_IOR(0, 1, int)
+#define NETGPU_IOCTL_BIND_QUEUE		_IOWR(0, 2, struct netgpu_params)
+#define NETGPU_IOCTL_SETUP_RING		_IOWR(0, 2, struct netgpu_params)
+#define NETGPU_IOCTL_ADD_REGION		_IOW(0, 3, struct dma_region)
+
-- 
2.24.1

