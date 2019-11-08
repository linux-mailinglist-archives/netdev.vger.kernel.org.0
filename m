Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCD8F58B3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbfKHUiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:11883 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbfKHUiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200403"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:07 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 01/15] ice: Use ice_ena_vsi and ice_dis_vsi in DCB configuration flow
Date:   Fri,  8 Nov 2019 12:37:52 -0800
Message-Id: <20191108203806.12109-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

DCB configuration flow needs to disable and enable only the PF (main)
VSI, so use ice_ena_vsi and ice_dis_vsi. To avoid the use of ifdef to
control the staticness of these functions, move them to ice_lib.c.

Also replace the allocate and copy of old_cfg to kmemdup() in
ice_pf_dcb_cfg().

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  4 -
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 31 ++++++--
 drivers/net/ethernet/intel/ice/ice_lib.c     | 56 ++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  4 +
 drivers/net/ethernet/intel/ice/ice_main.c    | 79 --------------------
 5 files changed, 84 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index f552a67467aa..7da4ae9608c4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -502,10 +502,6 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
-#ifdef CONFIG_DCB
-int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked);
-void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked);
-#endif /* CONFIG_DCB */
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 13da89e22123..baea28c712ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -150,6 +150,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 {
 	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
+	struct ice_vsi *pf_vsi;
 	int ret = 0;
 
 	curr_cfg = &pf->hw.port_info->local_dcbx_cfg;
@@ -169,15 +170,23 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	}
 
 	/* Store old config in case FW config fails */
-	old_cfg = devm_kzalloc(&pf->pdev->dev, sizeof(*old_cfg), GFP_KERNEL);
-	memcpy(old_cfg, curr_cfg, sizeof(*old_cfg));
+	old_cfg = kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);
+	if (!old_cfg)
+		return -ENOMEM;
+
+	pf_vsi = ice_get_main_vsi(pf);
+	if (!pf_vsi) {
+		dev_dbg(&pf->pdev->dev, "PF VSI doesn't exist\n");
+		ret = -EINVAL;
+		goto free_cfg;
+	}
 
 	/* avoid race conditions by holding the lock while disabling and
 	 * re-enabling the VSI
 	 */
 	if (!locked)
 		rtnl_lock();
-	ice_pf_dis_all_vsi(pf, true);
+	ice_dis_vsi(pf_vsi, true);
 
 	memcpy(curr_cfg, new_cfg, sizeof(*curr_cfg));
 	memcpy(&curr_cfg->etsrec, &curr_cfg->etscfg, sizeof(curr_cfg->etsrec));
@@ -204,10 +213,11 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	ice_pf_dcb_recfg(pf);
 
 out:
-	ice_pf_ena_all_vsi(pf, true);
+	ice_ena_vsi(pf_vsi, true);
 	if (!locked)
 		rtnl_unlock();
-	devm_kfree(&pf->pdev->dev, old_cfg);
+free_cfg:
+	kfree(old_cfg);
 	return ret;
 }
 
@@ -690,6 +700,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	struct ice_dcbx_cfg tmp_dcbx_cfg;
 	bool need_reconfig = false;
 	struct ice_port_info *pi;
+	struct ice_vsi *pf_vsi;
 	u8 type;
 	int ret;
 
@@ -761,8 +772,14 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	}
 
+	pf_vsi = ice_get_main_vsi(pf);
+	if (!pf_vsi) {
+		dev_dbg(&pf->pdev->dev, "PF VSI doesn't exist\n");
+		return;
+	}
+
 	rtnl_lock();
-	ice_pf_dis_all_vsi(pf, true);
+	ice_dis_vsi(pf_vsi, true);
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
@@ -774,6 +791,6 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	/* changes in configuration update VSI */
 	ice_pf_dcb_recfg(pf);
 
-	ice_pf_ena_all_vsi(pf, true);
+	ice_ena_vsi(pf_vsi, true);
 	rtnl_unlock();
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b1e96cac5b1f..f3cfd5017e29 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2040,6 +2040,62 @@ void ice_vsi_close(struct ice_vsi *vsi)
 	ice_vsi_free_rx_rings(vsi);
 }
 
+/**
+ * ice_ena_vsi - resume a VSI
+ * @vsi: the VSI being resume
+ * @locked: is the rtnl_lock already held
+ */
+int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
+{
+	int err = 0;
+
+	if (!test_bit(__ICE_NEEDS_RESTART, vsi->state))
+		return 0;
+
+	clear_bit(__ICE_NEEDS_RESTART, vsi->state);
+
+	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
+		if (netif_running(vsi->netdev)) {
+			if (!locked)
+				rtnl_lock();
+
+			err = ice_open(vsi->netdev);
+
+			if (!locked)
+				rtnl_unlock();
+		}
+	}
+
+	return err;
+}
+
+/**
+ * ice_dis_vsi - pause a VSI
+ * @vsi: the VSI being paused
+ * @locked: is the rtnl_lock already held
+ */
+void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
+{
+	if (test_bit(__ICE_DOWN, vsi->state))
+		return;
+
+	set_bit(__ICE_NEEDS_RESTART, vsi->state);
+
+	if (vsi->type == ICE_VSI_PF && vsi->netdev) {
+		if (netif_running(vsi->netdev)) {
+			if (!locked)
+				rtnl_lock();
+
+			ice_stop(vsi->netdev);
+
+			if (!locked)
+				rtnl_unlock();
+		} else {
+			ice_vsi_close(vsi);
+		}
+	}
+}
+
 /**
  * ice_free_res - free a block of resources
  * @res: pointer to the resource
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8d5a7978e066..2c5c01b7a582 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -62,6 +62,10 @@ int ice_vsi_release(struct ice_vsi *vsi);
 
 void ice_vsi_close(struct ice_vsi *vsi);
 
+int ice_ena_vsi(struct ice_vsi *vsi, bool locked);
+
+void ice_dis_vsi(struct ice_vsi *vsi, bool locked);
+
 int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
 
 int
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 32684fce7de6..5f3a692f28e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -435,43 +435,12 @@ static void ice_sync_fltr_subtask(struct ice_pf *pf)
 		}
 }
 
-/**
- * ice_dis_vsi - pause a VSI
- * @vsi: the VSI being paused
- * @locked: is the rtnl_lock already held
- */
-static void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
-{
-	if (test_bit(__ICE_DOWN, vsi->state))
-		return;
-
-	set_bit(__ICE_NEEDS_RESTART, vsi->state);
-
-	if (vsi->type == ICE_VSI_PF && vsi->netdev) {
-		if (netif_running(vsi->netdev)) {
-			if (!locked)
-				rtnl_lock();
-
-			ice_stop(vsi->netdev);
-
-			if (!locked)
-				rtnl_unlock();
-		} else {
-			ice_vsi_close(vsi);
-		}
-	}
-}
-
 /**
  * ice_pf_dis_all_vsi - Pause all VSIs on a PF
  * @pf: the PF
  * @locked: is the rtnl_lock already held
  */
-#ifdef CONFIG_DCB
-void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked)
-#else
 static void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked)
-#endif /* CONFIG_DCB */
 {
 	int v;
 
@@ -4440,54 +4409,6 @@ static void ice_vsi_release_all(struct ice_pf *pf)
 	}
 }
 
-/**
- * ice_ena_vsi - resume a VSI
- * @vsi: the VSI being resume
- * @locked: is the rtnl_lock already held
- */
-static int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
-{
-	int err = 0;
-
-	if (!test_bit(__ICE_NEEDS_RESTART, vsi->state))
-		return 0;
-
-	clear_bit(__ICE_NEEDS_RESTART, vsi->state);
-
-	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
-		if (netif_running(vsi->netdev)) {
-			if (!locked)
-				rtnl_lock();
-
-			err = ice_open(vsi->netdev);
-
-			if (!locked)
-				rtnl_unlock();
-		}
-	}
-
-	return err;
-}
-
-/**
- * ice_pf_ena_all_vsi - Resume all VSIs on a PF
- * @pf: the PF
- * @locked: is the rtnl_lock already held
- */
-#ifdef CONFIG_DCB
-int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked)
-{
-	int v;
-
-	ice_for_each_vsi(pf, v)
-		if (pf->vsi[v])
-			if (ice_ena_vsi(pf->vsi[v], locked))
-				return -EIO;
-
-	return 0;
-}
-#endif /* CONFIG_DCB */
-
 /**
  * ice_vsi_rebuild_by_type - Rebuild VSI of a given type
  * @pf: pointer to the PF instance
-- 
2.21.0

