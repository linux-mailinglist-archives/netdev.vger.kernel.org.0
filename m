Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9C602036
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiJRBJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJRBJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:09:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2471C7E
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666055364; x=1697591364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mMYZxYLtzUA09HyM2zDBclV5nMXSW/0b/hFR6Na8RrU=;
  b=jybIy92kO01BD3WY0n5Zczx0tbSsgRpQ9ugv6YshYaspNM9Ggq+AdDKq
   LpnyeglQCKdOuzllnDLAWYtDrVxzSnIWONQb0gPabRfwo7flilygE6sbs
   P8UW6MEnv+rcNcfbAoU26amqKe3FxIXgyWylCUf8D1is23q6tWwtwyVjc
   bl69kUXS0yoCj5qQzsxXyzf50qO8gejlS9kPZGldEmcsJFhOqjOnWMucu
   9cY0jdYJkioygKmfoFrH3lVpEb99FUcf0Bxf2m1+FOQM9XIdSCYRHTI2r
   9dlHfLW0YNxWiqnNtp79M7LenJiES7q6OgTIydlCuT1eoP6rb33Ny2YA3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="392264207"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="392264207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:09:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717704456"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="717704456"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2022 18:09:15 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        muhammad.husaini.zulkifli@intel.com, vinicius.gomes@intel.com
Subject: [PATCH v2 4/5] igc: Add support for DMA timestamp for non-PTP packets
Date:   Tue, 18 Oct 2022 09:07:32 +0800
Message-Id: <20221018010733.4765-5-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

For PTP traffic, timestamp is retrieved from TXSTMP register.
For all other packets, DMA time stamp field of the Transmit
Descriptor Write-back is used.

If the TXSTAMPO register is used for both PTP and non-PTP packets,
there is a significant possibility that the time stamp for a PTP packet
will be lost when there is a lot of traffic.

This patch introduce to use the DMA Time Stamp for non PTP packet to
solve the current issue. User application can add new SOF_TIMESTAMPING flag
SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH when configure the
hwtstamp_config for the socket option if require DMA Time Stamp.

Before:

ptp4l: rms    2 max    5 freq  -3404 +/-   3 delay     1 +/-   0
ptp4l: rms    3 max    6 freq  -3400 +/-   3 delay     1 +/-   0
ptp4l: rms    2 max    4 freq  -3400 +/-   3 delay     1 +/-   0
ptp4l: timed out while polling for tx timestamp
ptp4l: increasing tx_timestamp_timeout may correct this issue,
but it is likely caused by a driver bug
ptp4l: port 1 (enp170s0.vlan): send peer delay response failed
ptp4l: port 1 (enp170s0.vlan): SLAVE to FAULTY on FAULT_DETECTED
ptp4l: port 1 (enp170s0.vlan): FAULTY to LISTENING on INIT_COMPLETE
ptp4l: port 1 (enp170s0.vlan): LISTENING to MASTER on
ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l: selected local clock aa00aa.fffe.00aa00 as best master
ptp4l: port 1 (enp170s0.vlan): assuming the grand master role
ptp4l: port 1 (enp170s0.vlan): new foreign master 22bb22.fffe.bb22bb-1
ptp4l: selected best master clock 22bb22.fffe.bb22bb
ptp4l: port 1 (enp170s0.vlan): MASTER to UNCALIBRATED on RS_SLAVE
ptp4l: port 1 (enp170s0.vlan): UNCALIBRATED to SLAVE on
MASTER_CLOCK_SELECTED
ptp4l: rms   39 max   66 freq  -3355 +/-  45 delay     1 +/-   0
ptp4l: rms   20 max   36 freq  -3339 +/-  12 delay     1 +/-   0
ptp4l: rms   11 max   18 freq  -3371 +/-  11 delay     1 +/-   0
ptp4l: rms   10 max   16 freq  -3384 +/-   2 delay     1 +/-   0
ptp4l: rms    1 max    2 freq  -3375 +/-   2 delay     1 +/-   0
ptp4l: rms    3 max    6 freq  -3373 +/-   4 delay     0 +/-   0

After:

ptp4l: rms    3 max    4 freq  -3386 +/-   4 delay     0 +/-   0
ptp4l: rms    3 max    7 freq  -3380 +/-   3 delay     0 +/-   0
ptp4l: rms    3 max    6 freq  -3380 +/-   3 delay     0 +/-   0
ptp4l: rms    1 max    3 freq  -3381 +/-   2 delay     0 +/-   0
ptp4l: rms    3 max    5 freq  -3377 +/-   2 delay     0 +/-   0
ptp4l: rms    2 max    3 freq  -3377 +/-   2 delay     0 +/-   0
ptp4l: rms    3 max    6 freq  -3375 +/-   4 delay     0 +/-   0
ptp4l: rms    2 max    4 freq  -3380 +/-   2 delay     1 +/-   0
ptp4l: rms    4 max    7 freq  -3385 +/-   3 delay     0 +/-   0
ptp4l: rms    2 max    3 freq  -3384 +/-   2 delay     0 +/-   0
ptp4l: rms    4 max    7 freq  -3376 +/-   2 delay     0 +/-   0
ptp4l: rms    3 max    5 freq  -3376 +/-   4 delay     0 +/-   0
ptp4l: rms    3 max    5 freq  -3382 +/-   2 delay     0 +/-   0
ptp4l: rms    5 max    7 freq  -3389 +/-   2 delay     0 +/-   0
ptp4l: rms    3 max    4 freq  -3388 +/-   3 delay     1 +/-   0
ptp4l: rms    3 max    5 freq  -3387 +/-   4 delay     1 +/-   0
ptp4l: rms    5 max    8 freq  -3395 +/-   3 delay     1 +/-   0
ptp4l: rms    5 max    8 freq  -3399 +/-   4 delay     0 +/-   0
ptp4l: rms    2 max    5 freq  -3397 +/-   3 delay     1 +/-   0
ptp4l: rms    2 max    4 freq  -3397 +/-   3 delay     1 +/-   0
ptp4l: rms    2 max    3 freq  -3397 +/-   2 delay     1 +/-   0
ptp4l: rms    3 max    5 freq  -3391 +/-   2 delay     2 +/-   0

Test Setup:
back-to-back communication between Host and DUT. Host will act as
transmitter and DUT will become receiver. Host will generate the
packet using sample application with timestamping_flag of
SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH and hwtstamp_config flag of
HWTSTAMP_FLAG_DMA_TIMESTAMP.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Co-developed-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Co-developed-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         | 10 +++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  5 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 24 ++++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 83 ++++++++++++++++++++
 6 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 1e7e7071f64d..38a24b5260d1 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -348,6 +348,12 @@ extern char igc_driver_name[];
 #define IGC_I225_RX_LATENCY_1000	300
 #define IGC_I225_RX_LATENCY_2500	1485
 
+/* Transmit latency (for DMA timestamps) in nanosecond */
+#define IGC_I225_TX_DMA_LATENCY_10	13100
+#define IGC_I225_TX_DMA_LATENCY_100	1410
+#define IGC_I225_TX_DMA_LATENCY_1000	285
+#define IGC_I225_TX_DMA_LATENCY_2500	1485
+
 /* RX and TX descriptor control thresholds.
  * PTHRESH - MAC will consider prefetch if it has fewer than this number of
  *           descriptors available in its onboard memory.
@@ -410,6 +416,8 @@ enum igc_tx_flags {
 	/* olinfo flags */
 	IGC_TX_FLAGS_IPV4	= 0x10,
 	IGC_TX_FLAGS_CSUM	= 0x20,
+
+	IGC_TX_FLAGS_DMA_TSTAMP	= 0x200,
 };
 
 enum igc_boards {
@@ -627,6 +635,8 @@ void igc_ptp_reset(struct igc_adapter *adapter);
 void igc_ptp_suspend(struct igc_adapter *adapter);
 void igc_ptp_stop(struct igc_adapter *adapter);
 ktime_t igc_ptp_rx_pktstamp(struct igc_adapter *adapter, __le32 *buf);
+void igc_ptp_tx_dma_tstamp(struct igc_adapter *adapter,
+			   struct sk_buff *skb, u64 tstamp);
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index ce530f5fd7bd..672cf2d92165 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -16,7 +16,7 @@ union igc_adv_tx_desc {
 		__le32 olinfo_status;
 	} read;
 	struct {
-		__le64 rsvd;       /* Reserved */
+		__le64 dma_tstamp;
 		__le32 nxtseq_seed;
 		__le32 status;
 	} wb;
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f7311aeb293b..baedf48b4e2e 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -312,6 +312,7 @@
 #define IGC_TXD_CMD_DEXT	0x20000000 /* Desc extension (0 = legacy) */
 #define IGC_TXD_CMD_VLE		0x40000000 /* Add VLAN tag */
 #define IGC_TXD_STAT_DD		0x00000001 /* Descriptor Done */
+#define IGC_TXD_STAT_TS_STAT    0x00000002 /* DMA Timestamp in packet */
 #define IGC_TXD_CMD_TCP		0x01000000 /* TCP packet */
 #define IGC_TXD_CMD_IP		0x02000000 /* IP packet */
 #define IGC_TXD_CMD_TSE		0x04000000 /* TCP Seg enable */
@@ -520,6 +521,7 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_1588_STAT_EN	0x00000004
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..7d198fb6d619 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1532,7 +1532,8 @@ static int igc_ethtool_get_ts_info(struct net_device *dev,
 			SOF_TIMESTAMPING_SOFTWARE |
 			SOF_TIMESTAMPING_TX_HARDWARE |
 			SOF_TIMESTAMPING_RX_HARDWARE |
-			SOF_TIMESTAMPING_RAW_HARDWARE;
+			SOF_TIMESTAMPING_RAW_HARDWARE |
+			SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH;
 
 		info->tx_types =
 			BIT(HWTSTAMP_TX_OFF) |
@@ -1541,6 +1542,8 @@ static int igc_ethtool_get_ts_info(struct net_device *dev,
 		info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
 		info->rx_filters |= BIT(HWTSTAMP_FILTER_ALL);
 
+		info->flag = HWTSTAMP_FLAG_DMA_TIMESTAMP;
+
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 671255edf3c2..daa6ca5acab3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1415,6 +1415,7 @@ static int igc_tso(struct igc_ring *tx_ring,
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
+	struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
 	u16 count = TXD_USE_COUNT(skb_headlen(skb));
 	__be16 protocol = vlan_get_protocol(skb);
 	struct igc_tx_buffer *first;
@@ -1445,16 +1446,14 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
-
+	if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+		     !(skb_shinfo(skb)->tx_flags & SKBTX_HW_DMA_TSTAMP))) {
 		/* FIXME: add support for retrieving timestamps from
 		 * the other timer registers before skipping the
 		 * timestamping request.
 		 */
 		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
-		    !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
-					   &adapter->state)) {
+		    !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))	{
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= IGC_TX_FLAGS_TSTAMP;
 
@@ -1463,6 +1462,14 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		} else {
 			adapter->tx_hwtstamp_skipped++;
 		}
+	} else if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_DMA_TSTAMP)) {
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    adapter->tstamp_config.flags == HWTSTAMP_FLAG_DMA_TIMESTAMP) {
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			tx_flags |= IGC_TX_FLAGS_DMA_TSTAMP;
+		} else {
+			adapter->tx_hwtstamp_skipped++;
+		}
 	}
 
 	if (skb_vlan_tag_present(skb)) {
@@ -2741,6 +2748,13 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 		if (!(eop_desc->wb.status & cpu_to_le32(IGC_TXD_STAT_DD)))
 			break;
 
+		if (eop_desc->wb.status & cpu_to_le32(IGC_TXD_STAT_TS_STAT) &&
+		    tx_buffer->tx_flags & IGC_TX_FLAGS_DMA_TSTAMP) {
+			u64 tstamp = le64_to_cpu(eop_desc->wb.dma_tstamp);
+
+			igc_ptp_tx_dma_tstamp(adapter, tx_buffer->skb, tstamp);
+		}
+
 		/* clear next_to_watch to prevent false hangs */
 		tx_buffer->next_to_watch = NULL;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 8dbb9f903ca7..631972d7e97b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -432,6 +432,29 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
 	}
 }
 
+static void igc_ptp_dma_time_to_hwtstamp(struct igc_adapter *adapter,
+					 struct skb_shared_hwtstamps *hwtstamps,
+					 u64 systim)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 sec, nsec;
+
+	nsec = rd32(IGC_SYSTIML);
+	sec = rd32(IGC_SYSTIMH);
+
+	if (unlikely(nsec < (systim & 0xFFFFFFFF)))
+		--sec;
+
+	switch (adapter->hw.mac.type) {
+	case igc_i225:
+		memset(hwtstamps, 0, sizeof(*hwtstamps));
+		hwtstamps->hwtstamp = ktime_set(sec, systim & 0xFFFFFFFF);
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * igc_ptp_rx_pktstamp - Retrieve timestamp from Rx packet buffer
  * @adapter: Pointer to adapter the packet buffer belongs to
@@ -549,6 +572,28 @@ static void igc_ptp_enable_tx_timestamp(struct igc_adapter *adapter)
 	rd32(IGC_TXSTMPH);
 }
 
+static void igc_ptp_disable_dma_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 tqavctrl;
+
+	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl &= ~IGC_TQAVCTRL_1588_STAT_EN;
+
+	wr32(IGC_TQAVCTRL, tqavctrl);
+}
+
+static void igc_ptp_enable_dma_timestamp(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 tqavctrl;
+
+	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl |= IGC_TQAVCTRL_1588_STAT_EN;
+
+	wr32(IGC_TQAVCTRL, tqavctrl);
+}
+
 /**
  * igc_ptp_set_timestamp_mode - setup hardware for timestamping
  * @adapter: networking device structure
@@ -562,9 +607,14 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		igc_ptp_disable_tx_timestamp(adapter);
+		igc_ptp_disable_dma_timestamp(adapter);
 		break;
 	case HWTSTAMP_TX_ON:
 		igc_ptp_enable_tx_timestamp(adapter);
+
+		/* Ensure that flag only can be used during HWTSTAMP_TX_ON */
+		if (config->flags == HWTSTAMP_FLAG_DMA_TIMESTAMP)
+			igc_ptp_enable_dma_timestamp(adapter);
 		break;
 	default:
 		return -ERANGE;
@@ -683,6 +733,39 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	dev_kfree_skb_any(skb);
 }
 
+void igc_ptp_tx_dma_tstamp(struct igc_adapter *adapter,
+			   struct sk_buff *skb, u64 tstamp)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	int adjust = 0;
+
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
+		return;
+
+	igc_ptp_dma_time_to_hwtstamp(adapter, &shhwtstamps, tstamp);
+
+	switch (adapter->link_speed) {
+	case SPEED_10:
+		adjust = IGC_I225_TX_DMA_LATENCY_10;
+		break;
+	case SPEED_100:
+		adjust = IGC_I225_TX_DMA_LATENCY_100;
+		break;
+	case SPEED_1000:
+		adjust = IGC_I225_TX_DMA_LATENCY_1000;
+		break;
+	case SPEED_2500:
+		adjust = IGC_I225_TX_DMA_LATENCY_2500;
+		break;
+	}
+
+	shhwtstamps.hwtstamp =
+		ktime_add_ns(shhwtstamps.hwtstamp, adjust);
+
+	/* Notify the stack and free the skb after we've unlocked */
+	skb_tstamp_tx(skb, &shhwtstamps);
+}
+
 /**
  * igc_ptp_tx_work
  * @work: pointer to work struct
-- 
2.17.1

