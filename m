Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3539BCF8
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFDQXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:53970 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhFDQXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:40 -0400
IronPort-SDR: 1O7ZUNSS80XcPc1m9To5uC1CGiu4OIVILUJPbOu+Mu+dWVG3wdvVp5wYJunz2KhEFkdOrJVPxw
 s3OXMjDZmi1g==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003826"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003826"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:53 -0700
IronPort-SDR: yGqsUKLNQ2vRXWkLlFkeu3wbjbJE2SRVP/69mas0XJNUqQpNJRCsQqFZLOcHITpPACrelMzPRf
 2ioJkuGYV+Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309166"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 5/5] igc: Enable HW VLAN Insertion and HW VLAN Stripping
Date:   Fri,  4 Jun 2021 09:24:21 -0700
Message-Id: <20210604162421.3392644-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

Add HW VLAN acceleration protocol handling. In case of HW VLAN tagging,
we need that protocol available in the ndo_start_xmit(), so that it will be
stored in a new fields in the skb.

HW offloading is set to OFF by default.
Users are allow to turn on/off Rx/Tx HW VLAN acceleration via ethtool.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  4 ++
 drivers/net/ethernet/intel/igc/igc_main.c    | 74 +++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 +
 4 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index b6d3277c6f52..9e0bbb2e55e3 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -372,6 +372,7 @@ extern char igc_driver_name[];
 
 /* VLAN info */
 #define IGC_TX_FLAGS_VLAN_MASK	0xffff0000
+#define IGC_TX_FLAGS_VLAN_SHIFT	16
 
 /* igc_test_staterr - tests bits within Rx descriptor status and error fields */
 static inline __le32 igc_test_staterr(union igc_adv_rx_desc *rx_desc,
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 526a4c83711f..c3a5a5518790 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -94,6 +94,7 @@
 #define IGC_CTRL_SLU		0x00000040  /* Set link up (Force Link) */
 #define IGC_CTRL_FRCSPD		0x00000800  /* Force Speed */
 #define IGC_CTRL_FRCDPX		0x00001000  /* Force Duplex */
+#define IGC_CTRL_VME		0x40000000  /* IEEE VLAN mode enable */
 
 #define IGC_CTRL_RFCE		0x08000000  /* Receive Flow Control enable */
 #define IGC_CTRL_TFCE		0x10000000  /* Transmit flow control enable */
@@ -322,6 +323,9 @@
 #define IGC_RXD_STAT_IXSM	0x04	/* Ignore checksum */
 #define IGC_RXD_STAT_UDPCS	0x10	/* UDP xsum calculated */
 #define IGC_RXD_STAT_TCPCS	0x20	/* TCP xsum calculated */
+#define IGC_RXD_STAT_VP		0x08	/* IEEE VLAN Packet */
+
+#define IGC_RXDEXT_STATERR_LB	0x00040000
 
 /* Advanced Receive Descriptor bit definitions */
 #define IGC_RXDADV_STAT_TSIP	0x08000 /* timestamp in packet */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ea998d2defa4..2e71b006b660 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -111,6 +111,9 @@ void igc_reset(struct igc_adapter *adapter)
 	if (!netif_running(adapter->netdev))
 		igc_power_down_phy_copper_base(&adapter->hw);
 
+	/* Enable HW to recognize an 802.1Q VLAN Ethernet packet */
+	wr32(IGC_VET, ETH_P_8021Q);
+
 	/* Re-enable PTP, where applicable. */
 	igc_ptp_reset(adapter);
 
@@ -1122,13 +1125,17 @@ static inline int igc_maybe_stop_tx(struct igc_ring *tx_ring, const u16 size)
 	 ((u32)((_input) & (_flag)) * ((_result) / (_flag))) :	\
 	 ((u32)((_input) & (_flag)) / ((_flag) / (_result))))
 
-static u32 igc_tx_cmd_type(u32 tx_flags)
+static u32 igc_tx_cmd_type(struct sk_buff *skb, u32 tx_flags)
 {
 	/* set type for advanced descriptor with frame checksum insertion */
 	u32 cmd_type = IGC_ADVTXD_DTYP_DATA |
 		       IGC_ADVTXD_DCMD_DEXT |
 		       IGC_ADVTXD_DCMD_IFCS;
 
+	/* set HW vlan bit if vlan is present */
+	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_VLAN,
+				 IGC_ADVTXD_DCMD_VLE);
+
 	/* set segmentation bits for TSO */
 	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSO,
 				 (IGC_ADVTXD_DCMD_TSE));
@@ -1137,6 +1144,9 @@ static u32 igc_tx_cmd_type(u32 tx_flags)
 	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSTAMP,
 				 (IGC_ADVTXD_MAC_TSTAMP));
 
+	/* insert frame checksum */
+	cmd_type ^= IGC_SET_FLAG(skb->no_fcs, 1, IGC_ADVTXD_DCMD_IFCS);
+
 	return cmd_type;
 }
 
@@ -1171,8 +1181,9 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	u16 i = tx_ring->next_to_use;
 	unsigned int data_len, size;
 	dma_addr_t dma;
-	u32 cmd_type = igc_tx_cmd_type(tx_flags);
+	u32 cmd_type;
 
+	cmd_type = igc_tx_cmd_type(skb, tx_flags);
 	tx_desc = IGC_TX_DESC(tx_ring, i);
 
 	igc_tx_olinfo_status(tx_ring, tx_desc, tx_flags, skb->len - hdr_len);
@@ -1443,6 +1454,11 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		}
 	}
 
+	if (skb_vlan_tag_present(skb)) {
+		tx_flags |= IGC_TX_FLAGS_VLAN;
+		tx_flags |= (skb_vlan_tag_get(skb) << IGC_TX_FLAGS_VLAN_SHIFT);
+	}
+
 	/* record initial flags and protocol */
 	first->tx_flags = tx_flags;
 	first->protocol = protocol;
@@ -1542,6 +1558,25 @@ static inline void igc_rx_hash(struct igc_ring *ring,
 			     PKT_HASH_TYPE_L3);
 }
 
+static void igc_rx_vlan(struct igc_ring *rx_ring,
+			union igc_adv_rx_desc *rx_desc,
+			struct sk_buff *skb)
+{
+	struct net_device *dev = rx_ring->netdev;
+	u16 vid;
+
+	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    igc_test_staterr(rx_desc, IGC_RXD_STAT_VP)) {
+		if (igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_LB) &&
+		    test_bit(IGC_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
+			vid = be16_to_cpu((__force __be16)rx_desc->wb.upper.vlan);
+		else
+			vid = le16_to_cpu(rx_desc->wb.upper.vlan);
+
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
+	}
+}
+
 /**
  * igc_process_skb_fields - Populate skb header fields from Rx descriptor
  * @rx_ring: rx descriptor ring packet is being transacted on
@@ -1560,11 +1595,37 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 
 	igc_rx_checksum(rx_ring, rx_desc, skb);
 
+	igc_rx_vlan(rx_ring, rx_desc, skb);
+
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 }
 
+static void igc_vlan_mode(struct net_device *netdev, netdev_features_t features)
+{
+	bool enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	u32 ctrl;
+
+	ctrl = rd32(IGC_CTRL);
+
+	if (enable) {
+		/* enable VLAN tag insert/strip */
+		ctrl |= IGC_CTRL_VME;
+	} else {
+		/* disable VLAN tag insert/strip */
+		ctrl &= ~IGC_CTRL_VME;
+	}
+	wr32(IGC_CTRL, ctrl);
+}
+
+static void igc_restore_vlan(struct igc_adapter *adapter)
+{
+	igc_vlan_mode(adapter->netdev, adapter->netdev->features);
+}
+
 static struct igc_rx_buffer *igc_get_rx_buffer(struct igc_ring *rx_ring,
 					       const unsigned int size,
 					       int *rx_buffer_pgcnt)
@@ -3248,6 +3309,8 @@ static void igc_configure(struct igc_adapter *adapter)
 	igc_get_hw_control(adapter);
 	igc_set_rx_mode(netdev);
 
+	igc_restore_vlan(adapter);
+
 	igc_setup_tctl(adapter);
 	igc_setup_mrqc(adapter);
 	igc_setup_rctl(adapter);
@@ -4547,6 +4610,9 @@ static int igc_set_features(struct net_device *netdev,
 	netdev_features_t changed = netdev->features ^ features;
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+		igc_vlan_mode(netdev, features);
+
 	/* Add VLAN support */
 	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
 		return 0;
@@ -5873,11 +5939,15 @@ static int igc_probe(struct pci_dev *pdev,
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= NETIF_F_NTUPLE;
+	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 	netdev->hw_features |= netdev->features;
 
 	if (pci_using_dac)
 		netdev->features |= NETIF_F_HIGHDMA;
 
+	netdev->vlan_features |= netdev->features;
+
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = MAX_STD_JUMBO_FRAME_SIZE;
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 2491d565d758..0f82990567d9 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -11,6 +11,7 @@
 #define IGC_CTRL_EXT		0x00018  /* Extended Device Control - RW */
 #define IGC_MDIC		0x00020  /* MDI Control - RW */
 #define IGC_CONNSW		0x00034  /* Copper/Fiber switch control - RW */
+#define IGC_VET			0x00038  /* VLAN Ether Type - RW */
 #define IGC_I225_PHPM		0x00E14  /* I225 PHY Power Management */
 #define IGC_GPHY_VERSION	0x0001E  /* I225 gPHY Firmware Version */
 
-- 
2.26.2

