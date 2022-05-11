Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE8522A5C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiEKDTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiEKDT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:29 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3433F6CA9B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:23 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239150tsn64p3x
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:09 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: F3yR32iATbjrb611KrJdac8pmByHAm2taPcWXeMh9GC78qSvfGkl5GnEUetFd
        WIn423J0X4fZgVnYLsdZRWfbu9oblCOtd2HJYvNwe2mvwXNIcKl4ailXymxKc8TWe7bkzUO
        Mk34RWKRAW4qMjOqfn8amdHqBGp9/P2o7IExjWDjkEYPPGF10mkVPfG4tHvFitq9eV8MGFS
        AbItBBdxNT9HQdeNr94BRbjESL3OuLeTOgyuGTKA8GkqtL/IQ/kjCl39DZgcweIpZIt1Vqv
        5WuwEqTDIVxTvUnnHBJe0Jg5ww/0KHEs0MuNQkwNnkFL3NpSsF3uBjG7S+ZYqZ4AgEdZnCJ
        gQoQAJNH74bF+zdn+qxAtuWdj5lRk5uRmD7glL7
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 02/14] net: txgbe: Add hardware initialization
Date:   Wed, 11 May 2022 11:26:47 +0800
Message-Id: <20220511032659.641834-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the hardware by configuring the MAC layer.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |    3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  153 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  789 ++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   36 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  422 +++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 1728 +++++++++++++++++
 6 files changed, 3129 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 725aa1f721f6..eaf1d46693bc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -6,4 +6,5 @@
 
 obj-$(CONFIG_TXGBE) += txgbe.o
 
-txgbe-objs := txgbe_main.o
+txgbe-objs := txgbe_main.o \
+              txgbe_hw.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index dd6b6c03e998..48e6f69857ad 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -4,16 +4,40 @@
 #ifndef _TXGBE_H_
 #define _TXGBE_H_
 
+#include <net/ip.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+#include <linux/etherdevice.h>
+#include <linux/timecounter.h>
+#include <linux/clocksource.h>
+#include <linux/aer.h>
+
 #include "txgbe_type.h"
 
 #ifndef MAX_REQUEST_SIZE
 #define MAX_REQUEST_SIZE 256
 #endif
 
+struct txgbe_ring {
+	u8 reg_idx;
+} ____cacheline_internodealigned_in_smp;
+
 #define TXGBE_MAX_FDIR_INDICES          63
 
 #define MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+#define TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE       64
+
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
 	/* OS defined structs */
@@ -22,12 +46,37 @@ struct txgbe_adapter {
 
 	unsigned long state;
 
+	/* Some features need tri-state capability,
+	 * thus the additional *_CAPABLE flags.
+	 */
+	u32 flags2;
+	/* Tx fast path data */
+	int num_tx_queues;
+	u16 tx_itr_setting;
+
+	/* Rx fast path data */
+	int num_rx_queues;
+	u16 rx_itr_setting;
+
+	/* TX */
+	struct txgbe_ring *tx_ring[MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
+
+	int max_q_vectors;      /* upper limit of q_vectors for device */
+
 	/* structs defined in txgbe_hw.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
+
+	struct timer_list service_timer;
 	struct work_struct service_task;
+	u32 atr_sample_rate;
 
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+
+	bool netdev_registered;
+
+	struct txgbe_mac_addr *mac_table;
+
 };
 
 enum txgbe_state_t {
@@ -44,13 +93,83 @@ enum txgbe_state_t {
 	__TXGBE_PTP_TX_IN_PROGRESS,
 };
 
+void txgbe_down(struct txgbe_adapter *adapter);
+
+/**
+ * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
+ * disable a interrupt by writing to PX_IMS with the corresponding bit=1
+ * enable a interrupt by writing to PX_IMC with the corresponding bit=1
+ * trigger a interrupt by writing to PX_ICS with the corresponding bit=1
+ **/
+#define TXGBE_INTR_ALL (~0ULL)
+#define TXGBE_INTR_MISC(A) (1ULL << (A)->num_q_vectors)
+#define TXGBE_INTR_QALL(A) (TXGBE_INTR_MISC(A) - 1)
+#define TXGBE_INTR_Q(i) (1ULL << (i))
+static inline void txgbe_intr_enable(struct txgbe_hw *hw, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & 0xFFFFFFFF);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMC(0), mask);
+	mask = (qmask >> 32);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMC(1), mask);
+
+	/* skip the flush */
+}
+
+static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & 0xFFFFFFFF);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMS(0), mask);
+	mask = (qmask >> 32);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMS(1), mask);
+
+	/* skip the flush */
+}
+
+#define msec_delay(_x) msleep(_x)
+#define usec_delay(_x) udelay(_x)
+
 #define TXGBE_NAME "txgbe"
 
+struct txgbe_msg {
+	u16 msg_enable;
+};
+
+__maybe_unused static struct net_device *txgbe_hw_to_netdev(const struct txgbe_hw *hw)
+{
+	return ((struct txgbe_adapter *)hw->back)->netdev;
+}
+
+__maybe_unused static struct txgbe_msg *txgbe_hw_to_msg(const struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter =
+		container_of(hw, struct txgbe_adapter, hw);
+	return (struct txgbe_msg *)&adapter->msg_enable;
+}
+
 static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 {
 	return &pdev->dev;
 }
 
+#define txgbe_hw_dbg(fmt, arg...) \
+	netdev_dbg(txgbe_hw_to_netdev(hw), fmt, ##arg)
+
+#define DEBUGOUT(S)             txgbe_hw_dbg(S)
+#define DEBUGOUT1(S, A...)      txgbe_hw_dbg(S, ## A)
+#define DEBUGOUT2(S, A...)      txgbe_hw_dbg(S, ## A)
+#define DEBUGOUT3(S, A...)      txgbe_hw_dbg(S, ## A)
+#define DEBUGOUT4(S, A...)      txgbe_hw_dbg(S, ## A)
+#define DEBUGOUT5(S, A...)      txgbe_hw_dbg(S, ## A)
+#define DEBUGOUT6(S, A...)      txgbe_hw_dbg(S, ## A)
+
 #define txgbe_dev_info(format, arg...) \
 	dev_info(&adapter->pdev->dev, format, ## arg)
 #define txgbe_dev_warn(format, arg...) \
@@ -74,4 +193,38 @@ static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 #define TXGBE_FAILED_READ_CFG_WORD  0xffffU
 #define TXGBE_FAILED_READ_CFG_BYTE  0xffU
 
+extern u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg);
+
+enum {
+	TXGBE_ERROR_SOFTWARE,
+	TXGBE_ERROR_POLLING,
+	TXGBE_ERROR_INVALID_STATE,
+	TXGBE_ERROR_UNSUPPORTED,
+	TXGBE_ERROR_ARGUMENT,
+	TXGBE_ERROR_CAUTION,
+};
+
+#define ERROR_REPORT(level, format, arg...) do {                               \
+	switch (level) {                                                       \
+	case TXGBE_ERROR_SOFTWARE:                                             \
+	case TXGBE_ERROR_CAUTION:                                              \
+	case TXGBE_ERROR_POLLING:                                              \
+		netif_warn(txgbe_hw_to_msg(hw), drv, txgbe_hw_to_netdev(hw),   \
+			   format, ## arg);                                    \
+		break;                                                         \
+	case TXGBE_ERROR_INVALID_STATE:                                        \
+	case TXGBE_ERROR_UNSUPPORTED:                                          \
+	case TXGBE_ERROR_ARGUMENT:                                             \
+		netif_err(txgbe_hw_to_msg(hw), hw, txgbe_hw_to_netdev(hw),     \
+			  format, ## arg);                                     \
+		break;                                                         \
+	default:                                                               \
+		break;                                                         \
+	}                                                                      \
+} while (0)
+
+#define ERROR_REPORT1 ERROR_REPORT
+#define ERROR_REPORT2 ERROR_REPORT
+#define ERROR_REPORT3 ERROR_REPORT
+
 #endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
new file mode 100644
index 000000000000..e4ebaf007da9
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -0,0 +1,789 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe_type.h"
+#include "txgbe_hw.h"
+#include "txgbe.h"
+
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
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
+
+/**
+ *  txgbe_set_pci_config_data - Generic store PCI bus info
+ *  @hw: pointer to hardware structure
+ *  @link_status: the link status returned by the PCI config space
+ *
+ *  Stores the PCI bus info (speed, width, type) within the txgbe_hw structure
+ **/
+void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status)
+{
+	if (hw->bus.type == txgbe_bus_type_unknown)
+		hw->bus.type = txgbe_bus_type_pci_express;
+
+	switch (link_status & TXGBE_PCI_LINK_WIDTH) {
+	case TXGBE_PCI_LINK_WIDTH_1:
+		hw->bus.width = txgbe_bus_width_pcie_x1;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_2:
+		hw->bus.width = txgbe_bus_width_pcie_x2;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_4:
+		hw->bus.width = txgbe_bus_width_pcie_x4;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_8:
+		hw->bus.width = txgbe_bus_width_pcie_x8;
+		break;
+	default:
+		hw->bus.width = txgbe_bus_width_unknown;
+		break;
+	}
+
+	switch (link_status & TXGBE_PCI_LINK_SPEED) {
+	case TXGBE_PCI_LINK_SPEED_2500:
+		hw->bus.speed = txgbe_bus_speed_2500;
+		break;
+	case TXGBE_PCI_LINK_SPEED_5000:
+		hw->bus.speed = txgbe_bus_speed_5000;
+		break;
+	case TXGBE_PCI_LINK_SPEED_8000:
+		hw->bus.speed = txgbe_bus_speed_8000;
+		break;
+	default:
+		hw->bus.speed = txgbe_bus_speed_unknown;
+		break;
+	}
+}
+
+/**
+ *  txgbe_get_bus_info - Generic set PCI bus info
+ *  @hw: pointer to hardware structure
+ *
+ *  Gets the PCI bus info (speed, width, type) then calls helper function to
+ *  store this data within the txgbe_hw structure.
+ **/
+s32 txgbe_get_bus_info(struct txgbe_hw *hw)
+{
+	u16 link_status;
+
+	/* Get the negotiated link width and speed from PCI config space */
+	link_status = txgbe_read_pci_cfg_word(hw, TXGBE_PCI_LINK_STATUS);
+
+	txgbe_set_pci_config_data(hw, link_status);
+
+	return 0;
+}
+
+/**
+ *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
+ *  @hw: pointer to the HW structure
+ *
+ *  Determines the LAN function id by reading memory-mapped registers
+ *  and swaps the port value if requested.
+ **/
+void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
+{
+	struct txgbe_bus_info *bus = &hw->bus;
+	u32 reg;
+
+	reg = rd32(hw, TXGBE_CFG_PORT_ST);
+	bus->lan_id = TXGBE_CFG_PORT_ST_LAN_ID(reg);
+
+	/* check for a port swap */
+	reg = rd32(hw, TXGBE_MIS_PWR);
+	if (TXGBE_MIS_PWR_LAN_ID(reg) == TXGBE_MIS_PWR_LAN_ID_1)
+		bus->func = 0;
+	else
+		bus->func = bus->lan_id;
+}
+
+/**
+ *  txgbe_stop_adapter - Generic stop Tx/Rx units
+ *  @hw: pointer to hardware structure
+ *
+ *  Sets the adapter_stopped flag within txgbe_hw struct. Clears interrupts,
+ *  disables transmit and receive units. The adapter_stopped flag is used by
+ *  the shared code and drivers to determine if the adapter is in a stopped
+ *  state and should not touch the hardware.
+ **/
+s32 txgbe_stop_adapter(struct txgbe_hw *hw)
+{
+	u16 i;
+
+	/* Set the adapter_stopped flag so other driver functions stop touching
+	 * the hardware
+	 */
+	hw->adapter_stopped = true;
+
+	/* Disable the receive unit */
+	TCALL(hw, mac.ops.disable_rx);
+
+	/* Set interrupt mask to stop interrupts from being generated */
+	txgbe_intr_disable(hw, TXGBE_INTR_ALL);
+
+	/* Clear any pending interrupts, flush previous writes */
+	wr32(hw, TXGBE_PX_MISC_IC, 0xffffffff);
+	wr32(hw, TXGBE_BME_CTL, 0x3);
+
+	/* Disable the transmit unit.  Each queue must be disabled. */
+	for (i = 0; i < hw->mac.max_tx_queues; i++) {
+		wr32m(hw, TXGBE_PX_TR_CFG(i),
+		      TXGBE_PX_TR_CFG_SWFLSH | TXGBE_PX_TR_CFG_ENABLE,
+		      TXGBE_PX_TR_CFG_SWFLSH);
+	}
+
+	/* Disable the receive unit by stopping each queue */
+	for (i = 0; i < hw->mac.max_rx_queues; i++) {
+		wr32m(hw, TXGBE_PX_RR_CFG(i),
+		      TXGBE_PX_RR_CFG_RR_EN, 0);
+	}
+
+	/* flush all queues disables */
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* Prevent the PCI-E bus from hanging by disabling PCI-E master
+	 * access and verify no pending requests
+	 */
+	return txgbe_disable_pcie_master(hw);
+}
+
+/**
+ *  txgbe_set_rar - Set Rx address register
+ *  @hw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *  @addr: Address to put into receive address register
+ *  @vmdq: VMDq "set" or "pool" index
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
+		ERROR_REPORT2(TXGBE_ERROR_ARGUMENT,
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
+		ERROR_REPORT2(TXGBE_ERROR_ARGUMENT,
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
+		DEBUGOUT3("Keeping Current RAR0 Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
+			  hw->mac.addr[0], hw->mac.addr[1],
+			  hw->mac.addr[2], hw->mac.addr[3],
+			  hw->mac.addr[4], hw->mac.addr[5]);
+	} else {
+		/* Setup the receive address. */
+		DEBUGOUT("Overriding MAC Address in RAR[0]\n");
+		DEBUGOUT3("New MAC Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
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
+	DEBUGOUT1("Clearing RAR[1-%d]\n", rar_entries - 1);
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
+	DEBUGOUT(" Clearing MTA\n");
+	for (i = 0; i < hw->mac.mcft_size; i++)
+		wr32(hw, TXGBE_PSR_MC_TBL(i), 0);
+
+	TCALL(hw, mac.ops.init_uta_tables);
+
+	return 0;
+}
+
+/**
+ *  txgbe_disable_pcie_master - Disable PCI-express master access
+ *  @hw: pointer to hardware structure
+ *
+ *  Disables PCI-Express master access and verifies there are no pending
+ *  requests. TXGBE_ERR_MASTER_REQUESTS_PENDING is returned if master disable
+ *  bit hasn't caused the master requests to be disabled, else 0
+ *  is returned signifying master requests disabled.
+ **/
+s32 txgbe_disable_pcie_master(struct txgbe_hw *hw)
+{
+	s32 status = 0;
+	u32 i;
+
+	/* Always set this bit to ensure any future transactions are blocked */
+	pci_clear_master(((struct txgbe_adapter *)hw->back)->pdev);
+
+	/* Exit if master requests are blocked */
+	if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)) ||
+	    TXGBE_REMOVED(hw->hw_addr))
+		goto out;
+
+	/* Poll for master request bit to clear */
+	for (i = 0; i < TXGBE_PCI_MASTER_DISABLE_TIMEOUT; i++) {
+		usec_delay(100);
+		if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)))
+			goto out;
+	}
+
+	ERROR_REPORT1(TXGBE_ERROR_POLLING,
+		      "PCIe transaction pending bit did not clear.\n");
+	status = TXGBE_ERR_MASTER_REQUESTS_PENDING;
+out:
+	return status;
+}
+
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
+		ERROR_REPORT2(TXGBE_ERROR_ARGUMENT,
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
+ *  This function should only be involved in the IOV mode.
+ *  In IOV mode, Default pool is next pool after the number of
+ *  VFs advertized and not 0.
+ *  MPSAR table needs to be updated for SAN_MAC RAR [hw->mac.san_mac_rar_index]
+ *
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
+	DEBUGOUT(" Clearing UTA\n");
+
+	for (i = 0; i < 128; i++)
+		wr32(hw, TXGBE_PSR_UC_TBL(i), 0);
+
+	return 0;
+}
+
+/**
+ *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
+ *  @hw: pointer to hardware structure
+ *
+ *  Inits the thermal sensor thresholds according to the NVM map
+ *  and save off the threshold and location values into mac.thermal_sensor_data
+ **/
+s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
+{
+	s32 status = 0;
+
+	struct txgbe_thermal_sensor_data *data = &hw->mac.thermal_sensor_data;
+
+	memset(data, 0, sizeof(struct txgbe_thermal_sensor_data));
+
+	/* Only support thermal sensors attached to SP physical port 0 */
+	if (hw->bus.lan_id)
+		return TXGBE_NOT_IMPLEMENTED;
+
+	wr32(hw, TXGBE_TS_CTL, TXGBE_TS_CTL_EVAL_MD);
+	wr32(hw, TXGBE_TS_INT_EN,
+	     TXGBE_TS_INT_EN_ALARM_INT_EN | TXGBE_TS_INT_EN_DALARM_INT_EN);
+	wr32(hw, TXGBE_TS_EN, TXGBE_TS_EN_ENA);
+
+	data->sensor.alarm_thresh = 100;
+	wr32(hw, TXGBE_TS_ALARM_THRE, 677);
+	data->sensor.dalarm_thresh = 90;
+	wr32(hw, TXGBE_TS_DALARM_THRE, 614);
+
+	return status;
+}
+
+void txgbe_disable_rx(struct txgbe_hw *hw)
+{
+	u32 pfdtxgswc;
+	u32 rxctrl;
+
+	rxctrl = rd32(hw, TXGBE_RDB_PB_CTL);
+	if (rxctrl & TXGBE_RDB_PB_CTL_RXEN) {
+		pfdtxgswc = rd32(hw, TXGBE_PSR_CTL);
+		if (pfdtxgswc & TXGBE_PSR_CTL_SW_EN) {
+			pfdtxgswc &= ~TXGBE_PSR_CTL_SW_EN;
+			wr32(hw, TXGBE_PSR_CTL, pfdtxgswc);
+			hw->mac.set_lben = true;
+		} else {
+			hw->mac.set_lben = false;
+		}
+		rxctrl &= ~TXGBE_RDB_PB_CTL_RXEN;
+		wr32(hw, TXGBE_RDB_PB_CTL, rxctrl);
+
+		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+			/* disable mac receiver */
+			wr32m(hw, TXGBE_MAC_RX_CFG,
+			      TXGBE_MAC_RX_CFG_RE, 0);
+		}
+	}
+}
+
+int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
+{
+	u32 i = 0;
+	u32 reg = 0;
+	int err = 0;
+	/* if there's flash existing */
+	if (!(rd32(hw, TXGBE_SPI_STATUS) &
+	      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
+		/* wait hw load flash done */
+		for (i = 0; i < TXGBE_MAX_FLASH_LOAD_POLL_TIME; i++) {
+			reg = rd32(hw, TXGBE_SPI_ILDR_STATUS);
+			if (!(reg & check_bit)) {
+				/* done */
+				break;
+			}
+			msleep(200);
+		}
+		if (i == TXGBE_MAX_FLASH_LOAD_POLL_TIME)
+			err = TXGBE_ERR_FLASH_LOADING_FAILED;
+	}
+	return err;
+}
+
+/**
+ *  txgbe_init_ops - Inits func ptrs and MAC type
+ *  @hw: pointer to hardware structure
+ *
+ *  Initialize the function pointers and assign the MAC type for sapphire.
+ *  Does not touch the hardware.
+ **/
+
+s32 txgbe_init_ops(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* MAC */
+	mac->ops.init_hw = txgbe_init_hw;
+	mac->ops.get_mac_addr = txgbe_get_mac_addr;
+	mac->ops.stop_adapter = txgbe_stop_adapter;
+	mac->ops.get_bus_info = txgbe_get_bus_info;
+	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+	mac->ops.reset_hw = txgbe_reset_hw;
+	mac->ops.start_hw = txgbe_start_hw;
+	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
+
+	/* RAR */
+	mac->ops.set_rar = txgbe_set_rar;
+	mac->ops.clear_rar = txgbe_clear_rar;
+	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
+	mac->ops.init_uta_tables = txgbe_init_uta_tables;
+
+	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
+	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
+	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
+
+	/* Manageability interface */
+	mac->ops.init_thermal_sensor_thresh =
+				      txgbe_init_thermal_sensor_thresh;
+
+	return 0;
+}
+
+int txgbe_reset_misc(struct txgbe_hw *hw)
+{
+	int i;
+
+	/* receive packets that size > 2048 */
+	wr32m(hw, TXGBE_MAC_RX_CFG,
+	      TXGBE_MAC_RX_CFG_JE, TXGBE_MAC_RX_CFG_JE);
+
+	/* clear counters on read */
+	wr32m(hw, TXGBE_MMC_CONTROL,
+	      TXGBE_MMC_CONTROL_RSTONRD, TXGBE_MMC_CONTROL_RSTONRD);
+
+	wr32m(hw, TXGBE_MAC_RX_FLOW_CTRL,
+	      TXGBE_MAC_RX_FLOW_CTRL_RFE, TXGBE_MAC_RX_FLOW_CTRL_RFE);
+
+	wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
+
+	wr32m(hw, TXGBE_MIS_RST_ST,
+	      TXGBE_MIS_RST_ST_RST_INIT, 0x1E00);
+
+	/* errata 4: initialize mng flex tbl and wakeup flex tbl*/
+	wr32(hw, TXGBE_PSR_MNG_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_L(i), 0);
+		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_H(i), 0);
+		wr32(hw, TXGBE_PSR_MNG_FLEX_MSK(i), 0);
+	}
+	wr32(hw, TXGBE_PSR_LAN_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_L(i), 0);
+		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_H(i), 0);
+		wr32(hw, TXGBE_PSR_LAN_FLEX_MSK(i), 0);
+	}
+
+	/* set pause frame dst mac addr */
+	wr32(hw, TXGBE_RDB_PFCMACDAL, 0xC2000001);
+	wr32(hw, TXGBE_RDB_PFCMACDAH, 0x0180);
+
+	txgbe_init_thermal_sensor_thresh(hw);
+
+	return 0;
+}
+
+/**
+ *  txgbe_reset_hw - Perform hardware reset
+ *  @hw: pointer to hardware structure
+ *
+ *  Resets the hardware by resetting the transmit and receive units, masks
+ *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
+ *  reset.
+ **/
+s32 txgbe_reset_hw(struct txgbe_hw *hw)
+{
+	s32 status;
+	u32 reset = 0;
+	u32 i;
+
+	u32 reset_status = 0;
+	u32 rst_delay = 0;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = TCALL(hw, mac.ops.stop_adapter);
+	if (status != 0)
+		goto reset_hw_out;
+
+	/* Issue global reset to the MAC.  Needs to be SW reset if link is up.
+	 * If link reset is used when link is up, it might reset the PHY when
+	 * mng is using it.  If link is down or the flag to force full link
+	 * reset is set, then perform link reset.
+	 */
+	if (hw->force_full_reset) {
+		rst_delay = (rd32(hw, TXGBE_MIS_RST_ST) &
+			     TXGBE_MIS_RST_ST_RST_INIT) >>
+			     TXGBE_MIS_RST_ST_RST_INI_SHIFT;
+		if (hw->reset_type == TXGBE_SW_RESET) {
+			for (i = 0; i < rst_delay + 20; i++) {
+				reset_status =
+					rd32(hw, TXGBE_MIS_RST_ST);
+				if (!(reset_status &
+				    TXGBE_MIS_RST_ST_DEV_RST_ST_MASK))
+					break;
+				msleep(100);
+			}
+
+			if (reset_status & TXGBE_MIS_RST_ST_DEV_RST_ST_MASK) {
+				status = TXGBE_ERR_RESET_FAILED;
+				DEBUGOUT("Global reset polling failed to complete.\n");
+				goto reset_hw_out;
+			}
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_SW_RESET);
+			if (status != 0)
+				goto reset_hw_out;
+		} else if (hw->reset_type == TXGBE_GLOBAL_RESET) {
+			struct txgbe_adapter *adapter =
+					(struct txgbe_adapter *)hw->back;
+			msleep(100 * rst_delay + 2000);
+			pci_restore_state(adapter->pdev);
+			pci_save_state(adapter->pdev);
+			pci_wake_from_d3(adapter->pdev, false);
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
+		usec_delay(10);
+
+		if (hw->bus.lan_id == 0)
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST);
+		else
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST);
+
+		if (status != 0)
+			goto reset_hw_out;
+	}
+
+	status = txgbe_reset_misc(hw);
+	if (status != 0)
+		goto reset_hw_out;
+
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
+	pci_set_master(((struct txgbe_adapter *)hw->back)->pdev);
+
+reset_hw_out:
+	return status;
+}
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
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
new file mode 100644
index 000000000000..318c7f0dc5b9
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_HW_H_
+#define _TXGBE_HW_H_
+
+s32 txgbe_init_hw(struct txgbe_hw *hw);
+s32 txgbe_start_hw(struct txgbe_hw *hw);
+s32 txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
+s32 txgbe_get_bus_info(struct txgbe_hw *hw);
+void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
+void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
+s32 txgbe_stop_adapter(struct txgbe_hw *hw);
+
+s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		  u32 enable_addr);
+s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
+s32 txgbe_init_rx_addrs(struct txgbe_hw *hw);
+
+s32 txgbe_disable_pcie_master(struct txgbe_hw *hw);
+
+s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
+
+s32 txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
+s32 txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+s32 txgbe_init_uta_tables(struct txgbe_hw *hw);
+
+s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
+void txgbe_disable_rx(struct txgbe_hw *hw);
+int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
+
+int txgbe_reset_misc(struct txgbe_hw *hw);
+s32 txgbe_reset_hw(struct txgbe_hw *hw);
+s32 txgbe_init_ops(struct txgbe_hw *hw);
+
+#endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 54d73679e7c9..a1441af5b46b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -5,11 +5,14 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/vmalloc.h>
+#include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
 
 #include "txgbe.h"
+#include "txgbe_hw.h"
 
 char txgbe_driver_name[32] = TXGBE_NAME;
 static const char txgbe_driver_string[] =
@@ -44,6 +47,54 @@ static struct workqueue_struct *txgbe_wq;
 
 static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev);
 
+static void txgbe_check_minimum_link(struct txgbe_adapter *adapter,
+				     int expected_gts)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct pci_dev *pdev;
+
+	/* Some devices are not connected over PCIe and thus do not negotiate
+	 * speed. These devices do not have valid bus info, and thus any report
+	 * we generate may not be correct.
+	 */
+	if (hw->bus.type == txgbe_bus_type_internal)
+		return;
+
+	pdev = adapter->pdev;
+	pcie_print_link_status(pdev);
+}
+
+/**
+ * txgbe_enumerate_functions - Get the number of ports this device has
+ * @adapter: adapter structure
+ *
+ * This function enumerates the phsyical functions co-located on a single slot,
+ * in order to determine how many ports a device has. This is most useful in
+ * determining the required GT/s of PCIe bandwidth necessary for optimal
+ * performance.
+ **/
+static inline int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
+{
+	struct pci_dev *entry, *pdev = adapter->pdev;
+	int physfns = 0;
+
+	list_for_each_entry(entry, &pdev->bus->devices, bus_list) {
+		/* When the devices on the bus don't all match our device ID,
+		 * we can't reliably determine the correct number of
+		 * functions. This can occur if a function has been direct
+		 * attached to a virtual machine using VT-d, for example. In
+		 * this case, simply return -1 to indicate this.
+		 */
+		if (entry->vendor != pdev->vendor ||
+		    entry->device != pdev->device)
+			return -1;
+
+		physfns++;
+	}
+
+	return physfns;
+}
+
 void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
 {
 	if (!test_bit(__TXGBE_DOWN, &adapter->state) &&
@@ -52,6 +103,15 @@ void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
 		queue_work(txgbe_wq, &adapter->service_task);
 }
 
+static void txgbe_service_event_complete(struct txgbe_adapter *adapter)
+{
+	BUG_ON(!test_bit(__TXGBE_SERVICE_SCHED, &adapter->state));
+
+	/* flush memory to make sure state is correct before next watchdog */
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
+}
+
 static void txgbe_remove_adapter(struct txgbe_hw *hw)
 {
 	struct txgbe_adapter *adapter = hw->back;
@@ -64,6 +124,151 @@ static void txgbe_remove_adapter(struct txgbe_hw *hw)
 		txgbe_service_event_schedule(adapter);
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
+	u32 i;
+	struct txgbe_hw *hw = &adapter->hw;
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
+	struct txgbe_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
+	int err;
+	u8 old_addr[ETH_ALEN];
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+
+	err = TCALL(hw, mac.ops.init_hw);
+	switch (err) {
+	case 0:
+		break;
+	case TXGBE_ERR_MASTER_REQUESTS_PENDING:
+		txgbe_dev_err("master disable timed out\n");
+		break;
+	default:
+		txgbe_dev_err("Hardware Error: %d\n", err);
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
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
+		return; /* do nothing if already down */
+
+	txgbe_disable_pcie_master(hw);
+	/* disable receives */
+	TCALL(hw, mac.ops.disable_rx);
+
+	/* call carrier off first to avoid false dev_watchdog timeouts */
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	del_timer_sync(&adapter->service_timer);
+
+	if (hw->bus.lan_id == 0)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
+	else if (hw->bus.lan_id == 1)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN1_UP, 0);
+	else
+		txgbe_dev_err("%s: invalid bus lan id %d\n", __func__,
+			      hw->bus.lan_id);
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
+/**
+ *  txgbe_init_shared_code - Initialize the shared code
+ *  @hw: pointer to hardware structure
+ *
+ *  This will assign function pointers and assign the MAC type and PHY code.
+ **/
+s32 txgbe_init_shared_code(struct txgbe_hw *hw)
+{
+	s32 status;
+
+	status = txgbe_init_ops(hw);
+	return status;
+}
+
 /**
  * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
  * @adapter: board private structure to initialize
@@ -98,6 +303,28 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		goto out;
 	}
 
+	err = txgbe_init_shared_code(hw);
+	if (err) {
+		txgbe_err(probe, "init_shared_code failed: %d\n", err);
+		goto out;
+	}
+	adapter->mac_table = kzalloc(sizeof(*adapter->mac_table) *
+				     hw->mac.num_rar_entries,
+				     GFP_ATOMIC);
+	if (!adapter->mac_table) {
+		err = TXGBE_ERR_OUT_OF_MEM;
+		txgbe_err(probe, "mac_table allocation failed: %d\n", err);
+		goto out;
+	}
+
+	/* enable itr by default in dynamic mode */
+	adapter->rx_itr_setting = 1;
+	adapter->tx_itr_setting = 1;
+
+	adapter->atr_sample_rate = 20;
+
+	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
+
 	set_bit(__TXGBE_DOWN, &adapter->state);
 out:
 	return err;
@@ -128,6 +355,91 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_service_timer - Timer Call-back
+ * @data: pointer to adapter cast into an unsigned long
+ **/
+static void txgbe_service_timer(struct timer_list *t)
+{
+	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
+	unsigned long next_event_offset;
+
+	next_event_offset = HZ * 2;
+
+	/* Reset the timer */
+	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
+
+	txgbe_service_event_schedule(adapter);
+}
+
+/**
+ * txgbe_service_task - manages and runs subtasks
+ * @work: pointer to work_struct containing our data
+ **/
+static void txgbe_service_task(struct work_struct *work)
+{
+	struct txgbe_adapter *adapter = container_of(work,
+						     struct txgbe_adapter,
+						     service_task);
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			rtnl_lock();
+			txgbe_down(adapter);
+			rtnl_unlock();
+		}
+		txgbe_service_event_complete(adapter);
+		return;
+	}
+
+	txgbe_service_event_complete(adapter);
+}
+
+/**
+ * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
+ * netdev->dev_addr_list
+ * @netdev: network interface device structure
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
+ * @netdev: network interface device structure
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
 /**
  * txgbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -145,7 +457,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct txgbe_adapter *adapter = NULL;
 	struct txgbe_hw *hw = NULL;
-	int err, pci_using_dac;
+	int err, pci_using_dac, expected_gts;
 	unsigned int indices = MAX_TX_QUEUES;
 	bool disable_dev = false;
 
@@ -222,6 +534,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_ioremap;
 	}
 
+	netdev->watchdog_timeo = 5 * HZ;
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	/* setup the private structure */
@@ -229,7 +542,91 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_sw_init;
 
+	TCALL(hw, mac.ops.set_lan_id);
+
+	/* check if flash load is done after hw power up */
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
+	if (err)
+		goto err_sw_init;
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
+	if (err)
+		goto err_sw_init;
+
+	err = TCALL(hw, mac.ops.reset_hw);
+	if (err) {
+		txgbe_dev_err("HW Init failed: %d\n", err);
+		goto err_sw_init;
+	}
+
+	eth_hw_addr_set(netdev, hw->mac.perm_addr);
+
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
+		txgbe_dev_err("invalid MAC address\n");
+		err = -EIO;
+		goto err_sw_init;
+	}
+
+	txgbe_mac_set_default_filter(adapter, hw->mac.perm_addr);
+
+	timer_setup(&adapter->service_timer, txgbe_service_timer, 0);
+
+	if (TXGBE_REMOVED(hw->hw_addr)) {
+		err = -EIO;
+		goto err_sw_init;
+	}
+	INIT_WORK(&adapter->service_task, txgbe_service_task);
+	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
+	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
+
+	/* reset the hardware with the new settings */
+	err = TCALL(hw, mac.ops.start_hw);
+	if (err) {
+		txgbe_dev_err("HW init failed\n");
+		goto err_register;
+	}
+
+	/* pick up the PCI bus settings for reporting later */
+	TCALL(hw, mac.ops.get_bus_info);
+
+	strcpy(netdev->name, "eth%d");
+	err = register_netdev(netdev);
+	if (err)
+		goto err_register;
+
+	pci_set_drvdata(pdev, adapter);
+	adapter->netdev_registered = true;
+
+	/* carrier off reporting is important to ethtool even BEFORE open */
+	netif_carrier_off(netdev);
+
+	/* calculate the expected PCIe bandwidth required for optimal
+	 * performance. Note that some older parts will never have enough
+	 * bandwidth due to being older generation PCIe parts. We clamp these
+	 * parts to ensure that no warning is displayed, as this could confuse
+	 * users otherwise.
+	 */
+	expected_gts = txgbe_enumerate_functions(adapter) * 10;
+
+	/* don't check link if we failed to enumerate functions */
+	if (expected_gts > 0)
+		txgbe_check_minimum_link(adapter, expected_gts);
+
+	if ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)
+		txgbe_info(probe, "NCSI : support");
+	else
+		txgbe_info(probe, "NCSI : unsupported");
+
+	txgbe_dev_info("%02x:%02x:%02x:%02x:%02x:%02x\n",
+		       netdev->dev_addr[0], netdev->dev_addr[1],
+		       netdev->dev_addr[2], netdev->dev_addr[3],
+		       netdev->dev_addr[4], netdev->dev_addr[5]);
+
+	/* add san mac addr to netdev */
+	txgbe_add_sanmac_netdev(netdev);
+
+err_register:
 err_sw_init:
+	kfree(adapter->mac_table);
 	iounmap(adapter->io_addr);
 err_ioremap:
 	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
@@ -267,10 +664,19 @@ static void txgbe_remove(struct pci_dev *pdev)
 	set_bit(__TXGBE_REMOVING, &adapter->state);
 	cancel_work_sync(&adapter->service_task);
 
+	/* remove the added san mac */
+	txgbe_del_sanmac_netdev(netdev);
+
+	if (adapter->netdev_registered) {
+		unregister_netdev(netdev);
+		adapter->netdev_registered = false;
+	}
+
 	iounmap(adapter->io_addr);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
+	kfree(adapter->mac_table);
 	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 
@@ -292,6 +698,20 @@ static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
 	return false;
 }
 
+u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg)
+{
+	struct txgbe_adapter *adapter = hw->back;
+	u16 value;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return TXGBE_FAILED_READ_CFG_WORD;
+	pci_read_config_word(adapter->pdev, reg, &value);
+	if (value == TXGBE_FAILED_READ_CFG_WORD &&
+	    txgbe_check_cfg_remove(hw, adapter->pdev))
+		return TXGBE_FAILED_READ_CFG_WORD;
+	return value;
+}
+
 static struct pci_driver txgbe_driver = {
 	.name     = txgbe_driver_name,
 	.id_table = txgbe_pci_tbl,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ba9306982317..60b1c3a2ac50 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -73,15 +73,1743 @@
 /* Revision ID */
 #define TXGBE_SP_MPW  1
 
+/**************** Global Registers ****************************/
+/* chip control Registers */
+#define TXGBE_MIS_RST                   0x1000C
+#define TXGBE_MIS_PWR                   0x10000
+#define TXGBE_MIS_CTL                   0x10004
+#define TXGBE_MIS_PF_SM                 0x10008
+#define TXGBE_MIS_PRB_CTL               0x10010
+#define TXGBE_MIS_ST                    0x10028
+#define TXGBE_MIS_SWSM                  0x1002C
+#define TXGBE_MIS_RST_ST                0x10030
+
+#define TXGBE_MIS_RST_SW_RST            0x00000001U
+#define TXGBE_MIS_RST_LAN0_RST          0x00000002U
+#define TXGBE_MIS_RST_LAN1_RST          0x00000004U
+#define TXGBE_MIS_RST_LAN0_CHG_ETH_MODE 0x20000000U
+#define TXGBE_MIS_RST_LAN1_CHG_ETH_MODE 0x40000000U
+#define TXGBE_MIS_RST_GLOBAL_RST        0x80000000U
+#define TXGBE_MIS_RST_MASK      (TXGBE_MIS_RST_SW_RST | \
+				 TXGBE_MIS_RST_LAN0_RST | \
+				 TXGBE_MIS_RST_LAN1_RST)
+#define TXGBE_MIS_PWR_LAN_ID(_r)        ((0xC0000000U & (_r)) >> 30)
+#define TXGBE_MIS_PWR_LAN_ID_0          (1)
+#define TXGBE_MIS_PWR_LAN_ID_1          (2)
+#define TXGBE_MIS_PWR_LAN_ID_A          (3)
+#define TXGBE_MIS_ST_MNG_INIT_DN        0x00000001U
+#define TXGBE_MIS_ST_MNG_VETO           0x00000100U
+#define TXGBE_MIS_ST_LAN0_ECC           0x00010000U
+#define TXGBE_MIS_ST_LAN1_ECC           0x00020000U
+#define TXGBE_MIS_ST_MNG_ECC            0x00040000U
+#define TXGBE_MIS_ST_PCORE_ECC          0x00080000U
+#define TXGBE_MIS_ST_PCIWRP_ECC         0x00100000U
+#define TXGBE_MIS_SWSM_SMBI             1
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_DONE        0x00000000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_REQ         0x00080000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_INPROGRESS  0x00100000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_MASK        0x00180000U
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK      0x00070000U
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT     16
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST    0x3
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST 0x5
+#define TXGBE_MIS_RST_ST_RST_INIT       0x0000FF00U
+#define TXGBE_MIS_RST_ST_RST_INI_SHIFT  8
+#define TXGBE_MIS_RST_ST_RST_TIM        0x000000FFU
+#define TXGBE_MIS_PF_SM_SM              1
+#define TXGBE_MIS_PRB_CTL_LAN0_UP       0x2
+#define TXGBE_MIS_PRB_CTL_LAN1_UP       0x1
+
+/* Sensors for PVT(Process Voltage Temperature) */
+#define TXGBE_TS_CTL                    0x10300
+#define TXGBE_TS_EN                     0x10304
+#define TXGBE_TS_ST                     0x10308
+#define TXGBE_TS_ALARM_THRE             0x1030C
+#define TXGBE_TS_DALARM_THRE            0x10310
+#define TXGBE_TS_INT_EN                 0x10314
+#define TXGBE_TS_ALARM_ST               0x10318
+#define TXGBE_TS_ALARM_ST_DALARM        0x00000002U
+#define TXGBE_TS_ALARM_ST_ALARM         0x00000001U
+
+#define TXGBE_TS_CTL_EVAL_MD            0x80000000U
+#define TXGBE_TS_EN_ENA                 0x00000001U
+#define TXGBE_TS_ST_DATA_OUT_MASK       0x000003FFU
+#define TXGBE_TS_ALARM_THRE_MASK        0x000003FFU
+#define TXGBE_TS_DALARM_THRE_MASK       0x000003FFU
+#define TXGBE_TS_INT_EN_DALARM_INT_EN   0x00000002U
+#define TXGBE_TS_INT_EN_ALARM_INT_EN    0x00000001U
+
+struct txgbe_thermal_diode_data {
+	s16 temp;
+	s16 alarm_thresh;
+	s16 dalarm_thresh;
+};
+
+struct txgbe_thermal_sensor_data {
+	struct txgbe_thermal_diode_data sensor;
+};
+
+/* FMGR Registers */
+#define TXGBE_SPI_ILDR_STATUS           0x10120
+#define TXGBE_SPI_ILDR_STATUS_PERST     0x00000001U /* PCIE_PERST is done */
+#define TXGBE_SPI_ILDR_STATUS_PWRRST    0x00000002U /* Power on reset is done */
+#define TXGBE_SPI_ILDR_STATUS_SW_RESET  0x00000080U /* software reset is done */
+#define TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST 0x00000200U /* lan0 soft reset done */
+#define TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST 0x00000400U /* lan1 soft reset done */
+
+#define TXGBE_MAX_FLASH_LOAD_POLL_TIME  10
+
+#define TXGBE_SPI_CMD                   0x10104
+#define TXGBE_SPI_CMD_CMD(_v)           (((_v) & 0x7) << 28)
+#define TXGBE_SPI_CMD_CLK(_v)           (((_v) & 0x7) << 25)
+#define TXGBE_SPI_CMD_ADDR(_v)          (((_v) & 0xFFFFFF))
+#define TXGBE_SPI_DATA                  0x10108
+#define TXGBE_SPI_DATA_BYPASS           ((0x1) << 31)
+#define TXGBE_SPI_DATA_STATUS(_v)       (((_v) & 0xFF) << 16)
+#define TXGBE_SPI_DATA_OP_DONE          ((0x1))
+
+#define TXGBE_SPI_STATUS                0x1010C
+#define TXGBE_SPI_STATUS_OPDONE         ((0x1))
+#define TXGBE_SPI_STATUS_FLASH_BYPASS   ((0x1) << 31)
+
+#define TXGBE_SPI_USR_CMD               0x10110
+#define TXGBE_SPI_CMDCFG0               0x10114
+#define TXGBE_SPI_CMDCFG1               0x10118
+#define TXGBE_SPI_ECC_CTL               0x10130
+#define TXGBE_SPI_ECC_INJ               0x10134
+#define TXGBE_SPI_ECC_ST                0x10138
+#define TXGBE_SPI_ILDR_SWPTR            0x10124
+
+/************************* Port Registers ************************************/
+/* I2C registers */
+#define TXGBE_I2C_CON                   0x14900 /* I2C Control */
+#define TXGBE_I2C_CON_SLAVE_DISABLE     ((1 << 6))
+#define TXGBE_I2C_CON_RESTART_EN        ((1 << 5))
+#define TXGBE_I2C_CON_10BITADDR_MASTER  ((1 << 4))
+#define TXGBE_I2C_CON_10BITADDR_SLAVE   ((1 << 3))
+#define TXGBE_I2C_CON_SPEED(_v)         (((_v) & 0x3) << 1)
+#define TXGBE_I2C_CON_MASTER_MODE       ((1 << 0))
+#define TXGBE_I2C_TAR                   0x14904 /* I2C Target Address */
+#define TXGBE_I2C_DATA_CMD              0x14910 /* I2C Rx/Tx Data Buf and Cmd */
+#define TXGBE_I2C_DATA_CMD_STOP         ((1 << 9))
+#define TXGBE_I2C_DATA_CMD_READ         ((1 << 8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_DATA_CMD_WRITE        ((0 << 8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_SS_SCL_HCNT           0x14914 /* Standard speed I2C Clock SCL High Count */
+#define TXGBE_I2C_SS_SCL_LCNT           0x14918 /* Standard speed I2C Clock SCL Low Count */
+#define TXGBE_I2C_FS_SCL_HCNT           0x1491C
+#define TXGBE_I2C_FS_SCL_LCNT           0x14920
+#define TXGBE_I2C_HS_SCL_HCNT           0x14924 /* High speed I2C Clock SCL High Count */
+#define TXGBE_I2C_HS_SCL_LCNT           0x14928 /* High speed I2C Clock SCL Low Count */
+#define TXGBE_I2C_INTR_STAT             0x1492C /* I2C Interrupt Status */
+#define TXGBE_I2C_RAW_INTR_STAT         0x14934 /* I2C Raw Interrupt Status */
+#define TXGBE_I2C_INTR_STAT_RX_FULL     ((0x1) << 2)
+#define TXGBE_I2C_INTR_STAT_TX_EMPTY    ((0x1) << 4)
+#define TXGBE_I2C_INTR_MASK             0x14930 /* I2C Interrupt Mask */
+#define TXGBE_I2C_RX_TL                 0x14938 /* I2C Receive FIFO Threshold */
+#define TXGBE_I2C_TX_TL                 0x1493C /* I2C TX FIFO Threshold */
+#define TXGBE_I2C_CLR_INTR              0x14940 /* Clear Combined and Individual Int */
+#define TXGBE_I2C_CLR_RX_UNDER          0x14944 /* Clear RX_UNDER Interrupt */
+#define TXGBE_I2C_CLR_RX_OVER           0x14948 /* Clear RX_OVER Interrupt */
+#define TXGBE_I2C_CLR_TX_OVER           0x1494C /* Clear TX_OVER Interrupt */
+#define TXGBE_I2C_CLR_RD_REQ            0x14950 /* Clear RD_REQ Interrupt */
+#define TXGBE_I2C_CLR_TX_ABRT           0x14954 /* Clear TX_ABRT Interrupt */
+#define TXGBE_I2C_CLR_RX_DONE           0x14958 /* Clear RX_DONE Interrupt */
+#define TXGBE_I2C_CLR_ACTIVITY          0x1495C /* Clear ACTIVITY Interrupt */
+#define TXGBE_I2C_CLR_STOP_DET          0x14960 /* Clear STOP_DET Interrupt */
+#define TXGBE_I2C_CLR_START_DET         0x14964 /* Clear START_DET Interrupt */
+#define TXGBE_I2C_CLR_GEN_CALL          0x14968 /* Clear GEN_CALL Interrupt */
+#define TXGBE_I2C_ENABLE                0x1496C /* I2C Enable */
+#define TXGBE_I2C_STATUS                0x14970 /* I2C Status register */
+#define TXGBE_I2C_STATUS_MST_ACTIVITY   ((1U << 5))
+#define TXGBE_I2C_TXFLR                 0x14974 /* Transmit FIFO Level Reg */
+#define TXGBE_I2C_RXFLR                 0x14978 /* Receive FIFO Level Reg */
+#define TXGBE_I2C_SDA_HOLD              0x1497C /* SDA hold time length reg */
+#define TXGBE_I2C_TX_ABRT_SOURCE        0x14980 /* I2C TX Abort Status Reg */
+#define TXGBE_I2C_SDA_SETUP             0x14994 /* I2C SDA Setup Register */
+#define TXGBE_I2C_ENABLE_STATUS         0x1499C /* I2C Enable Status Register */
+#define TXGBE_I2C_FS_SPKLEN             0x149A0 /* ISS and FS spike suppression limit */
+#define TXGBE_I2C_HS_SPKLEN             0x149A4 /* HS spike suppression limit */
+#define TXGBE_I2C_SCL_STUCK_TIMEOUT     0x149AC /* I2C SCL stuck at low timeout register */
+#define TXGBE_I2C_SDA_STUCK_TIMEOUT     0x149B0 /*I2C SDA Stuck at Low Timeout*/
+#define TXGBE_I2C_CLR_SCL_STUCK_DET     0x149B4 /* Clear SCL Stuck at Low Detect Interrupt */
+#define TXGBE_I2C_DEVICE_ID             0x149b8 /* I2C Device ID */
+#define TXGBE_I2C_COMP_PARAM_1          0x149f4 /* Component Parameter Reg */
+#define TXGBE_I2C_COMP_VERSION          0x149f8 /* Component Version ID */
+#define TXGBE_I2C_COMP_TYPE             0x149fc /* DesignWare Component Type Reg */
+
+#define TXGBE_I2C_SLAVE_ADDR            (0xA0 >> 1)
+#define TXGBE_I2C_THERMAL_SENSOR_ADDR   0xF8
+
+/* port cfg Registers */
+#define TXGBE_CFG_PORT_CTL              0x14400
+#define TXGBE_CFG_PORT_ST               0x14404
+#define TXGBE_CFG_EX_VTYPE              0x14408
+#define TXGBE_CFG_LED_CTL               0x14424
+#define TXGBE_CFG_VXLAN                 0x14410
+#define TXGBE_CFG_VXLAN_GPE             0x14414
+#define TXGBE_CFG_GENEVE                0x14418
+#define TXGBE_CFG_TEREDO                0x1441C
+#define TXGBE_CFG_TCP_TIME              0x14420
+#define TXGBE_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
+/* port cfg bit */
+#define TXGBE_CFG_PORT_CTL_PFRSTD       0x00004000U /* Phy Function Reset Done */
+#define TXGBE_CFG_PORT_CTL_D_VLAN       0x00000001U /* double vlan*/
+#define TXGBE_CFG_PORT_CTL_ETAG_ETYPE_VLD 0x00000002U
+#define TXGBE_CFG_PORT_CTL_QINQ         0x00000004U
+#define TXGBE_CFG_PORT_CTL_DRV_LOAD     0x00000008U
+#define TXGBE_CFG_PORT_CTL_FORCE_LKUP   0x00000010U /* force link up */
+#define TXGBE_CFG_PORT_CTL_DCB_EN       0x00000400U /* dcb enabled */
+#define TXGBE_CFG_PORT_CTL_NUM_TC_MASK  0x00000800U /* number of TCs */
+#define TXGBE_CFG_PORT_CTL_NUM_TC_4     0x00000000U
+#define TXGBE_CFG_PORT_CTL_NUM_TC_8     0x00000800U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_MASK  0x00003000U /* number of TVs */
+#define TXGBE_CFG_PORT_CTL_NUM_VT_NONE  0x00000000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_16    0x00001000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_32    0x00002000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_64    0x00003000U
+/* Status Bit */
+#define TXGBE_CFG_PORT_ST_LINK_UP       0x00000001U
+#define TXGBE_CFG_PORT_ST_LINK_10G      0x00000002U
+#define TXGBE_CFG_PORT_ST_LINK_1G       0x00000004U
+#define TXGBE_CFG_PORT_ST_LINK_100M     0x00000008U
+#define TXGBE_CFG_PORT_ST_LAN_ID(_r)    ((0x00000100U & (_r)) >> 8)
+#define TXGBE_LINK_UP_TIME              90
+/* LED CTL Bit */
+#define TXGBE_CFG_LED_CTL_LINK_BSY_SEL  0x00000010U
+#define TXGBE_CFG_LED_CTL_LINK_100M_SEL 0x00000008U
+#define TXGBE_CFG_LED_CTL_LINK_1G_SEL   0x00000004U
+#define TXGBE_CFG_LED_CTL_LINK_10G_SEL  0x00000002U
+#define TXGBE_CFG_LED_CTL_LINK_UP_SEL   0x00000001U
+#define TXGBE_CFG_LED_CTL_LINK_OD_SHIFT 16
+/* LED modes */
+#define TXGBE_LED_LINK_UP               TXGBE_CFG_LED_CTL_LINK_UP_SEL
+#define TXGBE_LED_LINK_10G              TXGBE_CFG_LED_CTL_LINK_10G_SEL
+#define TXGBE_LED_LINK_ACTIVE           TXGBE_CFG_LED_CTL_LINK_BSY_SEL
+#define TXGBE_LED_LINK_1G               TXGBE_CFG_LED_CTL_LINK_1G_SEL
+#define TXGBE_LED_LINK_100M             TXGBE_CFG_LED_CTL_LINK_100M_SEL
+
+/* GPIO Registers */
+#define TXGBE_GPIO_DR                   0x14800
+#define TXGBE_GPIO_DDR                  0x14804
+#define TXGBE_GPIO_CTL                  0x14808
+#define TXGBE_GPIO_INTEN                0x14830
+#define TXGBE_GPIO_INTMASK              0x14834
+#define TXGBE_GPIO_INTTYPE_LEVEL        0x14838
+#define TXGBE_GPIO_INTSTATUS            0x14844
+#define TXGBE_GPIO_EOI                  0x1484C
+/*GPIO bit */
+#define TXGBE_GPIO_DR_0         0x00000001U /* SDP0 Data Value */
+#define TXGBE_GPIO_DR_1         0x00000002U /* SDP1 Data Value */
+#define TXGBE_GPIO_DR_2         0x00000004U /* SDP2 Data Value */
+#define TXGBE_GPIO_DR_3         0x00000008U /* SDP3 Data Value */
+#define TXGBE_GPIO_DR_4         0x00000010U /* SDP4 Data Value */
+#define TXGBE_GPIO_DR_5         0x00000020U /* SDP5 Data Value */
+#define TXGBE_GPIO_DR_6         0x00000040U /* SDP6 Data Value */
+#define TXGBE_GPIO_DR_7         0x00000080U /* SDP7 Data Value */
+#define TXGBE_GPIO_DDR_0        0x00000001U /* SDP0 IO direction */
+#define TXGBE_GPIO_DDR_1        0x00000002U /* SDP1 IO direction */
+#define TXGBE_GPIO_DDR_2        0x00000004U /* SDP1 IO direction */
+#define TXGBE_GPIO_DDR_3        0x00000008U /* SDP3 IO direction */
+#define TXGBE_GPIO_DDR_4        0x00000010U /* SDP4 IO direction */
+#define TXGBE_GPIO_DDR_5        0x00000020U /* SDP5 IO direction */
+#define TXGBE_GPIO_DDR_6        0x00000040U /* SDP6 IO direction */
+#define TXGBE_GPIO_DDR_7        0x00000080U /* SDP7 IO direction */
+#define TXGBE_GPIO_CTL_SW_MODE  0x00000000U /* SDP software mode */
+#define TXGBE_GPIO_INTEN_1      0x00000002U /* SDP1 interrupt enable */
+#define TXGBE_GPIO_INTEN_2      0x00000004U /* SDP2 interrupt enable */
+#define TXGBE_GPIO_INTEN_3      0x00000008U /* SDP3 interrupt enable */
+#define TXGBE_GPIO_INTEN_5      0x00000020U /* SDP5 interrupt enable */
+#define TXGBE_GPIO_INTEN_6      0x00000040U /* SDP6 interrupt enable */
+#define TXGBE_GPIO_INTTYPE_LEVEL_2 0x00000004U /* SDP2 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_3 0x00000008U /* SDP3 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_5 0x00000020U /* SDP5 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_6 0x00000040U /* SDP6 interrupt type level */
+#define TXGBE_GPIO_INTSTATUS_1  0x00000002U /* SDP1 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_2  0x00000004U /* SDP2 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_3  0x00000008U /* SDP3 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_5  0x00000020U /* SDP5 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_6  0x00000040U /* SDP6 interrupt status */
+#define TXGBE_GPIO_EOI_2        0x00000004U /* SDP2 interrupt clear */
+#define TXGBE_GPIO_EOI_3        0x00000008U /* SDP3 interrupt clear */
+#define TXGBE_GPIO_EOI_5        0x00000020U /* SDP5 interrupt clear */
+#define TXGBE_GPIO_EOI_6        0x00000040U /* SDP6 interrupt clear */
+
+/* TPH registers */
+#define TXGBE_CFG_TPH_TDESC     0x14F00 /* TPH conf for Tx desc write back */
+#define TXGBE_CFG_TPH_RDESC     0x14F04 /* TPH conf for Rx desc write back */
+#define TXGBE_CFG_TPH_RHDR      0x14F08 /* TPH conf for writing Rx pkt header */
+#define TXGBE_CFG_TPH_RPL       0x14F0C /* TPH conf for payload write access */
+/* TPH bit */
+#define TXGBE_CFG_TPH_TDESC_EN  0x80000000U
+#define TXGBE_CFG_TPH_TDESC_PH_SHIFT 29
+#define TXGBE_CFG_TPH_TDESC_ST_SHIFT 16
+#define TXGBE_CFG_TPH_RDESC_EN  0x80000000U
+#define TXGBE_CFG_TPH_RDESC_PH_SHIFT 29
+#define TXGBE_CFG_TPH_RDESC_ST_SHIFT 16
+#define TXGBE_CFG_TPH_RHDR_EN   0x00008000U
+#define TXGBE_CFG_TPH_RHDR_PH_SHIFT 13
+#define TXGBE_CFG_TPH_RHDR_ST_SHIFT 0
+#define TXGBE_CFG_TPH_RPL_EN    0x80000000U
+#define TXGBE_CFG_TPH_RPL_PH_SHIFT 29
+#define TXGBE_CFG_TPH_RPL_ST_SHIFT 16
+
+/*********************** Transmit DMA registers **************************/
+/* transmit global control */
+#define TXGBE_TDM_CTL           0x18000
+#define TXGBE_TDM_VF_TE(_i)     (0x18004 + ((_i) * 4))
+#define TXGBE_TDM_PB_THRE(_i)   (0x18020 + ((_i) * 4)) /* 8 of these 0 - 7 */
+#define TXGBE_TDM_LLQ(_i)       (0x18040 + ((_i) * 4)) /* 4 of these (0-3) */
+#define TXGBE_TDM_ETYPE_LB_L    0x18050
+#define TXGBE_TDM_ETYPE_LB_H    0x18054
+#define TXGBE_TDM_ETYPE_AS_L    0x18058
+#define TXGBE_TDM_ETYPE_AS_H    0x1805C
+#define TXGBE_TDM_MAC_AS_L      0x18060
+#define TXGBE_TDM_MAC_AS_H      0x18064
+#define TXGBE_TDM_VLAN_AS_L     0x18070
+#define TXGBE_TDM_VLAN_AS_H     0x18074
+#define TXGBE_TDM_TCP_FLG_L     0x18078
+#define TXGBE_TDM_TCP_FLG_H     0x1807C
+#define TXGBE_TDM_VLAN_INS(_i)  (0x18100 + ((_i) * 4)) /* 64 of these 0 - 63 */
+/* TDM CTL BIT */
+#define TXGBE_TDM_CTL_TE        0x1 /* Transmit Enable */
+#define TXGBE_TDM_CTL_PADDING   0x2 /* Padding byte number for ipsec ESP */
+#define TXGBE_TDM_CTL_VT_SHIFT  16  /* VLAN EtherType */
+/* Per VF Port VLAN insertion rules */
+#define TXGBE_TDM_VLAN_INS_VLANA_DEFAULT 0x40000000U /*Always use default VLAN*/
+#define TXGBE_TDM_VLAN_INS_VLANA_NEVER   0x80000000U /* Never insert VLAN tag */
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
+/* qos */
+#define TXGBE_TDM_PBWARB_CTL    0x18200
+#define TXGBE_TDM_PBWARB_CFG(_i) (0x18220 + ((_i) * 4)) /* 8 of these (0-7) */
+#define TXGBE_TDM_MMW           0x18208
+#define TXGBE_TDM_VM_CREDIT(_i) (0x18500 + ((_i) * 4))
+#define TXGBE_TDM_VM_CREDIT_VAL(v) (0x3FF & (v))
+/* fcoe */
+#define TXGBE_TDM_FC_EOF        0x18384
+#define TXGBE_TDM_FC_SOF        0x18380
+/* etag */
+#define TXGBE_TDM_ETAG_INS(_i)  (0x18700 + ((_i) * 4)) /* 64 of these 0 - 63 */
+/* statistic */
+#define TXGBE_TDM_SEC_DRP       0x18304
+#define TXGBE_TDM_PKT_CNT       0x18308
+#define TXGBE_TDM_OS2BMC_CNT    0x18314
+
+/**************************** Receive DMA registers **************************/
+/* receive control */
+#define TXGBE_RDM_ARB_CTL       0x12000
+#define TXGBE_RDM_VF_RE(_i)     (0x12004 + ((_i) * 4))
+#define TXGBE_RDM_RSC_CTL       0x1200C
+#define TXGBE_RDM_ARB_CFG(_i)   (0x12040 + ((_i) * 4)) /* 8 of these (0-7) */
+#define TXGBE_RDM_PF_QDE(_i)    (0x12080 + ((_i) * 4))
+#define TXGBE_RDM_PF_HIDE(_i)   (0x12090 + ((_i) * 4))
+/* VFRE bitmask */
+#define TXGBE_RDM_VF_RE_ENABLE_ALL  0xFFFFFFFFU
+
+/* FCoE DMA Context Registers */
+#define TXGBE_RDM_FCPTRL            0x12410
+#define TXGBE_RDM_FCPTRH            0x12414
+#define TXGBE_RDM_FCBUF             0x12418
+#define TXGBE_RDM_FCBUF_VALID       ((0x1)) /* DMA Context Valid */
+#define TXGBE_RDM_FCBUF_SIZE(_v)    (((_v) & 0x3) << 3) /* User Buffer Size */
+#define TXGBE_RDM_FCBUF_COUNT(_v)   (((_v) & 0xFF) << 8) /* Num of User Buf */
+#define TXGBE_RDM_FCBUF_OFFSET(_v)  (((_v) & 0xFFFF) << 16) /* User Buf Offset*/
+#define TXGBE_RDM_FCRW              0x12420
+#define TXGBE_RDM_FCRW_FCSEL(_v)    (((_v) & 0x1FF))  /* FC X_ID: 11 bits */
+#define TXGBE_RDM_FCRW_WE           ((0x1) << 14)   /* Write enable */
+#define TXGBE_RDM_FCRW_RE           ((0x1) << 15)   /* Read enable */
+#define TXGBE_RDM_FCRW_LASTSIZE(_v) (((_v) & 0xFFFF) << 16)
+
+/* statistic */
+#define TXGBE_RDM_DRP_PKT           0x12500
+#define TXGBE_RDM_BMC2OS_CNT        0x12510
+
+/***************************** RDB registers *********************************/
+/* Flow Control Registers */
+#define TXGBE_RDB_RFCV(_i)          (0x19200 + ((_i) * 4)) /* 4 of these (0-3)*/
+#define TXGBE_RDB_RFCL(_i)          (0x19220 + ((_i) * 4)) /* 8 of these (0-7)*/
+#define TXGBE_RDB_RFCH(_i)          (0x19260 + ((_i) * 4)) /* 8 of these (0-7)*/
+#define TXGBE_RDB_RFCRT             0x192A0
+#define TXGBE_RDB_RFCC              0x192A4
+/* receive packet buffer */
+#define TXGBE_RDB_PB_WRAP           0x19004
+#define TXGBE_RDB_PB_SZ(_i)         (0x19020 + ((_i) * 4))
+#define TXGBE_RDB_PB_CTL            0x19000
+#define TXGBE_RDB_UP2TC             0x19008
+#define TXGBE_RDB_PB_SZ_SHIFT       10
+#define TXGBE_RDB_PB_SZ_MASK        0x000FFC00U
+/* lli interrupt */
+#define TXGBE_RDB_LLI_THRE          0x19080
+#define TXGBE_RDB_LLI_THRE_SZ(_v)   ((0xFFF & (_v)))
+#define TXGBE_RDB_LLI_THRE_UP(_v)   ((0x7 & (_v)) << 16)
+#define TXGBE_RDB_LLI_THRE_UP_SHIFT 16
+
+/* ring assignment */
+#define TXGBE_RDB_PL_CFG(_i)    (0x19300 + ((_i) * 4))
+#define TXGBE_RDB_RSSTBL(_i)    (0x19400 + ((_i) * 4))
+#define TXGBE_RDB_RSSRK(_i)     (0x19480 + ((_i) * 4))
+#define TXGBE_RDB_RSS_TC        0x194F0
+#define TXGBE_RDB_RA_CTL        0x194F4
+#define TXGBE_RDB_5T_SA(_i)     (0x19600 + ((_i) * 4)) /* Src Addr Q Filter */
+#define TXGBE_RDB_5T_DA(_i)     (0x19800 + ((_i) * 4)) /* Dst Addr Q Filter */
+#define TXGBE_RDB_5T_SDP(_i)    (0x19A00 + ((_i) * 4)) /*Src Dst Addr Q Filter*/
+#define TXGBE_RDB_5T_CTL0(_i)   (0x19C00 + ((_i) * 4)) /* Five Tuple Q Filter */
+#define TXGBE_RDB_ETYPE_CLS(_i) (0x19100 + ((_i) * 4)) /* EType Q Select */
+#define TXGBE_RDB_SYN_CLS       0x19130
+#define TXGBE_RDB_5T_CTL1(_i)   (0x19E00 + ((_i) * 4)) /*128 of these (0-127)*/
+/* Flow Director registers */
+#define TXGBE_RDB_FDIR_CTL          0x19500
+#define TXGBE_RDB_FDIR_HKEY         0x19568
+#define TXGBE_RDB_FDIR_SKEY         0x1956C
+#define TXGBE_RDB_FDIR_DA4_MSK      0x1953C
+#define TXGBE_RDB_FDIR_SA4_MSK      0x19540
+#define TXGBE_RDB_FDIR_TCP_MSK      0x19544
+#define TXGBE_RDB_FDIR_UDP_MSK      0x19548
+#define TXGBE_RDB_FDIR_SCTP_MSK     0x19560
+#define TXGBE_RDB_FDIR_IP6_MSK      0x19574
+#define TXGBE_RDB_FDIR_OTHER_MSK    0x19570
+#define TXGBE_RDB_FDIR_FLEX_CFG(_i) (0x19580 + ((_i) * 4))
+/* Flow Director Stats registers */
+#define TXGBE_RDB_FDIR_FREE         0x19538
+#define TXGBE_RDB_FDIR_LEN          0x1954C
+#define TXGBE_RDB_FDIR_USE_ST       0x19550
+#define TXGBE_RDB_FDIR_FAIL_ST      0x19554
+#define TXGBE_RDB_FDIR_MATCH        0x19558
+#define TXGBE_RDB_FDIR_MISS         0x1955C
+/* Flow Director Programming registers */
+#define TXGBE_RDB_FDIR_IP6(_i)      (0x1950C + ((_i) * 4)) /* 3 of these (0-2)*/
+#define TXGBE_RDB_FDIR_SA           0x19518
+#define TXGBE_RDB_FDIR_DA           0x1951C
+#define TXGBE_RDB_FDIR_PORT         0x19520
+#define TXGBE_RDB_FDIR_FLEX         0x19524
+#define TXGBE_RDB_FDIR_HASH         0x19528
+#define TXGBE_RDB_FDIR_CMD          0x1952C
+/* VM RSS */
+#define TXGBE_RDB_VMRSSRK(_i, _p)   (0x1A000 + ((_i) * 4) + ((_p) * 0x40))
+#define TXGBE_RDB_VMRSSTBL(_i, _p)  (0x1B000 + ((_i) * 4) + ((_p) * 0x40))
+/* FCoE Redirection */
+#define TXGBE_RDB_FCRE_TBL_SIZE     (8) /* Max entries in FCRETA */
+#define TXGBE_RDB_FCRE_CTL          0x19140
+#define TXGBE_RDB_FCRE_CTL_ENA      ((0x1)) /* FCoE Redir Table Enable */
+#define TXGBE_RDB_FCRE_TBL(_i)      (0x19160 + ((_i) * 4))
+#define TXGBE_RDB_FCRE_TBL_RING(_v) (((_v) & 0x7F)) /* output queue number */
+/* statistic */
+#define TXGBE_RDB_MPCNT(_i)         (0x19040 + ((_i) * 4)) /* 8 of 3FA0-3FBC*/
+#define TXGBE_RDB_LXONTXC           0x1921C
+#define TXGBE_RDB_LXOFFTXC          0x19218
+#define TXGBE_RDB_PXON2OFFCNT(_i)   (0x19280 + ((_i) * 4)) /* 8 of these */
+#define TXGBE_RDB_PXONTXC(_i)       (0x192E0 + ((_i) * 4)) /* 8 of 3F00-3F1C*/
+#define TXGBE_RDB_PXOFFTXC(_i)      (0x192C0 + ((_i) * 4)) /* 8 of 3F20-3F3C*/
+#define TXGBE_RDB_PFCMACDAL         0x19210
+#define TXGBE_RDB_PFCMACDAH         0x19214
+#define TXGBE_RDB_TXSWERR           0x1906C
+#define TXGBE_RDB_TXSWERR_TB_FREE   0x3FF
+/* rdb_pl_cfg reg mask */
+#define TXGBE_RDB_PL_CFG_L4HDR          0x2
+#define TXGBE_RDB_PL_CFG_L3HDR          0x4
+#define TXGBE_RDB_PL_CFG_L2HDR          0x8
+#define TXGBE_RDB_PL_CFG_TUN_OUTER_L2HDR 0x20
+#define TXGBE_RDB_PL_CFG_TUN_TUNHDR     0x10
+#define TXGBE_RDB_PL_CFG_RSS_PL_MASK    0x7
+#define TXGBE_RDB_PL_CFG_RSS_PL_SHIFT   29
+/* RQTC Bit Masks and Shifts */
+#define TXGBE_RDB_RSS_TC_SHIFT_TC(_i)   ((_i) * 4)
+#define TXGBE_RDB_RSS_TC_TC0_MASK       (0x7 << 0)
+#define TXGBE_RDB_RSS_TC_TC1_MASK       (0x7 << 4)
+#define TXGBE_RDB_RSS_TC_TC2_MASK       (0x7 << 8)
+#define TXGBE_RDB_RSS_TC_TC3_MASK       (0x7 << 12)
+#define TXGBE_RDB_RSS_TC_TC4_MASK       (0x7 << 16)
+#define TXGBE_RDB_RSS_TC_TC5_MASK       (0x7 << 20)
+#define TXGBE_RDB_RSS_TC_TC6_MASK       (0x7 << 24)
+#define TXGBE_RDB_RSS_TC_TC7_MASK       (0x7 << 28)
+/* Packet Buffer Initialization */
+#define TXGBE_MAX_PACKET_BUFFERS        8
+#define TXGBE_RDB_PB_SZ_48KB    0x00000030U /* 48KB Packet Buffer */
+#define TXGBE_RDB_PB_SZ_64KB    0x00000040U /* 64KB Packet Buffer */
+#define TXGBE_RDB_PB_SZ_80KB    0x00000050U /* 80KB Packet Buffer */
+#define TXGBE_RDB_PB_SZ_128KB   0x00000080U /* 128KB Packet Buffer */
+#define TXGBE_RDB_PB_SZ_MAX     0x00000200U /* 512KB Packet Buffer */
+
+/* Packet buffer allocation strategies */
+enum {
+	PBA_STRATEGY_EQUAL      = 0, /* Distribute PB space equally */
+#define PBA_STRATEGY_EQUAL      PBA_STRATEGY_EQUAL
+	PBA_STRATEGY_WEIGHTED   = 1, /* Weight front half of TCs */
+#define PBA_STRATEGY_WEIGHTED   PBA_STRATEGY_WEIGHTED
+};
+
+/* FCRTL Bit Masks */
+#define TXGBE_RDB_RFCL_XONE             0x80000000U /* XON enable */
+#define TXGBE_RDB_RFCH_XOFFE            0x80000000U /* Packet buffer fc enable */
+/* FCCFG Bit Masks */
+#define TXGBE_RDB_RFCC_RFCE_802_3X      0x00000008U /* Tx link FC enable */
+#define TXGBE_RDB_RFCC_RFCE_PRIORITY    0x00000010U /* Tx priority FC enable */
+
+/* Immediate Interrupt Rx (A.K.A. Low Latency Interrupt) */
+#define TXGBE_RDB_5T_CTL1_SIZE_BP       0x00001000U /* Packet size bypass */
+#define TXGBE_RDB_5T_CTL1_LLI           0x00100000U /* Enables low latency Int */
+#define TXGBE_RDB_LLI_THRE_PRIORITY_MASK 0x00070000U /* VLAN priority mask */
+#define TXGBE_RDB_LLI_THRE_PRIORITY_EN  0x00080000U /* VLAN priority enable */
+#define TXGBE_RDB_LLI_THRE_CMN_EN       0x00100000U /* cmn packet receiveed */
+
+#define TXGBE_MAX_RDB_5T_CTL0_FILTERS           128
+#define TXGBE_RDB_5T_CTL0_PROTOCOL_MASK         0x00000003U
+#define TXGBE_RDB_5T_CTL0_PROTOCOL_TCP          0x00000000U
+#define TXGBE_RDB_5T_CTL0_PROTOCOL_UDP          0x00000001U
+#define TXGBE_RDB_5T_CTL0_PROTOCOL_SCTP         2
+#define TXGBE_RDB_5T_CTL0_PRIORITY_MASK         0x00000007U
+#define TXGBE_RDB_5T_CTL0_PRIORITY_SHIFT        2
+#define TXGBE_RDB_5T_CTL0_POOL_MASK             0x0000003FU
+#define TXGBE_RDB_5T_CTL0_POOL_SHIFT            8
+#define TXGBE_RDB_5T_CTL0_5TUPLE_MASK_MASK      0x0000001FU
+#define TXGBE_RDB_5T_CTL0_5TUPLE_MASK_SHIFT     25
+#define TXGBE_RDB_5T_CTL0_SOURCE_ADDR_MASK      0x1E
+#define TXGBE_RDB_5T_CTL0_DEST_ADDR_MASK        0x1D
+#define TXGBE_RDB_5T_CTL0_SOURCE_PORT_MASK      0x1B
+#define TXGBE_RDB_5T_CTL0_DEST_PORT_MASK        0x17
+#define TXGBE_RDB_5T_CTL0_PROTOCOL_COMP_MASK    0x0F
+#define TXGBE_RDB_5T_CTL0_POOL_MASK_EN          0x40000000U
+#define TXGBE_RDB_5T_CTL0_QUEUE_ENABLE          0x80000000U
+
+#define TXGBE_RDB_ETYPE_CLS_RX_QUEUE            0x007F0000U /* bits 22:16 */
+#define TXGBE_RDB_ETYPE_CLS_RX_QUEUE_SHIFT      16
+#define TXGBE_RDB_ETYPE_CLS_LLI                 0x20000000U /* bit 29 */
+#define TXGBE_RDB_ETYPE_CLS_QUEUE_EN            0x80000000U /* bit 31 */
+
+/* Receive Config masks */
+#define TXGBE_RDB_PB_CTL_RXEN           (0x80000000) /* Enable Receiver */
+#define TXGBE_RDB_PB_CTL_DISABLED       0x1
+
+#define TXGBE_RDB_RA_CTL_RSS_EN         0x00000004U /* RSS Enable */
+#define TXGBE_RDB_RA_CTL_RSS_MASK       0xFFFF0000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV4_TCP   0x00010000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV4       0x00020000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV6       0x00100000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV6_TCP   0x00200000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV4_UDP   0x00400000U
+#define TXGBE_RDB_RA_CTL_RSS_IPV6_UDP   0x00800000U
+
+enum txgbe_fdir_pballoc_type {
+	TXGBE_FDIR_PBALLOC_NONE = 0,
+	TXGBE_FDIR_PBALLOC_64K  = 1,
+	TXGBE_FDIR_PBALLOC_128K = 2,
+	TXGBE_FDIR_PBALLOC_256K = 3,
+};
+
+/* Flow Director register values */
+#define TXGBE_RDB_FDIR_CTL_PBALLOC_64K          0x00000001U
+#define TXGBE_RDB_FDIR_CTL_PBALLOC_128K         0x00000002U
+#define TXGBE_RDB_FDIR_CTL_PBALLOC_256K         0x00000003U
+#define TXGBE_RDB_FDIR_CTL_INIT_DONE            0x00000008U
+#define TXGBE_RDB_FDIR_CTL_PERFECT_MATCH        0x00000010U
+#define TXGBE_RDB_FDIR_CTL_REPORT_STATUS        0x00000020U
+#define TXGBE_RDB_FDIR_CTL_REPORT_STATUS_ALWAYS 0x00000080U
+#define TXGBE_RDB_FDIR_CTL_DROP_Q_SHIFT         8
+#define TXGBE_RDB_FDIR_CTL_FILTERMODE_SHIFT     21
+#define TXGBE_RDB_FDIR_CTL_MAX_LENGTH_SHIFT     24
+#define TXGBE_RDB_FDIR_CTL_HASH_BITS_SHIFT      20
+#define TXGBE_RDB_FDIR_CTL_FULL_THRESH_MASK     0xF0000000U
+#define TXGBE_RDB_FDIR_CTL_FULL_THRESH_SHIFT    28
+
+#define TXGBE_RDB_FDIR_TCP_MSK_DPORTM_SHIFT     16
+#define TXGBE_RDB_FDIR_UDP_MSK_DPORTM_SHIFT     16
+#define TXGBE_RDB_FDIR_IP6_MSK_DIPM_SHIFT       16
+#define TXGBE_RDB_FDIR_OTHER_MSK_POOL           0x00000004U
+#define TXGBE_RDB_FDIR_OTHER_MSK_L4P            0x00000008U
+#define TXGBE_RDB_FDIR_OTHER_MSK_L3P            0x00000010U
+#define TXGBE_RDB_FDIR_OTHER_MSK_TUN_TYPE       0x00000020U
+#define TXGBE_RDB_FDIR_OTHER_MSK_TUN_OUTIP      0x00000040U
+#define TXGBE_RDB_FDIR_OTHER_MSK_TUN            0x00000080U
+
+#define TXGBE_RDB_FDIR_FLEX_CFG_BASE_MAC        0x00000000U
+#define TXGBE_RDB_FDIR_FLEX_CFG_BASE_IP         0x00000001U
+#define TXGBE_RDB_FDIR_FLEX_CFG_BASE_L4_HDR     0x00000002U
+#define TXGBE_RDB_FDIR_FLEX_CFG_BASE_L4_PAYLOAD 0x00000003U
+#define TXGBE_RDB_FDIR_FLEX_CFG_BASE_MSK        0x00000003U
+#define TXGBE_RDB_FDIR_FLEX_CFG_MSK             0x00000004U
+#define TXGBE_RDB_FDIR_FLEX_CFG_OFST            0x000000F8U
+#define TXGBE_RDB_FDIR_FLEX_CFG_OFST_SHIFT      3
+#define TXGBE_RDB_FDIR_FLEX_CFG_VM_SHIFT        8
+
+#define TXGBE_RDB_FDIR_PORT_DESTINATION_SHIFT   16
+#define TXGBE_RDB_FDIR_FLEX_FLEX_SHIFT          16
+#define TXGBE_RDB_FDIR_HASH_BUCKET_VALID_SHIFT  15
+#define TXGBE_RDB_FDIR_HASH_SIG_SW_INDEX_SHIFT  16
+
+#define TXGBE_RDB_FDIR_CMD_CMD_MASK             0x00000003U
+#define TXGBE_RDB_FDIR_CMD_CMD_ADD_FLOW         0x00000001U
+#define TXGBE_RDB_FDIR_CMD_CMD_REMOVE_FLOW      0x00000002U
+#define TXGBE_RDB_FDIR_CMD_CMD_QUERY_REM_FILT   0x00000003U
+#define TXGBE_RDB_FDIR_CMD_FILTER_VALID         0x00000004U
+#define TXGBE_RDB_FDIR_CMD_FILTER_UPDATE        0x00000008U
+#define TXGBE_RDB_FDIR_CMD_IPv6DMATCH           0x00000010U
+#define TXGBE_RDB_FDIR_CMD_L4TYPE_UDP           0x00000020U
+#define TXGBE_RDB_FDIR_CMD_L4TYPE_TCP           0x00000040U
+#define TXGBE_RDB_FDIR_CMD_L4TYPE_SCTP          0x00000060U
+#define TXGBE_RDB_FDIR_CMD_IPV6                 0x00000080U
+#define TXGBE_RDB_FDIR_CMD_CLEARHT              0x00000100U
+#define TXGBE_RDB_FDIR_CMD_DROP                 0x00000200U
+#define TXGBE_RDB_FDIR_CMD_INT                  0x00000400U
+#define TXGBE_RDB_FDIR_CMD_LAST                 0x00000800U
+#define TXGBE_RDB_FDIR_CMD_COLLISION            0x00001000U
+#define TXGBE_RDB_FDIR_CMD_QUEUE_EN             0x00008000U
+#define TXGBE_RDB_FDIR_CMD_FLOW_TYPE_SHIFT      5
+#define TXGBE_RDB_FDIR_CMD_RX_QUEUE_SHIFT       16
+#define TXGBE_RDB_FDIR_CMD_TUNNEL_FILTER_SHIFT  23
+#define TXGBE_RDB_FDIR_CMD_VT_POOL_SHIFT        24
+#define TXGBE_RDB_FDIR_INIT_DONE_POLL           10
+#define TXGBE_RDB_FDIR_CMD_CMD_POLL             10
+#define TXGBE_RDB_FDIR_CMD_TUNNEL_FILTER        0x00800000U
+#define TXGBE_RDB_FDIR_DROP_QUEUE               127
+#define TXGBE_FDIR_INIT_DONE_POLL               10
+
+/******************************* PSR Registers *******************************/
+/* psr control */
+#define TXGBE_PSR_CTL                   0x15000
+#define TXGBE_PSR_VLAN_CTL              0x15088
+#define TXGBE_PSR_VM_CTL                0x151B0
+/* Header split receive */
+#define TXGBE_PSR_CTL_SW_EN             0x00040000U
+#define TXGBE_PSR_CTL_RSC_DIS           0x00010000U
+#define TXGBE_PSR_CTL_RSC_ACK           0x00020000U
+#define TXGBE_PSR_CTL_PCSD              0x00002000U
+#define TXGBE_PSR_CTL_IPPCSE            0x00001000U
+#define TXGBE_PSR_CTL_BAM               0x00000400U
+#define TXGBE_PSR_CTL_UPE               0x00000200U
+#define TXGBE_PSR_CTL_MPE               0x00000100U
+#define TXGBE_PSR_CTL_MFE               0x00000080U
+#define TXGBE_PSR_CTL_MO                0x00000060U
+#define TXGBE_PSR_CTL_TPE               0x00000010U
+#define TXGBE_PSR_CTL_MO_SHIFT          5
+/* VT_CTL bitmasks */
+#define TXGBE_PSR_VM_CTL_DIS_DEFPL      0x20000000U /* disable default pool */
+#define TXGBE_PSR_VM_CTL_REPLEN         0x40000000U /* replication enabled */
+#define TXGBE_PSR_VM_CTL_POOL_SHIFT     7
+#define TXGBE_PSR_VM_CTL_POOL_MASK      (0x3F << TXGBE_PSR_VM_CTL_POOL_SHIFT)
+/* VLAN Control Bit Masks */
+#define TXGBE_PSR_VLAN_CTL_VET          0x0000FFFFU  /* bits 0-15 */
+#define TXGBE_PSR_VLAN_CTL_CFI          0x10000000U  /* bit 28 */
+#define TXGBE_PSR_VLAN_CTL_CFIEN        0x20000000U  /* bit 29 */
+#define TXGBE_PSR_VLAN_CTL_VFE          0x40000000U  /* bit 30 */
+
+/* vm L2 contorl */
+#define TXGBE_PSR_VM_L2CTL(_i)          (0x15600 + ((_i) * 4))
+/* VMOLR bitmasks */
+#define TXGBE_PSR_VM_L2CTL_LBDIS        0x00000002U /* disable loopback */
+#define TXGBE_PSR_VM_L2CTL_LLB          0x00000004U /* local pool loopback */
+#define TXGBE_PSR_VM_L2CTL_UPE          0x00000010U /* unicast promiscuous */
+#define TXGBE_PSR_VM_L2CTL_TPE          0x00000020U /* ETAG promiscuous */
+#define TXGBE_PSR_VM_L2CTL_VACC         0x00000040U /* accept nomatched vlan */
+#define TXGBE_PSR_VM_L2CTL_VPE          0x00000080U /* vlan promiscuous mode */
+#define TXGBE_PSR_VM_L2CTL_AUPE         0x00000100U /* accept untagged packets */
+#define TXGBE_PSR_VM_L2CTL_ROMPE        0x00000200U /*accept packets in MTA tbl*/
+#define TXGBE_PSR_VM_L2CTL_ROPE         0x00000400U /* accept packets in UC tbl*/
+#define TXGBE_PSR_VM_L2CTL_BAM          0x00000800U /* accept broadcast packets*/
+#define TXGBE_PSR_VM_L2CTL_MPE          0x00001000U /* multicast promiscuous */
+
+/* etype switcher 1st stage */
+#define TXGBE_PSR_ETYPE_SWC(_i) (0x15128 + ((_i) * 4)) /* EType Queue Filter */
+/* ETYPE Queue Filter/Select Bit Masks */
+#define TXGBE_MAX_PSR_ETYPE_SWC_FILTERS         8
+#define TXGBE_PSR_ETYPE_SWC_FCOE                0x08000000U /* bit 27 */
+#define TXGBE_PSR_ETYPE_SWC_TX_ANTISPOOF        0x20000000U /* bit 29 */
+#define TXGBE_PSR_ETYPE_SWC_1588                0x40000000U /* bit 30 */
+#define TXGBE_PSR_ETYPE_SWC_FILTER_EN           0x80000000U /* bit 31 */
+#define TXGBE_PSR_ETYPE_SWC_POOL_ENABLE         (1 << 26) /* bit 26 */
+#define TXGBE_PSR_ETYPE_SWC_POOL_SHIFT          20
+/* ETQF filter list: one static filter per filter consumer. This is
+ *                 to avoid filter collisions later. Add new filters
+ *                 here!!
+ *
+ * Current filters:
+ *      EAPOL 802.1x (0x888e): Filter 0
+ *      FCoE (0x8906):   Filter 2
+ *      1588 (0x88f7):   Filter 3
+ *      FIP  (0x8914):   Filter 4
+ *      LLDP (0x88CC):   Filter 5
+ *      LACP (0x8809):   Filter 6
+ *      FC   (0x8808):   Filter 7
+ */
+#define TXGBE_PSR_ETYPE_SWC_FILTER_EAPOL        0
+#define TXGBE_PSR_ETYPE_SWC_FILTER_FCOE         2
+#define TXGBE_PSR_ETYPE_SWC_FILTER_1588         3
+#define TXGBE_PSR_ETYPE_SWC_FILTER_FIP          4
+#define TXGBE_PSR_ETYPE_SWC_FILTER_LLDP         5
+#define TXGBE_PSR_ETYPE_SWC_FILTER_LACP         6
+#define TXGBE_PSR_ETYPE_SWC_FILTER_FC           7
+
+/* mcasst/ucast overflow tbl */
+#define TXGBE_PSR_MC_TBL(_i)    (0x15200  + ((_i) * 4))
+#define TXGBE_PSR_UC_TBL(_i)    (0x15400 + ((_i) * 4))
+
+/* vlan tbl */
+#define TXGBE_PSR_VLAN_TBL(_i)  (0x16000 + ((_i) * 4))
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
+/* vlan switch */
+#define TXGBE_PSR_VLAN_SWC      0x16220
+#define TXGBE_PSR_VLAN_SWC_VM_L 0x16224
+#define TXGBE_PSR_VLAN_SWC_VM_H 0x16228
+#define TXGBE_PSR_VLAN_SWC_IDX  0x16230         /* 64 vlan entries */
+/* VLAN pool filtering masks */
+#define TXGBE_PSR_VLAN_SWC_VIEN         0x80000000U  /* filter is valid */
+#define TXGBE_PSR_VLAN_SWC_ENTRIES      64
+#define TXGBE_PSR_VLAN_SWC_VLANID_MASK  0x00000FFFU
+#define TXGBE_ETHERNET_IEEE_VLAN_TYPE   0x8100  /* 802.1q protocol */
+
+/* cloud switch */
+#define TXGBE_PSR_CL_SWC_DST0    0x16240
+#define TXGBE_PSR_CL_SWC_DST1    0x16244
+#define TXGBE_PSR_CL_SWC_DST2    0x16248
+#define TXGBE_PSR_CL_SWC_DST3    0x1624c
+#define TXGBE_PSR_CL_SWC_KEY     0x16250
+#define TXGBE_PSR_CL_SWC_CTL     0x16254
+#define TXGBE_PSR_CL_SWC_VM_L    0x16258
+#define TXGBE_PSR_CL_SWC_VM_H    0x1625c
+#define TXGBE_PSR_CL_SWC_IDX     0x16260
+
+#define TXGBE_PSR_CL_SWC_CTL_VLD        0x80000000U
+#define TXGBE_PSR_CL_SWC_CTL_DST_MSK    0x00000002U
+#define TXGBE_PSR_CL_SWC_CTL_KEY_MSK    0x00000001U
+
+/* FCoE SOF/EOF */
+#define TXGBE_PSR_FC_EOF        0x15158
+#define TXGBE_PSR_FC_SOF        0x151F8
+/* FCoE Filter Context Registers */
+#define TXGBE_PSR_FC_FLT_CTXT           0x15108
+#define TXGBE_PSR_FC_FLT_CTXT_VALID     ((0x1)) /* Filter Context Valid */
+#define TXGBE_PSR_FC_FLT_CTXT_FIRST     ((0x1) << 1) /* Filter First */
+#define TXGBE_PSR_FC_FLT_CTXT_WR        ((0x1) << 2) /* Write/Read Context */
+#define TXGBE_PSR_FC_FLT_CTXT_SEQID(_v) (((_v) & 0xFF) << 8) /* Sequence ID */
+#define TXGBE_PSR_FC_FLT_CTXT_SEQCNT(_v) (((_v) & 0xFFFF) << 16) /* Seq Count */
+
+#define TXGBE_PSR_FC_FLT_RW             0x15110
+#define TXGBE_PSR_FC_FLT_RW_FCSEL(_v)   (((_v) & 0x1FF)) /* FC OX_ID: 11 bits */
+#define TXGBE_PSR_FC_FLT_RW_RVALDT      ((0x1) << 13)  /* Fast Re-Validation */
+#define TXGBE_PSR_FC_FLT_RW_WE          ((0x1) << 14)  /* Write Enable */
+#define TXGBE_PSR_FC_FLT_RW_RE          ((0x1) << 15)  /* Read Enable */
+
+#define TXGBE_PSR_FC_PARAM              0x151D8
+
+/* FCoE Receive Control */
+#define TXGBE_PSR_FC_CTL                0x15100
+#define TXGBE_PSR_FC_CTL_FCOELLI        ((0x1))   /* Low latency interrupt */
+#define TXGBE_PSR_FC_CTL_SAVBAD         ((0x1) << 1) /* Save Bad Frames */
+#define TXGBE_PSR_FC_CTL_FRSTRDH        ((0x1) << 2) /* EN 1st Read Header */
+#define TXGBE_PSR_FC_CTL_LASTSEQH       ((0x1) << 3) /* EN Last Header in Seq */
+#define TXGBE_PSR_FC_CTL_ALLH           ((0x1) << 4) /* EN All Headers */
+#define TXGBE_PSR_FC_CTL_FRSTSEQH       ((0x1) << 5) /* EN 1st Seq. Header */
+#define TXGBE_PSR_FC_CTL_ICRC           ((0x1) << 6) /* Ignore Bad FC CRC */
+#define TXGBE_PSR_FC_CTL_FCCRCBO        ((0x1) << 7) /* FC CRC Byte Ordering */
+#define TXGBE_PSR_FC_CTL_FCOEVER(_v)    (((_v) & 0xF) << 8) /* FCoE Version */
+
+/* Management */
+#define TXGBE_PSR_MNG_FIT_CTL           0x15820
+/* Management Bit Fields and Masks */
+#define TXGBE_PSR_MNG_FIT_CTL_MPROXYE    0x40000000U /* Management Proxy Enable*/
+#define TXGBE_PSR_MNG_FIT_CTL_RCV_TCO_EN 0x00020000U /* Rcv TCO packet enable */
+#define TXGBE_PSR_MNG_FIT_CTL_EN_BMC2OS  0x10000000U /* Ena BMC2OS and OS2BMC traffic */
+#define TXGBE_PSR_MNG_FIT_CTL_EN_BMC2OS_SHIFT   28
+
+#define TXGBE_PSR_MNG_FLEX_SEL  0x1582C
+#define TXGBE_PSR_MNG_FLEX_DW_L(_i) (0x15A00 + ((_i) * 16))
+#define TXGBE_PSR_MNG_FLEX_DW_H(_i) (0x15A04 + ((_i) * 16))
+#define TXGBE_PSR_MNG_FLEX_MSK(_i)  (0x15A08 + ((_i) * 16))
+
+/* mirror */
+#define TXGBE_PSR_MR_CTL(_i)    (0x15B00 + ((_i) * 4))
+#define TXGBE_PSR_MR_VLAN_L(_i) (0x15B10 + ((_i) * 8))
+#define TXGBE_PSR_MR_VLAN_H(_i) (0x15B14 + ((_i) * 8))
+#define TXGBE_PSR_MR_VM_L(_i)   (0x15B30 + ((_i) * 8))
+#define TXGBE_PSR_MR_VM_H(_i)   (0x15B34 + ((_i) * 8))
+
+/* 1588 */
+#define TXGBE_PSR_1588_CTL      0x15188 /* Rx Time Sync Control register - RW */
+#define TXGBE_PSR_1588_STMPL    0x151E8 /* Rx timestamp Low - RO */
+#define TXGBE_PSR_1588_STMPH    0x151A4 /* Rx timestamp High - RO */
+#define TXGBE_PSR_1588_ATTRL    0x151A0 /* Rx timestamp attribute low - RO */
+#define TXGBE_PSR_1588_ATTRH    0x151A8 /* Rx timestamp attribute high - RO */
+#define TXGBE_PSR_1588_MSGTYPE  0x15120 /* RX message type register low - RW */
+/* 1588 CTL Bit */
+#define TXGBE_PSR_1588_CTL_VALID            0x00000001U /* Rx timestamp valid */
+#define TXGBE_PSR_1588_CTL_TYPE_MASK        0x0000000EU /* Rx type mask */
+#define TXGBE_PSR_1588_CTL_TYPE_L2_V2       0x00
+#define TXGBE_PSR_1588_CTL_TYPE_L4_V1       0x02
+#define TXGBE_PSR_1588_CTL_TYPE_L2_L4_V2    0x04
+#define TXGBE_PSR_1588_CTL_TYPE_EVENT_V2    0x0A
+#define TXGBE_PSR_1588_CTL_ENABLED          0x00000010U /* Rx Timestamp enabled*/
+/* 1588 msg type bit */
+#define TXGBE_PSR_1588_MSGTYPE_V1_CTRLT_MASK            0x000000FFU
+#define TXGBE_PSR_1588_MSGTYPE_V1_SYNC_MSG              0x00
+#define TXGBE_PSR_1588_MSGTYPE_V1_DELAY_REQ_MSG         0x01
+#define TXGBE_PSR_1588_MSGTYPE_V1_FOLLOWUP_MSG          0x02
+#define TXGBE_PSR_1588_MSGTYPE_V1_DELAY_RESP_MSG        0x03
+#define TXGBE_PSR_1588_MSGTYPE_V1_MGMT_MSG              0x04
+#define TXGBE_PSR_1588_MSGTYPE_V2_MSGID_MASK            0x0000FF00U
+#define TXGBE_PSR_1588_MSGTYPE_V2_SYNC_MSG              0x0000
+#define TXGBE_PSR_1588_MSGTYPE_V2_DELAY_REQ_MSG         0x0100
+#define TXGBE_PSR_1588_MSGTYPE_V2_PDELAY_REQ_MSG        0x0200
+#define TXGBE_PSR_1588_MSGTYPE_V2_PDELAY_RESP_MSG       0x0300
+#define TXGBE_PSR_1588_MSGTYPE_V2_FOLLOWUP_MSG          0x0800
+#define TXGBE_PSR_1588_MSGTYPE_V2_DELAY_RESP_MSG        0x0900
+#define TXGBE_PSR_1588_MSGTYPE_V2_PDELAY_FOLLOWUP_MSG   0x0A00
+#define TXGBE_PSR_1588_MSGTYPE_V2_ANNOUNCE_MSG          0x0B00
+#define TXGBE_PSR_1588_MSGTYPE_V2_SIGNALLING_MSG        0x0C00
+#define TXGBE_PSR_1588_MSGTYPE_V2_MGMT_MSG              0x0D00
+
+/* Wake up registers */
+#define TXGBE_PSR_WKUP_CTL      0x15B80
+#define TXGBE_PSR_WKUP_IPV      0x15B84
+#define TXGBE_PSR_LAN_FLEX_SEL  0x15B8C
+#define TXGBE_PSR_WKUP_IP4TBL(_i)       (0x15BC0 + ((_i) * 4))
+#define TXGBE_PSR_WKUP_IP6TBL(_i)       (0x15BE0 + ((_i) * 4))
+#define TXGBE_PSR_LAN_FLEX_DW_L(_i)     (0x15C00 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_CTL  0x15CFC
+/* Wake Up Filter Control Bit */
+#define TXGBE_PSR_WKUP_CTL_LNKC 0x00000001U /* Link Status Change Wakeup Enable*/
+#define TXGBE_PSR_WKUP_CTL_MAG  0x00000002U /* Magic Packet Wakeup Enable */
+#define TXGBE_PSR_WKUP_CTL_EX   0x00000004U /* Directed Exact Wakeup Enable */
+#define TXGBE_PSR_WKUP_CTL_MC   0x00000008U /* Directed Multicast Wakeup Enable*/
+#define TXGBE_PSR_WKUP_CTL_BC   0x00000010U /* Broadcast Wakeup Enable */
+#define TXGBE_PSR_WKUP_CTL_ARP  0x00000020U /* ARP Request Packet Wakeup Enable*/
+#define TXGBE_PSR_WKUP_CTL_IPV4 0x00000040U /* Directed IPv4 Pkt Wakeup Enable */
+#define TXGBE_PSR_WKUP_CTL_IPV6 0x00000080U /* Directed IPv6 Pkt Wakeup Enable */
+#define TXGBE_PSR_WKUP_CTL_IGNORE_TCO   0x00008000U /* Ignore WakeOn TCO pkts */
+#define TXGBE_PSR_WKUP_CTL_FLX0         0x00010000U /* Flexible Filter 0 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX1         0x00020000U /* Flexible Filter 1 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX2         0x00040000U /* Flexible Filter 2 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX3         0x00080000U /* Flexible Filter 3 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX4         0x00100000U /* Flexible Filter 4 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX5         0x00200000U /* Flexible Filter 5 Ena */
+#define TXGBE_PSR_WKUP_CTL_FLX_FILTERS  0x000F0000U /* Mask for 4 flex filters */
+#define TXGBE_PSR_WKUP_CTL_FLX_FILTERS_6 0x003F0000U /* Mask for 6 flex filters*/
+#define TXGBE_PSR_WKUP_CTL_FLX_FILTERS_8 0x00FF0000U /* Mask for 8 flex filters*/
+#define TXGBE_PSR_WKUP_CTL_FW_RST_WK    0x80000000U /* Ena wake on FW reset assertion */
+/* Mask for Ext. flex filters */
+#define TXGBE_PSR_WKUP_CTL_EXT_FLX_FILTERS  0x00300000U
+#define TXGBE_PSR_WKUP_CTL_ALL_FILTERS   0x000F00FFU /* Mask all 4 flex filters*/
+#define TXGBE_PSR_WKUP_CTL_ALL_FILTERS_6 0x003F00FFU /* Mask all 6 flex filters*/
+#define TXGBE_PSR_WKUP_CTL_ALL_FILTERS_8 0x00FF00FFU /* Mask all 8 flex filters*/
+#define TXGBE_PSR_WKUP_CTL_FLX_OFFSET    16 /* Offset to the Flex Filters bits*/
+
+#define TXGBE_PSR_MAX_SZ                0x15020
+
+/****************************** TDB ******************************************/
+#define TXGBE_TDB_RFCS                  0x1CE00
+#define TXGBE_TDB_PB_SZ(_i)             (0x1CC00 + ((_i) * 4)) /* 8 of these */
+#define TXGBE_TDB_MNG_TC                0x1CD10
+#define TXGBE_TDB_PRB_CTL               0x17010
+#define TXGBE_TDB_PBRARB_CTL            0x1CD00
+#define TXGBE_TDB_UP2TC                 0x1C800
+#define TXGBE_TDB_PBRARB_CFG(_i)        (0x1CD20 + ((_i) * 4)) /* 8 of (0-7) */
+
+#define TXGBE_TDB_PB_SZ_20KB    0x00005000U /* 20KB Packet Buffer */
+#define TXGBE_TDB_PB_SZ_40KB    0x0000A000U /* 40KB Packet Buffer */
+#define TXGBE_TDB_PB_SZ_MAX     0x00028000U /* 160KB Packet Buffer */
+#define TXGBE_TXPKT_SIZE_MAX    0xA /* Max Tx Packet size */
+#define TXGBE_MAX_PB            8
+
+/****************************** TSEC *****************************************/
+/* Security Control Registers */
+#define TXGBE_TSC_CTL                   0x1D000
+#define TXGBE_TSC_ST                    0x1D004
+#define TXGBE_TSC_BUF_AF                0x1D008
+#define TXGBE_TSC_BUF_AE                0x1D00C
+#define TXGBE_TSC_PRB_CTL               0x1D010
+#define TXGBE_TSC_MIN_IFG               0x1D020
+/* Security Bit Fields and Masks */
+#define TXGBE_TSC_CTL_SECTX_DIS         0x00000001U
+#define TXGBE_TSC_CTL_TX_DIS            0x00000002U
+#define TXGBE_TSC_CTL_STORE_FORWARD     0x00000004U
+#define TXGBE_TSC_CTL_IV_MSK_EN         0x00000008U
+#define TXGBE_TSC_ST_SECTX_RDY          0x00000001U
+#define TXGBE_TSC_ST_OFF_DIS            0x00000002U
+#define TXGBE_TSC_ST_ECC_TXERR          0x00000004U
+
+/* LinkSec (MacSec) Registers */
+#define TXGBE_TSC_LSEC_CAP              0x1D200
+#define TXGBE_TSC_LSEC_CTL              0x1D204
+#define TXGBE_TSC_LSEC_SCI_L            0x1D208
+#define TXGBE_TSC_LSEC_SCI_H            0x1D20C
+#define TXGBE_TSC_LSEC_SA               0x1D210
+#define TXGBE_TSC_LSEC_PKTNUM0          0x1D214
+#define TXGBE_TSC_LSEC_PKTNUM1          0x1D218
+#define TXGBE_TSC_LSEC_KEY0(_n)         0x1D21C
+#define TXGBE_TSC_LSEC_KEY1(_n)         0x1D22C
+#define TXGBE_TSC_LSEC_UNTAG_PKT        0x1D23C
+#define TXGBE_TSC_LSEC_ENC_PKT          0x1D240
+#define TXGBE_TSC_LSEC_PROT_PKT         0x1D244
+#define TXGBE_TSC_LSEC_ENC_OCTET        0x1D248
+#define TXGBE_TSC_LSEC_PROT_OCTET       0x1D24C
+
+/* IpSec Registers */
+#define TXGBE_TSC_IPS_IDX               0x1D100
+#define TXGBE_TSC_IPS_IDX_WT        0x80000000U
+#define TXGBE_TSC_IPS_IDX_RD        0x40000000U
+#define TXGBE_TSC_IPS_IDX_SD_IDX    0x0U /* */
+#define TXGBE_TSC_IPS_IDX_EN        0x00000001U
+#define TXGBE_TSC_IPS_SALT              0x1D104
+#define TXGBE_TSC_IPS_KEY(i)            (0x1D108 + ((i) * 4))
+
+/* 1588 */
+#define TXGBE_TSC_1588_CTL              0x1D400 /* Tx Time Sync Control reg */
+#define TXGBE_TSC_1588_STMPL            0x1D404 /* Tx timestamp value Low */
+#define TXGBE_TSC_1588_STMPH            0x1D408 /* Tx timestamp value High */
+#define TXGBE_TSC_1588_SYSTIML          0x1D40C /* System time register Low */
+#define TXGBE_TSC_1588_SYSTIMH          0x1D410 /* System time register High */
+#define TXGBE_TSC_1588_INC              0x1D414 /* Increment attributes reg */
+#define TXGBE_TSC_1588_INC_IV(v)   (((v) & 0xFFFFFF))
+#define TXGBE_TSC_1588_INC_IP(v)   (((v) & 0xFF) << 24)
+#define TXGBE_TSC_1588_INC_IVP(v, p)  \
+				(((v) & 0xFFFFFF) | TXGBE_TSC_1588_INC_IP(p))
+
+#define TXGBE_TSC_1588_ADJL         0x1D418 /* Time Adjustment Offset reg Low */
+#define TXGBE_TSC_1588_ADJH         0x1D41C /* Time Adjustment Offset reg High*/
+/* 1588 fields */
+#define TXGBE_TSC_1588_CTL_VALID    0x00000001U /* Tx timestamp valid */
+#define TXGBE_TSC_1588_CTL_ENABLED  0x00000010U /* Tx timestamping enabled */
+
+/********************************* RSEC **************************************/
+/* general rsec */
+#define TXGBE_RSC_CTL                   0x17000
+#define TXGBE_RSC_ST                    0x17004
+/* general rsec fields */
+#define TXGBE_RSC_CTL_SECRX_DIS         0x00000001U
+#define TXGBE_RSC_CTL_RX_DIS            0x00000002U
+#define TXGBE_RSC_CTL_CRC_STRIP         0x00000004U
+#define TXGBE_RSC_CTL_IV_MSK_EN         0x00000008U
+#define TXGBE_RSC_CTL_SAVE_MAC_ERR      0x00000040U
+#define TXGBE_RSC_ST_RSEC_RDY           0x00000001U
+#define TXGBE_RSC_ST_RSEC_OFLD_DIS      0x00000002U
+#define TXGBE_RSC_ST_ECC_RXERR          0x00000004U
+
+/* link sec */
+#define TXGBE_RSC_LSEC_CAP              0x17200
+#define TXGBE_RSC_LSEC_CTL              0x17204
+#define TXGBE_RSC_LSEC_SCI_L            0x17208
+#define TXGBE_RSC_LSEC_SCI_H            0x1720C
+#define TXGBE_RSC_LSEC_SA0              0x17210
+#define TXGBE_RSC_LSEC_SA1              0x17214
+#define TXGBE_RSC_LSEC_PKNUM0           0x17218
+#define TXGBE_RSC_LSEC_PKNUM1           0x1721C
+#define TXGBE_RSC_LSEC_KEY0(_n)         0x17220
+#define TXGBE_RSC_LSEC_KEY1(_n)         0x17230
+#define TXGBE_RSC_LSEC_UNTAG_PKT        0x17240
+#define TXGBE_RSC_LSEC_DEC_OCTET        0x17244
+#define TXGBE_RSC_LSEC_VLD_OCTET        0x17248
+#define TXGBE_RSC_LSEC_BAD_PKT          0x1724C
+#define TXGBE_RSC_LSEC_NOSCI_PKT        0x17250
+#define TXGBE_RSC_LSEC_UNSCI_PKT        0x17254
+#define TXGBE_RSC_LSEC_UNCHK_PKT        0x17258
+#define TXGBE_RSC_LSEC_DLY_PKT          0x1725C
+#define TXGBE_RSC_LSEC_LATE_PKT         0x17260
+#define TXGBE_RSC_LSEC_OK_PKT(_n)       0x17264
+#define TXGBE_RSC_LSEC_INV_PKT(_n)      0x17274
+#define TXGBE_RSC_LSEC_BADSA_PKT        0x1727C
+#define TXGBE_RSC_LSEC_INVSA_PKT        0x17280
+
+/* ipsec */
+#define TXGBE_RSC_IPS_IDX               0x17100
+#define TXGBE_RSC_IPS_IDX_WT        0x80000000U
+#define TXGBE_RSC_IPS_IDX_RD        0x40000000U
+#define TXGBE_RSC_IPS_IDX_TB_IDX    0x0U /* */
+#define TXGBE_RSC_IPS_IDX_TB_IP     0x00000002U
+#define TXGBE_RSC_IPS_IDX_TB_SPI    0x00000004U
+#define TXGBE_RSC_IPS_IDX_TB_KEY    0x00000006U
+#define TXGBE_RSC_IPS_IDX_EN        0x00000001U
+#define TXGBE_RSC_IPS_IP(i)             (0x17104 + ((i) * 4))
+#define TXGBE_RSC_IPS_SPI               0x17114
+#define TXGBE_RSC_IPS_IP_IDX            0x17118
+#define TXGBE_RSC_IPS_KEY(i)            (0x1711C + ((i) * 4))
+#define TXGBE_RSC_IPS_SALT              0x1712C
+#define TXGBE_RSC_IPS_MODE              0x17130
+#define TXGBE_RSC_IPS_MODE_IPV6         0x00000010
+#define TXGBE_RSC_IPS_MODE_DEC          0x00000008
+#define TXGBE_RSC_IPS_MODE_ESP          0x00000004
+#define TXGBE_RSC_IPS_MODE_AH           0x00000002
+#define TXGBE_RSC_IPS_MODE_VALID        0x00000001
+
+/************************************** ETH PHY ******************************/
+#define TXGBE_XPCS_IDA_ADDR    0x13000
+#define TXGBE_XPCS_IDA_DATA    0x13004
+#define TXGBE_ETHPHY_IDA_ADDR  0x13008
+#define TXGBE_ETHPHY_IDA_DATA  0x1300C
+
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
+
+/************************************* ETH MAC *****************************/
+#define TXGBE_MAC_TX_CFG                0x11000
+#define TXGBE_MAC_RX_CFG                0x11004
+#define TXGBE_MAC_PKT_FLT               0x11008
+#define TXGBE_MAC_PKT_FLT_PR            (0x1) /* promiscuous mode */
+#define TXGBE_MAC_PKT_FLT_RA            (0x80000000) /* receive all */
+#define TXGBE_MAC_WDG_TIMEOUT           0x1100C
+#define TXGBE_MAC_RX_FLOW_CTRL          0x11090
+#define TXGBE_MAC_ADDRESS0_HIGH         0x11300
+#define TXGBE_MAC_ADDRESS0_LOW          0x11304
+
+#define TXGBE_MAC_TX_CFG_TE             0x00000001U
+#define TXGBE_MAC_TX_CFG_SPEED_MASK     0x60000000U
+#define TXGBE_MAC_TX_CFG_SPEED_10G      0x00000000U
+#define TXGBE_MAC_TX_CFG_SPEED_1G       0x60000000U
+#define TXGBE_MAC_RX_CFG_RE             0x00000001U
+#define TXGBE_MAC_RX_CFG_JE             0x00000100U
+#define TXGBE_MAC_RX_CFG_LM             0x00000400U
+#define TXGBE_MAC_WDG_TIMEOUT_PWE       0x00000100U
+#define TXGBE_MAC_WDG_TIMEOUT_WTO_MASK  0x0000000FU
+#define TXGBE_MAC_WDG_TIMEOUT_WTO_DELTA 2
+
+#define TXGBE_MAC_RX_FLOW_CTRL_RFE      0x00000001U /* receive fc enable */
+#define TXGBE_MAC_RX_FLOW_CTRL_PFCE     0x00000100U /* pfc enable */
+
+#define TXGBE_MSCA                      0x11200
+#define TXGBE_MSCA_RA(v)                ((0xFFFF & (v)))
+#define TXGBE_MSCA_PA(v)                ((0x1F & (v)) << 16)
+#define TXGBE_MSCA_DA(v)                ((0x1F & (v)) << 21)
+#define TXGBE_MSCC                      0x11204
+#define TXGBE_MSCC_DATA(v)              ((0xFFFF & (v)))
+#define TXGBE_MSCC_CMD(v)               ((0x3 & (v)) << 16)
+enum TXGBE_MSCA_CMD_value {
+	TXGBE_MSCA_CMD_RSV = 0,
+	TXGBE_MSCA_CMD_WRITE,
+	TXGBE_MSCA_CMD_POST_READ,
+	TXGBE_MSCA_CMD_READ,
+};
+
+#define TXGBE_MSCC_SADDR                ((0x1U) << 18)
+#define TXGBE_MSCC_CR(v)                ((0x8U & (v)) << 19)
+#define TXGBE_MSCC_BUSY                 ((0x1U) << 22)
+
+/* EEE registers */
+
+/* statistic */
+#define TXGBE_MAC_LXONRXC               0x11E0C
+#define TXGBE_MAC_LXOFFRXC              0x11988
+#define TXGBE_MAC_PXONRXC(_i)           (0x11E30 + ((_i) * 4)) /* 8 of these */
+#define TXGBE_MAC_PXOFFRXC              0x119DC
+#define TXGBE_RX_BC_FRAMES_GOOD_LOW     0x11918
+#define TXGBE_RX_CRC_ERROR_FRAMES_LOW   0x11928
+#define TXGBE_RX_LEN_ERROR_FRAMES_LOW   0x11978
+#define TXGBE_RX_UNDERSIZE_FRAMES_GOOD  0x11938
+#define TXGBE_RX_OVERSIZE_FRAMES_GOOD   0x1193C
+#define TXGBE_RX_FRAME_CNT_GOOD_BAD_LOW 0x11900
+#define TXGBE_TX_FRAME_CNT_GOOD_BAD_LOW 0x1181C
+#define TXGBE_TX_MC_FRAMES_GOOD_LOW     0x1182C
+#define TXGBE_TX_BC_FRAMES_GOOD_LOW     0x11824
+#define TXGBE_MMC_CONTROL               0x11800
+#define TXGBE_MMC_CONTROL_RSTONRD       0x4 /* reset on read */
+#define TXGBE_MMC_CONTROL_UP            0x700
+
+/********************************* BAR registers ***************************/
+/* Interrupt Registers */
+#define TXGBE_BME_CTL				0x12020
+#define TXGBE_PX_MISC_IC                        0x100
+#define TXGBE_PX_MISC_ICS                       0x104
+#define TXGBE_PX_MISC_IEN                       0x108
+#define TXGBE_PX_MISC_IVAR                      0x4FC
+#define TXGBE_PX_GPIE                           0x118
+#define TXGBE_PX_ISB_ADDR_L                     0x160
+#define TXGBE_PX_ISB_ADDR_H                     0x164
+#define TXGBE_PX_TCP_TIMER                      0x170
+#define TXGBE_PX_ITRSEL                         0x180
+#define TXGBE_PX_IC(_i)                         (0x120 + (_i) * 4)
+#define TXGBE_PX_ICS(_i)                        (0x130 + (_i) * 4)
+#define TXGBE_PX_IMS(_i)                        (0x140 + (_i) * 4)
+#define TXGBE_PX_IMC(_i)                        (0x150 + (_i) * 4)
+#define TXGBE_PX_IVAR(_i)                       (0x500 + (_i) * 4)
+#define TXGBE_PX_ITR(_i)                        (0x200 + (_i) * 4)
+#define TXGBE_PX_TRANSACTION_PENDING            0x168
+#define TXGBE_PX_INTA                           0x110
+
+/* Interrupt register bitmasks */
+/* Extended Interrupt Cause Read */
+#define TXGBE_PX_MISC_IC_ETH_LKDN       0x00000100U /* eth link down */
+#define TXGBE_PX_MISC_IC_DEV_RST        0x00000400U /* device reset event */
+#define TXGBE_PX_MISC_IC_TIMESYNC       0x00000800U /* time sync */
+#define TXGBE_PX_MISC_IC_STALL          0x00001000U /* trans or recv path is stalled */
+#define TXGBE_PX_MISC_IC_LINKSEC        0x00002000U /* Tx LinkSec require key exchange */
+#define TXGBE_PX_MISC_IC_RX_MISS        0x00004000U /* Packet Buffer Overrun */
+#define TXGBE_PX_MISC_IC_FLOW_DIR       0x00008000U /* FDir Exception */
+#define TXGBE_PX_MISC_IC_I2C            0x00010000U /* I2C interrupt */
+#define TXGBE_PX_MISC_IC_ETH_EVENT      0x00020000U /* err reported by MAC except eth link down */
+#define TXGBE_PX_MISC_IC_ETH_LK         0x00040000U /* link up */
+#define TXGBE_PX_MISC_IC_ETH_AN         0x00080000U /* link auto-nego done */
+#define TXGBE_PX_MISC_IC_INT_ERR        0x00100000U /* integrity error */
+#define TXGBE_PX_MISC_IC_SPI            0x00200000U /* SPI interface */
+#define TXGBE_PX_MISC_IC_VF_MBOX        0x00800000U /* VF-PF message box */
+#define TXGBE_PX_MISC_IC_GPIO           0x04000000U /* GPIO interrupt */
+#define TXGBE_PX_MISC_IC_PCIE_REQ_ERR   0x08000000U /* pcie request error int */
+#define TXGBE_PX_MISC_IC_OVER_HEAT      0x10000000U /* overheat detection */
+#define TXGBE_PX_MISC_IC_PROBE_MATCH    0x20000000U /* probe match */
+#define TXGBE_PX_MISC_IC_MNG_HOST_MBOX  0x40000000U /* mng mailbox */
+#define TXGBE_PX_MISC_IC_TIMER          0x80000000U /* tcp timer */
+
+/* Extended Interrupt Cause Set */
+#define TXGBE_PX_MISC_ICS_ETH_LKDN      0x00000100U
+#define TXGBE_PX_MISC_ICS_DEV_RST       0x00000400U
+#define TXGBE_PX_MISC_ICS_TIMESYNC      0x00000800U
+#define TXGBE_PX_MISC_ICS_STALL         0x00001000U
+#define TXGBE_PX_MISC_ICS_LINKSEC       0x00002000U
+#define TXGBE_PX_MISC_ICS_RX_MISS       0x00004000U
+#define TXGBE_PX_MISC_ICS_FLOW_DIR      0x00008000U
+#define TXGBE_PX_MISC_ICS_I2C           0x00010000U
+#define TXGBE_PX_MISC_ICS_ETH_EVENT     0x00020000U
+#define TXGBE_PX_MISC_ICS_ETH_LK        0x00040000U
+#define TXGBE_PX_MISC_ICS_ETH_AN        0x00080000U
+#define TXGBE_PX_MISC_ICS_INT_ERR       0x00100000U
+#define TXGBE_PX_MISC_ICS_SPI           0x00200000U
+#define TXGBE_PX_MISC_ICS_VF_MBOX       0x00800000U
+#define TXGBE_PX_MISC_ICS_GPIO          0x04000000U
+#define TXGBE_PX_MISC_ICS_PCIE_REQ_ERR  0x08000000U
+#define TXGBE_PX_MISC_ICS_OVER_HEAT     0x10000000U
+#define TXGBE_PX_MISC_ICS_PROBE_MATCH   0x20000000U
+#define TXGBE_PX_MISC_ICS_MNG_HOST_MBOX 0x40000000U
+#define TXGBE_PX_MISC_ICS_TIMER         0x80000000U
+
+/* Extended Interrupt Enable Set */
+#define TXGBE_PX_MISC_IEN_ETH_LKDN      0x00000100U
+#define TXGBE_PX_MISC_IEN_DEV_RST       0x00000400U
+#define TXGBE_PX_MISC_IEN_TIMESYNC      0x00000800U
+#define TXGBE_PX_MISC_IEN_STALL         0x00001000U
+#define TXGBE_PX_MISC_IEN_LINKSEC       0x00002000U
+#define TXGBE_PX_MISC_IEN_RX_MISS       0x00004000U
+#define TXGBE_PX_MISC_IEN_FLOW_DIR      0x00008000U
+#define TXGBE_PX_MISC_IEN_I2C           0x00010000U
+#define TXGBE_PX_MISC_IEN_ETH_EVENT     0x00020000U
+#define TXGBE_PX_MISC_IEN_ETH_LK        0x00040000U
+#define TXGBE_PX_MISC_IEN_ETH_AN        0x00080000U
+#define TXGBE_PX_MISC_IEN_INT_ERR       0x00100000U
+#define TXGBE_PX_MISC_IEN_SPI           0x00200000U
+#define TXGBE_PX_MISC_IEN_VF_MBOX       0x00800000U
+#define TXGBE_PX_MISC_IEN_GPIO          0x04000000U
+#define TXGBE_PX_MISC_IEN_PCIE_REQ_ERR  0x08000000U
+#define TXGBE_PX_MISC_IEN_OVER_HEAT     0x10000000U
+#define TXGBE_PX_MISC_IEN_PROBE_MATCH   0x20000000U
+#define TXGBE_PX_MISC_IEN_MNG_HOST_MBOX 0x40000000U
+#define TXGBE_PX_MISC_IEN_TIMER         0x80000000U
+
+#define TXGBE_PX_MISC_IEN_MASK ( \
+				TXGBE_PX_MISC_IEN_ETH_LKDN | \
+				TXGBE_PX_MISC_IEN_DEV_RST | \
+				TXGBE_PX_MISC_IEN_ETH_EVENT | \
+				TXGBE_PX_MISC_IEN_ETH_LK | \
+				TXGBE_PX_MISC_IEN_ETH_AN | \
+				TXGBE_PX_MISC_IEN_INT_ERR | \
+				TXGBE_PX_MISC_IEN_VF_MBOX | \
+				TXGBE_PX_MISC_IEN_GPIO | \
+				TXGBE_PX_MISC_IEN_MNG_HOST_MBOX | \
+				TXGBE_PX_MISC_IEN_STALL | \
+				TXGBE_PX_MISC_IEN_PCIE_REQ_ERR | \
+				TXGBE_PX_MISC_IEN_TIMER)
+
+/* General purpose Interrupt Enable */
+#define TXGBE_PX_GPIE_MODEL             0x00000001U
+#define TXGBE_PX_GPIE_IMEN              0x00000002U
+#define TXGBE_PX_GPIE_LL_INTERVAL       0x000000F0U
+#define TXGBE_PX_GPIE_RSC_DELAY         0x00000700U
+
+/* Interrupt Vector Allocation Registers */
+#define TXGBE_PX_IVAR_REG_NUM              64
+#define TXGBE_PX_IVAR_ALLOC_VAL            0x80 /* Interrupt Allocation valid */
+
+#define TXGBE_MAX_INT_RATE              500000
+#define TXGBE_MIN_INT_RATE              980
+#define TXGBE_MAX_EITR                  0x00000FF8U
+#define TXGBE_MIN_EITR                  8
+#define TXGBE_PX_ITR_ITR_INT_MASK       0x00000FF8U
+#define TXGBE_PX_ITR_LLI_CREDIT         0x001f0000U
+#define TXGBE_PX_ITR_LLI_MOD            0x00008000U
+#define TXGBE_PX_ITR_CNT_WDIS           0x80000000U
+#define TXGBE_PX_ITR_ITR_CNT            0x0FE00000U
+
+/* transmit DMA Registers */
+#define TXGBE_PX_TR_BAL(_i)     (0x03000 + ((_i) * 0x40))
+#define TXGBE_PX_TR_BAH(_i)     (0x03004 + ((_i) * 0x40))
+#define TXGBE_PX_TR_WP(_i)      (0x03008 + ((_i) * 0x40))
+#define TXGBE_PX_TR_RP(_i)      (0x0300C + ((_i) * 0x40))
+#define TXGBE_PX_TR_CFG(_i)     (0x03010 + ((_i) * 0x40))
+/* Transmit Config masks */
+#define TXGBE_PX_TR_CFG_ENABLE          (1) /* Ena specific Tx Queue */
+#define TXGBE_PX_TR_CFG_TR_SIZE_SHIFT   1 /* tx desc number per ring */
+#define TXGBE_PX_TR_CFG_SWFLSH          (1 << 26) /* Tx Desc. wr-bk flushing */
+#define TXGBE_PX_TR_CFG_WTHRESH_SHIFT   16 /* shift to WTHRESH bits */
+#define TXGBE_PX_TR_CFG_THRE_SHIFT      8
+
+#define TXGBE_PX_TR_RPn(q_per_pool, vf_number, vf_q_index) \
+		(TXGBE_PX_TR_RP((q_per_pool) * (vf_number) + (vf_q_index)))
+#define TXGBE_PX_TR_WPn(q_per_pool, vf_number, vf_q_index) \
+		(TXGBE_PX_TR_WP((q_per_pool) * (vf_number) + (vf_q_index)))
+
+/* Receive DMA Registers */
+#define TXGBE_PX_RR_BAL(_i)             (0x01000 + ((_i) * 0x40))
+#define TXGBE_PX_RR_BAH(_i)             (0x01004 + ((_i) * 0x40))
+#define TXGBE_PX_RR_WP(_i)              (0x01008 + ((_i) * 0x40))
+#define TXGBE_PX_RR_RP(_i)              (0x0100C + ((_i) * 0x40))
+#define TXGBE_PX_RR_CFG(_i)             (0x01010 + ((_i) * 0x40))
+/* PX_RR_CFG bit definitions */
+#define TXGBE_PX_RR_CFG_RR_SIZE_SHIFT           1
+#define TXGBE_PX_RR_CFG_BSIZEPKT_SHIFT          2 /* so many KBs */
+#define TXGBE_PX_RR_CFG_BSIZEHDRSIZE_SHIFT      6 /* 64byte resolution (>> 6)
+						   * + at bit 8 offset (<< 12)
+						   *  = (<< 6)
+						   */
+#define TXGBE_PX_RR_CFG_DROP_EN         0x40000000U
+#define TXGBE_PX_RR_CFG_VLAN            0x80000000U
+#define TXGBE_PX_RR_CFG_RSC             0x20000000U
+#define TXGBE_PX_RR_CFG_CNTAG           0x10000000U
+#define TXGBE_PX_RR_CFG_RSC_CNT_MD      0x08000000U
+#define TXGBE_PX_RR_CFG_SPLIT_MODE      0x04000000U
+#define TXGBE_PX_RR_CFG_STALL           0x02000000U
+#define TXGBE_PX_RR_CFG_MAX_RSCBUF_1    0x00000000U
+#define TXGBE_PX_RR_CFG_MAX_RSCBUF_4    0x00800000U
+#define TXGBE_PX_RR_CFG_MAX_RSCBUF_8    0x01000000U
+#define TXGBE_PX_RR_CFG_MAX_RSCBUF_16   0x01800000U
+#define TXGBE_PX_RR_CFG_RR_THER         0x00070000U
+#define TXGBE_PX_RR_CFG_RR_THER_SHIFT   16
+
+#define TXGBE_PX_RR_CFG_RR_HDR_SZ       0x0000F000U
+#define TXGBE_PX_RR_CFG_RR_BUF_SZ       0x00000F00U
+#define TXGBE_PX_RR_CFG_RR_SZ           0x0000007EU
+#define TXGBE_PX_RR_CFG_RR_EN           0x00000001U
+
+/* statistic */
+#define TXGBE_PX_MPRC(_i)               (0x1020 + ((_i) * 64))
+#define TXGBE_VX_GPRC(_i)               (0x01014 + (0x40 * (_i)))
+#define TXGBE_VX_GPTC(_i)               (0x03014 + (0x40 * (_i)))
+#define TXGBE_VX_GORC_LSB(_i)           (0x01018 + (0x40 * (_i)))
+#define TXGBE_VX_GORC_MSB(_i)           (0x0101C + (0x40 * (_i)))
+#define TXGBE_VX_GOTC_LSB(_i)           (0x03018 + (0x40 * (_i)))
+#define TXGBE_VX_GOTC_MSB(_i)           (0x0301C + (0x40 * (_i)))
+#define TXGBE_VX_MPRC(_i)               (0x01020 + (0x40 * (_i)))
+
+#define TXGBE_PX_GPRC                   0x12504
+#define TXGBE_PX_GPTC                   0x18308
+
+#define TXGBE_PX_GORC_LSB               0x12508
+#define TXGBE_PX_GORC_MSB               0x1250C
+
+#define TXGBE_PX_GOTC_LSB               0x1830C
+#define TXGBE_PX_GOTC_MSB               0x18310
+
+/************************************* Stats registers ************************/
+#define TXGBE_FCCRC         0x15160 /* Num of Good Eth CRC w/ Bad FC CRC */
+#define TXGBE_FCOERPDC      0x12514 /* FCoE Rx Packets Dropped Count */
+#define TXGBE_FCLAST        0x12518 /* FCoE Last Error Count */
+#define TXGBE_FCOEPRC       0x15164 /* Number of FCoE Packets Received */
+#define TXGBE_FCOEDWRC      0x15168 /* Number of FCoE DWords Received */
+#define TXGBE_FCOEPTC       0x18318 /* Number of FCoE Packets Transmitted */
+#define TXGBE_FCOEDWTC      0x1831C /* Number of FCoE DWords Transmitted */
+
+/*************************** Flash region definition *************************/
+/* EEC Register */
+#define TXGBE_EEC_SK            0x00000001U /* EEPROM Clock */
+#define TXGBE_EEC_CS            0x00000002U /* EEPROM Chip Select */
+#define TXGBE_EEC_DI            0x00000004U /* EEPROM Data In */
+#define TXGBE_EEC_DO            0x00000008U /* EEPROM Data Out */
+#define TXGBE_EEC_FWE_MASK      0x00000030U /* FLASH Write Enable */
+#define TXGBE_EEC_FWE_DIS       0x00000010U /* Disable FLASH writes */
+#define TXGBE_EEC_FWE_EN        0x00000020U /* Enable FLASH writes */
+#define TXGBE_EEC_FWE_SHIFT     4
+#define TXGBE_EEC_REQ           0x00000040U /* EEPROM Access Request */
+#define TXGBE_EEC_GNT           0x00000080U /* EEPROM Access Grant */
+#define TXGBE_EEC_PRES          0x00000100U /* EEPROM Present */
+#define TXGBE_EEC_ARD           0x00000200U /* EEPROM Auto Read Done */
+#define TXGBE_EEC_FLUP          0x00800000U /* Flash update command */
+#define TXGBE_EEC_SEC1VAL       0x02000000U /* Sector 1 Valid */
+#define TXGBE_EEC_FLUDONE       0x04000000U /* Flash update done */
+/* EEPROM Addressing bits based on type (0-small, 1-large) */
+#define TXGBE_EEC_ADDR_SIZE     0x00000400U
+#define TXGBE_EEC_SIZE          0x00007800U /* EEPROM Size */
+#define TXGBE_EERD_MAX_ADDR     0x00003FFFU /* EERD allows 14 bits for addr. */
+
+#define TXGBE_EEC_SIZE_SHIFT            11
+#define TXGBE_EEPROM_WORD_SIZE_SHIFT    6
+#define TXGBE_EEPROM_OPCODE_BITS        8
+
+/* FLA Register */
+#define TXGBE_FLA_LOCKED        0x00000040U
+
+/* Part Number String Length */
+#define TXGBE_PBANUM_LENGTH     32
+
+/* Checksum and EEPROM pointers */
+#define TXGBE_PBANUM_PTR_GUARD          0xFAFA
+#define TXGBE_EEPROM_CHECKSUM           0x2F
+#define TXGBE_EEPROM_SUM                0xBABA
+#define TXGBE_ATLAS0_CONFIG_PTR         0x04
+#define TXGBE_PHY_PTR                   0x04
+#define TXGBE_ATLAS1_CONFIG_PTR         0x05
+#define TXGBE_OPTION_ROM_PTR            0x05
+#define TXGBE_PCIE_GENERAL_PTR          0x06
+#define TXGBE_PCIE_CONFIG0_PTR          0x07
+#define TXGBE_PCIE_CONFIG1_PTR          0x08
+#define TXGBE_CORE0_PTR                 0x09
+#define TXGBE_CORE1_PTR                 0x0A
+#define TXGBE_MAC0_PTR                  0x0B
+#define TXGBE_MAC1_PTR                  0x0C
+#define TXGBE_CSR0_CONFIG_PTR           0x0D
+#define TXGBE_CSR1_CONFIG_PTR           0x0E
+#define TXGBE_PCIE_ANALOG_PTR           0x02
+#define TXGBE_SHADOW_RAM_SIZE           0x4000
+#define TXGBE_TXGBE_PCIE_GENERAL_SIZE   0x24
+#define TXGBE_PCIE_CONFIG_SIZE          0x08
+#define TXGBE_EEPROM_LAST_WORD          0x800
+#define TXGBE_FW_PTR                    0x0F
+#define TXGBE_PBANUM0_PTR               0x05
+#define TXGBE_PBANUM1_PTR               0x06
+#define TXGBE_ALT_MAC_ADDR_PTR          0x37
+#define TXGBE_FREE_SPACE_PTR            0x3E
+#define TXGBE_SW_REGION_PTR             0x1C
+
+#define TXGBE_SAN_MAC_ADDR_PTR          0x18
+#define TXGBE_DEVICE_CAPS               0x1C
+#define TXGBE_EEPROM_VERSION_L          0x1D
+#define TXGBE_EEPROM_VERSION_H          0x1E
+#define TXGBE_ISCSI_BOOT_CONFIG         0x07
+
+#define TXGBE_SERIAL_NUMBER_MAC_ADDR    0x11
+#define TXGBE_MAX_MSIX_VECTORS_SAPPHIRE 0x40
+
+/* MSI-X capability fields masks */
+#define TXGBE_PCIE_MSIX_TBL_SZ_MASK     0x7FF
+
+/* Legacy EEPROM word offsets */
+#define TXGBE_ISCSI_BOOT_CAPS           0x0033
+#define TXGBE_ISCSI_SETUP_PORT_0        0x0030
+#define TXGBE_ISCSI_SETUP_PORT_1        0x0034
+
+/* EEPROM Commands - SPI */
+#define TXGBE_EEPROM_MAX_RETRY_SPI      5000 /* Max wait 5ms for RDY signal */
+#define TXGBE_EEPROM_STATUS_RDY_SPI     0x01
+#define TXGBE_EEPROM_READ_OPCODE_SPI    0x03  /* EEPROM read opcode */
+#define TXGBE_EEPROM_WRITE_OPCODE_SPI   0x02  /* EEPROM write opcode */
+#define TXGBE_EEPROM_A8_OPCODE_SPI      0x08  /* opcode bit-3 = addr bit-8 */
+#define TXGBE_EEPROM_WREN_OPCODE_SPI    0x06  /* EEPROM set Write Ena latch */
+/* EEPROM reset Write Enable latch */
+#define TXGBE_EEPROM_WRDI_OPCODE_SPI        0x04
+#define TXGBE_EEPROM_RDSR_OPCODE_SPI        0x05  /* EEPROM read Status reg */
+#define TXGBE_EEPROM_WRSR_OPCODE_SPI        0x01  /* EEPROM write Status reg */
+#define TXGBE_EEPROM_ERASE4K_OPCODE_SPI     0x20  /* EEPROM ERASE 4KB */
+#define TXGBE_EEPROM_ERASE64K_OPCODE_SPI    0xD8  /* EEPROM ERASE 64KB */
+#define TXGBE_EEPROM_ERASE256_OPCODE_SPI    0xDB  /* EEPROM ERASE 256B */
+
+/* EEPROM Read Register */
+#define TXGBE_EEPROM_RW_REG_DATA        16 /* data offset in EEPROM read reg */
+#define TXGBE_EEPROM_RW_REG_DONE        2 /* Offset to READ done bit */
+#define TXGBE_EEPROM_RW_REG_START       1 /* First bit to start operation */
+#define TXGBE_EEPROM_RW_ADDR_SHIFT      2 /* Shift to the address bits */
+#define TXGBE_NVM_POLL_WRITE            1 /* Flag for polling for wr complete */
+#define TXGBE_NVM_POLL_READ             0 /* Flag for polling for rd complete */
+
+#define NVM_INIT_CTRL_3                 0x38
+#define NVM_INIT_CTRL_3_LPLU            0x8
+#define NVM_INIT_CTRL_3_D10GMP_PORT0    0x40
+#define NVM_INIT_CTRL_3_D10GMP_PORT1    0x100
+
+#define TXGBE_ETH_LENGTH_OF_ADDRESS     6
+
+#define TXGBE_EEPROM_PAGE_SIZE_MAX      128
+#define TXGBE_EEPROM_RD_BUFFER_MAX_COUNT        256 /* words rd in burst */
+#define TXGBE_EEPROM_WR_BUFFER_MAX_COUNT        256 /* words wr in burst */
+#define TXGBE_EEPROM_CTRL_2             1 /* EEPROM CTRL word 2 */
+#define TXGBE_EEPROM_CCD_BIT            2
+
+#ifndef TXGBE_EEPROM_GRANT_ATTEMPTS
+#define TXGBE_EEPROM_GRANT_ATTEMPTS     1000 /* EEPROM attempts to gain grant */
+#endif
+
+#ifndef TXGBE_EERD_EEWR_ATTEMPTS
+/* Number of 5 microseconds we wait for EERD read and
+ * EERW write to complete
+ */
+#define TXGBE_EERD_EEWR_ATTEMPTS        100000
+#endif
+
+#ifndef TXGBE_FLUDONE_ATTEMPTS
+/* # attempts we wait for flush update to complete */
+#define TXGBE_FLUDONE_ATTEMPTS          20000
+#endif
+
+#define TXGBE_PCIE_CTRL2                0x5   /* PCIe Control 2 Offset */
+#define TXGBE_PCIE_CTRL2_DUMMY_ENABLE   0x8   /* Dummy Function Enable */
+#define TXGBE_PCIE_CTRL2_LAN_DISABLE    0x2   /* LAN PCI Disable */
+#define TXGBE_PCIE_CTRL2_DISABLE_SELECT 0x1   /* LAN Disable Select */
+
+#define TXGBE_SAN_MAC_ADDR_PORT0_OFFSET         0x0
+#define TXGBE_SAN_MAC_ADDR_PORT1_OFFSET         0x3
+#define TXGBE_DEVICE_CAPS_ALLOW_ANY_SFP         0x1
+#define TXGBE_DEVICE_CAPS_FCOE_OFFLOADS         0x2
+#define TXGBE_FW_LESM_PARAMETERS_PTR            0x2
+#define TXGBE_FW_LESM_STATE_1                   0x1
+#define TXGBE_FW_LESM_STATE_ENABLED             0x8000 /* LESM Enable bit */
+#define TXGBE_FW_PASSTHROUGH_PATCH_CONFIG_PTR   0x4
+#define TXGBE_FW_PATCH_VERSION_4                0x7
+#define TXGBE_FCOE_IBA_CAPS_BLK_PTR             0x33 /* iSCSI/FCOE block */
+#define TXGBE_FCOE_IBA_CAPS_FCOE                0x20 /* FCOE flags */
+#define TXGBE_ISCSI_FCOE_BLK_PTR                0x17 /* iSCSI/FCOE block */
+#define TXGBE_ISCSI_FCOE_FLAGS_OFFSET           0x0 /* FCOE flags */
+#define TXGBE_ISCSI_FCOE_FLAGS_ENABLE           0x1 /* FCOE flags enable bit */
+#define TXGBE_ALT_SAN_MAC_ADDR_BLK_PTR          0x17 /* Alt. SAN MAC block */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_OFFSET      0x0 /* Alt SAN MAC capability */
+#define TXGBE_ALT_SAN_MAC_ADDR_PORT0_OFFSET     0x1 /* Alt SAN MAC 0 offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_PORT1_OFFSET     0x4 /* Alt SAN MAC 1 offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_WWNN_OFFSET      0x7 /* Alt WWNN prefix offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_WWPN_OFFSET      0x8 /* Alt WWPN prefix offset */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_SANMAC      0x0 /* Alt SAN MAC exists */
+#define TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN      0x1 /* Alt WWN base exists */
+#define TXGBE_DEVICE_CAPS_WOL_PORT0_1   0x4 /* WoL supported on ports 0 & 1 */
+#define TXGBE_DEVICE_CAPS_WOL_PORT0     0x8 /* WoL supported on port 0 */
+#define TXGBE_DEVICE_CAPS_WOL_MASK      0xC /* Mask for WoL capabilities */
+
+/******************************** PCI Bus Info *******************************/
+#define TXGBE_PCI_DEVICE_STATUS         0xAA
+#define TXGBE_PCI_DEVICE_STATUS_TRANSACTION_PENDING     0x0020
+#define TXGBE_PCI_LINK_STATUS           0xB2
+#define TXGBE_PCI_DEVICE_CONTROL2       0xC8
+#define TXGBE_PCI_LINK_WIDTH            0x3F0
+#define TXGBE_PCI_LINK_WIDTH_1          0x10
+#define TXGBE_PCI_LINK_WIDTH_2          0x20
+#define TXGBE_PCI_LINK_WIDTH_4          0x40
+#define TXGBE_PCI_LINK_WIDTH_8          0x80
+#define TXGBE_PCI_LINK_SPEED            0xF
+#define TXGBE_PCI_LINK_SPEED_2500       0x1
+#define TXGBE_PCI_LINK_SPEED_5000       0x2
+#define TXGBE_PCI_LINK_SPEED_8000       0x3
+#define TXGBE_PCI_HEADER_TYPE_REGISTER  0x0E
+#define TXGBE_PCI_HEADER_TYPE_MULTIFUNC 0x80
+#define TXGBE_PCI_DEVICE_CONTROL2_16ms  0x0005
+
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET    4
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_MASK      \
+				(0x0001 << TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET)
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_ENABLE    \
+				(0x01 << TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET)
+
+#define TXGBE_PCIDEVCTRL2_TIMEO_MASK    0xf
+#define TXGBE_PCIDEVCTRL2_16_32ms_def   0x0
+#define TXGBE_PCIDEVCTRL2_50_100us      0x1
+#define TXGBE_PCIDEVCTRL2_1_2ms         0x2
+#define TXGBE_PCIDEVCTRL2_16_32ms       0x5
+#define TXGBE_PCIDEVCTRL2_65_130ms      0x6
+#define TXGBE_PCIDEVCTRL2_260_520ms     0x9
+#define TXGBE_PCIDEVCTRL2_1_2s          0xa
+#define TXGBE_PCIDEVCTRL2_4_8s          0xd
+#define TXGBE_PCIDEVCTRL2_17_34s        0xe
+
+/* Number of 100 microseconds we wait for PCI Express master disable */
+#define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        800
+
+/* PCI bus types */
+enum txgbe_bus_type {
+	txgbe_bus_type_unknown = 0,
+	txgbe_bus_type_pci,
+	txgbe_bus_type_pcix,
+	txgbe_bus_type_pci_express,
+	txgbe_bus_type_internal,
+	txgbe_bus_type_reserved
+};
+
+/* PCI bus speeds */
+enum txgbe_bus_speed {
+	txgbe_bus_speed_unknown	= 0,
+	txgbe_bus_speed_33	= 33,
+	txgbe_bus_speed_66	= 66,
+	txgbe_bus_speed_100	= 100,
+	txgbe_bus_speed_120	= 120,
+	txgbe_bus_speed_133	= 133,
+	txgbe_bus_speed_2500	= 2500,
+	txgbe_bus_speed_5000	= 5000,
+	txgbe_bus_speed_8000	= 8000,
+	txgbe_bus_speed_reserved
+};
+
+/* PCI bus widths */
+enum txgbe_bus_width {
+	txgbe_bus_width_unknown	= 0,
+	txgbe_bus_width_pcie_x1	= 1,
+	txgbe_bus_width_pcie_x2	= 2,
+	txgbe_bus_width_pcie_x4	= 4,
+	txgbe_bus_width_pcie_x8	= 8,
+	txgbe_bus_width_32	= 32,
+	txgbe_bus_width_64	= 64,
+	txgbe_bus_width_reserved
+};
+
+struct txgbe_addr_filter_info {
+	u32 num_mc_addrs;
+	u32 rar_used_count;
+	u32 mta_in_use;
+	u32 overflow_promisc;
+	bool user_set_promisc;
+};
+
+/* Bus parameters */
+struct txgbe_bus_info {
+	enum txgbe_bus_speed speed;
+	enum txgbe_bus_width width;
+	enum txgbe_bus_type type;
+
+	u16 func;
+	u16 lan_id;
+};
+
+/* forward declaration */
+struct txgbe_hw;
+
+struct txgbe_mac_operations {
+	s32 (*init_hw)(struct txgbe_hw *hw);
+	s32 (*reset_hw)(struct txgbe_hw *hw);
+	s32 (*start_hw)(struct txgbe_hw *hw);
+	s32 (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
+	s32 (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
+	s32 (*stop_adapter)(struct txgbe_hw *hw);
+	s32 (*get_bus_info)(struct txgbe_hw *hw);
+	void (*set_lan_id)(struct txgbe_hw *hw);
+
+	/* RAR */
+	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
+		       u32 enable_addr);
+	s32 (*clear_rar)(struct txgbe_hw *hw, u32 index);
+	s32 (*set_vmdq_san_mac)(struct txgbe_hw *hw, u32 vmdq);
+	s32 (*clear_vmdq)(struct txgbe_hw *hw, u32 rar, u32 vmdq);
+	s32 (*init_rx_addrs)(struct txgbe_hw *hw);
+	s32 (*init_uta_tables)(struct txgbe_hw *hw);
+
+	/* Manageability interface */
+	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
+	void (*disable_rx)(struct txgbe_hw *hw);
+};
+
+struct txgbe_mac_info {
+	struct txgbe_mac_operations ops;
+	u8 addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 perm_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 san_addr[TXGBE_ETH_LENGTH_OF_ADDRESS];
+	s32 mc_filter_type;
+	u32 mcft_size;
+	u32 num_rar_entries;
+	u32 max_tx_queues;
+	u32 max_rx_queues;
+	u8  san_mac_rar_index;
+	bool autotry_restart;
+	struct txgbe_thermal_sensor_data  thermal_sensor_data;
+	bool set_lben;
+};
+
+enum txgbe_reset_type {
+	TXGBE_LAN_RESET = 0,
+	TXGBE_SW_RESET,
+	TXGBE_GLOBAL_RESET
+};
+
 struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	void *back;
+	struct txgbe_mac_info mac;
+	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_bus_info bus;
 	u16 device_id;
 	u16 vendor_id;
 	u16 subsystem_device_id;
 	u16 subsystem_vendor_id;
 	u8 revision_id;
+	bool adapter_stopped;
+	enum txgbe_reset_type reset_type;
+	bool force_full_reset;
 	u16 subsystem_id;
 };
 
+#define TCALL(hw, func, args...) (((hw)->func != NULL) \
+		? (hw)->func((hw), ##args) : TXGBE_NOT_IMPLEMENTED)
+
+/* Error Codes */
+#define TXGBE_ERR                                100
+#define TXGBE_NOT_IMPLEMENTED                    0x7FFFFFFF
+/* (-TXGBE_ERR, TXGBE_ERR): reserved for non-txgbe defined error code */
+#define TXGBE_ERR_NOSUPP                        -(TXGBE_ERR + 0)
+#define TXGBE_ERR_EEPROM                        -(TXGBE_ERR + 1)
+#define TXGBE_ERR_EEPROM_CHECKSUM               -(TXGBE_ERR + 2)
+#define TXGBE_ERR_PHY                           -(TXGBE_ERR + 3)
+#define TXGBE_ERR_CONFIG                        -(TXGBE_ERR + 4)
+#define TXGBE_ERR_PARAM                         -(TXGBE_ERR + 5)
+#define TXGBE_ERR_MAC_TYPE                      -(TXGBE_ERR + 6)
+#define TXGBE_ERR_UNKNOWN_PHY                   -(TXGBE_ERR + 7)
+#define TXGBE_ERR_LINK_SETUP                    -(TXGBE_ERR + 8)
+#define TXGBE_ERR_ADAPTER_STOPPED               -(TXGBE_ERR + 9)
+#define TXGBE_ERR_INVALID_MAC_ADDR              -(TXGBE_ERR + 10)
+#define TXGBE_ERR_DEVICE_NOT_SUPPORTED          -(TXGBE_ERR + 11)
+#define TXGBE_ERR_MASTER_REQUESTS_PENDING       -(TXGBE_ERR + 12)
+#define TXGBE_ERR_INVALID_LINK_SETTINGS         -(TXGBE_ERR + 13)
+#define TXGBE_ERR_AUTONEG_NOT_COMPLETE          -(TXGBE_ERR + 14)
+#define TXGBE_ERR_RESET_FAILED                  -(TXGBE_ERR + 15)
+#define TXGBE_ERR_SWFW_SYNC                     -(TXGBE_ERR + 16)
+#define TXGBE_ERR_PHY_ADDR_INVALID              -(TXGBE_ERR + 17)
+#define TXGBE_ERR_I2C                           -(TXGBE_ERR + 18)
+#define TXGBE_ERR_SFP_NOT_SUPPORTED             -(TXGBE_ERR + 19)
+#define TXGBE_ERR_SFP_NOT_PRESENT               -(TXGBE_ERR + 20)
+#define TXGBE_ERR_SFP_NO_INIT_SEQ_PRESENT       -(TXGBE_ERR + 21)
+#define TXGBE_ERR_NO_SAN_ADDR_PTR               -(TXGBE_ERR + 22)
+#define TXGBE_ERR_FDIR_REINIT_FAILED            -(TXGBE_ERR + 23)
+#define TXGBE_ERR_EEPROM_VERSION                -(TXGBE_ERR + 24)
+#define TXGBE_ERR_NO_SPACE                      -(TXGBE_ERR + 25)
+#define TXGBE_ERR_OVERTEMP                      -(TXGBE_ERR + 26)
+#define TXGBE_ERR_UNDERTEMP                     -(TXGBE_ERR + 27)
+#define TXGBE_ERR_FC_NOT_NEGOTIATED             -(TXGBE_ERR + 28)
+#define TXGBE_ERR_FC_NOT_SUPPORTED              -(TXGBE_ERR + 29)
+#define TXGBE_ERR_SFP_SETUP_NOT_COMPLETE        -(TXGBE_ERR + 30)
+#define TXGBE_ERR_PBA_SECTION                   -(TXGBE_ERR + 31)
+#define TXGBE_ERR_INVALID_ARGUMENT              -(TXGBE_ERR + 32)
+#define TXGBE_ERR_HOST_INTERFACE_COMMAND        -(TXGBE_ERR + 33)
+#define TXGBE_ERR_OUT_OF_MEM                    -(TXGBE_ERR + 34)
+#define TXGBE_ERR_FEATURE_NOT_SUPPORTED         -(TXGBE_ERR + 36)
+#define TXGBE_ERR_EEPROM_PROTECTED_REGION       -(TXGBE_ERR + 37)
+#define TXGBE_ERR_FDIR_CMD_INCOMPLETE           -(TXGBE_ERR + 38)
+#define TXGBE_ERR_FLASH_LOADING_FAILED          -(TXGBE_ERR + 39)
+#define TXGBE_ERR_XPCS_POWER_UP_FAILED          -(TXGBE_ERR + 40)
+#define TXGBE_ERR_FW_RESP_INVALID               -(TXGBE_ERR + 41)
+#define TXGBE_ERR_PHY_INIT_NOT_DONE             -(TXGBE_ERR + 42)
+#define TXGBE_ERR_TIMEOUT                       -(TXGBE_ERR + 43)
+#define TXGBE_ERR_TOKEN_RETRY                   -(TXGBE_ERR + 44)
+#define TXGBE_ERR_REGISTER                      -(TXGBE_ERR + 45)
+#define TXGBE_ERR_MBX                           -(TXGBE_ERR + 46)
+#define TXGBE_ERR_MNG_ACCESS_FAILED             -(TXGBE_ERR + 47)
+
+/**
+ * register operations
+ **/
+/* read register */
+#define TXGBE_DEAD_READ_RETRIES     10
+#define TXGBE_DEAD_READ_REG         0xdeadbeefU
+#define TXGBE_DEAD_READ_REG64       0xdeadbeefdeadbeefULL
+#define TXGBE_FAILED_READ_REG       0xffffffffU
+#define TXGBE_FAILED_READ_REG64     0xffffffffffffffffULL
+
+static inline bool TXGBE_REMOVED(void __iomem *addr)
+{
+	return unlikely(!addr);
+}
+
+static inline u32
+txgbe_rd32(u8 __iomem *base)
+{
+	return readl(base);
+}
+
+static inline u32
+rd32(struct txgbe_hw *hw, u32 reg)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+	u32 val = TXGBE_FAILED_READ_REG;
+
+	if (unlikely(!base))
+		return val;
+
+	val = txgbe_rd32(base + reg);
+
+	return val;
+}
+
+#define rd32a(a, reg, offset) ( \
+	rd32((a), (reg) + ((offset) << 2)))
+
+static inline u32
+rd32m(struct txgbe_hw *hw, u32 reg, u32 mask)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+	u32 val = TXGBE_FAILED_READ_REG;
+
+	if (unlikely(!base))
+		return val;
+
+	val = txgbe_rd32(base + reg);
+	if (unlikely(val == TXGBE_FAILED_READ_REG))
+		return val;
+
+	return val & mask;
+}
+
+/* write register */
+static inline void
+txgbe_wr32(u8 __iomem *base, u32 val)
+{
+	writel(val, base);
+}
+
+static inline void
+wr32(struct txgbe_hw *hw, u32 reg, u32 val)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+
+	if (unlikely(!base))
+		return;
+
+	txgbe_wr32(base + reg, val);
+}
+
+#define wr32a(a, reg, off, val) \
+	wr32((a), (reg) + ((off) << 2), (val))
+
+static inline void
+wr32m(struct txgbe_hw *hw, u32 reg, u32 mask, u32 field)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+	u32 val;
+
+	if (unlikely(!base))
+		return;
+
+	val = txgbe_rd32(base + reg);
+	if (unlikely(val == TXGBE_FAILED_READ_REG))
+		return;
+
+	val = ((val & ~mask) | (field & mask));
+	txgbe_wr32(base + reg, val);
+}
+
+#define TXGBE_WRITE_FLUSH(H) rd32(H, TXGBE_MIS_PWR)
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0



