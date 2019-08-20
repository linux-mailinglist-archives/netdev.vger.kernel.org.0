Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7224E96BC5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfHTVvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:51:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:28767 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbfHTVux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330538"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Pawel Kaminski <pawel.kaminski@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 13/14] ice: Change type for queue counts
Date:   Tue, 20 Aug 2019 14:50:47 -0700
Message-Id: <20190820215048.14377-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pawel Kaminski <pawel.kaminski@intel.com>

These queue variables are being assigned values that are type u16.
Change the local variables to match these types. Since these
represent queue counts, they should never be negative.

Signed-off-by: Pawel Kaminski <pawel.kaminski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 8a5bf9730fdf..61cf1c5af928 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2337,11 +2337,11 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vf_res_request *vfres =
 		(struct virtchnl_vf_res_request *)msg;
-	int req_queues = vfres->num_queue_pairs;
+	u16 req_queues = vfres->num_queue_pairs;
 	struct ice_pf *pf = vf->pf;
-	int max_allowed_vf_queues;
-	int tx_rx_queue_left;
-	int cur_queues;
+	u16 max_allowed_vf_queues;
+	u16 tx_rx_queue_left;
+	u16 cur_queues;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2349,29 +2349,30 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	cur_queues = vf->num_vf_qs;
-	tx_rx_queue_left = min_t(int, pf->q_left_tx, pf->q_left_rx);
+	tx_rx_queue_left = min_t(u16, pf->q_left_tx, pf->q_left_rx);
 	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
-	if (req_queues <= 0) {
+	if (!req_queues) {
 		dev_err(&pf->pdev->dev,
-			"VF %d tried to request %d queues. Ignoring.\n",
-			vf->vf_id, req_queues);
+			"VF %d tried to request 0 queues. Ignoring.\n",
+			vf->vf_id);
 	} else if (req_queues > ICE_MAX_BASE_QS_PER_VF) {
 		dev_err(&pf->pdev->dev,
 			"VF %d tried to request more than %d queues.\n",
 			vf->vf_id, ICE_MAX_BASE_QS_PER_VF);
 		vfres->num_queue_pairs = ICE_MAX_BASE_QS_PER_VF;
-	} else if (req_queues - cur_queues > tx_rx_queue_left) {
+	} else if (req_queues > cur_queues &&
+		   req_queues - cur_queues > tx_rx_queue_left) {
 		dev_warn(&pf->pdev->dev,
-			 "VF %d requested %d more queues, but only %d left.\n",
+			 "VF %d requested %u more queues, but only %u left.\n",
 			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
-		vfres->num_queue_pairs = min_t(int, max_allowed_vf_queues,
+		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
 					       ICE_MAX_BASE_QS_PER_VF);
 	} else {
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
 		ice_vc_dis_vf(vf);
 		dev_info(&pf->pdev->dev,
-			 "VF %d granted request of %d queues.\n",
+			 "VF %d granted request of %u queues.\n",
 			 vf->vf_id, req_queues);
 		return 0;
 	}
-- 
2.21.0

