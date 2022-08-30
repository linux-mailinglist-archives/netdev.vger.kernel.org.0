Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998085A5C6F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiH3HFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiH3HFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:35 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641A06E89E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:29 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843125tuu055p4
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:24 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: Wp4pj0u9TIfUDgGA5LV3EW8KR4zKisQLv9DRyEes/kYJ9tPWo/OE7q9EuDMPM
        sFTuHAvv3Y4o/6mlHswuSl/LFYU0BdM5u54WI4kDNFReLoummcUCB5TlZGrIcH9VhH3PxNS
        +ZPW+j2IHhn2VTSwlliIS5bGXczcgVMpiTfvphuhwDgl8xlLMPfod0W7oqKotS6WlHll9FB
        43blqIjlPjOdrooDOydd9B5ihih/CHDORU/gnkKBeK4Jxm0/s5Ax4uU9cda/35SIh96yOTY
        CHIAu/07yFMLLB1sAbcVpoLtmp8zSkUW09oEl1KngmD4guQaVG2wD+sWbpgsOiCJQJl3DRv
        yAYDJPaEqsEVqPvCkqHq0Wb7Z1HWzyj75OqgalfOlwNWxKmneqzAZDQNY/WSLqwDWCMIFpd
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 02/16] net: txgbe: Reset hardware
Date:   Tue, 30 Aug 2022 15:04:40 +0800
Message-Id: <20220830070454.146211-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
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

Reset and initialize the hardware by configuring the MAC layer.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  14 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  26 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 236 ++++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   7 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   6 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 236 ++++++++++++++++++
 6 files changed, 525 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index a271a74b7ef7..42ffe70a6e4e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -23,6 +23,20 @@ struct txgbe_adapter {
 	u16 msg_enable;
 };
 
+#define TXGBE_INTR_ALL (~0ULL)
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
+}
+
 extern char txgbe_driver_name[];
 
 __maybe_unused static struct device *txgbe_hw_to_dev(const struct txgbe_hw *hw)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 822306f5eaba..9b87bca57324 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -19,16 +19,42 @@
 #define TUP4 TUP(p4)
 
 /* struct txgbe_mac_operations */
+static int txgbe_stop_adapter_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
 static void txgbe_bus_set_lan_id_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static int txgbe_reset_hw_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
+static void txgbe_disable_rx_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_init_thermal_sensor_thresh_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 {
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.stop_adapter = txgbe_stop_adapter_dummy;
 	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;
+	mac->ops.reset_hw = txgbe_reset_hw_dummy;
+
+	/* RAR */
+	mac->ops.disable_rx = txgbe_disable_rx_dummy;
+
+	/* Manageability interface */
+	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh_dummy;
 }
 
 #endif /* _TXGBE_TYPE_DUMMY_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 6477f5305c6a..15ecba51a678 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -5,6 +5,9 @@
 #include "txgbe_hw.h"
 #include "txgbe.h"
 
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
+
 /**
  *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
  *  @hw: pointer to the HW structure
@@ -28,6 +31,89 @@ void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
 		bus->func = bus->lan_id;
 }
 
+/**
+ *  txgbe_stop_adapter - Generic stop Tx/Rx units
+ *  @hw: pointer to hardware structure
+ *
+ *  Sets the adapter_stopped flag within txgbe_hw struct. Clears interrupts,
+ *  disables transmit and receive units. The adapter_stopped flag is used by
+ *  the shared code and drivers to determine if the adapter is in a stopped
+ *  state and should not touch the hardware.
+ **/
+int txgbe_stop_adapter(struct txgbe_hw *hw)
+{
+	u16 i;
+
+	/* Set the adapter_stopped flag so other driver functions stop touching
+	 * the hardware
+	 */
+	hw->adapter_stopped = true;
+
+	/* Disable the receive unit */
+	hw->mac.ops.disable_rx(hw);
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
+ *  txgbe_disable_pcie_master - Disable PCI-express master access
+ *  @hw: pointer to hardware structure
+ *
+ *  Disables PCI-Express master access and verifies there are no pending
+ *  requests. TXGBE_ERR_MASTER_REQUESTS_PENDING is returned if master disable
+ *  bit hasn't caused the master requests to be disabled, else 0
+ *  is returned signifying master requests disabled.
+ **/
+int txgbe_disable_pcie_master(struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	int status = 0;
+	u32 val;
+
+	/* Always set this bit to ensure any future transactions are blocked */
+	pci_clear_master(adapter->pdev);
+
+	/* Exit if master requests are blocked */
+	if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)))
+		goto out;
+
+	/* Poll for master request bit to clear */
+	status = read_poll_timeout(rd32, val, !val, 100, TXGBE_PCI_MASTER_DISABLE_TIMEOUT,
+				   false, hw, TXGBE_PX_TRANSACTION_PENDING);
+	if (status == 0)
+		goto out;
+
+	txgbe_info(hw, "PCIe transaction pending bit did not clear.\n");
+out:
+	return status;
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -57,6 +143,61 @@ int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
 	return ret;
 }
 
+/**
+ *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
+ *  @hw: pointer to hardware structure
+ *
+ *  Inits the thermal sensor thresholds according to the NVM map
+ *  and save off the threshold and location values into mac.thermal_sensor_data
+ **/
+void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
+{
+	struct txgbe_thermal_sensor_data *data = &hw->mac.thermal_sensor_data;
+
+	memset(data, 0, sizeof(struct txgbe_thermal_sensor_data));
+
+	/* Only support thermal sensors attached to SP physical port 0 */
+	if (hw->bus.lan_id)
+		return;
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
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 {
 	u32 i = 0, reg = 0;
@@ -94,5 +235,100 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+	mac->ops.reset_hw = txgbe_reset_hw;
+
+	/* RAR */
+	mac->ops.disable_rx = txgbe_disable_rx;
+
+	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
+	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
+
+	/* Manageability interface */
+	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh;
+}
+
+void txgbe_reset_misc(struct txgbe_hw *hw)
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
+int txgbe_reset_hw(struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	u32 reset = 0;
+	int status;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = hw->mac.ops.stop_adapter(hw);
+	if (status != 0)
+		return status;
+
+	if (hw->bus.lan_id == 0)
+		reset = TXGBE_MIS_RST_LAN0_RST;
+	else
+		reset = TXGBE_MIS_RST_LAN1_RST;
+
+	wr32(hw, TXGBE_MIS_RST,
+	     reset | rd32(hw, TXGBE_MIS_RST));
+	TXGBE_WRITE_FLUSH(hw);
+	usleep_range(10, 100);
+
+	if (hw->bus.lan_id == 0)
+		status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST);
+	else
+		status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST);
+
+	if (status != 0)
+		return status;
+
+	txgbe_reset_misc(hw);
+	pci_set_master(adapter->pdev);
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 778d134def03..04cf65812184 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -17,9 +17,16 @@
 #define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
 
 void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
+int txgbe_stop_adapter(struct txgbe_hw *hw);
 
+int txgbe_disable_pcie_master(struct txgbe_hw *hw);
+
+void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
+void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+void txgbe_reset_misc(struct txgbe_hw *hw);
+int txgbe_reset_hw(struct txgbe_hw *hw);
 void txgbe_init_ops(struct txgbe_hw *hw);
 
 int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 6b7431e13981..817d37019e53 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -215,6 +215,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_release_regions;
 
+	err = hw->mac.ops.reset_hw(hw);
+	if (err) {
+		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
+		goto err_pci_release_regions;
+	}
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	pci_set_drvdata(pdev, adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 3b1dd104373b..bbede2eedd5d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -103,6 +103,35 @@
 #define TXGBE_MIS_PRB_CTL_LAN0_UP       0x2
 #define TXGBE_MIS_PRB_CTL_LAN1_UP       0x1
 
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
 /* FMGR Registers */
 #define TXGBE_SPI_ILDR_STATUS           0x10120
 #define TXGBE_SPI_ILDR_STATUS_PERST     0x00000001U /* PCIE_PERST is done */
@@ -169,6 +198,178 @@
 #define TXGBE_CFG_PORT_ST_LAN_ID(_r)    ((0x00000100U & (_r)) >> 8)
 #define TXGBE_LINK_UP_TIME              90
 
+/***************************** RDB registers *********************************/
+/* receive packet buffer */
+#define TXGBE_RDB_PB_WRAP           0x19004
+#define TXGBE_RDB_PB_SZ(_i)         (0x19020 + ((_i) * 4))
+#define TXGBE_RDB_PB_CTL            0x19000
+#define TXGBE_RDB_UP2TC             0x19008
+#define TXGBE_RDB_PB_SZ_SHIFT       10
+#define TXGBE_RDB_PB_SZ_MASK        0x000FFC00U
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
+/* Receive Config masks */
+#define TXGBE_RDB_PB_CTL_RXEN           (0x80000000) /* Enable Receiver */
+#define TXGBE_RDB_PB_CTL_DISABLED       0x1
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
+#define TXGBE_PSR_LAN_FLEX_SEL  0x15B8C
+#define TXGBE_PSR_LAN_FLEX_DW_L(_i)     (0x15C00 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
+#define TXGBE_PSR_LAN_FLEX_CTL  0x15CFC
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
+/* transmit DMA Registers */
+#define TXGBE_PX_TR_BAL(_i)     (0x03000 + ((_i) * 0x40))
+#define TXGBE_PX_TR_BAH(_i)     (0x03004 + ((_i) * 0x40))
+#define TXGBE_PX_TR_WP(_i)      (0x03008 + ((_i) * 0x40))
+#define TXGBE_PX_TR_RP(_i)      (0x0300C + ((_i) * 0x40))
+#define TXGBE_PX_TR_CFG(_i)     (0x03010 + ((_i) * 0x40))
+/* Transmit Config masks */
+#define TXGBE_PX_TR_CFG_ENABLE          (1) /* Ena specific Tx Queue */
+#define TXGBE_PX_TR_CFG_TR_SIZE_SHIFT   1 /* tx desc number per ring */
+#define TXGBE_PX_TR_CFG_SWFLSH          BIT(26) /* Tx Desc. wr-bk flushing */
+#define TXGBE_PX_TR_CFG_WTHRESH_SHIFT   16 /* shift to WTHRESH bits */
+#define TXGBE_PX_TR_CFG_THRE_SHIFT      8
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
+/* Number of 80 microseconds we wait for PCI Express master disable */
+#define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        80000
+
 /* Bus parameters */
 struct txgbe_bus_info {
 	u16 func;
@@ -179,11 +380,23 @@ struct txgbe_bus_info {
 struct txgbe_hw;
 
 struct txgbe_mac_operations {
+	int (*reset_hw)(struct txgbe_hw *hw);
+	int (*stop_adapter)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
+
+	/* RAR */
+	void (*disable_rx)(struct txgbe_hw *hw);
+
+	/* Manageability interface */
+	void (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 };
 
 struct txgbe_mac_info {
 	struct txgbe_mac_operations ops;
+	u32 max_tx_queues;
+	u32 max_rx_queues;
+	struct txgbe_thermal_sensor_data  thermal_sensor_data;
+	bool set_lben;
 };
 
 struct txgbe_hw {
@@ -195,6 +408,7 @@ struct txgbe_hw {
 	u16 subsystem_device_id;
 	u16 subsystem_vendor_id;
 	u8 revision_id;
+	bool adapter_stopped;
 	u16 oem_ssid;
 	u16 oem_svid;
 };
@@ -205,4 +419,26 @@ struct txgbe_hw {
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
 
+static inline u32
+rd32m(struct txgbe_hw *hw, u32 reg, u32 mask)
+{
+	u32 val;
+
+	val = rd32(hw, reg);
+	return val & mask;
+}
+
+static inline void
+wr32m(struct txgbe_hw *hw, u32 reg, u32 mask, u32 field)
+{
+	u32 val;
+
+	val = rd32(hw, reg);
+	val = ((val & ~mask) | (field & mask));
+
+	wr32(hw, reg, val);
+}
+
+#define TXGBE_WRITE_FLUSH(H) rd32(H, TXGBE_MIS_PWR)
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

