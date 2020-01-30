Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF314E5D2
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgA3W7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:51510 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187789"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:22 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 07/15] ice: implement full NVM read from ETHTOOL_GEEPROM
Date:   Thu, 30 Jan 2020 14:59:02 -0800
Message-Id: <20200130225913.1671982-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The current implementation of .get_eeprom only enables reading from the
Shadow RAM portion of the NVM contents. Implement support for reading
the entire flash contents instead of only the initial portion contained
in the Shadow RAM.

A complete dump can take several seconds, but the ETHTOOL_GEEPROM ioctl
is capable of reading only a limited portion at a time by specifying the
offset and length to read.

In order to perform the reads directly, several functions are made non
static. Additionally, the unused ice_read_sr_buf_aq and ice_read_sr_buf
functions are removed.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.h   |   3 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  36 +++--
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 150 +-----------------
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   4 +
 5 files changed, 31 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 2240f226568f..0370e5835b2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1757,6 +1757,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_ENOMEM	= 9,  /* Out of memory */
 	ICE_AQ_RC_EBUSY		= 12, /* Device or resource busy */
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
+	ICE_AQ_RC_EINVAL	= 14, /* Invalid argument */
 	ICE_AQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
 	ICE_AQ_RC_ENOSYS	= 17, /* Function not implemented */
 	ICE_AQ_RC_ENOSEC	= 24, /* Missing security manifest */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index b5c013fdaaf9..045913cd7428 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -38,9 +38,6 @@ enum ice_status
 ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res);
 enum ice_status
 ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res);
-enum ice_status ice_init_nvm(struct ice_hw *hw);
-enum ice_status
-ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data);
 enum ice_status
 ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
 		      struct ice_aqc_alloc_free_res_elem *buf, u16 buf_size,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 90c6a3ca20c9..c3ddaab25313 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -240,39 +240,51 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
 	       u8 *bytes)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	u16 first_word, last_word, nwords;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	struct device *dev;
 	int ret = 0;
-	u16 *buf;
+	u8 *buf;
 
 	dev = ice_pf_to_dev(pf);
 
 	eeprom->magic = hw->vendor_id | (hw->device_id << 16);
+	netdev_dbg(netdev, "GEEPROM cmd 0x%08x, offset 0x%08x, len 0x%08x\n",
+		   eeprom->cmd, eeprom->offset, eeprom->len);
 
-	first_word = eeprom->offset >> 1;
-	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
-	nwords = last_word - first_word + 1;
-
-	buf = devm_kcalloc(dev, nwords, sizeof(u16), GFP_KERNEL);
+	buf = kzalloc(eeprom->len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	status = ice_read_sr_buf(hw, first_word, &nwords, buf);
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
 	if (status) {
-		dev_err(dev, "ice_read_sr_buf failed, err %d aq_err %d\n",
+		dev_err(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
 			status, hw->adminq.sq_last_status);
-		eeprom->len = sizeof(u16) * nwords;
 		ret = -EIO;
 		goto out;
 	}
 
-	memcpy(bytes, (u8 *)buf + (eeprom->offset & 1), eeprom->len);
+	status = ice_read_flat_nvm(hw, eeprom->offset, &eeprom->len, buf, false);
+	if (status == ICE_ERR_AQ_ERROR &&
+	    hw->adminq.sq_last_status == ICE_AQ_RC_EINVAL) {
+		/* do nothing, we reached the end */
+		ice_release_nvm(hw);
+		goto out;
+	} else if (status) {
+		dev_err(dev, "ice_read_flat_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		ret = -EIO;
+		ice_release_nvm(hw);
+		goto out;
+	}
+
+	ice_release_nvm(hw);
+
+	memcpy(bytes, buf, eeprom->len);
 out:
-	devm_kfree(dev, buf);
+	kfree(buf);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 622431aa1e22..ff9ccb17be25 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -108,70 +108,6 @@ ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 	return status;
 }
 
-/**
- * ice_check_sr_access_params - verify params for Shadow RAM R/W operations.
- * @hw: pointer to the HW structure
- * @offset: offset in words from module start
- * @words: number of words to access
- */
-static enum ice_status
-ice_check_sr_access_params(struct ice_hw *hw, u32 offset, u16 words)
-{
-	if ((offset + words) > hw->nvm.sr_words) {
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM error: offset beyond SR lmt.\n");
-		return ICE_ERR_PARAM;
-	}
-
-	if (words > ICE_SR_SECTOR_SIZE_IN_WORDS) {
-		/* We can access only up to 4KB (one sector), in one AQ write */
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM error: tried to access %d words, limit is %d.\n",
-			  words, ICE_SR_SECTOR_SIZE_IN_WORDS);
-		return ICE_ERR_PARAM;
-	}
-
-	if (((offset + (words - 1)) / ICE_SR_SECTOR_SIZE_IN_WORDS) !=
-	    (offset / ICE_SR_SECTOR_SIZE_IN_WORDS)) {
-		/* A single access cannot spread over two sectors */
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM error: cannot spread over two sectors.\n");
-		return ICE_ERR_PARAM;
-	}
-
-	return 0;
-}
-
-/**
- * ice_read_sr_aq - Read Shadow RAM.
- * @hw: pointer to the HW structure
- * @offset: offset in words from module start
- * @words: number of words to read
- * @data: storage for the words read from Shadow RAM (Little Endian)
- * @last_command: tells the AdminQ that this is the last command
- *
- * Reads 16-bit Little Endian word buffers from the Shadow RAM using the admin
- * command.
- */
-static enum ice_status
-ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, __le16 *data,
-	       bool last_command)
-{
-	enum ice_status status;
-
-	status = ice_check_sr_access_params(hw, offset, words);
-
-	/* values in "offset" and "words" parameters are sized as words
-	 * (16 bits) but ice_aq_read_nvm expects these values in bytes.
-	 * So do this conversion while calling ice_aq_read_nvm.
-	 */
-	if (!status)
-		status = ice_aq_read_nvm(hw, 0, 2 * offset, 2 * words, data,
-					 last_command, true, NULL);
-
-	return status;
-}
-
 /**
  * ice_read_sr_word_aq - Reads Shadow RAM via AQ
  * @hw: pointer to the HW structure
@@ -199,63 +135,6 @@ ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 	return 0;
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
@@ -263,7 +142,7 @@ ice_read_sr_buf_aq(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
  *
  * This function will request NVM ownership.
  */
-static enum ice_status
+enum ice_status
 ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access)
 {
 	if (hw->nvm.blank_nvm_mode)
@@ -278,7 +157,7 @@ ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access)
  *
  * This function will release NVM ownership.
  */
-static void ice_release_nvm(struct ice_hw *hw)
+void ice_release_nvm(struct ice_hw *hw)
 {
 	if (hw->nvm.blank_nvm_mode)
 		return;
@@ -412,31 +291,6 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 	return 0;
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
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 4245ef988edf..7375f6b96919 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -4,8 +4,12 @@
 #ifndef _ICE_NVM_H_
 #define _ICE_NVM_H_
 
+enum ice_status
+ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access);
+void ice_release_nvm(struct ice_hw *hw);
 enum ice_status
 ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 		  bool read_shadow_ram);
+enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
 #endif /* _ICE_NVM_H_ */
-- 
2.25.0.rc1

