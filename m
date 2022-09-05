Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637075AD361
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbiIEM7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiIEM7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:59:50 -0400
Received: from smtpbg.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D8B13D5C
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:59:40 -0700 (PDT)
X-QQ-mid: bizesmtp85t1662382777t2a95l5f
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 05 Sep 2022 20:59:35 +0800 (CST)
X-QQ-SSF: 01400000002000L0L000B00A0000000
X-QQ-FEAT: 4jmx9f9bCbvMzMJ34lis5ilQQCEBx9J9JUmxdhTruTw+qhiM9k2vyfbIwwXl8
        Zrj8jOhbk63/+tHDZLPTaobQq6W3dCCAIzv2EXRKTzcnKUl6dOXT2qz+olJv2PiNJr8Hona
        CyVa+qCFbhcqYcAXGPl+6brswGlrO+k1xhnPSiXZbJoMjlojg+agvUjNkIIh5ihgg8D+PIG
        2XUkWufQFqrK3VeEvBMkMCma5fLLTBOFbB9qTYQvxs0seSuTsEYaIbwLvM0uDst2VrVXXVN
        FMZqFxEZBv/apNY5CYsJpV1ZgDVwhb1CCdcR1t6k3o41LV+vQaYsX65Z6eA3ubTO7gSHODR
        WAu6sALi49MULHnKRrCkESZ33rrvPz+MAyP7Ym9fwUz/UAAT5YROsX10kknNTGIJCqq2hIh
        oBpqjbZMb4o6pYAo4RteeQ==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 01/02] net: ngbe: Initialize sw and reset hw
Date:   Mon,  5 Sep 2022 20:59:33 +0800
Message-Id: <20220905125933.2760-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize ngbe adapter for bus info.
Initialize ngbe adapter for mac phy oem type.
Reset ngbe hw status for driver.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  51 ++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   | 383 ++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |  18 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 198 ++++++++
 .../net/ethernet/wangxun/ngbe/ngbe_osdep.h    |  31 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 432 +++++++++++++++++-
 7 files changed, 1110 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h

diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
index 0baf75907496..391c2cbc1bb4 100644
--- a/drivers/net/ethernet/wangxun/ngbe/Makefile
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -6,4 +6,4 @@
 
 obj-$(CONFIG_NGBE) += ngbe.o
 
-ngbe-objs := ngbe_main.o
+ngbe-objs := ngbe_main.o ngbe_hw.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
index f5fa6e5238cc..3d100c7ab22e 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -4,6 +4,7 @@
 #ifndef _NGBE_H_
 #define _NGBE_H_
 
+#include "ngbe_osdep.h"
 #include "ngbe_type.h"
 
 #define NGBE_MAX_FDIR_INDICES		7
@@ -11,14 +12,62 @@
 #define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
 #define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
 
+/* TX/RX descriptor defines */
+#define NGBE_DEFAULT_TXD		512 /* default ring size */
+#define NGBE_DEFAULT_TX_WORK		256
+#define NGBE_MAX_TXD			8192
+#define NGBE_MIN_TXD			128
+
+#define NGBE_DEFAULT_RXD		512 /* default ring size */
+#define NGBE_DEFAULT_RX_WORK		256
+#define NGBE_MAX_RXD			8192
+#define NGBE_MIN_RXD			128
+
+struct ngbe_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u8 pools;
+};
+
 /* board specific private data structure */
 struct ngbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
+
+	/* structs defined in ngbe_hw.h */
+	struct ngbe_hw hw;
+
+	/* Tx fast path data */
+	int num_tx_queues;
+	u16 tx_itr_setting;
+	u16 tx_work_limit;
+
+	/* Rx fast path data */
+	int num_rx_queues;
+	u16 rx_itr_setting;
+	u16 rx_work_limit;
+
+	struct ngbe_mac_addr *mac_table;
+
+	int num_q_vectors;      /* current number of q_vectors for device */
+	int max_q_vectors;      /* upper limit of q_vectors for device */
+
+	u32 tx_ring_count;
+	u32 rx_ring_count;
+
+#define NGBE_MAX_RETA_ENTRIES 128
+	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
+
+#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
+	u32 *rss_key;
+
+	char eeprom_id[32];
+	u16 eeprom_cap;
+	u16 bd_number;
+	u32 wol;
 };
 
 extern char ngbe_driver_name[];
-
 #endif /* _NGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
new file mode 100644
index 000000000000..20c21f99e308
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/iopoll.h>
+
+#include "ngbe.h"
+#include "ngbe_hw.h"
+
+u32 rd32m(struct ngbe_hw *hw, u32 reg, u32 mask)
+{
+	u32 val;
+
+	val = rd32(hw, reg);
+	return val & mask;
+}
+
+void wr32m(struct ngbe_hw *hw, u32 reg, u32 mask, u32 field)
+{
+	u32 val;
+
+	val = rd32(hw, reg);
+	val = ((val & ~mask) | (field & mask));
+	wr32(hw, reg, val);
+}
+
+/**
+ * ngbe_hw_to_dev - Get device pointer from the hardware structure
+ * @hw: pointer to the device HW structure
+ *
+ * Used to access the device pointer
+ */
+struct device *ngbe_hw_to_dev(struct ngbe_hw *hw)
+{
+	struct ngbe_adapter *adapter = container_of(hw, struct ngbe_adapter, hw);
+
+	return &adapter->pdev->dev;
+}
+
+/**
+ *  ngbe_init_uta_tables - Initialize the Unicast Table Array
+ *  @hw: pointer to hardware structure
+ **/
+static void ngbe_init_uta_tables(struct ngbe_hw *hw)
+{
+	int i;
+
+	for (i = 0; i < 128; i++)
+		wr32(hw, NGBE_PSR_UC_TBL(i), 0);
+}
+
+/**
+ *  ngbe_get_mac_addr - Generic get MAC address
+ *  @hw: pointer to hardware structure
+ *  @mac_addr: Adapter MAC address
+ *
+ *  Reads the adapter's MAC address from first Receive Address Register (RAR0)
+ *  A reset of the adapter must be performed prior to calling this function
+ *  in order for the MAC address to have been loaded from the EEPROM into RAR0
+ **/
+static void ngbe_get_mac_addr(struct ngbe_hw *hw, u8 *mac_addr)
+{
+	u32 rar_high;
+	u32 rar_low;
+	u16 i;
+
+	wr32(hw, NGBE_PSR_MAC_SWC_IDX, 0);
+	rar_high = rd32(hw, NGBE_PSR_MAC_SWC_AD_H);
+	rar_low = rd32(hw, NGBE_PSR_MAC_SWC_AD_L);
+
+	for (i = 0; i < 2; i++)
+		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
+
+	for (i = 0; i < 4; i++)
+		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
+}
+
+/**
+ *  ngbe_validate_mac_addr - Validate MAC address
+ *  @mac_addr: pointer to MAC address.
+ *
+ *  Tests a MAC address to ensure it is a valid Individual Address
+ **/
+static int ngbe_validate_mac_addr(u8 *mac_addr)
+{
+	/* Make sure it is not a multicast address */
+	if (is_multicast_ether_addr(mac_addr))
+		return -EINVAL;
+	/* Not a broadcast address */
+	else if (is_broadcast_ether_addr(mac_addr))
+		return -EINVAL;
+	/* Reject the zero address */
+	else if (is_zero_ether_addr(mac_addr))
+		return -EINVAL;
+	return 0;
+}
+
+/**
+ *  ngbe_set_rar - Set Rx address register
+ *  @hw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *  @addr: Address to put into receive address register
+ *  @pools: "pool" index
+ *  @enable_addr: set flag that address is active
+ *
+ *  Puts an ethernet address into a receive address register.
+ **/
+static int ngbe_set_rar(struct ngbe_hw *hw, u32 index, u8 *addr, u64 pools,
+			u32 enable_addr)
+{
+	u32 rar_low, rar_high;
+	u32 rar_entries = hw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"RAR index %d is out of range.\n", index);
+		return -EINVAL;
+	}
+
+	/* select the MAC address */
+	wr32(hw, NGBE_PSR_MAC_SWC_IDX, index);
+
+	/* setup VMDq pool mapping */
+	wr32(hw, NGBE_PSR_MAC_SWC_VM, pools & 0xFFFFFFFF);
+
+	/* HW expects these in little endian so we reverse the byte
+	 * order from network order (big endian) to little endian
+	 */
+	rar_low = ((u32)addr[5] |
+		  ((u32)addr[4] << 8) |
+		  ((u32)addr[3] << 16) |
+		  ((u32)addr[2] << 24));
+	rar_high = ((u32)addr[1] |
+		   ((u32)addr[0] << 8));
+	if (enable_addr != 0)
+		rar_high |= NGBE_PSR_MAC_SWC_AD_H_AV;
+
+	wr32(hw, NGBE_PSR_MAC_SWC_AD_L, rar_low);
+	wr32m(hw, NGBE_PSR_MAC_SWC_AD_H,
+	      (NGBE_PSR_MAC_SWC_AD_H_AD(~0) |
+	      NGBE_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	      NGBE_PSR_MAC_SWC_AD_H_AV), rar_high);
+
+	return 0;
+}
+
+/**
+ *  ngbe_init_rx_addrs - Initializes receive address filters.
+ *  @hw: pointer to hardware structure
+ *
+ *  Places the MAC address in receive address register 0 and clears the rest
+ *  of the receive address registers. Clears the multicast table. Assumes
+ *  the receiver is in reset when the routine is called.
+ **/
+static void ngbe_init_rx_addrs(struct ngbe_hw *hw)
+{
+	u32 i;
+	u32 rar_entries = hw->mac.num_rar_entries;
+	u32 psrctl;
+
+	/* If the current mac address is valid, assume it is a software override
+	 * to the permanent address.
+	 * Otherwise, use the permanent address from the eeprom.
+	 */
+	if (ngbe_validate_mac_addr(hw->mac.addr) < 0) {
+		/* Get the MAC address from the RAR0 for later reference */
+		ngbe_get_mac_addr(hw, hw->mac.addr);
+		dev_dbg(ngbe_hw_to_dev(hw),
+			"Keeping Current RAR0 Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
+			hw->mac.addr[0], hw->mac.addr[1],
+			hw->mac.addr[2], hw->mac.addr[3],
+			hw->mac.addr[4], hw->mac.addr[5]);
+	} else {
+		/* Setup the receive address. */
+		dev_dbg(ngbe_hw_to_dev(hw), "Overriding MAC Address in RAR[0]\n");
+		dev_dbg(ngbe_hw_to_dev(hw),
+			"New MAC Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
+			hw->mac.addr[0], hw->mac.addr[1],
+			hw->mac.addr[2], hw->mac.addr[3],
+			hw->mac.addr[4], hw->mac.addr[5]);
+		ngbe_set_rar(hw, 0, hw->mac.addr, 0, NGBE_PSR_MAC_SWC_AD_H_AV);
+	}
+	hw->addr_ctrl.overflow_promisc = 0;
+	hw->addr_ctrl.rar_used_count = 1;
+	/* Zero out the other receive addresses. */
+	for (i = 1; i < rar_entries; i++) {
+		wr32(hw, NGBE_PSR_MAC_SWC_IDX, i);
+		wr32(hw, NGBE_PSR_MAC_SWC_AD_L, 0);
+		wr32(hw, NGBE_PSR_MAC_SWC_AD_H, 0);
+	}
+	/* Clear the MTA */
+	hw->addr_ctrl.mta_in_use = 0;
+	psrctl = rd32(hw, NGBE_PSR_CTL);
+	psrctl &= ~(NGBE_PSR_CTL_MO | NGBE_PSR_CTL_MFE);
+	psrctl |= hw->mac.mc_filter_type << NGBE_PSR_CTL_MO_SHIFT;
+	wr32(hw, NGBE_PSR_CTL, psrctl);
+	for (i = 0; i < hw->mac.mcft_size; i++)
+		wr32(hw, NGBE_PSR_MC_TBL(i), 0);
+
+	ngbe_init_uta_tables(hw);
+}
+
+static int ngbe_fmgr_cmd_op(struct ngbe_hw *hw, u32 cmd, u32 cmd_addr)
+{
+	u32 cmd_val = 0, val = 0;
+
+	cmd_val = (cmd << NGBE_SPI_CLK_CMD_OFFSET) |
+		  (NGBE_SPI_CLK_DIV << NGBE_SPI_CLK_DIV_OFFSET) | cmd_addr;
+	wr32(hw, NGBE_SPI_H_CMD_REG_ADDR, cmd_val);
+
+	return read_poll_timeout(rd32, val, (val & 0x1), 10, NGBE_SPI_TIME_OUT_VALUE,
+				 false, hw, NGBE_SPI_H_STA_REG_ADDR);
+}
+
+int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data)
+{
+	int ret = 0;
+
+	ret = ngbe_fmgr_cmd_op(hw, NGBE_SPI_CMD_READ_DWORD, addr);
+	if (ret < 0)
+		return ret;
+	*data = rd32(hw, NGBE_SPI_H_DAT_REG_ADDR);
+
+	return 0;
+}
+
+int ngbe_check_flash_load(struct ngbe_hw *hw, u32 check_bit)
+{
+	u32 reg = 0, status = 0;
+
+	/* if there's flash existing */
+	if (!(rd32(hw, NGBE_SPI_H_STA_REG_ADDR) &
+	      NGBE_SPI_STATUS_FLASH_BYPASS)) {
+		/* wait hw load flash done */
+		status = read_poll_timeout(rd32, reg, !(reg & check_bit), 1000, 400000,
+					   false, hw, NGBE_SPI_ILDR_STATUS);
+		if (status < 0)
+			return -EBUSY;
+	}
+	return 0;
+}
+
+/**
+ *  ngbe_get_pcie_msix_counts - Gets MSI-X vector count
+ *  @hw: pointer to hardware structure
+ *  @msix_count: number of MSI interrupts that can be obtained
+ *
+ *  Read PCIe configuration space, and get the MSI-X vector count from
+ *  the capabilities table.
+ **/
+int ngbe_get_pcie_msix_counts(struct ngbe_hw *hw, u16 *msix_count)
+{
+	struct ngbe_adapter *adapter = hw->back;
+	struct pci_dev *pdev = adapter->pdev;
+	struct device *dev = &pdev->dev;
+	u16 max_msix_count;
+	int pos;
+
+	*msix_count = 1;
+	/* max_msix_count for emerald */
+	max_msix_count = NGBE_MAX_MSIX_VECTORS;
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (!pos) {
+		dev_err(dev, "Unable to find MSI-X Capabilities\n");
+		return -EINVAL;
+	}
+	pci_read_config_word(pdev,
+			     pos + PCI_MSIX_FLAGS,
+			     msix_count);
+	*msix_count &= NGBE_PCIE_MSIX_TBL_SZ_MASK;
+	/* MSI-X count is zero-based in HW */
+	*msix_count += 1;
+
+	if (*msix_count > max_msix_count)
+		*msix_count = max_msix_count;
+
+	return 0;
+}
+
+static int ngbe_reset_misc(struct ngbe_hw *hw)
+{
+	int i;
+
+	/* receive packets that size > 2048 */
+	wr32m(hw, NGBE_MAC_RX_CFG, NGBE_MAC_RX_CFG_JE, NGBE_MAC_RX_CFG_JE);
+	/* clear counters on read */
+	wr32m(hw, NGBE_MMC_CONTROL,
+	      NGBE_MMC_CONTROL_RSTONRD, NGBE_MMC_CONTROL_RSTONRD);
+	wr32m(hw, NGBE_MAC_RX_FLOW_CTRL,
+	      NGBE_MAC_RX_FLOW_CTRL_RFE, NGBE_MAC_RX_FLOW_CTRL_RFE);
+	wr32(hw, NGBE_MAC_PKT_FLT, NGBE_MAC_PKT_FLT_PR);
+	wr32m(hw, NGBE_MIS_RST_ST, NGBE_MIS_RST_ST_RST_INIT, 0x1E00);
+	/* errata 4: initialize mng flex tbl and wakeup flex tbl */
+	wr32(hw, NGBE_PSR_MNG_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, NGBE_PSR_MNG_FLEX_DW_L(i), 0);
+		wr32(hw, NGBE_PSR_MNG_FLEX_DW_H(i), 0);
+		wr32(hw, NGBE_PSR_MNG_FLEX_MSK(i), 0);
+	}
+	wr32(hw, NGBE_PSR_LAN_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, NGBE_PSR_LAN_FLEX_DW_L(i), 0);
+		wr32(hw, NGBE_PSR_LAN_FLEX_DW_H(i), 0);
+		wr32(hw, NGBE_PSR_LAN_FLEX_MSK(i), 0);
+	}
+
+	/* set pause frame dst mac addr */
+	wr32(hw, NGBE_RDB_PFCMACDAL, 0xC2000001);
+	wr32(hw, NGBE_RDB_PFCMACDAH, 0x0180);
+	if (hw->mac.type == ngbe_mac_type_rgmii)
+		wr32(hw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
+	if (hw->gpio_ctrl) {
+		/* gpio0 is used to power on/off control*/
+		wr32(hw, NGBE_GPIO_DDR, 0x1);
+		wr32(hw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
+	}
+	return 0;
+}
+
+/**
+ *  ngbe_reset_hw - Perform hardware reset
+ *  @hw: pointer to hardware structure
+ *
+ *  Resets the hardware by resetting the transmit and receive units, masks
+ *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
+ *  reset.
+ **/
+int ngbe_reset_hw(struct ngbe_hw *hw)
+{
+	u32 reset_status = 0;
+	u32 rst_delay = 0;
+	int err;
+
+	/* Issue global reset to the MAC.  Needs to be SW reset if link is up.
+	 * If link reset is used when link is up, it might reset the PHY when
+	 * mng is using it.  If link is down or the flag to force full link
+	 * reset is set, then perform link reset.
+	 */
+	if (hw->force_full_reset) {
+		rst_delay = (rd32(hw, NGBE_MIS_RST_ST) &
+			     NGBE_MIS_RST_ST_RST_INIT) >>
+			     NGBE_MIS_RST_ST_RST_INI_SHIFT;
+		if (hw->reset_type == NGBE_SW_RESET) {
+			err = read_poll_timeout(rd32, reset_status,
+						!(reset_status & NGBE_MIS_RST_ST_DEV_RST_ST_MASK),
+						1000, rst_delay + 20000,
+						false, hw,
+						NGBE_MIS_RST_ST);
+			if (!err)
+				return err;
+
+			if (reset_status & NGBE_MIS_RST_ST_DEV_RST_ST_MASK) {
+				err = -EBUSY;
+				dev_err(ngbe_hw_to_dev(hw),
+					"software reset polling failed to complete %d.\n",
+					err);
+				return err;
+			}
+			err = ngbe_check_flash_load(hw, NGBE_SPI_ILDR_STATUS_SW_RESET);
+			if (err != 0)
+				return err;
+		}
+	} else {
+		wr32(hw, NGBE_MIS_RST, 1 << (hw->bus.func + 1) |
+		     rd32(hw, NGBE_MIS_RST));
+		ngbe_flush(hw);
+		msleep(20);
+	}
+
+	err = ngbe_reset_misc(hw);
+	if (err != 0)
+		return err;
+
+	/* Store the permanent mac address */
+	ngbe_get_mac_addr(hw, hw->mac.perm_addr);
+
+	/* reset num_rar_entries to 128 */
+	hw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	ngbe_init_rx_addrs(hw);
+	pci_set_master(((struct ngbe_adapter *)hw->back)->pdev);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
new file mode 100644
index 000000000000..c2c9dc186ad4
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _NGBE_HW_H_
+#define _NGBE_HW_H_
+
+u32 rd32m(struct ngbe_hw *hw, u32 reg, u32 mask);
+void wr32m(struct ngbe_hw *hw, u32 reg, u32 mask, u32 field);
+struct device *ngbe_hw_to_dev(struct ngbe_hw *hw);
+int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data);
+int ngbe_check_flash_load(struct ngbe_hw *hw, u32 check_bit);
+int ngbe_get_pcie_msix_counts(struct ngbe_hw *hw, u16 *msix_count);
+/* mac ops */
+int ngbe_reset_hw(struct ngbe_hw *hw);
+#endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 7674cb6e5700..6ea06d6032c6 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 
 #include "ngbe.h"
+#include "ngbe_hw.h"
 char ngbe_driver_name[] = "ngbe";
 
 /* ngbe_pci_tbl - PCI Device ID Table
@@ -56,6 +57,166 @@ static void ngbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ *  ngbe_init_type_code - Initialize the shared code
+ *  @hw: pointer to hardware structure
+ **/
+static void ngbe_init_type_code(struct ngbe_hw *hw)
+{
+	u8 wol_mask = 0, ncsi_mask = 0;
+	u16 type_mask = 0;
+
+	type_mask = (u16)(hw->subsystem_device_id & NGBE_OEM_MASK);
+	ncsi_mask = (u8)(hw->subsystem_device_id & NGBE_NCSI_MASK);
+	wol_mask = (u8)(hw->subsystem_device_id & NGBE_WOL_MASK);
+
+	switch (type_mask) {
+	case NGBE_SUBID_M88E1512_SFP:
+	case NGBE_SUBID_LY_M88E1512_SFP:
+		hw->phy.type = ngbe_phy_m88e1512_sfi;
+		break;
+	case NGBE_SUBID_M88E1512_RJ45:
+		hw->phy.type = ngbe_phy_m88e1512;
+		break;
+	case NGBE_SUBID_M88E1512_MIX:
+		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		break;
+	case NGBE_SUBID_YT8521S_SFP:
+	case NGBE_SUBID_YT8521S_SFP_GPIO:
+	case NGBE_SUBID_LY_YT8521S_SFP:
+		hw->phy.type = ngbe_phy_yt8521s_sfi;
+		break;
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
+		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
+		break;
+	case NGBE_SUBID_RGMII_FPGA:
+	case NGBE_SUBID_OCP_CARD:
+		fallthrough;
+	default:
+		hw->phy.type = ngbe_phy_internal;
+		break;
+	}
+
+	if (hw->phy.type == ngbe_phy_internal ||
+	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
+		hw->mac.type = ngbe_mac_type_mdi;
+	else
+		hw->mac.type = ngbe_mac_type_rgmii;
+
+	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
+	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
+			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
+
+	switch (type_mask) {
+	case NGBE_SUBID_LY_YT8521S_SFP:
+	case NGBE_SUBID_LY_M88E1512_SFP:
+	case NGBE_SUBID_YT8521S_SFP_GPIO:
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
+		hw->gpio_ctrl = 1;
+		break;
+	default:
+		hw->gpio_ctrl = 0;
+		break;
+	}
+}
+
+/**
+ * ngbe_init_rss_key - Initialize adapter RSS key
+ * @adapter: device handle
+ *
+ * Allocates and initializes the RSS key if it is not allocated.
+ **/
+static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
+{
+	u32 *rss_key;
+
+	if (!adapter->rss_key) {
+		rss_key = kzalloc(NGBE_RSS_KEY_SIZE, GFP_KERNEL);
+		if (unlikely(!rss_key))
+			return -ENOMEM;
+
+		netdev_rss_key_fill(rss_key, NGBE_RSS_KEY_SIZE);
+		adapter->rss_key = rss_key;
+	}
+
+	return 0;
+}
+
+/**
+ * ngbe_sw_init - Initialize general software structures
+ * @adapter: board private structure to initialize
+ **/
+static int ngbe_sw_init(struct ngbe_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ngbe_hw *hw = &adapter->hw;
+	struct device *dev = &pdev->dev;
+	u16 msix_count = 0;
+	u32 ssid = 0;
+	int err = 0;
+
+	/* PCI config space info */
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	hw->revision_id = pdev->revision;
+	hw->bus.device = PCI_SLOT(pdev->devfn);
+	hw->bus.func = PCI_FUNC(pdev->devfn);
+
+	hw->oem_svid = pdev->subsystem_vendor;
+	hw->oem_ssid = pdev->subsystem_device;
+	if (pdev->subsystem_vendor == PCI_SUB_VID_WANGXUN) {
+		hw->subsystem_vendor_id = pdev->subsystem_vendor;
+		hw->subsystem_device_id = pdev->subsystem_device;
+	} else {
+		err = ngbe_flash_read_dword(hw, 0xfffdc, &ssid);
+		if (err < 0) {
+			dev_err(dev, "Read internal subdid err %d\n", err);
+			return err;
+		}
+		hw->subsystem_device_id = swab16((u16)ssid);
+	}
+
+	/* mac type, phy type , oem type */
+	ngbe_init_type_code(hw);
+
+	hw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
+	hw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+	hw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	/* Set common capability flags and settings */
+	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
+
+	err = ngbe_get_pcie_msix_counts(hw, &msix_count);
+	if (err)
+		dev_err(dev, "Do not support MSI-X\n");
+	hw->mac.max_msix_vectors = msix_count;
+
+	adapter->mac_table = kcalloc(hw->mac.num_rar_entries,
+				     sizeof(struct ngbe_mac_addr),
+				     GFP_KERNEL);
+	if (!adapter->mac_table) {
+		dev_err(dev, "mac_table allocation failed: %d\n", err);
+		return -ENOMEM;
+	}
+
+	if (ngbe_init_rss_key(adapter))
+		return -ENOMEM;
+
+	/* enable itr by default in dynamic mode */
+	adapter->rx_itr_setting = 1;
+	adapter->tx_itr_setting = 1;
+
+	/* set default ring sizes */
+	adapter->tx_ring_count = NGBE_DEFAULT_TXD;
+	adapter->rx_ring_count = NGBE_DEFAULT_RXD;
+
+	/* set default work limits */
+	adapter->tx_work_limit = NGBE_DEFAULT_TX_WORK;
+	adapter->rx_work_limit = NGBE_DEFAULT_RX_WORK;
+
+	return 0;
+}
+
 /**
  * ngbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -72,6 +233,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 {
 	struct ngbe_adapter *adapter = NULL;
 	struct net_device *netdev;
+	struct ngbe_hw *hw = NULL;
+	static int cards_found;
 	int err;
 
 	err = pci_enable_device_mem(pdev);
@@ -111,6 +274,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	hw->back = adapter;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
 					pci_resource_start(pdev, 0),
@@ -120,12 +285,42 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	hw->hw_addr = adapter->io_addr;
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+	adapter->bd_number = cards_found;
+
+	/* setup the private structure */
+	err = ngbe_sw_init(adapter);
+	if (err)
+		goto err_free_mac_table;
+
+	/* check if flash load is done after hw power up */
+	err = ngbe_check_flash_load(hw, NGBE_SPI_ILDR_STATUS_PERST);
+	if (err)
+		goto err_sw_init;
+	err = ngbe_check_flash_load(hw, NGBE_SPI_ILDR_STATUS_PWRRST);
+	if (err)
+		goto err_sw_init;
+
+	/* reset_hw fills in the perm_addr as well */
+	hw->phy.reset_if_overtemp = true;
+	err = ngbe_reset_hw(hw);
+	hw->phy.reset_if_overtemp = false;
+	if (err) {
+		dev_err(&pdev->dev, "HW reset failed: %d\n", err);
+		goto err_sw_init;
+	}
+
 	pci_set_drvdata(pdev, adapter);
 
 	return 0;
 
+err_sw_init:
+err_free_mac_table:
+	kfree(adapter->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -146,6 +341,9 @@ static int ngbe_probe(struct pci_dev *pdev,
  **/
 static void ngbe_remove(struct pci_dev *pdev)
 {
+	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+
+	kfree(adapter->mac_table);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h
new file mode 100644
index 000000000000..aa8a3c5211cd
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _NGBE_OSDEP_H_
+#define _NGBE_OSDEP_H_
+
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/if_ether.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
+#include <linux/etherdevice.h>
+
+#define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
+#define rd32(a, reg)		readl((a)->hw_addr + (reg))
+#define wr64(a, reg, value)	writeq((value), ((a)->hw_addr + (reg)))
+#define rd64(a, reg)		readq((a)->hw_addr + (reg))
+
+#define wr32a(a, reg, off, val)	wr32((a), (reg) + ((off) << 2), (val))
+#define rd32a(a, reg, offset)	rd32((a), (reg) + ((offset) << 2))
+#define ngbe_flush(a)		rd32((a), 0x10000)
+
+#endif /* _NGBE_OSDEP_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 26e776c3539a..2c9d70f8c2bb 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -4,9 +4,6 @@
 #ifndef _NGBE_TYPE_H_
 #define _NGBE_TYPE_H_
 
-#include <linux/types.h>
-#include <linux/netdevice.h>
-
 /************ NGBE_register.h ************/
 /* Vendor ID */
 #ifndef PCI_VENDOR_ID_WANGXUN
@@ -27,6 +24,9 @@
 #define NGBE_DEV_ID_EM_WX1860A1			0x010a
 #define NGBE_DEV_ID_EM_WX1860A1L		0x010b
 
+/* Subsystem Vendor ID*/
+#define PCI_SUB_VID_WANGXUN			0x8088
+
 /* Subsystem ID */
 #define NGBE_SUBID_M88E1512_SFP			0x0003
 #define NGBE_SUBID_OCP_CARD			0x0040
@@ -47,4 +47,430 @@
 #define NGBE_WOL_SUP				0x4000
 #define NGBE_WOL_MASK				0x4000
 
+#define NGBE_ETH_LENGTH_OF_ADDRESS		6
+#define NGBE_MAX_MSIX_VECTORS			0x09
+#define NGBE_RAR_ENTRIES			32
+/* MSI-X capability fields masks */
+#define NGBE_PCIE_MSIX_TBL_SZ_MASK		0x7FF
+#define NGBE_PCI_LINK_STATUS			0xB2
+
+/* Media-dependent registers. */
+#define NGBE_MDIO_PHY_ID_HIGH			0x2 /* PHY ID High Reg*/
+#define NGBE_MDIO_PHY_ID_LOW			0x3 /* PHY ID Low Reg*/
+#define NGBE_MDIO_CLAUSE_SELECT			0x11220
+
+/**************** Global Registers ****************************/
+/* chip control Registers */
+#define NGBE_MIS_RST				0x1000C
+#define NGBE_MIS_PWR				0x10000
+#define NGBE_MIS_CTL				0x10004
+#define NGBE_MIS_PF_SM				0x10008
+#define NGBE_MIS_PRB_CTL			0x10010
+#define NGBE_MIS_ST				0x10028
+#define NGBE_MIS_SWSM				0x1002C
+#define NGBE_MIS_RST_ST				0x10030
+
+/* chip control bit and mask */
+#define NGBE_MIS_RST_SW_RST			BIT(0)
+#define NGBE_MIS_RST_LAN0_RST			BIT(1)
+#define NGBE_MIS_RST_LAN1_RST			BIT(2)
+#define NGBE_MIS_RST_LAN2_RST			BIT(3)
+#define NGBE_MIS_RST_LAN3_RST			BIT(4)
+#define NGBE_MIS_RST_FW_RST			BIT(5)
+
+#define NGBE_MIS_ST_MNG_INIT_DN			BIT(0)
+#define NGBE_MIS_ST_MNG_VETO			BIT(8)
+#define NGBE_MIS_ST_LAN0_ECC			BIT(16)
+#define NGBE_MIS_ST_LAN1_ECC			BIT(17)
+#define NGBE_MIS_ST_LAN2_ECC			BIT(18)
+#define NGBE_MIS_ST_LAN3_ECC			BIT(19)
+#define NGBE_MIS_ST_MNG_ECC			BIT(20)
+#define NGBE_MIS_ST_PCORE_ECC			BIT(21)
+#define NGBE_MIS_ST_PCIWRP_ECC			BIT(22)
+#define NGBE_MIS_ST_PCIEPHY_ECC			BIT(23)
+#define NGBE_MIS_ST_FMGR_ECC			BIT(24)
+#define NGBE_MIS_ST_GPHY_IN_RST(_r)		(BIT(9) << (_r))
+
+#define NGBE_MIS_SWSM_SMBI			BIT(0)
+#define NGBE_MIS_RST_ST_DEV_RST_ST_MASK		0x00180000U
+#define NGBE_MIS_RST_ST_RST_INIT		0x0000FF00U
+#define NGBE_MIS_RST_ST_RST_INI_SHIFT		8
+#define NGBE_MIS_RST_ST_RST_TIM			0x000000FFU
+#define NGBE_MIS_PF_SM_SM			BIT(0)
+#define NGBE_MIS_PRB_CTL_LAN0_UP		BIT(3)
+#define NGBE_MIS_PRB_CTL_LAN1_UP		BIT(2)
+#define NGBE_MIS_PRB_CTL_LAN2_UP		BIT(1)
+#define NGBE_MIS_PRB_CTL_LAN3_UP		BIT(0)
+
+#define NGBE_SPI_CLK_DIV			3
+#define NGBE_SPI_CMD_READ_DWORD			1  /* SPI read a dword cmd */
+#define NGBE_SPI_CLK_CMD_OFFSET			28  /* SPI cmd field off in cmd reg */
+#define NGBE_SPI_CLK_DIV_OFFSET			25  /* SPI clk div field off in cmd reg */
+#define NGBE_SPI_STATUS_FLASH_BYPASS		BIT(31)
+#define NGBE_SPI_TIME_OUT_VALUE			10000
+#define NGBE_SPI_H_CMD_REG_ADDR			0x10104  /* SPI cmd register address */
+#define NGBE_SPI_H_DAT_REG_ADDR			0x10108  /* SPI Data register address */
+#define NGBE_SPI_H_STA_REG_ADDR			0x1010c  /* SPI Status register address */
+#define NGBE_SPI_H_USR_CMD_REG_ADDR		0x10110  /* SPI User cmd register address */
+#define NGBE_SPI_CMD_CFG1_ADDR			0x10118  /* Flash cmd cfg register 1 */
+#define NGBE_MISC_RST_REG_ADDR			0x1000c  /* Misc reset register address */
+
+/* Checksum and EEPROM pointers */
+#define NGBE_CALSUM_COMMAND			0xE9
+#define NGBE_CALSUM_CAP_STATUS			0x10224
+#define NGBE_EEPROM_VERSION_STORE_REG		0x1022C
+#define NGBE_SAN_MAC_ADDR_PTR			0x18
+#define NGBE_DEVICE_CAPS			0x1C
+#define NGBE_EEPROM_VERSION_L			0x1D
+#define NGBE_EEPROM_VERSION_H			0x1E
+
+/* GPIO Registers */
+#define NGBE_GPIO_DR				0x14800
+#define NGBE_GPIO_DDR				0x14804
+#define NGBE_GPIO_CTL				0x14808
+#define NGBE_GPIO_INTEN				0x14830
+#define NGBE_GPIO_INTMASK			0x14834
+#define NGBE_GPIO_INTTYPE_LEVEL			0x14838
+#define NGBE_GPIO_POLARITY			0x1483C
+#define NGBE_GPIO_INTSTATUS			0x14840
+#define NGBE_GPIO_EOI				0x1484C
+/*GPIO bit */
+#define NGBE_GPIO_DR_0				BIT(0) /* SDP0 Data Value */
+#define NGBE_GPIO_DR_1				BIT(1) /* SDP1 Data Value */
+#define NGBE_GPIO_DDR_0				BIT(0) /* SDP0 IO direction */
+#define NGBE_GPIO_DDR_1				BIT(1) /* SDP1 IO direction */
+
+/* Wake up registers */
+#define NGBE_PSR_WKUP_CTL			0x15B80
+/* Wake Up Filter Control Bit */
+#define NGBE_PSR_WKUP_CTL_LNKC			BIT(0) /* Link Status Change Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_MAG			BIT(1) /* Magic Packet Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_EX			BIT(2) /* Directed Exact Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_MC			BIT(3) /* Directed Multicast Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_BC			BIT(4) /* Broadcast Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_ARP			BIT(5) /* ARP Request Packet Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_IPV4			BIT(6) /* Directed IPv4 Pkt Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_IPV6			BIT(7) /* Directed IPv6 Pkt Wakeup Enable */
+
+/* FMGR Registers */
+#define NGBE_SPI_ILDR_STATUS			0x10120
+#define NGBE_SPI_ILDR_STATUS_PERST		BIT(0) /* PCIE_PERST is done */
+#define NGBE_SPI_ILDR_STATUS_PWRRST		BIT(1) /* Power on reset done */
+#define NGBE_SPI_ILDR_STATUS_SW_RESET		BIT(11) /* software reset done */
+
+/******************************* PSR Registers *******************************/
+/* psr control */
+#define NGBE_PSR_CTL				0x15000
+#define NGBE_PSR_VLAN_CTL			0x15088
+#define NGBE_PSR_VM_CTL				0x151B0
+#define NGBE_PSR_PKT_CNT			0x151B8
+#define NGBE_PSR_MNG_PKT_CNT			0x151BC
+#define NGBE_PSR_DBG_DOP_CNT			0x151C0
+#define NGBE_PSR_MNG_DOP_CNT			0x151C4
+#define NGBE_PSR_VM_FLP_L			0x151C8
+
+/* Header split receive */
+#define NGBE_PSR_CTL_SW_EN			BIT(18)
+#define NGBE_PSR_CTL_PCSD			BIT(13)
+#define NGBE_PSR_CTL_IPPCSE			BIT(12)
+#define NGBE_PSR_CTL_BAM			BIT(10)
+#define NGBE_PSR_CTL_UPE			BIT(9)
+#define NGBE_PSR_CTL_MPE			BIT(8)
+#define NGBE_PSR_CTL_MFE			BIT(7)
+#define NGBE_PSR_CTL_MO				0x00000060U
+#define NGBE_PSR_CTL_TPE			BIT(4)
+#define NGBE_PSR_CTL_MO_SHIFT			5
+
+/* mcasst/ucast overflow tbl */
+#define NGBE_PSR_MC_TBL(_i)			(0x15200  + ((_i) * 4))
+#define NGBE_PSR_UC_TBL(_i)			(0x15400 + ((_i) * 4))
+
+/* vlan tbl */
+#define NGBE_PSR_VLAN_TBL(_i)			(0x16000 + ((_i) * 4))
+
+/************************************** MNG ********************************/
+#define NGBE_MNG_FW_SM				0x1E000
+#define NGBE_MNG_SWFW_SYNC			0x1E008
+#define NGBE_MNG_MBOX				0x1E100
+#define NGBE_MNG_MBOX_CTL			0x1E044
+
+/* SW_FW_SYNC definitions */
+#define NGBE_MNG_SWFW_SYNC_SW_PHY		BIT(0)
+#define NGBE_MNG_SWFW_SYNC_SW_FLASH		BIT(3)
+#define NGBE_MNG_SWFW_SYNC_SW_MB		BIT(2)
+
+#define NGBE_MNG_MBOX_CTL_SWRDY			BIT(0)
+#define NGBE_MNG_MBOX_CTL_SWACK			BIT(1)
+#define NGBE_MNG_MBOX_CTL_FWRDY			BIT(2)
+#define NGBE_MNG_MBOX_CTL_FWACK			BIT(3)
+
+/************************************* ETH MAC *****************************/
+#define NGBE_MAC_TX_CFG				0x11000
+#define NGBE_MAC_RX_CFG				0x11004
+#define NGBE_MAC_PKT_FLT			0x11008
+#define NGBE_MAC_PKT_FLT_PR			BIT(0) /* promiscuous mode */
+#define NGBE_MAC_PKT_FLT_RA			BIT(31) /* receive all */
+#define NGBE_MAC_WDG_TIMEOUT			0x1100C
+#define NGBE_MAC_TX_FLOW_CTRL			0x11070
+#define NGBE_MAC_RX_FLOW_CTRL			0x11090
+#define NGBE_MAC_INT_ST				0x110B0
+#define NGBE_MAC_INT_EN				0x110B4
+#define NGBE_MAC_ADDRESS0_HIGH			0x11300
+#define NGBE_MAC_ADDRESS0_LOW			0x11304
+
+#define NGBE_MAC_TX_CFG_TE			BIT(0)
+#define NGBE_MAC_RX_CFG_RE			BIT(0)
+#define NGBE_MAC_RX_CFG_JE			BIT(8)
+#define NGBE_MAC_RX_CFG_LM			BIT(10)
+#define NGBE_MAC_WDG_TIMEOUT_PWE		BIT(8)
+
+#define NGBE_MAC_RX_FLOW_CTRL_RFE		BIT(0) /* receive fc enable */
+
+/* statistic */
+#define NGBE_MAC_LXOFFRXC			0x11988
+#define NGBE_MAC_PXOFFRXC			0x119DC
+#define NGBE_RX_BC_FRAMES_GOOD_LOW		0x11918
+#define NGBE_RX_CRC_ERROR_FRAMES_LOW		0x11928
+#define NGBE_RX_LEN_ERROR_FRAMES_LOW		0x11978
+#define NGBE_RX_UNDERSIZE_FRAMES_GOOD		0x11938
+#define NGBE_RX_OVERSIZE_FRAMES_GOOD		0x1193C
+#define NGBE_RX_FRAME_CNT_GOOD_BAD_LOW		0x11900
+#define NGBE_TX_FRAME_CNT_GOOD_BAD_LOW		0x1181C
+#define NGBE_TX_MC_FRAMES_GOOD_LOW		0x1182C
+#define NGBE_TX_BC_FRAMES_GOOD_LOW		0x11824
+#define NGBE_MMC_CONTROL			0x11800
+#define NGBE_MMC_CONTROL_RSTONRD		BIT(2) /* reset on read */
+
+/* Manangbeent */
+#define NGBE_PSR_MNG_FIT_CTL			0x15820
+/* Manangbeent Bit Fields and Masks */
+#define NGBE_PSR_MNG_FIT_CTL_MPROXYE		BIT(30) /* Manangbeent Proxy Enable*/
+#define NGBE_PSR_MNG_FIT_CTL_RCV_TCO_EN		BIT(17) /* Rcv TCO packet enable */
+#define NGBE_PSR_MNG_FIT_CTL_EN_BMC2OS		BIT(28) /* Ena BMC2OS and OS2BMC traffic */
+#define NGBE_PSR_MNG_FIT_CTL_EN_BMC2OS_SHIFT	28
+
+#define NGBE_PSR_MNG_FLEX_SEL			0x1582C
+#define NGBE_PSR_MNG_FLEX_DW_L(_i)		(0x15A00  +  ((_i) * 16)) /* [0,15] */
+#define NGBE_PSR_MNG_FLEX_DW_H(_i)		(0x15A04  +  ((_i) * 16))
+#define NGBE_PSR_MNG_FLEX_MSK(_i)		(0x15A08  +  ((_i) * 16))
+
+/* Wake up registers */
+#define NGBE_PSR_WKUP_CTL			0x15B80
+#define NGBE_PSR_WKUP_IPV			0x15B84
+#define NGBE_PSR_LAN_FLEX_SEL			0x15B8C
+#define NGBE_PSR_WKUP_IP4TBL(_i)		(0x15BC0  +  ((_i) * 4)) /* [0,3] */
+#define NGBE_PSR_WKUP_IP6TBL(_i)		(0x15BE0  +  ((_i) * 4))
+#define NGBE_PSR_LAN_FLEX_DW_L(_i)		(0x15C00  +  ((_i) * 16)) /* [0,15] */
+#define NGBE_PSR_LAN_FLEX_DW_H(_i)		(0x15C04  +  ((_i) * 16))
+#define NGBE_PSR_LAN_FLEX_MSK(_i)		(0x15C08  +  ((_i) * 16))
+#define NGBE_PSR_LAN_FLEX_CTL			0x15CFC
+
+/* mac switcher */
+#define NGBE_PSR_MAC_SWC_AD_L			0x16200
+#define NGBE_PSR_MAC_SWC_AD_H			0x16204
+#define NGBE_PSR_MAC_SWC_VM			0x16208
+#define NGBE_PSR_MAC_SWC_IDX			0x16210
+/* RAH */
+#define NGBE_PSR_MAC_SWC_AD_H_AD(v)		(((v) & 0xFFFF))
+#define NGBE_PSR_MAC_SWC_AD_H_ADTYPE(v)		(((v) & 0x1) << 30)
+#define NGBE_PSR_MAC_SWC_AD_H_AV		BIT(31)
+#define NGBE_CLEAR_VMDQ_ALL			0xFFFFFFFFU
+
+/* statistic */
+#define NGBE_RDB_MPCNT				0x19040
+#define NGBE_RDB_PKT_CNT			0x19060
+#define NGBE_RDB_REPLI_CNT			0x19064
+#define NGBE_RDB_DRP_CNT			0x19068
+#define NGBE_RDB_LXONTXC			0x1921C
+#define NGBE_RDB_LXOFFTXC			0x19218
+#define NGBE_RDB_PFCMACDAL			0x19210
+#define NGBE_RDB_PFCMACDAH			0x19214
+#define NGBE_RDB_TXSWERR			0x1906C
+#define NGBE_RDB_TXSWERR_TB_FREE		0x3FF
+
+/****************** Manageablility Host Interface defines ********************/
+#define NGBE_HI_MAX_BLOCK_BYTE_LENGTH		256 /* Num of bytes in range */
+#define NGBE_HI_COMMAND_TIMEOUT			200 /* Process HI command limit */
+#define NGBE_HI_FLASH_ERASE_TIMEOUT		200 /* Process Erase command limit */
+#define NGBE_HI_FLASH_UPDATE_TIMEOUT		200 /* Process Update command limit */
+
+/* CEM Support */
+#define NGBE_FW_READ_SHADOW_RAM_CMD		0x31
+#define NGBE_FW_READ_SHADOW_RAM_LEN		0x6
+#define NGBE_FW_WRITE_SHADOW_RAM_CMD		0x33
+#define NGBE_FW_WRITE_SHADOW_RAM_LEN		0xA /* 8 plus 1 WORD to write */
+#define NGBE_FW_EEPROM_CHECKSUM_CMD		0xE9
+#define NGBE_FW_NVM_DATA_OFFSET			3
+#define NGBE_FW_CMD_DEFAULT_CHECKSUM		0xFF /* checksum always 0xFF */
+
+/* Host Interface Command Structures */
+struct ngbe_hic_hdr {
+	u8 cmd;
+	u8 buf_len;
+	union {
+		u8 cmd_resv;
+		u8 ret_status;
+	} cmd_or_resp;
+	u8 checksum;
+};
+
+struct ngbe_hic_hdr2_req {
+	u8 cmd;
+	u8 buf_lenh;
+	u8 buf_lenl;
+	u8 checksum;
+};
+
+struct ngbe_hic_hdr2_rsp {
+	u8 cmd;
+	u8 buf_lenl;
+	u8 buf_lenh_status;     /* 7-5: high bits of buf_len, 4-0: status */
+	u8 checksum;
+};
+
+union ngbe_hic_hdr2 {
+	struct ngbe_hic_hdr2_req req;
+	struct ngbe_hic_hdr2_rsp rsp;
+};
+
+/* These need to be dword aligned */
+struct ngbe_hic_read_shadow_ram {
+	union ngbe_hic_hdr2 hdr;
+	u32 address;
+	u16 length;
+	u16 pad2;
+	u16 data;
+	u16 pad3;
+};
+
+struct ngbe_hic_write_shadow_ram {
+	union ngbe_hic_hdr2 hdr;
+	u32 address;
+	u16 length;
+	u16 pad2;
+	u16 data;
+	u16 pad3;
+};
+
+enum ngbe_reset_type {
+	NGBE_LAN_RESET = 0,
+	NGBE_SW_RESET,
+	NGBE_GLOBAL_RESET
+};
+
+enum ngbe_phy_type {
+	ngbe_phy_unknown = 0,
+	ngbe_phy_none,
+	ngbe_phy_internal,
+	ngbe_phy_m88e1512,
+	ngbe_phy_m88e1512_sfi,
+	ngbe_phy_m88e1512_unknown,
+	ngbe_phy_yt8521s,
+	ngbe_phy_yt8521s_sfi,
+	ngbe_phy_internal_yt8521s_sfi,
+	ngbe_phy_generic
+};
+
+enum ngbe_media_type {
+	ngbe_media_type_unknown = 0,
+	ngbe_media_type_fiber,
+	ngbe_media_type_copper,
+	ngbe_media_type_backplane,
+	ngbe_media_type_virtual
+};
+
+enum ngbe_mac_type {
+	ngbe_mac_type_unknown = 0,
+	ngbe_mac_type_mdi,
+	ngbe_mac_type_rgmii
+};
+
+struct ngbe_hw;
+
+/* Function pointer table */
+struct ngbe_phy_operations {
+};
+
+struct ngbe_addr_filter_info {
+	u32 num_mc_addrs;
+	u32 rar_used_count;
+	u32 mta_in_use;
+	u32 overflow_promisc;
+	bool user_set_promisc;
+};
+
+/* Bus parameters */
+struct ngbe_bus_info {
+	u8 func;
+	u16 device;
+};
+
+struct ngbe_flash_info {
+	u32 semaphore_delay;
+	u32 dword_size;
+	u16 address_bits;
+};
+
+struct ngbe_eeprom_info {
+	u32 semaphore_delay;
+	u16 word_size;
+	u16 sw_region_offset;
+};
+
+struct ngbe_phy_info {
+	enum ngbe_phy_type type;
+	enum ngbe_media_type media_type;
+
+	u32 addr;
+	u32 id;
+
+	bool reset_if_overtemp;
+
+};
+
+struct ngbe_mac_info {
+	u8 addr[NGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 perm_addr[NGBE_ETH_LENGTH_OF_ADDRESS];
+	u8 san_addr[NGBE_ETH_LENGTH_OF_ADDRESS];
+
+	enum ngbe_mac_type type;
+	u32 max_tx_queues;
+	u32 max_rx_queues;
+	u16 max_msix_vectors;
+	u32 num_rar_entries;
+
+	s32 mc_filter_type;
+	u32 mcft_size;
+};
+
+struct ngbe_hw {
+	u8 __iomem *hw_addr;
+	void *back;
+
+	struct ngbe_addr_filter_info addr_ctrl;
+
+	struct ngbe_bus_info bus;
+	struct ngbe_flash_info flash;
+	struct ngbe_eeprom_info eeprom;
+
+	struct ngbe_mac_info mac;
+	struct ngbe_phy_info phy;
+
+	u16 device_id;
+	u16 vendor_id;
+	u16 subsystem_device_id;
+	u16 subsystem_vendor_id;
+	u16 oem_ssid;
+	u16 oem_svid;
+	u8 revision_id;
+
+	bool wol_enabled;
+	bool ncsi_enabled;
+	bool gpio_ctrl;
+
+	/* for reset */
+	enum ngbe_reset_type reset_type;
+	bool force_full_reset;
+
+};
 #endif /* _NGBE_TYPE_H_ */
-- 
2.37.1

