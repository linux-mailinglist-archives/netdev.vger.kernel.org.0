Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B14135F9B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbgAIRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:47:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:61385 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbgAIRrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:47:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 09:47:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="254669781"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2020 09:47:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Arkady Gilinksky <arkady.gilinsky@harmonicinc.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 1/7] i40e: Fix virtchnl_queue_select bitmap validation
Date:   Thu,  9 Jan 2020 09:47:07 -0800
Message-Id: <20200109174713.2940499-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
References: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently in i40e_vc_disable_queues_msg() we are incorrectly
validating the virtchnl queue select bitmaps. The
virtchnl_queue_select rx_queues and tx_queue bitmap is being
compared against ICE_MAX_VF_QUEUES, but the problem is that
these bitmaps can have a value greater than I40E_MAX_VF_QUEUES.
Fix this by comparing the bitmaps against BIT(I40E_MAX_VF_QUEUES).

Also, add the function i40e_vc_validate_vqs_bitmaps() that checks to see
if both virtchnl_queue_select bitmaps are empty along with checking that
the bitmaps only have valid bits set. This function can then be used in
both the queue enable and disable flows.

Suggested-by: Arkady Gilinksky <arkady.gilinsky@harmonicinc.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6a3f0fc56c3b..69523ac85639 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2321,6 +2321,22 @@ static int i40e_ctrl_vf_rx_rings(struct i40e_vsi *vsi, unsigned long q_map,
 	return ret;
 }
 
+/**
+ * i40e_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTHCHNL
+ * @vqs: virtchnl_queue_select structure containing bitmaps to validate
+ *
+ * Returns true if validation was successful, else false.
+ */
+static bool i40e_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
+{
+	if ((!vqs->rx_queues && !vqs->tx_queues) ||
+	    vqs->rx_queues >= BIT(I40E_MAX_VF_QUEUES) ||
+	    vqs->tx_queues >= BIT(I40E_MAX_VF_QUEUES))
+		return false;
+
+	return true;
+}
+
 /**
  * i40e_vc_enable_queues_msg
  * @vf: pointer to the VF info
@@ -2346,7 +2362,7 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if ((0 == vqs->rx_queues) && (0 == vqs->tx_queues)) {
+	if (i40e_vc_validate_vqs_bitmaps(vqs)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2408,9 +2424,7 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
-	    vqs->rx_queues > I40E_MAX_VF_QUEUES ||
-	    vqs->tx_queues > I40E_MAX_VF_QUEUES) {
+	if (i40e_vc_validate_vqs_bitmaps(vqs)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
-- 
2.24.1

