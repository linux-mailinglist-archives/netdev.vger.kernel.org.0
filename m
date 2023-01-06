Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02465FA71
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjAFDnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjAFDma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:42:30 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4FE6B5B3
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:42:18 -0800 (PST)
X-QQ-mid: bizesmtp76t1672976530t4js7hoi
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 11:42:10 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: ILHsT53NKPj1aLHcUrbIQDRIMZ+qLG+v/DnB7txQPayMeTQUGNJh2BKEHCI2E
        lecx/73RE5E4FsuqWwblzlmyRuSCB7sr5LgUMO/wAyE9I0vtfU3C8E1qrATB+usDkk4A/JJ
        FrHWKDkuMQ7PqgHhUWXdmVL+vB2VvpiZSuuo3h7vwewtFEfaGXegz7ex7q/c2CF9a3KQrHW
        b9qkLXhDZ19rg1I56JVfiJcGAFdOkqHN3NGhgtoF96PSzliG0N9DqQJdwYeA7qD4cmW779f
        Cp4Aiq+Y2OAciTsxXJE8wQSuXfVZvH4O7nrgny3ommYgziN6THsTgwDXBb2lhy556mjQaq5
        fKia2X+5xRXhZjdpAeIquH1cMAuvB/bhfH0hQn0vquDIECjurGkf9ohENXFROu5BRCwcIRJ
        8bbwK+vGXVw+0/T/Fj0OWA==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 7/8] net: txgbe: Remove structure txgbe_adapter
Date:   Fri,  6 Jan 2023 11:38:52 +0800
Message-Id: <20230106033853.2806007-8-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
References: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
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

Move the total private structure to libwx.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |   2 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  11 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   2 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 125 ++++++++----------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  12 --
 6 files changed, 64 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 148a0496e924..786e1090cf84 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -802,7 +802,7 @@ static int wx_del_mac_filter(struct wx *wx, u8 *addr, u16 pool)
  **/
 int wx_set_mac(struct net_device *netdev, void *p)
 {
-	struct wx *wx = container_of(&netdev, struct wx, netdev);
+	struct wx *wx = netdev_priv(netdev);
 	struct sockaddr *addr = p;
 	int retval;
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index f1231a6d83c6..0838d9ba4028 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -316,7 +316,9 @@ struct wx {
 	u8 revision_id;
 	u16 oem_ssid;
 	u16 oem_svid;
+	u16 msg_enable;
 	bool adapter_stopped;
+	char eeprom_id[32];
 	enum wx_reset_type reset_type;
 };
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index c74c3aaf9c64..ebc46f3be056 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -253,25 +253,22 @@ int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val)
 	return status;
 }
 
-static void txgbe_reset_misc(struct txgbe_adapter *adapter)
+static void txgbe_reset_misc(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
-
 	wx_reset_misc(wx);
 	txgbe_init_thermal_sensor_thresh(wx);
 }
 
 /**
  *  txgbe_reset_hw - Perform hardware reset
- *  @adapter: pointer to adapter structure
+ *  @wx: pointer to wx structure
  *
  *  Resets the hardware by resetting the transmit and receive units, masks
  *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
  *  reset.
  **/
-int txgbe_reset_hw(struct txgbe_adapter *adapter)
+int txgbe_reset_hw(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
 	int status;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
@@ -289,7 +286,7 @@ int txgbe_reset_hw(struct txgbe_adapter *adapter)
 	if (status != 0)
 		return status;
 
-	txgbe_reset_misc(adapter);
+	txgbe_reset_misc(wx);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wx, wx->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 775272642397..e82f65dff8a6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -6,6 +6,6 @@
 
 int txgbe_read_pba_string(struct wx *wx, u8 *pba_num, u32 pba_num_size);
 int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val);
-int txgbe_reset_hw(struct txgbe_adapter *adapter);
+int txgbe_reset_hw(struct wx *wx);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 85696bde1f43..aa4d09df3b01 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -34,26 +34,26 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
-static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
+static void txgbe_check_minimum_link(struct wx *wx)
 {
 	struct pci_dev *pdev;
 
-	pdev = adapter->pdev;
+	pdev = wx->pdev;
 	pcie_print_link_status(pdev);
 }
 
 /**
  * txgbe_enumerate_functions - Get the number of ports this device has
- * @adapter: adapter structure
+ * @wx: wx structure
  *
  * This function enumerates the phsyical functions co-located on a single slot,
  * in order to determine how many ports a device has. This is most useful in
  * determining the required GT/s of PCIe bandwidth necessary for optimal
  * performance.
  **/
-static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
+static int txgbe_enumerate_functions(struct wx *wx)
 {
-	struct pci_dev *entry, *pdev = adapter->pdev;
+	struct pci_dev *entry, *pdev = wx->pdev;
 	int physfns = 0;
 
 	list_for_each_entry(entry, &pdev->bus->devices, bus_list) {
@@ -72,23 +72,20 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
-static void txgbe_up_complete(struct txgbe_adapter *adapter)
+static void txgbe_up_complete(struct wx *wx)
 {
-	struct wx *wx = &adapter->wx;
-
 	wx_control_hw(wx, true);
 }
 
-static void txgbe_reset(struct txgbe_adapter *adapter)
+static void txgbe_reset(struct wx *wx)
 {
-	struct net_device *netdev = adapter->netdev;
-	struct wx *wx = &adapter->wx;
+	struct net_device *netdev = wx->netdev;
 	u8 old_addr[ETH_ALEN];
 	int err;
 
-	err = txgbe_reset_hw(adapter);
+	err = txgbe_reset_hw(wx);
 	if (err != 0)
-		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
+		wx_err(wx, "Hardware Error: %d\n", err);
 
 	/* do not flush user set addresses */
 	memcpy(old_addr, &wx->mac_table[0].addr, netdev->addr_len);
@@ -96,10 +93,9 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
 	wx_mac_set_default_filter(wx, old_addr);
 }
 
-static void txgbe_disable_device(struct txgbe_adapter *adapter)
+static void txgbe_disable_device(struct wx *wx)
 {
-	struct net_device *netdev = adapter->netdev;
-	struct wx *wx = &adapter->wx;
+	struct net_device *netdev = wx->netdev;
 
 	wx_disable_pcie_master(wx);
 	/* disable receives */
@@ -111,9 +107,8 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 	if (wx->bus.func < 2)
 		wr32m(wx, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wx->bus.func), 0);
 	else
-		dev_err(&adapter->pdev->dev,
-			"%s: invalid bus lan id %d\n",
-			__func__, wx->bus.func);
+		wx_err(wx, "%s: invalid bus lan id %d\n",
+		       __func__, wx->bus.func);
 
 	if (!(((wx->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
 	      ((wx->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
@@ -125,25 +120,20 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 	wr32m(wx, WX_TDM_CTL, WX_TDM_CTL_TE, 0);
 }
 
-static void txgbe_down(struct txgbe_adapter *adapter)
+static void txgbe_down(struct wx *wx)
 {
-	txgbe_disable_device(adapter);
-	txgbe_reset(adapter);
+	txgbe_disable_device(wx);
+	txgbe_reset(wx);
 }
 
 /**
- * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
- * @adapter: board private structure to initialize
+ * txgbe_sw_init - Initialize general software structures (struct wx)
+ * @wx: board private structure to initialize
  **/
-static int txgbe_sw_init(struct txgbe_adapter *adapter)
+static int txgbe_sw_init(struct wx *wx)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct wx *wx = &adapter->wx;
 	int err;
 
-	wx->hw_addr = adapter->io_addr;
-	wx->pdev = pdev;
-
 	wx->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
 	wx->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
 	wx->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
@@ -152,8 +142,7 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	/* PCI config space info */
 	err = wx_sw_init(wx);
 	if (err < 0) {
-		netif_err(adapter, probe, adapter->netdev,
-			  "read of internal subsystem device id failed\n");
+		wx_err(wx, "read of internal subsystem device id failed\n");
 		return err;
 	}
 
@@ -181,23 +170,23 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
  **/
 static int txgbe_open(struct net_device *netdev)
 {
-	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct wx *wx = netdev_priv(netdev);
 
-	txgbe_up_complete(adapter);
+	txgbe_up_complete(wx);
 
 	return 0;
 }
 
 /**
  * txgbe_close_suspend - actions necessary to both suspend and close flows
- * @adapter: the private adapter struct
+ * @wx: the private wx struct
  *
  * This function should contain the necessary work common to both suspending
  * and closing of the device.
  */
-static void txgbe_close_suspend(struct txgbe_adapter *adapter)
+static void txgbe_close_suspend(struct wx *wx)
 {
-	txgbe_disable_device(adapter);
+	txgbe_disable_device(wx);
 }
 
 /**
@@ -213,25 +202,25 @@ static void txgbe_close_suspend(struct txgbe_adapter *adapter)
  **/
 static int txgbe_close(struct net_device *netdev)
 {
-	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct wx *wx = netdev_priv(netdev);
 
-	txgbe_down(adapter);
-	wx_control_hw(&adapter->wx, false);
+	txgbe_down(wx);
+	wx_control_hw(wx, false);
 
 	return 0;
 }
 
 static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
-	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
-	struct wx *wx = &adapter->wx;
+	struct wx *wx = pci_get_drvdata(pdev);
+	struct net_device *netdev;
 
+	netdev = wx->netdev;
 	netif_device_detach(netdev);
 
 	rtnl_lock();
 	if (netif_running(netdev))
-		txgbe_close_suspend(adapter);
+		txgbe_close_suspend(wx);
 	rtnl_unlock();
 
 	wx_control_hw(wx, false);
@@ -273,16 +262,15 @@ static const struct net_device_ops txgbe_netdev_ops = {
  * Returns 0 on success, negative on failure
  *
  * txgbe_probe initializes an adapter identified by a pci_dev structure.
- * The OS initialization, configuring of the adapter private structure,
+ * The OS initialization, configuring of the wx private structure,
  * and a hardware reset occur.
  **/
 static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
-	struct txgbe_adapter *adapter = NULL;
-	struct wx *wx = NULL;
 	struct net_device *netdev;
 	int err, expected_gts;
+	struct wx *wx = NULL;
 
 	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
 	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
@@ -314,7 +302,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
-					 sizeof(struct txgbe_adapter),
+					 sizeof(struct wx),
 					 TXGBE_MAX_TX_QUEUES,
 					 TXGBE_MAX_RX_QUEUES);
 	if (!netdev) {
@@ -324,17 +312,16 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	adapter = netdev_priv(netdev);
-	adapter->netdev = netdev;
-	adapter->pdev = pdev;
-	wx = &adapter->wx;
+	wx = netdev_priv(netdev);
 	wx->netdev = netdev;
-	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
+	wx->pdev = pdev;
 
-	adapter->io_addr = devm_ioremap(&pdev->dev,
-					pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0));
-	if (!adapter->io_addr) {
+	wx->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
+
+	wx->hw_addr = devm_ioremap(&pdev->dev,
+				   pci_resource_start(pdev, 0),
+				   pci_resource_len(pdev, 0));
+	if (!wx->hw_addr) {
 		err = -EIO;
 		goto err_pci_release_regions;
 	}
@@ -342,7 +329,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->netdev_ops = &txgbe_netdev_ops;
 
 	/* setup the private structure */
-	err = txgbe_sw_init(adapter);
+	err = txgbe_sw_init(wx);
 	if (err)
 		goto err_free_mac_table;
 
@@ -360,7 +347,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	err = txgbe_reset_hw(adapter);
+	err = txgbe_reset_hw(wx);
 	if (err) {
 		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
 		goto err_free_mac_table;
@@ -406,15 +393,15 @@ static int txgbe_probe(struct pci_dev *pdev,
 			build = (eeprom_cfg_blkl << 8) | (eeprom_cfg_blkh >> 8);
 			patch = eeprom_cfg_blkh & 0x00ff;
 
-			snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+			snprintf(wx->eeprom_id, sizeof(wx->eeprom_id),
 				 "0x%08x, %d.%d.%d", etrack_id, major, build,
 				 patch);
 		} else {
-			snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+			snprintf(wx->eeprom_id, sizeof(wx->eeprom_id),
 				 "0x%08x", etrack_id);
 		}
 	} else {
-		snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id),
+		snprintf(wx->eeprom_id, sizeof(wx->eeprom_id),
 			 "0x%08x", etrack_id);
 	}
 
@@ -422,7 +409,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_release_hw;
 
-	pci_set_drvdata(pdev, adapter);
+	pci_set_drvdata(pdev, wx);
 
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
@@ -430,11 +417,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	 * parts to ensure that no warning is displayed, as this could confuse
 	 * users otherwise.
 	 */
-	expected_gts = txgbe_enumerate_functions(adapter) * 10;
+	expected_gts = txgbe_enumerate_functions(wx) * 10;
 
 	/* don't check link if we failed to enumerate functions */
 	if (expected_gts > 0)
-		txgbe_check_minimum_link(adapter);
+		txgbe_check_minimum_link(wx);
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
@@ -443,7 +430,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
 
-	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
+	netif_info(wx, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
 
@@ -471,16 +458,16 @@ static int txgbe_probe(struct pci_dev *pdev,
  **/
 static void txgbe_remove(struct pci_dev *pdev)
 {
-	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct wx *wx = pci_get_drvdata(pdev);
 	struct net_device *netdev;
 
-	netdev = adapter->netdev;
+	netdev = wx->netdev;
 	unregister_netdev(netdev);
 
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->wx.mac_table);
+	kfree(wx->mac_table);
 
 	pci_disable_pcie_error_reporting(pdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 7f7c139c6c94..cbd705a9f4bd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,18 +77,6 @@
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
 
-/* board specific private data structure */
-struct txgbe_adapter {
-	u8 __iomem *io_addr;
-	/* OS defined structs */
-	struct net_device *netdev;
-	struct pci_dev *pdev;
-	struct wx wx;
-	u16 msg_enable;
-
-	char eeprom_id[32];
-};
-
 extern char txgbe_driver_name[];
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

