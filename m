Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD794FFA31
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiDMPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiDMPdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD22037A87;
        Wed, 13 Apr 2022 08:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863842; x=1681399842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DViUqkwcqzhXJl9eAtXWVX72kqmsj+d+jOdh0DLymh8=;
  b=RZmkCpvBwrap79z83HeEsVMyml2t4S2vrSTnOve6pQo9q5nu2oDGpJzj
   MfprrB679z25mWHoCAJXu4jP+OrH+POl5sQrMFA5z9wMsacLlvrRyFsnE
   utJJ71xkNTrS2u8Dd8YyueLej3G5E3z3FT4ezOaAsGxuwR5++C9YAjZc1
   qxyCKNe/ZZ4XUwD5SzJgxTHV2tVihviPPz3YLKXQNU6K7Y5hDJrvI8blt
   MUVix03D0mvAJhZEg3QsUq2gIxLz6lIurhpCRpGvXSqYzgoCxrPlICXwB
   8thFrZ0aiNmz353GR2IackjtQIfRehsPYn7IdsiTcHxA/rBU5CX5l5lGF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544240"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544240"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318275"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:39 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 05/14] ice: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
Date:   Wed, 13 Apr 2022 17:30:06 +0200
Message-Id: <20220413153015.453864-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
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

When XSK pool uses need_wakeup feature, correlate -ENOBUFS that was
returned from xdp_do_redirect() with a XSK Rx queue being full. In such
case, terminate the Rx processing that is being done on the current HW
Rx ring and let the user space consume descriptors from XSK Rx queue so
that there is room that driver can use later on.

Introduce new internal return code ICE_XDP_EXIT that will indicate case
described above.

Note that it does not affect Tx processing that is bound to the same
NAPI context, nor the other Rx rings.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 29 +++++++++++++++--------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index cead3eb149bd..f5a906c03669 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -133,6 +133,7 @@ static inline int ice_skb_pad(void)
 #define ICE_XDP_CONSUMED	BIT(0)
 #define ICE_XDP_TX		BIT(1)
 #define ICE_XDP_REDIR		BIT(2)
+#define ICE_XDP_EXIT		BIT(3)
 
 #define ICE_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index e9ff05de0084..99bfa21c3938 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -540,9 +540,13 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return ICE_XDP_REDIR;
+		if (!err)
+			return ICE_XDP_REDIR;
+		if (xsk_uses_need_wakeup(rx_ring->xsk_pool) && err == -ENOBUFS)
+			result = ICE_XDP_EXIT;
+		else
+			result = ICE_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -553,15 +557,16 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		if (result == ICE_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_DROP:
+		result = ICE_XDP_CONSUMED;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
+		result = ICE_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough;
-	case XDP_DROP:
-		result = ICE_XDP_CONSUMED;
 		break;
 	}
 
@@ -629,12 +634,16 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
 		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
-		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)))
+		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
 			xdp_xmit |= xdp_res;
-		else if (xdp_res == ICE_XDP_CONSUMED)
+		} else if (xdp_res == ICE_XDP_EXIT) {
+			failure = true;
+			break;
+		} else if (xdp_res == ICE_XDP_CONSUMED) {
 			xsk_buff_free(xdp);
-		else
+		} else if (xdp_res == ICE_XDP_PASS) {
 			goto construct_skb;
+		}
 
 		total_rx_bytes += size;
 		total_rx_packets++;
@@ -669,7 +678,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
-	failure = !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
+	failure |= !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
 
 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
-- 
2.33.1

