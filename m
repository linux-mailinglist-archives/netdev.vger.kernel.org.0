Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669D521C6DE
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 02:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgGLAtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 20:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGLAtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 20:49:03 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C0C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:49:03 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d4so4383515pgk.4
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BYAcNbqomnLFwA+FOyL5j2aMBZflPQaTZWKnNjVgt7A=;
        b=GWJhfLvYFgpWldS65Z2+YzC34867Goxs/9O9+iGl5e9RGdfHV0HCorJvnlzUsCZwGQ
         lMfoWHX4qsWj1ED8EA8M32gJlAziEHuqsQIUcWUlVrE5bgNXHVuFgD1uZh0WsKW9HlSa
         NMJQCoovvoZIlb/sWSi2vSPIgrH124QeE1JnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BYAcNbqomnLFwA+FOyL5j2aMBZflPQaTZWKnNjVgt7A=;
        b=g26gfWIGtLqkCxHD6F5tylpVGBUz/ba3mD5F7q27QscBM7gGEUaTrXj9okpq4ooBmg
         JVp1wp01+XXRJTfM6xS5Ea0RqjuesU7tNNChSGuGXbmxHACXHdDvNjehS0vjqRyopy3E
         kwX4w74MGbxgE04fNcw+Cl2XXzWMwXsvDAISS99SgRLjStHiSYDysweRcE11js5c+L4H
         M+5+at1+cZEF0gK54BBV2vp79NymExdBQh8nquhOvlN+fuN51YR2THyIF7PVrPM8sGkZ
         6r7XZrtvCBqW7YCwj3yoG+XHmWZiceWgsXBl3VNa1kCCOYwhSCpFFKwQYNpwZxdliNFL
         3rmg==
X-Gm-Message-State: AOAM530EjzRk31oP0Pnaia+YcIAx3wM/ka69GHV6JlzXf87rvJyXtWUl
        EGKdhThnbhRFfGB2GBkUBGkIEQ==
X-Google-Smtp-Source: ABdhPJy9LT9OEsQRn4emZYagizEEoEL2apKuBH1Z2+BxlpYPA5bgEYpHw5Wf5uJs6i6e9LKByjAHsA==
X-Received: by 2002:a63:ea02:: with SMTP id c2mr63996156pgi.66.1594514943358;
        Sat, 11 Jul 2020 17:49:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q6sm10157589pfg.76.2020.07.11.17.49.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jul 2020 17:49:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] bnxt_en: Fix completion ring sizing with TPA enabled.
Date:   Sat, 11 Jul 2020 20:48:25 -0400
Message-Id: <1594514905-688-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
References: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current completion ring sizing formula is wrong with TPA enabled.
The formula assumes that the number of TPA completions are bound by the
RX ring size, but that's not true.  TPA_START completions are immediately
recycled so they are not bound by the RX ring size.  We must add
bp->max_tpa to the worst case maximum RX and TPA completions.

The completion ring can overflow because of this mistake.  This will
cause hardware to disable the completion ring when this happens,
leading to RX and TX traffic to stall on that ring.  This issue is
generally exposed only when the RX ring size is set very small.

Fix the formula by adding bp->max_tpa to the number of RX completions
if TPA is enabled.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.");
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 28147e4..7463a18 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3418,7 +3418,7 @@ void bnxt_set_tpa_flags(struct bnxt *bp)
  */
 void bnxt_set_ring_params(struct bnxt *bp)
 {
-	u32 ring_size, rx_size, rx_space;
+	u32 ring_size, rx_size, rx_space, max_rx_cmpl;
 	u32 agg_factor = 0, agg_ring_size = 0;
 
 	/* 8 for CRC and VLAN */
@@ -3474,7 +3474,15 @@ void bnxt_set_ring_params(struct bnxt *bp)
 	bp->tx_nr_pages = bnxt_calc_nr_ring_pages(ring_size, TX_DESC_CNT);
 	bp->tx_ring_mask = (bp->tx_nr_pages * TX_DESC_CNT) - 1;
 
-	ring_size = bp->rx_ring_size * (2 + agg_factor) + bp->tx_ring_size;
+	max_rx_cmpl = bp->rx_ring_size;
+	/* MAX TPA needs to be added because TPA_START completions are
+	 * immediately recycled, so the TPA completions are not bound by
+	 * the RX ring size.
+	 */
+	if (bp->flags & BNXT_FLAG_TPA)
+		max_rx_cmpl += bp->max_tpa;
+	/* RX and TPA completions are 32-byte, all others are 16-byte */
+	ring_size = max_rx_cmpl * 2 + agg_ring_size + bp->tx_ring_size;
 	bp->cp_ring_size = ring_size;
 
 	bp->cp_nr_pages = bnxt_calc_nr_ring_pages(ring_size, CP_DESC_CNT);
-- 
1.8.3.1

