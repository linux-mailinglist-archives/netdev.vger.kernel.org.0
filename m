Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE43522A59
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbiEKDT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpbg511.qq.com (smtpbg511.qq.com [203.205.250.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7DF6CABA
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:29 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239164t9woura3
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:24 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: Mw9wRCIuhZS/E9IYByn0rb+Scy/Achr0Y4cD9q3Zpzsq4HzytUhkbDrMI9dn6
        Yn4Qmh/JyOtBAS3eBwrJZ0ZVIA0vZh8VyqDYkJpgUB7bm4iAeF284fZbhm8p4bhHLC9oz36
        EuyDbZp1ZyBCxE5EoBRUHS7KTKRsEHS8v1TAtgRp9Lu4LDzmSMwzJOjIDnSJjV4Z0Y4T4Ai
        BkffXo4idO9zdU2Al7RVLygPOgUaShsdDbaW4Dwx7sVMI8Fjj6TxDOHLq+YGeSA3nV7B++Y
        ZnzISdNqalj7CKEponF1oM1KxcTIr5Xw+D/ExUruQaTsx44v2FTP1KmR2Iq8CjLygSt22C8
        bHftdqn3rZjY+7OenQevmOJVBNxU0X1cYYjPwIF
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 09/14] net: txgbe: Support PTP
Date:   Wed, 11 May 2022 11:26:54 +0800
Message-Id: <20220511032659.641834-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to enable PTP clock.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  34 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  95 +-
 .../net/ethernet/wangxun/txgbe/txgbe_ptp.c    | 840 ++++++++++++++++++
 4 files changed, 967 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ptp.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index aceb0d2e56ee..f233bc45575c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
               txgbe_hw.o txgbe_phy.o \
-              txgbe_lib.o
+              txgbe_lib.o txgbe_ptp.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 7a6683b33930..3b429cca494e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -12,6 +12,8 @@
 #include <linux/etherdevice.h>
 #include <linux/timecounter.h>
 #include <linux/clocksource.h>
+#include <linux/net_tstamp.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/aer.h>
 
 #include "txgbe_type.h"
@@ -110,6 +112,7 @@ enum txgbe_tx_flags {
  */
 struct txgbe_tx_buffer {
 	union txgbe_tx_desc *next_to_watch;
+	unsigned long time_stamp;
 	struct sk_buff *skb;
 	unsigned int bytecount;
 	unsigned short gso_segs;
@@ -200,6 +203,7 @@ struct txgbe_ring {
 	u8 reg_idx;
 	u16 next_to_use;
 	u16 next_to_clean;
+	unsigned long last_rx_timestamp;
 	u16 rx_buf_len;
 	union {
 		u16 next_to_alloc;
@@ -363,6 +367,8 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE         ((u32)(1 << 5))
 #define TXGBE_FLAG_FDIR_HASH_CAPABLE            ((u32)(1 << 6))
 #define TXGBE_FLAG_FDIR_PERFECT_CAPABLE         ((u32)(1 << 7))
+#define TXGBE_FLAG_RX_HWTSTAMP_ENABLED          ((u32)(1 << 8))
+#define TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER      ((u32)(1 << 9))
 
 /**
  * txgbe_adapter.flag2
@@ -477,6 +483,22 @@ struct txgbe_adapter {
 	bool netdev_registered;
 	u32 interrupt_event;
 
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_caps;
+	struct work_struct ptp_tx_work;
+	struct sk_buff *ptp_tx_skb;
+	struct hwtstamp_config tstamp_config;
+	unsigned long ptp_tx_start;
+	unsigned long last_overflow_check;
+	unsigned long last_rx_ptp_check;
+	spinlock_t tmreg_lock;
+	struct cyclecounter hw_cc;
+	struct timecounter hw_tc;
+	u32 base_incval;
+	u32 tx_hwtstamp_timeouts;
+	u32 tx_hwtstamp_skipped;
+	u32 rx_hwtstamp_cleared;
+
 	struct txgbe_mac_addr *mac_table;
 
 	__le16 vxlan_port;
@@ -572,6 +594,18 @@ static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
 	return netdev_get_tx_queue(ring->netdev, ring->queue_index);
 }
 
+void txgbe_ptp_init(struct txgbe_adapter *adapter);
+void txgbe_ptp_stop(struct txgbe_adapter *adapter);
+void txgbe_ptp_suspend(struct txgbe_adapter *adapter);
+void txgbe_ptp_overflow_check(struct txgbe_adapter *adapter);
+void txgbe_ptp_rx_hang(struct txgbe_adapter *adapter);
+void txgbe_ptp_rx_hwtstamp(struct txgbe_adapter *adapter, struct sk_buff *skb);
+int txgbe_ptp_set_ts_config(struct txgbe_adapter *adapter, struct ifreq *ifr);
+int txgbe_ptp_get_ts_config(struct txgbe_adapter *adapter, struct ifreq *ifr);
+void txgbe_ptp_start_cyclecounter(struct txgbe_adapter *adapter);
+void txgbe_ptp_reset(struct txgbe_adapter *adapter);
+void txgbe_ptp_check_pps_event(struct txgbe_adapter *adapter);
+
 /**
  * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
  * disable a interrupt by writing to PX_IMS with the corresponding bit=1
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index ea17747c0df9..b225417c27d5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -459,12 +459,13 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
 			"  next_to_use          <%x>\n"
 			"  next_to_clean        <%x>\n"
 			"tx_buffer_info[next_to_clean]\n"
+			"  time_stamp           <%lx>\n"
 			"  jiffies              <%lx>\n",
 			tx_ring->queue_index,
 			rd32(hw, TXGBE_PX_TR_RP(tx_ring->reg_idx)),
 			rd32(hw, TXGBE_PX_TR_WP(tx_ring->reg_idx)),
 			tx_ring->next_to_use, i,
-			jiffies);
+			tx_ring->tx_buffer_info[i].time_stamp, jiffies);
 
 		pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &value);
 		if (value == TXGBE_FAILED_READ_CFG_WORD)
@@ -735,17 +736,25 @@ static void txgbe_rx_vlan(struct txgbe_ring *ring,
  * @skb: pointer to current skb being populated
  *
  * This function checks the ring, descriptor, and packet information in
- * order to populate the hash, checksum, VLAN, protocol, and
+ * order to populate the hash, checksum, VLAN, timestamp, protocol, and
  * other fields within the skb.
  **/
 static void txgbe_process_skb_fields(struct txgbe_ring *rx_ring,
 				     union txgbe_rx_desc *rx_desc,
 				     struct sk_buff *skb)
 {
+	u32 flags = rx_ring->q_vector->adapter->flags;
+
 	txgbe_update_rsc_stats(rx_ring, skb);
 	txgbe_rx_hash(rx_ring, rx_desc, skb);
 	txgbe_rx_checksum(rx_ring, rx_desc, skb);
 
+	if (unlikely(flags & TXGBE_FLAG_RX_HWTSTAMP_ENABLED) &&
+	    unlikely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_TS))) {
+		txgbe_ptp_rx_hwtstamp(rx_ring->q_vector->adapter, skb);
+		rx_ring->last_rx_timestamp = jiffies;
+	}
+
 	txgbe_rx_vlan(rx_ring, rx_desc, skb);
 
 	skb_record_rx_queue(skb, rx_ring->queue_index);
@@ -1491,6 +1500,8 @@ void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
 	    !(adapter->flags2 & TXGBE_FLAG2_FDIR_REQUIRES_REINIT))
 		mask |= TXGBE_PX_MISC_IEN_FLOW_DIR;
 
+	mask |= TXGBE_PX_MISC_IEN_TIMESYNC;
+
 	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
 
 	/* unmask interrupt */
@@ -1559,6 +1570,9 @@ static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
 	txgbe_check_sfp_event(adapter, eicr);
 	txgbe_check_overtemp_event(adapter, eicr);
 
+	if (unlikely(eicr & TXGBE_PX_MISC_IC_TIMESYNC))
+		txgbe_ptp_check_pps_event(adapter);
+
 	/* re-enable the original interrupt state, no lsc, no queues */
 	if (!test_bit(__TXGBE_DOWN, &adapter->state))
 		txgbe_irq_enable(adapter, false, false);
@@ -1747,6 +1761,9 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
 	txgbe_check_sfp_event(adapter, eicr_misc);
 	txgbe_check_overtemp_event(adapter, eicr_misc);
 
+	if (unlikely(eicr_misc & TXGBE_PX_MISC_IC_TIMESYNC))
+		txgbe_ptp_check_pps_event(adapter);
+
 	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
 	/* would disable interrupts here but it is auto disabled */
 	napi_schedule_irqoff(&q_vector->napi);
@@ -3193,6 +3210,9 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 
 	/* update SAN MAC vmdq pool selection */
 	TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
+
+	if (test_bit(__TXGBE_PTP_RUNNING, &adapter->state))
+		txgbe_ptp_reset(adapter);
 }
 
 /**
@@ -3865,6 +3885,8 @@ int txgbe_open(struct net_device *netdev)
 	if (err)
 		goto err_set_queues;
 
+	txgbe_ptp_init(adapter);
+
 	txgbe_up_complete(adapter);
 
 	txgbe_clear_vxlan_port(adapter);
@@ -3898,6 +3920,8 @@ static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
 
+	txgbe_ptp_suspend(adapter);
+
 	txgbe_disable_device(adapter);
 	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
 		TCALL(hw, mac.ops.disable_tx_laser);
@@ -3926,6 +3950,8 @@ int txgbe_close(struct net_device *netdev)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
+	txgbe_ptp_stop(adapter);
+
 	txgbe_down(adapter);
 	txgbe_free_irq(adapter);
 
@@ -4264,6 +4290,11 @@ static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
 		TCALL(hw, mac.ops.fc_enable);
 		txgbe_set_rx_drop_en(adapter);
 
+		adapter->last_rx_ptp_check = jiffies;
+
+		if (test_bit(__TXGBE_PTP_RUNNING, &adapter->state))
+			txgbe_ptp_start_cyclecounter(adapter);
+
 		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
 			wr32(hw, TXGBE_MAC_TX_CFG,
 			     (rd32(hw, TXGBE_MAC_TX_CFG) &
@@ -4341,6 +4372,9 @@ static void txgbe_watchdog_link_is_down(struct txgbe_adapter *adapter)
 	if (!netif_carrier_ok(netdev))
 		return;
 
+	if (test_bit(__TXGBE_PTP_RUNNING, &adapter->state))
+		txgbe_ptp_start_cyclecounter(adapter);
+
 	txgbe_info(drv, "NIC Link is Down\n");
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
@@ -4641,6 +4675,12 @@ static void txgbe_service_task(struct work_struct *work)
 	txgbe_watchdog_subtask(adapter);
 	txgbe_fdir_reinit_subtask(adapter);
 	txgbe_check_hang_subtask(adapter);
+	if (test_bit(__TXGBE_PTP_RUNNING, &adapter->state)) {
+		txgbe_ptp_overflow_check(adapter);
+		if (unlikely(adapter->flags &
+			     TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER))
+			txgbe_ptp_rx_hang(adapter);
+	}
 
 	txgbe_service_event_complete(adapter);
 }
@@ -5102,6 +5142,10 @@ static u32 txgbe_tx_cmd_type(u32 tx_flags)
 	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_TSO,
 				   TXGBE_TXD_TSE);
 
+	/* set timestamp bit if present */
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_TSTAMP,
+				   TXGBE_TXD_MAC_TSTAMP);
+
 	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_LINKSEC,
 				   TXGBE_TXD_LINKSEC);
 
@@ -5255,6 +5299,11 @@ static int txgbe_tx_map(struct txgbe_ring *tx_ring,
 
 	netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
 
+	/* set the timestamp */
+	first->time_stamp = jiffies;
+
+	skb_tx_timestamp(skb);
+
 	/* Force memory writes to complete before letting h/w know there
 	 * are new descriptors to fetch.  (Only applicable for weak-ordered
 	 * memory model archs, such as IA-64).
@@ -5509,6 +5558,22 @@ netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
 		vlan_addlen += VLAN_HLEN;
 	}
 
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    adapter->ptp_clock) {
+		if (!test_and_set_bit_lock(__TXGBE_PTP_TX_IN_PROGRESS,
+					   &adapter->state)) {
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			tx_flags |= TXGBE_TX_FLAGS_TSTAMP;
+
+			/* schedule check for Tx timestamp */
+			adapter->ptp_tx_skb = skb_get(skb);
+			adapter->ptp_tx_start = jiffies;
+			schedule_work(&adapter->ptp_tx_work);
+		} else {
+			adapter->tx_hwtstamp_skipped++;
+		}
+	}
+
 	/* record initial flags and protocol */
 	first->tx_flags = tx_flags;
 	first->protocol = protocol;
@@ -5525,7 +5590,8 @@ netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
 	if (test_bit(__TXGBE_TX_FDIR_INIT_DONE, &tx_ring->state))
 		txgbe_atr(tx_ring, first, dptype);
 
-	txgbe_tx_map(tx_ring, first, hdr_len);
+	if (txgbe_tx_map(tx_ring, first, hdr_len))
+		goto cleanup_tx_tstamp;
 
 	return NETDEV_TX_OK;
 
@@ -5533,6 +5599,14 @@ netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
 	dev_kfree_skb_any(first->skb);
 	first->skb = NULL;
 
+cleanup_tx_tstamp:
+	if (unlikely(tx_flags & TXGBE_TX_FLAGS_TSTAMP)) {
+		dev_kfree_skb_any(adapter->ptp_tx_skb);
+		adapter->ptp_tx_skb = NULL;
+		cancel_work_sync(&adapter->ptp_tx_work);
+		clear_bit_unlock(__TXGBE_PTP_TX_IN_PROGRESS, &adapter->state);
+	}
+
 	return NETDEV_TX_OK;
 }
 
@@ -5632,6 +5706,20 @@ static int txgbe_del_sanmac_netdev(struct net_device *dev)
 	return err;
 }
 
+static int txgbe_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return txgbe_ptp_get_ts_config(adapter, ifr);
+	case SIOCSHWTSTAMP:
+		return txgbe_ptp_set_ts_config(adapter, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 void txgbe_do_reset(struct net_device *netdev)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
@@ -5805,6 +5893,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_tx_timeout         = txgbe_tx_timeout,
 	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
+	.ndo_eth_ioctl          = txgbe_ioctl,
 	.ndo_get_stats64        = txgbe_get_stats64,
 	.ndo_fdb_add            = txgbe_ndo_fdb_add,
 	.ndo_features_check     = txgbe_features_check,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ptp.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ptp.c
new file mode 100644
index 000000000000..11184c725c2e
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ptp.c
@@ -0,0 +1,840 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe.h"
+#include <linux/ptp_classify.h>
+
+/**
+ * SYSTIME is defined by a fixed point system which allows the user to
+ * define the scale counter increment value at every level change of
+ * the oscillator driving SYSTIME value. The time unit is determined by
+ * the clock frequency of the oscillator and TIMINCA register.
+ * The cyclecounter and timecounter structures are used to to convert
+ * the scale counter into nanoseconds. SYSTIME registers need to be converted
+ * to ns values by use of only a right shift.
+ * The following math determines the largest incvalue that will fit into
+ * the available bits in the TIMINCA register:
+ *   Period * [ 2 ^ ( MaxWidth - PeriodWidth ) ]
+ * PeriodWidth: Number of bits to store the clock period
+ * MaxWidth: The maximum width value of the TIMINCA register
+ * Period: The clock period for the oscillator, which changes based on the link
+ * speed:
+ *   At 10Gb link or no link, the period is 6.4 ns.
+ *   At 1Gb link, the period is multiplied by 10. (64ns)
+ *   At 100Mb link, the period is multiplied by 100. (640ns)
+ * round(): discard the fractional portion of the calculation
+ *
+ * The calculated value allows us to right shift the SYSTIME register
+ * value in order to quickly convert it into a nanosecond clock,
+ * while allowing for the maximum possible adjustment value.
+ *
+ * LinkSpeed    ClockFreq   ClockPeriod  TIMINCA:IV
+ * 10000Mbps    156.25MHz   6.4*10^-9    0xCCCCCC(0xFFFFF/ns)
+ * 1000 Mbps    62.5  MHz   16 *10^-9    0x800000(0x7FFFF/ns)
+ * 100  Mbps    6.25  MHz   160*10^-9    0xA00000(0xFFFF/ns)
+ * 10   Mbps    0.625 MHz   1600*10^-9   0xC7F380(0xFFF/ns)
+ * FPGA         31.25 MHz   32 *10^-9    0x800000(0x3FFFF/ns)
+ *
+ * These diagrams are only for the 10Gb link period
+ *
+ *       +--------------+  +--------------+
+ *       |      32      |  | 8 | 3 |  20  |
+ *       *--------------+  +--------------+
+ *        \________ 43 bits ______/  fract
+ *
+ * The 43 bit SYSTIME overflows every
+ *   2^43 * 10^-9 / 3600 = 2.4 hours
+ **/
+#define TXGBE_INCVAL_10GB 0xCCCCCC
+#define TXGBE_INCVAL_1GB  0x800000
+#define TXGBE_INCVAL_100  0xA00000
+#define TXGBE_INCVAL_10   0xC7F380
+#define TXGBE_INCVAL_FPGA 0x800000
+
+#define TXGBE_INCVAL_SHIFT_10GB  20
+#define TXGBE_INCVAL_SHIFT_1GB   18
+#define TXGBE_INCVAL_SHIFT_100   15
+#define TXGBE_INCVAL_SHIFT_10    12
+#define TXGBE_INCVAL_SHIFT_FPGA  17
+
+#define TXGBE_OVERFLOW_PERIOD    (HZ * 30)
+#define TXGBE_PTP_TX_TIMEOUT     (HZ)
+
+/**
+ * txgbe_ptp_read - read raw cycle counter (to be used by time counter)
+ * @hw_cc: the cyclecounter structure
+ *
+ * this function reads the cyclecounter registers and is called by the
+ * cyclecounter structure used to construct a ns counter from the
+ * arbitrary fixed point registers
+ */
+static u64 txgbe_ptp_read(const struct cyclecounter *hw_cc)
+{
+	struct txgbe_adapter *adapter =
+		container_of(hw_cc, struct txgbe_adapter, hw_cc);
+	struct txgbe_hw *hw = &adapter->hw;
+	u64 stamp = 0;
+
+	stamp |= (u64)rd32(hw, TXGBE_TSC_1588_SYSTIML);
+	stamp |= (u64)rd32(hw, TXGBE_TSC_1588_SYSTIMH) << 32;
+
+	return stamp;
+}
+
+/**
+ * txgbe_ptp_convert_to_hwtstamp - convert register value to hw timestamp
+ * @adapter: private adapter structure
+ * @hwtstamp: stack timestamp structure
+ * @systim: unsigned 64bit system time value
+ *
+ * We need to convert the adapter's RX/TXSTMP registers into a hwtstamp value
+ * which can be used by the stack's ptp functions.
+ *
+ * The lock is used to protect consistency of the cyclecounter and the SYSTIME
+ * registers. However, it does not need to protect against the Rx or Tx
+ * timestamp registers, as there can't be a new timestamp until the old one is
+ * unlatched by reading.
+ *
+ * In addition to the timestamp in hardware, some controllers need a software
+ * overflow cyclecounter, and this function takes this into account as well.
+ **/
+static void txgbe_ptp_convert_to_hwtstamp(struct txgbe_adapter *adapter,
+					  struct skb_shared_hwtstamps *hwtstamp,
+					  u64 timestamp)
+{
+	unsigned long flags;
+	u64 ns;
+
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
+
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	ns = timecounter_cyc2time(&adapter->hw_tc, timestamp);
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	hwtstamp->hwtstamp = ns_to_ktime(ns);
+}
+
+/**
+ * txgbe_ptp_adjfreq
+ * @ptp: the ptp clock structure
+ * @ppb: parts per billion adjustment from base
+ *
+ * adjust the frequency of the ptp cycle counter by the
+ * indicated ppb from the base frequency.
+ */
+static int txgbe_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct txgbe_adapter *adapter =
+		container_of(ptp, struct txgbe_adapter, ptp_caps);
+	struct txgbe_hw *hw = &adapter->hw;
+	u64 freq, incval;
+	u32 diff;
+	int neg_adj = 0;
+
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+
+	smp_mb();
+	incval = READ_ONCE(adapter->base_incval);
+
+	freq = incval;
+	freq *= ppb;
+	diff = div_u64(freq, 1000000000ULL);
+
+	incval = neg_adj ? (incval - diff) : (incval + diff);
+
+	if (incval > TXGBE_TSC_1588_INC_IV(~0))
+		txgbe_dev_warn("PTP ppb adjusted SYSTIME rate overflowed!\n");
+	wr32(hw, TXGBE_TSC_1588_INC,
+	     TXGBE_TSC_1588_INC_IVP(incval, 2));
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_adjtime
+ * @ptp: the ptp clock structure
+ * @delta: offset to adjust the cycle counter by ns
+ *
+ * adjust the timer by resetting the timecounter structure.
+ */
+static int txgbe_ptp_adjtime(struct ptp_clock_info *ptp,
+			     s64 delta)
+{
+	struct txgbe_adapter *adapter =
+		container_of(ptp, struct txgbe_adapter, ptp_caps);
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	timecounter_adjtime(&adapter->hw_tc, delta);
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_gettime64
+ * @ptp: the ptp clock structure
+ * @ts: timespec64 structure to hold the current time value
+ *
+ * read the timecounter and return the correct value on ns,
+ * after converting it into a struct timespec64.
+ */
+static int txgbe_ptp_gettime64(struct ptp_clock_info *ptp,
+			       struct timespec64 *ts)
+{
+	struct txgbe_adapter *adapter =
+		container_of(ptp, struct txgbe_adapter, ptp_caps);
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	ns = timecounter_read(&adapter->hw_tc);
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_settime64
+ * @ptp: the ptp clock structure
+ * @ts: the timespec64 containing the new time for the cycle counter
+ *
+ * reset the timecounter to use a new base value instead of the kernel
+ * wall timer value.
+ */
+static int txgbe_ptp_settime64(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	struct txgbe_adapter *adapter =
+		container_of(ptp, struct txgbe_adapter, ptp_caps);
+	u64 ns;
+	unsigned long flags;
+
+	ns = timespec64_to_ns(ts);
+
+	/* reset the timecounter */
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	timecounter_init(&adapter->hw_tc, &adapter->hw_cc, ns);
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_check_pps_event
+ * @adapter: the private adapter structure
+ * @eicr: the interrupt cause register value
+ *
+ * This function is called by the interrupt routine when checking for
+ * interrupts. It will check and handle a pps event.
+ */
+void txgbe_ptp_check_pps_event(struct txgbe_adapter *adapter)
+{
+	struct ptp_clock_event event;
+
+	event.type = PTP_CLOCK_PPS;
+
+	/* this check is necessary in case the interrupt was enabled via some
+	 * alternative means (ex. debug_fs). Better to check here than
+	 * everywhere that calls this function.
+	 */
+	if (!adapter->ptp_clock)
+		return;
+
+	/* we don't config PPS on SDP yet, so just return.
+	 * ptp_clock_event(adapter->ptp_clock, &event);
+	 */
+}
+
+/**
+ * txgbe_ptp_overflow_check - watchdog task to detect SYSTIME overflow
+ * @adapter: private adapter struct
+ *
+ * this watchdog task periodically reads the timecounter
+ * in order to prevent missing when the system time registers wrap
+ * around. This needs to be run approximately twice a minute for the fastest
+ * overflowing hardware. We run it for all hardware since it shouldn't have a
+ * large impact.
+ */
+void txgbe_ptp_overflow_check(struct txgbe_adapter *adapter)
+{
+	bool timeout = time_is_before_jiffies(adapter->last_overflow_check +
+					      TXGBE_OVERFLOW_PERIOD);
+	struct timespec64 ts;
+
+	if (timeout) {
+		txgbe_ptp_gettime64(&adapter->ptp_caps, &ts);
+		adapter->last_overflow_check = jiffies;
+	}
+}
+
+/**
+ * txgbe_ptp_rx_hang - detect error case when Rx timestamp registers latched
+ * @adapter: private network adapter structure
+ *
+ * this watchdog task is scheduled to detect error case where hardware has
+ * dropped an Rx packet that was timestamped when the ring is full. The
+ * particular error is rare but leaves the device in a state unable to timestamp
+ * any future packets.
+ */
+void txgbe_ptp_rx_hang(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_ring *rx_ring;
+	u32 tsyncrxctl = rd32(hw, TXGBE_PSR_1588_CTL);
+	unsigned long rx_event;
+	int n;
+
+	/* if we don't have a valid timestamp in the registers, just update the
+	 * timeout counter and exit
+	 */
+	if (!(tsyncrxctl & TXGBE_PSR_1588_CTL_VALID)) {
+		adapter->last_rx_ptp_check = jiffies;
+		return;
+	}
+
+	/* determine the most recent watchdog or rx_timestamp event */
+	rx_event = adapter->last_rx_ptp_check;
+	for (n = 0; n < adapter->num_rx_queues; n++) {
+		rx_ring = adapter->rx_ring[n];
+		if (time_after(rx_ring->last_rx_timestamp, rx_event))
+			rx_event = rx_ring->last_rx_timestamp;
+	}
+
+	/* only need to read the high RXSTMP register to clear the lock */
+	if (time_is_before_jiffies(rx_event + 5 * HZ)) {
+		rd32(hw, TXGBE_PSR_1588_STMPH);
+		adapter->last_rx_ptp_check = jiffies;
+
+		adapter->rx_hwtstamp_cleared++;
+		txgbe_warn(drv, "clearing RX Timestamp hang");
+	}
+}
+
+/**
+ * txgbe_ptp_clear_tx_timestamp - utility function to clear Tx timestamp state
+ * @adapter: the private adapter structure
+ *
+ * This function should be called whenever the state related to a Tx timestamp
+ * needs to be cleared. This helps ensure that all related bits are reset for
+ * the next Tx timestamp event.
+ */
+static void txgbe_ptp_clear_tx_timestamp(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	rd32(hw, TXGBE_TSC_1588_STMPH);
+	if (adapter->ptp_tx_skb) {
+		dev_kfree_skb_any(adapter->ptp_tx_skb);
+		adapter->ptp_tx_skb = NULL;
+	}
+	clear_bit_unlock(__TXGBE_PTP_TX_IN_PROGRESS, &adapter->state);
+}
+
+/**
+ * txgbe_ptp_tx_hwtstamp - utility function which checks for TX time stamp
+ * @adapter: the private adapter struct
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the shhwtstamps structure which
+ * is passed up the network stack
+ */
+static void txgbe_ptp_tx_hwtstamp(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct skb_shared_hwtstamps shhwtstamps;
+	u64 regval = 0;
+
+	regval |= (u64)rd32(hw, TXGBE_TSC_1588_STMPL);
+	regval |= (u64)rd32(hw, TXGBE_TSC_1588_STMPH) << 32;
+
+	txgbe_ptp_convert_to_hwtstamp(adapter, &shhwtstamps, regval);
+	skb_tstamp_tx(adapter->ptp_tx_skb, &shhwtstamps);
+
+	txgbe_ptp_clear_tx_timestamp(adapter);
+}
+
+/**
+ * txgbe_ptp_tx_hwtstamp_work
+ * @work: pointer to the work struct
+ *
+ * This work item polls TSYNCTXCTL valid bit to determine when a Tx hardware
+ * timestamp has been taken for the current skb. It is necessary, because the
+ * descriptor's "done" bit does not correlate with the timestamp event.
+ */
+static void txgbe_ptp_tx_hwtstamp_work(struct work_struct *work)
+{
+	struct txgbe_adapter *adapter = container_of(work, struct txgbe_adapter,
+						     ptp_tx_work);
+	struct txgbe_hw *hw = &adapter->hw;
+	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
+					      TXGBE_PTP_TX_TIMEOUT);
+	u32 tsynctxctl;
+
+	/* we have to have a valid skb to poll for a timestamp */
+	if (!adapter->ptp_tx_skb) {
+		txgbe_ptp_clear_tx_timestamp(adapter);
+		return;
+	}
+
+	/* stop polling once we have a valid timestamp */
+	tsynctxctl = rd32(hw, TXGBE_TSC_1588_CTL);
+	if (tsynctxctl & TXGBE_TSC_1588_CTL_VALID) {
+		txgbe_ptp_tx_hwtstamp(adapter);
+		return;
+	}
+
+	/* check timeout last in case timestamp event just occurred */
+	if (timeout) {
+		txgbe_ptp_clear_tx_timestamp(adapter);
+		adapter->tx_hwtstamp_timeouts++;
+		txgbe_warn(drv, "clearing Tx Timestamp hang");
+	} else {
+		/* reschedule to keep checking until we timeout */
+		schedule_work(&adapter->ptp_tx_work);
+	}
+}
+
+/**
+ * txgbe_ptp_rx_rgtstamp - utility function which checks for RX time stamp
+ * @q_vector: structure containing interrupt and ring information
+ * @skb: particular skb to send timestamp with
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the shhwtstamps structure which
+ * is passed up the network stack
+ */
+void txgbe_ptp_rx_hwtstamp(struct txgbe_adapter *adapter, struct sk_buff *skb)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u64 regval = 0;
+	u32 tsyncrxctl;
+
+	/* Read the tsyncrxctl register afterwards in order to prevent taking an
+	 * I/O hit on every packet.
+	 */
+	tsyncrxctl = rd32(hw, TXGBE_PSR_1588_CTL);
+	if (!(tsyncrxctl & TXGBE_PSR_1588_CTL_VALID))
+		return;
+
+	regval |= (u64)rd32(hw, TXGBE_PSR_1588_STMPL);
+	regval |= (u64)rd32(hw, TXGBE_PSR_1588_STMPH) << 32;
+
+	txgbe_ptp_convert_to_hwtstamp(adapter, skb_hwtstamps(skb), regval);
+}
+
+/**
+ * txgbe_ptp_get_ts_config - get current hardware timestamping configuration
+ * @adapter: pointer to adapter structure
+ * @ifreq: ioctl data
+ *
+ * This function returns the current timestamping settings. Rather than
+ * attempt to deconstruct registers to fill in the values, simply keep a copy
+ * of the old settings around, and return a copy when requested.
+ */
+int txgbe_ptp_get_ts_config(struct txgbe_adapter *adapter, struct ifreq *ifr)
+{
+	struct hwtstamp_config *config = &adapter->tstamp_config;
+
+	return copy_to_user(ifr->ifr_data, config,
+			    sizeof(*config)) ? -EFAULT : 0;
+}
+
+/**
+ * txgbe_ptp_set_timestamp_mode - setup the hardware for the requested mode
+ * @adapter: the private txgbe adapter structure
+ * @config: the hwtstamp configuration requested
+ *
+ * Outgoing time stamping can be enabled and disabled. Play nice and
+ * disable it when requested, although it shouldn't cause any overhead
+ * when no packet needs it. At most one packet in the queue may be
+ * marked for time stamping, otherwise it would be impossible to tell
+ * for sure to which packet the hardware time stamp belongs.
+ *
+ * Incoming time stamping has to be configured via the hardware
+ * filters. Not all combinations are supported, in particular event
+ * type has to be specified. Matching the kind of event packet is
+ * not supported, with the exception of "all V2 events regardless of
+ * level 2 or 4".
+ *
+ * Since hardware always timestamps Path delay packets when timestamping V2
+ * packets, regardless of the type specified in the register, only use V2
+ * Event mode. This more accurately tells the user what the hardware is going
+ * to do anyways.
+ *
+ * Note: this may modify the hwtstamp configuration towards a more general
+ * mode, if required to support the specifically requested mode.
+ */
+static int txgbe_ptp_set_timestamp_mode(struct txgbe_adapter *adapter,
+					struct hwtstamp_config *config)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 tsync_tx_ctl = TXGBE_TSC_1588_CTL_ENABLED;
+	u32 tsync_rx_ctl = TXGBE_PSR_1588_CTL_ENABLED;
+	u32 tsync_rx_mtrl = PTP_EV_PORT << 16;
+	bool is_l2 = false;
+	u32 regval;
+
+	/* reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		tsync_tx_ctl = 0;
+	case HWTSTAMP_TX_ON:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		tsync_rx_ctl = 0;
+		tsync_rx_mtrl = 0;
+		adapter->flags &= ~(TXGBE_FLAG_RX_HWTSTAMP_ENABLED |
+				    TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+		tsync_rx_ctl |= TXGBE_PSR_1588_CTL_TYPE_L4_V1;
+		tsync_rx_mtrl |= TXGBE_PSR_1588_MSGTYPE_V1_SYNC_MSG;
+		adapter->flags |= (TXGBE_FLAG_RX_HWTSTAMP_ENABLED |
+				   TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		tsync_rx_ctl |= TXGBE_PSR_1588_CTL_TYPE_L4_V1;
+		tsync_rx_mtrl |= TXGBE_PSR_1588_MSGTYPE_V1_DELAY_REQ_MSG;
+		adapter->flags |= (TXGBE_FLAG_RX_HWTSTAMP_ENABLED |
+				   TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER);
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		tsync_rx_ctl |= TXGBE_PSR_1588_CTL_TYPE_EVENT_V2;
+		is_l2 = true;
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		adapter->flags |= (TXGBE_FLAG_RX_HWTSTAMP_ENABLED |
+				   TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_ALL:
+	default:
+		/* register RXMTRL must be set in order to do V1 packets,
+		 * therefore it is not possible to time stamp both V1 Sync and
+		 * Delay_Req messages unless hardware supports timestamping all
+		 * packets => return error
+		 */
+		adapter->flags &= ~(TXGBE_FLAG_RX_HWTSTAMP_ENABLED |
+				    TXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER);
+		config->rx_filter = HWTSTAMP_FILTER_NONE;
+		return -ERANGE;
+	}
+
+	/* define ethertype filter for timestamping L2 packets */
+	if (is_l2)
+		wr32(hw,
+		     TXGBE_PSR_ETYPE_SWC(TXGBE_PSR_ETYPE_SWC_FILTER_1588),
+		     (TXGBE_PSR_ETYPE_SWC_FILTER_EN | /* enable filter */
+		      TXGBE_PSR_ETYPE_SWC_1588 | /* enable timestamping */
+		      ETH_P_1588));     /* 1588 eth protocol type */
+	else
+		wr32(hw,
+		     TXGBE_PSR_ETYPE_SWC(TXGBE_PSR_ETYPE_SWC_FILTER_1588),
+		     0);
+
+	/* enable/disable TX */
+	regval = rd32(hw, TXGBE_TSC_1588_CTL);
+	regval &= ~TXGBE_TSC_1588_CTL_ENABLED;
+	regval |= tsync_tx_ctl;
+	wr32(hw, TXGBE_TSC_1588_CTL, regval);
+
+	/* enable/disable RX */
+	regval = rd32(hw, TXGBE_PSR_1588_CTL);
+	regval &= ~(TXGBE_PSR_1588_CTL_ENABLED | TXGBE_PSR_1588_CTL_TYPE_MASK);
+	regval |= tsync_rx_ctl;
+	wr32(hw, TXGBE_PSR_1588_CTL, regval);
+
+	/* define which PTP packets are time stamped */
+	wr32(hw, TXGBE_PSR_1588_MSGTYPE, tsync_rx_mtrl);
+
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* clear TX/RX timestamp state, just to be sure */
+	txgbe_ptp_clear_tx_timestamp(adapter);
+	rd32(hw, TXGBE_PSR_1588_STMPH);
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_set_ts_config - user entry point for timestamp mode
+ * @adapter: pointer to adapter struct
+ * @ifreq: ioctl data
+ *
+ * Set hardware to requested mode. If unsupported, return an error with no
+ * changes. Otherwise, store the mode for future reference.
+ */
+int txgbe_ptp_set_ts_config(struct txgbe_adapter *adapter, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	int err;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = txgbe_ptp_set_timestamp_mode(adapter, &config);
+	if (err)
+		return err;
+
+	/* save these settings for future reference */
+	memcpy(&adapter->tstamp_config, &config,
+	       sizeof(adapter->tstamp_config));
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static void txgbe_ptp_link_speed_adjust(struct txgbe_adapter *adapter,
+					u32 *shift, u32 *incval)
+{
+	/**
+	 * Scale the NIC cycle counter by a large factor so that
+	 * relatively small corrections to the frequency can be added
+	 * or subtracted. The drawbacks of a large factor include
+	 * (a) the clock register overflows more quickly, (b) the cycle
+	 * counter structure must be able to convert the systime value
+	 * to nanoseconds using only a multiplier and a right-shift,
+	 * and (c) the value must fit within the timinca register space
+	 * => math based on internal DMA clock rate and available bits
+	 *
+	 * Note that when there is no link, internal DMA clock is same as when
+	 * link speed is 10Gb. Set the registers correctly even when link is
+	 * down to preserve the clock setting
+	 */
+	switch (adapter->link_speed) {
+	case TXGBE_LINK_SPEED_10_FULL:
+		*shift = TXGBE_INCVAL_SHIFT_10;
+		*incval = TXGBE_INCVAL_10;
+		break;
+	case TXGBE_LINK_SPEED_100_FULL:
+		*shift = TXGBE_INCVAL_SHIFT_100;
+		*incval = TXGBE_INCVAL_100;
+		break;
+	case TXGBE_LINK_SPEED_1GB_FULL:
+		*shift = TXGBE_INCVAL_SHIFT_1GB;
+		*incval = TXGBE_INCVAL_1GB;
+		break;
+	case TXGBE_LINK_SPEED_10GB_FULL:
+	default: /* TXGBE_LINK_SPEED_10GB_FULL */
+		*shift = TXGBE_INCVAL_SHIFT_10GB;
+		*incval = TXGBE_INCVAL_10GB;
+		break;
+	}
+}
+
+/**
+ * txgbe_ptp_start_cyclecounter - create the cycle counter from hw
+ * @adapter: pointer to the adapter structure
+ *
+ * This function should be called to set the proper values for the TIMINCA
+ * register and tell the cyclecounter structure what the tick rate of SYSTIME
+ * is. It does not directly modify SYSTIME registers or the timecounter
+ * structure. It should be called whenever a new TIMINCA value is necessary,
+ * such as during initialization or when the link speed changes.
+ */
+void txgbe_ptp_start_cyclecounter(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	unsigned long flags;
+	struct cyclecounter cc;
+	u32 incval = 0;
+
+	/* For some of the boards below this mask is technically incorrect.
+	 * The timestamp mask overflows at approximately 61bits. However the
+	 * particular hardware does not overflow on an even bitmask value.
+	 * Instead, it overflows due to conversion of upper 32bits billions of
+	 * cycles. Timecounters are not really intended for this purpose so
+	 * they do not properly function if the overflow point isn't 2^N-1.
+	 * However, the actual SYSTIME values in question take ~138 years to
+	 * overflow. In practice this means they won't actually overflow. A
+	 * proper fix to this problem would require modification of the
+	 * timecounter delta calculations.
+	 */
+	cc.mask = CLOCKSOURCE_MASK(64);
+	cc.mult = 1;
+	cc.shift = 0;
+
+	cc.read = txgbe_ptp_read;
+	txgbe_ptp_link_speed_adjust(adapter, &cc.shift, &incval);
+	wr32(hw, TXGBE_TSC_1588_INC,
+	     TXGBE_TSC_1588_INC_IVP(incval, 2));
+
+	/* update the base incval used to calculate frequency adjustment */
+	WRITE_ONCE(adapter->base_incval, incval);
+	smp_mb();
+
+	/* need lock to prevent incorrect read while modifying cyclecounter */
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	memcpy(&adapter->hw_cc, &cc, sizeof(adapter->hw_cc));
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+}
+
+/**
+ * txgbe_ptp_reset
+ * @adapter: the txgbe private board structure
+ *
+ * When the MAC resets, all of the hardware configuration for timesync is
+ * reset. This function should be called to re-enable the device for PTP,
+ * using the last known settings. However, we do lose the current clock time,
+ * so we fallback to resetting it based on the kernel's realtime clock.
+ *
+ * This function will maintain the hwtstamp_config settings, and it retriggers
+ * the SDP output if it's enabled.
+ */
+void txgbe_ptp_reset(struct txgbe_adapter *adapter)
+{
+	unsigned long flags;
+
+	/* reset the hardware timestamping mode */
+	txgbe_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
+	txgbe_ptp_start_cyclecounter(adapter);
+
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	timecounter_init(&adapter->hw_tc, &adapter->hw_cc,
+			 ktime_to_ns(ktime_get_real()));
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	adapter->last_overflow_check = jiffies;
+}
+
+/**
+ * txgbe_ptp_create_clock
+ * @adapter: the txgbe private adapter structure
+ *
+ * This function performs setup of the user entry point function table and
+ * initalizes the PTP clock device used by userspace to access the clock-like
+ * features of the PTP core. It will be called by txgbe_ptp_init, and may
+ * re-use a previously initialized clock (such as during a suspend/resume
+ * cycle).
+ */
+
+static long txgbe_ptp_create_clock(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	long err;
+
+	/* do nothing if we already have a clock device */
+	if (!IS_ERR_OR_NULL(adapter->ptp_clock))
+		return 0;
+
+	snprintf(adapter->ptp_caps.name, sizeof(adapter->ptp_caps.name),
+		 "%s", netdev->name);
+	adapter->ptp_caps.owner = THIS_MODULE;
+	adapter->ptp_caps.max_adj = 250000000; /* 10^-9s */
+	adapter->ptp_caps.n_alarm = 0;
+	adapter->ptp_caps.n_ext_ts = 0;
+	adapter->ptp_caps.n_per_out = 0;
+	adapter->ptp_caps.pps = 0;
+	adapter->ptp_caps.adjfreq = txgbe_ptp_adjfreq;
+	adapter->ptp_caps.adjtime = txgbe_ptp_adjtime;
+	adapter->ptp_caps.gettime64 = txgbe_ptp_gettime64;
+	adapter->ptp_caps.settime64 = txgbe_ptp_settime64;
+
+	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_caps,
+						pci_dev_to_dev(adapter->pdev));
+	if (IS_ERR(adapter->ptp_clock)) {
+		err = PTR_ERR(adapter->ptp_clock);
+		adapter->ptp_clock = NULL;
+		txgbe_dev_err("ptp_clock_register failed\n");
+		return err;
+	}
+
+	txgbe_dev_info("registered PHC device on %s\n", netdev->name);
+
+	/* Set the default timestamp mode to disabled here. We do this in
+	 * create_clock instead of initialization, because we don't want to
+	 * override the previous settings during a suspend/resume cycle.
+	 */
+	adapter->tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
+	adapter->tstamp_config.tx_type = HWTSTAMP_TX_OFF;
+
+	return 0;
+}
+
+/**
+ * txgbe_ptp_init
+ * @adapter: the txgbe private adapter structure
+ *
+ * This function performs the required steps for enabling ptp
+ * support. If ptp support has already been loaded it simply calls the
+ * cyclecounter init routine and exits.
+ */
+void txgbe_ptp_init(struct txgbe_adapter *adapter)
+{
+	/* initialize the spin lock first, since the user might call the clock
+	 * functions any time after we've initialized the ptp clock device.
+	 */
+	spin_lock_init(&adapter->tmreg_lock);
+
+	/* obtain a ptp clock device, or re-use an existing device */
+	if (txgbe_ptp_create_clock(adapter))
+		return;
+
+	/* we have a clock, so we can initialize work for timestamps now */
+	INIT_WORK(&adapter->ptp_tx_work, txgbe_ptp_tx_hwtstamp_work);
+
+	/* reset the ptp related hardware bits */
+	txgbe_ptp_reset(adapter);
+
+	/* enter the TXGBE_PTP_RUNNING state */
+	set_bit(__TXGBE_PTP_RUNNING, &adapter->state);
+}
+
+/**
+ * txgbe_ptp_suspend - stop ptp work items
+ * @adapter: pointer to adapter struct
+ *
+ * This function suspends ptp activity, and prevents more work from being
+ * generated, but does not destroy the clock device.
+ */
+void txgbe_ptp_suspend(struct txgbe_adapter *adapter)
+{
+	/* leave the TXGBE_PTP_RUNNING STATE */
+	if (!test_and_clear_bit(__TXGBE_PTP_RUNNING, &adapter->state))
+		return;
+
+	cancel_work_sync(&adapter->ptp_tx_work);
+	txgbe_ptp_clear_tx_timestamp(adapter);
+}
+
+/**
+ * txgbe_ptp_stop - destroy the ptp_clock device
+ * @adapter: pointer to adapter struct
+ *
+ * Completely destroy the ptp_clock device, and disable all PTP related
+ * features. Intended to be run when the device is being closed.
+ */
+void txgbe_ptp_stop(struct txgbe_adapter *adapter)
+{
+	/* first, suspend ptp activity */
+	txgbe_ptp_suspend(adapter);
+
+	/* now destroy the ptp clock device */
+	if (adapter->ptp_clock) {
+		ptp_clock_unregister(adapter->ptp_clock);
+		adapter->ptp_clock = NULL;
+		txgbe_dev_info("removed PHC on %s\n",
+			       adapter->netdev->name);
+	}
+}
-- 
2.27.0



