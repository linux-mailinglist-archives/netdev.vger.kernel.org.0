Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20853139D92
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgAMXmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:42:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgAMXmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d7112655;
        Mon, 13 Jan 2020 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=vF/SpMgpzCZ3bXnbdrKZDuJPd
        Io=; b=IOvlLoQaoIQY2bYbNq19qRyyCVJB2h+6QzN0LfyAg2ZX5Ht/DzQKBS9Mq
        ppzeHBhgp684Fdceunus+fS763L+vKhOhMcdLDNIAaSaMn2Dy9gY777GLMzIleL8
        dS0Jszwj8UD2s54eyfkmxaW41k32gIzxXEq8r8fSOIF0gvqCMcWkvWdW9CHELqQz
        k7dS/O7MmS1W8VYFtyVVKXiH+s08j4RG2Kz9EIDqzAGNMvsMUHVyY2FifyE0lz2I
        oUNynSGg1g8VNvXGvbD66sqxIdOcqUY4KSEuBSJemPhR3TNOtsg+0cx8NPKSFlKN
        uB/jGeS1xWah4U4fqhsFr1nlnuayQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5b9d984c (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:53 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 3/8] net: xfrm: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:28 -0500
Message-Id: <20200113234233.33886-4-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is converts xfrm segment iteration to use the new function, keeping
the flow of the existing code as intact as possible. One case is very
straight-forward, whereas the other case has some more subtle code that
likes to peak at ->next and relink skbs. By keeping the variables the
same as before, we can upgrade this code with minimal surgery required.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/xfrm/xfrm_device.c | 15 ++++-----------
 net/xfrm/xfrm_output.c |  9 +++------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 189ef15acbbc..50f567a88f45 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -78,7 +78,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	int err;
 	unsigned long flags;
 	struct xfrm_state *x;
-	struct sk_buff *skb2;
+	struct sk_buff *skb2, *nskb;
 	struct softnet_data *sd;
 	netdev_features_t esp_features = features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
@@ -148,11 +148,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	skb2 = skb;
-
-	do {
-		struct sk_buff *nskb = skb2->next;
-
+	skb_list_walk_safe(skb, skb2, nskb) {
 		esp_features |= skb->dev->gso_partial_features;
 		skb_mark_not_on_list(skb2);
 
@@ -176,14 +172,11 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 			if (!skb)
 				return NULL;
 
-			goto skip_push;
+			continue;
 		}
 
 		skb_push(skb2, skb2->data - skb_mac_header(skb2));
-
-skip_push:
-		skb2 = nskb;
-	} while (skb2);
+	}
 
 	return skb;
 }
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index b1db55b50ba1..fafc7aba705f 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -533,7 +533,7 @@ static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct sk_buff *segs;
+	struct sk_buff *segs, *nskb;
 
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_SGO_CB_OFFSET);
 	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_SGO_CB_OFFSET);
@@ -544,8 +544,7 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (segs == NULL)
 		return -EINVAL;
 
-	do {
-		struct sk_buff *nskb = segs->next;
+	skb_list_walk_safe(segs, segs, nskb) {
 		int err;
 
 		skb_mark_not_on_list(segs);
@@ -555,9 +554,7 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 			kfree_skb_list(nskb);
 			return err;
 		}
-
-		segs = nskb;
-	} while (segs);
+	}
 
 	return 0;
 }
-- 
2.24.1

