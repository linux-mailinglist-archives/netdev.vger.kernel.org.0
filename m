Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CD41AE369
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgDQRNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:30114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgDQRNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:04 -0400
IronPort-SDR: v/aiqpK+fBlvxoezLxrlD7IWOOrxInJcTXxcCMXJ37G0ug8M6pggcm0xjHiDei92Lzo4A0T5fy
 yRTycVb+xYxg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:56 -0700
IronPort-SDR: gZXZQVFtFSrdK8BfIhrmTyreNQxaA0h56VpnuGLBlrjCSa7lwJxxPjQNne109cr/knknmnv4MF
 4UZs7xxNtJlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383726"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:56 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 08/16] RDMA/irdma: Add PBLE resource manager
Date:   Fri, 17 Apr 2020 10:12:43 -0700
Message-Id: <20200417171251.1533371-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Implement a Physical Buffer List Entry (PBLE) resource manager
to manage a pool of PBLE HMC resource objects.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/pble.c | 510 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/pble.h | 135 ++++++++
 2 files changed, 645 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/pble.c
 create mode 100644 drivers/infiniband/hw/irdma/pble.h

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
new file mode 100644
index 000000000000..225083726d2f
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+#include "pble.h"
+
+static enum irdma_status_code
+add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc);
+
+/**
+ * irdma_destroy_pble_prm - destroy prm during module unload
+ * @pble_rsrc: pble resources
+ */
+void irdma_destroy_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
+{
+	struct irdma_chunk *chunk;
+	struct irdma_pble_prm *pinfo = &pble_rsrc->pinfo;
+
+	while (!list_empty(&pinfo->clist)) {
+		chunk = (struct irdma_chunk *)pinfo->clist.next;
+		list_del(&chunk->list);
+		if (chunk->type == PBLE_SD_PAGED)
+			irdma_pble_free_paged_mem(chunk);
+		if (chunk->bitmapbuf)
+			kfree(chunk->bitmapmem.va);
+		kfree(chunk->chunkmem.va);
+	}
+}
+
+/**
+ * irdma_hmc_init_pble - Initialize pble resources during module load
+ * @dev: irdma_sc_dev struct
+ * @pble_rsrc: pble resources
+ */
+enum irdma_status_code
+irdma_hmc_init_pble(struct irdma_sc_dev *dev,
+		    struct irdma_hmc_pble_rsrc *pble_rsrc)
+{
+	struct irdma_hmc_info *hmc_info;
+	u32 fpm_idx = 0;
+	enum irdma_status_code status = 0;
+
+	hmc_info = dev->hmc_info;
+	pble_rsrc->dev = dev;
+	pble_rsrc->fpm_base_addr = hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].base;
+	/* Start pble' on 4k boundary */
+	if (pble_rsrc->fpm_base_addr & 0xfff)
+		fpm_idx = (4096 - (pble_rsrc->fpm_base_addr & 0xfff)) >> 3;
+	pble_rsrc->unallocated_pble =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt - fpm_idx;
+	pble_rsrc->next_fpm_addr = pble_rsrc->fpm_base_addr + (fpm_idx << 3);
+	pble_rsrc->pinfo.pble_shift = PBLE_SHIFT;
+
+	spin_lock_init(&pble_rsrc->pinfo.prm_lock);
+	INIT_LIST_HEAD(&pble_rsrc->pinfo.clist);
+	if (add_pble_prm(pble_rsrc)) {
+		irdma_destroy_pble_prm(pble_rsrc);
+		status = IRDMA_ERR_NO_MEMORY;
+	}
+
+	return status;
+}
+
+/**
+ * get_sd_pd_idx -  Returns sd index, pd index and rel_pd_idx from fpm address
+ * @pble_rsrc: structure containing fpm address
+ * @idx: where to return indexes
+ */
+static void get_sd_pd_idx(struct irdma_hmc_pble_rsrc *pble_rsrc,
+			  struct sd_pd_idx *idx)
+{
+	idx->sd_idx = (u32)pble_rsrc->next_fpm_addr / IRDMA_HMC_DIRECT_BP_SIZE;
+	idx->pd_idx = (u32)(pble_rsrc->next_fpm_addr / IRDMA_HMC_PAGED_BP_SIZE);
+	idx->rel_pd_idx = (idx->pd_idx % IRDMA_HMC_PD_CNT_IN_SD);
+}
+
+/**
+ * add_sd_direct - add sd direct for pble
+ * @pble_rsrc: pble resource ptr
+ * @info: page info for sd
+ */
+static enum irdma_status_code
+add_sd_direct(struct irdma_hmc_pble_rsrc *pble_rsrc,
+	      struct irdma_add_page_info *info)
+{
+	struct irdma_sc_dev *dev = pble_rsrc->dev;
+	enum irdma_status_code ret_code = 0;
+	struct sd_pd_idx *idx = &info->idx;
+	struct irdma_chunk *chunk = info->chunk;
+	struct irdma_hmc_info *hmc_info = info->hmc_info;
+	struct irdma_hmc_sd_entry *sd_entry = info->sd_entry;
+	u32 offset = 0;
+
+	if (!sd_entry->valid) {
+		ret_code = irdma_add_sd_table_entry(dev->hw, hmc_info,
+						    info->idx.sd_idx,
+						    IRDMA_SD_TYPE_DIRECT,
+						    IRDMA_HMC_DIRECT_BP_SIZE);
+		if (ret_code)
+			return ret_code;
+
+		chunk->type = PBLE_SD_CONTIGOUS;
+	}
+
+	offset = idx->rel_pd_idx << HMC_PAGED_BP_SHIFT;
+	chunk->size = info->pages << HMC_PAGED_BP_SHIFT;
+	chunk->vaddr = (uintptr_t)(sd_entry->u.bp.addr.va + offset);
+	chunk->fpm_addr = pble_rsrc->next_fpm_addr;
+	dev_dbg(rfdev_to_dev(dev),
+		"PBLE: chunk_size[%lld] = 0x%llx vaddr=0x%llx fpm_addr = %llx\n",
+		chunk->size, chunk->size, chunk->vaddr, chunk->fpm_addr);
+
+	return 0;
+}
+
+/**
+ * fpm_to_idx - given fpm address, get pble index
+ * @pble_rsrc: pble resource management
+ * @addr: fpm address for index
+ */
+static u32 fpm_to_idx(struct irdma_hmc_pble_rsrc *pble_rsrc, u64 addr)
+{
+	u64 idx;
+
+	idx = (addr - (pble_rsrc->fpm_base_addr)) >> 3;
+
+	return (u32)idx;
+}
+
+/**
+ * add_bp_pages - add backing pages for sd
+ * @pble_rsrc: pble resource management
+ * @info: page info for sd
+ */
+static enum irdma_status_code
+add_bp_pages(struct irdma_hmc_pble_rsrc *pble_rsrc,
+	     struct irdma_add_page_info *info)
+{
+	struct irdma_sc_dev *dev = pble_rsrc->dev;
+	u8 *addr;
+	struct irdma_dma_mem mem;
+	struct irdma_hmc_pd_entry *pd_entry;
+	struct irdma_hmc_sd_entry *sd_entry = info->sd_entry;
+	struct irdma_hmc_info *hmc_info = info->hmc_info;
+	struct irdma_chunk *chunk = info->chunk;
+	enum irdma_status_code status = 0;
+	u32 rel_pd_idx = info->idx.rel_pd_idx;
+	u32 pd_idx = info->idx.pd_idx;
+	u32 i;
+
+	if (irdma_pble_get_paged_mem(chunk, info->pages))
+		return IRDMA_ERR_NO_MEMORY;
+
+	status = irdma_add_sd_table_entry(dev->hw, hmc_info, info->idx.sd_idx,
+					  IRDMA_SD_TYPE_PAGED,
+					  IRDMA_HMC_DIRECT_BP_SIZE);
+
+	if (status)
+		goto error;
+
+	addr = (u8 *)(uintptr_t)chunk->vaddr;
+	for (i = 0; i < info->pages; i++) {
+		mem.pa = (u64)chunk->dmainfo.dmaaddrs[i];
+		mem.size = 4096;
+		mem.va = addr;
+		pd_entry = &sd_entry->u.pd_table.pd_entry[rel_pd_idx++];
+		if (!pd_entry->valid) {
+			status = irdma_add_pd_table_entry(dev, hmc_info,
+							  pd_idx++, &mem);
+			if (status)
+				goto error;
+
+			addr += 4096;
+		}
+	}
+
+	chunk->fpm_addr = pble_rsrc->next_fpm_addr;
+	return 0;
+
+error:
+	irdma_pble_free_paged_mem(chunk);
+
+	return status;
+}
+
+/**
+ * add_pble_prm - add a sd entry for pble resoure
+ * @pble_rsrc: pble resource management
+ */
+static enum irdma_status_code
+add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
+{
+	struct irdma_sc_dev *dev = pble_rsrc->dev;
+	struct irdma_hmc_sd_entry *sd_entry;
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_chunk *chunk;
+	struct irdma_add_page_info info;
+	struct sd_pd_idx *idx = &info.idx;
+	enum irdma_status_code ret_code = 0;
+	enum irdma_sd_entry_type sd_entry_type;
+	u64 sd_reg_val = 0;
+	struct irdma_virt_mem chunkmem;
+	u32 pages;
+
+	if (pble_rsrc->unallocated_pble < PBLE_PER_PAGE)
+		return IRDMA_ERR_NO_MEMORY;
+
+	if (pble_rsrc->next_fpm_addr & 0xfff)
+		return IRDMA_ERR_INVALID_PAGE_DESC_INDEX;
+
+	chunkmem.size = sizeof(*chunk);
+	chunkmem.va = kzalloc(chunkmem.size, GFP_ATOMIC);
+	if (!chunkmem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	chunk = chunkmem.va;
+	chunk->chunkmem = chunkmem;
+	hmc_info = dev->hmc_info;
+	chunk->dev = dev;
+	chunk->fpm_addr = pble_rsrc->next_fpm_addr;
+	get_sd_pd_idx(pble_rsrc, idx);
+	sd_entry = &hmc_info->sd_table.sd_entry[idx->sd_idx];
+	pages = (idx->rel_pd_idx) ? (IRDMA_HMC_PD_CNT_IN_SD - idx->rel_pd_idx) :
+				    IRDMA_HMC_PD_CNT_IN_SD;
+	pages = min(pages, pble_rsrc->unallocated_pble >> PBLE_512_SHIFT);
+	info.chunk = chunk;
+	info.hmc_info = hmc_info;
+	info.pages = pages;
+	info.sd_entry = sd_entry;
+	if (!sd_entry->valid)
+		sd_entry_type = (!idx->rel_pd_idx &&
+				 (pages == IRDMA_HMC_PD_CNT_IN_SD) &&
+				 dev->privileged) ?
+				 IRDMA_SD_TYPE_DIRECT : IRDMA_SD_TYPE_PAGED;
+	else
+		sd_entry_type = sd_entry->entry_type;
+
+	dev_dbg(rfdev_to_dev(dev),
+		"PBLE: pages = %d, unallocated_pble[%d] current_fpm_addr = %llx\n",
+		pages, pble_rsrc->unallocated_pble, pble_rsrc->next_fpm_addr);
+	dev_dbg(rfdev_to_dev(dev), "PBLE: sd_entry_type = %d\n",
+		sd_entry_type);
+	if (sd_entry_type == IRDMA_SD_TYPE_DIRECT)
+		ret_code = add_sd_direct(pble_rsrc, &info);
+
+	if (ret_code)
+		sd_entry_type = IRDMA_SD_TYPE_PAGED;
+	else
+		pble_rsrc->stats_direct_sds++;
+
+	if (sd_entry_type == IRDMA_SD_TYPE_PAGED) {
+		ret_code = add_bp_pages(pble_rsrc, &info);
+		if (ret_code)
+			goto error;
+		else
+			pble_rsrc->stats_paged_sds++;
+	}
+
+	ret_code = irdma_prm_add_pble_mem(&pble_rsrc->pinfo, chunk);
+	if (ret_code)
+		goto error;
+
+	pble_rsrc->next_fpm_addr += chunk->size;
+	dev_dbg(rfdev_to_dev(dev),
+		"PBLE: next_fpm_addr = %llx chunk_size[%llu] = 0x%llx\n",
+		pble_rsrc->next_fpm_addr, chunk->size, chunk->size);
+	pble_rsrc->unallocated_pble -= (u32)(chunk->size >> 3);
+	list_add(&chunk->list, &pble_rsrc->pinfo.clist);
+	sd_reg_val = (sd_entry_type == IRDMA_SD_TYPE_PAGED) ?
+			     sd_entry->u.pd_table.pd_page_addr.pa :
+			     sd_entry->u.bp.addr.pa;
+	if (sd_entry->valid)
+		return 0;
+
+	if (dev->privileged) {
+		ret_code = irdma_hmc_sd_one(dev, hmc_info->hmc_fn_id,
+					    sd_reg_val, idx->sd_idx,
+					    sd_entry->entry_type, true);
+		if (ret_code)
+			goto error;
+	}
+
+	sd_entry->valid = true;
+	return 0;
+
+error:
+	if (chunk->bitmapbuf)
+		kfree(chunk->bitmapmem.va);
+
+	kfree(chunk->chunkmem.va);
+
+	return ret_code;
+}
+
+/**
+ * free_lvl2 - fee level 2 pble
+ * @pble_rsrc: pble resource management
+ * @palloc: level 2 pble allocation
+ */
+static void free_lvl2(struct irdma_hmc_pble_rsrc *pble_rsrc,
+		      struct irdma_pble_alloc *palloc)
+{
+	u32 i;
+	struct irdma_pble_level2 *lvl2 = &palloc->level2;
+	struct irdma_pble_info *root = &lvl2->root;
+	struct irdma_pble_info *leaf = lvl2->leaf;
+
+	for (i = 0; i < lvl2->leaf_cnt; i++, leaf++) {
+		if (leaf->addr)
+			irdma_prm_return_pbles(&pble_rsrc->pinfo,
+					       &leaf->chunkinfo);
+		else
+			break;
+	}
+
+	if (root->addr)
+		irdma_prm_return_pbles(&pble_rsrc->pinfo, &root->chunkinfo);
+
+	kfree(lvl2->leafmem.va);
+	lvl2->leaf = NULL;
+}
+
+/**
+ * get_lvl2_pble - get level 2 pble resource
+ * @pble_rsrc: pble resource management
+ * @palloc: level 2 pble allocation
+ */
+static enum irdma_status_code
+get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+	      struct irdma_pble_alloc *palloc)
+{
+	u32 lf4k, lflast, total, i;
+	u32 pblcnt = PBLE_PER_PAGE;
+	u64 *addr;
+	struct irdma_pble_level2 *lvl2 = &palloc->level2;
+	struct irdma_pble_info *root = &lvl2->root;
+	struct irdma_pble_info *leaf;
+	enum irdma_status_code ret_code;
+	u64 fpm_addr;
+
+	/* number of full 512 (4K) leafs) */
+	lf4k = palloc->total_cnt >> 9;
+	lflast = palloc->total_cnt % PBLE_PER_PAGE;
+	total = (lflast == 0) ? lf4k : lf4k + 1;
+	lvl2->leaf_cnt = total;
+
+	lvl2->leafmem.size = (sizeof(*leaf) * total);
+	lvl2->leafmem.va = kzalloc(lvl2->leafmem.size, GFP_ATOMIC);
+	if (!lvl2->leafmem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	lvl2->leaf = lvl2->leafmem.va;
+	leaf = lvl2->leaf;
+	ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo, &root->chunkinfo,
+				       total << 3, &root->addr, &fpm_addr);
+	if (ret_code) {
+		kfree(lvl2->leafmem.va);
+		lvl2->leaf = NULL;
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	root->idx = fpm_to_idx(pble_rsrc, fpm_addr);
+	root->cnt = total;
+	addr = (u64 *)(uintptr_t)root->addr;
+	for (i = 0; i < total; i++, leaf++) {
+		pblcnt = (lflast && ((i + 1) == total)) ?
+				lflast : PBLE_PER_PAGE;
+		ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo,
+					       &leaf->chunkinfo, pblcnt << 3,
+					       &leaf->addr, &fpm_addr);
+		if (ret_code)
+			goto error;
+
+		leaf->idx = fpm_to_idx(pble_rsrc, fpm_addr);
+
+		leaf->cnt = pblcnt;
+		*addr = (u64)leaf->idx;
+		addr++;
+	}
+
+	palloc->level = PBLE_LEVEL_2;
+	pble_rsrc->stats_lvl2++;
+	return 0;
+
+error:
+	free_lvl2(pble_rsrc, palloc);
+
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * get_lvl1_pble - get level 1 pble resource
+ * @pble_rsrc: pble resource management
+ * @palloc: level 1 pble allocation
+ */
+static enum irdma_status_code
+get_lvl1_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+	      struct irdma_pble_alloc *palloc)
+{
+	enum irdma_status_code ret_code;
+	u64 fpm_addr, vaddr;
+	struct irdma_pble_info *lvl1 = &palloc->level1;
+
+	ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo, &lvl1->chunkinfo,
+				       palloc->total_cnt << 3, &vaddr,
+				       &fpm_addr);
+	if (ret_code)
+		return IRDMA_ERR_NO_MEMORY;
+
+	lvl1->addr = vaddr;
+	palloc->level = PBLE_LEVEL_1;
+	lvl1->idx = fpm_to_idx(pble_rsrc, fpm_addr);
+	lvl1->cnt = palloc->total_cnt;
+	pble_rsrc->stats_lvl1++;
+
+	return 0;
+}
+
+/**
+ * get_lvl1_lvl2_pble - calls get_lvl1 and get_lvl2 pble routine
+ * @pble_rsrc: pble resources
+ * @palloc: contains all inforamtion regarding pble (idx + pble addr)
+ * @level1_only: flag for a level 1 PBLE
+ */
+static enum irdma_status_code
+get_lvl1_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+		   struct irdma_pble_alloc *palloc, bool level1_only)
+{
+	enum irdma_status_code status = 0;
+
+	status = get_lvl1_pble(pble_rsrc, palloc);
+	if (!status || level1_only || palloc->total_cnt <= PBLE_PER_PAGE)
+		return status;
+
+	status = get_lvl2_pble(pble_rsrc, palloc);
+
+	return status;
+}
+
+/**
+ * irdma_get_pble - allocate pbles from the prm
+ * @pble_rsrc: pble resources
+ * @palloc: contains all inforamtion regarding pble (idx + pble addr)
+ * @pble_cnt: #of pbles requested
+ * @level1_only: true if only pble level 1 to acquire
+ */
+enum irdma_status_code irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+				      struct irdma_pble_alloc *palloc,
+				      u32 pble_cnt, bool level1_only)
+{
+	enum irdma_status_code status = 0;
+	unsigned long flags;
+	int max_sds = 0;
+	int i;
+
+	palloc->total_cnt = pble_cnt;
+	palloc->level = PBLE_LEVEL_0;
+	spin_lock_irqsave(&pble_rsrc->pble_lock, flags);
+	/*check first to see if we can get pble's without acquiring
+	 * additional sd's
+	 */
+	status = get_lvl1_lvl2_pble(pble_rsrc, palloc, level1_only);
+	if (!status)
+		goto exit;
+
+	max_sds = (palloc->total_cnt >> 18) + 1;
+	for (i = 0; i < max_sds; i++) {
+		status = add_pble_prm(pble_rsrc);
+		if (status)
+			break;
+
+		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, level1_only);
+		/* if level1_only, only go through it once */
+		if (!status || level1_only)
+			break;
+	}
+
+exit:
+	if (!status) {
+		pble_rsrc->allocdpbles += pble_cnt;
+		pble_rsrc->stats_alloc_ok++;
+	} else {
+		pble_rsrc->stats_alloc_fail++;
+	}
+	spin_unlock_irqrestore(&pble_rsrc->pble_lock, flags);
+
+	return status;
+}
+
+/**
+ * irdma_free_pble - put pbles back into prm
+ * @pble_rsrc: pble resources
+ * @palloc: contains all information regarding pble resource being freed
+ */
+void irdma_free_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+		     struct irdma_pble_alloc *palloc)
+{
+	pble_rsrc->freedpbles += palloc->total_cnt;
+
+	if (palloc->level == PBLE_LEVEL_2)
+		free_lvl2(pble_rsrc, palloc);
+	else
+		irdma_prm_return_pbles(&pble_rsrc->pinfo,
+				       &palloc->level1.chunkinfo);
+	pble_rsrc->stats_alloc_freed++;
+}
diff --git a/drivers/infiniband/hw/irdma/pble.h b/drivers/infiniband/hw/irdma/pble.h
new file mode 100644
index 000000000000..59ed2c28ad11
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/pble.h
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_PBLE_H
+#define IRDMA_PBLE_H
+
+#define PBLE_SHIFT		6
+#define PBLE_PER_PAGE		512
+#define HMC_PAGED_BP_SHIFT	12
+#define PBLE_512_SHIFT		9
+#define PBLE_INVALID_IDX	0xffffffff
+
+enum irdma_pble_level {
+	PBLE_LEVEL_0 = 0,
+	PBLE_LEVEL_1 = 1,
+	PBLE_LEVEL_2 = 2,
+};
+
+enum irdma_alloc_type {
+	PBLE_NO_ALLOC	  = 0,
+	PBLE_SD_CONTIGOUS = 1,
+	PBLE_SD_PAGED	  = 2,
+};
+
+struct irdma_chunk;
+
+struct irdma_pble_chunkinfo {
+	struct irdma_chunk *pchunk;
+	u64 bit_idx;
+	u64 bits_used;
+};
+
+struct irdma_pble_info {
+	u64 addr;
+	u32 idx;
+	u32 cnt;
+	struct irdma_pble_chunkinfo chunkinfo;
+};
+
+struct irdma_pble_level2 {
+	struct irdma_pble_info root;
+	struct irdma_pble_info *leaf;
+	struct irdma_virt_mem leafmem;
+	u32 leaf_cnt;
+};
+
+struct irdma_pble_alloc {
+	u32 total_cnt;
+	enum irdma_pble_level level;
+	union {
+		struct irdma_pble_info level1;
+		struct irdma_pble_level2 level2;
+	};
+};
+
+struct sd_pd_idx {
+	u32 sd_idx;
+	u32 pd_idx;
+	u32 rel_pd_idx;
+};
+
+struct irdma_add_page_info {
+	struct irdma_chunk *chunk;
+	struct irdma_hmc_sd_entry *sd_entry;
+	struct irdma_hmc_info *hmc_info;
+	struct sd_pd_idx idx;
+	u32 pages;
+};
+
+struct irdma_chunk {
+	struct list_head list;
+	struct irdma_dma_info dmainfo;
+	void *bitmapbuf;
+
+	u32 sizeofbitmap;
+	u64 size;
+	u64 vaddr;
+	u64 fpm_addr;
+	u32 pg_cnt;
+	enum irdma_alloc_type type;
+	struct irdma_sc_dev *dev;
+	struct irdma_virt_mem bitmapmem;
+	struct irdma_virt_mem chunkmem;
+};
+
+struct irdma_pble_prm {
+	struct list_head clist;
+	spinlock_t prm_lock; /* protect prm bitmap */
+	u64 total_pble_alloc;
+	u64 free_pble_cnt;
+	u8 pble_shift;
+};
+
+struct irdma_hmc_pble_rsrc {
+	u32 unallocated_pble;
+	spinlock_t pble_lock; /* to serialize PBLE resource acquisition */
+	struct irdma_sc_dev *dev;
+	u64 fpm_base_addr;
+	u64 next_fpm_addr;
+	struct irdma_pble_prm pinfo;
+	u64 allocdpbles;
+	u64 freedpbles;
+	u32 stats_direct_sds;
+	u32 stats_paged_sds;
+	u64 stats_alloc_ok;
+	u64 stats_alloc_fail;
+	u64 stats_alloc_freed;
+	u64 stats_lvl1;
+	u64 stats_lvl2;
+};
+
+void irdma_destroy_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc);
+enum irdma_status_code
+irdma_hmc_init_pble(struct irdma_sc_dev *dev,
+		    struct irdma_hmc_pble_rsrc *pble_rsrc);
+void irdma_free_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+		     struct irdma_pble_alloc *palloc);
+enum irdma_status_code irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
+				      struct irdma_pble_alloc *palloc,
+				      u32 pble_cnt, bool level1_only);
+enum irdma_status_code irdma_prm_add_pble_mem(struct irdma_pble_prm *pprm,
+					      struct irdma_chunk *pchunk);
+enum irdma_status_code
+irdma_prm_get_pbles(struct irdma_pble_prm *pprm,
+		    struct irdma_pble_chunkinfo *chunkinfo, u32 mem_size,
+		    u64 *vaddr, u64 *fpm_addr);
+void irdma_prm_return_pbles(struct irdma_pble_prm *pprm,
+			    struct irdma_pble_chunkinfo *chunkinfo);
+void irdma_pble_acquire_lock(struct irdma_hmc_pble_rsrc *pble_rsrc,
+			     unsigned long *flags);
+void irdma_pble_release_lock(struct irdma_hmc_pble_rsrc *pble_rsrc,
+			     unsigned long *flags);
+void irdma_pble_free_paged_mem(struct irdma_chunk *chunk);
+enum irdma_status_code irdma_pble_get_paged_mem(struct irdma_chunk *chunk,
+						int pg_cnt);
+#endif /* IRDMA_PBLE_H */
-- 
2.25.2

