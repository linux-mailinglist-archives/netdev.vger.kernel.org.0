Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DE46837B7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjAaUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAaUp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACFB59E44;
        Tue, 31 Jan 2023 12:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197924; x=1706733924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fuhQHeKyui2rL3EdaJvz4AGvRHpKLNGu3DMNSdYMsqk=;
  b=UTQrRgZO8JJMnnmb96qS52GXbS8EmcjQJaagUlLbW8TY3d6iw1aqpbRI
   iBGrwwKXr/66idW+H/51lbor+zuK8Az9/Xv6/WzybLdS9Kb9IeIL8sfbL
   C4tI56d2W+lnq5+01ChVWts619wqoIJffdHO5vUIgmfjWlsZAinr7BEBM
   iY65w2RFjRaVYi6w1p/ULV24rt5hwyW6QXrn94x8mOVk5TPKgxCf/cV9m
   BKHlSP78Bum7ln/Pb8WUdGYBvD+n5IYeFJJXd9h8z9k9AEZc7xfwei06A
   Dd4ribUDvcA/n96dENrVlJyTmOpIY4TA/tUactek7LOruvzPFSJ8teY2A
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167142"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167142"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595248"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595248"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:19 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 04/13] ice: pull out next_to_clean bump out of ice_put_rx_buf()
Date:   Tue, 31 Jan 2023 21:44:57 +0100
Message-Id: <20230131204506.219292-5-maciej.fijalkowski@intel.com>
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

Plan is to move ice_put_rx_buf() to the end of ice_clean_rx_irq() so
in order to keep the ability of walking through HW Rx descriptors, pull
out next_to_clean handling out of ice_put_rx_buf().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 29 +++++++++++++----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 03edabd3ec80..1139b16f57cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -898,11 +898,12 @@ ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size)
+ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
+	       const unsigned int ntc)
 {
 	struct ice_rx_buf *rx_buf;
 
-	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+	rx_buf = &rx_ring->rx_buf[ntc];
 	rx_buf->pgcnt =
 #if (PAGE_SIZE < 8192)
 		page_count(rx_buf->page);
@@ -1040,19 +1041,12 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
  *
- * This function will update next_to_clean and then clean up the contents
- * of the rx_buf. It will either recycle the buffer or unmap it and free
- * the associated resources.
+ * This function will clean up the contents of the rx_buf. It will either
+ * recycle the buffer or unmap it and free the associated resources.
  */
 static void
 ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-	u16 ntc = rx_ring->next_to_clean + 1;
-
-	/* fetch, update, and store next to clean */
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-
 	if (!rx_buf)
 		return;
 
@@ -1114,6 +1108,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
+	u32 ntc = rx_ring->next_to_clean;
+	u32 cnt = rx_ring->count;
 	bool failure;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
@@ -1136,7 +1132,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		u16 rx_ptype;
 
 		/* get the Rx desc from Rx ring based on 'next_to_clean' */
-		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		rx_desc = ICE_RX_DESC(rx_ring, ntc);
 
 		/* status_error_len will always be zero for unused descriptors
 		 * because it's cleared in cleanup, and overlaps with hdr_addr
@@ -1160,6 +1156,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			if (rx_desc->wb.rxdid == FDIR_DESC_RXDID &&
 			    ctrl_vsi->vf)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
+			if (++ntc == cnt)
+				ntc = 0;
 			ice_put_rx_buf(rx_ring, NULL);
 			cleaned_count++;
 			continue;
@@ -1169,7 +1167,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, size);
+		rx_buf = ice_get_rx_buf(rx_ring, size, ntc);
 
 		if (!size) {
 			xdp->data = NULL;
@@ -1203,6 +1201,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
+		if (++ntc == cnt)
+			ntc = 0;
 		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
@@ -1222,6 +1222,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			break;
 		}
 
+		if (++ntc == cnt)
+			ntc = 0;
 		ice_put_rx_buf(rx_ring, rx_buf);
 		cleaned_count++;
 
@@ -1262,6 +1264,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 	}
 
+	rx_ring->next_to_clean = ntc;
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
-- 
2.34.1

