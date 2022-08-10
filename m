Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05658E91C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiHJI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiHJI4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:56:35 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD2E6E2F4
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:56:31 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121783t8qo0v7x
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:23 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: ZTnzshg2nJYteNpY9j6YXWjzZyJ3U2cdjMJnWaklDcPRpkWgcr8djEQiWGO1D
        J5if58pAr7SkW0y1O7oGOitA0kgfwQW7wsr/ckMU0DNrREdRIuQlV3dkuQDAKqUdwwdYbfM
        B2QUqU44bad9oXxwVCK2Ow2UoaLs69mzkhPxsG3aDZ67X0+vAJEgLnV9PI24vO6hOY5P1bf
        sCL6lPIv/oH9pEson6HcvRDau7nDnd7YQp1BDOBcPbxaLUSMFZ0/JdGnOUMzv+X0evJ3Tae
        ogXnvos5FWnqmYqWprY5GyAeBWmWY464Vidas/nbFPXN5lhQUNqUYTN2FPGgsBsdVVSD78Y
        Nh5y1ibm/uri+0izajqQl1vQwuhx8+uYKrRuK5BSTJ6joc5II5aWf/9718RXOUPJCurM0cw
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 02/16] net: txgbe: Reset hardware
Date:   Wed, 10 Aug 2022 16:55:18 +0800
Message-Id: <20220810085532.246613-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset and initialize the hardware by configuring the MAC layer.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  66 +++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 253 ++++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   7 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   6 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 249 +++++++++++++++++
 5 files changed, 581 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 94c43eef0cd6..393f6454f023 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -4,6 +4,8 @@
 #ifndef _TXGBE_H_
 #define _TXGBE_H_
 
+#include <linux/pci.h>
+
 #include "txgbe_type.h"
 
 #define TXGBE_MAX_FDIR_INDICES          63
@@ -25,12 +27,76 @@ struct txgbe_adapter {
 
 s32 txgbe_init_shared_code(struct txgbe_hw *hw);
 
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
 
+struct txgbe_msg {
+	u16 msg_enable;
+};
+
+__maybe_unused static struct net_device *txgbe_hw_to_netdev(const struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter =
+		container_of(hw, struct txgbe_adapter, hw);
+	return adapter->netdev;
+}
+
+__maybe_unused static struct txgbe_msg *txgbe_hw_to_msg(const struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter =
+		container_of(hw, struct txgbe_adapter, hw);
+	return (struct txgbe_msg *)&adapter->msg_enable;
+}
+
 #define TXGBE_FAILED_READ_CFG_DWORD 0xffffffffU
 #define TXGBE_FAILED_READ_CFG_WORD  0xffffU
 #define TXGBE_FAILED_READ_CFG_BYTE  0xffU
 
 extern u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg);
 
+enum {
+	TXGBE_ERROR_SOFTWARE,
+	TXGBE_ERROR_POLLING,
+	TXGBE_ERROR_INVALID_STATE,
+	TXGBE_ERROR_UNSUPPORTED,
+	TXGBE_ERROR_ARGUMENT,
+	TXGBE_ERROR_CAUTION,
+};
+
+#define ERROR_REPORT(hw, level, format, arg...) do {                           \
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
index 1baf965e50d7..060f9e4ef65b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -5,6 +5,9 @@
 #include "txgbe_hw.h"
 #include "txgbe.h"
 
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
+
 /**
  *  txgbe_set_pci_config_data - Generic store PCI bus info
  *  @hw: pointer to hardware structure
@@ -95,6 +98,93 @@ s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
 	return 0;
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
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	s32 status = 0;
+	u32 i;
+
+	/* Always set this bit to ensure any future transactions are blocked */
+	pci_clear_master(adapter->pdev);
+
+	/* Exit if master requests are blocked */
+	if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)) ||
+	    TXGBE_REMOVED(hw->hw_addr))
+		goto out;
+
+	/* Poll for master request bit to clear */
+	for (i = 0; i < TXGBE_PCI_MASTER_DISABLE_TIMEOUT; i++) {
+		usleep_range(100, 120);
+		if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)))
+			goto out;
+	}
+
+	ERROR_REPORT1(hw, TXGBE_ERROR_POLLING,
+		      "PCIe transaction pending bit did not clear.\n");
+	status = TXGBE_ERR_MASTER_REQUESTS_PENDING;
+out:
+	return status;
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -131,6 +221,67 @@ u32 txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr)
 	return rd32(hw, SPI_H_DAT_REG_ADDR);
 }
 
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
+s32 txgbe_disable_rx(struct txgbe_hw *hw)
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
+
+	return 0;
+}
+
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 {
 	u32 i = 0, reg = 0;
@@ -166,8 +317,110 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	struct txgbe_mac_info *mac = &hw->mac;
 
 	/* MAC */
+	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.get_bus_info = txgbe_get_bus_info;
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
 
 	return 0;
 }
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
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	u32 reset = 0;
+	s32 status;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = TCALL(hw, mac.ops.stop_adapter);
+	if (status != 0)
+		goto reset_hw_out;
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
+		goto reset_hw_out;
+
+	status = txgbe_reset_misc(hw);
+	if (status != 0)
+		goto reset_hw_out;
+
+	pci_set_master(adapter->pdev);
+
+reset_hw_out:
+	return status;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index fb250c99ddfd..e56fe21250c3 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -19,9 +19,16 @@
 s32 txgbe_get_bus_info(struct txgbe_hw *hw);
 void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
 s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
+s32 txgbe_stop_adapter(struct txgbe_hw *hw);
 
+s32 txgbe_disable_pcie_master(struct txgbe_hw *hw);
+
+s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
+s32 txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+int txgbe_reset_misc(struct txgbe_hw *hw);
+s32 txgbe_reset_hw(struct txgbe_hw *hw);
 s32 txgbe_init_ops(struct txgbe_hw *hw);
 
 u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index d6145eca7b0a..cb950d52a51d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -262,6 +262,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_release_regions;
 
+	err = TCALL(hw, mac.ops.reset_hw);
+	if (err) {
+		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
+		goto err_pci_release_regions;
+	}
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	/* pick up the PCI bus settings for reporting later */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index b769af5e6cbb..ae3407a30d9e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -101,6 +101,35 @@
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
@@ -173,6 +202,176 @@
 #define TXGBE_CFG_LED_CTL_LINK_10G_SEL  0x00000002U
 #define TXGBE_CFG_LED_CTL_LINK_UP_SEL   0x00000001U
 #define TXGBE_CFG_LED_CTL_LINK_OD_SHIFT 16
+
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
 /******************************** PCI Bus Info *******************************/
 #define TXGBE_PCI_DEVICE_STATUS         0xAA
 #define TXGBE_PCI_DEVICE_STATUS_TRANSACTION_PENDING     0x0020
@@ -208,6 +407,9 @@
 #define TXGBE_PCIDEVCTRL2_4_8s          0xd
 #define TXGBE_PCIDEVCTRL2_17_34s        0xe
 
+/* Number of 100 microseconds we wait for PCI Express master disable */
+#define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        800
+
 /* PCI bus types */
 enum txgbe_bus_type {
 	txgbe_bus_type_unknown = 0,
@@ -258,13 +460,24 @@ struct txgbe_bus_info {
 struct txgbe_hw;
 
 struct txgbe_mac_operations {
+	s32 (*reset_hw)(struct txgbe_hw *hw);
+	s32 (*stop_adapter)(struct txgbe_hw *hw);
 	s32 (*get_bus_info)(struct txgbe_hw *hw);
 	s32 (*set_lan_id)(struct txgbe_hw *hw);
 
+	/* RAR */
+	s32 (*disable_rx)(struct txgbe_hw *hw);
+
+	/* Manageability interface */
+	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 };
 
 struct txgbe_mac_info {
 	struct txgbe_mac_operations ops;
+	u32 max_tx_queues;
+	u32 max_rx_queues;
+	struct txgbe_thermal_sensor_data  thermal_sensor_data;
+	bool set_lben;
 };
 
 struct txgbe_hw {
@@ -276,6 +489,7 @@ struct txgbe_hw {
 	u16 subsystem_device_id;
 	u16 subsystem_vendor_id;
 	u8 revision_id;
+	bool adapter_stopped;
 	u16 oem_ssid;
 	u16 oem_svid;
 };
@@ -370,6 +584,22 @@ rd32(struct txgbe_hw *hw, u32 reg)
 	return val;
 }
 
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
 /* write register */
 static inline void
 txgbe_wr32(u8 __iomem *base, u32 val)
@@ -388,4 +618,23 @@ wr32(struct txgbe_hw *hw, u32 reg, u32 val)
 	txgbe_wr32(base + reg, val);
 }
 
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

