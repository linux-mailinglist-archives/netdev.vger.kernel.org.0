Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3336837CE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAaUq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjAaUq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:46:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043B59757;
        Tue, 31 Jan 2023 12:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197982; x=1706733982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5w+tkZrunFf5CIZeqrwR9rY7LTQzRXF9JBYAoAzaEZU=;
  b=Y1VLp1bjT59bktXVI9mEMVwghMFbGmdy4AS97p8ejVxGP1ZiOzQ8uJXQ
   MU+VzLm9m1vLLG18/e6oRYClytPnKTKhHxnOY2fK/y3Vtuo484l8YvCiW
   7wIUkikc3fWaMjLm7Rp0cZ4+UJrQJaw7bnoXCbjl7CwAwb2h8ndbgjXBl
   YmcdNLvjH6l0yLaySLH3SDQML/4kYOTlqzQHTF/daOY4/zKrDnMhM9pip
   g4OePC0AKPBB4E5g0dtlfF6DvB74A3FYDsAjxTA7FdFenU/xfjqbkH50a
   Yye7SYTtIpTYrxUuunfRNER70GiccndGml/0uYiHWmA3OsQfx+FCVWYzb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167488"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167488"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:46:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595460"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595460"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:32 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 09/13] ice: use xdp->frame_sz instead of recalculating truesize
Date:   Tue, 31 Jan 2023 21:45:02 +0100
Message-Id: <20230131204506.219292-10-maciej.fijalkowski@intel.com>
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

SKB path calculates truesize on three different functions, which could
be avoided as xdp_buff carries the already calculated truesize under
xdp_buff::frame_sz. If ice_add_rx_frag() is adjusted to take the
xdp_buff as an input just like functions responsible for creating
sk_buff initially, codebase could be simplified by removing these
redundant recalculations and rely on xdp_buff::frame_sz instead.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 33 +++++++----------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3a8639608f0b..dd4d7f5ba6bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -840,6 +840,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 /**
  * ice_add_rx_frag - Add contents of Rx buffer to sk_buff as a frag
  * @rx_ring: Rx descriptor ring to transact packets on
+ * @xdp: XDP buffer
  * @rx_buf: buffer containing page to add
  * @skb: sk_buff to place the data into
  * @size: packet length from rx_desc
@@ -849,19 +850,14 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
  * The function will then update the page offset.
  */
 static void
-ice_add_rx_frag(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
-		struct sk_buff *skb, unsigned int size)
+ice_add_rx_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
+		struct ice_rx_buf *rx_buf, struct sk_buff *skb,
+		unsigned int size)
 {
-#if (PAGE_SIZE >= 8192)
-	unsigned int truesize = SKB_DATA_ALIGN(size + rx_ring->rx_offset);
-#else
-	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
-#endif
-
 	if (!size)
 		return;
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
-			rx_buf->page_offset, size, truesize);
+			rx_buf->page_offset, size, xdp->frame_sz);
 }
 
 /**
@@ -943,13 +939,6 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	      struct xdp_buff *xdp)
 {
 	u8 metasize = xdp->data - xdp->data_meta;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(xdp->data_end -
-					       xdp->data_hard_start);
-#endif
 	struct sk_buff *skb;
 
 	/* Prefetch first cache line of first page. If xdp->data_meta
@@ -959,7 +948,7 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	 */
 	net_prefetch(xdp->data_meta);
 	/* build an skb around the page buffer */
-	skb = napi_build_skb(xdp->data_hard_start, truesize);
+	skb = napi_build_skb(xdp->data_hard_start, xdp->frame_sz);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -1017,13 +1006,9 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
 	if (size) {
-#if (PAGE_SIZE >= 8192)
-		unsigned int truesize = SKB_DATA_ALIGN(size);
-#else
-		unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
-#endif
 		skb_add_rx_frag(skb, 0, rx_buf->page,
-				rx_buf->page_offset + headlen, size, truesize);
+				rx_buf->page_offset + headlen, size,
+				xdp->frame_sz);
 	} else {
 		/* buffer is unused, change the act that should be taken later
 		 * on; data was copied onto skb's linear part so there's no
@@ -1176,7 +1161,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		continue;
 construct_skb:
 		if (skb) {
-			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
+			ice_add_rx_frag(rx_ring, xdp, rx_buf, skb, size);
 		} else if (likely(xdp->data)) {
 			if (ice_ring_uses_build_skb(rx_ring))
 				skb = ice_build_skb(rx_ring, rx_buf, xdp);
-- 
2.34.1

