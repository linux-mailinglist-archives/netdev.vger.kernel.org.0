Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4E65F976
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 03:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjAFCPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 21:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjAFCPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 21:15:13 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE43625DC
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:15:00 -0800 (PST)
X-QQ-mid: bizesmtp69t1672971294trchbgng
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 10:14:53 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000000A0000000
X-QQ-FEAT: 7QbCsSX/jDaw3MgGo64bkegm3saETx4qYLHVfzlk9V0+QvyW8nIX9kuEB6m8P
        btzTGeGMkmvPcKuyRUflpCMtnxRy/B6wvZNNo34w6qtUXJdN6i3U6LUnwlgh0i0p6/lMp96
        TN2FF8j7JLm8HnytN6JGN1M5T7ToNPB9eEFFaBD/VXBNN9T3g+ZseR2zARM2VVkrvFZDr9p
        m5pIsOII4Ma8Bq7gI94P0OlD2/F3RKNCGfF0vh0WLnvc3Z1JN4AoZyu+Wk9hEk37Nh83CU1
        U0d9Rxy1oujkicnmlfsoht+zG3v/4/mAO37NoXo7QqIykoIQ9qGeV1RLO+r+9IkWkDqTir0
        2aNVxMTuE0DvNp+l/zUH3sfYFLvJL4P9bOoikxEwWZr2k81ZLKIP0OlcRZdCLvqr7gc8oce
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 4/7] net: wangxun: Move MAC address handling to libwx
Date:   Fri,  6 Jan 2023 10:11:42 +0800
Message-Id: <20230106021145.2803126-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
References: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For setting MAC address, both txgbe and ngbe drivers have the same handling
flow with different parameters. Move the same codes to libwx.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 116 +++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   5 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  12 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  61 ++------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  11 --
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 146 ++----------------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  12 +-
 7 files changed, 151 insertions(+), 212 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index c57dc3238b3f..e04a394ddbe2 100644
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
@@ -722,6 +721,105 @@ void wx_init_rx_addrs(struct wx_hw *wxhw)
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
+		if (!(wxhw->mac_table[i].state & WX_MAC_STATE_IN_USE))
+			continue;
+
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
+		if (!ether_addr_equal(addr, wxhw->mac_table[i].addr))
+			continue;
+
+		wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+		wxhw->mac_table[i].pools &= ~(1ULL << pool);
+		if (!wxhw->mac_table[i].pools) {
+			wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+			memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
+		}
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
@@ -929,6 +1027,14 @@ int wx_sw_init(struct wx_hw *wxhw)
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
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f7cb482c8053..2af076489b5e 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -39,17 +39,6 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 	{ .device = 0 }
 };
 
-static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
-{
-	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
-	adapter->mac_table[0].pools = 1ULL;
-	adapter->mac_table[0].state = (NGBE_MAC_STATE_DEFAULT |
-				       NGBE_MAC_STATE_IN_USE);
-	wx_set_rar(&adapter->wxhw, 0, adapter->mac_table[0].addr,
-		   adapter->mac_table[0].pools,
-		   WX_PSR_MAC_SWC_AD_H_AV);
-}
-
 /**
  *  ngbe_init_type_code - Initialize the shared code
  *  @adapter: pointer to hardware structure
@@ -152,6 +141,10 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	wxhw->hw_addr = adapter->io_addr;
 	wxhw->pdev = pdev;
 
+	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
+	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+
 	/* PCI config space info */
 	err = wx_sw_init(wxhw);
 	if (err < 0) {
@@ -163,25 +156,13 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	/* mac type, phy type , oem type */
 	ngbe_init_type_code(adapter);
 
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
 
@@ -252,30 +233,6 @@ static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
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
-	struct wx_hw *wxhw = &adapter->wxhw;
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
@@ -312,7 +269,7 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_stop               = ngbe_close,
 	.ndo_start_xmit         = ngbe_xmit_frame,
 	.ndo_validate_addr      = eth_validate_addr,
-	.ndo_set_mac_address    = ngbe_set_mac,
+	.ndo_set_mac_address    = wx_set_mac,
 };
 
 /**
@@ -377,6 +334,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	wxhw = &adapter->wxhw;
+	wxhw->netdev = netdev;
 	adapter->msg_enable = BIT(3) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -463,7 +421,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	}
 
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
 
 	err = register_netdev(netdev);
 	if (err)
@@ -481,7 +439,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 err_register:
 	wx_control_hw(wxhw, false);
 err_free_mac_table:
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -503,6 +461,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 static void ngbe_remove(struct pci_dev *pdev)
 {
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct wx_hw *wxhw = &adapter->wxhw;
 	struct net_device *netdev;
 
 	netdev = adapter->netdev;
@@ -510,7 +469,7 @@ static void ngbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 83e73cac2953..4b6c5006c0c6 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -110,10 +110,6 @@
 #define NGBE_MAX_RXD				8192
 #define NGBE_MIN_RXD				128
 
-#define NGBE_MAC_STATE_DEFAULT		0x1
-#define NGBE_MAC_STATE_MODIFIED		0x2
-#define NGBE_MAC_STATE_IN_USE		0x4
-
 enum ngbe_phy_type {
 	ngbe_phy_unknown = 0,
 	ngbe_phy_none,
@@ -151,12 +147,6 @@ struct ngbe_phy_info {
 
 };
 
-struct ngbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
 /* board specific private data structure */
 struct ngbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -172,7 +162,6 @@ struct ngbe_adapter {
 	bool ncsi_enabled;
 	bool gpio_ctrl;
 
-	struct ngbe_mac_addr *mac_table;
 	u16 msg_enable;
 
 	/* Tx fast path data */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 96657430fe67..55ddb91e1886 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -72,90 +72,6 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
-static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
-{
-	struct wx_hw *wxhw = &adapter->wxhw;
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
-	struct wx_hw *wxhw = &adapter->wxhw;
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
-	struct wx_hw *wxhw = &adapter->wxhw;
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
-	struct wx_hw *wxhw = &adapter->wxhw;
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
 	struct wx_hw *wxhw = &adapter->wxhw;
@@ -166,6 +82,7 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 static void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
+	struct wx_hw *wxhw = &adapter->wxhw;
 	u8 old_addr[ETH_ALEN];
 	int err;
 
@@ -174,9 +91,9 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
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
@@ -227,6 +144,11 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
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
@@ -245,20 +167,6 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
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
 
@@ -349,39 +257,12 @@ static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
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
-	struct wx_hw *wxhw = &adapter->wxhw;
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
@@ -447,6 +328,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	wxhw = &adapter->wxhw;
+	wxhw->netdev = netdev;
 	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -496,7 +378,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
@@ -568,7 +450,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 err_release_hw:
 	wx_control_hw(wxhw, false);
 err_free_mac_table:
-	kfree(adapter->mac_table);
+	kfree(wxhw->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -598,7 +480,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->mac_table);
+	kfree(adapter->wxhw.mac_table);
 
 	pci_disable_pcie_error_reporting(pdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index c4d22ceeddad..ec8238ef234d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,16 +77,6 @@
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
 
-#define TXGBE_MAC_STATE_DEFAULT		0x1
-#define TXGBE_MAC_STATE_MODIFIED	0x2
-#define TXGBE_MAC_STATE_IN_USE		0x4
-
-struct txgbe_mac_addr {
-	u8 addr[ETH_ALEN];
-	u16 state; /* bitmask */
-	u64 pools;
-};
-
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;
@@ -95,7 +85,7 @@ struct txgbe_adapter {
 	struct pci_dev *pdev;
 	struct wx_hw wxhw;
 	u16 msg_enable;
-	struct txgbe_mac_addr *mac_table;
+
 	char eeprom_id[32];
 };
 
-- 
2.27.0

