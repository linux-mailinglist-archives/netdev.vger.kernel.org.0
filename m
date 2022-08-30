Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98625A5C72
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiH3HF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiH3HFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:45 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33248673F
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:37 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843130tjuco7sb
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:29 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: SN3wGuzO13GuZkoL6FDb4zrx5def9fvywCJQQ+Kqzw6Mc+n8vhdpoDA2KNzfN
        roTp6g9MDPyrHM3zNTukHWTSraqvCnwUEOXvCM9QUlKBy6/cjeGqg4EmBT70vCW4Scnn691
        008nLT6LY2dDqVGPhJAirnrIRO2JIDRY0a1IeeUlCsA6Q7Ww3WC7bz606uuswQQ/vOAVWqK
        4sD7CM+K+gag65piMXVYx7/niMANf8jru2sW5wbnyNpmMXFD3aXSnmeBofh+yNLn7GSAsQT
        mt6HaBHacCRpWZNtsHQ2hw+2793l2JrASPamfLP9qrs10f9+WRkJSaPKbt3i6BR2DYh+QGz
        L/yVxtLE+xBm8Y2QE40LvSqM9mhozgw3XnuqOkJUX5ukqs6QzQmDJeHHw3vIKvfcwEVroy7
        P8gxG8lVgls=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 04/16] net: txgbe: Add operations to interact with firmware
Date:   Tue, 30 Aug 2022 15:04:42 +0800
Message-Id: <20220830070454.146211-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add firmware interaction to get EEPROM information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  58 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 936 +++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  26 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  94 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 180 ++++
 6 files changed, 1285 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index f0c9d3055d5b..cd182fe09712 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -45,6 +45,7 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	char eeprom_id[32];
 	bool netdev_registered;
 
 	struct txgbe_mac_addr *mac_table;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index a6eacace3c6a..51d4f9be1071 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -37,6 +37,15 @@ static void txgbe_bus_set_lan_id_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static int txgbe_acquire_swfw_sync_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+	return -EPERM;
+}
+
+static void txgbe_release_swfw_sync_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+}
+
 static int txgbe_reset_hw_dummy(struct txgbe_hw *TUP0)
 {
 	return -EPERM;
@@ -50,6 +59,11 @@ static void txgbe_get_san_mac_addr_dummy(struct txgbe_hw *TUP0, u8 *TUP1)
 {
 }
 
+static void txgbe_get_wwn_prefix_dummy(struct txgbe_hw *TUP0,
+				       u16 *TUP1, u16 *TUP2)
+{
+}
+
 static void txgbe_set_rar_dummy(struct txgbe_hw *TUP0, u32 TUP1,
 				u8 *TUP2, u64 TUP3, u32 TUP4)
 {
@@ -79,12 +93,45 @@ static void txgbe_init_uta_tables_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static int txgbe_set_fw_drv_ver_dummy(struct txgbe_hw *TUP0, u8 TUP1,
+				      u8 TUP2, u8 TUP3, u8 TUP4)
+{
+	return -EPERM;
+}
+
 static void txgbe_init_thermal_sensor_thresh_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+/* struct txgbe_eeprom_operations */
+static void txgbe_init_eeprom_params_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static int txgbe_calc_eeprom_checksum_dummy(struct txgbe_hw *TUP0, u16 *TUP1)
+{
+	return -EPERM;
+}
+
+static int txgbe_read_ee_hostif_dummy(struct txgbe_hw *TUP0, u16 TUP1, u16 *TUP2)
+{
+	return -EPERM;
+}
+
+static int txgbe_read_ee_hostif_buffer_dummy(struct txgbe_hw *TUP0, u16 TUP1,
+					     u16 TUP2, u16 *TUP3)
+{
+	return -EPERM;
+}
+
+static int txgbe_validate_eeprom_checksum_dummy(struct txgbe_hw *TUP0, u16 *TUP1)
+{
+	return -EPERM;
+}
+
 static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 {
+	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
@@ -92,9 +139,12 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.get_mac_addr = txgbe_get_mac_addr_dummy;
 	mac->ops.stop_adapter = txgbe_stop_adapter_dummy;
 	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;
+	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync_dummy;
+	mac->ops.release_swfw_sync = txgbe_release_swfw_sync_dummy;
 	mac->ops.reset_hw = txgbe_reset_hw_dummy;
 	mac->ops.start_hw = txgbe_start_hw_dummy;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr_dummy;
+	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix_dummy;
 
 	/* RAR */
 	mac->ops.set_rar = txgbe_set_rar_dummy;
@@ -105,7 +155,15 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac_dummy;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables_dummy;
 
+	/* EEPROM */
+	eeprom->ops.init_params = txgbe_init_eeprom_params_dummy;
+	eeprom->ops.calc_checksum = txgbe_calc_eeprom_checksum_dummy;
+	eeprom->ops.read = txgbe_read_ee_hostif_dummy;
+	eeprom->ops.read_buffer = txgbe_read_ee_hostif_buffer_dummy;
+	eeprom->ops.validate_checksum = txgbe_validate_eeprom_checksum_dummy;
+
 	/* Manageability interface */
+	mac->ops.set_fw_drv_ver = txgbe_set_fw_drv_ver_dummy;
 	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh_dummy;
 }
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 2a0e2ef9678c..1b386570fb34 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -9,6 +9,9 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 
+static int txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
+static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw);
+
 int txgbe_init_hw(struct txgbe_hw *hw)
 {
 	int status;
@@ -24,6 +27,118 @@ int txgbe_init_hw(struct txgbe_hw *hw)
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
+int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
+			  u32 pba_num_size)
+{
+	int ret_val;
+	u16 pba_ptr;
+	u16 offset;
+	u16 length;
+	u16 data;
+
+	if (!pba_num) {
+		txgbe_info(hw, "PBA string buffer was null\n");
+		return -EINVAL;
+	}
+
+	ret_val = hw->eeprom.ops.read(hw,
+				      hw->eeprom.sw_region_offset + TXGBE_PBANUM0_PTR,
+				      &data);
+	if (ret_val != 0) {
+		txgbe_info(hw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	ret_val = hw->eeprom.ops.read(hw,
+				      hw->eeprom.sw_region_offset + TXGBE_PBANUM1_PTR,
+				      &pba_ptr);
+	if (ret_val != 0) {
+		txgbe_info(hw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	/* if data is not ptr guard the PBA must be in legacy format which
+	 * means pba_ptr is actually our second data word for the PBA number
+	 * and we can decode it into an ascii string
+	 */
+	if (data != TXGBE_PBANUM_PTR_GUARD) {
+		txgbe_info(hw, "NVM PBA number is not stored as string\n");
+
+		/* we will need 11 characters to store the PBA */
+		if (pba_num_size < 11) {
+			txgbe_info(hw, "PBA string buffer too small\n");
+			return -ENOMEM;
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
+	ret_val = hw->eeprom.ops.read(hw, pba_ptr, &length);
+	if (ret_val != 0) {
+		txgbe_info(hw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	if (length == 0xFFFF || length == 0) {
+		txgbe_info(hw, "NVM PBA number section invalid length\n");
+		return -EINVAL;
+	}
+
+	/* check if pba_num buffer is big enough */
+	if (pba_num_size  < (((u32)length * 2) - 1)) {
+		txgbe_info(hw, "PBA string buffer too small\n");
+		return -ENOMEM;
+	}
+
+	/* trim pba length from start of string */
+	pba_ptr++;
+	length--;
+
+	for (offset = 0; offset < length; offset++) {
+		ret_val = hw->eeprom.ops.read(hw, pba_ptr + offset, &data);
+		if (ret_val != 0) {
+			txgbe_info(hw, "NVM Read Error\n");
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
@@ -123,6 +238,58 @@ int txgbe_stop_adapter(struct txgbe_hw *hw)
 	return txgbe_disable_pcie_master(hw);
 }
 
+/**
+ *  txgbe_get_eeprom_semaphore - Get hardware semaphore
+ *  @hw: pointer to hardware structure
+ *
+ *  Sets the hardware semaphores so EEPROM access can occur for bit-bang method
+ **/
+static int txgbe_get_eeprom_semaphore(struct txgbe_hw *hw)
+{
+	int status = 0;
+	u32 swsm;
+
+	/* Get SMBI software semaphore between device drivers first */
+	status = read_poll_timeout(rd32, swsm, !(swsm & TXGBE_MIS_SWSM_SMBI),
+				   50, 100000, false, hw, TXGBE_MIS_SWSM);
+
+	if (status != 0) {
+		txgbe_info(hw, "Driver can't access the Eeprom - SMBI Semaphore not granted.\n");
+
+		/* this release is particularly important because our attempts
+		 * above to get the semaphore may have succeeded, and if there
+		 * was a timeout, we should unconditionally clear the semaphore
+		 * bits to free the driver to make progress
+		 */
+		txgbe_release_eeprom_semaphore(hw);
+
+		usleep_range(50, 100);
+		/* one last try
+		 * If the SMBI bit is 0 when we read it, then the bit will be
+		 * set and we have the semaphore
+		 */
+		swsm = rd32(hw, TXGBE_MIS_SWSM);
+		if (!(swsm & TXGBE_MIS_SWSM_SMBI))
+			status = 0;
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
+		wr32m(hw, TXGBE_MIS_SWSM, TXGBE_MIS_SWSM_SMBI, 0);
+		TXGBE_WRITE_FLUSH(hw);
+	}
+}
+
 /**
  *  txgbe_set_rar - Set Rx address register
  *  @hw: pointer to hardware structure
@@ -308,17 +475,137 @@ int txgbe_disable_pcie_master(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_acquire_swfw_sync - Acquire SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to acquire
+ *
+ *  Acquires the SWFW semaphore for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+int txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask)
+{
+	u32 fwmask = mask << 16;
+	u32 swmask = mask;
+	u32 timeout = 200;
+	u32 gssr = 0;
+	int ret = 0;
+	u32 i;
+
+	for (i = 0; i < timeout; i++) {
+		/* SW NVM semaphore bit is used for access to all
+		 * SW_FW_SYNC bits (not just NVM)
+		 */
+		ret = txgbe_get_eeprom_semaphore(hw);
+		if (ret != 0)
+			return ret;
+
+		if (txgbe_check_mng_access(hw)) {
+			gssr = rd32(hw, TXGBE_MNG_SWFW_SYNC);
+			if (gssr & (fwmask | swmask)) {
+				/* Resource is currently in use by FW or SW */
+				txgbe_release_eeprom_semaphore(hw);
+				usleep_range(5000, 6000);
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
+	usleep_range(5000, 6000);
+	return -EBUSY;
+}
+
+/**
+ *  txgbe_release_swfw_sync - Release SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to release
+ *
+ *  Releases the SWFW semaphore for the specified
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
+static int txgbe_get_san_mac_addr_offset(struct txgbe_hw *hw,
+					 u16 *san_mac_offset)
+{
+	int ret_val;
+
+	/* First read the EEPROM pointer to see if the MAC addresses are
+	 * available.
+	 */
+	ret_val = hw->eeprom.ops.read(hw,
+				      hw->eeprom.sw_region_offset + TXGBE_SAN_MAC_ADDR_PTR,
+				      san_mac_offset);
+	if (ret_val != 0) {
+		txgbe_dbg(hw, "eeprom at offset %d failed",
+			  TXGBE_SAN_MAC_ADDR_PTR);
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
 void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr)
 {
+	u16 san_mac_data, san_mac_offset;
+	int ret_val;
 	u8 i;
 
+	/* First read the EEPROM pointer to see if the MAC addresses are
+	 * available.  If they're not, no point in calling set_lan_id() here.
+	 */
+	ret_val = txgbe_get_san_mac_addr_offset(hw, &san_mac_offset);
+	if (ret_val != 0 || san_mac_offset == 0 || san_mac_offset == 0xFFFF)
+		goto san_mac_addr_out;
+
+	/* apply the port offset to the address offset */
+	(hw->bus.func) ? (san_mac_offset += TXGBE_SAN_MAC_ADDR_PORT1_OFFSET) :
+			 (san_mac_offset += TXGBE_SAN_MAC_ADDR_PORT0_OFFSET);
+	for (i = 0; i < 3; i++) {
+		ret_val = hw->eeprom.ops.read(hw, san_mac_offset,
+					      &san_mac_data);
+		if (ret_val != 0) {
+			txgbe_dbg(hw, "eeprom read at offset %d failed",
+				  san_mac_offset);
+			goto san_mac_addr_out;
+		}
+		san_mac_addr[i * 2] = (u8)(san_mac_data);
+		san_mac_addr[i * 2 + 1] = (u8)(san_mac_data >> 8);
+		san_mac_offset++;
+	}
+	return;
+
+san_mac_addr_out:
 	/* No addresses available in this EEPROM.  It's not an
 	 * error though, so just wipe the local address and return.
 	 */
@@ -388,6 +675,317 @@ void txgbe_init_uta_tables(struct txgbe_hw *hw)
 		wr32(hw, TXGBE_PSR_UC_TBL(i), 0);
 }
 
+/**
+ *  txgbe_get_wwn_prefix - Get alternative WWNN/WWPN prefix from the EEPROM
+ *  @hw: pointer to hardware structure
+ *  @wwnn_prefix: the alternative WWNN prefix
+ *  @wwpn_prefix: the alternative WWPN prefix
+ *
+ *  This function will read the EEPROM from the alternative SAN MAC address
+ *  block to check the support for the alternative WWNN/WWPN prefix support.
+ **/
+void txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			  u16 *wwpn_prefix)
+{
+	u16 offset, caps, alt_san_mac_blk_offset;
+
+	/* clear output first */
+	*wwnn_prefix = 0xFFFF;
+	*wwpn_prefix = 0xFFFF;
+
+	/* check if alternative SAN MAC is supported */
+	offset = hw->eeprom.sw_region_offset + TXGBE_ALT_SAN_MAC_ADDR_BLK_PTR;
+	if (hw->eeprom.ops.read(hw, offset, &alt_san_mac_blk_offset))
+		goto wwn_prefix_err;
+
+	if (alt_san_mac_blk_offset == 0 ||
+	    alt_san_mac_blk_offset == 0xFFFF)
+		return;
+
+	/* check capability in alternative san mac address block */
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_CAPS_OFFSET;
+	if (hw->eeprom.ops.read(hw, offset, &caps))
+		goto wwn_prefix_err;
+	if (!(caps & TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN))
+		return;
+
+	/* get the corresponding prefix for WWNN/WWPN */
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_WWNN_OFFSET;
+	if (hw->eeprom.ops.read(hw, offset, wwnn_prefix))
+		txgbe_dbg(hw, "eeprom read at offset %d failed", offset);
+
+	offset = alt_san_mac_blk_offset + TXGBE_ALT_SAN_MAC_ADDR_WWPN_OFFSET;
+	if (hw->eeprom.ops.read(hw, offset, wwpn_prefix))
+		goto wwn_prefix_err;
+
+wwn_prefix_err:
+	txgbe_dbg(hw, "eeprom read at offset %d failed", offset);
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
+	u8 sum = 0;
+	u32 i;
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
+int txgbe_host_interface_command(struct txgbe_hw *hw, u32 *buffer,
+				 u32 length, u32 timeout, bool return_data)
+{
+	u32 hdr_size = sizeof(struct txgbe_hic_hdr);
+	u32 hicr, i, bi, buf[64] = {};
+	int status = 0;
+	u32 dword_len;
+	u16 buf_len;
+
+	if (length == 0 || length > TXGBE_HI_MAX_BLOCK_BYTE_LENGTH) {
+		txgbe_info(hw, "Buffer length failure buffersize=%d.\n", length);
+		return -EINVAL;
+	}
+
+	status = hw->mac.ops.acquire_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_MB);
+	if (status != 0)
+		return status;
+
+	/* Calculate length in DWORDs. We must be DWORD aligned */
+	if ((length % (sizeof(u32))) != 0) {
+		txgbe_info(hw, "Buffer length failure, not aligned to dword");
+		status = -EINVAL;
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
+			wr32a(hw, TXGBE_MNG_MBOX, i, (__force u32)cpu_to_le32(buffer[i]));
+			/* write flush */
+			buf[i] = rd32a(hw, TXGBE_MNG_MBOX, i);
+		} else {
+			status = -EIO;
+			goto rel_out;
+		}
+	}
+	/* Setting this bit tells the ARC that a new command is pending. */
+	if (txgbe_check_mng_access(hw)) {
+		wr32m(hw, TXGBE_MNG_MBOX_CTL,
+		      TXGBE_MNG_MBOX_CTL_SWRDY, TXGBE_MNG_MBOX_CTL_SWRDY);
+	} else {
+		status = -EIO;
+		goto rel_out;
+	}
+
+	for (i = 0; i < timeout; i++) {
+		if (txgbe_check_mng_access(hw)) {
+			hicr = rd32(hw, TXGBE_MNG_MBOX_CTL);
+			if ((hicr & TXGBE_MNG_MBOX_CTL_FWRDY))
+				break;
+		}
+		usleep_range(1000, 2000);
+	}
+
+	buf[0] = rd32(hw, TXGBE_MNG_MBOX);
+	if ((buf[0] & 0xff0000) >> 16 == 0x80) {
+		txgbe_dbg(hw, "It's unknown cmd.\n");
+		status = -EINVAL;
+		goto rel_out;
+	}
+	/* Check command completion */
+	if (timeout != 0 && i == timeout) {
+		txgbe_dbg(hw, "Command has failed with no status valid.\n");
+
+		txgbe_dbg(hw, "write value:\n");
+		for (i = 0; i < dword_len; i++)
+			txgbe_dbg(hw, "%x ", buffer[i]);
+		txgbe_dbg(hw, "read value:\n");
+		for (i = 0; i < dword_len; i++)
+			txgbe_dbg(hw, "%x ", buf[i]);
+		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
+			status = -EINVAL;
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
+			le32_to_cpus(&buffer[bi]);
+		} else {
+			status = -EIO;
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
+		txgbe_info(hw, "Buffer not large enough for reply message.\n");
+		status = -EFAULT;
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
+			le32_to_cpus(&buffer[bi]);
+		} else {
+			status = -EIO;
+			goto rel_out;
+		}
+	}
+
+rel_out:
+	hw->mac.ops.release_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_MB);
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
+int txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
+			 u8 build, u8 sub)
+{
+	struct txgbe_hic_drv_info fw_cmd;
+	int ret_val = 0;
+	int i;
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
+						       (FW_CEM_HDR_LEN + fw_cmd.hdr.buf_len));
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
+			ret_val = -EFAULT;
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
+int txgbe_reset_hostif(struct txgbe_hw *hw)
+{
+	struct txgbe_hic_reset reset_cmd;
+	int ret_val = 0;
+	int i;
+
+	reset_cmd.hdr.cmd = FW_RESET_CMD;
+	reset_cmd.hdr.buf_len = FW_RESET_LEN;
+	reset_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	reset_cmd.lan_id = hw->bus.lan_id;
+	reset_cmd.reset_type = (u16)hw->reset_type;
+	reset_cmd.hdr.checksum = 0;
+	reset_cmd.hdr.checksum = txgbe_calculate_checksum((u8 *)&reset_cmd,
+							  (FW_CEM_HDR_LEN +
+							   reset_cmd.hdr.buf_len));
+
+	for (i = 0; i <= FW_CEM_MAX_RETRIES; i++) {
+		ret_val = txgbe_host_interface_command(hw, (u32 *)&reset_cmd,
+						       sizeof(reset_cmd),
+						       TXGBE_HI_COMMAND_TIMEOUT,
+						       true);
+		if (ret_val != 0)
+			continue;
+
+		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
+		    FW_CEM_RESP_STATUS_SUCCESS)
+			ret_val = 0;
+		else
+			ret_val = -EFAULT;
+
+		break;
+	}
+
+	return ret_val;
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -472,6 +1070,26 @@ void txgbe_disable_rx(struct txgbe_hw *hw)
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
+	if (!txgbe_mng_present(hw))
+		return false;
+
+	return true;
+}
+
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 {
 	u32 i = 0, reg = 0;
@@ -506,6 +1124,7 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
  **/
 void txgbe_init_ops(struct txgbe_hw *hw)
 {
+	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
@@ -513,9 +1132,12 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.get_mac_addr = txgbe_get_mac_addr;
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync;
+	mac->ops.release_swfw_sync = txgbe_release_swfw_sync;
 	mac->ops.reset_hw = txgbe_reset_hw;
 	mac->ops.start_hw = txgbe_start_hw;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
+	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
 
 	/* RAR */
 	mac->ops.set_rar = txgbe_set_rar;
@@ -530,7 +1152,15 @@ void txgbe_init_ops(struct txgbe_hw *hw)
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
 	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh;
 }
 
@@ -594,14 +1224,21 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		return status;
 
-	if (hw->bus.lan_id == 0)
-		reset = TXGBE_MIS_RST_LAN0_RST;
-	else
-		reset = TXGBE_MIS_RST_LAN1_RST;
-
-	wr32(hw, TXGBE_MIS_RST,
-	     reset | rd32(hw, TXGBE_MIS_RST));
-	TXGBE_WRITE_FLUSH(hw);
+	if (txgbe_mng_present(hw)) {
+		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+			txgbe_reset_hostif(hw);
+		}
+	} else {
+		if (hw->bus.lan_id == 0)
+			reset = TXGBE_MIS_RST_LAN0_RST;
+		else
+			reset = TXGBE_MIS_RST_LAN1_RST;
+
+		wr32(hw, TXGBE_MIS_RST,
+		     reset | rd32(hw, TXGBE_MIS_RST));
+		TXGBE_WRITE_FLUSH(hw);
+	}
 	usleep_range(10, 100);
 
 	if (hw->bus.lan_id == 0)
@@ -640,6 +1277,10 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 		hw->mac.num_rar_entries--;
 	}
 
+	/* Store the alternative WWNN/WWPN prefix */
+	hw->mac.ops.get_wwn_prefix(hw, &hw->mac.wwnn_prefix,
+				   &hw->mac.wwpn_prefix);
+
 	pci_set_master(adapter->pdev);
 
 	return 0;
@@ -670,3 +1311,280 @@ void txgbe_start_hw(struct txgbe_hw *hw)
 	/* We need to run link autotry after the driver loads */
 	hw->mac.autotry_restart = true;
 }
+
+/**
+ *  txgbe_init_eeprom_params - Initialize EEPROM params
+ *  @hw: pointer to hardware structure
+ *
+ *  Initializes the EEPROM parameters txgbe_eeprom_info within the
+ *  txgbe_hw struct in order to set up EEPROM access.
+ **/
+void txgbe_init_eeprom_params(struct txgbe_hw *hw)
+{
+	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
+	u16 eeprom_size;
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
+			txgbe_dbg(hw, "Eeprom params: type = %d, size = %d\n",
+				  eeprom->type, eeprom->word_size);
+		}
+	}
+
+	if (hw->eeprom.ops.read(hw, TXGBE_SW_REGION_PTR, &data)) {
+		txgbe_info(hw, "NVM Read Error\n");
+		return;
+	}
+
+	eeprom->sw_region_offset = data >> 1;
+}
+
+/**
+ *  txgbe_read_ee_hostif_data - Read EEPROM word using a host interface cmd
+ *  assuming that the semaphore is already obtained.
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: word read from the EEPROM
+ *
+ *  Reads a 16 bit word from the EEPROM using the hostif.
+ **/
+int txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset,
+			      u16 *data)
+{
+	struct txgbe_hic_read_shadow_ram buffer;
+	s32 status;
+
+	buffer.hdr.req.cmd = FW_READ_SHADOW_RAM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = FW_READ_SHADOW_RAM_LEN;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* convert offset from words to bytes */
+	buffer.address = (__force u32)cpu_to_be32(offset * 2);
+	/* one word */
+	buffer.length = (__force u16)cpu_to_be16(sizeof(u16));
+
+	status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+					      sizeof(buffer),
+					      TXGBE_HI_COMMAND_TIMEOUT, false);
+
+	if (status != 0)
+		return status;
+	if (txgbe_check_mng_access(hw))
+		*data = (u16)rd32a(hw, TXGBE_MNG_MBOX, FW_NVM_DATA_OFFSET);
+	else
+		status = -EIO;
+
+	return status;
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
+int txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset,
+			 u16 *data)
+{
+	int status = 0;
+
+	status = hw->mac.ops.acquire_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	if (status == 0) {
+		status = txgbe_read_ee_hostif_data(hw, offset, data);
+		hw->mac.ops.release_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
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
+int txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
+				u16 offset, u16 words, u16 *data)
+{
+	struct txgbe_hic_read_shadow_ram buffer;
+	u32 current_word = 0;
+	u16 words_to_read;
+	u32 value = 0;
+	int status;
+	u32 i;
+
+	/* Take semaphore for the entire operation. */
+	status = hw->mac.ops.acquire_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	if (status != 0) {
+		txgbe_info(hw, "EEPROM read buffer - semaphore failed\n");
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
+		buffer.address = (__force u32)cpu_to_be32((offset + current_word) * 2);
+		buffer.length = (__force u16)cpu_to_be16(words_to_read * 2);
+
+		status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+						      sizeof(buffer),
+						      TXGBE_HI_COMMAND_TIMEOUT,
+						      false);
+
+		if (status != 0) {
+			txgbe_info(hw, "Host interface command failed\n");
+			goto out;
+		}
+
+		for (i = 0; i < words_to_read; i++) {
+			u32 reg = TXGBE_MNG_MBOX + (FW_NVM_DATA_OFFSET << 2) +
+				  2 * i;
+
+			if (txgbe_check_mng_access(hw))
+				value = rd32(hw, reg);
+			else
+				return -EIO;
+
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
+	hw->mac.ops.release_swfw_sync(hw, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	return status;
+}
+
+/**
+ *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
+ *  @hw: pointer to hardware structure
+ *  @checksum: pointer to cheksum
+ *
+ *  Returns a negative error code on error
+ **/
+int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
+{
+	u16 *eeprom_ptrs = NULL;
+	u32 buffer_size = 0;
+	u16 *buffer = NULL;
+	u16 *local_buffer;
+	int status;
+	u16 i;
+
+	hw->eeprom.ops.init_params(hw);
+
+	if (!buffer) {
+		eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
+					     GFP_KERNEL);
+		if (!eeprom_ptrs)
+			return -ENOMEM;
+		/* Read pointer area */
+		status = txgbe_read_ee_hostif_buffer(hw, 0,
+						     TXGBE_EEPROM_LAST_WORD,
+						     eeprom_ptrs);
+		if (status != 0) {
+			txgbe_info(hw, "Failed to read EEPROM image\n");
+			return status;
+		}
+		local_buffer = eeprom_ptrs;
+	} else {
+		if (buffer_size < TXGBE_EEPROM_LAST_WORD)
+			return -EFAULT;
+		local_buffer = buffer;
+	}
+
+	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
+		if (i != hw->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
+			*checksum += local_buffer[i];
+
+	*checksum = TXGBE_EEPROM_SUM - *checksum;
+	if (*checksum < 0)
+		return -EINVAL;
+
+	if (eeprom_ptrs)
+		kvfree(eeprom_ptrs);
+
+	return 0;
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
+int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
+				   u16 *checksum_val)
+{
+	u16 read_checksum = 0;
+	u16 checksum;
+	int status;
+
+	/* Read the first word from the EEPROM. If this times out or fails, do
+	 * not continue or we could be in for a very long wait while every
+	 * EEPROM read fails
+	 */
+	status = hw->eeprom.ops.read(hw, 0, &checksum);
+	if (status) {
+		txgbe_info(hw, "EEPROM read failed\n");
+		return status;
+	}
+
+	checksum = 0;
+	status = hw->eeprom.ops.calc_checksum(hw, &checksum);
+	if (status != 0)
+		return status;
+
+	status = hw->eeprom.ops.read(hw, hw->eeprom.sw_region_offset +
+				     TXGBE_EEPROM_CHECKSUM,
+				     &read_checksum);
+	if (status != 0)
+		return status;
+
+	/* Verify read checksum from EEPROM is the same as
+	 * calculated checksum
+	 */
+	if (read_checksum != checksum) {
+		status = -EIO;
+		txgbe_info(hw, "Invalid EEPROM checksum\n");
+	}
+
+	/* If the user cares, return the calculated checksum */
+	if (checksum_val)
+		*checksum_val = checksum;
+
+	return status;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 9d822ab5cc7e..7a37de43af62 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -18,6 +18,8 @@
 
 int txgbe_init_hw(struct txgbe_hw *hw);
 void txgbe_start_hw(struct txgbe_hw *hw);
+int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
+			  u32 pba_num_size);
 void txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
 void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
 int txgbe_stop_adapter(struct txgbe_hw *hw);
@@ -27,6 +29,8 @@ void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 void txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
 void txgbe_init_rx_addrs(struct txgbe_hw *hw);
 
+int txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask);
+void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask);
 int txgbe_disable_pcie_master(struct txgbe_hw *hw);
 
 void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
@@ -35,6 +39,19 @@ void txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
 void txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 void txgbe_init_uta_tables(struct txgbe_hw *hw);
 
+void txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			  u16 *wwpn_prefix);
+
+int txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
+			 u8 build, u8 ver);
+int txgbe_reset_hostif(struct txgbe_hw *hw);
+u8 txgbe_calculate_checksum(u8 *buffer, u32 length);
+int txgbe_host_interface_command(struct txgbe_hw *hw, u32 *buffer,
+				 u32 length, u32 timeout, bool return_data);
+
+bool txgbe_mng_present(struct txgbe_hw *hw);
+bool txgbe_check_mng_access(struct txgbe_hw *hw);
+
 void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
@@ -43,6 +60,15 @@ void txgbe_reset_misc(struct txgbe_hw *hw);
 int txgbe_reset_hw(struct txgbe_hw *hw);
 void txgbe_init_ops(struct txgbe_hw *hw);
 
+void txgbe_init_eeprom_params(struct txgbe_hw *hw);
+int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum);
+int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
+				   u16 *checksum_val);
+int txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
+				u16 offset, u16 words, u16 *data);
+int txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset, u16 *data);
+int txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset, u16 *data);
+
 int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
 int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 856f8fe4ac1b..c50c67a95974 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -70,6 +70,20 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
+static void txgbe_release_hw_control(struct txgbe_adapter *adapter)
+{
+	/* Let firmware take over control of hw */
+	wr32m(&adapter->hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_DRV_LOAD, 0);
+}
+
+static void txgbe_get_hw_control(struct txgbe_adapter *adapter)
+{
+	/* Let firmware know the driver has taken over */
+	wr32m(&adapter->hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_DRV_LOAD, TXGBE_CFG_PORT_CTL_DRV_LOAD);
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -155,6 +169,11 @@ int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
 	return -ENOMEM;
 }
 
+static void txgbe_up_complete(struct txgbe_adapter *adapter)
+{
+	txgbe_get_hw_control(adapter);
+}
+
 void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -277,8 +296,12 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
  **/
 int txgbe_open(struct net_device *netdev)
 {
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
 	netif_carrier_off(netdev);
 
+	txgbe_up_complete(adapter);
+
 	return 0;
 }
 
@@ -311,6 +334,8 @@ int txgbe_close(struct net_device *netdev)
 
 	txgbe_down(adapter);
 
+	txgbe_release_hw_control(adapter);
+
 	return 0;
 }
 
@@ -326,6 +351,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		txgbe_close_suspend(adapter);
 	rtnl_unlock();
 
+	txgbe_release_hw_control(adapter);
+
 	pci_disable_device(pdev);
 }
 
@@ -443,6 +470,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	int err, expected_gts;
 
+	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
+	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
+	u16 build = 0, major = 0, patch = 0;
+	u8 part_str[TXGBE_PBANUM_LENGTH];
+	u32 etrack_id = 0;
+
 	err = pci_enable_device_mem(pdev);
 	if (err)
 		return err;
@@ -518,6 +551,15 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	/* make sure the EEPROM is good */
+	err = hw->eeprom.ops.validate_checksum(hw, NULL);
+	if (err != 0) {
+		dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
+		wr32(hw, TXGBE_MIS_RST, TXGBE_MIS_RST_SW_RST);
+		err = -EIO;
+		goto err_free_mac_table;
+	}
+
 	eth_hw_addr_set(netdev, hw->mac.perm_addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
@@ -528,12 +570,50 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	txgbe_mac_set_default_filter(adapter, hw->mac.perm_addr);
 
+	/* Save off EEPROM version number and Option Rom version which
+	 * together make a unique identify for the eeprom
+	 */
+	hw->eeprom.ops.read(hw,
+			    hw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_H,
+			    &eeprom_verh);
+	hw->eeprom.ops.read(hw,
+			    hw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_L,
+			    &eeprom_verl);
+	etrack_id = (eeprom_verh << 16) | eeprom_verl;
+
+	hw->eeprom.ops.read(hw,
+			    hw->eeprom.sw_region_offset + TXGBE_ISCSI_BOOT_CONFIG,
+			    &offset);
+
+	/* Make sure offset to SCSI block is valid */
+	if (!(offset == 0x0) && !(offset == 0xffff)) {
+		hw->eeprom.ops.read(hw, offset + 0x84, &eeprom_cfg_blkh);
+		hw->eeprom.ops.read(hw, offset + 0x83, &eeprom_cfg_blkl);
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
 	hw->mac.ops.start_hw(hw);
 
 	strcpy(netdev->name, "eth%d");
 	err = register_netdev(netdev);
 	if (err)
-		goto err_free_mac_table;
+		goto err_release_hw;
 
 	pci_set_drvdata(pdev, adapter);
 	adapter->netdev_registered = true;
@@ -555,11 +635,19 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	/* First try to read PBA as a string */
+	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
+	if (err)
+		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
+
 	netif_info(adapter, probe, netdev, "%02x:%02x:%02x:%02x:%02x:%02x\n",
 		   netdev->dev_addr[0], netdev->dev_addr[1],
 		   netdev->dev_addr[2], netdev->dev_addr[3],
 		   netdev->dev_addr[4], netdev->dev_addr[5]);
 
+	/* firmware requires blank driver version */
+	hw->mac.ops.set_fw_drv_ver(hw, 0xFF, 0xFF, 0xFF, 0xFF);
+
 	/* add san mac addr to netdev */
 	err = txgbe_add_sanmac_netdev(netdev);
 	if (err)
@@ -567,6 +655,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_release_hw:
+	txgbe_release_hw_control(adapter);
 err_free_mac_table:
 	kfree(adapter->mac_table);
 err_pci_release_regions:
@@ -602,6 +692,8 @@ static void txgbe_remove(struct pci_dev *pdev)
 		adapter->netdev_registered = false;
 	}
 
+	txgbe_release_hw_control(adapter);
+
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index b237a69e15ce..2fe848a33892 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -290,6 +290,30 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_CTL  0x15CFC
+/************************************** MNG ********************************/
+#define TXGBE_MNG_FW_SM         0x1E000
+#define TXGBE_MNG_SW_SM         0x1E004
+#define TXGBE_MNG_SWFW_SYNC     0x1E008
+#define TXGBE_MNG_MBOX          0x1E100
+#define TXGBE_MNG_MBOX_CTL      0x1E044
+#define TXGBE_MNG_OS2BMC_CNT    0x1E094
+#define TXGBE_MNG_BMC2OS_CNT    0x1E090
+
+/* Firmware Semaphore Register */
+#define TXGBE_MNG_FW_SM_MODE_MASK       0xE
+#define TXGBE_MNG_FW_SM_TS_ENABLED      0x1
+/* SW Semaphore Register bitmasks */
+#define TXGBE_MNG_SW_SM_SM              0x00000001U /* software Semaphore */
+
+/* SW_FW_SYNC definitions */
+#define TXGBE_MNG_SWFW_SYNC_SW_PHY      0x0001
+#define TXGBE_MNG_SWFW_SYNC_SW_FLASH    0x0008
+#define TXGBE_MNG_SWFW_SYNC_SW_MB       0x0004
+
+#define TXGBE_MNG_MBOX_CTL_SWRDY        0x1
+#define TXGBE_MNG_MBOX_CTL_SWACK        0x2
+#define TXGBE_MNG_MBOX_CTL_FWRDY        0x4
+#define TXGBE_MNG_MBOX_CTL_FWACK        0x8
 
 /************************************* ETH MAC *****************************/
 #define TXGBE_MAC_TX_CFG                0x11000
@@ -400,10 +424,125 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PX_RR_CFG_RR_SZ           0x0000007EU
 #define TXGBE_PX_RR_CFG_RR_EN           0x00000001U
 
+/* Part Number String Length */
+#define TXGBE_PBANUM_LENGTH     32
+
+/* Checksum and EEPROM pointers */
+#define TXGBE_PBANUM_PTR_GUARD          0xFAFA
+#define TXGBE_EEPROM_CHECKSUM           0x2F
+#define TXGBE_EEPROM_SUM                0xBABA
+#define TXGBE_EEPROM_LAST_WORD          0x800
+#define TXGBE_FW_PTR                    0x0F
+#define TXGBE_PBANUM0_PTR               0x05
+#define TXGBE_PBANUM1_PTR               0x06
+#define TXGBE_SW_REGION_PTR             0x1C
+
+#define TXGBE_SAN_MAC_ADDR_PTR          0x18
+#define TXGBE_DEVICE_CAPS               0x1C
+#define TXGBE_EEPROM_VERSION_L          0x1D
+#define TXGBE_EEPROM_VERSION_H          0x1E
+#define TXGBE_ISCSI_BOOT_CONFIG         0x07
+
+#define TXGBE_SERIAL_NUMBER_MAC_ADDR    0x11
+
 #define TXGBE_ETH_LENGTH_OF_ADDRESS     6
 
+#define TXGBE_SAN_MAC_ADDR_PORT0_OFFSET         0x0
+#define TXGBE_SAN_MAC_ADDR_PORT1_OFFSET         0x3
+#define TXGBE_ALT_SAN_MAC_ADDR_BLK_PTR          0x17 /* Alt. SAN MAC block */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_OFFSET      0x0 /* Alt SAN MAC capability */
+#define TXGBE_ALT_SAN_MAC_ADDR_PORT0_OFFSET     0x1 /* Alt SAN MAC 0 offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_PORT1_OFFSET     0x4 /* Alt SAN MAC 1 offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_WWNN_OFFSET      0x7 /* Alt WWNN prefix offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_WWPN_OFFSET      0x8 /* Alt WWPN prefix offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_SANMAC      0x0 /* Alt SAN MAC exists */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN      0x1 /* Alt WWN base exists */
+
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
 /* Number of 80 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        80000
+enum txgbe_eeprom_type {
+	txgbe_eeprom_uninitialized = 0,
+	txgbe_eeprom_spi,
+	txgbe_flash,
+	txgbe_eeprom_none /* No NVM support */
+};
 
 struct txgbe_addr_filter_info {
 	u32 num_mc_addrs;
@@ -422,14 +561,28 @@ struct txgbe_bus_info {
 /* forward declaration */
 struct txgbe_hw;
 
+/* Function pointer table */
+struct txgbe_eeprom_operations {
+	void (*init_params)(struct txgbe_hw *hw);
+	int (*read)(struct txgbe_hw *hw, u16 offset, u16 *data);
+	int (*read_buffer)(struct txgbe_hw *hw,
+			   u16 offset, u16 words, u16 *data);
+	int (*validate_checksum)(struct txgbe_hw *hw, u16 *checksum_val);
+	int (*calc_checksum)(struct txgbe_hw *hw, u16 *checksum);
+};
+
 struct txgbe_mac_operations {
 	int (*init_hw)(struct txgbe_hw *hw);
 	int (*reset_hw)(struct txgbe_hw *hw);
 	void (*start_hw)(struct txgbe_hw *hw);
 	void (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
 	void (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
+	void (*get_wwn_prefix)(struct txgbe_hw *hw, u16 *wwnn_prefix,
+			       u16 *wwpn_prefix);
 	int (*stop_adapter)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
+	int (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
+	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
 	/* RAR */
 	void (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
@@ -442,14 +595,28 @@ struct txgbe_mac_operations {
 	void (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
+	int (*set_fw_drv_ver)(struct txgbe_hw *hw, u8 maj, u8 min,
+			      u8 build, u8 ver);
 	void (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
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
@@ -461,10 +628,17 @@ struct txgbe_mac_info {
 	bool set_lben;
 };
 
+enum txgbe_reset_type {
+	TXGBE_LAN_RESET = 0,
+	TXGBE_SW_RESET,
+	TXGBE_GLOBAL_RESET
+};
+
 struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	struct txgbe_mac_info mac;
 	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_eeprom_info eeprom;
 	struct txgbe_bus_info bus;
 	u16 device_id;
 	u16 vendor_id;
@@ -472,6 +646,7 @@ struct txgbe_hw {
 	u16 subsystem_vendor_id;
 	u8 revision_id;
 	bool adapter_stopped;
+	enum txgbe_reset_type reset_type;
 	u16 oem_ssid;
 	u16 oem_svid;
 };
@@ -482,6 +657,11 @@ struct txgbe_hw {
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
 
+#define rd32a(a, reg, offset) ( \
+	rd32((a), (reg) + ((offset) << 2)))
+#define wr32a(a, reg, off, val) \
+	wr32((a), (reg) + ((off) << 2), (val))
+
 static inline u32
 rd32m(struct txgbe_hw *hw, u32 reg, u32 mask)
 {
-- 
2.27.0

