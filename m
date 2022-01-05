Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC018484B73
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiAEAFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:05:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:35819 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbiAEAFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 19:05:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641341144; x=1672877144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bbi0QvWwneW+bRXSdcHVXuxVugIJClBwG+2Tla/5rA4=;
  b=TGf89SVyVINwijl6axguh4gs9kdKBkF8MGv/C8qj7aMrcACCrA869LZN
   XQj0KmmZjoQKbU1gb7/zbmHQXnK5Bau1A/VHx7gQg7kwY5SkRvL6oYKCC
   HLgdyMixeAAtqdqkkcqqTh2HTN2zf2nKJG5+8OeoxUKX6uSnCn+1MB3Y6
   iQPCm1RDtZuebzDi+nEWWc9BMAFI9ekfJ1uVD3ROlVUtYM7bKD3Lfj77i
   ygFLRbqQScQHC0cpVjCkgcdMJr8vBUBViY03R3Mdh8SljPyxsGB7B2ndM
   wVoCO1eCmxbWPyH0YVnTayQ4TiIso7v6mGxXGCYpJzyZsXDP/8m0MNT0f
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222326412"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222326412"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:05:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470336977"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 16:05:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        shiraz.saleem@intel.com, mustafa.ismail@intel.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA support
Date:   Tue,  4 Jan 2022 16:04:56 -0800
Message-Id: <20220105000456.2510590-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The status of support for RDMA is currently being tracked with two
separate status flags.  This is unnecessary with the current state of
the driver.

Simplify status tracking down to a single flag.

Rename the helper function to denote the RDMA specific status and
universally use the helper function to test the status bit.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  3 ---
 drivers/net/ethernet/intel/ice/ice_idc.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_lib.h  |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++--------
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 4e16d185077d..6f445cc3390f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -468,7 +468,6 @@ enum ice_pf_flags {
 	ICE_FLAG_FD_ENA,
 	ICE_FLAG_PTP_SUPPORTED,		/* PTP is supported by NVM */
 	ICE_FLAG_PTP,			/* PTP is enabled by software */
-	ICE_FLAG_AUX_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_TC_MQPRIO,		/* support for Multi queue TC */
 	ICE_FLAG_CLS_FLOWER,
@@ -886,7 +885,6 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
 		ice_plug_aux_dev(pf);
 	}
 }
@@ -899,6 +897,5 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
 	ice_unplug_aux_dev(pf);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index fc3580167e7b..9493a38182f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -79,7 +79,7 @@ int ice_add_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset)
 
 	dev = ice_pf_to_dev(pf);
 
-	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+	if (!ice_is_rdma_ena(pf))
 		return -EINVAL;
 
 	vsi = ice_get_main_vsi(pf);
@@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
  */
 static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 {
-	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+	if (ice_is_rdma_ena(pf)) {
 		int index;
 
 		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
@@ -274,7 +274,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	/* if this PF doesn't support a technology that requires auxiliary
 	 * devices, then gracefully exit
 	 */
-	if (!ice_is_aux_ena(pf))
+	if (!ice_is_rdma_ena(pf))
 		return 0;
 
 	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0c187cf04fcf..b1c164b8066c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -732,14 +732,14 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 }
 
 /**
- * ice_is_aux_ena
+ * ice_is_rdma_ena
  * @pf: pointer to the PF struct
  *
- * returns true if AUX devices/drivers are supported, false otherwise
+ * returns true if RDMA is currently supported, false otherwise
  */
-bool ice_is_aux_ena(struct ice_pf *pf)
+bool ice_is_rdma_ena(struct ice_pf *pf)
 {
-	return test_bit(ICE_FLAG_AUX_ENA, pf->flags);
+	return test_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index b2ed189527d6..a2f54fbdc170 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -110,7 +110,7 @@ void ice_set_q_vector_intrl(struct ice_q_vector *q_vector);
 int ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
-bool ice_is_aux_ena(struct ice_pf *pf);
+bool ice_is_rdma_ena(struct ice_pf *pf);
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e29176889c23..078eb588f41e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3653,11 +3653,8 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
 
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
-	if (func_caps->common_cap.rdma) {
+	if (func_caps->common_cap.rdma)
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
-	}
 	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3785,7 +3782,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_left -= needed;
 
 	/* reserve vectors for RDMA auxiliary driver */
-	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+	if (ice_is_rdma_ena(pf)) {
 		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
 		if (v_left < needed)
 			goto no_hw_vecs_left_err;
@@ -3826,7 +3823,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			int v_remain = v_actual - v_other;
 			int v_rdma = 0, v_min_rdma = 0;
 
-			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+			if (ice_is_rdma_ena(pf)) {
 				/* Need at least 1 interrupt in addition to
 				 * AEQ MSIX
 				 */
@@ -3860,7 +3857,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
 				   pf->num_lan_msix);
 
-			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+			if (ice_is_rdma_ena(pf))
 				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
 					   pf->num_rdma_msix);
 		}
@@ -4688,7 +4685,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
-	if (ice_is_aux_ena(pf)) {
+	if (ice_is_rdma_ena(pf)) {
 		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
 		if (pf->aux_idx < 0) {
 			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
-- 
2.31.1

