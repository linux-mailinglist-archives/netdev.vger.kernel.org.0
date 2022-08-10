Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2B58E924
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiHJI5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiHJI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:11 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE0674DDA
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:56:58 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121815twi8i2ua
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:54 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: MeSsSe0XtefQ4JFoXOeik5y4AzCXatfoO/tfR5GOg5YH2tBWrMBjagLbU+xvK
        biNIa1PtCnM1LeCQ3BizHm7AAEG2yQzhSnNP+SldwQ74CBymRVWmutDuq/gRpBNHMOt6wkq
        /MDLpSJ/evJToXtcoy/JVNspCm6a6znfXM+lthPyAW1EkiBjL5rjQ/JwkMvhEEwc7QoZa/U
        ihYFn94oKfFYYVOt9fBVp5mEzKfE5LAo6xe4Prkil/s1MEHJvWbfpY80PccrwjK+Iz5OUY2
        7Jn9Lua1GN23wGrTg1A33vuujlpfil7umHoVsHjmULK0C+a+SdD3oNJDMCh8SIJQky8sfpW
        eQ6A57kox/WFDsoUlZ+X2d/VdV7+NDEY3PMDlveMc0YWoTqtmUNeLJlDWAn4EOt1vW7Sopj
        yZQjc7kAbMI=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 16/16] net: txgbe: support to respond Tx hang
Date:   Wed, 10 Aug 2022 16:55:32 +0800
Message-Id: <20220810085532.246613-17-jiawenwu@trustnetic.com>
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

Check Tx hang, and determine whether it is caused by PCIe link loss.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 186 ++++++++++++++++++
 2 files changed, 196 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 584b9542f768..7646cdfa1c67 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -122,6 +122,7 @@ struct txgbe_queue_stats {
 struct txgbe_tx_queue_stats {
 	u64 restart_queue;
 	u64 tx_busy;
+	u64 tx_done_old;
 };
 
 struct txgbe_rx_queue_stats {
@@ -135,6 +136,8 @@ struct txgbe_rx_queue_stats {
 };
 
 enum txgbe_ring_state_t {
+	__TXGBE_TX_DETECT_HANG,
+	__TXGBE_HANG_CHECK_ARMED,
 	__TXGBE_RX_RSC_ENABLED,
 };
 
@@ -143,6 +146,12 @@ struct txgbe_fwd_adapter {
 	struct txgbe_adapter *adapter;
 };
 
+#define check_for_tx_hang(ring) \
+	test_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
+#define set_check_for_tx_hang(ring) \
+	set_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
+#define clear_check_for_tx_hang(ring) \
+	clear_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
 #define ring_is_rsc_enabled(ring) \
 	test_bit(__TXGBE_RX_RSC_ENABLED, &(ring)->state)
 #define set_ring_rsc_enabled(ring) \
@@ -364,6 +373,7 @@ struct txgbe_adapter {
 
 	u64 restart_queue;
 	u64 lsc_int;
+	u32 tx_timeout_count;
 
 	/* RX */
 	struct txgbe_ring *rx_ring[TXGBE_MAX_RX_QUEUES];
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 33a2c681bb1f..806901db5a0b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -219,6 +219,130 @@ void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 	/* tx_buffer must be completely set up in the transmit path */
 }
 
+static u64 txgbe_get_tx_completed(struct txgbe_ring *ring)
+{
+	return ring->stats.packets;
+}
+
+static u64 txgbe_get_tx_pending(struct txgbe_ring *ring)
+{
+	struct txgbe_adapter *adapter;
+	struct txgbe_hw *hw;
+	u32 head, tail;
+
+	if (ring->accel)
+		adapter = ring->accel->adapter;
+	else
+		adapter = ring->q_vector->adapter;
+
+	hw = &adapter->hw;
+	head = rd32(hw, TXGBE_PX_TR_RP(ring->reg_idx));
+	tail = rd32(hw, TXGBE_PX_TR_WP(ring->reg_idx));
+
+	return ((head <= tail) ? tail : tail + ring->count) - head;
+}
+
+static inline bool txgbe_check_tx_hang(struct txgbe_ring *tx_ring)
+{
+	u64 tx_done = txgbe_get_tx_completed(tx_ring);
+	u64 tx_done_old = tx_ring->tx_stats.tx_done_old;
+	u64 tx_pending = txgbe_get_tx_pending(tx_ring);
+
+	clear_check_for_tx_hang(tx_ring);
+
+	/* Check for a hung queue, but be thorough. This verifies
+	 * that a transmit has been completed since the previous
+	 * check AND there is at least one packet pending. The
+	 * ARMED bit is set to indicate a potential hang. The
+	 * bit is cleared if a pause frame is received to remove
+	 * false hang detection due to PFC or 802.3x frames. By
+	 * requiring this to fail twice we avoid races with
+	 * pfc clearing the ARMED bit and conditions where we
+	 * run the check_tx_hang logic with a transmit completion
+	 * pending but without time to complete it yet.
+	 */
+	if (tx_done_old == tx_done && tx_pending)
+		/* make sure it is true for two checks in a row */
+		return test_and_set_bit(__TXGBE_HANG_CHECK_ARMED,
+					&tx_ring->state);
+	/* update completed stats and continue */
+	tx_ring->tx_stats.tx_done_old = tx_done;
+	/* reset the countdown */
+	clear_bit(__TXGBE_HANG_CHECK_ARMED, &tx_ring->state);
+
+	return false;
+}
+
+/**
+ * txgbe_tx_timeout - Respond to a Tx Hang
+ * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
+ **/
+static void txgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	bool real_tx_hang = false;
+	u16 value = 0;
+	u32 value2 = 0;
+	u32 value3 = 0;
+	u32 head, tail;
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
+
+		if (check_for_tx_hang(tx_ring) && txgbe_check_tx_hang(tx_ring))
+			real_tx_hang = true;
+	}
+
+	if (real_tx_hang)
+		netif_warn(adapter, drv, netdev, "Real Tx hang.\n");
+
+	/* Dump the relevant registers to determine the cause of a timeout event. */
+	pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &value);
+	netif_warn(adapter, drv, netdev, "pci vendor id: 0x%x\n", value);
+	pci_read_config_word(adapter->pdev, PCI_COMMAND, &value);
+	netif_warn(adapter, drv, netdev, "pci command reg: 0x%x.\n", value);
+
+	value2 = rd32(&adapter->hw, 0x10000);
+	netif_warn(adapter, drv, netdev, "reg mis_pwr: 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d0);
+	netif_warn(adapter, drv, netdev, "tdm desc 0 fatal: 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d4);
+	netif_warn(adapter, drv, netdev, "tdm desc 1 fatal: 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d8);
+	netif_warn(adapter, drv, netdev, "tdm desc 2 fatal: 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180dc);
+	netif_warn(adapter, drv, netdev, "tdm desc 3 fatal: 0x%08x\n", value2);
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		head = rd32(&adapter->hw, TXGBE_PX_TR_RP(adapter->tx_ring[i]->reg_idx));
+		tail = rd32(&adapter->hw, TXGBE_PX_TR_WP(adapter->tx_ring[i]->reg_idx));
+
+		netif_warn(adapter, drv, netdev,
+			   "tx ring %d next_to_use is %d, next_to_clean is %d\n",
+			   i, adapter->tx_ring[i]->next_to_use,
+			   adapter->tx_ring[i]->next_to_clean);
+		netif_warn(adapter, drv, netdev,
+			   "tx ring %d hw rp is 0x%x, wp is 0x%x\n",
+			   i, head, tail);
+	}
+
+	value2 = rd32(&adapter->hw, TXGBE_PX_IMS(0));
+	value3 = rd32(&adapter->hw, TXGBE_PX_IMS(1));
+	netif_warn(adapter, drv, netdev,
+		   "PX_IMS0 value is 0x%08x, PX_IMS1 value is 0x%08x\n",
+		   value2, value3);
+
+	if (value2 || value3) {
+		netif_warn(adapter, drv, netdev, "clear interrupt mask.\n");
+		wr32(&adapter->hw, TXGBE_PX_ICS(0), value2);
+		wr32(&adapter->hw, TXGBE_PX_IMC(0), value2);
+		wr32(&adapter->hw, TXGBE_PX_ICS(1), value3);
+		wr32(&adapter->hw, TXGBE_PX_IMC(1), value3);
+	}
+}
+
 /**
  * txgbe_clean_tx_irq - Reclaim resources after transmit completes
  * @q_vector: structure containing interrupt and ring information
@@ -322,6 +446,39 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
 	q_vector->tx.total_bytes += total_bytes;
 	q_vector->tx.total_packets += total_packets;
 
+	if (check_for_tx_hang(tx_ring) && txgbe_check_tx_hang(tx_ring)) {
+	/* schedule immediate reset if we believe we hung */
+		struct txgbe_hw *hw = &adapter->hw;
+		u16 value = 0;
+
+		netif_err(adapter, drv, adapter->netdev,
+			  "Detected Tx Unit Hang\n"
+			  "  Tx Queue             <%d>\n"
+			  "  TDH, TDT             <%x>, <%x>\n"
+			  "  next_to_use          <%x>\n"
+			  "  next_to_clean        <%x>\n"
+			  "tx_buffer_info[next_to_clean]\n"
+			  "  jiffies              <%lx>\n",
+			  tx_ring->queue_index,
+			  rd32(hw, TXGBE_PX_TR_RP(tx_ring->reg_idx)),
+			  rd32(hw, TXGBE_PX_TR_WP(tx_ring->reg_idx)),
+			  tx_ring->next_to_use, i, jiffies);
+
+		pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &value);
+		if (value == TXGBE_FAILED_READ_CFG_WORD)
+			netif_info(adapter, hw, adapter->netdev,
+				   "pcie link has been lost.\n");
+
+		netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
+
+		netif_info(adapter, probe, adapter->netdev,
+			   "tx hang %d detected on queue %d, resetting adapter\n",
+			   adapter->tx_timeout_count + 1, tx_ring->queue_index);
+
+		/* the adapter is about to reset, no point in enabling stuff */
+		return true;
+	}
+
 	netdev_tx_completed_queue(txring_txq(tx_ring),
 				  total_packets, total_bytes);
 
@@ -3590,6 +3747,32 @@ void txgbe_update_stats(struct txgbe_adapter *adapter)
 	net_stats->rx_missed_errors = total_mpc;
 }
 
+/**
+ * txgbe_check_hang_subtask - check for hung queues and dropped interrupts
+ * @adapter: pointer to the device adapter structure
+ *
+ * This function serves two purposes.  First it strobes the interrupt lines
+ * in order to make certain interrupts are occurring.  Secondly it sets the
+ * bits needed to check for TX hangs.  As a result we should immediately
+ * determine if a hang has occurred.
+ */
+static void txgbe_check_hang_subtask(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	/* If we're down or resetting, just bail */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	/* Force detection of hung controller */
+	if (netif_carrier_ok(adapter->netdev)) {
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			set_check_for_tx_hang(adapter->tx_ring[i]);
+	}
+}
+
 /**
  * txgbe_watchdog_update_link - update the link status
  * @adapter: pointer to the device adapter structure
@@ -3913,6 +4096,7 @@ static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
 		return;
 
 	netdev_err(adapter->netdev, "Reset adapter\n");
+	adapter->tx_timeout_count++;
 
 	rtnl_lock();
 	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
@@ -3993,6 +4177,7 @@ static void txgbe_service_task(struct work_struct *work)
 	txgbe_sfp_link_config_subtask(adapter);
 	txgbe_check_overtemp_subtask(adapter);
 	txgbe_watchdog_subtask(adapter);
+	txgbe_check_hang_subtask(adapter);
 
 	txgbe_service_event_complete(adapter);
 }
@@ -4970,6 +5155,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_set_rx_mode        = txgbe_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_change_mtu		= txgbe_change_mtu,
+	.ndo_tx_timeout         = txgbe_tx_timeout,
 	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
 	.ndo_get_stats64        = txgbe_get_stats64,
-- 
2.27.0

