Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97914FFA38
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiDMPdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbiDMPdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4483D37A87;
        Wed, 13 Apr 2022 08:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863850; x=1681399850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jgo3evBwcKnrCtnEZCg2TuPoWoUfHaUdZYgSBqSFEXE=;
  b=U4GfUpiHjEw4mI1w54IsOXmGwSAoC8kpLREAZQdDFR7L7fFFQqvz7A76
   rJK5ue0vPsL06L7CRInoHi8dRais/zcaqJbL9qlpHVUznWmGp20nE5zYC
   S70MzGPnRrHNAp0nFZJ+Kt3b3SgZi9QAPeQRuZeSqedtqMuOy3Y4rnV0/
   6I9MsToNqxu/mPLkTDNx94pRKmwNjiJ1Lt5fyaI73pljX/j6dWdSB39FW
   HdylDtfRovukCr20NruYBZs4echyqDmIycLKYhAYkWWyFrImWBLsXwynX
   ziw/sqdZj0qd1Ajncb1qFT53FTmizTpIcxHYaJ5vw3aLZGqboX7TnE5aF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544278"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544278"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318330"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:47 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 07/14] ixgbe: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
Date:   Wed, 13 Apr 2022 17:30:08 +0200
Message-Id: <20220413153015.453864-8-maciej.fijalkowski@intel.com>
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

Introduce new internal return code IXGBE_XDP_EXIT that will indicate case
described above.

Note that it does not affect Tx processing that is bound to the same
NAPI context, nor the other Rx rings.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 27 ++++++++++++-------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index bba3feaf3318..f1f69ce67420 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -8,6 +8,7 @@
 #define IXGBE_XDP_CONSUMED	BIT(0)
 #define IXGBE_XDP_TX		BIT(1)
 #define IXGBE_XDP_REDIR		BIT(2)
+#define IXGBE_XDP_EXIT		BIT(3)
 
 #define IXGBE_TXD_CMD (IXGBE_TXD_CMD_EOP | \
 		       IXGBE_TXD_CMD_RS)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 85497bf10624..bdd70b85a787 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -109,9 +109,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return IXGBE_XDP_REDIR;
+		if (!err)
+			return IXGBE_XDP_REDIR;
+		if (xsk_uses_need_wakeup(rx_ring->xsk_pool) && err == -ENOBUFS)
+			result = IXGBE_XDP_EXIT;
+		else
+			result = IXGBE_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -130,16 +134,17 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		if (result == IXGBE_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_DROP:
+		result = IXGBE_XDP_CONSUMED;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
+		result = IXGBE_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
-	case XDP_DROP:
-		result = IXGBE_XDP_CONSUMED;
-		break;
 	}
 	return result;
 }
@@ -303,12 +308,16 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
 		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
 
-		if (likely(xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)))
+		if (likely(xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))) {
 			xdp_xmit |= xdp_res;
-		else if (xdp_res == IXGBE_XDP_CONSUMED)
+		} else if (xdp_res == IXGBE_XDP_EXIT) {
+			failure = true;
+			break;
+		} else if (xdp_res == IXGBE_XDP_CONSUMED) {
 			xsk_buff_free(bi->xdp);
-		else
+		} else if (xdp_res == IXGBE_XDP_PASS) {
 			goto construct_skb;
+		}
 
 		bi->xdp = NULL;
 		total_rx_packets++;
-- 
2.33.1

