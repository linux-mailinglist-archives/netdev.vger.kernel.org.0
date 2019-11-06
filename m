Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD76F1F15
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbfKFTiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:38:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:25882 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfKFTiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:38:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:37:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473257"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:37:58 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 01/14] ice: implement set_eeprom functionality
Date:   Wed,  6 Nov 2019 11:37:43 -0800
Message-Id: <20191106193756.23819-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver needs set_eeprom to work so that it can
program the onboard NVM using our update application.

Add functions that are necessary to enable reading the
NVM image.  They implement basic functionality to lock,
read, unlock during an NVM read.  Also remove shadow ram
functionality since it is no longer used. In addition
move a few function declarations into ice_nvm.h.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 125 ++++++-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  24 ++
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 341 +++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  79 ++++
 8 files changed, 468 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_nvm.h

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 023e3d2fee5f..feadf144d7c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1170,6 +1170,8 @@ struct ice_aqc_nvm {
 	__le32 addr_low;
 };
 
+#define ICE_AQC_NVM_START_POINT			0
+
 /* NVM Checksum Command (direct, 0x0706) */
 struct ice_aqc_nvm_checksum {
 	u8 flags;
@@ -1673,6 +1675,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_ENOMEM	= 9,  /* Out of memory */
 	ICE_AQ_RC_EBUSY		= 12, /* Device or resource busy */
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
+	ICE_AQ_RC_EINVAL	= 14, /* Invalid argument */
 	ICE_AQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
 	ICE_AQ_RC_ENOSYS	= 17, /* Function not implemented */
 	ICE_AQ_RC_ENOSEC	= 24, /* Missing security manifest */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index c3df92f57777..8a409edef38a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -6,6 +6,7 @@
 
 #include "ice.h"
 #include "ice_type.h"
+#include "ice_nvm.h"
 #include "ice_flex_pipe.h"
 #include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
@@ -32,9 +33,6 @@ enum ice_status
 ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 		enum ice_aq_res_access_type access, u32 timeout);
 void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res);
-enum ice_status ice_init_nvm(struct ice_hw *hw);
-enum ice_status
-ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data);
 enum ice_status
 ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		struct ice_aq_desc *desc, void *buf, u16 buf_size,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 7e779060069c..c270fbbc25bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -226,12 +226,12 @@ static void ice_set_msglevel(struct net_device *netdev, u32 data)
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 }
 
-static int ice_get_eeprom_len(struct net_device *netdev)
+static int ice_get_eeprom_len(struct net_device __always_unused *netdev)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
-
-	return (int)(pf->hw.nvm.sr_words * sizeof(u16));
+	/* currently using a magic number of 0xFFFFFF to allow
+	 * reads within the 16MB range of the NVM
+	 */
+	return 0xFFFFFF;
 }
 
 static int
@@ -239,42 +239,127 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
 	       u8 *bytes)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	u16 first_word, last_word, nwords;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
-	struct device *dev;
 	int ret = 0;
-	u16 *buf;
+	u32 magic;
+	u8 *buf;
+
+	if (!eeprom->len || eeprom->len > ice_get_eeprom_len(netdev))
+		return -EINVAL;
+
+	magic = hw->vendor_id | (hw->device_id << 16);
+	if (eeprom->magic && eeprom->magic != magic) {
+		struct ice_nvm_access_cmd *nvm;
+		union ice_nvm_access_data *data;
+
+		nvm = (struct ice_nvm_access_cmd *)eeprom;
+		data = (union ice_nvm_access_data *)bytes;
+
+		netdev_dbg(netdev, "GEEPROM cmd 0x%08x, config 0x%08x, offset 0x%08x, data_size 0x%08x\n",
+			   nvm->command, nvm->config, nvm->offset,
+			   nvm->data_size);
+
+		status = ice_handle_nvm_access(hw, nvm, data);
 
-	dev = &pf->pdev->dev;
+		ice_debug_array(hw, ICE_DBG_NVM, 16, 1, (u8 *)data,
+				nvm->data_size);
 
-	eeprom->magic = hw->vendor_id | (hw->device_id << 16);
+		if (status) {
+			int err = ice_status_to_errno(status);
 
-	first_word = eeprom->offset >> 1;
-	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
-	nwords = last_word - first_word + 1;
+			netdev_info(netdev, "NVM read failed with status %d, error %d\n",
+				    status, err);
 
-	buf = devm_kcalloc(dev, nwords, sizeof(u16), GFP_KERNEL);
+			return err;
+		}
+
+		return 0;
+	}
+
+	eeprom->magic = magic;
+	netdev_dbg(netdev, "GEEPROM cmd 0x%08x, offset 0x%08x, len 0x%08x\n",
+		   eeprom->cmd, eeprom->offset, eeprom->len);
+
+	buf = kzalloc(eeprom->len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	status = ice_read_sr_buf(hw, first_word, &nwords, buf);
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
 	if (status) {
-		dev_err(dev, "ice_read_sr_buf failed, err %d aq_err %d\n",
+		dev_err(&pf->pdev->dev, "ice_acquire_nvm failed: %d %d\n",
 			status, hw->adminq.sq_last_status);
-		eeprom->len = sizeof(u16) * nwords;
 		ret = -EIO;
 		goto out;
 	}
 
-	memcpy(bytes, (u8 *)buf + (eeprom->offset & 1), eeprom->len);
+	/* kernel only issues 4kB reads so we are good to read 4KB at a time */
+	status = ice_aq_read_nvm(hw, ICE_AQC_NVM_START_POINT, eeprom->offset,
+				 eeprom->len, buf, true, false, NULL);
+	if (status == ICE_ERR_AQ_ERROR &&
+	    hw->adminq.sq_last_status == ICE_AQ_RC_EINVAL) {
+		/* do nothing, we reached the end */
+		ice_release_nvm(hw);
+		goto out;
+	} else if (status) {
+		dev_err(&pf->pdev->dev, "ice_aq_read_nvm failed: %d %d\n",
+			status, hw->adminq.sq_last_status);
+		ret = -EIO;
+		ice_release_nvm(hw);
+		goto out;
+	}
+
+	ice_release_nvm(hw);
+
+	memcpy(bytes, buf + eeprom->offset, eeprom->len);
 out:
-	devm_kfree(dev, buf);
+	kfree(buf);
 	return ret;
 }
 
+static int
+ice_set_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
+	       u8 *bytes)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_hw *hw = &np->vsi->back->hw;
+	struct ice_pf *pf = np->vsi->back;
+	union ice_nvm_access_data *data;
+	struct ice_nvm_access_cmd *nvm;
+	enum ice_status status = 0;
+	int err = 0;
+	u32 magic;
+
+	/* normal ethtool set_eeprom is not supported */
+	nvm = (struct ice_nvm_access_cmd *)eeprom;
+	data = (union ice_nvm_access_data *)bytes;
+	magic = hw->vendor_id | (hw->device_id << 16);
+
+	netdev_dbg(netdev, "SEEPROM cmd 0x%08x, config 0x%08x, offset 0x%08x, data_size 0x%08x\n",
+		   nvm->command, nvm->config, nvm->offset, nvm->data_size);
+	ice_debug_array(hw, ICE_DBG_NVM, 16, 1, (u8 *)data, nvm->data_size);
+
+	if (eeprom->magic == magic)
+		err = -EOPNOTSUPP;
+	/* check for NVM access method */
+	else if (!eeprom->magic || (eeprom->magic >> 16) != hw->device_id)
+		err = -EINVAL;
+	else if (ice_is_reset_in_progress(pf->state))
+		err = -EBUSY;
+	else
+		status = ice_handle_nvm_access(hw, nvm, data);
+
+	if (status) {
+		err = ice_status_to_errno(status);
+		netdev_info(netdev, "NVM write failed with status %d, error %d\n",
+			    status, err);
+	}
+
+	return err;
+}
+
 /**
  * ice_active_vfs - check if there are any active VFs
  * @pf: board private structure
@@ -3467,6 +3552,7 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_eeprom_len		= ice_get_eeprom_len,
 	.get_eeprom		= ice_get_eeprom,
+	.set_eeprom		= ice_set_eeprom,
 	.get_coalesce		= ice_get_coalesce,
 	.set_coalesce		= ice_set_coalesce,
 	.get_strings		= ice_get_strings,
@@ -3502,6 +3588,7 @@ static const struct ethtool_ops ice_ethtool_safe_mode_ops = {
 	.set_msglevel		= ice_set_msglevel,
 	.get_eeprom_len		= ice_get_eeprom_len,
 	.get_eeprom		= ice_get_eeprom,
+	.set_eeprom		= ice_set_eeprom,
 	.get_strings		= ice_get_strings,
 	.get_ethtool_stats	= ice_get_ethtool_stats,
 	.get_sset_count		= ice_get_sset_count,
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 152fbd556e9b..9497e990139c 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -91,6 +91,7 @@
 #define QRXFLXP_CNTXT_RXDID_IDX_M		ICE_M(0x3F, 0)
 #define QRXFLXP_CNTXT_RXDID_PRIO_S		8
 #define QRXFLXP_CNTXT_RXDID_PRIO_M		ICE_M(0x7, 8)
+#define GL_FWSTS				0x00083048
 #define GLGEN_RSTAT				0x000B8188
 #define GLGEN_RSTAT_DEVSTATE_M			ICE_M(0x3, 0)
 #define GLGEN_RSTCTL				0x000B8180
@@ -267,6 +268,7 @@
 #define VP_MDET_TX_TCLAN_VALID_M		BIT(0)
 #define VP_MDET_TX_TDPU(_VF)			(0x00040000 + ((_VF) * 4))
 #define VP_MDET_TX_TDPU_VALID_M			BIT(0)
+#define GL_MNG_FWSM				0x000B6134
 #define GLNVM_FLA				0x000B6108
 #define GLNVM_FLA_LOCKED_M			BIT(6)
 #define GLNVM_GENS				0x000B6100
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b1e96cac5b1f..3cfd11f41882 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2609,3 +2609,27 @@ ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set)
 	ice_free_fltr_list(&vsi->back->pdev->dev, &tmp_add_list);
 	return status;
 }
+
+/**
+ * ice_status_to_errno - convert from enum ice_status to Linux errno
+ * @err: ice_status value to convert
+ */
+int ice_status_to_errno(enum ice_status err)
+{
+	switch (err) {
+	case ICE_SUCCESS:
+		return 0;
+	case ICE_ERR_DOES_NOT_EXIST:
+		return -ENOENT;
+	case ICE_ERR_OUT_OF_RANGE:
+		return -ENOTTY;
+	case ICE_ERR_PARAM:
+		return -EINVAL;
+	case ICE_ERR_NO_MEMORY:
+		return -ENOMEM;
+	case ICE_ERR_MAX_LIMIT:
+		return -EAGAIN;
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8d5a7978e066..d8cc03197878 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -89,6 +89,8 @@ void ice_update_rx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
 
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
+int ice_status_to_errno(enum ice_status err);
+
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 
 char *ice_nvm_version_str(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index bcb431f1bd92..bd19ce9b5bfd 100644
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
-static enum ice_status
+enum ice_status
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
@@ -98,8 +103,9 @@ ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, u16 *data,
 	 * So do this conversion while calling ice_aq_read_nvm.
 	 */
 	if (!status)
-		status = ice_aq_read_nvm(hw, 0, 2 * offset, 2 * words, data,
-					 last_command, NULL);
+		status = ice_aq_read_nvm(hw, ICE_AQC_NVM_START_POINT,
+					 2 * offset, 2 * words, data,
+					 last_command, true, NULL);
 
 	return status;
 }
@@ -124,63 +130,6 @@ ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 	return status;
 }
 
-/**
- * ice_read_sr_buf_aq - Reads Shadow RAM buf via AQ
- * @hw: pointer to the HW structure
- * @offset: offset of the Shadow RAM word to read (0x000000 - 0x001FFF)
- * @words: (in) number of words to read; (out) number of words actually read
- * @data: words read from the Shadow RAM
- *
- * Reads 16 bit words (data buf) from the SR using the ice_read_sr_aq
- * method. Ownership of the NVM is taken before reading the buffer and later
- * released.
- */
-static enum ice_status
-ice_read_sr_buf_aq(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
-{
-	enum ice_status status;
-	bool last_cmd = false;
-	u16 words_read = 0;
-	u16 i = 0;
-
-	do {
-		u16 read_size, off_w;
-
-		/* Calculate number of bytes we should read in this step.
-		 * It's not allowed to read more than one page at a time or
-		 * to cross page boundaries.
-		 */
-		off_w = offset % ICE_SR_SECTOR_SIZE_IN_WORDS;
-		read_size = off_w ?
-			min_t(u16, *words,
-			      (ICE_SR_SECTOR_SIZE_IN_WORDS - off_w)) :
-			min_t(u16, (*words - words_read),
-			      ICE_SR_SECTOR_SIZE_IN_WORDS);
-
-		/* Check if this is last command, if so set proper flag */
-		if ((words_read + read_size) >= *words)
-			last_cmd = true;
-
-		status = ice_read_sr_aq(hw, offset, read_size,
-					data + words_read, last_cmd);
-		if (status)
-			goto read_nvm_buf_aq_exit;
-
-		/* Increment counter for words already read and move offset to
-		 * new read location
-		 */
-		words_read += read_size;
-		offset += read_size;
-	} while (words_read < *words);
-
-	for (i = 0; i < *words; i++)
-		data[i] = le16_to_cpu(((__force __le16 *)data)[i]);
-
-read_nvm_buf_aq_exit:
-	*words = words_read;
-	return status;
-}
-
 /**
  * ice_acquire_nvm - Generic request for acquiring the NVM ownership
  * @hw: pointer to the HW structure
@@ -188,7 +137,7 @@ ice_read_sr_buf_aq(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
  *
  * This function will request NVM ownership.
  */
-static enum ice_status
+enum ice_status
 ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access)
 {
 	if (hw->nvm.blank_nvm_mode)
@@ -203,7 +152,7 @@ ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access)
  *
  * This function will release NVM ownership.
  */
-static void ice_release_nvm(struct ice_hw *hw)
+void ice_release_nvm(struct ice_hw *hw)
 {
 	if (hw->nvm.blank_nvm_mode)
 		return;
@@ -219,8 +168,8 @@ static void ice_release_nvm(struct ice_hw *hw)
  *
  * Reads one 16 bit word from the Shadow RAM using the ice_read_sr_word_aq.
  */
-static enum ice_status
-ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
+static enum
+ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
 {
 	enum ice_status status;
 
@@ -292,31 +241,6 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 	return status;
 }
 
-/**
- * ice_read_sr_buf - Reads Shadow RAM buf and acquire lock if necessary
- * @hw: pointer to the HW structure
- * @offset: offset of the Shadow RAM word to read (0x000000 - 0x001FFF)
- * @words: (in) number of words to read; (out) number of words actually read
- * @data: words read from the Shadow RAM
- *
- * Reads 16 bit words (data buf) from the SR using the ice_read_nvm_buf_aq
- * method. The buf read is preceded by the NVM ownership take
- * and followed by the release.
- */
-enum ice_status
-ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
-{
-	enum ice_status status;
-
-	status = ice_acquire_nvm(hw, ICE_RES_READ);
-	if (!status) {
-		status = ice_read_sr_buf_aq(hw, offset, words, data);
-		ice_release_nvm(hw);
-	}
-
-	return status;
-}
-
 /**
  * ice_nvm_validate_checksum
  * @hw: pointer to the HW struct
@@ -347,3 +271,240 @@ enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw)
 
 	return status;
 }
+
+/**
+ * ice_nvm_access_get_features - Return the NVM access features structure
+ * @cmd: NVM access command to process
+ * @data: storage for the driver NVM features
+ *
+ * Fill in the data section of the NVM access request with a copy of the NVM
+ * features structure.
+ */
+static enum ice_status
+ice_nvm_access_get_features(struct ice_nvm_access_cmd *cmd,
+			    union ice_nvm_access_data *data)
+{
+	/* The provided data_size must be at least as large as our NVM
+	 * features structure. A larger size should not be treated as an
+	 * error, to allow future extensions to to the features structure to
+	 * work on older drivers.
+	 */
+	if (cmd->data_size < sizeof(struct ice_nvm_features))
+		return ICE_ERR_NO_MEMORY;
+
+	/* Initialize the data buffer to zeros */
+	memset(data, 0, cmd->data_size);
+
+	/* Fill in the features data */
+	data->drv_features.major = ICE_NVM_ACCESS_MAJOR_VER;
+	data->drv_features.minor = ICE_NVM_ACCESS_MINOR_VER;
+	data->drv_features.size = sizeof(struct ice_nvm_features);
+	data->drv_features.features[0] = ICE_NVM_FEATURES_0_REG_ACCESS;
+
+	return 0;
+}
+
+/**
+ * ice_nvm_access_get_module - Helper function to read module value
+ * @cmd: NVM access command structure
+ *
+ * Reads the module value out of the NVM access config field.
+ */
+static u32 ice_nvm_access_get_module(struct ice_nvm_access_cmd *cmd)
+{
+	return ((cmd->config & ICE_NVM_CFG_MODULE_M) >> ICE_NVM_CFG_MODULE_S);
+}
+
+/**
+ * ice_nvm_access_get_flags - Helper function to read flags value
+ * @cmd: NVM access command structure
+ *
+ * Reads the flags value out of the NVM access config field.
+ */
+static u32 ice_nvm_access_get_flags(struct ice_nvm_access_cmd *cmd)
+{
+	return ((cmd->config & ICE_NVM_CFG_FLAGS_M) >> ICE_NVM_CFG_FLAGS_S);
+}
+
+/**
+ * ice_nvm_access_get_adapter - Helper function to read adapter info
+ * @cmd: NVM access command structure
+ *
+ * Read the adapter info value out of the NVM access config field.
+ */
+static u32 ice_nvm_access_get_adapter(struct ice_nvm_access_cmd *cmd)
+{
+	return ((cmd->config & ICE_NVM_CFG_ADAPTER_INFO_M) >>
+		ICE_NVM_CFG_ADAPTER_INFO_S);
+}
+
+/**
+ * ice_validate_nvm_rw_reg - Check than an NVM access request is valid
+ * @cmd: NVM access command structure
+ *
+ * Validates that an NVM access structure is request to read or write a valid
+ * register offset. First validates that the module and flags are correct, and
+ * then ensures that the register offset is one of the accepted registers.
+ */
+static enum ice_status
+ice_validate_nvm_rw_reg(struct ice_nvm_access_cmd *cmd)
+{
+	u32 module, flags, offset;
+	u16 i;
+
+	module = ice_nvm_access_get_module(cmd);
+	flags = ice_nvm_access_get_flags(cmd);
+	offset = cmd->offset;
+
+	/* Make sure the module and flags indicate a read/write request */
+	if (module != ICE_NVM_REG_RW_MODULE ||
+	    flags != ICE_NVM_REG_RW_FLAGS ||
+	    cmd->data_size != FIELD_SIZEOF(union ice_nvm_access_data, regval))
+		return ICE_ERR_PARAM;
+
+	switch (offset) {
+	case GL_HICR:
+	case GL_HICR_EN: /* Note, this register is read only */
+	case GL_FWSTS:
+	case GL_MNG_FWSM:
+	case GLGEN_CSR_DEBUG_C:
+	case GLGEN_RSTAT:
+	case GLPCI_LBARCTRL:
+	case GLNVM_GENS:
+	case GLNVM_FLA:
+	case PF_FUNC_RID:
+		return 0;
+	default:
+		break;
+	}
+
+	for (i = 0; i <= ICE_NVM_ACCESS_GL_HIDA_MAX; i++)
+		if (offset == (u32)GL_HIDA(i))
+			return 0;
+
+	for (i = 0; i <= ICE_NVM_ACCESS_GL_HIBA_MAX; i++)
+		if (offset == (u32)GL_HIBA(i))
+			return 0;
+
+	/* All other register offsets are not valid */
+	return ICE_ERR_OUT_OF_RANGE;
+}
+
+/**
+ * ice_nvm_access_read - Handle an NVM read request
+ * @hw: pointer to the HW struct
+ * @cmd: NVM access command to process
+ * @data: storage for the register value read
+ *
+ * Process an NVM access request to read a register.
+ */
+static enum ice_status
+ice_nvm_access_read(struct ice_hw *hw, struct ice_nvm_access_cmd *cmd,
+		    union ice_nvm_access_data *data)
+{
+	enum ice_status status;
+
+	/* Always initialize the output data, even on failure */
+	memset(data, 0, cmd->data_size);
+
+	/* Make sure this is a valid read/write access request */
+	status = ice_validate_nvm_rw_reg(cmd);
+	if (status)
+		return status;
+
+	ice_debug(hw, ICE_DBG_NVM, "NVM access: reading register %08x\n",
+		  cmd->offset);
+
+	/* Read the register and store the contents in the data field */
+	data->regval = rd32(hw, cmd->offset);
+
+	return 0;
+}
+
+/**
+ * ice_nvm_access_write - Handle an NVM write request
+ * @hw: pointer to the HW struct
+ * @cmd: NVM access command to process
+ * @data: NVM access data to write
+ *
+ * Process an NVM access request to write a register.
+ */
+static enum ice_status
+ice_nvm_access_write(struct ice_hw *hw, struct ice_nvm_access_cmd *cmd,
+		     union ice_nvm_access_data *data)
+{
+	enum ice_status status;
+
+	/* Make sure this is a valid read/write access request */
+	status = ice_validate_nvm_rw_reg(cmd);
+	if (status)
+		return status;
+
+	/* Reject requests to write to read-only registers */
+	switch (cmd->offset) {
+	case GL_HICR_EN:
+	case GLGEN_RSTAT:
+		return ICE_ERR_OUT_OF_RANGE;
+	default:
+		break;
+	}
+
+	ice_debug(hw, ICE_DBG_NVM,
+		  "NVM access: writing register %08x with value %08x\n",
+		  cmd->offset, data->regval);
+
+	/* Write the data field to the specified register */
+	wr32(hw, cmd->offset, data->regval);
+
+	return 0;
+}
+
+/**
+ * ice_handle_nvm_access - Handle an NVM access request
+ * @hw: pointer to the HW struct
+ * @cmd: NVM access command info
+ * @data: pointer to read or return data
+ *
+ * Process an NVM access request. Read the command structure information and
+ * determine if it is valid. If not, report an error indicating the command
+ * was invalid.
+ *
+ * For valid commands, perform the necessary function, copying the data into
+ * the provided data buffer.
+ */
+enum ice_status
+ice_handle_nvm_access(struct ice_hw *hw, struct ice_nvm_access_cmd *cmd,
+		      union ice_nvm_access_data *data)
+{
+	u32 module, flags, adapter_info;
+
+	/* Extended flags are currently reserved and must be zero */
+	if ((cmd->config & ICE_NVM_CFG_EXT_FLAGS_M) != 0)
+		return ICE_ERR_PARAM;
+
+	/* Adapter info must match the HW device ID */
+	adapter_info = ice_nvm_access_get_adapter(cmd);
+	if (adapter_info != hw->device_id)
+		return ICE_ERR_PARAM;
+
+	switch (cmd->command) {
+	case ICE_NVM_CMD_READ:
+		module = ice_nvm_access_get_module(cmd);
+		flags = ice_nvm_access_get_flags(cmd);
+
+		/* Getting the driver's NVM features structure shares the same
+		 * command type as reading a register. Read the config field
+		 * to determine if this is a request to get features.
+		 */
+		if (module == ICE_NVM_GET_FEATURES_MODULE &&
+		    flags == ICE_NVM_GET_FEATURES_FLAGS &&
+		    cmd->offset == 0)
+			return ice_nvm_access_get_features(cmd, data);
+		else
+			return ice_nvm_access_read(hw, cmd, data);
+	case ICE_NVM_CMD_WRITE:
+		return ice_nvm_access_write(hw, cmd, data);
+	default:
+		return ICE_ERR_PARAM;
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
new file mode 100644
index 000000000000..75d167b7ebe3
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_NVM_H_
+#define _ICE_NVM_H_
+
+#define ICE_NVM_CMD_READ		0x0000000B
+#define ICE_NVM_CMD_WRITE		0x0000000C
+
+/* NVM Access config bits */
+#define ICE_NVM_CFG_MODULE_M		ICE_M(0xFF, 0)
+#define ICE_NVM_CFG_MODULE_S		0
+#define ICE_NVM_CFG_FLAGS_M		ICE_M(0xF, 8)
+#define ICE_NVM_CFG_FLAGS_S		8
+#define ICE_NVM_CFG_EXT_FLAGS_M		ICE_M(0xF, 12)
+#define ICE_NVM_CFG_ADAPTER_INFO_M	ICE_M(0xFFFF, 16)
+#define ICE_NVM_CFG_ADAPTER_INFO_S	16
+
+/* NVM Read Get Driver Features */
+#define ICE_NVM_GET_FEATURES_MODULE	0xE
+#define ICE_NVM_GET_FEATURES_FLAGS	0xF
+
+/* NVM Read/Write Mapped Space */
+#define ICE_NVM_REG_RW_MODULE	0x0
+#define ICE_NVM_REG_RW_FLAGS	0x1
+
+#define ICE_NVM_ACCESS_MAJOR_VER	0
+#define ICE_NVM_ACCESS_MINOR_VER	5
+
+/* NVM Access feature flags. Other bits in the features field are reserved and
+ * should be set to zero when reporting the ice_nvm_features structure.
+ */
+#define ICE_NVM_FEATURES_0_REG_ACCESS	BIT(1)
+
+/* NVM Access Features */
+struct ice_nvm_features {
+	u8 major;		/* Major version (informational only) */
+	u8 minor;		/* Minor version (informational only) */
+	u16 size;		/* size of ice_nvm_features structure */
+	u8 features[12];	/* Array of feature bits */
+};
+
+/* NVM Access command */
+struct ice_nvm_access_cmd {
+	u32 command;		/* NVM command: READ or WRITE */
+	u32 config;		/* NVM command configuration */
+	u32 offset;		/* offset to read/write, in bytes */
+	u32 data_size;		/* size of data field, in bytes */
+};
+
+/* NVM Access data */
+union ice_nvm_access_data {
+	u32 regval;	/* Storage for register value */
+	struct ice_nvm_features drv_features; /* NVM features */
+};
+
+/* NVM Access registers */
+#define GL_HIDA(_i)			(0x00082000 + ((_i) * 4))
+#define GL_HIBA(_i)			(0x00081000 + ((_i) * 4))
+#define GL_HICR				0x00082040
+#define GL_HICR_EN			0x00082044
+#define GLGEN_CSR_DEBUG_C		0x00075750
+#define GLPCI_LBARCTRL			0x0009DE74
+
+#define ICE_NVM_ACCESS_GL_HIDA_MAX	15
+#define ICE_NVM_ACCESS_GL_HIBA_MAX	1023
+
+enum ice_status
+ice_handle_nvm_access(struct ice_hw *hw, struct ice_nvm_access_cmd *cmd,
+		      union ice_nvm_access_data *data);
+enum ice_status
+ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access);
+void ice_release_nvm(struct ice_hw *hw);
+enum ice_status
+ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
+		void *data, bool last_command, bool read_shadow_ram,
+		struct ice_sq_cd *cd);
+enum ice_status ice_init_nvm(struct ice_hw *hw);
+#endif /* _ICE_NVM_H_ */
-- 
2.21.0

