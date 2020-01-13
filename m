Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8A6139D97
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgAMXnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:43:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55249 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgAMXnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:43:01 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 07fa34b0;
        Mon, 13 Jan 2020 22:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=tVnUNJOazYgFVI3CzDvPdFfXT
        4k=; b=1gUoaCqfSH21UP/T8H/kYla/uDGgR0lTivlFsn7eMNDOckIQ5N/kap+uL
        zAY/pw3ciwvkWMRssvpm3vXbFhQXTpaRleyAVVmiTccPiBM4aY/WCXvqBhIACqfi
        MRpmnObjEAMFqdjr6hl/bzfjCfmmDrQ1xAlPLo1dXTFG0bfjcYi+frldDIwMqhom
        NJ7ztHliOu1COE6M5VW3dSGu2TL2/FaiofXAffw8FCfSNNq/94fgDmWGqR8+2fA7
        PrZen+s7WI2Kj9VV2mrIEL7JHnwKweeQxnfYPoL4L62+E4m4LFmM5UbICf2bj3vc
        CfkIr9nFBDXdzci2X2PWJm4Ouc0qg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d65a9e72 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:43:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 8/8] net: mac80211: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:33 -0500
Message-Id: <20200113234233.33886-9-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a conversion case for the new function, keeping the flow of the
existing code as intact as possible. We also switch over to using
skb_mark_not_on_list instead of a null write to skb->next.

Finally, this code appeared to have a memory leak in the case where
header building fails before the last gso segment. In that case, the
remaining segments are not freed. So this commit also adds the proper
kfree_skb_list call for the remainder of the skbs.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/mac80211/tx.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a8a7306a1f56..4bd1faf4f779 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3949,18 +3949,15 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 	}
 
-	next = skb;
-	while (next) {
-		skb = next;
-		next = skb->next;
-
-		skb->prev = NULL;
-		skb->next = NULL;
+	skb_list_walk_safe(skb, skb, next) {
+		skb_mark_not_on_list(skb);
 
 		skb = ieee80211_build_hdr(sdata, skb, info_flags,
 					  sta, ctrl_flags);
-		if (IS_ERR(skb))
+		if (IS_ERR(skb)) {
+			kfree_skb_list(next);
 			goto out;
+		}
 
 		ieee80211_tx_stats(dev, skb->len);
 
-- 
2.24.1

