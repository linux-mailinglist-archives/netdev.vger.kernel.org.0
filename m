Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FCF215028
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgGEWWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EACEC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 207so15988073pfu.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DOVexpBA1lSRjuMgiG3/piaKPBo8txgUlzBLuPkPERA=;
        b=MWUpQGn8Y5/68H417vTvhyhaYTvkqxirmXIyVOfTgOCNQVbLx+xfD1KoylOB5oKv2C
         g+FYiIc2A+wyVRRo211iCIOHaORgbsAKi0eQC5Kc8WcDG/edEtuZ2wmxH6R403KM/3Bd
         J0UwVT3aUtOLvqFJV2HSlqlXS6FiRh7CJP6OU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DOVexpBA1lSRjuMgiG3/piaKPBo8txgUlzBLuPkPERA=;
        b=E0mkcT54Czq5l2mhwT7F0VqHxCtLS3BoEeeuzrfXZ9sAa6KFqZAF3a8afwaKnUrztR
         232CyITVQNAs7rpCml5WPwY7j48jBVEoYF77QSp6l2U7wsLfIT8v8695h3KjoRSq4qBL
         OvTh07Tv8y13ENf5dr2M9+ctCU0INe8JXvJOAsWMQB5MRmm+7xq0ti05UEnOc0VFTz0f
         I7YN9FSiOqD1pY3oJ3lV461q3t+5keR//x51B5sCPhCWnInA6zIFm2+CRKlEXpMSfnFI
         3rstv3QWhYzs3PCEX9lTll7PZJp6eRCar9h1yrDdSplwvEqCKSvWVQYKYSYU7Jj5NVJW
         XT2w==
X-Gm-Message-State: AOAM530t0NpLmu58h/e4EHPP4uPv5InbQAEVvG8HnxLw/BaT8FyPE6P4
        SuCmXuDAvhJLYG+vVFfRmHqg6Co6J3M=
X-Google-Smtp-Source: ABdhPJwqumgPtKvuOBWBcqCGwsSnIa8+8Qy4ZMKQbek9BEk8L64voA7YCXNcsClDw3bGSvbIw4XUaQ==
X-Received: by 2002:a63:db46:: with SMTP id x6mr34620071pgi.265.1593987767036;
        Sun, 05 Jul 2020 15:22:47 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:46 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 4/8] bnxt_en: Fill HW RSS table from the RSS logical indirection table.
Date:   Sun,  5 Jul 2020 18:22:08 -0400
Message-Id: <1593987732-1336-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical table, we can fill the HW RSS table
using the logical table's entries and converting them to the HW
specific format.  Re-initialize the logical table to standard
distribution if the number of RX rings changes during ring reservation.

v2: Use ALIGN() to roundup the RSS table size.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 88 ++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 96e678b..6c90a94 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4881,9 +4881,51 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
 	return 1;
 }
 
+static void __bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
+{
+	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
+	u16 i, j;
+
+	/* Fill the RSS indirection table with ring group ids */
+	for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++) {
+		if (!no_rss)
+			j = bp->rss_indir_tbl[i];
+		vnic->rss_table[i] = cpu_to_le16(vnic->fw_grp_ids[j]);
+	}
+}
+
+static void __bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
+				      struct bnxt_vnic_info *vnic)
+{
+	__le16 *ring_tbl = vnic->rss_table;
+	struct bnxt_rx_ring_info *rxr;
+	u16 tbl_size, i;
+
+	tbl_size = ALIGN(bp->rx_nr_rings, BNXT_RSS_TABLE_ENTRIES_P5);
+
+	for (i = 0; i < tbl_size; i++) {
+		u16 ring_id, j;
+
+		j = bp->rss_indir_tbl[i];
+		rxr = &bp->rx_ring[j];
+
+		ring_id = rxr->rx_ring_struct.fw_ring_id;
+		*ring_tbl++ = cpu_to_le16(ring_id);
+		ring_id = bnxt_cp_ring_for_rx(bp, rxr);
+		*ring_tbl++ = cpu_to_le16(ring_id);
+	}
+}
+
+static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
+{
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		__bnxt_fill_hw_rss_tbl_p5(bp, vnic);
+	else
+		__bnxt_fill_hw_rss_tbl(bp, vnic);
+}
+
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
-	u32 i, j, max_rings;
 	struct bnxt_vnic_info *vnic = &bp->vnic_info[vnic_id];
 	struct hwrm_vnic_rss_cfg_input req = {0};
 
@@ -4893,24 +4935,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_VNIC_RSS_CFG, -1, -1);
 	if (set_rss) {
+		bnxt_fill_hw_rss_tbl(bp, vnic);
 		req.hash_type = cpu_to_le32(bp->rss_hash_cfg);
 		req.hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
-		if (vnic->flags & BNXT_VNIC_RSS_FLAG) {
-			if (BNXT_CHIP_TYPE_NITRO_A0(bp))
-				max_rings = bp->rx_nr_rings - 1;
-			else
-				max_rings = bp->rx_nr_rings;
-		} else {
-			max_rings = 1;
-		}
-
-		/* Fill the RSS indirection table with ring group ids */
-		for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++, j++) {
-			if (j == max_rings)
-				j = 0;
-			vnic->rss_table[i] = cpu_to_le16(vnic->fw_grp_ids[j]);
-		}
-
 		req.ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 		req.hash_key_tbl_addr =
 			cpu_to_le64(vnic->rss_hash_key_dma_addr);
@@ -4922,9 +4949,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
 	struct bnxt_vnic_info *vnic = &bp->vnic_info[vnic_id];
-	u32 i, j, k, nr_ctxs, max_rings = bp->rx_nr_rings;
-	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[0];
 	struct hwrm_vnic_rss_cfg_input req = {0};
+	dma_addr_t ring_tbl_map;
+	u32 i, nr_ctxs;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_VNIC_RSS_CFG, -1, -1);
 	req.vnic_id = cpu_to_le16(vnic->fw_vnic_id);
@@ -4932,31 +4959,18 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 		hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 		return 0;
 	}
+	bnxt_fill_hw_rss_tbl(bp, vnic);
 	req.hash_type = cpu_to_le32(bp->rss_hash_cfg);
 	req.hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
-	req.ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 	req.hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
+	ring_tbl_map = vnic->rss_table_dma_addr;
 	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
-	for (i = 0, k = 0; i < nr_ctxs; i++) {
-		__le16 *ring_tbl = vnic->rss_table;
+	for (i = 0; i < nr_ctxs; ring_tbl_map += BNXT_RSS_TABLE_SIZE_P5, i++) {
 		int rc;
 
+		req.ring_grp_tbl_addr = cpu_to_le64(ring_tbl_map);
 		req.ring_table_pair_index = i;
 		req.rss_ctx_idx = cpu_to_le16(vnic->fw_rss_cos_lb_ctx[i]);
-		for (j = 0; j < 64; j++) {
-			u16 ring_id;
-
-			ring_id = rxr->rx_ring_struct.fw_ring_id;
-			*ring_tbl++ = cpu_to_le16(ring_id);
-			ring_id = bnxt_cp_ring_for_rx(bp, rxr);
-			*ring_tbl++ = cpu_to_le16(ring_id);
-			rxr++;
-			k++;
-			if (k == max_rings) {
-				k = 0;
-				rxr = &bp->rx_ring[0];
-			}
-		}
 		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 		if (rc)
 			return rc;
@@ -8251,6 +8265,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
+	bnxt_set_dflt_rss_indir_tbl(bp);
+
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
 		return rc;
-- 
1.8.3.1

