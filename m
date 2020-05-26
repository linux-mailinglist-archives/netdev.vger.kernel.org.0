Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768D11DE094
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgEVHGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 03:06:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:18659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbgEVHGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 03:06:15 -0400
IronPort-SDR: JcV9UnfGW+agjtNmSesg31Gql0ZWEBj+60NQKuUIV7PR0joO59V7/3qa7eKXNIdlF1Qqnfs/OP
 m+19yUoqMJJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:10 -0700
IronPort-SDR: z+aJYd6qjwUYh2dkD+WbdGAMkwUgvanI/wpQ8n8y78t9oV248U/XxcoM8uE1beQy06fTFDjtk+
 B1zMXDAJMElw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017761"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/17] ice: Fix casting issues
Date:   Thu, 21 May 2020 23:55:59 -0700
Message-Id: <20200522065607.1680050-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

Change min() macros to min_t() which has compare type specified and it
helps avoid precision loss.

In some cases there was precision loss during calls or assignments.
Some fields in structs were unnecessarily large and gave multiple
warnings.

There were also some minor type differences which are now fixed as well as
some cases where a simple cast was needed.

Callers were were passing data that is a u16 to
ice_sched_cfg_node_bw_alloc() but the function was truncating that to a u8.
Fix that by changing the function to take a u16.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 10 +++----
 drivers/net/ethernet/intel/ice/ice_base.c     | 24 ++++++++-------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  6 ++--
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 13 +++++----
 drivers/net/ethernet/intel/ice/ice_lib.c      | 29 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_main.c     | 13 +++++----
 drivers/net/ethernet/intel/ice/ice_sched.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 12 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 19 ++++++------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  4 +--
 13 files changed, 74 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index be90337cabb8..cd2bf9b8e385 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -248,8 +248,8 @@ struct ice_vsi {
 	u32 tx_busy;
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
-	int num_q_vectors;
-	int base_vector;		/* IRQ base for OS reserved vectors */
+	u16 num_q_vectors;
+	u16 base_vector;		/* IRQ base for OS reserved vectors */
 	enum ice_vsi_type type;
 	u16 vsi_num;			/* HW (absolute) index of this VSI */
 	u16 idx;			/* software index in pf->vsi[] */
@@ -390,11 +390,11 @@ struct ice_pf {
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
 	u32 hw_csum_rx_error;
-	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
-	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
+	u16 oicr_idx;		/* Other interrupt cause MSIX vector index */
+	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
 	u16 max_pf_txqs;	/* Total Tx queues PF wide */
 	u16 max_pf_rxqs;	/* Total Rx queues PF wide */
-	u32 num_lan_msix;	/* Total MSIX vectors for base driver */
+	u16 num_lan_msix;	/* Total MSIX vectors for base driver */
 	u16 num_lan_tx;		/* num LAN Tx queues setup */
 	u16 num_lan_rx;		/* num LAN Rx queues setup */
 	u16 next_vsi;		/* Next free slot in pf->vsi[] - 0-based! */
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index ee1c698ff056..4c835c144907 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -24,7 +24,7 @@ static int __ice_vsi_get_qs_contig(struct ice_qs_cfg *qs_cfg)
 
 	bitmap_set(qs_cfg->pf_map, offset, qs_cfg->q_count);
 	for (i = 0; i < qs_cfg->q_count; i++)
-		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = i + offset;
+		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = (u16)(i + offset);
 	mutex_unlock(qs_cfg->qs_mutex);
 
 	return 0;
@@ -47,7 +47,7 @@ static int __ice_vsi_get_qs_sc(struct ice_qs_cfg *qs_cfg)
 		if (index >= qs_cfg->pf_map_size)
 			goto err_scatter;
 		set_bit(index, qs_cfg->pf_map);
-		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = index;
+		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = (u16)index;
 	}
 	mutex_unlock(qs_cfg->qs_mutex);
 
@@ -96,7 +96,7 @@ static int ice_pf_rxq_wait(struct ice_pf *pf, int pf_q, bool ena)
  * We allocate one q_vector and set default value for ITR setting associated
  * with this q_vector. If allocation fails we return -ENOMEM.
  */
-static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
+static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_q_vector *q_vector;
@@ -376,7 +376,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Max packet size for this queue - must not be set to a larger value
 	 * than 5 x DBUF
 	 */
-	rlan_ctx.rxmax = min_t(u16, vsi->max_frame,
+	rlan_ctx.rxmax = min_t(u32, vsi->max_frame,
 			       chain_len * ring->rx_buf_len);
 
 	/* Rx queue threshold in units of 64 */
@@ -453,7 +453,7 @@ int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg)
 	if (ret) {
 		/* contig failed, so try with scatter approach */
 		qs_cfg->mapping_mode = ICE_VSI_MAP_SCATTER;
-		qs_cfg->q_count = min_t(u16, qs_cfg->q_count,
+		qs_cfg->q_count = min_t(unsigned int, qs_cfg->q_count,
 					qs_cfg->scatter_count);
 		ret = __ice_vsi_get_qs_sc(qs_cfg);
 	}
@@ -526,7 +526,8 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
 int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
-	int v_idx, err;
+	u16 v_idx;
+	int err;
 
 	if (vsi->q_vectors[0]) {
 		dev_dbg(dev, "VSI %d has existing q_vectors\n", vsi->vsi_num);
@@ -562,7 +563,7 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 {
 	int q_vectors = vsi->num_q_vectors;
-	int tx_rings_rem, rx_rings_rem;
+	u16 tx_rings_rem, rx_rings_rem;
 	int v_id;
 
 	/* initially assigning remaining rings count to VSIs num queue value */
@@ -571,10 +572,12 @@ void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 
 	for (v_id = 0; v_id < q_vectors; v_id++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[v_id];
-		int tx_rings_per_v, rx_rings_per_v, q_id, q_base;
+		u8 tx_rings_per_v, rx_rings_per_v;
+		u16 q_id, q_base;
 
 		/* Tx rings mapping to vector */
-		tx_rings_per_v = DIV_ROUND_UP(tx_rings_rem, q_vectors - v_id);
+		tx_rings_per_v = (u8)DIV_ROUND_UP(tx_rings_rem,
+						  q_vectors - v_id);
 		q_vector->num_ring_tx = tx_rings_per_v;
 		q_vector->tx.ring = NULL;
 		q_vector->tx.itr_idx = ICE_TX_ITR;
@@ -590,7 +593,8 @@ void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 		tx_rings_rem -= tx_rings_per_v;
 
 		/* Rx rings mapping to vector */
-		rx_rings_per_v = DIV_ROUND_UP(rx_rings_rem, q_vectors - v_id);
+		rx_rings_per_v = (u8)DIV_ROUND_UP(rx_rings_rem,
+						  q_vectors - v_id);
 		q_vector->num_ring_rx = rx_rings_per_v;
 		q_vector->rx.ring = NULL;
 		q_vector->rx.itr_idx = ICE_RX_ITR;
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index dd946866d7b8..9a865962296d 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -1128,7 +1128,7 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	}
 	memcpy(&e->desc, desc, sizeof(e->desc));
 	datalen = le16_to_cpu(desc->datalen);
-	e->msg_len = min(datalen, e->buf_len);
+	e->msg_len = min_t(u16, datalen, e->buf_len);
 	if (e->msg_buf && e->msg_len)
 		memcpy(e->msg_buf, cq->rq.r.rq_bi[desc_idx].va, e->msg_len);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b814bc54f752..41a6aa4ebb02 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2609,7 +2609,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int i, timeout = 50, err = 0;
-	u32 new_rx_cnt, new_tx_cnt;
+	u16 new_rx_cnt, new_tx_cnt;
 
 	if (ring->tx_pending > ICE_MAX_NUM_DESC ||
 	    ring->tx_pending < ICE_MIN_NUM_DESC ||
@@ -2661,8 +2661,8 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		if (ice_is_xdp_ena_vsi(vsi))
 			for (i = 0; i < vsi->num_xdp_txq; i++)
 				vsi->xdp_rings[i]->count = new_tx_cnt;
-		vsi->num_tx_desc = new_tx_cnt;
-		vsi->num_rx_desc = new_rx_cnt;
+		vsi->num_tx_desc = (u16)new_tx_cnt;
+		vsi->num_rx_desc = (u16)new_rx_cnt;
 		netdev_dbg(netdev, "Link is down, descriptor count change happens when link is brought up\n");
 		goto done;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 62e305511c7e..4dc72aef5381 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1694,7 +1694,7 @@ ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
 	 */
 	ice_set_key((u8 *)&sect_rx->tcam[0].key, sizeof(sect_rx->tcam[0].key),
 		    (u8 *)&port, NULL, NULL, NULL,
-		    offsetof(struct ice_boost_key_value, hv_dst_port_key),
+		    (u16)offsetof(struct ice_boost_key_value, hv_dst_port_key),
 		    sizeof(sect_rx->tcam[0].key.key.hv_dst_port_key));
 
 	/* exact copy of entry to Tx section entry */
@@ -2329,9 +2329,10 @@ ice_find_prof_id(struct ice_hw *hw, enum ice_block blk,
 		 struct ice_fv_word *fv, u8 *prof_id)
 {
 	struct ice_es *es = &hw->blk[blk].es;
-	u16 off, i;
+	u16 off;
+	u8 i;
 
-	for (i = 0; i < es->count; i++) {
+	for (i = 0; i < (u8)es->count; i++) {
 		off = i * es->fvw;
 
 		if (memcmp(&es->t[off], fv, es->fvw * sizeof(*fv)))
@@ -3461,7 +3462,7 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	DECLARE_BITMAP(ptgs_used, ICE_XLT1_CNT);
 	struct ice_prof_map *prof;
 	enum ice_status status;
-	u32 byte = 0;
+	u8 byte = 0;
 	u8 prof_id;
 
 	bitmap_zero(ptgs_used, ICE_XLT1_CNT);
@@ -3496,7 +3497,7 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 
 	/* build list of ptgs */
 	while (bytes && prof->ptg_cnt < ICE_MAX_PTG_PER_PROFILE) {
-		u32 bit;
+		u8 bit;
 
 		if (!ptypes[byte]) {
 			bytes--;
@@ -3530,7 +3531,7 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 				break;
 
 			/* nothing left in byte, then exit */
-			m = ~((1 << (bit + 1)) - 1);
+			m = ~(u8)((1 << (bit + 1)) - 1);
 			if (!(ptypes[byte] & m))
 				break;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index bf4c538c94bb..9330989ddb40 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -37,7 +37,8 @@ const char *ice_vsi_type_str(enum ice_vsi_type vsi_type)
  */
 static int ice_vsi_ctrl_all_rx_rings(struct ice_vsi *vsi, bool ena)
 {
-	int i, ret = 0;
+	int ret = 0;
+	u16 i;
 
 	for (i = 0; i < vsi->num_rxq; i++)
 		ice_vsi_ctrl_one_rx_ring(vsi, ena, i, false);
@@ -565,8 +566,8 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 	switch (vsi->type) {
 	case ICE_VSI_PF:
 		/* PF VSI will inherit RSS instance of PF */
-		vsi->rss_table_size = cap->rss_table_size;
-		vsi->rss_size = min_t(int, num_online_cpus(),
+		vsi->rss_table_size = (u16)cap->rss_table_size;
+		vsi->rss_size = min_t(u16, num_online_cpus(),
 				      BIT(cap->rss_table_entry_width));
 		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_PF;
 		break;
@@ -684,15 +685,15 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 				max_rss = ICE_MAX_LG_RSS_QS;
 			else
 				max_rss = ICE_MAX_RSS_QS_PER_VF;
-			qcount_rx = min_t(int, rx_numq_tc, max_rss);
+			qcount_rx = min_t(u16, rx_numq_tc, max_rss);
 			if (!vsi->req_rxq)
-				qcount_rx = min_t(int, qcount_rx,
+				qcount_rx = min_t(u16, qcount_rx,
 						  vsi->rss_size);
 		}
 	}
 
 	/* find the (rounded up) power-of-2 of qcount */
-	pow = order_base_2(qcount_rx);
+	pow = (u16)order_base_2(qcount_rx);
 
 	ice_for_each_traffic_class(i) {
 		if (!(vsi->tc_cfg.ena_tc & BIT(i))) {
@@ -941,7 +942,7 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id)
  */
 static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
 {
-	int start = 0, end = 0;
+	u16 start = 0, end = 0;
 
 	if (needed > res->end)
 		return -ENOMEM;
@@ -1024,6 +1025,7 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
 	u16 num_q_vectors;
+	int base;
 
 	dev = ice_pf_to_dev(pf);
 	/* SRIOV doesn't grab irq_tracker entries for each VSI */
@@ -1038,14 +1040,15 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
-	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
-				       vsi->idx);
-	if (vsi->base_vector < 0) {
+	base = ice_get_res(pf, pf->irq_tracker, num_q_vectors, vsi->idx);
+
+	if (base < 0) {
 		dev_err(dev, "%d MSI-X interrupts available. %s %d failed to get %d MSI-X vectors\n",
 			ice_get_free_res_count(pf->irq_tracker),
 			ice_vsi_type_str(vsi->type), vsi->idx, num_q_vectors);
 		return -ENOENT;
 	}
+	vsi->base_vector = (u16)base;
 	pf->num_avail_sw_msix -= num_q_vectors;
 
 	return 0;
@@ -1085,7 +1088,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
-	int i;
+	u16 i;
 
 	dev = ice_pf_to_dev(pf);
 	/* Allocate Tx rings */
@@ -1178,7 +1181,7 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	u8 *lut;
 
 	dev = ice_pf_to_dev(pf);
-	vsi->rss_size = min_t(int, vsi->rss_size, vsi->num_rxq);
+	vsi->rss_size = min_t(u16, vsi->rss_size, vsi->num_rxq);
 
 	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
 	if (!lut)
@@ -1673,7 +1676,7 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	u32 txq = 0, rxq = 0;
+	u16 txq = 0, rxq = 0;
 	int i, q;
 
 	for (i = 0; i < vsi->num_q_vectors; i++) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c4dda1fa5853..cbfd54867be1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2245,7 +2245,7 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 		return oicr_idx;
 
 	pf->num_avail_sw_msix -= 1;
-	pf->oicr_idx = oicr_idx;
+	pf->oicr_idx = (u16)oicr_idx;
 
 	err = devm_request_irq(dev, pf->msix_entries[pf->oicr_idx].vector,
 			       ice_misc_intr, 0, pf->int_name, pf);
@@ -2642,7 +2642,8 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 static u16
 ice_get_avail_q_count(unsigned long *pf_qmap, struct mutex *lock, u16 size)
 {
-	u16 count = 0, bit;
+	unsigned long bit;
+	u16 count = 0;
 
 	mutex_lock(lock);
 	for_each_clear_bit(bit, pf_qmap, size)
@@ -2881,8 +2882,8 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 	}
 
 	/* populate SW interrupts pool with number of OS granted IRQs. */
-	pf->num_avail_sw_msix = vectors;
-	pf->irq_tracker->num_entries = vectors;
+	pf->num_avail_sw_msix = (u16)vectors;
+	pf->irq_tracker->num_entries = (u16)vectors;
 	pf->irq_tracker->end = pf->irq_tracker->num_entries;
 
 	return 0;
@@ -2914,9 +2915,9 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 	}
 
 	if (new_tx)
-		vsi->req_txq = new_tx;
+		vsi->req_txq = (u16)new_tx;
 	if (new_rx)
-		vsi->req_rxq = new_rx;
+		vsi->req_rxq = (u16)new_rx;
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index eae707ddf8e8..d63acd2fcf79 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1917,7 +1917,7 @@ ice_sched_update_elem(struct ice_hw *hw, struct ice_sched_node *node,
  */
 static enum ice_status
 ice_sched_cfg_node_bw_alloc(struct ice_hw *hw, struct ice_sched_node *node,
-			    enum ice_rl_type rl_type, u8 bw_alloc)
+			    enum ice_rl_type rl_type, u16 bw_alloc)
 {
 	struct ice_aqc_txsched_elem_data buf;
 	struct ice_aqc_txsched_elem *data;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 51825a203e35..7d88944de31a 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -593,8 +593,8 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 			    ICE_AQC_GET_SW_CONF_RESP_IS_VF)
 				is_vf = true;
 
-			res_type = le16_to_cpu(ele->vsi_port_num) >>
-				ICE_AQC_GET_SW_CONF_RESP_TYPE_S;
+			res_type = (u8)(le16_to_cpu(ele->vsi_port_num) >>
+					ICE_AQC_GET_SW_CONF_RESP_TYPE_S);
 
 			if (res_type == ICE_AQC_GET_SW_CONF_RESP_VSI) {
 				/* FW VSI is not needed. Just continue. */
@@ -1618,12 +1618,12 @@ ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 	struct ice_aqc_sw_rules_elem *s_rule, *r_iter;
 	struct ice_fltr_list_entry *m_list_itr;
 	struct list_head *rule_head;
-	u16 elem_sent, total_elem_left;
+	u16 total_elem_left, s_rule_size;
 	struct ice_switch_info *sw;
 	struct mutex *rule_lock; /* Lock to protect filter rule list */
 	enum ice_status status = 0;
 	u16 num_unicast = 0;
-	u16 s_rule_size;
+	u8 elem_sent;
 
 	if (!m_list || !hw)
 		return ICE_ERR_PARAM;
@@ -1707,8 +1707,8 @@ ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 	     total_elem_left -= elem_sent) {
 		struct ice_aqc_sw_rules_elem *entry = r_iter;
 
-		elem_sent = min(total_elem_left,
-				(u16)(ICE_AQ_MAX_BUF_LEN / s_rule_size));
+		elem_sent = min_t(u8, total_elem_left,
+				  (ICE_AQ_MAX_BUF_LEN / s_rule_size));
 		status = ice_aq_sw_rules(hw, entry, elem_sent * s_rule_size,
 					 elem_sent, ice_aqc_opc_add_sw_rules,
 					 NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4ba1fc8261d9..05d1077f80c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -819,7 +819,7 @@ static struct sk_buff *
 ice_build_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	      struct xdp_buff *xdp)
 {
-	unsigned int metasize = xdp->data - xdp->data_meta;
+	u8 metasize = xdp->data - xdp->data_meta;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
 #else
@@ -934,7 +934,7 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  */
 static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-	u32 ntc = rx_ring->next_to_clean + 1;
+	u16 ntc = rx_ring->next_to_clean + 1;
 
 	/* fetch, update, and store next to clean */
 	ntc = (ntc < rx_ring->count) ? ntc : 0;
@@ -1544,7 +1544,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		 * don't allow the budget to go below 1 because that would exit
 		 * polling early.
 		 */
-		budget_per_ring = max(budget / q_vector->num_ring_rx, 1);
+		budget_per_ring = max_t(int, budget / q_vector->num_ring_rx, 1);
 	else
 		/* Max of 1 Rx ring in this q_vector so give it the budget */
 		budget_per_ring = budget;
@@ -2026,7 +2026,8 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		unsigned char *hdr;
 	} l4;
 	u64 cd_mss, cd_tso_len;
-	u32 paylen, l4_start;
+	u32 paylen;
+	u8 l4_start;
 	int err;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
@@ -2062,7 +2063,7 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			l4.udp->len = 0;
 
 			/* determine offset of outer transport header */
-			l4_start = l4.hdr - skb->data;
+			l4_start = (u8)(l4.hdr - skb->data);
 
 			/* remove payload length from outer checksum */
 			paylen = skb->len - l4_start;
@@ -2086,7 +2087,7 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	}
 
 	/* determine offset of transport header */
-	l4_start = l4.hdr - skb->data;
+	l4_start = (u8)(l4.hdr - skb->data);
 
 	/* remove payload length from checksum */
 	paylen = skb->len - l4_start;
@@ -2095,12 +2096,12 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		csum_replace_by_diff(&l4.udp->check,
 				     (__force __wsum)htonl(paylen));
 		/* compute length of UDP segmentation header */
-		off->header_len = sizeof(l4.udp) + l4_start;
+		off->header_len = (u8)sizeof(l4.udp) + l4_start;
 	} else {
 		csum_replace_by_diff(&l4.tcp->check,
 				     (__force __wsum)htonl(paylen));
 		/* compute length of TCP segmentation header */
-		off->header_len = (l4.tcp->doff * 4) + l4_start;
+		off->header_len = (u8)((l4.tcp->doff * 4) + l4_start);
 	}
 
 	/* update gso_segs and bytecount */
@@ -2331,7 +2332,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 
 	if (offload.cd_qw1 & ICE_TX_DESC_DTYPE_CTX) {
 		struct ice_tx_ctx_desc *cdesc;
-		int i = tx_ring->next_to_use;
+		u16 i = tx_ring->next_to_use;
 
 		/* grab the next descriptor */
 		cdesc = ICE_TX_CTX_DESC(tx_ring, i);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1f9c3d24cde7..9d6512f96b8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -8,7 +8,7 @@
  * @rx_ring: ring to bump
  * @val: new head index
  */
-void ice_release_rx_desc(struct ice_ring *rx_ring, u32 val)
+void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val)
 {
 	u16 prev_ntu = rx_ring->next_to_use & ~0x7;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index ba9164dad9ae..af0fca5b91ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -49,7 +49,7 @@ static inline void ice_xdp_ring_update_tail(struct ice_ring *xdp_ring)
 void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res);
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring);
 int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring);
-void ice_release_rx_desc(struct ice_ring *rx_ring, u32 val);
+void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val);
 void
 ice_process_skb_fields(struct ice_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4f5345a7c15d..9f6578eb4672 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -501,8 +501,8 @@ struct ice_hw {
 	u16 max_burst_size;	/* driver sets this value */
 
 	/* Tx Scheduler values */
-	u16 num_tx_sched_layers;
-	u16 num_tx_sched_phys_layers;
+	u8 num_tx_sched_layers;
+	u8 num_tx_sched_phys_layers;
 	u8 flattened_layers;
 	u8 max_cgds;
 	u8 sw_entry_point_layer;
-- 
2.26.2

