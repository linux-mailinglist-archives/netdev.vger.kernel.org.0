Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721E1179C53
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbgCDXVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:59250 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388531AbgCDXVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094611"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/16] iavf: Enable support for up to 16 queues
Date:   Wed,  4 Mar 2020 15:21:22 -0800
Message-Id: <20200304232136.4172118-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

Previous devices could only allocate 4 MSI-X vectors per VF so there was a
limitation of 4 queues. 800-series hardware can allocate more than 4 MSI-X
vectors, so expand the limitation on the number of queues that the driver
can support to account for these capabilities.

Fix ethtool channel operations to accommodate this change and adjust the
reporting of max number of queues to what is given to us by the PF. Since
we're not requesting queues above this value, just trigger reset to
activate the queues, which we already own.

Finally, fix a test condition that would display an incorrect error
message.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 20 +++++++-------
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 27 -------------------
 4 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index bd1b1ed323f4..bcd11b4b29df 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -81,7 +81,7 @@ struct iavf_vsi {
 #define IAVF_TX_DESC(R, i) (&(((struct iavf_tx_desc *)((R)->desc))[i]))
 #define IAVF_TX_CTXTDESC(R, i) \
 	(&(((struct iavf_tx_context_desc *)((R)->desc))[i]))
-#define IAVF_MAX_REQ_QUEUES 4
+#define IAVF_MAX_REQ_QUEUES 16
 
 #define IAVF_HKEY_ARRAY_SIZE ((IAVF_VFQF_HKEY_MAX_INDEX + 1) * 4)
 #define IAVF_HLUT_ARRAY_SIZE ((IAVF_VFQF_HLUT_MAX_INDEX + 1) * 4)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 84c3d8d97ef6..f807e2c7597f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -860,7 +860,7 @@ static void iavf_get_channels(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	/* Report maximum channels */
-	ch->max_combined = IAVF_MAX_REQ_QUEUES;
+	ch->max_combined = adapter->vsi_res->num_queue_pairs;
 
 	ch->max_other = NONQ_VECS;
 	ch->other_count = NONQ_VECS;
@@ -881,14 +881,7 @@ static int iavf_set_channels(struct net_device *netdev,
 			     struct ethtool_channels *ch)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	int num_req = ch->combined_count;
-
-	if (num_req != adapter->num_active_queues &&
-	    !(adapter->vf_res->vf_cap_flags &
-	      VIRTCHNL_VF_OFFLOAD_REQ_QUEUES)) {
-		dev_info(&adapter->pdev->dev, "PF is not capable of queue negotiation.\n");
-		return -EINVAL;
-	}
+	u32 num_req = ch->combined_count;
 
 	if ((adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ) &&
 	    adapter->num_tc) {
@@ -899,14 +892,19 @@ static int iavf_set_channels(struct net_device *netdev,
 	/* All of these should have already been checked by ethtool before this
 	 * even gets to us, but just to be sure.
 	 */
-	if (num_req <= 0 || num_req > IAVF_MAX_REQ_QUEUES)
+	if (num_req > adapter->vsi_res->num_queue_pairs)
 		return -EINVAL;
 
+	if (num_req == adapter->num_active_queues)
+		return 0;
+
 	if (ch->rx_count || ch->tx_count || ch->other_count != NONQ_VECS)
 		return -EINVAL;
 
 	adapter->num_req_queues = num_req;
-	return iavf_request_queues(adapter, num_req);
+	adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
+	iavf_schedule_reset(adapter);
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 76361bd468db..2050649848ba 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3450,7 +3450,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	}
 
 	if (num_req_queues &&
-	    num_req_queues != adapter->vsi_res->num_queue_pairs) {
+	    num_req_queues > adapter->vsi_res->num_queue_pairs) {
 		/* Problem.  The PF gave us fewer queues than what we had
 		 * negotiated in our request.  Need a reset to see if we can't
 		 * get back to a working state.
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 1ab9cb339acb..d58374c2c33d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -396,33 +396,6 @@ void iavf_map_queues(struct iavf_adapter *adapter)
 	kfree(vimi);
 }
 
-/**
- * iavf_request_queues
- * @adapter: adapter structure
- * @num: number of requested queues
- *
- * We get a default number of queues from the PF.  This enables us to request a
- * different number.  Returns 0 on success, negative on failure
- **/
-int iavf_request_queues(struct iavf_adapter *adapter, int num)
-{
-	struct virtchnl_vf_res_request vfres;
-
-	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
-		/* bail because we already have a command pending */
-		dev_err(&adapter->pdev->dev, "Cannot request queues, command %d pending\n",
-			adapter->current_op);
-		return -EBUSY;
-	}
-
-	vfres.num_queue_pairs = min_t(int, num, num_online_cpus());
-
-	adapter->current_op = VIRTCHNL_OP_REQUEST_QUEUES;
-	adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
-	return iavf_send_pf_msg(adapter, VIRTCHNL_OP_REQUEST_QUEUES,
-				(u8 *)&vfres, sizeof(vfres));
-}
-
 /**
  * iavf_add_ether_addrs
  * @adapter: adapter structure
-- 
2.24.1

