Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CEB139D94
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgAMXnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:43:00 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgAMXm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:56 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 795d2bec;
        Mon, 13 Jan 2020 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=lpYQ8mRTKKl00+oMm1LKTn2+b
        2U=; b=OZxdqHiJTVgxLo6ec8KH7Kc1HC0A5DsFdISCvHXFEFl1NyFhXP1t0qLgj
        ylpJo0VgbCJ0MPaA/VwHOK6ci34OvKdQFi3N1wFHSiqPGtt7qT/2X9Zbd4jagycl
        aaRPzzUbO26ymZ4jvy2sbsZpj58wn9gEx+nGNxRm/K78asu/7m58BVd0+BsJi/6g
        7n0GaOjEf7OfgW6LiopWXu5ZBr8HPkM8k8mZ4Lki4EVJc6BXddrgCGcIx1buD4Hc
        XrU9E7drtaYdx9UCSQBpxKTiqG/SSsS6Ip6RJrj6gNDb5hBJDWTeEt5C2z4Hwo5y
        j4kWhOVlOjqqDbLBSbJEkLjsmfbWA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9f5ad967 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 5/8] net: sched: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:30 -0500
Message-Id: <20200113234233.33886-6-Jason@zx2c4.com>
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
 net/sched/sch_cake.c | 4 +---
 net/sched/sch_tbf.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 90ef7cc79b69..1496e87cd07b 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1682,8 +1682,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
-		while (segs) {
-			nskb = segs->next;
+		skb_list_walk_safe(segs, segs, nskb) {
 			skb_mark_not_on_list(segs);
 			qdisc_skb_cb(segs)->pkt_len = segs->len;
 			cobalt_set_enqueue_time(segs, now);
@@ -1696,7 +1695,6 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			slen += segs->len;
 			q->buffer_used += segs->truesize;
 			b->packets++;
-			segs = nskb;
 		}
 
 		/* stats */
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 5f72f3f916a5..2cd94973795c 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -155,8 +155,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		return qdisc_drop(skb, sch, to_free);
 
 	nb = 0;
-	while (segs) {
-		nskb = segs->next;
+	skb_list_walk_safe(segs, segs, nskb) {
 		skb_mark_not_on_list(segs);
 		qdisc_skb_cb(segs)->pkt_len = segs->len;
 		len += segs->len;
@@ -167,7 +166,6 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		} else {
 			nb++;
 		}
-		segs = nskb;
 	}
 	sch->q.qlen += nb;
 	if (nb > 1)
-- 
2.24.1

