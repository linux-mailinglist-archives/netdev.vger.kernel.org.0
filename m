Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8A613115
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJaHJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJaHJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:09:38 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6535BB7E2
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 00:09:36 -0700 (PDT)
X-QQ-mid: bizesmtp69t1667200104t769aiv1
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 31 Oct 2022 15:08:22 +0800 (CST)
X-QQ-SSF: 01400000000000M0L000000A0000000
X-QQ-FEAT: 5BP7ZNt7eRwy01y+nZcV8CS0eSz6JzymLcR5f4NBTn4z7eiq8/Ro9dPMuAd5C
        FGjhIQDCr4WCBT2idPV5hFkCcNWbw+2Zz0ksIaEx6yTPYrSb8zzxC7+/dDP8qdkNrXXs6NX
        9Kx4sAfH2HZcLgXIAzJuMMWxOAaqrJhoEGDMkT3iv1RH/MH3pMm/vg09JXHCW6AOSs+5t/x
        jrOaGvcDgiSudrur4Q0nagwMzf72K+cT0E8cfHDtCep3zCzd4WR6JbnzQj6tASibHAPb7+l
        EHblCTc/kq/0B4H3OfhCOZf9U2BFHxXk71z72Hbxc1GginzxCobVKyVhMT6tOJ4f17hAA5W
        nYsPufoH4RcqxdefvIErtW1TiXKampvXgWAloEOvoRZgAFBiT0rvibjUH24uAaDTrIXt9o3
        cZYDaXDjSadk4iIoRw3lhg==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: [PATCH net-next 2/3] net: txgbe: Add operations to interact with firmware
Date:   Mon, 31 Oct 2022 15:07:56 +0800
Message-Id: <20221031070757.982-3-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070757.982-1-mengyuanlou@net-swift.com>
References: <20221031070757.982-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiawen Wu <jiawenwu@trustnetic.com>

Add firmware interaction to get EEPROM information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 219 +++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   2 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  85 ++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  14 ++
 5 files changed, 316 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 52e350f9a7d9..19e61377bd00 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -35,6 +35,7 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 	struct txgbe_mac_addr *mac_table;
+	char eeprom_id[32];
 };
 
 extern char txgbe_driver_name[];
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index c7c92c0ec561..0b1032195859 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -44,6 +44,218 @@ static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
 	wr32(wxhw, WX_TS_DALARM_THRE, 614);
 }
 
+/**
+ *  txgbe_read_pba_string - Reads part number string from EEPROM
+ *  @hw: pointer to hardware structure
+ *  @pba_num: stores the part number string from the EEPROM
+ *  @pba_num_size: part number string buffer length
+ *
+ *  Reads the part number string from the EEPROM.
+ **/
+int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size)
+{
+	u16 pba_ptr, offset, length, data;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int ret_val;
+
+	if (!pba_num) {
+		wx_err(wxhw, "PBA string buffer was null\n");
+		return -EINVAL;
+	}
+
+	ret_val = wx_read_ee_hostif(wxhw,
+				    wxhw->eeprom.sw_region_offset + TXGBE_PBANUM0_PTR,
+				    &data);
+	if (ret_val != 0) {
+		wx_err(wxhw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	ret_val = wx_read_ee_hostif(wxhw,
+				    wxhw->eeprom.sw_region_offset + TXGBE_PBANUM1_PTR,
+				    &pba_ptr);
+	if (ret_val != 0) {
+		wx_err(wxhw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	/* if data is not ptr guard the PBA must be in legacy format which
+	 * means pba_ptr is actually our second data word for the PBA number
+	 * and we can decode it into an ascii string
+	 */
+	if (data != TXGBE_PBANUM_PTR_GUARD) {
+		wx_err(wxhw, "NVM PBA number is not stored as string\n");
+
+		/* we will need 11 characters to store the PBA */
+		if (pba_num_size < 11) {
+			wx_err(wxhw, "PBA string buffer too small\n");
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
+	ret_val = wx_read_ee_hostif(wxhw, pba_ptr, &length);
+	if (ret_val != 0) {
+		wx_err(wxhw, "NVM Read Error\n");
+		return ret_val;
+	}
+
+	if (length == 0xFFFF || length == 0) {
+		wx_err(wxhw, "NVM PBA number section invalid length\n");
+		return -EINVAL;
+	}
+
+	/* check if pba_num buffer is big enough */
+	if (pba_num_size  < (((u32)length * 2) - 1)) {
+		wx_err(wxhw, "PBA string buffer too small\n");
+		return -ENOMEM;
+	}
+
+	/* trim pba length from start of string */
+	pba_ptr++;
+	length--;
+
+	for (offset = 0; offset < length; offset++) {
+		ret_val = wx_read_ee_hostif(wxhw, pba_ptr + offset, &data);
+		if (ret_val != 0) {
+			wx_err(wxhw, "NVM Read Error\n");
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
+/**
+ *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
+ *  @hw: pointer to hardware structure
+ *  @checksum: pointer to cheksum
+ *
+ *  Returns a negative error code on error
+ **/
+static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u16 *eeprom_ptrs = NULL;
+	u32 buffer_size = 0;
+	u16 *buffer = NULL;
+	u16 *local_buffer;
+	int status;
+	u16 i;
+
+	wx_init_eeprom_params(wxhw);
+
+	if (!buffer) {
+		eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
+					     GFP_KERNEL);
+		if (!eeprom_ptrs)
+			return -ENOMEM;
+		/* Read pointer area */
+		status = wx_read_ee_hostif_buffer(wxhw, 0,
+						  TXGBE_EEPROM_LAST_WORD,
+						  eeprom_ptrs);
+		if (status != 0) {
+			wx_err(wxhw, "Failed to read EEPROM image\n");
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
+		if (i != wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
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
+int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u16 read_checksum = 0;
+	u16 checksum;
+	int status;
+
+	/* Read the first word from the EEPROM. If this times out or fails, do
+	 * not continue or we could be in for a very long wait while every
+	 * EEPROM read fails
+	 */
+	status = wx_read_ee_hostif(wxhw, 0, &checksum);
+	if (status) {
+		wx_err(wxhw, "EEPROM read failed\n");
+		return status;
+	}
+
+	checksum = 0;
+	status = txgbe_calc_eeprom_checksum(hw, &checksum);
+	if (status != 0)
+		return status;
+
+	status = wx_read_ee_hostif(wxhw, wxhw->eeprom.sw_region_offset +
+				   TXGBE_EEPROM_CHECKSUM, &read_checksum);
+	if (status != 0)
+		return status;
+
+	/* Verify read checksum from EEPROM is the same as
+	 * calculated checksum
+	 */
+	if (read_checksum != checksum) {
+		status = -EIO;
+		wx_err(wxhw, "Invalid EEPROM checksum\n");
+	}
+
+	/* If the user cares, return the calculated checksum */
+	if (checksum_val)
+		*checksum_val = checksum;
+
+	return status;
+}
+
 static void txgbe_reset_misc(struct txgbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
@@ -63,7 +275,6 @@ static void txgbe_reset_misc(struct txgbe_hw *hw)
 int txgbe_reset_hw(struct txgbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
-	u32 reset = 0;
 	int status;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
@@ -71,10 +282,10 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		return status;
 
-	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
-	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
+	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP)))
+		wx_reset_hostif(wxhw);
 
-	WX_WRITE_FLUSH(wxhw);
 	usleep_range(10, 100);
 
 	status = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_LAN_SW_RST(wxhw->bus.func));
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 155f18ea4b8c..6a751a69177b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,6 +4,8 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
+int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size);
+int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val);
 int txgbe_reset_hw(struct txgbe_hw *hw);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index adfa4e7d0d52..36780e7f05b7 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -158,6 +158,14 @@ static int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 poo
 	return -ENOMEM;
 }
 
+static void txgbe_up_complete(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wx_control_hw(wxhw, true);
+}
+
 static void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -270,6 +278,10 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
  **/
 static int txgbe_open(struct net_device *netdev)
 {
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	txgbe_up_complete(adapter);
+
 	return 0;
 }
 
@@ -301,6 +313,7 @@ static int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
+	wx_control_hw(&adapter->hw.wxhw, false);
 
 	return 0;
 }
@@ -309,6 +322,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
 
 	netif_device_detach(netdev);
 
@@ -317,6 +332,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		txgbe_close_suspend(adapter);
 	rtnl_unlock();
 
+	wx_control_hw(wxhw, false);
+
 	pci_disable_device(pdev);
 }
 
@@ -393,6 +410,12 @@ static int txgbe_probe(struct pci_dev *pdev,
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
@@ -457,6 +480,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_free_mac_table;
 
+	err = wx_mng_present(wxhw);
+	if (err) {
+		dev_err(&pdev->dev, "Management capability is not present\n");
+		goto err_free_mac_table;
+	}
+
 	err = txgbe_reset_hw(hw);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
@@ -465,12 +494,59 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	/* make sure the EEPROM is good */
+	err = txgbe_validate_eeprom_checksum(hw, NULL);
+	if (err != 0) {
+		dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
+		wr32(wxhw, WX_MIS_RST, WX_MIS_RST_SW_RST);
+		err = -EIO;
+		goto err_free_mac_table;
+	}
+
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
 	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
 
+	/* Save off EEPROM version number and Option Rom version which
+	 * together make a unique identify for the eeprom
+	 */
+	wx_read_ee_hostif(wxhw,
+			  wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_H,
+			  &eeprom_verh);
+	wx_read_ee_hostif(wxhw,
+			  wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_L,
+			  &eeprom_verl);
+	etrack_id = (eeprom_verh << 16) | eeprom_verl;
+
+	wx_read_ee_hostif(wxhw,
+			  wxhw->eeprom.sw_region_offset + TXGBE_ISCSI_BOOT_CONFIG,
+			  &offset);
+
+	/* Make sure offset to SCSI block is valid */
+	if (!(offset == 0x0) && !(offset == 0xffff)) {
+		wx_read_ee_hostif(wxhw, offset + 0x84, &eeprom_cfg_blkh);
+		wx_read_ee_hostif(wxhw, offset + 0x83, &eeprom_cfg_blkl);
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
 	err = register_netdev(netdev);
 	if (err)
-		goto err_free_mac_table;
+		goto err_release_hw;
 
 	pci_set_drvdata(pdev, adapter);
 
@@ -488,10 +564,17 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	/* First try to read PBA as a string */
+	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
+	if (err)
+		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
+
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
 
+err_release_hw:
+	wx_control_hw(wxhw, false);
 err_free_mac_table:
 	kfree(adapter->mac_table);
 err_pci_release_regions:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 4082d3b76709..740a1c447e20 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -53,6 +53,20 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/* Part Number String Length */
+#define TXGBE_PBANUM_LENGTH                     32
+
+/* Checksum and EEPROM pointers */
+#define TXGBE_EEPROM_LAST_WORD                  0x800
+#define TXGBE_EEPROM_CHECKSUM                   0x2F
+#define TXGBE_EEPROM_SUM                        0xBABA
+#define TXGBE_EEPROM_VERSION_L                  0x1D
+#define TXGBE_EEPROM_VERSION_H                  0x1E
+#define TXGBE_ISCSI_BOOT_CONFIG                 0x07
+#define TXGBE_PBANUM0_PTR                       0x05
+#define TXGBE_PBANUM1_PTR                       0x06
+#define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
+
 struct txgbe_hw {
 	struct wx_hw wxhw;
 };
-- 
2.38.1

