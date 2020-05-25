Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108571E173E
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgEYVln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgEYVln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:41:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5C2C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u5so9096560pgn.5
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mwvn1MGpNNeTQh8ZLjxcw6uqSkVYHvjS1zbacHwaWOY=;
        b=CWIs5cvm5aD7RLHEG9IrmtXWL+qWZYmeTpHrg9zC1HDvOyCbBM3KSsmPfYVwkIkt6P
         /tM269KPPMTy+47Ie5l/awV21J/ijn38S597ttdGiCFEpzLFW7hHh3drOZcet1OXTbsh
         oUvbmQ3/LbyVLrBdgNXrjwmAaHi2yKITKhRWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mwvn1MGpNNeTQh8ZLjxcw6uqSkVYHvjS1zbacHwaWOY=;
        b=D3p0aUDIdDCinhr6EEQginRR1OCEsOZ6OoKqn/KgYYnDb10bYg7FqlwQ41Ov9vnPub
         PsxvVYMAIIcdTSAR6px0AUo9UWxNgAIcHzJkg3HDdCm0Wu0kRbosdLjOYaKCOI0J7Q4t
         cI1XcvwR37kQft3MNKWOTgrB7fWj0QzA5b7sF5ACccSwH/CUNaNsKR0netvGqLRPn5Rk
         Q++uq/1fiAvQBI6ABGi9d1wsswKKuJPo8OUF8/V73/2Q3ybmKBXr9iQx5IpikOO6Xogf
         hoLiGuClY+Oy4BR6bJe9LRhhr6zBHApDNA8W/L7ZSBqg22D3aaZKDNScSKxctyRHY862
         LeyQ==
X-Gm-Message-State: AOAM530oL/Qlxxp4OovOAVmLm5DW1vNTF2Zy9wkjIok8UwqVrxQVUjRt
        M5WXXJbSjUzL6m3UT3o2K6Au6w==
X-Google-Smtp-Source: ABdhPJz8KmaM68A+3e0YtgPXwnZ9nv1a8XC9NiRd5XwuPVSoH0Z8uMvD+IJQd0k2VFL0tkZl9lUDRg==
X-Received: by 2002:a62:5bc1:: with SMTP id p184mr2753833pfb.73.1590442902197;
        Mon, 25 May 2020 14:41:42 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g1sm13309401pfo.142.2020.05.25.14.41.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 May 2020 14:41:41 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/3] bnxt_en: Fix accumulation of bp->net_stats_prev.
Date:   Mon, 25 May 2020 17:41:17 -0400
Message-Id: <1590442879-18961-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have logic to maintain network counters across resets by storing
the counters in bp->net_stats_prev before reset.  But not all resets
will clear the counters.  Certain resets that don't need to change
the number of rings do not clear the counters.  The current logic
accumulates the counters before all resets, causing big jumps in
the counters after some resets, such as ethtool -G.

Fix it by only accumulating the counters during reset if the irq_re_init
parameter is set.  The parameter signifies that all rings and interrupts
will be reset and that means that the counters will also be reset.

Reported-by: Vijayendra Suman <vijayendra.suman@oracle.com>
Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d1a8371..abb203c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9310,7 +9310,7 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
-	if (bp->bnapi)
+	if (bp->bnapi && irq_re_init)
 		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
 	if (irq_re_init) {
 		bnxt_free_irq(bp);
-- 
2.5.1

