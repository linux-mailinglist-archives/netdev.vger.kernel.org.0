Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4658E92C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiHJI6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiHJI54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:56 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 01:57:50 PDT
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6475E6E2F5
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:57:49 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121799t1rgob2z
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:39 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: SGbEDZt3ZyYegWF5mSW2+RYIzuDjbnirBOdcNCXmriNJkMfHbsYVFxe98NpfR
        xEvgyxdQvp/3LQZJJgTQ308IjNGdTkUOXEx8A6efCmDtPNuy9St3q52A6UdtsBeC6BX11GO
        hT/rqmfS6pLYa9EIhAPSmxMIqG2j9voGJbs/f+S2i7t2WBJcSJ8wRENUz7xmXEnhSJiBmwi
        HZfzt6QC5T24r5bbb383vb+fxMts0YRLvV71C+bEI9iZPYusUYi1e2sydAb2OAazWRBwTKn
        8n28MwXLpQMKU9fZyx6f0jUoR1IL6TCBzqNsz08jI4QYqRpZJPyI0X0/D5CsweAE/dwYWqc
        t7L5CXTdNXumOd8/zqL96up6oj2QjuK28ZOspu+fcfMptI4S9ccx8xysWm0PO5QLJ6bB6g+
        8qcG9/yB8WQ=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 09/16] net: txgbe: Handle various event interrupts
Date:   Wed, 10 Aug 2022 16:55:25 +0800
Message-Id: <20220810085532.246613-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support to handle event interrupts like link down, device reset, etc.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  10 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  78 +++--
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 285 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  22 ++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   2 +
 6 files changed, 378 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index a4ebc58a984b..ac4a3ec16309 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -50,6 +50,7 @@ struct txgbe_q_vector {
 	u16 itr;        /* Interrupt throttle rate written to EITR */
 	struct txgbe_ring_container rx, tx;
 
+	struct napi_struct napi;
 	cpumask_t affinity_mask;
 	int numa_node;
 	struct rcu_head rcu;    /* to avoid race with update stats on free */
@@ -106,6 +107,10 @@ struct txgbe_mac_addr {
  **/
 #define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     BIT(0)
 #define TXGBE_FLAG2_SFP_NEEDS_RESET             BIT(1)
+#define TXGBE_FLAG2_TEMP_SENSOR_EVENT           BIT(2)
+#define TXGBE_FLAG2_PF_RESET_REQUESTED          BIT(3)
+#define TXGBE_FLAG2_RESET_INTR_RECEIVED         BIT(4)
+#define TXGBE_FLAG2_GLOBAL_RESET_REQUESTED      BIT(5)
 
 enum txgbe_isb_idx {
 	TXGBE_ISB_HEADER,
@@ -137,6 +142,8 @@ struct txgbe_adapter {
 	/* TX */
 	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
 
+	u64 lsc_int;
+
 	/* RX */
 	struct txgbe_ring *rx_ring[TXGBE_MAX_RX_QUEUES];
 	struct txgbe_q_vector *q_vector[MAX_MSIX_Q_VECTORS];
@@ -162,6 +169,7 @@ struct txgbe_adapter {
 
 	char eeprom_id[32];
 	bool netdev_registered;
+	u32 interrupt_event;
 
 	struct txgbe_mac_addr *mac_table;
 
@@ -203,7 +211,9 @@ void txgbe_irq_disable(struct txgbe_adapter *adapter);
 void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush);
 int txgbe_open(struct net_device *netdev);
 int txgbe_close(struct net_device *netdev);
+void txgbe_up(struct txgbe_adapter *adapter);
 void txgbe_down(struct txgbe_adapter *adapter);
+void txgbe_reinit_locked(struct txgbe_adapter *adapter);
 void txgbe_reset(struct txgbe_adapter *adapter);
 s32 txgbe_init_shared_code(struct txgbe_hw *hw);
 void txgbe_disable_device(struct txgbe_adapter *adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 8dd0dec41971..6a5398b2f80e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -1523,6 +1523,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	phy->ops.read_i2c_byte = txgbe_read_i2c_byte;
 	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom;
 	phy->ops.identify_sfp = txgbe_identify_module;
+	phy->ops.check_overtemp = txgbe_check_overtemp;
 	phy->ops.identify = txgbe_identify_phy;
 	phy->ops.init = txgbe_init_phy_ops;
 
@@ -2725,12 +2726,16 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
 	u32 reset = 0;
 	s32 status;
+	u32 i;
 
 	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
 	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
 	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
 	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;
 
+	u32 reset_status = 0;
+	u32 rst_delay = 0;
+
 	/* Call adapter stop to disable tx/rx and clear interrupts */
 	status = TCALL(hw, mac.ops.stop_adapter);
 	if (status != 0)
@@ -2751,30 +2756,67 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 	curr_vr_xs_or_pcs_mmd_digi_ctl1 =
 		txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
 
-	if (txgbe_mng_present(hw)) {
-		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
-		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
-			txgbe_reset_hostif(hw);
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
+				txgbe_dbg(hw, "Global reset polling failed to complete.\n");
+				goto reset_hw_out;
+			}
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_SW_RESET);
+			if (status != 0)
+				goto reset_hw_out;
+		} else if (hw->reset_type == TXGBE_GLOBAL_RESET) {
+			struct txgbe_adapter *adapter =
+				container_of(hw, struct txgbe_adapter, hw);
+			msleep(100 * rst_delay + 2000);
+			pci_restore_state(adapter->pdev);
+			pci_save_state(adapter->pdev);
+			pci_wake_from_d3(adapter->pdev, false);
 		}
 	} else {
+		if (txgbe_mng_present(hw)) {
+			if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+			      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+				txgbe_reset_hostif(hw);
+			}
+		} else {
+			if (hw->bus.lan_id == 0)
+				reset = TXGBE_MIS_RST_LAN0_RST;
+			else
+				reset = TXGBE_MIS_RST_LAN1_RST;
+
+			wr32(hw, TXGBE_MIS_RST,
+			     reset | rd32(hw, TXGBE_MIS_RST));
+			TXGBE_WRITE_FLUSH(hw);
+		}
+		usleep_range(10, 100);
+
 		if (hw->bus.lan_id == 0)
-			reset = TXGBE_MIS_RST_LAN0_RST;
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST);
 		else
-			reset = TXGBE_MIS_RST_LAN1_RST;
+			status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST);
 
-		wr32(hw, TXGBE_MIS_RST,
-		     reset | rd32(hw, TXGBE_MIS_RST));
-		TXGBE_WRITE_FLUSH(hw);
+		if (status != 0)
+			goto reset_hw_out;
 	}
-	usleep_range(10, 100);
-
-	if (hw->bus.lan_id == 0)
-		status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST);
-	else
-		status = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST);
-
-	if (status != 0)
-		goto reset_hw_out;
 
 	status = txgbe_reset_misc(hw);
 	if (status != 0)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 71954d2d4b9a..bb87cc7c4157 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -15,6 +15,12 @@
 
 char txgbe_driver_name[] = "txgbe";
 
+static const char txgbe_overheat_msg[] =
+	"Network adapter has been stopped because it has over heated."
+	"If the problem persists, restart or power off the system and replace the adapter.";
+static const char txgbe_underheat_msg[] =
+	"Network adapter has been started again, the temperature has been back to normal state";
+
 /* txgbe_pci_tbl - PCI Device ID Table
  *
  * Wildcard entries (PCI_ANY_ID) should come last
@@ -227,6 +233,113 @@ void txgbe_write_eitr(struct txgbe_q_vector *q_vector)
 	wr32(hw, TXGBE_PX_ITR(v_idx), itr_reg);
 }
 
+/**
+ * txgbe_check_overtemp_subtask - check for over temperature
+ * @adapter: pointer to adapter
+ **/
+static void txgbe_check_overtemp_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr = adapter->interrupt_event;
+	s32 temp_state;
+
+	if (test_bit(__TXGBE_DOWN, &adapter->state))
+		return;
+	if (!(adapter->flags2 & TXGBE_FLAG2_TEMP_SENSOR_EVENT))
+		return;
+
+	adapter->flags2 &= ~TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+
+	/* Since the warning interrupt is for both ports
+	 * we don't have to check if:
+	 *  - This interrupt wasn't for our port.
+	 *  - We may have missed the interrupt so always have to
+	 *    check if we  got a LSC
+	 */
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
+
+	temp_state = TCALL(hw, phy.ops.check_overtemp);
+	if (!temp_state || temp_state == TXGBE_NOT_IMPLEMENTED)
+		return;
+
+	if (temp_state == TXGBE_ERR_UNDERTEMP &&
+	    test_bit(__TXGBE_HANGING, &adapter->state)) {
+		netif_crit(adapter, drv, adapter->netdev,
+			   "%s\n", txgbe_underheat_msg);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
+		netif_carrier_on(adapter->netdev);
+		clear_bit(__TXGBE_HANGING, &adapter->state);
+	} else if (temp_state == TXGBE_ERR_OVERTEMP &&
+		!test_and_set_bit(__TXGBE_HANGING, &adapter->state)) {
+		netif_crit(adapter, drv, adapter->netdev,
+			   "%s\n", txgbe_overheat_msg);
+		netif_carrier_off(adapter->netdev);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, 0);
+	}
+
+	adapter->interrupt_event = 0;
+}
+
+static void txgbe_check_overtemp_event(struct txgbe_adapter *adapter, u32 eicr)
+{
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
+
+	if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+		adapter->interrupt_event = eicr;
+		adapter->flags2 |= TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+		txgbe_service_event_schedule(adapter);
+	}
+}
+
+static void txgbe_check_sfp_event(struct txgbe_adapter *adapter, u32 eicr)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr_mask = TXGBE_PX_MISC_IC_GPIO;
+	u32 reg;
+
+	if (eicr & eicr_mask) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			wr32(hw, TXGBE_GPIO_INTMASK, 0xFF);
+			reg = rd32(hw, TXGBE_GPIO_INTSTATUS);
+			if (reg & TXGBE_GPIO_INTSTATUS_2) {
+				adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_2);
+				adapter->sfp_poll_time = 0;
+				txgbe_service_event_schedule(adapter);
+			}
+			if (reg & TXGBE_GPIO_INTSTATUS_3) {
+				adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_3);
+				txgbe_service_event_schedule(adapter);
+			}
+
+			if (reg & TXGBE_GPIO_INTSTATUS_6) {
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_6);
+				adapter->flags |=
+					TXGBE_FLAG_NEED_LINK_CONFIG;
+				txgbe_service_event_schedule(adapter);
+			}
+			wr32(hw, TXGBE_GPIO_INTMASK, 0x0);
+		}
+	}
+}
+
+static void txgbe_check_lsc(struct txgbe_adapter *adapter)
+{
+	adapter->lsc_int++;
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_service_event_schedule(adapter);
+}
+
 /**
  * txgbe_irq_enable - Enable default interrupt generation settings
  * @adapter: board private structure
@@ -258,6 +371,8 @@ void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
 	/* enable misc interrupt */
 	mask = TXGBE_PX_MISC_IEN_MASK;
 
+	mask |= TXGBE_PX_MISC_IEN_OVER_HEAT;
+
 	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
 
 	/* unmask interrupt */
@@ -273,8 +388,37 @@ void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
 static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
 {
 	struct txgbe_adapter *adapter = data;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr;
+	u32 ecc;
+
+	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+
+	if (eicr & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr & TXGBE_PX_MISC_IC_INT_ERR) {
+		netif_info(adapter, link, adapter->netdev,
+			   "Received unrecoverable ECC Err, initiating reset.\n");
+		ecc = rd32(hw, TXGBE_MIS_ST);
+		if (((ecc & TXGBE_MIS_ST_LAN0_ECC) && hw->bus.lan_id == 0) ||
+		    ((ecc & TXGBE_MIS_ST_LAN1_ECC) && hw->bus.lan_id == 1))
+			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+
+		txgbe_service_event_schedule(adapter);
+	}
+	if (eicr & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	if ((eicr & TXGBE_PX_MISC_IC_STALL) ||
+	    (eicr & TXGBE_PX_MISC_IC_ETH_EVENT)) {
+		adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
 
-	txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	txgbe_check_sfp_event(adapter, eicr);
+	txgbe_check_overtemp_event(adapter, eicr);
 
 	/* re-enable the original interrupt state, no lsc, no queues */
 	if (!test_bit(__TXGBE_DOWN, &adapter->state))
@@ -285,6 +429,12 @@ static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
 
 static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
 {
+	struct txgbe_q_vector *q_vector = data;
+
+	/* EIAM disabled interrupts (on this vector) for us */
+	if (q_vector->rx.ring || q_vector->tx.ring)
+		napi_schedule_irqoff(&q_vector->napi);
+
 	return IRQ_HANDLED;
 }
 
@@ -362,6 +512,8 @@ static int txgbe_request_msix_irqs(struct txgbe_adapter *adapter)
 static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
 {
 	struct txgbe_adapter *adapter = data;
+	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
+	u32 eicr_misc;
 	u32 eicr;
 
 	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_VEC0);
@@ -377,9 +529,27 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
 	if (!(adapter->flags & TXGBE_FLAG_MSI_ENABLED))
 		wr32(&adapter->hw, TXGBE_PX_INTA, 1);
 
-	txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	eicr_misc = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	if (eicr_misc & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_INT_ERR) {
+		netif_info(adapter, link, adapter->netdev,
+			   "Received unrecoverable ECC Err, initiating reset.\n");
+		adapter->flags2 |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	txgbe_check_sfp_event(adapter, eicr_misc);
+	txgbe_check_overtemp_event(adapter, eicr_misc);
 
 	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
 
 	/* re-enable link(maybe) and non-queue interrupts, no flush.
 	 * txgbe_poll will re-enable the queue interrupts
@@ -651,11 +821,39 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
 	txgbe_irq_enable(adapter, true, true);
 
+	/* bring the link up in the watchdog, this could race with our first
+	 * link up interrupt but shouldn't be a problem
+	 */
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+
+	mod_timer(&adapter->service_timer, jiffies);
+
 	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
 	wr32m(hw, TXGBE_CFG_PORT_CTL,
 	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
 }
 
+void txgbe_reinit_locked(struct txgbe_adapter *adapter)
+{
+	/* put off any impending NetWatchDogTimeout */
+	netif_trans_update(adapter->netdev);
+
+	while (test_and_set_bit(__TXGBE_RESETTING, &adapter->state))
+		usleep_range(1000, 2000);
+	txgbe_down(adapter);
+	txgbe_up(adapter);
+	clear_bit(__TXGBE_RESETTING, &adapter->state);
+}
+
+void txgbe_up(struct txgbe_adapter *adapter)
+{
+	/* hardware has been reset, we need to reload some things */
+	txgbe_configure(adapter);
+
+	txgbe_up_complete(adapter);
+}
+
 void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -715,6 +913,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 
 	txgbe_irq_disable(adapter);
 
+	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
+			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
 	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
 
 	del_timer_sync(&adapter->service_timer);
@@ -1256,6 +1456,78 @@ static void txgbe_service_timer(struct timer_list *t)
 	txgbe_service_event_schedule(adapter);
 }
 
+static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
+{
+	u32 reset_flag = 0;
+	u32 value = 0;
+
+	if (!(adapter->flags2 & (TXGBE_FLAG2_PF_RESET_REQUESTED |
+				 TXGBE_FLAG2_GLOBAL_RESET_REQUESTED |
+				 TXGBE_FLAG2_RESET_INTR_RECEIVED)))
+		return;
+
+	/* If we're already down, just bail */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state))
+		return;
+
+	netdev_err(adapter->netdev, "Reset adapter\n");
+
+	rtnl_lock();
+	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+	}
+	if (adapter->flags2 & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_PF_RESET_REQUESTED;
+	}
+
+	if (adapter->flags2 & TXGBE_FLAG2_RESET_INTR_RECEIVED) {
+		/* If there's a recovery already waiting, it takes
+		 * precedence before starting a new reset sequence.
+		 */
+		adapter->flags2 &= ~TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		value = rd32m(&adapter->hw, TXGBE_MIS_RST_ST,
+			      TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK) >>
+			TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT;
+		if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST)
+			adapter->hw.reset_type = TXGBE_SW_RESET;
+		else if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST)
+			adapter->hw.reset_type = TXGBE_GLOBAL_RESET;
+
+		adapter->hw.force_full_reset = true;
+		txgbe_reinit_locked(adapter);
+		adapter->hw.force_full_reset = false;
+		goto unlock;
+	}
+
+	if (reset_flag & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		/*debug to up*/
+		txgbe_reinit_locked(adapter);
+	} else if (reset_flag & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		/* Request a Global Reset
+		 *
+		 * This will start the chip's countdown to the actual full
+		 * chip reset event, and a warning interrupt to be sent
+		 * to all PFs, including the requestor.  Our handler
+		 * for the warning interrupt will deal with the shutdown
+		 * and recovery of the switch setup.
+		 */
+		/*debug to up*/
+		pci_save_state(adapter->pdev);
+		if (txgbe_mng_present(&adapter->hw))
+			txgbe_reset_hostif(&adapter->hw);
+		else
+			wr32m(&adapter->hw, TXGBE_MIS_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST);
+	}
+
+unlock:
+	rtnl_unlock();
+}
+
 /**
  * txgbe_service_task - manages and runs subtasks
  * @work: pointer to work_struct containing our data
@@ -1275,13 +1547,21 @@ static void txgbe_service_task(struct work_struct *work)
 		return;
 	}
 
+	txgbe_reset_subtask(adapter);
 	txgbe_sfp_detection_subtask(adapter);
 	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_check_overtemp_subtask(adapter);
 	txgbe_watchdog_subtask(adapter);
 
 	txgbe_service_event_complete(adapter);
 }
 
+static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	return NETDEV_TX_OK;
+}
+
 /**
  * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
  * netdev->dev_addr_list
@@ -1331,6 +1611,7 @@ static int txgbe_del_sanmac_netdev(struct net_device *dev)
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
+	.ndo_start_xmit         = txgbe_xmit_frame,
 };
 
 void txgbe_assign_netdev_ops(struct net_device *dev)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index be0185570b62..5c6161a14876 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -394,3 +394,25 @@ s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
 	return txgbe_read_i2c_byte_int(hw, byte_offset, dev_addr,
 				       data, true);
 }
+
+/**
+ *  txgbe_check_overtemp - Checks if an overtemp occurred.
+ *  @hw: pointer to hardware structure
+ *
+ *  Checks if the LASI temp alarm status was triggered due to overtemp
+ **/
+s32 txgbe_check_overtemp(struct txgbe_hw *hw)
+{
+	s32 status = 0;
+	u32 ts_state;
+
+	/* Check that the LASI temp alarm status was triggered */
+	ts_state = rd32(hw, TXGBE_TS_ALARM_ST);
+
+	if (ts_state & TXGBE_TS_ALARM_ST_DALARM)
+		status = TXGBE_ERR_UNDERTEMP;
+	else if (ts_state & TXGBE_TS_ALARM_ST_ALARM)
+		status = TXGBE_ERR_OVERTEMP;
+
+	return status;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
index bb34e2dce2f8..c041dc8133cb 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -43,6 +43,7 @@ s32 txgbe_check_reset_blocked(struct txgbe_hw *hw);
 
 s32 txgbe_identify_module(struct txgbe_hw *hw);
 s32 txgbe_identify_sfp_module(struct txgbe_hw *hw);
+s32 txgbe_check_overtemp(struct txgbe_hw *hw);
 s32 txgbe_init_i2c(struct txgbe_hw *hw);
 s32 txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr);
 s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 690b644962f2..51d349f72591 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -1158,6 +1158,7 @@ struct txgbe_phy_operations {
 			     u8 dev_addr, u8 *data);
 	s32 (*read_i2c_eeprom)(struct txgbe_hw *hw, u8 byte_offset,
 			       u8 *eeprom_data);
+	s32 (*check_overtemp)(struct txgbe_hw *hw);
 };
 
 struct txgbe_eeprom_info {
@@ -1232,6 +1233,7 @@ struct txgbe_hw {
 	u8 revision_id;
 	bool adapter_stopped;
 	enum txgbe_reset_type reset_type;
+	bool force_full_reset;
 	enum txgbe_link_status link_status;
 	u16 oem_ssid;
 	u16 oem_svid;
-- 
2.27.0

