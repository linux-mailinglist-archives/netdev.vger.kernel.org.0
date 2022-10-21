Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E385606D47
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 03:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJUB5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 21:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJUB5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 21:57:08 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186B322B3B0
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 18:57:04 -0700 (PDT)
X-QQ-mid: bizesmtp66t1666317419t1nhh50w
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 21 Oct 2022 09:56:58 +0800 (CST)
X-QQ-SSF: 01400000000000H0V000000A0000000
X-QQ-FEAT: XBN7tc9DADJhclqn4O73mP1PcdXna1QFb6bRycRrSHCgM9ZcnBAJRmEub+OxZ
        p0WtpwAh0xSSdCRvgUVLS2NGwcQteuoLiJ9M0c7O95vOLzUxNwt+3bhVLosN8X1rNs8YYc5
        plnH6Gn7sAoOQi/KZ4nNshOsoqazhAeID3C+rkzC68NDKtkbRH/gxi6BzKthTKQppK3cSh6
        sKWtKydsMq69CstJkcjCxHJGBDlQhdmoo78ILgvu8/WSFqX6KdVlLp+KU53BkNDdjPBqP3R
        kdlBP5WQTkNP3FfJRYKWnaA7c5PGodUm14RZ+/tbXckOvGNZ+dlkBp/H27UNA3LU5GSEZcs
        mQnnV//yKTND5EHTu9GT0LfO0Y9yCbi/6gsFh0h98rK/RJyuYCp96xnalyj9ksgdCZmygaP
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RESEND PATCH net-next v4 3/3] net: txgbe: Set MAC address and register netdev
Date:   Fri, 21 Oct 2022 10:07:20 +0800
Message-Id: <20221021020720.519223-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221021020720.519223-1-jiawenwu@trustnetic.com>
References: <20221021020720.519223-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MAC address related operations, and register netdev.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 233 ++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   6 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  37 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  13 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  13 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 270 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   3 +
 7 files changed, 567 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 76f88cfb2476..8dbbac862f27 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
 
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 
@@ -71,7 +73,230 @@ int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
 }
 EXPORT_SYMBOL(wx_check_flash_load);
 
-static void wx_disable_rx(struct wx_hw *wxhw)
+/**
+ *  wx_get_mac_addr - Generic get MAC address
+ *  @wxhw: pointer to hardware structure
+ *  @mac_addr: Adapter MAC address
+ *
+ *  Reads the adapter's MAC address from first Receive Address Register (RAR0)
+ *  A reset of the adapter must be performed prior to calling this function
+ *  in order for the MAC address to have been loaded from the EEPROM into RAR0
+ **/
+void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr)
+{
+	u32 rar_high;
+	u32 rar_low;
+	u16 i;
+
+	wr32(wxhw, WX_PSR_MAC_SWC_IDX, 0);
+	rar_high = rd32(wxhw, WX_PSR_MAC_SWC_AD_H);
+	rar_low = rd32(wxhw, WX_PSR_MAC_SWC_AD_L);
+
+	for (i = 0; i < 2; i++)
+		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
+
+	for (i = 0; i < 4; i++)
+		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
+}
+EXPORT_SYMBOL(wx_get_mac_addr);
+
+/**
+ *  wx_set_rar - Set Rx address register
+ *  @wxhw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *  @addr: Address to put into receive address register
+ *  @pools: VMDq "set" or "pool" index
+ *  @enable_addr: set flag that address is active
+ *
+ *  Puts an ethernet address into a receive address register.
+ **/
+int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
+	       u32 enable_addr)
+{
+	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 rar_low, rar_high;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		wx_err(wxhw, "RAR index %d is out of range.\n", index);
+		return -EINVAL;
+	}
+
+	/* select the MAC address */
+	wr32(wxhw, WX_PSR_MAC_SWC_IDX, index);
+
+	/* setup VMDq pool mapping */
+	wr32(wxhw, WX_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
+	if (wxhw->mac.type == wx_mac_sp)
+		wr32(wxhw, WX_PSR_MAC_SWC_VM_H, pools >> 32);
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
+		rar_high |= WX_PSR_MAC_SWC_AD_H_AV;
+
+	wr32(wxhw, WX_PSR_MAC_SWC_AD_L, rar_low);
+	wr32m(wxhw, WX_PSR_MAC_SWC_AD_H,
+	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
+	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	       WX_PSR_MAC_SWC_AD_H_AV),
+	      rar_high);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_set_rar);
+
+/**
+ *  wx_clear_rar - Remove Rx address register
+ *  @wxhw: pointer to hardware structure
+ *  @index: Receive address register to write
+ *
+ *  Clears an ethernet address from a receive address register.
+ **/
+int wx_clear_rar(struct wx_hw *wxhw, u32 index)
+{
+	u32 rar_entries = wxhw->mac.num_rar_entries;
+
+	/* Make sure we are using a valid rar index range */
+	if (index >= rar_entries) {
+		wx_err(wxhw, "RAR index %d is out of range.\n", index);
+		return -EINVAL;
+	}
+
+	/* Some parts put the VMDq setting in the extra RAH bits,
+	 * so save everything except the lower 16 bits that hold part
+	 * of the address and the address valid bit.
+	 */
+	wr32(wxhw, WX_PSR_MAC_SWC_IDX, index);
+
+	wr32(wxhw, WX_PSR_MAC_SWC_VM_L, 0);
+	wr32(wxhw, WX_PSR_MAC_SWC_VM_H, 0);
+
+	wr32(wxhw, WX_PSR_MAC_SWC_AD_L, 0);
+	wr32m(wxhw, WX_PSR_MAC_SWC_AD_H,
+	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
+	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	       WX_PSR_MAC_SWC_AD_H_AV),
+	      0);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_clear_rar);
+
+/**
+ *  wx_clear_vmdq - Disassociate a VMDq pool index from a rx address
+ *  @wxhw: pointer to hardware struct
+ *  @rar: receive address register index to disassociate
+ *  @vmdq: VMDq pool index to remove from the rar
+ **/
+static int wx_clear_vmdq(struct wx_hw *wxhw, u32 rar, u32 __maybe_unused vmdq)
+{
+	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 mpsar_lo, mpsar_hi;
+
+	/* Make sure we are using a valid rar index range */
+	if (rar >= rar_entries) {
+		wx_err(wxhw, "RAR index %d is out of range.\n", rar);
+		return -EINVAL;
+	}
+
+	wr32(wxhw, WX_PSR_MAC_SWC_IDX, rar);
+	mpsar_lo = rd32(wxhw, WX_PSR_MAC_SWC_VM_L);
+	mpsar_hi = rd32(wxhw, WX_PSR_MAC_SWC_VM_H);
+
+	if (!mpsar_lo && !mpsar_hi)
+		return 0;
+
+	/* was that the last pool using this rar? */
+	if (mpsar_lo == 0 && mpsar_hi == 0 && rar != 0)
+		wx_clear_rar(wxhw, rar);
+
+	return 0;
+}
+
+/**
+ *  wx_init_uta_tables - Initialize the Unicast Table Array
+ *  @wxhw: pointer to hardware structure
+ **/
+static void wx_init_uta_tables(struct wx_hw *wxhw)
+{
+	int i;
+
+	wx_dbg(wxhw, " Clearing UTA\n");
+
+	for (i = 0; i < 128; i++)
+		wr32(wxhw, WX_PSR_UC_TBL(i), 0);
+}
+
+/**
+ *  wx_init_rx_addrs - Initializes receive address filters.
+ *  @wxhw: pointer to hardware structure
+ *
+ *  Places the MAC address in receive address register 0 and clears the rest
+ *  of the receive address registers. Clears the multicast table. Assumes
+ *  the receiver is in reset when the routine is called.
+ **/
+void wx_init_rx_addrs(struct wx_hw *wxhw)
+{
+	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 psrctl;
+	int i;
+
+	/* If the current mac address is valid, assume it is a software override
+	 * to the permanent address.
+	 * Otherwise, use the permanent address from the eeprom.
+	 */
+	if (!is_valid_ether_addr(wxhw->mac.addr)) {
+		/* Get the MAC address from the RAR0 for later reference */
+		wx_get_mac_addr(wxhw, wxhw->mac.addr);
+		wx_dbg(wxhw, "Keeping Current RAR0 Addr = %pM\n", wxhw->mac.addr);
+	} else {
+		/* Setup the receive address. */
+		wx_dbg(wxhw, "Overriding MAC Address in RAR[0]\n");
+		wx_dbg(wxhw, "New MAC Addr = %pM\n", wxhw->mac.addr);
+
+		wx_set_rar(wxhw, 0, wxhw->mac.addr, 0, WX_PSR_MAC_SWC_AD_H_AV);
+
+		if (wxhw->mac.type == wx_mac_sp) {
+			/* clear VMDq pool/queue selection for RAR 0 */
+			wx_clear_vmdq(wxhw, 0, WX_CLEAR_VMDQ_ALL);
+		}
+	}
+
+	/* Zero out the other receive addresses. */
+	wx_dbg(wxhw, "Clearing RAR[1-%d]\n", rar_entries - 1);
+	for (i = 1; i < rar_entries; i++) {
+		wr32(wxhw, WX_PSR_MAC_SWC_IDX, i);
+		wr32(wxhw, WX_PSR_MAC_SWC_AD_L, 0);
+		wr32(wxhw, WX_PSR_MAC_SWC_AD_H, 0);
+	}
+
+	/* Clear the MTA */
+	wxhw->addr_ctrl.mta_in_use = 0;
+	psrctl = rd32(wxhw, WX_PSR_CTL);
+	psrctl &= ~(WX_PSR_CTL_MO | WX_PSR_CTL_MFE);
+	psrctl |= wxhw->mac.mc_filter_type << WX_PSR_CTL_MO_SHIFT;
+	wr32(wxhw, WX_PSR_CTL, psrctl);
+	wx_dbg(wxhw, " Clearing MTA\n");
+	for (i = 0; i < wxhw->mac.mcft_size; i++)
+		wr32(wxhw, WX_PSR_MC_TBL(i), 0);
+
+	wx_init_uta_tables(wxhw);
+}
+EXPORT_SYMBOL(wx_init_rx_addrs);
+
+void wx_disable_rx(struct wx_hw *wxhw)
 {
 	u32 pfdtxgswc;
 	u32 rxctrl;
@@ -97,6 +322,7 @@ static void wx_disable_rx(struct wx_hw *wxhw)
 		}
 	}
 }
+EXPORT_SYMBOL(wx_disable_rx);
 
 /**
  *  wx_disable_pcie_master - Disable PCI-express master access
@@ -105,7 +331,7 @@ static void wx_disable_rx(struct wx_hw *wxhw)
  *  Disables PCI-Express master access and verifies there are no pending
  *  requests.
  **/
-static int wx_disable_pcie_master(struct wx_hw *wxhw)
+int wx_disable_pcie_master(struct wx_hw *wxhw)
 {
 	int status = 0;
 	u32 val;
@@ -125,10 +351,11 @@ static int wx_disable_pcie_master(struct wx_hw *wxhw)
 
 	return status;
 }
+EXPORT_SYMBOL(wx_disable_pcie_master);
 
 /**
  *  wx_stop_adapter - Generic stop Tx/Rx units
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *
  *  Sets the adapter_stopped flag within wx_hw struct. Clears interrupts,
  *  disables transmit and receive units. The adapter_stopped flag is used by
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 2c4c4cbbfb46..58a943dc76c1 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -5,6 +5,12 @@
 #define _WX_HW_H_
 
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
+void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr);
+int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools, u32 enable_addr);
+int wx_clear_rar(struct wx_hw *wxhw, u32 index);
+void wx_init_rx_addrs(struct wx_hw *wxhw);
+void wx_disable_rx(struct wx_hw *wxhw);
+int wx_disable_pcie_master(struct wx_hw *wxhw);
 int wx_stop_adapter(struct wx_hw *wxhw);
 void wx_reset_misc(struct wx_hw *wxhw);
 int wx_sw_init(struct wx_hw *wxhw);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index c720ad66f36c..a84ff4586013 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -51,6 +51,12 @@
 #define WX_TS_ALARM_ST_DALARM        BIT(1)
 #define WX_TS_ALARM_ST_ALARM         BIT(0)
 
+/*********************** Transmit DMA registers **************************/
+/* transmit global control */
+#define WX_TDM_CTL                   0x18000
+/* TDM CTL BIT */
+#define WX_TDM_CTL_TE                BIT(0) /* Transmit Enable */
+
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
 #define WX_RDB_PB_CTL                0x19000
@@ -76,6 +82,9 @@
 #define WX_PSR_CTL_MO_SHIFT          5
 #define WX_PSR_CTL_MO                (0x3 << WX_PSR_CTL_MO_SHIFT)
 #define WX_PSR_CTL_TPE               BIT(4)
+/* mcasst/ucast overflow tbl */
+#define WX_PSR_MC_TBL(_i)            (0x15200  + ((_i) * 4))
+#define WX_PSR_UC_TBL(_i)            (0x15400 + ((_i) * 4))
 
 /* Management */
 #define WX_PSR_MNG_FLEX_SEL          0x1582C
@@ -87,7 +96,20 @@
 #define WX_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define WX_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 
+/* mac switcher */
+#define WX_PSR_MAC_SWC_AD_L          0x16200
+#define WX_PSR_MAC_SWC_AD_H          0x16204
+#define WX_PSR_MAC_SWC_AD_H_AD(v)       (((v) & 0xFFFF))
+#define WX_PSR_MAC_SWC_AD_H_ADTYPE(v)   (((v) & 0x1) << 30)
+#define WX_PSR_MAC_SWC_AD_H_AV       BIT(31)
+#define WX_PSR_MAC_SWC_VM_L          0x16208
+#define WX_PSR_MAC_SWC_VM_H          0x1620C
+#define WX_PSR_MAC_SWC_IDX           0x16210
+#define WX_CLEAR_VMDQ_ALL            0xFFFFFFFFU
+
 /************************************* ETH MAC *****************************/
+#define WX_MAC_TX_CFG                0x11000
+#define WX_MAC_TX_CFG_TE             BIT(0)
 #define WX_MAC_RX_CFG                0x11004
 #define WX_MAC_RX_CFG_RE             BIT(0)
 #define WX_MAC_RX_CFG_JE             BIT(8)
@@ -143,16 +165,28 @@ enum wx_mac_type {
 struct wx_mac_info {
 	enum wx_mac_type type;
 	bool set_lben;
+	u8 addr[ETH_ALEN];
+	u8 perm_addr[ETH_ALEN];
+	s32 mc_filter_type;
+	u32 mcft_size;
+	u32 num_rar_entries;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
 	struct wx_thermal_sensor_data sensor;
 };
 
+struct wx_addr_filter_info {
+	u32 num_mc_addrs;
+	u32 mta_in_use;
+	bool user_set_promisc;
+};
+
 struct wx_hw {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
 	struct wx_bus_info bus;
 	struct wx_mac_info mac;
+	struct wx_addr_filter_info addr_ctrl;
 	u16 device_id;
 	u16 vendor_id;
 	u16 subsystem_device_id;
@@ -199,4 +233,7 @@ wr32m(struct wx_hw *wxhw, u32 reg, u32 mask, u32 field)
 #define wx_err(wxhw, fmt, arg...) \
 	dev_err(&(wxhw)->pdev->dev, fmt, ##arg)
 
+#define wx_dbg(wxhw, fmt, arg...) \
+	dev_dbg(&(wxhw)->pdev->dev, fmt, ##arg)
+
 #endif /* _WX_TYPE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index f866d7fa7161..52e350f9a7d9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -11,6 +11,18 @@
 
 #define TXGBE_SP_MAX_TX_QUEUES  128
 #define TXGBE_SP_MAX_RX_QUEUES  128
+#define TXGBE_SP_RAR_ENTRIES    128
+#define TXGBE_SP_MC_TBL_SIZE    128
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
 
 /* board specific private data structure */
 struct txgbe_adapter {
@@ -22,6 +34,7 @@ struct txgbe_adapter {
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
+	struct txgbe_mac_addr *mac_table;
 };
 
 extern char txgbe_driver_name[];
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index a679db3f2e41..c7c92c0ec561 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
 
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
 #include <linux/string.h>
 #include <linux/iopoll.h>
 #include <linux/types.h>
@@ -80,6 +82,17 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 		return status;
 
 	txgbe_reset_misc(hw);
+
+	/* Store the permanent mac address */
+	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
+
+	/* Store MAC address from RAR0, clear receive address registers, and
+	 * clear the multicast table.  Also reset num_rar_entries to 128,
+	 * since we modify this value when programming the SAN MAC address.
+	 */
+	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
+	wx_init_rx_addrs(wxhw);
+
 	pci_set_master(wxhw->pdev);
 
 	return 0;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 409103d5ac2b..adfa4e7d0d52 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -8,6 +8,7 @@
 #include <linux/string.h>
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
+#include <net/ip.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
@@ -72,6 +73,143 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
+static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
+			if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE) {
+				wx_set_rar(wxhw, i,
+					   adapter->mac_table[i].addr,
+					   adapter->mac_table[i].pools,
+					   WX_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				wx_clear_rar(wxhw, i);
+			}
+			adapter->mac_table[i].state &= ~(TXGBE_MAC_STATE_MODIFIED);
+		}
+	}
+}
+
+/* this function destroys the first RAR entry */
+static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
+					 u8 *addr)
+{
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+
+	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
+	adapter->mac_table[0].pools = 1ULL;
+	adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
+				       TXGBE_MAC_STATE_IN_USE);
+	wx_set_rar(wxhw, 0, adapter->mac_table[0].addr,
+		   adapter->mac_table[0].pools,
+		   WX_PSR_MAC_SWC_AD_H_AV);
+}
+
+static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
+{
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	u32 i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+	}
+	txgbe_sync_mac_table(adapter);
+}
+
+static int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
+{
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	/* search table for addr, if found, set to 0 and sync */
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
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
+static void txgbe_reset(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 old_addr[ETH_ALEN];
+	int err;
+
+	err = txgbe_reset_hw(hw);
+	if (err != 0)
+		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
+
+	/* do not flush user set addresses */
+	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
+	txgbe_flush_sw_mac_table(adapter);
+	txgbe_mac_set_default_filter(adapter, old_addr);
+}
+
+static void txgbe_disable_device(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+
+	wx_disable_pcie_master(wxhw);
+	/* disable receives */
+	wx_disable_rx(wxhw);
+
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	if (wxhw->bus.func < 2)
+		wr32m(wxhw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wxhw->bus.func), 0);
+	else
+		dev_err(&adapter->pdev->dev,
+			"%s: invalid bus lan id %d\n",
+			__func__, wxhw->bus.func);
+
+	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
+		/* disable mac transmiter */
+		wr32m(wxhw, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+	}
+
+	/* Disable the Tx DMA engine */
+	wr32m(wxhw, WX_TDM_CTL, WX_TDM_CTL_TE, 0);
+}
+
+static void txgbe_down(struct txgbe_adapter *adapter)
+{
+	txgbe_disable_device(adapter);
+	txgbe_reset(adapter);
+}
+
 /**
  * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
  * @adapter: board private structure to initialize
@@ -104,8 +242,65 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		break;
 	}
 
+	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
 	wxhw->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
 	wxhw->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
+	wxhw->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+
+	adapter->mac_table = kcalloc(wxhw->mac.num_rar_entries,
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
+static int txgbe_open(struct net_device *netdev)
+{
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
+static int txgbe_close(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	txgbe_down(adapter);
 
 	return 0;
 }
@@ -117,6 +312,11 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
+	rtnl_lock();
+	if (netif_running(netdev))
+		txgbe_close_suspend(adapter);
+	rtnl_unlock();
+
 	pci_disable_device(pdev);
 }
 
@@ -132,6 +332,47 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	return NETDEV_TX_OK;
+}
+
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
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct sockaddr *addr = p;
+	int retval;
+
+	retval = eth_prepare_mac_addr_change(netdev, addr);
+	if (retval)
+		return retval;
+
+	txgbe_del_mac_filter(adapter, wxhw->mac.addr, 0);
+	eth_hw_addr_set(netdev, addr->sa_data);
+	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
+
+	txgbe_mac_set_default_filter(adapter, wxhw->mac.addr);
+
+	return 0;
+}
+
+static const struct net_device_ops txgbe_netdev_ops = {
+	.ndo_open               = txgbe_open,
+	.ndo_stop               = txgbe_close,
+	.ndo_start_xmit         = txgbe_xmit_frame,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = txgbe_set_mac,
+};
+
 /**
  * txgbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -201,29 +442,36 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
-	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+	netdev->netdev_ops = &txgbe_netdev_ops;
 
 	/* setup the private structure */
 	err = txgbe_sw_init(adapter);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	/* check if flash load is done after hw power up */
 	err = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 	err = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_PWRRST);
 	if (err)
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 
 	err = txgbe_reset_hw(hw);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
-		goto err_pci_release_regions;
+		goto err_free_mac_table;
 	}
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
+	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+
+	err = register_netdev(netdev);
+	if (err)
+		goto err_free_mac_table;
+
 	pci_set_drvdata(pdev, adapter);
 
 	/* calculate the expected PCIe bandwidth required for optimal
@@ -240,8 +488,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
+
 	return 0;
 
+err_free_mac_table:
+	kfree(adapter->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -262,9 +514,17 @@ static int txgbe_probe(struct pci_dev *pdev,
  **/
 static void txgbe_remove(struct pci_dev *pdev)
 {
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev;
+
+	netdev = adapter->netdev;
+	unregister_netdev(netdev);
+
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
+	kfree(adapter->mac_table);
+
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index c891b0f07227..4082d3b76709 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -40,6 +40,9 @@
 #define TXGBE_SP_MPW  1
 
 /**************** SP Registers ****************************/
+/* chip control Registers */
+#define TXGBE_MIS_PRB_CTL                       0x10010
+#define TXGBE_MIS_PRB_CTL_LAN_UP(_i)            BIT(1 - (_i))
 /* FMGR Registers */
 #define TXGBE_SPI_ILDR_STATUS                   0x10120
 #define TXGBE_SPI_ILDR_STATUS_PERST             BIT(0) /* PCIE_PERST is done */
-- 
2.27.0

