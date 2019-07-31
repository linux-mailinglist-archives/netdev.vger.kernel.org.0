Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC517CEE3
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfGaUlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:2714 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730764AbfGaUly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901034"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/16] ice: Update number of VF queue before setting VSI resources
Date:   Wed, 31 Jul 2019 13:41:41 -0700
Message-Id: <20190731204147.8582-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

In case there is a request from a VF to change its number of queues, and
the request was successful, we need to update number of queues
configured on the VF before updating corresponding VSI for that VF,
especially LAN Tx queue tree and TC update, otherwise, we would continued
to use old value of vf->num_vf_qs for allocated Tx/Rx queues...

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 5d24b539648f..00aa6364124a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -567,11 +567,6 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	int tx_rx_queue_left;
 	int status;
 
-	/* setup VF VSI and necessary resources */
-	status = ice_alloc_vsi_res(vf);
-	if (status)
-		goto ice_alloc_vf_res_exit;
-
 	/* Update number of VF queues, in case VF had requested for queue
 	 * changes
 	 */
@@ -581,6 +576,11 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	    vf->num_req_qs != vf->num_vf_qs)
 		vf->num_vf_qs = vf->num_req_qs;
 
+	/* setup VF VSI and necessary resources */
+	status = ice_alloc_vsi_res(vf);
+	if (status)
+		goto ice_alloc_vf_res_exit;
+
 	if (vf->trusted)
 		set_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
 	else
-- 
2.21.0

