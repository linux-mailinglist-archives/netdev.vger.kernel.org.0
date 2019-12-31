Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37EB12DC27
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLaW1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:27:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:29321 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfLaW1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403579"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:51 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Robert Beckett <bob.beckett@collabora.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/11] igb: dont drop packets if rx flow control is enabled
Date:   Tue, 31 Dec 2019 14:27:40 -0800
Message-Id: <20191231222750.3749984-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
References: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

If Rx flow control has been enabled (via autoneg or forced), packets
should not be dropped due to Rx descriptor ring exhaustion. Instead
pause frames should be used to apply back pressure. This only applies
if VFs are not in use.

Move SRRCTL setup to its own function for easy reuse and only set drop
enable bit if Rx flow control is not enabled.

Since v1: always enable dropping of packets if VFs in use.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h         |  1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  8 ++++
 drivers/net/ethernet/intel/igb/igb_main.c    | 47 ++++++++++++++------
 3 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index ca54e268d157..49b5fa9d4783 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -661,6 +661,7 @@ void igb_configure_tx_ring(struct igb_adapter *, struct igb_ring *);
 void igb_configure_rx_ring(struct igb_adapter *, struct igb_ring *);
 void igb_setup_tctl(struct igb_adapter *);
 void igb_setup_rctl(struct igb_adapter *);
+void igb_setup_srrctl(struct igb_adapter *, struct igb_ring *);
 netdev_tx_t igb_xmit_frame_ring(struct sk_buff *, struct igb_ring *);
 void igb_alloc_rx_buffers(struct igb_ring *, u16);
 void igb_update_stats(struct igb_adapter *);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 4690d6c87f39..43c438365389 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -396,6 +396,7 @@ static int igb_set_pauseparam(struct net_device *netdev,
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	int retval = 0;
+	int i;
 
 	/* 100basefx does not support setting link flow control */
 	if (hw->dev_spec._82575.eth_flags.e100_base_fx)
@@ -428,6 +429,13 @@ static int igb_set_pauseparam(struct net_device *netdev,
 
 		retval = ((hw->phy.media_type == e1000_media_type_copper) ?
 			  igb_force_mac_fc(hw) : igb_setup_link(hw));
+
+		/* Make sure SRRCTL considers new fc settings for each ring */
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			struct igb_ring *ring = adapter->rx_ring[i];
+
+			igb_setup_srrctl(adapter, ring);
+		}
 	}
 
 	clear_bit(__IGB_RESETTING, &adapter->state);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d11e64a58ed1..b46bff8fe056 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4467,6 +4467,37 @@ static inline void igb_set_vmolr(struct igb_adapter *adapter,
 	wr32(E1000_VMOLR(vfn), vmolr);
 }
 
+/**
+ *  igb_setup_srrctl - configure the split and replication receive control
+ *                     registers
+ *  @adapter: Board private structure
+ *  @ring: receive ring to be configured
+ **/
+void igb_setup_srrctl(struct igb_adapter *adapter, struct igb_ring *ring)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	int reg_idx = ring->reg_idx;
+	u32 srrctl = 0;
+
+	srrctl = IGB_RX_HDR_LEN << E1000_SRRCTL_BSIZEHDRSIZE_SHIFT;
+	if (ring_uses_large_buffer(ring))
+		srrctl |= IGB_RXBUFFER_3072 >> E1000_SRRCTL_BSIZEPKT_SHIFT;
+	else
+		srrctl |= IGB_RXBUFFER_2048 >> E1000_SRRCTL_BSIZEPKT_SHIFT;
+	srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
+	if (hw->mac.type >= e1000_82580)
+		srrctl |= E1000_SRRCTL_TIMESTAMP;
+	/* Only set Drop Enable if VFs allocated, or we are supporting multiple
+	 * queues and rx flow control is disabled
+	 */
+	if (adapter->vfs_allocated_count ||
+	    (!(hw->fc.current_mode & e1000_fc_rx_pause) &&
+	     adapter->num_rx_queues > 1))
+		srrctl |= E1000_SRRCTL_DROP_EN;
+
+	wr32(E1000_SRRCTL(reg_idx), srrctl);
+}
+
 /**
  *  igb_configure_rx_ring - Configure a receive ring after Reset
  *  @adapter: board private structure
@@ -4481,7 +4512,7 @@ void igb_configure_rx_ring(struct igb_adapter *adapter,
 	union e1000_adv_rx_desc *rx_desc;
 	u64 rdba = ring->dma;
 	int reg_idx = ring->reg_idx;
-	u32 srrctl = 0, rxdctl = 0;
+	u32 rxdctl = 0;
 
 	/* disable the queue */
 	wr32(E1000_RXDCTL(reg_idx), 0);
@@ -4499,19 +4530,7 @@ void igb_configure_rx_ring(struct igb_adapter *adapter,
 	writel(0, ring->tail);
 
 	/* set descriptor configuration */
-	srrctl = IGB_RX_HDR_LEN << E1000_SRRCTL_BSIZEHDRSIZE_SHIFT;
-	if (ring_uses_large_buffer(ring))
-		srrctl |= IGB_RXBUFFER_3072 >> E1000_SRRCTL_BSIZEPKT_SHIFT;
-	else
-		srrctl |= IGB_RXBUFFER_2048 >> E1000_SRRCTL_BSIZEPKT_SHIFT;
-	srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
-	if (hw->mac.type >= e1000_82580)
-		srrctl |= E1000_SRRCTL_TIMESTAMP;
-	/* Only set Drop Enable if we are supporting multiple queues */
-	if (adapter->vfs_allocated_count || adapter->num_rx_queues > 1)
-		srrctl |= E1000_SRRCTL_DROP_EN;
-
-	wr32(E1000_SRRCTL(reg_idx), srrctl);
+	igb_setup_srrctl(adapter, ring);
 
 	/* set filtering for VMDQ pools */
 	igb_set_vmolr(adapter, reg_idx & 0x7, true);
-- 
2.24.1

