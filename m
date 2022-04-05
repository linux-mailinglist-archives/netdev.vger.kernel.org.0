Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA74F3C1A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbiDEME0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380451AbiDELmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967CD10C503;
        Tue,  5 Apr 2022 04:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156812; x=1680692812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VOYgpkuteQKctpO5ZQs6WExAcRB8Fjb3a6/EEWgDyRk=;
  b=FeljZoLNnIatGGISfAeCdqXHp9ntWm7o6kMt0P2HO4tQcwtUZCIJomqJ
   YQOBocyUbZUqY7sWmAYvcyRAoCbN1S1zeGfy4G0rOzVGsPFDIlQJrct9e
   nBP7ps5MbV41akrXeqb4YTM4EYCq3gtgq5mylnkv23p5bTOIEHF1pCNuu
   5YXSY88s+hzpDpMkCT2HlFFFGzgaSNiLOLZZAEBFy0TY+BwkQ6b5XDCXV
   t+LFYZCobVgmrPdTtdrFtrPle+j62y0gedPDGteugUbnXzGF93jsY376E
   Nkc2xvwvYJhcFRtoFk6uJisj1c5ORFMfG/4oBSlZcbGMVjWZA0xr9TBYo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307972"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307972"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570826"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:50 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 04/10] i40e: xsk: terminate NAPI when XSK Rx queue gets full
Date:   Tue,  5 Apr 2022 13:06:25 +0200
Message-Id: <20220405110631.404427-5-maciej.fijalkowski@intel.com>
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
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 ++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 19da3b22160f..8c5118c8baaf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -20,6 +20,7 @@ void i40e_release_rx_desc(struct i40e_ring *rx_ring, u32 val);
 #define I40E_XDP_CONSUMED	BIT(0)
 #define I40E_XDP_TX		BIT(1)
 #define I40E_XDP_REDIR		BIT(2)
+#define I40E_XDP_EXIT		BIT(3)
 
 /*
  * build_ctob - Builds the Tx descriptor (cmd, offset and type) qword
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index c1d25b0b0ca2..9f9e4ce9a24d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -161,9 +161,10 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return I40E_XDP_REDIR;
+		if (!err)
+			return I40E_XDP_REDIR;
+		result = (err == -ENOBUFS) ? I40E_XDP_EXIT : I40E_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -175,6 +176,9 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		if (result == I40E_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_DROP:
+		result = I40E_XDP_CONSUMED;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
@@ -182,9 +186,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
-	case XDP_DROP:
-		result = I40E_XDP_CONSUMED;
-		break;
 	}
 	return result;
 }
@@ -370,6 +371,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
 		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
+		if (xdp_res == I40E_XDP_EXIT) {
+			failure = true;
+			xsk_buff_free(bi);
+			next_to_clean = (next_to_clean + 1) & count_mask;
+			break;
+		}
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
 					  &rx_bytes, size, xdp_res);
 		total_rx_packets += rx_packets;
@@ -382,7 +389,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	cleaned_count = (next_to_clean - rx_ring->next_to_use - 1) & count_mask;
 
 	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
-		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
+		failure |= !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
-- 
2.33.1

