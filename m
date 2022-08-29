Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3145A569C
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiH2WBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiH2WBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:01:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F306D9CD;
        Mon, 29 Aug 2022 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661810462; x=1693346462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TjwFYCJhwXHxjhHf8QaDkV8NvtzPTtsxsyE+yFToU6Q=;
  b=QuPD2wQx80L6UWGeCQ3FyZg9gYkAxPbZCRSawWDKroHTK3tW/Ry15pIR
   kWiORUA862bPFmqJBEYvEcUahzCdU5K56m4A99foGC1AACDgiIBY8j4o+
   shq5+wApKcOozqpRASc1QAD+rzSFJbq9OuWMLpfB0dIcVNGlbnauecTFf
   mSflD6+H5tKPSZu28MBb6KML8uJ4PlkoAgXynC4Jh/cb5l9Yq+OuGJKsB
   ufu2cdMjg8nkgYx2e+rgrNJzVzaAH0mobLzNPE+uallS4/JOSJSRs0P1Z
   M5vZ+SVPvNOax+LZWOzVpyaurulr9tUa9tgmaZY0wa9SXiW0+l/MmrpZC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356726829"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="356726829"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 15:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="672551168"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 15:00:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Chandan <chandanx.rout@intel.com>
Subject: [PATCH net 1/3] ice: Fix DMA mappings leak
Date:   Mon, 29 Aug 2022 15:00:47 -0700
Message-Id: <20220829220049.333434-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix leak, when user changes ring parameters.
During reallocation of RX buffers, new DMA mappings are created for
those buffers. New buffers with different RX ring count should
substitute older ones, but those buffers were freed in ice_vsi_cfg_rxq
and reallocated again with ice_alloc_rx_buf. kfree on rx_buf caused
leak of already mapped DMA.
Reallocate ZC with xdp_buf struct, when BPF program loads. Reallocate
back to rx_buf, when BPF program unloads.
If BPF program is loaded/unloaded and XSK pools are created, reallocate
RX queues accordingly in XDP_SETUP_XSK_POOL handler.

Steps for reproduction:
while :
do
	for ((i=0; i<=8160; i=i+32))
	do
		ethtool -G enp130s0f0 rx $i tx $i
		sleep 0.5
		ethtool -g enp130s0f0
	done
done

Fixes: 617f3e1b588c ("ice: xsk: allocate separate memory for XDP SW ring")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Chandan <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 17 ------
 drivers/net/ethernet/intel/ice/ice_main.c |  8 +++
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 63 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.h  |  8 +++
 4 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 136d7911adb4..1e3243808178 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -7,18 +7,6 @@
 #include "ice_dcb_lib.h"
 #include "ice_sriov.h"
 
-static bool ice_alloc_rx_buf_zc(struct ice_rx_ring *rx_ring)
-{
-	rx_ring->xdp_buf = kcalloc(rx_ring->count, sizeof(*rx_ring->xdp_buf), GFP_KERNEL);
-	return !!rx_ring->xdp_buf;
-}
-
-static bool ice_alloc_rx_buf(struct ice_rx_ring *rx_ring)
-{
-	rx_ring->rx_buf = kcalloc(rx_ring->count, sizeof(*rx_ring->rx_buf), GFP_KERNEL);
-	return !!rx_ring->rx_buf;
-}
-
 /**
  * __ice_vsi_get_qs_contig - Assign a contiguous chunk of queues to VSI
  * @qs_cfg: gathered variables needed for PF->VSI queues assignment
@@ -519,11 +507,8 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->q_index, ring->q_vector->napi.napi_id);
 
-		kfree(ring->rx_buf);
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
-			if (!ice_alloc_rx_buf_zc(ring))
-				return -ENOMEM;
 			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
@@ -538,8 +523,6 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
-			if (!ice_alloc_rx_buf(ring))
-				return -ENOMEM;
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 				/* coverity[check_return] */
 				xdp_rxq_info_reg(&ring->xdp_rxq,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 173fe6c31341..e5bc69a9a37c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2898,10 +2898,18 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
+		/* reallocate Rx queues that are used for zero-copy */
+		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
+		if (xdp_ring_err)
+			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Rx resources failed");
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
 		xdp_ring_err = ice_destroy_xdp_rings(vsi);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
+		/* reallocate Rx queues that were used for zero-copy */
+		xdp_ring_err = ice_realloc_zc_buf(vsi, false);
+		if (xdp_ring_err)
+			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
 	} else {
 		/* safe to call even when prog == vsi->xdp_prog as
 		 * dev_xdp_install in net/core/dev.c incremented prog's
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index e48e29258450..03ce85f6e6df 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -192,6 +192,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
 	if (err)
 		return err;
+	ice_clean_rx_ring(rx_ring);
 
 	ice_qvec_toggle_napi(vsi, q_vector, false);
 	ice_qp_clean_rings(vsi, q_idx);
@@ -316,6 +317,62 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	return 0;
 }
 
+/**
+ * ice_realloc_rx_xdp_bufs - reallocate for either XSK or normal buffer
+ * @rx_ring: Rx ring
+ * @pool_present: is pool for XSK present
+ *
+ * Try allocating memory and return ENOMEM, if failed to allocate.
+ * If allocation was successful, substitute buffer with allocated one.
+ * Returns 0 on success, negative on failure
+ */
+static int
+ice_realloc_rx_xdp_bufs(struct ice_rx_ring *rx_ring, bool pool_present)
+{
+	size_t elem_size = pool_present ? sizeof(*rx_ring->xdp_buf) :
+					  sizeof(*rx_ring->rx_buf);
+	void *sw_ring = kcalloc(rx_ring->count, elem_size, GFP_KERNEL);
+
+	if (!sw_ring)
+		return -ENOMEM;
+
+	if (pool_present) {
+		kfree(rx_ring->rx_buf);
+		rx_ring->rx_buf = NULL;
+		rx_ring->xdp_buf = sw_ring;
+	} else {
+		kfree(rx_ring->xdp_buf);
+		rx_ring->xdp_buf = NULL;
+		rx_ring->rx_buf = sw_ring;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_realloc_zc_buf - reallocate XDP ZC queue pairs
+ * @vsi: Current VSI
+ * @zc: is zero copy set
+ *
+ * Reallocate buffer for rx_rings that might be used by XSK.
+ * XDP requires more memory, than rx_buf provides.
+ * Returns 0 on success, negative on failure
+ */
+int ice_realloc_zc_buf(struct ice_vsi *vsi, bool zc)
+{
+	struct ice_rx_ring *rx_ring;
+	unsigned long q;
+
+	for_each_set_bit(q, vsi->af_xdp_zc_qps,
+			 max_t(int, vsi->alloc_txq, vsi->alloc_rxq)) {
+		rx_ring = vsi->rx_rings[q];
+		if (ice_realloc_rx_xdp_bufs(rx_ring, zc))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 /**
  * ice_xsk_pool_setup - enable/disable a buffer pool region depending on its state
  * @vsi: Current VSI
@@ -345,11 +402,17 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[qid];
+
 		ret = ice_qp_dis(vsi, qid);
 		if (ret) {
 			netdev_err(vsi->netdev, "ice_qp_dis error = %d\n", ret);
 			goto xsk_pool_if_up;
 		}
+
+		ret = ice_realloc_rx_xdp_bufs(rx_ring, pool_present);
+		if (ret)
+			goto xsk_pool_if_up;
 	}
 
 	pool_failure = pool_present ? ice_xsk_pool_enable(vsi, pool, qid) :
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 21faec8e97db..4edbe81eb646 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -27,6 +27,7 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
 void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
 bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget);
+int ice_realloc_zc_buf(struct ice_vsi *vsi, bool zc);
 #else
 static inline bool
 ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
@@ -72,5 +73,12 @@ ice_xsk_wakeup(struct net_device __always_unused *netdev,
 
 static inline void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring) { }
 static inline void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring) { }
+
+static inline int
+ice_realloc_zc_buf(struct ice_vsi __always_unused *vsi,
+		   bool __always_unused zc)
+{
+	return 0;
+}
 #endif /* CONFIG_XDP_SOCKETS */
 #endif /* !_ICE_XSK_H_ */
-- 
2.35.1

