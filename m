Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F02350A82
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhCaXHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhCaXHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:24 -0400
IronPort-SDR: Hme8NDdBtLq9n5uYL30vNLbG0U0ABQTf+lh73Hk0jDnSP/zWe3+g3GLXqCmG4fpYLwJr0kcQwn
 JRHUeLuh0N5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587968"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587968"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:23 -0700
IronPort-SDR: Xk2NOME6bNkxHyXtZvddA3dQ8y4XQ5M3B3mQMW2c5CGCTO1gebkRgei1Qqos6LHfZ96oXBeqjQ
 KorCf59XAg6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680090"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Benita Bose <benita.bose@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 01/15] ice: Add Support for XPS
Date:   Wed, 31 Mar 2021 16:08:44 -0700
Message-Id: <20210331230858.782492-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benita Bose <benita.bose@intel.com>

Enable and configure XPS. The driver code implemented sets up the Transmit
Packet Steering Map, which in turn will be used by the kernel in queue
selection during Tx.

Signed-off-by: Benita Bose <benita.bose@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 23 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1148d768f8ed..be26775a7dfe 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -214,6 +214,26 @@ static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
 	return ring->q_index - vsi->tc_cfg.tc_info[tc].qoffset;
 }
 
+/**
+ * ice_cfg_xps_tx_ring - Configure XPS for a Tx ring
+ * @ring: The Tx ring to configure
+ *
+ * This enables/disables XPS for a given Tx descriptor ring
+ * based on the TCs enabled for the VSI that ring belongs to.
+ */
+static void ice_cfg_xps_tx_ring(struct ice_ring *ring)
+{
+	if (!ring->q_vector || !ring->netdev)
+		return;
+
+	/* We only initialize XPS once, so as not to overwrite user settings */
+	if (test_and_set_bit(ICE_TX_XPS_INIT_DONE, ring->xps_state))
+		return;
+
+	netif_set_xps_queue(ring->netdev, &ring->q_vector->affinity_mask,
+			    ring->q_index);
+}
+
 /**
  * ice_setup_tx_ctx - setup a struct ice_tlan_ctx instance
  * @ring: The Tx ring to configure
@@ -664,6 +684,9 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	u16 pf_q;
 	u8 tc;
 
+	/* Configure XPS */
+	ice_cfg_xps_tx_ring(ring);
+
 	pf_q = ring->reg_idx;
 	ice_setup_tx_ctx(ring, &tlan_ctx, pf_q);
 	/* copy context contents into the qg_buf */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 5dab77504fa5..40e34ede6e58 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -195,6 +195,11 @@ struct ice_rxq_stats {
 	u64 gro_dropped; /* GRO returned dropped */
 };
 
+enum ice_ring_state_t {
+	ICE_TX_XPS_INIT_DONE,
+	ICE_TX_NBITS,
+};
+
 /* this enum matches hardware bits and is meant to be used by DYN_CTLN
  * registers and QINT registers or more generally anywhere in the manual
  * mentioning ITR_INDX, ITR_NONE cannot be used as an index 'n' into any
@@ -292,6 +297,7 @@ struct ice_ring {
 	};
 
 	struct rcu_head rcu;		/* to avoid race on free */
+	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
 	struct bpf_prog *xdp_prog;
 	struct xsk_buff_pool *xsk_pool;
 	u16 rx_offset;
-- 
2.26.2

