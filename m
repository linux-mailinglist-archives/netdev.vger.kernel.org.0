Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA328D39
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388741AbfEWWd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:19070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbfEWWdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Fix hang when ethtool disables FW LLDP
Date:   Thu, 23 May 2019 15:33:31 -0700
Message-Id: <20190523223340.13449-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

When disabling and enabling VSIs, there are a couple of flows
that recursively acquire the RTNL lock which causes a deadlock.
Fix that.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 31 ++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  5 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  4 +--
 drivers/net/ethernet/intel/ice/ice_main.c    |  2 +-
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index e2e921506edc..8d849ef5cb0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -133,8 +133,10 @@ static void ice_pf_dcb_recfg(struct ice_pf *pf)
  * ice_pf_dcb_cfg - Apply new DCB configuration
  * @pf: pointer to the PF struct
  * @new_cfg: DCBX config to apply
+ * @locked: is the RTNL held
  */
-static int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg)
+static
+int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 {
 	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
@@ -163,7 +165,8 @@ static int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg)
 	/* avoid race conditions by holding the lock while disabling and
 	 * re-enabling the VSI
 	 */
-	rtnl_lock();
+	if (!locked)
+		rtnl_lock();
 	ice_pf_dis_all_vsi(pf, true);
 
 	memcpy(curr_cfg, new_cfg, sizeof(*curr_cfg));
@@ -192,7 +195,8 @@ static int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg)
 
 out:
 	ice_pf_ena_all_vsi(pf, true);
-	rtnl_unlock();
+	if (!locked)
+		rtnl_unlock();
 	devm_kfree(&pf->pdev->dev, old_cfg);
 	return ret;
 }
@@ -271,15 +275,16 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	prev_cfg->etscfg.tcbwtable[0] = ICE_TC_MAX_BW;
 	prev_cfg->etscfg.tsatable[0] = ICE_IEEE_TSA_ETS;
 	memcpy(&prev_cfg->etsrec, &prev_cfg->etscfg, sizeof(prev_cfg->etsrec));
-	ice_pf_dcb_cfg(pf, prev_cfg);
+	ice_pf_dcb_cfg(pf, prev_cfg, false);
 	devm_kfree(&pf->pdev->dev, prev_cfg);
 }
 
 /**
  * ice_dcb_init_cfg - set the initial DCB config in SW
  * @pf: pf to apply config to
+ * @locked: Is the RTNL held
  */
-static int ice_dcb_init_cfg(struct ice_pf *pf)
+static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
 {
 	struct ice_dcbx_cfg *newcfg;
 	struct ice_port_info *pi;
@@ -294,7 +299,7 @@ static int ice_dcb_init_cfg(struct ice_pf *pf)
 	memset(&pi->local_dcbx_cfg, 0, sizeof(*newcfg));
 
 	dev_info(&pf->pdev->dev, "Configuring initial DCB values\n");
-	if (ice_pf_dcb_cfg(pf, newcfg))
+	if (ice_pf_dcb_cfg(pf, newcfg, locked))
 		ret = -EINVAL;
 
 	devm_kfree(&pf->pdev->dev, newcfg);
@@ -305,8 +310,9 @@ static int ice_dcb_init_cfg(struct ice_pf *pf)
 /**
  * ice_dcb_sw_default_config - Apply a default DCB config
  * @pf: pf to apply config to
+ * @locked: was this function called with RTNL held
  */
-static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf)
+static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 {
 	struct ice_aqc_port_ets_elem buf = { 0 };
 	struct ice_dcbx_cfg *dcbcfg;
@@ -338,7 +344,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf)
 	dcbcfg->app[0].priority = 3;
 	dcbcfg->app[0].prot_id = ICE_APP_PROT_ID_FCOE;
 
-	ret = ice_pf_dcb_cfg(pf, dcbcfg);
+	ret = ice_pf_dcb_cfg(pf, dcbcfg, locked);
 	devm_kfree(&pf->pdev->dev, dcbcfg);
 	if (ret)
 		return ret;
@@ -349,8 +355,9 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf)
 /**
  * ice_init_pf_dcb - initialize DCB for a PF
  * @pf: pf to initiialize DCB for
+ * @locked: Was function called with RTNL held
  */
-int ice_init_pf_dcb(struct ice_pf *pf)
+int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 {
 	struct device *dev = &pf->pdev->dev;
 	struct ice_port_info *port_info;
@@ -386,7 +393,7 @@ int ice_init_pf_dcb(struct ice_pf *pf)
 	}
 
 	if (sw_default) {
-		err = ice_dcb_sw_dflt_cfg(pf);
+		err = ice_dcb_sw_dflt_cfg(pf, locked);
 		if (err) {
 			dev_err(&pf->pdev->dev,
 				"Failed to set local DCB config %d\n", err);
@@ -405,7 +412,7 @@ int ice_init_pf_dcb(struct ice_pf *pf)
 
 	set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 
-	err = ice_dcb_init_cfg(pf);
+	err = ice_dcb_init_cfg(pf, locked);
 	if (err)
 		goto dcb_init_err;
 
@@ -515,7 +522,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 
 		err = ice_lldp_to_dcb_cfg(event->msg_buf, dcbcfg);
 		if (!err)
-			ice_pf_dcb_cfg(pf, dcbcfg);
+			ice_pf_dcb_cfg(pf, dcbcfg, false);
 
 		devm_kfree(&pf->pdev->dev, dcbcfg);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index ca7b76faa03c..819081053ff5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -14,7 +14,7 @@ void ice_dcb_rebuild(struct ice_pf *pf);
 u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
-int ice_init_pf_dcb(struct ice_pf *pf);
+int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
 int
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
@@ -40,7 +40,8 @@ static inline u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg __always_unused *dcbcfg)
 	return 1;
 }
 
-static inline int ice_init_pf_dcb(struct ice_pf *pf)
+static inline int
+ice_init_pf_dcb(struct ice_pf *pf, bool __always_unused locked)
 {
 	dev_dbg(&pf->pdev->dev, "DCB not supported\n");
 	return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 76122a28da7e..c1511393846f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -458,7 +458,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 * will likely not need DCB, so failure to init is
 			 * not a concern of ethtool
 			 */
-			status = ice_init_pf_dcb(pf);
+			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_warn(&pf->pdev->dev, "Fail to init DCB\n");
 		} else {
@@ -497,7 +497,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 				dev_dbg(&pf->pdev->dev,
 					"Fail to reg for MIB change\n");
 
-			status = ice_init_pf_dcb(pf);
+			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_dbg(&pf->pdev->dev, "Fail to init DCB\n");
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cbe8c5f2d953..65def2773313 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2302,7 +2302,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_init_pf(pf);
 
-	err = ice_init_pf_dcb(pf);
+	err = ice_init_pf_dcb(pf, false);
 	if (err) {
 		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
-- 
2.21.0

