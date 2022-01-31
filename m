Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503D94A4E6C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356473AbiAaScX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:38008 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356502AbiAaScU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653940; x=1675189940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4jXI3N4TZrnReB4yC0kDy/c1ZvV0jMuT4M5TjQwH7Ug=;
  b=ieQwGQ/iWzRzwCYiBPt/QUGSQVOuYsHpqhLGUo365AnwYtZ7JgTchH7J
   F3lnCIm/sc/DImO6hl1Lzn3gLDUkTohciySVIX/ErzehCfWi0UcIQVL5U
   WPXV32sj5E7qm1yYA0lOqtm5Qes82RtGVuDFE2fcGctm89zXr3VRKI31k
   8abS72Ko1d7EERrvmhcIuZ1zPNW/3JSMFkaPHCvnNQClaXlSIxPbdR4Dh
   dnd5yYJouxqN5yPfCK41An/Qt3X2Qu8q+6kVPLEkjyOpCvjdfPjAjxlKk
   3I1cdY4NlByc9+qEu90CfWE2SMz3ULlWvODjLO+bZihPUwNXYjO+bi4i3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833086"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833086"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920428"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, kpsingh@kernel.org, yhs@fb.com,
        andrii@kernel.org, bpf@vger.kernel.org,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 7/9] ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
Date:   Mon, 31 Jan 2022 10:31:50 -0800
Message-Id: <20220131183152.3085432-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
References: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

To not dereference bi->xdp each time in ixgbe_construct_skb_zc(),
pass bi->xdp as an argument instead of bi. We can also call
xsk_buff_free() outside of the function as well as assign bi->xdp
to NULL, which seems to make it closer to its name.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index b3fd8e5cd85b..5447bfb31838 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -207,26 +207,24 @@ bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
 }
 
 static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
-					      struct ixgbe_rx_buffer *bi)
+					      const struct xdp_buff *xdp)
 {
-	unsigned int metasize = bi->xdp->data - bi->xdp->data_meta;
-	unsigned int datasize = bi->xdp->data_end - bi->xdp->data;
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	unsigned int datasize = xdp->data_end - xdp->data;
 	struct sk_buff *skb;
 
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       bi->xdp->data_end - bi->xdp->data_hard_start,
+			       xdp->data_end - xdp->data_hard_start,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, bi->xdp->data - bi->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), bi->xdp->data, datasize);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	xsk_buff_free(bi->xdp);
-	bi->xdp = NULL;
 	return skb;
 }
 
@@ -317,12 +315,15 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		}
 
 		/* XDP_PASS path */
-		skb = ixgbe_construct_skb_zc(rx_ring, bi);
+		skb = ixgbe_construct_skb_zc(rx_ring, bi->xdp);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_rx_buff_failed++;
 			break;
 		}
 
+		xsk_buff_free(bi->xdp);
+		bi->xdp = NULL;
+
 		cleaned_count++;
 		ixgbe_inc_ntc(rx_ring);
 
-- 
2.31.1

