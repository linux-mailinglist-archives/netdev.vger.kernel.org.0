Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF731AE364
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgDQRM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:12:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbgDQRM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:12:57 -0400
IronPort-SDR: jdL7i2YnOejqdpy8P265YTw4F8ZCsM9wPX0z5ogKlhGPJq5Mo5D1Byx/OsalXag0obyFtOIHvi
 ua9LIMyJ10Eg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:55 -0700
IronPort-SDR: aYenHFYPSvhyKDL0KecViGrqokp2ZsvODdn6j8TwwoBcKwERPheBVWj/aWNPbAmEkg+YTzyUPe
 Ml1d5BfSkehA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383710"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 04/16] RDMA/irdma: Add HMC backing store setup functions
Date:   Fri, 17 Apr 2020 10:12:39 -0700
Message-Id: <20200417171251.1533371-5-jeffrey.t.kirsher@intel.com>
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

HW uses host memory as a backing store for a number of
protocol context objects and queue state tracking.
The Host Memory Cache (HMC) is a component responsible for
managing these objects stored in host memory.

Add the functions and data structures to manage the allocation
of backing pages used by the HMC for the various objects

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/hmc.c | 705 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/hmc.h | 217 +++++++++
 2 files changed, 922 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/hmc.c
 create mode 100644 drivers/infiniband/hw/irdma/hmc.h

diff --git a/drivers/infiniband/hw/irdma/hmc.c b/drivers/infiniband/hw/irdma/hmc.c
new file mode 100644
index 000000000000..a5928030947c
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/hmc.c
@@ -0,0 +1,705 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+
+/**
+ * irdma_find_sd_index_limit - finds segment descriptor index limit
+ * @hmc_info: pointer to the HMC configuration information structure
+ * @type: type of HMC resources we're searching
+ * @idx: starting index for the object
+ * @cnt: number of objects we're trying to create
+ * @sd_idx: pointer to return index of the segment descriptor in question
+ * @sd_limit: pointer to return the maximum number of segment descriptors
+ *
+ * This function calculates the segment descriptor index and index limit
+ * for the resource defined by irdma_hmc_rsrc_type.
+ */
+
+static void irdma_find_sd_index_limit(struct irdma_hmc_info *hmc_info, u32 type,
+				      u32 idx, u32 cnt, u32 *sd_idx,
+				      u32 *sd_limit)
+{
+	u64 fpm_addr, fpm_limit;
+
+	fpm_addr = hmc_info->hmc_obj[(type)].base +
+		   hmc_info->hmc_obj[type].size * idx;
+	fpm_limit = fpm_addr + hmc_info->hmc_obj[type].size * cnt;
+	*sd_idx = (u32)(fpm_addr / IRDMA_HMC_DIRECT_BP_SIZE);
+	*sd_limit = (u32)((fpm_limit - 1) / IRDMA_HMC_DIRECT_BP_SIZE);
+	*sd_limit += 1;
+}
+
+/**
+ * irdma_find_pd_index_limit - finds page descriptor index limit
+ * @hmc_info: pointer to the HMC configuration information struct
+ * @type: HMC resource type we're examining
+ * @idx: starting index for the object
+ * @cnt: number of objects we're trying to create
+ * @pd_idx: pointer to return page descriptor index
+ * @pd_limit: pointer to return page descriptor index limit
+ *
+ * Calculates the page descriptor index and index limit for the resource
+ * defined by irdma_hmc_rsrc_type.
+ */
+
+static void irdma_find_pd_index_limit(struct irdma_hmc_info *hmc_info, u32 type,
+				      u32 idx, u32 cnt, u32 *pd_idx,
+				      u32 *pd_limit)
+{
+	u64 fpm_adr, fpm_limit;
+
+	fpm_adr = hmc_info->hmc_obj[type].base +
+		  hmc_info->hmc_obj[type].size * idx;
+	fpm_limit = fpm_adr + (hmc_info)->hmc_obj[(type)].size * (cnt);
+	*pd_idx = (u32)(fpm_adr / IRDMA_HMC_PAGED_BP_SIZE);
+	*pd_limit = (u32)((fpm_limit - 1) / IRDMA_HMC_PAGED_BP_SIZE);
+	*pd_limit += 1;
+}
+
+/**
+ * irdma_set_sd_entry - setup entry for sd programming
+ * @pa: physical addr
+ * @idx: sd index
+ * @type: paged or direct sd
+ * @entry: sd entry ptr
+ */
+static void irdma_set_sd_entry(u64 pa, u32 idx, enum irdma_sd_entry_type type,
+			       struct irdma_update_sd_entry *entry)
+{
+	entry->data = pa | (IRDMA_HMC_MAX_BP_COUNT << IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT_S) |
+		      (((type == IRDMA_SD_TYPE_PAGED) ? 0 : 1) << IRDMA_PFHMC_SDDATALOW_PMSDTYPE_S) |
+		      (1 << IRDMA_PFHMC_SDDATALOW_PMSDVALID_S);
+	entry->cmd = (idx | (1 << IRDMA_PFHMC_SDCMD_PMSDWR_S) | (1 << 15));
+}
+
+/**
+ * irdma_clr_sd_entry - setup entry for sd clear
+ * @idx: sd index
+ * @type: paged or direct sd
+ * @entry: sd entry ptr
+ */
+static void irdma_clr_sd_entry(u32 idx, enum irdma_sd_entry_type type,
+			       struct irdma_update_sd_entry *entry)
+{
+	entry->data = (IRDMA_HMC_MAX_BP_COUNT << IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT_S) |
+		      (((type == IRDMA_SD_TYPE_PAGED) ? 0 : 1) << IRDMA_PFHMC_SDDATALOW_PMSDTYPE_S);
+	entry->cmd = (idx | (1 << IRDMA_PFHMC_SDCMD_PMSDWR_S) | (1 << 15));
+}
+
+/**
+ * irdma_hmc_sd_one - setup 1 sd entry for cqp
+ * @dev: pointer to the device structure
+ * @hmc_fn_id: hmc's function id
+ * @pa: physical addr
+ * @sd_idx: sd index
+ * @type: paged or direct sd
+ * @setsd: flag to set or clear sd
+ */
+enum irdma_status_code irdma_hmc_sd_one(struct irdma_sc_dev *dev, u8 hmc_fn_id,
+					u64 pa, u32 sd_idx,
+					enum irdma_sd_entry_type type,
+					bool setsd)
+{
+	struct irdma_update_sds_info sdinfo;
+
+	sdinfo.cnt = 1;
+	sdinfo.hmc_fn_id = hmc_fn_id;
+	if (setsd)
+		irdma_set_sd_entry(pa, sd_idx, type, sdinfo.entry);
+	else
+		irdma_clr_sd_entry(sd_idx, type, sdinfo.entry);
+	return dev->cqp->process_cqp_sds(dev, &sdinfo);
+}
+
+/**
+ * irdma_hmc_sd_grp - setup group of sd entries for cqp
+ * @dev: pointer to the device structure
+ * @hmc_info: pointer to the HMC configuration information struct
+ * @sd_index: sd index
+ * @sd_cnt: number of sd entries
+ * @setsd: flag to set or clear sd
+ */
+static enum irdma_status_code irdma_hmc_sd_grp(struct irdma_sc_dev *dev,
+					       struct irdma_hmc_info *hmc_info,
+					       u32 sd_index, u32 sd_cnt,
+					       bool setsd)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+	struct irdma_update_sds_info sdinfo = {};
+	u64 pa;
+	u32 i;
+	enum irdma_status_code ret_code = 0;
+
+	sdinfo.hmc_fn_id = hmc_info->hmc_fn_id;
+	for (i = sd_index; i < sd_index + sd_cnt; i++) {
+		sd_entry = &hmc_info->sd_table.sd_entry[i];
+		if (!sd_entry || (!sd_entry->valid && setsd) ||
+		    (sd_entry->valid && !setsd))
+			continue;
+		if (setsd) {
+			pa = (sd_entry->entry_type == IRDMA_SD_TYPE_PAGED) ?
+				     sd_entry->u.pd_table.pd_page_addr.pa :
+				     sd_entry->u.bp.addr.pa;
+			irdma_set_sd_entry(pa, i, sd_entry->entry_type,
+					   &sdinfo.entry[sdinfo.cnt]);
+		} else {
+			irdma_clr_sd_entry(i, sd_entry->entry_type,
+					   &sdinfo.entry[sdinfo.cnt]);
+		}
+		sdinfo.cnt++;
+		if (sdinfo.cnt == IRDMA_MAX_SD_ENTRIES) {
+			ret_code = dev->cqp->process_cqp_sds(dev, &sdinfo);
+			if (ret_code) {
+				dev_dbg(rfdev_to_dev(dev),
+					"HMC: sd_programming failed err=%d\n",
+					ret_code);
+				return ret_code;
+			}
+
+			sdinfo.cnt = 0;
+		}
+	}
+	if (sdinfo.cnt)
+		ret_code = dev->cqp->process_cqp_sds(dev, &sdinfo);
+
+	return ret_code;
+}
+
+/**
+ * irdma_hmc_finish_add_sd_reg - program sd entries for objects
+ * @dev: pointer to the device structure
+ * @info: create obj info
+ */
+static enum irdma_status_code
+irdma_hmc_finish_add_sd_reg(struct irdma_sc_dev *dev,
+			    struct irdma_hmc_create_obj_info *info)
+{
+	if (info->start_idx >= info->hmc_info->hmc_obj[info->rsrc_type].cnt)
+		return IRDMA_ERR_INVALID_HMC_OBJ_INDEX;
+
+	if ((info->start_idx + info->count) >
+	    info->hmc_info->hmc_obj[info->rsrc_type].cnt)
+		return IRDMA_ERR_INVALID_HMC_OBJ_COUNT;
+
+	if (!info->add_sd_cnt)
+		return 0;
+	return irdma_hmc_sd_grp(dev, info->hmc_info,
+				info->hmc_info->sd_indexes[0], info->add_sd_cnt,
+				true);
+}
+
+/**
+ * irdma_sc_create_hmc_obj - allocate backing store for hmc objects
+ * @dev: pointer to the device structure
+ * @info: pointer to irdma_hmc_create_obj_info struct
+ *
+ * This will allocate memory for PDs and backing pages and populate
+ * the sd and pd entries.
+ */
+enum irdma_status_code
+irdma_sc_create_hmc_obj(struct irdma_sc_dev *dev,
+			struct irdma_hmc_create_obj_info *info)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+	u32 sd_idx, sd_lmt;
+	u32 pd_idx = 0, pd_lmt = 0;
+	u32 pd_idx1 = 0, pd_lmt1 = 0;
+	u32 i, j;
+	bool pd_error = false;
+	enum irdma_status_code ret_code = 0;
+
+	if (info->start_idx >= info->hmc_info->hmc_obj[info->rsrc_type].cnt)
+		return IRDMA_ERR_INVALID_HMC_OBJ_INDEX;
+
+	if ((info->start_idx + info->count) >
+	    info->hmc_info->hmc_obj[info->rsrc_type].cnt) {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: error type %u, start = %u, req cnt %u, cnt = %u\n",
+			info->rsrc_type, info->start_idx, info->count,
+			info->hmc_info->hmc_obj[info->rsrc_type].cnt);
+		return IRDMA_ERR_INVALID_HMC_OBJ_COUNT;
+	}
+
+	irdma_find_sd_index_limit(info->hmc_info, info->rsrc_type,
+				  info->start_idx, info->count, &sd_idx,
+				  &sd_lmt);
+	if (sd_idx >= info->hmc_info->sd_table.sd_cnt ||
+	    sd_lmt > info->hmc_info->sd_table.sd_cnt) {
+		return IRDMA_ERR_INVALID_SD_INDEX;
+	}
+
+	irdma_find_pd_index_limit(info->hmc_info, info->rsrc_type,
+				  info->start_idx, info->count, &pd_idx,
+				  &pd_lmt);
+
+	for (j = sd_idx; j < sd_lmt; j++) {
+		ret_code = irdma_add_sd_table_entry(dev->hw, info->hmc_info, j,
+						    info->entry_type,
+						    IRDMA_HMC_DIRECT_BP_SIZE);
+		if (ret_code)
+			goto exit_sd_error;
+
+		sd_entry = &info->hmc_info->sd_table.sd_entry[j];
+		if (sd_entry->entry_type == IRDMA_SD_TYPE_PAGED &&
+		    (dev->hmc_info == info->hmc_info &&
+		     info->rsrc_type != IRDMA_HMC_IW_PBLE)) {
+			pd_idx1 = max(pd_idx, (j * IRDMA_HMC_MAX_BP_COUNT));
+			pd_lmt1 = min(pd_lmt, (j + 1) * IRDMA_HMC_MAX_BP_COUNT);
+			for (i = pd_idx1; i < pd_lmt1; i++) {
+				/* update the pd table entry */
+				ret_code = irdma_add_pd_table_entry(dev,
+								    info->hmc_info,
+								    i, NULL);
+				if (ret_code) {
+					pd_error = true;
+					break;
+				}
+			}
+			if (pd_error) {
+				while (i && (i > pd_idx1)) {
+					irdma_remove_pd_bp(dev, info->hmc_info,
+							   i - 1);
+					i--;
+				}
+			}
+		}
+		if (sd_entry->valid)
+			continue;
+
+		info->hmc_info->sd_indexes[info->add_sd_cnt] = (u16)j;
+		info->add_sd_cnt++;
+		sd_entry->valid = true;
+	}
+	return irdma_hmc_finish_add_sd_reg(dev, info);
+
+exit_sd_error:
+	while (j && (j > sd_idx)) {
+		sd_entry = &info->hmc_info->sd_table.sd_entry[j - 1];
+		switch (sd_entry->entry_type) {
+		case IRDMA_SD_TYPE_PAGED:
+			pd_idx1 = max(pd_idx, (j - 1) * IRDMA_HMC_MAX_BP_COUNT);
+			pd_lmt1 = min(pd_lmt, (j * IRDMA_HMC_MAX_BP_COUNT));
+			for (i = pd_idx1; i < pd_lmt1; i++)
+				irdma_prep_remove_pd_page(info->hmc_info, i);
+			break;
+		case IRDMA_SD_TYPE_DIRECT:
+			irdma_prep_remove_pd_page(info->hmc_info, (j - 1));
+			break;
+		default:
+			ret_code = IRDMA_ERR_INVALID_SD_TYPE;
+			break;
+		}
+		j--;
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_finish_del_sd_reg - delete sd entries for objects
+ * @dev: pointer to the device structure
+ * @info: dele obj info
+ * @reset: true if called before reset
+ */
+static enum irdma_status_code
+irdma_finish_del_sd_reg(struct irdma_sc_dev *dev,
+			struct irdma_hmc_del_obj_info *info, bool reset)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+	enum irdma_status_code ret_code = 0;
+	u32 i, sd_idx;
+	struct irdma_dma_mem *mem;
+
+	if (dev->privileged && !reset)
+		ret_code = irdma_hmc_sd_grp(dev, info->hmc_info,
+					    info->hmc_info->sd_indexes[0],
+					    info->del_sd_cnt, false);
+
+	if (ret_code)
+		dev_dbg(rfdev_to_dev(dev), "HMC: error cqp sd sd_grp\n");
+	for (i = 0; i < info->del_sd_cnt; i++) {
+		sd_idx = info->hmc_info->sd_indexes[i];
+		sd_entry = &info->hmc_info->sd_table.sd_entry[sd_idx];
+		if (!sd_entry)
+			continue;
+		mem = (sd_entry->entry_type == IRDMA_SD_TYPE_PAGED) ?
+			      &sd_entry->u.pd_table.pd_page_addr :
+			      &sd_entry->u.bp.addr;
+
+		if (!mem || !mem->va) {
+			dev_dbg(rfdev_to_dev(dev), "HMC: error cqp sd mem\n");
+		} else {
+			dma_free_coherent(hw_to_dev(dev->hw), mem->size,
+					  mem->va, mem->pa);
+			mem->va = NULL;
+		}
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_del_hmc_obj - remove pe hmc objects
+ * @dev: pointer to the device structure
+ * @info: pointer to irdma_hmc_del_obj_info struct
+ * @reset: true if called before reset
+ *
+ * This will de-populate the SDs and PDs.  It frees
+ * the memory for PDS and backing storage.  After this function is returned,
+ * caller should deallocate memory allocated previously for
+ * book-keeping information about PDs and backing storage.
+ */
+enum irdma_status_code irdma_sc_del_hmc_obj(struct irdma_sc_dev *dev,
+					    struct irdma_hmc_del_obj_info *info,
+					    bool reset)
+{
+	struct irdma_hmc_pd_table *pd_table;
+	u32 sd_idx, sd_lmt;
+	u32 pd_idx, pd_lmt, rel_pd_idx;
+	u32 i, j;
+	enum irdma_status_code ret_code = 0;
+
+	if (info->start_idx >= info->hmc_info->hmc_obj[info->rsrc_type].cnt) {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: error start_idx[%04d]  >= [type %04d].cnt[%04d]\n",
+			info->start_idx, info->rsrc_type,
+			info->hmc_info->hmc_obj[info->rsrc_type].cnt);
+		return IRDMA_ERR_INVALID_HMC_OBJ_INDEX;
+	}
+
+	if ((info->start_idx + info->count) >
+	    info->hmc_info->hmc_obj[info->rsrc_type].cnt) {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: error start_idx[%04d] + count %04d  >= [type %04d].cnt[%04d]\n",
+			info->start_idx, info->count, info->rsrc_type,
+			info->hmc_info->hmc_obj[info->rsrc_type].cnt);
+		return IRDMA_ERR_INVALID_HMC_OBJ_COUNT;
+	}
+
+	irdma_find_pd_index_limit(info->hmc_info, info->rsrc_type,
+				  info->start_idx, info->count, &pd_idx,
+				  &pd_lmt);
+
+	for (j = pd_idx; j < pd_lmt; j++) {
+		sd_idx = j / IRDMA_HMC_PD_CNT_IN_SD;
+
+		if (!info->hmc_info->sd_table.sd_entry[sd_idx].valid)
+			continue;
+
+		if (info->hmc_info->sd_table.sd_entry[sd_idx].entry_type !=
+		    IRDMA_SD_TYPE_PAGED)
+			continue;
+
+		rel_pd_idx = j % IRDMA_HMC_PD_CNT_IN_SD;
+		pd_table = &info->hmc_info->sd_table.sd_entry[sd_idx].u.pd_table;
+		if (pd_table->pd_entry &&
+		    pd_table->pd_entry[rel_pd_idx].valid) {
+			ret_code = irdma_remove_pd_bp(dev, info->hmc_info, j);
+			if (ret_code) {
+				dev_dbg(rfdev_to_dev(dev),
+					"HMC: remove_pd_bp error\n");
+				return ret_code;
+			}
+		}
+	}
+
+	irdma_find_sd_index_limit(info->hmc_info, info->rsrc_type,
+				  info->start_idx, info->count, &sd_idx,
+				  &sd_lmt);
+	if (sd_idx >= info->hmc_info->sd_table.sd_cnt ||
+	    sd_lmt > info->hmc_info->sd_table.sd_cnt) {
+		dev_dbg(rfdev_to_dev(dev), "HMC: invalid sd_idx\n");
+		return IRDMA_ERR_INVALID_SD_INDEX;
+	}
+
+	for (i = sd_idx; i < sd_lmt; i++) {
+		pd_table = &info->hmc_info->sd_table.sd_entry[i].u.pd_table;
+		if (!info->hmc_info->sd_table.sd_entry[i].valid)
+			continue;
+		switch (info->hmc_info->sd_table.sd_entry[i].entry_type) {
+		case IRDMA_SD_TYPE_DIRECT:
+			ret_code = irdma_prep_remove_sd_bp(info->hmc_info, i);
+			if (!ret_code) {
+				info->hmc_info->sd_indexes[info->del_sd_cnt] =
+					(u16)i;
+				info->del_sd_cnt++;
+			}
+			break;
+		case IRDMA_SD_TYPE_PAGED:
+			ret_code = irdma_prep_remove_pd_page(info->hmc_info, i);
+			if (ret_code)
+				break;
+			if (dev->hmc_info != info->hmc_info &&
+			    info->rsrc_type == IRDMA_HMC_IW_PBLE &&
+			    pd_table->pd_entry) {
+				kfree(pd_table->pd_entry_virt_mem.va);
+				pd_table->pd_entry = NULL;
+			}
+			info->hmc_info->sd_indexes[info->del_sd_cnt] = (u16)i;
+			info->del_sd_cnt++;
+			break;
+		default:
+			break;
+		}
+	}
+	return irdma_finish_del_sd_reg(dev, info, reset);
+}
+
+/**
+ * irdma_add_sd_table_entry - Adds a segment descriptor to the table
+ * @hw: pointer to our hw struct
+ * @hmc_info: pointer to the HMC configuration information struct
+ * @sd_index: segment descriptor index to manipulate
+ * @type: what type of segment descriptor we're manipulating
+ * @direct_mode_sz: size to alloc in direct mode
+ */
+enum irdma_status_code irdma_add_sd_table_entry(struct irdma_hw *hw,
+						struct irdma_hmc_info *hmc_info,
+						u32 sd_index,
+						enum irdma_sd_entry_type type,
+						u64 direct_mode_sz)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+	struct irdma_dma_mem dma_mem;
+	u64 alloc_len;
+
+	sd_entry = &hmc_info->sd_table.sd_entry[sd_index];
+	if (!sd_entry->valid) {
+		if (type == IRDMA_SD_TYPE_PAGED)
+			alloc_len = IRDMA_HMC_PAGED_BP_SIZE;
+		else
+			alloc_len = direct_mode_sz;
+
+		/* allocate a 4K pd page or 2M backing page */
+		dma_mem.size = ALIGN(alloc_len, IRDMA_HMC_PD_BP_BUF_ALIGNMENT);
+		dma_mem.va = dma_alloc_coherent(hw_to_dev(hw),
+						dma_mem.size, &dma_mem.pa,
+						GFP_ATOMIC);
+		if (!dma_mem.va)
+			return IRDMA_ERR_NO_MEMORY;
+
+		if (type == IRDMA_SD_TYPE_PAGED) {
+			struct irdma_virt_mem *vmem =
+				&sd_entry->u.pd_table.pd_entry_virt_mem;
+
+			vmem->size = sizeof(struct irdma_hmc_pd_entry) * 512;
+			vmem->va = kzalloc(vmem->size, GFP_ATOMIC);
+			if (!vmem->va) {
+				dma_free_coherent(hw_to_dev(hw), dma_mem.size,
+						  dma_mem.va, dma_mem.pa);
+				dma_mem.va = NULL;
+				return IRDMA_ERR_NO_MEMORY;
+			}
+			sd_entry->u.pd_table.pd_entry = vmem->va;
+
+			memcpy(&sd_entry->u.pd_table.pd_page_addr, &dma_mem,
+			       sizeof(sd_entry->u.pd_table.pd_page_addr));
+		} else {
+			memcpy(&sd_entry->u.bp.addr, &dma_mem,
+			       sizeof(sd_entry->u.bp.addr));
+
+			sd_entry->u.bp.sd_pd_index = sd_index;
+		}
+
+		hmc_info->sd_table.sd_entry[sd_index].entry_type = type;
+		IRDMA_INC_SD_REFCNT(&hmc_info->sd_table);
+	}
+	if (sd_entry->entry_type == IRDMA_SD_TYPE_DIRECT)
+		IRDMA_INC_BP_REFCNT(&sd_entry->u.bp);
+
+	return 0;
+}
+
+/**
+ * irdma_add_pd_table_entry - Adds page descriptor to the specified table
+ * @dev: pointer to our device structure
+ * @hmc_info: pointer to the HMC configuration information structure
+ * @pd_index: which page descriptor index to manipulate
+ * @rsrc_pg: if not NULL, use preallocated page instead of allocating new one.
+ *
+ * This function:
+ *	1. Initializes the pd entry
+ *	2. Adds pd_entry in the pd_table
+ *	3. Mark the entry valid in irdma_hmc_pd_entry structure
+ *	4. Initializes the pd_entry's ref count to 1
+ * assumptions:
+ *	1. The memory for pd should be pinned down, physically contiguous and
+ *	   aligned on 4K boundary and zeroed memory.
+ *	2. It should be 4K in size.
+ */
+enum irdma_status_code irdma_add_pd_table_entry(struct irdma_sc_dev *dev,
+						struct irdma_hmc_info *hmc_info,
+						u32 pd_index,
+						struct irdma_dma_mem *rsrc_pg)
+{
+	struct irdma_hmc_pd_table *pd_table;
+	struct irdma_hmc_pd_entry *pd_entry;
+	struct irdma_dma_mem mem;
+	struct irdma_dma_mem *page = &mem;
+	u32 sd_idx, rel_pd_idx;
+	u64 *pd_addr;
+	u64 page_desc;
+
+	if (pd_index / IRDMA_HMC_PD_CNT_IN_SD >= hmc_info->sd_table.sd_cnt)
+		return IRDMA_ERR_INVALID_PAGE_DESC_INDEX;
+
+	sd_idx = (pd_index / IRDMA_HMC_PD_CNT_IN_SD);
+	if (hmc_info->sd_table.sd_entry[sd_idx].entry_type !=
+	    IRDMA_SD_TYPE_PAGED)
+		return 0;
+
+	rel_pd_idx = (pd_index % IRDMA_HMC_PD_CNT_IN_SD);
+	pd_table = &hmc_info->sd_table.sd_entry[sd_idx].u.pd_table;
+	pd_entry = &pd_table->pd_entry[rel_pd_idx];
+	if (!pd_entry->valid) {
+		if (rsrc_pg) {
+			pd_entry->rsrc_pg = true;
+			page = rsrc_pg;
+		} else {
+			page->size = ALIGN(IRDMA_HMC_PAGED_BP_SIZE,
+					   IRDMA_HMC_PD_BP_BUF_ALIGNMENT);
+			page->va = dma_alloc_coherent(hw_to_dev(dev->hw),
+						      page->size, &page->pa,
+						      GFP_KERNEL);
+			if (!page->va)
+				return IRDMA_ERR_NO_MEMORY;
+
+			pd_entry->rsrc_pg = false;
+		}
+
+		memcpy(&pd_entry->bp.addr, page, sizeof(pd_entry->bp.addr));
+		pd_entry->bp.sd_pd_index = pd_index;
+		pd_entry->bp.entry_type = IRDMA_SD_TYPE_PAGED;
+		page_desc = page->pa | 0x1;
+		pd_addr = pd_table->pd_page_addr.va;
+		pd_addr += rel_pd_idx;
+		memcpy(pd_addr, &page_desc, sizeof(*pd_addr));
+		pd_entry->sd_index = sd_idx;
+		pd_entry->valid = true;
+		IRDMA_INC_PD_REFCNT(pd_table);
+		if (hmc_info->hmc_fn_id < dev->hw_attrs.first_hw_vf_fpm_id)
+			IRDMA_INVALIDATE_PF_HMC_PD(dev, sd_idx, rel_pd_idx);
+		else if (dev->hw->hmc.hmc_fn_id != hmc_info->hmc_fn_id)
+			IRDMA_INVALIDATE_VF_HMC_PD(dev, sd_idx, rel_pd_idx,
+						   hmc_info->hmc_fn_id);
+	}
+	IRDMA_INC_BP_REFCNT(&pd_entry->bp);
+
+	return 0;
+}
+
+/**
+ * irdma_remove_pd_bp - remove a backing page from a page descriptor
+ * @dev: pointer to our HW structure
+ * @hmc_info: pointer to the HMC configuration information structure
+ * @idx: the page index
+ *
+ * This function:
+ *	1. Marks the entry in pd table (for paged address mode) or in sd table
+ *	   (for direct address mode) invalid.
+ *	2. Write to register PMPDINV to invalidate the backing page in FV cache
+ *	3. Decrement the ref count for the pd _entry
+ * assumptions:
+ *	1. Caller can deallocate the memory used by backing storage after this
+ *	   function returns.
+ */
+enum irdma_status_code irdma_remove_pd_bp(struct irdma_sc_dev *dev,
+					  struct irdma_hmc_info *hmc_info,
+					  u32 idx)
+{
+	struct irdma_hmc_pd_entry *pd_entry;
+	struct irdma_hmc_pd_table *pd_table;
+	struct irdma_hmc_sd_entry *sd_entry;
+	u32 sd_idx, rel_pd_idx;
+	struct irdma_dma_mem *mem;
+	u64 *pd_addr;
+
+	sd_idx = idx / IRDMA_HMC_PD_CNT_IN_SD;
+	rel_pd_idx = idx % IRDMA_HMC_PD_CNT_IN_SD;
+	if (sd_idx >= hmc_info->sd_table.sd_cnt)
+		return IRDMA_ERR_INVALID_PAGE_DESC_INDEX;
+
+	sd_entry = &hmc_info->sd_table.sd_entry[sd_idx];
+	if (sd_entry->entry_type != IRDMA_SD_TYPE_PAGED)
+		return IRDMA_ERR_INVALID_SD_TYPE;
+
+	pd_table = &hmc_info->sd_table.sd_entry[sd_idx].u.pd_table;
+	pd_entry = &pd_table->pd_entry[rel_pd_idx];
+	IRDMA_DEC_BP_REFCNT(&pd_entry->bp);
+	if (pd_entry->bp.ref_cnt)
+		return 0;
+
+	pd_entry->valid = false;
+	IRDMA_DEC_PD_REFCNT(pd_table);
+	pd_addr = pd_table->pd_page_addr.va;
+	pd_addr += rel_pd_idx;
+	memset(pd_addr, 0, sizeof(u64));
+	if (dev->privileged) {
+		if (dev->hmc_fn_id == hmc_info->hmc_fn_id)
+			IRDMA_INVALIDATE_PF_HMC_PD(dev, sd_idx, idx);
+		else
+			IRDMA_INVALIDATE_VF_HMC_PD(dev, sd_idx, idx,
+						   hmc_info->hmc_fn_id);
+	}
+
+	if (!pd_entry->rsrc_pg) {
+		mem = &pd_entry->bp.addr;
+		if (!mem || !mem->va)
+			return IRDMA_ERR_PARAM;
+
+		dma_free_coherent(hw_to_dev(dev->hw), mem->size, mem->va,
+				  mem->pa);
+		mem->va = NULL;
+	}
+	if (!pd_table->ref_cnt)
+		kfree(pd_table->pd_entry_virt_mem.va);
+
+	return 0;
+}
+
+/**
+ * irdma_prep_remove_sd_bp - Prepares to remove a backing page from a sd entry
+ * @hmc_info: pointer to the HMC configuration information structure
+ * @idx: the page index
+ */
+enum irdma_status_code irdma_prep_remove_sd_bp(struct irdma_hmc_info *hmc_info,
+					       u32 idx)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+
+	sd_entry = &hmc_info->sd_table.sd_entry[idx];
+	IRDMA_DEC_BP_REFCNT(&sd_entry->u.bp);
+	if (sd_entry->u.bp.ref_cnt)
+		return IRDMA_ERR_NOT_READY;
+
+	IRDMA_DEC_SD_REFCNT(&hmc_info->sd_table);
+	sd_entry->valid = false;
+
+	return 0;
+}
+
+/**
+ * irdma_prep_remove_pd_page - Prepares to remove a PD page from sd entry.
+ * @hmc_info: pointer to the HMC configuration information structure
+ * @idx: segment descriptor index to find the relevant page descriptor
+ */
+enum irdma_status_code
+irdma_prep_remove_pd_page(struct irdma_hmc_info *hmc_info, u32 idx)
+{
+	struct irdma_hmc_sd_entry *sd_entry;
+
+	sd_entry = &hmc_info->sd_table.sd_entry[idx];
+
+	if (sd_entry->u.pd_table.ref_cnt)
+		return IRDMA_ERR_NOT_READY;
+
+	sd_entry->valid = false;
+	IRDMA_DEC_SD_REFCNT(&hmc_info->sd_table);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/irdma/hmc.h b/drivers/infiniband/hw/irdma/hmc.h
new file mode 100644
index 000000000000..6f3fbf61f048
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/hmc.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_HMC_H
+#define IRDMA_HMC_H
+
+#include "defs.h"
+
+#define IRDMA_HMC_MAX_BP_COUNT			512
+#define IRDMA_MAX_SD_ENTRIES			11
+#define IRDMA_HW_DBG_HMC_INVALID_BP_MARK	0xca
+#define IRDMA_HMC_INFO_SIGNATURE		0x484d5347
+#define IRDMA_HMC_PD_CNT_IN_SD			512
+#define IRDMA_HMC_DIRECT_BP_SIZE		0x200000
+#define IRDMA_HMC_MAX_SD_COUNT			8192
+#define IRDMA_HMC_PAGED_BP_SIZE			4096
+#define IRDMA_HMC_PD_BP_BUF_ALIGNMENT		4096
+#define IRDMA_FIRST_VF_FPM_ID			8
+#define FPM_MULTIPLIER				1024
+
+#define IRDMA_INC_SD_REFCNT(sd_table)	((sd_table)->ref_cnt++)
+#define IRDMA_INC_PD_REFCNT(pd_table)	((pd_table)->ref_cnt++)
+#define IRDMA_INC_BP_REFCNT(bp)		((bp)->ref_cnt++)
+
+#define IRDMA_DEC_SD_REFCNT(sd_table)	((sd_table)->ref_cnt--)
+#define IRDMA_DEC_PD_REFCNT(pd_table)	((pd_table)->ref_cnt--)
+#define IRDMA_DEC_BP_REFCNT(bp)		((bp)->ref_cnt--)
+
+/**
+ * IRDMA_INVALIDATE_PF_HMC_PD - Invalidates the pd cache in the hardware
+ * @hw: pointer to our hw struct
+ * @sd_idx: segment descriptor index
+ * @pd_idx: page descriptor index
+ */
+#define IRDMA_INVALIDATE_PF_HMC_PD(dev, sd_idx, pd_idx)			\
+	writel((((sd_idx) << IRDMA_PFHMC_PDINV_PMSDIDX_S) |		\
+		(0x1 << IRDMA_PFHMC_PDINV_PMSDPARTSEL_S) |		\
+		((pd_idx) << IRDMA_PFHMC_PDINV_PMPDIDX_S)),		\
+	       (dev)->hw_regs[IRDMA_PFHMC_PDINV])
+
+/**
+ * IRDMA_INVALIDATE_VF_HMC_PD - Invalidates the pd cache in the hardware
+ * @hw: pointer to our hw struct
+ * @sd_idx: segment descriptor index
+ * @pd_idx: page descriptor index
+ * @hmc_fn_id: VF's function id
+ */
+#define IRDMA_INVALIDATE_VF_HMC_PD(dev, sd_idx, pd_idx, hmc_fn_id)	\
+	writel((((sd_idx) << IRDMA_PFHMC_PDINV_PMSDIDX_S) |		\
+		((pd_idx) << IRDMA_PFHMC_PDINV_PMPDIDX_S)),		\
+	       (dev)->hw_regs[IRDMA_GLHMC_VFPDINV] +			\
+		((hmc_fn_id) - (dev)->hw_attrs.first_hw_vf_fpm_id))
+
+enum irdma_hmc_rsrc_type {
+	IRDMA_HMC_IW_QP		 = 0,
+	IRDMA_HMC_IW_CQ		 = 1,
+	IRDMA_HMC_IW_RESERVED	 = 2,
+	IRDMA_HMC_IW_HTE	 = 3,
+	IRDMA_HMC_IW_ARP	 = 4,
+	IRDMA_HMC_IW_APBVT_ENTRY = 5,
+	IRDMA_HMC_IW_MR		 = 6,
+	IRDMA_HMC_IW_XF		 = 7,
+	IRDMA_HMC_IW_XFFL	 = 8,
+	IRDMA_HMC_IW_Q1		 = 9,
+	IRDMA_HMC_IW_Q1FL	 = 10,
+	IRDMA_HMC_IW_TIMER       = 11,
+	IRDMA_HMC_IW_FSIMC       = 12,
+	IRDMA_HMC_IW_FSIAV       = 13,
+	IRDMA_HMC_IW_PBLE	 = 14,
+	IRDMA_HMC_IW_RRF	 = 15,
+	IRDMA_HMC_IW_RRFFL       = 16,
+	IRDMA_HMC_IW_HDR	 = 17,
+	IRDMA_HMC_IW_MD		 = 18,
+	IRDMA_HMC_IW_OOISC       = 19,
+	IRDMA_HMC_IW_OOISCFFL    = 20,
+	IRDMA_HMC_IW_MAX, /* Must be last entry */
+};
+
+enum irdma_sd_entry_type {
+	IRDMA_SD_TYPE_INVALID = 0,
+	IRDMA_SD_TYPE_PAGED   = 1,
+	IRDMA_SD_TYPE_DIRECT  = 2,
+};
+
+struct irdma_hmc_obj_info {
+	u64 base;
+	u32 max_cnt;
+	u32 cnt;
+	u64 size;
+};
+
+struct irdma_hmc_bp {
+	enum irdma_sd_entry_type entry_type;
+	struct irdma_dma_mem addr;
+	u32 sd_pd_index;
+	u32 ref_cnt;
+};
+
+struct irdma_hmc_pd_entry {
+	struct irdma_hmc_bp bp;
+	u32 sd_index;
+	bool rsrc_pg:1;
+	bool valid:1;
+};
+
+struct irdma_hmc_pd_table {
+	struct irdma_dma_mem pd_page_addr;
+	struct irdma_hmc_pd_entry *pd_entry;
+	struct irdma_virt_mem pd_entry_virt_mem;
+	u32 ref_cnt;
+	u32 sd_index;
+};
+
+struct irdma_hmc_sd_entry {
+	enum irdma_sd_entry_type entry_type;
+	bool valid;
+	union {
+		struct irdma_hmc_pd_table pd_table;
+		struct irdma_hmc_bp bp;
+	} u;
+};
+
+struct irdma_hmc_sd_table {
+	struct irdma_virt_mem addr;
+	u32 sd_cnt;
+	u32 ref_cnt;
+	struct irdma_hmc_sd_entry *sd_entry;
+};
+
+struct irdma_hmc_info {
+	u32 signature;
+	u8 hmc_fn_id;
+	u16 first_sd_index;
+	struct irdma_hmc_obj_info *hmc_obj;
+	struct irdma_virt_mem hmc_obj_virt_mem;
+	struct irdma_hmc_sd_table sd_table;
+	u16 sd_indexes[IRDMA_HMC_MAX_SD_COUNT];
+};
+
+struct irdma_update_sd_entry {
+	u64 cmd;
+	u64 data;
+};
+
+struct irdma_update_sds_info {
+	u32 cnt;
+	u8 hmc_fn_id;
+	struct irdma_update_sd_entry entry[IRDMA_MAX_SD_ENTRIES];
+};
+
+struct irdma_ccq_cqe_info;
+struct irdma_hmc_fcn_info {
+	void (*callback_fcn)(struct irdma_sc_dev *dev, void *cqp_callback_param,
+			     struct irdma_ccq_cqe_info *ccq_cqe_info);
+	void *cqp_callback_param;
+	u32 vf_id;
+	u16 iw_vf_idx;
+	u8 free_fcn;
+};
+
+struct irdma_hmc_create_obj_info {
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_virt_mem add_sd_virt_mem;
+	u32 rsrc_type;
+	u32 start_idx;
+	u32 count;
+	u32 add_sd_cnt;
+	enum irdma_sd_entry_type entry_type;
+	bool privileged;
+};
+
+struct irdma_hmc_del_obj_info {
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_virt_mem del_sd_virt_mem;
+	u32 rsrc_type;
+	u32 start_idx;
+	u32 count;
+	u32 del_sd_cnt;
+	bool privileged;
+};
+
+enum irdma_status_code irdma_copy_dma_mem(struct irdma_hw *hw, void *dest_buf,
+					  struct irdma_dma_mem *src_mem,
+					  u64 src_offset, u64 size);
+enum irdma_status_code
+irdma_sc_create_hmc_obj(struct irdma_sc_dev *dev,
+			struct irdma_hmc_create_obj_info *info);
+enum irdma_status_code irdma_sc_del_hmc_obj(struct irdma_sc_dev *dev,
+					    struct irdma_hmc_del_obj_info *info,
+					    bool reset);
+enum irdma_status_code irdma_hmc_sd_one(struct irdma_sc_dev *dev, u8 hmc_fn_id,
+					u64 pa, u32 sd_idx,
+					enum irdma_sd_entry_type type,
+					bool setsd);
+enum irdma_status_code
+irdma_update_sds_noccq(struct irdma_sc_dev *dev,
+		       struct irdma_update_sds_info *info);
+struct irdma_vfdev *irdma_vfdev_from_fpm(struct irdma_sc_dev *dev,
+					 u8 hmc_fn_id);
+struct irdma_hmc_info *irdma_vf_hmcinfo_from_fpm(struct irdma_sc_dev *dev,
+						 u8 hmc_fn_id);
+enum irdma_status_code irdma_add_sd_table_entry(struct irdma_hw *hw,
+						struct irdma_hmc_info *hmc_info,
+						u32 sd_index,
+						enum irdma_sd_entry_type type,
+						u64 direct_mode_sz);
+enum irdma_status_code irdma_add_pd_table_entry(struct irdma_sc_dev *dev,
+						struct irdma_hmc_info *hmc_info,
+						u32 pd_index,
+						struct irdma_dma_mem *rsrc_pg);
+enum irdma_status_code irdma_remove_pd_bp(struct irdma_sc_dev *dev,
+					  struct irdma_hmc_info *hmc_info,
+					  u32 idx);
+enum irdma_status_code irdma_prep_remove_sd_bp(struct irdma_hmc_info *hmc_info,
+					       u32 idx);
+enum irdma_status_code
+irdma_prep_remove_pd_page(struct irdma_hmc_info *hmc_info, u32 idx);
+#endif /* IRDMA_HMC_H */
-- 
2.25.2

