Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B9E6EBDDA
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjDWIEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDWIED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:04:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66CECC;
        Sun, 23 Apr 2023 01:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682237041; x=1713773041;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G0XyZQr0lWt2nCgkhFWbx6CaAVGdFmm8bH/ztlgYvVM=;
  b=mpKFF3JcEy6fKxfTyXRGjIUUIdlVzgLtA3ntvAsmZF/IjhXLuCKCvnQ7
   NFgE/RmvN/r/aP4OqbXLBGoU+BZpzvHUOMbD9f4BgagErXYCpjmBa7Hc7
   bAaqA4UhYNiQFr7kAXVurdZs1b6xkYPJsqNu2eaWq6fRlKRAnyKIWRhup
   c2WV7NP/8rz1sKMmMnryAqhXOkv/uOnZx0gRWvnxxic54Qpvoa74nw7yy
   8yW4pTpnzs8TCs+wpOd0NnE2dq/c3X6fqW/Lnaq8FsvWfuU56PsVjwKfS
   JxuQhoZXhwRZihnd6La1mpS+uN7LsDTdLoY8hvc0SGUFpSxIseCQfmnfB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="409192541"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="409192541"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 01:04:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="725307916"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="725307916"
Received: from dev.xiaoyan.gong (HELO dev.sh.intel.com) ([10.67.103.155])
  by orsmga001.jf.intel.com with ESMTP; 23 Apr 2023 01:03:57 -0700
From:   gongxiao-intel <xiaoyan.gong@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiaoyan.gong@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] igc: enable multiple TXSTMP registers  reporting TX timestamp.
Date:   Sun, 23 Apr 2023 15:53:12 +0800
Message-Id: <20230423075312.544244-1-xiaoyan.gong@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HW TX timestamps created by the NIC via socket options can be
requested using the current network timestamps generation capability of
SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this socket flag
is PTP, however other packet applications that require tx timestamps might
also ask for it.

The problem is that, when there is a lot of traffic, there is a high chance
that the timestamps for a PTP packet will be lost if both PTP and Non-PTP
packets use the same SOF_TIMESTAMPING_TX_HARDWARE causing the tx timeout.

The root cause of this problem is that igc only use one TXSTMP register to
report TX timestamp. Such implementation intensify the race of TX timestamp
query from multiple sockets.

However, Intel i225/i226 controller has 4 TXSTMP registers. This patch fully
utilizes 4 TXSTMP registers to reduce the race of TX timestamp query.

This patch dedicates TXSTMP register 0 to all PTP packets. In most case, only
one PTP sync process will run on a network port. So, one TXSTMP register is
enough for PTP stream.

For TXSTMP register 1 - 3, they are allocated to sockets round robin. And each
socket can only occupy one register at a time. So, at least 3 sockets can requiest
TX timestamp simultaneously.
---
 drivers/net/ethernet/intel/igc/igc.h         | 24 +++--
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 55 +++++++++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 97 +++++++++++++-------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  4 +-
 6 files changed, 129 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index df3e26c0cf01..de5229d35848 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -35,6 +35,8 @@ void igc_ethtool_set_ops(struct net_device *);
 
 #define MAX_FLEX_FILTER			32
 
+#define IGC_N_TXSTAMP	4
+
 enum igc_mac_filter_type {
 	IGC_MAC_FILTER_TYPE_DST = 0,
 	IGC_MAC_FILTER_TYPE_SRC
@@ -227,9 +229,13 @@ struct igc_adapter {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_caps;
 	struct work_struct ptp_tx_work;
-	struct sk_buff *ptp_tx_skb;
+	/* Access to ptp_tx_skb and ptp_tx_start is protected by the
+	 * ptp_tx_lock.
+	 */
+	spinlock_t ptp_tx_lock;
+	struct sk_buff *ptp_tx_skb[IGC_N_TXSTAMP];
 	struct hwtstamp_config tstamp_config;
-	unsigned long ptp_tx_start;
+	unsigned long ptp_tx_start[IGC_N_TXSTAMP];
 	unsigned int ptp_flags;
 	/* System time value lock */
 	spinlock_t tmreg_lock;
@@ -401,19 +407,17 @@ enum igc_state_t {
 	__IGC_TESTING,
 	__IGC_RESETTING,
 	__IGC_DOWN,
-	__IGC_PTP_TX_IN_PROGRESS,
 };
 
-enum igc_tx_flags {
 	/* cmd_type flags */
-	IGC_TX_FLAGS_VLAN	= 0x01,
-	IGC_TX_FLAGS_TSO	= 0x02,
-	IGC_TX_FLAGS_TSTAMP	= 0x04,
+#define	IGC_TX_FLAGS_VLAN	0x01
+#define	IGC_TX_FLAGS_TSO	0x02
+#define	IGC_TX_FLAGS_TSTAMP_MASK	0x0F000
+#define	IGC_TX_FLAGS_TSTAMP(_n)	(0x08000 + (_n << 12))
 
 	/* olinfo flags */
-	IGC_TX_FLAGS_IPV4	= 0x10,
-	IGC_TX_FLAGS_CSUM	= 0x20,
-};
+#define	IGC_TX_FLAGS_IPV4	0x10
+#define	IGC_TX_FLAGS_CSUM	0x20
 
 enum igc_boards {
 	board_base,
diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index 7a992befca24..2a4b871f05b9 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -34,7 +34,7 @@ struct igc_adv_tx_context_desc {
 
 /* Adv Transmit Descriptor Config Masks */
 #define IGC_ADVTXD_MAC_TSTAMP	0x00080000 /* IEEE1588 Timestamp packet */
-#define IGC_ADVTXD_DTYP_CTXT	0x00200000 /* Advanced Context Descriptor */
+#define IGC_ADVTXD_DTYP_CTXT	0x000F0000 /* Advanced Context Descriptor */
 #define IGC_ADVTXD_DTYP_DATA	0x00300000 /* Advanced Data Descriptor */
 #define IGC_ADVTXD_DCMD_EOP	0x01000000 /* End of Packet */
 #define IGC_ADVTXD_DCMD_IFCS	0x02000000 /* Insert FCS (Ethernet CRC) */
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 9dec3563ce3a..21b636c65bf4 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -453,7 +453,7 @@
 #define IGC_IMIREXT_SIZE_BP	0x00001000  /* Packet size bypass */
 
 /* Time Sync Transmit Control bit definitions */
-#define IGC_TSYNCTXCTL_TXTT_0			0x00000001  /* Tx timestamp reg 0 valid */
+#define IGC_TSYNCTXCTL_TXTT(_n)			(0x00000001 << _n)
 #define IGC_TSYNCTXCTL_ENABLED			0x00000010  /* enable Tx timestamping */
 #define IGC_TSYNCTXCTL_MAX_ALLOWED_DLY_MASK	0x0000F000  /* max delay */
 #define IGC_TSYNCTXCTL_SYNC_COMP_ERR		0x20000000  /* sync err */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 25fc6c65209b..7420cbe5ce9d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1237,7 +1237,7 @@ static u32 igc_tx_cmd_type(struct sk_buff *skb, u32 tx_flags)
 				 (IGC_ADVTXD_DCMD_TSE));
 
 	/* set timestamp bit if present */
-	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSTAMP,
+	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSTAMP_MASK,
 				 (IGC_ADVTXD_MAC_TSTAMP));
 
 	/* insert frame checksum */
@@ -1498,6 +1498,14 @@ static int igc_tso(struct igc_ring *tx_ring,
 	return 1;
 }
 
+static bool igc_is_ptp_packet(struct sk_buff *skb)
+{
+	__be16 protocol = vlan_get_protocol(skb);
+
+	/* FIXME: also handle UDP packets */
+	return protocol == htons(ETH_P_1588);
+}
+
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
@@ -1565,22 +1573,51 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+		bool is_ptp = igc_is_ptp_packet(skb);
+		spin_lock(&adapter->ptp_tx_lock);
 
 		/* FIXME: add support for retrieving timestamps from
 		 * the other timer registers before skipping the
 		 * timestamping request.
 		 */
-		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
-		    !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
-					   &adapter->state)) {
-			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-			tx_flags |= IGC_TX_FLAGS_TSTAMP;
-
-			adapter->ptp_tx_skb = skb_get(skb);
-			adapter->ptp_tx_start = jiffies;
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON) {
+			bool is_pending_tstamp = false;
+			int i;
+			int avail_ts_reg = -1;
+
+			if (is_ptp) {
+				if (!adapter->ptp_tx_skb[0]) {
+					avail_ts_reg = 0;
+				} else {
+					is_pending_tstamp = true;
+				}
+			} else {
+				for (i = 1; i < IGC_N_TXSTAMP; i++) {
+					if (adapter->ptp_tx_skb[i]) {
+						if (adapter->ptp_tx_skb[i]->sk == skb->sk) {
+							is_pending_tstamp = true;
+							break;
+						}
+					} else {
+						if (avail_ts_reg == -1)
+							avail_ts_reg = i;
+					}
+				}
+			}
+			if (!is_pending_tstamp && avail_ts_reg != -1) {
+				skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+				tx_flags |= IGC_TX_FLAGS_TSTAMP(avail_ts_reg);
+
+				adapter->ptp_tx_skb[avail_ts_reg] = skb_get(skb);
+				adapter->ptp_tx_start[avail_ts_reg] = jiffies;
+			} else {
+				adapter->tx_hwtstamp_skipped++;
+			}
 		} else {
 			adapter->tx_hwtstamp_skipped++;
 		}
+
+		spin_unlock(&adapter->ptp_tx_lock);
 	}
 
 	if (skb_vlan_tag_present(skb)) {
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 4e10ced736db..b5ffd67ef815 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -545,13 +545,18 @@ static void igc_ptp_disable_tx_timestamp(struct igc_adapter *adapter)
 
 static void igc_ptp_enable_tx_timestamp(struct igc_adapter *adapter)
 {
+	int i;
 	struct igc_hw *hw = &adapter->hw;
 
 	wr32(IGC_TSYNCTXCTL, IGC_TSYNCTXCTL_ENABLED | IGC_TSYNCTXCTL_TXSYNSIG);
 
 	/* Read TXSTMP registers to discard any timestamp previously stored. */
-	rd32(IGC_TXSTMPL);
-	rd32(IGC_TXSTMPH);
+	for (i = 0; i < IGC_N_TXSTAMP; i++) {
+		rd32(IGC_TXSTMPL(i));
+		rd32(IGC_TXSTMPH(i));
+		adapter->ptp_tx_skb[i] = NULL;
+		adapter->ptp_tx_start[i] = 0;
+	}
 }
 
 /**
@@ -603,48 +608,49 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	return 0;
 }
 
-static void igc_ptp_tx_timeout(struct igc_adapter *adapter)
+static void igc_ptp_tx_timeout(struct igc_adapter *adapter, int ts_reg_idx)
 {
 	struct igc_hw *hw = &adapter->hw;
 
-	dev_kfree_skb_any(adapter->ptp_tx_skb);
-	adapter->ptp_tx_skb = NULL;
+	dev_kfree_skb_any(adapter->ptp_tx_skb[ts_reg_idx]);
+	adapter->ptp_tx_skb[ts_reg_idx] = NULL;
+	adapter->ptp_tx_start[ts_reg_idx] = 0;
 	adapter->tx_hwtstamp_timeouts++;
-	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
+
 	/* Clear the tx valid bit in TSYNCTXCTL register to enable interrupt. */
-	rd32(IGC_TXSTMPH);
+	rd32(IGC_TXSTMPH(ts_reg_idx));
 	netdev_warn(adapter->netdev, "Tx timestamp timeout\n");
 }
 
 void igc_ptp_tx_hang(struct igc_adapter *adapter)
 {
-	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
-					      IGC_PTP_TX_TIMEOUT);
+	int i;
+	spin_lock(&adapter->ptp_tx_lock);
 
-	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
-		return;
+	for (i = 0; i < IGC_N_TXSTAMP; i++) {
+		if (!adapter->ptp_tx_skb[i])
+			continue;
+		if (time_is_after_jiffies(adapter->ptp_tx_start[i] + IGC_PTP_TX_TIMEOUT))
+			continue;
 
-	/* If we haven't received a timestamp within the timeout, it is
-	 * reasonable to assume that it will never occur, so we can unlock the
-	 * timestamp bit when this occurs.
-	 */
-	if (timeout) {
-		cancel_work_sync(&adapter->ptp_tx_work);
-		igc_ptp_tx_timeout(adapter);
+		igc_ptp_tx_timeout(adapter, i);
 	}
+
+	spin_unlock(&adapter->ptp_tx_lock);
 }
 
 /**
  * igc_ptp_tx_hwtstamp - utility function which checks for TX time stamp
  * @adapter: Board private structure
+ * @ts_reg_idx: The TXSTMP register index
  *
  * If we were asked to do hardware stamping and such a time stamp is
  * available, then it must have been for this skb here because we only
  * allow only one such packet into the queue.
  */
-static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
+static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter, int ts_reg_idx)
 {
-	struct sk_buff *skb = adapter->ptp_tx_skb;
+	struct sk_buff *skb = adapter->ptp_tx_skb[ts_reg_idx];
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct igc_hw *hw = &adapter->hw;
 	int adjust = 0;
@@ -653,8 +659,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	if (WARN_ON_ONCE(!skb))
 		return;
 
-	regval = rd32(IGC_TXSTMPL);
-	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
+	regval = rd32(IGC_TXSTMPL(ts_reg_idx));
+	regval |= (u64)rd32(IGC_TXSTMPH(ts_reg_idx)) << 32;
 	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))
 		return;
 
@@ -681,8 +687,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	 * a copy of the skb pointer to ensure other threads can't change it
 	 * while we're notifying the stack.
 	 */
-	adapter->ptp_tx_skb = NULL;
-	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
+	adapter->ptp_tx_skb[ts_reg_idx] = NULL;
+	adapter->ptp_tx_start[ts_reg_idx] = 0;
+
 
 	/* Notify the stack and free the skb after we've unlocked */
 	skb_tstamp_tx(skb, &shhwtstamps);
@@ -702,15 +709,32 @@ static void igc_ptp_tx_work(struct work_struct *work)
 						   ptp_tx_work);
 	struct igc_hw *hw = &adapter->hw;
 	u32 tsynctxctl;
+	int i;
+	bool no_txstamp_sock = true;
 
-	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
-		return;
+	spin_lock(&adapter->ptp_tx_lock);
+	for (i = 0; i < IGC_N_TXSTAMP; i++) {
+		if (adapter->ptp_tx_skb[i]) {
+			no_txstamp_sock = false;
+			break;
+		}
+	}
+
+	if (no_txstamp_sock)
+		goto unlock;
 
 	tsynctxctl = rd32(IGC_TSYNCTXCTL);
-	if (WARN_ON_ONCE(!(tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)))
-		return;
+	for (i = 0; i < IGC_N_TXSTAMP; i++) {
+		if (adapter->ptp_tx_skb[i]) {
+			if (WARN_ON_ONCE(!(tsynctxctl & IGC_TSYNCTXCTL_TXTT(i))))
+				continue;
+
+			igc_ptp_tx_hwtstamp(adapter, i);
+		}
+	}
 
-	igc_ptp_tx_hwtstamp(adapter);
+unlock:
+	spin_unlock(&adapter->ptp_tx_lock);
 }
 
 /**
@@ -1017,13 +1041,22 @@ static void igc_ptm_stop(struct igc_adapter *adapter)
  */
 void igc_ptp_suspend(struct igc_adapter *adapter)
 {
+	int i;
+
 	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
 		return;
 
 	cancel_work_sync(&adapter->ptp_tx_work);
-	dev_kfree_skb_any(adapter->ptp_tx_skb);
-	adapter->ptp_tx_skb = NULL;
-	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
+
+	spin_lock(&adapter->ptp_tx_lock);
+	for (i = 0; i < IGC_N_TXSTAMP; i++) {
+		if (adapter->ptp_tx_skb[i]) {
+			dev_kfree_skb_any(adapter->ptp_tx_skb[i]);
+			adapter->ptp_tx_skb[i] = NULL;
+			adapter->ptp_tx_start[i] = 0;
+		}
+	}
+	spin_unlock(&adapter->ptp_tx_lock);
 
 	if (pci_device_is_present(adapter->pdev)) {
 		igc_ptp_time_save(adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 01c86d36856d..8c04fdc1b77a 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -243,8 +243,8 @@
 #define IGC_SYSTIMR	0x0B6F8  /* System time register Residue */
 #define IGC_TIMINCA	0x0B608  /* Increment attributes register - RW */
 
-#define IGC_TXSTMPL	0x0B618  /* Tx timestamp value Low - RO */
-#define IGC_TXSTMPH	0x0B61C  /* Tx timestamp value High - RO */
+#define IGC_TXSTMPL(_n)	(0x0B618 + ((_n) * (_n == 1 ? 0x080 : 0x020)))  /* Tx timestamp value Low - RO */
+#define IGC_TXSTMPH(_n)	(0x0B61C + ((_n) * (_n == 1 ? 0x080 : 0x020)))  /* Tx timestamp value High - RO */
 
 #define IGC_TIMADJ	0x0B60C  /* Time Adjustment Offset Register */
 
-- 
2.34.1

