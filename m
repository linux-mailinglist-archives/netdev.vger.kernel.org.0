Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0845A5C7C
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiH3HGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiH3HGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:06:17 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19698C2E88
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:06 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843162t2w71riq
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:06:01 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: XBN7tc9DADKqNLRD8sLFSSBNh23vdQIlG1pJfJvvLoUxXagnvwVsBtuykaq3D
        GOfwH+1XyIJL6LAvMbNOKy6v6bAV5mkvj0k2Qn2VKHhBcu23TZ3lU1Y2c8845V0v7WxuwFm
        Uy0GmucxKBOGscDPT0pso/5H6Lauqg72DAudSA/kCrFH84sapCshUM38btbfIvMnrZuuQw7
        mWhVp/0yhdE2o0NwWE9Eb9b0SU56heBSKfvehNFGp08A1m1MyQCXWYHbk/D18/M+xhZr2le
        fF6VrOn87n0yccX7R2Gqeb3ewEaXEe5aWP/wS3y9ZIG9ArFbh6EJ3YHBdi7olrX7M4nHxhS
        2bFN3y3ge24mWAQDGpU1bPhmZYPBdgISWQ2XpPiabafbhHWyd0klKRBDqhwHMsEtQlNCJUs
        ORfzKEanLYY=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 15/16] net: txgbe: Support to get system network statistics
Date:   Tue, 30 Aug 2022 15:04:53 +0800
Message-Id: <20220830070454.146211-16-jiawenwu@trustnetic.com>
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

Support to get system network statistics.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  13 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |   5 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  53 +++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 186 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  90 +++++++++
 6 files changed, 348 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index ef5f86261a45..52a26b5b0ced 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -359,10 +359,20 @@ struct txgbe_adapter {
 	/* TX */
 	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
 
+	u64 restart_queue;
 	u64 lsc_int;
 
 	/* RX */
 	struct txgbe_ring *rx_ring[TXGBE_MAX_RX_QUEUES];
+	u64 hw_csum_rx_error;
+	u64 hw_csum_rx_good;
+	u64 hw_rx_no_dma_resources;
+	u64 rsc_total_count;
+	u64 rsc_total_flush;
+	u64 non_eop_descs;
+	u32 alloc_rx_page_failed;
+	u32 alloc_rx_buff_failed;
+
 	struct txgbe_q_vector *q_vector[MAX_MSIX_Q_VECTORS];
 
 	int num_q_vectors;      /* current number of q_vectors for device */
@@ -372,7 +382,9 @@ struct txgbe_adapter {
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
+	struct txgbe_hw_stats stats;
 
+	u64 tx_busy;
 	unsigned int tx_ring_count;
 	unsigned int rx_ring_count;
 
@@ -452,6 +464,7 @@ void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
 			     struct txgbe_ring *ring);
 void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
 			     struct txgbe_ring *ring);
+void txgbe_update_stats(struct txgbe_adapter *adapter);
 int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 90118d1602c4..561cefd40670 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -52,6 +52,10 @@ static int txgbe_init_hw_dummy(struct txgbe_hw *TUP0)
 	return -EPERM;
 }
 
+static void txgbe_clear_hw_cntrs_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 static void txgbe_get_mac_addr_dummy(struct txgbe_hw *TUP0, u8 *TUP1)
 {
 }
@@ -244,6 +248,7 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw_dummy;
+	mac->ops.clear_hw_cntrs = txgbe_clear_hw_cntrs_dummy;
 	mac->ops.get_mac_addr = txgbe_get_mac_addr_dummy;
 	mac->ops.stop_adapter = txgbe_stop_adapter_dummy;
 	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index b3cb0a846260..3e751a9557f8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -107,6 +107,55 @@ int txgbe_init_hw(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_clear_hw_cntrs - Generic clear hardware counters
+ *  @hw: pointer to hardware structure
+ *
+ *  Clears all hardware statistics counters by reading them from the hardware
+ *  Statistics counters are clear on read.
+ **/
+void txgbe_clear_hw_cntrs(struct txgbe_hw *hw)
+{
+	u16 i = 0;
+
+	rd32(hw, TXGBE_RX_CRC_ERROR_FRAMES_LOW);
+	for (i = 0; i < 8; i++)
+		rd32(hw, TXGBE_RDB_MPCNT(i));
+
+	rd32(hw, TXGBE_RX_LEN_ERROR_FRAMES_LOW);
+	rd32(hw, TXGBE_RDB_LXONTXC);
+	rd32(hw, TXGBE_RDB_LXOFFTXC);
+	rd32(hw, TXGBE_MAC_LXONRXC);
+	rd32(hw, TXGBE_MAC_LXOFFRXC);
+
+	for (i = 0; i < 8; i++) {
+		rd32(hw, TXGBE_RDB_PXONTXC(i));
+		rd32(hw, TXGBE_RDB_PXOFFTXC(i));
+		rd32(hw, TXGBE_MAC_PXONRXC(i));
+		wr32m(hw, TXGBE_MMC_CONTROL,
+		      TXGBE_MMC_CONTROL_UP, i << 16);
+		rd32(hw, TXGBE_MAC_PXOFFRXC);
+	}
+	for (i = 0; i < 8; i++)
+		rd32(hw, TXGBE_RDB_PXON2OFFCNT(i));
+	for (i = 0; i < 128; i++)
+		wr32(hw, TXGBE_PX_MPRC(i), 0);
+
+	rd32(hw, TXGBE_PX_GPRC);
+	rd32(hw, TXGBE_PX_GPTC);
+	rd32(hw, TXGBE_PX_GORC_MSB);
+	rd32(hw, TXGBE_PX_GOTC_MSB);
+
+	rd32(hw, TXGBE_RX_BC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_RX_UNDERSIZE_FRAMES_GOOD);
+	rd32(hw, TXGBE_RX_OVERSIZE_FRAMES_GOOD);
+	rd32(hw, TXGBE_RX_FRAME_CNT_GOOD_BAD_LOW);
+	rd32(hw, TXGBE_TX_FRAME_CNT_GOOD_BAD_LOW);
+	rd32(hw, TXGBE_TX_MC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_TX_BC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_RDM_DRP_PKT);
+}
+
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
  *  @hw: pointer to hardware structure
@@ -1995,6 +2044,7 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw;
+	mac->ops.clear_hw_cntrs = txgbe_clear_hw_cntrs;
 	mac->ops.get_mac_addr = txgbe_get_mac_addr;
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
@@ -3308,6 +3358,9 @@ void txgbe_start_hw(struct txgbe_hw *hw)
 	/* Clear the VLAN filter table */
 	hw->mac.ops.clear_vfta(hw);
 
+	/* Clear statistics registers */
+	hw->mac.ops.clear_hw_cntrs(hw);
+
 	TXGBE_WRITE_FLUSH(hw);
 
 	/* Clear the rate limiters */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 5799838fd10c..d0a6d73e0b28 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -80,6 +80,7 @@ extern struct txgbe_dptype txgbe_ptype_lookup[256];
 u16 txgbe_get_pcie_msix_count(struct txgbe_hw *hw);
 int txgbe_init_hw(struct txgbe_hw *hw);
 void txgbe_start_hw(struct txgbe_hw *hw);
+void txgbe_clear_hw_cntrs(struct txgbe_hw *hw);
 int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
 			  u32 pba_num_size);
 void txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 63c396f8a42d..c27a6a8b609e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -3315,6 +3315,189 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_get_stats64 - Get System Network Statistics
+ * @netdev: network interface device structure
+ * @stats: storage space for 64bit statistics
+ */
+static void txgbe_get_stats64(struct net_device *netdev,
+			      struct rtnl_link_stats64 *stats)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *ring = READ_ONCE(adapter->rx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin_irq(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry_irq(&ring->syncp,
+				 start));
+			stats->rx_packets += packets;
+			stats->rx_bytes   += bytes;
+		}
+	}
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *ring = READ_ONCE(adapter->tx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin_irq(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry_irq(&ring->syncp,
+							   start));
+			stats->tx_packets += packets;
+			stats->tx_bytes   += bytes;
+		}
+	}
+	rcu_read_unlock();
+	/* following stats updated by txgbe_watchdog_subtask() */
+	stats->multicast        = netdev->stats.multicast;
+	stats->rx_errors        = netdev->stats.rx_errors;
+	stats->rx_length_errors = netdev->stats.rx_length_errors;
+	stats->rx_crc_errors    = netdev->stats.rx_crc_errors;
+	stats->rx_missed_errors = netdev->stats.rx_missed_errors;
+}
+
+/**
+ * txgbe_update_stats - Update the board statistics counters.
+ * @adapter: board private structure
+ **/
+void txgbe_update_stats(struct txgbe_adapter *adapter)
+{
+	struct net_device_stats *net_stats = &adapter->netdev->stats;
+	struct txgbe_hw_stats *hwstats = &adapter->stats;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	u64 alloc_rx_page_failed = 0, alloc_rx_buff_failed = 0;
+	u64 non_eop_descs = 0, restart_queue = 0, tx_busy = 0;
+	u64 hw_csum_rx_good = 0, hw_csum_rx_error = 0;
+	u32 i, missed_rx = 0, mpc, bprc, lxon, lxoff;
+	u64 bytes = 0, packets = 0;
+	u64 total_mpc = 0;
+
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED) {
+		u64 rsc_count = 0;
+		u64 rsc_flush = 0;
+
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			rsc_count += adapter->rx_ring[i]->rx_stats.rsc_count;
+			rsc_flush += adapter->rx_ring[i]->rx_stats.rsc_flush;
+		}
+		adapter->rsc_total_count = rsc_count;
+		adapter->rsc_total_flush = rsc_flush;
+	}
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *rx_ring = adapter->rx_ring[i];
+
+		non_eop_descs += rx_ring->rx_stats.non_eop_descs;
+		alloc_rx_page_failed += rx_ring->rx_stats.alloc_rx_page_failed;
+		alloc_rx_buff_failed += rx_ring->rx_stats.alloc_rx_buff_failed;
+		hw_csum_rx_error += rx_ring->rx_stats.csum_err;
+		hw_csum_rx_good += rx_ring->rx_stats.csum_good_cnt;
+		bytes += rx_ring->stats.bytes;
+		packets += rx_ring->stats.packets;
+	}
+	adapter->non_eop_descs = non_eop_descs;
+	adapter->alloc_rx_page_failed = alloc_rx_page_failed;
+	adapter->alloc_rx_buff_failed = alloc_rx_buff_failed;
+	adapter->hw_csum_rx_error = hw_csum_rx_error;
+	adapter->hw_csum_rx_good = hw_csum_rx_good;
+	net_stats->rx_bytes = bytes;
+	net_stats->rx_packets = packets;
+
+	bytes = 0;
+	packets = 0;
+	/* gather some stats to the adapter struct that are per queue */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
+
+		restart_queue += tx_ring->tx_stats.restart_queue;
+		tx_busy += tx_ring->tx_stats.tx_busy;
+		bytes += tx_ring->stats.bytes;
+		packets += tx_ring->stats.packets;
+	}
+	adapter->restart_queue = restart_queue;
+	adapter->tx_busy = tx_busy;
+	net_stats->tx_bytes = bytes;
+	net_stats->tx_packets = packets;
+
+	hwstats->crcerrs += rd32(hw, TXGBE_RX_CRC_ERROR_FRAMES_LOW);
+
+	/* 8 register reads */
+	for (i = 0; i < 8; i++) {
+		/* for packet buffers not used, the register should read 0 */
+		mpc = rd32(hw, TXGBE_RDB_MPCNT(i));
+		missed_rx += mpc;
+		hwstats->mpc[i] += mpc;
+		total_mpc += hwstats->mpc[i];
+		hwstats->pxontxc[i] += rd32(hw, TXGBE_RDB_PXONTXC(i));
+		hwstats->pxofftxc[i] += rd32(hw, TXGBE_RDB_PXOFFTXC(i));
+		hwstats->pxonrxc[i] += rd32(hw, TXGBE_MAC_PXONRXC(i));
+	}
+
+	hwstats->gprc += rd32(hw, TXGBE_PX_GPRC);
+
+	hwstats->o2bgptc += rd32(hw, TXGBE_TDM_OS2BMC_CNT);
+	if (txgbe_check_mng_access(&adapter->hw)) {
+		hwstats->o2bspc += rd32(hw, TXGBE_MNG_OS2BMC_CNT);
+		hwstats->b2ospc += rd32(hw, TXGBE_MNG_BMC2OS_CNT);
+	}
+	hwstats->b2ogprc += rd32(hw, TXGBE_RDM_BMC2OS_CNT);
+	hwstats->gorc += rd32(hw, TXGBE_PX_GORC_LSB);
+	hwstats->gorc += (u64)rd32(hw, TXGBE_PX_GORC_MSB) << 32;
+
+	hwstats->gotc += rd32(hw, TXGBE_PX_GOTC_LSB);
+	hwstats->gotc += (u64)rd32(hw, TXGBE_PX_GOTC_MSB) << 32;
+
+	adapter->hw_rx_no_dma_resources += rd32(hw, TXGBE_RDM_DRP_PKT);
+	hwstats->lxonrxc += rd32(hw, TXGBE_MAC_LXONRXC);
+
+	bprc = rd32(hw, TXGBE_RX_BC_FRAMES_GOOD_LOW);
+	hwstats->bprc += bprc;
+	hwstats->mprc = 0;
+
+	for (i = 0; i < 128; i++)
+		hwstats->mprc += rd32(hw, TXGBE_PX_MPRC(i));
+
+	hwstats->roc += rd32(hw, TXGBE_RX_OVERSIZE_FRAMES_GOOD);
+	hwstats->rlec += rd32(hw, TXGBE_RX_LEN_ERROR_FRAMES_LOW);
+	lxon = rd32(hw, TXGBE_RDB_LXONTXC);
+	hwstats->lxontxc += lxon;
+	lxoff = rd32(hw, TXGBE_RDB_LXOFFTXC);
+	hwstats->lxofftxc += lxoff;
+
+	hwstats->gptc += rd32(hw, TXGBE_PX_GPTC);
+	hwstats->mptc += rd32(hw, TXGBE_TX_MC_FRAMES_GOOD_LOW);
+	hwstats->ruc += rd32(hw, TXGBE_RX_UNDERSIZE_FRAMES_GOOD);
+	hwstats->tpr += rd32(hw, TXGBE_RX_FRAME_CNT_GOOD_BAD_LOW);
+	hwstats->bptc += rd32(hw, TXGBE_TX_BC_FRAMES_GOOD_LOW);
+	/* Fill out the OS statistics structure */
+	net_stats->multicast = hwstats->mprc;
+
+	/* Rx Errors */
+	net_stats->rx_errors = hwstats->crcerrs + hwstats->rlec;
+	net_stats->rx_dropped = 0;
+	net_stats->rx_length_errors = hwstats->rlec;
+	net_stats->rx_crc_errors = hwstats->crcerrs;
+	net_stats->rx_missed_errors = total_mpc;
+}
+
 /**
  * txgbe_watchdog_update_link - update the link status
  * @adapter: pointer to the device adapter structure
@@ -3485,6 +3668,8 @@ static void txgbe_watchdog_subtask(struct txgbe_adapter *adapter)
 	else
 		txgbe_watchdog_link_is_down(adapter);
 
+	txgbe_update_stats(adapter);
+
 	txgbe_watchdog_flush_tx(adapter);
 }
 
@@ -4702,6 +4887,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_change_mtu		= txgbe_change_mtu,
 	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
+	.ndo_get_stats64        = txgbe_get_stats64,
 	.ndo_features_check     = txgbe_features_check,
 	.ndo_set_features       = txgbe_set_features,
 	.ndo_fix_features       = txgbe_fix_features,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 5a2b0183d94b..a78cf6e9dcfa 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -463,6 +463,16 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_TDM_RP_RATE_MIN(v) ((0x3FFF & (v)))
 #define TXGBE_TDM_RP_RATE_MAX(v) ((0x3FFF & (v)) << 16)
 
+/* statistic */
+#define TXGBE_TDM_SEC_DRP       0x18304
+#define TXGBE_TDM_PKT_CNT       0x18308
+#define TXGBE_TDM_OS2BMC_CNT    0x18314
+
+/**************************** Receive DMA registers **************************/
+/* statistic */
+#define TXGBE_RDM_DRP_PKT           0x12500
+#define TXGBE_RDM_BMC2OS_CNT        0x12510
+
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
 #define TXGBE_RDB_PB_WRAP           0x19004
@@ -888,6 +898,18 @@ enum {
 #define TXGBE_PX_RR_CFG_RR_SZ           0x0000007EU
 #define TXGBE_PX_RR_CFG_RR_EN           0x00000001U
 
+/* statistic */
+#define TXGBE_PX_MPRC(_i)               (0x1020 + ((_i) * 64))
+
+#define TXGBE_PX_GPRC                   0x12504
+#define TXGBE_PX_GPTC                   0x18308
+
+#define TXGBE_PX_GORC_LSB               0x12508
+#define TXGBE_PX_GORC_MSB               0x1250C
+
+#define TXGBE_PX_GOTC_LSB               0x1830C
+#define TXGBE_PX_GOTC_MSB               0x18310
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH     32
 
@@ -1325,6 +1347,73 @@ struct txgbe_bus_info {
 	u16 lan_id;
 };
 
+/* Statistics counters collected by the MAC */
+struct txgbe_hw_stats {
+	u64 crcerrs;
+	u64 illerrc;
+	u64 errbc;
+	u64 mspdc;
+	u64 mpctotal;
+	u64 mpc[8];
+	u64 mlfc;
+	u64 mrfc;
+	u64 rlec;
+	u64 lxontxc;
+	u64 lxonrxc;
+	u64 lxofftxc;
+	u64 lxoffrxc;
+	u64 pxontxc[8];
+	u64 pxonrxc[8];
+	u64 pxofftxc[8];
+	u64 pxoffrxc[8];
+	u64 prc64;
+	u64 prc127;
+	u64 prc255;
+	u64 prc511;
+	u64 prc1023;
+	u64 prc1522;
+	u64 gprc;
+	u64 bprc;
+	u64 mprc;
+	u64 gptc;
+	u64 gorc;
+	u64 gotc;
+	u64 rnbc[8];
+	u64 ruc;
+	u64 rfc;
+	u64 roc;
+	u64 rjc;
+	u64 mngprc;
+	u64 mngpdc;
+	u64 mngptc;
+	u64 tor;
+	u64 tpr;
+	u64 tpt;
+	u64 ptc64;
+	u64 ptc127;
+	u64 ptc255;
+	u64 ptc511;
+	u64 ptc1023;
+	u64 ptc1522;
+	u64 mptc;
+	u64 bptc;
+	u64 xec;
+	u64 qprc[16];
+	u64 qptc[16];
+	u64 qbrc[16];
+	u64 qbtc[16];
+	u64 qprdc[16];
+	u64 pxon2offc[8];
+	u64 fccrc;
+	u64 fclast;
+	u64 ldpcec;
+	u64 pcrc8ec;
+	u64 b2ospc;
+	u64 b2ogprc;
+	u64 o2bgptc;
+	u64 o2bspc;
+};
+
 /* forward declaration */
 struct txgbe_hw;
 
@@ -1346,6 +1435,7 @@ struct txgbe_mac_operations {
 	int (*init_hw)(struct txgbe_hw *hw);
 	int (*reset_hw)(struct txgbe_hw *hw);
 	void (*start_hw)(struct txgbe_hw *hw);
+	void (*clear_hw_cntrs)(struct txgbe_hw *hw);
 	void (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
 	void (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
 	void (*get_wwn_prefix)(struct txgbe_hw *hw, u16 *wwnn_prefix,
-- 
2.27.0

