Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B058E926
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiHJI5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiHJI5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:45 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAC96F570
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:57:34 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121786tky1rr78
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:25 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: y5ttDAKJaXM6/JF7KIrODo/4KztQKU7Mnqb9bPtEqjXwitJOE94qYnTpxE1mv
        aOVbO6dGOyQD15seEOEYz/VMtxTXfdIUcxtgIRwrIBJdUmdA7h5mov3uCx8QJFVDJIy1uT6
        uk6WSGvoRULGbanfd/WAs2z8GAtBUsRSUX77t/oMDMzeui9f77vEnI7ntf1PwgsY39OFkYN
        WXSiIFqx2nRgQwi500AiNAyIQb3TEpfPM6YEPaZhL8DOkv/k9b1oNCCU0Qy9dvYb0Nnxtwk
        n9H0H02a+Tm9JoZzP0Y7RMnEt1U8QEul2IangaOBn5AXIutGA/Q3JN82089wA0aTRS7uHND
        0sMVOaqXTqeKV59r9HmbBdaqkW2+4o5lR0z0FaOkJ4guZK/Yxit5ar6uD+X9GFSipperNnz
        kffxwQWXnr4=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 03/16] net: txgbe: Set MAC address and register netdev
Date:   Wed, 10 Aug 2022 16:55:19 +0800
Message-Id: <20220810085532.246613-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MAC address related operations, and register netdev.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  38 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 360 ++++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  14 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 303 ++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  63 +++
 5 files changed, 774 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 393f6454f023..a10792612c2e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -4,15 +4,31 @@
 #ifndef _TXGBE_H_
 #define _TXGBE_H_
 
+#include <net/ip.h>
 #include <linux/pci.h>
+#include <linux/etherdevice.h>
 
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
@@ -20,12 +36,31 @@ struct txgbe_adapter {
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
 s32 txgbe_init_shared_code(struct txgbe_hw *hw);
+void txgbe_disable_device(struct txgbe_adapter *adapter);
 
 #define TXGBE_INTR_ALL (~0ULL)
 
@@ -61,6 +96,9 @@ __maybe_unused static struct txgbe_msg *txgbe_hw_to_msg(const struct txgbe_hw *h
 	return (struct txgbe_msg *)&adapter->msg_enable;
 }
 
+#define txgbe_dbg(hw, fmt, arg...) \
+	netdev_dbg(txgbe_hw_to_netdev(hw), fmt, ##arg)
+
 #define TXGBE_FAILED_READ_CFG_DWORD 0xffffffffU
 #define TXGBE_FAILED_READ_CFG_WORD  0xffffU
 #define TXGBE_FAILED_READ_CFG_BYTE  0xffU
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 060f9e4ef65b..ef44da54c954 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -7,6 +7,50 @@
 
 #define TXGBE_SP_MAX_TX_QUEUES  128
 #define TXGBE_SP_MAX_RX_QUEUES  128
+#define TXGBE_SP_RAR_ENTRIES    128
+
+s32 txgbe_init_hw(struct txgbe_hw *hw)
+{
+	s32 status;
+
+	/* Reset the hardware */
+	status = TCALL(hw, mac.ops.reset_hw);
+
+	if (status == 0) {
+		/* Start the HW */
+		status = TCALL(hw, mac.ops.start_hw);
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
+s32 txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr)
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
+
+	return 0;
+}
 
 /**
  *  txgbe_set_pci_config_data - Generic store PCI bus info
@@ -148,6 +192,166 @@ s32 txgbe_stop_adapter(struct txgbe_hw *hw)
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
+s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		  u32 enable_addr)
+{
+	u32 rar_low, rar_high;
+	u32 rar_entries = hw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		ERROR_REPORT2(hw, TXGBE_ERROR_ARGUMENT,
+			      "RAR index %d is out of range.\n", index);
+		return TXGBE_ERR_INVALID_ARGUMENT;
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
+
+	return 0;
+}
+
+/**
+ *  txgbe_clear_rar - Remove Rx address register
+ *  @hw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *
+ *  Clears an ethernet address from a receive address register.
+ **/
+s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index)
+{
+	u32 rar_entries = hw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		ERROR_REPORT2(hw, TXGBE_ERROR_ARGUMENT,
+			      "RAR index %d is out of range.\n", index);
+		return TXGBE_ERR_INVALID_ARGUMENT;
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
+
+	return 0;
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
+s32 txgbe_init_rx_addrs(struct txgbe_hw *hw)
+{
+	u32 i;
+	u32 rar_entries = hw->mac.num_rar_entries;
+	u32 psrctl;
+
+	/* If the current mac address is valid, assume it is a software override
+	 * to the permanent address.
+	 * Otherwise, use the permanent address from the eeprom.
+	 */
+	if (!is_valid_ether_addr(hw->mac.addr)) {
+		/* Get the MAC address from the RAR0 for later reference */
+		TCALL(hw, mac.ops.get_mac_addr, hw->mac.addr);
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
+		TCALL(hw, mac.ops.set_rar, 0, hw->mac.addr, 0,
+		      TXGBE_PSR_MAC_SWC_AD_H_AV);
+
+		/* clear VMDq pool/queue selection for RAR 0 */
+		TCALL(hw, mac.ops.clear_vmdq, 0, TXGBE_CLEAR_VMDQ_ALL);
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
+	TCALL(hw, mac.ops.init_uta_tables);
+
+	return 0;
+}
+
 /**
  *  txgbe_disable_pcie_master - Disable PCI-express master access
  *  @hw: pointer to hardware structure
@@ -185,6 +389,97 @@ s32 txgbe_disable_pcie_master(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_get_san_mac_addr - SAN MAC address retrieval from the EEPROM
+ *  @hw: pointer to hardware structure
+ *  @san_mac_addr: SAN MAC address
+ *
+ *  Reads the SAN MAC address.
+ **/
+s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr)
+{
+	u8 i;
+
+	/* No addresses available in this EEPROM.  It's not an
+	 * error though, so just wipe the local address and return.
+	 */
+	for (i = 0; i < 6; i++)
+		san_mac_addr[i] = 0xFF;
+	return 0;
+}
+
+/**
+ *  txgbe_clear_vmdq - Disassociate a VMDq pool index from a rx address
+ *  @hw: pointer to hardware struct
+ *  @rar: receive address register index to disassociate
+ *  @vmdq: VMDq pool index to remove from the rar
+ **/
+s32 txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 __maybe_unused vmdq)
+{
+	u32 mpsar_lo, mpsar_hi;
+	u32 rar_entries = hw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (rar >= rar_entries) {
+		ERROR_REPORT2(hw, TXGBE_ERROR_ARGUMENT,
+			      "RAR index %d is out of range.\n", rar);
+		return TXGBE_ERR_INVALID_ARGUMENT;
+	}
+
+	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, rar);
+	mpsar_lo = rd32(hw, TXGBE_PSR_MAC_SWC_VM_L);
+	mpsar_hi = rd32(hw, TXGBE_PSR_MAC_SWC_VM_H);
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		goto done;
+
+	if (!mpsar_lo && !mpsar_hi)
+		goto done;
+
+	/* was that the last pool using this rar? */
+	if (mpsar_lo == 0 && mpsar_hi == 0 && rar != 0)
+		TCALL(hw, mac.ops.clear_rar, rar);
+done:
+	return 0;
+}
+
+/**
+ *  txgbe_set_vmdq_san_mac - Associate default VMDq pool index with a rx address
+ *  @hw: pointer to hardware struct
+ *  @vmdq: VMDq pool index
+ **/
+s32 txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq)
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
+
+	return 0;
+}
+
+/**
+ *  txgbe_init_uta_tables - Initialize the Unicast Table Array
+ *  @hw: pointer to hardware structure
+ **/
+s32 txgbe_init_uta_tables(struct txgbe_hw *hw)
+{
+	int i;
+
+	txgbe_dbg(hw, " Clearing UTA\n");
+
+	for (i = 0; i < 128; i++)
+		wr32(hw, TXGBE_PSR_UC_TBL(i), 0);
+
+	return 0;
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -317,14 +612,25 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.init_hw = txgbe_init_hw;
+	mac->ops.get_mac_addr = txgbe_get_mac_addr;
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.get_bus_info = txgbe_get_bus_info;
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
 
@@ -419,8 +725,62 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		goto reset_hw_out;
 
+	/* Store the permanent mac address */
+	TCALL(hw, mac.ops.get_mac_addr, hw->mac.perm_addr);
+
+	/* Store MAC address from RAR0, clear receive address registers, and
+	 * clear the multicast table.  Also reset num_rar_entries to 128,
+	 * since we modify this value when programming the SAN MAC address.
+	 */
+	hw->mac.num_rar_entries = 128;
+	TCALL(hw, mac.ops.init_rx_addrs);
+
+	/* Store the permanent SAN mac address */
+	TCALL(hw, mac.ops.get_san_mac_addr, hw->mac.san_addr);
+
+	/* Add the SAN MAC address to the RAR only if it's a valid address */
+	if (is_valid_ether_addr(hw->mac.san_addr)) {
+		TCALL(hw, mac.ops.set_rar, hw->mac.num_rar_entries - 1,
+		      hw->mac.san_addr, 0, TXGBE_PSR_MAC_SWC_AD_H_AV);
+
+		/* Save the SAN MAC RAR index */
+		hw->mac.san_mac_rar_index = hw->mac.num_rar_entries - 1;
+
+		/* Reserve the last RAR for the SAN MAC address */
+		hw->mac.num_rar_entries--;
+	}
+
 	pci_set_master(adapter->pdev);
 
 reset_hw_out:
 	return status;
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
+s32 txgbe_start_hw(struct txgbe_hw *hw)
+{
+	int ret_val = 0;
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
+
+	return ret_val;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index e56fe21250c3..6b17942c4670 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -16,13 +16,27 @@
 #define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
 #define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
 
+s32 txgbe_init_hw(struct txgbe_hw *hw);
+s32 txgbe_start_hw(struct txgbe_hw *hw);
+s32 txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
 s32 txgbe_get_bus_info(struct txgbe_hw *hw);
 void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
 s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
 s32 txgbe_stop_adapter(struct txgbe_hw *hw);
 
+s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		  u32 enable_addr);
+s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
+s32 txgbe_init_rx_addrs(struct txgbe_hw *hw);
+
 s32 txgbe_disable_pcie_master(struct txgbe_hw *hw);
 
+s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
+
+s32 txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
+s32 txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+s32 txgbe_init_uta_tables(struct txgbe_hw *hw);
+
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 s32 txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index cb950d52a51d..21b63856db49 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -100,6 +100,131 @@ static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
 	return false;
 }
 
+static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
+			if (adapter->mac_table[i].state &
+					TXGBE_MAC_STATE_IN_USE) {
+				TCALL(hw, mac.ops.set_rar, i,
+				      adapter->mac_table[i].addr,
+				      adapter->mac_table[i].pools,
+				      TXGBE_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				TCALL(hw, mac.ops.clear_rar, i);
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
+	TCALL(hw, mac.ops.set_rar, 0, adapter->mac_table[0].addr,
+	      adapter->mac_table[0].pools,
+	      TXGBE_PSR_MAC_SWC_AD_H_AV);
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
+void txgbe_reset(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 old_addr[ETH_ALEN];
+	int err;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+
+	err = TCALL(hw, mac.ops.init_hw);
+	switch (err) {
+	case 0:
+		break;
+	case TXGBE_ERR_MASTER_REQUESTS_PENDING:
+		dev_err(&adapter->pdev->dev, "master disable timed out\n");
+		break;
+	default:
+		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
+	}
+
+	/* do not flush user set addresses */
+	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
+	txgbe_flush_sw_mac_table(adapter);
+	txgbe_mac_set_default_filter(adapter, old_addr);
+
+	/* update SAN MAC vmdq pool selection */
+	TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
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
+	TCALL(hw, mac.ops.disable_rx);
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
  *  txgbe_init_shared_code - Initialize the shared code
  *  @hw: pointer to hardware structure
@@ -151,6 +276,63 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 			  "init_shared_code failed: %d\n", err);
 		return err;
 	}
+	adapter->mac_table = kzalloc(sizeof(*adapter->mac_table) *
+				     hw->mac.num_rar_entries,
+				     GFP_ATOMIC);
+	if (!adapter->mac_table) {
+		err = TXGBE_ERR_OUT_OF_MEM;
+		netif_err(adapter, probe, adapter->netdev,
+			  "mac_table allocation failed: %d\n", err);
+		return err;
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
 
 	return 0;
 }
@@ -162,6 +344,11 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
+	rtnl_lock();
+	if (netif_running(netdev))
+		txgbe_close_suspend(adapter);
+	rtnl_unlock();
+
 	pci_disable_device(pdev);
 }
 
@@ -177,6 +364,62 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
+ * netdev->dev_addr_list
+ * @dev: network interface device structure
+ *
+ * Returns non-zero on failure
+ **/
+static int txgbe_add_sanmac_netdev(struct net_device *dev)
+{
+	int err = 0;
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (is_valid_ether_addr(hw->mac.san_addr)) {
+		rtnl_lock();
+		err = dev_addr_add(dev, hw->mac.san_addr,
+				   NETDEV_HW_ADDR_T_SAN);
+		rtnl_unlock();
+
+		/* update SAN MAC vmdq pool selection */
+		TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
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
+	int err = 0;
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_mac_info *mac = &adapter->hw.mac;
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
@@ -245,35 +488,62 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 	hw->hw_addr = adapter->io_addr;
 
+	txgbe_assign_netdev_ops(netdev);
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	/* setup the private structure */
 	err = txgbe_sw_init(adapter);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	TCALL(hw, mac.ops.set_lan_id);
 
 	/* check if flash load is done after hw power up */
 	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	err = TCALL(hw, mac.ops.reset_hw);
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
+	/* reset the hardware with the new settings */
+	err = TCALL(hw, mac.ops.start_hw);
+	if (err) {
+		dev_err(&pdev->dev, "HW init failed\n");
+		goto err_free_mac_table;
+	}
+
 	/* pick up the PCI bus settings for reporting later */
 	TCALL(hw, mac.ops.get_bus_info);
 
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
@@ -287,8 +557,18 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (expected_gts > 0)
 		txgbe_check_minimum_link(adapter);
 
+	netif_info(adapter, probe, netdev, "%02x:%02x:%02x:%02x:%02x:%02x\n",
+		   netdev->dev_addr[0], netdev->dev_addr[1],
+		   netdev->dev_addr[2], netdev->dev_addr[3],
+		   netdev->dev_addr[4], netdev->dev_addr[5]);
+
+	/* add san mac addr to netdev */
+	txgbe_add_sanmac_netdev(netdev);
+
 	return 0;
 
+err_free_mac_table:
+	kfree(adapter->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -309,9 +589,24 @@ static int txgbe_probe(struct pci_dev *pdev,
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
index ae3407a30d9e..5baf328138a5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -203,6 +203,23 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_CFG_LED_CTL_LINK_UP_SEL   0x00000001U
 #define TXGBE_CFG_LED_CTL_LINK_OD_SHIFT 16
 
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
@@ -244,6 +261,22 @@ struct txgbe_thermal_sensor_data {
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
@@ -372,6 +405,8 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PX_RR_CFG_RR_SZ           0x0000007EU
 #define TXGBE_PX_RR_CFG_RR_EN           0x00000001U
 
+#define TXGBE_ETH_LENGTH_OF_ADDRESS     6
+
 /******************************** PCI Bus Info *******************************/
 #define TXGBE_PCI_DEVICE_STATUS         0xAA
 #define TXGBE_PCI_DEVICE_STATUS_TRANSACTION_PENDING     0x0020
@@ -446,6 +481,14 @@ enum txgbe_bus_width {
 	txgbe_bus_width_reserved
 };
 
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
 	enum txgbe_bus_speed speed;
@@ -460,13 +503,24 @@ struct txgbe_bus_info {
 struct txgbe_hw;
 
 struct txgbe_mac_operations {
+	s32 (*init_hw)(struct txgbe_hw *hw);
 	s32 (*reset_hw)(struct txgbe_hw *hw);
+	s32 (*start_hw)(struct txgbe_hw *hw);
+	s32 (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
+	s32 (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
 	s32 (*stop_adapter)(struct txgbe_hw *hw);
 	s32 (*get_bus_info)(struct txgbe_hw *hw);
 	s32 (*set_lan_id)(struct txgbe_hw *hw);
 
 	/* RAR */
+	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		       u32 enable_addr);
+	s32 (*clear_rar)(struct txgbe_hw *hw, u32 index);
 	s32 (*disable_rx)(struct txgbe_hw *hw);
+	s32 (*set_vmdq_san_mac)(struct txgbe_hw *hw, u32 vmdq);
+	s32 (*clear_vmdq)(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+	s32 (*init_rx_addrs)(struct txgbe_hw *hw);
+	s32 (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
 	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
@@ -474,8 +528,16 @@ struct txgbe_mac_operations {
 
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
@@ -483,6 +545,7 @@ struct txgbe_mac_info {
 struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	struct txgbe_mac_info mac;
+	struct txgbe_addr_filter_info addr_ctrl;
 	struct txgbe_bus_info bus;
 	u16 device_id;
 	u16 vendor_id;
-- 
2.27.0

