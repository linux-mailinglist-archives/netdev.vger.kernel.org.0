Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6239E480
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFGQw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:57118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhFGQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:46 -0400
IronPort-SDR: al4GmQufVg7HP9VUqjuSFlBuqP3kuMBwF8UMCB36Lu+ijMGxpe5TCpDhDYDv5dQPD6F/i8e2XX
 VMB6va9T7U2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474555"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474555"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:54 -0700
IronPort-SDR: 5boQvbe5G9/hVDjnKxn3wOD75K+gn248Kp1gCkWmCQPuJ1ow3wYfLH00xJ4nYkzOA3i9d4Yygt
 FGaObFi2DNoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841247"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 08/15] ice: use static inline for dummy functions
Date:   Mon,  7 Jun 2021 09:53:18 -0700
Message-Id: <20210607165325.182087-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Trivial:
The driver had previously attempted to use #define
macros to make functions that have no use in certain
configs disappear. Using static inlines instead allows
for certain static checkers to process the code better,
and results in no functional change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.h     | 12 +++++-----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  | 15 +++++++------
 drivers/net/ethernet/intel/ice/ice_dcb_nl.h   |  9 ++++----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  | 22 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  4 ++--
 5 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.h b/drivers/net/ethernet/intel/ice/ice_arfs.h
index f39cd16403ed..80ed76f0cace 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.h
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.h
@@ -52,12 +52,12 @@ bool
 ice_is_arfs_using_perfect_flow(struct ice_hw *hw,
 			       enum ice_fltr_ptype flow_type);
 #else
-#define ice_sync_arfs_fltrs(pf) do {} while (0)
-#define ice_init_arfs(vsi) do {} while (0)
-#define ice_clear_arfs(vsi) do {} while (0)
-#define ice_remove_arfs(pf) do {} while (0)
-#define ice_free_cpu_rx_rmap(vsi) do {} while (0)
-#define ice_rebuild_arfs(pf) do {} while (0)
+static inline void ice_clear_arfs(struct ice_vsi *vsi) { }
+static inline void ice_free_cpu_rx_rmap(struct ice_vsi *vsi) { }
+static inline void ice_init_arfs(struct ice_vsi *vsi) { }
+static inline void ice_sync_arfs_fltrs(struct ice_pf *pf) { }
+static inline void ice_remove_arfs(struct ice_pf *pf) { }
+static inline void ice_rebuild_arfs(struct ice_pf *pf) { }
 
 static inline int ice_set_cpu_rx_rmap(struct ice_vsi __always_unused *vsi)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 35c21d9ae009..261b6e2ed7bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -60,7 +60,7 @@ static inline bool ice_is_dcb_active(struct ice_pf *pf)
 		test_bit(ICE_FLAG_DCB_ENA, pf->flags));
 }
 #else
-#define ice_dcb_rebuild(pf) do {} while (0)
+static inline void ice_dcb_rebuild(struct ice_pf *pf) { }
 
 static inline u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg __always_unused *dcbcfg)
 {
@@ -113,11 +113,12 @@ ice_is_pfc_causing_hung_q(struct ice_pf __always_unused *pf,
 	return false;
 }
 
-#define ice_update_dcb_stats(pf) do {} while (0)
-#define ice_pf_dcb_recfg(pf) do {} while (0)
-#define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
-#define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
-#define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
-#define ice_vsi_cfg_netdev_tc(vsi, ena_tc) do {} while (0)
+static inline void ice_pf_dcb_recfg(struct ice_pf *pf) { }
+static inline void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi) { }
+static inline void ice_update_dcb_stats(struct ice_pf *pf) { }
+static inline void
+ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf, struct ice_rq_event_info *event) { }
+static inline void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc) { }
+static inline void ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring) { }
 #endif /* CONFIG_DCB */
 #endif /* _ICE_DCB_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.h b/drivers/net/ethernet/intel/ice/ice_dcb_nl.h
index 6c630a362293..eac2f34bdcdd 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.h
@@ -11,9 +11,10 @@ void
 ice_dcbnl_flush_apps(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
 		     struct ice_dcbx_cfg *new_cfg);
 #else
-#define ice_dcbnl_setup(vsi) do {} while (0)
-#define ice_dcbnl_set_all(vsi) do {} while (0)
-#define ice_dcbnl_flush_apps(pf, old_cfg, new_cfg) do {} while (0)
+static inline void ice_dcbnl_setup(struct ice_vsi *vsi) { }
+static inline void ice_dcbnl_set_all(struct ice_vsi *vsi) { }
+static inline void
+ice_dcbnl_flush_apps(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
+		     struct ice_dcbx_cfg *new_cfg) { }
 #endif /* CONFIG_DCB */
-
 #endif /* _ICE_DCB_NL_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 77ff0023f7be..842cb077df86 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -158,16 +158,18 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
 #else /* CONFIG_PCI_IOV */
-#define ice_process_vflr_event(pf) do {} while (0)
-#define ice_free_vfs(pf) do {} while (0)
-#define ice_vc_process_vf_msg(pf, event) do {} while (0)
-#define ice_vc_notify_link_state(pf) do {} while (0)
-#define ice_vc_notify_reset(pf) do {} while (0)
-#define ice_set_vf_state_qs_dis(vf) do {} while (0)
-#define ice_vf_lan_overflow_event(pf, event) do {} while (0)
-#define ice_print_vfs_mdd_events(pf) do {} while (0)
-#define ice_print_vf_rx_mdd_event(vf) do {} while (0)
-#define ice_restore_all_vfs_msi_state(pdev) do {} while (0)
+static inline void ice_process_vflr_event(struct ice_pf *pf) { }
+static inline void ice_free_vfs(struct ice_pf *pf) { }
+static inline
+void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event) { }
+static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
+static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
+static inline void ice_set_vf_state_qs_dis(struct ice_vf *vf) { }
+static inline
+void ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event) { }
+static inline void ice_print_vfs_mdd_events(struct ice_pf *pf) { }
+static inline void ice_print_vf_rx_mdd_event(struct ice_vf *vf) { }
+static inline void ice_restore_all_vfs_msi_state(struct pci_dev *pdev) { }
 
 static inline bool
 ice_is_malicious_vf(struct ice_pf __always_unused *pf,
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index fad783690134..ea208808623a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -60,7 +60,7 @@ ice_xsk_wakeup(struct net_device __always_unused *netdev,
 	return -EOPNOTSUPP;
 }
 
-#define ice_xsk_clean_rx_ring(rx_ring) do {} while (0)
-#define ice_xsk_clean_xdp_ring(xdp_ring) do {} while (0)
+static inline void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring) { }
+static inline void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring) { }
 #endif /* CONFIG_XDP_SOCKETS */
 #endif /* !_ICE_XSK_H_ */
-- 
2.26.2

