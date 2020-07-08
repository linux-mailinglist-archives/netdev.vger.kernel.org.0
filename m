Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7421866D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgGHLyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgGHLy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D117C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j18so2677452wmi.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4FE+YgW8molov2tJ30wlCLOLFWY6asucEzSbIlix75A=;
        b=NaXGIqetrvchFt9bk/QsC78NEB8Fm0fmle8aUhMKgdUpTM3n0DNVtSz2bkIwNzH1tH
         U800xBlIdhpSfWy840K4j0AW/WqkdLisXuiH8yJ6RNkK614uB8U7nPPT8aIBqL+Dkz4A
         4d0s23b6J2WM8VZ67p7s53YjRjVmf7HaSdDE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4FE+YgW8molov2tJ30wlCLOLFWY6asucEzSbIlix75A=;
        b=g1GzPxDanNhbFdwmCe6hp4ItiPCj0dijBvXB7vo7Cm330X5qHbZOO2b58G2Y6DKG7/
         Csl0/1dNpZBX2QU/GmFhFGeTUgVzIlkqzjZCUup5TFGyA5MqOT7gPjiCGzSCVRsZ9Q+N
         +UGRqLRJPczfPIXCwIYYMe2YIIZUdBi2CGBQfmYLMJzo3zGjxa1LuSGXbQ9Qv5u+r5EK
         QtF3IWCCXKGqZ7KlK14mReoqXiZem9Aso0jwnOTETzuVx89aXofgMJGG7g5C9HK/53SR
         6mLbMT6J5WUZlr2fI3qznLQAw1ssJh2h3pQVZZg4l1RQM4Ks68NZPzXWsclYzENYRd2B
         QJqQ==
X-Gm-Message-State: AOAM533Kt86fw+wJP8h4vSmxQve7fO32Po4cV6YB5DlVAXrrQlW9u1au
        TktAAtqBSBzKQ47QI1jsm8QsIA==
X-Google-Smtp-Source: ABdhPJwnmfZzy1K9X0qITxpft3cQf4MPTI5qPlM8ja1Ht+oLBxKP7euGFK4EjC0zH/+jzcgKd9G3nw==
X-Received: by 2002:a7b:c099:: with SMTP id r25mr9619927wmh.159.1594209268100;
        Wed, 08 Jul 2020 04:54:28 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 5/9] bnxt_en: Fill HW RSS table from the RSS logical indirection table.
Date:   Wed,  8 Jul 2020 07:53:57 -0400
Message-Id: <1594209241-1692-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical table, we can fill the HW RSS table
using the logical table's entries and converting them to the HW
specific format.  Re-initialize the logical table to standard
distribution if the number of RX rings changes during ring reservation.

v4: Use bnxt_get_rxfh_indir_size() to get the RSS table size.

v2: Use ALIGN() to roundup the RSS table size.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 88 ++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3d0bb43..fcb7bf2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4878,9 +4878,51 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
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
+	tbl_size = bnxt_get_rxfh_indir_size(bp->dev);
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
 
@@ -4890,24 +4932,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 
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
@@ -4919,9 +4946,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
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
@@ -4929,31 +4956,18 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
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
@@ -8248,6 +8262,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
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

