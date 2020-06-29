Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EE120DFB2
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbgF2UjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgF2TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:15 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB44C08EB2A
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:56 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so6698074plq.6
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BTE+mFGvT7ItM5aGaBUH2jfnDHC//PL89QhRJInPnUg=;
        b=LKEG9YXftjgCp+zR7T6U0ItRZ+zpsLqlYfWklyUIhcvYS/40lyWF3mxT0MQaP1LeJZ
         yHOSMEXREP1RcYMSpix0gyq92eyGoFCr/4w0EHr6/tVSiYSgfHWww+4N5mY87YU7+R5v
         /qgyKTi5Mryq1nlsS9ODXZDklazQZkvpBuxhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BTE+mFGvT7ItM5aGaBUH2jfnDHC//PL89QhRJInPnUg=;
        b=al7JxbOlmMTZ4BcGOfNHI65YakpEwJW88QQ+IsBo+tdoTT8J4rTW6cUhWB0wgQDCUJ
         sW3Ey8J/sIanftySYwzvu9TcRyWVjXB+LBX3FHH+AxmQUl/Z47q/iXuLm7yRCV+Gmdb3
         pn9fqLgzSCPe5QQ3FefidqHz/d+XW5mRVqbVuOtAbu3lkTdICCLa8IjU8M5mM/pvOvPk
         yEKk4RJXcxsuk6SnE6m8TKwEvh5KpGSs5m0qdcyZLv8+LsU+x7va7FUR7ON3F6iWCbWV
         Zq0gsObBWieIO+dqeWEa02Qo+6y87gcSY+NP2BS7VFOxi5znGnTInoubutbwEWKFUUez
         MVyQ==
X-Gm-Message-State: AOAM53304NzNkzHBeTH5wg+7MXayH9Uix15CAdxauLYySUf4hI0sttK5
        8kz36/+hAzmE1KxZI8njpY3tkw==
X-Google-Smtp-Source: ABdhPJyfrINcRFOuIFmADGVFT44jsAakhIIMOYMYh32CPLeXv4sUn8nmQQWDPTpPv3hA+0cIewVPXA==
X-Received: by 2002:a17:902:9687:: with SMTP id n7mr12366197plp.180.1593412496062;
        Sun, 28 Jun 2020 23:34:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:55 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/8] bnxt_en: Fill HW RSS table from the RSS logical indirection table.
Date:   Mon, 29 Jun 2020 02:34:20 -0400
Message-Id: <1593412464-503-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical table, we can fill the HW RSS table
using the logical table's entries and converting them to the HW
specific format.  Re-initialize the logical table to standard
distribution if the number of RX rings changes during ring reservation.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 89 ++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7bf843d..87d37dc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4882,9 +4882,52 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
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
+	tbl_size = (bp->rx_nr_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
+		   ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
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
 
@@ -4894,24 +4937,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 
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
@@ -4923,9 +4951,9 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
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
@@ -4933,31 +4961,18 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
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
@@ -8252,6 +8267,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
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

