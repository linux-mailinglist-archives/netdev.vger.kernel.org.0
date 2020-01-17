Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87314113A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgAQS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:36273 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbgAQS4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819580"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:20 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 7/9] i40e: Removing hung_queue variable to use txqueue function parameter
Date:   Fri, 17 Jan 2020 10:56:15 -0800
Message-Id: <20200117185617.1585693-8-jeffrey.t.kirsher@intel.com>
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
some cleanups into Intel i40e driver to remove a redundant loop to find
stopped queue.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 41 ++++++---------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 33912cf964eb..8c3e753bfb9d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -307,37 +307,18 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_ring *tx_ring = NULL;
-	unsigned int i, hung_queue = 0;
+	unsigned int i;
 	u32 head, val;
 
 	pf->tx_timeout_count++;
 
-	/* find the stopped queue the same way the stack does */
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		struct netdev_queue *q;
-		unsigned long trans_start;
-
-		q = netdev_get_tx_queue(netdev, i);
-		trans_start = q->trans_start;
-		if (netif_xmit_stopped(q) &&
-		    time_after(jiffies,
-			       (trans_start + netdev->watchdog_timeo))) {
-			hung_queue = i;
-			break;
-		}
-	}
-
-	if (i == netdev->num_tx_queues) {
-		netdev_info(netdev, "tx_timeout: no netdev hung queue found\n");
-	} else {
-		/* now that we have an index, find the tx_ring struct */
-		for (i = 0; i < vsi->num_queue_pairs; i++) {
-			if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc) {
-				if (hung_queue ==
-				    vsi->tx_rings[i]->queue_index) {
-					tx_ring = vsi->tx_rings[i];
-					break;
-				}
+	/* with txqueue index, find the tx_ring struct */
+	for (i = 0; i < vsi->num_queue_pairs; i++) {
+		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc) {
+			if (txqueue ==
+			    vsi->tx_rings[i]->queue_index) {
+				tx_ring = vsi->tx_rings[i];
+				break;
 			}
 		}
 	}
@@ -363,14 +344,14 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 			val = rd32(&pf->hw, I40E_PFINT_DYN_CTL0);
 
 		netdev_info(netdev, "tx_timeout: VSI_seid: %d, Q %d, NTC: 0x%x, HWB: 0x%x, NTU: 0x%x, TAIL: 0x%x, INT: 0x%x\n",
-			    vsi->seid, hung_queue, tx_ring->next_to_clean,
+			    vsi->seid, txqueue, tx_ring->next_to_clean,
 			    head, tx_ring->next_to_use,
 			    readl(tx_ring->tail), val);
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

