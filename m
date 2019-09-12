Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF79B1596
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfILUuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:59558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbfILUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345135"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/6] ice: Implement Dynamic Device Personalization (DDP) download
Date:   Thu, 12 Sep 2019 13:49:59 -0700
Message-Id: <20190912205002.12159-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Add the required defines, structures, and functions to enable downloading
a DDP package.  Before download, checks are performed to ensure the package
is valid and compatible.

Note that package download is not yet requested by the driver as further
initialization is required to utilize the package.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  60 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  40 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 608 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  25 +
 .../net/ethernet/intel/ice/ice_flex_type.h    | 372 +++++++++++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  26 +
 9 files changed, 1137 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_pipe.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_pipe.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_type.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 2d140ba83781..9edde960b4f2 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -15,6 +15,7 @@ ice-y := ice_main.o	\
 	 ice_sched.o	\
 	 ice_lib.o	\
 	 ice_txrx.o	\
+	 ice_flex_pipe.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 9c9791788610..023e3d2fee5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1530,6 +1530,56 @@ struct ice_aqc_get_clear_fw_log {
 	__le32 addr_low;
 };
 
+/* Download Package (indirect 0x0C40) */
+/* Also used for Update Package (indirect 0x0C42) */
+struct ice_aqc_download_pkg {
+	u8 flags;
+#define ICE_AQC_DOWNLOAD_PKG_LAST_BUF	0x01
+	u8 reserved[3];
+	__le32 reserved1;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+struct ice_aqc_download_pkg_resp {
+	__le32 error_offset;
+	__le32 error_info;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Get Package Info List (indirect 0x0C43) */
+struct ice_aqc_get_pkg_info_list {
+	__le32 reserved1;
+	__le32 reserved2;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Version format for packages */
+struct ice_pkg_ver {
+	u8 major;
+	u8 minor;
+	u8 update;
+	u8 draft;
+};
+
+#define ICE_PKG_NAME_SIZE	32
+
+struct ice_aqc_get_pkg_info {
+	struct ice_pkg_ver ver;
+	char name[ICE_PKG_NAME_SIZE];
+	u8 is_in_nvm;
+	u8 is_active;
+	u8 is_active_at_boot;
+	u8 is_modified;
+};
+
+/* Get Package Info List response buffer format (0x0C43) */
+struct ice_aqc_get_pkg_info_resp {
+	__le32 count;
+	struct ice_aqc_get_pkg_info pkg_info[1];
+};
 /**
  * struct ice_aq_desc - Admin Queue (AQ) descriptor
  * @flags: ICE_AQ_FLAG_* flags
@@ -1592,6 +1642,7 @@ struct ice_aq_desc {
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
+		struct ice_aqc_download_pkg download_pkg;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
 		struct ice_aqc_set_event_mask set_event_mask;
@@ -1624,6 +1675,11 @@ enum ice_aq_err {
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
 	ICE_AQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
 	ICE_AQ_RC_ENOSYS	= 17, /* Function not implemented */
+	ICE_AQ_RC_ENOSEC	= 24, /* Missing security manifest */
+	ICE_AQ_RC_EBADSIG	= 25, /* Bad RSA signature */
+	ICE_AQ_RC_ESVN		= 26, /* SVN number prohibits this package */
+	ICE_AQ_RC_EBADMAN	= 27, /* Manifest hash mismatch */
+	ICE_AQ_RC_EBADBUF	= 28, /* Buffer hash mismatches manifest */
 };
 
 /* Admin Queue command opcodes */
@@ -1712,6 +1768,10 @@ enum ice_adminq_opc {
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
 
+	/* package commands */
+	ice_aqc_opc_download_pkg			= 0x0C40,
+	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
+
 	/* debug commands */
 	ice_aqc_opc_fw_logging				= 0xFF09,
 	ice_aqc_opc_fw_logging_info			= 0xFF10,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 22d2a11ef41f..20956643036c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -910,6 +910,7 @@ void ice_deinit_hw(struct ice_hw *hw)
 
 	ice_sched_cleanup_all(hw);
 	ice_sched_clear_agg(hw);
+	ice_free_seg(hw);
 
 	if (hw->port_info) {
 		devm_kfree(ice_hw_to_dev(hw), hw->port_info);
@@ -1230,6 +1231,12 @@ ice_debug_cq(struct ice_hw *hw, u32 __maybe_unused mask, void *desc, void *buf,
 
 /* FW Admin Queue command wrappers */
 
+/* Software lock/mutex that is meant to be held while the Global Config Lock
+ * in firmware is acquired by the software to prevent most (but not all) types
+ * of AQ commands from being sent to FW
+ */
+DEFINE_MUTEX(ice_global_cfg_lock_sw);
+
 /**
  * ice_aq_send_cmd - send FW Admin Queue command to FW Admin Queue
  * @hw: pointer to the HW struct
@@ -1244,7 +1251,38 @@ enum ice_status
 ice_aq_send_cmd(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf,
 		u16 buf_size, struct ice_sq_cd *cd)
 {
-	return ice_sq_send_cmd(hw, &hw->adminq, desc, buf, buf_size, cd);
+	struct ice_aqc_req_res *cmd = &desc->params.res_owner;
+	bool lock_acquired = false;
+	enum ice_status status;
+
+	/* When a package download is in process (i.e. when the firmware's
+	 * Global Configuration Lock resource is held), only the Download
+	 * Package, Get Version, Get Package Info List and Release Resource
+	 * (with resource ID set to Global Config Lock) AdminQ commands are
+	 * allowed; all others must block until the package download completes
+	 * and the Global Config Lock is released.  See also
+	 * ice_acquire_global_cfg_lock().
+	 */
+	switch (le16_to_cpu(desc->opcode)) {
+	case ice_aqc_opc_download_pkg:
+	case ice_aqc_opc_get_pkg_info_list:
+	case ice_aqc_opc_get_ver:
+		break;
+	case ice_aqc_opc_release_res:
+		if (le16_to_cpu(cmd->res_id) == ICE_AQC_RES_ID_GLBL_LOCK)
+			break;
+		/* fall-through */
+	default:
+		mutex_lock(&ice_global_cfg_lock_sw);
+		lock_acquired = true;
+		break;
+	}
+
+	status = ice_sq_send_cmd(hw, &hw->adminq, desc, buf, buf_size, cd);
+	if (lock_acquired)
+		mutex_unlock(&ice_global_cfg_lock_sw);
+
+	return status;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 0525a051e05b..ce55f8ae6b52 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -6,6 +6,7 @@
 
 #include "ice.h"
 #include "ice_type.h"
+#include "ice_flex_pipe.h"
 #include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
 
@@ -66,6 +67,9 @@ void ice_fill_dflt_direct_cmd_desc(struct ice_aq_desc *desc, u16 opcode);
 extern const struct ice_ctx_ele ice_tlan_ctx_info[];
 enum ice_status
 ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info);
+
+extern struct mutex ice_global_cfg_lock_sw;
+
 enum ice_status
 ice_aq_send_cmd(struct ice_hw *hw, struct ice_aq_desc *desc,
 		void *buf, u16 buf_size, struct ice_sq_cd *cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
new file mode 100644
index 000000000000..4e965dc5eb93
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -0,0 +1,608 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "ice_common.h"
+#include "ice_flex_pipe.h"
+
+/**
+ * ice_find_buf_table
+ * @ice_seg: pointer to the ice segment
+ *
+ * Returns the address of the buffer table within the ice segment.
+ */
+static struct ice_buf_table *ice_find_buf_table(struct ice_seg *ice_seg)
+{
+	struct ice_nvm_table *nvms;
+
+	nvms = (struct ice_nvm_table *)
+		(ice_seg->device_table +
+		 le32_to_cpu(ice_seg->device_table_count));
+
+	return (__force struct ice_buf_table *)
+		(nvms->vers + le32_to_cpu(nvms->table_count));
+}
+
+/**
+ * ice_acquire_global_cfg_lock
+ * @hw: pointer to the HW structure
+ * @access: access type (read or write)
+ *
+ * This function will request ownership of the global config lock for reading
+ * or writing of the package. When attempting to obtain write access, the
+ * caller must check for the following two return values:
+ *
+ * ICE_SUCCESS        - Means the caller has acquired the global config lock
+ *                      and can perform writing of the package.
+ * ICE_ERR_AQ_NO_WORK - Indicates another driver has already written the
+ *                      package or has found that no update was necessary; in
+ *                      this case, the caller can just skip performing any
+ *                      update of the package.
+ */
+static enum ice_status
+ice_acquire_global_cfg_lock(struct ice_hw *hw,
+			    enum ice_aq_res_access_type access)
+{
+	enum ice_status status;
+
+	status = ice_acquire_res(hw, ICE_GLOBAL_CFG_LOCK_RES_ID, access,
+				 ICE_GLOBAL_CFG_LOCK_TIMEOUT);
+
+	if (!status)
+		mutex_lock(&ice_global_cfg_lock_sw);
+	else if (status == ICE_ERR_AQ_NO_WORK)
+		ice_debug(hw, ICE_DBG_PKG,
+			  "Global config lock: No work to do\n");
+
+	return status;
+}
+
+/**
+ * ice_release_global_cfg_lock
+ * @hw: pointer to the HW structure
+ *
+ * This function will release the global config lock.
+ */
+static void ice_release_global_cfg_lock(struct ice_hw *hw)
+{
+	mutex_unlock(&ice_global_cfg_lock_sw);
+	ice_release_res(hw, ICE_GLOBAL_CFG_LOCK_RES_ID);
+}
+
+/**
+ * ice_aq_download_pkg
+ * @hw: pointer to the hardware structure
+ * @pkg_buf: the package buffer to transfer
+ * @buf_size: the size of the package buffer
+ * @last_buf: last buffer indicator
+ * @error_offset: returns error offset
+ * @error_info: returns error information
+ * @cd: pointer to command details structure or NULL
+ *
+ * Download Package (0x0C40)
+ */
+static enum ice_status
+ice_aq_download_pkg(struct ice_hw *hw, struct ice_buf_hdr *pkg_buf,
+		    u16 buf_size, bool last_buf, u32 *error_offset,
+		    u32 *error_info, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_download_pkg *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	if (error_offset)
+		*error_offset = 0;
+	if (error_info)
+		*error_info = 0;
+
+	cmd = &desc.params.download_pkg;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_download_pkg);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	if (last_buf)
+		cmd->flags |= ICE_AQC_DOWNLOAD_PKG_LAST_BUF;
+
+	status = ice_aq_send_cmd(hw, &desc, pkg_buf, buf_size, cd);
+	if (status == ICE_ERR_AQ_ERROR) {
+		/* Read error from buffer only when the FW returned an error */
+		struct ice_aqc_download_pkg_resp *resp;
+
+		resp = (struct ice_aqc_download_pkg_resp *)pkg_buf;
+		if (error_offset)
+			*error_offset = le32_to_cpu(resp->error_offset);
+		if (error_info)
+			*error_info = le32_to_cpu(resp->error_info);
+	}
+
+	return status;
+}
+
+/**
+ * ice_find_seg_in_pkg
+ * @hw: pointer to the hardware structure
+ * @seg_type: the segment type to search for (i.e., SEGMENT_TYPE_CPK)
+ * @pkg_hdr: pointer to the package header to be searched
+ *
+ * This function searches a package file for a particular segment type. On
+ * success it returns a pointer to the segment header, otherwise it will
+ * return NULL.
+ */
+static struct ice_generic_seg_hdr *
+ice_find_seg_in_pkg(struct ice_hw *hw, u32 seg_type,
+		    struct ice_pkg_hdr *pkg_hdr)
+{
+	u32 i;
+
+	ice_debug(hw, ICE_DBG_PKG, "Package format version: %d.%d.%d.%d\n",
+		  pkg_hdr->format_ver.major, pkg_hdr->format_ver.minor,
+		  pkg_hdr->format_ver.update, pkg_hdr->format_ver.draft);
+
+	/* Search all package segments for the requested segment type */
+	for (i = 0; i < le32_to_cpu(pkg_hdr->seg_count); i++) {
+		struct ice_generic_seg_hdr *seg;
+
+		seg = (struct ice_generic_seg_hdr *)
+			((u8 *)pkg_hdr + le32_to_cpu(pkg_hdr->seg_offset[i]));
+
+		if (le32_to_cpu(seg->seg_type) == seg_type)
+			return seg;
+	}
+
+	return NULL;
+}
+
+/**
+ * ice_dwnld_cfg_bufs
+ * @hw: pointer to the hardware structure
+ * @bufs: pointer to an array of buffers
+ * @count: the number of buffers in the array
+ *
+ * Obtains global config lock and downloads the package configuration buffers
+ * to the firmware. Metadata buffers are skipped, and the first metadata buffer
+ * found indicates that the rest of the buffers are all metadata buffers.
+ */
+static enum ice_status
+ice_dwnld_cfg_bufs(struct ice_hw *hw, struct ice_buf *bufs, u32 count)
+{
+	enum ice_status status;
+	struct ice_buf_hdr *bh;
+	u32 offset, info, i;
+
+	if (!bufs || !count)
+		return ICE_ERR_PARAM;
+
+	/* If the first buffer's first section has its metadata bit set
+	 * then there are no buffers to be downloaded, and the operation is
+	 * considered a success.
+	 */
+	bh = (struct ice_buf_hdr *)bufs;
+	if (le32_to_cpu(bh->section_entry[0].type) & ICE_METADATA_BUF)
+		return 0;
+
+	/* reset pkg_dwnld_status in case this function is called in the
+	 * reset/rebuild flow
+	 */
+	hw->pkg_dwnld_status = ICE_AQ_RC_OK;
+
+	status = ice_acquire_global_cfg_lock(hw, ICE_RES_WRITE);
+	if (status) {
+		if (status == ICE_ERR_AQ_NO_WORK)
+			hw->pkg_dwnld_status = ICE_AQ_RC_EEXIST;
+		else
+			hw->pkg_dwnld_status = hw->adminq.sq_last_status;
+		return status;
+	}
+
+	for (i = 0; i < count; i++) {
+		bool last = ((i + 1) == count);
+
+		if (!last) {
+			/* check next buffer for metadata flag */
+			bh = (struct ice_buf_hdr *)(bufs + i + 1);
+
+			/* A set metadata flag in the next buffer will signal
+			 * that the current buffer will be the last buffer
+			 * downloaded
+			 */
+			if (le16_to_cpu(bh->section_count))
+				if (le32_to_cpu(bh->section_entry[0].type) &
+				    ICE_METADATA_BUF)
+					last = true;
+		}
+
+		bh = (struct ice_buf_hdr *)(bufs + i);
+
+		status = ice_aq_download_pkg(hw, bh, ICE_PKG_BUF_SIZE, last,
+					     &offset, &info, NULL);
+
+		/* Save AQ status from download package */
+		hw->pkg_dwnld_status = hw->adminq.sq_last_status;
+		if (status) {
+			ice_debug(hw, ICE_DBG_PKG,
+				  "Pkg download failed: err %d off %d inf %d\n",
+				  status, offset, info);
+
+			break;
+		}
+
+		if (last)
+			break;
+	}
+
+	ice_release_global_cfg_lock(hw);
+
+	return status;
+}
+
+/**
+ * ice_aq_get_pkg_info_list
+ * @hw: pointer to the hardware structure
+ * @pkg_info: the buffer which will receive the information list
+ * @buf_size: the size of the pkg_info information buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Get Package Info List (0x0C43)
+ */
+static enum ice_status
+ice_aq_get_pkg_info_list(struct ice_hw *hw,
+			 struct ice_aqc_get_pkg_info_resp *pkg_info,
+			 u16 buf_size, struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_pkg_info_list);
+
+	return ice_aq_send_cmd(hw, &desc, pkg_info, buf_size, cd);
+}
+
+/**
+ * ice_download_pkg
+ * @hw: pointer to the hardware structure
+ * @ice_seg: pointer to the segment of the package to be downloaded
+ *
+ * Handles the download of a complete package.
+ */
+static enum ice_status
+ice_download_pkg(struct ice_hw *hw, struct ice_seg *ice_seg)
+{
+	struct ice_buf_table *ice_buf_tbl;
+
+	ice_debug(hw, ICE_DBG_PKG, "Segment version: %d.%d.%d.%d\n",
+		  ice_seg->hdr.seg_ver.major, ice_seg->hdr.seg_ver.minor,
+		  ice_seg->hdr.seg_ver.update, ice_seg->hdr.seg_ver.draft);
+
+	ice_debug(hw, ICE_DBG_PKG, "Seg: type 0x%X, size %d, name %s\n",
+		  le32_to_cpu(ice_seg->hdr.seg_type),
+		  le32_to_cpu(ice_seg->hdr.seg_size), ice_seg->hdr.seg_name);
+
+	ice_buf_tbl = ice_find_buf_table(ice_seg);
+
+	ice_debug(hw, ICE_DBG_PKG, "Seg buf count: %d\n",
+		  le32_to_cpu(ice_buf_tbl->buf_count));
+
+	return ice_dwnld_cfg_bufs(hw, ice_buf_tbl->buf_array,
+				  le32_to_cpu(ice_buf_tbl->buf_count));
+}
+
+/**
+ * ice_init_pkg_info
+ * @hw: pointer to the hardware structure
+ * @pkg_hdr: pointer to the driver's package hdr
+ *
+ * Saves off the package details into the HW structure.
+ */
+static enum ice_status
+ice_init_pkg_info(struct ice_hw *hw, struct ice_pkg_hdr *pkg_hdr)
+{
+	struct ice_global_metadata_seg *meta_seg;
+	struct ice_generic_seg_hdr *seg_hdr;
+
+	if (!pkg_hdr)
+		return ICE_ERR_PARAM;
+
+	meta_seg = (struct ice_global_metadata_seg *)
+		   ice_find_seg_in_pkg(hw, SEGMENT_TYPE_METADATA, pkg_hdr);
+	if (meta_seg) {
+		hw->pkg_ver = meta_seg->pkg_ver;
+		memcpy(hw->pkg_name, meta_seg->pkg_name, sizeof(hw->pkg_name));
+
+		ice_debug(hw, ICE_DBG_PKG, "Pkg: %d.%d.%d.%d, %s\n",
+			  meta_seg->pkg_ver.major, meta_seg->pkg_ver.minor,
+			  meta_seg->pkg_ver.update, meta_seg->pkg_ver.draft,
+			  meta_seg->pkg_name);
+	} else {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Did not find metadata segment in driver package\n");
+		return ICE_ERR_CFG;
+	}
+
+	seg_hdr = ice_find_seg_in_pkg(hw, SEGMENT_TYPE_ICE, pkg_hdr);
+	if (seg_hdr) {
+		hw->ice_pkg_ver = seg_hdr->seg_ver;
+		memcpy(hw->ice_pkg_name, seg_hdr->seg_name,
+		       sizeof(hw->ice_pkg_name));
+
+		ice_debug(hw, ICE_DBG_PKG, "Ice Pkg: %d.%d.%d.%d, %s\n",
+			  seg_hdr->seg_ver.major, seg_hdr->seg_ver.minor,
+			  seg_hdr->seg_ver.update, seg_hdr->seg_ver.draft,
+			  seg_hdr->seg_name);
+	} else {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Did not find ice segment in driver package\n");
+		return ICE_ERR_CFG;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_get_pkg_info
+ * @hw: pointer to the hardware structure
+ *
+ * Store details of the package currently loaded in HW into the HW structure.
+ */
+static enum ice_status ice_get_pkg_info(struct ice_hw *hw)
+{
+	struct ice_aqc_get_pkg_info_resp *pkg_info;
+	enum ice_status status;
+	u16 size;
+	u32 i;
+
+	size = sizeof(*pkg_info) + (sizeof(pkg_info->pkg_info[0]) *
+				    (ICE_PKG_CNT - 1));
+	pkg_info = kzalloc(size, GFP_KERNEL);
+	if (!pkg_info)
+		return ICE_ERR_NO_MEMORY;
+
+	status = ice_aq_get_pkg_info_list(hw, pkg_info, size, NULL);
+	if (status)
+		goto init_pkg_free_alloc;
+
+	for (i = 0; i < le32_to_cpu(pkg_info->count); i++) {
+#define ICE_PKG_FLAG_COUNT	4
+		char flags[ICE_PKG_FLAG_COUNT + 1] = { 0 };
+		u8 place = 0;
+
+		if (pkg_info->pkg_info[i].is_active) {
+			flags[place++] = 'A';
+			hw->active_pkg_ver = pkg_info->pkg_info[i].ver;
+			memcpy(hw->active_pkg_name,
+			       pkg_info->pkg_info[i].name,
+			       sizeof(hw->active_pkg_name));
+			hw->active_pkg_in_nvm = pkg_info->pkg_info[i].is_in_nvm;
+		}
+		if (pkg_info->pkg_info[i].is_active_at_boot)
+			flags[place++] = 'B';
+		if (pkg_info->pkg_info[i].is_modified)
+			flags[place++] = 'M';
+		if (pkg_info->pkg_info[i].is_in_nvm)
+			flags[place++] = 'N';
+
+		ice_debug(hw, ICE_DBG_PKG, "Pkg[%d]: %d.%d.%d.%d,%s,%s\n",
+			  i, pkg_info->pkg_info[i].ver.major,
+			  pkg_info->pkg_info[i].ver.minor,
+			  pkg_info->pkg_info[i].ver.update,
+			  pkg_info->pkg_info[i].ver.draft,
+			  pkg_info->pkg_info[i].name, flags);
+	}
+
+init_pkg_free_alloc:
+	kfree(pkg_info);
+
+	return status;
+}
+
+/**
+ * ice_verify_pkg - verify package
+ * @pkg: pointer to the package buffer
+ * @len: size of the package buffer
+ *
+ * Verifies various attributes of the package file, including length, format
+ * version, and the requirement of at least one segment.
+ */
+static enum ice_status ice_verify_pkg(struct ice_pkg_hdr *pkg, u32 len)
+{
+	u32 seg_count;
+	u32 i;
+
+	if (len < sizeof(*pkg))
+		return ICE_ERR_BUF_TOO_SHORT;
+
+	if (pkg->format_ver.major != ICE_PKG_FMT_VER_MAJ ||
+	    pkg->format_ver.minor != ICE_PKG_FMT_VER_MNR ||
+	    pkg->format_ver.update != ICE_PKG_FMT_VER_UPD ||
+	    pkg->format_ver.draft != ICE_PKG_FMT_VER_DFT)
+		return ICE_ERR_CFG;
+
+	/* pkg must have at least one segment */
+	seg_count = le32_to_cpu(pkg->seg_count);
+	if (seg_count < 1)
+		return ICE_ERR_CFG;
+
+	/* make sure segment array fits in package length */
+	if (len < sizeof(*pkg) + ((seg_count - 1) * sizeof(pkg->seg_offset)))
+		return ICE_ERR_BUF_TOO_SHORT;
+
+	/* all segments must fit within length */
+	for (i = 0; i < seg_count; i++) {
+		u32 off = le32_to_cpu(pkg->seg_offset[i]);
+		struct ice_generic_seg_hdr *seg;
+
+		/* segment header must fit */
+		if (len < off + sizeof(*seg))
+			return ICE_ERR_BUF_TOO_SHORT;
+
+		seg = (struct ice_generic_seg_hdr *)((u8 *)pkg + off);
+
+		/* segment body must fit */
+		if (len < off + le32_to_cpu(seg->seg_size))
+			return ICE_ERR_BUF_TOO_SHORT;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_free_seg - free package segment pointer
+ * @hw: pointer to the hardware structure
+ *
+ * Frees the package segment pointer in the proper manner, depending on if the
+ * segment was allocated or just the passed in pointer was stored.
+ */
+void ice_free_seg(struct ice_hw *hw)
+{
+	if (hw->pkg_copy) {
+		devm_kfree(ice_hw_to_dev(hw), hw->pkg_copy);
+		hw->pkg_copy = NULL;
+		hw->pkg_size = 0;
+	}
+	hw->seg = NULL;
+}
+
+/**
+ * ice_chk_pkg_version - check package version for compatibility with driver
+ * @pkg_ver: pointer to a version structure to check
+ *
+ * Check to make sure that the package about to be downloaded is compatible with
+ * the driver. To be compatible, the major and minor components of the package
+ * version must match our ICE_PKG_SUPP_VER_MAJ and ICE_PKG_SUPP_VER_MNR
+ * definitions.
+ */
+static enum ice_status ice_chk_pkg_version(struct ice_pkg_ver *pkg_ver)
+{
+	if (pkg_ver->major != ICE_PKG_SUPP_VER_MAJ ||
+	    pkg_ver->minor != ICE_PKG_SUPP_VER_MNR)
+		return ICE_ERR_NOT_SUPPORTED;
+
+	return 0;
+}
+
+/**
+ * ice_init_pkg - initialize/download package
+ * @hw: pointer to the hardware structure
+ * @buf: pointer to the package buffer
+ * @len: size of the package buffer
+ *
+ * This function initializes a package. The package contains HW tables
+ * required to do packet processing. First, the function extracts package
+ * information such as version. Then it finds the ice configuration segment
+ * within the package; this function then saves a copy of the segment pointer
+ * within the supplied package buffer. Next, the function will cache any hints
+ * from the package, followed by downloading the package itself. Note, that if
+ * a previous PF driver has already downloaded the package successfully, then
+ * the current driver will not have to download the package again.
+ *
+ * The local package contents will be used to query default behavior and to
+ * update specific sections of the HW's version of the package (e.g. to update
+ * the parse graph to understand new protocols).
+ *
+ * This function stores a pointer to the package buffer memory, and it is
+ * expected that the supplied buffer will not be freed immediately. If the
+ * package buffer needs to be freed, such as when read from a file, use
+ * ice_copy_and_init_pkg() instead of directly calling ice_init_pkg() in this
+ * case.
+ */
+enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buf, u32 len)
+{
+	struct ice_pkg_hdr *pkg;
+	enum ice_status status;
+	struct ice_seg *seg;
+
+	if (!buf || !len)
+		return ICE_ERR_PARAM;
+
+	pkg = (struct ice_pkg_hdr *)buf;
+	status = ice_verify_pkg(pkg, len);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "failed to verify pkg (err: %d)\n",
+			  status);
+		return status;
+	}
+
+	/* initialize package info */
+	status = ice_init_pkg_info(hw, pkg);
+	if (status)
+		return status;
+
+	/* before downloading the package, check package version for
+	 * compatibility with driver
+	 */
+	status = ice_chk_pkg_version(&hw->pkg_ver);
+	if (status)
+		return status;
+
+	/* find segment in given package */
+	seg = (struct ice_seg *)ice_find_seg_in_pkg(hw, SEGMENT_TYPE_ICE, pkg);
+	if (!seg) {
+		ice_debug(hw, ICE_DBG_INIT, "no ice segment in package.\n");
+		return ICE_ERR_CFG;
+	}
+
+	/* download package */
+	status = ice_download_pkg(hw, seg);
+	if (status == ICE_ERR_AQ_NO_WORK) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "package previously loaded - no work.\n");
+		status = 0;
+	}
+
+	/* Get information on the package currently loaded in HW, then make sure
+	 * the driver is compatible with this version.
+	 */
+	if (!status) {
+		status = ice_get_pkg_info(hw);
+		if (!status)
+			status = ice_chk_pkg_version(&hw->active_pkg_ver);
+	}
+
+	if (status)
+		ice_debug(hw, ICE_DBG_INIT, "package load failed, %d\n",
+			  status);
+
+	return status;
+}
+
+/**
+ * ice_copy_and_init_pkg - initialize/download a copy of the package
+ * @hw: pointer to the hardware structure
+ * @buf: pointer to the package buffer
+ * @len: size of the package buffer
+ *
+ * This function copies the package buffer, and then calls ice_init_pkg() to
+ * initialize the copied package contents.
+ *
+ * The copying is necessary if the package buffer supplied is constant, or if
+ * the memory may disappear shortly after calling this function.
+ *
+ * If the package buffer resides in the data segment and can be modified, the
+ * caller is free to use ice_init_pkg() instead of ice_copy_and_init_pkg().
+ *
+ * However, if the package buffer needs to be copied first, such as when being
+ * read from a file, the caller should use ice_copy_and_init_pkg().
+ *
+ * This function will first copy the package buffer, before calling
+ * ice_init_pkg(). The caller is free to immediately destroy the original
+ * package buffer, as the new copy will be managed by this function and
+ * related routines.
+ */
+enum ice_status ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len)
+{
+	enum ice_status status;
+	u8 *buf_copy;
+
+	if (!buf || !len)
+		return ICE_ERR_PARAM;
+
+	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+
+	status = ice_init_pkg(hw, buf_copy, len);
+	if (status) {
+		/* Free the copy, since we failed to initialize the package */
+		devm_kfree(ice_hw_to_dev(hw), buf_copy);
+	} else {
+		/* Track the copied pkg so we can free it later */
+		hw->pkg_copy = buf_copy;
+		hw->pkg_size = len;
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
new file mode 100644
index 000000000000..3843c462bc42
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_FLEX_PIPE_H_
+#define _ICE_FLEX_PIPE_H_
+
+#include "ice_type.h"
+
+/* Package minimal version supported */
+#define ICE_PKG_SUPP_VER_MAJ	1
+#define ICE_PKG_SUPP_VER_MNR	3
+
+/* Package format version */
+#define ICE_PKG_FMT_VER_MAJ	1
+#define ICE_PKG_FMT_VER_MNR	0
+#define ICE_PKG_FMT_VER_UPD	0
+#define ICE_PKG_FMT_VER_DFT	0
+
+#define ICE_PKG_CNT 4
+
+enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buff, u32 len);
+enum ice_status
+ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
+void ice_free_seg(struct ice_hw *hw);
+#endif /* _ICE_FLEX_PIPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
new file mode 100644
index 000000000000..b7fb90594faf
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_FLEX_TYPE_H_
+#define _ICE_FLEX_TYPE_H_
+/* Extraction Sequence (Field Vector) Table */
+struct ice_fv_word {
+	u8 prot_id;
+	u16 off;		/* Offset within the protocol header */
+	u8 resvrd;
+} __packed;
+
+#define ICE_MAX_FV_WORDS 48
+struct ice_fv {
+	struct ice_fv_word ew[ICE_MAX_FV_WORDS];
+};
+
+/* Package and segment headers and tables */
+struct ice_pkg_hdr {
+	struct ice_pkg_ver format_ver;
+	__le32 seg_count;
+	__le32 seg_offset[1];
+};
+
+/* generic segment */
+struct ice_generic_seg_hdr {
+#define SEGMENT_TYPE_METADATA	0x00000001
+#define SEGMENT_TYPE_ICE	0x00000010
+	__le32 seg_type;
+	struct ice_pkg_ver seg_ver;
+	__le32 seg_size;
+	char seg_name[ICE_PKG_NAME_SIZE];
+};
+
+/* ice specific segment */
+
+union ice_device_id {
+	struct {
+		__le16 device_id;
+		__le16 vendor_id;
+	} dev_vend_id;
+	__le32 id;
+};
+
+struct ice_device_id_entry {
+	union ice_device_id device;
+	union ice_device_id sub_device;
+};
+
+struct ice_seg {
+	struct ice_generic_seg_hdr hdr;
+	__le32 device_table_count;
+	struct ice_device_id_entry device_table[1];
+};
+
+struct ice_nvm_table {
+	__le32 table_count;
+	__le32 vers[1];
+};
+
+struct ice_buf {
+#define ICE_PKG_BUF_SIZE	4096
+	u8 buf[ICE_PKG_BUF_SIZE];
+};
+
+struct ice_buf_table {
+	__le32 buf_count;
+	struct ice_buf buf_array[1];
+};
+
+/* global metadata specific segment */
+struct ice_global_metadata_seg {
+	struct ice_generic_seg_hdr hdr;
+	struct ice_pkg_ver pkg_ver;
+	__le32 track_id;
+	char pkg_name[ICE_PKG_NAME_SIZE];
+};
+
+#define ICE_MIN_S_OFF		12
+#define ICE_MAX_S_OFF		4095
+#define ICE_MIN_S_SZ		1
+#define ICE_MAX_S_SZ		4084
+
+/* section information */
+struct ice_section_entry {
+	__le32 type;
+	__le16 offset;
+	__le16 size;
+};
+
+#define ICE_MIN_S_COUNT		1
+#define ICE_MAX_S_COUNT		511
+#define ICE_MIN_S_DATA_END	12
+#define ICE_MAX_S_DATA_END	4096
+
+#define ICE_METADATA_BUF	0x80000000
+
+struct ice_buf_hdr {
+	__le16 section_count;
+	__le16 data_end;
+	struct ice_section_entry section_entry[1];
+};
+
+#define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz) ((ICE_PKG_BUF_SIZE - \
+	sizeof(struct ice_buf_hdr) - (hd_sz)) / (ent_sz))
+
+/* ice package section IDs */
+#define ICE_SID_XLT1_SW			12
+#define ICE_SID_XLT2_SW			13
+#define ICE_SID_PROFID_TCAM_SW		14
+#define ICE_SID_PROFID_REDIR_SW		15
+#define ICE_SID_FLD_VEC_SW		16
+
+#define ICE_SID_XLT1_ACL		22
+#define ICE_SID_XLT2_ACL		23
+#define ICE_SID_PROFID_TCAM_ACL		24
+#define ICE_SID_PROFID_REDIR_ACL	25
+#define ICE_SID_FLD_VEC_ACL		26
+
+#define ICE_SID_XLT1_FD			32
+#define ICE_SID_XLT2_FD			33
+#define ICE_SID_PROFID_TCAM_FD		34
+#define ICE_SID_PROFID_REDIR_FD		35
+#define ICE_SID_FLD_VEC_FD		36
+
+#define ICE_SID_XLT1_RSS		42
+#define ICE_SID_XLT2_RSS		43
+#define ICE_SID_PROFID_TCAM_RSS		44
+#define ICE_SID_PROFID_REDIR_RSS	45
+#define ICE_SID_FLD_VEC_RSS		46
+
+#define ICE_SID_RXPARSER_BOOST_TCAM	56
+
+#define ICE_SID_XLT1_PE			82
+#define ICE_SID_XLT2_PE			83
+#define ICE_SID_PROFID_TCAM_PE		84
+#define ICE_SID_PROFID_REDIR_PE		85
+#define ICE_SID_FLD_VEC_PE		86
+
+/* Label Metadata section IDs */
+#define ICE_SID_LBL_FIRST		0x80000010
+#define ICE_SID_LBL_RXPARSER_TMEM	0x80000018
+/* The following define MUST be updated to reflect the last label section ID */
+#define ICE_SID_LBL_LAST		0x80000038
+
+enum ice_block {
+	ICE_BLK_SW = 0,
+	ICE_BLK_ACL,
+	ICE_BLK_FD,
+	ICE_BLK_RSS,
+	ICE_BLK_PE,
+	ICE_BLK_COUNT
+};
+
+/* package labels */
+struct ice_label {
+	__le16 value;
+#define ICE_PKG_LABEL_SIZE	64
+	char name[ICE_PKG_LABEL_SIZE];
+};
+
+struct ice_label_section {
+	__le16 count;
+	struct ice_label label[1];
+};
+
+#define ICE_MAX_LABELS_IN_BUF ICE_MAX_ENTRIES_IN_BUF( \
+	sizeof(struct ice_label_section) - sizeof(struct ice_label), \
+	sizeof(struct ice_label))
+
+struct ice_sw_fv_section {
+	__le16 count;
+	__le16 base_offset;
+	struct ice_fv fv[1];
+};
+
+/* The BOOST TCAM stores the match packet header in reverse order, meaning
+ * the fields are reversed; in addition, this means that the normally big endian
+ * fields of the packet are now little endian.
+ */
+struct ice_boost_key_value {
+#define ICE_BOOST_REMAINING_HV_KEY	15
+	u8 remaining_hv_key[ICE_BOOST_REMAINING_HV_KEY];
+	__le16 hv_dst_port_key;
+	__le16 hv_src_port_key;
+	u8 tcam_search_key;
+} __packed;
+
+struct ice_boost_key {
+	struct ice_boost_key_value key;
+	struct ice_boost_key_value key2;
+};
+
+/* package Boost TCAM entry */
+struct ice_boost_tcam_entry {
+	__le16 addr;
+	__le16 reserved;
+	/* break up the 40 bytes of key into different fields */
+	struct ice_boost_key key;
+	u8 boost_hit_index_group;
+	/* The following contains bitfields which are not on byte boundaries.
+	 * These fields are currently unused by driver software.
+	 */
+#define ICE_BOOST_BIT_FIELDS		43
+	u8 bit_fields[ICE_BOOST_BIT_FIELDS];
+};
+
+struct ice_boost_tcam_section {
+	__le16 count;
+	__le16 reserved;
+	struct ice_boost_tcam_entry tcam[1];
+};
+
+#define ICE_MAX_BST_TCAMS_IN_BUF ICE_MAX_ENTRIES_IN_BUF( \
+	sizeof(struct ice_boost_tcam_section) - \
+	sizeof(struct ice_boost_tcam_entry), \
+	sizeof(struct ice_boost_tcam_entry))
+
+struct ice_xlt1_section {
+	__le16 count;
+	__le16 offset;
+	u8 value[1];
+} __packed;
+
+struct ice_xlt2_section {
+	__le16 count;
+	__le16 offset;
+	__le16 value[1];
+};
+
+struct ice_prof_redir_section {
+	__le16 count;
+	__le16 offset;
+	u8 redir_value[1];
+};
+
+struct ice_pkg_enum {
+	struct ice_buf_table *buf_table;
+	u32 buf_idx;
+
+	u32 type;
+	struct ice_buf_hdr *buf;
+	u32 sect_idx;
+	void *sect;
+	u32 sect_type;
+
+	u32 entry_idx;
+	void *(*handler)(u32 sect_type, void *section, u32 index, u32 *offset);
+};
+
+struct ice_es {
+	u32 sid;
+	u16 count;
+	u16 fvw;
+	u16 *ref_count;
+	struct list_head prof_map;
+	struct ice_fv_word *t;
+	struct mutex prof_map_lock;	/* protect access to profiles list */
+	u8 *written;
+	u8 reverse; /* set to true to reverse FV order */
+};
+
+/* PTYPE Group management */
+
+/* Note: XLT1 table takes 13-bit as input, and results in an 8-bit packet type
+ * group (PTG) ID as output.
+ *
+ * Note: PTG 0 is the default packet type group and it is assumed that all PTYPE
+ * are a part of this group until moved to a new PTG.
+ */
+#define ICE_DEFAULT_PTG	0
+
+struct ice_ptg_entry {
+	struct ice_ptg_ptype *first_ptype;
+	u8 in_use;
+};
+
+struct ice_ptg_ptype {
+	struct ice_ptg_ptype *next_ptype;
+	u8 ptg;
+};
+
+struct ice_vsig_entry {
+	struct list_head prop_lst;
+	struct ice_vsig_vsi *first_vsi;
+	u8 in_use;
+};
+
+struct ice_vsig_vsi {
+	struct ice_vsig_vsi *next_vsi;
+	u32 prop_mask;
+	u16 changed;
+	u16 vsig;
+};
+
+#define ICE_XLT1_CNT	1024
+
+/* XLT1 Table */
+struct ice_xlt1 {
+	struct ice_ptg_entry *ptg_tbl;
+	struct ice_ptg_ptype *ptypes;
+	u8 *t;
+	u32 sid;
+	u16 count;
+};
+
+#define ICE_MAX_VSIGS	768
+
+/* VSIG bit layout:
+ * [0:12]: incremental VSIG index 1 to ICE_MAX_VSIGS
+ * [13:15]: PF number of device
+ */
+#define ICE_VSIG_IDX_M	(0x1FFF)
+#define ICE_PF_NUM_S	13
+#define ICE_PF_NUM_M	(0x07 << ICE_PF_NUM_S)
+#define ICE_VSIG_VALUE(vsig, pf_id) \
+	(u16)((((u16)(vsig)) & ICE_VSIG_IDX_M) | \
+	      (((u16)(pf_id) << ICE_PF_NUM_S) & ICE_PF_NUM_M))
+#define ICE_DEFAULT_VSIG	0
+
+/* XLT2 Table */
+struct ice_xlt2 {
+	struct ice_vsig_entry *vsig_tbl;
+	struct ice_vsig_vsi *vsis;
+	u16 *t;
+	u32 sid;
+	u16 count;
+};
+
+/* Keys are made up of two values, each one-half the size of the key.
+ * For TCAM, the entire key is 80 bits wide (or 2, 40-bit wide values)
+ */
+#define ICE_TCAM_KEY_VAL_SZ	5
+#define ICE_TCAM_KEY_SZ		(2 * ICE_TCAM_KEY_VAL_SZ)
+
+struct ice_prof_tcam_entry {
+	__le16 addr;
+	u8 key[ICE_TCAM_KEY_SZ];
+	u8 prof_id;
+} __packed;
+
+struct ice_prof_id_section {
+	__le16 count;
+	struct ice_prof_tcam_entry entry[1];
+} __packed;
+
+struct ice_prof_tcam {
+	u32 sid;
+	u16 count;
+	u16 max_prof_id;
+	struct ice_prof_tcam_entry *t;
+	u8 cdid_bits; /* # CDID bits to use in key, 0, 2, 4, or 8 */
+};
+
+struct ice_prof_redir {
+	u8 *t;
+	u32 sid;
+	u16 count;
+};
+
+/* Tables per block */
+struct ice_blk_info {
+	struct ice_xlt1 xlt1;
+	struct ice_xlt2 xlt2;
+	struct ice_prof_tcam prof;
+	struct ice_prof_redir prof_redir;
+	struct ice_es es;
+	u8 overwrite; /* set to true to allow overwrite of table entries */
+	u8 is_list_init;
+};
+
+#endif /* _ICE_FLEX_TYPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 6f78ff5534af..152fbd556e9b 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -55,6 +55,8 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
+#define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
+#define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
 #define GLFLXP_RXDID_FLAGS(_i, _j)		(0x0045D000 + ((_i) * 4 + (_j) * 256))
 #define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S	0
 #define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M	ICE_M(0x3F, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 7ec8a529b5cf..6667d17a4206 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -12,6 +12,7 @@
 #include "ice_osdep.h"
 #include "ice_controlq.h"
 #include "ice_lan_tx_rx.h"
+#include "ice_flex_type.h"
 
 static inline bool ice_is_tc_ena(unsigned long bitmap, u8 tc)
 {
@@ -31,6 +32,7 @@ static inline bool ice_is_tc_ena(unsigned long bitmap, u8 tc)
 #define ICE_DBG_LAN		BIT_ULL(8)
 #define ICE_DBG_SW		BIT_ULL(13)
 #define ICE_DBG_SCHED		BIT_ULL(14)
+#define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
 #define ICE_DBG_AQ_CMD		BIT_ULL(27)
@@ -469,6 +471,30 @@ struct ice_hw {
 
 	u8 ucast_shared;	/* true if VSIs can share unicast addr */
 
+	/* Active package version (currently active) */
+	struct ice_pkg_ver active_pkg_ver;
+	u8 active_pkg_name[ICE_PKG_NAME_SIZE];
+	u8 active_pkg_in_nvm;
+
+	enum ice_aq_err pkg_dwnld_status;
+
+	/* Driver's package ver - (from the Metadata seg) */
+	struct ice_pkg_ver pkg_ver;
+	u8 pkg_name[ICE_PKG_NAME_SIZE];
+
+	/* Driver's Ice package version (from the Ice seg) */
+	struct ice_pkg_ver ice_pkg_ver;
+	u8 ice_pkg_name[ICE_PKG_NAME_SIZE];
+
+	/* Pointer to the ice segment */
+	struct ice_seg *seg;
+
+	/* Pointer to allocated copy of pkg memory */
+	u8 *pkg_copy;
+	u32 pkg_size;
+
+	/* HW block tables */
+	struct ice_blk_info blk[ICE_BLK_COUNT];
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
-- 
2.21.0

