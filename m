Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1405A5C6E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiH3HF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiH3HFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:41 -0400
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88AA8275E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:34 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843127tickb27e
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:27 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: 8l1XDVMHwbjbVgf0HsdI0wodyEhs9h/hcHYljtHx/M+7gBvysvmSOrzqCVL1v
        DS9TCKad42pSeshqYx7HIrymtPGxK0OTbT4fS6iWkHfltdxiLj9xk/rHKlx/UVJrqBVaswk
        wGpby64gCwegor563q1+pWX95gHpyT6ENqozeDpitIJlcq+FoYEVK6y6m5qXizDex/DRO7x
        sCzDujg1ylvXPEKK/puevjh39HAGzOV2BZD22tUXaWDsk6CXF28y9FgJ4OK9hoDuMx9TL72
        TAaFx14GTF6m4XUcnhoKKn2cjlNNNz5AMCVH/MR/zb7+wzhSpfaM67Rad0LLxFXkoZyR3FJ
        /RQEN6zj1wWejItvSiS0vWhCZm/dZK/0qYfDvcD7xf5Ri5KUX8cuccn7+PtP4Mh/UdxCtdd
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 03/16] net: txgbe: Set MAC address and register netdev
Date:   Tue, 30 Aug 2022 15:04:41 +0800
Message-Id: <20220830070454.146211-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MAC address related operations, and register netdev.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  39 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  52 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 338 +++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  14 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 351 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  63 ++++
 6 files changed, 853 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 42ffe70a6e4e..f0c9d3055d5b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -4,13 +4,30 @@
 #ifndef _TXGBE_H_
 #define _TXGBE_H_
 
+#include <net/ip.h>
+#include <linux/etherdevice.h>
+
 #include "txgbe_type.h"
 
+struct txgbe_ring {
+	u8 reg_idx;
+} ____cacheline_internodealigned_in_smp;
+
 #define TXGBE_MAX_FDIR_INDICES          63
 
 #define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+struct txgbe_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u64 pools;
+};
+
+#define TXGBE_MAC_STATE_DEFAULT         0x1
+#define TXGBE_MAC_STATE_MODIFIED        0x2
+#define TXGBE_MAC_STATE_IN_USE          0x4
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -18,11 +35,33 @@ struct txgbe_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
+	/* Tx fast path data */
+	int num_tx_queues;
+
+	/* TX */
+	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
+
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
+
+	bool netdev_registered;
+
+	struct txgbe_mac_addr *mac_table;
+
 };
 
+/* needed by txgbe_main.c */
+void txgbe_assign_netdev_ops(struct net_device *netdev);
+
+int txgbe_open(struct net_device *netdev);
+int txgbe_close(struct net_device *netdev);
+void txgbe_down(struct txgbe_adapter *adapter);
+void txgbe_reset(struct txgbe_adapter *adapter);
+void txgbe_disable_device(struct txgbe_adapter *adapter);
+
+int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
+
 #define TXGBE_INTR_ALL (~0ULL)
 
 static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 9b87bca57324..a6eacace3c6a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -19,6 +19,15 @@
 #define TUP4 TUP(p4)
 
 /* struct txgbe_mac_operations */
+static int txgbe_init_hw_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
+static void txgbe_get_mac_addr_dummy(struct txgbe_hw *TUP0, u8 *TUP1)
+{
+}
+
 static int txgbe_stop_adapter_dummy(struct txgbe_hw *TUP0)
 {
 	return -EPERM;
@@ -33,10 +42,43 @@ static int txgbe_reset_hw_dummy(struct txgbe_hw *TUP0)
 	return -EPERM;
 }
 
+static void txgbe_start_hw_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_get_san_mac_addr_dummy(struct txgbe_hw *TUP0, u8 *TUP1)
+{
+}
+
+static void txgbe_set_rar_dummy(struct txgbe_hw *TUP0, u32 TUP1,
+				u8 *TUP2, u64 TUP3, u32 TUP4)
+{
+}
+
+static void txgbe_clear_rar_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+}
+
+static void txgbe_init_rx_addrs_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_clear_vmdq_dummy(struct txgbe_hw *TUP0, u32 TUP1, u32 TUP2)
+{
+}
+
 static void txgbe_disable_rx_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static void txgbe_set_vmdq_san_mac_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+}
+
+static void txgbe_init_uta_tables_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 static void txgbe_init_thermal_sensor_thresh_dummy(struct txgbe_hw *TUP0)
 {
 }
@@ -46,12 +88,22 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.init_hw = txgbe_init_hw_dummy;
+	mac->ops.get_mac_addr = txgbe_get_mac_addr_dummy;
 	mac->ops.stop_adapter = txgbe_stop_adapter_dummy;
 	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;
 	mac->ops.reset_hw = txgbe_reset_hw_dummy;
+	mac->ops.start_hw = txgbe_start_hw_dummy;
+	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr_dummy;
 
 	/* RAR */
+	mac->ops.set_rar = txgbe_set_rar_dummy;
+	mac->ops.clear_rar = txgbe_clear_rar_dummy;
+	mac->ops.init_rx_addrs = txgbe_init_rx_addrs_dummy;
+	mac->ops.clear_vmdq = txgbe_clear_vmdq_dummy;
 	mac->ops.disable_rx = txgbe_disable_rx_dummy;
+	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac_dummy;
+	mac->ops.init_uta_tables = txgbe_init_uta_tables_dummy;
 
 	/* Manageability interface */
 	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh_dummy;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 15ecba51a678..2a0e2ef9678c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -7,6 +7,48 @@
 
 #define TXGBE_SP_MAX_TX_QUEUES  128
 #define TXGBE_SP_MAX_RX_QUEUES  128
+#define TXGBE_SP_RAR_ENTRIES    128
+
+int txgbe_init_hw(struct txgbe_hw *hw)
+{
+	int status;
+
+	/* Reset the hardware */
+	status = hw->mac.ops.reset_hw(hw);
+
+	if (status == 0) {
+		/* Start the HW */
+		hw->mac.ops.start_hw(hw);
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_get_mac_addr - Generic get MAC address
+ *  @hw: pointer to hardware structure
+ *  @mac_addr: Adapter MAC address
+ *
+ *  Reads the adapter's MAC address from first Receive Address Register (RAR0)
+ *  A reset of the adapter must be performed prior to calling this function
+ *  in order for the MAC address to have been loaded from the EEPROM into RAR0
+ **/
+void txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr)
+{
+	u32 rar_high;
+	u32 rar_low;
+	u16 i;
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, 0);
+	rar_high = rd32(hw, TXGBE_PSR_MAC_SWC_AD_H);
+	rar_low = rd32(hw, TXGBE_PSR_MAC_SWC_AD_L);
+
+	for (i = 0; i < 2; i++)
+		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
+
+	for (i = 0; i < 4; i++)
+		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
+}
 
 /**
  *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
@@ -81,6 +123,158 @@ int txgbe_stop_adapter(struct txgbe_hw *hw)
 	return txgbe_disable_pcie_master(hw);
 }
 
+/**
+ *  txgbe_set_rar - Set Rx address register
+ *  @hw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *  @addr: Address to put into receive address register
+ *  @pools: VMDq "set" or "pool" index
+ *  @enable_addr: set flag that address is active
+ *
+ *  Puts an ethernet address into a receive address register.
+ **/
+void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		   u32 enable_addr)
+{
+	u32 rar_entries = hw->mac.num_rar_entries;
+	u32 rar_low, rar_high;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		txgbe_info(hw, "RAR index %d is out of range.\n", index);
+		return;
+	}
+
+	/* select the MAC address */
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, index);
+
+	/* setup VMDq pool mapping */
+	wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
+	wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, pools >> 32);
+
+	/* HW expects these in little endian so we reverse the byte
+	 * order from network order (big endian) to little endian
+	 *
+	 * Some parts put the VMDq setting in the extra RAH bits,
+	 * so save everything except the lower 16 bits that hold part
+	 * of the address and the address valid bit.
+	 */
+	rar_low = ((u32)addr[5] |
+		  ((u32)addr[4] << 8) |
+		  ((u32)addr[3] << 16) |
+		  ((u32)addr[2] << 24));
+	rar_high = ((u32)addr[1] |
+		   ((u32)addr[0] << 8));
+	if (enable_addr != 0)
+		rar_high |= TXGBE_PSR_MAC_SWC_AD_H_AV;
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_AD_L, rar_low);
+	wr32m(hw, TXGBE_PSR_MAC_SWC_AD_H,
+	      (TXGBE_PSR_MAC_SWC_AD_H_AD(~0) |
+	       TXGBE_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	       TXGBE_PSR_MAC_SWC_AD_H_AV),
+	      rar_high);
+}
+
+/**
+ *  txgbe_clear_rar - Remove Rx address register
+ *  @hw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *
+ *  Clears an ethernet address from a receive address register.
+ **/
+void txgbe_clear_rar(struct txgbe_hw *hw, u32 index)
+{
+	u32 rar_entries = hw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		txgbe_info(hw, "RAR index %d is out of range.\n", index);
+		return;
+	}
+
+	/* Some parts put the VMDq setting in the extra RAH bits,
+	 * so save everything except the lower 16 bits that hold part
+	 * of the address and the address valid bit.
+	 */
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, index);
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, 0);
+	wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, 0);
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_AD_L, 0);
+	wr32m(hw, TXGBE_PSR_MAC_SWC_AD_H,
+	      (TXGBE_PSR_MAC_SWC_AD_H_AD(~0) |
+	       TXGBE_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	       TXGBE_PSR_MAC_SWC_AD_H_AV),
+	      0);
+}
+
+/**
+ *  txgbe_init_rx_addrs - Initializes receive address filters.
+ *  @hw: pointer to hardware structure
+ *
+ *  Places the MAC address in receive address register 0 and clears the rest
+ *  of the receive address registers. Clears the multicast table. Assumes
+ *  the receiver is in reset when the routine is called.
+ **/
+void txgbe_init_rx_addrs(struct txgbe_hw *hw)
+{
+	u32 rar_entries = hw->mac.num_rar_entries;
+	u32 psrctl;
+	u32 i;
+
+	/* If the current mac address is valid, assume it is a software override
+	 * to the permanent address.
+	 * Otherwise, use the permanent address from the eeprom.
+	 */
+	if (!is_valid_ether_addr(hw->mac.addr)) {
+		/* Get the MAC address from the RAR0 for later reference */
+		hw->mac.ops.get_mac_addr(hw, hw->mac.addr);
+
+		txgbe_dbg(hw, "Keeping Current RAR0 Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
+			  hw->mac.addr[0], hw->mac.addr[1],
+			  hw->mac.addr[2], hw->mac.addr[3],
+			  hw->mac.addr[4], hw->mac.addr[5]);
+	} else {
+		/* Setup the receive address. */
+		txgbe_dbg(hw, "Overriding MAC Address in RAR[0]\n");
+		txgbe_dbg(hw, "New MAC Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
+			  hw->mac.addr[0], hw->mac.addr[1],
+			  hw->mac.addr[2], hw->mac.addr[3],
+			  hw->mac.addr[4], hw->mac.addr[5]);
+
+		hw->mac.ops.set_rar(hw, 0, hw->mac.addr, 0,
+				    TXGBE_PSR_MAC_SWC_AD_H_AV);
+
+		/* clear VMDq pool/queue selection for RAR 0 */
+		hw->mac.ops.clear_vmdq(hw, 0, TXGBE_CLEAR_VMDQ_ALL);
+	}
+	hw->addr_ctrl.overflow_promisc = 0;
+
+	hw->addr_ctrl.rar_used_count = 1;
+
+	/* Zero out the other receive addresses. */
+	txgbe_dbg(hw, "Clearing RAR[1-%d]\n", rar_entries - 1);
+	for (i = 1; i < rar_entries; i++) {
+		wr32(hw, TXGBE_PSR_MAC_SWC_IDX, i);
+		wr32(hw, TXGBE_PSR_MAC_SWC_AD_L, 0);
+		wr32(hw, TXGBE_PSR_MAC_SWC_AD_H, 0);
+	}
+
+	/* Clear the MTA */
+	hw->addr_ctrl.mta_in_use = 0;
+	psrctl = rd32(hw, TXGBE_PSR_CTL);
+	psrctl &= ~(TXGBE_PSR_CTL_MO | TXGBE_PSR_CTL_MFE);
+	psrctl |= hw->mac.mc_filter_type << TXGBE_PSR_CTL_MO_SHIFT;
+	wr32(hw, TXGBE_PSR_CTL, psrctl);
+	txgbe_dbg(hw, " Clearing MTA\n");
+	for (i = 0; i < hw->mac.mcft_size; i++)
+		wr32(hw, TXGBE_PSR_MC_TBL(i), 0);
+
+	hw->mac.ops.init_uta_tables(hw);
+}
+
 /**
  *  txgbe_disable_pcie_master - Disable PCI-express master access
  *  @hw: pointer to hardware structure
@@ -114,6 +308,86 @@ int txgbe_disable_pcie_master(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_get_san_mac_addr - SAN MAC address retrieval from the EEPROM
+ *  @hw: pointer to hardware structure
+ *  @san_mac_addr: SAN MAC address
+ *
+ *  Reads the SAN MAC address.
+ **/
+void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr)
+{
+	u8 i;
+
+	/* No addresses available in this EEPROM.  It's not an
+	 * error though, so just wipe the local address and return.
+	 */
+	for (i = 0; i < 6; i++)
+		san_mac_addr[i] = 0xFF;
+}
+
+/**
+ *  txgbe_clear_vmdq - Disassociate a VMDq pool index from a rx address
+ *  @hw: pointer to hardware struct
+ *  @rar: receive address register index to disassociate
+ *  @vmdq: VMDq pool index to remove from the rar
+ **/
+void txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 __maybe_unused vmdq)
+{
+	u32 rar_entries = hw->mac.num_rar_entries;
+	u32 mpsar_lo, mpsar_hi;
+
+	/* Make sure we are using a valid rar index range */
+	if (rar >= rar_entries) {
+		txgbe_info(hw, "RAR index %d is out of range.\n", rar);
+		return;
+	}
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, rar);
+	mpsar_lo = rd32(hw, TXGBE_PSR_MAC_SWC_VM_L);
+	mpsar_hi = rd32(hw, TXGBE_PSR_MAC_SWC_VM_H);
+
+	if (!mpsar_lo && !mpsar_hi)
+		return;
+
+	/* was that the last pool using this rar? */
+	if (mpsar_lo == 0 && mpsar_hi == 0 && rar != 0)
+		hw->mac.ops.clear_rar(hw, rar);
+}
+
+/**
+ *  txgbe_set_vmdq_san_mac - Associate default VMDq pool index with a rx address
+ *  @hw: pointer to hardware struct
+ *  @vmdq: VMDq pool index
+ **/
+void txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq)
+{
+	u32 rar = hw->mac.san_mac_rar_index;
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, rar);
+	if (vmdq < 32) {
+		wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, 1 << vmdq);
+		wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, 0);
+	} else {
+		wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, 0);
+		wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, 1 << (vmdq - 32));
+	}
+}
+
+/**
+ *  txgbe_init_uta_tables - Initialize the Unicast Table Array
+ *  @hw: pointer to hardware structure
+ **/
+void txgbe_init_uta_tables(struct txgbe_hw *hw)
+{
+	int i;
+
+	txgbe_dbg(hw, " Clearing UTA\n");
+
+	for (i = 0; i < 128; i++)
+		wr32(hw, TXGBE_PSR_UC_TBL(i), 0);
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -235,13 +509,24 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.init_hw = txgbe_init_hw;
+	mac->ops.get_mac_addr = txgbe_get_mac_addr;
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
 	mac->ops.reset_hw = txgbe_reset_hw;
+	mac->ops.start_hw = txgbe_start_hw;
+	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
 
 	/* RAR */
+	mac->ops.set_rar = txgbe_set_rar;
+	mac->ops.clear_rar = txgbe_clear_rar;
+	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
+	mac->ops.clear_vmdq = txgbe_clear_vmdq;
 	mac->ops.disable_rx = txgbe_disable_rx;
+	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
+	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
+	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
 
@@ -328,7 +613,60 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 		return status;
 
 	txgbe_reset_misc(hw);
+
+	/* Store the permanent mac address */
+	hw->mac.ops.get_mac_addr(hw, hw->mac.perm_addr);
+
+	/* Store MAC address from RAR0, clear receive address registers, and
+	 * clear the multicast table.  Also reset num_rar_entries to 128,
+	 * since we modify this value when programming the SAN MAC address.
+	 */
+	hw->mac.num_rar_entries = 128;
+	hw->mac.ops.init_rx_addrs(hw);
+
+	/* Store the permanent SAN mac address */
+	hw->mac.ops.get_san_mac_addr(hw, hw->mac.san_addr);
+
+	/* Add the SAN MAC address to the RAR only if it's a valid address */
+	if (is_valid_ether_addr(hw->mac.san_addr)) {
+		hw->mac.ops.set_rar(hw, hw->mac.num_rar_entries - 1,
+				    hw->mac.san_addr, 0,
+				    TXGBE_PSR_MAC_SWC_AD_H_AV);
+
+		/* Save the SAN MAC RAR index */
+		hw->mac.san_mac_rar_index = hw->mac.num_rar_entries - 1;
+
+		/* Reserve the last RAR for the SAN MAC address */
+		hw->mac.num_rar_entries--;
+	}
+
 	pci_set_master(adapter->pdev);
 
 	return 0;
 }
+
+/**
+ *  txgbe_start_hw - Prepare hardware for Tx/Rx
+ *  @hw: pointer to hardware structure
+ *
+ *  Starts the hardware using the generic start_hw function
+ *  and the generation start_hw function.
+ *  Then performs revision-specific operations, if any.
+ **/
+void txgbe_start_hw(struct txgbe_hw *hw)
+{
+	u32 i;
+
+	/* Clear the rate limiters */
+	for (i = 0; i < hw->mac.max_tx_queues; i++) {
+		wr32(hw, TXGBE_TDM_RP_IDX, i);
+		wr32(hw, TXGBE_TDM_RP_RATE, 0);
+	}
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* Clear adapter stopped flag */
+	hw->adapter_stopped = false;
+
+	/* We need to run link autotry after the driver loads */
+	hw->mac.autotry_restart = true;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 04cf65812184..9d822ab5cc7e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -16,11 +16,25 @@
 #define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
 #define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
 
+int txgbe_init_hw(struct txgbe_hw *hw);
+void txgbe_start_hw(struct txgbe_hw *hw);
+void txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
 void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
 int txgbe_stop_adapter(struct txgbe_hw *hw);
 
+void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		   u32 enable_addr);
+void txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
+void txgbe_init_rx_addrs(struct txgbe_hw *hw);
+
 int txgbe_disable_pcie_master(struct txgbe_hw *hw);
 
+void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
+
+void txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
+void txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+void txgbe_init_uta_tables(struct txgbe_hw *hw);
+
 void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 817d37019e53..856f8fe4ac1b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -70,6 +70,155 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
+static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
+			if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE) {
+				hw->mac.ops.set_rar(hw, i,
+						    adapter->mac_table[i].addr,
+						    adapter->mac_table[i].pools,
+						    TXGBE_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				hw->mac.ops.clear_rar(hw, i);
+			}
+			adapter->mac_table[i].state &=
+				~(TXGBE_MAC_STATE_MODIFIED);
+		}
+	}
+}
+
+/* this function destroys the first RAR entry */
+static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
+					 u8 *addr)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
+	adapter->mac_table[0].pools = 1ULL;
+	adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
+				       TXGBE_MAC_STATE_IN_USE);
+	hw->mac.ops.set_rar(hw, 0, adapter->mac_table[0].addr,
+			    adapter->mac_table[0].pools,
+			    TXGBE_PSR_MAC_SWC_AD_H_AV);
+}
+
+static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+	}
+	txgbe_sync_mac_table(adapter);
+}
+
+int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	/* search table for addr, if found, set to 0 and sync */
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (ether_addr_equal(addr, adapter->mac_table[i].addr)) {
+			if (adapter->mac_table[i].pools & (1ULL << pool)) {
+				adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+				adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+				adapter->mac_table[i].pools &= ~(1ULL << pool);
+				txgbe_sync_mac_table(adapter);
+			}
+			return 0;
+		}
+
+		if (adapter->mac_table[i].pools != (1 << pool))
+			continue;
+		if (!ether_addr_equal(addr, adapter->mac_table[i].addr))
+			continue;
+
+		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+		txgbe_sync_mac_table(adapter);
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+void txgbe_reset(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 old_addr[ETH_ALEN];
+	int err;
+
+	err = hw->mac.ops.init_hw(hw);
+	if (err != 0)
+		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
+
+	/* do not flush user set addresses */
+	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
+	txgbe_flush_sw_mac_table(adapter);
+	txgbe_mac_set_default_filter(adapter, old_addr);
+
+	/* update SAN MAC vmdq pool selection */
+	hw->mac.ops.set_vmdq_san_mac(hw, 0);
+}
+
+void txgbe_disable_device(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	txgbe_disable_pcie_master(hw);
+	/* disable receives */
+	hw->mac.ops.disable_rx(hw);
+
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	if (hw->bus.lan_id == 0)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
+	else if (hw->bus.lan_id == 1)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN1_UP, 0);
+	else
+		dev_err(&adapter->pdev->dev,
+			"%s: invalid bus lan id %d\n",
+			__func__, hw->bus.lan_id);
+
+	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+	      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+		/* disable mac transmiter */
+		wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, 0);
+	}
+	/* disable transmits in the hardware now that interrupts are off */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		u8 reg_idx = adapter->tx_ring[i]->reg_idx;
+
+		wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
+	}
+
+	/* Disable the Tx DMA engine */
+	wr32m(hw, TXGBE_TDM_CTL, TXGBE_TDM_CTL_TE, 0);
+}
+
+void txgbe_down(struct txgbe_adapter *adapter)
+{
+	txgbe_disable_device(adapter);
+	txgbe_reset(adapter);
+}
+
 /**
  * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
  * @adapter: board private structure to initialize
@@ -105,6 +254,63 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	txgbe_init_ops_dummy(hw);
 	txgbe_init_ops(hw);
 
+	adapter->mac_table = kcalloc(hw->mac.num_rar_entries,
+				     sizeof(struct txgbe_mac_addr),
+				     GFP_KERNEL);
+	if (!adapter->mac_table) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "mac_table allocation failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * txgbe_open - Called when a network interface is made active
+ * @netdev: network interface device structure
+ *
+ * Returns 0 on success, negative value on failure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).
+ **/
+int txgbe_open(struct net_device *netdev)
+{
+	netif_carrier_off(netdev);
+
+	return 0;
+}
+
+/**
+ * txgbe_close_suspend - actions necessary to both suspend and close flows
+ * @adapter: the private adapter struct
+ *
+ * This function should contain the necessary work common to both suspending
+ * and closing of the device.
+ */
+static void txgbe_close_suspend(struct txgbe_adapter *adapter)
+{
+	txgbe_disable_device(adapter);
+}
+
+/**
+ * txgbe_close - Disables a network interface
+ * @netdev: network interface device structure
+ *
+ * Returns 0, this is not allowed to fail
+ *
+ * The close entry point is called when an interface is de-activated
+ * by the OS.  The hardware is still under the drivers control, but
+ * needs to be disabled.  A global MAC reset is issued to stop the
+ * hardware, and all transmit and receive resources are freed.
+ **/
+int txgbe_close(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	txgbe_down(adapter);
+
 	return 0;
 }
 
@@ -115,6 +321,11 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
+	rtnl_lock();
+	if (netif_running(netdev))
+		txgbe_close_suspend(adapter);
+	rtnl_unlock();
+
 	pci_disable_device(pdev);
 }
 
@@ -130,6 +341,89 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_set_mac - Change the Ethernet Address of the NIC
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int txgbe_set_mac(struct net_device *netdev, void *p)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	txgbe_del_mac_filter(adapter, hw->mac.addr, 0);
+	eth_hw_addr_set(netdev, addr->sa_data);
+	memcpy(hw->mac.addr, addr->sa_data, netdev->addr_len);
+
+	txgbe_mac_set_default_filter(adapter, hw->mac.addr);
+
+	return 0;
+}
+
+/**
+ * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
+ * netdev->dev_addr_list
+ * @dev: network interface device structure
+ *
+ * Returns non-zero on failure
+ **/
+static int txgbe_add_sanmac_netdev(struct net_device *dev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_hw *hw = &adapter->hw;
+	int err = 0;
+
+	if (is_valid_ether_addr(hw->mac.san_addr)) {
+		rtnl_lock();
+		err = dev_addr_add(dev, hw->mac.san_addr,
+				   NETDEV_HW_ADDR_T_SAN);
+		rtnl_unlock();
+
+		/* update SAN MAC vmdq pool selection */
+		hw->mac.ops.set_vmdq_san_mac(hw, 0);
+	}
+	return err;
+}
+
+/**
+ * txgbe_del_sanmac_netdev - Removes the SAN MAC address to the corresponding
+ * netdev->dev_addr_list
+ * @dev: network interface device structure
+ *
+ * Returns non-zero on failure
+ **/
+static int txgbe_del_sanmac_netdev(struct net_device *dev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_mac_info *mac = &adapter->hw.mac;
+	int err = 0;
+
+	if (is_valid_ether_addr(mac->san_addr)) {
+		rtnl_lock();
+		err = dev_addr_del(dev, mac->san_addr, NETDEV_HW_ADDR_T_SAN);
+		rtnl_unlock();
+	}
+	return err;
+}
+
+static const struct net_device_ops txgbe_netdev_ops = {
+	.ndo_open               = txgbe_open,
+	.ndo_stop               = txgbe_close,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = txgbe_set_mac,
+};
+
+void txgbe_assign_netdev_ops(struct net_device *dev)
+{
+	dev->netdev_ops = &txgbe_netdev_ops;
+}
+
 /**
  * txgbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -198,32 +492,54 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 	hw->hw_addr = adapter->io_addr;
 
+	txgbe_assign_netdev_ops(netdev);
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	/* setup the private structure */
 	err = txgbe_sw_init(adapter);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	hw->mac.ops.set_lan_id(hw);
 
 	/* check if flash load is done after hw power up */
 	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	err = hw->mac.ops.reset_hw(hw);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 	}
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	eth_hw_addr_set(netdev, hw->mac.perm_addr);
+
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
+		dev_err(&pdev->dev, "invalid MAC address\n");
+		err = -EIO;
+		goto err_free_mac_table;
+	}
+
+	txgbe_mac_set_default_filter(adapter, hw->mac.perm_addr);
+
+	hw->mac.ops.start_hw(hw);
+
+	strcpy(netdev->name, "eth%d");
+	err = register_netdev(netdev);
+	if (err)
+		goto err_free_mac_table;
+
 	pci_set_drvdata(pdev, adapter);
+	adapter->netdev_registered = true;
+
+	/* carrier off reporting is important to ethtool even BEFORE open */
+	netif_carrier_off(netdev);
 
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
@@ -239,8 +555,20 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	netif_info(adapter, probe, netdev, "%02x:%02x:%02x:%02x:%02x:%02x\n",
+		   netdev->dev_addr[0], netdev->dev_addr[1],
+		   netdev->dev_addr[2], netdev->dev_addr[3],
+		   netdev->dev_addr[4], netdev->dev_addr[5]);
+
+	/* add san mac addr to netdev */
+	err = txgbe_add_sanmac_netdev(netdev);
+	if (err)
+		goto err_free_mac_table;
+
 	return 0;
 
+err_free_mac_table:
+	kfree(adapter->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -261,9 +589,24 @@ static int txgbe_probe(struct pci_dev *pdev,
  **/
 static void txgbe_remove(struct pci_dev *pdev)
 {
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev;
+
+	netdev = adapter->netdev;
+
+	/* remove the added san mac */
+	txgbe_del_sanmac_netdev(netdev);
+
+	if (adapter->netdev_registered) {
+		unregister_netdev(netdev);
+		adapter->netdev_registered = false;
+	}
+
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
+	kfree(adapter->mac_table);
+
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index bbede2eedd5d..b237a69e15ce 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -198,6 +198,23 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_CFG_PORT_ST_LAN_ID(_r)    ((0x00000100U & (_r)) >> 8)
 #define TXGBE_LINK_UP_TIME              90
 
+/*********************** Transmit DMA registers **************************/
+/* transmit global control */
+#define TXGBE_TDM_CTL           0x18000
+/* TDM CTL BIT */
+#define TXGBE_TDM_CTL_TE        0x1 /* Transmit Enable */
+#define TXGBE_TDM_CTL_PADDING   0x2 /* Padding byte number for ipsec ESP */
+#define TXGBE_TDM_CTL_VT_SHIFT  16  /* VLAN EtherType */
+
+#define TXGBE_TDM_RP_CTL        0x18400
+#define TXGBE_TDM_RP_CTL_RST    ((0x1) << 0)
+#define TXGBE_TDM_RP_CTL_RPEN   ((0x1) << 2)
+#define TXGBE_TDM_RP_CTL_RLEN   ((0x1) << 3)
+#define TXGBE_TDM_RP_IDX        0x1820C
+#define TXGBE_TDM_RP_RATE       0x18404
+#define TXGBE_TDM_RP_RATE_MIN(v) ((0x3FFF & (v)))
+#define TXGBE_TDM_RP_RATE_MAX(v) ((0x3FFF & (v)) << 16)
+
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
 #define TXGBE_RDB_PB_WRAP           0x19004
@@ -239,6 +256,22 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PSR_CTL_MO                0x00000060U
 #define TXGBE_PSR_CTL_TPE               0x00000010U
 #define TXGBE_PSR_CTL_MO_SHIFT          5
+/* mcasst/ucast overflow tbl */
+#define TXGBE_PSR_MC_TBL(_i)    (0x15200  + ((_i) * 4))
+#define TXGBE_PSR_UC_TBL(_i)    (0x15400 + ((_i) * 4))
+
+/* mac switcher */
+#define TXGBE_PSR_MAC_SWC_AD_L  0x16200
+#define TXGBE_PSR_MAC_SWC_AD_H  0x16204
+#define TXGBE_PSR_MAC_SWC_VM_L  0x16208
+#define TXGBE_PSR_MAC_SWC_VM_H  0x1620C
+#define TXGBE_PSR_MAC_SWC_IDX   0x16210
+/* RAH */
+#define TXGBE_PSR_MAC_SWC_AD_H_AD(v)       (((v) & 0xFFFF))
+#define TXGBE_PSR_MAC_SWC_AD_H_ADTYPE(v)   (((v) & 0x1) << 30)
+#define TXGBE_PSR_MAC_SWC_AD_H_AV       0x80000000U
+#define TXGBE_CLEAR_VMDQ_ALL            0xFFFFFFFFU
+
 /* Management */
 #define TXGBE_PSR_MNG_FIT_CTL           0x15820
 /* Management Bit Fields and Masks */
@@ -367,9 +400,19 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PX_RR_CFG_RR_SZ           0x0000007EU
 #define TXGBE_PX_RR_CFG_RR_EN           0x00000001U
 
+#define TXGBE_ETH_LENGTH_OF_ADDRESS     6
+
 /* Number of 80 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        80000
 
+struct txgbe_addr_filter_info {
+	u32 num_mc_addrs;
+	u32 rar_used_count;
+	u32 mta_in_use;
+	u32 overflow_promisc;
+	bool user_set_promisc;
+};
+
 /* Bus parameters */
 struct txgbe_bus_info {
 	u16 func;
@@ -380,12 +423,23 @@ struct txgbe_bus_info {
 struct txgbe_hw;
 
 struct txgbe_mac_operations {
+	int (*init_hw)(struct txgbe_hw *hw);
 	int (*reset_hw)(struct txgbe_hw *hw);
+	void (*start_hw)(struct txgbe_hw *hw);
+	void (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
+	void (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
 	int (*stop_adapter)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
 
 	/* RAR */
+	void (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+			u32 enable_addr);
+	void (*clear_rar)(struct txgbe_hw *hw, u32 index);
 	void (*disable_rx)(struct txgbe_hw *hw);
+	void (*set_vmdq_san_mac)(struct txgbe_hw *hw, u32 vmdq);
+	void (*clear_vmdq)(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+	void (*init_rx_addrs)(struct txgbe_hw *hw);
+	void (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
 	void (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
@@ -393,8 +447,16 @@ struct txgbe_mac_operations {
 
 struct txgbe_mac_info {
 	struct txgbe_mac_operations ops;
+	u8 addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 perm_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 san_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	s32 mc_filter_type;
+	u32 mcft_size;
+	u32 num_rar_entries;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
+	u8  san_mac_rar_index;
+	bool autotry_restart;
 	struct txgbe_thermal_sensor_data  thermal_sensor_data;
 	bool set_lben;
 };
@@ -402,6 +464,7 @@ struct txgbe_mac_info {
 struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	struct txgbe_mac_info mac;
+	struct txgbe_addr_filter_info addr_ctrl;
 	struct txgbe_bus_info bus;
 	u16 device_id;
 	u16 vendor_id;
-- 
2.27.0

