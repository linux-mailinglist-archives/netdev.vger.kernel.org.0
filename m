Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A661165228
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBSWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgBSWG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824809"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/13] ice: Always clear the QRXFLXP_CNTXT register for VF Rx queues
Date:   Wed, 19 Feb 2020 14:06:43 -0800
Message-Id: <20200219220652.2255171-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when the PF reduces its number of channels via ethtool and
then VFs are created there may be stale data for some of the Rx queues
belonging to VFs. This happens when a VF reuses an Rx queue that was
previously used by the PF. Specifically, the QRXFLXP_CNTXT register
will have incorrect values. Fix this by always clearing the relevant
values in the QRXFLXP_CNTXT register for VF queues.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c       | 8 ++++++--
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 75cc5a366b26..54aa533f36d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -386,8 +386,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	 /* Enable Flexible Descriptors in the queue context which
 	  * allows this driver to select a specific receive descriptor format
 	  */
+	regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
 	if (vsi->type != ICE_VSI_VF) {
-		regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
 		regval |= (rxdid << QRXFLXP_CNTXT_RXDID_IDX_S) &
 			QRXFLXP_CNTXT_RXDID_IDX_M;
 
@@ -398,8 +398,12 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 		regval |= (0x03 << QRXFLXP_CNTXT_RXDID_PRIO_S) &
 			QRXFLXP_CNTXT_RXDID_PRIO_M;
 
-		wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
+	} else {
+		regval &= ~(QRXFLXP_CNTXT_RXDID_IDX_M |
+			    QRXFLXP_CNTXT_RXDID_PRIO_M |
+			    QRXFLXP_CNTXT_TS_M);
 	}
+	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 43e4efbccd8e..1d37a9f02c1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -85,6 +85,7 @@
 #define QRXFLXP_CNTXT_RXDID_IDX_M		ICE_M(0x3F, 0)
 #define QRXFLXP_CNTXT_RXDID_PRIO_S		8
 #define QRXFLXP_CNTXT_RXDID_PRIO_M		ICE_M(0x7, 8)
+#define QRXFLXP_CNTXT_TS_M			BIT(11)
 #define GLGEN_RSTAT				0x000B8188
 #define GLGEN_RSTAT_DEVSTATE_M			ICE_M(0x3, 0)
 #define GLGEN_RSTCTL				0x000B8180
-- 
2.24.1

