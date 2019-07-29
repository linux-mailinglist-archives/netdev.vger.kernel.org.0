Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0881A7894F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfG2KLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33049 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfG2KLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id f20so18776871pgj.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZUh4eDg3IyDK581SUn1vU1Qu/3jRfmrvpgAE2cyy3T0=;
        b=JZAKCIJS13Dc1aQd/rErf5vA5Jqnf97da+OXR8X47Gtxh8JSHzsO28HUOQ4aB50gZF
         hSAyU6etZ+cyUkhWinf4gr/SqY6zRyOWWRAfi2CrC2c7b0KL2QszCkAp4+jHu3udGw5C
         j3bhjJ9CkTAUfvTPD8PdzOcOfeVCwMqrm6lHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZUh4eDg3IyDK581SUn1vU1Qu/3jRfmrvpgAE2cyy3T0=;
        b=B4gusCGUjnqmLgSfTiRZ9pzJX8tRhElGoZoSEJGzY86kzkv5+FqA3fGWzayHjfhT5J
         OjhZIoJH1J55TV5FXYZQXdbYBIc8ZF3C2f7bE1l2kK++0OujoltsO0uRrYLROiNr3T/d
         x/k/5x7S4iP+Ytdg5B9Q/buKvs81uAvSiiaywe8fYMacu7FCw/jlJKqURDD+LdltwWd6
         6B9XqWwKpIv45dZ8QSEp7y5gy985+UhSJC/M9FnIhlwefslesZZZOE4hbkVLr8cGh8uZ
         VRuDqfX0GOEaB1B339/Zqm01MzxFJA/zjoh4JfDPoS56xFAwNj2zrxEnq207fWV8w3V7
         LuCw==
X-Gm-Message-State: APjAAAXb/fnWjwpS1kqfflK4jbUURQ/J2IHRqSR2pBVDc1Jvz+Pgz8t3
        BN4x050j1uLy6aYHSBSATDDlhw==
X-Google-Smtp-Source: APXvYqxc6EZvdY4rCYinBtoHagI6BXvyZs6YZ9nT6qLehDQXJ9E3JO5031Bvck/0noqpi4rxKII3iQ==
X-Received: by 2002:a17:90a:3590:: with SMTP id r16mr112272545pjb.44.1564395078129;
        Mon, 29 Jul 2019 03:11:18 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 04/16] bnxt_en: Expand bnxt_tpa_info struct to support 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:21 -0400
Message-Id: <1564395033-19511-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an aggregation array to bnxt_tpa_info struct to keep track of the
aggregation completions.  The aggregation completions are not
completed at the TPA_END completion on 57500 chips so we need to
keep track of them.  The array is only allocated on the new chips
when required.  An agg_count field is also added to keep track of the
number of these completions.

The maximum concurrent TPA is now discovered from firmware instead of
the hardcoded 64.  Add a new bp->max_tpa to keep track of maximum
configured TPA.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 41 ++++++++++++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  6 +++++
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7e3a37a..b4b3405 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2333,7 +2333,7 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
 		int j;
 
 		if (rxr->rx_tpa) {
-			for (j = 0; j < MAX_TPA; j++) {
+			for (j = 0; j < bp->max_tpa; j++) {
 				struct bnxt_tpa_info *tpa_info =
 							&rxr->rx_tpa[j];
 				u8 *data = tpa_info->data;
@@ -2495,6 +2495,10 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 
+		if (rxr->rx_tpa) {
+			kfree(rxr->rx_tpa[0].agg_arr);
+			rxr->rx_tpa[0].agg_arr = NULL;
+		}
 		kfree(rxr->rx_tpa);
 		rxr->rx_tpa = NULL;
 	}
@@ -2502,15 +2506,33 @@ static void bnxt_free_tpa_info(struct bnxt *bp)
 
 static int bnxt_alloc_tpa_info(struct bnxt *bp)
 {
-	int i;
+	int i, j, total_aggs = 0;
+
+	bp->max_tpa = MAX_TPA;
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		if (!bp->max_tpa_v2)
+			return 0;
+		bp->max_tpa = max_t(u16, bp->max_tpa_v2, MAX_TPA_P5);
+		total_aggs = bp->max_tpa * MAX_SKB_FRAGS;
+	}
 
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
+		struct rx_agg_cmp *agg;
 
-		rxr->rx_tpa = kcalloc(MAX_TPA, sizeof(struct bnxt_tpa_info),
+		rxr->rx_tpa = kcalloc(bp->max_tpa, sizeof(struct bnxt_tpa_info),
 				      GFP_KERNEL);
 		if (!rxr->rx_tpa)
 			return -ENOMEM;
+
+		if (!(bp->flags & BNXT_FLAG_CHIP_P5))
+			continue;
+		agg = kcalloc(total_aggs, sizeof(*agg), GFP_KERNEL);
+		rxr->rx_tpa[0].agg_arr = agg;
+		if (!agg)
+			return -ENOMEM;
+		for (j = 1; j < bp->max_tpa; j++)
+			rxr->rx_tpa[j].agg_arr = agg + j * MAX_SKB_FRAGS;
 	}
 	return 0;
 }
@@ -2974,7 +2996,7 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 			u8 *data;
 			dma_addr_t mapping;
 
-			for (i = 0; i < MAX_TPA; i++) {
+			for (i = 0; i < bp->max_tpa; i++) {
 				data = __bnxt_alloc_rx_data(bp, &mapping,
 							    GFP_KERNEL);
 				if (!data)
@@ -4435,6 +4457,7 @@ static int bnxt_hwrm_clear_vnic_filter(struct bnxt *bp)
 static int bnxt_hwrm_vnic_set_tpa(struct bnxt *bp, u16 vnic_id, u32 tpa_flags)
 {
 	struct bnxt_vnic_info *vnic = &bp->vnic_info[vnic_id];
+	u16 max_aggs = VNIC_TPA_CFG_REQ_MAX_AGGS_MAX;
 	struct hwrm_vnic_tpa_cfg_input req = {0};
 
 	if (vnic->fw_vnic_id == INVALID_HW_RING_ID)
@@ -4474,9 +4497,14 @@ static int bnxt_hwrm_vnic_set_tpa(struct bnxt *bp, u16 vnic_id, u32 tpa_flags)
 			nsegs = (MAX_SKB_FRAGS - n) / n;
 		}
 
-		segs = ilog2(nsegs);
+		if (bp->flags & BNXT_FLAG_CHIP_P5) {
+			segs = MAX_TPA_SEGS_P5;
+			max_aggs = bp->max_tpa;
+		} else {
+			segs = ilog2(nsegs);
+		}
 		req.max_agg_segs = cpu_to_le16(segs);
-		req.max_aggs = cpu_to_le16(VNIC_TPA_CFG_REQ_MAX_AGGS_MAX);
+		req.max_aggs = cpu_to_le16(max_aggs);
 
 		req.min_agg_len = cpu_to_le32(512);
 	}
@@ -4836,6 +4864,7 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		if (flags &
 		    VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP)
 			bp->flags |= BNXT_FLAG_ROCE_MIRROR_CAP;
+		bp->max_tpa_v2 = le16_to_cpu(resp->max_aggs_supported);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 650d800..290f426 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -554,6 +554,8 @@ struct nqe_cn {
 #define BNXT_DEFAULT_TX_RING_SIZE	511
 
 #define MAX_TPA		64
+#define MAX_TPA_P5	256
+#define MAX_TPA_SEGS_P5	0x3f
 
 #if (BNXT_PAGE_SHIFT == 16)
 #define MAX_RX_PAGES	1
@@ -835,6 +837,8 @@ struct bnxt_tpa_info {
 	((hdr_info) & 0x1ff)
 
 	u16			cfa_code; /* cfa_code in TPA start compl */
+	u8			agg_count;
+	struct rx_agg_cmp	*agg_arr;
 };
 
 struct bnxt_rx_ring_info {
@@ -1481,6 +1485,8 @@ struct bnxt {
 					       u16, void *, u8 *, dma_addr_t,
 					       unsigned int);
 
+	u16			max_tpa_v2;
+	u16			max_tpa;
 	u32			rx_buf_size;
 	u32			rx_buf_use_size;	/* useable size */
 	u16			rx_offset;
-- 
2.5.1

