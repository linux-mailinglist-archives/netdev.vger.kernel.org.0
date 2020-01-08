Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D36134F38
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgAHV7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:39 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgAHV7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:34 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f69a1799;
        Wed, 8 Jan 2020 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=N8hYQyQsfm2xzM3cDKHkrO1oJ
        SE=; b=TjFkpQ6cHma+t08R73u3CeJvOFSgvfdhnlUQd3Oo1H8SfLHUcrlgLmBBk
        0oUrlC5MNxxf20n+esgj1VTKd5RBreE6CbQJftqn0KJ6/Iot1Ac5h9cN2KGU5ow2
        034L5AOIyl9Exj5UK3RNCQ3sJMP/yJRqt1SX1vxIAQdae0GrPJZDfn/eN+OIbP+F
        sLkbkSPX349eV/u1dJgZmC/m0Bh4NCdCExM5M9dr6rdkEgv/5Z2IIK5/3pWmsDaY
        Q7qbPCr1Uvi/3NMgf4OZYWXTRNULslB3atG1jENDWHc+XLdTAGY06v3FN0lYtyKX
        ocfK1Df4PBuYqve4p+XRnsVmWaSKw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6238ef12 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 8/8] net: iwlwifi: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:09 -0500
Message-Id: <20200108215909.421487-9-Jason@zx2c4.com>
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
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index dc5c02fbc65a..6a241d37a057 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -847,10 +847,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 	else if (next)
 		consume_skb(skb);
 
-	while (next) {
-		tmp = next;
-		next = tmp->next;
-
+	skb_list_walk_safe(next, tmp, next) {
 		memcpy(tmp->cb, cb, sizeof(tmp->cb));
 		/*
 		 * Compute the length of all the data added for the A-MSDU.
@@ -880,9 +877,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 			skb_shinfo(tmp)->gso_size = 0;
 		}
 
-		tmp->prev = NULL;
-		tmp->next = NULL;
-
+		skb_mark_not_on_list(tmp);
 		__skb_queue_tail(mpdus_skb, tmp);
 		i++;
 	}
-- 
2.24.1

