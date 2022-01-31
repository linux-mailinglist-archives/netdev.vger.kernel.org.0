Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC04A4E66
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356396AbiAaScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:38004 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356305AbiAaScQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653936; x=1675189936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XxLWtDWt+xejv9wOu97zqtbPR+YGNEwJOApele4Re6Y=;
  b=dAxzouFzv8uw2hPO1t4wkJMmvtjFNM8N4VJSXV3M9VbvLhAgZHxIWFrB
   Qtr8cerwqCErryFwM3UCsejkU2+cnP8nOeFiPbrFVv2q+9YTSjDOIFycv
   ArxqocVvakyDvkBF+SIaXaM+tJ/KaYz16mzQXttx4ZCs0pjl7xmFfidFA
   JN2Ey4/SPz7UeAaW3NItPoVrE0IIwUmGsnWGwVpNcyE3hnMZc61GEZ+T9
   KEUJ59Nu/cGnCyMUGqZDvg1R/q+Brm4BDkUcs2H+4XjoyRdob1ZPabnMy
   G7zB8PwyqWjI+dkZ3f0oVIy2Mncr6jDhstqmuPPE4r2tvmiNc7OfxHnn5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833056"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833056"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920406"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, kpsingh@kernel.org, yhs@fb.com,
        andrii@kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 3/9] ice: respect metadata in legacy-rx/ice_construct_skb()
Date:   Mon, 31 Jan 2022 10:31:46 -0800
Message-Id: <20220131183152.3085432-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
References: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

In "legacy-rx" mode represented by ice_construct_skb(), we can
still use XDP (and XDP metadata), but after XDP_PASS the metadata
will be lost as it doesn't get copied to the skb.
Copy it along with the frame headers. Account its size on skb
allocation, and when copying just treat it as a part of the frame
and do a pull after to "move" it to the "reserved" zone.
Point net_prefetch() to xdp->data_meta instead of data. This won't
change anything when the meta is not here, but will save some cache
misses otherwise.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3e38695f1c9d..c2258bee8ecb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -983,15 +983,17 @@ static struct sk_buff *
 ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		  struct xdp_buff *xdp)
 {
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(xdp->data);
+	net_prefetch(xdp->data_meta);
 
 	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
+			       ICE_RX_HDR_SIZE + metasize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
@@ -1003,8 +1005,13 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		headlen = eth_get_headlen(skb->dev, xdp->data, ICE_RX_HDR_SIZE);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen,
-							 sizeof(long)));
+	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
+	       ALIGN(headlen + metasize, sizeof(long)));
+
+	if (metasize) {
+		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
-- 
2.31.1

