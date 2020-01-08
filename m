Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF438134F32
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgAHV7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:23 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgAHV7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:23 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 80fe77a9;
        Wed, 8 Jan 2020 21:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=fpDOqHDxETum3ysxuM/uIGDqR
        Dk=; b=eyO1CelqROt6GPvfRswTaOEQWSeQOWfLzvfQuMH7WaQopiee5H4l1KWB8
        PgwU7KQq3LRqbKO2IZsJc2UgeBjyyZpKUT8U6ookVTFtLoQ2bGGlV5zL6UD9zrci
        WsK5qRZZ8R8eTN0rV2rb1Ul2eCP9pkhVUzgPvxTqjzkNd/7D06u9sDerhIpaRtFW
        A96rtpeoYrrh6BEMSajg1EQNsNmWVYT7dY4n84hqDByrInKxMYxGAcWVD3Q1v7MP
        FsPBov6ESim2JJPJ/rJ4MQg3xJuQxYtHBWqQ78nJA7zCJNIrGh6kg7ekl7FaBr0y
        0seI+nP4Rwq/ewPpVBzjqkwNG50mg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ca7d6bd9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 2/8] net: tap: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:03 -0500
Message-Id: <20200108215909.421487-3-Jason@zx2c4.com>
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
 drivers/net/tap.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a6d63665ad03..1f4bdd94407a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -341,6 +341,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		features |= tap->tap_features;
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
+		struct sk_buff *next;
 
 		if (IS_ERR(segs))
 			goto drop;
@@ -352,16 +353,13 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		}
 
 		consume_skb(skb);
-		while (segs) {
-			struct sk_buff *nskb = segs->next;
-
-			segs->next = NULL;
-			if (ptr_ring_produce(&q->ring, segs)) {
-				kfree_skb(segs);
-				kfree_skb_list(nskb);
+		skb_list_walk_safe(segs, skb, next) {
+			skb_mark_not_on_list(skb);
+			if (ptr_ring_produce(&q->ring, skb)) {
+				kfree_skb(skb);
+				kfree_skb_list(next);
 				break;
 			}
-			segs = nskb;
 		}
 	} else {
 		/* If we receive a partial checksum and the tap side
-- 
2.24.1

