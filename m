Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1B9F58B8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbfKHUiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:18 -0500
Received: from mga12.intel.com ([192.55.52.136]:11886 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732519AbfKHUiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200438"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 08/15] ice: Change max MSI-x vector_id check in cfg_irq_map
Date:   Fri,  8 Nov 2019 12:37:59 -0800
Message-Id: <20191108203806.12109-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we check to make sure the vector_id passed down from iavf
is less than or equal to pf->hw.func_caps.common_caps.num_msix_vectors.
This is incorrect because the vector_id is always 0-based and never
greater than or equal to the ICE_MAX_INTR_PER_VF. Fix this by checking
to make sure the vector_id is less than the max allowed interrupts per
VF (ICE_MAX_INTR_PER_VF).

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 639d1b2a9e19..2ac83ad3d1a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2173,9 +2173,11 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 
 		vector_id = map->vector_id;
 		vsi_id = map->vsi_id;
-		/* validate msg params */
-		if (!(vector_id < pf->hw.func_caps.common_cap
-		    .num_msix_vectors) || !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
+		/* vector_id is always 0-based for each VF, and can never be
+		 * larger than or equal to the max allowed interrupts per VF
+		 */
+		if (!(vector_id < ICE_MAX_INTR_PER_VF) ||
+		    !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
 		    (!vector_id && (map->rxq_map || map->txq_map))) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
-- 
2.21.0

