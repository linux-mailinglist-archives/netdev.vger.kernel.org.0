Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532AF6280F9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbiKNNNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiKNNMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:54 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB152B639
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431572; x=1699967572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5CXANIjA6BWHHNb13wm9L8q6AtXb5fYM6qjRVPqs3A4=;
  b=bqTR0lysmGVlk5TXSBpU+SQ823eEtuuifHTDVPyKc7Ra0sfWEfLEqfqu
   hBTb5tsXp7ddZ/NVW+b+mC2B6p8ur5KKnG8+S1dRFdtMIdGT/y3nC3jSv
   m+YMBGyv9l+q760mMEmzga74+b3fhj4cQZVM3NiibjDXUYbVhcuSexhxG
   ghu8wzuGjhs7j0uJcc6V5guP3recSrA9L/Rbuwiti3XRe1Ary4jumR5oa
   BXWzSf/RhIoP5aTvD487k/G+568ot4G2Gkektr2tCsoLiNI7phT8R5Pjx
   xU3nes+cIswsuv28y/B3v7Nd5DgxAHu/5pKAVs6dGQlHa+4BT5+D86mjq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="398254719"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="398254719"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616306084"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616306084"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:46 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 12/13] ice, irdma: prepare reservation of MSI-X to reload
Date:   Mon, 14 Nov 2022 13:57:54 +0100
Message-Id: <20221114125755.13659-13-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move MSI-X number for LAN and RDMA to structure to have it in one
place. Use req_msix to store how many MSI-X for each feature user
requested. Structure msix is used to store the current number of MSI-X.

The MSI-X number needs to be adjust if kernel doesn't support that many
MSI-X or if hardware doesn't support it. Rewrite MSI-X adjustment
function to use it in both cases.

Use the same algorithm like previously. First allocate minimum MSI-X for
each feature than if there is enough MSI-X distribute it equally between
each one.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Co-developed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/infiniband/hw/irdma/main.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice.h         |  16 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_idc.c     |   6 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 284 +++++++++++--------
 6 files changed, 189 insertions(+), 131 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 514453777e07..0a70b27b93a3 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -230,7 +230,7 @@ static void irdma_fill_device_info(struct irdma_device *iwdev, struct ice_pf *pf
 	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
 	rf->hw.hw_addr = pf->hw.hw_addr;
 	rf->pcidev = pf->pdev;
-	rf->msix_count =  pf->num_rdma_msix;
+	rf->msix_count =  pf->msix.rdma;
 	rf->pf_id = pf->hw.pf_id;
 	rf->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
 	rf->default_vsi.vsi_idx = vsi->vsi_num;
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index df1f6d85cd43..ef9ea43470bf 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -518,6 +518,14 @@ struct ice_agg_node {
 	u8 valid;
 };
 
+struct ice_msix {
+	u16 all;			/* All reserved MSI-X */
+	u16 misc;			/* MSI-X reserved for misc */
+	u16 eth;			/* MSI-X reserved for eth */
+	u16 rdma;			/* MSI-X reserved for RDMA */
+	u16 vf;				/* MSI-X reserved for VF */
+};
+
 struct ice_pf {
 	struct pci_dev *pdev;
 
@@ -531,6 +539,10 @@ struct ice_pf {
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
 	struct ice_res_tracker *irq_tracker;
+	/* Store MSI-X requested by user via devlink */
+	struct ice_msix req_msix;
+	/* Store currently used MSI-X */
+	struct ice_msix msix;
 	/* First MSIX vector used by SR-IOV VFs. Calculated by subtracting the
 	 * number of MSIX vectors needed for all SR-IOV VFs from the number of
 	 * MSIX vectors allowed on this PF.
@@ -561,7 +573,6 @@ struct ice_pf {
 	struct tty_driver *ice_gnss_tty_driver;
 	struct tty_port *gnss_tty_port[ICE_GNSS_TTY_MINOR_DEVICES];
 	struct gnss_serial *gnss_serial[ICE_GNSS_TTY_MINOR_DEVICES];
-	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
 	u16 rdma_base_vector;
 
 	/* spinlock to protect the AdminQ wait list */
@@ -578,7 +589,6 @@ struct ice_pf {
 	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
 	u16 max_pf_txqs;	/* Total Tx queues PF wide */
 	u16 max_pf_rxqs;	/* Total Rx queues PF wide */
-	u16 num_lan_msix;	/* Total MSIX vectors for base driver */
 	u16 num_lan_tx;		/* num LAN Tx queues setup */
 	u16 num_lan_rx;		/* num LAN Rx queues setup */
 	u16 next_vsi;		/* Next free slot in pf->vsi[] - 0-based! */
@@ -934,7 +944,7 @@ void ice_unload(struct ice_pf *pf);
  */
 static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
-	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
+	if (pf->hw.func_caps.common_cap.rdma && pf->msix.rdma) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 		set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1dfce48cfdc2..65f71da6bc70 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3513,7 +3513,7 @@ ice_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
  */
 static int ice_get_max_txq(struct ice_pf *pf)
 {
-	return min3(pf->num_lan_msix, (u16)num_online_cpus(),
+	return min3(pf->msix.eth, (u16)num_online_cpus(),
 		    (u16)pf->hw.func_caps.common_cap.num_txq);
 }
 
@@ -3523,7 +3523,7 @@ static int ice_get_max_txq(struct ice_pf *pf)
  */
 static int ice_get_max_rxq(struct ice_pf *pf)
 {
-	return min3(pf->num_lan_msix, (u16)num_online_cpus(),
+	return min3(pf->msix.eth, (u16)num_online_cpus(),
 		    (u16)pf->hw.func_caps.common_cap.num_rxq);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index e6bc2285071e..2534a3460596 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -237,11 +237,11 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 	if (ice_is_rdma_ena(pf)) {
 		int index;
 
-		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
+		index = ice_get_res(pf, pf->irq_tracker, pf->msix.rdma,
 				    ICE_RES_RDMA_VEC_ID);
 		if (index < 0)
 			return index;
-		pf->num_avail_sw_msix -= pf->num_rdma_msix;
+		pf->num_avail_sw_msix -= pf->msix.rdma;
 		pf->rdma_base_vector = (u16)index;
 	}
 	return 0;
@@ -253,7 +253,7 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
  */
 static void ice_free_rdma_qvector(struct ice_pf *pf)
 {
-	pf->num_avail_sw_msix -= pf->num_rdma_msix;
+	pf->num_avail_sw_msix -= pf->msix.rdma;
 	ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
 		     ICE_RES_RDMA_VEC_ID);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index bc04f2b9f8a2..11b0b3cca76c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -184,7 +184,7 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, struct ice_vf *vf)
 			vsi->alloc_txq = vsi->req_txq;
 			vsi->num_txq = vsi->req_txq;
 		} else {
-			vsi->alloc_txq = min3(pf->num_lan_msix,
+			vsi->alloc_txq = min3(pf->msix.eth,
 					      ice_get_avail_txq_count(pf),
 					      (u16)num_online_cpus());
 		}
@@ -199,7 +199,7 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, struct ice_vf *vf)
 				vsi->alloc_rxq = vsi->req_rxq;
 				vsi->num_rxq = vsi->req_rxq;
 			} else {
-				vsi->alloc_rxq = min3(pf->num_lan_msix,
+				vsi->alloc_rxq = min3(pf->msix.eth,
 						      ice_get_avail_rxq_count(pf),
 						      (u16)num_online_cpus());
 			}
@@ -207,7 +207,7 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, struct ice_vf *vf)
 
 		pf->num_lan_rx = vsi->alloc_rxq;
 
-		vsi->num_q_vectors = min_t(int, pf->num_lan_msix,
+		vsi->num_q_vectors = min_t(int, pf->msix.eth,
 					   max_t(int, vsi->alloc_rxq,
 						 vsi->alloc_txq));
 		break;
@@ -1100,7 +1100,7 @@ ice_chnl_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	u8 offset = 0;
 	int pow;
 
-	qcount = min_t(int, vsi->num_rxq, pf->num_lan_msix);
+	qcount = min_t(int, vsi->num_rxq, pf->msix.eth);
 
 	pow = order_base_2(qcount);
 	qmap = ((offset << ICE_AQ_VSI_TC_Q_OFFSET_S) &
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0dfc427e623a..a4c283bc8da0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3818,119 +3818,193 @@ static int ice_init_pf(struct ice_pf *pf)
 }
 
 /**
- * ice_reduce_msix_usage - Reduce usage of MSI-X vectors
+ * ice_distribute_msix - distribute amount of MSI-X across all features
  * @pf: board private structure
- * @v_remain: number of remaining MSI-X vectors to be distributed
+ * @msix: structure that stores MSI-X amount for all features
+ * @num_msix: amount of MSI-X to distribute
+ * @req_lan: amount of requested LAN MSI-X
+ * @req_rdma: amount of requested RDMA MSI-X
  *
- * Reduce the usage of MSI-X vectors when entire request cannot be fulfilled.
- * pf->num_lan_msix and pf->num_rdma_msix values are set based on number of
- * remaining vectors.
+ * The function is trying to distribute MSI-X across all supported features.
+ * As a side effect the function can turn off not critical features if the
+ * number of msix is too low.
+ *
+ * Function returns -ERANGE if the amount of msix is too low to support
+ * basic driver operations. It is critical error.
+ *
+ * In rest cases function returns number of used MSI-X in total,
+ *
+ * First try to distribute minimum amount of MSI-X across all features. If
+ * there still are remaing MSI-X distribute it equally.
+ *
+ * Function can be called to distribute MSI-X amount received from hardware
+ * or from kernel. To support both cases MSI-X for VF isn't set here. This
+ * should be set outside this function based on returned value.
  */
-static void ice_reduce_msix_usage(struct ice_pf *pf, int v_remain)
+static int
+ice_distribute_msix(struct ice_pf *pf, struct ice_msix *msix, int num_msix,
+		    int req_lan, int req_rdma)
 {
-	int v_rdma;
+	struct device *dev = ice_pf_to_dev(pf);
+	int rem_msix = num_msix;
+	int additional_msix;
 
-	if (!ice_is_rdma_ena(pf)) {
-		pf->num_lan_msix = v_remain;
-		return;
+	msix->all = num_msix;
+	msix->eth = 0;
+	msix->rdma = 0;
+	msix->misc = 0;
+
+	if (num_msix < ICE_MIN_MSIX) {
+		dev_warn(dev, "not enough MSI-X vectors. wanted = %d, available = %d\n",
+			 ICE_MIN_MSIX, num_msix);
+		return -ERANGE;
 	}
 
-	/* RDMA needs at least 1 interrupt in addition to AEQ MSIX */
-	v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
+	msix->misc = ICE_MIN_LAN_OICR_MSIX;
+	/* Minimum LAN */
+	msix->eth = ICE_MIN_LAN_TXRX_MSIX;
+	req_lan -= ICE_MIN_LAN_TXRX_MSIX;
+	rem_msix = rem_msix - msix->misc - msix->eth;
+	additional_msix = req_lan;
 
-	if (v_remain < ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_RDMA_MSIX) {
-		dev_warn(ice_pf_to_dev(pf), "Not enough MSI-X vectors to support RDMA.\n");
-		clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+	/* MSI-X distribution for misc */
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		if (rem_msix >= ICE_FDIR_MSIX) {
+			msix->misc += ICE_FDIR_MSIX;
+			rem_msix -= ICE_FDIR_MSIX;
+		} else {
+			dev_warn(dev, "not enough MSI-X vectors. wanted = %d, available = %d\n",
+				 ICE_FDIR_MSIX, rem_msix);
+			dev_warn(dev, "turning flow director off\n");
+			clear_bit(ICE_FLAG_FD_ENA, pf->flags);
+			goto exit;
+		}
+	}
+
+	if (test_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags)) {
+		if (rem_msix >= ICE_ESWITCH_MSIX) {
+			msix->misc += ICE_ESWITCH_MSIX;
+			rem_msix -= ICE_ESWITCH_MSIX;
+		} else {
+			dev_warn(dev, "not enough MSI-X vectors. wanted = %d, available = %d\n",
+				 ICE_ESWITCH_MSIX, rem_msix);
+			dev_warn(dev, "turning eswitch off\n");
+			clear_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags);
+			goto exit;
+		}
+	}
 
-		pf->num_rdma_msix = 0;
-		pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
-	} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
-		   (v_remain - v_rdma < v_rdma)) {
-		/* Support minimum RDMA and give remaining vectors to LAN MSIX */
-		pf->num_rdma_msix = ICE_MIN_RDMA_MSIX;
-		pf->num_lan_msix = v_remain - ICE_MIN_RDMA_MSIX;
+	/* Minimum RDMA
+	 * Minimum MSI-X for RDMA is ICE_MIN_RDMA_MSIX, but it is better to
+	 * have ICE_RDMA_NUM_AEQ_MSIX + 1 for queue. Instead of starting
+	 * with ICE_MIN_RDMA_MSIX and going to distribution for LAN, try
+	 * to start with ICE_RDMA_NUM_AEQ_MSIX + 1 if there are MSI-X for it
+	 */
+	if (ice_is_rdma_ena(pf)) {
+		if (rem_msix >= ICE_RDMA_NUM_AEQ_MSIX + 1 &&
+		    req_rdma >= ICE_RDMA_NUM_AEQ_MSIX + 1) {
+			msix->rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
+			rem_msix -= msix->rdma;
+			req_rdma -= msix->rdma;
+			additional_msix += req_rdma;
+		} else if (rem_msix >= ICE_MIN_RDMA_MSIX) {
+			msix->rdma = ICE_MIN_RDMA_MSIX;
+			rem_msix -= ICE_MIN_RDMA_MSIX;
+			req_rdma -= ICE_MIN_RDMA_MSIX;
+			additional_msix += req_rdma;
+		} else {
+			dev_warn(dev, "not enough MSI-X vectors. wanted = %d, available = %d\n",
+				 ICE_MIN_RDMA_MSIX, rem_msix);
+			dev_warn(dev, "turning RDMA off\n");
+			clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+			goto exit;
+		}
 	} else {
-		/* Split remaining MSIX with RDMA after accounting for AEQ MSIX
-		 */
-		pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
-				    ICE_RDMA_NUM_AEQ_MSIX;
-		pf->num_lan_msix = v_remain - pf->num_rdma_msix;
+		req_rdma = 0;
 	}
-}
 
-/**
- * ice_ena_msix_range - Request a range of MSIX vectors from the OS
- * @pf: board private structure
- *
- * Compute the number of MSIX vectors wanted and request from the OS. Adjust
- * device usage if there are not enough vectors. Return the number of vectors
- * reserved or negative on failure.
- */
-static int ice_ena_msix_range(struct ice_pf *pf)
-{
-	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
-	struct device *dev = ice_pf_to_dev(pf);
-	int err, i;
+	/* Check if there is enough additional MSI-X for all used features */
+	if (rem_msix >= additional_msix) {
+		/* Best case scenario */
+		msix->eth += req_lan;
+		rem_msix -= req_lan;
 
-	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
-	num_cpus = num_online_cpus();
+		msix->rdma += req_rdma;
+		rem_msix -= req_rdma;
+	} else if (rem_msix) {
+		int factor = DIV_ROUND_UP(additional_msix, rem_msix);
+		int rdma = req_rdma / factor;
 
-	/* LAN miscellaneous handler */
-	v_other = ICE_MIN_LAN_OICR_MSIX;
+		dev_warn(dev, "not enough MSI-X vectors. requested = %d, obtained = %d\n",
+			 additional_msix, rem_msix);
 
-	/* Flow Director */
-	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
-		v_other += ICE_FDIR_MSIX;
+		msix->rdma += rdma;
+		rem_msix -= rdma;
 
-	/* switchdev */
-	if (test_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags))
-		v_other += ICE_ESWITCH_MSIX;
+		msix->eth += rem_msix;
+		rem_msix = 0;
 
-	v_wanted = v_other;
+		dev_notice(dev, "enable %d MSI-X vectors for LAN and %d for RDMA\n",
+			   msix->eth, msix->rdma);
+	}
 
-	/* LAN traffic */
-	pf->num_lan_msix = num_cpus;
-	v_wanted += pf->num_lan_msix;
+	/* It is fine if rem_msix isn't 0 here, as it can be used for VF.
+	 * It isn't done here as this function also cover MSI-X distribution
+	 * for MSI-X amount returned from kernel
+	 */
 
-	/* RDMA auxiliary driver */
-	if (ice_is_rdma_ena(pf)) {
-		pf->num_rdma_msix = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
-		v_wanted += pf->num_rdma_msix;
-	}
+exit:
+	/* Return number of used MSI-X instead of remaing */
+	return num_msix - rem_msix;
+}
 
-	if (v_wanted > hw_num_msix) {
-		int v_remain;
+/**
+ * ice_set_def_msix - set default value for MSI-X based on hardware
+ * @pf: board private structure
+ *
+ * Function will return -ERANGE when there is critical error and
+ * minimum amount of MSI-X can't be used. In success returns 0.
+ */
+static int
+ice_set_def_msix(struct ice_pf *pf)
+{
+	int hw_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
+	int num_cpus = num_present_cpus();
+	int used_msix;
 
-		dev_warn(dev, "not enough device MSI-X vectors. wanted = %d, available = %d\n",
-			 v_wanted, hw_num_msix);
+	/* set default only if it wasn't previously set in devlink API */
+	if (pf->req_msix.eth)
+		return 0;
 
-		if (hw_num_msix < ICE_MIN_MSIX) {
-			err = -ERANGE;
-			goto exit_err;
-		}
+	used_msix = ice_distribute_msix(pf, &pf->req_msix, hw_msix, num_cpus,
+					num_cpus + ICE_RDMA_NUM_AEQ_MSIX);
 
-		v_remain = hw_num_msix - v_other;
-		if (v_remain < ICE_MIN_LAN_TXRX_MSIX) {
-			v_other = ICE_MIN_MSIX - ICE_MIN_LAN_TXRX_MSIX;
-			v_remain = ICE_MIN_LAN_TXRX_MSIX;
-		}
+	if (used_msix < 0)
+		return -ERANGE;
 
-		ice_reduce_msix_usage(pf, v_remain);
-		v_wanted = pf->num_lan_msix + pf->num_rdma_msix + v_other;
+	pf->req_msix.vf = hw_msix - used_msix;
 
-		dev_notice(dev, "Reducing request to %d MSI-X vectors for LAN traffic.\n",
-			   pf->num_lan_msix);
-		if (ice_is_rdma_ena(pf))
-			dev_notice(dev, "Reducing request to %d MSI-X vectors for RDMA.\n",
-				   pf->num_rdma_msix);
-	}
+	return 0;
+}
 
+/**
+ * ice_ena_msix_range - Request a range of MSIX vectors from the OS
+ * @pf: board private structure
+ *
+ * Compute the number of MSIX vectors wanted and request from the OS. Adjust
+ * device usage if there are not enough vectors. Return the number of vectors
+ * reserved or negative on failure.
+ */
+static int ice_ena_msix_range(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int v_wanted, v_actual, err, i;
+
+	v_wanted = pf->req_msix.eth + pf->req_msix.rdma + pf->req_msix.misc;
 	pf->msix_entries = devm_kcalloc(dev, v_wanted,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
-	if (!pf->msix_entries) {
-		err = -ENOMEM;
-		goto exit_err;
-	}
+	if (!pf->msix_entries)
+		return -ENOMEM;
 
 	for (i = 0; i < v_wanted; i++)
 		pf->msix_entries[i].entry = i;
@@ -3938,46 +4012,17 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	/* actually reserve the vectors */
 	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
 					 ICE_MIN_MSIX, v_wanted);
-	if (v_actual < 0) {
-		dev_err(dev, "unable to reserve MSI-X vectors\n");
-		err = v_actual;
-		goto msix_err;
-	}
 
-	if (v_actual < v_wanted) {
-		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
-			 v_wanted, v_actual);
-
-		if (v_actual < ICE_MIN_MSIX) {
-			/* error if we can't get minimum vectors */
-			pci_disable_msix(pf->pdev);
-			err = -ERANGE;
-			goto msix_err;
-		} else {
-			int v_remain = v_actual - v_other;
-
-			if (v_remain < ICE_MIN_LAN_TXRX_MSIX)
-				v_remain = ICE_MIN_LAN_TXRX_MSIX;
-
-			ice_reduce_msix_usage(pf, v_remain);
-
-			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
-				   pf->num_lan_msix);
-
-			if (ice_is_rdma_ena(pf))
-				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
-					   pf->num_rdma_msix);
-		}
-	}
+	v_actual = ice_distribute_msix(pf, &pf->msix, v_actual,
+				       pf->req_msix.eth, pf->req_msix.rdma);
+	if (v_actual < 0)
+		goto msix_err;
 
 	return v_actual;
 
 msix_err:
 	devm_kfree(dev, pf->msix_entries);
 
-exit_err:
-	pf->num_rdma_msix = 0;
-	pf->num_lan_msix = 0;
 	return err;
 }
 
@@ -4014,6 +4059,9 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 {
 	int vectors;
 
+	if (ice_set_def_msix(pf))
+		return -ERANGE;
+
 	vectors = ice_ena_msix_range(pf);
 
 	if (vectors < 0)
-- 
2.36.1

