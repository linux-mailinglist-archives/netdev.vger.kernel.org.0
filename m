Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187F678953
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfG2KLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38771 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfG2KLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so27307185plb.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gSv4rFgPDcMyQr7gclGr5hZA7ruQjkQygumdzWs0B7Q=;
        b=cVLbEzCa96UaKRLsSupYILnVty6qU4UIbkwq+lTOKFv/J/OZkU1xDaMzf22Nb7gsHj
         KPuFTwwtOmvKHvHlplbgh4fKM92V6452BKU2Icg1EWojWAgoJZeK/Yh8hSEb8TOHHRaY
         3RAnG+hWA3m61nEzxBZcRcRdSwahHA10rAdUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gSv4rFgPDcMyQr7gclGr5hZA7ruQjkQygumdzWs0B7Q=;
        b=oje7vjASV5Sig++ydsE2MAcvjXU9WkL77bY6TPG1hUH0egbUcW9VDwdIvVz8pODky6
         LwQLsMvli6Wkqn2XlykoF4s0HCqVvq08QT4kAjg3zGcpg7tx4LAXcvkDIxJGTVRiSGjV
         KVrN1tSBfhenmY+hK9ll8H9nvLQF28NjeCf/FlzIq7PIUoVWulxvZX5P9/TyLrX61zaS
         HvcljIAFASlz6LvG0OkM32FiQ5fBF7ruLusnmkaBc4xPAttkcBodl8Cwji37H4kT60Nw
         ZWc9nzHNHtDI/nh0PKORJqxyFLf8frGTjun2W1Xp/1mFE/f0NPIwhF2VXydCdmczAJvD
         XKAg==
X-Gm-Message-State: APjAAAUbmEOTij12E8EDSBe8aRBqRDoMcFwKGWeyx49uk0l6OJIVa782
        5UtTrp5qkhgiZjq9Rb4iaU8LS9Qg0dg=
X-Google-Smtp-Source: APXvYqzjafidjeEd6lxWKaZKGD/CTatWXhNqKnwpbAEzWhQHiitcDzKyVpD0k5zWu+ynFACtinbsAQ==
X-Received: by 2002:a17:902:a409:: with SMTP id p9mr110446338plq.218.1564395082169;
        Mon, 29 Jul 2019 03:11:22 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 09/16] bnxt_en: Add TPA ID mapping logic for 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:26 -0400
Message-Id: <1564395033-19511-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new TPA feature on 57500 supports a larger number of concurrent TPAs
(up to 1024) divided among the functions.  We need to add some logic to
map the hardware TPA ID to a software index that keeps track of each TPA
in progress.  A 1:1 direct mapping without translation would be too
wasteful as we would have to allocate 1024 TPA structures for each RX
ring on each PCI function.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 46 +++++++++++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  9 ++++++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 535b4c1..e5b1477 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1152,6 +1152,33 @@ static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 	rxr->rx_next_cons = 0xffff;
 }
 
+static u16 bnxt_alloc_agg_idx(struct bnxt_rx_ring_info *rxr, u16 agg_id)
+{
+	struct bnxt_tpa_idx_map *map = rxr->rx_tpa_idx_map;
+	u16 idx = agg_id & MAX_TPA_P5_MASK;
+
+	if (test_bit(idx, map->agg_idx_bmap))
+		idx = find_first_zero_bit(map->agg_idx_bmap,
+					  BNXT_AGG_IDX_BMAP_SIZE);
+	__set_bit(idx, map->agg_idx_bmap);
+	map->agg_id_tbl[agg_id] = idx;
+	return idx;
+}
+
+static void bnxt_free_agg_idx(struct bnxt_rx_ring_info *rxr, u16 idx)
+{
+	struct bnxt_tpa_idx_map *map = rxr->rx_tpa_idx_map;
+
+	__clear_bit(idx, map->agg_idx_bmap);
+}
+
+static u16 bnxt_lookup_agg_idx(struct bnxt_rx_ring_info *rxr, u16 agg_id)
+{
+	struct bnxt_tpa_idx_map *map = rxr->rx_tpa_idx_map;
+
+	return map->agg_id_tbl[agg_id];
+}
+
 static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			   struct rx_tpa_start_cmp *tpa_start,
 			   struct rx_tpa_start_cmp_ext *tpa_start1)
@@ -1162,10 +1189,12 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	struct rx_bd *prod_bd;
 	dma_addr_t mapping;
 
-	if (bp->flags & BNXT_FLAG_CHIP_P5)
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		agg_id = TPA_START_AGG_ID_P5(tpa_start);
-	else
+		agg_id = bnxt_alloc_agg_idx(rxr, agg_id);
+	} else {
 		agg_id = TPA_START_AGG_ID(tpa_start);
+	}
 	cons = tpa_start->rx_tpa_start_cmp_opaque;
 	prod = rxr->rx_prod;
 	cons_rx_buf = &rxr->rx_buf_ring[cons];
@@ -1445,6 +1474,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		agg_id = TPA_END_AGG_ID_P5(tpa_end);
+		agg_id = bnxt_lookup_agg_idx(rxr, agg_id);
 		agg_bufs = TPA_END_AGG_BUFS_P5(tpa_end1);
 		tpa_info = &rxr->rx_tpa[agg_id];
 		if (unlikely(agg_bufs != tpa_info->agg_count)) {
@@ -1454,6 +1484,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		}
 		tpa_info->agg_count = 0;
 		*event |= BNXT_AGG_EVENT;
+		bnxt_free_agg_idx(rxr, agg_id);
 		idx = agg_id;
 		gro = !!(bp->flags & BNXT_FLAG_GRO);
 	} else {
@@ -1560,6 +1591,7 @@ static void bnxt_tpa_agg(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	u16 agg_id = TPA_AGG_AGG_ID(rx_agg);
 	struct bnxt_tpa_info *tpa_info;
 
+	agg_id = bnxt_lookup_agg_idx(rxr, agg_id);
 	tpa_info = &rxr->rx_tpa[agg_id];
 	BUG_ON(tpa_info->agg_count >= MAX_SKB_FRAGS);
 	tpa_info->agg_arr[tpa_info->agg_count++] = *rx_agg;
@@ -2383,6 +2415,7 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
 	max_agg_idx = bp->rx_agg_nr_pages * RX_DESC_CNT;
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+		struct bnxt_tpa_idx_map *map;
 		int j;
 
 		if (rxr->rx_tpa) {
@@ -2453,6 +2486,9 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
 			__free_page(rxr->rx_page);
 			rxr->rx_page = NULL;
 		}
+		map = rxr->rx_tpa_idx_map;
+		if (map)
+			memset(map->agg_idx_bmap, 0, sizeof(map->agg_idx_bmap));
 	}
 }
 
@@ -2548,6 +2584,8 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 
+		kfree(rxr->rx_tpa_idx_map);
+		rxr->rx_tpa_idx_map = NULL;
 		if (rxr->rx_tpa) {
 			kfree(rxr->rx_tpa[0].agg_arr);
 			rxr->rx_tpa[0].agg_arr = NULL;
@@ -2586,6 +2624,10 @@ static int bnxt_alloc_tpa_info(struct bnxt *bp)
 			return -ENOMEM;
 		for (j = 1; j < bp->max_tpa; j++)
 			rxr->rx_tpa[j].agg_arr = agg + j * MAX_SKB_FRAGS;
+		rxr->rx_tpa_idx_map = kzalloc(sizeof(*rxr->rx_tpa_idx_map),
+					      GFP_KERNEL);
+		if (!rxr->rx_tpa_idx_map)
+			return -ENOMEM;
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 290f426..309cf99 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -555,6 +555,7 @@ struct nqe_cn {
 
 #define MAX_TPA		64
 #define MAX_TPA_P5	256
+#define MAX_TPA_P5_MASK	(MAX_TPA_P5 - 1)
 #define MAX_TPA_SEGS_P5	0x3f
 
 #if (BNXT_PAGE_SHIFT == 16)
@@ -841,6 +842,13 @@ struct bnxt_tpa_info {
 	struct rx_agg_cmp	*agg_arr;
 };
 
+#define BNXT_AGG_IDX_BMAP_SIZE	(MAX_TPA_P5 / BITS_PER_LONG)
+
+struct bnxt_tpa_idx_map {
+	u16		agg_id_tbl[1024];
+	unsigned long	agg_idx_bmap[BNXT_AGG_IDX_BMAP_SIZE];
+};
+
 struct bnxt_rx_ring_info {
 	struct bnxt_napi	*bnapi;
 	u16			rx_prod;
@@ -868,6 +876,7 @@ struct bnxt_rx_ring_info {
 	dma_addr_t		rx_agg_desc_mapping[MAX_RX_AGG_PAGES];
 
 	struct bnxt_tpa_info	*rx_tpa;
+	struct bnxt_tpa_idx_map *rx_tpa_idx_map;
 
 	struct bnxt_ring_struct	rx_ring_struct;
 	struct bnxt_ring_struct	rx_agg_ring_struct;
-- 
2.5.1

