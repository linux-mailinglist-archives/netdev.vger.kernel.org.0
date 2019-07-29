Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBFF7894E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfG2KLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37678 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfG2KLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so27776817pfa.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5fd5JJg8OdDeLiY3sb25Oqek2pPQy/5c/QRncme7DYI=;
        b=DA6urL55GTiJb2tgJxvyQNpjZC6fXiILo71OIopECxfzWcQk3p2EGc4RJSv4U5jhbR
         GEBoIX0rMvw5x8DuT44GobhALM8NL00t5XvivPeK1h9Fk7EDvZ8BjEGK7UufcuQpmvU+
         zeOvtuP654v4wM5nZo32LqbgbMjfSHOF6D85Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5fd5JJg8OdDeLiY3sb25Oqek2pPQy/5c/QRncme7DYI=;
        b=ppe2MfeMz7MY4Ko4rCzuniR0mrlX3qiLtWJb6Y0+fQnrD5Oye2RWc5gf6I1OYg+EY7
         KDQ789DnlaFA6JOR/dmu7agNPSYwaJ5mQIZ7rUqxUhEOalArC3S0oyMh/pZdxqBfk4Tw
         Z7Gp7UYxA4Nm/aVbFT7Sg3MKwv1J7E1y79v8aw8QdivvmP8fR6UFx0JY8KLhoGkqQmEA
         2pOo+tRIjcPpfcv1TksRubAWduuWu+k1RPHSj6Hves8TIMNH1VFKQscP8ncEZH2eVeeM
         jB2fR0etM1mXhcrlUeNgAw9zXOaQZHt41Ffwlor2AXqX2n3mJMDHpDVbbScRbOBpbKyv
         EgCQ==
X-Gm-Message-State: APjAAAXEaarJAvKcw/NyAqFof03V1KGPiE4lFFHNl8YUovY66sSdJi4G
        v6aRZtpDp+AwBYXOE7sOupZDnmKFsjs=
X-Google-Smtp-Source: APXvYqzExoQm6dUNc11IXdiZle8uhy8mK6/1PLgkSPZHUzd1trGFFLXqJP1u4yBA+eSW3f3956agVw==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr77697166pjb.115.1564395081314;
        Mon, 29 Jul 2019 03:11:21 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 08/16] bnxt_en: Add fast path logic for TPA on 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:25 -0400
Message-Id: <1564395033-19511-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all the previous refactoring, the TPA fast path can now be
modified slightly to support TPA on the new chips.  The main
difference is that the agg completions are retrieved differently using
the bnxt_get_tpa_agg_p5() function on the new chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 100 ++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b615206..535b4c1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -840,6 +840,15 @@ static struct rx_agg_cmp *bnxt_get_agg(struct bnxt *bp,
 	return agg;
 }
 
+static struct rx_agg_cmp *bnxt_get_tpa_agg_p5(struct bnxt *bp,
+					      struct bnxt_rx_ring_info *rxr,
+					      u16 agg_id, u16 curr)
+{
+	struct bnxt_tpa_info *tpa_info = &rxr->rx_tpa[agg_id];
+
+	return &tpa_info->agg_arr[curr];
+}
+
 static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 idx,
 				   u16 start, u32 agg_bufs, bool tpa)
 {
@@ -848,8 +857,12 @@ static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 idx,
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 	u16 prod = rxr->rx_agg_prod;
 	u16 sw_prod = rxr->rx_sw_agg_prod;
+	bool p5_tpa = false;
 	u32 i;
 
+	if ((bp->flags & BNXT_FLAG_CHIP_P5) && tpa)
+		p5_tpa = true;
+
 	for (i = 0; i < agg_bufs; i++) {
 		u16 cons;
 		struct rx_agg_cmp *agg;
@@ -857,7 +870,10 @@ static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 idx,
 		struct rx_bd *prod_bd;
 		struct page *page;
 
-		agg = bnxt_get_agg(bp, cpr, idx, start + i);
+		if (p5_tpa)
+			agg = bnxt_get_tpa_agg_p5(bp, rxr, idx, start + i);
+		else
+			agg = bnxt_get_agg(bp, cpr, idx, start + i);
 		cons = agg->rx_agg_cmp_opaque;
 		__clear_bit(cons, rxr->rx_agg_bmap);
 
@@ -974,8 +990,12 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 	struct pci_dev *pdev = bp->pdev;
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 	u16 prod = rxr->rx_agg_prod;
+	bool p5_tpa = false;
 	u32 i;
 
+	if ((bp->flags & BNXT_FLAG_CHIP_P5) && tpa)
+		p5_tpa = true;
+
 	for (i = 0; i < agg_bufs; i++) {
 		u16 cons, frag_len;
 		struct rx_agg_cmp *agg;
@@ -983,7 +1003,10 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 		struct page *page;
 		dma_addr_t mapping;
 
-		agg = bnxt_get_agg(bp, cpr, idx, i);
+		if (p5_tpa)
+			agg = bnxt_get_tpa_agg_p5(bp, rxr, idx, i);
+		else
+			agg = bnxt_get_agg(bp, cpr, idx, i);
 		cons = agg->rx_agg_cmp_opaque;
 		frag_len = (le32_to_cpu(agg->rx_agg_cmp_len_flags_type) &
 			    RX_AGG_CMP_LEN) >> RX_AGG_CMP_LEN_SHIFT;
@@ -1089,6 +1112,9 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	} else if (cmp_type == CMP_TYPE_RX_L2_TPA_END_CMP) {
 		struct rx_tpa_end_cmp *tpa_end = cmp;
 
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			return 0;
+
 		agg_bufs = TPA_END_AGG_BUFS(tpa_end);
 	}
 
@@ -1130,22 +1156,27 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			   struct rx_tpa_start_cmp *tpa_start,
 			   struct rx_tpa_start_cmp_ext *tpa_start1)
 {
-	u8 agg_id = TPA_START_AGG_ID(tpa_start);
-	u16 cons, prod;
-	struct bnxt_tpa_info *tpa_info;
 	struct bnxt_sw_rx_bd *cons_rx_buf, *prod_rx_buf;
+	struct bnxt_tpa_info *tpa_info;
+	u16 cons, prod, agg_id;
 	struct rx_bd *prod_bd;
 	dma_addr_t mapping;
 
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		agg_id = TPA_START_AGG_ID_P5(tpa_start);
+	else
+		agg_id = TPA_START_AGG_ID(tpa_start);
 	cons = tpa_start->rx_tpa_start_cmp_opaque;
 	prod = rxr->rx_prod;
 	cons_rx_buf = &rxr->rx_buf_ring[cons];
 	prod_rx_buf = &rxr->rx_buf_ring[prod];
 	tpa_info = &rxr->rx_tpa[agg_id];
 
-	if (unlikely(cons != rxr->rx_next_cons)) {
-		netdev_warn(bp->dev, "TPA cons %x != expected cons %x\n",
-			    cons, rxr->rx_next_cons);
+	if (unlikely(cons != rxr->rx_next_cons ||
+		     TPA_START_ERROR(tpa_start))) {
+		netdev_warn(bp->dev, "TPA cons %x, expected cons %x, error code %x\n",
+			    cons, rxr->rx_next_cons,
+			    TPA_START_ERROR_CODE(tpa_start1));
 		bnxt_sched_reset(bp, rxr);
 		return;
 	}
@@ -1190,6 +1221,7 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	tpa_info->flags2 = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_flags2);
 	tpa_info->metadata = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_metadata);
 	tpa_info->hdr_info = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_hdr_info);
+	tpa_info->agg_count = 0;
 
 	rxr->rx_prod = NEXT_RX(prod);
 	cons = NEXT_RX(cons);
@@ -1363,7 +1395,10 @@ static inline struct sk_buff *bnxt_gro_skb(struct bnxt *bp,
 	skb_shinfo(skb)->gso_size =
 		le32_to_cpu(tpa_end1->rx_tpa_end_cmp_seg_len);
 	skb_shinfo(skb)->gso_type = tpa_info->gso_type;
-	payload_off = TPA_END_PAYLOAD_OFF(tpa_end);
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		payload_off = TPA_END_PAYLOAD_OFF_P5(tpa_end1);
+	else
+		payload_off = TPA_END_PAYLOAD_OFF(tpa_end);
 	skb = bp->gro_func(tpa_info, payload_off, TPA_END_GRO_TS(tpa_end), skb);
 	if (likely(skb))
 		tcp_gro_complete(skb);
@@ -1391,14 +1426,14 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 {
 	struct bnxt_napi *bnapi = cpr->bnapi;
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
-	u8 agg_id = TPA_END_AGG_ID(tpa_end);
 	u8 *data_ptr, agg_bufs;
 	unsigned int len;
 	struct bnxt_tpa_info *tpa_info;
 	dma_addr_t mapping;
 	struct sk_buff *skb;
-	u16 idx = 0;
+	u16 idx = 0, agg_id;
 	void *data;
+	bool gro;
 
 	if (unlikely(bnapi->in_reset)) {
 		int rc = bnxt_discard_rx(bp, cpr, raw_cons, tpa_end);
@@ -1408,24 +1443,39 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		return NULL;
 	}
 
-	tpa_info = &rxr->rx_tpa[agg_id];
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		agg_id = TPA_END_AGG_ID_P5(tpa_end);
+		agg_bufs = TPA_END_AGG_BUFS_P5(tpa_end1);
+		tpa_info = &rxr->rx_tpa[agg_id];
+		if (unlikely(agg_bufs != tpa_info->agg_count)) {
+			netdev_warn(bp->dev, "TPA end agg_buf %d != expected agg_bufs %d\n",
+				    agg_bufs, tpa_info->agg_count);
+			agg_bufs = tpa_info->agg_count;
+		}
+		tpa_info->agg_count = 0;
+		*event |= BNXT_AGG_EVENT;
+		idx = agg_id;
+		gro = !!(bp->flags & BNXT_FLAG_GRO);
+	} else {
+		agg_id = TPA_END_AGG_ID(tpa_end);
+		agg_bufs = TPA_END_AGG_BUFS(tpa_end);
+		tpa_info = &rxr->rx_tpa[agg_id];
+		idx = RING_CMP(*raw_cons);
+		if (agg_bufs) {
+			if (!bnxt_agg_bufs_valid(bp, cpr, agg_bufs, raw_cons))
+				return ERR_PTR(-EBUSY);
+
+			*event |= BNXT_AGG_EVENT;
+			idx = NEXT_CMP(idx);
+		}
+		gro = !!TPA_END_GRO(tpa_end);
+	}
 	data = tpa_info->data;
 	data_ptr = tpa_info->data_ptr;
 	prefetch(data_ptr);
 	len = tpa_info->len;
 	mapping = tpa_info->mapping;
 
-	agg_bufs = TPA_END_AGG_BUFS(tpa_end);
-
-	if (agg_bufs) {
-		idx = RING_CMP(*raw_cons);
-		if (!bnxt_agg_bufs_valid(bp, cpr, agg_bufs, raw_cons))
-			return ERR_PTR(-EBUSY);
-
-		*event |= BNXT_AGG_EVENT;
-		idx = NEXT_CMP(idx);
-	}
-
 	if (unlikely(agg_bufs > MAX_SKB_FRAGS || TPA_END_ERRORS(tpa_end1))) {
 		bnxt_abort_tpa(cpr, idx, agg_bufs);
 		if (agg_bufs > MAX_SKB_FRAGS)
@@ -1498,7 +1548,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 			(tpa_info->flags2 & RX_CMP_FLAGS2_T_L4_CS_CALC) >> 3;
 	}
 
-	if (TPA_END_GRO(tpa_end))
+	if (gro)
 		skb = bnxt_gro_skb(bp, tpa_info, tpa_end, tpa_end1, skb);
 
 	return skb;
@@ -10785,7 +10835,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 	if (BNXT_SUPPORTS_TPA(bp)) {
 		bp->gro_func = bnxt_gro_func_5730x;
-		if (BNXT_CHIP_P4(bp))
+		if (BNXT_CHIP_P4_PLUS(bp))
 			bp->gro_func = bnxt_gro_func_5731x;
 	}
 	if (!BNXT_CHIP_P4_PLUS(bp))
-- 
2.5.1

