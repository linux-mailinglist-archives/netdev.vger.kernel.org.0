Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D508FA79E8
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfIDEfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfIDEfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804417"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] ice: Limit Max TCs on devices with more than 4 ports
Date:   Tue,  3 Sep 2019 21:35:07 -0700
Message-Id: <20190904043512.28066-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

This patch limits the max TCs set by the driver to the value provided by
the firmware as per the capabilities of the device. Otherwise, hard coding
to 8 TC max would fail the device configurations with more than 4 ports.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c     | 12 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c    | 10 ++++++++--
 drivers/net/ethernet/intel/ice/ice_type.h       |  3 +++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 8ebc695171b6..4da0cde9695b 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -91,6 +91,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_SRIOV				0x0012
 #define ICE_AQC_CAPS_VF					0x0013
 #define ICE_AQC_CAPS_VSI				0x0017
+#define ICE_AQC_CAPS_DCB				0x0018
 #define ICE_AQC_CAPS_RSS				0x0040
 #define ICE_AQC_CAPS_RXQS				0x0041
 #define ICE_AQC_CAPS_TXQS				0x0042
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6c0abb284c10..9492cd34b09d 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1594,6 +1594,18 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 					  prefix, func_p->guar_num_vsi);
 			}
 			break;
+		case ICE_AQC_CAPS_DCB:
+			caps->dcb = (number == 1);
+			caps->active_tc_bitmap = logical_id;
+			caps->maxtc = phys_id;
+			ice_debug(hw, ICE_DBG_INIT,
+				  "%s: DCB = %d\n", prefix, caps->dcb);
+			ice_debug(hw, ICE_DBG_INIT,
+				  "%s: active TC bitmap = %d\n", prefix,
+				  caps->active_tc_bitmap);
+			ice_debug(hw, ICE_DBG_INIT,
+				  "%s: TC max = %d\n", prefix, caps->maxtc);
+			break;
 		case ICE_AQC_CAPS_RSS:
 			caps->rss_table_size = number;
 			caps->rss_table_entry_width = logical_id;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index d9578919aad8..4614ec95529b 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -413,7 +413,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 	memset(&pi->local_dcbx_cfg, 0, sizeof(*dcbcfg));
 
 	dcbcfg->etscfg.willing = 1;
-	dcbcfg->etscfg.maxtcs = 8;
+	dcbcfg->etscfg.maxtcs = hw->func_caps.common_cap.maxtc;
 	dcbcfg->etscfg.tcbwtable[0] = 100;
 	dcbcfg->etscfg.tsatable[0] = ICE_IEEE_TSA_ETS;
 
@@ -422,7 +422,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 	dcbcfg->etsrec.willing = 0;
 
 	dcbcfg->pfc.willing = 1;
-	dcbcfg->pfc.pfccap = IEEE_8021QAZ_MAX_TCS;
+	dcbcfg->pfc.pfccap = hw->func_caps.common_cap.maxtc;
 
 	dcbcfg->numapps = 1;
 	dcbcfg->app[0].selector = ICE_APP_SEL_ETHTYPE;
@@ -454,6 +454,9 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	err = ice_init_dcb(hw);
 	if (err) {
 		/* FW LLDP is disabled, activate SW DCBX/LLDP mode */
+		dev_info(&pf->pdev->dev,
+			 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
+			 pf->hw.func_caps.common_cap.maxtc);
 		dev_info(&pf->pdev->dev,
 			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
 		port_info->is_sw_lldp = true;
@@ -484,6 +487,9 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	if (err)
 		goto dcb_init_err;
 
+	dev_info(&pf->pdev->dev,
+		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
+		 pf->hw.func_caps.common_cap.maxtc);
 	dev_info(&pf->pdev->dev, "DCBX offload supported\n");
 	return err;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 40b028e73234..4501d50a7dcc 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -139,6 +139,9 @@ struct ice_phy_info {
 /* Common HW capabilities for SW use */
 struct ice_hw_common_caps {
 	u32 valid_functions;
+	/* DCB capabilities */
+	u32 active_tc_bitmap;
+	u32 maxtc;
 
 	/* Tx/Rx queues */
 	u16 num_rxq;		/* Number/Total Rx queues */
-- 
2.21.0

