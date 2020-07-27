Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD13522FC76
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgG0WqQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:46:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgG0WqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:46:12 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RMhEqm012449
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmhknw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:10 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:53 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 0F4593FAB6F83; Mon, 27 Jul 2020 15:44:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Date:   Mon, 27 Jul 2020 15:44:44 -0700
Message-ID: <20200727224444.2987641-22-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1034 bulkscore=0 lowpriorityscore=0 suspectscore=3
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

This provides the interface between the netgpu core module and the
nvidia kernel driver.  This should be built as an external module,
pointing to the nvidia build.  For example:

export NV_PACKAGE_DIR=/w/nvidia/NVIDIA-Linux-x86_64-440.64
make -C ${kdir} M=`pwd` O=obj $*

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/misc/netgpu/nvidia/Kbuild        |   9 +
 drivers/misc/netgpu/nvidia/Kconfig       |  10 +
 drivers/misc/netgpu/nvidia/netgpu_cuda.c | 416 +++++++++++++++++++++++
 3 files changed, 435 insertions(+)
 create mode 100644 drivers/misc/netgpu/nvidia/Kbuild
 create mode 100644 drivers/misc/netgpu/nvidia/Kconfig
 create mode 100644 drivers/misc/netgpu/nvidia/netgpu_cuda.c

diff --git a/drivers/misc/netgpu/nvidia/Kbuild b/drivers/misc/netgpu/nvidia/Kbuild
new file mode 100644
index 000000000000..10a3b3156f30
--- /dev/null
+++ b/drivers/misc/netgpu/nvidia/Kbuild
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+nv_dir = $(NV_PACKAGE_DIR)/kernel
+
+KBUILD_EXTRA_SYMBOLS = $(nv_dir)/Module.symvers
+
+obj-m := netgpu_cuda.o
+
+ccflags-y += -I$(nv_dir)
diff --git a/drivers/misc/netgpu/nvidia/Kconfig b/drivers/misc/netgpu/nvidia/Kconfig
new file mode 100644
index 000000000000..6bb8be158943
--- /dev/null
+++ b/drivers/misc/netgpu/nvidia/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# NetGPU framework
+#
+
+config NETGPU_CUDA
+	tristate "Network/GPU driver for Nvidia"
+	depends on NETGPU && m
+	help
+	  Experimental Network / GPU driver for Nvidia
diff --git a/drivers/misc/netgpu/nvidia/netgpu_cuda.c b/drivers/misc/netgpu/nvidia/netgpu_cuda.c
new file mode 100644
index 000000000000..2cd93dab52ad
--- /dev/null
+++ b/drivers/misc/netgpu/nvidia/netgpu_cuda.c
@@ -0,0 +1,416 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uio.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/memory.h>
+#include <linux/interval_tree.h>
+
+#include <net/netgpu.h>
+#include "../netgpu_priv.h"
+
+#include "nvidia/nv-p2p.h"
+
+/* nvidia GPU uses 64K pages */
+#define GPU_PAGE_SHIFT		16
+#define GPU_PAGE_SIZE		(1UL << GPU_PAGE_SHIFT)
+#define GPU_PAGE_MASK		(GPU_PAGE_SIZE - 1)
+
+struct netgpu_cuda_region {
+	struct netgpu_region r;				/* must be first */
+	struct rb_root_cached root;
+	struct nvidia_p2p_page_table *gpu_pgtbl;
+};
+
+struct netgpu_cuda_dmamap {
+	struct netgpu_dmamap map;			/* must be first */
+	unsigned pg_shift;
+	unsigned long pg_mask;
+	u64 *dma;
+	struct nvidia_p2p_dma_mapping *gpu_map;
+};
+
+/* page_range represents one contiguous GPU PA region */
+struct netgpu_page_range {
+	unsigned long pfn;
+	struct resource *res;
+	struct interval_tree_node va_node;
+};
+
+static int nvidia_pg_shift[] = {
+	[NVIDIA_P2P_PAGE_SIZE_4KB]   = 12,
+	[NVIDIA_P2P_PAGE_SIZE_64KB]  = 16,
+	[NVIDIA_P2P_PAGE_SIZE_128KB] = 17,
+};
+
+#define node2page_range(itn) \
+	container_of(itn, struct netgpu_page_range, va_node)
+
+#define region_remove_each(root, first, last, itn)			\
+	while ((itn = interval_tree_iter_first(root, first, last)) &&	\
+	       (interval_tree_remove(itn, root), 1))
+
+#define cuda_region_remove_each(r, itn)					\
+	region_remove_each(&cuda_region(r)->root, r->start,		\
+			   r->start + (r->nr_pages << PAGE_SHIFT) - 1,	\
+			   itn)
+
+static inline struct netgpu_cuda_region *
+cuda_region(struct netgpu_region *r)
+{
+	return (struct netgpu_cuda_region *)r;
+}
+
+static inline struct netgpu_cuda_dmamap *
+cuda_map(struct netgpu_dmamap *map)
+{
+	return (struct netgpu_cuda_dmamap *)map;
+}
+
+static inline struct netgpu_page_range *
+region_find(struct netgpu_region *r, unsigned long start, int count)
+{
+	struct interval_tree_node *itn;
+	unsigned long last;
+
+	last = start + count * PAGE_SIZE - 1;
+
+	itn = interval_tree_iter_first(&cuda_region(r)->root, start, last);
+	return itn ? node2page_range(itn) : 0;
+}
+
+static dma_addr_t
+netgpu_cuda_get_dma(struct netgpu_dmamap *map, unsigned long addr)
+{
+	unsigned long base, idx;
+
+	base = addr - map->start;
+	idx = base >> cuda_map(map)->pg_shift;
+	return cuda_map(map)->dma[idx] + (base & cuda_map(map)->pg_mask);
+}
+
+static int
+netgpu_cuda_get_page(struct netgpu_dmamap *map, unsigned long addr,
+		     struct page **page, dma_addr_t *dma)
+{
+	struct netgpu_page_range *pr;
+	unsigned long idx;
+
+	pr = region_find(map->r, addr, 1);
+	if (!pr)
+		return -EFAULT;
+	idx = (addr - pr->va_node.start) >> PAGE_SHIFT;
+
+	*page = pfn_to_page(pr->pfn + idx);
+	get_page(*page);
+	*dma = netgpu_cuda_get_dma(map, addr);
+
+	return 0;
+}
+
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
+netgpu_cuda_get_pages(struct netgpu_region *r, struct page **pages,
+		      unsigned long addr, int count)
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
+
+static void
+netgpu_cuda_unmap_region(struct netgpu_dmamap *map)
+{
+	struct pci_dev *pdev;
+	int err;
+
+	pdev = cuda_map(map)->gpu_map->pci_dev;
+
+	err = nvidia_p2p_dma_unmap_pages(pdev, cuda_region(map->r)->gpu_pgtbl,
+					 cuda_map(map)->gpu_map);
+	if (err)
+		pr_err("nvidia_p2p_dma_unmap failed: %d\n", err);
+}
+
+static struct netgpu_dmamap *
+netgpu_cuda_map_region(struct netgpu_region *r, struct device *device)
+{
+	struct netgpu_cuda_region *cr = cuda_region(r);
+	struct nvidia_p2p_dma_mapping *gpu_map;
+	struct netgpu_dmamap *map;
+	struct pci_dev *pdev;
+	int err;
+
+	map = kmalloc(sizeof(struct netgpu_cuda_dmamap), GFP_KERNEL);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	pdev = to_pci_dev(device);
+
+	/*
+	 * takes PA from pgtbl, performs mapping, saves mapping
+	 * dma_mapping holds dma mapped addresses, and pdev.
+	 * mem_info contains pgtbl and mapping list.  mapping is added to list.
+	 * rm_p2p_dma_map_pages() does the work.
+	 */
+	err = nvidia_p2p_dma_map_pages(pdev, cr->gpu_pgtbl, &gpu_map);
+	if (err) {
+		kfree(map);
+		return ERR_PTR(err);
+	}
+
+	cuda_map(map)->gpu_map = gpu_map;
+	cuda_map(map)->dma = gpu_map->dma_addresses;
+	cuda_map(map)->pg_shift = nvidia_pg_shift[gpu_map->page_size_type];
+	cuda_map(map)->pg_mask = (1UL << cuda_map(map)->pg_shift) - 1;
+
+	return map;
+}
+
+static struct resource *
+netgpu_add_pages(int nid, u64 start, u64 end)
+{
+	struct mhp_params params = { .pgprot = PAGE_KERNEL };
+
+	return add_memory_pages(nid, start, end - start, &params);
+}
+
+static void
+netgpu_free_pages(struct resource *res)
+{
+	release_memory_pages(res);
+}
+
+static void
+netgpu_free_page_range(struct netgpu_page_range *pr)
+{
+	unsigned long pfn, pfn_end;
+	struct page *page;
+
+	pfn_end = pr->pfn +
+		  ((pr->va_node.last + 1 - pr->va_node.start) >> PAGE_SHIFT);
+
+	/* XXX verify page count is 2! */
+	for (pfn = pr->pfn; pfn < pfn_end; pfn++) {
+		page = pfn_to_page(pfn);
+		set_page_count(page, 0);
+	}
+	netgpu_free_pages(pr->res);
+	kfree(pr);
+}
+
+static void
+netgpu_cuda_release_pages(struct netgpu_region *r)
+{
+	struct interval_tree_node *va_node;
+
+	cuda_region_remove_each(r, va_node)
+		netgpu_free_page_range(node2page_range(va_node));
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
+		SetPagePrivate(page);
+		set_page_private(page, va);
+		va += PAGE_SIZE;
+	}
+}
+
+static int
+netgpu_add_page_range(struct netgpu_region *r, u64 va, u64 start, u64 end)
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
+	pr->va_node.start = va;
+	pr->va_node.last = va + (end - start) - 1;
+	pr->res = res;
+
+	netgpu_init_pages(va, PHYS_PFN(start), PHYS_PFN(end));
+
+	interval_tree_insert(&pr->va_node, &cuda_region(r)->root);
+
+	return 0;
+}
+
+static void
+netgpu_cuda_pgtbl_cb(void *data)
+{
+	struct netgpu_region *r = data;
+
+	/* This is required - nvidia gets unhappy if the page table is
+	 * freed from the page table callback.
+	 */
+	cuda_region(r)->gpu_pgtbl = NULL;
+	netgpu_detach_region(r);
+}
+
+static struct netgpu_region *
+netgpu_cuda_add_region(struct netgpu_mem *mem, const struct iovec *iov)
+{
+	struct nvidia_p2p_page_table *gpu_pgtbl = NULL;
+	u64 va, pa, len, start, end;
+	struct netgpu_region *r;
+	int err, i, gpu_pgsize;
+
+	err = -ENOMEM;
+	r = kzalloc(sizeof(struct netgpu_cuda_region), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(err);
+
+	start = (u64)iov->iov_base;
+	r->start = round_down(start, GPU_PAGE_SIZE);
+	len = round_up(start - r->start + iov->iov_len, GPU_PAGE_SIZE);
+	r->nr_pages = len >> PAGE_SHIFT;
+
+	r->mem = mem;
+	INIT_LIST_HEAD(&r->ctx_list);
+	INIT_LIST_HEAD(&r->dma_list);
+	spin_lock_init(&r->lock);
+
+	/*
+	 * allocates page table, sets gpu_uuid to owning gpu.
+	 * allocates page array, set PA for each page.
+	 * sets page_size (64K here)
+	 * rm_p2p_get_pages() does the actual work.
+	 */
+	err = nvidia_p2p_get_pages(0, 0, r->start, len, &gpu_pgtbl,
+				   netgpu_cuda_pgtbl_cb, r);
+	if (err)
+		goto out;
+
+	/* gpu pgtbl owns r, will free via netgpu_cuda_pgtbl_cb */
+	cuda_region(r)->gpu_pgtbl = gpu_pgtbl;
+
+	if (!NVIDIA_P2P_PAGE_TABLE_VERSION_COMPATIBLE(gpu_pgtbl)) {
+		pr_err("incompatible page table\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	gpu_pgsize = 1UL << nvidia_pg_shift[gpu_pgtbl->page_size];
+	if (r->nr_pages != gpu_pgtbl->entries * gpu_pgsize / PAGE_SIZE) {
+		pr_err("GPU page count %ld != host page count %ld\n",
+		       gpu_pgtbl->entries * gpu_pgsize / PAGE_SIZE,
+		       r->nr_pages);
+		err = -EINVAL;
+		goto out;
+	}
+
+	start = U64_MAX;
+	end = 0;
+
+	for (i = 0; i < gpu_pgtbl->entries; i++) {
+		pa = gpu_pgtbl->pages[i]->physical_address;
+		if (pa != end) {
+			if (end) {
+				err = netgpu_add_page_range(r, va, start, end);
+				if (err)
+					goto out;
+			}
+			start = pa;
+			va = r->start + i * gpu_pgsize;
+		}
+		end = pa + gpu_pgsize;
+	}
+	err = netgpu_add_page_range(r, va, start, end);
+	if (err)
+		goto out;
+
+	return r;
+
+out:
+	netgpu_cuda_release_pages(r);
+	if (gpu_pgtbl)
+		nvidia_p2p_put_pages(0, 0, r->start, gpu_pgtbl);
+	kfree(r);
+
+	return ERR_PTR(err);
+}
+
+static void
+netgpu_cuda_free_region(struct netgpu_mem *mem, struct netgpu_region *r)
+{
+	netgpu_cuda_release_pages(r);
+	if (cuda_region(r)->gpu_pgtbl)
+		nvidia_p2p_put_pages(0, 0, r->start, cuda_region(r)->gpu_pgtbl);
+	kfree(r);
+}
+
+struct netgpu_ops cuda_ops = {
+	.owner		= THIS_MODULE,
+	.memtype	= NETGPU_MEMTYPE_CUDA,
+	.add_region	= netgpu_cuda_add_region,
+	.free_region	= netgpu_cuda_free_region,
+	.map_region	= netgpu_cuda_map_region,
+	.unmap_region	= netgpu_cuda_unmap_region,
+	.get_dma	= netgpu_cuda_get_dma,
+	.get_page	= netgpu_cuda_get_page,
+	.get_pages	= netgpu_cuda_get_pages,
+};
+
+static int __init
+netgpu_cuda_init(void)
+{
+	return netgpu_register(&cuda_ops);
+}
+
+static void __exit
+netgpu_cuda_fini(void)
+{
+	netgpu_unregister(cuda_ops.memtype);
+}
+
+module_init(netgpu_cuda_init);
+module_exit(netgpu_cuda_fini);
+MODULE_LICENSE("GPL v2");
-- 
2.24.1

