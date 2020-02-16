Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57146160194
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBPDpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:45:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgBPDo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916605"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:57 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] ice: Fix virtchnl_queue_select bitmap validation
Date:   Sat, 15 Feb 2020 19:44:47 -0800
Message-Id: <20200216034452.1251706-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently in ice_vc_ena_qs_msg() we are incorrectly validating the
virtchnl queue select bitmaps. The virtchnl_queue_select rx_queues and
tx_queue bitmap is being compared against ICE_MAX_BASE_QS_PER_VF, but
the problem is that these bitmaps can have a value greater than
ICE_MAX_BASE_QS_PER_VF. Fix this by comparing the bitmaps against
BIT(ICE_MAX_BASE_QS_PER_VF).

Also, add the function ice_vc_validate_vqs_bitmaps() that checks to see
if both virtchnl_queue_select bitmaps are empty along with checking that
the bitmaps only have valid bits set. This function can then be used in
both the queue enable and disable flows.

Arkady Gilinksky's patch on the intel-wired-lan mailing list
("i40e/iavf: Fix msg interface between VF and PF") made me
aware of this issue.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 26 +++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 7c8ec4fee25b..a21f9d2edbbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2070,6 +2070,22 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 				     (u8 *)&stats, sizeof(stats));
 }
 
+/**
+ * ice_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTCHNL
+ * @vqs: virtchnl_queue_select structure containing bitmaps to validate
+ *
+ * Return true on successful validation, else false
+ */
+static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
+{
+	if ((!vqs->rx_queues && !vqs->tx_queues) ||
+	    vqs->rx_queues >= BIT(ICE_MAX_BASE_QS_PER_VF) ||
+	    vqs->tx_queues >= BIT(ICE_MAX_BASE_QS_PER_VF))
+		return false;
+
+	return true;
+}
+
 /**
  * ice_vc_ena_qs_msg
  * @vf: pointer to the VF info
@@ -2097,13 +2113,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (!vqs->rx_queues && !vqs->tx_queues) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
-	if (vqs->rx_queues > ICE_MAX_BASE_QS_PER_VF ||
-	    vqs->tx_queues > ICE_MAX_BASE_QS_PER_VF) {
+	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -2193,7 +2203,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (!vqs->rx_queues && !vqs->tx_queues) {
+	if (!ice_vc_validate_vqs_bitmaps(vqs)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
-- 
2.24.1

