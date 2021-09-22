Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F18414308
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhIVH6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhIVH6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:19 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37429C061574;
        Wed, 22 Sep 2021 00:56:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w29so4057380wra.8;
        Wed, 22 Sep 2021 00:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aYY93TLMcBSAyVY5AhUUIXk9y2G1cIIvKCD5QoFrSJM=;
        b=KJ8cxFmqcyxZz3hTebLLKKRGXjsCaAG0fmjw+PM5rvykQeym12H14NLzfBwbULeEMW
         4bODH8uvkgZCvSI4gCeGLNxFksppdclIOXkMtGCJclBVoWn8aUJVsbBqy+0vGsqNBqhP
         S4ZjuBqqoDbLHlRmbhqfit0bg/V+beVC4xc5uEW1sOhLPkTbFNm1nRCCdezKciNokRfp
         VQAL2A3frVmjtB0IWh0AkJWd6G0f4kS/wntRw9uc1V+BkS4bm/tibSEGTTnzmfZnXNlJ
         MewPqrSL8N4pnK+l7jOWDwHhu5P4GGmdl5Dp84VxRU17rCAwgoBPD27ZpI2mhj9Ih6j1
         GoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aYY93TLMcBSAyVY5AhUUIXk9y2G1cIIvKCD5QoFrSJM=;
        b=fOLTIFLEMN1+UTE4OReuou/Ei6PRHN96hNU+xpgUbTpbMwfZH6fQPMJzb0XGrvld7d
         HfU4Tr1dhOvRdd4qD09vv6nsedXDVWBlwcvEPC7ysf1d2Aetdv3DfENjpJSAeHgFiaVL
         hXRz2LFHs5vpAeNsPX0dXXVEJPSFcKhw76coUM0qRPbgtBUV2goaQ6WnGbtPbs4bFaXH
         Oilcb/vpzTkvRg51VktJESEXDEpONnYwRe1MttpjWqHTdKnc1urBt6b8XhA/sLAqa4zX
         QLjC8dkT87/I2PR+QDScOGfCYw24qpA3vI5yYYzlL62rZ6RcbIM+WtGl73731ieAbX6h
         ZxOQ==
X-Gm-Message-State: AOAM531qQoV+fVst/4k5T8BqrJARy8Mz9wrYZctBXHygBpkR0vNXwwtC
        yU/NuRwrcjZCFO2slZmRl20XxzjAxupEMX0+
X-Google-Smtp-Source: ABdhPJy8BnAu69nYxy5rJUc5NGRZhnIp94JkSF2phstaFBo4tYca3lFVP4y1TDNSCtAT4fxyCtPTCw==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr8873856wml.80.1632297408770;
        Wed, 22 Sep 2021 00:56:48 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:48 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 05/13] i40e: use the xsk batched rx allocation interface
Date:   Wed, 22 Sep 2021 09:56:05 +0200
Message-Id: <20210922075613.12186-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Use the new xsk batched rx allocation interface for the zero-copy data
path. As the array of struct xdp_buff pointers kept by the driver is
really a ring that wraps, the allocation routine is modified to detect
a wrap and in that case call the allocation function twice. The
allocation function cannot deal with wrapped rings, only arrays. As we
now know exactly how many buffers we get and that there is no
wrapping, the allocation function can be simplified even more as all
if-statements in the allocation loop can be removed, improving
performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 52 +++++++++++-----------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index e7e778ca074c..6f85879ba993 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -193,42 +193,40 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 {
 	u16 ntu = rx_ring->next_to_use;
 	union i40e_rx_desc *rx_desc;
-	struct xdp_buff **bi, *xdp;
+	struct xdp_buff **xdp;
+	u32 nb_buffs, i;
 	dma_addr_t dma;
-	bool ok = true;
 
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
-	bi = i40e_rx_bi(rx_ring, ntu);
-	do {
-		xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!xdp) {
-			ok = false;
-			goto no_buffers;
-		}
-		*bi = xdp;
-		dma = xsk_buff_xdp_get_dma(xdp);
+	xdp = i40e_rx_bi(rx_ring, ntu);
+
+	nb_buffs = min_t(u16, count, rx_ring->count - ntu);
+	nb_buffs = xsk_buff_alloc_batch(rx_ring->xsk_pool, xdp, nb_buffs);
+	if (!nb_buffs)
+		return false;
+
+	i = nb_buffs;
+	while (i--) {
+		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->read.hdr_addr = 0;
 
 		rx_desc++;
-		bi++;
-		ntu++;
-
-		if (unlikely(ntu == rx_ring->count)) {
-			rx_desc = I40E_RX_DESC(rx_ring, 0);
-			bi = i40e_rx_bi(rx_ring, 0);
-			ntu = 0;
-		}
-	} while (--count);
+		xdp++;
+	}
 
-no_buffers:
-	if (rx_ring->next_to_use != ntu) {
-		/* clear the status bits for the next_to_use descriptor */
-		rx_desc->wb.qword1.status_error_len = 0;
-		i40e_release_rx_desc(rx_ring, ntu);
+	ntu += nb_buffs;
+	if (ntu == rx_ring->count) {
+		rx_desc = I40E_RX_DESC(rx_ring, 0);
+		xdp = i40e_rx_bi(rx_ring, 0);
+		ntu = 0;
 	}
 
-	return ok;
+	/* clear the status bits for the next_to_use descriptor */
+	rx_desc->wb.qword1.status_error_len = 0;
+	i40e_release_rx_desc(rx_ring, ntu);
+
+	return count == nb_buffs ? true : false;
 }
 
 /**
@@ -365,7 +363,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			break;
 
 		bi = *i40e_rx_bi(rx_ring, next_to_clean);
-		bi->data_end = bi->data + size;
+		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
 		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
-- 
2.29.0

