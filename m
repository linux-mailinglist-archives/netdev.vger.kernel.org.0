Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5D22E474
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG0Daa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0Da3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41531C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so8615871pgq.1
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G1GUxuzgb4Wc63vmvzCFKSCYZ3kP0SARS89j4q/pjnc=;
        b=hFP+ewC33t7gFRM5U+OwjKsWdKVQIFJ6SdbCgirILCWsXdW0SbBfg44Hmncgtck82M
         X9F6gGoCT6eiPNQOtAilgqruc59TXMzBWKQhG7T85pRqrjqZ4cs5hvjrYy3fDWCB/jal
         rHahVLSGz7Q4vFmQb6HFtwEPbqbgJ7M4A0ymM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G1GUxuzgb4Wc63vmvzCFKSCYZ3kP0SARS89j4q/pjnc=;
        b=i8+q9pGhGTHeLdaijFezC5oPtFz8AaQZNO8X3X/b4eMG200kYv2nNK/tcvc2pdEHML
         WbZ1MqCsJL2F2uM00MLYlTaSMl9K0Zj37PcEB0ak9U/EnYkkWFziK6eBVUwy1Yvt/Xk1
         M+imKz9RhRuujyt1/dEor+RLPmbOMkuZBeeb9A8ZYEAf0/A5BUikZIdzsz8AESCFPmRa
         fe0nSQnH4ygc2s8VbxlyyrJwWTtlWn/QHMkE5Qj5Jbq25QnXTkKQ8/h1ppMsESZRv8gX
         0oTUJNZLbbav8hg6aIrOZ2lR8aTeubRRye5eAC7Swma1hMiACQFEYZ5TuRLvc6EMLnBh
         F5Ww==
X-Gm-Message-State: AOAM5307Xvpi8QCqlGtnjpBITcPFoyrFBm386MQ2bvjRxevga8NYKhvU
        bjjkcRV1iKV5X7YEbreW6ZL8vrk6f5o=
X-Google-Smtp-Source: ABdhPJyvsmP21HBhQ/newl6ihBlAt4M4VQLyjvs6JKT14F9joKoYnFy5/P4FSL00B9hauX1KnN5PoA==
X-Received: by 2002:a63:e00c:: with SMTP id e12mr18073768pgh.413.1595820628682;
        Sun, 26 Jul 2020 20:30:28 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:28 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/10] bnxt_en: Allocate additional memory for all statistics blocks.
Date:   Sun, 26 Jul 2020 23:29:41 -0400
Message-Id: <1595820586-2203-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
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

