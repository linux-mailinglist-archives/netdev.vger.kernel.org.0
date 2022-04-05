Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60584F3C38
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiDEMG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380423AbiDELme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060CF10BBF4;
        Tue,  5 Apr 2022 04:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156810; x=1680692810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JgaTU7sgVI5xvX23l5Zz5pnDBNJRfRd9PQn2BcJjRxo=;
  b=goRM7iDtX44VhksJwKq/wsUYyMAAJtVOGv9yr/7OC6Avnh/PYy4LaixZ
   5Ag4+qwJMO4uv8TRbwEPOrIOBt4zjR0LGFjWfO58Pb6IYk/Zi5Tq2Xr1/
   6JTCuNAmL9eHa8NZDhtQJ3ltdQm0TqnGnZKBRin9E48bYjZZW+wrM0bLG
   nHle7e11pN88JcheH1VUg97pIZ1arKjiXzq1s60LpAEmNWLzFOUT+TddC
   jWsHig2yVOTt5GHGzUStyymPj1yYiGi4KpSkKnUTSdGMTbYXP5zZoN1fk
   9JoCt/HKT4Hd63HwoLC7h9OTeDEqd62hv3QuN1RojkgSlxek9Q2umS/Vt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307964"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307964"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570814"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:47 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 03/10] ice: xsk: terminate NAPI when XSK Rx queue gets full
Date:   Tue,  5 Apr 2022 13:06:24 +0200
Message-Id: <20220405110631.404427-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
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

Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
Rx queue being full. In such case, terminate the softirq processing and
let the user space to consume descriptors from XSK Rx queue so that
there is room that driver can use later on.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 25 +++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

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
index dfbcaf08520e..2439141cfa9d 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -538,9 +538,10 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return ICE_XDP_REDIR;
+		if (!err)
+			return ICE_XDP_REDIR;
+		result = (err == -ENOBUFS) ? ICE_XDP_EXIT : ICE_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -551,15 +552,15 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
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
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough;
-	case XDP_DROP:
-		result = ICE_XDP_CONSUMED;
 		break;
 	}
 
@@ -628,10 +629,16 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 
 		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
 		if (xdp_res) {
-			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
+			if (xdp_res == ICE_XDP_EXIT) {
+				failure = true;
+				xsk_buff_free(xdp);
+				ice_bump_ntc(rx_ring);
+				break;
+			} else if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
-			else
+			} else {
 				xsk_buff_free(xdp);
+			}
 
 			total_rx_bytes += size;
 			total_rx_packets++;
@@ -666,7 +673,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
-	failure = !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
+	failure |= !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
 
 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
-- 
2.33.1

