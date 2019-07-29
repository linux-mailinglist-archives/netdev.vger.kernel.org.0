Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9078951
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfG2KL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:27 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42309 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbfG2KLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:25 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so27361469plb.9
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vCDA1OndQh65P6AQRPQsMz2TvKV5p4prVWxUam+jogg=;
        b=B3YoMljWVw/MxPYvG141f3IKGYh+1q5iRaTcpzVTN+BM+eMt+77NaAJFuDFXJzSCOn
         WxI4K/LmUndWdqNlf84dLAHnsN2O//oiucpuMS6k+x5P33JS/qa6cA/n/L5t39gEPwmH
         8pGGlHmJfio0YVwu78a/vpS8bUv4gHkD8ey04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vCDA1OndQh65P6AQRPQsMz2TvKV5p4prVWxUam+jogg=;
        b=in+uhepC+ZMhODa93O0PqdKA0LuArx/sR3yxdQOqZzcDi7E2vGe3t9dHKFIQUU+ZbT
         JQulz2diELaJgrZ1kf+y0dRlYW0aHu1+uBpM+yydzed+kRz6Ck6C+R5vDYstyTXZ7JT8
         PaK9t03jvNa8OSTpbfkU015qdCu1LcMhGeMCK01aLudMlNfLel/EaBrKzc3UZjxWQx4A
         6GccgUIhdSXCiLRz6VQAxA9BwybHe0tSyIeEQyT4IyRj7LaGBO94x416lG2tHC76Aveb
         CoEeYXE+kmaQujb0skS3rhp1D4cK9pzR4ZHgEHKgM6YrwdNJN1Aw6+Qzot4lFO1+75i0
         HLxQ==
X-Gm-Message-State: APjAAAXac4T2nEqsG3U8Gh8l9sGso4RXS7q1nGeg9VoeszwhUNgzjPuT
        5T4o7nmB/T7ko8Q51/0ebdkJtdxgXn4=
X-Google-Smtp-Source: APXvYqxBbbKpNclY64UrLh1a4bnm5vLgjyJyfZa1h94s1/GqaseAVqzCJsxdaYmef3rj3/n6e4xJXw==
X-Received: by 2002:a17:902:2ac8:: with SMTP id j66mr104352343plb.273.1564395084390;
        Mon, 29 Jul 2019 03:11:24 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 12/16] bnxt_en: Allocate the larger per-ring statistics block for 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:29 -0400
Message-Id: <1564395033-19511-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new TPA implemantation has additional TPA counters that extend the
per-ring statistics block.  Allocate the proper size accordingly.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 36b58df..38ac007 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3635,7 +3635,7 @@ static void bnxt_free_ring_stats(struct bnxt *bp)
 	if (!bp->bnapi)
 		return;
 
-	size = sizeof(struct ctx_hw_stats);
+	size = bp->hw_ring_stats_size;
 
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
@@ -3654,7 +3654,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	u32 size, i;
 	struct pci_dev *pdev = bp->pdev;
 
-	size = sizeof(struct ctx_hw_stats);
+	size = bp->hw_ring_stats_size;
 
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
@@ -4989,6 +4989,11 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		    VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP)
 			bp->flags |= BNXT_FLAG_ROCE_MIRROR_CAP;
 		bp->max_tpa_v2 = le16_to_cpu(resp->max_aggs_supported);
+		if (bp->max_tpa_v2)
+			bp->hw_ring_stats_size =
+				sizeof(struct ctx_hw_stats_ext);
+		else
+			bp->hw_ring_stats_size = sizeof(struct ctx_hw_stats);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
@@ -6186,6 +6191,7 @@ static int bnxt_hwrm_stat_ctx_alloc(struct bnxt *bp)
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_STAT_CTX_ALLOC, -1, -1);
 
+	req.stats_dma_length = cpu_to_le16(bp->hw_ring_stats_size);
 	req.update_period_ms = cpu_to_le32(bp->stats_coal_ticks / 1000);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 309cf99..6c710d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1607,6 +1607,7 @@ struct bnxt {
 	int			hw_port_stats_size;
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
+	u16			hw_ring_stats_size;
 	u8			pri2cos[8];
 	u8			pri2cos_valid;
 
-- 
2.5.1

