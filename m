Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9652A5A5C7F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiH3HGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiH3HGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:06:21 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E30CC2EBC
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:09 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843164t93os0n8
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:06:04 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: CR3LFp2JE4kGYilL+lsphAAJ4onDaomw6jYpS51uzr2JYE3M013aoLJOB9bPy
        7WYgTX2MwB77q7lPZ4mPQ9gKC7LzKzCyjea/lMt0yQEZBzZAkKpyJYvidZgBX1qfQhlzrVS
        DHkyke4iP2ynEBFjzmJLBsDwzgbEd82VzkYPQ3KA8EBD5hmWsDlpUZtyOJm7JPQhNpYFD2t
        9f3eZ3eO5PKO0ze0KrwIaeLQo0TPVipxMrE0HtuSFhDn0ff9mjfiY7s4GTezZJHi5zEyXF0
        4g9I7AdqneT6jxV160kxmNyaKzJPB8hOjeUBMMhP25OIzQ5zhFxMStKE6UwqDDQWhP7iEOj
        HXKgNDzOfCQu82OvUmB4UvKOsaBtHgg2T+dYvY7k2AGTIVEd6Qb9Yj87dqACWjMIvgQidWS
        7KoMXq+ywtc=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 16/16] net: txgbe: support to respond Tx hang
Date:   Tue, 30 Aug 2022 15:04:54 +0800
Message-Id: <20220830070454.146211-17-jiawenwu@trustnetic.com>
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

Check Tx hang, and determine whether it is caused by PCIe link loss.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  12 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 180 ++++++++++++++++++
 2 files changed, 192 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 52a26b5b0ced..d38fc3a6765e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -119,6 +119,7 @@ struct txgbe_queue_stats {
 struct txgbe_tx_queue_stats {
 	u64 restart_queue;
 	u64 tx_busy;
+	u64 tx_done_old;
 };
 
 struct txgbe_rx_queue_stats {
@@ -132,6 +133,8 @@ struct txgbe_rx_queue_stats {
 };
 
 enum txgbe_ring_state_t {
+	__TXGBE_TX_DETECT_HANG,
+	__TXGBE_HANG_CHECK_ARMED,
 	__TXGBE_RX_RSC_ENABLED,
 };
 
@@ -140,6 +143,12 @@ struct txgbe_fwd_adapter {
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
@@ -361,6 +370,7 @@ struct txgbe_adapter {
 
 	u64 restart_queue;
 	u64 lsc_int;
+	u32 tx_timeout_count;
 
 	/* RX */
 	struct txgbe_ring *rx_ring[TXGBE_MAX_RX_QUEUES];
@@ -561,4 +571,6 @@ __maybe_unused static struct net_device *txgbe_hw_to_netdev(const struct txgbe_h
 #define txgbe_info(hw, fmt, arg...) \
 	dev_info(txgbe_hw_to_dev(hw), fmt, ##arg)
 
+#define TXGBE_FAILED_READ_CFG_WORD  0xffffU
+
 #endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index c27a6a8b609e..8664db1a03f9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -186,6 +186,124 @@ void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 	/* tx_buffer must be completely set up in the transmit path */
 }
 
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
+static bool txgbe_check_tx_hang(struct txgbe_ring *tx_ring)
+{
+	u64 tx_done_old = tx_ring->tx_stats.tx_done_old;
+	u64 tx_pending = txgbe_get_tx_pending(tx_ring);
+	u64 tx_done = tx_ring->stats.packets;
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
+	u32 value2 = 0, value3 = 0;
+	u32 head, tail;
+	u16 value = 0;
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
@@ -289,6 +407,39 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
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
 
@@ -3498,6 +3649,32 @@ void txgbe_update_stats(struct txgbe_adapter *adapter)
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
@@ -3817,6 +3994,7 @@ static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
 		return;
 
 	netdev_err(adapter->netdev, "Reset adapter\n");
+	adapter->tx_timeout_count++;
 
 	rtnl_lock();
 	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
@@ -3886,6 +4064,7 @@ static void txgbe_service_task(struct work_struct *work)
 	txgbe_sfp_link_config_subtask(adapter);
 	txgbe_check_overtemp_subtask(adapter);
 	txgbe_watchdog_subtask(adapter);
+	txgbe_check_hang_subtask(adapter);
 
 	txgbe_service_event_complete(adapter);
 }
@@ -4885,6 +5064,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = txgbe_set_mac,
 	.ndo_change_mtu		= txgbe_change_mtu,
+	.ndo_tx_timeout         = txgbe_tx_timeout,
 	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
 	.ndo_get_stats64        = txgbe_get_stats64,
-- 
2.27.0

