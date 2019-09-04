Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32DFA79EC
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfIDEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfIDEfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804423"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Always notify FW of VF reset
Date:   Tue,  3 Sep 2019 21:35:09 -0700
Message-Id: <20190904043512.28066-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

The call to ice_dis_vsi_txq() acts as the notification to the firmware
that the VF is being reset. Because of this, we need to make this call
every time we reset, regardless of whatever else we do to stop the Tx
queues.

Without this change, VF resets would fail to complete on interfaces that
were up and running.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index b93324e9f4bc..c58e3e3212df 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1074,9 +1074,16 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	for (v = 0; v < pf->num_alloc_vfs; v++)
 		ice_trigger_vf_reset(&pf->vf[v], is_vflr);
 
-	for (v = 0; v < pf->num_alloc_vfs; v++)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[v].vf_states))
-			ice_dis_vf_qs(&pf->vf[v]);
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		struct ice_vsi *vsi;
+
+		vf = &pf->vf[v];
+		vsi = pf->vsi[vf->lan_vsi_idx];
+		if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
+			ice_dis_vf_qs(vf);
+		ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
+				NULL, ICE_VF_RESET, vf->vf_id, NULL);
+	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -1171,12 +1178,12 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
 		ice_dis_vf_qs(vf);
-	else
-		/* Call Disable LAN Tx queue AQ call even when queues are not
-		 * enabled. This is needed for successful completion of VFR
-		 */
-		ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
-				NULL, ICE_VF_RESET, vf->vf_id, NULL);
+
+	/* Call Disable LAN Tx queue AQ whether or not queues are
+	 * enabled. This is needed for successful completion of VFR.
+	 */
+	ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
+			NULL, ICE_VF_RESET, vf->vf_id, NULL);
 
 	hw = &pf->hw;
 	/* poll VPGEN_VFRSTAT reg to make sure
-- 
2.21.0

