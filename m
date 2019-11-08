Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B47F58B4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732645AbfKHUiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:11886 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbfKHUiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200430"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/15] ice: configure software LLDP in ice_init_pf_dcb
Date:   Fri,  8 Nov 2019 12:37:57 -0800
Message-Id: <20191108203806.12109-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Move software LLDP configuration when FW DCBX is disabled to
ice_init_pf_dcb, since that is where the FW DCBX state is determined.
Remove this software LLDP configuration from ice_vsi_setup and
ice_set_priv_flags. Software configuration includes redirecting Rx LLDP
packets up the stack, when FW DCBX is not running.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 15 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  5 -----
 drivers/net/ethernet/intel/ice/ice_lib.c     | 14 ++++----------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 9448a289363d..1150dbd98d0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -594,6 +594,8 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
 		 pf->hw.func_caps.common_cap.maxtc);
 	if (err) {
+		struct ice_vsi *pf_vsi;
+
 		/* FW LLDP is disabled, activate SW DCBX/LLDP mode */
 		dev_info(&pf->pdev->dev,
 			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
@@ -606,6 +608,19 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 			goto dcb_init_err;
 		}
 
+		/* If the FW DCBX engine is not running then Rx LLDP packets
+		 * need to be redirected up the stack.
+		 */
+		pf_vsi = ice_get_main_vsi(pf);
+		if (!pf_vsi) {
+			dev_err(&pf->pdev->dev,
+				"Failed to set local DCB config\n");
+			err = -EIO;
+			goto dcb_init_err;
+		}
+
+		ice_cfg_sw_lldp(pf_vsi, false, true);
+
 		pf->dcbx_cap = DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
 		return 0;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f85d224f964d..1f00091f7906 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1206,11 +1206,6 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_warn(&pf->pdev->dev, "Fail to init DCB\n");
-
-			/* Forward LLDP packets to default VSI so that they
-			 * are passed up the stack
-			 */
-			ice_cfg_sw_lldp(vsi, false, true);
 		} else {
 			enum ice_status status;
 			bool dcbx_agent_status;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index bc37896930f2..ebcf81edcb19 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1881,23 +1881,17 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	 * out PAUSE or PFC frames. If enabled, FW can still send FC frames.
 	 * The rule is added once for PF VSI in order to create appropriate
 	 * recipe, since VSI/VSI list is ignored with drop action...
-	 * Also add rules to handle LLDP Tx and Rx packets.  Tx LLDP packets
-	 * need to be dropped so that VFs cannot send LLDP packets to reconfig
-	 * DCB settings in the HW.  Also, if the FW DCBX engine is not running
-	 * then Rx LLDP packets need to be redirected up the stack.
+	 * Also add rules to handle LLDP Tx packets.  Tx LLDP packets need to
+	 * be dropped so that VFs cannot send LLDP packets to reconfig DCB
+	 * settings in the HW.
 	 */
-	if (!ice_is_safe_mode(pf)) {
+	if (!ice_is_safe_mode(pf))
 		if (vsi->type == ICE_VSI_PF) {
 			ice_vsi_add_rem_eth_mac(vsi, true);
 
 			/* Tx LLDP packets */
 			ice_cfg_sw_lldp(vsi, true, true);
-
-			/* Rx LLDP packets */
-			if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-				ice_cfg_sw_lldp(vsi, false, true);
 		}
-	}
 
 	return vsi;
 
-- 
2.21.0

