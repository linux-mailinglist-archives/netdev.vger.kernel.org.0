Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C463720E12A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbgF2Uwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731345AbgF2TNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA44C08EB29
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv18so2812092pjb.1
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mbaAvhTszPEEGed4ZM7nlK7TgYl4Wm8m3zbiOcYdKlw=;
        b=cSq5LDjg+maw3kRXBA6Bya3ktmWL4+EGzYQbnVpEr/gTjbI+D6JXQLfpjMjRWZpFQK
         OJmD/xy5ruyFOTxKXVnryQMQKr87x6Yp+HB0OsM4TBhTfl33+1Jl2iz0rSNSnP0rp3Ro
         6M+O4Sutt6mM5s8asvb+k8dQ+sfCu9WLOot2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mbaAvhTszPEEGed4ZM7nlK7TgYl4Wm8m3zbiOcYdKlw=;
        b=owejYPXdzuk62P4C67DIgjRb013xq3AkykbNH5i8daEfs76JmH2TgJdYMSd9GGk8T4
         k8ZcWi4JFyF07l47q6Bqzmh55ebuGpV87CHNojnJZCBpx35cq0qbYpuER9V0PRJoe1YA
         o6ksDtsbEByNDTjjIhEiJa7XxLlURPI3XQbLLj/N9JtpMd3U6r+sHeP0lW3yntH8VMuB
         UI3wdFZdtmzBR/OXtBxolmi2oqcAZ7qTXkvnX2ChMJDENPJLkSf+m0LMIRUjkpx7smH7
         BN6groHQpP7BlL8rMpbKSIMUN454+zpI610LOONghZGC9zrcKviJGxca9rKdCuFWk1JW
         gKTQ==
X-Gm-Message-State: AOAM533cv6A5Ca4k8APfnegV5LUbF2vYdUziFJscioCkdZqnEenSXqhb
        FRMYsBJfI991zPHXvgs4hKMgfM4p8p8=
X-Google-Smtp-Source: ABdhPJzmi8DI5Fobv7wLyoG5u79ozNaXQP4hY4zLHmNLlbO0oetwZR8TJPO5NsysqR6wFFd5LamhVw==
X-Received: by 2002:a17:90a:6448:: with SMTP id y8mr16240479pjm.142.1593412493365;
        Sun, 28 Jun 2020 23:34:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/8] bnxt_en: Add helper function to return the number of RSS contexts.
Date:   Mon, 29 Jun 2020 02:34:19 -0400
Message-Id: <1593412464-503-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some chips, this varies based on the number of RX rings.  Add this
helper function and refactor the existing code to use it.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 924bbcc..7bf843d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4873,6 +4873,15 @@ static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
 		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
 }
 
+int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
+{
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return DIV_ROUND_UP(rx_rings, BNXT_RSS_TABLE_ENTRIES_P5);
+	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
+		return 2;
+	return 1;
+}
+
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
 	u32 i, j, max_rings;
@@ -4928,7 +4937,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	req.hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
 	req.ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 	req.hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
-	nr_ctxs = DIV_ROUND_UP(bp->rx_nr_rings, 64);
+	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 	for (i = 0, k = 0; i < nr_ctxs; i++) {
 		__le16 *ring_tbl = vnic->rss_table;
 		int rc;
@@ -7681,7 +7690,7 @@ static int __bnxt_setup_vnic_p5(struct bnxt *bp, u16 vnic_id)
 {
 	int rc, i, nr_ctxs;
 
-	nr_ctxs = DIV_ROUND_UP(bp->rx_nr_rings, 64);
+	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 	for (i = 0; i < nr_ctxs; i++) {
 		rc = bnxt_hwrm_vnic_ctx_alloc(bp, vnic_id, i);
 		if (rc) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6de2813..5890913 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2039,6 +2039,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 int hwrm_send_message_silent(struct bnxt *, void *, u32, int);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 			    int bmap_size, bool async_only);
+int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings);
 int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id);
 int __bnxt_hwrm_get_tx_rings(struct bnxt *bp, u16 fid, int *tx_rings);
 int bnxt_nq_rings_in_use(struct bnxt *bp);
-- 
1.8.3.1

