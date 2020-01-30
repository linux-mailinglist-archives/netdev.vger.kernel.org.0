Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFE14E5BF
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgA3W70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:51511 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbgA3W7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187785"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:21 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 06/15] ice: create function to read a section of the NVM and Shadow RAM
Date:   Thu, 30 Jan 2020 14:59:01 -0800
Message-Id: <20200130225913.1671982-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NVM contents are read via firmware by using the ice_aq_read_nvm
function. This function has a couple of limits:

1) The AdminQ commands can only take buffers sized up to 4Kb. Thus, any
   larger read must be split into multiple reads.
2) when reading from the Shadow RAM, reads must not cross sector
   boundaries. The sectors are also 4Kb in size.

Implement the ice_read_flat_nvm function to read portions of the NVM by
flat offset. That is, to read using offsets from the start of the NVM
rather than from a specific module.

This function will be able to read both from the NVM and from the Shadow
RAM. For simplicity NVM reads will always be broken up to not cross 4Kb
page boundaries, even though this is not required unless reading from
the Shadow RAM.

Use this new function as the implementation of ice_read_sr_word_aq.

The ice_read_sr_buf_aq function is not modified here. This is because
a following change will remove the only caller of that function in favor
of directly using ice_read_flat_nvm. Thus, there is little benefit to
changing it now only to remove it momentarily. At the same time, the
ice_read_sr_aq function will also be removed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 87 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  3 +
 3 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 4459bc564b11..2240f226568f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1250,6 +1250,8 @@ struct ice_aqc_nvm {
 	__le32 addr_low;
 };
 
+#define ICE_AQC_NVM_START_POINT			0
+
 /* NVM Checksum Command (direct, 0x0706) */
 struct ice_aqc_nvm_checksum {
 	u8 flags;
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 46db9bb0977f..622431aa1e22 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -11,13 +11,15 @@
  * @length: length of the section to be read (in bytes from the offset)
  * @data: command buffer (size [bytes] = length)
  * @last_command: tells if this is the last command in a series
+ * @read_shadow_ram: tell if this is a shadow RAM read
  * @cd: pointer to command details structure or NULL
  *
  * Read the NVM using the admin queue commands (0x0701)
  */
 static enum ice_status
 ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
-		void *data, bool last_command, struct ice_sq_cd *cd)
+		void *data, bool last_command, bool read_shadow_ram,
+		struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc;
 	struct ice_aqc_nvm *cmd;
@@ -30,6 +32,9 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_read);
 
+	if (!read_shadow_ram && module_typeid == ICE_AQC_NVM_START_POINT)
+		cmd->cmd_flags |= ICE_AQC_NVM_FLASH_ONLY;
+
 	/* If this is the last command in a series, set the proper flag. */
 	if (last_command)
 		cmd->cmd_flags |= ICE_AQC_NVM_LAST_CMD;
@@ -41,6 +46,68 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 	return ice_aq_send_cmd(hw, &desc, data, length, cd);
 }
 
+/**
+ * ice_read_flat_nvm - Read portion of NVM by flat offset
+ * @hw: pointer to the HW struct
+ * @offset: offset from beginning of NVM
+ * @length: (in) number of bytes to read; (out) number of bytes actually read
+ * @data: buffer to return data in (sized to fit the specified length)
+ * @read_shadow_ram: if true, read from shadow RAM instead of NVM
+ *
+ * Reads a portion of the NVM, as a flat memory space. This function will
+ * correctly handle reading of sizes beyond a page by breaking the request
+ * into multiple reads.
+ *
+ * Returns a status code on failure. Note that the data pointer may be
+ * partially updated if some reads succeed before a failure.
+ */
+enum ice_status
+ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
+		  bool read_shadow_ram)
+{
+	enum ice_status status;
+	bool last_cmd = true;
+	u32 inlen = *length;
+	u32 bytes_read = 0;
+
+	*length = 0;
+
+	/* Verify the length of the read if this is for the Shadow RAM */
+	if (read_shadow_ram && ((offset + inlen) > (hw->nvm.sr_words * 2))) {
+		ice_debug(hw, ICE_DBG_NVM,
+			  "NVM error: requested offset is beyond Shadow RAM limit\n");
+		return ICE_ERR_PARAM;
+	}
+
+	do {
+		u32 read_size, page_offset;
+
+		/* ice_aq_read_nvm cannot read more than 4Kb at a time.
+		 * Additionally, break the reads up so that they do not cross
+		 * a page boundary.
+		 */
+		page_offset = offset % ICE_AQ_MAX_BUF_LEN;
+		read_size = min_t(u32, ICE_AQ_MAX_BUF_LEN - page_offset,
+				  inlen - bytes_read);
+
+		if ((bytes_read + read_size) < inlen)
+			last_cmd = false;
+
+		status = ice_aq_read_nvm(hw, ICE_AQC_NVM_START_POINT,
+					 offset, read_size,
+					 data + bytes_read, last_cmd,
+					 read_shadow_ram, NULL);
+		if (status)
+			break;
+
+		bytes_read += read_size;
+		offset += read_size;
+	} while (!last_cmd);
+
+	*length = bytes_read;
+	return status;
+}
+
 /**
  * ice_check_sr_access_params - verify params for Shadow RAM R/W operations.
  * @hw: pointer to the HW structure
@@ -100,7 +167,7 @@ ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, __le16 *data,
 	 */
 	if (!status)
 		status = ice_aq_read_nvm(hw, 0, 2 * offset, 2 * words, data,
-					 last_command, NULL);
+					 last_command, true, NULL);
 
 	return status;
 }
@@ -111,19 +178,25 @@ ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, __le16 *data,
  * @offset: offset of the Shadow RAM word to read (0x000000 - 0x001FFF)
  * @data: word read from the Shadow RAM
  *
- * Reads one 16 bit word from the Shadow RAM using the ice_read_sr_aq method.
+ * Reads one 16 bit word from the Shadow RAM using ice_read_flat_nvm.
  */
 static enum ice_status
 ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 {
+	u32 bytes = sizeof(u16);
 	enum ice_status status;
 	__le16 data_local;
 
-	status = ice_read_sr_aq(hw, offset, 1, &data_local, true);
-	if (!status)
-		*data = le16_to_cpu(data_local);
+	/* Note that ice_read_flat_nvm checks if the read is past the Shadow
+	 * RAM size, and ensures we don't read across a page boundary
+	 */
+	status = ice_read_flat_nvm(hw, offset * sizeof(u16), &bytes,
+				   (u8 *)&data_local, true);
+	if (status)
+		return status;
 
-	return status;
+	*data = le16_to_cpu(data_local);
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index a9fa011c22c6..4245ef988edf 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -4,5 +4,8 @@
 #ifndef _ICE_NVM_H_
 #define _ICE_NVM_H_
 
+enum ice_status
+ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
+		  bool read_shadow_ram);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
 #endif /* _ICE_NVM_H_ */
-- 
2.25.0.rc1

