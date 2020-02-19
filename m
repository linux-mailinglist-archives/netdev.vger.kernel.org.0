Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B299716521A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgBSWG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:06:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:51315 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgBSWG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824800"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Avinash Dayanand <avinash.dayanand@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/13] ice: Validate config for SW DCB map
Date:   Wed, 19 Feb 2020 14:06:40 -0800
Message-Id: <20200219220652.2255171-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avinash Dayanand <avinash.dayanand@intel.com>

Validate the inputs for SW DCB config received either via lldptool or pcap
file. And don't apply DCB for bad bandwidth inputs. Without this patch, any
config having bad inputs will cause the loss of link making PF unusable
even after driver reload. Recoverable only via system reboot.

Signed-off-by: Avinash Dayanand <avinash.dayanand@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 40 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  1 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c  |  6 +++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 7108fb41b604..1c118e7bab88 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -148,6 +148,43 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_dcb_bwchk - check if ETS bandwidth input parameters are correct
+ * @pf: pointer to the PF struct
+ * @dcbcfg: pointer to DCB config structure
+ */
+int ice_dcb_bwchk(struct ice_pf *pf, struct ice_dcbx_cfg *dcbcfg)
+{
+	struct ice_dcb_ets_cfg *etscfg = &dcbcfg->etscfg;
+	u8 num_tc, total_bw = 0;
+	int i;
+
+	/* returns number of contigous TCs and 1 TC for non-contigous TCs,
+	 * since at least 1 TC has to be configured
+	 */
+	num_tc = ice_dcb_get_num_tc(dcbcfg);
+
+	/* no bandwidth checks required if there's only one TC, so assign
+	 * all bandwidth to TC0 and return
+	 */
+	if (num_tc == 1) {
+		etscfg->tcbwtable[0] = ICE_TC_MAX_BW;
+		return 0;
+	}
+
+	for (i = 0; i < num_tc; i++)
+		total_bw += etscfg->tcbwtable[i];
+
+	if (!total_bw) {
+		etscfg->tcbwtable[0] = ICE_TC_MAX_BW;
+	} else if (total_bw != ICE_TC_MAX_BW) {
+		dev_err(ice_pf_to_dev(pf), "Invalid config, total bandwidth must equal 100\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * ice_pf_dcb_cfg - Apply new DCB configuration
  * @pf: pointer to the PF struct
@@ -182,6 +219,9 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		return ret;
 	}
 
+	if (ice_dcb_bwchk(pf, new_cfg))
+		return -EINVAL;
+
 	/* Store old config in case FW config fails */
 	old_cfg = kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);
 	if (!old_cfg)
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index f15e5776f287..37680e815b02 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -20,6 +20,7 @@ u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
+int ice_dcb_bwchk(struct ice_pf *pf, struct ice_dcbx_cfg *dcbcfg);
 void ice_pf_dcb_recfg(struct ice_pf *pf);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index b61aba428adb..c572aa5c28e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -95,6 +95,11 @@ static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
 		new_cfg->etsrec.prio_table[i] = ets->reco_prio_tc[i];
 	}
 
+	if (ice_dcb_bwchk(pf, new_cfg)) {
+		err = -EINVAL;
+		goto ets_out;
+	}
+
 	/* max_tc is a 1-8 value count of number of TC's, not a 0-7 value
 	 * for the TC's index number.  Add one to value if not zero, and
 	 * for zero set it to the FW's default value
@@ -119,6 +124,7 @@ static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
 	if (err == ICE_DCB_NO_HW_CHG)
 		err = ICE_DCB_HW_CHG_RST;
 
+ets_out:
 	mutex_unlock(&pf->tc_mutex);
 	return err;
 }
-- 
2.24.1

