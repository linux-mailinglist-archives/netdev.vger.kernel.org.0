Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BEC350A85
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhCaXHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:62991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhCaXH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:27 -0400
IronPort-SDR: 3sMLb15uK6B09tD0iLif7faGDWcg0c99jQXDQSoa0Q7WOUD1M9cMpVUK7Xnc2yzXXpP10MJYqT
 HW4fkowvvEcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587983"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:24 -0700
IronPort-SDR: iwDN63d32cdI6OXFZryh3lhQlV5YT1+Ya9ChKmcRVlrLeXHU23LlgnsY4MP3XSEXxgI9ataOkK
 +BFDcPvC7YoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680133"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 10/15] ice: Change ice_vsi_setup_q_map() to not depend on RSS
Date:   Wed, 31 Mar 2021 16:08:53 -0700
Message-Id: <20210331230858.782492-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, ice_vsi_setup_q_map() depends on the VSI's rss_size. However,
the Rx Queue Mapping section of the VSI context has no dependency on RSS.
Instead, limit the maximum number of Rx queues per TC based on the Rx
Queue mapping section of the VSI context, which currently allows for up
to 256 Rx queues per TC.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c | 50 ++++++++----------------
 2 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9bf346133cbd..ecbf62eddcc9 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -89,6 +89,7 @@
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
+#define ICE_MAX_RXQS_PER_TC		256	/* Used when setting VSI context per TC Rx queues */
 #define ICE_MAX_RESET_WAIT		20
 
 #define ICE_VSIQF_HKEY_ARRAY_SIZE	((VSIQF_HKEY_MAX_INDEX + 1) *	4)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0763696c3d08..f2cf914cba69 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -742,11 +742,10 @@ static void ice_set_dflt_vsi_ctx(struct ice_vsi_ctx *ctxt)
  */
 static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 {
-	u16 offset = 0, qmap = 0, tx_count = 0;
+	u16 offset = 0, qmap = 0, tx_count = 0, pow = 0;
+	u16 num_txq_per_tc, num_rxq_per_tc;
 	u16 qcount_tx = vsi->alloc_txq;
 	u16 qcount_rx = vsi->alloc_rxq;
-	u16 tx_numq_tc, rx_numq_tc;
-	u16 pow = 0, max_rss = 0;
 	bool ena_tc0 = false;
 	u8 netdev_tc = 0;
 	int i;
@@ -764,12 +763,15 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 		vsi->tc_cfg.ena_tc |= 1;
 	}
 
-	rx_numq_tc = qcount_rx / vsi->tc_cfg.numtc;
-	if (!rx_numq_tc)
-		rx_numq_tc = 1;
-	tx_numq_tc = qcount_tx / vsi->tc_cfg.numtc;
-	if (!tx_numq_tc)
-		tx_numq_tc = 1;
+	num_rxq_per_tc = min_t(u16, qcount_rx / vsi->tc_cfg.numtc, ICE_MAX_RXQS_PER_TC);
+	if (!num_rxq_per_tc)
+		num_rxq_per_tc = 1;
+	num_txq_per_tc = qcount_tx / vsi->tc_cfg.numtc;
+	if (!num_txq_per_tc)
+		num_txq_per_tc = 1;
+
+	/* find the (rounded up) power-of-2 of qcount */
+	pow = (u16)order_base_2(num_rxq_per_tc);
 
 	/* TC mapping is a function of the number of Rx queues assigned to the
 	 * VSI for each traffic class and the offset of these queues.
@@ -782,26 +784,6 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	 *
 	 * Setup number and offset of Rx queues for all TCs for the VSI
 	 */
-
-	qcount_rx = rx_numq_tc;
-
-	/* qcount will change if RSS is enabled */
-	if (test_bit(ICE_FLAG_RSS_ENA, vsi->back->flags)) {
-		if (vsi->type == ICE_VSI_PF || vsi->type == ICE_VSI_VF) {
-			if (vsi->type == ICE_VSI_PF)
-				max_rss = ICE_MAX_LG_RSS_QS;
-			else
-				max_rss = ICE_MAX_RSS_QS_PER_VF;
-			qcount_rx = min_t(u16, rx_numq_tc, max_rss);
-			if (!vsi->req_rxq)
-				qcount_rx = min_t(u16, qcount_rx,
-						  vsi->rss_size);
-		}
-	}
-
-	/* find the (rounded up) power-of-2 of qcount */
-	pow = (u16)order_base_2(qcount_rx);
-
 	ice_for_each_traffic_class(i) {
 		if (!(vsi->tc_cfg.ena_tc & BIT(i))) {
 			/* TC is not enabled */
@@ -815,16 +797,16 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 
 		/* TC is enabled */
 		vsi->tc_cfg.tc_info[i].qoffset = offset;
-		vsi->tc_cfg.tc_info[i].qcount_rx = qcount_rx;
-		vsi->tc_cfg.tc_info[i].qcount_tx = tx_numq_tc;
+		vsi->tc_cfg.tc_info[i].qcount_rx = num_rxq_per_tc;
+		vsi->tc_cfg.tc_info[i].qcount_tx = num_txq_per_tc;
 		vsi->tc_cfg.tc_info[i].netdev_tc = netdev_tc++;
 
 		qmap = ((offset << ICE_AQ_VSI_TC_Q_OFFSET_S) &
 			ICE_AQ_VSI_TC_Q_OFFSET_M) |
 			((pow << ICE_AQ_VSI_TC_Q_NUM_S) &
 			 ICE_AQ_VSI_TC_Q_NUM_M);
-		offset += qcount_rx;
-		tx_count += tx_numq_tc;
+		offset += num_rxq_per_tc;
+		tx_count += num_txq_per_tc;
 		ctxt->info.tc_mapping[i] = cpu_to_le16(qmap);
 	}
 
@@ -837,7 +819,7 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	if (offset)
 		vsi->num_rxq = offset;
 	else
-		vsi->num_rxq = qcount_rx;
+		vsi->num_rxq = num_rxq_per_tc;
 
 	vsi->num_txq = tx_count;
 
-- 
2.26.2

