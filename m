Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18B6837B1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjAaUpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjAaUpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:18 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3440C577CA;
        Tue, 31 Jan 2023 12:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197917; x=1706733917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y5TsZ35lgtOg1Ajr9NLwq/jpNvXHXh9JVeIDnkdTx4s=;
  b=FFczOTEqpE5VuqrCwN99knUMAEFTBawj5utglm5ZLozC1jP+7Lqurs0G
   Cq41DUQOiiIupdRsyq3R2Wbr7gYCWaPv1fn9rHjw2pr67e+oLzfTFFQmF
   MqynmKhKND2+Kjk7LAd9C2cghEkHnMklSXqCeBguNZ2DfiW9MnUGqEjZV
   csL8OTFYrRowNPcXvhdJTDTspSn1fJaA89cNHLy2OwwY1bU8IBsY8J18A
   rjyNq3f69tNBpzqPSeMcu6rx7plqoZgxItZnml3vBFruEszesBh8pPcjA
   aeDFh9krT7L8BSpUoobE5fwDWRy/wd09R+Wfh1PFqRzmRbL2P5yAWJuHp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167096"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167096"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595226"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595226"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:14 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 02/13] ice: add xdp_buff to ice_rx_ring struct
Date:   Tue, 31 Jan 2023 21:44:55 +0100
Message-Id: <20230131204506.219292-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for XDP multi-buffer support, let's store xdp_buff on
Rx ring struct. This will allow us to combine fragmented frames across
separate NAPI cycles in the same way as currently skb fragments are
handled. This means that skb pointer on Rx ring will become redundant
and will be removed. For now it is kept and layout of Rx ring struct was
not inspected, some member movement will be needed later on so that will
be the time to take care of it.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c | 39 +++++++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index e36abcfeb958..5b66f6f7db78 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -533,6 +533,7 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 		}
 	}
 
+	xdp_init_buff(&ring->xdp, ice_rx_pg_size(ring) / 2, &ring->xdp_rxq);
 	err = ice_setup_rx_ctx(ring);
 	if (err) {
 		dev_err(dev, "ice_setup_rx_ctx failed for RxQ %d, err %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index d0a6534122e0..15983c54210a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -523,8 +523,16 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	return -ENOMEM;
 }
 
+/**
+ * ice_rx_frame_truesize
+ * @rx_ring: ptr to Rx ring
+ * @size: size
+ *
+ * calculate the truesize with taking into the account PAGE_SIZE of
+ * underlying arch
+ */
 static unsigned int
-ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, unsigned int __maybe_unused size)
+ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, const unsigned int size)
 {
 	unsigned int truesize;
 
@@ -1103,21 +1111,20 @@ ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
  */
 int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
+	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
+	struct xdp_buff *xdp = &rx_ring->xdp;
 	struct ice_tx_ring *xdp_ring = NULL;
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
-	struct xdp_buff xdp;
 	bool failure;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-	frame_sz = ice_rx_frame_truesize(rx_ring, 0);
+	xdp->frame_sz = ice_rx_frame_truesize(rx_ring, 0);
 #endif
-	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	if (xdp_prog)
@@ -1171,30 +1178,30 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		rx_buf = ice_get_rx_buf(rx_ring, size, &rx_buf_pgcnt);
 
 		if (!size) {
-			xdp.data = NULL;
-			xdp.data_end = NULL;
-			xdp.data_hard_start = NULL;
-			xdp.data_meta = NULL;
+			xdp->data = NULL;
+			xdp->data_end = NULL;
+			xdp->data_hard_start = NULL;
+			xdp->data_meta = NULL;
 			goto construct_skb;
 		}
 
 		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
 			     offset;
-		xdp_prepare_buff(&xdp, hard_start, offset, size, !!offset);
+		xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
-		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
+		xdp->frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
 		if (!xdp_prog)
 			goto construct_skb;
 
-		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring);
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
 			xdp_xmit |= xdp_res;
-			ice_rx_buf_adjust_pg_offset(rx_buf, xdp.frame_sz);
+			ice_rx_buf_adjust_pg_offset(rx_buf, xdp->frame_sz);
 		} else {
 			rx_buf->pagecnt_bias++;
 		}
@@ -1207,11 +1214,11 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 construct_skb:
 		if (skb) {
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
-		} else if (likely(xdp.data)) {
+		} else if (likely(xdp->data)) {
 			if (ice_ring_uses_build_skb(rx_ring))
-				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
+				skb = ice_build_skb(rx_ring, rx_buf, xdp);
 			else
-				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
+				skb = ice_construct_skb(rx_ring, rx_buf, xdp);
 		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 166713f8abbd..b0c39d557008 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -303,6 +303,7 @@ struct ice_rx_ring {
 	struct bpf_prog *xdp_prog;
 	struct ice_tx_ring *xdp_ring;
 	struct xsk_buff_pool *xsk_pool;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	dma_addr_t dma;			/* physical address of ring */
 	u64 cached_phctime;
-- 
2.34.1

