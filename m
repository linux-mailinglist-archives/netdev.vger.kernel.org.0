Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B714522A4E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiEKDT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiEKDT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:27 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4476B7FA
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:22 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239152tn88knan
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:11 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: lz+CLQuFFPx/vrz9hPQFcHDGHmxOCC2anikSVbwjti+kaAacJ1cNmY52h92a+
        svtxioO1cbJYIGVp5VRrXB6GVwti/rvJa9kkfrPgZt3cpJEEgi5p1nxijKej0iPsKY4a+Wf
        m2pvAEpyLk00KVkN1uroHHr3Ay5YjbyU6E2m85oluR/rmlI5OhGiQFgNmMsjqlwefIs8Bc3
        ybMVDFNzHzYxBEBnilZSrXfHkKIvgOWrfPR+zkkcYN4DAfoT2uGNnufr5A7qDbArJBhdTqO
        w46DgW1PPR43JS7Gw8+HfdW2NLQl54AHYCLwnMORl3jFr4/7SZaEYPrp0Q6VxUemhklTU8z
        VvqCLNGTaayVhyQXAdrrW6slKnZsbtVcW7BdFWF
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 03/14] net: txgbe: Add operations to interact with firmware
Date:   Wed, 11 May 2022 11:26:48 +0800
Message-Id: <20220511032659.641834-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add firmware interaction to get EEPROM information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   13 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1024 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   26 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   59 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  113 ++
 5 files changed, 1226 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 48e6f69857ad..4c5de310292f 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -38,6 +38,11 @@ struct txgbe_mac_addr {
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
+/**
+ * txgbe_adapter.flag2
+ **/
+#define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     (1U << 0)
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	/* OS defined structs */
@@ -73,6 +78,7 @@ struct txgbe_adapter {
 
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
 
+	char eeprom_id[32];
 	bool netdev_registered;
 
 	struct txgbe_mac_addr *mac_table;
@@ -133,6 +139,13 @@ static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
 	/* skip the flush */
 }
 
+#define TXGBE_CPU_TO_BE16(_x) cpu_to_be16(_x)
+#define TXGBE_BE16_TO_CPU(_x) be16_to_cpu(_x)
+#define TXGBE_CPU_TO_BE32(_x) cpu_to_be32(_x)
+#define TXGBE_BE32_TO_CPU(_x) be32_to_cpu(_x)
+#define TXGBE_CPU_TO_LE32(_i) cpu_to_le32(_i)
+#define TXGBE_LE32_TO_CPUS(_i) le32_to_cpus(_i)
+
 #define msec_delay(_x) msleep(_x)
 #define usec_delay(_x) udelay(_x)
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index e4ebaf007da9..9865ae301133 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -9,6 +9,9 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 
+static s32 txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
+static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw);
+
 s32 txgbe_init_hw(struct txgbe_hw *hw)
 {
 	s32 status;
@@ -24,6 +27,118 @@ s32 txgbe_init_hw(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_read_pba_string - Reads part number string from EEPROM
+ *  @hw: pointer to hardware structure
+ *  @pba_num: stores the part number string from the EEPROM
+ *  @pba_num_size: part number string buffer length
+ *
+ *  Reads the part number string from the EEPROM.
+ **/
+s32 txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
+			  u32 pba_num_size)
+{
+	s32 ret_val;
+	u16 data;
+	u16 pba_ptr;
+	u16 offset;
+	u16 length;
+
+	if (!pba_num) {
+		DEBUGOUT("PBA string buffer was null\n");
+		return TXGBE_ERR_INVALID_ARGUMENT;
+	}
+
+	ret_val = TCALL(hw, eeprom.ops.read,
+			hw->eeprom.sw_region_offset + TXGBE_PBANUM0_PTR,
+			&data);
+	if (ret_val) {
+		DEBUGOUT("NVM Read Error\n");
+		return ret_val;
+	}
+
+	ret_val = TCALL(hw, eeprom.ops.read,
+			hw->eeprom.sw_region_offset + TXGBE_PBANUM1_PTR,
+			&pba_ptr);
+	if (ret_val) {
+		DEBUGOUT("NVM Read Error\n");
+		return ret_val;
+	}
+
+	/* if data is not ptr guard the PBA must be in legacy format which
+	 * means pba_ptr is actually our second data word for the PBA number
+	 * and we can decode it into an ascii string
+	 */
+	if (data != TXGBE_PBANUM_PTR_GUARD) {
+		DEBUGOUT("NVM PBA number is not stored as string\n");
+
+		/* we will need 11 characters to store the PBA */
+		if (pba_num_size < 11) {
+			DEBUGOUT("PBA string buffer too small\n");
+			return TXGBE_ERR_NO_SPACE;
+		}
+
+		/* extract hex string from data and pba_ptr */
+		pba_num[0] = (data >> 12) & 0xF;
+		pba_num[1] = (data >> 8) & 0xF;
+		pba_num[2] = (data >> 4) & 0xF;
+		pba_num[3] = data & 0xF;
+		pba_num[4] = (pba_ptr >> 12) & 0xF;
+		pba_num[5] = (pba_ptr >> 8) & 0xF;
+		pba_num[6] = '-';
+		pba_num[7] = 0;
+		pba_num[8] = (pba_ptr >> 4) & 0xF;
+		pba_num[9] = pba_ptr & 0xF;
+
+		/* put a null character on the end of our string */
+		pba_num[10] = '\0';
+
+		/* switch all the data but the '-' to hex char */
+		for (offset = 0; offset < 10; offset++) {
+			if (pba_num[offset] < 0xA)
+				pba_num[offset] += '0';
+			else if (pba_num[offset] < 0x10)
+				pba_num[offset] += 'A' - 0xA;
+		}
+
+		return 0;
+	}
+
+	ret_val = TCALL(hw, eeprom.ops.read, pba_ptr, &length);
+	if (ret_val) {
+		DEBUGOUT("NVM Read Error\n");
+		return ret_val;
+	}
+
+	if (length == 0xFFFF || length == 0) {
+		DEBUGOUT("NVM PBA number section invalid length\n");
+		return TXGBE_ERR_PBA_SECTION;
+	}
+
+	/* check if pba_num buffer is big enough */
+	if (pba_num_size  < (((u32)length * 2) - 1)) {
+		DEBUGOUT("PBA string buffer too small\n");
+		return TXGBE_ERR_NO_SPACE;
+	}
+
+	/* trim pba length from start of string */
+	pba_ptr++;
+	length--;
+
+	for (offset = 0; offset < length; offset++) {
+		ret_val = TCALL(hw, eeprom.ops.read, pba_ptr + offset, &data);
+		if (ret_val) {
+			DEBUGOUT("NVM Read Error\n");
+			return ret_val;
+		}
+		pba_num[offset * 2] = (u8)(data >> 8);
+		pba_num[(offset * 2) + 1] = (u8)(data & 0xFF);
+	}
+	pba_num[offset * 2] = '\0';
+
+	return 0;
+}
+
 /**
  *  txgbe_get_mac_addr - Generic get MAC address
  *  @hw: pointer to hardware structure
@@ -190,6 +305,102 @@ s32 txgbe_stop_adapter(struct txgbe_hw *hw)
 	return txgbe_disable_pcie_master(hw);
 }
 
+/**
+ *  txgbe_get_eeprom_semaphore - Get hardware semaphore
+ *  @hw: pointer to hardware structure
+ *
+ *  Sets the hardware semaphores so EEPROM access can occur for bit-bang method
+ **/
+static s32 txgbe_get_eeprom_semaphore(struct txgbe_hw *hw)
+{
+	s32 status = TXGBE_ERR_EEPROM;
+	u32 timeout = 2000;
+	u32 i;
+	u32 swsm;
+
+	/* Get SMBI software semaphore between device drivers first */
+	for (i = 0; i < timeout; i++) {
+		/* If the SMBI bit is 0 when we read it, then the bit will be
+		 * set and we have the semaphore
+		 */
+		swsm = rd32(hw, TXGBE_MIS_SWSM);
+		if (!(swsm & TXGBE_MIS_SWSM_SMBI)) {
+			status = 0;
+			break;
+		}
+		usec_delay(50);
+	}
+
+	if (i == timeout) {
+		DEBUGOUT("Driver can't access the Eeprom - SMBI Semaphore not granted.\n");
+
+		/* this release is particularly important because our attempts
+		 * above to get the semaphore may have succeeded, and if there
+		 * was a timeout, we should unconditionally clear the semaphore
+		 * bits to free the driver to make progress
+		 */
+		txgbe_release_eeprom_semaphore(hw);
+
+		usec_delay(50);
+		/* one last try
+		 * If the SMBI bit is 0 when we read it, then the bit will be
+		 * set and we have the semaphore
+		 */
+		swsm = rd32(hw, TXGBE_MIS_SWSM);
+		if (!(swsm & TXGBE_MIS_SWSM_SMBI))
+			status = 0;
+	}
+
+	/* Now get the semaphore between SW/FW through the SWESMBI bit */
+	if (status == 0) {
+		for (i = 0; i < timeout; i++) {
+			if (txgbe_check_mng_access(hw)) {
+			/* Set the SW EEPROM semaphore bit to request access */
+				wr32m(hw, TXGBE_MNG_SW_SM,
+				      TXGBE_MNG_SW_SM_SM, TXGBE_MNG_SW_SM_SM);
+
+				/* If we set the bit successfully then we got
+				 * semaphore.
+				 */
+				swsm = rd32(hw, TXGBE_MNG_SW_SM);
+				if (swsm & TXGBE_MNG_SW_SM_SM)
+					break;
+			}
+			usec_delay(50);
+		}
+
+		/* Release semaphores and return error if SW EEPROM semaphore
+		 * was not granted because we don't have access to the EEPROM
+		 */
+		if (i >= timeout) {
+			ERROR_REPORT1(TXGBE_ERROR_POLLING,
+				      "SWESMBI Software EEPROM semaphore not granted.\n");
+			txgbe_release_eeprom_semaphore(hw);
+			status = TXGBE_ERR_EEPROM;
+		}
+	} else {
+		ERROR_REPORT1(TXGBE_ERROR_POLLING,
+			      "Software semaphore SMBI between device drivers not granted.\n");
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_release_eeprom_semaphore - Release hardware semaphore
+ *  @hw: pointer to hardware structure
+ *
+ *  This function clears hardware semaphore bits.
+ **/
+static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw)
+{
+	if (txgbe_check_mng_access(hw)) {
+		wr32m(hw, TXGBE_MNG_SW_SM, TXGBE_MNG_SW_SM_SM, 0);
+		wr32m(hw, TXGBE_MIS_SWSM, TXGBE_MIS_SWSM_SMBI, 0);
+		TXGBE_WRITE_FLUSH(hw);
+	}
+}
+
 /**
  *  txgbe_set_rar - Set Rx address register
  *  @hw: pointer to hardware structure
@@ -386,17 +597,137 @@ s32 txgbe_disable_pcie_master(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_acquire_swfw_sync - Acquire SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to acquire
+ *
+ *  Acquires the SWFW semaphore through the GSSR register for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+s32 txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask)
+{
+	u32 gssr = 0;
+	u32 swmask = mask;
+	u32 fwmask = mask << 16;
+	u32 timeout = 200;
+	u32 i;
+
+	for (i = 0; i < timeout; i++) {
+		/* SW NVM semaphore bit is used for access to all
+		 * SW_FW_SYNC bits (not just NVM)
+		 */
+		if (txgbe_get_eeprom_semaphore(hw))
+			return TXGBE_ERR_SWFW_SYNC;
+
+		if (txgbe_check_mng_access(hw)) {
+			gssr = rd32(hw, TXGBE_MNG_SWFW_SYNC);
+			if (gssr & (fwmask | swmask)) {
+				/* Resource is currently in use by FW or SW */
+				txgbe_release_eeprom_semaphore(hw);
+				msec_delay(5);
+			} else {
+				gssr |= swmask;
+				wr32(hw, TXGBE_MNG_SWFW_SYNC, gssr);
+				txgbe_release_eeprom_semaphore(hw);
+				return 0;
+			}
+		}
+	}
+
+	/* If time expired clear the bits holding the lock and retry */
+	if (gssr & (fwmask | swmask))
+		txgbe_release_swfw_sync(hw, gssr & (fwmask | swmask));
+
+	msec_delay(5);
+	return TXGBE_ERR_SWFW_SYNC;
+}
+
+/**
+ *  txgbe_release_swfw_sync - Release SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to release
+ *
+ *  Releases the SWFW semaphore through the GSSR register for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask)
+{
+	txgbe_get_eeprom_semaphore(hw);
+	if (txgbe_check_mng_access(hw))
+		wr32m(hw, TXGBE_MNG_SWFW_SYNC, mask, 0);
+
+	txgbe_release_eeprom_semaphore(hw);
+}
+
+/**
+ *  txgbe_get_san_mac_addr_offset - Get SAN MAC address offset from the EEPROM
+ *  @hw: pointer to hardware structure
+ *  @san_mac_offset: SAN MAC address offset
+ *
+ *  This function will read the EEPROM location for the SAN MAC address
+ *  pointer, and returns the value at that location.  This is used in both
+ *  get and set mac_addr routines.
+ **/
+static s32 txgbe_get_san_mac_addr_offset(struct txgbe_hw *hw,
+					 u16 *san_mac_offset)
+{
+	s32 ret_val;
+
+	/* First read the EEPROM pointer to see if the MAC addresses are
+	 * available.
+	 */
+	ret_val = TCALL(hw, eeprom.ops.read,
+			hw->eeprom.sw_region_offset + TXGBE_SAN_MAC_ADDR_PTR,
+			san_mac_offset);
+	if (ret_val) {
+		ERROR_REPORT2(TXGBE_ERROR_INVALID_STATE,
+			      "eeprom at offset %d failed",
+			      TXGBE_SAN_MAC_ADDR_PTR);
+	}
+
+	return ret_val;
+}
+
 /**
  *  txgbe_get_san_mac_addr - SAN MAC address retrieval from the EEPROM
  *  @hw: pointer to hardware structure
  *  @san_mac_addr: SAN MAC address
  *
- *  Reads the SAN MAC address.
+ *  Reads the SAN MAC address from the EEPROM.
  **/
 s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr)
 {
+	u16 san_mac_data, san_mac_offset;
 	u8 i;
+	s32 ret_val;
+
+	/* First read the EEPROM pointer to see if the MAC addresses are
+	 * available.  If they're not, no point in calling set_lan_id() here.
+	 */
+	ret_val = txgbe_get_san_mac_addr_offset(hw, &san_mac_offset);
+	if (ret_val || san_mac_offset == 0 || san_mac_offset == 0xFFFF)
+		goto san_mac_addr_out;
+
+	/* apply the port offset to the address offset */
+	(hw->bus.func) ? (san_mac_offset += TXGBE_SAN_MAC_ADDR_PORT1_OFFSET) :
+			 (san_mac_offset += TXGBE_SAN_MAC_ADDR_PORT0_OFFSET);
+	for (i = 0; i < 3; i++) {
+		ret_val = TCALL(hw, eeprom.ops.read, san_mac_offset,
+				&san_mac_data);
+		if (ret_val) {
+			ERROR_REPORT2(TXGBE_ERROR_INVALID_STATE,
+				      "eeprom read at offset %d failed",
+				      san_mac_offset);
+			goto san_mac_addr_out;
+		}
+		san_mac_addr[i * 2] = (u8)(san_mac_data);
+		san_mac_addr[i * 2 + 1] = (u8)(san_mac_data >> 8);
+		san_mac_offset++;
+	}
+	return 0;
 
+san_mac_addr_out:
 	/* No addresses available in this EEPROM.  It's not an
 	 * error though, so just wipe the local address and return.
 	 */
@@ -482,6 +813,324 @@ s32 txgbe_init_uta_tables(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ *  Get alternative WWNN/WWPN prefix from the EEPROM
+ *  @hw: pointer to hardware structure
+ *  @wwnn_prefix: the alternative WWNN prefix
+ *  @wwpn_prefix: the alternative WWPN prefix
+ *
+ *  This function will read the EEPROM from the alternative SAN MAC address
+ *  block to check the support for the alternative WWNN/WWPN prefix support.
+ **/
+s32 txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			 u16 *wwpn_prefix)
+{
+	u16 offset, caps;
+	u16 alt_san_mac_blk_offset;
+
+	/* clear output first */
+	*wwnn_prefix = 0xFFFF;
+	*wwpn_prefix = 0xFFFF;
+
+	/* check if alternative SAN MAC is supported */
+	offset = hw->eeprom.sw_region_offset + TXGBE_ALT_SAN_MAC_ADDR_BLK_PTR;
+	if (TCALL(hw, eeprom.ops.read, offset, &alt_san_mac_blk_offset))
+		goto wwn_prefix_err;
+
+	if (alt_san_mac_blk_offset == 0 ||
+	    alt_san_mac_blk_offset == 0xFFFF)
+		goto wwn_prefix_out;
+
+	/* check capability in alternative san mac address block */
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_CAPS_OFFSET;
+	if (TCALL(hw, eeprom.ops.read, offset, &caps))
+		goto wwn_prefix_err;
+	if (!(caps & TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN))
+		goto wwn_prefix_out;
+
+	/* get the corresponding prefix for WWNN/WWPN */
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_WWNN_OFFSET;
+	if (TCALL(hw, eeprom.ops.read, offset, wwnn_prefix)) {
+		ERROR_REPORT2(TXGBE_ERROR_INVALID_STATE,
+			      "eeprom read at offset %d failed", offset);
+	}
+
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_WWPN_OFFSET;
+	if (TCALL(hw, eeprom.ops.read, offset, wwpn_prefix))
+		goto wwn_prefix_err;
+
+wwn_prefix_err:
+	ERROR_REPORT2(TXGBE_ERROR_INVALID_STATE,
+		      "eeprom read at offset %d failed", offset);
+wwn_prefix_out:
+	return 0;
+}
+
+/**
+ *  txgbe_calculate_checksum - Calculate checksum for buffer
+ *  @buffer: pointer to EEPROM
+ *  @length: size of EEPROM to calculate a checksum for
+ *  Calculates the checksum for some buffer on a specified length.  The
+ *  checksum calculated is returned.
+ **/
+u8 txgbe_calculate_checksum(u8 *buffer, u32 length)
+{
+	u32 i;
+	u8 sum = 0;
+
+	if (!buffer)
+		return 0;
+
+	for (i = 0; i < length; i++)
+		sum += buffer[i];
+
+	return (u8)(0 - sum);
+}
+
+/**
+ *  txgbe_host_interface_command - Issue command to manageability block
+ *  @hw: pointer to the HW structure
+ *  @buffer: contains the command to write and where the return status will
+ *   be placed
+ *  @length: length of buffer, must be multiple of 4 bytes
+ *  @timeout: time in ms to wait for command completion
+ *  @return_data: read and return data from the buffer (true) or not (false)
+ *   Needed because FW structures are big endian and decoding of
+ *   these fields can be 8 bit or 16 bit based on command. Decoding
+ *   is not easily understood without making a table of commands.
+ *   So we will leave this up to the caller to read back the data
+ *   in these cases.
+ *
+ *  Communicates with the manageability block.  On success return 0
+ *  else return TXGBE_ERR_HOST_INTERFACE_COMMAND.
+ **/
+s32 txgbe_host_interface_command(struct txgbe_hw *hw, u32 *buffer,
+				 u32 length, u32 timeout, bool return_data)
+{
+	u32 hicr, i, bi;
+	u32 hdr_size = sizeof(struct txgbe_hic_hdr);
+	u16 buf_len;
+	u32 dword_len;
+	s32 status = 0;
+	u32 buf[64] = {};
+
+	if (length == 0 || length > TXGBE_HI_MAX_BLOCK_BYTE_LENGTH) {
+		DEBUGOUT1("Buffer length failure buffersize=%d.\n", length);
+		return TXGBE_ERR_HOST_INTERFACE_COMMAND;
+	}
+
+	if (TCALL(hw, mac.ops.acquire_swfw_sync, TXGBE_MNG_SWFW_SYNC_SW_MB) != 0)
+		return TXGBE_ERR_SWFW_SYNC;
+
+	/* Calculate length in DWORDs. We must be DWORD aligned */
+	if ((length % (sizeof(u32))) != 0) {
+		DEBUGOUT("Buffer length failure, not aligned to dword");
+		status = TXGBE_ERR_INVALID_ARGUMENT;
+		goto rel_out;
+	}
+
+	dword_len = length >> 2;
+
+	/* The device driver writes the relevant command block
+	 * into the ram area.
+	 */
+	for (i = 0; i < dword_len; i++) {
+		if (txgbe_check_mng_access(hw)) {
+			wr32a(hw, TXGBE_MNG_MBOX, i, TXGBE_CPU_TO_LE32(buffer[i]));
+			/* write flush */
+			buf[i] = rd32a(hw, TXGBE_MNG_MBOX, i);
+		} else {
+			status = TXGBE_ERR_MNG_ACCESS_FAILED;
+			goto rel_out;
+		}
+	}
+	/* Setting this bit tells the ARC that a new command is pending. */
+	if (txgbe_check_mng_access(hw)) {
+		wr32m(hw, TXGBE_MNG_MBOX_CTL,
+		      TXGBE_MNG_MBOX_CTL_SWRDY, TXGBE_MNG_MBOX_CTL_SWRDY);
+	} else {
+		status = TXGBE_ERR_MNG_ACCESS_FAILED;
+		goto rel_out;
+	}
+
+	for (i = 0; i < timeout; i++) {
+		if (txgbe_check_mng_access(hw)) {
+			hicr = rd32(hw, TXGBE_MNG_MBOX_CTL);
+			if ((hicr & TXGBE_MNG_MBOX_CTL_FWRDY))
+				break;
+		}
+		msec_delay(1);
+	}
+
+	buf[0] = rd32(hw, TXGBE_MNG_MBOX);
+	if ((buf[0] & 0xff0000) >> 16 == 0x80) {
+		DEBUGOUT("It's unknown cmd.\n");
+		status = TXGBE_ERR_MNG_ACCESS_FAILED;
+		goto rel_out;
+	}
+	/* Check command completion */
+	if (timeout != 0 && i == timeout) {
+		ERROR_REPORT1(TXGBE_ERROR_CAUTION,
+			      "Command has failed with no status valid.\n");
+
+		ERROR_REPORT1(TXGBE_ERROR_CAUTION, "write value:\n");
+		for (i = 0; i < dword_len; i++)
+			ERROR_REPORT1(TXGBE_ERROR_CAUTION, "%x ", buffer[i]);
+		ERROR_REPORT1(TXGBE_ERROR_CAUTION, "read value:\n");
+		for (i = 0; i < dword_len; i++)
+			ERROR_REPORT1(TXGBE_ERROR_CAUTION, "%x ", buf[i]);
+		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
+			status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+			goto rel_out;
+		}
+	}
+
+	if (!return_data)
+		goto rel_out;
+
+	/* Calculate length in DWORDs */
+	dword_len = hdr_size >> 2;
+
+	/* first pull in the header so we know the buffer length */
+	for (bi = 0; bi < dword_len; bi++) {
+		if (txgbe_check_mng_access(hw)) {
+			buffer[bi] = rd32a(hw, TXGBE_MNG_MBOX, bi);
+			TXGBE_LE32_TO_CPUS(&buffer[bi]);
+		} else {
+			status = TXGBE_ERR_MNG_ACCESS_FAILED;
+			goto rel_out;
+		}
+	}
+
+	/* If there is any thing in data position pull it in */
+	buf_len = ((struct txgbe_hic_hdr *)buffer)->buf_len;
+	if (buf_len == 0)
+		goto rel_out;
+
+	if (length < buf_len + hdr_size) {
+		DEBUGOUT("Buffer not large enough for reply message.\n");
+		status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+		goto rel_out;
+	}
+
+	/* Calculate length in DWORDs, add 3 for odd lengths */
+	dword_len = (buf_len + 3) >> 2;
+
+	/* Pull in the rest of the buffer (bi is where we left off) */
+	for (; bi <= dword_len; bi++) {
+		if (txgbe_check_mng_access(hw)) {
+			buffer[bi] = rd32a(hw, TXGBE_MNG_MBOX, bi);
+			TXGBE_LE32_TO_CPUS(&buffer[bi]);
+		} else {
+			status = TXGBE_ERR_MNG_ACCESS_FAILED;
+			goto rel_out;
+		}
+	}
+
+rel_out:
+	TCALL(hw, mac.ops.release_swfw_sync, TXGBE_MNG_SWFW_SYNC_SW_MB);
+	return status;
+}
+
+/**
+ *  txgbe_set_fw_drv_ver - Sends driver version to firmware
+ *  @hw: pointer to the HW structure
+ *  @maj: driver version major number
+ *  @min: driver version minor number
+ *  @build: driver version build number
+ *  @sub: driver version sub build number
+ *
+ *  Sends driver version number to firmware through the manageability
+ *  block.  On success return 0
+ *  else returns TXGBE_ERR_SWFW_SYNC when encountering an error acquiring
+ *  semaphore or TXGBE_ERR_HOST_INTERFACE_COMMAND when command fails.
+ **/
+s32 txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
+			 u8 build, u8 sub)
+{
+	struct txgbe_hic_drv_info fw_cmd;
+	int i;
+	s32 ret_val = 0;
+
+	fw_cmd.hdr.cmd = FW_CEM_CMD_DRIVER_INFO;
+	fw_cmd.hdr.buf_len = FW_CEM_CMD_DRIVER_INFO_LEN;
+	fw_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	fw_cmd.port_num = (u8)hw->bus.func;
+	fw_cmd.ver_maj = maj;
+	fw_cmd.ver_min = min;
+	fw_cmd.ver_build = build;
+	fw_cmd.ver_sub = sub;
+	fw_cmd.hdr.checksum = 0;
+	fw_cmd.hdr.checksum = txgbe_calculate_checksum((u8 *)&fw_cmd,
+				(FW_CEM_HDR_LEN + fw_cmd.hdr.buf_len));
+	fw_cmd.pad = 0;
+	fw_cmd.pad2 = 0;
+
+	for (i = 0; i <= FW_CEM_MAX_RETRIES; i++) {
+		ret_val = txgbe_host_interface_command(hw, (u32 *)&fw_cmd,
+						       sizeof(fw_cmd),
+						       TXGBE_HI_COMMAND_TIMEOUT,
+						       true);
+		if (ret_val != 0)
+			continue;
+
+		if (fw_cmd.hdr.cmd_or_resp.ret_status ==
+		    FW_CEM_RESP_STATUS_SUCCESS)
+			ret_val = 0;
+		else
+			ret_val = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+
+		break;
+	}
+
+	return ret_val;
+}
+
+/**
+ *  txgbe_reset_hostif - send reset cmd to fw
+ *  @hw: pointer to hardware structure
+ *
+ *  Sends reset cmd to firmware through the manageability
+ *  block.  On success return 0
+ *  else returns TXGBE_ERR_SWFW_SYNC when encountering an error acquiring
+ *  semaphore or TXGBE_ERR_HOST_INTERFACE_COMMAND when command fails.
+ **/
+s32 txgbe_reset_hostif(struct txgbe_hw *hw)
+{
+	struct txgbe_hic_reset reset_cmd;
+	int i;
+	s32 status = 0;
+
+	reset_cmd.hdr.cmd = FW_RESET_CMD;
+	reset_cmd.hdr.buf_len = FW_RESET_LEN;
+	reset_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	reset_cmd.lan_id = hw->bus.lan_id;
+	reset_cmd.reset_type = (u16)hw->reset_type;
+	reset_cmd.hdr.checksum = 0;
+	reset_cmd.hdr.checksum = txgbe_calculate_checksum((u8 *)&reset_cmd,
+				(FW_CEM_HDR_LEN + reset_cmd.hdr.buf_len));
+
+	for (i = 0; i <= FW_CEM_MAX_RETRIES; i++) {
+		status = txgbe_host_interface_command(hw, (u32 *)&reset_cmd,
+						      sizeof(reset_cmd),
+						      TXGBE_HI_COMMAND_TIMEOUT,
+						      true);
+		if (status != 0)
+			continue;
+
+		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
+		    FW_CEM_RESP_STATUS_SUCCESS) {
+			status = 0;
+		} else {
+			status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+		}
+
+		break;
+	}
+
+	return status;
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -541,6 +1190,46 @@ void txgbe_disable_rx(struct txgbe_hw *hw)
 	}
 }
 
+/**
+ * txgbe_mng_present - returns true when management capability is present
+ * @hw: pointer to hardware structure
+ */
+bool txgbe_mng_present(struct txgbe_hw *hw)
+{
+	u32 fwsm;
+
+	fwsm = rd32(hw, TXGBE_MIS_ST);
+	return fwsm & TXGBE_MIS_ST_MNG_INIT_DN;
+}
+
+bool txgbe_check_mng_access(struct txgbe_hw *hw)
+{
+	bool ret = false;
+	u32 rst_delay;
+	u32 i;
+
+	struct txgbe_adapter *adapter = hw->back;
+
+	if (!txgbe_mng_present(hw))
+		return false;
+	if (adapter->hw.revision_id != TXGBE_SP_MPW)
+		return true;
+	if (!(adapter->flags2 & TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED))
+		return true;
+
+	rst_delay = (rd32(&adapter->hw, TXGBE_MIS_RST_ST) &
+		     TXGBE_MIS_RST_ST_RST_INIT) >>
+		     TXGBE_MIS_RST_ST_RST_INI_SHIFT;
+	for (i = 0; i < rst_delay + 2; i++) {
+		if (!(adapter->flags2 & TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED)) {
+			ret = true;
+			break;
+		}
+		msleep(100);
+	}
+	return ret;
+}
+
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 {
 	u32 i = 0;
@@ -575,6 +1264,7 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 s32 txgbe_init_ops(struct txgbe_hw *hw)
 {
 	struct txgbe_mac_info *mac = &hw->mac;
+	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw;
@@ -582,9 +1272,12 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.get_bus_info = txgbe_get_bus_info;
 	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync;
+	mac->ops.release_swfw_sync = txgbe_release_swfw_sync;
 	mac->ops.reset_hw = txgbe_reset_hw;
 	mac->ops.start_hw = txgbe_start_hw;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
+	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
 
 	/* RAR */
 	mac->ops.set_rar = txgbe_set_rar;
@@ -596,7 +1289,16 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
 
+	/* EEPROM */
+	eeprom->ops.init_params = txgbe_init_eeprom_params;
+	eeprom->ops.calc_checksum = txgbe_calc_eeprom_checksum;
+	eeprom->ops.read = txgbe_read_ee_hostif;
+	eeprom->ops.read_buffer = txgbe_read_ee_hostif_buffer;
+	eeprom->ops.validate_checksum = txgbe_validate_eeprom_checksum;
+
 	/* Manageability interface */
+	mac->ops.set_fw_drv_ver = txgbe_set_fw_drv_ver;
+
 	mac->ops.init_thermal_sensor_thresh =
 				      txgbe_init_thermal_sensor_thresh;
 
@@ -695,6 +1397,14 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_SW_RESET);
 			if (status != 0)
 				goto reset_hw_out;
+			/* errata 7 */
+			if (txgbe_mng_present(hw) &&
+			    hw->revision_id == TXGBE_SP_MPW) {
+				struct txgbe_adapter *adapter =
+					(struct txgbe_adapter *)hw->back;
+				adapter->flags2 &=
+					~TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED;
+			}
 		} else if (hw->reset_type == TXGBE_GLOBAL_RESET) {
 			struct txgbe_adapter *adapter =
 					(struct txgbe_adapter *)hw->back;
@@ -704,14 +1414,21 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 			pci_wake_from_d3(adapter->pdev, false);
 		}
 	} else {
-		if (hw->bus.lan_id == 0)
-			reset = TXGBE_MIS_RST_LAN0_RST;
-		else
-			reset = TXGBE_MIS_RST_LAN1_RST;
-
-		wr32(hw, TXGBE_MIS_RST,
-		     reset | rd32(hw, TXGBE_MIS_RST));
-		TXGBE_WRITE_FLUSH(hw);
+		if (txgbe_mng_present(hw)) {
+			if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+			      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+				txgbe_reset_hostif(hw);
+			}
+		} else {
+			if (hw->bus.lan_id == 0)
+				reset = TXGBE_MIS_RST_LAN0_RST;
+			else
+				reset = TXGBE_MIS_RST_LAN1_RST;
+
+			wr32(hw, TXGBE_MIS_RST,
+			     reset | rd32(hw, TXGBE_MIS_RST));
+			TXGBE_WRITE_FLUSH(hw);
+		}
 		usec_delay(10);
 
 		if (hw->bus.lan_id == 0)
@@ -752,6 +1469,10 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 		hw->mac.num_rar_entries--;
 	}
 
+	/* Store the alternative WWNN/WWPN prefix */
+	TCALL(hw, mac.ops.get_wwn_prefix, &hw->mac.wwnn_prefix,
+	      &hw->mac.wwpn_prefix);
+
 	pci_set_master(((struct txgbe_adapter *)hw->back)->pdev);
 
 reset_hw_out:
@@ -787,3 +1508,288 @@ s32 txgbe_start_hw(struct txgbe_hw *hw)
 	return ret_val;
 }
 
+/**
+ *  txgbe_init_eeprom_params - Initialize EEPROM params
+ *  @hw: pointer to hardware structure
+ *
+ *  Initializes the EEPROM parameters txgbe_eeprom_info within the
+ *  txgbe_hw struct in order to set up EEPROM access.
+ **/
+s32 txgbe_init_eeprom_params(struct txgbe_hw *hw)
+{
+	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
+	u16 eeprom_size;
+	s32 status = 0;
+	u16 data;
+
+	if (eeprom->type == txgbe_eeprom_uninitialized) {
+		eeprom->semaphore_delay = 10;
+		eeprom->type = txgbe_eeprom_none;
+
+		if (!(rd32(hw, TXGBE_SPI_STATUS) &
+		      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
+			eeprom->type = txgbe_flash;
+
+			eeprom_size = 4096;
+			eeprom->word_size = eeprom_size >> 1;
+
+			DEBUGOUT2("Eeprom params: type = %d, size = %d\n",
+				  eeprom->type, eeprom->word_size);
+		}
+	}
+
+	status = TCALL(hw, eeprom.ops.read, TXGBE_SW_REGION_PTR, &data);
+	if (status) {
+		DEBUGOUT("NVM Read Error\n");
+		return status;
+	}
+	eeprom->sw_region_offset = data >> 1;
+
+	return status;
+}
+
+/**
+ *  txgbe_read_ee_hostif - Read EEPROM word using a host interface cmd
+ *  assuming that the semaphore is already obtained.
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: word read from the EEPROM
+ *
+ *  Reads a 16 bit word from the EEPROM using the hostif.
+ **/
+s32 txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset,
+			      u16 *data)
+{
+	s32 status;
+	struct txgbe_hic_read_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = FW_READ_SHADOW_RAM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = FW_READ_SHADOW_RAM_LEN;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* convert offset from words to bytes */
+	buffer.address = TXGBE_CPU_TO_BE32(offset * 2);
+	/* one word */
+	buffer.length = TXGBE_CPU_TO_BE16(sizeof(u16));
+
+	status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+					      sizeof(buffer),
+					      TXGBE_HI_COMMAND_TIMEOUT, false);
+
+	if (status)
+		return status;
+	if (txgbe_check_mng_access(hw)) {
+		*data = (u16)rd32a(hw, TXGBE_MNG_MBOX, FW_NVM_DATA_OFFSET);
+	} else {
+		status = TXGBE_ERR_MNG_ACCESS_FAILED;
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ *  txgbe_read_ee_hostif - Read EEPROM word using a host interface cmd
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: word read from the EEPROM
+ *
+ *  Reads a 16 bit word from the EEPROM using the hostif.
+ **/
+s32 txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset,
+			 u16 *data)
+{
+	s32 status = 0;
+
+	if (TCALL(hw, mac.ops.acquire_swfw_sync,
+		  TXGBE_MNG_SWFW_SYNC_SW_FLASH) == 0) {
+		status = txgbe_read_ee_hostif_data(hw, offset, data);
+		TCALL(hw, mac.ops.release_swfw_sync,
+		      TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	} else {
+		status = TXGBE_ERR_SWFW_SYNC;
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_read_ee_hostif_buffer- Read EEPROM word(s) using hostif
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @words: number of words
+ *  @data: word(s) read from the EEPROM
+ *
+ *  Reads a 16 bit word(s) from the EEPROM using the hostif.
+ **/
+s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
+				u16 offset, u16 words, u16 *data)
+{
+	struct txgbe_hic_read_shadow_ram buffer;
+	u32 current_word = 0;
+	u16 words_to_read;
+	s32 status;
+	u32 i;
+	u32 value = 0;
+
+	/* Take semaphore for the entire operation. */
+	status = TCALL(hw, mac.ops.acquire_swfw_sync,
+		       TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	if (status) {
+		DEBUGOUT("EEPROM read buffer - semaphore failed\n");
+		return status;
+	}
+	while (words) {
+		if (words > FW_MAX_READ_BUFFER_SIZE / 2)
+			words_to_read = FW_MAX_READ_BUFFER_SIZE / 2;
+		else
+			words_to_read = words;
+
+		buffer.hdr.req.cmd = FW_READ_SHADOW_RAM_CMD;
+		buffer.hdr.req.buf_lenh = 0;
+		buffer.hdr.req.buf_lenl = FW_READ_SHADOW_RAM_LEN;
+		buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+		/* convert offset from words to bytes */
+		buffer.address = TXGBE_CPU_TO_BE32((offset + current_word) * 2);
+		buffer.length = TXGBE_CPU_TO_BE16(words_to_read * 2);
+
+		status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+						      sizeof(buffer),
+						      TXGBE_HI_COMMAND_TIMEOUT,
+						      false);
+
+		if (status) {
+			DEBUGOUT("Host interface command failed\n");
+			goto out;
+		}
+
+		for (i = 0; i < words_to_read; i++) {
+			u32 reg = TXGBE_MNG_MBOX + (FW_NVM_DATA_OFFSET << 2) +
+				  2 * i;
+			if (txgbe_check_mng_access(hw)) {
+				value = rd32(hw, reg);
+			} else {
+				status = TXGBE_ERR_MNG_ACCESS_FAILED;
+				return status;
+			}
+			data[current_word] = (u16)(value & 0xffff);
+			current_word++;
+			i++;
+			if (i < words_to_read) {
+				value >>= 16;
+				data[current_word] = (u16)(value & 0xffff);
+				current_word++;
+			}
+		}
+		words -= words_to_read;
+	}
+
+out:
+	TCALL(hw, mac.ops.release_swfw_sync, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	return status;
+}
+
+/**
+ *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
+ *  @hw: pointer to hardware structure
+ *
+ *  Returns a negative error code on error, or the 16-bit checksum
+ **/
+s32 txgbe_calc_eeprom_checksum(struct txgbe_hw *hw)
+{
+	u16 *buffer = NULL;
+	u32 buffer_size = 0;
+
+	u16 *eeprom_ptrs = NULL;
+	u16 *local_buffer;
+	s32 status;
+	u16 checksum = 0;
+	u16 i;
+
+	TCALL(hw, eeprom.ops.init_params);
+
+	if (!buffer) {
+		eeprom_ptrs = vmalloc(TXGBE_EEPROM_LAST_WORD * sizeof(u16));
+		if (!eeprom_ptrs)
+			return TXGBE_ERR_NO_SPACE;
+		/* Read pointer area */
+		status = txgbe_read_ee_hostif_buffer(hw, 0,
+						     TXGBE_EEPROM_LAST_WORD,
+						     eeprom_ptrs);
+		if (status) {
+			DEBUGOUT("Failed to read EEPROM image\n");
+			return status;
+		}
+		local_buffer = eeprom_ptrs;
+	} else {
+		if (buffer_size < TXGBE_EEPROM_LAST_WORD)
+			return TXGBE_ERR_PARAM;
+		local_buffer = buffer;
+	}
+
+	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
+		if (i != hw->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
+			checksum += local_buffer[i];
+
+	checksum = (u16)TXGBE_EEPROM_SUM - checksum;
+	if (eeprom_ptrs)
+		vfree(eeprom_ptrs);
+
+	return (s32)checksum;
+}
+
+/**
+ *  txgbe_validate_eeprom_checksum - Validate EEPROM checksum
+ *  @hw: pointer to hardware structure
+ *  @checksum_val: calculated checksum
+ *
+ *  Performs checksum calculation and validates the EEPROM checksum.  If the
+ *  caller does not need checksum_val, the value can be NULL.
+ **/
+s32 txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
+				   u16 *checksum_val)
+{
+	s32 status;
+	u16 checksum;
+	u16 read_checksum = 0;
+
+	/* Read the first word from the EEPROM. If this times out or fails, do
+	 * not continue or we could be in for a very long wait while every
+	 * EEPROM read fails
+	 */
+	status = TCALL(hw, eeprom.ops.read, 0, &checksum);
+	if (status) {
+		DEBUGOUT("EEPROM read failed\n");
+		return status;
+	}
+
+	status = TCALL(hw, eeprom.ops.calc_checksum);
+	if (status < 0)
+		return status;
+
+	checksum = (u16)(status & 0xffff);
+
+	status = txgbe_read_ee_hostif(hw, hw->eeprom.sw_region_offset +
+				      TXGBE_EEPROM_CHECKSUM,
+				      &read_checksum);
+	if (status)
+		return status;
+
+	/* Verify read checksum from EEPROM is the same as
+	 * calculated checksum
+	 */
+	if (read_checksum != checksum) {
+		status = TXGBE_ERR_EEPROM_CHECKSUM;
+		ERROR_REPORT1(TXGBE_ERROR_INVALID_STATE,
+			      "Invalid EEPROM checksum\n");
+	}
+
+	/* If the user cares, return the calculated checksum */
+	if (checksum_val)
+		*checksum_val = checksum;
+
+	return status;
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 318c7f0dc5b9..700d344ba6c1 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -6,6 +6,8 @@
 
 s32 txgbe_init_hw(struct txgbe_hw *hw);
 s32 txgbe_start_hw(struct txgbe_hw *hw);
+s32 txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
+			  u32 pba_num_size);
 s32 txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
 s32 txgbe_get_bus_info(struct txgbe_hw *hw);
 void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
@@ -17,6 +19,8 @@ s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
 s32 txgbe_init_rx_addrs(struct txgbe_hw *hw);
 
+s32 txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask);
+void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask);
 s32 txgbe_disable_pcie_master(struct txgbe_hw *hw);
 
 s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
@@ -25,6 +29,19 @@ s32 txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
 s32 txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 s32 txgbe_init_uta_tables(struct txgbe_hw *hw);
 
+s32 txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			 u16 *wwpn_prefix);
+
+s32 txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
+			 u8 build, u8 ver);
+s32 txgbe_reset_hostif(struct txgbe_hw *hw);
+u8 txgbe_calculate_checksum(u8 *buffer, u32 length);
+s32 txgbe_host_interface_command(struct txgbe_hw *hw, u32 *buffer,
+				 u32 length, u32 timeout, bool return_data);
+
+bool txgbe_mng_present(struct txgbe_hw *hw);
+bool txgbe_check_mng_access(struct txgbe_hw *hw);
+
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
@@ -33,4 +50,13 @@ int txgbe_reset_misc(struct txgbe_hw *hw);
 s32 txgbe_reset_hw(struct txgbe_hw *hw);
 s32 txgbe_init_ops(struct txgbe_hw *hw);
 
+s32 txgbe_init_eeprom_params(struct txgbe_hw *hw);
+s32 txgbe_calc_eeprom_checksum(struct txgbe_hw *hw);
+s32 txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
+				   u16 *checksum_val);
+s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
+				u16 offset, u16 words, u16 *data);
+s32 txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset, u16 *data);
+s32 txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset, u16 *data);
+
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index a1441af5b46b..9336eadfc690 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -458,6 +458,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct txgbe_adapter *adapter = NULL;
 	struct txgbe_hw *hw = NULL;
 	int err, pci_using_dac, expected_gts;
+	u16 offset = 0;
+	u16 eeprom_verh = 0, eeprom_verl = 0;
+	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
+	u32 etrack_id = 0;
+	u16 build = 0, major = 0, patch = 0;
+	u8 part_str[TXGBE_PBANUM_LENGTH];
 	unsigned int indices = MAX_TX_QUEUES;
 	bool disable_dev = false;
 
@@ -558,6 +564,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 	}
 
+	/* make sure the EEPROM is good */
+	if (TCALL(hw, eeprom.ops.validate_checksum, NULL)) {
+		txgbe_dev_err("The EEPROM Checksum Is Not Valid\n");
+		wr32(hw, TXGBE_MIS_RST, TXGBE_MIS_RST_SW_RST);
+		err = -EIO;
+		goto err_sw_init;
+	}
+
 	eth_hw_addr_set(netdev, hw->mac.perm_addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
@@ -578,6 +592,43 @@ static int txgbe_probe(struct pci_dev *pdev,
 	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
 	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
 
+	/* Save off EEPROM version number and Option Rom version which
+	 * together make a unique identify for the eeprom
+	 */
+	TCALL(hw, eeprom.ops.read,
+	      hw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_H,
+	      &eeprom_verh);
+	TCALL(hw, eeprom.ops.read,
+	      hw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_L,
+	      &eeprom_verl);
+	etrack_id = (eeprom_verh << 16) | eeprom_verl;
+
+	TCALL(hw, eeprom.ops.read,
+	      hw->eeprom.sw_region_offset + TXGBE_ISCSI_BOOT_CONFIG, &offset);
+
+	/* Make sure offset to SCSI block is valid */
+	if (!(offset == 0x0) && !(offset == 0xffff)) {
+		TCALL(hw, eeprom.ops.read, offset + 0x84, &eeprom_cfg_blkh);
+		TCALL(hw, eeprom.ops.read, offset + 0x83, &eeprom_cfg_blkl);
+
+		/* Only display Option Rom if exist */
+		if (eeprom_cfg_blkl && eeprom_cfg_blkh) {
+			major = eeprom_cfg_blkl >> 8;
+			build = (eeprom_cfg_blkl << 8) | (eeprom_cfg_blkh >> 8);
+			patch = eeprom_cfg_blkh & 0x00ff;
+
+			snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+				 "0x%08x, %d.%d.%d", etrack_id, major, build,
+				 patch);
+		} else {
+			snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+				 "0x%08x", etrack_id);
+		}
+	} else {
+		snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+			 "0x%08x", etrack_id);
+	}
+
 	/* reset the hardware with the new settings */
 	err = TCALL(hw, mac.ops.start_hw);
 	if (err) {
@@ -616,11 +667,19 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		txgbe_info(probe, "NCSI : unsupported");
 
+	/* First try to read PBA as a string */
+	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
+	if (err)
+
+		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
 	txgbe_dev_info("%02x:%02x:%02x:%02x:%02x:%02x\n",
 		       netdev->dev_addr[0], netdev->dev_addr[1],
 		       netdev->dev_addr[2], netdev->dev_addr[3],
 		       netdev->dev_addr[4], netdev->dev_addr[5]);
 
+	/* firmware requires blank driver version */
+	TCALL(hw, mac.ops.set_fw_drv_ver, 0xFF, 0xFF, 0xFF, 0xFF);
+
 	/* add san mac addr to netdev */
 	txgbe_add_sanmac_netdev(netdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 60b1c3a2ac50..e1b438e18edc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -1540,8 +1540,92 @@ enum TXGBE_MSCA_CMD_value {
 #define TXGBE_PCIDEVCTRL2_4_8s          0xd
 #define TXGBE_PCIDEVCTRL2_17_34s        0xe
 
+/****************** Manageablility Host Interface defines ********************/
+#define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
+#define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
+#define TXGBE_HI_COMMAND_TIMEOUT        5000 /* Process HI command limit */
+
+/* CEM Support */
+#define FW_CEM_HDR_LEN                  0x4
+#define FW_CEM_CMD_DRIVER_INFO          0xDD
+#define FW_CEM_CMD_DRIVER_INFO_LEN      0x5
+#define FW_CEM_CMD_RESERVED             0X0
+#define FW_CEM_MAX_RETRIES              3
+#define FW_CEM_RESP_STATUS_SUCCESS      0x1
+#define FW_READ_SHADOW_RAM_CMD          0x31
+#define FW_READ_SHADOW_RAM_LEN          0x6
+#define FW_DEFAULT_CHECKSUM             0xFF /* checksum always 0xFF */
+#define FW_NVM_DATA_OFFSET              3
+#define FW_MAX_READ_BUFFER_SIZE         244
+#define FW_RESET_CMD                    0xDF
+#define FW_RESET_LEN                    0x2
+
+/* Host Interface Command Structures */
+struct txgbe_hic_hdr {
+	u8 cmd;
+	u8 buf_len;
+	union {
+		u8 cmd_resv;
+		u8 ret_status;
+	} cmd_or_resp;
+	u8 checksum;
+};
+
+struct txgbe_hic_hdr2_req {
+	u8 cmd;
+	u8 buf_lenh;
+	u8 buf_lenl;
+	u8 checksum;
+};
+
+struct txgbe_hic_hdr2_rsp {
+	u8 cmd;
+	u8 buf_lenl;
+	u8 buf_lenh_status;     /* 7-5: high bits of buf_len, 4-0: status */
+	u8 checksum;
+};
+
+union txgbe_hic_hdr2 {
+	struct txgbe_hic_hdr2_req req;
+	struct txgbe_hic_hdr2_rsp rsp;
+};
+
+struct txgbe_hic_drv_info {
+	struct txgbe_hic_hdr hdr;
+	u8 port_num;
+	u8 ver_sub;
+	u8 ver_build;
+	u8 ver_min;
+	u8 ver_maj;
+	u8 pad; /* end spacing to ensure length is mult. of dword */
+	u16 pad2; /* end spacing to ensure length is mult. of dword2 */
+};
+
+/* These need to be dword aligned */
+struct txgbe_hic_read_shadow_ram {
+	union txgbe_hic_hdr2 hdr;
+	u32 address;
+	u16 length;
+	u16 pad2;
+	u16 data;
+	u16 pad3;
+};
+
+struct txgbe_hic_reset {
+	struct txgbe_hic_hdr hdr;
+	u16 lan_id;
+	u16 reset_type;
+};
+
 /* Number of 100 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        800
+enum txgbe_eeprom_type {
+	txgbe_eeprom_uninitialized = 0,
+	txgbe_eeprom_spi,
+	txgbe_flash,
+	txgbe_eeprom_none /* No NVM support */
+};
+
 
 /* PCI bus types */
 enum txgbe_bus_type {
@@ -1600,15 +1684,29 @@ struct txgbe_bus_info {
 /* forward declaration */
 struct txgbe_hw;
 
+/* Function pointer table */
+struct txgbe_eeprom_operations {
+	s32 (*init_params)(struct txgbe_hw *hw);
+	s32 (*read)(struct txgbe_hw *hw, u16 offset, u16 *data);
+	s32 (*read_buffer)(struct txgbe_hw *hw,
+			   u16 offset, u16 words, u16 *data);
+	s32 (*validate_checksum)(struct txgbe_hw *hw, u16 *checksum_val);
+	s32 (*calc_checksum)(struct txgbe_hw *hw);
+};
+
 struct txgbe_mac_operations {
 	s32 (*init_hw)(struct txgbe_hw *hw);
 	s32 (*reset_hw)(struct txgbe_hw *hw);
 	s32 (*start_hw)(struct txgbe_hw *hw);
 	s32 (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
 	s32 (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
+	s32 (*get_wwn_prefix)(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			      u16 *wwpn_prefix);
 	s32 (*stop_adapter)(struct txgbe_hw *hw);
 	s32 (*get_bus_info)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
+	s32 (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
+	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
 	/* RAR */
 	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
@@ -1620,15 +1718,29 @@ struct txgbe_mac_operations {
 	s32 (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
+	s32 (*set_fw_drv_ver)(struct txgbe_hw *hw, u8 maj, u8 min,
+			      u8 build, u8 ver);
 	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 	void (*disable_rx)(struct txgbe_hw *hw);
 };
 
+struct txgbe_eeprom_info {
+	struct txgbe_eeprom_operations ops;
+	enum txgbe_eeprom_type type;
+	u32 semaphore_delay;
+	u16 word_size;
+	u16 sw_region_offset;
+};
+
 struct txgbe_mac_info {
 	struct txgbe_mac_operations ops;
 	u8 addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
 	u8 perm_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
 	u8 san_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	/* prefix for World Wide Node Name (WWNN) */
+	u16 wwnn_prefix;
+	/* prefix for World Wide Port Name (WWPN) */
+	u16 wwpn_prefix;
 	s32 mc_filter_type;
 	u32 mcft_size;
 	u32 num_rar_entries;
@@ -1651,6 +1763,7 @@ struct txgbe_hw {
 	void *back;
 	struct txgbe_mac_info mac;
 	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_eeprom_info eeprom;
 	struct txgbe_bus_info bus;
 	u16 device_id;
 	u16 vendor_id;
-- 
2.27.0



