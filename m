Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A622E949
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgG0JlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0JlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:21 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A39C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:21 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so8999867pjd.3
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G1GUxuzgb4Wc63vmvzCFKSCYZ3kP0SARS89j4q/pjnc=;
        b=UOgLVxfmh2IHyO3cQKl7QWvmKF1UIB6B0XU4sJnSpTPFNL1dFm5p4fzLGvWXVSyu8c
         MaV+fjU96WSPGveMtoeu4nC/o8w9APLh7mjaHfT6WnAk7rYSiQFJze/Lw/sFtnH3u1di
         wqdCDm1s8NOIWGwWbo7PzgJ9de7vU4JTviin4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G1GUxuzgb4Wc63vmvzCFKSCYZ3kP0SARS89j4q/pjnc=;
        b=sxzNILtPKnXzz8QgQ8qLY28R2kcNlQQGFiepw0Axj1v40OaUO0V9PnReFBNW7UC28d
         G20LMODblC+jBP3mkADZruUmcg3n3I5o/zt5MAF22dGkRtJnLVrCBVOM70rQuR6jKNy9
         YkU7n/rrpkGNI6VnKrEa0Z83YvZ0NULvnMBGbGcR3YAENuYOIcky9oHsAUgHb8ZYfgvE
         Cb0Wyw13mOfLSfVk6qjvFiqrK1jTilpQN6QAyJFXGMq83P5kU6JvLmqDcLfIKh1uVDQI
         WDzbfHZPZ0l//o9c5XXwefafNexaHMZyMEt4BnolqeKCKfqctCsfJ3zIE9DgjP7RiZEy
         tc+w==
X-Gm-Message-State: AOAM531hFZduHt2PZhw0JUCMKVT0a+qtBEfQWabv4QJCRILOKfOMtFBr
        BDUibB1RYRo+Rj5kdSLstiV7SlsE4Fs=
X-Google-Smtp-Source: ABdhPJzbHH+ytPa5VgEyv3Ws6DPF2u9QG7bsjB4yuBZYVhlo0krlZQOr4I4sLkyc2aOXMzpV43tysA==
X-Received: by 2002:a17:902:be0b:: with SMTP id r11mr4996222pls.114.1595842880642;
        Mon, 27 Jul 2020 02:41:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 05/10] bnxt_en: Allocate additional memory for all statistics blocks.
Date:   Mon, 27 Jul 2020 05:40:40 -0400
Message-Id: <1595842845-19403-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of these DMAed hardware counters are not full 64-bit counters and
so we need to accumulate them as they overflow.  Allocate copies of these
DMA statistics memory blocks with the same size for accumulation.  The
hardware counter widths are also counter specific so we allocate
memory for masks that correspond to each counter.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 ++++++++++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 ++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d232618..33dcb98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3705,6 +3705,10 @@ static int bnxt_alloc_hwrm_short_cmd_req(struct bnxt *bp)
 
 static void bnxt_free_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
 {
+	kfree(stats->hw_masks);
+	stats->hw_masks = NULL;
+	kfree(stats->sw_stats);
+	stats->sw_stats = NULL;
 	if (stats->hw_stats) {
 		dma_free_coherent(&bp->pdev->dev, stats->len, stats->hw_stats,
 				  stats->hw_stats_map);
@@ -3712,7 +3716,8 @@ static void bnxt_free_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
 	}
 }
 
-static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
+static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats,
+				bool alloc_masks)
 {
 	stats->hw_stats = dma_alloc_coherent(&bp->pdev->dev, stats->len,
 					     &stats->hw_stats_map, GFP_KERNEL);
@@ -3720,7 +3725,21 @@ static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
 		return -ENOMEM;
 
 	memset(stats->hw_stats, 0, stats->len);
+
+	stats->sw_stats = kzalloc(stats->len, GFP_KERNEL);
+	if (!stats->sw_stats)
+		goto stats_mem_err;
+
+	if (alloc_masks) {
+		stats->hw_masks = kzalloc(stats->len, GFP_KERNEL);
+		if (!stats->hw_masks)
+			goto stats_mem_err;
+	}
 	return 0;
+
+stats_mem_err:
+	bnxt_free_stats_mem(bp, stats);
+	return -ENOMEM;
 }
 
 static void bnxt_free_port_stats(struct bnxt *bp)
@@ -3760,7 +3779,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 
 		cpr->stats.len = size;
-		rc = bnxt_alloc_stats_mem(bp, &cpr->stats);
+		rc = bnxt_alloc_stats_mem(bp, &cpr->stats, !i);
 		if (rc)
 			return rc;
 
@@ -3774,7 +3793,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		goto alloc_ext_stats;
 
 	bp->port_stats.len = BNXT_PORT_STATS_SIZE;
-	rc = bnxt_alloc_stats_mem(bp, &bp->port_stats);
+	rc = bnxt_alloc_stats_mem(bp, &bp->port_stats, true);
 	if (rc)
 		return rc;
 
@@ -3790,7 +3809,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		goto alloc_tx_ext_stats;
 
 	bp->rx_port_stats_ext.len = sizeof(struct rx_port_stats_ext);
-	rc = bnxt_alloc_stats_mem(bp, &bp->rx_port_stats_ext);
+	rc = bnxt_alloc_stats_mem(bp, &bp->rx_port_stats_ext, true);
 	/* Extended stats are optional */
 	if (rc)
 		return 0;
@@ -3802,7 +3821,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	if (bp->hwrm_spec_code >= 0x10902 ||
 	    (bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED)) {
 		bp->tx_port_stats_ext.len = sizeof(struct tx_port_stats_ext);
-		rc = bnxt_alloc_stats_mem(bp, &bp->tx_port_stats_ext);
+		rc = bnxt_alloc_stats_mem(bp, &bp->tx_port_stats_ext, true);
 		/* Extended stats are optional */
 		if (rc)
 			return 0;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 7e9fe1f..69672ec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -920,6 +920,8 @@ struct bnxt_sw_stats {
 };
 
 struct bnxt_stats_mem {
+	u64		*sw_stats;
+	u64		*hw_masks;
 	void		*hw_stats;
 	dma_addr_t	hw_stats_map;
 	int		len;
-- 
1.8.3.1

