Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FD23533F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHAQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:19614 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgHAQSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:10 -0400
IronPort-SDR: ffQKhH9mRkOSunxGcLnV7WSu7nqLkwGZz8K3xr+uRjSVsz2xuXagnT50rCn6iI55AsxVatoPI/
 oPjMztyxfXZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810852"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: 2Hult/smAvq7lO4M9rYgI9CV6kWkcXw2y/kwmxJUBYesNDyi2xOgeLmIZ2MGQh2GJk3gSQ+4Ff
 ahTU0kGgSxHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457705"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 06/14] ice: add useful statistics
Date:   Sat,  1 Aug 2020 09:17:54 -0700
Message-Id: <20200801161802.867645-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Display and count some useful hot-path statistics. The usefulness is as
follows:

- tx_restart: use to determine if the transmit ring size is too small or
  if the transmit interrupt rate is too low.
- rx_gro_dropped: use to count drops from GRO layer, which previously were
  completely uncounted when occurring.
- tx_busy: use to determine when the driver is miscounting number of
  descriptors needed for an skb.
- tx_timeout: as our other drivers, count the number of times we've reset
  due to timeout because the kernel only prints a warning once per netdev.

Several of these were already counted but not displayed.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 4 ++++
 drivers/net/ethernet/intel/ice/ice_main.c     | 4 +++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 7 ++++++-
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7d194d2a031a..fe140ff38f74 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -256,6 +256,7 @@ struct ice_vsi {
 	u32 tx_busy;
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
+	u32 rx_gro_dropped;
 	u16 num_q_vectors;
 	u16 base_vector;		/* IRQ base for OS reserved vectors */
 	enum ice_vsi_type type;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 06b93e97892d..9e8e9531cd87 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -59,8 +59,11 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
 	ICE_VSI_STAT("rx_unknown_protocol", eth_stats.rx_unknown_protocol),
 	ICE_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	ICE_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
+	ICE_VSI_STAT("rx_gro_dropped", rx_gro_dropped),
 	ICE_VSI_STAT("tx_errors", eth_stats.tx_errors),
 	ICE_VSI_STAT("tx_linearize", tx_linearize),
+	ICE_VSI_STAT("tx_busy", tx_busy),
+	ICE_VSI_STAT("tx_restart", tx_restart),
 };
 
 enum ice_ethtool_test_id {
@@ -100,6 +103,7 @@ static const struct ice_stats ice_gstrings_pf_stats[] = {
 	ICE_PF_STAT("rx_broadcast.nic", stats.eth.rx_broadcast),
 	ICE_PF_STAT("tx_broadcast.nic", stats.eth.tx_broadcast),
 	ICE_PF_STAT("tx_errors.nic", stats.eth.tx_errors),
+	ICE_PF_STAT("tx_timeout.nic", tx_timeout_count),
 	ICE_PF_STAT("rx_size_64.nic", stats.rx_size_64),
 	ICE_PF_STAT("tx_size_64.nic", stats.tx_size_64),
 	ICE_PF_STAT("rx_size_127.nic", stats.rx_size_127),
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bd2a2df25def..22bbd84eef64 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5290,6 +5290,7 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	vsi->tx_linearize = 0;
 	vsi->rx_buf_failed = 0;
 	vsi->rx_page_failed = 0;
+	vsi->rx_gro_dropped = 0;
 
 	rcu_read_lock();
 
@@ -5304,6 +5305,7 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 		vsi_stats->rx_bytes += bytes;
 		vsi->rx_buf_failed += ring->rx_stats.alloc_buf_failed;
 		vsi->rx_page_failed += ring->rx_stats.alloc_page_failed;
+		vsi->rx_gro_dropped += ring->rx_stats.gro_dropped;
 	}
 
 	/* update XDP Tx rings counters */
@@ -5335,7 +5337,7 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	ice_update_eth_stats(vsi);
 
 	cur_ns->tx_errors = cur_es->tx_errors;
-	cur_ns->rx_dropped = cur_es->rx_discards;
+	cur_ns->rx_dropped = cur_es->rx_discards + vsi->rx_gro_dropped;
 	cur_ns->tx_dropped = cur_es->tx_discards;
 	cur_ns->multicast = cur_es->rx_multicast;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 77c94daeb434..51b4df7a59d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -193,6 +193,7 @@ struct ice_rxq_stats {
 	u64 non_eop_descs;
 	u64 alloc_page_failed;
 	u64 alloc_buf_failed;
+	u64 gro_dropped; /* GRO returned dropped */
 };
 
 /* this enum matches hardware bits and is meant to be used by DYN_CTLN
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 02b12736ea80..bc2f4390b51d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -191,7 +191,12 @@ ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	napi_gro_receive(&rx_ring->q_vector->napi, skb);
+	if (napi_gro_receive(&rx_ring->q_vector->napi, skb) == GRO_DROP) {
+		/* this is tracked separately to help us debug stack drops */
+		rx_ring->rx_stats.gro_dropped++;
+		netdev_dbg(rx_ring->netdev, "Receive Queue %d: Dropped packet from GRO\n",
+			   rx_ring->q_index);
+	}
 }
 
 /**
-- 
2.26.2

