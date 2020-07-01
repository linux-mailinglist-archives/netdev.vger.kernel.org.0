Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5454321161F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGAWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:25463 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgGAWed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:33 -0400
IronPort-SDR: X/LgfdoMJDRDqOmAgxlp1gEpGPqY1T1w8wANt3lcEp6Vbhwd3NWDmYO7SP95LO5yMbtuTsTwOp
 dI9ZxVRXSshg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178608"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178608"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: 3Ag61RbYoRNqMU9k8WIeZqReWl4sRtlWDU/2PKJUZcypVtZDI2PLNG3dtgmNxdNSiYQOhw4Hz/
 VQ4kWgLdtA3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276128"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 09/12] i40e: introduce new dump desc XDP command
Date:   Wed,  1 Jul 2020 15:34:09 -0700
Message-Id: <20200701223412.2675606-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

Interfaces already exist for dumping Rx and Tx descriptor information.
Introduce another for doing the same for XDP descriptors.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 59 +++++++++++++++----
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 41a4cf8e3d61..d3ad2e3aa838 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -10,6 +10,12 @@
 
 static struct dentry *i40e_dbg_root;
 
+enum ring_type {
+	RING_TYPE_RX,
+	RING_TYPE_TX,
+	RING_TYPE_XDP
+};
+
 /**
  * i40e_dbg_find_vsi - searches for the vsi with the given seid
  * @pf: the PF structure to search for the vsi
@@ -530,11 +536,12 @@ static void i40e_dbg_dump_aq_desc(struct i40e_pf *pf)
  * @ring_id: ring id entered by user
  * @desc_n: descriptor number entered by user
  * @pf: the i40e_pf created in command write
- * @is_rx_ring: true if rx, false if tx
+ * @type: enum describing whether ring is RX, TX or XDP
  **/
 static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
-			       struct i40e_pf *pf, bool is_rx_ring)
+			       struct i40e_pf *pf, enum ring_type type)
 {
+	bool is_rx_ring = type == RING_TYPE_RX;
 	struct i40e_tx_desc *txd;
 	union i40e_rx_desc *rxd;
 	struct i40e_ring *ring;
@@ -546,6 +553,10 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 		dev_info(&pf->pdev->dev, "vsi %d not found\n", vsi_seid);
 		return;
 	}
+	if (type == RING_TYPE_XDP && !i40e_enabled_xdp_vsi(vsi)) {
+		dev_info(&pf->pdev->dev, "XDP not enabled on VSI %d\n", vsi_seid);
+		return;
+	}
 	if (ring_id >= vsi->num_queue_pairs || ring_id < 0) {
 		dev_info(&pf->pdev->dev, "ring %d not found\n", ring_id);
 		return;
@@ -557,15 +568,32 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 		return;
 	}
 
-	ring = kmemdup(is_rx_ring
-		       ? vsi->rx_rings[ring_id] : vsi->tx_rings[ring_id],
-		       sizeof(*ring), GFP_KERNEL);
+	switch (type) {
+	case RING_TYPE_RX:
+		ring = kmemdup(vsi->rx_rings[ring_id], sizeof(*ring), GFP_KERNEL);
+		break;
+	case RING_TYPE_TX:
+		ring = kmemdup(vsi->tx_rings[ring_id], sizeof(*ring), GFP_KERNEL);
+		break;
+	case RING_TYPE_XDP:
+		ring = kmemdup(vsi->xdp_rings[ring_id], sizeof(*ring), GFP_KERNEL);
+		break;
+	}
 	if (!ring)
 		return;
 
 	if (cnt == 2) {
-		dev_info(&pf->pdev->dev, "vsi = %02i %s ring = %02i\n",
-			 vsi_seid, is_rx_ring ? "rx" : "tx", ring_id);
+		switch (type) {
+		case RING_TYPE_RX:
+			dev_info(&pf->pdev->dev, "VSI = %02i Rx ring = %02i\n", vsi_seid, ring_id);
+			break;
+		case RING_TYPE_TX:
+			dev_info(&pf->pdev->dev, "VSI = %02i Tx ring = %02i\n", vsi_seid, ring_id);
+			break;
+		case RING_TYPE_XDP:
+			dev_info(&pf->pdev->dev, "VSI = %02i XDP ring = %02i\n", vsi_seid, ring_id);
+			break;
+		}
 		for (i = 0; i < ring->count; i++) {
 			if (!is_rx_ring) {
 				txd = I40E_TX_DESC(ring, i);
@@ -603,7 +631,7 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 				 rxd->read.rsvd1, rxd->read.rsvd2);
 		}
 	} else {
-		dev_info(&pf->pdev->dev, "dump desc rx/tx <vsi_seid> <ring_id> [<desc_n>]\n");
+		dev_info(&pf->pdev->dev, "dump desc rx/tx/xdp <vsi_seid> <ring_id> [<desc_n>]\n");
 	}
 
 out:
@@ -960,13 +988,19 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 				cnt = sscanf(&cmd_buf[12], "%i %i %i",
 					     &vsi_seid, &ring_id, &desc_n);
 				i40e_dbg_dump_desc(cnt, vsi_seid, ring_id,
-						   desc_n, pf, true);
+						   desc_n, pf, RING_TYPE_RX);
 			} else if (strncmp(&cmd_buf[10], "tx", 2)
 					== 0) {
 				cnt = sscanf(&cmd_buf[12], "%i %i %i",
 					     &vsi_seid, &ring_id, &desc_n);
 				i40e_dbg_dump_desc(cnt, vsi_seid, ring_id,
-						   desc_n, pf, false);
+						   desc_n, pf, RING_TYPE_TX);
+			} else if (strncmp(&cmd_buf[10], "xdp", 3)
+					== 0) {
+				cnt = sscanf(&cmd_buf[13], "%i %i %i",
+					     &vsi_seid, &ring_id, &desc_n);
+				i40e_dbg_dump_desc(cnt, vsi_seid, ring_id,
+						   desc_n, pf, RING_TYPE_XDP);
 			} else if (strncmp(&cmd_buf[10], "aq", 2) == 0) {
 				i40e_dbg_dump_aq_desc(pf);
 			} else {
@@ -974,6 +1008,8 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 					 "dump desc tx <vsi_seid> <ring_id> [<desc_n>]\n");
 				dev_info(&pf->pdev->dev,
 					 "dump desc rx <vsi_seid> <ring_id> [<desc_n>]\n");
+				dev_info(&pf->pdev->dev,
+					 "dump desc xdp <vsi_seid> <ring_id> [<desc_n>]\n");
 				dev_info(&pf->pdev->dev, "dump desc aq\n");
 			}
 		} else if (strncmp(&cmd_buf[5], "reset stats", 11) == 0) {
@@ -1144,7 +1180,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 			buff = NULL;
 		} else {
 			dev_info(&pf->pdev->dev,
-				 "dump desc tx <vsi_seid> <ring_id> [<desc_n>], dump desc rx <vsi_seid> <ring_id> [<desc_n>],\n");
+				 "dump desc tx <vsi_seid> <ring_id> [<desc_n>], dump desc rx <vsi_seid> <ring_id> [<desc_n>], dump desc xdp <vsi_seid> <ring_id> [<desc_n>],\n");
 			dev_info(&pf->pdev->dev, "dump switch\n");
 			dev_info(&pf->pdev->dev, "dump vsi [seid]\n");
 			dev_info(&pf->pdev->dev, "dump reset stats\n");
@@ -1560,6 +1596,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 		dev_info(&pf->pdev->dev, "  dump vsi [seid]\n");
 		dev_info(&pf->pdev->dev, "  dump desc tx <vsi_seid> <ring_id> [<desc_n>]\n");
 		dev_info(&pf->pdev->dev, "  dump desc rx <vsi_seid> <ring_id> [<desc_n>]\n");
+		dev_info(&pf->pdev->dev, "  dump desc xdp <vsi_seid> <ring_id> [<desc_n>]\n");
 		dev_info(&pf->pdev->dev, "  dump desc aq\n");
 		dev_info(&pf->pdev->dev, "  dump reset stats\n");
 		dev_info(&pf->pdev->dev, "  dump debug fwdata <cluster_id> <table_id> <index>\n");
-- 
2.26.2

