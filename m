Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA40107A97
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKVW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:29:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:7936 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfKVW3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:29:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:29:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409027344"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:29:09 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/15] ice: Only disable VF state when freeing each VF resources
Date:   Fri, 22 Nov 2019 14:28:56 -0800
Message-Id: <20191122222905.670858-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

It is wrong to set PF disable state flag for all VFs when freeing VF
resources - Instead, we should set VF disable state flag for each VF with
its resources being returned to the device. Right now, all VF opcodes,
mailbox communication to clear its resources as well fails - since we
already indicate that PF is in disable state, with all VFs not active. In
addition, we don't need to notify VF that PF is intending to reset it, if
it is already in disabled state.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index f8d26674cf5a..869111a45d61 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -318,8 +318,9 @@ void ice_free_vfs(struct ice_pf *pf)
 	pf->num_alloc_vfs = 0;
 	for (i = 0; i < tmp; i++) {
 		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
-			/* disable VF qp mappings */
+			/* disable VF qp mappings and set VF disable state */
 			ice_dis_vf_mappings(&pf->vf[i]);
+			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
 			ice_free_vf_res(&pf->vf[i]);
 		}
 	}
@@ -1303,9 +1304,12 @@ static void ice_vc_notify_vf_reset(struct ice_vf *vf)
 	if (!vf || vf->vf_id >= vf->pf->num_alloc_vfs)
 		return;
 
-	/* verify if the VF is in either init or active before proceeding */
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
-	    !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+	/* Bail out if VF is in disabled state, neither initialized, nor active
+	 * state - otherwise proceed with notifications
+	 */
+	if ((!test_bit(ICE_VF_STATE_INIT, vf->vf_states) &&
+	     !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) ||
+	    test_bit(ICE_VF_STATE_DIS, vf->vf_states))
 		return;
 
 	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
-- 
2.23.0

