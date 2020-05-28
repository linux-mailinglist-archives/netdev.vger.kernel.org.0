Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47E61E588C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgE1HZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:14695 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgE1HZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:45 -0400
IronPort-SDR: qXOVtxDSaR54HbZr3vSS3VsZbjINw4b4FNxf60TVeHU5ElGkQjCd4WFbc7hcC6iQVaoaj35kMW
 lzPuQCb5OKIw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:43 -0700
IronPort-SDR: 1jAuYuyWuq8MqCQ2wiNj7PZ+ZTM/9mji+Vbv+zUj1Ov3Mc43RI/ikBqFLO4m7b5vEsaHfUhhPl
 e67RM12jZUTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831135"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Marta Plantykow <marta.a.plantykow@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Add XDP Tx to VSI ring stats
Date:   Thu, 28 May 2020 00:25:34 -0700
Message-Id: <20200528072538.1621790-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marta Plantykow <marta.a.plantykow@intel.com>

When XDP Tx program is loaded and packets are sent from
interface, VSI statistics are not updated. This patch adds
packets sent on Tx XDP ring to VSI ring stats.

Signed-off-by: Marta Plantykow <marta.a.plantykow@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 42 ++++++++++++++++++-----
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 081fec3131cd..81c5f0ce5b8f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4219,6 +4219,33 @@ ice_fetch_u64_stats_per_ring(struct ice_ring *ring, u64 *pkts, u64 *bytes)
 	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 }
 
+/**
+ * ice_update_vsi_tx_ring_stats - Update VSI Tx ring stats counters
+ * @vsi: the VSI to be updated
+ * @rings: rings to work on
+ * @count: number of rings
+ */
+static void
+ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_ring **rings,
+			     u16 count)
+{
+	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
+	u16 i;
+
+	for (i = 0; i < count; i++) {
+		struct ice_ring *ring;
+		u64 pkts, bytes;
+
+		ring = READ_ONCE(rings[i]);
+		ice_fetch_u64_stats_per_ring(ring, &pkts, &bytes);
+		vsi_stats->tx_packets += pkts;
+		vsi_stats->tx_bytes += bytes;
+		vsi->tx_restart += ring->tx_stats.restart_q;
+		vsi->tx_busy += ring->tx_stats.tx_busy;
+		vsi->tx_linearize += ring->tx_stats.tx_linearize;
+	}
+}
+
 /**
  * ice_update_vsi_ring_stats - Update VSI stats counters
  * @vsi: the VSI to be updated
@@ -4246,15 +4273,7 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	rcu_read_lock();
 
 	/* update Tx rings counters */
-	ice_for_each_txq(vsi, i) {
-		ring = READ_ONCE(vsi->tx_rings[i]);
-		ice_fetch_u64_stats_per_ring(ring, &pkts, &bytes);
-		vsi_stats->tx_packets += pkts;
-		vsi_stats->tx_bytes += bytes;
-		vsi->tx_restart += ring->tx_stats.restart_q;
-		vsi->tx_busy += ring->tx_stats.tx_busy;
-		vsi->tx_linearize += ring->tx_stats.tx_linearize;
-	}
+	ice_update_vsi_tx_ring_stats(vsi, vsi->tx_rings, vsi->num_txq);
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
@@ -4266,6 +4285,11 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 		vsi->rx_page_failed += ring->rx_stats.alloc_page_failed;
 	}
 
+	/* update XDP Tx rings counters */
+	if (ice_is_xdp_ena_vsi(vsi))
+		ice_update_vsi_tx_ring_stats(vsi, vsi->xdp_rings,
+					     vsi->num_xdp_txq);
+
 	rcu_read_unlock();
 }
 
-- 
2.26.2

