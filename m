Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9794FFA3F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiDMPdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiDMPdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8837A26;
        Wed, 13 Apr 2022 08:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863847; x=1681399847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iuX1I9I5/OrcahEg2jn+B/BkoU3Ra9dfauKmPu7YwyQ=;
  b=V3nGn2Do8uCx4d6Ca13nm4MWi738ddAbKOC90SAJzbVPa/6TGmzpUDa2
   hR9AucLiTPJGDv92jK3gEhEBVV9vF7ZY7TD+fWKyqMUKBrfXAlBHgFujW
   Vh2FO4zosolV6AZJclmXTv6+s5rbxyrzNtaCDvNdyDQqh5gRB7qO6Upoa
   2HjSM1bHCWeZ/pIUMTTjdRasg/7U5P7lKMSEvuppYT5naCJzacBBhjGVN
   ITluuEmY0KOEyAZGuFskKI2WY2woNB270wjaEStYgPg57vBpzhi0cihba
   4R/A2QdcfH6a4kchsWLjZ8olEnmadOK5J3s3ABWAS87kgIwvn20Tz+I/r
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544268"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544268"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318309"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:42 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 06/14] i40e: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
Date:   Wed, 13 Apr 2022 17:30:07 +0200
Message-Id: <20220413153015.453864-7-maciej.fijalkowski@intel.com>
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

Introduce new internal return code I40E_XDP_EXIT that will indicate case
described above.

Note that it does not affect Tx processing that is bound to the same
NAPI context, nor the other Rx rings.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 32 +++++++++++++------
 2 files changed, 23 insertions(+), 10 deletions(-)

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
index c1d25b0b0ca2..94ea8288859a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -161,9 +161,13 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return I40E_XDP_REDIR;
+		if (!err)
+			return I40E_XDP_REDIR;
+		if (xsk_uses_need_wakeup(rx_ring->xsk_pool) && err == -ENOBUFS)
+			result = I40E_XDP_EXIT;
+		else
+			result = I40E_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -175,16 +179,17 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		if (result == I40E_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_DROP:
+		result = I40E_XDP_CONSUMED;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
+		result = I40E_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
-	case XDP_DROP:
-		result = I40E_XDP_CONSUMED;
-		break;
 	}
 	return result;
 }
@@ -271,7 +276,8 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 				      unsigned int *rx_packets,
 				      unsigned int *rx_bytes,
 				      unsigned int size,
-				      unsigned int xdp_res)
+				      unsigned int xdp_res,
+				      bool *failure)
 {
 	struct sk_buff *skb;
 
@@ -281,11 +287,15 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 	if (likely(xdp_res == I40E_XDP_REDIR) || xdp_res == I40E_XDP_TX)
 		return;
 
+	if (xdp_res == I40E_XDP_EXIT) {
+		*failure = true;
+		return;
+	}
+
 	if (xdp_res == I40E_XDP_CONSUMED) {
 		xsk_buff_free(xdp_buff);
 		return;
 	}
-
 	if (xdp_res == I40E_XDP_PASS) {
 		/* NB! We are not checking for errors using
 		 * i40e_test_staterr with
@@ -371,7 +381,9 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
-					  &rx_bytes, size, xdp_res);
+					  &rx_bytes, size, xdp_res, &failure);
+		if (failure)
+			break;
 		total_rx_packets += rx_packets;
 		total_rx_bytes += rx_bytes;
 		xdp_xmit |= xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR);
@@ -382,7 +394,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	cleaned_count = (next_to_clean - rx_ring->next_to_use - 1) & count_mask;
 
 	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
-		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
+		failure |= !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
-- 
2.33.1

