Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0581F139D93
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAMXm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:42:57 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbgAMXmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a2974b3b;
        Mon, 13 Jan 2020 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=ZqXj0juaBipmcsv7BSxQNxYO0
        90=; b=oRE+EmwaN6ITMVkleZVKa22w4lLN0TxmqO23ZF7yQYnSkjqnWKTFR1jn6
        clyZ+97s82yGyzEZMefvXls4boNrlxvXHVVY7kGnw1dhApZ31/7K/v16KIaia8hx
        qJuDNnfEBy2ba76SeKBJkUChTmw89dj212Lm6r1iPItx7/D64Z311HMN8rjbnWFv
        mnfA1DBgN7Zc4sI9mc7yXYS1DvIxAEOOzFAn9WHMBD+05SVx2eecVXdgwMQNFA1M
        AQgIAQMEPTCOhYkGyAt2+Bch5awrTYz0XFvyABBqhf1MoN10STDPOF2WDL8COHVE
        r2auSK28JfRJbKLRvpmBDobf4mt8g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8f823dd8 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:55 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 4/8] net: openvswitch: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:29 -0500
Message-Id: <20200113234233.33886-5-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, keeping
the flow of the existing code as intact as possible.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/openvswitch/datapath.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index e3a37d22539c..659c2a790fe7 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -321,8 +321,7 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	}
 
 	/* Queue all of the segments. */
-	skb = segs;
-	do {
+	skb_list_walk_safe(segs, skb, nskb) {
 		if (gso_type & SKB_GSO_UDP && skb != segs)
 			key = &later_key;
 
@@ -330,17 +329,15 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 		if (err)
 			break;
 
-	} while ((skb = skb->next));
+	}
 
 	/* Free all of the segments. */
-	skb = segs;
-	do {
-		nskb = skb->next;
+	skb_list_walk_safe(segs, skb, nskb) {
 		if (err)
 			kfree_skb(skb);
 		else
 			consume_skb(skb);
-	} while ((skb = nskb));
+	}
 	return err;
 }
 
-- 
2.24.1

