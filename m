Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC77894C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfG2KLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40146 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbfG2KLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so27772137pfp.7
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9/W0HCHf3rdVDuAD3wM68ya2YktHLulHFCxKHy3gONQ=;
        b=fGKitGlF1N3bjJG9UqveQdlPOLjglBFMkg+Vv5r3r/R7pGGS+mSNC0Oye6ajEmYT4J
         xwUdhD+E3FaGcPgDBzRdyIjB1dvi9aUnDg9YqRk6DbMyL+4GCWe2zPfwOGFiVKbqU2ug
         llXN4B6BDM4ga6jawZ7FKCUOJNFlAOtKDepRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9/W0HCHf3rdVDuAD3wM68ya2YktHLulHFCxKHy3gONQ=;
        b=mN5mhRRofCAjq1GGIQkL2lCO044Nyi800/c5QHagqwdxz/fiGX2nI6GLR6EG5nRPiE
         VUBdolya8HgbfQGJZIMPajd8b09kizUsaUJrwCbWSeddmg1m40QwVXKlAHgFhy98ScOq
         22zL/LiNoP34AQKLk0BO1E5orTybE7edvUHHWCM/hNSL2HnMcEFkJaRggp87Ky6wfBYT
         L5wzG6aTOWVwg/D8Yv1tUVtAxYCwHLzoHW5+xhpzJDU6ARiQ88UJjhd9lbuLbLay7kiU
         QL4y4MSntxwJQIDAlKGo0U83xezzvcTWJeb8nyP1tptZPq0YBb+d9CGFbXZN6PCIFav2
         JD0g==
X-Gm-Message-State: APjAAAWb1KYX3FMbqKmJA4Z0SQ9jkqyOUS1jrozV/E57S8mCwh7+0c1O
        OSxivlhjkKnDGZbPJvDsLh5OAQ==
X-Google-Smtp-Source: APXvYqxX/tYSZchYp+jhxaGxBs1z99khsS3TJEUU+yfByqr+dKHS0hFEGiEsS+zL3F59pjVbhIt/SQ==
X-Received: by 2002:a17:90a:db42:: with SMTP id u2mr111593043pjx.48.1564395077507;
        Mon, 29 Jul 2019 03:11:17 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 03/16] bnxt_en: Refactor TPA logic.
Date:   Mon, 29 Jul 2019 06:10:20 -0400
Message-Id: <1564395033-19511-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the TPA logic slightly, so that the code can be more easily
extended to support TPA on the new 57500 chips.  In particular, the
logic to get the next aggregation completion is refactored into a
new function bnxt_get_agg() so that this operation is made more
generalized.  This operation will be different on the new chip in TPA
mode.  The logic to recycle the aggregation buffers has a new start
index parameter added for the same purpose.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 117 ++++++++++++++++++------------
 1 file changed, 69 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7134d2c..7e3a37a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -828,8 +828,20 @@ static inline int bnxt_alloc_rx_page(struct bnxt *bp,
 	return 0;
 }
 
-static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 cp_cons,
-				   u32 agg_bufs)
+static struct rx_agg_cmp *bnxt_get_agg(struct bnxt *bp,
+				       struct bnxt_cp_ring_info *cpr,
+				       u16 cp_cons, u16 curr)
+{
+	struct rx_agg_cmp *agg;
+
+	cp_cons = RING_CMP(ADV_RAW_CMP(cp_cons, curr));
+	agg = (struct rx_agg_cmp *)
+		&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
+	return agg;
+}
+
+static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 idx,
+				   u16 start, u32 agg_bufs, bool tpa)
 {
 	struct bnxt_napi *bnapi = cpr->bnapi;
 	struct bnxt *bp = bnapi->bp;
@@ -845,8 +857,7 @@ static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 cp_cons,
 		struct rx_bd *prod_bd;
 		struct page *page;
 
-		agg = (struct rx_agg_cmp *)
-			&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
+		agg = bnxt_get_agg(bp, cpr, idx, start + i);
 		cons = agg->rx_agg_cmp_opaque;
 		__clear_bit(cons, rxr->rx_agg_bmap);
 
@@ -874,7 +885,6 @@ static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 cp_cons,
 
 		prod = NEXT_RX_AGG(prod);
 		sw_prod = NEXT_RX_AGG(sw_prod);
-		cp_cons = NEXT_CMP(cp_cons);
 	}
 	rxr->rx_agg_prod = prod;
 	rxr->rx_sw_agg_prod = sw_prod;
@@ -957,8 +967,8 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 
 static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 				     struct bnxt_cp_ring_info *cpr,
-				     struct sk_buff *skb, u16 cp_cons,
-				     u32 agg_bufs)
+				     struct sk_buff *skb, u16 idx,
+				     u32 agg_bufs, bool tpa)
 {
 	struct bnxt_napi *bnapi = cpr->bnapi;
 	struct pci_dev *pdev = bp->pdev;
@@ -973,8 +983,7 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 		struct page *page;
 		dma_addr_t mapping;
 
-		agg = (struct rx_agg_cmp *)
-			&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
+		agg = bnxt_get_agg(bp, cpr, idx, i);
 		cons = agg->rx_agg_cmp_opaque;
 		frag_len = (le32_to_cpu(agg->rx_agg_cmp_len_flags_type) &
 			    RX_AGG_CMP_LEN) >> RX_AGG_CMP_LEN_SHIFT;
@@ -1008,7 +1017,7 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 			 * allocated already.
 			 */
 			rxr->rx_agg_prod = prod;
-			bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs - i);
+			bnxt_reuse_rx_agg_bufs(cpr, idx, i, agg_bufs - i, tpa);
 			return NULL;
 		}
 
@@ -1021,7 +1030,6 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 		skb->truesize += PAGE_SIZE;
 
 		prod = NEXT_RX_AGG(prod);
-		cp_cons = NEXT_CMP(cp_cons);
 	}
 	rxr->rx_agg_prod = prod;
 	return skb;
@@ -1081,9 +1089,7 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	} else if (cmp_type == CMP_TYPE_RX_L2_TPA_END_CMP) {
 		struct rx_tpa_end_cmp *tpa_end = cmp;
 
-		agg_bufs = (le32_to_cpu(tpa_end->rx_tpa_end_cmp_misc_v1) &
-			    RX_TPA_END_CMP_AGG_BUFS) >>
-			   RX_TPA_END_CMP_AGG_BUFS_SHIFT;
+		agg_bufs = TPA_END_AGG_BUFS(tpa_end);
 	}
 
 	if (agg_bufs) {
@@ -1195,11 +1201,10 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	cons_rx_buf->data = NULL;
 }
 
-static void bnxt_abort_tpa(struct bnxt_cp_ring_info *cpr, u16 cp_cons,
-			   u32 agg_bufs)
+static void bnxt_abort_tpa(struct bnxt_cp_ring_info *cpr, u16 idx, u32 agg_bufs)
 {
 	if (agg_bufs)
-		bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs);
+		bnxt_reuse_rx_agg_bufs(cpr, idx, 0, agg_bufs, true);
 }
 
 static struct sk_buff *bnxt_gro_func_5731x(struct bnxt_tpa_info *tpa_info,
@@ -1371,9 +1376,7 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 	skb_shinfo(skb)->gso_size =
 		le32_to_cpu(tpa_end1->rx_tpa_end_cmp_seg_len);
 	skb_shinfo(skb)->gso_type = tpa_info->gso_type;
-	payload_off = (le32_to_cpu(tpa_end->rx_tpa_end_cmp_misc_v1) &
-		       RX_TPA_END_CMP_PAYLOAD_OFFSET) >>
-		      RX_TPA_END_CMP_PAYLOAD_OFFSET_SHIFT;
+	payload_off = TPA_END_PAYLOAD_OFF(tpa_end);
 	skb = bp->gro_func(tpa_info, payload_off, TPA_END_GRO_TS(tpa_end), skb);
 	if (likely(skb))
 		tcp_gro_complete(skb);
@@ -1403,11 +1406,11 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 	u8 agg_id = TPA_END_AGG_ID(tpa_end);
 	u8 *data_ptr, agg_bufs;
-	u16 cp_cons = RING_CMP(*raw_cons);
 	unsigned int len;
 	struct bnxt_tpa_info *tpa_info;
 	dma_addr_t mapping;
 	struct sk_buff *skb;
+	u16 idx = 0;
 	void *data;
 
 	if (unlikely(bnapi->in_reset)) {
@@ -1425,19 +1428,19 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	len = tpa_info->len;
 	mapping = tpa_info->mapping;
 
-	agg_bufs = (le32_to_cpu(tpa_end->rx_tpa_end_cmp_misc_v1) &
-		    RX_TPA_END_CMP_AGG_BUFS) >> RX_TPA_END_CMP_AGG_BUFS_SHIFT;
+	agg_bufs = TPA_END_AGG_BUFS(tpa_end);
 
 	if (agg_bufs) {
+		idx = RING_CMP(*raw_cons);
 		if (!bnxt_agg_bufs_valid(bp, cpr, agg_bufs, raw_cons))
 			return ERR_PTR(-EBUSY);
 
 		*event |= BNXT_AGG_EVENT;
-		cp_cons = NEXT_CMP(cp_cons);
+		idx = NEXT_CMP(idx);
 	}
 
 	if (unlikely(agg_bufs > MAX_SKB_FRAGS || TPA_END_ERRORS(tpa_end1))) {
-		bnxt_abort_tpa(cpr, cp_cons, agg_bufs);
+		bnxt_abort_tpa(cpr, idx, agg_bufs);
 		if (agg_bufs > MAX_SKB_FRAGS)
 			netdev_warn(bp->dev, "TPA frags %d exceeded MAX_SKB_FRAGS %d\n",
 				    agg_bufs, (int)MAX_SKB_FRAGS);
@@ -1447,7 +1450,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	if (len <= bp->rx_copy_thresh) {
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, mapping);
 		if (!skb) {
-			bnxt_abort_tpa(cpr, cp_cons, agg_bufs);
+			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			return NULL;
 		}
 	} else {
@@ -1456,7 +1459,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 
 		new_data = __bnxt_alloc_rx_data(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
-			bnxt_abort_tpa(cpr, cp_cons, agg_bufs);
+			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			return NULL;
 		}
 
@@ -1471,7 +1474,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 
 		if (!skb) {
 			kfree(data);
-			bnxt_abort_tpa(cpr, cp_cons, agg_bufs);
+			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			return NULL;
 		}
 		skb_reserve(skb, bp->rx_offset);
@@ -1479,7 +1482,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	}
 
 	if (agg_bufs) {
-		skb = bnxt_rx_pages(bp, cpr, skb, cp_cons, agg_bufs);
+		skb = bnxt_rx_pages(bp, cpr, skb, idx, agg_bufs, true);
 		if (!skb) {
 			/* Page reuse already handled by bnxt_rx_pages(). */
 			return NULL;
@@ -1623,7 +1626,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (agg_bufs)
-			bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs);
+			bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0, agg_bufs,
+					       false);
 
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
@@ -1646,7 +1650,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
 			if (agg_bufs)
-				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs);
+				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0,
+						       agg_bufs, false);
 			rc = -ENOMEM;
 			goto next_rx;
 		}
@@ -1666,7 +1671,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (agg_bufs) {
-		skb = bnxt_rx_pages(bp, cpr, skb, cp_cons, agg_bufs);
+		skb = bnxt_rx_pages(bp, cpr, skb, cp_cons, agg_bufs, false);
 		if (!skb) {
 			rc = -ENOMEM;
 			goto next_rx;
@@ -2483,6 +2488,33 @@ static int bnxt_alloc_ring(struct bnxt *bp, struct bnxt_ring_mem_info *rmem)
 	return 0;
 }
 
+static void bnxt_free_tpa_info(struct bnxt *bp)
+{
+	int i;
+
+	for (i = 0; i < bp->rx_nr_rings; i++) {
+		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+
+		kfree(rxr->rx_tpa);
+		rxr->rx_tpa = NULL;
+	}
+}
+
+static int bnxt_alloc_tpa_info(struct bnxt *bp)
+{
+	int i;
+
+	for (i = 0; i < bp->rx_nr_rings; i++) {
+		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+
+		rxr->rx_tpa = kcalloc(MAX_TPA, sizeof(struct bnxt_tpa_info),
+				      GFP_KERNEL);
+		if (!rxr->rx_tpa)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static void bnxt_free_rx_rings(struct bnxt *bp)
 {
 	int i;
@@ -2490,6 +2522,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 	if (!bp->rx_ring)
 		return;
 
+	bnxt_free_tpa_info(bp);
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 		struct bnxt_ring_struct *ring;
@@ -2503,9 +2536,6 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 		page_pool_destroy(rxr->page_pool);
 		rxr->page_pool = NULL;
 
-		kfree(rxr->rx_tpa);
-		rxr->rx_tpa = NULL;
-
 		kfree(rxr->rx_agg_bmap);
 		rxr->rx_agg_bmap = NULL;
 
@@ -2539,7 +2569,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 
 static int bnxt_alloc_rx_rings(struct bnxt *bp)
 {
-	int i, rc, agg_rings = 0, tpa_rings = 0;
+	int i, rc = 0, agg_rings = 0;
 
 	if (!bp->rx_ring)
 		return -ENOMEM;
@@ -2547,9 +2577,6 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
 		agg_rings = 1;
 
-	if (bp->flags & BNXT_FLAG_TPA)
-		tpa_rings = 1;
-
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 		struct bnxt_ring_struct *ring;
@@ -2591,17 +2618,11 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 			rxr->rx_agg_bmap = kzalloc(mem_size, GFP_KERNEL);
 			if (!rxr->rx_agg_bmap)
 				return -ENOMEM;
-
-			if (tpa_rings) {
-				rxr->rx_tpa = kcalloc(MAX_TPA,
-						sizeof(struct bnxt_tpa_info),
-						GFP_KERNEL);
-				if (!rxr->rx_tpa)
-					return -ENOMEM;
-			}
 		}
 	}
-	return 0;
+	if (bp->flags & BNXT_FLAG_TPA)
+		rc = bnxt_alloc_tpa_info(bp);
+	return rc;
 }
 
 static void bnxt_free_tx_rings(struct bnxt *bp)
-- 
2.5.1

