Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2FB141134
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgAQS4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:62189 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgAQS4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819584"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:20 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 8/9] ice: Removing hung_queue variable to use txqueue function parameter
Date:   Fri, 17 Jan 2020 10:56:16 -0800
Message-Id: <20200117185617.1585693-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

The scope of function .ndo_tx_timeout was changed to include the hang
queue when a TX timeout event occurs. See commit 0290bd291cc0
("netdev: pass the stuck queue to the timeout handler") for more
details. Now, drivers don't need to identify which queue is stopped.
Drivers can simply use the queue index provided by dev_watchdog and
execute all actions needed to restore network traffic. This commit do
some cleanups into Intel ice driver to remove a redundant loop to find
stopped queue.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 41 ++++++-----------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bf539483e25e..eb9d00608e9a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5086,36 +5086,17 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct ice_ring *tx_ring = NULL;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	int hung_queue = -1;
 	u32 i;
 
 	pf->tx_timeout_count++;
 
-	/* find the stopped queue the same way dev_watchdog() does */
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		unsigned long trans_start;
-		struct netdev_queue *q;
-
-		q = netdev_get_tx_queue(netdev, i);
-		trans_start = q->trans_start;
-		if (netif_xmit_stopped(q) &&
-		    time_after(jiffies,
-			       trans_start + netdev->watchdog_timeo)) {
-			hung_queue = i;
-			break;
-		}
-	}
-
-	if (i == netdev->num_tx_queues)
-		netdev_info(netdev, "tx_timeout: no netdev hung queue found\n");
-	else
-		/* now that we have an index, find the tx_ring struct */
-		for (i = 0; i < vsi->num_txq; i++)
-			if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
-				if (hung_queue == vsi->tx_rings[i]->q_index) {
-					tx_ring = vsi->tx_rings[i];
-					break;
-				}
+	/* now that we have an index, find the tx_ring struct */
+	for (i = 0; i < vsi->num_txq; i++)
+		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
+			if (txqueue == vsi->tx_rings[i]->q_index) {
+				tx_ring = vsi->tx_rings[i];
+				break;
+			}
 
 	/* Reset recovery level if enough time has elapsed after last timeout.
 	 * Also ensure no new reset action happens before next timeout period.
@@ -5130,19 +5111,19 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		struct ice_hw *hw = &pf->hw;
 		u32 head, val = 0;
 
-		head = (rd32(hw, QTX_COMM_HEAD(vsi->txq_map[hung_queue])) &
+		head = (rd32(hw, QTX_COMM_HEAD(vsi->txq_map[txqueue])) &
 			QTX_COMM_HEAD_HEAD_M) >> QTX_COMM_HEAD_HEAD_S;
 		/* Read interrupt register */
 		val = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
 
 		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %d, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
-			    vsi->vsi_num, hung_queue, tx_ring->next_to_clean,
+			    vsi->vsi_num, txqueue, tx_ring->next_to_clean,
 			    head, tx_ring->next_to_use, val);
 	}
 
 	pf->tx_timeout_last_recovery = jiffies;
-	netdev_info(netdev, "tx_timeout recovery level %d, hung_queue %d\n",
-		    pf->tx_timeout_recovery_level, hung_queue);
+	netdev_info(netdev, "tx_timeout recovery level %d, txqueue %d\n",
+		    pf->tx_timeout_recovery_level, txqueue);
 
 	switch (pf->tx_timeout_recovery_level) {
 	case 1:
-- 
2.24.1

