Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34F6571CB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfFZTau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:41408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfFZTag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762482"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/10] i40e: Fix descriptor count manipulation
Date:   Wed, 26 Jun 2019 12:31:01 -0700
Message-Id: <20190626193103.2169-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Changing descriptor count via 'ethtool -G' is not persistent across resets.
When PF reset occurs, we roll back to the default value of vsi->num_desc,
which is used then in i40e_alloc_rings to set descriptor count. XDP does a
PF reset so when user has changed the descriptor count and load XDP
program, the default count will be back there.

To fix this:
  * introduce new VSI members - num_tx_desc and num_rx_desc in favour of
    num_desc
  * set them in i40e_set_ringparam to user's values
  * set them to default values in i40e_set_num_rings_in_vsi only when they
    don't have previous values

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  3 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  5 +--
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  4 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 36 +++++++++++++------
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 8dc98d1d2e86..24e6ce6517a7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -775,7 +775,8 @@ struct i40e_vsi {
 	u16 alloc_queue_pairs;	/* Allocated Tx/Rx queues */
 	u16 req_queue_pairs;	/* User requested queue pairs */
 	u16 num_queue_pairs;	/* Used tx and rx pairs */
-	u16 num_desc;
+	u16 num_tx_desc;
+	u16 num_rx_desc;
 	enum i40e_vsi_type type;  /* VSI type, e.g., LAN, FCoE, etc */
 	s16 vf_id;		/* Virtual function ID for SRIOV VSIs */
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index dc5b40013e61..55d20acfcf70 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -333,8 +333,9 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 		 "    seid = %d, id = %d, uplink_seid = %d\n",
 		 vsi->seid, vsi->id, vsi->uplink_seid);
 	dev_info(&pf->pdev->dev,
-		 "    base_queue = %d, num_queue_pairs = %d, num_desc = %d\n",
-		 vsi->base_queue, vsi->num_queue_pairs, vsi->num_desc);
+		 "    base_queue = %d, num_queue_pairs = %d, num_tx_desc = %d, num_rx_desc = %d\n",
+		 vsi->base_queue, vsi->num_queue_pairs, vsi->num_tx_desc,
+		 vsi->num_rx_desc);
 	dev_info(&pf->pdev->dev, "    type = %i\n", vsi->type);
 	if (vsi->type == I40E_VSI_SRIOV)
 		dev_info(&pf->pdev->dev, "    VF ID = %i\n", vsi->vf_id);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index a6c5e10421dd..527eb52c5401 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1982,6 +1982,8 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			if (i40e_enabled_xdp_vsi(vsi))
 				vsi->xdp_rings[i]->count = new_tx_count;
 		}
+		vsi->num_tx_desc = new_tx_count;
+		vsi->num_rx_desc = new_rx_count;
 		goto done;
 	}
 
@@ -2118,6 +2120,8 @@ static int i40e_set_ringparam(struct net_device *netdev,
 		rx_rings = NULL;
 	}
 
+	vsi->num_tx_desc = new_tx_count;
+	vsi->num_rx_desc = new_rx_count;
 	i40e_up(vsi);
 
 free_tx:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6a10f9f9479c..ff1525e0dc3d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10078,8 +10078,12 @@ static int i40e_set_num_rings_in_vsi(struct i40e_vsi *vsi)
 	switch (vsi->type) {
 	case I40E_VSI_MAIN:
 		vsi->alloc_queue_pairs = pf->num_lan_qps;
-		vsi->num_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
-				      I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_tx_desc)
+			vsi->num_tx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_rx_desc)
+			vsi->num_rx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
 		if (pf->flags & I40E_FLAG_MSIX_ENABLED)
 			vsi->num_q_vectors = pf->num_lan_msix;
 		else
@@ -10089,22 +10093,32 @@ static int i40e_set_num_rings_in_vsi(struct i40e_vsi *vsi)
 
 	case I40E_VSI_FDIR:
 		vsi->alloc_queue_pairs = 1;
-		vsi->num_desc = ALIGN(I40E_FDIR_RING_COUNT,
-				      I40E_REQ_DESCRIPTOR_MULTIPLE);
+		vsi->num_tx_desc = ALIGN(I40E_FDIR_RING_COUNT,
+					 I40E_REQ_DESCRIPTOR_MULTIPLE);
+		vsi->num_rx_desc = ALIGN(I40E_FDIR_RING_COUNT,
+					 I40E_REQ_DESCRIPTOR_MULTIPLE);
 		vsi->num_q_vectors = pf->num_fdsb_msix;
 		break;
 
 	case I40E_VSI_VMDQ2:
 		vsi->alloc_queue_pairs = pf->num_vmdq_qps;
-		vsi->num_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
-				      I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_tx_desc)
+			vsi->num_tx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_rx_desc)
+			vsi->num_rx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
 		vsi->num_q_vectors = pf->num_vmdq_msix;
 		break;
 
 	case I40E_VSI_SRIOV:
 		vsi->alloc_queue_pairs = pf->num_vf_qps;
-		vsi->num_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
-				      I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_tx_desc)
+			vsi->num_tx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
+		if (!vsi->num_rx_desc)
+			vsi->num_rx_desc = ALIGN(I40E_DEFAULT_NUM_DESCRIPTORS,
+						 I40E_REQ_DESCRIPTOR_MULTIPLE);
 		break;
 
 	default:
@@ -10380,7 +10394,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->vsi = vsi;
 		ring->netdev = vsi->netdev;
 		ring->dev = &pf->pdev->dev;
-		ring->count = vsi->num_desc;
+		ring->count = vsi->num_tx_desc;
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		if (vsi->back->hw_features & I40E_HW_WB_ON_ITR_CAPABLE)
@@ -10397,7 +10411,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->vsi = vsi;
 		ring->netdev = NULL;
 		ring->dev = &pf->pdev->dev;
-		ring->count = vsi->num_desc;
+		ring->count = vsi->num_tx_desc;
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		if (vsi->back->hw_features & I40E_HW_WB_ON_ITR_CAPABLE)
@@ -10413,7 +10427,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->vsi = vsi;
 		ring->netdev = vsi->netdev;
 		ring->dev = &pf->pdev->dev;
-		ring->count = vsi->num_desc;
+		ring->count = vsi->num_rx_desc;
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		ring->itr_setting = pf->rx_itr_default;
-- 
2.21.0

