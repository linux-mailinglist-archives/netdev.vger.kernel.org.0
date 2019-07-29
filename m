Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3878959
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfG2KLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37044 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbfG2KLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id i70so17264657pgd.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3+VbyW/YGsMX0Qot6Cuyl0hg00Ki3fEVjxVDclJiACg=;
        b=PuIAh2Yqe7nkiCQI6IOuRgUN45hHej/VtKnRHwRaHwQSKVoeum856/i/2f57yTjg5p
         46AItY/B2zoagl9BzcxXzJ5dLI4ZuHH16Pj9/SflEx23z1uElBMFP+VybBHKmD01gpEV
         69uhN+z30yzZQOeRi4btETgCSgdpuZDSPQ3dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3+VbyW/YGsMX0Qot6Cuyl0hg00Ki3fEVjxVDclJiACg=;
        b=bITgwQmPxizcDd1O/274DGUhWW4vdMoUMfygj11TgbCwaGMvDU6HJKDhl75DeP1iMX
         pTmGnXCWWb3zcjaQ1wp8VEfp5KXmI0qpc8HFC1PVx7ivqYZC0QFIhFlFnqG3TRUd+W7p
         sTJQfrbX83Jg9BqVJl2QmLItCufuJaO7pUakPyEH9MmJziSXI0iY1tQoD+3awF2g06d9
         j4qID6QEQLhcfpjwemzrRuyMGgZpK/haW8l+GpEGb+C6yE2chmBVxnMK9qXl56DSuZr1
         XARf3kdzkopXLUH+6WLucS5LdojleD3Rjj5H/G3zmFk536yyKwHFrU+/tYeBMQn0R8t6
         Ae7A==
X-Gm-Message-State: APjAAAXNqOrADRS0NcCTwtkadx7ckPF+9JEIp2D2V30nltB1hnNL4idg
        qNJegzwh0M707rS94ls8Wf8YUtsDpQc=
X-Google-Smtp-Source: APXvYqykzGNuQTAq8T8/1D8AE+zJCgSw565bCyyA6u4fY5kKeVtMaezWZki8U+xEG7xIBnVwbbLNxg==
X-Received: by 2002:a65:51c1:: with SMTP id i1mr82433353pgq.417.1564395078834;
        Mon, 29 Jul 2019 03:11:18 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 05/16] bnxt_en: Handle standalone RX_AGG completions.
Date:   Mon, 29 Jul 2019 06:10:22 -0400
Message-Id: <1564395033-19511-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the new 57500 chips, these new RX_AGG completions are not coalesced
at the TPA_END completion.  Handle these by storing them in the
array in the bnxt_tpa_info struct, as they are seen when processing
the CMPL ring.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4b3405..810eea2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1517,6 +1517,17 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 	return skb;
 }
 
+static void bnxt_tpa_agg(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
+			 struct rx_agg_cmp *rx_agg)
+{
+	u16 agg_id = TPA_AGG_AGG_ID(rx_agg);
+	struct bnxt_tpa_info *tpa_info;
+
+	tpa_info = &rxr->rx_tpa[agg_id];
+	BUG_ON(tpa_info->agg_count >= MAX_SKB_FRAGS);
+	tpa_info->agg_arr[tpa_info->agg_count++] = *rx_agg;
+}
+
 static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 			     struct sk_buff *skb)
 {
@@ -1558,6 +1569,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	rxcmp = (struct rx_cmp *)
 			&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
 
+	cmp_type = RX_CMP_TYPE(rxcmp);
+
+	if (cmp_type == CMP_TYPE_RX_TPA_AGG_CMP) {
+		bnxt_tpa_agg(bp, rxr, (struct rx_agg_cmp *)rxcmp);
+		goto next_rx_no_prod_no_len;
+	}
+
 	tmp_raw_cons = NEXT_RAW_CMP(tmp_raw_cons);
 	cp_cons = RING_CMP(tmp_raw_cons);
 	rxcmp1 = (struct rx_cmp_ext *)
@@ -1566,8 +1584,6 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
-	cmp_type = RX_CMP_TYPE(rxcmp);
-
 	prod = rxr->rx_prod;
 
 	if (cmp_type == CMP_TYPE_RX_L2_TPA_START_CMP) {
-- 
2.5.1

