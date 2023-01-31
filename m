Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F18D6837BE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjAaUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAaUpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90DE589A6;
        Tue, 31 Jan 2023 12:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197926; x=1706733926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=noIsMBLuFXdqzgQTH3+BlsZi9jslaUZoCdpeVHnDl8U=;
  b=HTHdokdbWfCvgRinU58vzjfFfEfGU6NCxvQQn8RQfvZCTfEaS/I6870L
   BrjdZ1VQ5PhlNNp6CgcAj+3oyCZpVe79blRNwZY+mvv3O/1RHi0J7AnT2
   qJwajPp9KXbmaYFWxWiZ8IX4S8W7JidOQ3nmiFffLJ+i/mgggyiTp22fa
   Yzsk71KRNEzyJ6m+zEVBkGjh4vp+9RToM+M8tt5+g18KHd0HaTFm4J9ea
   8tO5gCfA5iXKAS0K7DjBgU6qC7BPTJGspsO8FhD4XMVcuIxqC5pHclZZz
   uQY3lcDLKnn4Z2om4LzAa2+CZU0NM/hahNRTmZU2At/Mt56pJwBX8duhi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167167"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167167"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595261"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595261"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:24 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 06/13] ice: centrallize Rx buffer recycling
Date:   Tue, 31 Jan 2023 21:44:59 +0100
Message-Id: <20230131204506.219292-7-maciej.fijalkowski@intel.com>
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

Currently calls to ice_put_rx_buf() are sprinkled through
ice_clean_rx_irq() - first place is for explicit flow director's
descriptor handling, second is after running XDP prog and the last one
is after taking care of skb.

1st callsite was actually only for ntc bump purpose, as Rx buffer to be
recycled is not even passed to a function.

It is possible to walk through Rx buffers processed in particular NAPI
cycle by caching ntc from beginning of the ice_clean_rx_irq().

To do so, let us store XDP verdict inside ice_rx_buf, so action we need
to take on will be known. For XDP prog absence, just store ICE_XDP_PASS
as a verdict.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 81 ++++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
 2 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b4dc80295b12..661a66c3d0b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -553,34 +553,39 @@ ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, const unsigned int size)
  * @xdp: xdp_buff used as input to the XDP program
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
+ * @rx_buf: Rx buffer to store the XDP action
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
-static int
+static void
 ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
+	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
+	    struct ice_rx_buf *rx_buf)
 {
-	int err;
+	unsigned int ret = ICE_XDP_PASS;
 	u32 act;
 
+	if (!xdp_prog)
+		goto exit;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		return ICE_XDP_PASS;
+		break;
 	case XDP_TX:
 		if (static_branch_unlikely(&ice_xdp_locking_key))
 			spin_lock(&xdp_ring->tx_lock);
-		err = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
+		ret = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
 		if (static_branch_unlikely(&ice_xdp_locking_key))
 			spin_unlock(&xdp_ring->tx_lock);
-		if (err == ICE_XDP_CONSUMED)
+		if (ret == ICE_XDP_CONSUMED)
 			goto out_failure;
-		return err;
+		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog))
 			goto out_failure;
-		return ICE_XDP_REDIR;
+		ret = ICE_XDP_REDIR;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
@@ -589,8 +594,10 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		return ICE_XDP_CONSUMED;
+		ret = ICE_XDP_CONSUMED;
 	}
+exit:
+	rx_buf->act = ret;
 }
 
 /**
@@ -855,9 +862,6 @@ ice_add_rx_frag(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		return;
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
 			rx_buf->page_offset, size, truesize);
-
-	/* page is being used so we must update the page offset */
-	ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
 }
 
 /**
@@ -970,9 +974,6 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	/* buffer is used by skb, update page_offset */
-	ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
-
 	return skb;
 }
 
@@ -1023,14 +1024,13 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 #endif
 		skb_add_rx_frag(skb, 0, rx_buf->page,
 				rx_buf->page_offset + headlen, size, truesize);
-		/* buffer is used by skb, update page_offset */
-		ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
 	} else {
-		/* buffer is unused, reset bias back to rx_buf; data was copied
-		 * onto skb's linear part so there's no need for adjusting
-		 * page offset and we can reuse this buffer as-is
+		/* buffer is unused, change the act that should be taken later
+		 * on; data was copied onto skb's linear part so there's no
+		 * need for adjusting page offset and we can reuse this buffer
+		 * as-is
 		 */
-		rx_buf->pagecnt_bias++;
+		rx_buf->act = ICE_XDP_CONSUMED;
 	}
 
 	return skb;
@@ -1084,11 +1084,12 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int offset = rx_ring->rx_offset;
 	struct xdp_buff *xdp = &rx_ring->xdp;
 	struct ice_tx_ring *xdp_ring = NULL;
-	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
 	u32 ntc = rx_ring->next_to_clean;
 	u32 cnt = rx_ring->count;
+	u32 cached_ntc = ntc;
+	u32 xdp_xmit = 0;
 	bool failure;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
@@ -1137,7 +1138,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
 			if (++ntc == cnt)
 				ntc = 0;
-			ice_put_rx_buf(rx_ring, NULL);
 			cleaned_count++;
 			continue;
 		}
@@ -1164,25 +1164,15 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		xdp->frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
-		if (!xdp_prog)
+		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf);
+		if (rx_buf->act == ICE_XDP_PASS)
 			goto construct_skb;
-
-		xdp_res = ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring);
-		if (!xdp_res)
-			goto construct_skb;
-		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
-			xdp_xmit |= xdp_res;
-			ice_rx_buf_adjust_pg_offset(rx_buf, xdp->frame_sz);
-		} else {
-			rx_buf->pagecnt_bias++;
-		}
 		total_rx_bytes += size;
 		total_rx_pkts++;
 
 		cleaned_count++;
 		if (++ntc == cnt)
 			ntc = 0;
-		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1203,7 +1193,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 
 		if (++ntc == cnt)
 			ntc = 0;
-		ice_put_rx_buf(rx_ring, rx_buf);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
@@ -1243,6 +1232,22 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 	}
 
+	while (cached_ntc != ntc) {
+		struct ice_rx_buf *buf = &rx_ring->rx_buf[cached_ntc];
+
+		if (buf->act & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
+			xdp_xmit |= buf->act;
+		} else if (buf->act & ICE_XDP_CONSUMED) {
+			buf->pagecnt_bias++;
+		} else if (buf->act == ICE_XDP_PASS) {
+			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
+		}
+
+		ice_put_rx_buf(rx_ring, buf);
+		if (++cached_ntc >= cnt)
+			cached_ntc = 0;
+	}
 	rx_ring->next_to_clean = ntc;
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 717355c6d4c5..9d67d6f1b1f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -173,6 +173,7 @@ struct ice_rx_buf {
 	struct page *page;
 	unsigned int page_offset;
 	unsigned int pgcnt;
+	unsigned int act;
 	unsigned int pagecnt_bias;
 };
 
-- 
2.34.1

