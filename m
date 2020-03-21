Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B0918DEA1
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgCUIKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:33283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgCUIKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:35 -0400
IronPort-SDR: UU/RBpsB06HNT6uQmywDXoeLM/JQqRzxJZHc59UE74rIJemzSz6HAVHlZdPieBHx6aYufQDz+z
 BvxdDPQZgu9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:30 -0700
IronPort-SDR: /8zy2L8+SHkp52m/+i49YLrZEjukDUauChjcUS9LAfvk2hW8XCvoSHSHAPWsYT6N5H8y0e5Cuu
 FP+9LW+LqwbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737951"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/9] ice: create function to read a section of the NVM and Shadow RAM
Date:   Sat, 21 Mar 2020 01:10:21 -0700
Message-Id: <20200321081028.2763550-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

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
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 87 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  3 +
 3 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 38b6ffb6ad2e..33017d37ea33 100644
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
index 5597ec50a662..97aaf75379ae 100644
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
+ * Reads a portion of the NVM, as a flat memory space. This function correctly
+ * breaks read requests across Shadow RAM sectors and ensures that no single
+ * read request exceeds the maximum 4Kb read for a single AdminQ command.
+ *
+ * Returns a status code on failure. Note that the data pointer may be
+ * partially updated if some reads succeed before a failure.
+ */
+enum ice_status
+ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
+		  bool read_shadow_ram)
+{
+	enum ice_status status;
+	u32 inlen = *length;
+	u32 bytes_read = 0;
+	bool last_cmd;
+
+	*length = 0;
+
+	/* Verify the length of the read if this is for the Shadow RAM */
+	if (read_shadow_ram && ((offset + inlen) > (hw->nvm.sr_words * 2u))) {
+		ice_debug(hw, ICE_DBG_NVM,
+			  "NVM error: requested offset is beyond Shadow RAM limit\n");
+		return ICE_ERR_PARAM;
+	}
+
+	do {
+		u32 read_size, sector_offset;
+
+		/* ice_aq_read_nvm cannot read more than 4Kb at a time.
+		 * Additionally, a read from the Shadow RAM may not cross over
+		 * a sector boundary. Conveniently, the sector size is also
+		 * 4Kb.
+		 */
+		sector_offset = offset % ICE_AQ_MAX_BUF_LEN;
+		read_size = min_t(u32, ICE_AQ_MAX_BUF_LEN - sector_offset,
+				  inlen - bytes_read);
+
+		last_cmd = !(bytes_read + read_size < inlen);
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
+	/* Note that ice_read_flat_nvm takes into account the 4Kb AdminQ and
+	 * Shadow RAM sector restrictions necessary when reading from the NVM.
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
2.25.1

