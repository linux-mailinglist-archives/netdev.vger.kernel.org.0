Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA692EC5EF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAFV5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:57:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:52550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbhAFV5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:57:11 -0500
IronPort-SDR: NBMPY8wny4MoeQSGPDweLn+b2+L5M/WtZxf7SZStoSGDcxrHpLW0DtMLmUGP82sl5HskXe41zR
 U0beqoWVKVuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="241418416"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="241418416"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:59 -0800
IronPort-SDR: Ymdv9XnxJATABmVYbLSI4LPH5+6dqp6Wwz8evSohRej8WJ9ur5b1VwBYgDwxa8L6kp9bNOOK6E
 bmwRDFIizo7Q==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="361734670"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:58 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v1 2/2] ice: remove GRO drop accounting
Date:   Wed,  6 Jan 2021 13:55:39 -0800
Message-Id: <20210106215539.2103688-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was counting GRO drops but now that the stack
does it with the previous patch, the driver can drop
all the logic.  The driver keeps the dev_dbg message in order
to do optional detailed tracing.

This mostly undoes commit a8fffd7ae9a5 ("ice: add useful statistics").

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 1 -
 drivers/net/ethernet/intel/ice/ice_main.c     | 4 +---
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 -
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 2 --
 5 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 56725356a17b..dde850045e7e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -256,7 +256,6 @@ struct ice_vsi {
 	u32 tx_busy;
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
-	u32 rx_gro_dropped;
 	u16 num_q_vectors;
 	u16 base_vector;		/* IRQ base for OS reserved vectors */
 	enum ice_vsi_type type;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9e8e9531cd87..025c0a13e724 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -59,7 +59,6 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
 	ICE_VSI_STAT("rx_unknown_protocol", eth_stats.rx_unknown_protocol),
 	ICE_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	ICE_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
-	ICE_VSI_STAT("rx_gro_dropped", rx_gro_dropped),
 	ICE_VSI_STAT("tx_errors", eth_stats.tx_errors),
 	ICE_VSI_STAT("tx_linearize", tx_linearize),
 	ICE_VSI_STAT("tx_busy", tx_busy),
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c52b9bb0e3ab..e157a2b4fcb9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5314,7 +5314,6 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	vsi->tx_linearize = 0;
 	vsi->rx_buf_failed = 0;
 	vsi->rx_page_failed = 0;
-	vsi->rx_gro_dropped = 0;
 
 	rcu_read_lock();
 
@@ -5329,7 +5328,6 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 		vsi_stats->rx_bytes += bytes;
 		vsi->rx_buf_failed += ring->rx_stats.alloc_buf_failed;
 		vsi->rx_page_failed += ring->rx_stats.alloc_page_failed;
-		vsi->rx_gro_dropped += ring->rx_stats.gro_dropped;
 	}
 
 	/* update XDP Tx rings counters */
@@ -5361,7 +5359,7 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	ice_update_eth_stats(vsi);
 
 	cur_ns->tx_errors = cur_es->tx_errors;
-	cur_ns->rx_dropped = cur_es->rx_discards + vsi->rx_gro_dropped;
+	cur_ns->rx_dropped = cur_es->rx_discards;
 	cur_ns->tx_dropped = cur_es->tx_discards;
 	cur_ns->multicast = cur_es->rx_multicast;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ff1a1cbd078e..6ce2046fc349 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -193,7 +193,6 @@ struct ice_rxq_stats {
 	u64 non_eop_descs;
 	u64 alloc_page_failed;
 	u64 alloc_buf_failed;
-	u64 gro_dropped; /* GRO returned dropped */
 };
 
 /* this enum matches hardware bits and is meant to be used by DYN_CTLN
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index bc2f4390b51d..3601b7d8abe5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -192,8 +192,6 @@ ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 	if (napi_gro_receive(&rx_ring->q_vector->napi, skb) == GRO_DROP) {
-		/* this is tracked separately to help us debug stack drops */
-		rx_ring->rx_stats.gro_dropped++;
 		netdev_dbg(rx_ring->netdev, "Receive Queue %d: Dropped packet from GRO\n",
 			   rx_ring->q_index);
 	}
-- 
2.29.2

