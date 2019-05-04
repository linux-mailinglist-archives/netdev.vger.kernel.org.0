Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA4A13C51
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfEDXyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:32555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfEDXyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994662"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Refactor getting/setting coalesce
Date:   Sat,  4 May 2019 16:49:22 -0700
Message-Id: <20190504234929.3005-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if the driver has an uneven amount of Rx/Tx queues
setting the coalesce settings through ethtool will result in
an error. This is happening because in the setting coalesce
flow we are reporting an error if either Rx or Tx fails.

Also, the flow for setting/getting per_q_coalesce and
setting/getting coalesce settings for the entire device
is different.

Fix these issues by adding one function, ice_set_q_coalesce(),
and another, ice_get_q_coalesce(), that both getting/setting
per_q and entire device coalesce can use. This makes handling
the error cases generic between the two flows and simplifies
__ice_set_coalesce() and __ice_get_coalesce().

Also, add a header comment to __ice_set_coalesce().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 152 ++++++++++++-------
 1 file changed, 93 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0bfe696d8077..08ec2f3c5977 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2254,50 +2254,61 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 	return 0;
 }
 
+/**
+ * ice_get_q_coalesce - get a queue's ITR/INTRL (coalesce) settings
+ * @vsi: VSI associated to the queue for getting ITR/INTRL (coalesce) settings
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ *
+ * Return 0 on success, and negative under the following conditions:
+ * 1. Getting Tx or Rx ITR/INTRL (coalesce) settings failed.
+ * 2. The q_num passed in is not a valid number/index for Tx and Rx rings.
+ */
+static int
+ice_get_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
+{
+	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
+		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+					&vsi->rx_rings[q_num]->q_vector->rx))
+			return -EINVAL;
+		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+					&vsi->tx_rings[q_num]->q_vector->tx))
+			return -EINVAL;
+	} else if (q_num < vsi->num_rxq) {
+		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+					&vsi->rx_rings[q_num]->q_vector->rx))
+			return -EINVAL;
+	} else if (q_num < vsi->num_txq) {
+		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+					&vsi->tx_rings[q_num]->q_vector->tx))
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * __ice_get_coalesce - get ITR/INTRL values for the device
  * @netdev: pointer to the netdev associated with this query
  * @ec: ethtool structure to fill with driver's coalesce settings
  * @q_num: queue number to get the coalesce settings for
+ *
+ * If the caller passes in a negative q_num then we return coalesce settings
+ * based on queue number 0, else use the actual q_num passed in.
  */
 static int
 __ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 		   int q_num)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	int tx = -EINVAL, rx = -EINVAL;
 	struct ice_vsi *vsi = np->vsi;
 
-	if (q_num < 0) {
-		rx = ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
-					 &vsi->rx_rings[0]->q_vector->rx);
-		tx = ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
-					 &vsi->tx_rings[0]->q_vector->tx);
-
-		goto update_coalesced_frames;
-	}
-
-	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		rx = ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
-					 &vsi->rx_rings[q_num]->q_vector->rx);
-		tx = ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
-					 &vsi->tx_rings[q_num]->q_vector->tx);
-	} else if (q_num < vsi->num_rxq) {
-		rx = ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
-					 &vsi->rx_rings[q_num]->q_vector->rx);
-	} else if (q_num < vsi->num_txq) {
-		tx = ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
-					 &vsi->tx_rings[q_num]->q_vector->tx);
-	} else {
-		/* q_num is invalid for both Rx and Tx queues */
-		return -EINVAL;
-	}
+	if (q_num < 0)
+		q_num = 0;
 
-update_coalesced_frames:
-	/* either q_num is invalid for both Rx and Tx queues or setting coalesce
-	 * failed completely
-	 */
-	if (tx && rx)
+	if (ice_get_q_coalesce(vsi, ec, q_num))
 		return -EINVAL;
 
 	if (q_num < vsi->num_txq)
@@ -2423,54 +2434,77 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	return 0;
 }
 
+/**
+ * ice_set_q_coalesce - set a queue's ITR/INTRL (coalesce) settings
+ * @vsi: VSI associated to the queue that need updating
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ *
+ * Return 0 on success, and negative under the following conditions:
+ * 1. Setting Tx or Rx ITR/INTRL (coalesce) settings failed.
+ * 2. The q_num passed in is not a valid number/index for Tx and Rx rings.
+ */
+static int
+ice_set_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
+{
+	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
+		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+					&vsi->rx_rings[q_num]->q_vector->rx,
+					vsi))
+			return -EINVAL;
+
+		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+					&vsi->tx_rings[q_num]->q_vector->tx,
+					vsi))
+			return -EINVAL;
+	} else if (q_num < vsi->num_rxq) {
+		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+					&vsi->rx_rings[q_num]->q_vector->rx,
+					vsi))
+			return -EINVAL;
+	} else if (q_num < vsi->num_txq) {
+		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+					&vsi->tx_rings[q_num]->q_vector->tx,
+					vsi))
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * __ice_set_coalesce - set ITR/INTRL values for the device
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: ethtool structure to fill with driver's coalesce settings
+ * @q_num: queue number to get the coalesce settings for
+ *
+ * If the caller passes in a negative q_num then we set the coalesce settings
+ * for all Tx/Rx queues, else use the actual q_num passed in.
+ */
 static int
 __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 		   int q_num)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	int rx = -EINVAL, tx = -EINVAL;
 	struct ice_vsi *vsi = np->vsi;
 
 	if (q_num < 0) {
 		int i;
 
 		ice_for_each_q_vector(vsi, i) {
-			struct ice_q_vector *q_vector = vsi->q_vectors[i];
-
-			if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
-						&q_vector->rx, vsi) ||
-			    ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
-						&q_vector->tx, vsi))
+			if (ice_set_q_coalesce(vsi, ec, i))
 				return -EINVAL;
 		}
-
 		goto set_work_lmt;
 	}
 
-	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		rx = ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
-					 &vsi->rx_rings[q_num]->q_vector->rx,
-					 vsi);
-		tx = ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
-					 &vsi->tx_rings[q_num]->q_vector->tx,
-					 vsi);
-	} else if (q_num < vsi->num_rxq) {
-		rx = ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
-					 &vsi->rx_rings[q_num]->q_vector->rx,
-					 vsi);
-	} else if (q_num < vsi->num_txq) {
-		tx  = ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
-					  &vsi->tx_rings[q_num]->q_vector->tx,
-					  vsi);
-	}
-
-	/* either q_num is invalid for both Rx and Tx queues or setting coalesce
-	 * failed completely
-	 */
-	if (rx && tx)
+	if (ice_set_q_coalesce(vsi, ec, q_num))
 		return -EINVAL;
 
 set_work_lmt:
+
 	if (ec->tx_max_coalesced_frames_irq || ec->rx_max_coalesced_frames_irq)
 		vsi->work_lmt = max(ec->tx_max_coalesced_frames_irq,
 				    ec->rx_max_coalesced_frames_irq);
-- 
2.20.1

