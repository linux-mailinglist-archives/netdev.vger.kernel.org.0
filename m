Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AD765FA74
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjAFDnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjAFDmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:42:35 -0500
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7966B5BF
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:42:21 -0800 (PST)
X-QQ-mid: bizesmtp76t1672976533tvfn11jo
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 11:42:13 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: j84kgieUNVTUUIsw2etIhA6Z0jrdjDIjd6WgcYVildh5DlWyR/Yixd8UHA6w6
        dZn1VQTxwONRCJXRvkosqX1SVl8fCpuc5YGGLwvvfcSlkuO5/bIH4+zvHlqWwCT0eckWW/z
        aTacXZwgzurpl337PIw+rzstVzA8gLnHzMb7E5hmwMAkWM46yReHS3+0h6iJx0Znd2ZsF8l
        UC/8+Lmosc9rpJpoZ2PBfMrp2rcrPX8KWkok5BeoGTToIAZbIoIg4QEq8zo1tZJ1eJz2Uxi
        9ZBKAgnpQ/eWqL9OX932vKCSP4m8vm5HZzeMaTY1oQpCoxhJAguwXu1jBENLJI1Nr/WuY+E
        QHLEMG3dm1G3RBat/zCHbJOU8NNPkkOulSg2+g0J6LDXPQH/W9cC7B3O+so/axj4Hov33VT
        Ef6oIjiop9gRXElrisrg3w==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: [PATCH net-next v3 8/8] net: ngbe: Remove structure ngbe_adapter
Date:   Fri,  6 Jan 2023 11:38:53 +0800
Message-Id: <20230106033853.2806007-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
References: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
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

From: Mengyuan Lou <mengyuanlou@net-swift.com>

Move the total private structure to libwx.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  38 ++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  20 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 183 +++++++-----------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  80 --------
 5 files changed, 120 insertions(+), 205 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 0838d9ba4028..a52908d01c9c 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -189,6 +189,8 @@
 #define WX_MAC_STATE_MODIFIED        0x2
 #define WX_MAC_STATE_IN_USE          0x4
 
+#define WX_CFG_PORT_ST               0x14404
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -253,6 +255,12 @@ enum wx_mac_type {
 	wx_mac_em
 };
 
+enum em_mac_type {
+	em_mac_type_unknown = 0,
+	em_mac_type_mdi,
+	em_mac_type_rgmii
+};
+
 struct wx_mac_info {
 	enum wx_mac_type type;
 	bool set_lben;
@@ -306,6 +314,7 @@ struct wx {
 	struct net_device *netdev;
 	struct wx_bus_info bus;
 	struct wx_mac_info mac;
+	enum em_mac_type mac_type;
 	struct wx_eeprom_info eeprom;
 	struct wx_addr_filter_info addr_ctrl;
 	struct wx_mac_addr *mac_table;
@@ -320,6 +329,35 @@ struct wx {
 	bool adapter_stopped;
 	char eeprom_id[32];
 	enum wx_reset_type reset_type;
+
+	bool wol_enabled;
+	bool ncsi_enabled;
+	bool gpio_ctrl;
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
+#define WX_MAX_RETA_ENTRIES 128
+	u8 rss_indir_tbl[WX_MAX_RETA_ENTRIES];
+
+#define WX_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
+	u32 *rss_key;
+	u32 wol;
+
+	u16 bd_number;
 };
 
 #define WX_INTR_ALL (~0ULL)
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index a0c978767e72..588de24b5e18 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -10,10 +10,9 @@
 #include "ngbe_type.h"
 #include "ngbe_hw.h"
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
+int ngbe_eeprom_chksum_hostif(struct wx *wx)
 {
 	struct wx_hic_read_shadow_ram buffer;
-	struct wx *wx = &adapter->wx;
 	int status;
 	int tmp;
 
@@ -37,14 +36,12 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 	return -EIO;
 }
 
-static int ngbe_reset_misc(struct ngbe_adapter *adapter)
+static int ngbe_reset_misc(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
-
 	wx_reset_misc(wx);
-	if (adapter->mac_type == ngbe_mac_type_rgmii)
+	if (wx->mac_type == em_mac_type_rgmii)
 		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0xF);
-	if (adapter->gpio_ctrl) {
+	if (wx->gpio_ctrl) {
 		/* gpio0 is used to power on/off control*/
 		wr32(wx, NGBE_GPIO_DDR, 0x1);
 		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
@@ -54,25 +51,24 @@ static int ngbe_reset_misc(struct ngbe_adapter *adapter)
 
 /**
  *  ngbe_reset_hw - Perform hardware reset
- *  @adapter: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int ngbe_reset_hw(struct ngbe_adapter *adapter)
+int ngbe_reset_hw(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
 	int status = 0;
 	u32 reset = 0;
 
-	/* Call adapter stop to disable tx/rx and clear interrupts */
+	/* Call wx stop to disable tx/rx and clear interrupts */
 	status = wx_stop_adapter(wx);
 	if (status != 0)
 		return status;
 	reset = WX_MIS_RST_LAN_RST(wx->bus.func);
 	wr32(wx, WX_MIS_RST, reset | rd32(wx, WX_MIS_RST));
-	ngbe_reset_misc(adapter);
+	ngbe_reset_misc(wx);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wx, wx->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index 0683aefab0d9..8d14d51c0a90 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -7,6 +7,6 @@
 #ifndef _NGBE_HW_H_
 #define _NGBE_HW_H_
 
-int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter);
-int ngbe_reset_hw(struct ngbe_adapter *adapter);
+int ngbe_eeprom_chksum_hostif(struct wx *wx);
+int ngbe_reset_hw(struct wx *wx);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 1b8cff7dccee..f66513ddf6d9 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -41,55 +41,25 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 
 /**
  *  ngbe_init_type_code - Initialize the shared code
- *  @adapter: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  **/
-static void ngbe_init_type_code(struct ngbe_adapter *adapter)
+static void ngbe_init_type_code(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
 	int wol_mask = 0, ncsi_mask = 0;
-	u16 type_mask = 0;
+	u16 type_mask = 0, val;
 
 	wx->mac.type = wx_mac_em;
 	type_mask = (u16)(wx->subsystem_device_id & NGBE_OEM_MASK);
 	ncsi_mask = wx->subsystem_device_id & NGBE_NCSI_MASK;
 	wol_mask = wx->subsystem_device_id & NGBE_WOL_MASK;
 
-	switch (type_mask) {
-	case NGBE_SUBID_M88E1512_SFP:
-	case NGBE_SUBID_LY_M88E1512_SFP:
-		adapter->phy.type = ngbe_phy_m88e1512_sfi;
-		break;
-	case NGBE_SUBID_M88E1512_RJ45:
-		adapter->phy.type = ngbe_phy_m88e1512;
-		break;
-	case NGBE_SUBID_M88E1512_MIX:
-		adapter->phy.type = ngbe_phy_m88e1512_unknown;
-		break;
-	case NGBE_SUBID_YT8521S_SFP:
-	case NGBE_SUBID_YT8521S_SFP_GPIO:
-	case NGBE_SUBID_LY_YT8521S_SFP:
-		adapter->phy.type = ngbe_phy_yt8521s_sfi;
-		break;
-	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
-	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		adapter->phy.type = ngbe_phy_internal_yt8521s_sfi;
-		break;
-	case NGBE_SUBID_RGMII_FPGA:
-	case NGBE_SUBID_OCP_CARD:
-		fallthrough;
-	default:
-		adapter->phy.type = ngbe_phy_internal;
-		break;
-	}
-
-	if (adapter->phy.type == ngbe_phy_internal ||
-	    adapter->phy.type == ngbe_phy_internal_yt8521s_sfi)
-		adapter->mac_type = ngbe_mac_type_mdi;
-	else
-		adapter->mac_type = ngbe_mac_type_rgmii;
+	val = rd32(wx, WX_CFG_PORT_ST);
+	wx->mac_type = (val & BIT(7)) >> 7 ?
+		       em_mac_type_rgmii :
+		       em_mac_type_mdi;
 
-	adapter->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
-	adapter->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
+	wx->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
+	wx->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
 			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
 
 	switch (type_mask) {
@@ -97,31 +67,31 @@ static void ngbe_init_type_code(struct ngbe_adapter *adapter)
 	case NGBE_SUBID_LY_M88E1512_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		adapter->gpio_ctrl = 1;
+		wx->gpio_ctrl = 1;
 		break;
 	default:
-		adapter->gpio_ctrl = 0;
+		wx->gpio_ctrl = 0;
 		break;
 	}
 }
 
 /**
- * ngbe_init_rss_key - Initialize adapter RSS key
- * @adapter: device handle
+ * ngbe_init_rss_key - Initialize wx RSS key
+ * @wx: device handle
  *
  * Allocates and initializes the RSS key if it is not allocated.
  **/
-static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
+static inline int ngbe_init_rss_key(struct wx *wx)
 {
 	u32 *rss_key;
 
-	if (!adapter->rss_key) {
-		rss_key = kzalloc(NGBE_RSS_KEY_SIZE, GFP_KERNEL);
+	if (!wx->rss_key) {
+		rss_key = kzalloc(WX_RSS_KEY_SIZE, GFP_KERNEL);
 		if (unlikely(!rss_key))
 			return -ENOMEM;
 
-		netdev_rss_key_fill(rss_key, NGBE_RSS_KEY_SIZE);
-		adapter->rss_key = rss_key;
+		netdev_rss_key_fill(rss_key, WX_RSS_KEY_SIZE);
+		wx->rss_key = rss_key;
 	}
 
 	return 0;
@@ -129,18 +99,14 @@ static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
 
 /**
  * ngbe_sw_init - Initialize general software structures
- * @adapter: board private structure to initialize
+ * @wx: board private structure to initialize
  **/
-static int ngbe_sw_init(struct ngbe_adapter *adapter)
+static int ngbe_sw_init(struct wx *wx)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct wx *wx = &adapter->wx;
+	struct pci_dev *pdev = wx->pdev;
 	u16 msix_count = 0;
 	int err = 0;
 
-	wx->hw_addr = adapter->io_addr;
-	wx->pdev = pdev;
-
 	wx->mac.num_rar_entries = NGBE_RAR_ENTRIES;
 	wx->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
 	wx->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
@@ -148,43 +114,42 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	/* PCI config space info */
 	err = wx_sw_init(wx);
 	if (err < 0) {
-		netif_err(adapter, probe, adapter->netdev,
-			  "Read of internal subsystem device id failed\n");
+		wx_err(wx, "read of internal subsystem device id failed\n");
 		return err;
 	}
 
 	/* mac type, phy type , oem type */
-	ngbe_init_type_code(adapter);
+	ngbe_init_type_code(wx);
 
 	/* Set common capability flags and settings */
-	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
+	wx->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
 	err = wx_get_pcie_msix_counts(wx, &msix_count, NGBE_MAX_MSIX_VECTORS);
 	if (err)
 		dev_err(&pdev->dev, "Do not support MSI-X\n");
 	wx->mac.max_msix_vectors = msix_count;
 
-	if (ngbe_init_rss_key(adapter))
+	if (ngbe_init_rss_key(wx))
 		return -ENOMEM;
 
 	/* enable itr by default in dynamic mode */
-	adapter->rx_itr_setting = 1;
-	adapter->tx_itr_setting = 1;
+	wx->rx_itr_setting = 1;
+	wx->tx_itr_setting = 1;
 
 	/* set default ring sizes */
-	adapter->tx_ring_count = NGBE_DEFAULT_TXD;
-	adapter->rx_ring_count = NGBE_DEFAULT_RXD;
+	wx->tx_ring_count = NGBE_DEFAULT_TXD;
+	wx->rx_ring_count = NGBE_DEFAULT_RXD;
 
 	/* set default work limits */
-	adapter->tx_work_limit = NGBE_DEFAULT_TX_WORK;
-	adapter->rx_work_limit = NGBE_DEFAULT_RX_WORK;
+	wx->tx_work_limit = NGBE_DEFAULT_TX_WORK;
+	wx->rx_work_limit = NGBE_DEFAULT_RX_WORK;
 
 	return 0;
 }
 
-static void ngbe_down(struct ngbe_adapter *adapter)
+static void ngbe_down(struct wx *wx)
 {
-	netif_carrier_off(adapter->netdev);
-	netif_tx_disable(adapter->netdev);
+	netif_carrier_off(wx->netdev);
+	netif_tx_disable(wx->netdev);
 };
 
 /**
@@ -198,8 +163,7 @@ static void ngbe_down(struct ngbe_adapter *adapter)
  **/
 static int ngbe_open(struct net_device *netdev)
 {
-	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct wx *wx = &adapter->wx;
+	struct wx *wx = netdev_priv(netdev);
 
 	wx_control_hw(wx, true);
 
@@ -219,10 +183,10 @@ static int ngbe_open(struct net_device *netdev)
  **/
 static int ngbe_close(struct net_device *netdev)
 {
-	struct ngbe_adapter *adapter = netdev_priv(netdev);
+	struct wx *wx = netdev_priv(netdev);
 
-	ngbe_down(adapter);
-	wx_control_hw(&adapter->wx, false);
+	ngbe_down(wx);
+	wx_control_hw(wx, false);
 
 	return 0;
 }
@@ -235,26 +199,27 @@ static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
 
 static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
-	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
+	struct wx *wx = pci_get_drvdata(pdev);
+	struct net_device *netdev;
 
+	netdev = wx->netdev;
 	netif_device_detach(netdev);
 
 	rtnl_lock();
 	if (netif_running(netdev))
-		ngbe_down(adapter);
+		ngbe_down(wx);
 	rtnl_unlock();
-	wx_control_hw(&adapter->wx, false);
+	wx_control_hw(wx, false);
 
 	pci_disable_device(pdev);
 }
 
 static void ngbe_shutdown(struct pci_dev *pdev)
 {
-	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct wx *wx = pci_get_drvdata(pdev);
 	bool wake;
 
-	wake = !!adapter->wol;
+	wake = !!wx->wol;
 
 	ngbe_dev_shutdown(pdev, &wake);
 
@@ -279,17 +244,16 @@ static const struct net_device_ops ngbe_netdev_ops = {
  *
  * Returns 0 on success, negative on failure
  *
- * ngbe_probe initializes an adapter identified by a pci_dev structure.
- * The OS initialization, configuring of the adapter private structure,
+ * ngbe_probe initializes an wx identified by a pci_dev structure.
+ * The OS initialization, configuring of the wx private structure,
  * and a hardware reset occur.
  **/
 static int ngbe_probe(struct pci_dev *pdev,
 		      const struct pci_device_id __always_unused *ent)
 {
-	struct ngbe_adapter *adapter = NULL;
-	struct wx *wx = NULL;
 	struct net_device *netdev;
 	u32 e2rom_cksum_cap = 0;
+	struct wx *wx = NULL;
 	static int func_nums;
 	u16 e2rom_ver = 0;
 	u32 etrack_id = 0;
@@ -320,7 +284,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
-					 sizeof(struct ngbe_adapter),
+					 sizeof(struct wx),
 					 NGBE_MAX_TX_QUEUES,
 					 NGBE_MAX_RX_QUEUES);
 	if (!netdev) {
@@ -330,17 +294,15 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	adapter = netdev_priv(netdev);
-	adapter->netdev = netdev;
-	adapter->pdev = pdev;
-	wx = &adapter->wx;
+	wx = netdev_priv(netdev);
 	wx->netdev = netdev;
-	adapter->msg_enable = BIT(3) - 1;
+	wx->pdev = pdev;
+	wx->msg_enable = BIT(3) - 1;
 
-	adapter->io_addr = devm_ioremap(&pdev->dev,
-					pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0));
-	if (!adapter->io_addr) {
+	wx->hw_addr = devm_ioremap(&pdev->dev,
+				   pci_resource_start(pdev, 0),
+				   pci_resource_len(pdev, 0));
+	if (!wx->hw_addr) {
 		err = -EIO;
 		goto err_pci_release_regions;
 	}
@@ -349,9 +311,9 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	adapter->bd_number = func_nums;
+	wx->bd_number = func_nums;
 	/* setup the private structure */
-	err = ngbe_sw_init(adapter);
+	err = ngbe_sw_init(wx);
 	if (err)
 		goto err_free_mac_table;
 
@@ -369,7 +331,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = ngbe_reset_hw(adapter);
+	err = ngbe_reset_hw(wx);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -386,7 +348,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	wx_init_eeprom_params(wx);
 	if (wx->bus.func == 0 || e2rom_cksum_cap == 0) {
 		/* make sure the EEPROM is ready */
-		err = ngbe_eeprom_chksum_hostif(adapter);
+		err = ngbe_eeprom_chksum_hostif(wx);
 		if (err) {
 			dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
 			err = -EIO;
@@ -394,14 +356,14 @@ static int ngbe_probe(struct pci_dev *pdev,
 		}
 	}
 
-	adapter->wol = 0;
-	if (adapter->wol_enabled)
-		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
+	wx->wol = 0;
+	if (wx->wol_enabled)
+		wx->wol = NGBE_PSR_WKUP_CTL_MAG;
 
-	adapter->wol_enabled = !!(adapter->wol);
-	wr32(wx, NGBE_PSR_WKUP_CTL, adapter->wol);
+	wx->wol_enabled = !!(wx->wol);
+	wr32(wx, NGBE_PSR_WKUP_CTL, wx->wol);
 
-	device_set_wakeup_enable(&pdev->dev, adapter->wol);
+	device_set_wakeup_enable(&pdev->dev, wx->wol);
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
@@ -427,12 +389,12 @@ static int ngbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_register;
 
-	pci_set_drvdata(pdev, adapter);
+	pci_set_drvdata(pdev, wx);
 
-	netif_info(adapter, probe, netdev,
+	netif_info(wx, probe, netdev,
 		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
-		   adapter->phy.type == ngbe_phy_internal ? "Internal" : "External");
-	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
+		   wx->mac_type == em_mac_type_mdi ? "Internal" : "External");
+	netif_info(wx, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
 
@@ -460,11 +422,10 @@ static int ngbe_probe(struct pci_dev *pdev,
  **/
 static void ngbe_remove(struct pci_dev *pdev)
 {
-	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
-	struct wx *wx = &adapter->wx;
+	struct wx *wx = pci_get_drvdata(pdev);
 	struct net_device *netdev;
 
-	netdev = adapter->netdev;
+	netdev = wx->netdev;
 	unregister_netdev(netdev);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index a8042524dfa1..369d181930bc 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -110,86 +110,6 @@
 #define NGBE_MAX_RXD				8192
 #define NGBE_MIN_RXD				128
 
-enum ngbe_phy_type {
-	ngbe_phy_unknown = 0,
-	ngbe_phy_none,
-	ngbe_phy_internal,
-	ngbe_phy_m88e1512,
-	ngbe_phy_m88e1512_sfi,
-	ngbe_phy_m88e1512_unknown,
-	ngbe_phy_yt8521s,
-	ngbe_phy_yt8521s_sfi,
-	ngbe_phy_internal_yt8521s_sfi,
-	ngbe_phy_generic
-};
-
-enum ngbe_media_type {
-	ngbe_media_type_unknown = 0,
-	ngbe_media_type_fiber,
-	ngbe_media_type_copper,
-	ngbe_media_type_backplane,
-};
-
-enum ngbe_mac_type {
-	ngbe_mac_type_unknown = 0,
-	ngbe_mac_type_mdi,
-	ngbe_mac_type_rgmii
-};
-
-struct ngbe_phy_info {
-	enum ngbe_phy_type type;
-	enum ngbe_media_type media_type;
-
-	u32 addr;
-	u32 id;
-
-	bool reset_if_overtemp;
-
-};
-
-/* board specific private data structure */
-struct ngbe_adapter {
-	u8 __iomem *io_addr;    /* Mainly for iounmap use */
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-
-	struct wx wx;
-	struct ngbe_phy_info phy;
-	enum ngbe_mac_type mac_type;
-
-	bool wol_enabled;
-	bool ncsi_enabled;
-	bool gpio_ctrl;
-
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
 extern char ngbe_driver_name[];
 
 #endif /* _NGBE_TYPE_H_ */
-- 
2.27.0

