Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B97B64AFFD
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 07:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiLMGlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 01:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLMGlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 01:41:19 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64176E08A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:41:10 -0800 (PST)
X-QQ-mid: bizesmtp77t1670913473t1m4la5g
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 13 Dec 2022 14:37:43 +0800 (CST)
X-QQ-SSF: 01400000000000H0W000B00A0000000
X-QQ-FEAT: WZt+XiBtOcQyeEwgtAVxcZpKMvn5oK0wEUbEWob5ehyhTNYtiSGsBcmJBFIf8
        tVcaG4PIWZUN5M93wdDJmx7m/ao2+vW3AKefNQ2+CoDWpycxsBKG+CGadSQMPPBsJI+MsAs
        kt2QAGl8O/umrRlarmnOaA2aoCLOBOnh8N0KnZRJBFinrp0luKBCO4QPjT73rzfHAzd/rFb
        wdT6BORMHfQV/s0jB+WNIQdgUzQogT/lg8O2EZhz+hklbh1GLDbtONlEg7hpaba+ZUF6cQF
        DDVCUr2vjQGiXSS9/uT7tSln/QB39i1f7WrCK8Yo9+hOMTrEE9sF4/qSHdCZE5XuGY0FnRi
        qA2YlZBGrkWOpurqRTnAlxFYZZfCsu7iOyfEbi5Nj4eEkbgh5qZHXeRwxdvEw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next] net: wangxun: Adjust code structure
Date:   Tue, 13 Dec 2022 14:35:43 +0800
Message-Id: <20221213063543.2408987-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>

Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
And move the same codes which sets MAC address between txgbe and ngbe to
libwx.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 123 ++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   5 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  12 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 --------
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  21 +--
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 127 ++++---------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  59 +++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  43 -----
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  36 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 174 +++---------------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  22 ++-
 13 files changed, 305 insertions(+), 406 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index c57dc3238b3f..205620a1c13b 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/etherdevice.h>
+#include <linux/netdevice.h>
 #include <linux/if_ether.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
@@ -536,8 +537,8 @@ EXPORT_SYMBOL(wx_get_mac_addr);
  *
  *  Puts an ethernet address into a receive address register.
  **/
-int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
-	       u32 enable_addr)
+static int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
+		      u32 enable_addr)
 {
 	u32 rar_entries = wxhw->mac.num_rar_entries;
 	u32 rar_low, rar_high;
@@ -581,7 +582,6 @@ int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
 
 	return 0;
 }
-EXPORT_SYMBOL(wx_set_rar);
 
 /**
  *  wx_clear_rar - Remove Rx address register
@@ -590,7 +590,7 @@ EXPORT_SYMBOL(wx_set_rar);
  *
  *  Clears an ethernet address from a receive address register.
  **/
-int wx_clear_rar(struct wx_hw *wxhw, u32 index)
+static int wx_clear_rar(struct wx_hw *wxhw, u32 index)
 {
 	u32 rar_entries = wxhw->mac.num_rar_entries;
 
@@ -618,7 +618,6 @@ int wx_clear_rar(struct wx_hw *wxhw, u32 index)
 
 	return 0;
 }
-EXPORT_SYMBOL(wx_clear_rar);
 
 /**
  *  wx_clear_vmdq - Disassociate a VMDq pool index from a rx address
@@ -722,6 +721,112 @@ void wx_init_rx_addrs(struct wx_hw *wxhw)
 }
 EXPORT_SYMBOL(wx_init_rx_addrs);
 
+static void wx_sync_mac_table(struct wx_hw *wxhw)
+{
+	int i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		if (wxhw->mac_table[i].state & WX_MAC_STATE_MODIFIED) {
+			if (wxhw->mac_table[i].state & WX_MAC_STATE_IN_USE) {
+				wx_set_rar(wxhw, i,
+					   wxhw->mac_table[i].addr,
+					   wxhw->mac_table[i].pools,
+					   WX_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				wx_clear_rar(wxhw, i);
+			}
+			wxhw->mac_table[i].state &= ~(WX_MAC_STATE_MODIFIED);
+		}
+	}
+}
+
+/* this function destroys the first RAR entry */
+void wx_mac_set_default_filter(struct wx_hw *wxhw, u8 *addr)
+{
+	memcpy(&wxhw->mac_table[0].addr, addr, ETH_ALEN);
+	wxhw->mac_table[0].pools = 1ULL;
+	wxhw->mac_table[0].state = (WX_MAC_STATE_DEFAULT | WX_MAC_STATE_IN_USE);
+	wx_set_rar(wxhw, 0, wxhw->mac_table[0].addr,
+		   wxhw->mac_table[0].pools,
+		   WX_PSR_MAC_SWC_AD_H_AV);
+}
+EXPORT_SYMBOL(wx_mac_set_default_filter);
+
+void wx_flush_sw_mac_table(struct wx_hw *wxhw)
+{
+	u32 i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+		wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+		memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
+		wxhw->mac_table[i].pools = 0;
+	}
+	wx_sync_mac_table(wxhw);
+}
+EXPORT_SYMBOL(wx_flush_sw_mac_table);
+
+static int wx_del_mac_filter(struct wx_hw *wxhw, u8 *addr, u16 pool)
+{
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	/* search table for addr, if found, set to 0 and sync */
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		if (ether_addr_equal(addr, wxhw->mac_table[i].addr)) {
+			if (wxhw->mac_table[i].pools & (1ULL << pool)) {
+				wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+				wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+				wxhw->mac_table[i].pools &= ~(1ULL << pool);
+				wx_sync_mac_table(wxhw);
+			}
+			return 0;
+		}
+
+		if (wxhw->mac_table[i].pools != (1 << pool))
+			continue;
+		if (!ether_addr_equal(addr, wxhw->mac_table[i].addr))
+			continue;
+
+		wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+		wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+		memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
+		wxhw->mac_table[i].pools = 0;
+		wx_sync_mac_table(wxhw);
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+/**
+ * wx_set_mac - Change the Ethernet Address of the NIC
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
+ **/
+int wx_set_mac(struct net_device *netdev, void *p)
+{
+	struct wx_hw *wxhw = container_of(&netdev, struct wx_hw, netdev);
+	struct sockaddr *addr = p;
+	int retval;
+
+	retval = eth_prepare_mac_addr_change(netdev, addr);
+	if (retval)
+		return retval;
+
+	wx_del_mac_filter(wxhw, wxhw->mac.addr, 0);
+	eth_hw_addr_set(netdev, addr->sa_data);
+	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
+
+	wx_mac_set_default_filter(wxhw, wxhw->mac.addr);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_set_mac);
+
 void wx_disable_rx(struct wx_hw *wxhw)
 {
 	u32 pfdtxgswc;
@@ -929,6 +1034,14 @@ int wx_sw_init(struct wx_hw *wxhw)
 		return err;
 	}
 
+	wxhw->mac_table = kcalloc(wxhw->mac.num_rar_entries,
+				  sizeof(struct wx_mac_addr),
+				  GFP_KERNEL);
+	if (!wxhw->mac_table) {
+		wx_err(wxhw, "mac_table allocation failed\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(wx_sw_init);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index a0652f5e9939..5ac4ff78fd72 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -15,9 +15,10 @@ int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
 int wx_reset_hostif(struct wx_hw *wxhw);
 void wx_init_eeprom_params(struct wx_hw *wxhw);
 void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr);
-int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools, u32 enable_addr);
-int wx_clear_rar(struct wx_hw *wxhw, u32 index);
 void wx_init_rx_addrs(struct wx_hw *wxhw);
+void wx_mac_set_default_filter(struct wx_hw *wxhw, u8 *addr);
+void wx_flush_sw_mac_table(struct wx_hw *wxhw);
+int wx_set_mac(struct net_device *netdev, void *p);
 void wx_disable_rx(struct wx_hw *wxhw);
 int wx_disable_pcie_master(struct wx_hw *wxhw);
 int wx_stop_adapter(struct wx_hw *wxhw);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 1cbeef8230bf..af7fd112aee4 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -185,6 +185,10 @@
 
 #define WX_SW_REGION_PTR             0x1C
 
+#define WX_MAC_STATE_DEFAULT         0x1
+#define WX_MAC_STATE_MODIFIED        0x2
+#define WX_MAC_STATE_IN_USE          0x4
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -284,6 +288,12 @@ struct wx_addr_filter_info {
 	bool user_set_promisc;
 };
 
+struct wx_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u64 pools;
+};
+
 enum wx_reset_type {
 	WX_LAN_RESET = 0,
 	WX_SW_RESET,
@@ -293,10 +303,12 @@ enum wx_reset_type {
 struct wx_hw {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
+	struct net_device *netdev;
 	struct wx_bus_info bus;
 	struct wx_mac_info mac;
 	struct wx_eeprom_info eeprom;
 	struct wx_addr_filter_info addr_ctrl;
+	struct wx_mac_addr *mac_table;
 	u16 device_id;
 	u16 vendor_id;
 	u16 subsystem_device_id;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
deleted file mode 100644
index af147ca8605c..000000000000
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
-
-#ifndef _NGBE_H_
-#define _NGBE_H_
-
-#include "ngbe_type.h"
-
-#define NGBE_MAX_FDIR_INDICES		7
-
-#define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
-#define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
-
-#define NGBE_ETH_LENGTH_OF_ADDRESS	6
-#define NGBE_MAX_MSIX_VECTORS		0x09
-#define NGBE_RAR_ENTRIES		32
-
-/* TX/RX descriptor defines */
-#define NGBE_DEFAULT_TXD		512 /* default ring size */
-#define NGBE_DEFAULT_TX_WORK		256
-#define NGBE_MAX_TXD			8192
-#define NGBE_MIN_TXD			128
-
-#define NGBE_DEFAULT_RXD		512 /* default ring size */
-#define NGBE_DEFAULT_RX_WORK		256
-#define NGBE_MAX_RXD			8192
-#define NGBE_MIN_RXD			128
-
-#define NGBE_MAC_STATE_DEFAULT		0x1
-#define NGBE_MAC_STATE_MODIFIED		0x2
-#define NGBE_MAC_STATE_IN_USE		0x4
-
-struct ngbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
-/* board specific private data structure */
-struct ngbe_adapter {
-	u8 __iomem *io_addr;    /* Mainly for iounmap use */
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-
-	/* structs defined in ngbe_hw.h */
-	struct ngbe_hw hw;
-	struct ngbe_mac_addr *mac_table;
-	u16 msg_enable;
-
-	/* Tx fast path data */
-	int num_tx_queues;
-	u16 tx_itr_setting;
-	u16 tx_work_limit;
-
-	/* Rx fast path data */
-	int num_rx_queues;
-	u16 rx_itr_setting;
-	u16 rx_work_limit;
-
-	int num_q_vectors;      /* current number of q_vectors for device */
-	int max_q_vectors;      /* upper limit of q_vectors for device */
-
-	u32 tx_ring_count;
-	u32 rx_ring_count;
-
-#define NGBE_MAX_RETA_ENTRIES 128
-	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
-
-#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
-	u32 *rss_key;
-	u32 wol;
-
-	u16 bd_number;
-};
-
-extern char ngbe_driver_name[];
-
-#endif /* _NGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 0e3923b3737e..6e06a46fe9fa 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -9,12 +9,11 @@
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
 #include "ngbe_hw.h"
-#include "ngbe.h"
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
+int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 {
 	struct wx_hic_read_shadow_ram buffer;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int status;
 	int tmp;
 
@@ -38,14 +37,14 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
 	return -EIO;
 }
 
-static int ngbe_reset_misc(struct ngbe_hw *hw)
+static int ngbe_reset_misc(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_reset_misc(wxhw);
-	if (hw->mac_type == ngbe_mac_type_rgmii)
+	if (adapter->mac_type == ngbe_mac_type_rgmii)
 		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
-	if (hw->gpio_ctrl) {
+	if (adapter->gpio_ctrl) {
 		/* gpio0 is used to power on/off control*/
 		wr32(wxhw, NGBE_GPIO_DDR, 0x1);
 		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
@@ -55,15 +54,15 @@ static int ngbe_reset_misc(struct ngbe_hw *hw)
 
 /**
  *  ngbe_reset_hw - Perform hardware reset
- *  @hw: pointer to hardware structure
+ *  @adapter: pointer to hardware structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int ngbe_reset_hw(struct ngbe_hw *hw)
+int ngbe_reset_hw(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int status = 0;
 	u32 reset = 0;
 
@@ -73,7 +72,7 @@ int ngbe_reset_hw(struct ngbe_hw *hw)
 		return status;
 	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
 	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
-	ngbe_reset_misc(hw);
+	ngbe_reset_misc(adapter);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index 42476a3fe57c..0683aefab0d9 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -7,6 +7,6 @@
 #ifndef _NGBE_HW_H_
 #define _NGBE_HW_H_
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
-int ngbe_reset_hw(struct ngbe_hw *hw);
+int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter);
+int ngbe_reset_hw(struct ngbe_adapter *adapter);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f0b24366da18..25b1b0d251d1 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -14,7 +14,7 @@
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
 #include "ngbe_hw.h"
-#include "ngbe.h"
+
 char ngbe_driver_name[] = "ngbe";
 
 /* ngbe_pci_tbl - PCI Device ID Table
@@ -39,27 +39,14 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 	{ .device = 0 }
 };
 
-static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
-{
-	struct ngbe_hw *hw = &adapter->hw;
-
-	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
-	adapter->mac_table[0].pools = 1ULL;
-	adapter->mac_table[0].state = (NGBE_MAC_STATE_DEFAULT |
-				       NGBE_MAC_STATE_IN_USE);
-	wx_set_rar(&hw->wxhw, 0, adapter->mac_table[0].addr,
-		   adapter->mac_table[0].pools,
-		   WX_PSR_MAC_SWC_AD_H_AV);
-}
-
 /**
  *  ngbe_init_type_code - Initialize the shared code
- *  @hw: pointer to hardware structure
+ *  @adapter: pointer to hardware structure
  **/
-static void ngbe_init_type_code(struct ngbe_hw *hw)
+static void ngbe_init_type_code(struct ngbe_adapter *adapter)
 {
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int wol_mask = 0, ncsi_mask = 0;
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 type_mask = 0;
 
 	wxhw->mac.type = wx_mac_em;
@@ -70,39 +57,39 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	switch (type_mask) {
 	case NGBE_SUBID_M88E1512_SFP:
 	case NGBE_SUBID_LY_M88E1512_SFP:
-		hw->phy.type = ngbe_phy_m88e1512_sfi;
+		adapter->phy.type = ngbe_phy_m88e1512_sfi;
 		break;
 	case NGBE_SUBID_M88E1512_RJ45:
-		hw->phy.type = ngbe_phy_m88e1512;
+		adapter->phy.type = ngbe_phy_m88e1512;
 		break;
 	case NGBE_SUBID_M88E1512_MIX:
-		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		adapter->phy.type = ngbe_phy_m88e1512_unknown;
 		break;
 	case NGBE_SUBID_YT8521S_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_LY_YT8521S_SFP:
-		hw->phy.type = ngbe_phy_yt8521s_sfi;
+		adapter->phy.type = ngbe_phy_yt8521s_sfi;
 		break;
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
+		adapter->phy.type = ngbe_phy_internal_yt8521s_sfi;
 		break;
 	case NGBE_SUBID_RGMII_FPGA:
 	case NGBE_SUBID_OCP_CARD:
 		fallthrough;
 	default:
-		hw->phy.type = ngbe_phy_internal;
+		adapter->phy.type = ngbe_phy_internal;
 		break;
 	}
 
-	if (hw->phy.type == ngbe_phy_internal ||
-	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
-		hw->mac_type = ngbe_mac_type_mdi;
+	if (adapter->phy.type == ngbe_phy_internal ||
+	    adapter->phy.type == ngbe_phy_internal_yt8521s_sfi)
+		adapter->mac_type = ngbe_mac_type_mdi;
 	else
-		hw->mac_type = ngbe_mac_type_rgmii;
+		adapter->mac_type = ngbe_mac_type_rgmii;
 
-	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
-	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
+	adapter->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
+	adapter->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
 			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
 
 	switch (type_mask) {
@@ -110,10 +97,10 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	case NGBE_SUBID_LY_M88E1512_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->gpio_ctrl = 1;
+		adapter->gpio_ctrl = 1;
 		break;
 	default:
-		hw->gpio_ctrl = 0;
+		adapter->gpio_ctrl = 0;
 		break;
 	}
 }
@@ -147,14 +134,17 @@ static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
 static int ngbe_sw_init(struct ngbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct ngbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u16 msix_count = 0;
 	int err = 0;
 
 	wxhw->hw_addr = adapter->io_addr;
 	wxhw->pdev = pdev;
 
+	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
+	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+
 	/* PCI config space info */
 	err = wx_sw_init(wxhw);
 	if (err < 0) {
@@ -164,27 +154,15 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	}
 
 	/* mac type, phy type , oem type */
-	ngbe_init_type_code(hw);
+	ngbe_init_type_code(adapter);
 
-	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
-	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
-	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
 	/* Set common capability flags and settings */
 	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
-
 	err = wx_get_pcie_msix_counts(wxhw, &msix_count, NGBE_MAX_MSIX_VECTORS);
 	if (err)
 		dev_err(&pdev->dev, "Do not support MSI-X\n");
 	wxhw->mac.max_msix_vectors = msix_count;
 
-	adapter->mac_table = kcalloc(wxhw->mac.num_rar_entries,
-				     sizeof(struct ngbe_mac_addr),
-				     GFP_KERNEL);
-	if (!adapter->mac_table) {
-		dev_err(&pdev->dev, "mac_table allocation failed: %d\n", err);
-		return -ENOMEM;
-	}
-
 	if (ngbe_init_rss_key(adapter))
 		return -ENOMEM;
 
@@ -221,8 +199,7 @@ static void ngbe_down(struct ngbe_adapter *adapter)
 static int ngbe_open(struct net_device *netdev)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct ngbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_control_hw(wxhw, true);
 
@@ -245,7 +222,7 @@ static int ngbe_close(struct net_device *netdev)
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
 
 	ngbe_down(adapter);
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	return 0;
 }
@@ -256,30 +233,6 @@ static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-/**
- * ngbe_set_mac - Change the Ethernet Address of the NIC
- * @netdev: network interface device structure
- * @p: pointer to an address structure
- *
- * Returns 0 on success, negative on failure
- **/
-static int ngbe_set_mac(struct net_device *netdev, void *p)
-{
-	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
-	struct sockaddr *addr = p;
-
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
-
-	eth_hw_addr_set(netdev, addr->sa_data);
-	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
-
-	ngbe_mac_set_default_filter(adapter, wxhw->mac.addr);
-
-	return 0;
-}
-
 static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -291,7 +244,7 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	if (netif_running(netdev))
 		ngbe_down(adapter);
 	rtnl_unlock();
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	pci_disable_device(pdev);
 }
@@ -316,7 +269,7 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_stop               = ngbe_close,
 	.ndo_start_xmit         = ngbe_xmit_frame,
 	.ndo_validate_addr      = eth_validate_addr,
-	.ndo_set_mac_address    = ngbe_set_mac,
+	.ndo_set_mac_address    = wx_set_mac,
 };
 
 /**
@@ -334,7 +287,6 @@ static int ngbe_probe(struct pci_dev *pdev,
 		      const struct pci_device_id __always_unused *ent)
 {
 	struct ngbe_adapter *adapter = NULL;
-	struct ngbe_hw *hw = NULL;
 	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
 	u32 e2rom_cksum_cap = 0;
@@ -381,8 +333,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	hw = &adapter->hw;
-	wxhw = &hw->wxhw;
+	wxhw = &adapter->wxhw;
+	wxhw->netdev = netdev;
 	adapter->msg_enable = BIT(3) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -403,7 +355,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_free_mac_table;
 
-	/* check if flash load is done after hw power up */
+	/* check if flash load is done after adapter power up */
 	err = wx_check_flash_load(wxhw, NGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
 		goto err_free_mac_table;
@@ -417,7 +369,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = ngbe_reset_hw(hw);
+	err = ngbe_reset_hw(adapter);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -434,7 +386,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	wx_init_eeprom_params(wxhw);
 	if (wxhw->bus.func == 0 || e2rom_cksum_cap == 0) {
 		/* make sure the EEPROM is ready */
-		err = ngbe_eeprom_chksum_hostif(hw);
+		err = ngbe_eeprom_chksum_hostif(adapter);
 		if (err) {
 			dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
 			err = -EIO;
@@ -443,10 +395,10 @@ static int ngbe_probe(struct pci_dev *pdev,
 	}
 
 	adapter->wol = 0;
-	if (hw->wol_enabled)
+	if (adapter->wol_enabled)
 		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
 
-	hw->wol_enabled = !!(adapter->wol);
+	adapter->wol_enabled = !!(adapter->wol);
 	wr32(wxhw, NGBE_PSR_WKUP_CTL, adapter->wol);
 
 	device_set_wakeup_enable(&pdev->dev, adapter->wol);
@@ -469,7 +421,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	}
 
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
 
 	err = register_netdev(netdev);
 	if (err)
@@ -479,7 +431,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	netif_info(adapter, probe, netdev,
 		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
-		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
+		   adapter->phy.type == ngbe_phy_internal ? "Internal" : "External");
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
@@ -487,7 +439,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 err_register:
 	wx_control_hw(wxhw, false);
 err_free_mac_table:
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -509,6 +461,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 static void ngbe_remove(struct pci_dev *pdev)
 {
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct wx_hw *wxhw = &adapter->wxhw;
 	struct net_device *netdev;
 
 	netdev = adapter->netdev;
@@ -516,7 +469,7 @@ static void ngbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 39f6c03f1a54..feedd55202e0 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -90,6 +90,26 @@
 #define NGBE_FW_CMD_ST_PASS			0x80658383
 #define NGBE_FW_CMD_ST_FAIL			0x70657376
 
+#define NGBE_MAX_FDIR_INDICES			7
+
+#define NGBE_MAX_RX_QUEUES			(NGBE_MAX_FDIR_INDICES + 1)
+#define NGBE_MAX_TX_QUEUES			(NGBE_MAX_FDIR_INDICES + 1)
+
+#define NGBE_ETH_LENGTH_OF_ADDRESS		6
+#define NGBE_MAX_MSIX_VECTORS			0x09
+#define NGBE_RAR_ENTRIES			32
+
+/* TX/RX descriptor defines */
+#define NGBE_DEFAULT_TXD			512 /* default ring size */
+#define NGBE_DEFAULT_TX_WORK			256
+#define NGBE_MAX_TXD				8192
+#define NGBE_MIN_TXD				128
+
+#define NGBE_DEFAULT_RXD			512 /* default ring size */
+#define NGBE_DEFAULT_RX_WORK			256
+#define NGBE_MAX_RXD				8192
+#define NGBE_MIN_RXD				128
+
 enum ngbe_phy_type {
 	ngbe_phy_unknown = 0,
 	ngbe_phy_none,
@@ -127,7 +147,14 @@ struct ngbe_phy_info {
 
 };
 
-struct ngbe_hw {
+/* board specific private data structure */
+struct ngbe_adapter {
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+
+	/* structs defined in ngbe_hw.h */
 	struct wx_hw wxhw;
 	struct ngbe_phy_info phy;
 	enum ngbe_mac_type mac_type;
@@ -135,5 +162,35 @@ struct ngbe_hw {
 	bool wol_enabled;
 	bool ncsi_enabled;
 	bool gpio_ctrl;
+
+	u16 msg_enable;
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
+	u32 wol;
+
+	u16 bd_number;
 };
+
+extern char ngbe_driver_name[];
+
 #endif /* _NGBE_TYPE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
deleted file mode 100644
index 19e61377bd00..000000000000
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
-
-#ifndef _TXGBE_H_
-#define _TXGBE_H_
-
-#define TXGBE_MAX_FDIR_INDICES          63
-
-#define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
-#define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
-
-#define TXGBE_SP_MAX_TX_QUEUES  128
-#define TXGBE_SP_MAX_RX_QUEUES  128
-#define TXGBE_SP_RAR_ENTRIES    128
-#define TXGBE_SP_MC_TBL_SIZE    128
-
-struct txgbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
-#define TXGBE_MAC_STATE_DEFAULT         0x1
-#define TXGBE_MAC_STATE_MODIFIED        0x2
-#define TXGBE_MAC_STATE_IN_USE          0x4
-
-/* board specific private data structure */
-struct txgbe_adapter {
-	u8 __iomem *io_addr;    /* Mainly for iounmap use */
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-
-	/* structs defined in txgbe_type.h */
-	struct txgbe_hw hw;
-	u16 msg_enable;
-	struct txgbe_mac_addr *mac_table;
-	char eeprom_id[32];
-};
-
-extern char txgbe_driver_name[];
-
-#endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 167f7ff73192..02656b5971fd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -12,18 +12,16 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
-#include "txgbe.h"
 
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *
  *  Inits the thermal sensor thresholds according to the NVM map
  *  and save off the threshold and location values into mac.thermal_sensor_data
  **/
-static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
+static void txgbe_init_thermal_sensor_thresh(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	struct wx_thermal_sensor_data *data = &wxhw->mac.sensor;
 
 	memset(data, 0, sizeof(struct wx_thermal_sensor_data));
@@ -46,16 +44,15 @@ static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
 
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @pba_num: stores the part number string from the EEPROM
  *  @pba_num_size: part number string buffer length
  *
  *  Reads the part number string from the EEPROM.
  **/
-int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size)
+int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 {
 	u16 pba_ptr, offset, length, data;
-	struct wx_hw *wxhw = &hw->wxhw;
 	int ret_val;
 
 	if (!pba_num) {
@@ -155,14 +152,13 @@ int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size)
 
 /**
  *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @checksum: pointer to cheksum
  *
  *  Returns a negative error code on error
  **/
-static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
+static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 *eeprom_ptrs = NULL;
 	u32 buffer_size = 0;
 	u16 *buffer = NULL;
@@ -210,15 +206,14 @@ static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
 
 /**
  *  txgbe_validate_eeprom_checksum - Validate EEPROM checksum
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *  @checksum_val: calculated checksum
  *
  *  Performs checksum calculation and validates the EEPROM checksum.  If the
  *  caller does not need checksum_val, the value can be NULL.
  **/
-int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
+int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	u16 read_checksum = 0;
 	u16 checksum;
 	int status;
@@ -234,7 +229,7 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
 	}
 
 	checksum = 0;
-	status = txgbe_calc_eeprom_checksum(hw, &checksum);
+	status = txgbe_calc_eeprom_checksum(wxhw, &checksum);
 	if (status != 0)
 		return status;
 
@@ -258,25 +253,22 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
 	return status;
 }
 
-static void txgbe_reset_misc(struct txgbe_hw *hw)
+static void txgbe_reset_misc(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
-
 	wx_reset_misc(wxhw);
-	txgbe_init_thermal_sensor_thresh(hw);
+	txgbe_init_thermal_sensor_thresh(wxhw);
 }
 
 /**
  *  txgbe_reset_hw - Perform hardware reset
- *  @hw: pointer to hardware structure
+ *  @wxhw: pointer to hardware structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int txgbe_reset_hw(struct txgbe_hw *hw)
+int txgbe_reset_hw(struct wx_hw *wxhw)
 {
-	struct wx_hw *wxhw = &hw->wxhw;
 	int status;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
@@ -294,7 +286,7 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		return status;
 
-	txgbe_reset_misc(hw);
+	txgbe_reset_misc(wxhw);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 6a751a69177b..b4f34ab91a38 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,8 +4,8 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
-int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size);
-int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val);
-int txgbe_reset_hw(struct txgbe_hw *hw);
+int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size);
+int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val);
+int txgbe_reset_hw(struct wx_hw *wxhw);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 36780e7f05b7..e559c34b42cd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -14,7 +14,6 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
-#include "txgbe.h"
 
 char txgbe_driver_name[] = "txgbe";
 
@@ -73,95 +72,9 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
-static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
-{
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
-	int i;
-
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
-			if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE) {
-				wx_set_rar(wxhw, i,
-					   adapter->mac_table[i].addr,
-					   adapter->mac_table[i].pools,
-					   WX_PSR_MAC_SWC_AD_H_AV);
-			} else {
-				wx_clear_rar(wxhw, i);
-			}
-			adapter->mac_table[i].state &= ~(TXGBE_MAC_STATE_MODIFIED);
-		}
-	}
-}
-
-/* this function destroys the first RAR entry */
-static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
-					 u8 *addr)
-{
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
-
-	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
-	adapter->mac_table[0].pools = 1ULL;
-	adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
-				       TXGBE_MAC_STATE_IN_USE);
-	wx_set_rar(wxhw, 0, adapter->mac_table[0].addr,
-		   adapter->mac_table[0].pools,
-		   WX_PSR_MAC_SWC_AD_H_AV);
-}
-
-static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
-{
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
-	u32 i;
-
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
-		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
-		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
-		adapter->mac_table[i].pools = 0;
-	}
-	txgbe_sync_mac_table(adapter);
-}
-
-static int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
-{
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
-	u32 i;
-
-	if (is_zero_ether_addr(addr))
-		return -EINVAL;
-
-	/* search table for addr, if found, set to 0 and sync */
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		if (ether_addr_equal(addr, adapter->mac_table[i].addr)) {
-			if (adapter->mac_table[i].pools & (1ULL << pool)) {
-				adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
-				adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
-				adapter->mac_table[i].pools &= ~(1ULL << pool);
-				txgbe_sync_mac_table(adapter);
-			}
-			return 0;
-		}
-
-		if (adapter->mac_table[i].pools != (1 << pool))
-			continue;
-		if (!ether_addr_equal(addr, adapter->mac_table[i].addr))
-			continue;
-
-		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
-		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
-		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
-		adapter->mac_table[i].pools = 0;
-		txgbe_sync_mac_table(adapter);
-		return 0;
-	}
-	return -ENOMEM;
-}
-
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_control_hw(wxhw, true);
 }
@@ -169,24 +82,24 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 static void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct txgbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u8 old_addr[ETH_ALEN];
 	int err;
 
-	err = txgbe_reset_hw(hw);
+	err = txgbe_reset_hw(wxhw);
 	if (err != 0)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
 	/* do not flush user set addresses */
-	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
-	txgbe_flush_sw_mac_table(adapter);
-	txgbe_mac_set_default_filter(adapter, old_addr);
+	memcpy(old_addr, &wxhw->mac_table[0].addr, netdev->addr_len);
+	wx_flush_sw_mac_table(wxhw);
+	wx_mac_set_default_filter(wxhw, old_addr);
 }
 
 static void txgbe_disable_device(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	wx_disable_pcie_master(wxhw);
 	/* disable receives */
@@ -225,13 +138,17 @@ static void txgbe_down(struct txgbe_adapter *adapter)
 static int txgbe_sw_init(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	int err;
 
 	wxhw->hw_addr = adapter->io_addr;
 	wxhw->pdev = pdev;
 
+	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
+	wxhw->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
+	wxhw->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
+	wxhw->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+
 	/* PCI config space info */
 	err = wx_sw_init(wxhw);
 	if (err < 0) {
@@ -250,20 +167,6 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		break;
 	}
 
-	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
-	wxhw->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
-	wxhw->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
-	wxhw->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
-
-	adapter->mac_table = kcalloc(wxhw->mac.num_rar_entries,
-				     sizeof(struct txgbe_mac_addr),
-				     GFP_KERNEL);
-	if (!adapter->mac_table) {
-		netif_err(adapter, probe, adapter->netdev,
-			  "mac_table allocation failed\n");
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -313,7 +216,7 @@ static int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
-	wx_control_hw(&adapter->hw.wxhw, false);
+	wx_control_hw(&adapter->wxhw, false);
 
 	return 0;
 }
@@ -322,8 +225,7 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	struct txgbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_hw *wxhw = &adapter->wxhw;
 
 	netif_device_detach(netdev);
 
@@ -355,39 +257,12 @@ static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-/**
- * txgbe_set_mac - Change the Ethernet Address of the NIC
- * @netdev: network interface device structure
- * @p: pointer to an address structure
- *
- * Returns 0 on success, negative on failure
- **/
-static int txgbe_set_mac(struct net_device *netdev, void *p)
-{
-	struct txgbe_adapter *adapter = netdev_priv(netdev);
-	struct wx_hw *wxhw = &adapter->hw.wxhw;
-	struct sockaddr *addr = p;
-	int retval;
-
-	retval = eth_prepare_mac_addr_change(netdev, addr);
-	if (retval)
-		return retval;
-
-	txgbe_del_mac_filter(adapter, wxhw->mac.addr, 0);
-	eth_hw_addr_set(netdev, addr->sa_data);
-	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
-
-	txgbe_mac_set_default_filter(adapter, wxhw->mac.addr);
-
-	return 0;
-}
-
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
 	.ndo_start_xmit         = txgbe_xmit_frame,
 	.ndo_validate_addr      = eth_validate_addr,
-	.ndo_set_mac_address    = txgbe_set_mac,
+	.ndo_set_mac_address    = wx_set_mac,
 };
 
 /**
@@ -405,7 +280,6 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
-	struct txgbe_hw *hw = NULL;
 	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
 	int err, expected_gts;
@@ -453,8 +327,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	hw = &adapter->hw;
-	wxhw = &hw->wxhw;
+	wxhw = &adapter->wxhw;
+	wxhw->netdev = netdev;
 	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -486,7 +360,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = txgbe_reset_hw(hw);
+	err = txgbe_reset_hw(wxhw);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -495,7 +369,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	/* make sure the EEPROM is good */
-	err = txgbe_validate_eeprom_checksum(hw, NULL);
+	err = txgbe_validate_eeprom_checksum(wxhw, NULL);
 	if (err != 0) {
 		dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
 		wr32(wxhw, WX_MIS_RST, WX_MIS_RST_SW_RST);
@@ -504,7 +378,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
@@ -565,7 +439,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
 	/* First try to read PBA as a string */
-	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
+	err = txgbe_read_pba_string(wxhw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
 
@@ -576,7 +450,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 err_release_hw:
 	wx_control_hw(wxhw, false);
 err_free_mac_table:
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -606,7 +480,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->mac_table);
+	kfree(adapter->wxhw.mac_table);
 
 	pci_disable_pcie_error_reporting(pdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 740a1c447e20..083fee0954d4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -67,8 +67,28 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
-struct txgbe_hw {
+#define TXGBE_MAX_FDIR_INDICES          63
+
+#define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+#define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
+#define TXGBE_SP_RAR_ENTRIES    128
+#define TXGBE_SP_MC_TBL_SIZE    128
+
+/* board specific private data structure */
+struct txgbe_adapter {
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
 	struct wx_hw wxhw;
+	u16 msg_enable;
+
+	char eeprom_id[32];
 };
 
+extern char txgbe_driver_name[];
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

