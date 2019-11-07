Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D1F3B30
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfKGWOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:16683 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfKGWOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420892"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Implement DCBNL support
Date:   Thu,  7 Nov 2019 14:14:26 -0800
Message-Id: <20191107221438.17994-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Implement interface layer for the DCBNL subsystem. These are the functions
to support the callbacks defined in the dcbnl_rtnl_ops struct. These
callbacks are going to be used to interface with the DCB settings of the
device. Implementation of dcb_nl set functions and supporting SW DCB
functions.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  15 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  15 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   | 933 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb_nl.h   |  19 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +
 9 files changed, 991 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcb_nl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcb_nl.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index df5a9699276a..7cb829132d28 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -20,5 +20,5 @@ ice-y := ice_main.o	\
 	 ice_flex_pipe.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
-ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_lib.o
+ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7da4ae9608c4..8d7e8fc55585 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -180,6 +180,7 @@ enum ice_state {
 	__ICE_NEEDS_RESTART,
 	__ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
 	__ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
+	__ICE_DCBNL_DEVRESET,		/* set by dcbnl devreset */
 	__ICE_PFR_REQ,			/* set by driver and peers */
 	__ICE_CORER_REQ,		/* set by driver and peers */
 	__ICE_GLOBR_REQ,		/* set by driver and peers */
@@ -365,6 +366,7 @@ struct ice_pf {
 	struct work_struct serv_task;
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
+	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index c00c68bacadb..9448a289363d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include "ice_dcb_lib.h"
+#include "ice_dcb_nl.h"
 
 static void ice_pf_dcb_recfg(struct ice_pf *pf);
 
@@ -155,16 +156,19 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
  * @new_cfg: DCBX config to apply
  * @locked: is the RTNL held
  */
-static
 int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 {
-	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
+	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
+	int ret = ICE_DCB_NO_HW_CHG;
 	struct ice_vsi *pf_vsi;
-	int ret = 0;
 
 	curr_cfg = &pf->hw.port_info->local_dcbx_cfg;
 
+	/* FW does not care if change happened */
+	if (!pf->hw.port_info->is_sw_lldp)
+		ret = ICE_DCB_HW_CHG_RST;
+
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(new_cfg) > 1) {
 		dev_dbg(&pf->pdev->dev, "DCB tagging enabled (num TC > 1)\n");
@@ -184,6 +188,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	if (!old_cfg)
 		return -ENOMEM;
 
+	dev_info(&pf->pdev->dev, "Commit DCB Configuration to the hardware\n");
 	pf_vsi = ice_get_main_vsi(pf);
 	if (!pf_vsi) {
 		dev_dbg(&pf->pdev->dev, "PF VSI doesn't exist\n");
@@ -200,6 +205,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 
 	memcpy(curr_cfg, new_cfg, sizeof(*curr_cfg));
 	memcpy(&curr_cfg->etsrec, &curr_cfg->etscfg, sizeof(curr_cfg->etsrec));
+	memcpy(&new_cfg->etsrec, &curr_cfg->etscfg, sizeof(curr_cfg->etsrec));
 
 	/* Only send new config to HW if we are in SW LLDP mode. Otherwise,
 	 * the new config came from the HW in the first place.
@@ -559,6 +565,8 @@ static void ice_pf_dcb_recfg(struct ice_pf *pf)
 		}
 
 		ice_vsi_map_rings_to_vectors(pf->vsi[v]);
+		if (pf->vsi[v]->type == ICE_VSI_PF)
+			ice_dcbnl_set_all(pf->vsi[v]);
 	}
 }
 
@@ -770,6 +778,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 
 	need_reconfig = ice_dcb_need_recfg(pf, &tmp_dcbx_cfg,
 					   &pi->local_dcbx_cfg);
+	ice_dcbnl_flush_apps(pf, &tmp_dcbx_cfg, &pi->local_dcbx_cfg);
 	if (!need_reconfig)
 		return;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 59e40cf2dd73..e90e25b7da77 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -9,12 +9,17 @@
 #include "ice_lib.h"
 
 #ifdef CONFIG_DCB
-#define ICE_TC_MAX_BW 100 /* Default Max BW percentage */
+#define ICE_TC_MAX_BW		100 /* Default Max BW percentage */
+#define ICE_DCB_HW_CHG_RST	0 /* DCB configuration changed with reset */
+#define ICE_DCB_NO_HW_CHG	1 /* DCB configuration did not change */
+#define ICE_DCB_HW_CHG		2 /* DCB configuration changed, no reset */
 
 void ice_dcb_rebuild(struct ice_pf *pf);
 u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
+int
+ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -57,6 +62,14 @@ ice_init_pf_dcb(struct ice_pf *pf, bool __always_unused locked)
 	return -EOPNOTSUPP;
 }
 
+static inline int
+ice_pf_dcb_cfg(struct ice_pf __always_unused *pf,
+	       struct ice_dcbx_cfg __always_unused *new_cfg,
+	       bool __always_unused locked)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 			      struct ice_tx_buf __always_unused *first)
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
new file mode 100644
index 000000000000..717efbb7c4d1
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -0,0 +1,933 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_dcb.h"
+#include "ice_dcb_lib.h"
+#include "ice_dcb_nl.h"
+#include <net/dcbnl.h>
+
+#define ICE_APP_PROT_ID_ROCE	0x8915
+
+/**
+ * ice_dcbnl_devreset - perform enough of a ifdown/ifup to sync DCBNL info
+ * @netdev: device associated with interface that needs reset
+ */
+static void ice_dcbnl_devreset(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	while (ice_is_reset_in_progress(pf->state))
+		usleep_range(1000, 2000);
+
+	set_bit(__ICE_DCBNL_DEVRESET, pf->state);
+	dev_close(netdev);
+	netdev_state_change(netdev);
+	dev_open(netdev, NULL);
+	netdev_state_change(netdev);
+	clear_bit(__ICE_DCBNL_DEVRESET, pf->state);
+}
+
+/**
+ * ice_dcbnl_getets - retrieve local ETS configuration
+ * @netdev: the relevant netdev
+ * @ets: struct to hold ETS configuration
+ */
+static int ice_dcbnl_getets(struct net_device *netdev, struct ieee_ets *ets)
+{
+	struct ice_dcbx_cfg *dcbxcfg;
+	struct ice_port_info *pi;
+	struct ice_pf *pf;
+
+	pf = ice_netdev_to_pf(netdev);
+	pi = pf->hw.port_info;
+	dcbxcfg = &pi->local_dcbx_cfg;
+
+	ets->willing = dcbxcfg->etscfg.willing;
+	ets->ets_cap = dcbxcfg->etscfg.maxtcs;
+	ets->cbs = dcbxcfg->etscfg.cbs;
+	memcpy(ets->tc_tx_bw, dcbxcfg->etscfg.tcbwtable, sizeof(ets->tc_tx_bw));
+	memcpy(ets->tc_rx_bw, dcbxcfg->etscfg.tcbwtable, sizeof(ets->tc_rx_bw));
+	memcpy(ets->tc_tsa, dcbxcfg->etscfg.tsatable, sizeof(ets->tc_tsa));
+	memcpy(ets->prio_tc, dcbxcfg->etscfg.prio_table, sizeof(ets->prio_tc));
+	memcpy(ets->tc_reco_bw, dcbxcfg->etsrec.tcbwtable,
+	       sizeof(ets->tc_reco_bw));
+	memcpy(ets->tc_reco_tsa, dcbxcfg->etsrec.tsatable,
+	       sizeof(ets->tc_reco_tsa));
+	memcpy(ets->reco_prio_tc, dcbxcfg->etscfg.prio_table,
+	       sizeof(ets->reco_prio_tc));
+
+	return 0;
+}
+
+/**
+ * ice_dcbnl_setets - set IEEE ETS configuration
+ * @netdev: pointer to relevant netdev
+ * @ets: struct to hold ETS configuration
+ */
+static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+	int bwcfg = 0, bwrec = 0;
+	int err, i, max_tc = 0;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
+		return -EINVAL;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	mutex_lock(&pf->tc_mutex);
+
+	new_cfg->etscfg.willing = ets->willing;
+	new_cfg->etscfg.cbs = ets->cbs;
+	ice_for_each_traffic_class(i) {
+		new_cfg->etscfg.tcbwtable[i] = ets->tc_tx_bw[i];
+		bwcfg += ets->tc_tx_bw[i];
+		new_cfg->etscfg.tsatable[i] = ets->tc_tsa[i];
+		new_cfg->etscfg.prio_table[i] = ets->prio_tc[i];
+		if (ets->prio_tc[i] > max_tc)
+			max_tc = ets->prio_tc[i];
+		new_cfg->etsrec.tcbwtable[i] = ets->tc_reco_bw[i];
+		bwrec += ets->tc_reco_bw[i];
+		new_cfg->etsrec.tsatable[i] = ets->tc_reco_tsa[i];
+		new_cfg->etsrec.prio_table[i] = ets->reco_prio_tc[i];
+	}
+
+	/* max_tc is a 1-8 value count of number of TC's, not a 0-7 value
+	 * for the TC's index number.  Add one to value if not zero, and
+	 * for zero set it to the FW's default value
+	 */
+	if (max_tc)
+		max_tc++;
+	else
+		max_tc = IEEE_8021QAZ_MAX_TCS;
+
+	new_cfg->etscfg.maxtcs = max_tc;
+
+	if (!bwcfg)
+		new_cfg->etscfg.tcbwtable[0] = 100;
+
+	if (!bwrec)
+		new_cfg->etsrec.tcbwtable[0] = 100;
+
+	err = ice_pf_dcb_cfg(pf, new_cfg, true);
+	/* return of zero indicates new cfg applied */
+	if (err == ICE_DCB_HW_CHG_RST)
+		ice_dcbnl_devreset(netdev);
+	if (err == ICE_DCB_NO_HW_CHG)
+		err = ICE_DCB_HW_CHG_RST;
+
+	mutex_unlock(&pf->tc_mutex);
+	return err;
+}
+
+/**
+ * ice_dcbnl_getnumtcs - Get max number of traffic classes supported
+ * @dev: pointer to netdev struct
+ * @tcid: TC ID
+ * @num: total number of TCs supported by the adapter
+ *
+ * Return the total number of TCs supported
+ */
+static int
+ice_dcbnl_getnumtcs(struct net_device *dev, int __always_unused tcid, u8 *num)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(dev);
+
+	if (!test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags))
+		return -EINVAL;
+
+	*num = IEEE_8021QAZ_MAX_TCS;
+	return 0;
+}
+
+/**
+ * ice_dcbnl_getdcbx - retrieve current DCBX capability
+ * @netdev: pointer to the netdev struct
+ */
+static u8 ice_dcbnl_getdcbx(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	return pf->dcbx_cap;
+}
+
+/**
+ * ice_dcbnl_setdcbx - set required DCBX capability
+ * @netdev: the corresponding netdev
+ * @mode: required mode
+ */
+static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	/* No support for LLD_MANAGED modes or CEE+IEEE */
+	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    ((mode & DCB_CAP_DCBX_VER_IEEE) && (mode & DCB_CAP_DCBX_VER_CEE)) ||
+	    !(mode & DCB_CAP_DCBX_HOST))
+		return ICE_DCB_NO_HW_CHG;
+
+	/* Already set to the given mode no change */
+	if (mode == pf->dcbx_cap)
+		return ICE_DCB_NO_HW_CHG;
+
+	pf->dcbx_cap = mode;
+	if (mode & DCB_CAP_DCBX_VER_CEE)
+		pf->hw.port_info->local_dcbx_cfg.dcbx_mode = ICE_DCBX_MODE_CEE;
+	else
+		pf->hw.port_info->local_dcbx_cfg.dcbx_mode = ICE_DCBX_MODE_IEEE;
+
+	dev_info(&pf->pdev->dev, "DCBx mode = 0x%x\n", mode);
+	return ICE_DCB_HW_CHG_RST;
+}
+
+/**
+ * ice_dcbnl_get_perm_hw_addr - MAC address used by DCBX
+ * @netdev: pointer to netdev struct
+ * @perm_addr: buffer to return permanent MAC address
+ */
+static void ice_dcbnl_get_perm_hw_addr(struct net_device *netdev, u8 *perm_addr)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+	int i, j;
+
+	memset(perm_addr, 0xff, MAX_ADDR_LEN);
+
+	for (i = 0; i < netdev->addr_len; i++)
+		perm_addr[i] = pi->mac.perm_addr[i];
+
+	for (j = 0; j < netdev->addr_len; j++, i++)
+		perm_addr[i] = pi->mac.perm_addr[j];
+}
+
+/**
+ * ice_get_pfc_delay - Retrieve PFC Link Delay
+ * @hw: pointer to HW struct
+ * @delay: holds the PFC Link Delay value
+ */
+static void ice_get_pfc_delay(struct ice_hw *hw, u16 *delay)
+{
+	u32 val;
+
+	val = rd32(hw, PRTDCB_GENC);
+	*delay = (u16)((val & PRTDCB_GENC_PFCLDA_M) >> PRTDCB_GENC_PFCLDA_S);
+}
+
+/**
+ * ice_dcbnl_getpfc - retrieve local IEEE PFC config
+ * @netdev: pointer to netdev struct
+ * @pfc: struct to hold PFC info
+ */
+static int ice_dcbnl_getpfc(struct net_device *netdev, struct ieee_pfc *pfc)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *dcbxcfg;
+	struct ice_port_info *pi = pf->hw.port_info;
+	int i;
+
+	dcbxcfg = &pi->local_dcbx_cfg;
+	pfc->pfc_cap = dcbxcfg->pfc.pfccap;
+	pfc->pfc_en = dcbxcfg->pfc.pfcena;
+	pfc->mbc = dcbxcfg->pfc.mbc;
+	ice_get_pfc_delay(&pf->hw, &pfc->delay);
+
+	ice_for_each_traffic_class(i) {
+		pfc->requests[i] = pf->stats.priority_xoff_tx[i];
+		pfc->indications[i] = pf->stats.priority_xoff_rx[i];
+	}
+
+	return 0;
+}
+
+/**
+ * ice_dcbnl_setpfc - set local IEEE PFC config
+ * @netdev: pointer to relevant netdev
+ * @pfc: pointer to struct holding PFC config
+ */
+static int ice_dcbnl_setpfc(struct net_device *netdev, struct ieee_pfc *pfc)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+	int err;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
+		return -EINVAL;
+
+	mutex_lock(&pf->tc_mutex);
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	if (pfc->pfc_cap)
+		new_cfg->pfc.pfccap = pfc->pfc_cap;
+	else
+		new_cfg->pfc.pfccap = pf->hw.func_caps.common_cap.maxtc;
+
+	new_cfg->pfc.pfcena = pfc->pfc_en;
+
+	err = ice_pf_dcb_cfg(pf, new_cfg, true);
+	if (err == ICE_DCB_HW_CHG_RST)
+		ice_dcbnl_devreset(netdev);
+	if (err == ICE_DCB_NO_HW_CHG)
+		err = ICE_DCB_HW_CHG_RST;
+	mutex_unlock(&pf->tc_mutex);
+	return err;
+}
+
+/**
+ * ice_dcbnl_get_pfc_cfg - Get CEE PFC config
+ * @netdev: pointer to netdev struct
+ * @prio: corresponding user priority
+ * @setting: the PFC setting for given priority
+ */
+static void
+ice_dcbnl_get_pfc_cfg(struct net_device *netdev, int prio, u8 *setting)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (prio >= ICE_MAX_USER_PRIORITY)
+		return;
+
+	*setting = (pi->local_dcbx_cfg.pfc.pfcena >> prio) & 0x1;
+	dev_dbg(&pf->pdev->dev,
+		"Get PFC Config up=%d, setting=%d, pfcenable=0x%x\n",
+		prio, *setting, pi->local_dcbx_cfg.pfc.pfcena);
+}
+
+/**
+ * ice_dcbnl_set_pfc_cfg - Set CEE PFC config
+ * @netdev: the corresponding netdev
+ * @prio: User Priority
+ * @set: PFC setting to apply
+ */
+static void ice_dcbnl_set_pfc_cfg(struct net_device *netdev, int prio, u8 set)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (prio >= ICE_MAX_USER_PRIORITY)
+		return;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	new_cfg->pfc.pfccap = pf->hw.func_caps.common_cap.maxtc;
+	if (set)
+		new_cfg->pfc.pfcena |= BIT(prio);
+	else
+		new_cfg->pfc.pfcena &= ~BIT(prio);
+
+	dev_dbg(&pf->pdev->dev, "Set PFC config UP:%d set:%d pfcena:0x%x\n",
+		prio, set, new_cfg->pfc.pfcena);
+}
+
+/**
+ * ice_dcbnl_getpfcstate - get CEE PFC mode
+ * @netdev: pointer to netdev struct
+ */
+static u8 ice_dcbnl_getpfcstate(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+
+	/* Return enabled if any UP enabled for PFC */
+	if (pi->local_dcbx_cfg.pfc.pfcena)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * ice_dcbnl_getstate - get DCB enabled state
+ * @netdev: pointer to netdev struct
+ */
+static u8 ice_dcbnl_getstate(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	u8 state = 0;
+
+	state = test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
+
+	dev_dbg(&pf->pdev->dev, "DCB enabled state = %d\n", state);
+	return state;
+}
+
+/**
+ * ice_dcbnl_setstate - Set CEE DCB state
+ * @netdev: pointer to relevant netdev
+ * @state: state value to set
+ */
+static u8 ice_dcbnl_setstate(struct net_device *netdev, u8 state)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return ICE_DCB_NO_HW_CHG;
+
+	/* Nothing to do */
+	if (!!state == test_bit(ICE_FLAG_DCB_ENA, pf->flags))
+		return ICE_DCB_NO_HW_CHG;
+
+	if (state) {
+		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
+		memcpy(&pf->hw.port_info->desired_dcbx_cfg,
+		       &pf->hw.port_info->local_dcbx_cfg,
+		       sizeof(struct ice_dcbx_cfg));
+	} else {
+		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+	}
+
+	return ICE_DCB_HW_CHG;
+}
+
+/**
+ * ice_dcbnl_get_pg_tc_cfg_tx - get CEE PG Tx config
+ * @netdev: pointer to netdev struct
+ * @prio: the corresponding user priority
+ * @prio_type: traffic priority type
+ * @pgid: the BW group ID the traffic class belongs to
+ * @bw_pct: BW percentage for the corresponding BWG
+ * @up_map: prio mapped to corresponding TC
+ */
+static void
+ice_dcbnl_get_pg_tc_cfg_tx(struct net_device *netdev, int prio,
+			   u8 __always_unused *prio_type, u8 *pgid,
+			   u8 __always_unused *bw_pct,
+			   u8 __always_unused *up_map)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (prio >= ICE_MAX_USER_PRIORITY)
+		return;
+
+	*pgid = pi->local_dcbx_cfg.etscfg.prio_table[prio];
+	dev_dbg(&pf->pdev->dev,
+		"Get PG config prio=%d tc=%d\n", prio, *pgid);
+}
+
+/**
+ * ice_dcbnl_set_pg_tc_cfg_tx - set CEE PG Tx config
+ * @netdev: pointer to relevant netdev
+ * @tc: the corresponding traffic class
+ * @prio_type: the traffic priority type
+ * @bwg_id: the BW group ID the TC belongs to
+ * @bw_pct: the BW perventage for the BWG
+ * @up_map: prio mapped to corresponding TC
+ */
+static void
+ice_dcbnl_set_pg_tc_cfg_tx(struct net_device *netdev, int tc,
+			   u8 __always_unused prio_type,
+			   u8 __always_unused bwg_id,
+			   u8 __always_unused bw_pct, u8 up_map)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+	int i;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (tc >= ICE_MAX_TRAFFIC_CLASS)
+		return;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	/* prio_type, bwg_id and bw_pct per UP are not supported */
+
+	ice_for_each_traffic_class(i) {
+		if (up_map & BIT(i))
+			new_cfg->etscfg.prio_table[i] = tc;
+	}
+	new_cfg->etscfg.tsatable[tc] = ICE_IEEE_TSA_ETS;
+}
+
+/**
+ * ice_dcbnl_get_pg_bwg_cfg_tx - Get CEE PGBW config
+ * @netdev: pointer to the netdev struct
+ * @pgid: corresponding traffic class
+ * @bw_pct: the BW percentage for the corresponding TC
+ */
+static void
+ice_dcbnl_get_pg_bwg_cfg_tx(struct net_device *netdev, int pgid, u8 *bw_pct)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (pgid >= ICE_MAX_TRAFFIC_CLASS)
+		return;
+
+	*bw_pct = pi->local_dcbx_cfg.etscfg.tcbwtable[pgid];
+	dev_dbg(&pf->pdev->dev, "Get PG BW config tc=%d bw_pct=%d\n",
+		pgid, *bw_pct);
+}
+
+/**
+ * ice_dcbnl_set_pg_bwg_cfg_tx - set CEE PG Tx BW config
+ * @netdev: the corresponding netdev
+ * @pgid: Correspongind traffic class
+ * @bw_pct: the BW percentage for the specified TC
+ */
+static void
+ice_dcbnl_set_pg_bwg_cfg_tx(struct net_device *netdev, int pgid, u8 bw_pct)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (pgid >= ICE_MAX_TRAFFIC_CLASS)
+		return;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	new_cfg->etscfg.tcbwtable[pgid] = bw_pct;
+}
+
+/**
+ * ice_dcbnl_get_pg_tc_cfg_rx - Get CEE PG Rx config
+ * @netdev: pointer to netdev struct
+ * @prio: the corresponding user priority
+ * @prio_type: the traffic priority type
+ * @pgid: the PG ID
+ * @bw_pct: the BW percentage for the corresponding BWG
+ * @up_map: prio mapped to corresponding TC
+ */
+static void
+ice_dcbnl_get_pg_tc_cfg_rx(struct net_device *netdev, int prio,
+			   u8 __always_unused *prio_type, u8 *pgid,
+			   u8 __always_unused *bw_pct,
+			   u8 __always_unused *up_map)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_port_info *pi = pf->hw.port_info;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	if (prio >= ICE_MAX_USER_PRIORITY)
+		return;
+
+	*pgid = pi->local_dcbx_cfg.etscfg.prio_table[prio];
+}
+
+/**
+ * ice_dcbnl_get_pg_bwg_cfg_rx - Get CEE PG BW Rx config
+ * @netdev: pointer to netdev struct
+ * @pgid: the corresponding traffic class
+ * @bw_pct: the BW percentage for the corresponding TC
+ */
+static void
+ice_dcbnl_get_pg_bwg_cfg_rx(struct net_device *netdev, int __always_unused pgid,
+			    u8 *bw_pct)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return;
+
+	*bw_pct = 0;
+}
+
+/**
+ * ice_dcbnl_get_cap - Get DCBX capabilities of adapter
+ * @netdev: pointer to netdev struct
+ * @capid: the capability type
+ * @cap: the capability value
+ */
+static u8 ice_dcbnl_get_cap(struct net_device *netdev, int capid, u8 *cap)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	if (!(test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags)))
+		return ICE_DCB_NO_HW_CHG;
+
+	switch (capid) {
+	case DCB_CAP_ATTR_PG:
+		*cap = true;
+		break;
+	case DCB_CAP_ATTR_PFC:
+		*cap = true;
+		break;
+	case DCB_CAP_ATTR_UP2TC:
+		*cap = false;
+		break;
+	case DCB_CAP_ATTR_PG_TCS:
+		*cap = 0x80;
+		break;
+	case DCB_CAP_ATTR_PFC_TCS:
+		*cap = 0x80;
+		break;
+	case DCB_CAP_ATTR_GSP:
+		*cap = false;
+		break;
+	case DCB_CAP_ATTR_BCN:
+		*cap = false;
+		break;
+	case DCB_CAP_ATTR_DCBX:
+		*cap = pf->dcbx_cap;
+		break;
+	default:
+		*cap = false;
+		break;
+	}
+
+	dev_dbg(&pf->pdev->dev, "DCBX Get Capability cap=%d capval=0x%x\n",
+		capid, *cap);
+	return 0;
+}
+
+/**
+ * ice_dcbnl_getapp - get CEE APP
+ * @netdev: pointer to netdev struct
+ * @idtype: the App selector
+ * @id: the App ethtype or port number
+ */
+static int ice_dcbnl_getapp(struct net_device *netdev, u8 idtype, u16 id)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct dcb_app app = {
+				.selector = idtype,
+				.protocol = id,
+			     };
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return -EINVAL;
+
+	return dcb_getapp(netdev, &app);
+}
+
+/**
+ * ice_dcbnl_find_app - Search for APP in given DCB config
+ * @cfg: struct to hold DCBX config
+ * @app: struct to hold app data to look for
+ */
+static bool
+ice_dcbnl_find_app(struct ice_dcbx_cfg *cfg,
+		   struct ice_dcb_app_priority_table *app)
+{
+	int i;
+
+	for (i = 0; i < cfg->numapps; i++) {
+		if (app->selector == cfg->app[i].selector &&
+		    app->prot_id == cfg->app[i].prot_id &&
+		    app->priority == cfg->app[i].priority)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_dcbnl_setapp - set local IEEE App config
+ * @netdev: relevant netdev struct
+ * @app: struct to hold app config info
+ */
+static int ice_dcbnl_setapp(struct net_device *netdev, struct dcb_app *app)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcb_app_priority_table new_app;
+	struct ice_dcbx_cfg *old_cfg, *new_cfg;
+	int ret;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
+		return -EINVAL;
+
+	mutex_lock(&pf->tc_mutex);
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	old_cfg = &pf->hw.port_info->local_dcbx_cfg;
+
+	if (old_cfg->numapps == ICE_DCBX_MAX_APPS) {
+		ret = -EINVAL;
+		goto setapp_out;
+	}
+
+	ret = dcb_ieee_setapp(netdev, app);
+	if (ret)
+		goto setapp_out;
+
+	new_app.selector = app->selector;
+	new_app.prot_id = app->protocol;
+	new_app.priority = app->priority;
+	if (ice_dcbnl_find_app(old_cfg, &new_app)) {
+		ret = 0;
+		goto setapp_out;
+	}
+
+	new_cfg->app[new_cfg->numapps++] = new_app;
+	ret = ice_pf_dcb_cfg(pf, new_cfg, true);
+	/* return of zero indicates new cfg applied */
+	if (ret == ICE_DCB_HW_CHG_RST)
+		ice_dcbnl_devreset(netdev);
+	if (ret == ICE_DCB_NO_HW_CHG)
+		ret = ICE_DCB_HW_CHG_RST;
+
+setapp_out:
+	mutex_unlock(&pf->tc_mutex);
+	return ret;
+}
+
+/**
+ * ice_dcbnl_delapp - Delete local IEEE App config
+ * @netdev: relevant netdev
+ * @app: struct to hold app too delete
+ *
+ * Will not delete first application required by the FW
+ */
+static int ice_dcbnl_delapp(struct net_device *netdev, struct dcb_app *app)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *old_cfg, *new_cfg;
+	int i, j, ret = 0;
+
+	if (pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED)
+		return -EINVAL;
+
+	mutex_lock(&pf->tc_mutex);
+	ret = dcb_ieee_delapp(netdev, app);
+	if (ret)
+		goto delapp_out;
+
+	old_cfg = &pf->hw.port_info->local_dcbx_cfg;
+
+	if (old_cfg->numapps == 1)
+		goto delapp_out;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	for (i = 1; i < new_cfg->numapps; i++) {
+		if (app->selector == new_cfg->app[i].selector &&
+		    app->protocol == new_cfg->app[i].prot_id &&
+		    app->priority == new_cfg->app[i].priority) {
+			new_cfg->app[i].selector = 0;
+			new_cfg->app[i].prot_id = 0;
+			new_cfg->app[i].priority = 0;
+			break;
+		}
+	}
+
+	/* Did not find DCB App */
+	if (i == new_cfg->numapps) {
+		ret = -EINVAL;
+		goto delapp_out;
+	}
+
+	new_cfg->numapps--;
+
+	for (j = i; j < new_cfg->numapps; j++) {
+		new_cfg->app[i].selector = old_cfg->app[j + 1].selector;
+		new_cfg->app[i].prot_id = old_cfg->app[j + 1].prot_id;
+		new_cfg->app[i].priority = old_cfg->app[j + 1].priority;
+	}
+
+	ret = ice_pf_dcb_cfg(pf, new_cfg, true);
+	/* return of zero indicates new cfg applied */
+	if (ret == ICE_DCB_HW_CHG_RST)
+		ice_dcbnl_devreset(netdev);
+	if (ret == ICE_DCB_NO_HW_CHG)
+		ret = ICE_DCB_HW_CHG_RST;
+
+delapp_out:
+	mutex_unlock(&pf->tc_mutex);
+	return ret;
+}
+
+/**
+ * ice_dcbnl_cee_set_all - Commit CEE DCB settings to HW
+ * @netdev: the corresponding netdev
+ */
+static u8 ice_dcbnl_cee_set_all(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_dcbx_cfg *new_cfg;
+	int err;
+
+	if ((pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) ||
+	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
+		return ICE_DCB_NO_HW_CHG;
+
+	new_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
+	mutex_lock(&pf->tc_mutex);
+
+	err = ice_pf_dcb_cfg(pf, new_cfg, true);
+
+	mutex_unlock(&pf->tc_mutex);
+	return (err != ICE_DCB_HW_CHG_RST) ? ICE_DCB_NO_HW_CHG : err;
+}
+
+static const struct dcbnl_rtnl_ops dcbnl_ops = {
+	/* IEEE 802.1Qaz std */
+	.ieee_getets = ice_dcbnl_getets,
+	.ieee_setets = ice_dcbnl_setets,
+	.ieee_getpfc = ice_dcbnl_getpfc,
+	.ieee_setpfc = ice_dcbnl_setpfc,
+	.ieee_setapp = ice_dcbnl_setapp,
+	.ieee_delapp = ice_dcbnl_delapp,
+
+	/* CEE std */
+	.getstate = ice_dcbnl_getstate,
+	.setstate = ice_dcbnl_setstate,
+	.getpermhwaddr = ice_dcbnl_get_perm_hw_addr,
+	.setpgtccfgtx = ice_dcbnl_set_pg_tc_cfg_tx,
+	.setpgbwgcfgtx = ice_dcbnl_set_pg_bwg_cfg_tx,
+	.getpgtccfgtx = ice_dcbnl_get_pg_tc_cfg_tx,
+	.getpgbwgcfgtx = ice_dcbnl_get_pg_bwg_cfg_tx,
+	.getpgtccfgrx = ice_dcbnl_get_pg_tc_cfg_rx,
+	.getpgbwgcfgrx = ice_dcbnl_get_pg_bwg_cfg_rx,
+	.setpfccfg = ice_dcbnl_set_pfc_cfg,
+	.getpfccfg = ice_dcbnl_get_pfc_cfg,
+	.setall = ice_dcbnl_cee_set_all,
+	.getcap = ice_dcbnl_get_cap,
+	.getnumtcs = ice_dcbnl_getnumtcs,
+	.getpfcstate = ice_dcbnl_getpfcstate,
+	.getapp = ice_dcbnl_getapp,
+
+	/* DCBX configuration */
+	.getdcbx = ice_dcbnl_getdcbx,
+	.setdcbx = ice_dcbnl_setdcbx,
+};
+
+/**
+ * ice_dcbnl_set_all - set all the apps and ieee data from DCBX config
+ * @vsi: pointer to VSI struct
+ */
+void ice_dcbnl_set_all(struct ice_vsi *vsi)
+{
+	struct net_device *netdev = vsi->netdev;
+	struct ice_dcbx_cfg *dcbxcfg;
+	struct ice_port_info *pi;
+	struct dcb_app sapp;
+	struct ice_pf *pf;
+	int i;
+
+	if (!netdev)
+		return;
+
+	pf = ice_netdev_to_pf(netdev);
+	pi = pf->hw.port_info;
+
+	/* SW DCB taken care of by SW Default Config */
+	if (pf->dcbx_cap & DCB_CAP_DCBX_HOST)
+		return;
+
+	/* DCB not enabled */
+	if (!test_bit(ICE_FLAG_DCB_ENA, pf->flags))
+		return;
+
+	dcbxcfg = &pi->local_dcbx_cfg;
+
+	for (i = 0; i < dcbxcfg->numapps; i++) {
+		u8 prio, tc_map;
+
+		prio = dcbxcfg->app[i].priority;
+		tc_map = BIT(dcbxcfg->etscfg.prio_table[prio]);
+
+		/* Add APP only if the TC is enabled for this VSI */
+		if (tc_map & vsi->tc_cfg.ena_tc) {
+			sapp.selector = dcbxcfg->app[i].selector;
+			sapp.protocol = dcbxcfg->app[i].prot_id;
+			sapp.priority = prio;
+			dcb_ieee_setapp(netdev, &sapp);
+		}
+	}
+	/* Notify user-space of the changes */
+	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, 0, 0);
+}
+
+/**
+ * ice_dcbnl_vsi_del_app - Delete APP on all VSIs
+ * @vsi: pointer to the main VSI
+ * @app: APP to delete
+ *
+ * Delete given APP from all the VSIs for given PF
+ */
+static void
+ice_dcbnl_vsi_del_app(struct ice_vsi *vsi,
+		      struct ice_dcb_app_priority_table *app)
+{
+	struct dcb_app sapp;
+	int err;
+
+	sapp.selector = app->selector;
+	sapp.protocol = app->prot_id;
+	sapp.priority = app->priority;
+	err = ice_dcbnl_delapp(vsi->netdev, &sapp);
+	dev_dbg(&vsi->back->pdev->dev,
+		"Deleting app for VSI idx=%d err=%d sel=%d proto=0x%x, prio=%d\n",
+		vsi->idx, err, app->selector, app->prot_id, app->priority);
+}
+
+/**
+ * ice_dcbnl_flush_apps - Delete all removed APPs
+ * @pf: the corresponding PF
+ * @old_cfg: old DCBX configuration data
+ * @new_cfg: new DCBX configuration data
+ *
+ * Find and delete all APPS that are not present in the passed
+ * DCB configuration
+ */
+void
+ice_dcbnl_flush_apps(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
+		     struct ice_dcbx_cfg *new_cfg)
+{
+	struct ice_vsi *main_vsi = ice_get_main_vsi(pf);
+	int i;
+
+	if (!main_vsi)
+		return;
+
+	for (i = 0; i < old_cfg->numapps; i++) {
+		struct ice_dcb_app_priority_table app = old_cfg->app[i];
+
+		/* The APP is not available anymore delete it */
+		if (!ice_dcbnl_find_app(new_cfg, &app))
+			ice_dcbnl_vsi_del_app(main_vsi, &app);
+	}
+}
+
+/**
+ * ice_dcbnl_setup - setup DCBNL
+ * @vsi: VSI to get associated netdev from
+ */
+void ice_dcbnl_setup(struct ice_vsi *vsi)
+{
+	struct net_device *netdev = vsi->netdev;
+	struct ice_pf *pf;
+
+	pf = ice_netdev_to_pf(netdev);
+	if (!test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags))
+		return;
+
+	netdev->dcbnl_ops = &dcbnl_ops;
+	ice_dcbnl_set_all(vsi);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.h b/drivers/net/ethernet/intel/ice/ice_dcb_nl.h
new file mode 100644
index 000000000000..6c630a362293
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_DCB_NL_H_
+#define _ICE_DCB_NL_H_
+
+#ifdef CONFIG_DCB
+void ice_dcbnl_setup(struct ice_vsi *vsi);
+void ice_dcbnl_set_all(struct ice_vsi *vsi);
+void
+ice_dcbnl_flush_apps(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
+		     struct ice_dcbx_cfg *new_cfg);
+#else
+#define ice_dcbnl_setup(vsi) do {} while (0)
+#define ice_dcbnl_set_all(vsi) do {} while (0)
+#define ice_dcbnl_flush_apps(pf, old_cfg, new_cfg) do {} while (0)
+#endif /* CONFIG_DCB */
+
+#endif /* _ICE_DCB_NL_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 152fbd556e9b..e8f32350fed2 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -52,6 +52,9 @@
 #define PF_MBX_ATQLEN_ATQLEN_M			ICE_M(0x3FF, 0)
 #define PF_MBX_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_MBX_ATQT				0x0022E300
+#define PRTDCB_GENC				0x00083000
+#define PRTDCB_GENC_PFCLDA_S			16
+#define PRTDCB_GENC_PFCLDA_M			ICE_M(0xFFFF, 16)
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f3cfd5017e29..bc37896930f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2487,6 +2487,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 bool ice_is_reset_in_progress(unsigned long *state)
 {
 	return test_bit(__ICE_RESET_OICR_RECV, state) ||
+	       test_bit(__ICE_DCBNL_DEVRESET, state) ||
 	       test_bit(__ICE_PFR_REQ, state) ||
 	       test_bit(__ICE_CORER_REQ, state) ||
 	       test_bit(__ICE_GLOBR_REQ, state);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cacbe2103b28..d963aec59845 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9,6 +9,7 @@
 #include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
+#include "ice_dcb_nl.h"
 
 #define DRV_VERSION_MAJOR 0
 #define DRV_VERSION_MINOR 8
@@ -2516,6 +2517,9 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	/* netdev has to be configured before setting frame size */
 	ice_vsi_cfg_frame_size(vsi);
 
+	/* Setup DCB netlink interface */
+	ice_dcbnl_setup(vsi);
+
 	/* registering the NAPI handler requires both the queues and
 	 * netdev to be created, which are done in ice_pf_vsi_setup()
 	 * and ice_cfg_netdev() respectively
@@ -2596,6 +2600,7 @@ static void ice_deinit_pf(struct ice_pf *pf)
 {
 	ice_service_task_stop(pf);
 	mutex_destroy(&pf->sw_mutex);
+	mutex_destroy(&pf->tc_mutex);
 	mutex_destroy(&pf->avail_q_mutex);
 
 	if (pf->avail_txqs) {
@@ -2645,6 +2650,7 @@ static int ice_init_pf(struct ice_pf *pf)
 	ice_set_pf_caps(pf);
 
 	mutex_init(&pf->sw_mutex);
+	mutex_init(&pf->tc_mutex);
 
 	/* setup service timer and periodic service task */
 	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
-- 
2.21.0

