Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA54B2CF1
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347765AbiBKS01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:26:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbiBKS00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:26:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD85196;
        Fri, 11 Feb 2022 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644603984; x=1676139984;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s5WfNCZd73EAI4KrJoj6LXBheMSi7DvzOP4eKw1j/2g=;
  b=P0SI4PYKqbU1isRtkBww1maJ58tNnkJWe1tvIc32nDQMalUypkIF80w7
   7rDYfcVA0x9htXVGrKx79al6PPfVO57V0bu9FI+EqGw6bF0yLYwxseBBK
   u/VS95jmrHDfrxm93Ja8YF64rYcLlQ8bOb3zofqtyM5EK9IAE3MRMscg9
   3YLIJgscmkZxsj0xmzMzl7BDNyTIC/smc50NMCTPTlGcLCryO5rPkNGmv
   kTOB6x7+3etQZM72oHzL8mJEjLLiM5h4A3S7MhfCHvWeN4pDIyT+XRLhs
   BMHOyziGOz4koU55xLmYh+gpdg9/PlFbrgUX2Te5v3kDhul5/qgigps4b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="249990381"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="249990381"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 10:26:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="602446958"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 11 Feb 2022 10:26:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [RESEND PATCH net-next 1/1] ice: Simplify tracking status of RDMA support
Date:   Fri, 11 Feb 2022 10:26:03 -0800
Message-Id: <20220211182603.745166-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The status of support for RDMA is currently being tracked with two
separate status flags. This is unnecessary with the current state of
the driver.

Simplify status tracking down to a single flag.

Rename the helper function to denote the RDMA specific status and
universally use the helper function to test the status bit.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  3 ---
 drivers/net/ethernet/intel/ice/ice_idc.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_lib.h  |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++--------
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 827fcb5e0d4c..8f40f6f9b8eb 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -471,7 +471,6 @@ enum ice_pf_flags {
 	ICE_FLAG_FD_ENA,
 	ICE_FLAG_PTP_SUPPORTED,		/* PTP is supported by NVM */
 	ICE_FLAG_PTP,			/* PTP is enabled by software */
-	ICE_FLAG_AUX_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_TC_MQPRIO,		/* support for Multi queue TC */
 	ICE_FLAG_CLS_FLOWER,
@@ -891,7 +890,6 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
 		set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 	}
 }
@@ -904,6 +902,5 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
 	ice_unplug_aux_dev(pf);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 263a2e7577a2..73aa520317d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -79,7 +79,7 @@ int ice_add_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset)
 
 	dev = ice_pf_to_dev(pf);
 
-	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+	if (!ice_is_rdma_ena(pf))
 		return -EINVAL;
 
 	vsi = ice_get_main_vsi(pf);
@@ -241,7 +241,7 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
  */
 static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 {
-	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+	if (ice_is_rdma_ena(pf)) {
 		int index;
 
 		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
@@ -279,7 +279,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	/* if this PF doesn't support a technology that requires auxiliary
 	 * devices, then gracefully exit
 	 */
-	if (!ice_is_aux_ena(pf))
+	if (!ice_is_rdma_ena(pf))
 		return 0;
 
 	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f23917d6a495..7a1cb29e5bcb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -733,14 +733,14 @@ bool ice_is_safe_mode(struct ice_pf *pf)
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
index 133fc235141a..491f13f98797 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -100,7 +100,7 @@ void ice_set_q_vector_intrl(struct ice_q_vector *q_vector);
 int ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
-bool ice_is_aux_ena(struct ice_pf *pf);
+bool ice_is_rdma_ena(struct ice_pf *pf);
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ce90ebf4b853..cff476f735ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3699,11 +3699,8 @@ static void ice_set_pf_caps(struct ice_pf *pf)
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
@@ -3831,7 +3828,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_left -= needed;
 
 	/* reserve vectors for RDMA auxiliary driver */
-	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+	if (ice_is_rdma_ena(pf)) {
 		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
 		if (v_left < needed)
 			goto no_hw_vecs_left_err;
@@ -3872,7 +3869,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			int v_remain = v_actual - v_other;
 			int v_rdma = 0, v_min_rdma = 0;
 
-			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+			if (ice_is_rdma_ena(pf)) {
 				/* Need at least 1 interrupt in addition to
 				 * AEQ MSIX
 				 */
@@ -3906,7 +3903,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
 				   pf->num_lan_msix);
 
-			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+			if (ice_is_rdma_ena(pf))
 				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
 					   pf->num_rdma_msix);
 		}
@@ -4732,7 +4729,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
-	if (ice_is_aux_ena(pf)) {
+	if (ice_is_rdma_ena(pf)) {
 		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
 		if (pf->aux_idx < 0) {
 			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
-- 
2.31.1

