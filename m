Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7189222E94C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgG0Jl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0Jl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25D1C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s189so9162870pgc.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MAi3Am317LeCluIV6Rdu6mwDRg8tdVZte/EbywqhOFc=;
        b=dEW59IgyIG9kkUNdMokrSgBJ/IkDQbDXDneKLyxNFqfh0cMF9BNZ6E9xa1rujCbd4i
         mbdLB/yB7jL9+xp/HSs1CbgQsb09sMalfLyRRsrxtRRSbVUao1BThrYq1KTETQWxyDHO
         i7EUNDAjoKmuCsXnftof7WyNK6nWgNkrvyC6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MAi3Am317LeCluIV6Rdu6mwDRg8tdVZte/EbywqhOFc=;
        b=RUJ7NfXqiC//01pdbRui33Mvi/BMiTmhCtaLpnyxV1Dtz0Dsbo/baMF3JV2i6epUqt
         I2OWpC6MLdpDNWZsekN+yLPzPxIYqR/ActSx7wH/Xfe9mmx5zk0sDRK1nsmCH5rsrqzI
         i0VFNBZpqJrtGvnJNyGRewGPstcm42AxpoFAFHs8IhWUdh1ZmkqlUl1h/GGXXZ+r37vD
         k0UIVG4zpskcbQRtvHh1cklkBTgWXd+czXwBGVeZK6rLRU9aSGa+jaAkwHDURtMzcE8R
         A/pMEYA3pNLOcgoUwymFHPKos3Un6m/rpdJG5Wwbi+XoVeDF1qBAVAVAIaJUd/74eyN5
         dFPA==
X-Gm-Message-State: AOAM531o9fCnnG1HJdFNbVnnaj7MrPYYrdH0ZLpyYWlDgUlN78sYyvyk
        8IzjyrYSid+zP2kOX8mmmgM5JKdx1YA=
X-Google-Smtp-Source: ABdhPJy4irUKS6qe5ow2SKzVE//xmlbROF3p0EZe3f0lJWpUDunpyGDpLYzoXhrXCyhPIiTJnpWHqQ==
X-Received: by 2002:a05:6a00:7ca:: with SMTP id n10mr8271148pfu.129.1595842886229;
        Mon, 27 Jul 2020 02:41:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 07/10] bnxt_en: Retrieve hardware masks for port counters.
Date:   Mon, 27 Jul 2020 05:40:42 -0400
Message-Id: <1595842845-19403-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If supported by newer firmware, make the firmware call to query all
the port counter masks.  If not supported, assume 40-bit port
counter masks.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 75 ++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 65d503f..b79d8e9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3785,13 +3785,19 @@ static int bnxt_hwrm_func_qstat_ext(struct bnxt *bp,
 	return rc;
 }
 
+static int bnxt_hwrm_port_qstats(struct bnxt *bp, u8 flags);
+static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp, u8 flags);
+
 static void bnxt_init_stats(struct bnxt *bp)
 {
 	struct bnxt_napi *bnapi = bp->bnapi[0];
 	struct bnxt_cp_ring_info *cpr;
 	struct bnxt_stats_mem *stats;
+	__le64 *rx_stats, *tx_stats;
+	int rc, rx_count, tx_count;
+	u64 *rx_masks, *tx_masks;
 	u64 mask;
-	int rc;
+	u8 flags;
 
 	cpr = &bnapi->cp_ring;
 	stats = &cpr->stats;
@@ -3803,6 +3809,54 @@ static void bnxt_init_stats(struct bnxt *bp)
 			mask = -1ULL;
 		bnxt_fill_masks(stats->hw_masks, mask, stats->len / 8);
 	}
+	if (bp->flags & BNXT_FLAG_PORT_STATS) {
+		stats = &bp->port_stats;
+		rx_stats = stats->hw_stats;
+		rx_masks = stats->hw_masks;
+		rx_count = sizeof(struct rx_port_stats) / 8;
+		tx_stats = rx_stats + BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+		tx_masks = rx_masks + BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+		tx_count = sizeof(struct tx_port_stats) / 8;
+
+		flags = PORT_QSTATS_REQ_FLAGS_COUNTER_MASK;
+		rc = bnxt_hwrm_port_qstats(bp, flags);
+		if (rc) {
+			mask = (1ULL << 40) - 1;
+
+			bnxt_fill_masks(rx_masks, mask, rx_count);
+			bnxt_fill_masks(tx_masks, mask, tx_count);
+		} else {
+			bnxt_copy_hw_masks(rx_masks, rx_stats, rx_count);
+			bnxt_copy_hw_masks(tx_masks, tx_stats, tx_count);
+			bnxt_hwrm_port_qstats(bp, 0);
+		}
+	}
+	if (bp->flags & BNXT_FLAG_PORT_STATS_EXT) {
+		stats = &bp->rx_port_stats_ext;
+		rx_stats = stats->hw_stats;
+		rx_masks = stats->hw_masks;
+		rx_count = sizeof(struct rx_port_stats_ext) / 8;
+		stats = &bp->tx_port_stats_ext;
+		tx_stats = stats->hw_stats;
+		tx_masks = stats->hw_masks;
+		tx_count = sizeof(struct tx_port_stats_ext) / 8;
+
+		flags = FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK;
+		rc = bnxt_hwrm_port_qstats_ext(bp, flags);
+		if (rc) {
+			mask = (1ULL << 40) - 1;
+
+			bnxt_fill_masks(rx_masks, mask, rx_count);
+			if (tx_stats)
+				bnxt_fill_masks(tx_masks, mask, tx_count);
+		} else {
+			bnxt_copy_hw_masks(rx_masks, rx_stats, rx_count);
+			if (tx_stats)
+				bnxt_copy_hw_masks(tx_masks, tx_stats,
+						   tx_count);
+			bnxt_hwrm_port_qstats_ext(bp, 0);
+		}
+	}
 }
 
 static void bnxt_free_port_stats(struct bnxt *bp)
@@ -7530,7 +7584,7 @@ int bnxt_hwrm_fw_set_time(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
-static int bnxt_hwrm_port_qstats(struct bnxt *bp)
+static int bnxt_hwrm_port_qstats(struct bnxt *bp, u8 flags)
 {
 	struct bnxt_pf_info *pf = &bp->pf;
 	struct hwrm_port_qstats_input req = {0};
@@ -7538,6 +7592,10 @@ static int bnxt_hwrm_port_qstats(struct bnxt *bp)
 	if (!(bp->flags & BNXT_FLAG_PORT_STATS))
 		return 0;
 
+	if (flags && !(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED))
+		return -EOPNOTSUPP;
+
+	req.flags = flags;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_QSTATS, -1, -1);
 	req.port_id = cpu_to_le16(pf->port_id);
 	req.tx_stat_host_addr = cpu_to_le64(bp->port_stats.hw_stats_map +
@@ -7546,7 +7604,7 @@ static int bnxt_hwrm_port_qstats(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
-static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
+static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp, u8 flags)
 {
 	struct hwrm_port_qstats_ext_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_queue_pri2cos_qcfg_input req2 = {0};
@@ -7558,7 +7616,11 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 	if (!(bp->flags & BNXT_FLAG_PORT_STATS_EXT))
 		return 0;
 
+	if (flags && !(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED))
+		return -EOPNOTSUPP;
+
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_QSTATS_EXT, -1, -1);
+	req.flags = flags;
 	req.port_id = cpu_to_le16(pf->port_id);
 	req.rx_stat_size = cpu_to_le16(sizeof(struct rx_port_stats_ext));
 	req.rx_stat_host_addr = cpu_to_le64(bp->rx_port_stats_ext.hw_stats_map);
@@ -7576,6 +7638,9 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 		bp->fw_rx_stats_ext_size = 0;
 		bp->fw_tx_stats_ext_size = 0;
 	}
+	if (flags)
+		goto qstats_done;
+
 	if (bp->fw_tx_stats_ext_size <=
 	    offsetof(struct tx_port_stats_ext, pfc_pri0_tx_duration_us) / 8) {
 		mutex_unlock(&bp->hwrm_cmd_lock);
@@ -10494,8 +10559,8 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_HWRM_EXEC_FWD_REQ_SP_EVENT, &bp->sp_event))
 		bnxt_hwrm_exec_fwd_req(bp);
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
-		bnxt_hwrm_port_qstats(bp);
-		bnxt_hwrm_port_qstats_ext(bp);
+		bnxt_hwrm_port_qstats(bp, 0);
+		bnxt_hwrm_port_qstats_ext(bp, 0);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
-- 
1.8.3.1

