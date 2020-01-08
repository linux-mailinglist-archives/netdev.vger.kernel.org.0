Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C8C134F34
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgAHV7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:31 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgAHV73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:29 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 05df009f;
        Wed, 8 Jan 2020 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=B0BVih7yJ2iX3/QXlOUv4EwSD
        pY=; b=bUDm7Iu33+i5q6XZRxiIP1JN15D034AJAM0TXG4UkZORYxA85A3kMuKCD
        /aa1sqK4C+IO84m07w7kjovVzguLR7ox3a6PAxFvsQBnqAJ/R8lKH9rtb/yVz1k0
        5kq1/FgYmaUqe0pR/WzYqLIkZTF0Ho1EGI/ElTjMYtdyTiR9na8GWKNqGS25lw2M
        4sYHS41YlEUzn7/S/d78x4DPKrK4kA4zDW4/QAJSOa0H7Epa0OVrcpF4VX07dIg6
        n2G7h3gRuoIKZIgNU0dTMeYPhFY0zD3gqs8e/tApXo6z3Y62335GcTOf7/cOk2re
        t+YNcmBmB9hqz7w3TgYpg1+fMyb8Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8cceac7f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6/8] net: sfc: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:07 -0500
Message-Id: <20200108215909.421487-7-Jason@zx2c4.com>
In-Reply-To: <20200108215909.421487-1-Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, and
while we're at it, we can remove a null write to skb->next by replacing
it with skb_mark_not_on_list.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/ethernet/sfc/tx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 00c1c4402451..547692b33b4d 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -473,12 +473,9 @@ static int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue,
 	dev_consume_skb_any(skb);
 	skb = segments;
 
-	while (skb) {
-		next = skb->next;
-		skb->next = NULL;
-
+	skb_list_walk_safe(skb, skb, next) {
+		skb_mark_not_on_list(skb);
 		efx_enqueue_skb(tx_queue, skb);
-		skb = next;
 	}
 
 	return 0;
-- 
2.24.1

