Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18C9F069
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbfH0QjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:39:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:10368 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730257AbfH0Qif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876345"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: add validation in OP_CONFIG_VSI_QUEUES VF message
Date:   Tue, 27 Aug 2019 09:38:24 -0700
Message-Id: <20190827163832.8362-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Check num_queue_pairs to avoid access to unallocated field of
vsi->tx_rings/vsi->rx_rings. Without this validation we can set
vsi->alloc_txq/vsi->alloc_rxq to value smaller than ICE_MAX_BASE_QS_PER_VF
and send this command with num_queue_pairs greater than
vsi->alloc_txq/vsi->alloc_rxq. This lead to access to unallocated memory.

In VF vsi alloc_txq and alloc_rxq should be the same. Get minimum
because looks more readable.

Also add validation for ring_len param. It should be greater than 32 and
be multiple of 32. Incorrect value leads to hang traffic on PF.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 86637d99ee77..e6578d2f0876 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1712,6 +1712,19 @@ static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
 	return (vsi && (qid < vsi->alloc_txq));
 }
 
+/**
+ * ice_vc_isvalid_ring_len
+ * @ring_len: length of ring
+ *
+ * check for the valid ring count, should be multiple of ICE_REQ_DESC_MULTIPLE
+ */
+static bool ice_vc_isvalid_ring_len(u16 ring_len)
+{
+	return (ring_len >= ICE_MIN_NUM_DESC &&
+		ring_len <= ICE_MAX_NUM_DESC &&
+		!(ring_len % ICE_REQ_DESC_MULTIPLE));
+}
+
 /**
  * ice_vc_config_rss_key
  * @vf: pointer to the VF info
@@ -2107,16 +2120,17 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (qci->num_queue_pairs > ICE_MAX_BASE_QS_PER_VF) {
-		dev_err(&pf->pdev->dev,
-			"VF-%d requesting more than supported number of queues: %d\n",
-			vf->vf_id, qci->num_queue_pairs);
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
-	if (!vsi) {
+	if (qci->num_queue_pairs > ICE_MAX_BASE_QS_PER_VF ||
+	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
+		dev_err(&pf->pdev->dev,
+			"VF-%d requesting more than supported number of queues: %d\n",
+			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -2127,6 +2141,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		    qpi->rxq.vsi_id != qci->vsi_id ||
 		    qpi->rxq.queue_id != qpi->txq.queue_id ||
 		    qpi->txq.headwb_enabled ||
+		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
+		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
 		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
@@ -2137,7 +2153,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		/* copy Rx queue info from VF into VSI */
 		vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 		vsi->rx_rings[i]->count = qpi->rxq.ring_len;
-		if (qpi->rxq.databuffer_size > ((16 * 1024) - 128)) {
+		if (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
+		    qpi->rxq.databuffer_size < 1024) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
-- 
2.21.0

