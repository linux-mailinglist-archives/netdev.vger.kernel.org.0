Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6924279304
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgIYVJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:09:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:48591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbgIYVJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:09:43 -0400
IronPort-SDR: kzFY1mzsxyAB4xfXQgfqX1gydr3gjDXdi00SgZhGTEI0hJttbQjE85ECsHUSVdYjJ/CEUFHmxl
 dLnoApLwJeqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="161724527"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="161724527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:42 -0700
IronPort-SDR: gytlvxey0FU73PRzGGv3K6zAGdFcBLbsIGARyij+osAlwQenPsarWArIB15AU+SFatt5F/Z7Oz
 CixBU6HXBS1w==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="291979275"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net v2 3/4] ice: fix memory leak if register_netdev_fails
Date:   Fri, 25 Sep 2020 14:09:29 -0700
Message-Id: <20200925210930.4049734-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
References: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_setup_pf_sw function can cause a memory leak if register_netdev
fails, due to accidentally failing to free the VSI rings. Fix the memory
leak by using ice_vsi_release, ensuring we actually go through the full
teardown process.

This should be safe even if the netdevice is not registered because we
will have set the netdev pointer to NULL, ensuring ice_vsi_release won't
call unregister_netdev.

An alternative fix would be moving management of the PF VSI netdev into
the main VSI setup code. This is complicated and likely requires
significant refactor in how we manage VSIs

Fixes: 3a858ba392c3 ("ice: Add support for VSI allocation and deallocation")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_lib.h  |  6 ------
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++----------
 3 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f2682776f8c8..65cc78279501 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -246,7 +246,7 @@ static int ice_get_free_slot(void *array, int size, int curr)
  * ice_vsi_delete - delete a VSI from the switch
  * @vsi: pointer to VSI being removed
  */
-void ice_vsi_delete(struct ice_vsi *vsi)
+static void ice_vsi_delete(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_vsi_ctx *ctxt;
@@ -313,7 +313,7 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
  *
  * Returns 0 on success, negative on failure
  */
-int ice_vsi_clear(struct ice_vsi *vsi)
+static int ice_vsi_clear(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = NULL;
 	struct device *dev;
@@ -563,7 +563,7 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
  * ice_vsi_put_qs - Release queues from VSI to PF
  * @vsi: the VSI that is going to release queues
  */
-void ice_vsi_put_qs(struct ice_vsi *vsi)
+static void ice_vsi_put_qs(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	int i;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 981f3a156c24..3da17895a2b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -45,10 +45,6 @@ int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 
-void ice_vsi_delete(struct ice_vsi *vsi);
-
-int ice_vsi_clear(struct ice_vsi *vsi);
-
 #ifdef CONFIG_DCB
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 #endif /* CONFIG_DCB */
@@ -79,8 +75,6 @@ bool ice_is_reset_in_progress(unsigned long *state);
 void
 ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio);
 
-void ice_vsi_put_qs(struct ice_vsi *vsi);
-
 void ice_vsi_dis_irq(struct ice_vsi *vsi);
 
 void ice_vsi_free_irq(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 954f11f86f50..54a7f55eb8c1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3169,10 +3169,8 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		return -EBUSY;
 
 	vsi = ice_pf_vsi_setup(pf, pf->hw.port_info);
-	if (!vsi) {
-		status = -ENOMEM;
-		goto unroll_vsi_setup;
-	}
+	if (!vsi)
+		return -ENOMEM;
 
 	status = ice_cfg_netdev(vsi);
 	if (status) {
@@ -3219,12 +3217,7 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	}
 
 unroll_vsi_setup:
-	if (vsi) {
-		ice_vsi_free_q_vectors(vsi);
-		ice_vsi_delete(vsi);
-		ice_vsi_put_qs(vsi);
-		ice_vsi_clear(vsi);
-	}
+	ice_vsi_release(vsi);
 	return status;
 }
 
-- 
2.26.2

