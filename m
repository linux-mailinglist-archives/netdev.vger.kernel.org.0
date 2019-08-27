Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83999F05E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbfH0Qil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:10368 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730276AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876360"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Alloc queue management bitmaps and arrays dynamically
Date:   Tue, 27 Aug 2019 09:38:29 -0700
Message-Id: <20190827163832.8362-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The total number of queues available on the device is divided between
multiple physical functions (PF) in the firmware and provided to the
driver when it gets function capabilities from the firmware. Thus
each PF knows how many Tx/Rx queues it has. These queues are then
doled out to different VSIs (for LAN traffic, SR-IOV VF traffic, etc.)

To track usage of these queues at the PF level, the driver uses two
bitmaps avail_txqs and avail_rxqs. At the VSI level (i.e. struct ice_vsi
instances) the driver uses two arrays txq_map and rxq_map, to track
ownership of VSIs' queues in avail_txqs and avail_rxqs respectively.

The aforementioned bitmaps and arrays should be allocated dynamically,
because the number of queues supported by a PF is only available once
function capabilities have been queried. The current static allocation
consumes way more memory than required.

This patch removes the DECLARE_BITMAP for avail_txqs and avail_rxqs
and instead uses bitmap_zalloc to allocate the bitmaps during init.
Similarly txq_map and rxq_map are now allocated in ice_vsi_alloc_arrays.
As a result ICE_MAX_TXQS and ICE_MAX_RXQS defines are no longer needed.
Also as txq_map and rxq_map are now allocated and freed, some code
reordering was required in ice_vsi_rebuild for correct functioning.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 12 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 45 ++++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_main.c | 40 ++++++++++++++++----
 3 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 97d0f61cf52b..fb2bc836b20a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -73,8 +73,6 @@ extern const char ice_drv_ver[];
 #define ICE_MBXRQ_LEN		512
 #define ICE_MIN_MSIX		2
 #define ICE_NO_VSI		0xffff
-#define ICE_MAX_TXQS		2048
-#define ICE_MAX_RXQS		2048
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
 #define ICE_MAX_SCATTER_TXQS	16
@@ -284,8 +282,8 @@ struct ice_vsi {
 	/* queue information */
 	u8 tx_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
 	u8 rx_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
-	u16 txq_map[ICE_MAX_TXQS];	 /* index in pf->avail_txqs */
-	u16 rxq_map[ICE_MAX_RXQS];	 /* index in pf->avail_rxqs */
+	u16 *txq_map;			 /* index in pf->avail_txqs */
+	u16 *rxq_map;			 /* index in pf->avail_rxqs */
 	u16 alloc_txq;			 /* Allocated Tx queues */
 	u16 num_txq;			 /* Used Tx queues */
 	u16 alloc_rxq;			 /* Allocated Rx queues */
@@ -355,9 +353,9 @@ struct ice_pf {
 	u16 num_vf_qps;			/* num queue pairs per VF */
 	u16 num_vf_msix;		/* num vectors per VF */
 	DECLARE_BITMAP(state, __ICE_STATE_NBITS);
-	DECLARE_BITMAP(avail_txqs, ICE_MAX_TXQS);
-	DECLARE_BITMAP(avail_rxqs, ICE_MAX_RXQS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
+	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
+	unsigned long *avail_rxqs;	/* bitmap to track PF Rx queue usage */
 	unsigned long serv_tmr_period;
 	unsigned long serv_tmr_prev;
 	struct timer_list serv_tmr;
@@ -368,6 +366,8 @@ struct ice_pf {
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
+	u16 max_pf_txqs;	/* Total Tx queues PF wide */
+	u16 max_pf_rxqs;	/* Total Rx queues PF wide */
 	u32 num_lan_msix;	/* Total MSIX vectors for base driver */
 	u16 num_lan_tx;		/* num LAN Tx queues setup */
 	u16 num_lan_rx;		/* num LAN Rx queues setup */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fb866be84088..a39767e8c2a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -263,12 +263,24 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	vsi->tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
 				     sizeof(*vsi->tx_rings), GFP_KERNEL);
 	if (!vsi->tx_rings)
-		goto err_txrings;
+		return -ENOMEM;
 
 	vsi->rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
 				     sizeof(*vsi->rx_rings), GFP_KERNEL);
 	if (!vsi->rx_rings)
-		goto err_rxrings;
+		goto err_rings;
+
+	vsi->txq_map = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
+				    sizeof(*vsi->txq_map), GFP_KERNEL);
+
+	if (!vsi->txq_map)
+		goto err_txq_map;
+
+	vsi->rxq_map = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
+				    sizeof(*vsi->rxq_map), GFP_KERNEL);
+	if (!vsi->rxq_map)
+		goto err_rxq_map;
+
 
 	/* There is no need to allocate q_vectors for a loopback VSI. */
 	if (vsi->type == ICE_VSI_LB)
@@ -283,10 +295,13 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	return 0;
 
 err_vectors:
+	devm_kfree(&pf->pdev->dev, vsi->rxq_map);
+err_rxq_map:
+	devm_kfree(&pf->pdev->dev, vsi->txq_map);
+err_txq_map:
 	devm_kfree(&pf->pdev->dev, vsi->rx_rings);
-err_rxrings:
+err_rings:
 	devm_kfree(&pf->pdev->dev, vsi->tx_rings);
-err_txrings:
 	return -ENOMEM;
 }
 
@@ -433,6 +448,14 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 		devm_kfree(&pf->pdev->dev, vsi->rx_rings);
 		vsi->rx_rings = NULL;
 	}
+	if (vsi->txq_map) {
+		devm_kfree(&pf->pdev->dev, vsi->txq_map);
+		vsi->txq_map = NULL;
+	}
+	if (vsi->rxq_map) {
+		devm_kfree(&pf->pdev->dev, vsi->rxq_map);
+		vsi->rxq_map = NULL;
+	}
 }
 
 /**
@@ -664,7 +687,7 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
 	struct ice_qs_cfg tx_qs_cfg = {
 		.qs_mutex = &pf->avail_q_mutex,
 		.pf_map = pf->avail_txqs,
-		.pf_map_size = ICE_MAX_TXQS,
+		.pf_map_size = pf->max_pf_txqs,
 		.q_count = vsi->alloc_txq,
 		.scatter_count = ICE_MAX_SCATTER_TXQS,
 		.vsi_map = vsi->txq_map,
@@ -674,7 +697,7 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
 	struct ice_qs_cfg rx_qs_cfg = {
 		.qs_mutex = &pf->avail_q_mutex,
 		.pf_map = pf->avail_rxqs,
-		.pf_map_size = ICE_MAX_RXQS,
+		.pf_map_size = pf->max_pf_rxqs,
 		.q_count = vsi->alloc_rxq,
 		.scatter_count = ICE_MAX_SCATTER_RXQS,
 		.vsi_map = vsi->rxq_map,
@@ -3018,6 +3041,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		vsi->base_vector = 0;
 	}
 
+	ice_vsi_put_qs(vsi);
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
 	ice_dev_onetime_setup(&pf->hw);
@@ -3025,6 +3049,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		ice_vsi_set_num_qs(vsi, vf->vf_id);
 	else
 		ice_vsi_set_num_qs(vsi, ICE_INVAL_VFID);
+
+	ret = ice_vsi_alloc_arrays(vsi);
+	if (ret < 0)
+		goto err_vsi;
+
+	ice_vsi_get_qs(vsi);
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* Initialize VSI struct elements and create VSI in FW */
@@ -3032,9 +3062,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	if (ret < 0)
 		goto err_vsi;
 
-	ret = ice_vsi_alloc_arrays(vsi);
-	if (ret < 0)
-		goto err_vsi;
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e47aab6d998d..2499c7ee5038 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2207,13 +2207,23 @@ static void ice_deinit_pf(struct ice_pf *pf)
 	ice_service_task_stop(pf);
 	mutex_destroy(&pf->sw_mutex);
 	mutex_destroy(&pf->avail_q_mutex);
+
+	if (pf->avail_txqs) {
+		bitmap_free(pf->avail_txqs);
+		pf->avail_txqs = NULL;
+	}
+
+	if (pf->avail_rxqs) {
+		bitmap_free(pf->avail_rxqs);
+		pf->avail_rxqs = NULL;
+	}
 }
 
 /**
  * ice_init_pf - Initialize general software structures (struct ice_pf)
  * @pf: board private structure to initialize
  */
-static void ice_init_pf(struct ice_pf *pf)
+static int ice_init_pf(struct ice_pf *pf)
 {
 	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
 #ifdef CONFIG_PCI_IOV
@@ -2229,12 +2239,6 @@ static void ice_init_pf(struct ice_pf *pf)
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->avail_q_mutex);
 
-	/* Clear avail_[t|r]x_qs bitmaps (set all to avail) */
-	mutex_lock(&pf->avail_q_mutex);
-	bitmap_zero(pf->avail_txqs, ICE_MAX_TXQS);
-	bitmap_zero(pf->avail_rxqs, ICE_MAX_RXQS);
-	mutex_unlock(&pf->avail_q_mutex);
-
 	if (pf->hw.func_caps.common_cap.rss_table_size)
 		set_bit(ICE_FLAG_RSS_ENA, pf->flags);
 
@@ -2243,6 +2247,22 @@ static void ice_init_pf(struct ice_pf *pf)
 	pf->serv_tmr_period = HZ;
 	INIT_WORK(&pf->serv_task, ice_service_task);
 	clear_bit(__ICE_SERVICE_SCHED, pf->state);
+
+	pf->max_pf_txqs = pf->hw.func_caps.common_cap.num_txq;
+	pf->max_pf_rxqs = pf->hw.func_caps.common_cap.num_rxq;
+
+	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
+	if (!pf->avail_txqs)
+		return -ENOMEM;
+
+	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
+	if (!pf->avail_rxqs) {
+		devm_kfree(&pf->pdev->dev, pf->avail_txqs);
+		pf->avail_txqs = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /**
@@ -2467,7 +2487,11 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		 hw->fw_maj_ver, hw->fw_min_ver, hw->fw_build,
 		 hw->api_maj_ver, hw->api_min_ver);
 
-	ice_init_pf(pf);
+	err = ice_init_pf(pf);
+	if (err) {
+		dev_err(dev, "ice_init_pf failed: %d\n", err);
+		goto err_init_pf_unroll;
+	}
 
 	err = ice_init_pf_dcb(pf, false);
 	if (err) {
-- 
2.21.0

